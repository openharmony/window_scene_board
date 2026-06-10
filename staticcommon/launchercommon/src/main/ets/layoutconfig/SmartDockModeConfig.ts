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

import { ILayoutConfig } from './ILayoutConfig';
import { CommonConstants } from '../constants/CommonConstants';

/**
 * Dock list mode configuration
 */
export class SmartDockModeConfig extends ILayoutConfig {
  private static mInstance: SmartDockModeConfig;
  /**
   * Dock list mode configuration index
   */
  static SMART_DOCK_MODE_CONFIG = 'SmartDockModeConfig';

  protected constructor() {
    super();
  }

  /**
   * Get the Dock list mode configuration instance
   */
  static getInstance(): SmartDockModeConfig {
    if (!SmartDockModeConfig.mInstance) {
      SmartDockModeConfig.mInstance = new SmartDockModeConfig();
      SmartDockModeConfig.mInstance.initConfig();
    }
    return SmartDockModeConfig.mInstance;
  }

  initConfig(): void {
    const config = this.loadPersistConfig();
  }

  getConfigLevel(): string {
    return CommonConstants.LAYOUT_CONFIG_LEVEL_COMMON;
  }

  getConfigType(): number {
    return CommonConstants.LAYOUT_CONFIG_TYPE_MODE;
  }

  getConfigName(): string {
    return SmartDockModeConfig.SMART_DOCK_MODE_CONFIG;
  }

  public getPersistConfigJson(): string {
    return JSON.stringify({});
  }
}
