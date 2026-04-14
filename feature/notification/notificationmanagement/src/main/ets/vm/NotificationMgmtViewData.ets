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
import { DeviceHelper } from '@ohos/managementcomponent';
import { BitUtil } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import {
  getIdxInModelFlags,
  getViewDataSlotType,
  LockScreenNtfStyle,
  NotificationConstants,
  RemindType,
  SlotType
} from '../common/NotificationMgmtCommon';
import { NotificationMgmtModel } from '../model/NotificationMgmtModel';
import { notificationManager } from '@kit.NotificationKit';
import { RemindLabelsParser } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/RemindLabelsParser';
import image from '@ohos.multimedia.image';
import { bundleManager } from '@kit.AbilityKit';

const TAG = 'NotificationMgmt_ViewData';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 通知管理ViewData
 */
export class NotificationMgmtViewData {
  /* 开关是否打开 */
  private on: boolean = true;
  /* 是否启用 */
  private enabled: boolean = true;
  /* 允许发送通知，值与 on 保持一致 */
  private allow: StateValue = new StateValue();
  /* 是否置顶 */
  private pinTop: StateValue = new StateValue();
  /* 是否静默 */
  private silence: StateValue = new StateValue();
  /* 是否隐藏 */
  private silenceOn: boolean = false;
  /* 锁屏通知 */
  private screenLockReminder: VisualReminderViewData = new VisualReminderViewData();
  /* 横幅通知 */
  private bannerReminder: VisualReminderViewData = new VisualReminderViewData();
  /* 桌面角标 */
  private badgeReminder: VisualReminderViewData = new VisualReminderViewData();
  /* 声音提醒 */
  private soundReminder: StateValue = new StateValue();
  /* 震动提醒 */
  private vibrationReinder: StateValue = new StateValue();
  /* 隐藏横幅通知内容 */
  private hideBannerContentReinder: StateNumberValue = new StateNumberValue(0);
  /* 类型 */
  private viewSlots: ObservedArray<SlotViewData> = new ObservedArray(new SlotViewData(SlotType.OTHER, ''));
  /* 是否包含返回按钮，直板机及折叠屏折叠态需要显示返回按钮，其他情况不显示返回按钮 */
  private hideBackButton: boolean = true;
  /* 是否从主页（通知和状态栏）跳转过来，false表示由其他场景（如左滑通知卡片，更多设置）直接跳转 */
  private fromMainPage: boolean = false;
  /* 是否来自应用和元服务 */
  private fromAppAndMeta: boolean = false;

  public isEnabled(): boolean {
    return this.enabled;
  }

  public setEnabled(enabled: boolean): void {
    this.enabled = enabled;
  }

  /* 是否为原生应用 */
  public isNativeApp(): boolean {
    return true;
  }

  public isOn(): boolean {
    return this.on;
  }

  public isSilent(): boolean {
    return this.silenceOn;
  }

  public getAllowState(): StateValue {
    return this.allow;
  }

  public getPinTopState(): StateValue {
    return this.pinTop;
  }

  public getSilenceState(): StateValue {
    return this.silence;
  }

  public getScreenLockReminderViewData(): VisualReminderViewData {
    return this.screenLockReminder;
  }

  public getBannerReminderViewData(): VisualReminderViewData {
    return this.bannerReminder;
  }

  public getCornerReminderViewData(): VisualReminderViewData {
    return this.badgeReminder;
  }

  public getSoundReminderState(): StateValue {
    return this.soundReminder;
  }

  public getVibrationReinderState(): StateValue {
    return this.vibrationReinder;
  }

  public getHideBannerContentReminder(): StateNumberValue {
    return this.hideBannerContentReinder;
  }

  public getSlotsViewData(): ObservedArray<SlotViewData> {
    return this.viewSlots;
  }

  public getSilenceSlotsViewData(): ObservedArray<SlotViewData> {
    return new ObservedArray(new SlotViewData(SlotType.OTHER, $r('app.string.silent_notification'), this.silence.isOn()));
  }

  public isHideBackButton(): boolean {
    return this.hideBackButton;
  }

  public updateHideBackButton(hideBackButton: boolean): void {
    this.hideBackButton = hideBackButton;
  }

