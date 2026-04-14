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

import { LiveCardOtherLayoutVm } from './LiveBaseVm';
import { LiveCardPickupModel } from '../model/LiveCardPickupModel';
import { ILiveCardOtherPickupVm } from '../interface/ILiveCardOtherPickupVm';
import { LiveStyle } from '../constants/LiveStyle';

@ObservedV2
export class LiveCardOtherPickupVm extends LiveCardOtherLayoutVm<LiveCardPickupModel>
  implements ILiveCardOtherPickupVm {
  // 扩展区副文本字体大小
  get contentFontSize(): string | number {
    return `${LiveStyle.PICKUP_EXTEND_TIMER_FONT_SIZE}vp`;
  }

  // 扩展区副文本字重
  get contentFontWeight(): FontWeight | number | string {
    return FontWeight.Bold;
  }

  // 下划线底部间距
  get lineMarginBottom(): number {
    return 3.3;
  }
}