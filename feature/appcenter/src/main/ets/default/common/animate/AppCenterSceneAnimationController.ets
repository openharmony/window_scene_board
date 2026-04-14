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

// import sceneSessionManager from '@ohos.sceneSessionManager';
import { LogHelper, LogDomain } from '@ohos/basicutils';
import { AppCenterSceneConstants } from './AppCenterSceneConstants';

const TAG = 'AppCenterSceneAnimationController';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class AppCenterSceneAnimationController {
  private static mInstance: AppCenterSceneAnimationController;
  private animatedSceneRecords: Map<number, number> = new Map();

  /**
   * Get Instance for AppCenterSceneAnimationController
   *
   * @returns
   */
  public static getInstance(): AppCenterSceneAnimationController {
    if (!AppCenterSceneAnimationController.mInstance) {
      AppCenterSceneAnimationController.mInstance = new AppCenterSceneAnimationController();
    }

    return AppCenterSceneAnimationController.mInstance;
  }

  public enqueue(animatedScene: number, isRegularAnimation: boolean = false): void {
    let target = this.animatedSceneRecords.get(animatedScene);
    this.animatedSceneRecords.set(animatedScene, target === undefined ? 1 : target + 1);
    log.showDebug(`setSystemAnimatedScenes ${animatedScene} enqueue`);
    // sceneSessionManager.setSystemAnimatedScenes(animatedScene, isRegularAnimation);
  }

  public dequeue(animatedScene: number): void {
    let target = this.animatedSceneRecords.get(animatedScene);
    if (target === undefined || target <= 0) {
      log.showWarn(`setSystemAnimatedScenes ${animatedScene}, no_matched_start abandoned`);
      return;
    }

    this.animatedSceneRecords.set(animatedScene, target - 1);
    log.showDebug(`setSystemAnimatedScenes ${animatedScene} dequeue`);
    // sceneSessionManager.setSystemAnimatedScenes(AppCenterSceneConstants.OTHERS, false);
  }

  public dumpAnimatedSceneRecords(): void {
    this.animatedSceneRecords.forEach((val: number, k: number) => {
      log.showDebug(`${k}, ${val}`);
    });
  }
}