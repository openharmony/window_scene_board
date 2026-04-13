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

/**
 * SingePage缩放类
 */
// instrument ignore next
@Observed
export class EditModeSingePageViewData {
  /**
   * SingePage缩放比例
   */
  private singePageScale: number = 1;

  /**
   * SingePage透明度
   */
  private opacity: number = 1;

  /**
   * SingePage背板透明度
   */
  private singePageBackgroundOpacity: number = 0;

  /**
   * SingePage背板饱和度
   */
  private singePageBackgroundSaturate: number = 1;

  /**
   * 编辑模式背景偏移量
   */
  private editModeBgTranslateY: number = 0;

  public setEditModeBgTranslateY(editModeBgTranslateY: number): void {
    this.editModeBgTranslateY = editModeBgTranslateY;
  }

  public getEditModeBgTranslateY(): number {
    return this.editModeBgTranslateY;
  }

  public getSingePageSwiperScale(): number {
    return this.singePageScale;
  }

  public setSingePageSwiperScale(pageScale: number): void {
    this.singePageScale = pageScale;
  }

  public getSingePageBackgroundOpacity(): number {
    return this.singePageBackgroundOpacity;
  }

  public setSingePageBackgroundOpacity(pageBgOpacity: number): void {
    this.singePageBackgroundOpacity = pageBgOpacity;
  }

  public getSingePageBackgroundSaturate(): number {
    return this.singePageBackgroundSaturate;
  }

  public setSingePageBackgroundSaturate(saturate: number): void {
    this.singePageBackgroundSaturate = saturate;
  }

  public getOpacity(): number {
    return this.opacity;
  }

  public setOpacity(opacity: number): void {
    this.opacity = opacity;
  }
}