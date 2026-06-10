/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { rpc } from '@kit.IPCKit';
import { common, Want } from '@kit.AbilityKit';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { SmartNotificationUtil } from '@ohos/systemuicommon/src/main/ets/utils/SmartNotificationUtil';
import { NotificationIpcManager } from '@ohos/systemuicommon/src/main/ets/manager/NotificationIpcManager';
import { NotificationConfigEvent, SystemUICommonUtil } from '@ohos/systemuicommon';
import { ScreenLockApi } from '@ohos/screenlockcommon/src/main/ets/api/ScreenLockApi';
import { SCBOobeManager } from '@ohos/windowscene';
import { DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper';
import { notificationConfigManager } from './NotificationConfigManager';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { SystemUICcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICcmConfig';

const TAG = 'SettingSearchManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const DISABLE_PC_SEARCH_ITEMS = ['notification_not_banner', 'hide_banner_content_title'];
const STATUS_BAR_ENABLE_SWITCH = new Set([
  'status_bar',
  'enable_switch_icon_visible',
  'enable_switch_notification_icon',
  'enable_switch_net_speed',
  'enable_switch_vpn',
  'enable_switch_ring_mode',
  'enable_switch_silent',
  'enable_switch_nearlink',
  'enable_switch_bluetooth',
  'enable_switch_alarm_clock',
  'enable_switch_nfc',
  'enable_switch_head_phones',
]);
/* 全场景开关条目出现事件的key */
const NTF_DISTRIBUTION_BUTTON_EVENT = 'notification.event.DISTRIBUTED_DEVICE_TYPES_CHANGE';

interface ISearchItems {
  itemList: string[];
}

interface IStatusBarSearchItems {
  enableItemList: string[];
  disableItemList: string[];
}

/**
 * 动态使能和去使能设置搜索项，针对通知管理页面，搜索项和开关项存在联动：
 * 如果开关项关闭，则对应子页面和关联菜单去使能，不支持搜索展示
 * 如果开关项打开，则对应子页面和关联菜单动态使能，支持搜索展示
 */
export class SettingSearchManager {
  private static readonly SETTINGS_ENABLE_SEARCH_ITEMS: number = 2;
  private static readonly requestWant: Want = {
    bundleName: 'com.ohos.settings',
    abilityName: 'SettingsExtService',
  };
  /**
   * 智能提醒开关去使能搜索项最大重试时间
   */
  private static readonly MAX_RETRY_INTERVAL = 30000;

  /**
   * 智能提醒开关去使能搜索项
   */
  public static async disableSmartReminderSearchItem(context: common.ServiceExtensionContext): Promise<void> {
    // 查询当前 设备#用户 环境下是否开放智能提醒开关
    const isSupportSmartNtf: boolean = await SmartNotificationUtil.isSupportSmartNtf();
    log.showInfo(`isSupportSmartNtf ${isSupportSmartNtf}`);
    if (isSupportSmartNtf) {
      return;
    }
    await SettingSearchManager.setSettingSearchItems(context, ['display_banner_notification_content','smart_hiding_of_banner_content']);
  }

  /**
   * PC特有搜索项，使能和去使能
   */
  public static async handlePCModeSpecialSearchItem(context: common.ServiceExtensionContext): Promise<void> {
    // QXS动态切换模式，这里需要动态使能，去使能搜索项
    await SettingSearchManager.setSettingSearchItems(context,
      DISABLE_PC_SEARCH_ITEMS, DeviceHelper.isPC());
  }

  public static async enableDistributionSearchItem(context: common.ServiceExtensionContext): Promise<void> {
    log.showInfo(`Distribution search item is activated`);
    await SettingSearchManager.setSettingSearchItems(context,
      ['allow_notification_distribution', 'allow_live_view_distribution'], true);
  }

  /**
   * 检查key是否支持
   */
  private static isSupportKey(key: string, callback: () => boolean): boolean {
    try {
      return callback();
    } catch (error) {
      log.showError(`isSupport systemui.live2 check for ${key}, err ${error}`);
      return false;
    }
  }

  /**
   * 获取所有live2的开关
   */
  private static getLive2StatusBarSearchItems(): IStatusBarSearchItems {
    const enableItemList: Set<string> = new Set(STATUS_BAR_ENABLE_SWITCH);
    let disableItemList: string[] = [];
    let isSupportNFC = true;
    let isSupportVibrator = true;
    let isSupportNearlink = false;

    // 是否支持NFC
    isSupportNFC = SettingSearchManager.isSupportKey('nfc', () =>
      canIUse('SystemCapability.Communication.NFC.Core')
    );
    // 是否支持星闪
    isSupportNearlink  = SettingSearchManager.isSupportKey('nearlink', () =>
      systemParameterEnhance.getSync('const.nearlink.enable', 'false') === 'true'
    );
    // 是否支持震动
    isSupportVibrator = SettingSearchManager.isSupportKey('vibrator', () =>
      systemParameterEnhance.getSync('const.vibrator.support_vibrator', 'true') === 'true'
    );
    log.showInfo(`nfc: ${isSupportNFC} vibrator: ${isSupportVibrator} nearlink: ${isSupportNearlink}`);
    // NFC支持情况
    if (!isSupportNFC) {
      enableItemList.delete('enable_switch_nfc')
      disableItemList.push('enable_switch_nfc')
    }
    // 星闪支持情况
    if (isSupportNearlink) {
      enableItemList.delete('enable_switch_bluetooth')
      disableItemList.push('enable_switch_bluetooth')
    } else {
      enableItemList.delete('enable_switch_nearlink')
      disableItemList.push('enable_switch_nearlink')
    }
    // 震动支持情况
    if (isSupportVibrator) {
      enableItemList.delete('enable_switch_silent')
      disableItemList.push('enable_switch_silent')
    } else {
      enableItemList.delete('enable_switch_ring_mode')
      disableItemList.push('enable_switch_ring_mode')
    }
    // V2需禁用纯净显示|通知|实时网速
    disableItemList.push('simple_display', 'show_app_notification_icons', 'show_network_speed');
    return { enableItemList: Array.from(enableItemList), disableItemList };
  }

  /**
   * 获取所有live1的开关
   */
  private static getLive1StatusBarSearchItems(): IStatusBarSearchItems {
    // 关闭所有V2开关,除status_bar
    const disableItemList = [...Array.from(STATUS_BAR_ENABLE_SWITCH)].filter(item => item !== 'status_bar');
    // 打开所有v1开关
    const enableItemList = ['status_bar', 'simple_display', 'show_app_notification_icons', 'show_network_speed'];
    return { enableItemList, disableItemList };
  }

  /**
   * 状态栏使能开关的 设置搜索动态使能
   */
  public static async enableStatusBarSearchItem(context: common.ServiceExtensionContext): Promise<void> {
    if (DeviceHelper.is2In1DevicePcType()) {
      // QXS 设备PC模式下所有开关动态禁用
      SettingSearchManager.setSettingSearchItems(context, Array.from(STATUS_BAR_ENABLE_SWITCH), false);
      return Promise.resolve();
    }
    let enableItemList: string[] = [];
    let disableItemList: string[] = [];
    const isEnabledLive2 = SystemUICcmConfig.instance.isEnabledLive2;
    log.showInfo(`isEnabledLive2: ${isEnabledLive2}`);
    if (isEnabledLive2) {
      const searchItems = SettingSearchManager.getLive2StatusBarSearchItems();
      enableItemList = searchItems.enableItemList;
      disableItemList = searchItems.disableItemList;
    } else {
      const searchItems = SettingSearchManager.getLive1StatusBarSearchItems();
      enableItemList = searchItems.enableItemList;
      disableItemList = searchItems.disableItemList;
    }
    SettingSearchManager.setSettingSearchItems(context, enableItemList, true);
    SettingSearchManager.setSettingSearchItems(context, disableItemList, false);
    return Promise.resolve();
  }

  /**
   * 动态使能和去使能设置搜索项
   * @param context 上下文
   * @param itemList 配置搜索项 name，同 searchPage.json 中的 itemName
   * @param isEnable true = 使能搜索项 | false = 去使能搜索项
   * @returns
   */
  public static async setSettingSearchItems(context: common.ServiceExtensionContext, itemList: string[],
    isEnable: boolean = false): Promise<void> {
    log.showInfo(`Set SettingsSearchItems for ${itemList} start ${isEnable}`);
    const notificationIpcManager = new NotificationIpcManager(context, SettingSearchManager.requestWant);
    const data = rpc.MessageSequence.create();
    const searchItems: ISearchItems = { itemList };
    data.writeString(JSON.stringify({
      method: isEnable ? 'enableSearchItems' : 'disableSearchItems',
      extra: searchItems,
    }));

    let retryTimes = 0;
    let retryInterval = 1000;
    let isSuccess = false;
    while (!isSuccess) {
      try {
        if (ScreenLockApi.getLock() || SCBOobeManager.isOobeActivated()) {
          await SystemUICommonUtil.sleep(retryInterval);
          continue;
        }
        await notificationIpcManager.send(SettingSearchManager.SETTINGS_ENABLE_SEARCH_ITEMS, data);
        isSuccess = true;
        log.showInfo(`Set SettingsSearchItems for ${itemList} success, retryTimes: ${retryTimes}`);
      } catch (err) {
        log.error(`Set SettingsSearchItems for ${itemList}, retryTimes: ${retryTimes}, error:`, err);
        await SystemUICommonUtil.sleep(retryInterval);
        retryInterval = Math.min(retryInterval * 2, SettingSearchManager.MAX_RETRY_INTERVAL);
        retryTimes++;
      }
    }
    try {
      data.reclaim();
    } catch (err) {
      log.error('MessageSequence reclaim failed', err);
    }
    // 请求设置搜索使能开关后就断开连接
    await notificationIpcManager.disconnect();
  }

  public static onDistributionButtonChange = async (event: NotificationConfigEvent): Promise<void> => {
    if (event[0] === NTF_DISTRIBUTION_BUTTON_EVENT) {
      await SettingSearchManager.enableDistributionSearchItem(GlobalContext.getContext());
      notificationConfigManager.unsubscribeChangeEvent(this.onDistributionButtonChange);
    }
  }
}
