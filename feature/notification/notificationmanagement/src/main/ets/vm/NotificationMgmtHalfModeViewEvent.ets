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

import { LogDomain, Logger } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { EnterpriseConfig, PinTopAppItem } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicUiCommon';
import { BitUtil } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import {
  getIdxInModelFlags,
  getModelSlotType,
  RemindType,
  SlotType,
  SwitchKey
} from '../common/NotificationMgmtCommon';
import {
  notificationSettingManager
} from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/NotificationSettingManager';
import { NotificationMgmtBaseViewEvent } from './NotificationMgmtBaseViewEvent';
import {
  NtfSettingSysEventReporter
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/NtfSettingSysEventReporter';
import { notificationManager } from '@kit.NotificationKit';
import { SettingsKeyConstants } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/constants';
import { DeviceHelper, sSettingsUtil } from '@ohos/managementcomponent';

const TAG = 'NotificationMgmtHalfMode_ViewEvent';
const log: Logger = Logger.getLogHelper(LogDomain.NC);

export class NotificationMgmtHalfModeViewEvent extends NotificationMgmtBaseViewEvent {
  private currModelRemindMode: number = 0;
  private currModelSlots: notificationManager.NotificationSlot[] = [];
  private switchOldStatusMap: Map<SwitchKey | SlotType, boolean | number> =
    new Map<SwitchKey | SlotType, boolean | number>();
  /**
   * 加载开关数据
   */
  public override async load() {
    log.showInfo(TAG, 'Load.');
    if (this.isHidedBundle()) {
      this.viewData.setEnabled(false);
      this.viewData?.updateAllowState(false);
    } else {
      await Promise.all([
        this.loadAllowState(),
        this.loadSwitchConfig()
      ]);
      this.initSwitchOldStatusMap();
    }
  }

  /**
   * 加载开关数据（除允许通知开关以外的数据）
   */
  public loadSwitchConfig = async () => {
    return Promise.all([
      this.loadPinTopConfig(),
      this.loadSilenceConfig(),
      this.loadHideBannerContentConfig(),
      this.loadSlotsState(),
      this.loadBadgeState(),
      this.loadSlotsConfig()
    ]);
  }

  private loadSilenceConfig() {
    log.showInfo(TAG, 'LoadSilenceConfig');
    this.model?.getSilenceState().then((isOn) => this.viewData?.updateSilenceState(isOn));
  }

  private initSwitchOldStatusMap() {
    log.showInfo(TAG, 'init switch old status map');
    this.switchOldStatusMap.set(SwitchKey.ALLOW, this.viewData.getAllowState().isOn());
    this.switchOldStatusMap.set(SwitchKey.PIN_TOP, this.viewData.getPinTopState().isOn());
    this.switchOldStatusMap.set(SwitchKey.SILENCE, this.viewData.getSilenceState().isOn());
    this.switchOldStatusMap.set(SwitchKey.SLOTS, this.currModelRemindMode);
    this.switchOldStatusMap.set(SwitchKey.BADGE, this.viewData.getCornerReminderViewData().isOn());
    for (let slot of this.viewData.getSlotsViewData()) {
      this.switchOldStatusMap.set(slot.getType(), slot.isOn());
    }
  }

  private async loadAllowState() {
    log.showDebug(TAG, 'loadAllowState.');
    await this.model?.getAllowState().then((isOn) => this.viewData?.updateAllowState(isOn));
  }

  private async loadPinTopConfig() {
    log.showDebug(TAG, 'LoadPinTopConfig.');
    await this.model?.getPinTopState().then(isOn => this.viewData?.updatePinTopState(isOn));
  }

  private async loadHideBannerContentConfig() {
    log.showDebug(TAG, 'loadHideBannerContentConfig.');
    await this.model?.getBannerDisplayMode().then(type => {
      this.viewData?.updateHideBannerContentReminder(type);
    })
  }

  private async loadSlotsState() {
    log.showDebug(TAG, 'loadSlotsState.');
    await this.model?.getSlotFlags()
      .then(slotFlags => {
        this.currModelRemindMode = slotFlags;
        this.viewData?.updateReminderTypes(slotFlags);
      });
  }

  private async loadBadgeState() {
    log.showDebug(TAG, 'loadBadgeState.');
    await this.model?.getBadgeState()
      .then((isOn: boolean) => {
        this.viewData?.updateBadgeReinderState(isOn);
      });
    this.viewData?.updateBadgeTotalSwitchState(
      sSettingsUtil.getSecureValue(SettingsKeyConstants.APP_NTF_CONFIG_SHOW_DESKTOP_BADGES) ===
      "true" ? true : false);
  }

  private async loadSlotsConfig() {
    log.showDebug(TAG, 'LoadSlotsConfig.');
    await this.model?.getSlots().then((modelSlots: notificationManager.NotificationSlot[]) => {
      this.currModelSlots = modelSlots;
      this.viewData?.reloadSlots(modelSlots);
    });
  }

  /**
   * 允许通知开关UI变化事件
   */
  public override allowStateChanged = (isOn: boolean): void => {
    log.showInfo(TAG, 'AllowStateChanged. to [%{public}s]', isOn);
    if (isOn) {
      // 配置加载完成后再变更允许开关状态，避免出现开关切换动画
      this.loadSwitchConfig().then(() => {
        this.viewData?.updateAllowState(isOn);
      });
    } else {
      this.viewData?.updateAllowState(isOn);
      this.pinTopStateChanged(isOn);
    }
  }

  /**
   * 置顶通知开关UI变化事件
   */
  public override pinTopStateChanged = (isOn: boolean) => {
    log.showInfo(TAG, 'PinTopStateChanged. to [%{public}s]', isOn);
    this.viewData?.updatePinTopState(isOn);
  }

  /**
   * 静默通知开关变化事件
   */
  public override silentStateChanged = (isOn: boolean): void => {
    log.showInfo(TAG, `SilentState changes to ${isOn}`);
    this.viewData?.updateSilenceState(isOn);
    // 刷新可视化按钮图标
    if (isOn) {
      this.viewData?.updateLockScreenReminderUI(isOn);
      this.viewData?.updateBannerReminderUI(isOn);
    } else {
      this.viewData?.updateLockScreenReminderUI(!this.viewData.getScreenLockReminderViewData().isOn());
      this.viewData?.updateBannerReminderUI(!this.viewData.getBannerReminderViewData().isOn());
    }
  }

  /**
   * 隐藏横幅通知内容开关变化事件
   */
  public hideBannerContentChanged = (type: number): void => {
    log.showInfo(TAG, 'hideBannerContentChanged. type: [%{public}d]', type);
    this.model?.setBannerDisplayMode(type).then(() => {
      this.viewData?.updateHideBannerContentReminder(type);
    });
  }

  /**
   * 可视化提醒方式开关UI变化事件
   */
  public override remindStateChanged = (type: RemindType, isOn: boolean): void => {
    log.showInfo(TAG, 'RemindStateChange. type: [%{public}d], isOn: [%{public}s]', type, isOn);
    // 静默通知开关开启时，点击任意提醒开关
    if (type !== RemindType.DESKTOP_CORNER && this.viewData?.getSilenceState().isOn() === true) {
      // 1.处理被点击的开关，将其打开
      // 处理可视化ui图标变化
      if (type === RemindType.LOCK_SCREEN && !DeviceHelper.isPC()) {
        this.viewData.getScreenLockReminderViewData().setState(true);
        this.viewData.updateLockScreenReminderUI(false);
      } else if (type === RemindType.BANNER && !DeviceHelper.isPC()) {
        this.viewData.getBannerReminderViewData().setState(true);
        this.viewData.updateBannerReminderUI(false);
      } else {
        this.changeRemindState(type, true);
      }

      // 2.将未被点击的开关放入remainingTypes
      const allTypes = Object.values(RemindType).filter(val => typeof val === 'number').map(Number);
      const excludeTypes = new Set([type, RemindType.DESKTOP_CORNER]);
      const remainingTypes = allTypes.filter(type => !excludeTypes.has(type));
      // 处理未被点击的开关，将其关闭
      remainingTypes.forEach(index => {
        this.changeRemindState(index, false);
      });
      // 3.更新静默通知开关
      this.viewData?.updateSilenceState(false);
      return;
    }
    this.changeRemindState(type, isOn);
  }

  private changeRemindState(type: RemindType, isOn: boolean): void {
    if (type === RemindType.LOCK_SCREEN) {
      this.viewData?.updateLockScreenReminderState(isOn);
    } else if (type === RemindType.BANNER) {
      this.viewData?.updateBannerReminderState(isOn);
    } else if (type === RemindType.SOUND) {
      this.viewData?.updateSoundReminderState(isOn);
    } else if (type === RemindType.VIBRATION) {
      this.viewData?.updateVibrationReminderState(isOn);
    }
  }

  /**
   * 桌面角标开关UI变化事件
   */
  public override badgeStateChanged = (isOn: boolean): void => {
    log.showInfo(TAG, 'BadgeStateChanged. isOn: [%{public}s]', isOn);
    this.viewData?.updateBadgeReinderState(isOn);
  }

  /**
   * 类型状态开关UI变化事件
   */
  public override slotStateChanged = (isOn: boolean, slotType: SlotType): void => {
    log.showInfo(TAG, 'SlotStateChanged. isOn: [%{public}s], slotType: [%{public}d]', isOn, slotType);
    for (let slot of this.viewData.getSlotsViewData()) {
      if (slot.getType() === slotType) {
        slot.setState(isOn);
      }
    }
  }

  /**
   * 点击确定处理事件
   * return true-成功，关闭半模态；false-取消，不关闭半模态
   */
  public onClickConfirm = async (): Promise<boolean> => {
    log.showInfo(TAG, 'onClickConfirm');
    // 先处理置顶开关，超过5个的弹窗被取消时，返回页面
    const pinTonState = this.viewData.getPinTopState().isOn();
    if (this.switchOldStatusMap.has(SwitchKey.PIN_TOP) &&
      this.switchOldStatusMap.get(SwitchKey.PIN_TOP) !== pinTonState) {
      const res = await this.pinTopStateDataChanged(pinTonState);
      if (!res) {
        log.showInfo(TAG, 'pinTopDialog is canceled');
        this.viewData?.updatePinTopState(false);
        return false;
      }
    }
    // 批量处理其余开关变化
    await this.batchProcessDataChange();
    log.showInfo(TAG, 'onClickConfirm success');
    return true;
  }

  private async batchProcessDataChange() {
    log.showInfo(TAG, 'batchProcessDataChange enter');
    const promiseArray: Promise<void>[] = [];
    const allowState = this.viewData.getAllowState().isOn();
    if (this.switchOldStatusMap.has(SwitchKey.ALLOW) &&
      this.switchOldStatusMap.get(SwitchKey.ALLOW) !== allowState) {
      promiseArray.push(this.allowStateDataChanged(allowState));
    }

    const silenceState = this.viewData.getSilenceState().isOn();
    if (this.switchOldStatusMap.has(SwitchKey.SILENCE) &&
      this.switchOldStatusMap.get(SwitchKey.SILENCE) !== silenceState) {
      promiseArray.push(this.silenceStateDataChanged(silenceState));
    }

    const targetFlags = this.calculateSlotsFlags();
    if (this.switchOldStatusMap.has(SwitchKey.SLOTS) &&
      this.switchOldStatusMap.get(SwitchKey.SLOTS) !== targetFlags) {
      promiseArray.push(this.slotsDataChanged(targetFlags));
    }

    const badgeState = this.viewData.getCornerReminderViewData().isOn();
    if (this.switchOldStatusMap.has(SwitchKey.BADGE) &&
      this.switchOldStatusMap.get(SwitchKey.BADGE) !== badgeState) {
      promiseArray.push(this.badgeStateDataChanged(badgeState));
    }

    for (let slot of this.viewData.getSlotsViewData()) {
      if (this.switchOldStatusMap.has(slot.getType()) &&
        this.switchOldStatusMap.get(slot.getType()) !== slot.isOn()) {
        promiseArray.push(this.slotStateDataChanged(slot.isOn(), slot.getType()));
      }
    }
    await Promise.all(promiseArray);
    log.showInfo(TAG, 'batchProcessDataChange exit');
  }

  public refreshSlots(): void {
    this.viewData.refreshSlotsByReminderMode(this.currModelSlots);
  }

  private calculateSlotsFlags = (): number => {
    let targetFlags = this.currModelRemindMode;
    targetFlags = BitUtil.changeByIdx(targetFlags, getIdxInModelFlags(RemindType.LOCK_SCREEN),
      this.viewData.getScreenLockReminderViewData().isOn());
    targetFlags = BitUtil.changeByIdx(targetFlags, getIdxInModelFlags(RemindType.BANNER),
      this.viewData.getBannerReminderViewData().isOn());
    targetFlags = BitUtil.changeByIdx(targetFlags, getIdxInModelFlags(RemindType.SOUND),
      this.viewData.getSoundReminderState().isOn());
    targetFlags = BitUtil.changeByIdx(targetFlags, getIdxInModelFlags(RemindType.VIBRATION),
      this.viewData.getVibrationReinderState().isOn());
    return targetFlags;
  }

  // 置顶开关数据变化处理
  private async pinTopStateDataChanged(isOn: boolean): Promise<boolean> {
    log.showInfo(TAG, 'pinTopStateDataChanged. to [%{public}s]', isOn);
    this.reportMgmtOperate('TOP', isOn);

    if (isOn && (await notificationSettingManager.getPinTopCount()) >= 5) {
      return this.openPinTopExceededDialog();
    } else {
      this.doPinTopStateChanged(isOn);
    }
    return true;
  }

  // 静默开关数据变化处理
  private async silenceStateDataChanged(isOn: boolean): Promise<void> {
    log.showInfo(TAG, 'silenceStateDataChanged. to [%{public}s]', isOn);
    await this.model?.setSilenceState(isOn);
    await this.reportMgmtOperate('SILENCE', isOn);
  }

  private doPinTopStateChanged(isOn: boolean) {
    this.model?.setPinTopState(isOn);
  }

  private async openPinTopExceededDialog(): Promise<boolean> {
    return new Promise((resolve) => {
      log.showInfo(TAG, 'OpenPinTopExceededDialog.');
      if (this.pinTopExceededDialogControllerBuilder) {
        const controller = this.pinTopExceededDialogControllerBuilder({
          limit: 5,
          onSelected: (selected: Set<PinTopAppItem>) => {
            this.onPinTopSelected(controller, selected);
            resolve(true);
          },
          onCancel: () => {
            this.onPinTopCancel(controller);
            resolve(false);
          }
        });
        controller.open();
      } else {
        log.showWarn(TAG, 'PinTOpExceededDialogControllerBuilder is none');
        resolve(false);
      }
    });
  }

  private onPinTopSelected = (controller: CustomDialogController, selected: Set<PinTopAppItem>): void => {
    log.showInfo(TAG, 'PinTopDialogSelected. selected len is %{public}d', selected.size);
    this.model?.batchDisablePinTop(selected).then((isSuccess) => {
      if (isSuccess) {
        this.doPinTopStateChanged(true);
      }
      controller.close();
    });
  }
  private onPinTopCancel = (controller: CustomDialogController): void => {
    log.showInfo(TAG, 'PinTopDialogCancel.');
    controller.close();
  }

  // 允许通知开关数据变化处理
  private async allowStateDataChanged(isOn: boolean): Promise<void> {
    log.showInfo(TAG, 'allowStateDataChanged. isOn: [%{public}s]', isOn);
    await this.model?.setAllowState(isOn);
    await this.reportMgmtOperate('ALLOWED', isOn);
  }

  // 可视化开关数据变化处理
  private async slotsDataChanged(flags: number): Promise<void> {
    log.showInfo(TAG, 'slotsDataChanged. flags: [%{public}s]', flags);
    await this.model?.setSlotFlags(flags);
  }

  /**
   * 桌面角标开关数据变化事件
   */
  private async badgeStateDataChanged(isOn: boolean): Promise<void> {
    log.showInfo(TAG, 'badgeStateDataChanged. isOn: [%{public}s]', isOn);
    await this.model?.setDesktopBadge(isOn);
    await this.reportMgmtOperate('BADGE', isOn);
  }

  /**
   * 类型状态开关数据变化事件
   */
  private async slotStateDataChanged(isOn: boolean, slotType: SlotType): Promise<void> {
    log.showInfo(TAG, 'slotStateDataChanged. isOn: [%{public}s], slotType: [%{public}d]', isOn, slotType);
    const modelSlotType = getModelSlotType(slotType);
    if (modelSlotType == null) {
      log.showWarn(TAG, 'Slot state changed. model slot type is undefined for [%{public}d]', slotType);
      return;
    }
    await this.model?.setSlot(modelSlotType, isOn);
    await this.reportTypeOperate(SlotType[slotType], isOn);
  }

  public async reportHalfModeCloseOperate(operationType: number): Promise<void> {
    try {
      NtfSettingSysEventReporter.notificationCloseHalfMode({
        FROM_APP: this.bundleName ?? '',
        OPERATION_TYPE: operationType
      });
    } catch (e) {
      log.showError(TAG, 'reportHalfModeCloseOperate Error. bundleName: %{public}s operationType: %{public}s',
        this.bundleName, operationType);
    }
  }

  private isHidedBundle() {
    const ret = EnterpriseConfig.isHideBundle(this.bundleName);
    log.showInfo(TAG, 'IsHideBundle for %{public}s is %{public}s', this.bundleName, ret);
    return ret;
  }
}