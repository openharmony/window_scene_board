/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import { LogDomain, LogHelper } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { DeviceHelper, sSettingsUtil } from '@ohos/managementcomponent';
import { display } from '@kit.ArkUI';
import { NotificationMgmtModel } from '../model/NotificationMgmtModel';
import { EnterpriseConfig,
  PinTopAppItem, PinTopDialogOption } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicUiCommon';
import { BitUtil } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { NtfSettingSysEventReporter }
  from '@ohos/managementcomponent/src/main/ets/com/ohos/common/NtfSettingSysEventReporter';
import { NotificationMgmtViewData } from './NotificationMgmtViewData';
import { getIdxInModelFlags, getModelSlotType, NotificationConstants,
  RemindType, SlotType } from '../common/NotificationMgmtCommon';
import {
  notificationSettingManager
} from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/NotificationSettingManager';
import { NotificationConfigEvent, NotificationConfigEventType
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { PageStorages } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/PageStorages';
import NtfSettingUtil from '@ohos/managementcomponent/src/main/ets/com/ohos/common/NtfSettingUtil';
import { SettingsKeyConstants } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/constants';
import { common } from '@kit.AbilityKit';

const TAG = 'NotificationMgmt_ViewEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export class NotificationMgmtViewEvent {
  private pinTopExceededDialogControllerBuilder?: (option: PinTopDialogOption) => CustomDialogController;
  private viewData?: NotificationMgmtViewData;
  private model?: NotificationMgmtModel;
  private currModelRemindMode: number = 0;
  private bundleName: string = '';
  private appIndex: number = 0;
  private uid?: number;
  private pageInfos?: NavPathStack;

  public init(viewData: NotificationMgmtViewData, appInfo: ESObject,
    dialogControllerBuilder: (option: PinTopDialogOption) => CustomDialogController, pageInfos?: NavPathStack): void {
    this.bundleName = appInfo.appBundleName ?? '';
    this.appIndex = appInfo.appIndex ?? 0;
    this.uid = appInfo.appUid == null ? undefined : Number.parseInt(appInfo.appUid.toString());
    this.pageInfos = pageInfos;
    this.model = new NotificationMgmtModel(this.bundleName, this.uid);
    this.viewData = viewData;
    this.pinTopExceededDialogControllerBuilder = dialogControllerBuilder;
    this.load();

    notificationSettingManager.subscribeChangeEvent(this.onConfigChange);
  }

  public destroy(): void {
    notificationSettingManager.unsubscribeChangeEvent(this.onConfigChange);
  }

  public load() {
    log.showInfo('Load.')
    if (this.isHidedBundle()) {
      this.viewData?.setEnabled(false);
      this.viewData?.updateAllowState(false);
    } else {
      this.model?.getAllowState().then((isOn) => {
        this.viewData?.updateAllowState(isOn);
      });
      this.loadDetailConfig();
    }
  }

  private isHidedBundle() {
    const ret = EnterpriseConfig.isHideBundle(this.bundleName);
    log.showInfo('IsHideBundle for %{public}s is %{public}s', this.bundleName, ret);
    return ret;
  }

  private onConfigChange = (event: NotificationConfigEvent): void => {
    if (event.type === NotificationConfigEventType.UPDATE_ITEM ||
      event.type === NotificationConfigEventType.PINTOP_ITEM ||
      event.type === NotificationConfigEventType.HIDE_BANNER_CONTENT ||
      event.type === NotificationConfigEventType.SLOT_CHANGE ||
      event.type === NotificationConfigEventType.SILENT_NOTIFICATION) {
      this.load();
    } else if (event.type === NotificationConfigEventType.DELETE_ITEM) {
      if (event.uid !== this.uid) {
        return;
      }
      if (this.viewData?.isFromMainPage()) {
        // 从设置-通知和状态栏进入 父页面是Navigation，需要使用NavPathStack.pop返回
        this.pageInfos?.pop();
      } else {
        // 其他页面进入，触发返回按钮
        PageStorages.popContext();
      }
    }
  };

  /**
   * 加载详细数据（除开关以外的配置数据）
   */
  private loadDetailConfig() {
    if (this.viewData?.isOn()) {
      this.loadPinTopConfig();
      this.loadSilenceConfig();
      this.loadHideBannerContentConfig();
      this.loadReminderTypesConfig();
      this.loadSlotsConfig();
    }
  }

  private loadSilenceConfig() {
    log.showInfo('LoadSilenceConfig');
    this.model?.getSilenceState().then((isOn) => this.viewData?.updateSilenceState(isOn));
  }

  private loadPinTopConfig() {
    log.showDebug('LoadPinTopConfig.');
    this.model?.getPinTopState().then(isOn => this.viewData?.updatePinTopState(isOn));
  }

  private loadHideBannerContentConfig() {
    log.showDebug('loadHideBannerContentConfig.');
    this.model?.getBannerDisplayMode().then(type => {
      this.viewData?.updateHideBannerContentReminder(type);
    })
  }

  private loadReminderTypesConfig() {
    log.showDebug('LoadReminderTypesConfig.');
    this.model?.getBadgeState()
      .then((isOn: boolean) => {
        this.viewData?.updateBadgeReinderState(isOn);
      });
    this.model?.getSlotFlags()
      .then(slotFlags => {
        this.currModelRemindMode = slotFlags;
        this.viewData?.updateReminderTypes(slotFlags);
      });

    this.viewData?.updateBadgeTotalSwitchState(sSettingsUtil.getSecureValue(
      SettingsKeyConstants.APP_NTF_CONFIG_SHOW_DESKTOP_BADGES) ===
      'true' ? true : false);
  }

  private loadSlotsConfig = (): void => {
    log.showDebug('LoadSlotsConfig.');
    this.model?.getSlots().then(this.viewData?.reloadSlots);
  }

  public initNavMode(initMode: NavigationMode): void {
    log.showInfo('InitNavMode. initMode: %{public}d.', initMode);
    this.viewData?.updateHideBackButton(this.isHideBackButton(initMode));
  }

  private isHideBackButton(mode: NavigationMode) {
    let isHide = false;

    if (mode === NavigationMode.Split) {
      isHide = true;
    } else {
      isHide = this.getDefaultNavModeByDevice() === NavigationMode.Split;
    }
    log.showDebug('IsHideBackButton. mode: [%{public}d], return: [%{public}s]', mode, isHide);
    return isHide;
  }

  private getDefaultNavModeByDevice(): NavigationMode {
    if (DeviceHelper.isPC() || DeviceHelper.isPad()) {
      return NavigationMode.Split;
    }

    try {
      if (display.isFoldable() &&
        (display.getFoldStatus() === display.FoldStatus.FOLD_STATUS_EXPANDED ||
        NtfSettingUtil.isXTFoldExpandedMode())) {
        return NavigationMode.Split;
      }
    } catch (error) {
      log.showError(`get fold status failed ${error}`);
    }

    return NavigationMode.Stack;
  }

  public onNavModeChanged(mode: NavigationMode): void {
    log.showInfo('OnNavModeChanged. mode: [%{public}d]', mode);
    this.viewData?.updateHideBackButton(mode === NavigationMode.Split);
  }

  /**
   * 允许通知开关变化事件
   */
  public allowStateChanged = (isOn: boolean): void => {
    log.showInfo('AllowStateChanged. to [%{public}s]', isOn);
    this.reportMgmtOperate('ALLOWED', isOn);
    this.model?.setAllowState(isOn).then(() => {
      this.viewData?.updateAllowState(isOn);
      this.loadDetailConfig();
    });
    if (isOn === false) {
      this.pinTopStateChanged(isOn);
    }
  }

  private async reportMgmtOperate(switchId: string, isOn: boolean): Promise<void> {
    try {
      NtfSettingSysEventReporter.notificationSettingAppManagement({
        CREATOR_BUNDLE_NAME: this.bundleName,
        SWITCH_ID: switchId,
        SWITCH_STATUS: isOn ? 0 : 1
      });
    } catch (e) {
      log.showError('ReportMgmtOperate Error. bundleName: %{public}s switchId: %{public}s isOn: %{public}s',
        this.bundleName, switchId, isOn);
    }
  }

  private async reportMgmtSelectOperate(switchId: string, type: number): Promise<void> {
    try {
      NtfSettingSysEventReporter.notificationSettingAppManagement({
        CREATOR_BUNDLE_NAME: this.bundleName,
        SWITCH_ID: switchId,
        SWITCH_STATUS: type
      });
    } catch (e) {
      log.showError('reportMgmtSelectOperate Error. bundleName: %{public}s switchId: %{public}s isOn: %{public}s',
        this.bundleName, switchId, type);
    }
  }

  /**
   * 隐藏横幅通知内容开关变化事件
   */
  public hideBannerContentChanged = (type: number): void => {
    log.showInfo('hideBannerContentChanged. type: [%{public}d]', type);
    this.reportMgmtSelectOperate('HIDE_BANNER_CONTENT', type);
    this.model?.setBannerDisplayMode(type).then(() => {
      this.viewData?.updateHideBannerContentReminder(type);
    });
  }

  /**
   * 置顶通知开关变化事件
   */
  public pinTopStateChanged = async (isOn: boolean): Promise<void> => {
    log.showInfo('PinTopStateChanged. to [%{public}s]', isOn);
    this.reportMgmtOperate('TOP', isOn);

    if (isOn && (await notificationSettingManager.getPinTopCount()) >= 5) {
      this.viewData?.updatePinTopState(false);
      this.openPinTopExceededDialog();
    } else {
      this.doPinTopStateChanged(isOn);
    }
  }

  private doPinTopStateChanged(isOn: boolean) {
    this.model?.setPinTopState(isOn).then(() => {
      this.viewData?.updatePinTopState(isOn);
    });
  }

  private doSilenceStateChanged(isOn: boolean) {
    this.model?.setSilenceState(isOn).then(() => {
      this.viewData?.updateSilenceState(isOn);
      this.loadSlotsConfig();
    });
  }

  private openPinTopExceededDialog(): void {
    log.showInfo('OpenPinTopExceededDialog.');
    if (this.pinTopExceededDialogControllerBuilder) {
      const controller = this.pinTopExceededDialogControllerBuilder({
        limit: 5,
        onSelected: (selected: Set<PinTopAppItem>) => { this.onPinTopSelected(controller, selected) },
        onCancel: () => { this.onPinTopCancel(controller) }
      });
      controller.open();
    } else {
      log.showWarn('PinTOpExceededDialogControllerBuilder is none');
    }
  }

  private onPinTopSelected = (controller: CustomDialogController, selected: Set<PinTopAppItem>): void => {
    log.showInfo('PinTopDialogSelected. selected len is %{public}d', selected.size);
    this.model?.batchDisablePinTop(selected).then((isSuccess) => {
      if (isSuccess) {
        this.doPinTopStateChanged(true);
      }
      controller.close();
    });
  }

  private onPinTopCancel = (controller: CustomDialogController): void => {
    log.showInfo('PinTopDialogCancel.');
    controller.close();
  }

  /**
   * 静默通知开关变化事件
   */
  public silentStateChanged = (isOn: boolean): void => {
    log.showInfo(`SilentState changes to ${isOn}`);
    this.reportMgmtOperate('SILENCE', isOn);
    this.doSilenceStateChanged(isOn);
  }

  /**
   * 可视化提醒方式开关变化事件
   */
  public remindStateChanged = (type: RemindType, isOn: boolean): void => {
    // 静默通知开关开启时，点击任意提醒开关
    if (type !== RemindType.DESKTOP_CORNER && this.viewData?.getSilenceState().isOn() === true) {
      // 1.处理被点击的开关，将其打开
      log.showInfo('RemindStateChange. clicked button type: [%{public}d], isOn: [%{public}s], currModelRemindMode: [%{public}d]',
        type, true, this.currModelRemindMode);
      const idx = getIdxInModelFlags(type);
      if (idx == null) {
        log.showWarn('Can not get ans remind flag idx for [%{public}d]', type);
        return;
      }
      this.changeRemindState(type, true);
      // 更新类别的提醒方式
      let targetReminderMode = BitUtil.changeByIdx(this.currModelRemindMode, idx, true);
      this.currModelRemindMode = targetReminderMode;
      log.showInfo(`currModelRemindMode ${this.currModelRemindMode}`)

      // 2.将未被点击的开关放入remainingTypes
      const allTypes = Object.values(RemindType).filter(val => typeof val === 'number').map(Number);
      const excludeTypes = new Set([type, RemindType.DESKTOP_CORNER]);
      const remainingTypes = allTypes.filter(type => !excludeTypes.has(type));
      // 处理未被点击的开关，将其关闭
      remainingTypes.forEach(index => {
        const idx = getIdxInModelFlags(index);
        if (idx == null) {
          log.showWarn('Can not get ans remind flag idx for [%{public}d]', index);
          return;
        }
        this.changeRemindState(index, false);
        // 更新类别的提醒方式
        let targetReminderMode = BitUtil.changeByIdx(this.currModelRemindMode, idx, false);
        this.currModelRemindMode = targetReminderMode;
        log.showInfo(`currModelRemindMode ${this.currModelRemindMode}`)
      });
      this.model?.setSlotFlags(this.currModelRemindMode).then(() => {
        this.loadSlotsConfig();
      });
      // 3.更新静默通知开关
      this.doSilenceStateChanged(false);
      return;
    }
    // 静默通知未开启时，正常处理
    this.specificRemindStateChanged(type, isOn);
  }

  private specificRemindStateChanged(type: RemindType, isOn: boolean): void {
    log.showInfo('RemindStateChange. fen type: [%{public}d], isOn: [%{public}s], currModelRemindMode: [%{public}d]',
      type, isOn, this.currModelRemindMode);
    const idx = getIdxInModelFlags(type);

    if (idx == null) {
      log.showWarn('Can not get ans remind flag idx for [%{public}d]', type);
      return;
    }

    this.changeRemindState(type, isOn);

    let targetReminderMode = BitUtil.changeByIdx(this.currModelRemindMode, idx, isOn);
    this.model?.setSlotFlags(targetReminderMode).then(() => {
      this.currModelRemindMode = targetReminderMode;
      this.loadSlotsConfig();
    });
  }

  private changeRemindState(type: RemindType, isOn: boolean): void {
    if (type === RemindType.LOCK_SCREEN) {
      this.reportMgmtOperate('Lock', isOn);
      this.viewData?.updateLockScreenReminderState(isOn);
    } else if (type === RemindType.BANNER) {
      this.reportMgmtOperate('BANNER', isOn);
      this.viewData?.updateBannerReminderState(isOn);
    } else if (type === RemindType.SOUND) {
      this.reportMgmtOperate('RING', isOn);
      this.viewData?.updateSoundReminderState(isOn);
    } else if (type === RemindType.VIBRATION) {
      this.reportMgmtOperate('VIBRATION', isOn);
      this.viewData?.updateVibrationReminderState(isOn);
    }
  }
  /**
   * 桌面角标开关变化事件
   */
  public badgeStateChanged = (isOn: boolean): void => {
    log.showInfo('BadgeStateChanged. isOn: [%{public}s]', isOn);
    this.reportMgmtOperate('BADGE', isOn);
    this.model?.setDesktopBadge(isOn).then(() => {
      this.viewData?.updateBadgeReinderState(isOn);
    });
  }
  /**
   * 类型状态开关变化事件
   */
  public slotStateChanged = (isOn: boolean, slotType: SlotType): void => {
    log.showInfo('SlotStateChanged. isOn: [%{public}s], slotType: [%{public}d]', isOn, slotType);
    const modelSlotType = getModelSlotType(slotType);
    if (modelSlotType == null) {
      log.showWarn('Slot state changed. model slot type is undefined for [%{public}d]', slotType);
      return
    }

    this.reportTypeOperate(SlotType[slotType], isOn);
    this.model?.setSlot(modelSlotType, isOn).then(this.loadSlotsConfig)
  }

  private async reportTypeOperate(switchId: string, isOn: boolean): Promise<void> {
    try {
      NtfSettingSysEventReporter.notificationSettingAppManagementTypeChange({
        CREATOR_BUNDLE_NAME: this.bundleName,
        SWITCH_ID: switchId,
        SWITCH_STATUS: isOn ? 0 : 1
      });
    } catch (e) {
      log.showError('ReportTypeOperate Error. bundleName: %{public}s switchId: %{public}s isOn: %{public}s',
        this.bundleName, switchId, isOn);
    }
  }

  public openAppNtfMgmt = (abilityName: string) => {
    try {
      log.showInfo(`handleAppNtfMgmtClick bundleName: ${this.bundleName}, appIndex: ${this.appIndex}`);
      NtfSettingSysEventReporter.ntfSettingOpenAppInnerMgmt({
        CREATOR_BUNDLE_NAME: this.bundleName
      });
      (getContext(this) as common.UIAbilityContext).startAbility({
        bundleName: this.bundleName,
        abilityName: abilityName,
        parameters: {
          'linkFeature': NotificationConstants.APP_NTF_MGMT,
          'ohos.extra.param.key.appCloneIndex': this.appIndex
        }
      });
    } catch (e) {
      log.error(`open app notification management for ${this.bundleName} error:`, e);
    }
  }
}