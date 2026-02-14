/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { CompanionIconInfo } from '@ohos/basicutils';

const TAG = 'SCBCompanionController';

export interface SCBCompanionController {
  update: (compInfo: CompanionIconInfo) => void;
  quickAdd?: (compInfo: CompanionIconInfo) => () => void;
  delete?: (compInfo: CompanionIconInfo) => void;
}

export class SCBCompanionManager {
  private static instance: SCBCompanionManager;
  private controllerMap: Map<number, SCBCompanionController | undefined> = new Map();

  static getInstance(): SCBCompanionManager {
    if (SCBCompanionManager.instance == null) {
      SCBCompanionManager.instance = new SCBCompanionManager();
    }
    return SCBCompanionManager.instance;
  }

  registerController(controller: SCBCompanionController, screenId: number = 0) {
    this.controllerMap.set(screenId, controller);
  }

  unRegisterController(screenId: number = 0) {
    this.controllerMap.set(screenId, undefined);
  }

  getController(screenId: number = 0): SCBCompanionController | undefined {
    return this.controllerMap.get(screenId);
  }
}