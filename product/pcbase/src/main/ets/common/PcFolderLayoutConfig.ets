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

import { CommonConstants } from '@ohos/launchercommon';
import { FolderLayoutConfig } from '@ohos/launchercommon';
import PcFolderLayoutInfo from './configs/PcFolderLayoutInfo';

/**
 * Pc Folder layout configuration
 */
export default class PcFolderLayoutConfig extends FolderLayoutConfig {
  protected constructor() {
    super();
    this.mFolderLayoutInfo = PcFolderLayoutInfo;
  }

  /**
   * Get folder layout configuration instance
   */
  static getInstance(): PcFolderLayoutConfig {
    if (globalThis.PcFolderLayoutConfig == null) {
      globalThis.PcFolderLayoutConfig = new PcFolderLayoutConfig();
    }
    return globalThis.PcFolderLayoutConfig;
  }

  getConfigLevel(): string {
    return CommonConstants.LAYOUT_CONFIG_LEVEL_PRODUCT;
  }
}
