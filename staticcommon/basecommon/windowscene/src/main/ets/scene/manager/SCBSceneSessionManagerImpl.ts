/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBSceneMissionManager } from './SCBSceneMissionManager';
import { SCBConstants } from '@ohos/commonconstants';

const TAG = 'SCBSceneSessionManagerImpl';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

/**
 * Inner implementation of SceneSessionManager.
 */
export class SCBSceneSessionManagerImpl {
  constructor() {
    this.registerMissionManagementListener();
  }

  /**
   * init with order.
   */
  public init(): void {
    log.showInfo('init.');
  }

  private registerMissionManagementListener(): void {
    sceneSessionManager.on('sceneSessionDestruct', (persistentId: number) => {
      SCBSceneMissionManager.getInstance().removeSceneSessionAfterDestruct(persistentId);
    });

    sceneSessionManager.on('sceneSessionTransferToTargetScreen', (persistentId: number, targetScreen: number,
      record: Record<string, Object>) => {
      SCBSceneMissionManager.getInstance().transferSceneToTargetScreen(persistentId, targetScreen, record);
    });
  }
}