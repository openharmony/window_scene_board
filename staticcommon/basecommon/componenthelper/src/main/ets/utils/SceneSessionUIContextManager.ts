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

import { CheckEmptyUtils } from '@ohos/basicutils';
import { UIContext } from '@kit.ArkUI';
import sceneSessionManager from '@ohos.sceneSessionManager';

export class SceneSessionUIContextManager {
  private static sceneSessionManagerClass: SceneSessionUIContextManager;
  private uiContext: UIContext;

  protected constructor() {}

  public setUiContext(context: UIContext): void {
    this.uiContext = context;
  }

  public getUiContext(): UIContext {
    if (!this.uiContext) {
      this.uiContext = sceneSessionManager.getRootSceneUIContext();
    }
    return this.uiContext;
  }

  public static getInstance(): SceneSessionUIContextManager {
    if (CheckEmptyUtils.isEmpty(this.sceneSessionManagerClass)) {
      this.sceneSessionManagerClass = new SceneSessionUIContextManager();
    }
    return this.sceneSessionManagerClass;
  }
}