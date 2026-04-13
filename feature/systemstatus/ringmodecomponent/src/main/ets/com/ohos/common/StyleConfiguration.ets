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

import { CommonStyleManager } from '@ohos/systemuicommon';

const TAG: string = 'capsule-StyleConfiguration';

export class StatusRingModeComponentStyle {
  public statusBarRingModeWidth: Length = $r('app.float.status_bar_ring_mode_width');
  public statusBarRingModeHeight: Length = $r('app.float.status_bar_ring_mode_height');
  public statusBarRingOffWidth: Length = $r('app.float.status_bar_ring_off_width');
}

export class ControlCenterRingModeComponentStyle {
  public onBgColor: ResourceStr = $r('app.color.control_center_complex_toggle_ring_mode_on_bg_color');
  public brightnessIconColor: ResourceStr = '#FFFF9800';
}

export default class StyleConfiguration {
  static getStatusRingModeComponentStyle(): StatusRingModeComponentStyle {
    const key: string = TAG + '-StatusRingMode';
    return CommonStyleManager.getStyle(key, StatusRingModeComponentStyle);
  }

  static getControlCenterRingModeComponentStyle(): ControlCenterRingModeComponentStyle {
    const key: string = TAG + '-ControlCenterRingMode';
    return CommonStyleManager.getStyle(key, ControlCenterRingModeComponentStyle);
  }
}