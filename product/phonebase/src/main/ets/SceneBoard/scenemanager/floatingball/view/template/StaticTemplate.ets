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

import { LogDomain, Logger } from '@ohos/basicutils';
import { FloatingBall } from '../../model/FloatingBallModel';
import { FloatingBallStyle } from '../../constants/FloatingBallStyle';
import { IFloatingBallListVm } from '../../interface/IFloatingBallListVm';

const TAG = 'FloatingBallStaticTemplate';
const log = Logger.getLogHelper(LogDomain.WINDOW);

/**
 * 图标 + 文字
 */
@Builder
export function StaticTemplate(ball: FloatingBall, listVm: IFloatingBallListVm) {
  Row() {
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

    // title
    Column() {
      Text(ball.title)
        .minFontSize(FloatingBallStyle.FONT_CAPTION_M)
        .maxFontSize(FloatingBallStyle.FONT_BODY_S)
        .heightAdaptivePolicy(TextHeightAdaptivePolicy.MIN_FONT_SIZE_FIRST)
        .fontWeight(FontWeight.Medium)
        .maxFontScale(1)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .padding(listVm.isRtl ? { left: FloatingBallStyle.LENGTH6 } : { right: FloatingBallStyle.LENGTH6})
        .fontColor(ball.fontColor)
    }
    .clip(true)
    .layoutWeight(1)
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
  }
  .id(TAG)
  .justifyContent(FlexAlign.Center)
}
