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

import { commonEventManager, osAccount } from '@kit.BasicServicesKit';
import type { bundleManager } from '@kit.AbilityKit';
import process from '@ohos.process';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { NotificationConfigEntity, PinTopConfigCommand } from '../model/NotificationConfigEntity';
import { SystemuiConstants } from '../constants/SystemuiConstants';
import { SCBConstants } from '@ohos/commonconstants/src/main/ets/constants/SCBConstants';
import {
  NotificationConfigEvent,
  NotificationConfigEventType,
  NotificationConfigHideBannerContentEvent,
  NotificationConfigPinTopEvent,
  NotificationSilenceEvent,
} from '../model/NotificationConfigEvent';
import type { BundleResource } from '../utils/BundleResourceUtil';
import { HideBannerContentType } from '../constants/HideBannerContentType';
import lazy { LogWithHa } from '../maintenance/CommonExceptionMaintenance';
import { CommonExceptionCode } from '../maintenance/CommonExceptionCode';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/base/DeviceHelper';
import { NtfSettingManagerUtils, SwitchState } from '../utils/NtfSettingManagerUtils';

const log = LogHelper.getLogHelper(LogDomain.NC, 'NotificationConfigBaseManager');

/**
 * 默认用户ID
 */
const DEFAULT_USER_ID = 100;

export class NotificationConfigBaseManager {
  public userId: number = DEFAULT_USER_ID;
  protected commonEventSubscribers: commonEventManager.CommonEventSubscriber[] = [];

  private listeners: Set<(data: NotificationConfigEvent) => void> = new Set();
  private accountManager?: osAccount.AccountManager;
  private isSubscribedConfigEvent = false;
  private isSubscribedDistributionEvent = false;

  /**
   * 获取置顶的应用列表数量
   * @returns
   */
  public async getPinTopCount(): Promise<number> {
    const predicates = NotificationConfigEntity.getPredicates();
    predicates.equalTo({ pinTop: true });
    predicates.inCondition({ userId: [this.userId, 0] });
    return NotificationConfigEntity.queryCount(predicates);
  }

  /**
   * 获取置顶的应用列表
   * @returns
   */
  public async getPinTopList(): Promise<NotificationConfigEntity[]> {
    const predicates = NotificationConfigEntity.getPredicates();
    predicates.equalTo({ pinTop: true });
    predicates.inCondition({ userId: [this.userId, 0] });
    return NotificationConfigEntity.queryList(predicates);
  }

  /**
   * 查询置顶状态
   * @param uid
   * @returns
   */
  public async getPinTopState(uid: number): Promise<boolean> {
    try {
      const config = await NotificationConfigEntity.queryByProps({ uid });
      return config?.pinTop ?? false;
    } catch (e) {
      LogWithHa.error(log, `Get pipTop state for ${uid} error: ${e}`, CommonExceptionCode.GET_PIN_TOP_FAIL, e);
      return false;
    }
  }

  /**
   * 查询静默状态
   * @param uid
   * @returns
   */
  public async getSilenceState(bundleName: string, uid: number): Promise<boolean> {
    try {
      const result = await NtfSettingManagerUtils.isSilentReminderEnabled(bundleName, uid);
      return result === SwitchState.USER_MODIFIED_ON;
    } catch (e) {
      LogWithHa.error(log, `Get silent state for ${uid} error: ${e}`, CommonExceptionCode.GET_SILENCE_FAIL, e);
      return false;
    }
  }

  /**
   * 设置静默通知状态
   * returns 返回修改结果，true表示成功
   */
  public async setSilentState(uid: number, bundleName: string, isSilent: boolean): Promise<boolean> {
    try {
      log.showInfo(`Set ${uid} silent state to ${isSilent} success`);
      await NtfSettingManagerUtils.setSilentReminderEnabled(bundleName, uid, isSilent);
      this.publishChangeEvent(new NotificationSilenceEvent(uid, bundleName, isSilent));
      return true;
    } catch (e) {
      LogWithHa.error(log, `Set ${uid} Silent state to ${!isSilent} error: ${e}`,
        CommonExceptionCode.SET_SILENCE_FAIL, e);
    }
    return false;
  }

