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

import { DualInstanceHandler } from '../handler/DualInstanceHandler';
import { EngineLoadStrategy } from './EngineLoadStrategy';

/**
 * Default load strategy where 2 TE instances would exist for a brief time, avoiding black frame on theme switch
 *
 * @since 2024-07-18
 */
export class GracefullyLoadStrategy extends EngineLoadStrategy {
  /**
   * GLS would start the backup instance, only kill idle instance when backup instance is loaded
   */
  public execution(): void {
    super.execution();
    DualInstanceHandler.getInstance().registerCurrentStrategy(this);
    this.engineContainerMgr.startNewInstance();
  }
}