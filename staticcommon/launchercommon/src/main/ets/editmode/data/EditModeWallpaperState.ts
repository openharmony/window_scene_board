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

import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'EditModeWallpaperState';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Observed
export class EditModeWallpaperState {
  /**
   * 是否显示编辑模式UI控件
   */
  private isWallpaperShow: boolean = false;

  /**
   * 设置是否显示编辑模式壁纸控件
   *
   * @param isWallpaperShow 判断是否显示编辑模式壁纸控件
   */
  public setShowWallpaperView(isWallpaperShow: boolean): void {
    log.showInfo('setEditModeViewShow: %{public}s', isWallpaperShow);
    this.isWallpaperShow = isWallpaperShow;
  }

  /**
   * 判断是否显示编辑模式壁纸控件
   *
   * @returns boolean 是否显示编辑模式壁纸控件
   */
  public isShowWallpaper(): boolean {
    return this.isWallpaperShow;
  }
}