  /**
   * 设置置顶状态
   * returns 返回修改结果，true表示成功
   */
  public async setPinTopState(uid: number, pinTop: boolean): Promise<boolean> {
    try {
      const config = await NotificationConfigEntity.queryByProps({ uid });
      if (config) {
        config.pinTop = pinTop;
        await config.save();
        log.showInfo(`Set ${uid} pinPop state to ${pinTop} success`);
        this.publishChangeEvent(new NotificationConfigPinTopEvent(uid, pinTop));
        return true;
      } else {
        log.showInfo(`Cannot find config for ${uid}`);
      }
    } catch (e) {
      LogWithHa.error(log, `Set ${uid} pinPop state to ${pinTop} error: ${e}`, CommonExceptionCode.SET_PIN_TOP_FAIL, e);
    }
    return false;
  }

  /**
   * 查询是否隐藏横幅通知内容
   * @param uid 应用uid
   * @returns
   */
  public async getHideBannerContentState(uid: number): Promise<number> {
    try {
      const config = await NotificationConfigEntity.queryByProps({ uid });
      return config?.hideBannerContent ?? HideBannerContentType.FOLLOW_SYSTEM;
    } catch (e) {
      LogWithHa.error(log, `Get HideBannerContent state for ${uid} error: ${e}`,
        CommonExceptionCode.GET_HIDDEN_BANNER_FAIL, e);
      return 0;
    }
  }

  /**
   * 设置是否隐藏横幅通知内容
   * returns 返回修改结果，true表示成功
   */
  public async setHideBannerContentState(uid: number, hideBannerContent: number): Promise<boolean> {
    try {
      const config = await NotificationConfigEntity.queryByProps({ uid });
      if (config) {
        config.hideBannerContent = hideBannerContent;
        await config.save();
        log.showInfo(`Set ${uid} HideBannerContent state to ${hideBannerContent} success`);
        this.publishChangeEvent(new NotificationConfigHideBannerContentEvent(uid, hideBannerContent));
        return true;
      } else {
        log.showInfo(`Cannot find config for ${uid}`);
      }
    } catch (e) {
      LogWithHa.error(log, `Set ${uid} HideBannerContent state to ${hideBannerContent} error: ${e}`,
        CommonExceptionCode.SET_HIDDEN_BANNER_FAIL, e);
    }
    return false;
  }

  /**
   * 批量设置置顶状态
   * returns 返回修改结果，true表示至少有一个成功
   */
  public async batchSetPinTopState(list: PinTopConfigCommand[]): Promise<boolean> {
    const result = await Promise.all(list.map((item) => this.setPinTopState(item.uid, item.enable)));
    return result.some(Boolean);
  }

  /**
   * 批量取消置顶状态
   * @param uidList 应用UID列表
   */
  public async batchCancelPinTopState(uidList: number[]): Promise<boolean> {
    try {
      log.showInfo(`Cancel pin top for [${uidList}] begin`);
      const predicates = NotificationConfigEntity.getPredicates();
      predicates.inCondition({ uid: uidList });
      await NotificationConfigEntity.update({ pinTop: false }, predicates);
      uidList.forEach((uid) => {
        this.publishChangeEvent(new NotificationConfigPinTopEvent(uid, false));
      });
      log.showInfo(`Cancel pin top for [${uidList}] end`);
      return true;
    } catch (e) {
      log.error(`Cancel pin top for [${uidList}] error:`, e);
      return false;
    }
  }

  /**
   * 订阅通知配置变更的事件
   * @param listener
   */
  public subscribeChangeEvent(listener: (event: NotificationConfigEvent) => void): void {
    this.listeners.add(listener);

    if (!this.isSubscribedConfigEvent) {
      this.subscribeConfigChangeEvent();
      this.isSubscribedConfigEvent = true;
    }
  }

  /**
   * 订阅全场景协同开关出现的事件
   * @param listener
   */
  public subscribeDistributionChangeEvent(listener: (event: NotificationConfigEvent) => void): void {
    if (!DeviceHelper.isPad()) {
      return;
    }
    this.listeners.add(listener);

    if (!this.isSubscribedDistributionEvent) {
      this.subscribeCommonEvent({
        events: [SystemuiConstants.DISTRIBUTED_DEVICE_TYPES_CHANGE],
        publisherPermission: 'ohos.permission.NOTIFICATION_CONTROLLER',
      }, (event) => {
        const data = [event.event] as unknown as NotificationConfigEvent;
        log.info(`Receive notification distribution change event:`, data);
        this.triggerChangeEvent(data);
      });
      this.isSubscribedDistributionEvent = true;
    }
  }

  /**
   * 取消订阅事件
   * @param listener
   */
  public unsubscribeChangeEvent(listener: (data: NotificationConfigEvent) => void): void {
    this.listeners.delete(listener);
  }

