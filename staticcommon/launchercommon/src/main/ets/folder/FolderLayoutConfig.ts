/**
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
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

import { ILayoutConfig } from '../layoutconfig/ILayoutConfig';
import { CommonConstants } from '../constants/CommonConstants';
import type { FolderLayoutInfo } from './FolderLayoutInfo';
import { folderLayoutInfo } from './FolderLayoutInfo';

/**
 * Folder layout configuration
 */
export class FolderLayoutConfig extends ILayoutConfig {
  private static mInstance: FolderLayoutConfig;
  /**
   *  The index of Folder layout configuration
   */
  static FOLDER_GRID_LAYOUT_INFO = 'FolderGridLayoutInfo';
  protected mFolderLayoutInfo: FolderLayoutInfo = folderLayoutInfo;

  constructor() {
    super();
  }

  /**
   * Get folder layout configuration instance
   */
  static getInstance(): FolderLayoutConfig {
    if (!FolderLayoutConfig.mInstance) {
      FolderLayoutConfig.mInstance = new FolderLayoutConfig();
      FolderLayoutConfig.mInstance.initConfig();
    }
    return FolderLayoutConfig.mInstance;
  }

  initConfig(): void {
    const config: FolderLayoutInfo = this.loadPersistConfig() as FolderLayoutInfo;
    this.mFolderLayoutInfo = config;
  }

  getConfigLevel(): string {
    return CommonConstants.LAYOUT_CONFIG_LEVEL_COMMON;
  }

  getConfigType(): number {
    return CommonConstants.LAYOUT_CONFIG_TYPE_FUNCTION;
  }

  getConfigName(): string {
    return FolderLayoutConfig.FOLDER_GRID_LAYOUT_INFO;
  }

  getPersistConfigJson(): string {
    return JSON.stringify(this.mFolderLayoutInfo);
  }

  /**
   * Update folder layout data
   *
   * @params {gridLayoutInfo} folder layout data
   */
  updateFolderLayoutInfo(folderLayoutInfo: FolderLayoutInfo): void {
    this.mFolderLayoutInfo = folderLayoutInfo;
    super.persistConfig();
  }

  /**
   * Get folder layout data
   *
   * @return folder layout data
   */
  getFolderLayoutInfo(): FolderLayoutInfo {
    return this.mFolderLayoutInfo;
  }

  /**
   * 返回默认的布局大小
   *
   * @returns
   */
  getDefaultLayoutInfo(): FolderLayoutInfo {
    return folderLayoutInfo;
  }
}
