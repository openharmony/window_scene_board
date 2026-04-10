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

import { CommonConstants } from '@ohos/launchercommon';
import { SmartDockSuggestAppConfig } from '@ohos/launchercommon';
import PresetSuggestAppItem from './PresetSuggestAppItem';

/**
 * 桌面Dock建议app布局配置
 */
export default class PcSmartDockSuggestAppConfig extends SmartDockSuggestAppConfig {
  private static sProductInstance: PcSmartDockSuggestAppConfig | null = null;

  protected constructor() {
    super();
    this.mSuggestAppInfo = PresetSuggestAppItem;
  }

  public static getInstance(): PcSmartDockSuggestAppConfig {
    if (PcSmartDockSuggestAppConfig.sProductInstance == null) {
      PcSmartDockSuggestAppConfig.sProductInstance = new PcSmartDockSuggestAppConfig();
      PcSmartDockSuggestAppConfig.sProductInstance.initConfig();
    }
    return PcSmartDockSuggestAppConfig.sProductInstance;
  }

  public getConfigLevel(): string {
    return CommonConstants.LAYOUT_CONFIG_LEVEL_PRODUCT;
  }
}
