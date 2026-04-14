/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

import { SingleContext, singleManager } from '@ohos/basicutils/src/main/ets/TsIndex';
import { BaseModulePreLoader } from '@ohos/launchercommon';
import { layoutConfigManager } from '@ohos/launchercommon';
import { SmartDockModeConfig } from '@ohos/launchercommon';
import { SmartDockLayoutConfig } from '@ohos/launchercommon';
import { SmartDockStyleConfig } from './SmartDockStyleConfig';

/**
 * smartDock config preLoader
 */
export class SmartDockPreLoader extends BaseModulePreLoader {

  public static singleName: string = 'SmartDockPreLoader';

  public smartDockLayoutConfig: SmartDockLayoutConfig;

  constructor(ctx?: SingleContext) {
    super(ctx);
    this.smartDockLayoutConfig = singleManager.get<SmartDockLayoutConfig>(SmartDockLayoutConfig, ctx);
  }

  protected loadConfig(): void {
    layoutConfigManager.addConfigToManager(this.smartDockLayoutConfig);
    layoutConfigManager.addConfigToManager(SmartDockModeConfig.getInstance());
    layoutConfigManager.addConfigToManager(SmartDockStyleConfig.getInstance());
  }

  protected loadData(): void {
  }

  releaseConfigAndData(): void {
    layoutConfigManager.removeConfigFromManager();
  }
}

export const smartDockPreLoader: SmartDockPreLoader = singleManager.get<SmartDockPreLoader>(SmartDockPreLoader);
