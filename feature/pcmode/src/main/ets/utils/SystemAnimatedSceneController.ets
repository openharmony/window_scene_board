/**
 * Copyright (c) 2023-Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

import sceneSessionManager from '@ohos.sceneSessionManager';
import { LogHelper, LogDomain, SingletonHelper } from '@ohos/basicutils';
import { SystemAnimatedScene } from '../constants/SystemAnimatedScene';

const TAG = 'AnimatedSceneCtrl';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class SystemAnimatedSceneController {
  private animatedSceneRecords: Map<number, number> = new Map();

  enqueue(animatedScene: number, isRegularAnimation: boolean = false): void {
    let target = this.animatedSceneRecords.get(animatedScene);
    this.animatedSceneRecords.set(animatedScene, target === undefined ? 1 : target + 1);
    log.showDebug(`setSystemAnimatedScenes ${animatedScene} enqueue`);
    sceneSessionManager.setSystemAnimatedScenes(animatedScene, isRegularAnimation);
  }

  dequeue(animatedScene: number): void {
    let target = this.animatedSceneRecords.get(animatedScene);
    if (target === undefined || target <= 0) {
      log.showWarn(`setSystemAnimatedScenes ${animatedScene}, no_matched_start abandoned`);
      return;
    }

    this.animatedSceneRecords.set(animatedScene, target - 1);
    log.showDebug(`setSystemAnimatedScenes ${animatedScene} dequeue`);
    sceneSessionManager.setSystemAnimatedScenes(SystemAnimatedScene.OTHERS, false);
  }

  dumpAnimatedSceneRecords(): void {
    this.animatedSceneRecords.forEach((val: number, k: number) => {
      log.showDebug(`${k}, ${val}`);
    });
  }
}

export const systemAniSceneCtrl = SingletonHelper.getInstance(SystemAnimatedSceneController, TAG);