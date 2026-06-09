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

import { CommonStyleManager } from '@ohos/systemuicommon';

const TAG = 'PC-CameraPanel-StyleConfiguration';

export class CameraComponentCommonStyle {
  pcCameraPanelRadius: Length = '8vp';
  pcCameraPanelTitleFontSize = $r('sys.float.ohos_id_text_size_headline8');
  pcCameraPanelTitleTextColor = $r('sys.color.ohos_id_color_text_primary');
  pcCameraPanelTextFontWeight = 'sys.string.ohos_id_text_font_family_medium';
  pcCameraPanelTitleHeight: Length = '56vp';
  pcCameraPanelTitleContainerHeight: Length = '32vp';
  pcCameraPanelTitleContainerWidth: Length = '244vp';
  pcCameraPanelTitleMarginLeft: Length = '24vp';
}

export class CameraComponentContentStyle {
  pcCameraPanelContentContainerWidth: Length = '352vp';
  pcCameraPanelContentHeight: Length = '56vp';
  pcCameraPanelContentContainerHeight: Length = '48vp';
  pcCameraPanelContentContainerRadius: Length = '8vp';
  pcCameraPanelIconWidth: Length = '24vp';
  pcCameraPanelIconHeight: Length = '24vp';
  pcCameraPanelIconMarginLeft: Length = '20vp';
  pcCameraPanelTextColor = $r('sys.color.ohos_id_color_text_primary');
  pcCameraPanelTextFontSize = $r('sys.float.ohos_id_text_size_body2');
  pcCameraPanelTextFontWeight = 'sys.string.ohos_id_text_font_family_medium';
  pcCameraPanelTextMarginLeft: Length = '12vp';
  pcCameraPanelTextContainnerWidth: Length = '208vp';
  pcCameraPanelTextContainnerHeight: Length = '20vp';
}

export default class StyleConfiguration {
  static getCameraComponentCommonStyle(): CameraComponentCommonStyle {
    const key: string = TAG + '-CameraCommonStyle';
    return CommonStyleManager.getStyle(key, CameraComponentCommonStyle);
  }

  static getCameraComponentContentStyle(): CameraComponentContentStyle {
    const key: string = TAG + '-CameraContentStyle';
    return CommonStyleManager.getStyle(key, CameraComponentContentStyle);
  }
}