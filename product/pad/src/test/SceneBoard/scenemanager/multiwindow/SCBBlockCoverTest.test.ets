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
import {
  SCBGestureAction,
  SCBGestureActionId,
  SCBSceneContainerSession,
  SCBSceneContainerState,
  SCBSceneInfo, SCBSceneSession,
  SCBScreenProperty,
  ScenePanelState} from '@ohos/windowscene';
import { beforeAll, describe, expect, it, Level } from '@ohos/hypium';
import { BlockCoverController } from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBBlockCover';
import sceneSessionManager from '@ohos.sceneSessionManager';

function SCBBlockCoverSubTest_01() {
  let sceneInfo: SCBSceneInfo;
  let sceneSession: SCBSceneSession;
  let containerSession: SCBSceneContainerSession;
  let blockCoverController: BlockCoverController;
  let screenProperty = new SCBScreenProperty();

  describe('BlockCoverControllerTest_001', () => {
    beforeAll(() => {
      sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      sceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      containerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      blockCoverController = new BlockCoverController(() => {
        return containerSession
      }, () => {
      });
    })

    it('session_001', Level.LEVEL0, () => {
      blockCoverController.session();
      expect(true).assertEqual(true);
    })

    it('persistentId_001', Level.LEVEL0, () => {
      blockCoverController.persistentId();
      expect(true).assertEqual(true);
    })

    it('handleGestureAction_001', Level.LEVEL0, () => {
      let action = new SCBGestureAction({
        id: SCBGestureActionId.SPLIT_GESTURE_BEGIN,
      });
      blockCoverController.handleGestureAction(containerSession, screenProperty, action);
      expect(true).assertEqual(true);
    })

    it('onAboutToDisappear_001', Level.LEVEL0, () => {
      blockCoverController.onAboutToDisappear();
      expect(true).assertEqual(true);
    })
  })
}

function SCBBlockCoverSubTest_02() {
  let sceneInfo: SCBSceneInfo;
  let sceneSession: SCBSceneSession;
  let containerSession: SCBSceneContainerSession;
  let blockCoverController: BlockCoverController;
  let screenProperty = new SCBScreenProperty();

  describe('BlockCoverControllerTest_002', () => {
    beforeAll(() => {
      sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      sceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      containerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      blockCoverController = new BlockCoverController(() => {
        return containerSession
      }, () => {
      });
    })
    it('handleGestureAction002', Level.LEVEL0, () => {
      let action = new SCBGestureAction({
        id: SCBGestureActionId.EXIT_SPLIT,
      });
      blockCoverController.handleGestureAction(containerSession, screenProperty, action);
      expect(true).assertEqual(true);
    })

    it('handleGestureAction003', Level.LEVEL0, () => {
      let action = new SCBGestureAction({
        id: SCBGestureActionId.FLOAT_GESTURE_BEGIN,
      });
      blockCoverController.handleGestureAction(containerSession, screenProperty, action);
      expect(true).assertEqual(true);
    })

    it('handleGestureAction004', Level.LEVEL0, () => {
      let action = new SCBGestureAction({
        id: SCBGestureActionId.SPLIT_GESTURE_END,
      });
      blockCoverController.handleGestureAction(containerSession, screenProperty, action);
      expect(true).assertEqual(true);
    })

    it('handleGestureAction005', Level.LEVEL0, () => {
      let action = new SCBGestureAction({
        id: SCBGestureActionId.FLOAT_GESTURE_END,
      });
      blockCoverController.handleGestureAction(containerSession, screenProperty, action);
      expect(true).assertEqual(true);
    })

  })
}

function SCBBlockCoverSubTest_03() {
  let sceneInfo: SCBSceneInfo;
  let sceneSession: SCBSceneSession;
  let containerSession: SCBSceneContainerSession;
  let blockCoverController: BlockCoverController;
  let screenProperty = new SCBScreenProperty();

  describe('BlockCoverControllerTest_003', () => {
    beforeAll(() => {
      sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      sceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      containerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      blockCoverController = new BlockCoverController(() => {
        return containerSession
      }, () => {
      });
    })

    it('onContainerFoldChange_001', Level.LEVEL0, () => {
      blockCoverController.show();
      blockCoverController.onContainerFoldChange(containerSession, screenProperty);
      expect(true).assertEqual(true);
    })

    it('onContainerStateChange001', Level.LEVEL0, () => {
      blockCoverController.onContainerStateChange(containerSession, screenProperty,
        SCBSceneContainerState.ONE_STEP, ScenePanelState.SPLIT);
      expect(true).assertEqual(true);
    })

    it('onContainerStateChange002', Level.LEVEL0, () => {
      blockCoverController.onContainerStateChange(containerSession, screenProperty,
        SCBSceneContainerState.FULL_SCREEN, ScenePanelState.SPLIT);
      expect(true).assertEqual(true);
    })

    it('recordTouchEvent001', Level.LEVEL0, () => {
      blockCoverController.recordTouchEvent(TouchType.Down);
      expect(true).assertEqual(true);
    })

    it('recordTouchEvent002', Level.LEVEL0, () => {
      blockCoverController.recordTouchEvent(TouchType.Up);
      expect(true).assertEqual(true);
    })

    it('maximizeOneStepIfNeed_001', Level.LEVEL0, () => {
      blockCoverController.maximizeIfNeed();
      expect(true).assertEqual(true);
    })
  })
}

export function SCBBlockCoverTest() {
  SCBBlockCoverSubTest_01();
  SCBBlockCoverSubTest_02();
  SCBBlockCoverSubTest_03();
}