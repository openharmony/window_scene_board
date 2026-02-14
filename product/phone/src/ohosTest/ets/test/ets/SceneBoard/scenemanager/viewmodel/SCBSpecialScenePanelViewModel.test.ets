/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBScreenProperty } from '@ohos/windowscene';
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  describe,
  beforeAll,
  it,
  Level,
  beforeEach,
  afterEach,
  afterAll,
  expect,
  MockKit,
  ArgumentMatchers,
  when
} from '@ohos/hypium';
import { RotationConstants } from '@ohos/commonconstants';
import {
  SCBSpecialScenePanelViewModel,
  SpecialScenePanelStateCollectionHandler
} from '@ohos/phonebase/src/main/ets/SceneBoard/scenemanager/viewmodel/SCBSpecialScenePanelViewModel';
import {
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneMode,
  SCBSceneSession,
  SCBSceneSessionManager,
  RecentViewParam,
  SCBKeyboardSession,
  KeyboardChangeCallback,
  SCBSceneContainerSessionArray,
  SCBTransitionController
} from '@ohos/windowscene';
import { ReflectionUtils } from '../multiwindow/ReflectionUtils';
import { DeviceState } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { SCBSpecialScenePanelAnimator } from '@ohos/phonebase/src/main/ets/SceneBoard/scenemanager/viewanimator/SCBSpecialScenePanelAnimator';

const MOCK_TAG = 'SCBSpecialScenePanelViewModel';
const mockLog = LogHelper.getLogHelper(LogDomain.WINDOW, MOCK_TAG);

let handlerViewParam: RecentViewParam;
let handlerStates: ScenePanelState;
let blackBackgroundState: boolean;
const panelStateCollectionHandler: SpecialScenePanelStateCollectionHandler = {
  getPanelState: (): ScenePanelState => {
    return handlerStates;
  },

  updatePanelState: (state: ScenePanelState) => {
    handlerStates = state;
  },

  getViewParam: (): RecentViewParam => {
    return handlerViewParam;
  },
  getPanelName: (): string => {
    return '';
  },

  getScreenRotationAnimCnt: (): number => {
    return 0;
  },

  updateBlackBackgroundState: (state: boolean): void => {
    blackBackgroundState = state;
  },

  getMattesLockState: (): boolean => {
    return true;
  },

  getFoldStatus: (): number => {
    return DeviceState.DEFAULT_STATE;
  },
  getShowCompanionIconState: (): boolean => {
    return true;
  },
  updateShowCompanionIconState: (isShowCompanionIcon: boolean): void => {
  }
}
let keyboardChangeCallbackMap: Map<string, KeyboardChangeCallback> = new Map<string, KeyboardChangeCallback>();
let keyboardChangeListenerList: Array<KeyboardChangeCallback> = new Array();

enum ScenePanelState {
  HOME,
  FULLSCENE,
  RECENT
}

