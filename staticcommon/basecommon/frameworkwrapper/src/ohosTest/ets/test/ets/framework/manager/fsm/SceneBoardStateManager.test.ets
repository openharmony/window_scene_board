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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { SceneBoardCoreStateFsm } from '../../../../../../../main/ets/manager/fsm/SceneBoardCoreStateFsm';
import { CoreEventType, FsmName, StateType } from '../../../../../../../main/ets/manager/fsm/SceneBoardStateConfig';
import { SceneBoardStateManager } from '../../../../../../../main/ets/manager/fsm/SceneBoardStateManager';
import { AbstractState, FsmListener, StateFsm } from '../../../../../../../main/ets/manager/fsm/StateFsm';

export function SceneBoardStateManagerTest() {
  describe('SceneBoardStateManagerTest', () => {
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

    it('consumeEvent_test', 0, () => {
      let sceneBoardStateManager: SceneBoardStateManager = SceneBoardStateManager.getInstance();
      sceneBoardStateManager.init();
      sceneBoardStateManager.consumeEvent(CoreEventType.ENTER_DESKTOP);
      expect(sceneBoardStateManager).not().assertUndefined();
    })

    it('registerFsm_test_01', 0, () => {
      let sceneBoardStateManager: SceneBoardStateManager = SceneBoardStateManager.getInstance();
      sceneBoardStateManager.init();
      let fsm: StateFsm = new SceneBoardCoreStateFsm();
      sceneBoardStateManager.registerFsm(fsm);
      expect(sceneBoardStateManager).not().assertUndefined();
    })

    it('registerFsm_test_02', 0, () => {
      let sceneBoardStateManager: SceneBoardStateManager = SceneBoardStateManager.getInstance();
      sceneBoardStateManager.init();
      let fsm: StateFsm = new DTStateFsm(FsmName.SCREEN_LOCK_FSM);
      sceneBoardStateManager.registerFsm(fsm);
      expect(sceneBoardStateManager).not().assertUndefined();
    })

    it('registerStateChange_test_01', 0, () => {
      let sceneBoardStateManager: SceneBoardStateManager = SceneBoardStateManager.getInstance();
      sceneBoardStateManager.init();
      let fsm: StateFsm = new DTStateFsm(FsmName.SCREEN_LOCK_FSM);
      sceneBoardStateManager.registerFsm(fsm);
      sceneBoardStateManager.registerStateChange(FsmName.SCREEN_LOCK_FSM, new DTFsmListener());
      expect(sceneBoardStateManager).not().assertUndefined();
    })

    it('registerStateChange_test_02', 0, () => {
      let sceneBoardStateManager: SceneBoardStateManager = SceneBoardStateManager.getInstance();
      sceneBoardStateManager.init();
      let fsm: StateFsm = new DTStateFsm(FsmName.SCREEN_LOCK_FSM);
      sceneBoardStateManager.registerFsm(fsm);
      sceneBoardStateManager.registerStateChange(FsmName.AOD_FSM, new DTFsmListener());
      expect(sceneBoardStateManager).not().assertUndefined();
    })

    it('unRegisterStateChange_test_01', 0, () => {
      let sceneBoardStateManager: SceneBoardStateManager = SceneBoardStateManager.getInstance();
      sceneBoardStateManager.init();
      let fsm: StateFsm = new DTStateFsm(FsmName.SCREEN_LOCK_FSM);
      sceneBoardStateManager.registerFsm(fsm);
      let listener: FsmListener = new DTFsmListener();
      sceneBoardStateManager.registerStateChange(FsmName.SCREEN_LOCK_FSM, listener);
      sceneBoardStateManager.unRegisterStateChange(FsmName.SCREEN_LOCK_FSM, listener);
      expect(sceneBoardStateManager).not().assertUndefined();
    })

    it('unRegisterStateChange_test_02', 0, () => {
      let sceneBoardStateManager: SceneBoardStateManager = SceneBoardStateManager.getInstance();
      sceneBoardStateManager.init();
      let listener: FsmListener = new DTFsmListener();
      sceneBoardStateManager.unRegisterStateChange(FsmName.AOD_FSM, listener);
      expect(sceneBoardStateManager).not().assertUndefined();
    })

    it('getCurrentState_test_01', 0, () => {
      let sceneBoardStateManager: SceneBoardStateManager = SceneBoardStateManager.getInstance();
      sceneBoardStateManager.init();
      let fsm: StateFsm = new DTStateFsm(FsmName.SCREEN_LOCK_FSM);
      sceneBoardStateManager.registerFsm(fsm);
      sceneBoardStateManager.getCurrentState(FsmName.SCREEN_LOCK_FSM);
      expect(sceneBoardStateManager).not().assertUndefined();
    })

    it('getCurrentState_test_02', 0, () => {
      let sceneBoardStateManager: SceneBoardStateManager = SceneBoardStateManager.getInstance();
      sceneBoardStateManager.init();
      sceneBoardStateManager.getCurrentState(FsmName.AOD_FSM);
      expect(sceneBoardStateManager).not().assertUndefined();
    })
  })
}

class DTStateFsm extends StateFsm {
  constructor(name: FsmName) {
    super(name, new DTState(StateType.INIT));
  }

  public init(): void {
  }
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