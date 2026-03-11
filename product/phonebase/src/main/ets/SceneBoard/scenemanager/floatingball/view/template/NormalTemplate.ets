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

const TAG = 'FloatingBallNormalTemplate';
const log = Logger.getLogHelper(LogDomain.WINDOW);

/**
 * 主文本 + 副文本(颜色不同)
 */
@Builder
export function NormalTemplate(ball: FloatingBall) {
  Row(){
    Column() {
      // title
      Row() {
        Text(ball.title)
          .fontSize(FloatingBallStyle.FONT_CAPTION_L)
          .fontWeight(FontWeight.Medium)
          .maxFontScale(1)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontColor(ball.fontColor)
      }
      .clip(true)
      .justifyContent(FlexAlign.Center) // Row内子元素水平方向对齐方式

      // content
      Row() {
        Text(ball.content)
          .fontSize(FloatingBallStyle.FONT_CAPTION_M)
          .fontWeight(FontWeight.Medium)
          .maxFontScale(1)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontColor(ball.contentFontColor)
      }
      .justifyContent(FlexAlign.Center) // Row内子元素水平方向首端对齐
      .clip(true)
    }
    .alignItems(HorizontalAlign.Center) // Column内子元素在水平方居中对齐
  }
  .id(TAG)
  .constraintSize({
    maxWidth: FloatingBallStyle.INNER_ROW_MAX_WIDTH - FloatingBallStyle.LENGTH8 * 2,
    minWidth: FloatingBallStyle.INNER_ROW_MIN_WIDTH - FloatingBallStyle.LENGTH8 * 2
  })
  .justifyContent(FlexAlign.Center)
}