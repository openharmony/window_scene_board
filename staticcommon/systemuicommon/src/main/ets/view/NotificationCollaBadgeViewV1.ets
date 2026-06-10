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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LengthMetrics } from '@kit.ArkUI';
const TAG = 'NotificationCollaBadgeViewV1';
const log = LogHelper.getLogHelper(LogDomain.NC, TAG);

const BIG_ICON_SIZE = 32;

const COLLA_IMAGE_WIDTH: number = 10;
const COLLA_BADGE_WIDTH = BIG_ICON_SIZE * 0.5;
const COLLA_BADGE_RIGHT_BOTTOM_OFFSET = -4;
const COLLA_BADGE_OVERLAY_RIGHT_BOTTOM_OFFSET = 0;

@Component
export struct NotificationCollaBadgeViewV1 {
  geometryTransitionId: string = '';
  isOverlayIcon: boolean = false;
  build() {
    Stack({ alignContent: Alignment.Center }) {
      Column()
        .width('100%')
        .height('100%')
        .borderRadius('50%')
        .backgroundBlurStyle(BlurStyle.COMPONENT_REGULAR, { inactiveColor: $r('app.color.notification_colla_badge_bg_color') })

      Image($r('app.media.app_icon_phone_fill'))
        .draggable(false)
        .syncLoad(true)
        .autoResize(false)
        .width(COLLA_IMAGE_WIDTH)
        .height(COLLA_IMAGE_WIDTH)
        .objectFit(ImageFit.Contain)
    }
    .id('collaBadge')
    .geometryTransition(this.geometryTransitionId, { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
    .width(COLLA_BADGE_WIDTH)
    .height(COLLA_BADGE_WIDTH)
    .position({
      end: LengthMetrics.vp(this.isOverlayIcon ? COLLA_BADGE_OVERLAY_RIGHT_BOTTOM_OFFSET :
        COLLA_BADGE_RIGHT_BOTTOM_OFFSET),
      bottom: LengthMetrics.vp(this.isOverlayIcon ? COLLA_BADGE_OVERLAY_RIGHT_BOTTOM_OFFSET :
        COLLA_BADGE_RIGHT_BOTTOM_OFFSET),
    })
    .enabled(false)
  }
}