/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
import { GlobalContext } from '@ohos/frameworkwrapper';
import { FormStackAnimateItem } from '../viewmodel/FormStackAnimateItem';
import { formStackSnapShowManager } from '../common/FormStackSnapShowManager';
import { FormStackUtil } from '../common/FormStackUtil';

const TAG: string = 'FormStackMaskView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

@Component
export struct SecondFormMask {
  private readonly mFixedOffsetY: number = 0;

  @ObjectLink maskItem: FormStackAnimateItem;
  @Link mFormStackItemWidth: number;
  @Link mFormStackItemHeight: number;
  @Prop mStaticMaskExtraWidth: number;
  @StorageLink('currColorMode') currColorMode: number = GlobalContext.getContext()?.config?.colorMode as number ?? 0;
  private mIsOuterDesktop: boolean = false;

  private buildLog(): boolean {
    log.showDebug('build form mask: id=%{public}s, opacity=%{public}d, scaleX=%{public}d, scaleY=%{public}d,' +
      'zIndex=%{public}d, visible=%{public}s, rotate=%{public}d', this.maskItem.idStr, this.maskItem.mOpacity,
      this.maskItem.mScaleX, this.maskItem.mScaleY, this.maskItem.zIndex, this.maskItem.mVisible,
      this.maskItem.mRotateAngle);
    return true;
  }


  @Styles
  commonStyle() {
    .width(this.mFormStackItemWidth + (this.mIsOuterDesktop ? this.mStaticMaskExtraWidth : 0))
    .height(this.mFormStackItemHeight)
    .offset({ x: 0, y: this.maskItem.mIsOffsetY ? this.mFixedOffsetY : 0 })
    .borderRadius(this.maskItem.mBorderRadius)
    .opacity(this.maskItem.mOpacity)
    .scale({
      x: this.maskItem.mScaleX,
      y: this.maskItem.mScaleY,
      centerX: '50%',
      centerY: '0%'
    })
    .translate({ x: 0, y: this.maskItem.mTranslateY })
    .rotate({
      x: 1,
      angle: this.maskItem.mRotateAngle,
      centerX: '50%',
      centerY: '0%'
    })
    .visibility(this.maskItem.mVisible ? Visibility.Visible : Visibility.Hidden)
    .zIndex(this.maskItem.zIndex)
  }

  @Styles
  innerStyle() {
    .width('100%')
    .height('100%')
    .borderRadius(this.maskItem.mBorderRadius)
  }

  build() {
    if (this.maskItem.snapshot) { // 需要带着截图做动效
      Stack() {
        if (this.buildLog()) {
        }
        Image(this.maskItem.snapshot)
          .innerStyle()
        Column()
          .innerStyle()
          .backgroundColor(this.currColorMode === 0 ? '#e67e7f80' : '#FFD7D8D9')
      }.commonStyle()
    } else {
      Column() {
        if (this.buildLog()) {
        }
      }
      .commonStyle()
      .backgroundColor(this.currColorMode === 0 ? '#e67e7f80' : '#FFD7D8D9')
    }
  }
}

@Component
export struct FormStackBackboard {
  private readonly mFormBorderRadius: number = 0;

  @Link mFormStackItemWidth: number;
  @Link mFormStackItemHeight: number;
  @Link mFormBackboardScale: number;
  @Link mFormBackboardRadiusOffset: number;
  @Link mFormBackboardOffset: number;

  build() {
    Column() {
    }
    .width(this.mFormStackItemWidth)
    .height(this.mFormStackItemHeight)
    .borderRadius(this.mFormBorderRadius + this.mFormBackboardRadiusOffset)
    .backgroundBlurStyle(BlurStyle.Thin, { policy: 1 }, { disableSystemAdaptation: true })
    .translate({ y: -this.mFormBackboardOffset })
    .scale({ x: this.mFormBackboardScale, y: this.mFormBackboardScale })
    .id(`${TAG}_Column_backboard`)
  }
}

@Component
export struct FormStackMask {
  private mFormStackItemWidth: number = 0;
  private mFormStackItemHeight: number = 0;
  private readonly mFormBorderRadius: number = 0;
  private mZIndex: number = 0;

  @Link mFormStackMaskOpacity: number;
  @Link mFormStackScale: number;
  @Link mFormStackOffset: number;
  @StorageLink('currColorMode') currColorMode: number = GlobalContext.getContext()?.config?.colorMode as number ?? 0;

  build() {
    Column() {
    }
    .width(this.mFormStackItemWidth)
    .height(this.mFormStackItemHeight)
    .borderRadius(this.mFormBorderRadius)
    .id(`${TAG}_Column_formstackMask`)
    .backgroundColor(this.currColorMode === 0 ? '#e67e7f80' : '#FFD7D8D9')
    .opacity(this.mFormStackMaskOpacity)
    .scale({
      x: this.mFormStackScale,
      y: this.mFormStackScale,
      centerX: '50%',
      centerY: '0'
    })
    .translate({ y: this.mFormStackOffset })
    .zIndex(this.mZIndex)
  }
}

@Component
export struct FormStackCoverImage {
  private mFormStackItemWidth: number = 0;
  private mFormStackItemHeight: number = 0;
  private readonly mFormBorderRadius: number = 0;
  private mZIndex: number = 0;

  private buildLog(): boolean {
    if (!FormStackUtil.isValidImage(formStackSnapShowManager.coverImagePixel)) {
      log.showError('formstack cover image invalid, can not build view!');
      return false;
    }

    log.showWarn('build formstack cover image.');
    return true;
  }

  build() {
    if (this.buildLog()) {
      Image(formStackSnapShowManager.coverImagePixel)
        .draggable(false)
        .objectFit(ImageFit.Fill)
        .autoResize(false)
        .syncLoad(true)
        .interpolation(ImageInterpolation.Medium)
        .width(this.mFormStackItemWidth)
        .height(this.mFormStackItemHeight)
        .borderRadius(this.mFormBorderRadius)
        .zIndex(this.mZIndex)
    }
  }
}