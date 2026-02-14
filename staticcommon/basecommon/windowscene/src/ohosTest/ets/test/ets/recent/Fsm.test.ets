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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { FSM, FSMEvent, FSMState, FSMTransition } from '../../../../../main/ets/recent/Fsm'

enum PanelState {
  HOME_STATE = 'HOME_STATE',
  RECENT_STATE = 'RECENT_STATE',
  APP_STATE = 'APP_STATE'
}

let states = new Map<string, FSMState>();

class HomeState extends FSMState {
  constructor() {
    super(PanelState.HOME_STATE);
  }

  public init(): void {
    let trans1 = FSMTransition.builder(new FSMEvent('EVENT_TO_HOME'), HomeState.getInstance());
    let trans2 = FSMTransition.builder(new FSMEvent('EVENT_TO_RECENT'), RecentState.getInstance());
    let trans3 = FSMTransition.builder(new FSMEvent('EVENT_TO_APP'), AppState.getInstance());
    let trans4 = FSMTransition.builder(new FSMEvent(FSMEvent.NULL), AppState.getInstance());
    this.addTransition(trans1).addTransition(trans2).addTransition(trans3).addTransition(trans4);
  }

  onEnter(): boolean {
    return true;
  }

  public static getInstance(): HomeState {
    if (!states.has(PanelState.HOME_STATE)) {
      states.set(PanelState.HOME_STATE, new HomeState());
    }
    return states.get(PanelState.HOME_STATE) as HomeState;
  }
}

class RecentState extends FSMState {
  constructor() {
    super(PanelState.RECENT_STATE);
  }

  public init(): void {
    let trans1 = FSMTransition.builder(new FSMEvent('EVENT_TO_HOME'), HomeState.getInstance());
    let trans2 = FSMTransition.builder(new FSMEvent('EVENT_TO_RECENT'), RecentState.getInstance());
    let trans3 = FSMTransition.builder(new FSMEvent('EVENT_TO_APP'), AppState.getInstance());
    this.addTransition(trans1).addTransition(trans2).addTransition(trans3)
  }

  public static getInstance(): RecentState {
    if (!states.has(PanelState.RECENT_STATE)) {
      states.set(PanelState.RECENT_STATE, new RecentState());
    }
    return states.get(PanelState.RECENT_STATE) as RecentState;
  }
}

class AppState extends FSMState {
  constructor() {
    super(PanelState.APP_STATE);
  }

  public init(): void {
    let trans1 = FSMTransition.builder(new FSMEvent('EVENT_TO_HOME'), HomeState.getInstance());
    let trans2 = FSMTransition.builder(new FSMEvent('EVENT_TO_RECENT'), RecentState.getInstance());
    let trans3 = FSMTransition.builder(new FSMEvent('EVENT_TO_APP'), AppState.getInstance());
    this.addTransition(trans1).addTransition(trans2).addTransition(trans3);
  }

  public static getInstance(): AppState {
    if (!states.has(PanelState.APP_STATE)) {
      states.set(PanelState.APP_STATE, new AppState());
    }
    return states.get(PanelState.APP_STATE) as AppState;
  }
}

