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

import { Rect } from '../../../scene/common/GlassSceneManager';
import ScreenShotManager from '../../manager/ScreenshotManager';
import { ScreenFunctionConstants } from '../constants/ScreenFunctionConstants';
import { calculateSize } from '../constants/WifiConstants';
import { GlassShowToastOptions, GlassToastManager } from '../../../toast/manager/GlassToastManager';
import { display } from '@kit.ArkUI';
import { GlassSystemSceneType, GlassSystemSceneManager } from '../../../scene/common/GlassSystemSceneManager';
import { VisionGlassResourceManager } from '../../../IdlVisionGlassExtService/VisionGlassResourceManager';

const rect: Rect = {
  left: 106,
  top: 767,
  width: 405,
  height: 239
};

@Component
export default struct ScreenShotComponent {
  @State isScreenRecording: boolean = false;
  @Consume windowSize: SizeOptions;
  @Consume screenId: number;

  private onClose(): void {
    GlassSystemSceneManager.getInstance().hideSystemView(GlassSystemSceneType.GLASS_CONTROL);
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.glass_ic_screenshot'))
          .width(calculateSize(this.windowSize.height as number, ScreenFunctionConstants.CAPSULE_ICON_SIZE_SCALE))
          .height(calculateSize(this.windowSize.height as number, ScreenFunctionConstants.CAPSULE_ICON_SIZE_SCALE))
      }
      .onClick(async () => {
        this.onClose();
        let isGlassCanSaveImage: boolean = await ScreenShotManager.getInstance().checkIsGlassCanSaveImage();
        if (!isGlassCanSaveImage) {
          let options: GlassShowToastOptions = {
            message: ScreenFunctionConstants.NO_PERMISSION_GRANTED_MSG,
            bottom: ScreenFunctionConstants.TOAST_BOTTOM,
            duration: ScreenFunctionConstants.TOAST_DURATION,
            width: ScreenFunctionConstants.NO_PERMISSION_GRANTED_WID
          }
          GlassToastManager.getInstance().showToast(options);
          VisionGlassResourceManager.getInstance().showRightDialogOnPhone();
          return;
        }
        let isPrivacyScreen: boolean = display.hasPrivateWindow(this.screenId);
        if (isPrivacyScreen) {
          let options: GlassShowToastOptions = {
            message: ScreenFunctionConstants.PRIVACY_SCREEN_MSG,
            bottom: ScreenFunctionConstants.TOAST_BOTTOM,
            duration: ScreenFunctionConstants.TOAST_DURATION,
            width: ScreenFunctionConstants.PRIVACY_SCREE_MSG_WID
          }
          GlassToastManager.getInstance().showToast(options);
          return;
        }
        ScreenShotManager.getInstance().showWindow(rect);
      })
      .backgroundColor(ScreenFunctionConstants.BUTTON_BACKGROUND_COLOR)
      .borderRadius(ScreenFunctionConstants.FULL_SIZE)
      .width(calculateSize(this.windowSize.height as number, ScreenFunctionConstants.CAPSULE_HEIGHT_SCALE))
      .height(calculateSize(this.windowSize.height as number, ScreenFunctionConstants.CAPSULE_HEIGHT_SCALE))
      .justifyContent(FlexAlign.Center)

      Row()
        .size({
          width: calculateSize(this.windowSize.height as number, ScreenFunctionConstants.CAPSULE_HEIGHT_SCALE),
          height: calculateSize(this.windowSize.height as number, ScreenFunctionConstants.CIRCLE_NAME_TOP_MARGIN)
        })

      Text($r('app.string.ScreenShot_label'))
        .fontColor(Color.White)
        .fontSize(ScreenFunctionConstants.FONT_SIZE)
        .fontWeight(ScreenFunctionConstants.FONT_WEIGHT)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .textAlign(TextAlign.Center)
        .opacity(0.5)
    }
    .width(calculateSize(this.windowSize.height as number, ScreenFunctionConstants.CAPSULE_HEIGHT_SCALE))
    .alignItems(HorizontalAlign.Center)
  }
}