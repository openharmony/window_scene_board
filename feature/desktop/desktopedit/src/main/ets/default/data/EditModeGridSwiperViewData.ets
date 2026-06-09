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

/**
 * GridSwiper缩放类
 */
// instrument ignore next
@Observed
export class EditModeGridSwiperViewData {
  /**
   * GridSwiper缩放比例
   */
  private gridSwiperScale: number = 1;

  /**
   * Swiper的prevMargin,NextMargin
   */
  private prevNextMargin: number = 0;

  public setGridSwiperScale(swiperScale: number): void {
    this.gridSwiperScale = swiperScale;
  }

  public getGridSwiperScale(): number {
    return this.gridSwiperScale;
  }

  public setPrevNextMargin(prevNextMargin: number): void {
    this.prevNextMargin = prevNextMargin;
  }

  public getPrevNextMargin(): number {
    return this.prevNextMargin;
  }
}