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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { CompanionIconInfo } from '../../../../../../../src/main/ets/scene/session/SCBSceneContainerSession';
import {
  SCBCompanionController,
  SCBCompanionManager
} from '../../../../../../main/ets/animation/SCBCompanionController';


export default function SCBCompanionManagerTest() {
  describe('SCBCompanionManagerTest', () => {
    it('getInstance', 0, () => {
      let companionManager: SCBCompanionManager = SCBCompanionManager.getInstance();
      expect(companionManager).not().assertNull();
      companionManager = SCBCompanionManager.getInstance();
      expect(companionManager).not().assertNull();
    });

    it('controller', 0, () => {
      let companionManager: SCBCompanionManager = SCBCompanionManager.getInstance();
      let controller: SCBCompanionController = {
        update: (compInfo: CompanionIconInfo) => {
        }
      }
      companionManager.registerController(controller);
      expect(companionManager.getController()).assertEqual(controller);
      companionManager.unRegisterController();
      expect(companionManager.getController()).assertUndefined();
    });
  });
}