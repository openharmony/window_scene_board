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

import { NotificationBase } from '@ohos/systemuicommon/newTsIndex';
import { NotificationConfig } from '../common/NotificationConfig';
import { NtfAnimationConsts } from '../common/NtfAnimationConsts';
import { NotificationStyle } from '../constants/NotificationStyle';
import { LengthMetrics } from '@kit.ArkUI';

export interface NotificationAppNameViewParam {
  ntf: NotificationBase;
  textFontColor?: ResourceColor;
}

@Builder
export function NotificationAppNameView($$: NotificationAppNameViewParam) {
  Text($$.ntf.appLabel)
    .draggable(false)
    .fontSize($r('app.float.ntf_app_name_font_size'))
    .maxFontScale(NotificationStyle.DEFAULT_MAX_SCALE)
    .fontColor($$.textFontColor ?? $r('app.color.theme_ntf_color_text_primary'))
    .fontWeight(FontWeight.Regular)
    .fontFeature('\"ss08\" on')
    .maxLines(NotificationConfig.LAYOUT_WEIGHT_ONE)
    .textOverflow({ overflow: TextOverflow.Ellipsis })
    .renderGroup(true)
    .margin({ start: LengthMetrics.resource($r('app.float.ntf_header_common_margin')) })
    .transition(TransitionEffect.translate({ y: 5 })
      .animation({
        duration: 333,
        curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE
      }).combine(
        TransitionEffect.OPACITY.animation({
          delay: 50,
          duration: 333,
          curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE
        })
      ))
}