export default function RecentFsmTest() {
  describe('RecentFsmTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    });
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    });
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    });
    it('stateInit', 0, () => {
      let homeState = new HomeState();
      homeState.init();
      expect(homeState.toString()).assertEqual(PanelState.HOME_STATE);
      expect(homeState.equalTo(homeState)).assertTrue();
      expect(homeState.can(FSMEvent.NULL)).assertTrue;
    });
    it('stateCan', 0, () => {
      let homeState = HomeState.getInstance();
      homeState.init();
      expect(homeState.can(FSMEvent.NULL)).assertTrue;
      expect(homeState.can('EVENT_TO_APP')).assertTrue;
      expect(homeState.can('EVENT_TO_RECENT')).assertTrue;
    });

    it('stateTransfer', 0, () => {
      let homeState = HomeState.getInstance();
      homeState.init();
      let nextState = homeState.transfer('EVENT_TO_RECENT');
      expect(nextState.equalTo(RecentState.getInstance())).assertTrue();
    });
    it('stateAutoTransfer', 0, () => {
      let recentState = RecentState.getInstance();
      recentState.init();
      let nextState = recentState.transfer('EVENT_TO_HOME');
      expect(nextState.equalTo(AppState.getInstance())).assertTrue();
    });
    it('stateTransferWithFsm', 0, () => {
      let homeState = HomeState.getInstance();
      homeState.init();

      let recentState = RecentState.getInstance();
      recentState.init();

      let appState = AppState.getInstance();
      appState.init();

      let fsm = new FSM('testFSM');
      fsm.addState(homeState).addState(recentState).addState(appState);
      fsm.currentState = homeState;

      homeState.attachToFsm(fsm);
      recentState.attachToFsm(fsm);
      appState.attachToFsm(fsm);

      let nextState = homeState.transfer('EVENT_TO_RECENT');
      expect(nextState.equalTo(RecentState.getInstance())).assertTrue();
      expect(fsm.currentState.equalTo(RecentState.getInstance())).assertTrue();
    });
    it('transitionsNotEqualWithDiffEvent', 0, () => {
      let trans1 = FSMTransition.builder(new FSMEvent('EVENT_TO_HOME'), HomeState.getInstance(), () => {
        return false;
      });
      let trans2 = FSMTransition.builder(new FSMEvent('EVENT_TO_HOME'), HomeState.getInstance(), () => {
        return true;
      });
      expect(trans1.equalTo(trans2)).assertFalse();
    });
    it('transitionsNotEqualWithSameEvent', 0, () => {
      let event = new FSMEvent('EVENT_TO_HOME');
      let trans1 = FSMTransition.builder(event, HomeState.getInstance(), () => {
        return false;
      });
      let trans2 = FSMTransition.builder(event, HomeState.getInstance(), () => {
        return true;
      });
      expect(trans1.equalTo(trans2)).assertFalse();
    });
    it('transitionsEqual', 0, () => {
      let event = new FSMEvent('EVENT_TO_HOME');
      let judge = () => {
        return true;
      }
      let trans1 = FSMTransition.builder(event, HomeState.getInstance(), judge);
      let trans2 = FSMTransition.builder(event, HomeState.getInstance(), judge);
      expect(trans1.equalTo(trans2)).assertTrue();
    });
    it('transitionsDoJudge', 0, () => {
      let event = new FSMEvent('EVENT_TO_HOME');
      let judge = () => {
        return true;
      }
      let trans1 = FSMTransition.builder(event, HomeState.getInstance(), judge);
      expect(trans1.doJudge()).assertTrue();
    });
    it('transitionsGetNextState', 0, () => {
      let event = new FSMEvent('EVENT_TO_HOME');
      let judge = () => {
        return true;
      }
      let trans1 = FSMTransition.builder(event, HomeState.getInstance(), judge);
      expect(trans1.getNextState().equalTo(HomeState.getInstance())).assertTrue();
    });
    it('eventOnReturnTrue', 0, () => {
      let eventToHome = new FSMEvent('EVENT_TO_HOME');
      let judge = () => {
        return true;
      }
      let homeState = new HomeState();
      let recentState = new RecentState();
      let trans1 = FSMTransition.builder(eventToHome, homeState, judge);
      recentState.addTransition(trans1);
      let nextState = recentState.transfer(eventToHome.toString());

      expect(nextState.equalTo(homeState)).assertTrue();
    });
    it('fsmGetState', 0, () => {
      let homeState = HomeState.getInstance();
      homeState.init();

      let recentState = RecentState.getInstance();
      recentState.init();

      let appState = AppState.getInstance();
      appState.init();

      let fsm = new FSM('testFSM');
      fsm.addState(homeState).addState(recentState).addState(appState);
      fsm.currentState = homeState;

      let state = fsm.getState(PanelState.HOME_STATE);
      expect(state != null).assertTrue();
      state = state as HomeState;
      expect(state.toString()).assertEqual(PanelState.HOME_STATE);
    });
    it('fsmAttachNoCan', 0, () => {
      let homeState = HomeState.getInstance();
      homeState.init();

      let recentState = RecentState.getInstance();
      recentState.init();

      let appState = AppState.getInstance();
      appState.init();

      let fsm = new FSM('testFSM');
      fsm.addState(homeState).addState(recentState).addState(appState);
      fsm.currentState = homeState;
      homeState.attachToFsm(fsm);

      expect(fsm.can(new FSMEvent('EVENT_TO_RECENT'))).assertFalse();
      expect(fsm.can(new FSMEvent('EVENT_TO_APP'))).assertFalse();
      expect(fsm.can('EVENT_INVALID')).assertFalse();
    });

    it('fsmCan', 0, () => {
      let homeState = HomeState.getInstance();
      homeState.init();

      let recentState = RecentState.getInstance();
      recentState.init();

      let appState = AppState.getInstance();
      appState.init();

      let fsm = new FSM('testFSM');
      fsm.addState(homeState).addState(recentState).addState(appState);
      fsm.currentState = homeState;

      homeState.attachToFsm(fsm);

      expect(fsm.can('EVENT_TO_RECENT')).assertTrue();
      expect(fsm.can('EVENT_TO_APP')).assertTrue();
      expect(fsm.can('EVENT_INVALID')).assertFalse();
    });
    it('fsmTransfer', 0, () => {
      let homeState = HomeState.getInstance();
      homeState.init();

      let recentState = RecentState.getInstance();
      recentState.init();

      let appState = AppState.getInstance();
      appState.init();

      let fsm = new FSM('testFSM');
      fsm.addState(homeState).addState(recentState).addState(appState);
      fsm.currentState = homeState;

      homeState.attachToFsm(fsm);
      recentState.attachToFsm(fsm);
      appState.attachToFsm(fsm);

      expect(fsm.currentState.toString()).assertEqual(PanelState.HOME_STATE)
      let ret = fsm.transfer('EVENT_TO_RECENT');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.RECENT_STATE)
      ret = fsm.transfer('EVENT_TO_HOME');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.APP_STATE)
      ret = fsm.transfer('EVENT_TO_HOME');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.APP_STATE)
    });
    it('fsmTransfer_copy_01', 0, () => {
      let homeState = HomeState.getInstance();
      homeState.init();

      let recentState = RecentState.getInstance();
      recentState.init();

      let appState = AppState.getInstance();
      appState.init();

      let fsm = new FSM('testFSM');
      fsm.addState(homeState).addState(recentState).addState(appState);
      fsm.currentState = homeState;

      homeState.attachToFsm(fsm);
      recentState.attachToFsm(fsm);
      appState.attachToFsm(fsm);

      expect(fsm.currentState.toString()).assertEqual(PanelState.HOME_STATE)
      let ret = fsm.transfer('EVENT_TO_RECENT');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.RECENT_STATE)
      ret = fsm.transfer('EVENT_TO_HOME');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.APP_STATE)
      ret = fsm.transfer('EVENT_TO_HOME');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.APP_STATE)
    });

    it('fsmTransfer_copy_02', 0, () => {
      let homeState = HomeState.getInstance();
      homeState.init();

      let recentState = RecentState.getInstance();
      recentState.init();

      let appState = AppState.getInstance();
      appState.init();

      let fsm = new FSM('testFSM');
      fsm.addState(homeState).addState(recentState).addState(appState);
      fsm.currentState = homeState;

      homeState.attachToFsm(fsm);
      recentState.attachToFsm(fsm);
      appState.attachToFsm(fsm);

      expect(fsm.currentState.toString()).assertEqual(PanelState.HOME_STATE)
      let ret = fsm.transfer('EVENT_TO_RECENT');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.RECENT_STATE)
      ret = fsm.transfer('EVENT_TO_HOME');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.APP_STATE)
      ret = fsm.transfer('EVENT_TO_HOME');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.APP_STATE)
    });

    it('fsmTransfer_copy_03', 0, () => {
      let homeState = HomeState.getInstance();
      homeState.init();

      let recentState = RecentState.getInstance();
      recentState.init();

      let appState = AppState.getInstance();
      appState.init();

      let fsm = new FSM('testFSM');
      fsm.addState(homeState).addState(recentState).addState(appState);
      fsm.currentState = homeState;

      homeState.attachToFsm(fsm);
      recentState.attachToFsm(fsm);
      appState.attachToFsm(fsm);

      expect(fsm.currentState.toString()).assertEqual(PanelState.HOME_STATE)
      let ret = fsm.transfer('EVENT_TO_RECENT');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.RECENT_STATE)
      ret = fsm.transfer('EVENT_TO_HOME');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.APP_STATE)
      ret = fsm.transfer('EVENT_TO_HOME');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.APP_STATE)
    });

    it('fsmTransfer_copy_04', 0, () => {
      let homeState = HomeState.getInstance();
      homeState.init();

      let recentState = RecentState.getInstance();
      recentState.init();

      let appState = AppState.getInstance();
      appState.init();

      let fsm = new FSM('testFSM');
      fsm.addState(homeState).addState(recentState).addState(appState);
      fsm.currentState = homeState;

      homeState.attachToFsm(fsm);
      recentState.attachToFsm(fsm);
      appState.attachToFsm(fsm);

      expect(fsm.currentState.toString()).assertEqual(PanelState.HOME_STATE)
      let ret = fsm.transfer('EVENT_TO_RECENT');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.RECENT_STATE)
      ret = fsm.transfer('EVENT_TO_HOME');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.APP_STATE)
      ret = fsm.transfer('EVENT_TO_HOME');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.APP_STATE)
    });

    it('fsmTransfer_copy_05', 0, () => {
      let homeState = HomeState.getInstance();
      homeState.init();

      let recentState = RecentState.getInstance();
      recentState.init();

      let appState = AppState.getInstance();
      appState.init();

      let fsm = new FSM('testFSM');
      fsm.addState(homeState).addState(recentState).addState(appState);
      fsm.currentState = homeState;

      homeState.attachToFsm(fsm);
      recentState.attachToFsm(fsm);
      appState.attachToFsm(fsm);

      expect(fsm.currentState.toString()).assertEqual(PanelState.HOME_STATE)
      let ret = fsm.transfer('EVENT_TO_RECENT');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.RECENT_STATE)
      ret = fsm.transfer('EVENT_TO_HOME');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.APP_STATE)
      ret = fsm.transfer('EVENT_TO_HOME');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.APP_STATE)
    });

    it('fsmTransfer_copy_06', 0, () => {
      let homeState = HomeState.getInstance();
      homeState.init();

      let recentState = RecentState.getInstance();
      recentState.init();

      let appState = AppState.getInstance();
      appState.init();

      let fsm = new FSM('testFSM');
      fsm.addState(homeState).addState(recentState).addState(appState);
      fsm.currentState = homeState;

      homeState.attachToFsm(fsm);
      recentState.attachToFsm(fsm);
      appState.attachToFsm(fsm);

      expect(fsm.currentState.toString()).assertEqual(PanelState.HOME_STATE)
      let ret = fsm.transfer('EVENT_TO_RECENT');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.RECENT_STATE)
      ret = fsm.transfer('EVENT_TO_HOME');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.APP_STATE)
      ret = fsm.transfer('EVENT_TO_HOME');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.APP_STATE)
    });

    it('fsmTransfer_copy_07', 0, () => {
      let homeState = HomeState.getInstance();
      homeState.init();

      let recentState = RecentState.getInstance();
      recentState.init();

      let appState = AppState.getInstance();
      appState.init();

      let fsm = new FSM('testFSM');
      fsm.addState(homeState).addState(recentState).addState(appState);
      fsm.currentState = homeState;

      homeState.attachToFsm(fsm);
      recentState.attachToFsm(fsm);
      appState.attachToFsm(fsm);

      expect(fsm.currentState.toString()).assertEqual(PanelState.HOME_STATE)
      let ret = fsm.transfer('EVENT_TO_RECENT');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.RECENT_STATE)
      ret = fsm.transfer('EVENT_TO_HOME');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.APP_STATE)
      ret = fsm.transfer('EVENT_TO_HOME');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.APP_STATE)
    });

    it('fsmTransfer_copy_08', 0, () => {
      let homeState = HomeState.getInstance();
      homeState.init();

      let recentState = RecentState.getInstance();
      recentState.init();

      let appState = AppState.getInstance();
      appState.init();

      let fsm = new FSM('testFSM');
      fsm.addState(homeState).addState(recentState).addState(appState);
      fsm.currentState = homeState;

      homeState.attachToFsm(fsm);
      recentState.attachToFsm(fsm);
      appState.attachToFsm(fsm);

      expect(fsm.currentState.toString()).assertEqual(PanelState.HOME_STATE)
      let ret = fsm.transfer('EVENT_TO_RECENT');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.RECENT_STATE)
      ret = fsm.transfer('EVENT_TO_HOME');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.APP_STATE)
      ret = fsm.transfer('EVENT_TO_HOME');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.APP_STATE)
    });

    it('fsmTransfer_copy_09', 0, () => {
      let homeState = HomeState.getInstance();
      homeState.init();

      let recentState = RecentState.getInstance();
      recentState.init();

      let appState = AppState.getInstance();
      appState.init();

      let fsm = new FSM('testFSM');
      fsm.addState(homeState).addState(recentState).addState(appState);
      fsm.currentState = homeState;

      homeState.attachToFsm(fsm);
      recentState.attachToFsm(fsm);
      appState.attachToFsm(fsm);

      expect(fsm.currentState.toString()).assertEqual(PanelState.HOME_STATE)
      let ret = fsm.transfer('EVENT_TO_RECENT');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.RECENT_STATE)
      ret = fsm.transfer('EVENT_TO_HOME');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.APP_STATE)
      ret = fsm.transfer('EVENT_TO_HOME');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.APP_STATE)
    });

    it('fsmTransfer_copy_10', 0, () => {
      let homeState = HomeState.getInstance();
      homeState.init();

      let recentState = RecentState.getInstance();
      recentState.init();

      let appState = AppState.getInstance();
      appState.init();

      let fsm = new FSM('testFSM');
      fsm.addState(homeState).addState(recentState).addState(appState);
      fsm.currentState = homeState;

      homeState.attachToFsm(fsm);
      recentState.attachToFsm(fsm);
      appState.attachToFsm(fsm);

      expect(fsm.currentState.toString()).assertEqual(PanelState.HOME_STATE)
      let ret = fsm.transfer('EVENT_TO_RECENT');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.RECENT_STATE)
      ret = fsm.transfer('EVENT_TO_HOME');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.APP_STATE)
      ret = fsm.transfer('EVENT_TO_HOME');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.APP_STATE)
    });

    it('fsmTransfer_copy_11', 0, () => {
      let homeState = HomeState.getInstance();
      homeState.init();

      let recentState = RecentState.getInstance();
      recentState.init();

      let appState = AppState.getInstance();
      appState.init();

      let fsm = new FSM('testFSM');
      fsm.addState(homeState).addState(recentState).addState(appState);
      fsm.currentState = homeState;

      homeState.attachToFsm(fsm);
      recentState.attachToFsm(fsm);
      appState.attachToFsm(fsm);

      expect(fsm.currentState.toString()).assertEqual(PanelState.HOME_STATE)
      let ret = fsm.transfer('EVENT_TO_RECENT');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.RECENT_STATE)
      ret = fsm.transfer('EVENT_TO_HOME');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.APP_STATE)
      ret = fsm.transfer('EVENT_TO_HOME');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.APP_STATE)
    });

    it('fsmTransfer_copy_12', 0, () => {
      let homeState = HomeState.getInstance();
      homeState.init();

      let recentState = RecentState.getInstance();
      recentState.init();

      let appState = AppState.getInstance();
      appState.init();

      let fsm = new FSM('testFSM');
      fsm.addState(homeState).addState(recentState).addState(appState);
      fsm.currentState = homeState;

      homeState.attachToFsm(fsm);
      recentState.attachToFsm(fsm);
      appState.attachToFsm(fsm);

      expect(fsm.currentState.toString()).assertEqual(PanelState.HOME_STATE)
      let ret = fsm.transfer('EVENT_TO_RECENT');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.RECENT_STATE)
      ret = fsm.transfer('EVENT_TO_HOME');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.APP_STATE)
      ret = fsm.transfer('EVENT_TO_HOME');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.APP_STATE)
    });

    it('fsmTransfer_copy_13', 0, () => {
      let homeState = HomeState.getInstance();
      homeState.init();

      let recentState = RecentState.getInstance();
      recentState.init();

      let appState = AppState.getInstance();
      appState.init();

      let fsm = new FSM('testFSM');
      fsm.addState(homeState).addState(recentState).addState(appState);
      fsm.currentState = homeState;

      homeState.attachToFsm(fsm);
      recentState.attachToFsm(fsm);
      appState.attachToFsm(fsm);

      expect(fsm.currentState.toString()).assertEqual(PanelState.HOME_STATE)
      let ret = fsm.transfer('EVENT_TO_RECENT');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.RECENT_STATE)
      ret = fsm.transfer('EVENT_TO_HOME');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.APP_STATE)
      ret = fsm.transfer('EVENT_TO_HOME');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.APP_STATE)
    });

    it('fsmTransfer_copy_14', 0, () => {
      let homeState = HomeState.getInstance();
      homeState.init();

      let recentState = RecentState.getInstance();
      recentState.init();

      let appState = AppState.getInstance();
      appState.init();

      let fsm = new FSM('testFSM');
      fsm.addState(homeState).addState(recentState).addState(appState);
      fsm.currentState = homeState;

      homeState.attachToFsm(fsm);
      recentState.attachToFsm(fsm);
      appState.attachToFsm(fsm);

      expect(fsm.currentState.toString()).assertEqual(PanelState.HOME_STATE)
      let ret = fsm.transfer('EVENT_TO_RECENT');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.RECENT_STATE)
      ret = fsm.transfer('EVENT_TO_HOME');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.APP_STATE)
      ret = fsm.transfer('EVENT_TO_HOME');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.APP_STATE)
    });

    it('fsmTransfer_copy_15', 0, () => {
      let homeState = HomeState.getInstance();
      homeState.init();

      let recentState = RecentState.getInstance();
      recentState.init();

      let appState = AppState.getInstance();
      appState.init();

      let fsm = new FSM('testFSM');
      fsm.addState(homeState).addState(recentState).addState(appState);
      fsm.currentState = homeState;

      homeState.attachToFsm(fsm);
      recentState.attachToFsm(fsm);
      appState.attachToFsm(fsm);

      expect(fsm.currentState.toString()).assertEqual(PanelState.HOME_STATE)
      let ret = fsm.transfer('EVENT_TO_RECENT');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.RECENT_STATE)
      ret = fsm.transfer('EVENT_TO_HOME');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.APP_STATE)
      ret = fsm.transfer('EVENT_TO_HOME');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.APP_STATE)
    });

    it('fsmTransfer_copy_16', 0, () => {
      let homeState = HomeState.getInstance();
      homeState.init();

      let recentState = RecentState.getInstance();
      recentState.init();

      let appState = AppState.getInstance();
      appState.init();

      let fsm = new FSM('testFSM');
      fsm.addState(homeState).addState(recentState).addState(appState);
      fsm.currentState = homeState;

      homeState.attachToFsm(fsm);
      recentState.attachToFsm(fsm);
      appState.attachToFsm(fsm);

      expect(fsm.currentState.toString()).assertEqual(PanelState.HOME_STATE)
      let ret = fsm.transfer('EVENT_TO_RECENT');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.RECENT_STATE)
      ret = fsm.transfer('EVENT_TO_HOME');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.APP_STATE)
      ret = fsm.transfer('EVENT_TO_HOME');
      expect(ret != null).assertTrue();
      expect(fsm.currentState.toString()).assertEqual(PanelState.APP_STATE)
    });
  });
}