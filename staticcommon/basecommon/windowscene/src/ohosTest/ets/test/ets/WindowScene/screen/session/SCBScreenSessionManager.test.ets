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
import { afterAll, afterEach, ArgumentMatchers, beforeAll, beforeEach, describe, expect, it,
  Level,
  MockKit, when } from '@ohos/hypium';
import {
  SCBScreenProperty,
  SCBScreenSession
} from '../../../../../../../main/ets/screen/session/SCBScreenSession';
import screenSessionManager from '@ohos.screenSessionManager';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import {
  SCBPropertyChangeReason,
  SCBScreenSessionArray,
  SCBScreenSessionManager,
} from '../../../../../../../main/ets/screen/session/SCBScreenSessionManager';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { ReflectionUtils } from '../../utils/ReflectionUtils';
import type { UIContext } from '@ohos.arkui.UIContext';
import { RotationConstants } from '@ohos/commonconstants';


export function SCBScreenSessionManagerTest() {
  SCBScreenSessionManagerBasicTest();
}

function SCBScreenSessionManagerBasicTest() {
  const ZERO: number = 0;
  describe('SCBScreenSessionManagerBasicTest', () => {
    let prop: SCBScreenProperty;
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.

    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
      prop = new SCBScreenProperty();
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

    it('getInstance', 0, () => {
      expect(SCBScreenSessionManager.getInstance()).not().assertFail();
    })

    it('getMainScreenSession', 0, () => {
      let sessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();

      let callbackMap = new Map<string, Function>();
      let testPtr : UIContext;
      let screenSession: screenSessionManager.ScreenSession = {
        screenId: -1,
        name: 'testScreen',
        on: (type: string, callback: Function): void => {
          callbackMap.set(type, callback);
        },
        setScreenRotationLocked: (isLocked: boolean): void => {

        },
        loadContent: (path: string, context: ServiceExtensionContext, storage?: LocalStorage): void => {

        },
        setTouchEnabled: (isTouchEnabled: boolean): void => {

        },
        getScreenUIContext: (): UIContext => {
          return testPtr;
        }
      };
      let scbScreenSession: SCBScreenSession = new SCBScreenSession(screenSession);

      let list: SCBScreenSessionArray = sessionManager.getScreenSessionList();
      if (list.length <= 0) {
        expect(sessionManager.getMainScreenSession()).not().assertTrue();
      } else {
        expect(sessionManager.getMainScreenSession()).assertEqual(list[0]);
      }
    })

    it('getOrientationLockByIpc', 0, () => {
      let sessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      expect(sessionManager.getScreenOrientationLocked()).assertEqual(true);
    })

    it('getScreenOrientationLocked', 0, () => {
      let sessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(sessionManager, sessionManager.getScreenOrientationLocked);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(sessionManager.getScreenOrientationLocked()).assertEqual(true);
    })

    it('getScreenSessionList', 0, () => {
      let sessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      let list: SCBScreenSessionArray = sessionManager.getScreenSessionList();
      expect(sessionManager.getScreenSessionList()).not().assertFail();
      if (list.length > 0) {
        expect(sessionManager.getScreenSessionList()).assertEqual(list)
      }
    })

    it('isFoldablePhoneExpandStatus', 0, () => {
      let sessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      let screenId: number = 0;
      if (sessionManager.getMainScreenSession()?.session) {
        screenId = sessionManager.getMainScreenSession()?.session?.screenId;
      }
      let screenSession = sessionManager.getScreenSession(screenId);
      if (!screenSession) {
        expect(sessionManager.isFoldablePhoneExpandStatus(screenId)).assertEqual(true);
      } else {
        expect(sessionManager.isFoldablePhoneExpandStatus(screenId))
          .assertEqual(screenSession.isFoldablePhoneExpandStatus());

      }
    })

    it('notifyScenePanelFoldChange', 0, () => {
      let sessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      try {
        let scbScreenProp: SCBScreenProperty = new SCBScreenProperty();
        expect(scbScreenProp.top).assertEqual(ZERO);
        expect(scbScreenProp.width).assertEqual(ZERO);
        expect(scbScreenProp.height).assertEqual(ZERO);
        expect(scbScreenProp.radius).assertEqual(ZERO);
        expect(scbScreenProp.rotation).assertEqual(ZERO);
        expect(scbScreenProp.screenId).assertEqual(ZERO);
        let translateX = scbScreenProp.getTranslateX()
        let translateY = scbScreenProp.getTranslateY()
        expect(translateX).assertEqual(ZERO);
        expect(translateY).assertEqual(ZERO);
        let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.ROTATION;
        sessionManager.notifyScenePanelFoldChange(scbScreenProp, reason);
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('notifyScenePanelRotationChange', 0, () => {
      let sessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      try {
        let scbScreenProp: SCBScreenProperty = new SCBScreenProperty();
        expect(scbScreenProp.top).assertEqual(ZERO);
        expect(scbScreenProp.width).assertEqual(ZERO);
        expect(scbScreenProp.height).assertEqual(ZERO);
        expect(scbScreenProp.radius).assertEqual(ZERO);
        expect(scbScreenProp.rotation).assertEqual(ZERO);
        expect(scbScreenProp.screenId).assertEqual(ZERO);
        let translateX = scbScreenProp.getTranslateX()
        let translateY = scbScreenProp.getTranslateY()
        expect(translateX).assertEqual(ZERO);
        expect(translateY).assertEqual(ZERO);

        let currScreenProperty: SCBScreenProperty = new SCBScreenProperty();
        currScreenProperty.copy(scbScreenProp);

        sessionManager.notifyScenePanelRotationChange(scbScreenProp, currScreenProperty);
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('notifyScenePanelRotationChangeWithNullProperty', 0, () => {
      let sessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      try {
        let scbScreenProp: SCBScreenProperty = new SCBScreenProperty();
        expect(scbScreenProp.top).assertEqual(ZERO);
        expect(scbScreenProp.width).assertEqual(ZERO);
        expect(scbScreenProp.height).assertEqual(ZERO);
        expect(scbScreenProp.radius).assertEqual(ZERO);
        expect(scbScreenProp.rotation).assertEqual(ZERO);
        expect(scbScreenProp.screenId).assertEqual(ZERO);
        let translateX = scbScreenProp.getTranslateX()
        let translateY = scbScreenProp.getTranslateY()
        expect(translateX).assertEqual(ZERO);
        expect(translateY).assertEqual(ZERO);

        let currScreenProperty: SCBScreenProperty | null = null;

        sessionManager.notifyScenePanelRotationChange(scbScreenProp, currScreenProperty);
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('notifyScreenLockEvent', 0, () => {
      let sessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      if (typeof screenSessionManager.notifyScreenLockEvent === 'function') {
        try {
          screenSessionManager.notifyScreenLockEvent(1);
        } catch (e) {
          expect(false).assertFail();
        }
      } else {
        expect(false).assertFalse();
      }
    })

    it('resetRotationWhenOrientationLocked1', 0, () => {
      let sessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      try {
        let callbackMap = new Map<string, Function>();
        let testPtr : UIContext;
        let screenSession: screenSessionManager.ScreenSession = {
          screenId: -1,
          name: 'testScreen',
          on: (type: string, callback: Function): void => {
            callbackMap.set(type, callback);
          },
          setScreenRotationLocked: (isLocked: boolean): void => {

          },
          loadContent: (path: string, context: ServiceExtensionContext, storage?: LocalStorage): void => {

          },
          setTouchEnabled: (isTouchEnabled: boolean): void => {

          },
          getScreenUIContext: (): UIContext => {
            return testPtr;
          }
        };
        let scbScreenSession: SCBScreenSession = new SCBScreenSession(screenSession);
        sessionManager.resetRotationWhenOrientationLocked(scbScreenSession);
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('resetRotationWhenOrientationLocked2', 0, () => {
      let sessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      try {
        let callbackMap = new Map<string, Function>();
        let screenSession: screenSessionManager.ScreenSession = {
          screenId: -1,
          name: 'testScreen',
          on: (type: string, callback: Function): void => {
            callbackMap.set(type, callback);
          },
          setScreenRotationLocked: (isLocked: boolean): void => {
          },
          loadContent: (path: string, context: ServiceExtensionContext, storage?: LocalStorage): void => {
          },
          setTouchEnabled: (isTouchEnabled: boolean): void => {
          },
          getScreenUIContext: (): UIContext => {
            throw new Error('Function not implemented.');
          }
        };
        let scbScreenSession: SCBScreenSession = new SCBScreenSession(screenSession);
        scbScreenSession.scbScreenProperty.rotation = RotationConstants.ROTATION_0;
        sessionManager.resetRotationWhenOrientationLocked(scbScreenSession);
        expect(scbScreenSession.scbScreenProperty.rotation).assertEqual(RotationConstants.ROTATION_0);
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('resetRotationWhenOrientationLocked3', 0, () => {
      let sessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      try {
        let callbackMap = new Map<string, Function>();
        let screenSession: screenSessionManager.ScreenSession = {
          screenId: -1,
          name: 'testScreen',
          on: (type: string, callback: Function): void => {
            callbackMap.set(type, callback);
          },
          setScreenRotationLocked: (isLocked: boolean): void => {
          },
          loadContent: (path: string, context: ServiceExtensionContext, storage?: LocalStorage): void => {
          },
          setTouchEnabled: (isTouchEnabled: boolean): void => {
          },
          getScreenUIContext: (): UIContext => {
            throw new Error('Function not implemented.');
          }
        };
        let scbScreenSession: SCBScreenSession = new SCBScreenSession(screenSession);
        scbScreenSession.scbScreenProperty.rotation = RotationConstants.ROTATION_90;
        sessionManager.resetRotationWhenOrientationLocked(scbScreenSession);
        expect(scbScreenSession.scbScreenProperty.rotation).assertEqual(RotationConstants.ROTATION_90);
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('resetRotationWhenOrientationLocked4', 0, () => {
      let sessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      try {
        let callbackMap = new Map<string, Function>();
        let screenSession: screenSessionManager.ScreenSession = {
          screenId: -1,
          name: 'testScreen',
          on: (type: string, callback: Function): void => {
            callbackMap.set(type, callback);
          },
          setScreenRotationLocked: (isLocked: boolean): void => {
          },
          loadContent: (path: string, context: ServiceExtensionContext, storage?: LocalStorage): void => {
          },
          setTouchEnabled: (isTouchEnabled: boolean): void => {
          },
          getScreenUIContext: (): UIContext => {
            throw new Error('Function not implemented.');
          }
        };
        let scbScreenSession: SCBScreenSession = new SCBScreenSession(screenSession);
        scbScreenSession.scbScreenProperty.rotation = RotationConstants.ROTATION_180;
        sessionManager.resetRotationWhenOrientationLocked(scbScreenSession);
        expect(scbScreenSession.scbScreenProperty.rotation).assertEqual(RotationConstants.ROTATION_180);
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('resetRotationWhenOrientationLocked5', 0, () => {
      let sessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      try {
        let callbackMap = new Map<string, Function>();
        let screenSession: screenSessionManager.ScreenSession = {
          screenId: -1,
          name: 'testScreen',
          on: (type: string, callback: Function): void => {
            callbackMap.set(type, callback);
          },
          setScreenRotationLocked: (isLocked: boolean): void => {
          },
          loadContent: (path: string, context: ServiceExtensionContext, storage?: LocalStorage): void => {
          },
          setTouchEnabled: (isTouchEnabled: boolean): void => {
          },
          getScreenUIContext: (): UIContext => {
            throw new Error('Function not implemented.');
          }
        };
        let scbScreenSession: SCBScreenSession = new SCBScreenSession(screenSession);
        scbScreenSession.scbScreenProperty.rotation = RotationConstants.ROTATION_270;
        sessionManager.resetRotationWhenOrientationLocked(scbScreenSession);
        expect(scbScreenSession.scbScreenProperty.rotation).assertEqual(RotationConstants.ROTATION_270);
      } catch (e) {
        expect(false).assertFail();
      }
    })
    
    it('setScreenOffDelayTime', 0, () => {
      let sessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      try {
        sessionManager.setScreenOffDelayTime(0);
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('registerAndUnRegisterCbWthAnimationTest_01', Level.LEVEL0, (): void => {
      let callback = (): boolean => {
        return true;
      }
      let sessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      sessionManager.registerRotationAnimationCallbacks(callback);
      sessionManager.unRegisterRotationAnimationCallbacks(callback);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      expect(sessionManager.hasRotationCallbacks(screenProperty)).assertEqual(false);
    })
    it('registerAndUnRegisterCbWthAnimationTest_02', Level.LEVEL0, (): void => {
      let callback = (): boolean => {
        return true;
      }
      let sessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      sessionManager.registerRotationAnimationCallbacks(callback);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      expect(sessionManager.hasRotationCallbacks(screenProperty)).assertEqual(true);
    })
    it('registerAndUnRegisterCbWthAnimationTest_03', Level.LEVEL0, (): void => {
      let callback1 = (): boolean => true;
      let callback2 = (): boolean => true;
      let callback3 = (): boolean => true;
      let sessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      sessionManager.registerRotationAnimationCallbacks(callback1);
      sessionManager.registerRotationAnimationCallbacks(callback2);
      sessionManager.registerRotationAnimationCallbacks(callback3);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      expect(sessionManager.hasRotationCallbacks(screenProperty)).assertEqual(true);
    })

    it('shouldExecuteRegisteredCallbacks', Level.LEVEL0, (): void => {
      let count = 0;
      let callback = () => {
        count++;
      };
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let sessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      sessionManager.registerBeforeRotationAnimationCallbacks(callback);
      sessionManager.notifyExcuteBeforeRotationAnimationCallbacks(screenProperty);
      sessionManager.unRegisterBeforeRotationAnimationCallbacks(callback);
      expect(count).assertEqual(1);
    })

    it('shouldNotExecuteAfterUnregister', Level.LEVEL0, (): void => {
      let count = 0;
      let callback = () => {
        count++;
      };
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let sessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      sessionManager.registerBeforeRotationAnimationCallbacks(callback);
      sessionManager.unRegisterBeforeRotationAnimationCallbacks(callback);
      sessionManager.notifyExcuteBeforeRotationAnimationCallbacks(screenProperty);
      expect(count).assertEqual(0);
    })

    it('updateVisibleSystemRotationBeforeScenePanel', Level.LEVEL0, (): void => {
      let count = 0;
      let screenPropertyChangeCallbackFunc = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
        count++;
      };
      let sessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      sessionManager.registerScreenPropertyChangeCallbacks(screenPropertyChangeCallbackFunc, 0, true, null, true);
      expect(count).assertEqual(0);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      sessionManager.updateVisibleSystemRotationBeforeScenePanel(screenProperty);
      sessionManager.unRegisterScreenPropertyChangeCallbacks(screenPropertyChangeCallbackFunc, 0, true, null, true);
      expect(count).assertEqual(1);
    })

    it('updateSystemSceneFoldChangeBeforeScenePanel', Level.LEVEL0, (): void => {
      let count = 0;
      let screenPropertyChangeCallbackFunc = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
        count++;
      };
      let sessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      sessionManager.registerScreenPropertyChangeCallbacks(screenPropertyChangeCallbackFunc, 0, true, null, true);
      expect(count).assertEqual(0);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      sessionManager.updateSystemSceneFoldChangeBeforeScenePanel(screenProperty, SCBPropertyChangeReason.EXPAND_TO_FOLD);
      sessionManager.unRegisterScreenPropertyChangeCallbacks(screenPropertyChangeCallbackFunc, 0, true, null, true);
      expect(count).assertEqual(1);
    })
  });
}