  /**
   * allow 和 on 需要同步更新
   *
   * @param isOn
   */
  public updateAllowState(isOn: boolean): void {
    this.allow.setState(isOn);
    this.on = isOn;
  }

  /**
   * 更新置顶状态
   * @param isOn
   */
  public updatePinTopState(isOn: boolean): void {
    log.showInfo('UpdatePinTopState to %{public}s', isOn);
    this.pinTop.setState(isOn);
  }

  /**
   * 更新静默状态
   * @param isOn
   */
  public updateSilenceState(isOn: boolean): void {
    log.showInfo('UpdateSilenceState to %{public}s', isOn);
    this.silence.setState(isOn);
    this.silenceOn = isOn;
  }

  /**
   * 更新提醒方式
   * @param flags 二进制位表示
   */
  public updateReminderTypes(flags: number): void {
    log.showDebug('Set reminder types to [%{public}d]', flags);
    this.updateLockScreenReminderState(this.parseStateFromFlagsByReminderType(RemindType.LOCK_SCREEN, flags));
    this.updateBannerReminderState(this.parseStateFromFlagsByReminderType(RemindType.BANNER, flags));
    this.updateSoundReminderState(this.parseStateFromFlagsByReminderType(RemindType.SOUND, flags));
    this.updateVibrationReminderState(this.parseStateFromFlagsByReminderType(RemindType.VIBRATION, flags));
  }

  /**
   * 更新锁屏提示状态
   * @param isOn
   */
  public updateLockScreenReminderState(isOn: boolean): void {
    log.showDebug('Set lock screen reminder to [%{public}s]', isOn);
    const lockScreenStyle = NotificationMgmtModel.getLockScreenStyle() ?? LockScreenNtfStyle.LIST;
    this.screenLockReminder.setState(isOn);
    if (DeviceHelper.isPC()) {
      this.screenLockReminder.setImg($r('app.media.setting_noti_mgmt_app_lock_banner_pc'))
    } else {
      if (lockScreenStyle === LockScreenNtfStyle.LIST) {
        this.screenLockReminder.setImg(isOn && !this.getSilenceState().isOn() ?
        $r('app.media.pic_list_down_check') :
        $r('app.media.pic_list_down_grey'));
      } else {
        this.screenLockReminder.setImg(isOn && !this.getSilenceState().isOn() ?
        $r('app.media.pic_bottom_check') :
        $r('app.media.pic_bottom_grey'));
      }
    }
  }

  /**
   * 半模态下开关静默通知，更新可视化提醒方式UI
   */
  public updateLockScreenReminderUI(isOn: boolean) {
    const lockScreenStyle = NotificationMgmtModel.getLockScreenStyle() ?? LockScreenNtfStyle.LIST;
    if (lockScreenStyle === LockScreenNtfStyle.LIST) {
      this.screenLockReminder.setImg(!isOn ? $r('app.media.pic_list_down_check') : $r('app.media.pic_list_down_grey'));
    } else {
      this.screenLockReminder.setImg(!isOn ? $r('app.media.pic_bottom_check') : $r('app.media.pic_bottom_grey'));
    }
  }

  public updateBannerReminderUI(isOn: boolean) {
    if (DeviceHelper.isPC()) {
      this.bannerReminder.setImg($r('app.media.setting_noti_mgmt_app_unlock_banner_pc'));
    } else {
      this.bannerReminder.setImg(!isOn ? $r('app.media.pic_top_check') : $r('app.media.pic_top_grey'));
    }
  }

  /**
   * 更新横幅提示状态
   * @param isOn
   */
  public updateBannerReminderState(isOn: boolean): void {
    log.showDebug('Set banner reminder to [%{public}s]', isOn);
    this.bannerReminder.setState(isOn);
    if (DeviceHelper.isPC()) {
      this.bannerReminder.setImg($r('app.media.setting_noti_mgmt_app_unlock_banner_pc'))
    } else {
      this.bannerReminder.setImg(isOn && !this.getSilenceState().isOn() ? $r('app.media.pic_top_check') :
      $r('app.media.pic_top_grey'));
    }
  }