export default function SCBSpecialScenePanelViewModelTest() {

  describe('SCBSpecialScenePanelViewModel_getContainerSessionList_testSuite', (): void => {
    let screenProperty: SCBScreenProperty;
    let phyScreenProperty: SCBScreenProperty;
    let viewModel: SCBSpecialScenePanelViewModel;

    beforeAll(() => {
      screenProperty = new SCBScreenProperty();
      phyScreenProperty = new SCBScreenProperty();
      viewModel = new SCBSpecialScenePanelViewModel(screenProperty, phyScreenProperty);
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('should_not_null_when_after_viewModel_init', Level.LEVEL0, () => {
      expect(viewModel.getContainerSessionList().isEmpty()).assertTrue();
    });
  });

  describe('SCBSpecialScenePanelViewModel_getSceneSessionByPersistentId_testSuite', (): void => {
    let screenProperty: SCBScreenProperty;
    let phyScreenProperty: SCBScreenProperty;
    let viewModel: SCBSpecialScenePanelViewModel;

    beforeAll(() => {
      screenProperty = new SCBScreenProperty();
      phyScreenProperty = new SCBScreenProperty();
      viewModel = new SCBSpecialScenePanelViewModel(screenProperty, phyScreenProperty);
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('should_return_null_when_after_viewModel_init', Level.LEVEL0, () => {
      expect(viewModel.getSceneSessionByPersistentId(1)).assertNull();
    });
  });

  describe('SCBSpecialScenePanelViewModel_getSceneContainerSessionWithContainerId_testSuite', (): void => {
    let screenProperty: SCBScreenProperty;
    let phyScreenProperty: SCBScreenProperty;
    let viewModel: SCBSpecialScenePanelViewModel;

    beforeAll(() => {
      screenProperty = new SCBScreenProperty();
      phyScreenProperty = new SCBScreenProperty();
      viewModel = new SCBSpecialScenePanelViewModel(screenProperty, phyScreenProperty);
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('should_return_null_when_after_viewModel_init', Level.LEVEL0, () => {
      expect(viewModel.getSceneContainerSessionWithContainerId(1)).assertNull();
    });
  })

  describe('SCBSpecialScenePanelViewModel_updateScenePanelState_testSuite', (): void => {
    let mocker: MockKit;
    let states: ScenePanelState;
    let scbSpecialScenePanelViewModel: SCBSpecialScenePanelViewModel;
    beforeAll(() => {
      mocker = new MockKit();
      scbSpecialScenePanelViewModel =
        new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
      states = ScenePanelState.HOME;
      let sceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 12345);
      let keyboardSession = new SCBKeyboardSession(sceneSessionManager.requestSceneSession(sceneInfo),
        () => {}, keyboardChangeCallbackMap, keyboardChangeListenerList);
      scbSpecialScenePanelViewModel.init(keyboardSession, panelStateCollectionHandler);
      scbSpecialScenePanelViewModel.updateScenePanelState(ScenePanelState.HOME);
    });

    afterAll(() => {
      SCBSceneSessionManager.getInstance().unRegisterFullSceneEndCallback();
    });

    /**
     * 用例描述: 根据state与sceneInfo判断是否更新panelState
     * 预置条件: 注册panelStateCollectionHandler函数
     * 测试场景: 当state未改变，不调用updateKeyguardOccludedState
     * 预期结果: 不更新keyguardOccludedState
     */
    it('test_notCallUpdateKeyguardOccludedStateWhenStateDoesNotChange_returnNull', Level.LEVEL0, async () => {
      let mockLogShowInfo: Function = mocker.mockFunc(mockLog, mockLog.showInfo);
      when(mockLogShowInfo)(ArgumentMatchers.any).afterReturnNothing();

      // 更新state
      scbSpecialScenePanelViewModel.updateScenePanelState(ScenePanelState.HOME);

      expect(states).assertEqual(ScenePanelState.HOME);
      mocker.verify('showInfo', ['updateKeyguardOccludedState sceneFlag: 1, occluded: false']).never();
      mocker.ignoreMock(mockLog, mockLog.showInfo);
    });

    /**
     * 用例描述: 根据state与sceneInfo判断是否更新panelState
     * 预置条件: 存在sceneInfo且已注册panelStateCollectionHandler函数
     * 测试场景: 当state改变，调用updateKeyguardOccludedState
     * 预期结果: 更新keyguardOccludedState
     */
    it('test_updateStateAndCallUpdateKeyguardOccludedStateWhenStateChanges_returnNull', Level.LEVEL0, () => {
      let sceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 123);

      // 更新state
      states = ScenePanelState.HOME;
      scbSpecialScenePanelViewModel.updateScenePanelState(ScenePanelState.RECENT, sceneInfo);

      expect(panelStateCollectionHandler.getPanelState()).assertEqual(ScenePanelState.RECENT);
    });

    /**
     * 用例描述: 根据state与sceneInfo判断是否更新panelState
     * 预置条件: 存在sceneInfo且state是全屏
     * 测试场景: 存在sceneInfo且state是全屏，是否调用fullSceneEndCallback回调函数
     * 预期结果: 调用updateFullSceneEnd
     */
    it('test_callUpdateFullSceneEndWhenSceneInfoIsProvidedAndStateIsFULLSCENE_returnNull', Level.LEVEL0, () => {
      let fullSceneIsCalled = false;
      let sceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 123);
      const fullSceneCallback = () => {
        fullSceneIsCalled = true;
      }

      // 注册全屏回调函数
      SCBSceneSessionManager.getInstance().registerFullSceneEndCallback(fullSceneCallback);

      // 更新state
      states = ScenePanelState.FULLSCENE;
      scbSpecialScenePanelViewModel.updateScenePanelState(ScenePanelState.FULLSCENE, sceneInfo);

      expect(states).assertEqual(ScenePanelState.FULLSCENE);
      expect(fullSceneIsCalled).assertTrue();
    });

    /**
     * 用例描述: 根据state与sceneInfo判断是否更新panelState
     * 预置条件: 不存在sceneInfo且state是全屏
     * 测试场景: 不存在sceneInfo且state是全屏，是否调用fullSceneEndCallback回调函数
     * 预期结果: 不调用updateFullSceneEnd
     */
    it('test_notCallUpdateFullSceneEndWhenSceneInfoIsNotProvidedAndStateIsFullScene_returnNull', Level.LEVEL0,
      async () => {
        let fullSceneIsCalled = false;
        const fullSceneCallback = () => {
          fullSceneIsCalled = true;
        }

        // 注册全屏回调函数
        SCBSceneSessionManager.getInstance().registerFullSceneEndCallback(fullSceneCallback);

        // 更新state
        scbSpecialScenePanelViewModel.updateScenePanelState(ScenePanelState.FULLSCENE);

        expect(states).assertEqual(ScenePanelState.FULLSCENE);
        expect(fullSceneIsCalled).assertFalse();
      });

    /**
     * 用例描述: 根据state与sceneInfo判断是否更新panelState
     * 预置条件: 不存在sceneInfo且state不是全屏
     * 测试场景: 不存在sceneInfo且state不是全屏，是否调用fullSceneEndCallback回调函数
     * 预期结果: 不调用updateFullSceneEnd
     */
    it('test_notCallUpdateFullSceneEndWhenSceneInfoIsNotProvidedAndStateIsNotFullscene_returnNull', Level.LEVEL0,
      async () => {
        let fullSceneIsCalled = false;
        const fullSceneCallback = () => {
          fullSceneIsCalled = true;
        }

        // 注册全屏回调函数
        SCBSceneSessionManager.getInstance().registerFullSceneEndCallback(fullSceneCallback);

        // 更新state
        scbSpecialScenePanelViewModel.updateScenePanelState(ScenePanelState.RECENT);

        expect(panelStateCollectionHandler.getPanelState()).assertEqual(ScenePanelState.RECENT);
        expect(fullSceneIsCalled).assertFalse();
      });
  });

  describe('SCBSpecialScenePanelViewModel_getSceneContainerSessionWithPersistentId_testSuite', (): void => {
    let screenProperty: SCBScreenProperty;
    let phyScreenProperty: SCBScreenProperty;
    let viewModel: SCBSpecialScenePanelViewModel;

    beforeAll(() => {
      screenProperty = new SCBScreenProperty();
      phyScreenProperty = new SCBScreenProperty();
      viewModel = new SCBSpecialScenePanelViewModel(screenProperty, phyScreenProperty);
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('should_return_null_when_after_viewModel_init', Level.LEVEL0, () => {
      expect(viewModel.getSceneContainerSessionWithPersistentId(1)).assertNull();
    });
  });

  describe('SCBSpecialScenePanelViewModel_getContainerSessionByPersistentIdOrContainerId_testSuite', (): void => {
    let screenProperty: SCBScreenProperty;
    let phyScreenProperty: SCBScreenProperty;
    let viewModel: SCBSpecialScenePanelViewModel;

    beforeAll(() => {
      screenProperty = new SCBScreenProperty();
      phyScreenProperty = new SCBScreenProperty();
      viewModel = new SCBSpecialScenePanelViewModel(screenProperty, phyScreenProperty);
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('should_return_null_when_after_viewModel_init', Level.LEVEL0, () => {
      expect(viewModel.getContainerSessionByPersistentIdOrContainerId()).assertNull();
    });
  });

  describe('SCBSpecialScenePanelViewModel_createSceneSession_testSuite', () => {
    let mocker: MockKit;
    let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 9527);
    let sdkSceneSession = sceneSessionManager.requestSceneSession(sceneInfo);
    let scbSpecialScenePanelViewModel: SCBSpecialScenePanelViewModel;

    beforeAll(() => {
      mocker = new MockKit();
      scbSpecialScenePanelViewModel =
        new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
    });

    afterAll(() => {
    });

    it('should_return_null_when_after_viewModel_init', Level.LEVEL0, async () => {
      expect(scbSpecialScenePanelViewModel.getSceneSessionByPersistentId(1)).assertNull();
    });
  });

  describe('getSceneContainerSessionWithContainerId_testSuite', (): void => {
    let screenProperty: SCBScreenProperty;
    let phyScreenProperty: SCBScreenProperty;
    let viewModel: SCBSpecialScenePanelViewModel;

    beforeAll(() => {
      screenProperty = new SCBScreenProperty();
      phyScreenProperty = new SCBScreenProperty();
      viewModel = new SCBSpecialScenePanelViewModel(screenProperty, phyScreenProperty);
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('should_return_null_when_after_viewModel_init', Level.LEVEL0, async () => {
      expect(viewModel.getSceneContainerSessionWithContainerId(1)).assertNull();
    });
  });

  describe('getSceneContainerSessionWithPersistentId_testSuite', (): void => {
    let screenProperty: SCBScreenProperty;
    let phyScreenProperty: SCBScreenProperty;
    let viewModel: SCBSpecialScenePanelViewModel;

    beforeAll(() => {
      screenProperty = new SCBScreenProperty();
      phyScreenProperty = new SCBScreenProperty();
      viewModel = new SCBSpecialScenePanelViewModel(screenProperty, phyScreenProperty);
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('should_return_null_when_after_viewModel_init', Level.LEVEL0, async () => {
      expect(viewModel.getSceneContainerSessionWithPersistentId(1)).assertNull();
    });
  });

  describe('getContainerSessionByPersistentIdOrContainerId_testSuite', (): void => {
    let screenProperty: SCBScreenProperty;
    let phyScreenProperty: SCBScreenProperty;
    let viewModel: SCBSpecialScenePanelViewModel;

    beforeAll(() => {
      screenProperty = new SCBScreenProperty();
      phyScreenProperty = new SCBScreenProperty();
      viewModel = new SCBSpecialScenePanelViewModel(screenProperty, phyScreenProperty);
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('should_return_null_when_after_viewModel_init', Level.LEVEL0, async () => {
      expect(viewModel.getContainerSessionByPersistentIdOrContainerId()).assertNull();
    });
  });

  describe('SCBSpecialScenePanelViewModel_needMinimizeActiveContainer_testSuite', () => {
    let panelViewModel: SCBSpecialScenePanelViewModel;
    let mocker: MockKit;

    beforeAll(() => {
      panelViewModel = new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
      mocker = new MockKit();
    });

    /**
     * 用例描述: 判断是否需要最小化当前处于active的containerSession
     * 预置条件: 无
     * 测试场景: 传入相同的currentContainer和activeContainer
     * 预期结果: 返回false
     */
    it('test_currentContainerIsSameActiveContainer_returnFalse', Level.LEVEL0, () => {
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let containerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

      let result: boolean = panelViewModel.needMinimizeActiveContainer(containerSession, containerSession);

      expect(result).assertFalse();
    });

    /**
     * 用例描述: 判断是否需要最小化当前处于active的containerSession
     * 预置条件: currentContainer和activeContainer均处于全屏模式
     * 测试场景: 传入currentContainer和activeContainer判断会否需要最小化activeContainer
     * 预期结果: 返回True
     */
    it('test_currentContainerAndActiveContainerAreInFullScreenMode_returnTrue', Level.LEVEL0, () => {
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let currContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let curMockFunction = mocker.mockFunc(currContainerSession, currContainerSession.getContainerWindowMode);

      let activeSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let activeSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(activeSceneInfo), activeSceneInfo);
      let activeContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(activeSceneSession, new SCBScreenProperty());
      let activeMockFunction = mocker.mockFunc(activeContainerSession, activeContainerSession.getContainerWindowMode)

      when(curMockFunction)(ArgumentMatchers.any).afterReturn(SCBSceneMode.FULLSCREEN);
      when(activeMockFunction)(ArgumentMatchers.any).afterReturn(SCBSceneMode.FULLSCREEN);

      let result: boolean = panelViewModel.needMinimizeActiveContainer(currContainerSession, activeContainerSession);

      expect(result).assertTrue();
      mocker.ignoreMock(currContainerSession, currContainerSession.getContainerWindowMode);
      mocker.ignoreMock(activeContainerSession, activeContainerSession.getContainerWindowMode);
    });

    /**
     * 用例描述: 判断是否需要最小化当前处于active的containerSession
     * 预置条件: 仅activeContainer均处于全屏模式
     * 测试场景: 传入currentContainer和activeContainer判断会否需要最小化activeContainer
     * 预期结果: 返回True
     */
    it('test_onlyActiveContainerInFullScreenMode_returnFalse', Level.LEVEL0, () => {
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let currContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let curMockFunction = mocker.mockFunc(currContainerSession, currContainerSession.getContainerWindowMode);

      let activeSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let activeSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(activeSceneInfo), activeSceneInfo);
      let activeContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(activeSceneSession, new SCBScreenProperty());
      let activeMockFunction = mocker.mockFunc(activeContainerSession, activeContainerSession.getContainerWindowMode)

      when(curMockFunction)(ArgumentMatchers.any).afterReturn(SCBSceneMode.PRIMARY);
      when(activeMockFunction)(ArgumentMatchers.any).afterReturn(SCBSceneMode.FULLSCREEN);

      let result: boolean = panelViewModel.needMinimizeActiveContainer(currContainerSession, activeContainerSession);

      expect(result).assertFalse();
      mocker.ignoreMock(currContainerSession, currContainerSession.getContainerWindowMode);
      mocker.ignoreMock(activeContainerSession, activeContainerSession.getContainerWindowMode);
    });

    /**
     * 用例描述: 判断是否需要最小化当前处于active的containerSession
     * 预置条件: 仅currentContainer均处于全屏模式
     * 测试场景: 传入currentContainer和activeContainer判断会否需要最小化activeContainer
     * 预期结果: 返回True
     */
    it('test_onlyCurrentContainerInFullScreenMode_returnFalse', Level.LEVEL0, () => {
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let currContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let curMockFunction = mocker.mockFunc(currContainerSession, currContainerSession.getContainerWindowMode);

      let activeSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let activeSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(activeSceneInfo), activeSceneInfo);
      let activeContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(activeSceneSession, new SCBScreenProperty());
      let activeMockFunction = mocker.mockFunc(activeContainerSession, activeContainerSession.getContainerWindowMode)

      when(curMockFunction)(ArgumentMatchers.any).afterReturn(SCBSceneMode.FULLSCREEN);
      when(activeMockFunction)(ArgumentMatchers.any).afterReturn(SCBSceneMode.PRIMARY);

      let result: boolean = panelViewModel.needMinimizeActiveContainer(currContainerSession, activeContainerSession);

      expect(result).assertFalse();
      mocker.ignoreMock(currContainerSession, currContainerSession.getContainerWindowMode);
      mocker.ignoreMock(activeContainerSession, activeContainerSession.getContainerWindowMode);
    });
  });

  describe('createSceneSession_testSuite', () => {
    let mocker: MockKit;
    let states: ScenePanelState;
    let viewParam: RecentViewParam;
    let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 9527);
    let sdkSceneSession = sceneSessionManager.requestSceneSession(sceneInfo)
    let sceneSession: SCBSceneSession = new SCBSceneSession(sdkSceneSession, sceneInfo);
    let scbSpecialScenePanelViewModel: SCBSpecialScenePanelViewModel;

    beforeAll(() => {
      mocker = new MockKit();
      scbSpecialScenePanelViewModel =
        new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
      states = ScenePanelState.HOME;
      let keyboardSession = new SCBKeyboardSession(sceneSessionManager.requestSceneSession(sceneInfo),
        () => {}, keyboardChangeCallbackMap, keyboardChangeListenerList);
      scbSpecialScenePanelViewModel.init(keyboardSession, panelStateCollectionHandler);
    });

    afterAll(() => {
      SCBSceneSessionManager.getInstance().unRegisterFullSceneEndCallback();
    });

    /**
     * 用例描述: 测试createSceneSession方法
     * 预置条件: mock SCBSceneSessionManager的requestSceneSession方法，无论参数是什么都返回null
     * 测试场景: 当SCBSceneSessionManager的requestSceneSession方法返回结果为null时，直接返回null
     * 预期结果: 返回结果为null
     */
    it('test_should_return_null_when_requestSceneSession_returns_null', Level.LEVEL0, () => {
      let mockRequestSceneSession: Function =
        mocker.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().requestSceneSession);
      when(mockRequestSceneSession)(ArgumentMatchers.any).afterReturn(null);
      let result: SCBSceneSession | null = scbSpecialScenePanelViewModel.createSceneSession(sceneInfo);
      expect(result).assertNull();
      mocker.verify('requestSceneSession', [sceneInfo]).atLeast(1);
      mocker.ignoreMock(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().requestSceneSession);
    });

    /**
     * 用例描述: 测试createSceneSession方法
     * 预置条件: mock requestSceneSession方法
     * 测试场景: 当requestSceneSession方法正常返回sceneSession
     * 预期结果: 从requestSceneSession中获取对应的sceneSession
     */
    it('test_should_return_SCBSceneSession_when_requestSceneSession_returns_valid_session', Level.LEVEL0, () => {
      let mockRequestSceneSession: Function =
        mocker.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().requestSceneSession);
      when(mockRequestSceneSession)(ArgumentMatchers.any).afterReturn(sdkSceneSession);

      let result: SCBSceneSession | null = scbSpecialScenePanelViewModel.createSceneSession(sceneInfo);

      expect(result).not().assertNull();
      mocker.verify('requestSceneSession', [sceneInfo]).atLeast(1);
      mocker.ignoreMock(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().requestSceneSession);
    });

    /**
     * 用例描述: 测试requestNewSceneSession方法
     * 预置条件: mock requestSceneSession方法
     * 测试场景: 当requestSceneSession方法抛异常
     * 预期结果: 返回结果为null
     */
    it('test_should_handle_exception_when_requestSceneSession_throws_error', Level.LEVEL0, () => {
      let mockRequestSceneSession: Function =
        mocker.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().requestSceneSession);
      when(mockRequestSceneSession)(ArgumentMatchers.any).afterThrow('Error');

      let result: SCBSceneSession | null = scbSpecialScenePanelViewModel.createSceneSession(sceneInfo);

      expect(result).assertNull();
      mocker.verify('requestSceneSession', [sceneInfo]).atLeast(1);
      mocker.ignoreMock(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().requestSceneSession);
    });
  });

  describe('SCBSpecialScenePanelViewModel_addSpecialSceneContainerSession_testSuite', () => {
    let viewModel: SCBSpecialScenePanelViewModel =
      new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9527);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let sceneContainerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

    beforeAll(() => {
      viewModel.getContainerSessionList().clear();
    })

    afterEach(() => {
      viewModel.getContainerSessionList().clear();
    });

    it('test_should_add_session_if_not_already_present', Level.LEVEL0, () => {
      expect(viewModel.getContainerSessionList().length).assertEqual(0);

      viewModel.addSpecialSceneContainerSession(sceneContainerSession);

      expect(viewModel.getContainerSessionList().length).assertEqual(1);
    });

    it('test_should_not_add_session_if_already_present', Level.LEVEL0, () => {
      viewModel.getContainerSessionList().push(sceneContainerSession);
      expect(viewModel.getContainerSessionList().length).assertEqual(1);

      viewModel.addSpecialSceneContainerSession(sceneContainerSession);

      expect(viewModel.getContainerSessionList().length).assertEqual(1);
    });
  });

  describe('SCBSpecialScenePanelViewModel_removeSpecialSceneContainerSession_testSuite', () => {
    let viewModel: SCBSpecialScenePanelViewModel =
      new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9527);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let sceneContainerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

    beforeAll(() => {
      viewModel.getContainerSessionList().clear();
      viewModel.getContainerSessionList().push(sceneContainerSession);
    })

    afterEach(() => {
      viewModel.getContainerSessionList().clear();
      viewModel.getContainerSessionList().push(sceneContainerSession);
    });

    it('test_should_not_remove_anything_when_sceneContainerSession_is_null', Level.LEVEL0, () => {
      expect(viewModel.getContainerSessionList().length).assertEqual(1);

      viewModel.removeSpecialSceneContainerSession(null);

      expect(viewModel.getContainerSessionList().length).assertEqual(1);
    });

    it('test_should_remove_the_correct_session_when_session_exists', Level.LEVEL0, () => {
      expect(viewModel.getContainerSessionList().length).assertEqual(1);

      viewModel.removeSpecialSceneContainerSession(sceneContainerSession);

      expect(viewModel.getContainerSessionList().length).assertEqual(0);
    });

    it('test_should_not_remove_anything_when_session_does_not_exist', Level.LEVEL0, () => {
      let sceneInfo02: SCBSceneInfo = new SCBSceneInfo('testBundle02', 'testModule02', 'testAbility02', 0, 9528);
      let sceneSession02: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo02), sceneInfo02);
      let sceneContainerSession02: SCBSceneContainerSession =
        new SCBSceneContainerSession(sceneSession02, new SCBScreenProperty());
      expect(viewModel.getContainerSessionList().length).assertEqual(1);

      viewModel.removeSpecialSceneContainerSession(sceneContainerSession02);

      expect(viewModel.getContainerSessionList().length).assertEqual(1);
    });
  });

  describe('SCBSpecialScenePanelViewModel_onDestroyScene_testSuite', () => {
    let mocker: MockKit = new MockKit();
    let viewModel: SCBSpecialScenePanelViewModel =
      new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9527);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let sceneContainerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

    let keyboardSession = new SCBKeyboardSession(sceneSessionManager.requestSceneSession(sceneInfo),
      () => {}, keyboardChangeCallbackMap, keyboardChangeListenerList);
    viewModel.init(keyboardSession, panelStateCollectionHandler);

    beforeAll(() => {
      viewModel.getContainerSessionList().clear();
      viewModel.getContainerSessionList().push(sceneContainerSession);
    })

    afterEach(() => {
      viewModel.getContainerSessionList().clear();
      viewModel.getContainerSessionList().push(sceneContainerSession);
    });

    it('test_should_handle_no_containerSession_when_persistentId_and_containerId_are_undefined', Level.LEVEL0, () => {
      expect(viewModel.getContainerSessionList().length).assertEqual(1);

      viewModel.onDestroyScene();

      expect(viewModel.getContainerSessionList().length).assertEqual(1);
    });

    it('test_should_update_scene_panel_state_to_HOME_when_no_more_sessions', Level.LEVEL0, () => {
      let mockRequestDestruction: Function =
        mocker.mockFunc(sceneContainerSession, sceneContainerSession.requestDestruction);
      when(mockRequestDestruction)(ArgumentMatchers.any).afterReturnNothing();
      expect(viewModel.getContainerSessionList().length).assertEqual(1);
      panelStateCollectionHandler.updatePanelState(ScenePanelState.FULLSCENE);
      viewModel.onDestroyScene(9527);

      mocker.verify('requestDestruction', [true]).atLeast(1);
      expect(panelStateCollectionHandler.getPanelState())
        .assertEqual(ScenePanelState.HOME);
      mocker.ignoreMock(sceneContainerSession, sceneContainerSession.requestDestruction);
    });

    it('test_whenHasMoreSessions_thenScenePanelStateNotHome', Level.LEVEL0, () => {
      let sceneInfo02: SCBSceneInfo = new SCBSceneInfo('testBundle02', 'testModule02', 'testAbility02', 0, 9528);
      let sceneSession02: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo02), sceneInfo02);
      let sceneContainerSession02: SCBSceneContainerSession =
        new SCBSceneContainerSession(sceneSession02, new SCBScreenProperty());
      viewModel.getContainerSessionList().push(sceneContainerSession02);
      let mockRequestDestruction: Function =
        mocker.mockFunc(sceneContainerSession, sceneContainerSession.requestDestruction);
      when(mockRequestDestruction)(ArgumentMatchers.any).afterReturnNothing();
      expect(viewModel.getContainerSessionList().length).assertEqual(2);
      panelStateCollectionHandler.updatePanelState(ScenePanelState.FULLSCENE);

      viewModel.onDestroyScene(9527);

      mocker.verify('requestDestruction', [true]).atLeast(1);
      expect(viewModel.getContainerSessionList().length).assertEqual(1);
      expect(panelStateCollectionHandler.getPanelState())
        .assertEqual(ScenePanelState.FULLSCENE);
      mocker.ignoreMock(sceneContainerSession, sceneContainerSession.requestDestruction);
    });
  });

  describe('SCBSpecialScenePanelViewModel_onCloseScene_testSuite', () => {
    let mocker: MockKit = new MockKit();
    let viewModel: SCBSpecialScenePanelViewModel =
      new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9527);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let sceneContainerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

    let keyboardSession = new SCBKeyboardSession(sceneSessionManager.requestSceneSession(sceneInfo),
      () => {}, keyboardChangeCallbackMap, keyboardChangeListenerList);
    viewModel.init(keyboardSession, panelStateCollectionHandler);

    beforeAll(() => {
      viewModel.getContainerSessionList().clear();
      viewModel.getContainerSessionList().push(sceneContainerSession);
    })

    afterEach(() => {
      viewModel.getContainerSessionList().clear();
      viewModel.getContainerSessionList().push(sceneContainerSession);
    });

    it('test_should_log_error_when_containerSession_is_not_found', Level.LEVEL0, () => {
      panelStateCollectionHandler.updateBlackBackgroundState(true);
      let mockShowError: Function = mocker.mockFunc(mockLog, mockLog.showError);

      viewModel.onCloseScene(1, 1);

      mocker.verify('showError', [`cannot find containerSession with persistentId:1`]).atLeast(1);
      mocker.ignoreMock(mockLog, mockLog.showError);
    });

    it('test_should_update_scene_panel_state_to_HOME_when_no_active_sessions_remain', Level.LEVEL0, () => {
      expect(viewModel.getContainerSessionList().length).assertEqual(1);
      panelStateCollectionHandler.updateBlackBackgroundState(true)
      panelStateCollectionHandler.updatePanelState(ScenePanelState.FULLSCENE);

      viewModel.onCloseScene(9527);

      expect(viewModel.getContainerSessionList().length).assertEqual(0);
      expect(panelStateCollectionHandler.getPanelState())
        .assertEqual(ScenePanelState.HOME);
    });

    it('test_should_not_update_scene_panel_state_to_HOME_when_has_active_sessions_remain', Level.LEVEL0, () => {
      let mockGetActiveCount: Function = mocker.mockFunc(viewModel, viewModel.getActiveSceneContainerSessionCount);
      when(mockGetActiveCount)(ArgumentMatchers.any).afterReturn(1);
      expect(viewModel.getContainerSessionList().length).assertEqual(1);
      panelStateCollectionHandler.updateBlackBackgroundState(true);
      panelStateCollectionHandler.updatePanelState(ScenePanelState.FULLSCENE);

      viewModel.onCloseScene(9527);

      expect(viewModel.getContainerSessionList().length).assertEqual(0);
      expect(panelStateCollectionHandler.getPanelState())
        .assertEqual(ScenePanelState.FULLSCENE);
      mocker.ignoreMock(viewModel, viewModel.getActiveSceneContainerSessionCount);
    });
  });

  describe('SCBSpecialScenePanelViewModel_minimizeAllScene_testSuite', () => {
    let mocker: MockKit = new MockKit();
    let viewModel: SCBSpecialScenePanelViewModel =
      new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9527);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let sceneContainerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

    let keyboardSession = new SCBKeyboardSession(sceneSessionManager.requestSceneSession(sceneInfo),
      () => {}, keyboardChangeCallbackMap, keyboardChangeListenerList);
    viewModel.init(keyboardSession, panelStateCollectionHandler);

    beforeAll(() => {
      viewModel.getContainerSessionList().clear();
      viewModel.getContainerSessionList().push(sceneContainerSession);
    })

    afterEach(() => {
      viewModel.getContainerSessionList().clear();
      viewModel.getContainerSessionList().push(sceneContainerSession);
    });

    it('test_should_call_sceneContainerTransitionOut_and_requestBackgroundWithTransitionOut', Level.LEVEL0, () => {
      let panelAnimator: SCBSpecialScenePanelAnimator = ReflectionUtils.getProperty(viewModel, 'panelAnimator');
      let mockSceneContainerTransitionOut: Function =
        mocker.mockFunc(panelAnimator, panelAnimator.sceneContainerTransitionOut);
      let mockRequestBackgroundWithTransitionOut: Function =
        mocker.mockFunc(sceneContainerSession, sceneContainerSession.requestBackgroundWithTransitionOut);
      when(mockSceneContainerTransitionOut)(ArgumentMatchers.any).afterReturnNothing();
      when(mockRequestBackgroundWithTransitionOut)(ArgumentMatchers.any).afterReturnNothing();
      ReflectionUtils.getProperty(viewModel, 'panelStateCollectionHandler')?.updatePanelState(ScenePanelState.FULLSCENE);

      viewModel.minimizeAllScene();

      expect(ReflectionUtils.getProperty(viewModel, 'panelStateCollectionHandler')?.getPanelState())
        .assertEqual(ScenePanelState.HOME);
      mocker.ignoreMock(panelAnimator, panelAnimator.sceneContainerTransitionOut);
      mocker.ignoreMock(sceneContainerSession, sceneContainerSession.requestBackgroundWithTransitionOut);
    });

    it('test_should_not_call_sceneContainerTransitionOut_and_requestBackgroundWithTransitionOut', Level.LEVEL0, () => {
      ReflectionUtils.setProperty(sceneContainerSession, '_isActive', false);
      let panelAnimator: SCBSpecialScenePanelAnimator = ReflectionUtils.getProperty(viewModel, 'panelAnimator')
      let mockSceneContainerTransitionOut: Function =
        mocker.mockFunc(panelAnimator, panelAnimator.sceneContainerTransitionOut);
      let mockRequestBackgroundWithTransitionOut: Function =
        mocker.mockFunc(sceneContainerSession, sceneContainerSession.requestBackgroundWithTransitionOut);
      when(mockSceneContainerTransitionOut)(ArgumentMatchers.any).afterReturnNothing();
      when(mockRequestBackgroundWithTransitionOut)(ArgumentMatchers.any).afterReturnNothing();
      ReflectionUtils.getProperty(viewModel, 'panelStateCollectionHandler')?.updatePanelState(ScenePanelState.FULLSCENE);

      viewModel.minimizeAllScene();

      mocker.verify('sceneContainerTransitionOut', [sceneContainerSession]).never();
      mocker.verify('requestBackgroundWithTransitionOut', []).never();
      expect(ReflectionUtils.getProperty(viewModel, 'panelStateCollectionHandler')?.getPanelState())
        .assertEqual(ScenePanelState.HOME);
      mocker.ignoreMock(panelAnimator, panelAnimator.sceneContainerTransitionOut);
      mocker.ignoreMock(sceneContainerSession, sceneContainerSession.requestBackgroundWithTransitionOut);
    });
  });

  describe('SCBSpecialScenePanelViewModel_requestSceneSession_testSuite', () => {
    let mocker: MockKit = new MockKit();
    let viewModel: SCBSpecialScenePanelViewModel =
      new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9527);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let sceneContainerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

    beforeAll(() => {
      viewModel.getContainerSessionList().clear();
      viewModel.getContainerSessionList().push(sceneContainerSession);
    })

    afterEach(() => {
      viewModel.getContainerSessionList().clear();
      viewModel.getContainerSessionList().push(sceneContainerSession);
    });

    it('test_getSceneSessionByPersistentId_with_already_exists_persistentId', Level.LEVEL0, () => {
      let result: SCBSceneSession | null = viewModel.requestSceneSession(sceneInfo);
      expect(result).assertEqual(sceneSession);
    });

    it('test_updateCallerSessionIdAndToSessionId_with_already_exists_persistentId', Level.LEVEL0, () => {
      let mockUpdateCallerSessionIdAndToSessionId: Function =
        mocker.mockFunc(viewModel, viewModel.updateCallerSessionIdAndToSessionId);
      when(mockUpdateCallerSessionIdAndToSessionId)(ArgumentMatchers.any).afterReturnNothing();
      sceneInfo.callerPersistentId = 111;

      let result: SCBSceneSession | null = viewModel.requestSceneSession(sceneInfo);

      expect(result).assertEqual(sceneSession);
      mocker.verify('updateCallerSessionIdAndToSessionId', [sceneSession, 111]).atLeast(1);
      mocker.ignoreMock(viewModel, viewModel.updateCallerSessionIdAndToSessionId);
    });

    it('test_createSceneSession_with_not_exists_persistentId', Level.LEVEL0, () => {
      let sceneInfo02: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 111);
      let sceneSession02: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo02), sceneInfo02);
      let mockCreateSceneSession: Function = mocker.mockFunc(viewModel, viewModel.createSceneSession);
      when(mockCreateSceneSession)(ArgumentMatchers.any).afterReturn(sceneSession02);

      let result: SCBSceneSession | null = viewModel.requestSceneSession(sceneInfo02);

      expect(result).assertEqual(sceneSession02);
      mocker.ignoreMock(viewModel, viewModel.createSceneSession);
    });

    it('test_createSceneSession_when_no_persistentId_but_has_callerPersistentId', Level.LEVEL0, () => {
      let sceneInfo02: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 0);
      sceneInfo02.callerPersistentId = 9527;
      let sceneSession02: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo02), sceneInfo02);
      let mockCreateSceneSession: Function = mocker.mockFunc(viewModel, viewModel.createSceneSession);
      let mockUpdateCallerSessionIdAndToSessionId: Function =
        mocker.mockFunc(viewModel, viewModel.updateCallerSessionIdAndToSessionId);
      when(mockCreateSceneSession)(ArgumentMatchers.any).afterReturn(sceneSession02);
      when(mockUpdateCallerSessionIdAndToSessionId)(ArgumentMatchers.any).afterReturnNothing();

      let result: SCBSceneSession | null = viewModel.requestSceneSession(sceneInfo02);

      expect(result).assertEqual(sceneSession02);
      mocker.verify('updateCallerSessionIdAndToSessionId', [sceneInfo02, 9527]).atLeast(1);
      mocker.ignoreMock(viewModel, viewModel.createSceneSession);
      mocker.ignoreMock(viewModel, viewModel.updateCallerSessionIdAndToSessionId);
    });

    it('test_createSceneSession_failed_when_no_persistentId_but_has_callerPersistentId', Level.LEVEL0, () => {
      let sceneInfo02: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 0);
      sceneInfo02.callerPersistentId = 9527;
      let mockCreateSceneSession: Function = mocker.mockFunc(viewModel, viewModel.createSceneSession);
      let mockUpdateCallerSessionIdAndToSessionId: Function =
        mocker.mockFunc(viewModel, viewModel.updateCallerSessionIdAndToSessionId);
      when(mockCreateSceneSession)(ArgumentMatchers.any).afterReturn(null);
      when(mockUpdateCallerSessionIdAndToSessionId)(ArgumentMatchers.any).afterReturnNothing();

      let result: SCBSceneSession | null = viewModel.requestSceneSession(sceneInfo02);

      expect(result).assertEqual(null);
      mocker.verify('updateCallerSessionIdAndToSessionId', [null, 9527]).never();
      mocker.ignoreMock(viewModel, viewModel.createSceneSession);
      mocker.ignoreMock(viewModel, viewModel.updateCallerSessionIdAndToSessionId);
    });

    it('test_updateCallerSessionIdAndToSessionId_when_no_persistentId_and_no_callerPersistentId_and_getSceneSession_return_null',
      Level.LEVEL0, () => {
        let sceneInfo02: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 222);
        sceneInfo02.callerPersistentId = 0;
        let sceneSession02: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo02), sceneInfo02);
        let mockCreateSceneSession: Function = mocker.mockFunc(viewModel, viewModel.createSceneSession);
        let mockUpdateCallerSessionIdAndToSessionId: Function =
          mocker.mockFunc(viewModel, viewModel.updateCallerSessionIdAndToSessionId);
        when(mockCreateSceneSession)(ArgumentMatchers.any).afterReturn(sceneSession02);
        when(mockUpdateCallerSessionIdAndToSessionId)(ArgumentMatchers.any).afterReturnNothing();

        let result: SCBSceneSession | null = viewModel.requestSceneSession(sceneInfo02);

        expect(result).assertEqual(sceneSession02);
        mocker.ignoreMock(viewModel, viewModel.createSceneSession);
        mocker.ignoreMock(viewModel, viewModel.updateCallerSessionIdAndToSessionId);
      });

    it('test_not_updateCallerSessionIdAndToSessionId_when_no_persistentId_and_no_callerPersistentId_and_getSceneSession_return_null',
      Level.LEVEL0, () => {
        let sceneInfo02: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 222);
        sceneInfo02.callerPersistentId = 0;
        let sceneSession02: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo02), sceneInfo02);
        let mockCreateSceneSession: Function = mocker.mockFunc(viewModel, viewModel.createSceneSession);
        let mockUpdateCallerSessionIdAndToSessionId: Function =
          mocker.mockFunc(viewModel, viewModel.updateCallerSessionIdAndToSessionId);
        when(mockCreateSceneSession)(ArgumentMatchers.any).afterReturn(null);
        when(mockUpdateCallerSessionIdAndToSessionId)(ArgumentMatchers.any).afterReturnNothing();

        let result: SCBSceneSession | null = viewModel.requestSceneSession(sceneInfo02);

        expect(result).assertEqual(null);
        mocker.verify('updateCallerSessionIdAndToSessionId', [null, 0]).never();
        mocker.ignoreMock(viewModel, viewModel.createSceneSession);
        mocker.ignoreMock(viewModel, viewModel.updateCallerSessionIdAndToSessionId);
      });

    it('test_whenNoPersistentIdAndNoCallerPersistentId_thenReturnSceneSession',
      Level.LEVEL0, () => {
        let sceneInfo02: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 333);
        sceneInfo02.callerPersistentId = 0;
        let sceneSession02: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo02), sceneInfo02);
        let mockGetSceneSession: Function = mocker.mockFunc(viewModel, viewModel.getSceneSessionByPersistentId);
        let mockUpdateCallerSessionIdAndToSessionId: Function =
          mocker.mockFunc(viewModel, viewModel.updateCallerSessionIdAndToSessionId);
        when(mockGetSceneSession)(ArgumentMatchers.any).afterReturn(sceneSession02);
        when(mockUpdateCallerSessionIdAndToSessionId)(ArgumentMatchers.any).afterReturnNothing();

        let result: SCBSceneSession | null = viewModel.requestSceneSession(sceneInfo02);

        expect(result).assertEqual(sceneSession02);
        mocker.ignoreMock(viewModel, viewModel.getSceneSession);
        mocker.ignoreMock(viewModel, viewModel.updateCallerSessionIdAndToSessionId);
      });
  });

  describe('SCBSpecialScenePanelViewModel_onMaximizeScene_testSuite', (): void => {
    let mocker: MockKit;
    let scbSpecialScenePanelViewModel: SCBSpecialScenePanelViewModel;

    beforeAll(() => {
      mocker = new MockKit();
      scbSpecialScenePanelViewModel =
        new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
    });

    /**
     * 用例描述: 通过persistentId与containerId找到窗口容器，然后最大化
     * 预置条件: 存在container并在前台
     * 测试场景: 根据persistentId与containerId找session，但session不存在
     * 预期结果: 不进行操作，直接返回
     */
    it('test_whenMaximizeSceneWhenNotFoundSessionByPersistentIdAndContainerId_thenMaxNotSuccess', Level.LEVEL0,
      async () => {
        let persistentId = 998;
        let containerId = 999;
        let mockLogShowError: Function = mocker.mockFunc(mockLog, mockLog.showError);
        when(mockLogShowError)(ArgumentMatchers.any).afterReturnNothing();

        // 调用接口，最大化容器
        scbSpecialScenePanelViewModel.onMaximizeScene(persistentId, containerId);

        mocker.verify('showError', [`cannot find containerSession with persistentId:${persistentId}`]).once();
        mocker.ignoreMock(mockLog, mockLog.showError);
      });

    /**
     * 用例描述: 通过persistentId与containerId找到窗口容器，然后最大化
     * 预置条件: 存在container并在前台
     * 测试场景: 根据persistentId与containerId找到session，但session不在前台
     * 预期结果: 不进行操作，直接返回
     */
    it('test_whenMaximizeSceneWhenIsNotActive_thenMaxNotSuccess', Level.LEVEL0, async () => {
      let persistentId = 123;
      let containerId = 234;
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, persistentId);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sceneContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

      let mockLogShowWarn: Function = mocker.mockFunc(mockLog, mockLog.showWarn);
      when(mockLogShowWarn)(ArgumentMatchers.any).afterReturnNothing();

      // mock 获取session数据接口
      let mockGetContainerSessionByPersistentIdOrContainerId: Function = mocker.mockFunc(scbSpecialScenePanelViewModel,
        scbSpecialScenePanelViewModel.getContainerSessionByPersistentIdOrContainerId);
      when(mockGetContainerSessionByPersistentIdOrContainerId)(ArgumentMatchers.any).afterReturn(sceneContainerSession);

      // 调用接口，最大化容器
      scbSpecialScenePanelViewModel.onMaximizeScene(persistentId, containerId);

      mocker.verify('showWarn', [`containerSession is already background:${persistentId}`]).once();
      mocker.ignoreMock(mockLog, mockLog.showWarn);
    });

    /**
     * 用例描述: 通过persistentId与containerId找到窗口容器，然后最大化
     * 预置条件: 存在container并在前台
     * 测试场景: 根据persistentId与containerId找到session，且session在前台
     * 预期结果: 成功max
     */
    it('test_whenMaximizeSceneWhenSessionIsActive_thenMaxSuccess', Level.LEVEL0, async () => {
      let persistentId = 123;
      let containerId = 234;
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, persistentId);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      sceneSession.floatBorderRadius = 1;
      let sceneContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

      // 窗口置为可交互
      sceneContainerSession.requestActivation();

      // mock 获取session数据接口
      let mockGetContainerSessionByPersistentIdOrContainerId: Function = mocker.mockFunc(scbSpecialScenePanelViewModel,
        scbSpecialScenePanelViewModel.getContainerSessionByPersistentIdOrContainerId);
      when(mockGetContainerSessionByPersistentIdOrContainerId)(ArgumentMatchers.any).afterReturn(sceneContainerSession);

      // 调用接口，最大化容器
      scbSpecialScenePanelViewModel.onMaximizeScene(persistentId, containerId);

      // 校验重置窗口属性
      expect(sceneSession.floatBorderRadius).assertEqual(0);
    });
  })

  describe('SCBSpecialScenePanelViewModel_resetWindowEffect_testSuite', (): void => {
    let mocker: MockKit;
    let scbSpecialScenePanelViewModel: SCBSpecialScenePanelViewModel;

    beforeAll(() => {
      mocker = new MockKit();
      scbSpecialScenePanelViewModel =
        new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
    });

    /**
     * 用例描述: 重置窗口radius属性
     * 预置条件: 存在container并在前台
     * 测试场景: 当container的primarySession、secondarySession均存在，尝试重置窗口radius属性
     * 预期结果: 重置radius，并打印secondary错误日志
     */
    it('test_whenResetWindowEffectWhenPrimarySessionNotExist_thenNotResetRadius', Level.LEVEL0, async () => {
      let persistentId = 123;
      let containerId = 234;
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, persistentId);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      sceneSession.floatBorderRadius = 1;
      let sceneContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

      let mockLogShowError: Function = mocker.mockFunc(mockLog, mockLog.showError);
      when(mockLogShowError)(ArgumentMatchers.any).afterReturnNothing();

      // mock secondarySession
      sceneContainerSession.secondarySession = sceneSession;

      // 窗口置为可交互
      sceneContainerSession.requestActivation();

      // mock 获取session数据接口
      let mockGetContainerSessionByPersistentIdOrContainerId: Function = mocker.mockFunc(scbSpecialScenePanelViewModel,
        scbSpecialScenePanelViewModel.getContainerSessionByPersistentIdOrContainerId);
      when(mockGetContainerSessionByPersistentIdOrContainerId)(ArgumentMatchers.any).afterReturn(sceneContainerSession);

      // 调用接口，最大化容器
      scbSpecialScenePanelViewModel.onMaximizeScene(persistentId, containerId);

      // 校验错误日志打印
      // 校验重置窗口属性与错误日志打印
      expect(sceneSession.floatBorderRadius).assertEqual(0);
      mocker.ignoreMock(mockLog, mockLog.showError);
    });
  })

  describe('SCBSpecialScenePanelViewModel_clearCallerPersistentIdForSession_testSuite', (): void => {
    let mocker: MockKit;
    let scbSpecialScenePanelViewModel: SCBSpecialScenePanelViewModel;

    beforeAll(() => {
      mocker = new MockKit();
      scbSpecialScenePanelViewModel =
        new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
    });
    /**
     * 用例描述: 根据persistentId清空session的callerPersistentId
     * 预置条件: 创建session列表
     * 测试场景: 当根据不存在的id去清空session的callerPersistentId
     * 预期结果: 不清空callerPersistentId
     */
    it('test_clearCallerPersistentIdwhenNoPersistentId_returnUndefined', Level.LEVEL0, async () => {
      let mockLogShowInfo: Function = mocker.mockFunc(mockLog, mockLog.showInfo);
      when(mockLogShowInfo)(ArgumentMatchers.any).afterReturnNothing();

      let persistentId = undefined;
      scbSpecialScenePanelViewModel.clearCallerPersistentIdForSession(persistentId);

      mocker.verify('showInfo', ['clear session caller persistentId for undefined']).once();
      mocker.ignoreMock(mockLog, mockLog.showInfo);
    });

    /**
     * 用例描述: 根据persistentId清空session的callerPersistentId
     * 预置条件: 创建session列表
     * 测试场景: 当persistentId小于0时，去清空session的callerPersistentId
     * 预期结果: 不清空callerPersistentId
     */
    it('test_clearCallerPersistentIdWhenPersistentIdLessThanZero_noReturn', Level.LEVEL0, async () => {
      let mockLogShowInfo: Function = mocker.mockFunc(mockLog, mockLog.showInfo);
      when(mockLogShowInfo)(ArgumentMatchers.any).afterReturnNothing();

      let persistentId = -1;
      scbSpecialScenePanelViewModel.clearCallerPersistentIdForSession(persistentId);

      mocker.verify('showInfo', ['clear session caller persistentId for -1']).once();
      mocker.ignoreMock(mockLog, mockLog.showInfo);
    });

    /**
     * 用例描述: 根据persistentId清空session的callerPersistentId
     * 预置条件: 创建session列表
     * 测试场景: 当persistentId大于0,但session列表里并没有该id对应的数据，去清空session的callerPersistentId
     * 预期结果: 不清空callerPersistentId
     */
    it('test_clearCallerPersistentIdWhenNotFindSessionByPersistentId_notSuccess', Level.LEVEL0, async () => {
      let mockLogShowInfo: Function = mocker.mockFunc(mockLog, mockLog.showInfo);
      when(mockLogShowInfo)(ArgumentMatchers.any).afterReturnNothing();

      let persistentId = 1;
      scbSpecialScenePanelViewModel.clearCallerPersistentIdForSession(persistentId);

      mocker.verify('showInfo', ['clear session caller persistentId for 1']).once();
      mocker.ignoreMock(mockLog, mockLog.showInfo);
    });

    /**
     * 用例描述: 根据persistentId清空session的callerPersistentId
     * 预置条件: 创建session列表
     * 测试场景: 当persistentId大于0,session列表与info里有该id对应的数据，去清空session的callerPersistentId
     * 预期结果: 清空callerPersistentId
     */
    it('test_clearCallerPersistentIdWhenFindSessionAndSceneInfoByPersistentId_success', Level.LEVEL0, async () => {
      let persistentId = 2;
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, persistentId);
      sceneInfo.callerPersistentId = persistentId;
      let primarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

      // mock 获取session数据接口
      let mockGetSceneSessionByPersistentId: Function = mocker.mockFunc(scbSpecialScenePanelViewModel,
        scbSpecialScenePanelViewModel.getSceneSessionByPersistentId);
      when(mockGetSceneSessionByPersistentId)(persistentId).afterReturn(primarySession);

      scbSpecialScenePanelViewModel.clearCallerPersistentIdForSession(persistentId);

      expect(primarySession.sceneInfo.callerPersistentId).assertEqual(0);
    });
  })

  describe('SCBSpecialScenePanelViewModel_clearToPersistentIdForSession_testSuite', (): void => {
    let mocker: MockKit;
    let scbSpecialScenePanelViewModel: SCBSpecialScenePanelViewModel;

    beforeAll(() => {
      mocker = new MockKit();
      scbSpecialScenePanelViewModel =
        new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
    });

    afterAll(() => {
      // 用例结束，清除sessionList()
      scbSpecialScenePanelViewModel.getContainerSessionList().clear();
      mocker.ignoreMock(mockLog, mockLog.showInfo);
    })

    /**
     * 用例描述: 根据persistentId清空session的toPersistentId
     * 预置条件: 创建session列表
     * 测试场景: 当persistentId小于0时，去清空session的toPersistentId
     * 预期结果: 不清空toPersistentId
     */
    it('test_clearToPersistentIdForSessionWhenPersistentIdLessThanZero_returnUndefined', Level.LEVEL0, async () => {
      let persistentId = -1;
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, persistentId);
      sceneInfo.toPersistentId = persistentId;
      let primarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

      // mock 获取session数据接口
      let mockGetSceneSessionByPersistentId: Function = mocker.mockFunc(scbSpecialScenePanelViewModel,
        scbSpecialScenePanelViewModel.getSceneSessionByPersistentId);
      when(mockGetSceneSessionByPersistentId)(persistentId).afterReturn(primarySession);

      scbSpecialScenePanelViewModel.clearToPersistentIdForSession(persistentId);

      expect(primarySession.sceneInfo.toPersistentId).assertEqual(persistentId);
    });

    /**
     * 用例描述: 根据persistentId清空session的toPersistentId
     * 预置条件: 创建session列表
     * 测试场景: 当persistentId大于0时，但session列表里并没有该id对应的数据，去清空session的toPersistentId
     * 预期结果: 不清空toPersistentId
     */
    it('test_clearToPersistentIdForSessionWhenNotFindSessionByPersistentId_notSuccess', Level.LEVEL0, async () => {
      let persistentId = 1;
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, persistentId);
      sceneInfo.toPersistentId = persistentId;
      let primarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

      // mock 获取session数据接口
      let mockGetSceneSessionByPersistentId: Function = mocker.mockFunc(scbSpecialScenePanelViewModel,
        scbSpecialScenePanelViewModel.getSceneSessionByPersistentId);
      when(mockGetSceneSessionByPersistentId)(persistentId).afterReturn(null);

      scbSpecialScenePanelViewModel.clearToPersistentIdForSession(persistentId);

      expect(primarySession.sceneInfo.toPersistentId).assertEqual(persistentId);
    });

    /**
     * 用例描述: 根据persistentId清空session的toPersistentId
     * 预置条件: 创建session列表
     * 测试场景: 当persistentId小于0时，session列表与info里有该id对应的数据，去清空session的toPersistentId
     * 预期结果: 清空toPersistentId
     */
    it('test_clearToPersistentIdForSessionWhenFindSessionAndSceneInfoByPersistentId_success', Level.LEVEL0,
      async () => {
        let persistentId = 2;
        let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, persistentId);
        sceneInfo.toPersistentId = persistentId;
        let primarySession: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

        // mock 获取session数据接口
        let mockGetSceneSessionByPersistentId: Function = mocker.mockFunc(scbSpecialScenePanelViewModel,
          scbSpecialScenePanelViewModel.getSceneSessionByPersistentId);
        when(mockGetSceneSessionByPersistentId)(persistentId).afterReturn(primarySession);

        scbSpecialScenePanelViewModel.clearToPersistentIdForSession(persistentId);

        expect(primarySession.sceneInfo.toPersistentId).assertEqual(0);
      });
  })

  describe('SCBSpecialScenePanelViewModel_linkCallerAndToPersistentForSession_testSuite', (): void => {
    let mocker: MockKit;
    let scbSpecialScenePanelViewModel: SCBSpecialScenePanelViewModel;

    beforeAll(() => {
      mocker = new MockKit();
      scbSpecialScenePanelViewModel =
        new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
    });

    /**
     * 用例描述: 根据persistentId关联session的callerPersistentId与toPersistentId
     * 预置条件: 创建session列表
     * 测试场景: 当传入session，但session无info信息时，尝试关联callerPersistentId与toPersistentId
     * 预期结果: 不关联id,直接返回
     */
    it('test_linkCallerAndToPersistentWhenNoSceneInfo_returnNoLinkAll', Level.LEVEL0, async () => {
      let mockLogShowWarn: Function = mocker.mockFunc(mockLog, mockLog.showWarn);
      when(mockLogShowWarn)(ArgumentMatchers.any).afterReturnNothing();
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

      // 构造sceneInfo为null
      ReflectionUtils.setProperty(sceneSession, "sceneInfo", null);
      // 调用接口，关联persistentId
      scbSpecialScenePanelViewModel.linkCallerAndToPersistentForSession(sceneSession);

      mocker.verify('showWarn', ['linkCallerAndToPersistentForSession, session is null or scene info is null.']).once();
      mocker.ignoreMock(mockLog, mockLog.showWarn);
    });

    /**
     * 用例描述: 根据persistentId关联session的callerPersistentId与toPersistentId
     * 预置条件: 创建session列表
     * 测试场景: 当传入session且callerPersistentId不大于0时，尝试关联callerPersistentId与toPersistentId
     * 预期结果: callerPersistentId不关联id,sessionInfo的callerPersistentId置0
     */
    it('test_linkCallerAndToPersistentWhenCallerPersistentIdNotBigThanZero_returnNoLinkCallerPersistentId',
      Level.LEVEL0,
      async () => {
        let persistentId = 123;
        let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, persistentId);
        let sceneSession: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
        sceneSession.sceneInfo.toPersistentId = persistentId;

        let persistentId2 = 0;
        let sceneInfo2 = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, persistentId2);
        let sceneSession2: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo2), sceneInfo2);
        sceneSession2.sceneInfo.toPersistentId = persistentId2;

        // mock 获取session数据接口
        let mockGetSceneSessionByPersistentId: Function = mocker.mockFunc(scbSpecialScenePanelViewModel,
          scbSpecialScenePanelViewModel.getSceneSessionByPersistentId);
        when(mockGetSceneSessionByPersistentId)(persistentId).afterReturn(sceneSession);
        // 调用接口，关联persistentId
        scbSpecialScenePanelViewModel.linkCallerAndToPersistentForSession(sceneSession2);
        expect(sceneSession.sceneInfo.toPersistentId).assertEqual(persistentId);
        // 置零persistentId
        expect(sceneSession2.sceneInfo.toPersistentId).assertEqual(0);

        // 覆盖条件 小于0
        let persistentIdOther = -1;
        sceneSession2.sceneInfo.toPersistentId = persistentIdOther;
        when(mockGetSceneSessionByPersistentId)(persistentIdOther).afterReturn(sceneSession);
        // 调用接口，关联persistentId
        scbSpecialScenePanelViewModel.linkCallerAndToPersistentForSession(sceneSession2);
        expect(sceneSession.sceneInfo.toPersistentId).assertEqual(persistentId);
        // 置零persistentId
        expect(sceneSession2.sceneInfo.toPersistentId).assertEqual(0);
      });

    /**
     * 用例描述: 根据persistentId关联session的callerPersistentId与toPersistentId
     * 预置条件: 创建session列表
     * 测试场景: 当传入session且callerPersistentId大于0且toPersistentId小于0时，尝试关联callerPersistentId与toPersistentId
     * 预期结果: callerPersistentId关联id,toPersistentId不关联id,sessionInfo的callerPersistentId与toPersistentId置0
     */
    it('test_linkCallerAndToPersistentWhenToPersistentIdLessThanZero_returnNoLinkToPersistentId', Level.LEVEL0,
      async () => {
        let persistentId = 123;
        let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, persistentId);
        let sceneSession: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
        sceneSession.sceneInfo.toPersistentId = persistentId;
        sceneSession.sceneInfo.callerPersistentId = persistentId;

        let persistentId2 = -1;
        let callertPersistentId2 = 1;
        let sceneInfo2 = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, persistentId2);
        let sceneSession2: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo2), sceneInfo2);
        sceneSession2.sceneInfo.callerPersistentId = callertPersistentId2;
        sceneSession2.sceneInfo.toPersistentId = persistentId2;

        // mock 获取session数据接口
        let mockGetSceneSessionByPersistentId: Function = mocker.mockFunc(scbSpecialScenePanelViewModel,
          scbSpecialScenePanelViewModel.getSceneSessionByPersistentId);
        when(mockGetSceneSessionByPersistentId)(callertPersistentId2).afterReturn(sceneSession);
        // 调用接口，关联persistentId
        scbSpecialScenePanelViewModel.linkCallerAndToPersistentForSession(sceneSession2);
        expect(sceneSession.sceneInfo.toPersistentId).assertEqual(persistentId2);
        // 置零persistentId
        expect(sceneSession2.sceneInfo.toPersistentId).assertEqual(0);
      });

    /**
     * 用例描述: 更新session的callerPersistentId与toPersistentId
     * 预置条件: 创建session列表
     * 测试场景: 当传入session且callerPersistentId、toPersistentId均大于0时，尝试关联callerPersistentId与toPersistentId
     * 预期结果: callerPersistentId、toPersistentId关联id,sessionInfo的callerPersistentId与toPersistentId置0
     */
    it('test_linkCallerAndToPersistentWhenCallerPersistentAndToPersistentIdBigThanZero_returnLinkAll', Level.LEVEL0,
      async () => {
        let persistentId = 123;
        let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, persistentId);
        let sceneSession: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
        sceneSession.sceneInfo.toPersistentId = persistentId;
        sceneSession.sceneInfo.callerPersistentId = persistentId;

        let persistentId2 = 2;
        let callertPersistentId2 = 1;
        let sceneInfo2 = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, persistentId2);
        let sceneSession2: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo2), sceneInfo2);
        sceneSession2.sceneInfo.callerPersistentId = callertPersistentId2;
        sceneSession2.sceneInfo.toPersistentId = persistentId2;

        // mock 获取session数据接口
        let mockGetSceneSessionByPersistentId: Function = mocker.mockFunc(scbSpecialScenePanelViewModel,
          scbSpecialScenePanelViewModel.getSceneSessionByPersistentId);
        when(mockGetSceneSessionByPersistentId)(persistentId2).afterReturn(sceneSession);
        // 调用接口，关联persistentId
        scbSpecialScenePanelViewModel.linkCallerAndToPersistentForSession(sceneSession2);
        expect(sceneSession.sceneInfo.callerPersistentId).assertEqual(callertPersistentId2);
        // 置零persistentId
        expect(sceneSession2.sceneInfo.toPersistentId).assertEqual(0);
      });
  })

  describe('SCBSpecialScenePanelViewModel_updateCallerSessionIdAndToSessionId_testSuite', (): void => {
    let mocker: MockKit;
    let scbSpecialScenePanelViewModel: SCBSpecialScenePanelViewModel;

    beforeAll(() => {
      mocker = new MockKit();
      scbSpecialScenePanelViewModel =
        new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
    });

    /**
     * 用例描述: 根据persistentId关联session的callerPersistentId与toPersistentId
     * 预置条件: 创建session列表
     * 测试场景: 当传入session，但session无info信息时，尝试更新callerPersistentId与toPersistentId
     * 预期结果: 不更新id,直接返回
     */
    it('test_updateCallerSessionIdAndToSessionIdWhenNoSceneInfo_returnNotUpdateId', Level.LEVEL0, async () => {
      let mockLogShowWarn: Function = mocker.mockFunc(mockLog, mockLog.showWarn);
      when(mockLogShowWarn)(ArgumentMatchers.any).afterReturnNothing();
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

      // 构造sceneInfo为null
      ReflectionUtils.setProperty(sceneSession, "sceneInfo", null);
      // 调用接口，更新persistentId
      scbSpecialScenePanelViewModel.updateCallerSessionIdAndToSessionId(sceneSession, 123);

      mocker.verify('showWarn', ['set caller persistentId, but null session or scene info.']).once();
      mocker.ignoreMock(mockLog, mockLog.showWarn);
    })

    /**
     * 用例描述: 根据persistentId关联session的callerPersistentId与toPersistentId
     * 预置条件: 创建session列表
     * 测试场景: 当传入session的callerPersistentId与新的callerPersistentId相同,且不为0，尝试更新callerPersistentId与toPersistentId
     * 预期结果: 更新id
     */
    it('test_updateCallerSessionIdAndToSessionIdWhenCallerPersistentIdIsTheSame_returnUpdateId', Level.LEVEL0,
      async () => {
        let persistentId = 123;
        let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, persistentId);
        let sceneSession: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
        sceneSession.sceneInfo.callerPersistentId = persistentId;

        // 调用接口，更新persistentId
        scbSpecialScenePanelViewModel.updateCallerSessionIdAndToSessionId(sceneSession, persistentId);

        expect(sceneSession.sceneInfo.callerPersistentId).assertEqual(0);
      })

    /**
     * 用例描述: 根据persistentId关联session的callerPersistentId与toPersistentId
     * 预置条件: 创建session列表
     * 测试场景: 当传入session的callerPersistentId与新的callerPersistentId相同,且为0，尝试更新callerPersistentId与toPersistentId
     * 预期结果: 不更新id
     */
    it('test_updateCallerSessionIdAndToSessionIdWhenCallerPersistentIdIsTheSameAndNotBeZero_returnNotUpdateId',
      Level.LEVEL0, async () => {
        let persistentId = 0;
        let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, persistentId);
        let sceneSession: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
        sceneSession.sceneInfo.callerPersistentId = persistentId;

        // 调用接口，更新persistentId
        scbSpecialScenePanelViewModel.updateCallerSessionIdAndToSessionId(sceneSession, persistentId);

        expect(sceneSession.sceneInfo.callerPersistentId).assertEqual(0);
      })

    /**
     * 用例描述: 根据persistentId关联session的callerPersistentId与toPersistentId
     * 预置条件: 创建session列表
     * 测试场景: 当传入session的callerPersistentId与新的callerPersistentId不相同
     * 预期结果: 更新id
     */
    it('test_updateCallerSessionIdAndToSessionIdWhenCallerPersistentIdIsNotTheSame_returnUpdateId', Level.LEVEL0,
      async () => {
        let persistentId = 123;
        let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, persistentId);
        let sceneSession: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
        sceneSession.sceneInfo.callerPersistentId = persistentId;

        let persistentId2 = 234;
        let sceneInfo2 = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, persistentId2);
        let sceneSession2: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo2), sceneInfo2);
        sceneSession2.sceneInfo.callerPersistentId = persistentId2;

        // mock 获取session数据接口
        let mockGetSceneSessionByPersistentId: Function = mocker.mockFunc(scbSpecialScenePanelViewModel,
          scbSpecialScenePanelViewModel.getSceneSessionByPersistentId);
        scbSpecialScenePanelViewModel.getContainerSessionList()
          .push(new SCBSceneContainerSession(sceneSession2, new SCBScreenProperty()));
        when(mockGetSceneSessionByPersistentId)(persistentId2).afterReturn(sceneSession2);

        // 调用接口，更新persistentId
        scbSpecialScenePanelViewModel.updateCallerSessionIdAndToSessionId(sceneSession, persistentId2);

        expect(sceneSession2.sceneInfo.toPersistentId).assertEqual(persistentId);
        expect(sceneSession.sceneInfo.callerPersistentId).assertEqual(persistentId2);
      })

    /**
     * 用例描述: 根据persistentId关联session的callerPersistentId与toPersistentId
     * 预置条件: 创建session列表
     * 测试场景: 根据新的callerPersistentId获取session，当sceneInfo不存在
     * 预期结果: 仅更新旧session的callerPersistentId
     */
    it('test_updateCallerSessionIdAndToSessionIdWhenNewCallerPersistentIdSessionNotExist_returnUpdateCallerPersistentId',
      Level.LEVEL0, async () => {
        let persistentId = 123;
        let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, persistentId);
        let sceneSession: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
        sceneSession.sceneInfo.callerPersistentId = persistentId;

        let persistentId2 = 234;
        let sceneInfo2 = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, persistentId2);
        let sceneSession2: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo2), sceneInfo2);
        sceneSession2.sceneInfo.callerPersistentId = persistentId2;
        sceneSession2.sceneInfo.toPersistentId = persistentId2

        // mock 获取session数据接口
        let mockGetSceneSessionByPersistentId: Function = mocker.mockFunc(scbSpecialScenePanelViewModel,
          scbSpecialScenePanelViewModel.getSceneSessionByPersistentId);
        scbSpecialScenePanelViewModel.getContainerSessionList()
          .push(new SCBSceneContainerSession(sceneSession2, new SCBScreenProperty()));
        when(mockGetSceneSessionByPersistentId)(persistentId2).afterReturn(null);

        // 调用接口，更新persistentId
        scbSpecialScenePanelViewModel.updateCallerSessionIdAndToSessionId(sceneSession, persistentId2);

        expect(sceneSession2.sceneInfo.toPersistentId).assertEqual(persistentId2);
        expect(sceneSession.sceneInfo.callerPersistentId).assertEqual(0);
      })
  })

  describe('SCBSpecialScenePanelViewModel_onMinimizeScene_testSuite', () => {
    let mocker: MockKit = new MockKit();
    let viewModel: SCBSpecialScenePanelViewModel =
      new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9527);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let sceneContainerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

    let keyboardSession: SCBKeyboardSession;
    let keyboardChangeCallbackMap: Map<string, KeyboardChangeCallback> = new Map<string, KeyboardChangeCallback>();
    let keyboardChangeListenerList: Array<KeyboardChangeCallback> = new Array();
    keyboardSession = new SCBKeyboardSession(sceneSessionManager.requestSceneSession(sceneInfo),
      () => {}, keyboardChangeCallbackMap, keyboardChangeListenerList);
    viewModel.init(keyboardSession, panelStateCollectionHandler);

    beforeAll(() => {
      viewModel.getContainerSessionList().clear();
    })

    afterEach(() => {
      viewModel.getContainerSessionList().clear();
    });

    it('test_whenContainerSessionIsNotFound_thenShouldLogError', Level.LEVEL0, () => {
      let mockShowError: Function = mocker.mockFunc(mockLog, mockLog.showError);
      when(mockShowError)(ArgumentMatchers.any).afterReturnNothing();

      viewModel.onMinimizeScene(-1, -1);

      mocker.verify('showError', [`cannot find containerSession with persistentId:-1`]).atLeast(1);
      mocker.ignoreMock(mockLog, mockLog.showError);
    });

    it('test_whenContainerSessionIsAlreadyBackground_thenShouldLogWarn', Level.LEVEL0, () => {
      ReflectionUtils.setProperty(sceneContainerSession, '_isActive', false);
      viewModel.getContainerSessionList().push(sceneContainerSession);
      let mockShowWarn: Function = mocker.mockFunc(mockLog, mockLog.showWarn);
      when(mockShowWarn)(ArgumentMatchers.any).afterReturnNothing();

      viewModel.onMinimizeScene(9527);

      mocker.verify('showWarn', [`containerSession is already background:9527`]).atLeast(1);
      mocker.ignoreMock(mockLog, mockLog.showWarn);
    });

    it('test_whenContainerSessionIsSplit_thenShouldLogError', Level.LEVEL0, () => {
      ReflectionUtils.setProperty(sceneContainerSession, '_isActive', true);
      ReflectionUtils.setProperty(sceneContainerSession, 'isSplit', true);
      viewModel.getContainerSessionList().push(sceneContainerSession);
      let mockShowError: Function = mocker.mockFunc(mockLog, mockLog.showError);
      when(mockShowError)(ArgumentMatchers.any).afterReturnNothing();

      viewModel.onMinimizeScene(9527);

      mocker.verify('showError', [`show when locked session cannot be split`]).atLeast(1);
      mocker.ignoreMock(mockLog, mockLog.showError);
    });

    it('test_whenSucceedBackToCallerIsSuccessful_thenShouldLogInfo', Level.LEVEL0, () => {
      ReflectionUtils.setProperty(sceneContainerSession, '_isActive', true);
      ReflectionUtils.setProperty(sceneContainerSession, 'isSplit', false);
      viewModel.getContainerSessionList().push(sceneContainerSession);
      let mockShowInfo: Function = mocker.mockFunc(mockLog, mockLog.showInfo);
      let mockSucceedBackToCaller: Function = mocker.mockFunc(viewModel, viewModel.succeedBackToCaller);
      when(mockShowInfo)(ArgumentMatchers.any).afterReturnNothing();
      when(mockSucceedBackToCaller)(ArgumentMatchers.any).afterReturn(true);

      viewModel.onMinimizeScene(9527);

      mocker.verify('showInfo', [`succeedBackToCaller success`]).atLeast(1);
      mocker.ignoreMock(mockLog, mockLog.showInfo);
      mocker.ignoreMock(viewModel, viewModel.succeedBackToCaller);
    });

    it('test_whenSucceedBackToCallerIsFails_thenRequestSceneContainerBackgroundAndUpdateState', Level.LEVEL0, () => {
      ReflectionUtils.setProperty(sceneContainerSession, '_isActive', true);
      ReflectionUtils.setProperty(sceneContainerSession, 'isSplit', false);
      viewModel.getContainerSessionList().push(sceneContainerSession);
      let mockSucceedBackToCaller: Function = mocker.mockFunc(viewModel, viewModel.succeedBackToCaller);
      let mockRequestSceneContainerBackgroundWithTransition: Function =
        mocker.mockFunc(viewModel, viewModel.requestSceneContainerBackgroundWithTransition);
      when(mockSucceedBackToCaller)(ArgumentMatchers.any).afterReturn(false);
      when(mockRequestSceneContainerBackgroundWithTransition)(ArgumentMatchers.any).afterReturnNothing();
      ReflectionUtils.getProperty(viewModel,
        'panelStateCollectionHandler')?.updatePanelState(ScenePanelState.FULLSCENE);

      viewModel.onMinimizeScene(9527);

      expect(ReflectionUtils.getProperty(viewModel, 'panelStateCollectionHandler')?.getPanelState())
        .assertEqual(ScenePanelState.HOME);
      mocker.ignoreMock(viewModel, viewModel.succeedBackToCaller);
      mocker.ignoreMock(viewModel, viewModel.requestSceneContainerBackgroundWithTransition);
    });
  });

  describe('SCBSpecialScenePanelViewModel_succeedBackToCaller_testSuite', () => {
    let viewModel: SCBSpecialScenePanelViewModel =
      new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9527);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let sceneContainerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());


    it('test_whenCallerPersistentIdIsZero_thenReturnFalse', Level.LEVEL0, () => {
      sceneSession.sceneInfo.callerPersistentId = 0;

      let ret: boolean = viewModel.succeedBackToCaller(sceneContainerSession, 1);

      expect(ret).assertFalse();
    });
  });

  describe('SCBSpecialScenePanelViewModel_requestSceneContainerBackgroundWithTransition_testSuite', () => {
    let viewModel: SCBSpecialScenePanelViewModel =
      new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9527);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let sceneContainerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());


    it('test_whenIsMoveRollbackFalse_thenSuccess', Level.LEVEL0, () => {
      sceneContainerSession.isDisappearing = false;

      viewModel.requestSceneContainerBackgroundWithTransition(sceneContainerSession);

      expect(sceneContainerSession.isDisappearing).assertTrue();
    });
  });

  describe('SCBSpecialScenePanelViewModel_getSceneSession_testSuite', () => {
    let viewModel: SCBSpecialScenePanelViewModel =
      new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
    let sceneInfo: SCBSceneInfo =
      new SCBSceneInfo('testBundleUnique', 'testModuleUnique', 'testAbilityUnique', 0, 6545);

    beforeEach(() => {
      SCBSceneSessionManager.getInstance().getFloatingSessionList().clear();
      SCBSceneSessionManager.getInstance().getSpecialContainerSessionList().clear();
      SCBSceneSessionManager.getInstance().getContainerSessionList().clear();
    });

    it('test_whenAllContainerSessionListIsEmpty_thenReturnNull', Level.LEVEL0, () => {
      let ret: SCBSceneSession | null = viewModel.getSceneSession(sceneInfo);

      expect(ret).assertNull();
    });
  });

  describe('SCBSpecialScenePanelViewModel_getTopActiveSceneContainerSession_testSuite', () => {
    let viewModel: SCBSpecialScenePanelViewModel =
      new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9527);

    afterEach(() => {
      viewModel.getContainerSessionList().clear();
    });

    it('test_whenSpecialContainerSessionListIsEmpty_thenReturnNull', Level.LEVEL0, () => {
      let ret: SCBSceneContainerSession | null = viewModel.getTopActiveSceneContainerSession();

      expect(ret).assertNull();
    });
  });

  describe('SCBSpecialScenePanelViewModel_onLockReceived_testSuite', () => {
    let viewModel: SCBSpecialScenePanelViewModel =
      new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
    let mocker: MockKit = new MockKit();
    afterEach(() => {
      viewModel.getContainerSessionList().clear();
    });

    it('test_whenSpecialContainerSessionListIsEmpty_thenReturnNull', Level.LEVEL0, () => {
      let mockRecentLog: Function = mocker.mockFunc(mockLog, mockLog.showInfo)
      when(mockRecentLog)(ArgumentMatchers.any).afterReturnNothing();

      viewModel.onLockReceived();

      mocker.verify('showInfo', ['no activeSession, begin rotation recover']).atLeast(1);
      mocker.ignoreMock(mockLog, mockLog.showInfo)
    });
  });

  describe('SCBSpecialScenePanelViewModel_succeedBackToCaller_testSuite02', () => {
    let viewModel: SCBSpecialScenePanelViewModel =
      new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9527);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let sceneContainerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());


    it('test_whenCallerPersistentIdIsZero_thenReturnFalse', Level.LEVEL0, () => {
      sceneSession.sceneInfo.callerPersistentId = 0;

      let ret: boolean = viewModel.succeedBackToCaller(sceneContainerSession, 1);

      expect(ret).assertFalse();
    });
  });

  describe('SCBSpecialScenePanelViewModel_release_testSuite', () => {
    let viewModel: SCBSpecialScenePanelViewModel =
      new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());

    it('test_whenRelease_thenUnRegisterCallback', Level.LEVEL0, () => {
      viewModel.release();
      let handler: SpecialScenePanelStateCollectionHandler | null =
        ReflectionUtils.getProperty(viewModel, 'panelStateCollectionHandler');
      expect(handler).assertNull();
    });
  });

  describe('SCBSpecialScenePanelViewModel_onTransferSceneIn_testSuite', () => {
    let viewModel: SCBSpecialScenePanelViewModel =
      new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9537);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    sceneSession.sessionData.isShowWhenLocked = true;
    let sceneContainerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
    sceneContainerSession.isMidScene = false;
    sceneContainerSession.isSplit = false;
    ReflectionUtils.setProperty(sceneContainerSession, 'isActive', true);

    let sessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();


    it('test_whenSessionListIsNotEmptyAndActiveSessionCountBigThanZero_thenDisappear', Level.LEVEL0, () => {
      viewModel.addSpecialSceneContainerSession(sceneContainerSession);
      sessionList.add(sceneContainerSession);
      viewModel.onTransferSceneIn(sessionList);
      expect(sceneContainerSession.isDisappearing).assertFalse();
    });

    it('test_whenSessionIsFloat_thenSetFloatState', Level.LEVEL0, () => {
      ReflectionUtils.setProperty(sceneContainerSession, 'isFloat', true);
      sessionList.add(sceneContainerSession);
      viewModel.onTransferSceneIn(sessionList);
      let isFloat: boolean = ReflectionUtils.getProperty(sceneContainerSession, 'isFloat');
      expect(isFloat).assertFalse();
    });

    it('test_whenPrimarySessionIsNull_thenFocusSecondarySession', Level.LEVEL0, () => {
      sceneContainerSession.primarySession = null;
      sceneContainerSession.secondarySession = sceneSession;
      sessionList.add(sceneContainerSession);
      viewModel.onTransferSceneIn(sessionList);
      expect(sceneContainerSession.getFocusedSession()).assertNull();
    });
  });

  describe('SCBSpecialScenePanelViewModel_onTransferSceneOut_testSuite', () => {
    let viewModel: SCBSpecialScenePanelViewModel =
      new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9537);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let sceneContainerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
    ReflectionUtils.setProperty(sceneContainerSession, 'isActive', true);
    let sessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();

    let keyboardSession = new SCBKeyboardSession(sceneSessionManager.requestSceneSession(sceneInfo),
      () => {
      }, keyboardChangeCallbackMap, keyboardChangeListenerList);
    viewModel.init(keyboardSession, panelStateCollectionHandler);


    it('test_whenIsNotScreenLocked_thenClearSessionlist', Level.LEVEL0, () => {
      viewModel.onTransferSceneIn(sessionList);
      viewModel.onTransferSceneOut();

      let specialSessionList: SCBSceneContainerSessionArray =
        ReflectionUtils.getProperty(viewModel, 'specialContainerSessionList');
      expect(specialSessionList.length).assertEqual(0);
    });

    it('test_whenIsScreenLocked_thenDeleteSession', Level.LEVEL0, () => {
      viewModel.onTransferSceneIn(sessionList);
      let ssm = SCBSceneSessionManager.getInstance();
      ReflectionUtils.setProperty(ssm, 'isScreenLock', true);
      viewModel.onTransferSceneOut();

      let specialSessionList: SCBSceneContainerSessionArray =
        ReflectionUtils.getProperty(viewModel, 'specialContainerSessionList');
      expect(specialSessionList.length).assertEqual(0);

    });

    it('test_whenNoActiveSession_thenUpdateScenePanelState', Level.LEVEL0, () => {
      viewModel.onTransferSceneOut();
      expect(panelStateCollectionHandler.getPanelState()).assertEqual(ScenePanelState.HOME);
    });
  });

  describe('SCBSpecialScenePanelViewModel_sceneContainerTransitionOut_testSuite', () => {
    let viewModel: SCBSpecialScenePanelViewModel =
      new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9537);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let sceneContainerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

    it('test_whenIsNotMoveRollback_thenSetIconAlphaToZero', Level.LEVEL0, () => {
      let panelAnimator: SCBSpecialScenePanelAnimator = ReflectionUtils.getProperty(viewModel, 'panelAnimator')
      panelAnimator.sceneContainerTransitionOut(sceneContainerSession, false);
      expect(sceneContainerSession.iconAlpha).assertEqual(0);
    });
  });

  describe('SCBSpecialScenePanelViewModel_buildRectForTransition_testSuite', () => {
    let viewModel: SCBSpecialScenePanelViewModel =
      new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9537);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let sceneContainerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

    it('test_whenCompanionIconInfoNotNull_thenSetBundleNameToNull', Level.LEVEL0, () => {
      let scbTransitionController: SCBTransitionController = {
        appData: {
          bundleName: '',
          abilityName: '',
          appIconId: 'OpenFolderGridSwiperGlobal',
          appIconNumber: 0,
          iconRadius: 0
        },
        onActive: (): void => {},
        onInactive: (): void =>{}
      };
      sceneContainerSession.initCompanionIconInfo(sceneInfo, scbTransitionController);
      ReflectionUtils.useFunc(viewModel, 'buildRectForTransition', sceneContainerSession);
      expect(sceneContainerSession.companionIconInfo.bundleName).assertEqual('');
    });

    it('test_whenIsNotScreenVertical_thenUpdateOpacitySuccess', Level.LEVEL0, () => {
      let screenProperty = new SCBScreenProperty();
      screenProperty.rotation = RotationConstants.ROTATION_360;
      ReflectionUtils.setProperty(viewModel, 'screenProperty', screenProperty);
      ReflectionUtils.useFunc(viewModel, 'buildRectForTransition', sceneContainerSession);
      let shouldHideStatusBar: boolean = ReflectionUtils.getProperty(viewModel, 'shouldHideStatusBar');
      expect(shouldHideStatusBar).assertTrue();
    });
  });

  describe('SCBSpecialScenePanelViewModel_updateCallerSessionIdAndToSessionId_testSuite', () => {
    let viewModel: SCBSpecialScenePanelViewModel =
      new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9537);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenSceneInfoIsNull_thenReturn', Level.LEVEL0, () => {
      ReflectionUtils.setProperty(sceneSession, 'sceneInfo', null);
      viewModel.updateCallerSessionIdAndToSessionId(sceneSession, 2);
      expect(sceneSession.sceneInfo).assertNull();
    });
  });

  describe('SCBSpecialScenePanelViewModel_isItemShowCanBeChanged_testSuite', () => {
    let viewModel: SCBSpecialScenePanelViewModel =
      new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9537);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let sceneContainerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

    it('test_whenIsRemoveAndIsNotShow_thenReturnTrue', Level.LEVEL0, () => {
      let res: boolean = viewModel.isItemShowCanBeChanged(sceneContainerSession, true);
      expect(res).assertTrue();
    });

    it('test_whenIsRemoveAndSceneInfoIsNull_thenReturnFalse', Level.LEVEL0, () => {
      sceneContainerSession.primarySession = null;
      let res: boolean = viewModel.isItemShowCanBeChanged(sceneContainerSession, true);
      expect(res).assertFalse();
    });
  });

  describe('SCBSpecialScenePanelViewModel_getSceneSession_testSuite', () => {
    let viewModel: SCBSpecialScenePanelViewModel =
      new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9547);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let sceneContainerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

    it('test_whenSpecialSceneSessionTupleExist_thenReturnSpecialTupleIndexZero', Level.LEVEL0, () => {
      viewModel.addSpecialSceneContainerSession(sceneContainerSession);
      let res: SCBSceneSession | null = viewModel.getSceneSession(sceneInfo);
      expect(res?.sceneInfo?.bundleName).assertEqual('testBundle');
      viewModel.removeSpecialSceneContainerSession(sceneContainerSession);
    });

    it('test_whenSceneSessionTupleExist_thenReturnSessionTupleIndexZero', Level.LEVEL0, () => {
      let ssm = SCBSceneSessionManager.getInstance();
      let SCBSCSArray = new SCBSceneContainerSessionArray();
      SCBSCSArray.add(sceneContainerSession);
      let callback = () => {
        return SCBSCSArray;
      }
      ssm.mainScreenId = 233;
      ssm.registerGetContainerSessionListCallback(callback, 233);

      let res: SCBSceneSession | null = viewModel.getSceneSession(sceneInfo);
      expect(res?.sceneInfo?.bundleName).assertEqual('testBundle');
      ssm.unregisterGetContainerSessionListCallback(233);
    });

    it('test_whenSceneFloatSessionTupleExist_thenReturnFloatTupleIndexZero', Level.LEVEL0, () => {
      let ssm = SCBSceneSessionManager.getInstance();

      let SCBSCSArray = new SCBSceneContainerSessionArray();
      SCBSCSArray.add(sceneContainerSession);
      let callback = () => {
        return SCBSCSArray;
      }
      ssm.registerGetFloatingSessionListCallback(callback);
      let res: SCBSceneSession | null = viewModel.getSceneSession(sceneInfo);
      expect(res?.sceneInfo?.bundleName).assertEqual('testBundle');
      ReflectionUtils.setProperty(ssm, 'getFloatingSessionListCallback', null);
    });

    it('test_whenTupleNotExist_thenReturnNull', Level.LEVEL0, () => {
      let res: SCBSceneSession | null = viewModel.getSceneSession(sceneInfo);
      expect(res).assertNull();
    });
  });

  describe('SCBSpecialScenePanelViewModel_getActiveSceneContainerSessionCount_testSuite', () => {
    let viewModel: SCBSpecialScenePanelViewModel =
      new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9667);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let sceneContainerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
    let sessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();

    it('test_whenInputSessionListExist_thenReturnLengthWhichIsActive', Level.LEVEL0, () => {
      ReflectionUtils.setProperty(sceneContainerSession, 'isActive', true);
      sessionList.add(sceneContainerSession);
      let res: number = viewModel.getActiveSceneContainerSessionCount(sessionList);
      expect(res).assertEqual(0);
    });

    it('test_whenInputSessionListNotExist_thenReturnSpecialContainerLengthWhichIsActive', Level.LEVEL0, () => {
      let res: number = viewModel.getActiveSceneContainerSessionCount();
      expect(res).assertEqual(0);
    });
  });

  describe('SCBSpecialScenePanelViewModel_getContainerSessionByPersistentIdOrContainerId_testSuite', () => {
    let viewModel: SCBSpecialScenePanelViewModel =
      new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9537);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let sceneContainerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

    it('test_whenPersistentIdExist_thenReturnSceneContainerSessionWithPersistentId', Level.LEVEL0, () => {
      viewModel.addSpecialSceneContainerSession(sceneContainerSession);
      let res: SCBSceneContainerSession | null = viewModel.getContainerSessionByPersistentIdOrContainerId(9537);
      expect(res).not().assertNull();
    });

    it('test_whenContainerIdExist_thenReturnSceneContainerSessionWithContainerId', Level.LEVEL0, () => {
      let res: SCBSceneContainerSession | null = viewModel.getContainerSessionByPersistentIdOrContainerId(0, 9557);
      expect(res).assertNull();
    });

    it('test_whenContainerIdAndPersistentIdNotExist_thenReturnNull', Level.LEVEL0, () => {
      let res: SCBSceneContainerSession | null = viewModel.getContainerSessionByPersistentIdOrContainerId(0, 0);
      expect(res).assertNull();
    });
  });

  describe('SCBSpecialScenePanelViewModel_getSessionFromFloatingScene_testSuite', () => {
    let viewModel: SCBSpecialScenePanelViewModel =
      new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9567);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let sceneContainerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

    it('test_whenFloatingSceneSessionFindPersistentId_thenReturnSceneSession', Level.LEVEL0, () => {
      let ssm = SCBSceneSessionManager.getInstance();
      let SCBSCSArray = new SCBSceneContainerSessionArray();
      SCBSCSArray.add(sceneContainerSession);
      let callback = () => {
        return SCBSCSArray;
      }
      ssm.registerGetFloatingSessionListCallback(callback);

      let res: SCBSceneContainerSession | null = viewModel.getSessionFromFloatingScene(9567);
      expect(res).not().assertNull();
      ReflectionUtils.setProperty(ssm, 'getFloatingSessionListCallback', null);
    });

    it('test_whenFloatingSceneSessionNotFindPersistentId_thenReturnNull', Level.LEVEL0, () => {
      let res: SCBSceneContainerSession | null = viewModel.getSessionFromFloatingScene(9567);
      expect(res).assertNull();
    });
  });

  describe('SCBSpecialScenePanelViewModel_succeedBackToCaller_testSuite', () => {
    let persistentId = 9577;
    let viewModel: SCBSpecialScenePanelViewModel =
      new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, persistentId);
    sceneInfo.callerPersistentId = 9577;
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let sceneContainerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

    it('test_whenCallerPersistentIdIsUndefined_thenReturnFalse', Level.LEVEL0, () => {
      sceneInfo.callerPersistentId = undefined;
      let sceneSession2: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sceneContainerSession2: SCBSceneContainerSession =
        new SCBSceneContainerSession(sceneSession2, new SCBScreenProperty());
      let res: boolean = viewModel.succeedBackToCaller(sceneContainerSession2, persistentId);
      expect(res).assertFalse();
    });

    it('test_whenCallerPersistentIdIsZero_thenReturnFalse', Level.LEVEL0, () => {
      sceneInfo.callerPersistentId = 0;
      let sceneSession2: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sceneContainerSession2: SCBSceneContainerSession =
        new SCBSceneContainerSession(sceneSession2, new SCBScreenProperty());
      let res: boolean = viewModel.succeedBackToCaller(sceneContainerSession2, persistentId);
      expect(res).assertFalse();
    });

    it('test_whenCallerContainerSessionIsNull_thenReturnFalse', Level.LEVEL0, () => {
      sceneInfo.callerPersistentId = 9578;
      let sceneSession2: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sceneContainerSession2: SCBSceneContainerSession =
        new SCBSceneContainerSession(sceneSession2, new SCBScreenProperty());
      let res: boolean = viewModel.succeedBackToCaller(sceneContainerSession2, persistentId);
      expect(res).assertFalse();
    });

    it('test_whenCallerPersistentIdEqualPersistentId_thenReturnFalse', Level.LEVEL0, () => {
      sceneInfo.callerPersistentId = 9577;
      viewModel.addSpecialSceneContainerSession(sceneContainerSession);
      let res: boolean = viewModel.succeedBackToCaller(sceneContainerSession, persistentId);
      expect(res).assertFalse();
    });

    it('test_whenIsNotPhoneCall_thenReturnTrue', Level.LEVEL0, () => {
      let sceneInfo2: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9579);
      sceneInfo2.callerPersistentId = 9579;
      let sceneSession2: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo2), sceneInfo2);
      let sceneContainerSession2: SCBSceneContainerSession =
        new SCBSceneContainerSession(sceneSession2, new SCBScreenProperty());
      ReflectionUtils.setProperty(viewModel, 'specialContainerSessionList', new SCBSceneContainerSessionArray());
      viewModel.addSpecialSceneContainerSession(sceneContainerSession2);
      let res: boolean = viewModel.succeedBackToCaller(sceneContainerSession2, 9666);
      expect(res).assertTrue();
    });
  });
}