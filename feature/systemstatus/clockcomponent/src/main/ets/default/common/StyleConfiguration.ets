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
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { StatusBarType } from '@ohos/systemuicommon/Index';

import { CommonStyleManager } from '@ohos/systemuicommon';

const TAG = 'clock-StyleConfiguration';

export class ClockComponentStyle {
  public statusBarWeekMaxWidth: Length = $r('app.float.status_bar_week_width');
  public statusBarClockMarginLeftRight: Length = $r('app.float.status_bar_clock_margin_left_right');
  public statusBarClockLineHeight: Length = $r('app.float.status_bar_clock_line_height');
  public statusBarClockPaddingLeftRight: Length = $r('app.float.clock_icon_container_padding_window');
  public statusBarBellIconPaddingLeftRight: Resource = $r('app.float.bell_icon_padding_left_right');

  constructor() {
    if (DeviceHelper.isHAD()) {
      this.statusBarClockMarginLeftRight = $r('app.float.had_status_bar_clock_margin_left_right');
      this.statusBarClockLineHeight = $r('app.float.had_status_bar_clock_line_height');
    }
    if (StatusBarType.isWindowStyle(AppStorage.get('statusBarType') as number)) {
      this.statusBarClockLineHeight = $r('app.float.window_status_bar_clock_line_height');
      this.statusBarClockMarginLeftRight = $r('app.float.window_status_bar_clock_margin_left_right');
    }
  }
}

export default class StyleConfiguration {
  static getClockComponentStyle(): ClockComponentStyle {
    const key: string = TAG + '-ClockComponent';
    return CommonStyleManager.getStyle(key, ClockComponentStyle);
  }
}