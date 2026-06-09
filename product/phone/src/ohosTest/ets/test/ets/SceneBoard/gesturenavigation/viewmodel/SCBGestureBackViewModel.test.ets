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

import { CheckEmptyUtils } from '@ohos/basicutils';
import { viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import {
  EventType,
  GestureType,
  PcKeyType,
  scbEventExclusiveManager,
  SCBRotateChangeReason,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBScreenSessionManager,
  SCBSpecificSession,
  SCBSystemSceneSession,
  SystemSessionInfo
} from '@ohos/windowscene';
import {
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBGestureBackViewModel }
  from '@ohos/phonebase/src/main/ets/SceneBoard/gesturenavigation/back/viewmodel/SCBGestureBackViewModel';


export default function SCBGestureBackViewModelTest() {
  describe('SCBGestureBackViewModelTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.·
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

    let historicalPoint: HistoricalPoint = {
      touchObject: {
        type: TouchType.Down,
        id: 0,
        displayX: 0,
        displayY: 0,
        windowX: 0,
        windowY: 0,
        screenX: 0,
        screenY: 0,
        x: 0,
        y: 0
      },
      size: 0,
      force: 0,
      timestamp: 0
    }

    let eventArea: Area = {
      width: 0,
      height: 0,
      position: {
        x: 0, y: 0
      },
      globalPosition: {
        x: 0, y: 0
      }
    };

    let eventTarget: EventTarget = {
      area: eventArea
    };

    let event: GestureEvent = {
      target: eventTarget,
      timestamp: 0,
      source: 0,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: 0,
      repeat: false,
      fingerList: [],
      offsetX: 0,
      offsetY: 1,
      angle: 0,
      speed: 0,
      scale: 0,
      pinchCenterX: 0,
      pinchCenterY: 0,
      velocityX: 0,
      velocityY: 0,
      velocity: 0
    };

    let touchEvent: TouchEvent = {
      target: {
        area: {
          width: 0,
          height: 0,
          position: {
            x: 0, y: 0
          },
          globalPosition: {
            x: 0, y: 0
          }
        }
      },
      timestamp: 0,
      source: 0,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: 0,
      type: TouchType.Down,
      touches: [],
      changedTouches: [{
        id: 0,
        type: 0,
        displayX: 0,
        displayY: 0,
        windowX: 0,
        windowY: 0,
        screenX: 0,
        screenY: 0,
        x: 0,
        y: 0
      }],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [historicalPoint, historicalPoint];
      },
      preventDefault: () => {
      }
    }

    const backViewModel: SCBGestureBackViewModel = new SCBGestureBackViewModel();

    it('SCBGestureBackViewModelTest_init_1', 0, () => {
      let backViewModel: SCBGestureBackViewModel = new SCBGestureBackViewModel();
      let persistentId: number = 10;
      let zIndex: number = 10;
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      expect(backViewModel.init(persistentId, zIndex, screenProperty) === undefined).assertTrue();
    });

    it('SCBGestureBackViewModelTest_sendClickEvent_1', 0, () => {
      let backViewModel: SCBGestureBackViewModel = new SCBGestureBackViewModel();
      expect(backViewModel.sendClickEvent(touchEvent, touchEvent) === undefined).assertTrue();
    });

    it('SCBGestureBackViewModelTest_sendClickEvent_2', 0, () => {
      let backViewModel: SCBGestureBackViewModel = new SCBGestureBackViewModel();
      let persistentId: number = 10;
      let zIndex: number = 10;
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      backViewModel.init(persistentId, zIndex, screenProperty);
      expect(backViewModel.sendClickEvent(touchEvent, touchEvent) === undefined).assertTrue();
    });

    it('SCBGestureBackViewModelTest_registerRotateAnimaChangeCallBack_1', 0, () => {
      let backViewModel: SCBGestureBackViewModel = new SCBGestureBackViewModel();
      expect(backViewModel.registerRotateAnimaChangeCallBack() === undefined).assertTrue();
    });

    it('SCBGestureBackViewModelTest_unRegisterRotateAnimaChangeCallBack_1', 0, () => {
      let backViewModel: SCBGestureBackViewModel = new SCBGestureBackViewModel();
      expect(backViewModel.unRegisterRotateAnimaChangeCallBack() === undefined).assertTrue();
    });

    it('SCBGestureBackViewModelTest_rotateAnimaChangeCallBack_1', 0, () => {
      let backViewModel: SCBGestureBackViewModel = new SCBGestureBackViewModel();
      backViewModel.registerRotateAnimaChangeCallBack();
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let reason: SCBRotateChangeReason = SCBRotateChangeReason.ROTATE_BEGIN;
      expect(SCBScreenSessionManager.getInstance().
        notifyScreenRotateToCallbacks(screenProperty, reason) === undefined).assertTrue();
    });

    it('SCBGestureBackViewModelTest_rotateAnimaChangeCallBack_2', 0, () => {
      let backViewModel: SCBGestureBackViewModel = new SCBGestureBackViewModel();
      backViewModel.registerRotateAnimaChangeCallBack();
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let reason: SCBRotateChangeReason = SCBRotateChangeReason.ROTATE_END;
      expect(SCBScreenSessionManager.getInstance().
        notifyScreenRotateToCallbacks(screenProperty, reason) === undefined).assertTrue();
    });

    it('SCBGestureBackViewModelTest_refreshGestureHotZonePocketFold_1', 0, () => {
      let backViewModel: SCBGestureBackViewModel = new SCBGestureBackViewModel();
      expect(backViewModel.refreshGestureHotZonePocketFold() === undefined).assertTrue();
    });

    it('SCBGestureBackViewModelTest_refreshGestureHotZoneToDefault_2', 0, () => {
      let backViewModel: SCBGestureBackViewModel = new SCBGestureBackViewModel();
      expect(backViewModel.refreshGestureHotZoneToDefault() === undefined).assertTrue();
    });

    it('SCBGestureBackViewModelTest_processBackEvent1', 0, () => {
      let mocker = new MockKit();
      when(mocker.mockFunc(viewMgrPolicy, viewMgrPolicy.isViewShowing))(ArgumentMatchers.any).afterReturn(true);
      expect(backViewModel.processBackEvent(GestureType.BACK, event) === undefined).assertTrue();
      mocker.ignoreMock(viewMgrPolicy, viewMgrPolicy.isViewShowing);
    });

    it('SCBGestureBackViewModelTest_processBackEvent2', 0, () => {
      let mocker = new MockKit();
      when(mocker.mockFunc(viewMgrPolicy, viewMgrPolicy.isViewShowing))(ArgumentMatchers.any).afterReturn(false);
      let scbSceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      when(mocker.mockFunc(SCBSceneSessionManager, SCBSceneSessionManager.getInstance))()
        .afterReturn(scbSceneSessionManager);
      when(mocker.mockFunc(scbSceneSessionManager, scbSceneSessionManager.getFocusedSession))().afterReturn(null);
      expect(backViewModel.processBackEvent(GestureType.BACK, event) === undefined).assertTrue();
      mocker.ignoreMock(viewMgrPolicy, viewMgrPolicy.isViewShowing);
      mocker.ignoreMock(SCBSceneSessionManager, SCBSceneSessionManager.getInstance);
      mocker.ignoreMock(scbSceneSessionManager, scbSceneSessionManager.getFocusedSession);
    });

    it('SCBGestureBackViewModelTest_processBackEvent3', 0, () => {
      let mocker = new MockKit();
      when(mocker.mockFunc(viewMgrPolicy, viewMgrPolicy.isViewShowing))(ArgumentMatchers.any).afterReturn(false);
      let scbSceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      when(mocker.mockFunc(SCBSceneSessionManager, SCBSceneSessionManager.getInstance))()
        .afterReturn(scbSceneSessionManager);
      let scbSpecificSession: SCBSpecificSession = {
        session: {
          type: sceneSessionManager.SessionType.TYPE_PIP
        } as sceneSessionManager.SceneSession
      } as SCBSpecificSession;
      when(mocker.mockFunc(scbSceneSessionManager, scbSceneSessionManager.getFocusedSession))()
        .afterReturn(scbSpecificSession);
      expect(backViewModel.processBackEvent(GestureType.BACK, event) === undefined).assertTrue();
      mocker.ignoreMock(viewMgrPolicy, viewMgrPolicy.isViewShowing);
      mocker.ignoreMock(SCBSceneSessionManager, SCBSceneSessionManager.getInstance);
      mocker.ignoreMock(scbSceneSessionManager, scbSceneSessionManager.getFocusedSession);
    });

    it('SCBGestureBackViewModelTest_processBackEvent4', 0, () => {
      let mocker = new MockKit();
      when(mocker.mockFunc(viewMgrPolicy, viewMgrPolicy.isViewShowing))(ArgumentMatchers.any).afterReturn(false);
      let scbSceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      when(mocker.mockFunc(SCBSceneSessionManager, SCBSceneSessionManager.getInstance))()
        .afterReturn(scbSceneSessionManager);
      let scbSceneSession: SCBSceneSession = {} as SCBSceneSession;
      when(mocker.mockFunc(scbSceneSessionManager, scbSceneSessionManager.getFocusedSession))()
        .afterReturn(scbSceneSession);
      expect(backViewModel.processBackEvent(GestureType.BACK, event) === undefined).assertTrue();
      mocker.ignoreMock(viewMgrPolicy, viewMgrPolicy.isViewShowing);
      mocker.ignoreMock(SCBSceneSessionManager, SCBSceneSessionManager.getInstance);
      mocker.ignoreMock(scbSceneSessionManager, scbSceneSessionManager.getFocusedSession);
    });

    it('SCBGestureBackViewModelTest_processBackEvent_5', 0, () => {
      let gestureBackViewModel = new SCBGestureBackViewModel();
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(viewMgrPolicy, viewMgrPolicy.isViewShowing);
      when(mockFunc)(ViewType.FLASHLIGHT_TIPS).afterReturn(false);
      when(mockFunc)(ViewType.KEYGUARD).afterReturn(true);
      expect(gestureBackViewModel.processBackEvent(GestureType.BACK, event) === undefined).assertTrue()
      mocker.ignoreMock(viewMgrPolicy, viewMgrPolicy.isViewShowing);
    });

    it('SCBGestureBackViewModelTest_processBackEvent_6', 0, () => {
      let gestureBackViewModel = new SCBGestureBackViewModel();
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(viewMgrPolicy, viewMgrPolicy.isViewShowing);
      when(mockFunc)(ViewType.FLASHLIGHT_TIPS).afterReturn(false);
      when(mockFunc)(ViewType.KEYGUARD).afterReturn(false);
      let scbSceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      when(mocker.mockFunc(SCBSceneSessionManager, SCBSceneSessionManager.getInstance))()
        .afterReturn(scbSceneSessionManager);
      let scbSceneSession: SCBSceneSession = {} as SCBSceneSession;
      when(mocker.mockFunc(scbSceneSessionManager, scbSceneSessionManager.getFocusedSession))(10)
        .afterReturn(scbSceneSession);
      expect(gestureBackViewModel.processBackEvent(GestureType.BACK, event) === undefined).assertTrue();
      mocker.ignoreMock(viewMgrPolicy, viewMgrPolicy.isViewShowing);
      mocker.ignoreMock(SCBSceneSessionManager, SCBSceneSessionManager.getInstance);
      mocker.ignoreMock(scbSceneSessionManager, scbSceneSessionManager.getFocusedSession);
    });

    it('SCBGestureBackViewModelTest_registerPcKeyCallback1', 0, () => {
      let mocker = new MockKit();
      when(mocker.mockFunc(viewMgrPolicy, viewMgrPolicy.isViewShowing))(ArgumentMatchers.any).afterReturn(true);
      expect(backViewModel.registerPcKeyCallback(PcKeyType.BACK, true) === undefined).assertTrue();
      mocker.ignoreMock(viewMgrPolicy, viewMgrPolicy.isViewShowing);
    })

    it('SCBGestureBackViewModelTest_registerPcKeyCallback2', 0, () => {
      let mocker = new MockKit();
      when(mocker.mockFunc(viewMgrPolicy, viewMgrPolicy.isViewShowing))(ArgumentMatchers.any).afterReturn(false);
      expect(backViewModel.registerPcKeyCallback(PcKeyType.BACK, false) === undefined).assertTrue();
      mocker.ignoreMock(viewMgrPolicy, viewMgrPolicy.isViewShowing);
    })

    it('SCBGestureBackViewModelTest_registerPcKeyCallback3', 0, () => {
      let mocker = new MockKit();
      when(mocker.mockFunc(viewMgrPolicy, viewMgrPolicy.isViewShowing))(ArgumentMatchers.any).afterReturn(false);
      expect(backViewModel.registerPcKeyCallback(PcKeyType.BACK, true) === undefined).assertTrue();
      mocker.ignoreMock(viewMgrPolicy, viewMgrPolicy.isViewShowing);
    })

    it('SCBGestureBackViewModelTest_registerPcKeyCallback4', 0, () => {
      let mocker = new MockKit();
      when(mocker.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive))(EventType.GESTURE_BACK).afterReturn(true);
      expect(backViewModel.registerPcKeyCallback(PcKeyType.BACK, true) === undefined).assertTrue();
      mocker.ignoreMock(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
    })

    it('SCBGestureBackViewModelTest_registerPcKeyCallback5', 0, () => {
      let mocker = new MockKit();
      when(mocker.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive))(EventType.GESTURE_BACK).afterReturn(false);
      when(mocker.mockFunc(viewMgrPolicy, viewMgrPolicy.isViewShowing))(ViewType.KEYGUARD).afterReturn(true);
      expect(backViewModel.registerPcKeyCallback(PcKeyType.BACK, true) === undefined).assertTrue();
      mocker.ignoreMock(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      mocker.ignoreMock(viewMgrPolicy, viewMgrPolicy.isViewShowing);
    })

    it('SCBGestureBackViewModelTest_registerPcKeyCallback6', 0, () => {
      let mocker = new MockKit();
      when(mocker.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive))(EventType.GESTURE_BACK).afterReturn(false);
      when(mocker.mockFunc(viewMgrPolicy, viewMgrPolicy.isViewShowing))(ViewType.KEYGUARD).afterReturn(false);
      expect(backViewModel.registerPcKeyCallback(PcKeyType.BACK, true) === undefined).assertTrue();
      mocker.ignoreMock(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      mocker.ignoreMock(viewMgrPolicy, viewMgrPolicy.isViewShowing);
    })

    it('SCBGestureBackViewModelTest_registerPcKeyCallback7', 0, () => {
      let mocker = new MockKit();
      when(mocker.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive))(EventType.GESTURE_BACK).afterReturn(false);
      when(mocker.mockFunc(viewMgrPolicy, viewMgrPolicy.isViewShowing))(ViewType.KEYGUARD).afterReturn(false);
      expect(backViewModel.registerPcKeyCallback(PcKeyType.BACK_FLOAT, true) === undefined).assertTrue();
      mocker.ignoreMock(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      mocker.ignoreMock(viewMgrPolicy, viewMgrPolicy.isViewShowing);
    })

    it('SCBGestureBackViewModelTest_setBackResponseRegion1', 0, () => {
      expect(backViewModel.setBackResponseRegion(true, 1, 1) === undefined).assertTrue();
    })

    it('SCBGestureBackViewModelTest_setBackResponseRegion2', 0, () => {
      expect(backViewModel.setBackResponseRegion(false, 1, 1) === undefined).assertTrue();
    })

    it('SCBGestureBackViewModelTest_sceneSessionSetResponseRegion1', 0, () => {
      let mocker = new MockKit();
      let sysSceneSession: SCBSystemSceneSession = {} as SCBSystemSceneSession;
      when(mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty))(ArgumentMatchers.any).afterReturn(true);
      expect(backViewModel.setBackResponseRegion(false, 1, 1) === undefined).assertTrue();
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
    })

    it('SCBGestureBackViewModelTest_sceneSessionSetResponseRegion2', 0, () => {
      let systemSessionInfo: SystemSessionInfo = {
        systemType: sceneSessionManager.SessionType.TYPE_PANEL,
        sceneName: 'SCBGestureBackViewModelTest',
        sceneZIndex: 101,
        isFocusable: false,
        isTouchable: true,
        privacyMode: false,
        hitTestMode: HitTestMode.Default,
        sceneType: sceneSessionManager.SceneType.INPUT_SCENE,
        isOverlayScene: true,
      };
      let sysSceneSession: SCBSystemSceneSession = SCBSceneSessionManager.getInstance()
        .requestSystemSceneSession(systemSessionInfo);
      expect(backViewModel.setBackResponseRegion(true, 1, 1) === undefined).assertTrue();
    })

    it('SCBGestureBackViewModelTest_sceneSessionSetResponseRegion3', 0, () => {
      let systemSessionInfo: SystemSessionInfo = {
        systemType: sceneSessionManager.SessionType.TYPE_PANEL,
        sceneName: 'SCBGestureBackViewModelTest',
        sceneZIndex: 101,
        isFocusable: false,
        isTouchable: true,
        privacyMode: false,
        hitTestMode: HitTestMode.Default,
        sceneType: sceneSessionManager.SceneType.INPUT_SCENE,
        isOverlayScene: true,
      };
      let sysSceneSession: SCBSystemSceneSession = SCBSceneSessionManager.getInstance()
        .requestSystemSceneSession(systemSessionInfo);
      expect(backViewModel.setBackResponseRegion(false, 1, 1) === undefined).assertTrue();
    })
  })
}
