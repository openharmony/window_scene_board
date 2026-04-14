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
import { DeviceHelper } from '@ohos/frameworkwrapper';

import { CommonStyleManager } from '@ohos/systemuicommon';

const TAG = 'camera-StyleConfiguration';

export class StartsBarCameraComponentStyle {
  public statusBarCameraWidth: Length = $r('app.float.status_bar_camera_width');
  public statusBarCameraHeight: Length = $r('app.float.status_bar_camera_height');

  constructor() {
    if (DeviceHelper.isHAD()) {
      this.statusBarCameraWidth = $r('app.float.had_status_bar_camera_width');
      this.statusBarCameraHeight = $r('app.float.had_status_bar_camera_height');
    }
  }
}

export default class StyleConfiguration {
  static getStartsBarCameraComponentStyle(): StartsBarCameraComponentStyle {
    const key: string = TAG + '-startsBarCamera';
    return CommonStyleManager.getStyle(key, StartsBarCameraComponentStyle);
  }
}