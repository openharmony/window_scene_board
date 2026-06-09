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
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  TestType,
  Size,
  Level } from '@ohos/hypium';
import { SCBScenePanelFSM } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/SCBScenePanelFSM';
import { SCBScenePanelManager } from '@ohos/windowscene';
import { ScenePanelStates } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/ScenePanelStates';

export default function SCBScenePanelFSMTest() {
  describe('SCBScenePanelFSMTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    let scenePanelFSM: SCBScenePanelFSM = SCBScenePanelFSM.getInstance(SCBScenePanelManager.getInstance());
    it('SCBScenePanelFSM_consumeStartEvent_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scenePanelFSM.setCurrentStateToApp();
      scenePanelFSM.consumeStartEvent({ offsetX: 0, offsetY: 0 } as GestureEvent);
      expect(scenePanelFSM.currentState.toString()).assertEqual(ScenePanelStates.STATE_APP_IDLE);
    })

    it('SCBScenePanelFSM_consumeStartEvent_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scenePanelFSM.setCurrentStateToApp();
      scenePanelFSM.oneStepViewModel = null;
      scenePanelFSM.consumeStartEvent({ offsetX: 0, offsetY: 0 } as GestureEvent);
      expect(scenePanelFSM.currentState.toString()).assertEqual(ScenePanelStates.STATE_APP_IDLE);
    })

    it('SCBScenePanelFSM_consumeStartEvent_test_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scenePanelFSM.setCurrentStateToRecent();
      scenePanelFSM.consumeStartEvent({ offsetX: 0, offsetY: 0 } as GestureEvent);
      expect(scenePanelFSM.currentState.toString()).assertEqual(ScenePanelStates.STATE_RECENT_IDLE);
    })

    it('SCBScenePanelFSM_consumeUpdateEvent_test_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scenePanelFSM.setCurrentStateToRecent();
      scenePanelFSM.consumeUpdateEvent({ offsetX: 0, offsetY: 0 } as GestureEvent);
      expect(scenePanelFSM.currentState.toString()).assertEqual(ScenePanelStates.STATE_RECENT_IDLE);
    })

    it('SCBScenePanelFSM_consumeEndEvent_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scenePanelFSM.setCurrentStateToApp();
      scenePanelFSM.oneStepViewModel = null;
      scenePanelFSM.consumeEndEvent({ offsetX: 0, offsetY: 0 } as GestureEvent);
      expect(scenePanelFSM.currentState.toString()).assertEqual(ScenePanelStates.STATE_APP_IDLE);
    })

    it('SCBScenePanelFSM_consumeEndEvent_test_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scenePanelFSM.setCurrentStateToRecent();
      scenePanelFSM.consumeEndEvent({ offsetX: 0, offsetY: 0 } as GestureEvent);
      expect(scenePanelFSM.currentState.toString()).assertEqual(ScenePanelStates.STATE_RECENT_IDLE);
    })

    it('SCBScenePanelFSM_isFollowingState_0', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scenePanelFSM.setCurrentStateToRecent();
      expect(scenePanelFSM.isFollowingState()).assertEqual(false);
    })

    it('SCBScenePanelFSM_isFollowingState_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scenePanelFSM.setCurrentStateToApp();
      scenePanelFSM.consumeUpdateEvent({ offsetX: 3, offsetY: -52 } as GestureEvent);
      expect(scenePanelFSM.isFollowingState()).assertEqual(true);
    })
  })
}