/**
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

import { RecentsStyleConstants } from '@ohos/windowscene';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { RecentAccessibilityUtils } from './scenepanel/recentpanel/RecentAccessibilityUtils';

const TAG = 'RecentEmptyView';
/**
 * Page prompt, when there is no recent task.
 */
@Component
export struct RecentEmptyView {
  private outerScaleSize: number = 1;

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
         Text($r('app.string.No_running_apps_recently')).draggable(false)
           .id(`${TAG}_text_noRecents`)
           .fontColor(RecentsStyleConstants.DEFAULT_FONT_COLOR)
           .fontSize(RecentsStyleConstants.RECENT_EMPTY_FONT_SIZE)

    }
    .onAppear(() => {
      RecentAccessibilityUtils.requestFocusForAccessibility(`RecentEmptyView`, TAG);
    })
    .width(RecentsStyleConstants.DEFAULT_LAYOUT_PERCENTAGE)
    .height(RecentsStyleConstants.DEFAULT_LAYOUT_PERCENTAGE)
  }
}