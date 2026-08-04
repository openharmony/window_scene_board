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

import notificationManager from '@ohos.notificationManager';
import { LogDomain, LogHelper } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import type { PinTopConfigCommand } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import lazy { LogWithHa } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import type { PinTopAppItem } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicUiCommon';
import { LockScreenNtfStyle } from '../common/NotificationMgmtCommon';
import BundleResourceModel from '@ohos/managementcomponent/src/main/ets/com/ohos/model/bundleResourceModel';
import {
  notificationSettingManager
} from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/NotificationSettingManager';
import {
  SettingsConstants,
  SettingsKeyConstants
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/constants';
import { sSettingsUtil } from '@ohos/managementcomponent';
import {
  NotificationConfigSlotChangeEvent,
  NotificationConfigBadgeChangeEvent
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { SettingExceptionCode } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/SettingExceptionCode';

const TAG = 'NotificationMgmt_Model';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 通知管理业务模型
 */
export class NotificationMgmtModel {
  private bundleOption: notificationManager.BundleOption;

  constructor(bundleName: string, uid?: number) {
    this.bundleOption = { bundle: bundleName, uid: uid };
    log.showInfo('Construct for {%{public}s, %{public}d}.', this.bundleOption.bundle, this.bundleOption.uid);
  }

  /**
   * 获取锁屏样式配置
   * @returns
   */
  public static getLockScreenStyle(): LockScreenNtfStyle | undefined {
    try {
      log.showInfo('GetLockScreenStyle start.');
      const defValue: string = SettingsConstants.NTF_LOCK_SCREEN_STYLE_UPPER ? 'true' : 'false';
      const value = sSettingsUtil.getSecureValue(SettingsKeyConstants.NTF_SCREEN_LOCK_STYLE, defValue);
      const result = value === 'true' ? LockScreenNtfStyle.LIST : LockScreenNtfStyle.DOWN;
      log.showInfo('GetLockScreenStyle succeed. value: [%{public}s], return: [%{public}d]', value, result);
      return result;
    } catch (e) {
      log.showError('GetLockScreenStyle error by [%{public}d]', e.code);
      return undefined;
    }
  }

  /**
   * 获取应用是否允许发送通知状态
   */
  public getAllowState = async (): Promise<boolean> => {
    try {
      log.showInfo('GetAllowState start.');
      const result = await notificationManager.isNotificationEnabled(this.bundleOption)
      log.showInfo('GetAllowState return: [%{public}s]', result);
      return result;
    } catch (e) {
      LogWithHa.error(log, `GetAllowState error by ${e.code}`, SettingExceptionCode.GET_NTF_SWITCH_FAIL, e);
      return false;
    }
  }
  /**
   * 设置应用是否允许通知状态
   */
  public setAllowState = async (isOn: boolean): Promise<void> => {
    try {
      log.showInfo('SetAllowState to [%{public}s] start.', isOn);
      await notificationManager.setNotificationEnable(this.bundleOption, isOn);
      log.showInfo('SetAllowState to [%{public}s] succeed.', isOn);
      return Promise.resolve();
    } catch (e) {
      LogWithHa.error(log, `SetAllowState to ${isOn} error by ${e.code}`, SettingExceptionCode.SET_NTF_SWITCH_FAIL, e);
      return Promise.reject(e);
    }
  }
  /**
   * 获取应用置顶状态
   */
  public getPinTopState = async (): Promise<boolean> => {
    try {
      log.showInfo('GetPinTopState start.');
      const result = await notificationSettingManager.getPinTopState(this.bundleOption.uid);
      log.showInfo('GetPinTopState. config.pinTopEnable: [%{public}s]', result);
      return result;
    } catch (e) {
      log.showError('GetPinTopState error by [%{public}d]', e.code);
      return Promise.reject(e);
    }
  }
  /**
   * 获取应用静默状态
   */
  public getSilenceState = async (): Promise<boolean> => {
    try {
      log.showInfo('GetSilenceState start.');
      const result = await notificationSettingManager.getSilenceState(this.bundleOption.bundle, this.bundleOption.uid);
      log.showInfo('GetSilenceState: [%{public}s]', result);
      return result;
    } catch (e) {
      LogWithHa.error(log, `GetSilenceState error by ${e.code}`, SettingExceptionCode.GET_SILENCE_STATE_FAIL, e);
      return Promise.reject(e);
    }
  }

  /**
   * 设置应用静默状态
   */
  public setSilenceState = async (isOn: boolean): Promise<void> => {
    try {
      log.showInfo('SetSilenceState to [%{public}s] start.', isOn);
      if (await notificationSettingManager.setSilentState(this.bundleOption.uid, this.bundleOption.bundle, isOn)) {
        log.showInfo('SetSilenceState to [%{public}s] succeed.', isOn);
        return Promise.resolve();
      } else {
        log.showWarn('SetSilenceState to [%{public}s] failed.', isOn);
        return Promise.reject();
      }
    } catch (e) {
      LogWithHa.error(log, `SetSilenceState to ${isOn} error by ${e.code}`, SettingExceptionCode.SET_SILENCE_STATE_FAIL, e);
      return Promise.reject(e);
    }
  }
  /**
   * 设置应用置顶状态
   */
  public setPinTopState = async (isOn: boolean): Promise<void> => {
    try {
      log.showInfo('SetPinTopState to [%{public}s] start.', isOn)
      if (await notificationSettingManager.setPinTopState(this.bundleOption.uid, isOn)) {
        log.showInfo('SetPinTopState to [%{public}s] succeed.', isOn);
        return Promise.resolve();
      } else {
        log.showWarn('SetPinTopState to [%{public}s] failed.', isOn);
        return Promise.reject();
      }
    } catch (e) {
      log.showError('SetPinTopState to [%{public}s] error by [%{public}d]', isOn, e.code);
      return Promise.reject(e);
    }
  }
  /**
   * 设置横幅通知是否隐藏内容
   */
  public getBannerDisplayMode = async (): Promise<number> => {
    try {
      log.showInfo('getBannerDisplayMode start');
      const result = await notificationSettingManager.getHideBannerContentState(this.bundleOption.uid);
      log.showInfo('getBannerDisplayMode to [%{public}d] succeed', result);
      return result;
    } catch (e) {
      log.showError('getBannerDisplayMode error by [%{public}d]', e.code);
      return Promise.reject(e);
    }
  }
  /**
   * 设置横幅通知是否隐藏内容
   */
  public setBannerDisplayMode = async (type: number): Promise<void> => {
    try {
      log.showInfo('setBannerDisplayMode to [%{public}s] start.', type)
      if (await notificationSettingManager.setHideBannerContentState(this.bundleOption.uid, type)) {
        log.showInfo('setBannerDisplayMode to [%{public}s] succeed.', type);
        return Promise.resolve();
      } else {
        log.showWarn('setBannerDisplayMode to [%{public}s] failed.', type);
      }
    } catch (e) {
      log.showError('setBannerDisplayMode to [%{public}s] error by [%{public}d]', type, e.code);
    }
    return Promise.reject();
  }

  public batchDisablePinTop = async (apps: Set<PinTopAppItem>): Promise<boolean> => {
    log.showInfo('BatchDisablePinTop.');
    const commands = this.convert2Commands(apps);
    return this.doBatchDisablePinTop(commands);
  }

  private async doBatchDisablePinTop(apps: PinTopConfigCommand[]): Promise<boolean> {
    log.showDebug('DoBatchDisablePinTop.');
    try {
      const ret = await notificationSettingManager.batchSetPinTopState(apps);
      log.showInfo('BatchDisablePinTop succeed, return %{public}s', ret);
      return Promise.resolve(ret);
    } catch (e) {
      log.showError('BatchDisablePinTop error for %{public}d apps', apps.length);
      return Promise.resolve(false);
    }
  }

  private convert2Commands(apps: Set<PinTopAppItem>): PinTopConfigCommand[] {
    const commands: PinTopConfigCommand[] = [];
    apps.forEach((app) => {
      commands.push({
        uid: app.uid,
        enable: false
      })
    });
    return commands;
  }

  /**
   * 获取应用提醒方式
   */
  public getSlotFlags = async (): Promise<number> => {
    try {
      log.showInfo('GetSlotFlags start.');
      const ret = await notificationManager.getSlotFlagsByBundle(this.bundleOption);
      log.showInfo('GetSlotFlags return: [%{public}d]', ret);
      return ret;
    } catch (e) {
      log.showError('GetSlotFlags error by [%{public}d]', e.code);
      return Promise.reject(e);
    }
  }
  /**
   * 获取桌面角标状态
   */
  public getBadgeState = async (): Promise<boolean> => {
    try {
      log.showInfo('GetBadgeState start.');
      const isOn = await notificationManager.isBadgeDisplayed(this.bundleOption);
      log.showInfo(`GetBadgeState return ${isOn}`);
      return isOn;
    } catch (e) {
      log.showError('GetBadgeState error by [%{public}d]', e.code);
      return Promise.reject(e);
    }
  }
  /**
   * 设置应用提醒方式
   */
  public setSlotFlags = async (slotFlags: number): Promise<void> => {
    try {
      log.showInfo('SetSlotFlags to [%{public}d] start.', slotFlags);
      await notificationManager.setSlotFlagsByBundle(this.bundleOption, slotFlags);
      notificationSettingManager.triggerChangeEvent(new NotificationConfigSlotChangeEvent(this.bundleOption.uid!));
      log.showInfo('SetSlotFlags to [%{public}d] succeed', slotFlags);
      return Promise.resolve();
    } catch (e) {
      log.showError('SetSlotFlags to [%{public}d] error by [%{public}d]', slotFlags, e.code);
      return Promise.reject(e);
    }
  }
  /**
   * 设置桌面角标显示
   */
  public setDesktopBadge = async (isOn: boolean): Promise<void> => {
    try {
      log.showInfo('SetDesktopBadge to [%{public}s] start.', isOn);
      await notificationManager.displayBadge(this.bundleOption, isOn);
      notificationSettingManager.triggerChangeEvent(new NotificationConfigBadgeChangeEvent(this.bundleOption.uid!));
      log.showInfo('SetDesktopBadge to [%{public}s] success.', isOn);
      return Promise.resolve();
    } catch (e) {
      log.showError('SetDesktopBadge to [%{public}s] error by [%{public}d]', isOn, e.code);
      return Promise.reject(e);
    }
  }
  /**
   * 获取应用类型提醒配置列表
   */
  public getSlots = async (): Promise<notificationManager.NotificationSlot[]> => {
    try {
      log.showInfo('GetSlots start.');
      const ret = await notificationManager.getSlotsByBundle(this.bundleOption);
      log.showInfo('GetSlots result.len: [%{public}d]', ret?.length);
      return ret;
    } catch (e) {
      log.showError('GetSlots error by [%{public}d]', e.code);
      return Promise.reject(e);
    }
  }
  /**
   * 设置应用类型提醒配置
   */
  public setSlot = async (slotType: notificationManager.SlotType, isOn: boolean): Promise<void> => {
    try {
      log.showInfo('SetSlot for [%{public}d] to [%{public}s] start.', slotType, isOn);
      await notificationManager.setNotificationEnableSlot(this.bundleOption, slotType, isOn);
      log.showInfo('SetSlot for [%{public}d] to [%{public}s] succeed.', slotType, isOn);
      return Promise.resolve();
    } catch (e) {
      log.showError('Set slot for [%{public}d] to [%{public}s] error by [%{public}d]', slotType, isOn, e.code);
      return Promise.reject(e);
    }
  }

  /**
   * 获取应用是否为备份应用
   */
  public isDeliver = async (): Promise<boolean> => {
    log.showInfo('IsDeliver.');
    try {
      const bundleModel = new BundleResourceModel();
      const ret = await bundleModel.isDeliverApplication(this.bundleOption.bundle);
      log.showInfo('IsDeliver. return %{public}s', ret);
      return Promise.resolve(ret);
    } catch (error) {
      log.showError('LoadDeliverFlag Error')
      return Promise.reject();
    }
  }
}