  /**
   * 发布通知配置更新事件
   */
  public publishChangeEvent(event: NotificationConfigEvent): void {
    try {
      commonEventManager.publishAsUser(SystemuiConstants.NOTIFICATION_CONFIG_CHANGE_EVENT, this.userId, {
        bundleName: SCBConstants.SCENE_BOARD_PKG,
        subscriberPermissions: ['ohos.permission.NOTIFICATION_CONTROLLER'],
        code: process.tid,
        parameters: event,
      }, (e) => {
        if (e) {
          log.error(`user:${this.userId} publish ${SystemuiConstants.NOTIFICATION_CONFIG_CHANGE_EVENT} for type ${event.type} error:`, e);
        } else {
          log.showInfo(`user:${this.userId} publish ${SystemuiConstants.NOTIFICATION_CONFIG_CHANGE_EVENT} for type ${event.type} success`);
        }
      });
    } catch (error) {
      LogWithHa.error(log, `commonEventManager.publish fail error: ${error}`,
        CommonExceptionCode.PUBLIC_CONFIG_CHANGE_FAIL, error);
    }

    this.triggerChangeEvent(event);
  }

  /**
   * 获取应用图标和名称
   * @param data
   * @returns
   */
  public async getAppResource(context, bundleName: string, bundleType: bundleManager.BundleType,
    parseIcon: boolean = true): Promise<BundleResource> {
    const { BundleResourceUtil } = await import('../utils/BundleResourceUtil');
    return BundleResourceUtil.getBundleResource(context, bundleName, bundleType, parseIcon);
  }

  /**
   * 订阅通知配置表更新事件
   */
  protected subscribeConfigChangeEvent(): void {
    this.subscribeCommonEvent({
      events: [SystemuiConstants.NOTIFICATION_CONFIG_CHANGE_EVENT],
      publisherBundleName: SCBConstants.SCENE_BOARD_PKG,
      publisherPermission: 'ohos.permission.NOTIFICATION_CONTROLLER',
    }, (event) => {
      // 同线程的在使用内部事件转发，不用公共事件的处理
      if (event.code === process.tid) {
        return;
      }
      const data = event?.parameters as NotificationConfigEvent;
      if (!Object.values(NotificationConfigEventType).includes(data.type)) {
        log.error(`Invalid notification config change event:`, event);
        return;
      }
      log.info(`Recieve notification config change event:`, data);
      this.triggerChangeEvent(data);
    });
  }

  /**
   * 触发事件
   * @param event
   */
  public triggerChangeEvent(event: NotificationConfigEvent): void {
    for (const listener of this.listeners.values()) {
      try {
        listener(event);
      } catch (e) {
        LogWithHa.error(log, `Trigger change event for ${event.type} error: ${e}`,
          CommonExceptionCode.TRIGGER_CHANGE_FAIL, e);
      }
    }
  };

  /**
   * 订阅公共事件
   * @param subscribeInfo 事件信息
   * @param callback 回调
   */
  protected async subscribeCommonEvent(
    subscribeInfo: commonEventManager.CommonEventSubscribeInfo,
    callback: (event: commonEventManager.CommonEventData
  ) => void): Promise<void> {
    try {
      const subscriber = await commonEventManager.createSubscriber(subscribeInfo);
      commonEventManager.subscribe(subscriber, (err, event) => {
        if (err) {
          log.error(`Receive ${subscribeInfo.events} error:`, err);
          return;
        }
        callback(event);
      });
      log.showInfo(`Subscribe ${subscribeInfo.events} success`);
      this.commonEventSubscribers.push(subscriber);
    } catch (e) {
      LogWithHa.error(log, `Subscribe ${subscribeInfo.events} error: ${e}`,
        CommonExceptionCode.SUBSCRIBE_COMMON_FAIL, e);
    }
  }

  /**
   * 销毁所有公共事件订阅
   */
  protected unsubscribeCommonEvent(): void {
    for (const subscriber of this.commonEventSubscribers) {
      commonEventManager.unsubscribe(subscriber);
    }
    this.commonEventSubscribers = [];
  }

  /**
   * 根据uid获取userId
   * @param uid
   * @returns
   */
  protected getUserIdFromUid(uid: number): number {
    if (!this.accountManager) {
      this.accountManager = osAccount.getAccountManager();
    }
    return this.accountManager.getOsAccountLocalIdForUidSync(uid);
  }
}