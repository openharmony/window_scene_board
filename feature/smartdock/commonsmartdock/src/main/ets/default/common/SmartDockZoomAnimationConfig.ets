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

import { curves } from '@kit.ArkUI';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SmartDockZoomFeatureSwitch } from '@ohos/launchercommon';

const TAG = 'SmartDock_M_SmartDockZoomAnimationConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);


export class SmartDockZoomAnimationConfig {
  /* 曲线类型 */
  private static curve: curves.ICurve = curves.cubicBezierCurve(0.4, 0, 0.4, 1);
  /* 曲线时长 */
  private static duration: number = 400;
  /* 是否首次加载 */
  public static initialed: boolean = false;
  static {
    SmartDockZoomAnimationConfig.initial();
  }

  /**
   * 加载配置，只加载首次
   */
  public static initial(): void {
    if (!SmartDockZoomAnimationConfig.initialed || SmartDockZoomFeatureSwitch.isDebugMode()) {
      SmartDockZoomAnimationConfig.loadConfig();
      SmartDockZoomAnimationConfig.initialed = true;
      log.showInfo('initial dock zoom config, duration: %{public}d',
        SmartDockZoomAnimationConfig.duration);
    }
  }

  /**
   * 获取动效曲线
   */
  public static getAnimationCurve(): Curve | ICurve {
    if (!SmartDockZoomAnimationConfig.curve) {
      log.showWarn('zoom animation curve is undefined');
      return Curve.Linear;
    }
    return SmartDockZoomAnimationConfig.curve;
  }

  /**
   * 获取动效长度，弹簧曲线不生效
   */
  public static getAnimationDuration(): number {
    return SmartDockZoomAnimationConfig.duration;
  }


  private static loadConfig(): void {
    if (SmartDockZoomFeatureSwitch.isSupportZoom()) {
      SmartDockZoomAnimationConfig.curve = curves.interpolatingSpring(0, 1, 260, 28);
    }
  }
}