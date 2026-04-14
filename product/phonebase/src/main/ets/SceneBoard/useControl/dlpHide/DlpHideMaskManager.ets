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

import { DomainName, TraceUtil, LogDomain, LogHelper } from '@ohos/basicutils';
import { ControlType, SCBAppUseControlManager, ResUtils } from '@ohos/windowscene';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import lottie, { AnimationItem } from '@ohos/lottie';
import { util } from '@kit.ArkTS';
import common from '@ohos.app.ability.common';

const PHONE_MARGIN = '16vp';
const SUBTITLE_TOP_MARGIN = '12vp';
const DLP_MASK_DELAY = 300;
const DLP_WHITE_BOARD_EXIT_DURATION = 300;
const TAG = 'SCBDesktop';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
let renderingSettings: RenderingContextSettings = new RenderingContextSettings(true);
let canvasRenderingContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(renderingSettings);
const STAR_SHIELD_SIZE: string = '72vp';
const RETRY_SUBTITLE_TOP_MARGIN: string = '4.5vp';

export function registerDlpHideMaskParam() {
  SCBAppUseControlManager.getInstance().registerComponentBuilderParam(ControlType.DLP, {
    loadBundleName: 'com.ohos.dlpcredmgr',
    loadAbilityName: 'PeepMaskLayerAbility',
    useControlMainMaskBuilder: mainMaskBuilder,
    useControlRecentMaskBuilder: recentMaskBuilder,
    isNeedShowUseControlComponent: undefined
  });
}

@Builder
export function recentMaskBuilder() {
  DlpHideRecentMaskComponent()
}

@Builder
export function mainMaskBuilder() {
  DlpHideMainMaskComponent()
}

@Component
struct DlpHideRecentMaskComponent {
  build() {
    Stack() {
      Column() {
      }
      .backgroundEffect({
        radius: ResUtils.getNumber($r('app.float.dlp_mask_blur_radius'))
      }, { disableSystemAdaptation: true })
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)

      Column() {
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.dlp_mask_color'))

      Column() {
        Image($r('app.media.star_shield'))
          .width(STAR_SHIELD_SIZE)
          .height(STAR_SHIELD_SIZE)
          .draggable(false)
          .interpolation(ImageInterpolation.Medium)
        Text($r('app.string.privacy_protection'))
          .textAlign(TextAlign.Center)
          .fontFamily('HarmonyHeiTi')
          .fontWeight(FontWeight.Regular)
          .fontSize($r('sys.float.Body_L'))
          .fontColor($r('app.color.dlp_mask_reminder_text_color'))
          .margin({ top: SUBTITLE_TOP_MARGIN })

        Text($r('app.string.remove_protection'))
          .textAlign(TextAlign.Center)
          .fontFamily('HarmonyHeiTi')
          .fontWeight(FontWeight.Medium)
          .fontSize($r('sys.float.Body_L'))
          .fontColor($r('sys.color.font_emphasize'))
          .margin({ top: RETRY_SUBTITLE_TOP_MARGIN })
      }
      .margin({
        left: PHONE_MARGIN,
        right: PHONE_MARGIN
      })
    }
    .width('100%')
    .height('100%')
  }
}

@Component
struct DlpHideMainMaskComponent {
  @State isMainMaskShowed: boolean = false;
  private timerId: number = -1;

  aboutToAppear(): void {
    this.isMainMaskShowed = false;
    this.timerId = setTimeout(() => {
      this.isMainMaskShowed = true;
      clearTimeout(this.timerId);
    }, DLP_MASK_DELAY);
  }

  aboutToDisappear(): void {
    clearTimeout(this.timerId);
  }

  build() {
    Stack() {
      if (this.isMainMaskShowed) {
        Column() {
        }
        .backgroundEffect({
          radius: ResUtils.getNumber($r('app.float.dlp_mask_blur_radius'))
        }, { disableSystemAdaptation: true })
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      } else {
        Column() {
        }
        .transition(
          TransitionEffect.asymmetric(
            TransitionEffect.IDENTITY,
            TransitionEffect.OPACITY.animation({ duration: DLP_WHITE_BOARD_EXIT_DURATION })
          )
        )
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .backgroundColor($r('app.color.dlp_white_board_background'))
        .width('100%')
        .height('100%')
      }

      Column() {
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.dlp_mask_color'))
    }
  }
}