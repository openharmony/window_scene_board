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

import { NotificationBase, NotificationDataManager, threadCall,} from '@ohos/systemuicommon/newTsIndex';
import process from '@ohos.process';
import { notificationConfigManager } from '../manager/NotificationConfigManager';
import { notificationManager } from '@kit.NotificationKit';
import { commonEventManager } from '@kit.BasicServicesKit';
import {
  ClickNotificationErrorCode,
  ClickNotificationMaintenance
} from '@ohos/systemuicommon/src/main/ets/maintenance/ClickNotificationMaintenance';
import { AnimateToScheduleUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { ExtAppConstants, WindowConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import lazy { SCBScreenSessionManager, SCBSystemSceneSession, SCBSceneSessionManager,
  StartAbilityUtil } from '@ohos/windowscene/src/main/ets/TsIndex';
import { DefaultPanelZIndex } from '@ohos/systemuicommon/src/main/ets/base/common/info/DefaultPanelZIndex';
import sceneSessionManager from '@ohos.sceneSessionManager';
import settings from '@ohos.settings';
import { FingerprintEvent } from '@ohos.multimodalInput.shortKey';
import { GlobalContext, obtainLocalEvent, sEventManager, EventConstants } from '@ohos/frameworkwrapper';
import lazy { OuterAppManager } from '@ohos/launchercommon/src/main/ets/manager/OuterAppManager';
import lazy { AppBundleInfo, AppInfo } from '@ohos/launchercommon/src/main/ets/bean/OuterAppNameList';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import { StatusBarEventType } from '@ohos/systemuicommon/src/main/ets/event/StatusBarEvent';
import { NotificationConstants } from '../common/NotificationConstants';
import { bundleManager } from '@kit.AbilityKit';
import { MetaServiceConnect } from '@ohos/systemuicommon/src/main/ets/manager/MetaServiceConnect';
// import { serviceNotification } from '@kit.PushKit';

const log = LogHelper.getLogHelper(LogDomain.NC, 'NotificationApiUtil');
const EVENT_DELIVER_NOTIFICATION_REMOVE = 'event.deliver.notification.remove';

/**
 * 录屏bundleName
 */
const SCREEN_RECORDE_BUNDLE_NAME = 'com.ohos.screenrecorder';

/**
 * 进程异常退出取消通知原因码
 */
const ABNORMAL_REASON_CODE = 6;

/**
 * 与底层交互的通知API工具类
 */
export class NotificationApiUtil {
  /**
   * 关闭通知开关
   * @param ntf
   */
  public static closeSwitch(ntf: NotificationBase): void {
    if (ntf.isLiveView()) {
      NotificationApiUtil.setLiveViewEnable(ntf.creatorBundleName, ntf.creatorUid, false);
    } else {
      // 关闭置顶
      if (ntf.isDisplayAtTop) {
        notificationConfigManager.setPinTopState(ntf.creatorUid, false);
      }
      // 如果是通知，关闭通知时需要发送删除通知的事件
      NotificationApiUtil.sendDeliverNotificationRemoveEvent(ntf, true);

      // 关闭通知
      NotificationApiUtil.setNtfEnable(ntf.creatorBundleName, ntf.creatorUid, false);
    }
  }

  /**
   * 通知移除时发送公共事件告诉
   * @param ntf 通知数据
   * @param isRemoveAll 是否移除全部
   */
  private static sendDeliverNotificationRemoveEvent(ntf: NotificationBase, isRemoveAll: boolean = false): void {
    // 非通知，直接跳过
    if (!ntf.isDeliverNotification) {
      return;
    }

    if (isRemoveAll) {
      // 批量删除通知
      log.showInfo(`sendDeliverNotificationRemoveEvent removeAll`);
      const options: commonEventManager.CommonEventPublishData = {
        data: ntf?.deliverNotificationKey + '-1-1',
        subscriberPermissions: ['ohos.permission.NOTIFICATION_CONTROLLER']
      };
      NotificationApiUtil.sendDeliverCommonEvent(EVENT_DELIVER_NOTIFICATION_REMOVE, options);
    } else {
      const nftList: NotificationBase[]  = ntf.isNormalGroup() ? ntf.children : [ntf];
      nftList.forEach(deliverNtf => {
        const options: commonEventManager.CommonEventPublishData = {
          data: deliverNtf?.deliverNotificationKey + '-0-0',
          subscriberPermissions: ['ohos.permission.NOTIFICATION_CONTROLLER']
        };
        NotificationApiUtil.sendDeliverCommonEvent(EVENT_DELIVER_NOTIFICATION_REMOVE, options);
      });
    }
  }

  /**
   * 发送公共事件
   * @param options
   */
  private static sendDeliverCommonEvent(event: string, options: commonEventManager.CommonEventPublishData): void {
    log.showInfo(`Send deliver notification ${event} event, data: ${options.data}`);
    try {
      commonEventManager.publish(event, options, err => {
        if (err) {
          log.showError(`sendDeliverCommonEvent: ${err.code}, message is ${err.message}`);
        } else {
          log.showInfo('sendDeliverCommonEvent success');
        }
      });
    } catch (err) {
      log.showError(`sendDeliverCommonEvent: ${err.code}, message is ${err.message}`);
    }
  }

  /**
   * 设置应用通知开关
   *
   * @param bundleName 应用包名
   * @param uid 应用uid
   * @param enable 是否开启
   */
  public static async setNtfEnable(bundleName: string, uid: number, enable: boolean): Promise<void> {
    const clickInfo = ClickNotificationMaintenance.getInfo();
    try {
      log.showInfo(`Set notification switch of ${bundleName}_${uid} to ${enable} begin`);
      await notificationManager.setNotificationEnable({
        bundle: bundleName,
        uid: uid
      }, enable);
      ClickNotificationMaintenance.reportClick(ClickNotificationErrorCode.SET_NTF_ENABLE_SUCC, clickInfo);
      log.showInfo(`Set notification switch of ${bundleName}_${uid} to ${enable} end`);
    } catch (e) {
      ClickNotificationMaintenance.reportClick(ClickNotificationErrorCode.SET_NTF_ENABLE_FAIL, clickInfo);
      log.error(`Set notification switch of ${bundleName}_${uid} to ${enable} error:`, e);
    }
  }

  /**
   * 设置应用实况窗开关
   *
   * @param bundleName 应用包名
   * @param uid 应用uid
   * @param enable 是否开启
   */
  public static async setLiveViewEnable(bundleName: string, uid: number, enable: boolean): Promise<void> {
    try {
      log.showInfo(`Set live view switch of ${bundleName}_${uid}} to ${enable} begin`);
      await notificationManager.setNotificationEnableSlot({
        bundle: bundleName,
        uid: uid
      }, notificationManager.SlotType.LIVE_VIEW, enable, true);
      log.showInfo(`Set live view switch of ${bundleName}_${uid}} to ${enable} end`);
    } catch (e) {
      log.error(`Set live view switch of ${bundleName}_${uid}} to ${enable} error:`, e);
    }
  }

  /**
   * 设置元服务通知开关
   *
   * @param bundleName 应用包名
   * @param uid 应用uid
   * @param enable 是否开启
   */
  static async setMetaServiceNotificationEnable(bundleName: string, uid: number, enable: boolean): Promise<void> {
    try {
      log.showInfo(`set meta service notification enable begin: ${bundleName}, ${uid}, ${enable}`);
      await notificationManager.setNotificationEnable({ bundle: bundleName, uid }, enable);
      // await serviceNotification.setSubscribeNotificationSetting(bundleName, { bundleName, enable });
      log.showInfo(`set meta service notification enable success: ${bundleName}, ${uid}, ${enable}`);
    } catch (err) {
      log.error(`set meta service notification enable failed: ${bundleName}`, err);
    }
  }

  /**
   * 设置未安装元服务实况开关
   *
   * @param bundleName 应用包名
   * @param uid 应用uid
   * @param enable 是否开启
   */
  static async setUnstallMetaServiceLiveEnable(bundleName: string, uid: number, enable: boolean): Promise<void> {
    await MetaServiceConnect.instance.collectMetaSerciveLiveChange('', bundleName)
  }

  /**
   * 点击删除通知
   *
   * @param ntf 通知
   */
  public static async removeNtfByClick(ntf: NotificationBase): Promise<void> {
    log.showInfo('Remove ntfList by click');
    await NotificationDataManager.instance.removeLiveView([ntf], true);
  }

  /**
   * 删除按钮移除通知
   *
   * @param ntfList 通知列表
   */
  public static async removeNtfByCancel(ntfList: NotificationBase[]): Promise<void> {
    // 如果是通知，删除通知时需要发送删除通知的事件
    ntfList.forEach(ntf => {
      NotificationApiUtil.sendDeliverNotificationRemoveEvent(ntf);
    });
    log.showInfo('Remove ntfList by cancel');
    await NotificationDataManager.instance.removeLiveView(ntfList, false);
  }

  public static async batchRemoveNtfByClick(ntfList: NotificationBase[]): Promise<void> {
    log.showInfo('Remove ntfList by click');
    await NotificationDataManager.instance.removeLiveView(ntfList, true);
  }

  /**
   * 打开通知设置（提供给子线程 跨线程调用）
   * @param bundleName
   * @param appIndex
   */
  @threadCall()
  public static openNtfSetting(bundleName: string, appIndex: number, uri: string, uid: number, isMetaService: boolean = false) {
    if (isMetaService) {
      StartAbilityUtil.startAbilityFromOther({
        bundleName: ExtAppConstants.PKG_SETTINGS,
        abilityName: ExtAppConstants.ABILITY_SETTINGS_MAIN,
        moduleName: ExtAppConstants.MODULE_PHONE_SETTINGS_SOUND,
        uri: 'systemui_notification_settings',
        parameters: {
          pushParams: {
            config: { bundleName: bundleName, isFromNc: true, appIndex, uid, isMetaService: true },
          }
        }
      });
      return;
    }
    StartAbilityUtil.startAbilityFromOther({
      bundleName: ExtAppConstants.PKG_SETTINGS,
      abilityName: ExtAppConstants.ABILITY_SETTINGS_MAIN,
      moduleName: ExtAppConstants.MODULE_PHONE_SETTINGS_SOUND,
      uri: uri,
      parameters: {
        pushParams: {
          config: {bundleName: bundleName, isFromNc: true, appIndex: appIndex, uid: uid}
        }
      }
    });
  }

  /**
   * 跳转时钟首页（提供给子线程 跨线程调用）
   */
  @threadCall()
  public static startClockMainAbility(): void {
    StartAbilityUtil.startAbilityFromOther({
      bundleName: ExtAppConstants.PKG_CLOCK,
      abilityName: ExtAppConstants.ABILITY_CLOCK,
      moduleName: ExtAppConstants.MODULE_CLOCK,
      parameters: {
        action: 'CLICK_TIME_FORM_HEADER',
        tabActive: 'ALARM_CLOCK_TAB'
      }
    });
  }

  /**
   * 跳转日历首页（提供给子线程 跨线程调用）
   */
  @threadCall()
  public static startCalendarMainAbility(): void {
    let date = new Date();
    StartAbilityUtil.startAbilityFromOther({
      bundleName: ExtAppConstants.PKG_CALENDAR,
      abilityName: ExtAppConstants.ABILITY_CALENDAR,
      moduleName: ExtAppConstants.MODULE_CALENDAR,
      parameters: {
        action: 'CLICK_MONTH_FORM_HEADER',
        tabIndex: '1',
        year: date.getFullYear(),
        month: date.getMonth(),
        day: date.getDate()
      }
    });
  }

  /**
   * 提升GC避让效率
   * @param value 0-动效开始 1-动效结束
   */
  public static raiseAnimateToGCPriority(value: number): void {
    AnimateToScheduleUtils.raiseAnimateToGCPriority(value, process.tid);
  }

  /**
   * 设置窗口旋转状态（提供给子线程 跨线程调用）
   * @param enabled
   */
  @threadCall()
  public static setRotateEnabled(enabled: boolean): void {
    const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    screenSession?.setEnableRotate(enabled, WindowConstants.WINDOW_NAME_DROPDOWN);
  }

  /*
   * 打开通知设置弹窗，设置状态栏层级，状态栏层级比页面层级高，状态栏层级需降级（提供给子线程 跨线程调用）
   */
  @threadCall()
  public static setStatusBarZIndex(action: 'update' | 'reset'): void {
    try {
      const sysSessionStatusBar: SCBSystemSceneSession = SCBSceneSessionManager.getInstance()
        .getSystemSceneSessionWithSystemType(sceneSessionManager.SessionType.TYPE_STATUS_BAR);
      if (!sysSessionStatusBar) {
        log.showInfo(`failed to get sysSessionStatusBar`);
        return;
      }
      if (action === 'update') {
        sysSessionStatusBar.zIndex = DefaultPanelZIndex.PANEL_STATUS_BAR_LOWER;
      }
      if (action === 'reset') {
        sysSessionStatusBar.zIndex = DefaultPanelZIndex.PANEL_STATUS_BAR;
      }
      log.showInfo(`setStatusBarZIndex success, zIndex: ${sysSessionStatusBar.zIndex}`);
    } catch (err) {
      log.showError(`setStatusBarZIndex failed, err: ${err}`);
    }
  }

  /**
   * 向状态栏发送智控键事件
   */
  public static postStatusBarFingerprintEvent(event: FingerprintEvent): void {
    sEventManager.publish(obtainLocalEvent(EventConstants.STATUS_BAR_DROPDOWN_FINGER_PRINT, event));
  }

  /**
   * 录屏进程异常被杀时，关闭触摸轨迹开关
   *
   * @param bundle 进程bundle
   * @param reason 进程取消通知原因
   */
  public static async appDeadNtfCancelHandle(bundle: string | undefined, reason: number | undefined): Promise<void> {
    try {
      if (bundle === SCREEN_RECORDE_BUNDLE_NAME && reason === ABNORMAL_REASON_CODE) {
        const result = await settings.setValue(GlobalContext.getContext(), 'settings.input.show_touch_hint', 'false');
        log.showInfo(`Set ShowTouch off ${result}`);
      }
    } catch (error) {
      log.showError(`Set Touch hint error:${error?.message}`);
    }
  }

  /**
   * 显示toast
   */
  @threadCall()
  public static showToast(message?: string, duration?: number, showMode?: number): void {
    try {
      ArkUIAdapter.uiContext?.getPromptAction().showToast({
        message: message,
        duration: duration,
        showMode: showMode,
      });
    } catch (error) {
      log.showError('showToast error by [%{public}d] [%{public}s]', error.code, error.message);
    }
  }

  /**
   * 判断是否为可扩展设备外屏支持的应用
   */
  @threadCall()
  public static isOuterBlockApp(bundleName: string, abilityName?: string): boolean | Promise<boolean> {
    // 组织查询参数
    let appArr: AppBundleInfo[] = [{
      bundleName: bundleName,
      abilityNames: abilityName ? [abilityName] : [],
    }];

    let isBlocked = true;
    // 查询是否为外屏支持应用
    const params = JSON.stringify(appArr);
    let retStr = OuterAppManager.getInstance().isBlockApps(params);
    log.showWarn(`isBlockApps params: ${params} result: ${retStr} `);
    let result: AppInfo[] = JSON.parse(retStr);
    if (result.length) {
      isBlocked = !result[0].appIsOuterSupport;
      // 若传入了abilityName, 还需判断对应的abilityName是否支持外屏
      if (abilityName && result[0].abilityInfos?.length) {
        isBlocked = !result[0].abilityInfos[0].appIsOuterSupport;
      }
      log.showInfo(`isOuterBlockApp bundleName: ${bundleName} abilityName: ${abilityName} isBlocked: ${isBlocked}`);
    }
    return isBlocked;
  }

  /**
   * 向状态栏发送隐藏事件
   */
  @threadCall()
  public static postStatusBarHideEvent(): void {
    sEventManager.publish(obtainLocalEvent(StatusBarEventType.STATUS_BAR_HIDE_IN_APP, true));
  }

  @threadCall()
  public static openAppNtfMgmt(bundleName: string, abilityName: string, appIndex: number) {
    log.showInfo(`handleAppNtfMgmtClick bundleName: ${bundleName}, appIndex: ${appIndex}`);
    try {
      GlobalContext.getContext().startAbility({
        bundleName: bundleName,
        abilityName: abilityName,
        parameters: {
          'linkFeature': NotificationConstants.APP_NTF_MGMT,
          'ohos.extra.param.key.appCloneIndex': appIndex
        }
      });
    } catch (e) {
      log.error(`open app notification management for ${bundleName} error:`, e);
    }
  }

  /**
   * 获取应用内通知管理abilityName
   * @param bundleName 包名
   * @returns
   */
  public static getAppNtfMgmtAbilityName(bundleName: string): string {
    if (!bundleName) {
      return '';
    }
    try {
      const abilityInfos =
        bundleManager.queryAbilityInfoSync({
          bundleName: bundleName,
          parameters: { linkFeature: NotificationConstants.APP_NTF_MGMT }
        }, bundleManager.AbilityFlag.GET_ABILITY_INFO_DEFAULT | bundleManager.AbilityFlag.GET_ABILITY_INFO_WITH_SKILL);
      for (const abilityInfo of abilityInfos) {
        if (abilityInfo?.skills?.flatMap(skill => skill?.uris)?.find(uri => uri?.linkFeature ===
        NotificationConstants.APP_NTF_MGMT)) {
          return abilityInfo.name;
        }
      }
    } catch (e) {
      // 17700001 - The specified bundleName is not found.
      // 17700003 - The specified ability is not found.
      if (e.code !== 17700003 && e.code !== 17700001) {
        log.error(`Get app notification management abilityName for ${bundleName} error: `, e);
      }
    }
    return '';
  }
}