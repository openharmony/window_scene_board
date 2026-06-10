/**
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

import { CommonConstants, FolderLayoutInfo } from '@ohos/launchercommon';
import { FolderLayoutConfig } from '@ohos/launchercommon';
import phoneFolderLayoutInfo from './PhoneFolderLayoutInfo';

/**
 * Phone Folder layout configuration
 */
export default class PhoneFolderLayoutConfig extends FolderLayoutConfig {
  private static phoneInstance: PhoneFolderLayoutConfig;

  protected constructor() {
    super();
    this.mFolderLayoutInfo = phoneFolderLayoutInfo;
  }

  /**
   * Get folder layout configuration instance
   */
  static getInstance(): PhoneFolderLayoutConfig {
    if (PhoneFolderLayoutConfig.phoneInstance === undefined) {
      PhoneFolderLayoutConfig.phoneInstance = new PhoneFolderLayoutConfig();
      PhoneFolderLayoutConfig.phoneInstance.initConfig();
    }
    return PhoneFolderLayoutConfig.phoneInstance;
  }

  getConfigLevel(): string {
    return CommonConstants.LAYOUT_CONFIG_LEVEL_PRODUCT;
  }

  /**
   * 返回默认的布局大小
   *
   * @returns
   */
  getDefaultLayoutInfo(): FolderLayoutInfo {
    return phoneFolderLayoutInfo;
  }
}
