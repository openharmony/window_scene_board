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

import { ControlCenterState } from '@ohos/controlcentercommon/Index';
import lazy Controller from '../controller/ControlCenterController';
import { DesktopMode } from '../viewModel/EmergencyManager';
import { LogHelper, LogDomain, } from '@ohos/basicutils';
import { DesktopModeEnum } from '@ohos/launchercommon/src/main/ets/desktopmode/statemanager/DesktopMode';

const TAG: string = 'Ctrl.ControlCenterVisibilityController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

// 用于控制控制中心各部分的显隐
export default class ControlCenterVisibilityController {

  public static getVisibility(backgroundOpacity: number, emergency: DesktopMode): Visibility {
    if (ControlCenterVisibilityController.isSlidingBrightness(backgroundOpacity)) {
      return Visibility.Hidden;
    } else if (emergency.desktopMode === DesktopModeEnum.EMERGENCY_MODE) {
      return Visibility.Hidden;
    } else {
      // 其他场景的默认显示，并受mainLayout的visibility属性的统一控制
      return Visibility.Visible;
    }
  }

  // 控制头部按钮、隐私指示器显隐
  public static getHeadVisibility(state: ControlCenterState,
    backgroundOpacity: number, emergency: DesktopMode): Visibility {
    if (ControlCenterVisibilityController.isSlidingBrightness(backgroundOpacity)) {
      return Visibility.Hidden;
    } else if (emergency.desktopMode === DesktopModeEnum.EMERGENCY_MODE) {
      return Visibility.Hidden;
    } else if (state !== ControlCenterState.MAIN_LAYOUT) {
      return Visibility.Hidden;
    } else {
      // 其他场景的默认显示，并受mainLayout的visibility属性的统一控制
      return Visibility.Visible;
    }
  }

  /**
   * 控制头部热区显隐-兼容应急模式横滑互切
   *
   * @param state 控制中心页面状态
   * @param backgroundOpacity 背景透明度
   * @returns
   */
  public static getHeadLayoutVisibility(state: ControlCenterState, backgroundOpacity: number): Visibility {
    if (ControlCenterVisibilityController.isSlidingBrightness(backgroundOpacity)) {
      return Visibility.Hidden;
    } else if (state !== ControlCenterState.MAIN_LAYOUT) {
      return Visibility.Hidden;
    }
    // 其他场景的默认显示，并受mainLayout的visibility属性的统一控制
    return Visibility.Visible;
  }

  // 竖屏媒体卡片显隐
  public static getMediaCardVisibility(
    showMediaAboveCardToggles: boolean, backgroundOpacity: number): Visibility {
    log.showInfo('showMediaAboveCardToggles:' + showMediaAboveCardToggles + ', backgroundOpacity:' + backgroundOpacity);
    if (ControlCenterVisibilityController.isSlidingBrightness(backgroundOpacity)) {
      return Visibility.Hidden;
    } else if (!showMediaAboveCardToggles) {
      return Visibility.Hidden;
    } else {
      // 其他场景的默认显示，并受mainLayout的visibility属性的统一控制
      return Visibility.Visible;
    }
  }

  // 控制每行开关显隐
  public static getToggleRowVisibility(backgroundOpacity: number): Visibility {
    if (ControlCenterVisibilityController.isSlidingBrightness(backgroundOpacity)) {
      // 滑动亮度条时隐藏
      return Visibility.Hidden;
    } else {
      // 其他场景的默认显示，并受mainLayout的visibility属性的统一控制
      return Visibility.Visible;
    }
  }

  public static getIOTVisibility(backgroundOpacity: number, emergency: DesktopMode, lockStatus: number): Visibility {
    log.showInfo(`backgroundOpacity:${backgroundOpacity}, lockStatus:${lockStatus}, emergency:${emergency}`);
    if (lockStatus === 1) {
      return Visibility.None;
    }
    if (ControlCenterVisibilityController.isSlidingBrightness(backgroundOpacity)) {
      return Visibility.Hidden;
    } else {
      // 其他场景的默认显示，并受mainLayout的visibility属性的统一控制
      return Visibility.Visible;
    }
  }

  // 竖屏亮度条显影控制
  public static getBrightnessVisibility(showMediaAboveCardToggles: boolean): Visibility {
    return showMediaAboveCardToggles ? Visibility.Visible : Visibility.Hidden;
  }

  private static isSlidingBrightness(backgroundOpacity: number): boolean {
    return Controller.getData().state === ControlCenterState.MAIN_LAYOUT && backgroundOpacity === 0;
  }
}