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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SettingsConstants, SettingsKeyConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { sSettingsUtil } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import Constants, { EyeComfortToggleData } from '../common/Constants';
import { ToggleOperation } from './EyeComfortToggleController';
import { EyeComfortToggleController } from './EyeComfortToggleController';
import { promptAction } from '@kit.ArkUI';
import lazy { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { EyeComfortSubpageController } from './EyeComfortSubpageController';
import { settings } from '@kit.BasicServicesKit';
import { EyeComportCommonUtil } from '../common/EyeComportCommonUtil';
import { EnableSettingsSearchItemManager } from '../common/EnableSettingsSearchItemManager';
import { ToggleViewData } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleViewData';

const TAG = 'Ctrl.PhoneToggleOperation';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

export class PhoneToggleOperation implements ToggleOperation {
  private mViewData: ToggleViewData = new ToggleViewData();
  private mEyeComfortToggleData: EyeComfortToggleData = new EyeComfortToggleData();
  private eyeComfortMode: string = SettingsConstants.EYE_SHIELD_MODE_DEFAULT;
  private openLottieName: string = '';
  private closeLottieName: string = '';
  private currentOpenLottieName: string = '';
  private currentCloseLottieName: string = '';
  private records: Record<string, object | null> = {};

  constructor(mViewData: ToggleViewData, records: Record<string, object | null>) {
    this.records = records;
    this.mViewData = mViewData;
  }

  public getEyeComportMode(): string {
    return this.eyeComfortMode;
  }

  public initEyeComportToggle(): void {
    this.updateEyeComfortStatus();
    this.updateEyeComfortMode();
  }

  /**
   * 护眼模式开启状态更新
   */
  private updateEyeComfortStatus(): void {
    const eyeShieldEnable: string = sSettingsUtil.getSystemValue(SettingsKeyConstants.EYE_SHIELD_ENABLE,
      SettingsConstants.EYE_SHIELD_MODE_CLOSE);
    const statusOpen: boolean = eyeShieldEnable === '1';
    if (this.mViewData.isOn !== statusOpen) {
      this.mViewData.isOn = statusOpen;
      this.updateIcon();
    }
    log.showInfo(`updateEyeComfortStatus eyeShieldEnable:${eyeShieldEnable} status: ${this.mViewData.isOn}`);
  }

  /**
   * 护眼模式更新
   */
  private updateEyeComfortMode(): void {
    // 查询当前护眼模式
    this.eyeComfortMode = sSettingsUtil.getSystemValue(SettingsKeyConstants.EYE_COMFORT_MODE,
      SettingsConstants.EYE_SHIELD_MODE_DEFAULT);
    log.showInfo(`get eyeComfortMode: ${this.eyeComfortMode}`);

    let eyeComfortLastMode: string = sSettingsUtil.getSystemValue(SettingsKeyConstants.LAST_EYE_COMFORT_MODE,
      SettingsConstants.EYE_SHIELD_MODE_DEFAULT);
    log.showInfo(`get lastEyeComfortMode: ${eyeComfortLastMode}`);
    // 如果lastMode为空，但是mode不为0，需要主动设置一下lastMode，适配升级场景
    if (eyeComfortLastMode === SettingsConstants.EYE_SHIELD_MODE_DEFAULT &&
      this.eyeComfortMode !== SettingsConstants.EYE_SHIELD_MODE_DEFAULT) {
      sSettingsUtil.setValueEx(settings.domainName.USER_PROPERTY, SettingsKeyConstants.LAST_EYE_COMFORT_MODE,
        this.eyeComfortMode);
      log.showInfo(`change eyeComfortLastMode to: ${this.eyeComfortMode}`);
      eyeComfortLastMode = this.eyeComfortMode;
    }
    if (this.mEyeComfortToggleData.eyeComfortLastMode !== eyeComfortLastMode) {
      this.mEyeComfortToggleData.eyeComfortLastMode = eyeComfortLastMode;
      this.updateIcon();
    }
    this.matchLottieName();
  }

  updateIcon(): void {
    this.mViewData.icon = this.matchEyeComfortModeIcon();
  }

  /**
   * 护眼模式使能切换监听
   */
  public onEyeShieldEnableChange(): void {
    this.updateEyeComfortStatus();

    // 如果当前模式是智能护眼模式且护眼模式生效则弹窗提醒
    if (this.eyeComfortMode === SettingsConstants.EYE_SHIELD_MODE_SCHEDULE_SWING) {
      if (this.mViewData.isOn) {
        promptAction.showToast({
          message: ResUtils.getInnerString($r('app.string.control_center_eye_comfort_smart_open_subtitle_active')),
          showMode: 2,
          duration: 2000
        });
      }
      // 更新二级页智能护眼子标题
      new EyeComfortSubpageController().updateSubTitleByComfortChange();
    }
  }

  /**
   * 护眼模式切换监听
   */
  public onEyeComfortModeChange(): void {
    this.updateEyeComfortMode();
    this.setEyeComfortModeLottieData();
  }

  /**
   * 点击操作
   *
   * @returns
   */
  public handleOneClick(callback: () => void): void {
    // 如果当前开关状态是开启，则直接关闭
    if (this.mViewData.isOn) {
      this.mViewData.isOn = false;
      this.updateIcon();
      EyeComfortToggleController.getInstance().setEyeComfortMode(SettingsConstants.EYE_SHIELD_MODE_CLOSE);
      return;
    }
    // 如果当前是关闭态，需要拉起二级页
    callback();
  }

  /**
   * 匹配对应的lottie
   */
  private matchLottieName(): void {
    switch (this.eyeComfortMode) {
      case SettingsConstants.EYE_SHIELD_MODE_SCHEDULE_CUSTOM:
      case SettingsConstants.EYE_SHIELD_MODE_SCHEDULE_SUNSET:
        this.openLottieName = Constants.LOTTIE_DATA_SCHEDULE_OPEN;
        this.closeLottieName = Constants.LOTTIE_DATA_SCHEDULE_CLOSE;
        break;
      case SettingsConstants.EYE_SHIELD_MODE_SCHEDULE_SWING:
        this.openLottieName = Constants.LOTTIE_DATA_SWING_OPEN;
        this.closeLottieName = Constants.LOTTIE_DATA_SWING_CLOSE;
        break;
      default:
        this.openLottieName = Constants.LOTTIE_DATA_DAY;
        this.closeLottieName = Constants.LOTTIE_DATA_DAY;
    }
    log.showInfo(`matchLottieName eyeComfortMode: ${this.eyeComfortMode} , currentStatus: ${this.mViewData.isOn}`);
  }

  /**
   * 加载护眼模式状态匹配对应的动效资源
   *
   * @param callback 回调函数，用于设置lottieData
   */
  public setEyeComfortModeLottieData(callback?: (lottieName: string, isOpen: boolean) => void): void {
    // 手机需要保存两份lottie
    log.showInfo(`setEyeComfortModeLottieData openLottieName ${this.openLottieName}, closeLottieName ${this.closeLottieName}`);
    if (this.openLottieName === this.currentOpenLottieName && this.closeLottieName === this.currentCloseLottieName) {
      log.showInfo(`lottieData not change`);
      return;
    }
    if (callback) {
      callback(this.openLottieName, true);
      callback(this.closeLottieName, false);
    } else {
      EyeComportCommonUtil.getInstance().loadLottieData(this.openLottieName, data => {
        this.records.openLottieData = data;
      });
      EyeComportCommonUtil.getInstance().loadLottieData(this.closeLottieName, data => {
        this.records.closeLottieData = data;
      });
    }
    this.currentOpenLottieName = this.openLottieName;
    this.currentCloseLottieName = this.closeLottieName;
  }

  public getEyeComfortLottieData(): object | null {
    return this.mViewData.isOn ? this.records.openLottieData : this.records.closeLottieData;
  }

  /**
   * 根据护眼模式状态匹配对应的图标资源
   * 同时更新对应的lottie name
   *
   * @returns 图标资源
   */
  public matchEyeComfortModeIcon(): Resource {
    log.showInfo(`matchEyeComfortModeIcon status ${this.mViewData.isOn}, mode ${this.eyeComfortMode}`);
    // 如果是关闭态返回默认图标
    if (!this.mViewData.isOn) {
      return $r('app.media.ic_eye_comfort_day');
    }
    // 如果是开启态，根据当前mode，返回对应图标
    switch (this.eyeComfortMode) {
      case SettingsConstants.EYE_SHIELD_MODE_SCHEDULE_CUSTOM:
      case SettingsConstants.EYE_SHIELD_MODE_SCHEDULE_SUNSET:
        return $r('app.media.ic_eye_comfort_schedule');
      case SettingsConstants.EYE_SHIELD_MODE_SCHEDULE_SWING:
        return $r('app.media.ic_eye_comfort_swing');
      default:
        return $r('app.media.ic_eye_comfort_day');
    }
  }

  /**
   * 清除护眼模式Lottie
   */
  public removeAllLottieData(): void {
    this.records = {};
    this.currentOpenLottieName = '';
    this.currentCloseLottieName = '';
  }
}
