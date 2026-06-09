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

import IconEditPageConstants from '../common/constants/IconEditPageConstants';

/**
 * IconEditPageData
 */
export class IconEditPageData {
  /**
   * iconsColumnMargin
   */
  private _iconsColumnMargin: number = IconEditPageConstants.PREVIEW_ICONS_MARGIN_BOTTOM;

  /**
   * previewContentHeight
   */
  private _previewContentHeight: number = IconEditPageConstants.PREVIEW_ICONS_HEIGHT;

  /**
   * bottomSheetHeight
   */
  private _bottomSheetHeight: number = IconEditPageConstants.BOTTOMSHEET_HEIGHT;

  /**
   * oriPreviewPath
   */
  private _oriPreviewPath: string = IconEditPageConstants.PREVIEW_PATH_DEFAULT;

  public setIconsColumnMargin(value: number): void {
    this._iconsColumnMargin = value;
  }

  public getIconsColumnMargin(): number {
    return this._iconsColumnMargin;
  }

  public setPreviewContentHeight(value: number): void {
    this._previewContentHeight = value;
  }

  public getPreviewContentHeight(): number {
    return this._previewContentHeight;
  }

  public setBottomSheetHeight(value: number): void {
    this._bottomSheetHeight = value;
  }

  public getBottomSheetHeight(): number {
    return this._bottomSheetHeight;
  }


  public setOriPreviewPath(value: string): void {
    this._oriPreviewPath = value;
  }

  public getOriPreviewPath(): string {
    return this._oriPreviewPath;
  }
}