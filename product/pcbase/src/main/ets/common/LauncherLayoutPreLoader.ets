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

import { SingleContext } from '@ohos/basicutils/src/main/ets/utils/SingleManager';
import { LayoutViewModel } from '@ohos/launchercommon';
import { CommonConstants } from '@ohos/launchercommon';
import { layoutConfigManager } from '@ohos/launchercommon';
import { BaseModulePreLoader } from '@ohos/launchercommon';
import PcLauncherLayoutStyleConfig from './PcLauncherLayoutStyleConfig';

/**
 * Load desktop layout configurations.
 */
export class LauncherLayoutPreLoader extends BaseModulePreLoader {
  public static singleName: string = 'LauncherLayoutPreLoader';

  public constructor(ctx?: SingleContext) {
    super(ctx);
  }

  public releaseConfigAndData(): void {
    layoutConfigManager.removeConfigFromManager();
  }

  protected loadConfig(): void {
    layoutConfigManager.addConfigToManager(PcLauncherLayoutStyleConfig.getInstance(this.singleContext));
  }

  protected loadData(): void {
    LayoutViewModel.getInstance(this.singleContext).setDevice(CommonConstants.PAD_DEVICE_TYPE);
  }
}
