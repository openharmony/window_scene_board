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

import { LogDomain, Logger } from '@ohos/basicutils';
import { FloatingBall } from '../../model/FloatingBallModel';
import { FloatingBallStyle } from '../../constants/FloatingBallStyle';
import { IFloatingBallListVm } from '../../interface/IFloatingBallListVm';

const TAG = 'FloatingBallEmphasisTemplate';
const log = Logger.getLogHelper(LogDomain.WINDOW);

/**
 * 数字 + 文本
 */
@Builder
export function EmphasisTemplate(ball: FloatingBall, listVm: IFloatingBallListVm) {
  Row() {
    if (ball.icon) {
      // icon
      Column() {
        Image(ball.icon)
          .id(`icon_image`)
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Cover)
          .borderRadius($r('sys.float.corner_radius_level9'))
          .draggable(false)
          .interpolation(ImageInterpolation.Medium) // 设置图片插值效果缓解在缩放时的锯齿问题
          .flexGrow(0)
          .flexShrink(0)
      }
      .width(FloatingBallStyle.ICON_WIDTH)
      .height(FloatingBallStyle.ICON_HEIGHT)
      .margin({ left: FloatingBallStyle.LENGTH4, right: FloatingBallStyle.LENGTH4 }) // 距离右侧8vp
      .alignItems(HorizontalAlign.Center) // 子组件在水平方向上居中对齐
      .justifyContent(FlexAlign.Center) // 子组件在垂直方向上居中对齐
    }
    Column() {
      Column() {
        // title
        Row() {
          Text(ball.title)
            .fontSize(FloatingBallStyle.FONT_BODY_M)
            .fontWeight(FontWeight.Bold)
            .maxLines(1)
            .maxFontScale(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .fontColor(ball.fontColor)
            .wordBreak(WordBreak.BREAK_ALL)
        }
        .clip(true)
        .justifyContent(FlexAlign.Center) // Row内子元素水平方向对齐方式(默认值：FlexAlign.Start)

        // content
        Row() {
          Text(ball.content)
            .fontSize(FloatingBallStyle.FONT_CAPTION_S)
            .fontWeight(FontWeight.Bold)
            .maxFontScale(1)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .fontColor(ball.fontColor)
            .wordBreak(WordBreak.BREAK_ALL)
        }
        .justifyContent(FlexAlign.Center) // Row内子元素水平方向对齐方式(默认值：FlexAlign.Start)
        .clip(true)
      }
      .alignItems(HorizontalAlign.Center) // 标题和内容组件内居中
    }
    .padding(ball.icon ?
      (listVm.isRtl ? { left: FloatingBallStyle.LENGTH8 } : { right: FloatingBallStyle.LENGTH8 }) : undefined)
    .alignItems(ball.icon ? HorizontalAlign.Start : HorizontalAlign.Center)
    .constraintSize({
      maxWidth: FloatingBallStyle.INNER_ROW_MAX_WIDTH - FloatingBallStyle.LENGTH8 - FloatingBallStyle.ICON_WIDTH,
      minWidth: FloatingBallStyle.INNER_ROW_MIN_WIDTH - FloatingBallStyle.LENGTH8 - FloatingBallStyle.ICON_WIDTH,
    })
    .layoutWeight(1)
  }
  .id(TAG)
  .justifyContent(ball.icon ? (listVm.isRtl ? FlexAlign.End : FlexAlign.Start) : FlexAlign.Center)
  .width('100%')
  .height('100%')
}