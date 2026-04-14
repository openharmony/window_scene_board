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
import image from '@ohos.multimedia.image';
import { AnimationItem } from '@ohos/lottie';
import { util } from '@kit.ArkTS';
import { common } from '@kit.AbilityKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import lottie from '@ohos/lottie';

const TAG = 'LiveCardWalletStatusInfoVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ObservedV2
export class ImageInfo {
  @Trace public X: number = 0;
  @Trace public Y: number = 9;
  @Trace public Z: number = -2;
  @Trace public cardimagePixelMap: image.PixelMap | undefined = undefined;
  @Trace public updateCardimagePixelMap: image.PixelMap | undefined = undefined;
  @Trace public angle: number = 45;
  @Trace public translateX: number = 0;
  @Trace public translateY: number | string = -12;
  @Trace public translateZ: number | string = 0;
  @Trace public scalaX: number = 0;
  @Trace public scalaY: number = 0;
  @Trace public sweepPositionX: number = -30;
  @Trace public sweepPositionY: number = -10;
  @Trace public imageUpdateCardOpacity: number = 0;
  @Trace public defaultCardOpacity: number = 1;
  public nextInstruction: number = -1;
  public istriggerpopup: boolean = false
  public swipeCardSurfaceUpdate = false

  public CleanStatus() {
    this.X = 0;
    this.Y = 9;
    this.Z = -2;
    this.cardimagePixelMap = undefined
    this.updateCardimagePixelMap = undefined
    this.angle = 45;
    this.translateX = 0;
    this.translateY = -12;
    this.translateZ = 0;
    this.scalaX = 0;
    this.scalaY = 0;
    this.sweepPositionX = -30;
    this.sweepPositionY = -10;
    this.imageUpdateCardOpacity = 0;
    this.defaultCardOpacity = 1;
    this.nextInstruction = -1;
    this.istriggerpopup = false;
    this.swipeCardSurfaceUpdate = false;
  }
}

@ObservedV2
export class TextInfo {
  @Trace public textOpacity: number = 0;
  @Trace public textMainTitle: string = '-';
  @Trace public textSubTitle: string = '-';
  @Trace public textTranslateX: number = 0;
  @Trace public textTranslateY: number | string = 0;
  @Trace public textTranslateZ: number | string = 0;

  public CleanStatus() {
    this.textOpacity = 0;
    this.textMainTitle = '-';
    this.textSubTitle = '-';
    this.textTranslateX = 0;
    this.textTranslateY = 0;
    this.textTranslateZ = 0;
  }
}

@ObservedV2
export class RadioInfo {
  @Trace public radioOpacity: number = 0;
  @Trace public controller: CanvasRenderingContext2D = new CanvasRenderingContext2D();
  public animateNameAppear: string = 'animateAppear';
  public animateNameDisAppear: string = 'animateDisAppear';
  public animatePathAppear: string = 'common/animation/appear.json';
  public animatePathDisAppear: string = 'common/animation/disappear.json';
  @Trace public cardImageFailPixelMap: image.PixelMap | undefined = undefined;
  @Trace public animateItemAppear: AnimationItem | null = null;
  @Trace public animateItemAppearDisAppear: AnimationItem | null = null;
  @Trace public isSwipeFailureIcon: boolean = false;
  @Trace public radioTranslateX: number = 0;
  @Trace public radioTranslateY: number | string = 0;
  @Trace public radioTranslateZ: number | string = 0;
  @Trace public radioscalaX: number = 0;
  @Trace public radioscalaY: number = 0;

  public CleanStatus() {
    this.radioOpacity = 0;
    this.controller = new CanvasRenderingContext2D();
    this.animateItemAppear = null;
    this.animateItemAppearDisAppear = null;
    this.isSwipeFailureIcon = false;
    this.radioTranslateX = 0;
    this.radioTranslateY = 0;
    this.radioTranslateZ = 0;
    this.radioscalaX = 0;
    this.radioscalaY = 0;
  }

  public geLottieData(jsonName: string, callback: (value: object) => void): void {
    let resStr = util.TextDecoder.create('utf-8', { ignoreBOM: true });
    try {
      let context = getContext(this) as common.UIAbilityContext;
      let data = context?.resourceManager.getRawFileContentSync(jsonName);
      let lottieStr = resStr.decodeToString(new Uint8Array(data));
      let lottieData: object | null = JSON.parse(lottieStr);
      log.showWarn(`loadLottieData, lottieData: ${jsonName} ${lottieData}`);
      if (callback && lottieData !== null) {
        callback(lottieData);
      }
    } catch (err) {
      log.showError(`geLottieData error ${err}`);
    }
  }

  public destroyLottie(): void {
    lottie.destroy(this.animateNameAppear);
    lottie.destroy(this.animateNameDisAppear);
  }
}

@ObservedV2
export class OverlayBoxInfo {
  @Trace public borderRadius: number = 16;
  @Trace public translateY: number = -41;
  @Trace public width: number = 0;
  @Trace public height: number = 0;
  @Trace public scaleX: number = 1;
  @Trace public scaleY: number = 1;
  @Trace public backGroundColor: boolean = false;
  @Trace public opacity: number = 1

  public cleanStatus() {
    this.borderRadius = 16;
    this.translateY = -41;
    this.width = 0;
    this.height = 0;
    this.scaleX = 1;
    this.scaleY = 1;
    this.opacity = 1;
    this.backGroundColor = false;
  }
}

@ObservedV2
export class NoAnchorPointOverallPageLayOutInfo {
  @Trace public pageLayOutAlignment: boolean = false
  @Trace public pageLayOutOffsetX: number = 12
  @Trace public pageLayOutIsHaveHole: boolean = true

  public cleanStatus() {
    this.pageLayOutAlignment = false
    this.pageLayOutOffsetX = 12
    this.pageLayOutIsHaveHole = true
  }
}

