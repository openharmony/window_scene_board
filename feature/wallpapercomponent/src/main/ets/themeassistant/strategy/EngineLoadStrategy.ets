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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { EngineContainerManager } from '../component/EngineContainerManager';
import { ThemeServiceHelper } from '../ThemeServiceHelper';

const TAG: string = 'EngineLoadStrategy';

const LOG: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * A parent class contains basic interface of a ThemeEngine load strategy definition
 *
 * @since 2024-07-18
 */
export class EngineLoadStrategy {
  protected engineContainerMgr: EngineContainerManager = EngineContainerManager.getInstance();

  /**
   * Main function to execute a load strategy to start a ThemeEngine instance
   */
  public execution(): void {
    LOG.info(TAG, 'Executing engine load strategy on theme activation');
  }

  /**
   * To be called on each instance loaded, applicable to all strategies
   */
  public onExecutionSuccess(proxyId: string = 'DefaultProxy'): void {
    LOG.info(TAG, `On start execution success for ${proxyId}`);
    ThemeServiceHelper.getInstance().updateDesktopAppState();
    this.engineContainerMgr.killIdleInstance(proxyId);
  }
}