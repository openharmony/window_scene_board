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

import { CreateStore } from '../utils/CreateStore';
import type { GlassSystemSceneType } from '../../scene/common/GlassSystemSceneManager';
import { SCBSceneSession } from '@ohos/windowscene';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, 'GlassStatusManager');

export class GlassStatusManager {
  private static instance?: GlassStatusManager;
  public activeSystemScene: CreateStore<Map<GlassSystemSceneType, boolean>> | null = null;
  public activeAppScene: CreateStore<Set<SCBSceneSession>> | null = null;

  private constructor() {
    log.showInfo(`constructor`);
  }

  public static getInstance(): GlassStatusManager {
    if (!GlassStatusManager.instance) {
      GlassStatusManager.instance = new GlassStatusManager();
    }
    return GlassStatusManager.instance;
  }

  public static destroyInstance(): void {
    if (!GlassStatusManager.instance) {
      return;
    }
    log.showInfo(`destroyInstance`);
    GlassStatusManager.instance.release();
    GlassStatusManager.instance = undefined;
  }

  public init(): void {
    this.activeSystemScene = new CreateStore(new Map());
    this.activeAppScene = new CreateStore(new Set());
  }

  public release(): void {
    this.activeSystemScene = null;
    this.activeAppScene = null;
  }
}