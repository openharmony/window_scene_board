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

import {
  AppListStyleConfig,
  CommonConstants,
  FolderCommonConstants,
  FolderModel,
  LayoutViewModel
} from '../../../../../../TsIndex';
import { SmallFolderConstants } from '../../../../../common/SmallFolderConstants';

const DEFAULT_BLUR = 20;

/**
 * 小文件夹样式配置类
 */
export class SmallFolderStyleConfig extends AppListStyleConfig {
  private static instance: SmallFolderStyleConfig;
  private static isInPreviewMode: boolean = false;

  /**
   * small folder app size
   */
  mFolderAppSize = SmallFolderConstants.DEFAULT_APP_ICON_WIDTH;

  /**
   * small folder grid margin side
   */
  mGridMargin = SmallFolderConstants.DEFAULT_FOLDER_GRID_PADDING;

  /**
   * small folder grid gap
   */
  mFolderGridGap = SmallFolderConstants.DEFAULT_FOLDER_GRID_GAP;

  /**
   * small folder list blur
   */
  mBackdropBlur = DEFAULT_BLUR;

  /**
   * small folder radius
   */
  mSmallFolderRadius = SmallFolderConstants.DEFAULT_FOLDER_RADIUS;

  /**
   * small folder icon radius
   */
  mSmallFolderIconRadius = SmallFolderConstants.DEFAULT_FOLDER_RADIUS;

  private constructor() {
    super();
  }

  /**
   * get small folder style config instance
   */
  public static getInstance(): SmallFolderStyleConfig {
    if (SmallFolderStyleConfig.instance == null) {
      SmallFolderStyleConfig.instance = new SmallFolderStyleConfig();
    }
    SmallFolderStyleConfig.instance.initConfig();
    return SmallFolderStyleConfig.instance;
  }

  /**
   * 设置是否为预览模式
   *
   * @param isInPreviewMode
   */
  public static setInPreviewMode(isInPreviewMode: boolean): void {
    SmallFolderStyleConfig.isInPreviewMode = isInPreviewMode;
    SmallFolderStyleConfig.instance.initConfig();
  }

  initConfig(): void {
    const layoutViewModel = LayoutViewModel.getInstance();
    const desktopFolderLayoutInfo = FolderModel.getInstance().getSmallFolderLayout();
    const folderResult =
      layoutViewModel.calculateFolder(desktopFolderLayoutInfo, SmallFolderStyleConfig.isInPreviewMode);

    this.mFolderAppSize = folderResult.mFolderAppSize ?? 0;
    this.mFolderGridGap = folderResult.mFolderGridGap ?? 0;
    this.mGridMargin = folderResult.mGridMargin ?? 0;
    this.mSmallFolderRadius = folderResult.mSmallFolderRadius ?? 0;
    this.mSmallFolderIconRadius = folderResult.mFolderIconRadius ?? 0;
  }

  getConfigLevel(): string {
    return CommonConstants.LAYOUT_CONFIG_LEVEL_FEATURE;
  }

  getFeatureName(): string {
    return FolderCommonConstants.FEATURE_NAME_SMALL_FOLDER;
  }
}