  /**
   * 更新角标提示状态
   * @param isOn
   */
  public updateBadgeReinderState(isOn: boolean): void {
    log.showDebug('Set badge reminder to [%{public}s].', isOn);
    this.badgeReminder.setState(isOn);
    if (DeviceHelper.isPC()) {
      this.badgeReminder.setImg($r('app.media.pic_pc_grid_grey'));
    } else {
      this.badgeReminder.setImg((this.badgeReminder.getTotalSwtich() && isOn) ? $r('app.media.pic_grid_check') :
      $r('app.media.pic_grid_grey'));
    }
  }

  /**
   * 更新角标总开关状态
   * @param isOn
   */
  public updateBadgeTotalSwitchState(isOn: boolean): void {
    log.showDebug('Set badge TotalSwitch to [%{public}s].', isOn);
    this.badgeReminder.setTotalSwtich(isOn);
    if (DeviceHelper.isPC()) {
      this.badgeReminder.setImg($r('app.media.pic_pc_grid_grey'));
    } else {
      this.badgeReminder.setImg((isOn && this.badgeReminder.isOn()) ? $r('app.media.pic_grid_check') :
      $r('app.media.pic_grid_grey'));
    }
  }

  /**
   * 更新声音提示状态
   * @param isOn
   */
  public updateSoundReminderState(isOn: boolean): void {
    log.showDebug('Set sound reminder to [%{public}s]', isOn);
    this.soundReminder.setState(isOn);
  }

  /**
   * 更新震动提示状态
   * @param isOn
   */
  public updateVibrationReminderState(isOn: boolean): void {
    log.showDebug('Set vibration reminder to [%{public}s]', isOn);
    this.vibrationReinder.setState(isOn);
  }

  /**
   * 更新隐藏横幅通知内容状态
   * @param isOn
   */
  public updateHideBannerContentReminder(type: number): void {
    log.showDebug(`Set hide banner content to ${type}`);
    this.hideBannerContentReinder.setState(type);
  }

  private parseStateFromFlagsByReminderType(type: RemindType, flags: number): boolean {
    const idxInFlags = getIdxInModelFlags(type);
    if (idxInFlags == null) {
      log.showWarn('ParseStateFromFlagsByReminderType none. type: [%{public}d], flags: [%{public}d]', type, flags);
      return false;
    }

    const ret = BitUtil.getStateByIdx(flags, idxInFlags);
    log.showDebug('ParseStateFromFlagsByReminderType, flags: [%{public}d] type: [%{public}d] return: [%{public}s]',
      flags, type, ret);
    return ret;
  }

  /**
   * 加载类型配置
   * @param modelSlots
   */
  public reloadSlots = (modelSlots: notificationManager.NotificationSlot[]): void => {
    log.showInfo('ReloadSlots.');
    this.viewSlots.splice(0, this.viewSlots.length, ...this.parseSlotsViewData(modelSlots))
    log.showDebug('ReloadSlots. viewSlots: %{public}s from: %{public}s',
      this.viewSlots.map(it => `{${it.getType()} - ${it.getSecLabel()} - ${it.isOn()}}`).join(','),
      modelSlots.map(it => `{${it.notificationType} - ${it.reminderMode} - ${it.enabled}}`).join(',')
    );
  }

  public refreshSlotsByReminderMode(modelSlots: notificationManager.NotificationSlot[]): void {
    if (modelSlots?.length != this.viewSlots.length) {
      log.showWarn('modelSolts.len: %{public}d, viewSlots.len: %{public}d', modelSlots?.length, this.viewSlots.length);
      return;
    }

    for (let i = 0; i < modelSlots.length; i++) {
      this.viewSlots[i].setSecLabel(this.getSecLabelByRemindMode(modelSlots[i].reminderMode, modelSlots[i].enabled));
    }
  }

  private parseSlotsViewData(slots: notificationManager.NotificationSlot[]): SlotViewData[] {
    let viewSlots: SlotViewData[] = [];
    for (let slot of slots) {
      let viewSlot = this.parseSlotViewData(slot);
      if (viewSlot) {
        viewSlots.push(viewSlot);
      }
    }
    return viewSlots;
  }

  private parseSlotViewData(slot: notificationManager.NotificationSlot): SlotViewData | undefined {
    const slotType = getViewDataSlotType(slot);
    if (slotType == null) {
      log.showWarn('ParseSlotViewData. slotType is none for [%{public}d]', slot.notificationType);
      return undefined;
    }

    const secondaryLabel = this.getSecLabelByRemindMode(slot.reminderMode, slot.enabled);
    log.showDebug('ParseSlotViewData. slotRemindMode: [%{public}d], enable: [%{public}s], ret: [%{public}s]',
      slot.reminderMode, slot.enabled, secondaryLabel);
    return new SlotViewData(slotType, secondaryLabel, slot.enabled ?? false);
  }

