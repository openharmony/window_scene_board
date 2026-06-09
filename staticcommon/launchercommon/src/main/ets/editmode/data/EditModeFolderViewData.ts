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
import { ConfigurationConstant } from '@kit.AbilityKit';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { StateEx, SCBVisualEffectMgr } from '@ohos/componenthelper';
import { WallpaperConstants } from '@ohos/commonconstants';
import { FolderDataModelManager } from '../../TsIndex';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG: string = 'EditModeFolderViewData';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Observed
export class EditModeFolderViewData {
  /**
   * 编辑模式下文件夹背板颜色
   */
  private folderBackgroundColor: string = '#00FFFFFF';
  private opacity: number = 0;

  /**
   * 编辑模式下文件夹背板
   */
  public isFolderExtraBackGroundShow: StateEx<boolean> = new StateEx(false, 'isFolderExtraBackGroundShow');

  public getFolderBackgroundColor(): string {
    this.updateFolderBackgroundColor();
    return this.folderBackgroundColor;
  }

  public setFolderBackgroundColor(folderBackgroundColor: string): void {
    this.folderBackgroundColor = folderBackgroundColor;
  }

  public updateFolderBackgroundColor(): void {
    let isDarkMode: boolean =
      GlobalContext.getContext()?.config?.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
    // 1-极浅壁纸；2-浅色壁纸；3-深色壁纸；4-极深壁纸；5-普通花壁纸；6-极花壁纸
    const degree = FolderDataModelManager.getInstance().getDegree();
    const isWhiteWallpaper: boolean = degree === WallpaperConstants.WALLPAPER_TYPE_ONE;
    const isBlackWallpaper: boolean =
      degree === WallpaperConstants.WALLPAPER_TYPE_THREE || degree === WallpaperConstants.WALLPAPER_TYPE_FOUR;
    const whiteModeWallpaperColor = isWhiteWallpaper ? '#B3FFFFFF' : '#4DFFFFFF';
    const darkModeWallpaperColor = isBlackWallpaper ? '#80000000' : '#4D000000';
    if (SCBVisualEffectMgr.isFolderSolidColor()) {
      this.folderBackgroundColor = isDarkMode ? '#802E3033' : '#99FAFAFA';
    } else {
      this.folderBackgroundColor = isDarkMode ? darkModeWallpaperColor : whiteModeWallpaperColor;
    }
  }

  /**
   * 获取编辑模式下文件夹背板透明度
   * @returns opacity 透明度
   */
  public getFolderBackgroundOpacity(): number {
    return this.opacity;
  }

  /**
   * 获取编辑模式下文件夹背板模糊透明度
   * @returns opacity 透明度
   */
  public getFolderBackgroundBlurOpacity(): number {
    log.showInfo(`getFolderBackgroundBlurOpacity ${1 - this.opacity}`);
    return 1 - this.opacity;
  }


  /**
   * 设置编辑模式下文件夹背板透明度
   * @param opacity 透明度
   */
  public setFolderBackgroundOpacity(opacity: number): void {
    this.opacity = opacity;
  }
}