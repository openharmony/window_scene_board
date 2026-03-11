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

const TAG = 'FloatingBallSimpleTemplate';
const log = Logger.getLogHelper(LogDomain.WINDOW);

/**
 * 长文本
 */
@Builder
export function SimpleTemplate(ball: FloatingBall, listVm: IFloatingBallListVm) {
  Row(){
    Text(ball.title)
      .fontSize(FloatingBallStyle.FONT_CAPTION_M)
      .fontWeight(FontWeight.Medium)
      .maxFontScale(1)
      .maxLines(2)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .fontColor(ball.fontColor)
      .wordBreak(WordBreak.BREAK_WORD) // 换行规则
      .direction(listVm.isRtl ? Direction.Rtl : Direction.Ltr)
  }
  .id(TAG)
  .clip(true)
  .padding({left: FloatingBallStyle.LENGTH8, right: FloatingBallStyle.LENGTH8})
  .justifyContent(FlexAlign.Center)
}

