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

import { DualInstanceHandler } from '../handler/DualInstanceHandler';
import { EngineLoadStrategy } from './EngineLoadStrategy';

/**
 * Backup strategy to kill the idle instance first before starting backup instance
 *
 * @since 2024-07-18
 */
export class SingularInstanceLoadStrategy extends EngineLoadStrategy {
  /**
   * On executing, idle TE will be killed to maximise available RAM for starting another instance
   */
  public execution(): void {
    super.execution();
    DualInstanceHandler.getInstance().registerCurrentStrategy(this);
    this.engineContainerMgr.killIdleInstance();
    this.engineContainerMgr.restartCurrentInstance();
  }
}