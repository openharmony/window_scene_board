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

import CommonStyleManager from '../manager/CommonStyleManager';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { StatusBarType } from '../plugin/info/StatusBarType';

const TAG = 'Common-StyleConfiguration';
const deviceTypeInfo = DeviceHelper.DEVICE_TYPE;

export class CommonStyle {
  public statusBarFontSize: Length = $r('app.float.status_bar_font_size');
  public statusBarIconWidth: Length = $r('app.float.status_bar_icon_width');
  public statusBarIconHeight: Length = $r('app.float.status_bar_icon_height');
  public statusBarMarginLeftRight: Length = $r('app.float.status_bar_margin_left_right');
  public statusBarIconColor: ResourceColor = $r('sys.color.ohos_id_color_primary');
  public deviceTypeInfo = deviceTypeInfo;

  constructor() {
    if (DeviceHelper.isHAD()) {
      this.statusBarFontSize = $r('app.float.had_status_bar_font_size');
    }
    if (StatusBarType.isWindowStyle(AppStorage.get('statusBarType') as number)) {
      this.statusBarFontSize = $r('app.float.window_status_bar_font_size');
    }
  }
}

export class StatusBarBackgroundStyle {
  public backgroundHeight: Length = '22vp';
  public backgroundWidth: Length = '22vp';
  public backgroundRadius: Length = '11vp';
  public backgroundColor: ResourceColor = '#66FFFFFF';
  public iconBgColorSelected: ResourceColor = '#19000000';
  public iconBgColorUnSelected: ResourceColor = '#00000000';
  public iconBgColorHovered: ResourceColor = '#0C000000';
}

export default class StyleConfiguration {
  static getCommonStyle(): CommonStyle {
    const key: string = TAG + '-Common';
    return CommonStyleManager.getStyle(key, CommonStyle);
  }

  static getStatusBarIconBackgroundStyle(): StatusBarBackgroundStyle {
    const key: string = TAG + '-StatusBarIconBackground';
    return CommonStyleManager.getStyle(key, StatusBarBackgroundStyle);
  }
}