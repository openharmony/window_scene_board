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

export class NotificationPinTopVm {
  public fontColor?: ResourceColor;
  public foregroundBrightness?: BrightnessOptions;
  public geometryTransitionId?: string;
}

@Builder
export function NotificationPinTopView($$: NotificationPinTopVm) {
  Text($r('app.string.topped_notification_flag'))
    .draggable(false)
    .border({
      width: $r('app.float.ntf_pin_top_flag_border_width'),
      color: $$.fontColor,
      radius: $r('app.float.ntf_pin_top_flag_border_radius'),
      style: BorderStyle.Solid
    })
    .padding({
      top: $r('app.float.ntf_pin_top_flag_padding_vertical'),
      bottom: $r('app.float.ntf_pin_top_flag_padding_vertical'),
      left: $r('app.float.ntf_pin_top_flag_padding_horizontal'),
      right: $r('app.float.ntf_pin_top_flag_padding_horizontal')
    })
    .fontSize($r('app.float.ntf_pin_top_flag_font_size'))
    .fontWeight(FontWeight.Medium)
    .fontColor($$.fontColor)
    .foregroundBrightness($$.foregroundBrightness)
    .renderGroup(true)
    .margin({ end: LengthMetrics.resource($r('app.float.ntf_item_date_time_margin')) })
    .geometryTransition($$.geometryTransitionId, { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
}