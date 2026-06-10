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
import { StyleConstants } from '@ohos/launchercommon';
import { SmallFoldStyleUtil } from '@ohos/launchercommon/src/main/ets/utils/SmallFoldStyleUtil';
import { editModeGuideManager, GuideReportStatus } from '../EditModeGuideManager'

const TAG: string = 'EditModeGuidePage';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 新形态折叠产品外屏应用入口引导提示页
 */
@Component
export struct EditModeGuidePage {
  private images: ImageFrameInfo[] = [];

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    editModeGuideManager.saveOpenedStatus();
    editModeGuideManager.editModeGuideReport(GuideReportStatus.OPEN);
    this.images = editModeGuideManager.getFlashlightTipsResource();
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    editModeGuideManager.editModeGuideReport(GuideReportStatus.CLOSE);
    this.images = [];
  }

  build() {
    Stack() {
      ImageAnimator()
        .images(this.images)
        .draggable(false)
        .state(AnimationStatus.Running)
        .height(StyleConstants.PERCENTAGE_100)
        .width(StyleConstants.PERCENTAGE_100)
        .accessibilityLevel('no')
        .iterations(-1)

      Text($r('app.string.edit_mode_pinch_gesture_tip'))
        .fontColor($r('sys.color.ohos_id_color_text_primary_contrary'))
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .fontWeight(FontWeight.Medium)
        .textAlign(TextAlign.Center)
        .margin({ left: StyleConstants.DEFAULT_24, right: StyleConstants.DEFAULT_24 })
        .maxFontScale(SmallFoldStyleUtil.LEVEL_BIG_2_FONT_SIZE_SCALE)
        .accessibilityText($r('app.string.edit_mode_pinch_gesture_tip'))
    }
    .height(StyleConstants.PERCENTAGE_100)
    .width(StyleConstants.PERCENTAGE_100)
    .backgroundColor(StyleConstants.APP_NAME_FIRST_SHADOW_COLOR)
  }
}