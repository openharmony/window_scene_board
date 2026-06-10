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
import { LiveCardProgressModel } from '../model/LiveCardProgressModel'
import { LiveIndicatorType, LiveLineType } from '../model/LiveCommonModel';
import { LiveNotification } from '../model/LiveNotification';
import { LengthMetrics } from '@kit.ArkUI';
import { ILiveCardOtherProgressVm } from '../interface/ILiveCardOtherProgressVm';
import { LiveVmInjector } from '../LiveVmInjector';
import { image } from '@kit.ImageKit';
import { ResourceVm } from '../../vm/ResourceVm';

const DOTTED_LINE_SIZE = 4;
const LINE_PADDING = 8;
const INDICATOR_UP_IMAGE_WIDTH = 36;
const INDICATOR_OVERLAY_IMAGE_WIDTH = 64;
const INDICATOR_OVERLAY_IMAGE_HEIGHT = 56;


@ComponentV2
export struct LiveCardOtherProgressView {
  @Consumer() liveVmInjector: LiveVmInjector = LiveVmInjector.HOLDER;
  @Param @Require live: LiveNotification;

  @Computed get data(): LiveCardProgressModel {
    return this.live.card as LiveCardProgressModel;
  }
  @Computed get otherProgressVm(): ILiveCardOtherProgressVm {
    return this.liveVmInjector.getCardOtherProgressVm(this.live);
  }

  build() {
    Stack({ alignContent: Alignment.BottomStart }) {
      this.constructProgress()
      if (this.otherProgressVm.isLayoutIndicatorTypeUp()) {
        this.constructIndicatorUp()
      } else if (this.otherProgressVm.isLayoutIndicatorTypeOverlay()) {
        this.constructIndicatorOverlay()
      }
    }
    .height(72)
    .width('100%')
    .opacity(this.otherProgressVm.extendOpacity)
    .padding({
      left: 12,
      right: 12,
      bottom: this.data.layoutIndicatorType === LiveIndicatorType.UP ? 12 : 20
    })
  }

  @Builder
  constructProgress() {
    Stack({ alignContent: Alignment.Center }) {
      this.constructLine()
      this.constructNodes()
    }
    .width('100%')
    .height(20)
  }

  @Builder
  constructLine() {
    Stack({ alignContent: Alignment.Start }) {
      if (this.data.layoutLineType === LiveLineType.DOTTED_LINE) {
        // 虚线总体
        Stack({ alignContent: Alignment.Start }) {
          Repeat(this.otherProgressVm.dots).each((dot)=>{
            Row()
              .id('dot_background_' + dot.index)
              .width(DOTTED_LINE_SIZE)
              .height(DOTTED_LINE_SIZE)
              .borderRadius(DOTTED_LINE_SIZE / 2)
              .backgroundColor(this.otherProgressVm.lineBackgroundColor)
              .offset({ x: dot.item.offset * (ResourceVm.instance.isRTL ? -1 : 1) })
          }).key((dot, index) => `dot_${dot.offset}_${index}`)
        }
        .width('100%')

        // 虚线进度
        Stack({ alignContent: Alignment.Start }) {
          Repeat(this.otherProgressVm.dots).each((dot)=>{
            Row()
              .id('dot_progress_' + dot.index)
              .width(DOTTED_LINE_SIZE)
              .height(DOTTED_LINE_SIZE)
              .borderRadius(DOTTED_LINE_SIZE / 2)
              .backgroundColor(this.otherProgressVm.lineColor)
              .offset({ x: dot.item.offset * (ResourceVm.instance.isRTL ? -1 : 1) })
          }).key((dot, index) => `dot_${dot.offset}_${index}`)
        }
        .width(this.otherProgressVm.dotProgressWidth)
        .clip(true)
      } else {
        Line()
          .width('100%')
          .height(this.otherProgressVm.lineHeight)
          .backgroundColor(this.otherProgressVm.lineBackgroundColor)
          .borderRadius(this.otherProgressVm.lineHeight / 2)
        Line()
          .width(`${this.otherProgressVm.lineProgress}%`)
          .height(this.otherProgressVm.lineHeight)
          .backgroundColor(this.otherProgressVm.lineColor)
          .borderRadius(this.otherProgressVm.lineHeight / 2)
      }
    }
    .width('100%')
    .padding({ left: LINE_PADDING, right: LINE_PADDING })
    .onSizeChange((oldSize, newSize)=>{
      if (newSize.width && newSize.width !== oldSize.width) {
        this.otherProgressVm.handleLineSizeChange(newSize);
      }
    })
  }

  @Builder
  constructNodes() {
    Row() {
      ForEach((this.data.layoutNodeIcons), (layoutNodeIcon: image.PixelMap) => {
        Image(layoutNodeIcon)
          .width(20)
          .height(20)
          .objectFit(ImageFit.Contain)
          .syncLoad(true)
          .draggable(false)
          .borderRadius(10)
          .interpolation(ImageInterpolation.Medium)
      })
    }
    .zIndex(1)
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  constructIndicatorUp() {
    Stack({ alignContent: Alignment.Top }) {
      Image($r('app.media.bubble_tips'))
        .draggable(false)
        .width('100%')
      Image(this.data?.layoutIndicatorIcon)
        .width(32)
        .height(32)
        .margin({ top: 2 })
        .objectFit(ImageFit.Contain)
        .draggable(false)
        .interpolation(ImageInterpolation.Medium)
        .borderRadius(16)
        .visibility(this.data?.layoutIndicatorIcon ? Visibility.Visible : Visibility.Hidden)
    }
    .width(INDICATOR_UP_IMAGE_WIDTH)
    .height(40)
    .margin({ bottom: LengthMetrics.vp(20) })
    .offset({ start: LengthMetrics.vp(this.otherProgressVm.translateX) })
    .opacity(this.otherProgressVm.indicatorOpacity)
    .visibility(this.otherProgressVm.isIndicatorShow ? Visibility.Visible : Visibility.Hidden)
  }

  @Builder
  constructIndicatorOverlay() {
    Image(this.data?.layoutIndicatorIcon)
      .width(INDICATOR_OVERLAY_IMAGE_WIDTH)
      .height(INDICATOR_OVERLAY_IMAGE_HEIGHT)
      .objectFit(ImageFit.Contain)
      .draggable(false)
      .interpolation(ImageInterpolation.Medium)
      .offset({ start: LengthMetrics.vp(this.otherProgressVm.translateX) })
      .opacity(this.otherProgressVm.indicatorOpacity)
      .onSizeChange((oldSize, newSize) => {
        if (newSize.width) {
          this.otherProgressVm.handleIndicatorOverlaySizeChange(newSize);
        }
      })
      .visibility(this.data?.layoutIndicatorIcon ? Visibility.Visible : Visibility.Hidden)
  }
}