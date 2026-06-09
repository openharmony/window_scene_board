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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium'
import { SceneBoardCoreStateFsm } from '../../../../../../../main/ets/manager/fsm/SceneBoardCoreStateFsm';
import { CoreEventType, StateType } from '../../../../../../../main/ets/manager/fsm/SceneBoardStateConfig';
import { AbstractState, FsmListener, StateFsm } from '../../../../../../../main/ets/manager/fsm/StateFsm';

export function StateFsmTest() {
  describe('StateFsmTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    it('transfer_test_01', 0, () => {
      let fsm: StateFsm = new SceneBoardCoreStateFsm();
      fsm.init();
      fsm.transfer(CoreEventType.ENTER_DESKTOP);
      expect(fsm.currentState.stateType).not().assertUndefined();
    })

    it('transfer_test_02', 0, () => {
      let fsm: StateFsm = new SceneBoardCoreStateFsm();
      fsm.init();
      fsm.transfer(CoreEventType.SCENE_BOARD_START_UP);
      expect(fsm.currentState.stateType).not().assertUndefined();
    })

    it('transfer_test_03', 0, () => {
      let fsm: StateFsm = new SceneBoardCoreStateFsm();
      fsm.init();
      fsm.transfer(CoreEventType.SCENE_BOARD_START_UP);
      expect(fsm.currentState.stateType).not().assertUndefined();

      let mocker: MockKit = new MockKit();
      let stateFsm: StateFsm = new SceneBoardCoreStateFsm();
      let mockGetState: Function = mocker.mockFunc(stateFsm, stateFsm.getState);
      when(mockGetState)(ArgumentMatchers.any).afterReturn(undefined);
      stateFsm.transfer(CoreEventType.SCENE_BOARD_START_UP);
      mocker.ignoreMock(stateFsm, stateFsm.getState);
    })

    it('addState_test_01', 0, () => {
      let fsm: StateFsm = new SceneBoardCoreStateFsm();
      fsm.init();
      expect(fsm.currentState.stateType).not().assertUndefined();
    })

    it('addState_test_02', 0, () => {
      let fsm: StateFsm = new SceneBoardCoreStateFsm();
      fsm.init();
      fsm.addState(new DTState(StateType.INIT));
      expect(fsm.currentState.stateType).not().assertUndefined();
    })

    it('getState_test', 0, () => {
      let fsm: StateFsm = new SceneBoardCoreStateFsm();
      fsm.init();
      fsm.getState(StateType.INIT);
      expect(fsm.currentState.stateType).not().assertUndefined();
    })

    it('getState_test', 0, () => {
      let fsm: StateFsm = new SceneBoardCoreStateFsm();
      fsm.init();
      fsm.getState(StateType.INIT);
      expect(fsm.currentState.stateType).not().assertUndefined();
    })

    it('registerListener_test', 0, () => {
      let fsm: StateFsm = new SceneBoardCoreStateFsm();
      fsm.init();
      fsm.registerListener(new DTFsmListener());
      fsm.registerListener(new DTFsmListener());
      expect(fsm.currentState.stateType).not().assertUndefined();
    })

    it('unRegisterListener_test', 0, () => {
      let fsm: StateFsm = new SceneBoardCoreStateFsm();
      fsm.init();
      let listener = new DTFsmListener();
      fsm.unRegisterListener(listener);
      fsm.registerListener(listener);
      fsm.unRegisterListener(listener);
      expect(fsm.currentState.stateType).not().assertUndefined();
    })
  })
}

class DTState extends AbstractState {
  public handleEvent(event: CoreEventType, ...args: Object[]): StateType {
    return this.stateType;
  }

  public toString(): string {
    return 'DTState';
  }
}

class DTFsmListener extends FsmListener {
  onFsmStateChange(oldState: StateType, newState: StateType, event: CoreEventType): void {
  }

  getName(): string {
    return 'DTFsmListener';
  }
}