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
import { describe, expect, it, Level } from '@ohos/hypium';
import {
  GuideTipSceneSession
} from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/Guidance/GuideTipSceneSession';
import sceneSessionManager from '@ohos.sceneSessionManager';


export function GuideTipSceneSessionTest() {
  describe('GuideTipSceneSessionTest_001', () => {
    it("constructor_001", Level.LEVEL0, () => {
      new GuideTipSceneSession("GuideTipSceneSessionTest", sceneSessionManager.SessionType.TYPE_PANEL, 0);
      expect(true).assertTrue();
    });

    it("setZOrder_001", Level.LEVEL0, () => {
      let session = new GuideTipSceneSession("GuideTipSceneSessionTest", sceneSessionManager.SessionType.TYPE_PANEL, 0);
      session.setZOrder(1);
      expect(true).assertTrue();
    });

    it("setVisibility_001", Level.LEVEL0, () => {
      let session = new GuideTipSceneSession("GuideTipSceneSessionTest", sceneSessionManager.SessionType.TYPE_PANEL, 0);
      session.setVisibility(true);
      expect(session.visibility).assertTrue();
      session.setVisibility(false);
      expect(session.visibility).assertFalse();
    });

    it("requestSceneSessionDestruction_001", Level.LEVEL0, () => {
      let session = new GuideTipSceneSession("GuideTipSceneSessionTest", sceneSessionManager.SessionType.TYPE_PANEL, 0);
      session.requestSceneSessionDestruction();
      expect(true).assertTrue();
    });
  });
}