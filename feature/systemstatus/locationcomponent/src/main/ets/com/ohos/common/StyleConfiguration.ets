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
import { DeviceHelper, SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { SCBConstants } from '@ohos/commonconstants';

const TAG = 'location-StyleConfiguration';

export class StartsBarLocationComponentStyle {
  public statusBarLocationWidth: Length = $r('app.float.status_bar_location_width');
  public statusBarLocationHeight: Length = $r('app.float.status_bar_location_height');
}

class PCStartsBarLocationComponentStyle extends StartsBarLocationComponentStyle {
  public statusBarLocationWidth: Length = $r('app.float.pc_status_bar_location_width');
  public statusBarLocationHeight: Length = $r('app.float.pc_status_bar_location_height');
}

export default class StyleConfiguration {
  static getStartsBarLocationComponentStyle(): StartsBarLocationComponentStyle {
    const key: string = TAG + '-startsBarLocation';
    const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    if (uiType === SCBConstants.UITYPE_PC || DeviceHelper.is2In1DevicePcType()) {
      return CommonStyleManager.getStyle(key, PCStartsBarLocationComponentStyle);
    }
    return CommonStyleManager.getStyle(key, StartsBarLocationComponentStyle);
  }
}