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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SettingsConstants, SettingsKeyConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { sSettingsUtil } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import Constants, { EyeComfortToggleData } from '../common/Constants';
import { ToggleOperation } from './EyeComfortToggleController';
import { settings } from '@kit.BasicServicesKit';
import { EyeComportCommonUtil } from '../common/EyeComportCommonUtil';
import { EyeComfortToggleController } from './EyeComfortToggleController';
import { ToggleViewData } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleViewData';

const TAG = 'Ctrl.PCToggleOperation';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

export class PCToggleOperation implements ToggleOperation {
  private mViewData: ToggleViewData = new ToggleViewData();
  private mEyeComfortToggleData: EyeComfortToggleData = new EyeComfortToggleData();
  private eyeComfortMode: string = SettingsConstants.EYE_SHIELD_MODE_DEFAULT;
  private currentLottieName: string = '';
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
    this.updateEyeComfortIcon();
  }

  /**
   * 护眼模式开启状态更新
   */
  private updateEyeComfortStatus(): void {
    const eyeComfortMode: string = sSettingsUtil.getSystemValue(SettingsKeyConstants.EYE_COMFORT_MODE,
      SettingsConstants.EYE_SHIELD_MODE_DEFAULT);
    this.eyeComfortMode = eyeComfortMode;

    const statusOpen: boolean = SettingsConstants.EYE_SHIELD_ENABLE_OPEN_VALUE.includes(eyeComfortMode);
    if (this.mViewData.isOn !== statusOpen) {
      this.mViewData.isOn = statusOpen;
    }
    log.showInfo(`get eyeComfortMode: ${eyeComfortMode} toggle status: ${this.mViewData.isOn}`);
  }

  /**
   * 触发护眼模式图标更新
   */
  private updateEyeComfortIcon(): void {
    let eyeComfortLastMode: string = sSettingsUtil.getSystemValue(SettingsKeyConstants.LAST_EYE_COMFORT_MODE,
      SettingsConstants.EYE_SHIELD_MODE_DEFAULT);
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
    this.setEyeComfortModeLottieData();
    log.showInfo(`get eyeComfortLastMode: ${eyeComfortLastMode}`);
  }


  /**
   * 加载护眼模式状态匹配对应的动效资源
   */
  public setEyeComfortModeLottieData(): void {
    const lottieName: string = this.getLottieName();
    log.showInfo(`matchEyeComfortModeLottieData lottieName ${lottieName}, currentLottieName ${this.currentLottieName}`);
    if (lottieName !== this.currentLottieName) {
      this.currentLottieName = lottieName;
      EyeComportCommonUtil.getInstance().loadLottieData(lottieName, data => {
        this.records.openLottieData = data;
      });
      return;
    }
  }

  public getEyeComfortLottieData(): object | null {
    return this.records.openLottieData;
  }

  public onLastEyeComfortModeChange(): void {
    this.updateEyeComfortIcon();
  }

  public onEyeComfortModeChange(): void {
    this.updateEyeComfortStatus();
  }

  public handleOneClick(): void {
    this.mViewData.isOn = !this.mViewData.isOn;
    let setValueResult: boolean = true;
    // 如果是打开开关需要先确认需要切换到哪个模式
    if (this.mViewData.isOn) {
      log.showInfo(`last mode ${this.mEyeComfortToggleData.eyeComfortLastMode}`);
      // 如果lastMode是默认值表示没有开启过护眼模式，打开全天开启
      if (this.mEyeComfortToggleData.eyeComfortLastMode !== SettingsConstants.EYE_SHIELD_MODE_DEFAULT) {
        setValueResult =
          EyeComportCommonUtil.getInstance().setEyeComfortMode(this.mEyeComfortToggleData.eyeComfortLastMode);
      } else {
        setValueResult =
          EyeComportCommonUtil.getInstance().setEyeComfortMode(SettingsConstants.EYE_SHIELD_MODE_OPEN_ALL_DAY);
      }
    } else {
      setValueResult = EyeComportCommonUtil.getInstance().setEyeComfortMode(SettingsConstants.EYE_SHIELD_MODE_CLOSE);
    }
    // 如果点击失败则返回之前状态
    if (!setValueResult) {
      this.mViewData.isOn = !this.mViewData.isOn;
      return;
    }
  }

  /**
   * 根据护眼模式状态匹配对应的图标资源
   *
   * @returns 图标资源
   */
  public matchEyeComfortModeIcon(): Resource {
    log.showInfo(`matchEyeComfortModeIcon lastMode: ${this.mEyeComfortToggleData.eyeComfortLastMode}`);
    switch (this.mEyeComfortToggleData.eyeComfortLastMode) {
      case SettingsConstants.EYE_SHIELD_MODE_SCHEDULE_CUSTOM:
      case SettingsConstants.EYE_SHIELD_MODE_SCHEDULE_SUNSET:
        return $r('app.media.ic_eye_comfort_schedule');
      case SettingsConstants.EYE_SHIELD_MODE_SCHEDULE_SWING:
        return $r('app.media.ic_eye_comfort_swing');
      default:
        return $r('app.media.ic_eye_comfort_day');
    }
  }

  updateIcon(): void {
    this.mViewData.icon = this.matchEyeComfortModeIcon();
  }

  /**
   * 获取需要播放的lottie name
   *
   * @returns
   */
  private getLottieName(): string {
    switch (this.mEyeComfortToggleData.eyeComfortLastMode) {
      case SettingsConstants.EYE_SHIELD_MODE_OPEN_ALL_DAY:
        return Constants.LOTTIE_DATA_DAY;
      case SettingsConstants.EYE_SHIELD_MODE_SCHEDULE_CUSTOM:
      case SettingsConstants.EYE_SHIELD_MODE_SCHEDULE_SUNSET:
        return Constants.LOTTIE_DATA_SCHEDULE;
      case SettingsConstants.EYE_SHIELD_MODE_SCHEDULE_SWING:
        return Constants.LOTTIE_DATA_SWING;
      default:
        return Constants.LOTTIE_DATA_DAY;
    }
  }

  /**
   * 清除护眼模式Lottie
   */
  public removeAllLottieData(): void {
    this.records = {};
    this.currentLottieName = '';
  }
}