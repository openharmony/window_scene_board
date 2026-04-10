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

import { PanelMonthViewModel } from '../calendar/PanelMonthViewModel';
import { SingleMonthlyView } from './SingleMonthlyView';

const TAG: string = 'SwiperMonthlyView';

@Component
export struct SwiperMonthlyView {
  // 月视图绑定的视图模型
  @ObjectLink viewModel: PanelMonthViewModel;

  @State private cachedCount: number = 0;

  private clearSelectHandler: () => void = (): void => {
    this.viewModel.onSelectedDateChange();
  };

  onSwiperIndexChange(index: number): void {
    this.viewModel.onSwiperIndexChange(index);
  }

  build() {
    Swiper(this.viewModel.swiperController) {
      ForEach(new Array(this.viewModel.MAX_MONTH_COUNT).fill(''), (item: string, index: number) => {
        if (this.viewModel.singleMonthlyViewModels[index]) {
          SingleMonthlyView(
            {
              viewModel: this.viewModel.singleMonthlyViewModels[index],
              clearSelectHandler: this.clearSelectHandler
            })
        }
      }, (item: string, index: number) => index.toString())
    }
    .accessibilityLevel('no')
    .cachedCount(this.cachedCount)
    .index(this.viewModel.currentIndex)
    .autoPlay(false)
    .indicator(false)
    .loop(true) // 默认开启循环播放
    .duration(500)
    .vertical(false)
    .focusable(true)
    .onAnimationStart((index: number, targetIndex: number) => {
      this.viewModel.updateDataArrayForAnimate(targetIndex);
    })
    .onChange((index: number) => {
      this.onSwiperIndexChange(index);
    })
    .layoutWeight(1)
  }
}