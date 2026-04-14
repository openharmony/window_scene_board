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

import { INotificationTimeVm, SystemUIColorVm } from '@ohos/systemuicommon/newIndex';

export interface NotificationTimeViewParams {
  timeVm: INotificationTimeVm;
  colorVm: SystemUIColorVm;
  geometryTransitionId?: string;
  visibility?: Visibility;
}

@Builder
export function NotificationTimeView($$: NotificationTimeViewParams) {
  Text($$.timeVm.timeText)
    .draggable(false)
    .fontSize($r('app.float.ntf_app_time_font_size'))
    .maxFontScale(1)
    .fontColor($$.colorVm.timeFontColor)
    .foregroundBrightness($$.colorVm.timeFgBrightness)
    .fontWeight(FontWeight.Regular)
    .maxLines(1)
    .textOverflow({ overflow: TextOverflow.Ellipsis })
    .geometryTransition($$.geometryTransitionId, { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
    .visibility($$.visibility)
}