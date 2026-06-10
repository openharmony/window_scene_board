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
 * 编辑模式壁纸背景色类
 */
// instrument ignore next
@Observed
export class EditModeWallpaperViewData {
  /**
   * Wallpaper背板颜色
   */
  private wallpaperBackgroundColor: string = '';

  /**
   * 编辑模式背板blurScale
   */
  private wallpaperBackgroundBlurScale: number = 0;

  public getWallpaperBackgroundBlurScale(): number {
    return this.wallpaperBackgroundBlurScale;
  }

  public setWallpaperBackgroundBlurScale(backgroundBlurScale: number): void {
    this.wallpaperBackgroundBlurScale = backgroundBlurScale;
  }

  public getWallpaperBackgroundColor(): string {
    return this.wallpaperBackgroundColor;
  }

  public setWallpaperBackgroundColor(backgroundColor: string): void {
    this.wallpaperBackgroundColor = backgroundColor;
  }
}