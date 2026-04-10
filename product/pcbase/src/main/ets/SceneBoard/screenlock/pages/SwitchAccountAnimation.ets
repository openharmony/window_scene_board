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

import settings from '@ohos.settings';
import { systemDateTime } from '@kit.BasicServicesKit';
import { LogDomain, LogHelper, } from '@ohos/basicutils';
import { MultiSpace } from '../../../common/EnterpriseMultiSpaceController';

const TAG = 'SwitchAccoutAnimation';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class SwitchAccountAnimationParameter {
  public static readonly dynamicEffectRatio: number = 0.9;
  public static readonly delay: number = 0;
  public static readonly statusBarOpacityBegin: number = 0;
  public static readonly statusBarScaleBegin: number = 0.8;
  public static readonly statusBarTranslateBegin: string = '125vp';
  public static readonly statusBarOpacityEnd: number = 1;
  public static readonly statusBarScaleEnd: number = 1
  public static readonly statusBarTranslateEnd: string = '0';
  public static readonly statusTime: number = (this.delay + 600) * this.dynamicEffectRatio;
  public static readonly userTranslateBegin: string = '-308vp';
  public static readonly userTranslateEnd: string = '0';
  public static readonly userTime: number = (this.delay + 300) * this.dynamicEffectRatio;
  public static readonly timeViewScaleBegin: number = 0.8;
  public static readonly timeViewOpacityBegin: number = 0;
  public static readonly timeViewTranslateBegin: string = '72vp';
  public static readonly timeViewScaleEnd: number = 1;
  public static readonly timeViewOpacityEnd: number = 100;
  public static readonly timeViewTranslateEnd: string = '0';
  public static readonly timeViewTime: number = (this.delay + 550) * this.dynamicEffectRatio;
  public static readonly userItemViewOpacityBegin: number = 0;
  public static readonly userImageOpacityBegin: number = 0;
  public static readonly userImagescaleBegin: number = 1.2;
  public static readonly passwordViewOpacityBegin: number = 0;
  public static readonly userImageOpacityEnd: number = 1;
  public static readonly userItemViewOpacityEnd: number = 1;
  public static readonly userImagescaleEnd: number = 1;
  public static readonly passwordViewOpacityEnd: number = 1;
  public static readonly userItemTime: number = this.delay + 200;
  public static readonly spaceSwitchScaleBegin: ScaleOptions = { x: 0.8, y: 0.8 };
  public static readonly spaceSwitchOpacityBegin: number = 50;
  public static readonly spaceSwitchRadiusBegin: number = 25;
  public static readonly spaceSwitchShadowRadiusBegin: number = 50;
  public static readonly spaceSwitchScaleEnd: ScaleOptions = { x: 1, y: 1 };
  public static readonly spaceSwitchOpacityEnd: number = 50;
  public static readonly spaceSwitchRadiusEnd: number = 25;
  public static readonly spaceSwitchShadowRadiusEnd: number = 25;
  public static readonly spaceSwitchIconOpacityEnd: number = 0;
  public static readonly spaceLoadOpacityEnd: number = 1;
  public static readonly spaceLoadOpacityBegin: number = 0;
  public static readonly spaceSwitchIconOpacityBegin: number = 1;
  public static readonly spaceSwitchIconScaleBegin: ScaleOptions = { x: 0.8, y: 0.8 };
  public static readonly spaceSwitchSpaceLoadTxtOpacityBegin: number = 1;
  public static readonly spaceSwitchSpaceLoadTxtOpacityEnd: number = 0;
  public static readonly spaceSwitchSpaceBackgroundBlurEnd: number = 0;
  public static readonly spaceSwitchBorderWidthEnd: number = 0;
  public static readonly spaceSwitchLoadBlueEnd: number = 0;
  public static readonly spaceSwitchBackRadiusEnd: number = 0;
  public static readonly spaceSwitchBackShadowRadiusEnd: number = 0;
  public static readonly spaceSwitchScaleTime: number = this.delay * this.dynamicEffectRatio;
  public static readonly spaceSwitchRadiusTime: number = (this.delay + 400) * this.dynamicEffectRatio;
  public static readonly doubleStarOpacityBegin: number = 1;
  public static readonly doubleStarOpacityEnd: number = 0;
  public static readonly closeAnimation: number = 1500;
  public static readonly passwordViewTime: number = 500 * this.dynamicEffectRatio;
  public static readonly spaceBackgroundBlurBegin: number = 50;
}

const SWITCH_ID_INIT_VIAL: string = '0';
// 设置开启动效的有效期为3秒
const ANIMATION_OPEN_PERIOD: number = 5000;

export class SwitchAccountAnimationMethod {
  // 冷启动有2个场景需要读有效期
  private static enableCheckCnt: number = 1;
  static enableEnterpriseSpace(): boolean {
    return MultiSpace.get().checkSpaceEnable();
  }

  static enableAnimation(): boolean {
    if (!MultiSpace.get().checkSpaceEnable()) {
      return false;
    }
    if (SwitchAccountAnimationMethod.enableCheckCnt > 0) {
      SwitchAccountAnimationMethod.enableCheckCnt --;
    }

    const context: Context = getContext();
    const animationStatus: string = settings.getValueSync(context, 'screenAnimationStatus', SWITCH_ID_INIT_VIAL);
    if (SwitchAccountAnimationMethod.enableCheckCnt <= 0) {
      // 读完状态值后，清空置零
      settings.setValue(context, 'screenAnimationStatus', SWITCH_ID_INIT_VIAL, settings.domainName.DEVICE_SHARED);
    }
    let currentTime: number = systemDateTime.getUptime(systemDateTime.TimeType.ACTIVE, false);
    log.showInfo(`currentTime:${currentTime} ,Deposit time:${animationStatus}`);
    return (currentTime - Number(animationStatus)) < ANIMATION_OPEN_PERIOD;
  }
}