  private getSecLabelByRemindMode(remindMode?: number, enable?: boolean): ResourceStr {
    if (enable == null || enable === false) {
      return $r('app.string.remind_disable');
    }

    if (this.silence.isOn()) {
      return $r('app.string.silent_notification');
    }

    if (remindMode == null) {
      return $r('app.string.remind_only_notification_center');
    }

    return RemindLabelsParser.parse(remindMode);
  }

  public setFromMainPage(): void {
    log.showInfo('SetFromMainPage.');
    this.fromMainPage = true;
  }

  public isFromMainPage(): boolean {
    return this.fromMainPage;
  }

  public setFromAppAndMeta(): void {
    this.fromAppAndMeta = true;
  }

  public isFromAppAndMeta(): boolean {
    return this.fromAppAndMeta;
  }

  /**
   * 获取应用内通知管理abilityName
   * @param bundleName 包名
   * @returns
   */
  public getAppNtfMgmtAbilityName(bundleName: string): string {
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

@Observed
export class VisualReminderViewData {
  private state?: boolean;
  private img: Resource = $r('app.media.pic_grid_grey');
  private totalSwtich?: boolean;

  public isOn(): boolean {
    return this.state ?? false;
  }

  public setState(isOn: boolean): void {
    this.state = isOn;
  }

  public getImg(): Resource {
    return this.img;
  }

  public setImg(img: Resource): void {
    this.img = img;
  }

  public isInitialized(): boolean {
    return this.state !== undefined;
  }

  public getTotalSwtich(): boolean {
    return this.totalSwtich ?? true;
  }

  public setTotalSwtich(isOn: boolean) {
    this.totalSwtich = isOn;
  }
}

@Observed
export class SoltCfg {
  private type: SlotType;
  private viewData: SlotViewData;

  constructor(type: SlotType, viewData: SlotViewData) {
    this.type = type;
    this.viewData = viewData;
  }

  public getType(): SlotType {
    return this.type;
  }

  public getSlot(): SlotViewData {
    return this.viewData;
  }
}

@Observed
export class SlotViewData {
  private type: SlotType;
  private secondaryLabel: ResourceStr;
  private state?: boolean;

  constructor(type: SlotType, secondaryLabel: ResourceStr, state?: boolean) {
    this.type = type;
    this.secondaryLabel = secondaryLabel;
    this.state = state;
  }

  public getType(): SlotType {
    return this.type;
  }

  public getSecLabel(): ResourceStr {
    return this.secondaryLabel;
  }

  public setSecLabel(label: ResourceStr): void {
    this.secondaryLabel = label;
  }

  public isOn(): boolean {
    return this.state ?? false;
  }

  public setState(state: boolean): void {
    this.state = state;
  }

  public isInitialized(): boolean {
    return this.state !== undefined;
  }
}

@Observed
export class ObservedArray<T> extends Array<T> {
}

@Observed
export class StateValue {
  private value?: boolean;

  constructor(state?: boolean) {
    this.value = state ?? false;
  }

  public isOn(): boolean {
    return this.value ?? false;
  }

  public setState(state: boolean): void {
    this.value = state;
  }

  public isInitialized(): boolean {
    return this.value !== undefined;
  }
}

@Observed
export class StateNumberValue {
  private value: number;

  constructor(state: number) {
    this.value = state;
  }

  public setState(state: number): void {
    this.value = state;
  }

  public getState(): number {
    return this.value;
  }
}

@Observed
export class VisualReminderConfig {
  public label: ResourceStr = '';
  public viewData: VisualReminderViewData = new VisualReminderViewData();
  public onChange: (isOn: boolean) => void = () => {
    log.showWarn('VisualReinderConfig undefined.');
  };
}

/**
 * 半模态界面向子组件同步应用信息
 */
@Observed
export class AppVersionInfo {
  public appTitle: string = '';
  public appVersion: string = '';
  public appIcon: image.PixelMap | string | Resource | undefined | null = null;
}