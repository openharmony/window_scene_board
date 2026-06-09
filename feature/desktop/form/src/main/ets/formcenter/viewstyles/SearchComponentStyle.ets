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

import { LengthMetrics } from '@kit.ArkUI';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { launcherStatusUtil } from '@ohos/windowscene';

export class SearchComponentStyle {
  // common
  public fontSize: Length = 16;

  // search
  public searchMargin?: Margin | Length | LocalizedMargin = {
    start: LengthMetrics.vp(16),
    end: LengthMetrics.vp(16),
    top: LengthMetrics.vp(8),

  };
  public searchRadius?: Length | BorderRadiuses | LocalizedBorderRadiuses = $r('sys.float.corner_radius_level12');
  public searchFontColor?: ResourceColor = $r('sys.color.font_primary');
  public searchBgrColor?: ResourceColor = $r('sys.color.comp_background_tertiary');
  public searchDefaultFocus?: boolean = false;
  public visibility: Visibility = Visibility.Visible;
}