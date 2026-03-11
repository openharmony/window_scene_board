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
  describe, beforeAll, beforeEach, afterEach, afterAll, it,
  expect , MockKit, when, ArgumentMatchers
} from '@ohos/hypium';
import {
  SCBScreenProperty,
  SCBScreenSession
} from '../../../../../../../main/ets/screen/session/SCBScreenSession';
import { SCBScreenSessionManager } from '../../../../../../../../src/main/ets/screen/session/SCBScreenSessionManager';
import screenSessionManager from '@ohos.screenSessionManager';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import type { UIContext } from '@ohos.arkui.UIContext';


export function SCBScreenSessionTest() {
  const ZERO: number = 0;
  describe('SCBScreenPropertyTest', () => {
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
    it('initSCBScreenProperty', 0, () => {
      // let prop_init: SCBScreenProperty = new SCBScreenProperty();
      expect(prop.left).assertEqual(ZERO);
      expect(prop.top).assertEqual(ZERO);
      expect(prop.width).assertEqual(ZERO);
      expect(prop.height).assertEqual(ZERO);
      expect(prop.radius).assertEqual(ZERO);
      expect(prop.rotation).assertEqual(ZERO);
      expect(prop.screenId).assertEqual(ZERO);
    })

    it('SCBScreenProperty_updateTest', 0, () => {
      const bounds: screenSessionManager.RRect = {
        left: 1,
        top: 1,
        width: 100,
        height: 100,
        radius: 1
      };
      let screenProp: screenSessionManager.ScreenProperty = {
        rotation: 1,
        bounds: bounds,
        fakeBounds: bounds,
        isFakeInUse: false
      };
      prop.update(screenProp);

      expect(prop.left).assertEqual(1);
      expect(prop.top).assertEqual(1);
      expect(prop.width).assertEqual(100);
      expect(prop.height).assertEqual(100);
      expect(prop.radius).assertEqual(1);
      expect(prop.rotation).assertEqual(1);
    })

    it('SCBScreenProperty_updateTranslate', 0, () => {
      let translateX = prop.getTranslateX()
      let translateY = prop.getTranslateY()
      expect(translateX).assertEqual(0);
      expect(translateY).assertEqual(0);

      prop.updateTranslate(100, 200);
      translateX = prop.getTranslateX()
      translateY = prop.getTranslateY()
      expect(translateX).assertEqual(100);
      expect(translateY).assertEqual(200);
    })

    it('SCBScreenProperty_copy', 0, () => {
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

      const bounds: screenSessionManager.RRect = {
        left: 2,
        top: 3,
        width: 4,
        height: 5,
        radius: 6,
      };
      let screenProp: screenSessionManager.ScreenProperty = {
        rotation: 1,
        bounds: bounds,
        fakeBounds: bounds,
        isFakeInUse: false
      };
      scbScreenProp.update(screenProp);
      scbScreenProp.updateTranslate(7, 8);

      expect(scbScreenProp.rotation).assertEqual(1);
      expect(scbScreenProp.left).assertEqual(2);
      expect(scbScreenProp.top).assertEqual(3);
      expect(scbScreenProp.width).assertEqual(4);
      expect(scbScreenProp.height).assertEqual(5);
      expect(scbScreenProp.radius).assertEqual(6);
      expect(scbScreenProp.getTranslateX()).assertEqual(7);
      expect(scbScreenProp.getTranslateY()).assertEqual(8);

      prop.copy(scbScreenProp);

      expect(prop.rotation).assertEqual(1);
      expect(prop.left).assertEqual(2);
      expect(prop.top).assertEqual(3);
      expect(prop.width).assertEqual(4);
      expect(prop.height).assertEqual(5);
      expect(prop.radius).assertEqual(6);
      let translateX_copy = prop.getTranslateX();
      let translateY_copy = prop.getTranslateY();
      expect(translateX_copy).assertEqual(7);
      expect(translateY_copy).assertEqual(8);

    })

    it('SCBScreenProperty_copyBounds', 0, () => {
      let bounds: screenSessionManager.RRect = {
        left: 1,
        top: 1,
        width: 1,
        height: 1,
        radius: 1,
      };
      expect(prop.left).assertEqual(ZERO);
      expect(prop.top).assertEqual(ZERO);
      expect(prop.width).assertEqual(ZERO);
      expect(prop.height).assertEqual(ZERO);
      expect(prop.radius).assertEqual(ZERO);

      prop.copyBounds(bounds);
      expect(prop.left).assertEqual(1);
      expect(prop.top).assertEqual(1);
      expect(prop.width).assertEqual(1);
      expect(prop.height).assertEqual(1);
      expect(prop.radius).assertEqual(1);
    })

    it('SCBScreenProperty_isScreenVertical', 0, () => {
      let isScreenVertical = true;
      prop.defaultScreenOrientation = 0;
      prop.rotation = 0;
      isScreenVertical = prop.isScreenVertical();
      expect(isScreenVertical).assertTrue();

      prop.defaultScreenOrientation = 0;
      prop.rotation = 180;
      isScreenVertical = prop.isScreenVertical();
      expect(isScreenVertical).assertTrue();

      prop.defaultScreenOrientation = 0;
      prop.rotation = 90;
      isScreenVertical = prop.isScreenVertical();
      expect(isScreenVertical).assertFalse();

      prop.defaultScreenOrientation = 0;
      prop.rotation = 270;
      isScreenVertical = prop.isScreenVertical();
      expect(isScreenVertical).assertFalse();

      prop.defaultScreenOrientation = 1;
      prop.rotation = 90;
      isScreenVertical = prop.isScreenVertical();
      expect(isScreenVertical).assertTrue();

      prop.defaultScreenOrientation = 1;
      prop.rotation = 270;
      isScreenVertical = prop.isScreenVertical();
      expect(isScreenVertical).assertTrue();

      prop.defaultScreenOrientation = 1;
      prop.rotation = 0;
      isScreenVertical = prop.isScreenVertical();
      expect(isScreenVertical).assertFalse();

      prop.defaultScreenOrientation = 1;
      prop.rotation = 180;
      isScreenVertical = prop.isScreenVertical();
      expect(isScreenVertical).assertFalse();

      prop.defaultScreenOrientation = 111;
      prop.rotation = 123;
      isScreenVertical = prop.isScreenVertical();
      expect(isScreenVertical).assertFalse();
    })


  });

  describe('SCBScreenSessionTest', () => {
    interface ScreenSessionTestObj {
      callbackMap: Map<string, Function>;
      scbScreenSession: SCBScreenSession;
      scbScreenSessionManager: SCBScreenSessionManager;
    }

    let createInstance = (): ScreenSessionTestObj => {
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
      let scbScreenSessionManager = SCBScreenSessionManager.getInstance();
      let obj: ScreenSessionTestObj = {
        callbackMap, scbScreenSession, scbScreenSessionManager
      };
      return obj;
    };

    let screenSessionTestObj: ScreenSessionTestObj
    beforeEach(() => {
      screenSessionTestObj = createInstance();
    })


    it('initScreenSession', 0, () => {
      // let screenSessionTestObj: ScreenSessionTestObj = createInstance();
      expect(screenSessionTestObj).not().assertNull();

      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();
      expect(scbScreenSession.session).not().assertNull();
      expect(scbScreenSession.scbScreenProperty.screenId).assertEqual(-1);
      expect(scbScreenSession.sensorScreenProperty.screenId).assertEqual(-1);

      let callbackMap: Map<string, Function> = screenSessionTestObj.callbackMap;
      expect(callbackMap).not().assertNull();

      type UnFn = Function | undefined;

      let fn_connect: UnFn = callbackMap.get('connect');
      expect(fn_connect).not().assertUndefined();
      let fn_disconnect: UnFn = callbackMap.get('disconnect');
      expect(fn_disconnect).not().assertUndefined();
      let fn_propertyChange: UnFn = callbackMap.get('propertyChange');
      expect(fn_propertyChange).not().assertUndefined();
      let fn_sensorRotationChange: UnFn = callbackMap.get('sensorRotationChange');
      expect(fn_sensorRotationChange).not().assertUndefined();
      let fn_screenOrientationChange: UnFn = callbackMap.get('screenOrientationChange');
      expect(fn_screenOrientationChange).not().assertUndefined();
      let fn_screenRotationLockedChange: UnFn = callbackMap.get('screenRotationLockedChange');
      expect(fn_screenRotationLockedChange).not().assertUndefined();

    })


    it('SCBScreenSession_registerPropertyChange', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      let propertyChangeFn: Function = () => {
        return true;
      }
      scbScreenSession.registerPropertyChange(propertyChangeFn);
      expect(scbScreenSession.onPropertyChange).not().assertNull();
    })


    it('SCBScreenSession_updatePhysicalProperty', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();
      const screenPropBounds: screenSessionManager.RRect = {
        left: 1,
        top: 1,
        width: 100,
        height: 100,
        radius: 1
      };
      let screenProp: screenSessionManager.ScreenProperty = {
        rotation: 1,
        bounds: screenPropBounds,
        fakeBounds: screenPropBounds,
        isFakeInUse: false
      };
      let reason = 0;
      let propertyChangeFnCalled: Boolean = false;
      let registerCalled: boolean = false;
      let propertyChangeFn: Function = (scbScreenProp: SCBScreenProperty, changeReason: number, needNotify: boolean) => {
        if (registerCalled === false) {
          registerCalled = true;
          return;
        }
        propertyChangeFnCalled = true;
      }
      scbScreenSession.registerPropertyChange(propertyChangeFn);
      scbScreenSession.updatePhysicalProperty(screenProp, reason);

      let bounds = scbScreenSession.bounds;
      expect(bounds.left).assertEqual(1);
      expect(bounds.top).assertEqual(1);
      expect(bounds.width).assertEqual(100);
      expect(bounds.height).assertEqual(100);
      expect(bounds.radius).assertEqual(1);

      let physicalBounds = scbScreenSession.physicalBounds;
      expect(physicalBounds.left).assertEqual(1);
      expect(physicalBounds.top).assertEqual(1);
      expect(physicalBounds.width).assertEqual(100);
      expect(physicalBounds.height).assertEqual(100);
      expect(physicalBounds.radius).assertEqual(1);

      expect(propertyChangeFnCalled).assertTrue();
    })


    it('SCBScreenSession_updateVirtualProperty', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();

      let scbScreenProp = new SCBScreenProperty();
      const screenPropBounds: screenSessionManager.RRect = {
        left: 2,
        top: 3,
        width: 101,
        height: 102,
        radius: 9,
      };
      let screenProp: screenSessionManager.ScreenProperty = {
        rotation: 1,
        bounds: screenPropBounds,
        fakeBounds: screenPropBounds,
        isFakeInUse: false
      };
      scbScreenProp.update(screenProp);
      let reason = 8;

      let propertyChangeFnCalled: Boolean = false;
      let registerCalled: boolean = false;
      let fnCallTimes = 0;
      let propertyChangeFn: Function = (scbScreenProp: SCBScreenProperty, changeReason: number, needNotify: boolean) => {
        fnCallTimes++;
        if (registerCalled === false) {
          registerCalled = true;
          return;
        }
        propertyChangeFnCalled = true;
        expect(fnCallTimes).assertEqual(2);
        expect(changeReason).assertEqual(8);
        expect(needNotify).assertTrue();
      }
      scbScreenSession.registerPropertyChange(propertyChangeFn);

      scbScreenSession.updateVirtualProperty(scbScreenProp, reason, true);
      let bounds = scbScreenSession.bounds;
      expect(bounds.left).assertEqual(2);
      expect(bounds.top).assertEqual(3);
      expect(bounds.width).assertEqual(101);
      expect(bounds.height).assertEqual(102);
      expect(bounds.radius).assertEqual(9);

      expect(propertyChangeFnCalled).assertTrue();

    })

    it('SCBScreenSession_isVertical', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();


      let isVertical = true;
      let rotation = 0;

      scbScreenSession.defaultScreenOrientation = 0;
      rotation = 0;
      isVertical = scbScreenSession.isVertical(rotation);
      expect(isVertical).assertTrue();

      scbScreenSession.defaultScreenOrientation = 0;
      rotation = 180;
      isVertical = scbScreenSession.isVertical(rotation);
      expect(isVertical).assertTrue();

      scbScreenSession.defaultScreenOrientation = 0;
      rotation = 90;
      isVertical = scbScreenSession.isVertical(rotation);
      expect(isVertical).assertFalse();

      scbScreenSession.defaultScreenOrientation = 0;
      rotation = 270;
      isVertical = scbScreenSession.isVertical(rotation);
      expect(isVertical).assertFalse();

      scbScreenSession.defaultScreenOrientation = 1;
      rotation = 90;
      isVertical = scbScreenSession.isVertical(rotation);
      expect(isVertical).assertTrue();

      scbScreenSession.defaultScreenOrientation = 1;
      rotation = 270;
      isVertical = scbScreenSession.isVertical(rotation);
      expect(isVertical).assertTrue();

      scbScreenSession.defaultScreenOrientation = 1;
      rotation = 0;
      isVertical = scbScreenSession.isVertical(rotation);
      expect(isVertical).assertFalse();

      scbScreenSession.defaultScreenOrientation = 1;
      rotation = 180;
      isVertical = scbScreenSession.isVertical(rotation);
      expect(isVertical).assertFalse();

      scbScreenSession.defaultScreenOrientation = 111;
      rotation = 123;
      isVertical = scbScreenSession.isVertical(rotation);
      expect(isVertical).assertFalse();


    })

    it('SCBScreenSession_calculateFoldablePhoneRotation', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();

      let rotation: number = 0;
      let calcRotation: number = 0;

      rotation = 0;
      calcRotation = scbScreenSession.calculateFoldablePhoneRotation(rotation);
      expect(calcRotation).assertEqual(90);

      rotation = 90;
      calcRotation = scbScreenSession.calculateFoldablePhoneRotation(rotation);
      expect(calcRotation).assertEqual(180);

      rotation = 180;
      calcRotation = scbScreenSession.calculateFoldablePhoneRotation(rotation);
      expect(calcRotation).assertEqual(270);

      rotation = 270;
      calcRotation = scbScreenSession.calculateFoldablePhoneRotation(rotation);
      expect(calcRotation).assertEqual(0);

      rotation = 110;
      calcRotation = scbScreenSession.calculateFoldablePhoneRotation(rotation);
      expect(calcRotation).assertEqual(90);

    })

    it('SCBScreenSession_resumeFoldablePhoneRotation', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();

      let rotation: number = 0;
      let calcRotation: number = 0;

      rotation = 0;
      calcRotation = scbScreenSession.resumeFoldablePhoneRotation(rotation);
      expect(calcRotation).assertEqual(270);

      rotation = 90;
      calcRotation = scbScreenSession.resumeFoldablePhoneRotation(rotation);
      expect(calcRotation).assertEqual(0);

      rotation = 180;
      calcRotation = scbScreenSession.resumeFoldablePhoneRotation(rotation);
      expect(calcRotation).assertEqual(90);

      rotation = 270;
      calcRotation = scbScreenSession.resumeFoldablePhoneRotation(rotation);
      expect(calcRotation).assertEqual(180);

      rotation = 110;
      calcRotation = scbScreenSession.resumeFoldablePhoneRotation(rotation);
      expect(calcRotation).assertEqual(270);

    })

    it('SCBScreenSession_setEnableRotate', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();

      let enableRotate: boolean = true;
      scbScreenSession.setEnableRotate(false, 'test1');
      enableRotate = Reflect.get(scbScreenSession, "_enableRotate");
      expect(enableRotate).assertFalse();

      scbScreenSession.setEnableRotate(false, 'test2');
      enableRotate = Reflect.get(scbScreenSession, "_enableRotate");
      expect(enableRotate).assertFalse();

      scbScreenSession.setEnableRotate(true, 'test1');
      enableRotate = Reflect.get(scbScreenSession, "_enableRotate");
      expect(enableRotate).assertFalse();

      scbScreenSession.setEnableRotate(true, 'test2');
      enableRotate = Reflect.get(scbScreenSession, "_enableRotate");
      expect(enableRotate).assertTrue();
    })

    it('SCBScreenSession_recordRotationWhenLockAutoRotation', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();

      scbScreenSession.scbScreenProperty.rotation = 270;
      scbScreenSession.recordRotationWhenLockAutoRotation();
      expect(scbScreenSession.rotationWhenLockAutoRotation).assertEqual(270);

      scbScreenSession.scbScreenProperty.rotation = 180;
      scbScreenSession.recordRotationWhenLockAutoRotation();
      expect(scbScreenSession.rotationWhenLockAutoRotation).assertEqual(180);

      scbScreenSession.scbScreenProperty.rotation = 90;
      scbScreenSession.recordRotationWhenLockAutoRotation();
      expect(scbScreenSession.rotationWhenLockAutoRotation).assertEqual(90);
    })

    it('SCBScreenSession_isTentStatus', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();
      expect(scbScreenSession.isTentStatus).assertEqual(false);
    })

    it('SCBScreenSession_isCameraStatus', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();
      expect(scbScreenSession.isCameraStatus).assertEqual(false);
    })

    it('SCBScreenSession_isExtendScreen', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();
      expect(scbScreenSession.isExtendScreen).assertEqual(false);
    })

    it('SCBScreenSession_isMainScreen', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();
      expect(scbScreenSession.isMainScreen).assertEqual(false);
    })

    it('SCBScreenSession_setScreenFakeInUse', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();
      let isFakeInUse: boolean = false;
      scbScreenSession.setScreenFakeInUse(isFakeInUse);
      expect(isFakeInUse).assertEqual(scbScreenSession.isFakeInUse);
    })

    it('SCBScreenSession_rotationChangeByWindow', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();
      let rotationAfter: number = 0;
      let rotateReasonDescription: string = "test";
      scbScreenSession.rotationChangeByWindow(rotationAfter, rotateReasonDescription);
      expect(scbScreenSession.isExpandStatus).assertFalse();
      let rotationAfter1: number = 90;
      scbScreenSession.rotationChangeByWindow(rotationAfter1, rotateReasonDescription);
      expect(scbScreenSession.isExpandStatus).assertFalse();
      let rotationAfter2: number = 270;
      scbScreenSession.rotationChangeByWindow(rotationAfter2, rotateReasonDescription);
      expect(scbScreenSession.isExpandStatus).assertFalse();
    })

    it('SCBScreenSession_getRealRotation', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(scbScreenSession, scbScreenSession.isRotateScreenPolicy);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let screenRotation: number = 0;
      let screenRotation1 : number = scbScreenSession.getRealRotation(screenRotation);
      expect(screenRotation1).assertEqual(scbScreenSession.scbScreenProperty.rotation);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let screenRotation2 : number = scbScreenSession.getRealRotation(screenRotation);
      expect(screenRotation2).assertEqual(screenRotation);
    })

    it('SCBScreenSession_isFoldablePhoneExpandStatus', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(SCBScreenSession, SCBScreenSession.isDualDisplayFoldDevice);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let ret : boolean = scbScreenSession.isFoldablePhoneExpandStatus();
      expect(ret).assertFalse();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let ret1 : boolean = scbScreenSession.isFoldablePhoneExpandStatus();
      expect(ret1).assertEqual(scbScreenSession.isExpandStatus);
    })

    it('SCBScreenSession_isPhoneFoldingStatus', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();
      let ret : boolean = scbScreenSession.isPhoneFoldingStatus();
      expect(ret).assertFalse();
    })

    it('SCBScreenSession_coverPhoneSensorRotation', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();
      let rotation: number = 0;
      scbScreenSession.coverPhoneSensorRotation(rotation);
      expect(scbScreenSession.isExpandStatus).assertFalse();
    })

    it('SCBScreenSession_setSkipRotation', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();
      let rotation: number = 90;
      scbScreenSession.setSkipRotation(rotation);
      expect(scbScreenSession.isExpandStatus).assertFalse();
    })

    it('SCBScreenSession_doSkippedRotationIfNeed', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();
      let rotation: number = 90;
      scbScreenSession.doSkippedRotationIfNeed(rotation);
      expect(scbScreenSession.isExpandStatus).assertFalse();
    })

    it('SCBScreenSession_isDualDisplayFoldDevice', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();
      let ret : boolean = SCBScreenSession.isDualDisplayFoldDevice();
      expect(ret).assertFalse();
    })

    it('SCBScreenSession_getScreenComponentRotation1', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();

      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(SCBScreenSession, SCBScreenSession.isDualDisplayFoldDevice);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(scbScreenSession.getScreenComponentRotation(0)).assertEqual(0);
    })

    it('SCBScreenSession_getScreenComponentRotation2', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();

      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(SCBScreenSession, SCBScreenSession.isDualDisplayFoldDevice);

      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect(scbScreenSession.getScreenComponentRotation(0)).assertEqual(0);
    })

    it('SCBScreenSession_rotationChangeByWindow1', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();
 
      let rotateReasonDescription: string = 'unlock';
      let sensorRotation: number = 0;
      scbScreenSession.currentSensorRotation = 90;
      scbScreenSession.setEnableRotate(false, 'test1');
      scbScreenSession.rotationChangeByWindow(sensorRotation, rotateReasonDescription);
      expect(scbScreenSession.currentSensorRotation).assertEqual(90);
    })
 
    it('SCBScreenSession_rotationChangeByWindow2', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();
 
      let rotateReasonDescription: string = 'unlock';
      let sensorRotation: number = 0;
      scbScreenSession.currentSensorRotation = 90;
      scbScreenSession.setEnableRotate(true, 'test1');
      scbScreenSession.rotationChangeByWindow(sensorRotation, rotateReasonDescription);
      expect(scbScreenSession.currentSensorRotation).assertEqual(90);
    })

    it('SCBScreenSession_rotationChangeByWindow3', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();

      let rotateReasonDescription: string = 'scenePanelStartScene';
      let sensorRotation: number = 0;
      scbScreenSession.currentSensorRotation = 90;
      scbScreenSession.setEnableRotate(false, 'test1');
      scbScreenSession.rotationChangeByWindow(sensorRotation, rotateReasonDescription);
      expect(scbScreenSession.currentSensorRotation).assertEqual(90);
    })

    it('SCBScreenSession_rotationChangeByWindow4', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();

      let rotateReasonDescription: string = 'unlock';
      let sensorRotation: number = 0;
      scbScreenSession.currentSensorRotation = 180;
      scbScreenSession.setEnableRotate(true, 'test1');
      scbScreenSession.rotationChangeByWindow(sensorRotation, rotateReasonDescription);
      expect(scbScreenSession.currentSensorRotation).assertEqual(180);
    })

    it('SCBScreenSession_rotationChangeByWindow5', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();

      let rotateReasonDescription: string = 'unlock';
      let sensorRotation: number = 0;
      scbScreenSession.currentSensorRotation = 270;
      scbScreenSession.setEnableRotate(true, 'test1');
      scbScreenSession.rotationChangeByWindow(sensorRotation, rotateReasonDescription);
      expect(scbScreenSession.currentSensorRotation).assertEqual(270);
    })

    it('SCBScreenSession_rotationChangeByWindow6', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();

      let rotateReasonDescription: string = 'unlock';
      let sensorRotation: number = 90;
      scbScreenSession.currentSensorRotation = 0;
      scbScreenSession.setEnableRotate(true, 'test1');
      scbScreenSession.rotationChangeByWindow(sensorRotation, rotateReasonDescription);
      expect(scbScreenSession.currentSensorRotation).assertEqual(0);
    })

    it('SCBScreenSession_rotationChangeByWindow7', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();

      let rotateReasonDescription: string = 'unlock';
      let sensorRotation: number = 90;
      scbScreenSession.currentSensorRotation = 90;
      scbScreenSession.setEnableRotate(true, 'test1');
      scbScreenSession.rotationChangeByWindow(sensorRotation, rotateReasonDescription);
      expect(scbScreenSession.currentSensorRotation).assertEqual(90);
    })

    it('SCBScreenSession_rotationChangeByWindow8', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();

      let rotateReasonDescription: string = 'unlock';
      let sensorRotation: number = 90;
      scbScreenSession.currentSensorRotation = 180;
      scbScreenSession.setEnableRotate(true, 'test1');
      scbScreenSession.rotationChangeByWindow(sensorRotation, rotateReasonDescription);
      expect(scbScreenSession.currentSensorRotation).assertEqual(180);
    })

    it('SCBScreenSession_rotationChangeByWindow9', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();

      let rotateReasonDescription: string = 'unlock';
      let sensorRotation: number = 90;
      scbScreenSession.currentSensorRotation = 270;
      scbScreenSession.setEnableRotate(true, 'test1');
      scbScreenSession.rotationChangeByWindow(sensorRotation, rotateReasonDescription);
      expect(scbScreenSession.currentSensorRotation).assertEqual(270);
    })

    it('SCBScreenSession_rotationChangeByWindow10', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();

      let rotateReasonDescription: string = 'unlock';
      let sensorRotation: number = 180;
      scbScreenSession.currentSensorRotation = 0;
      scbScreenSession.setEnableRotate(true, 'test1');
      scbScreenSession.rotationChangeByWindow(sensorRotation, rotateReasonDescription);
      expect(scbScreenSession.currentSensorRotation).assertEqual(0);
    })

    it('SCBScreenSession_rotationChangeByWindow11', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();

      let rotateReasonDescription: string = 'unlock';
      let sensorRotation: number = 180;
      scbScreenSession.currentSensorRotation = 90;
      scbScreenSession.setEnableRotate(true, 'test1');
      scbScreenSession.rotationChangeByWindow(sensorRotation, rotateReasonDescription);
      expect(scbScreenSession.currentSensorRotation).assertEqual(90);
    })

    it('SCBScreenSession_rotationChangeByWindow12', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();

      let rotateReasonDescription: string = 'unlock';
      let sensorRotation: number = 180;
      scbScreenSession.currentSensorRotation = 180;
      scbScreenSession.setEnableRotate(true, 'test1');
      scbScreenSession.rotationChangeByWindow(sensorRotation, rotateReasonDescription);
      expect(scbScreenSession.currentSensorRotation).assertEqual(180);
    })

    it('SCBScreenSession_rotationChangeByWindow13', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();

      let rotateReasonDescription: string = 'unlock';
      let sensorRotation: number = 180;
      scbScreenSession.currentSensorRotation = 270;
      scbScreenSession.setEnableRotate(true, 'test1');
      scbScreenSession.rotationChangeByWindow(sensorRotation, rotateReasonDescription);
      expect(scbScreenSession.currentSensorRotation).assertEqual(270);
    })

    it('SCBScreenSession_rotationChangeByWindow14', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();

      let rotateReasonDescription: string = 'lock';
      let sensorRotation: number = 90;
      scbScreenSession.currentSensorRotation = 0;
      scbScreenSession.setEnableRotate(false, 'test1');
      scbScreenSession.rotationChangeByWindow(sensorRotation, rotateReasonDescription);
      expect(scbScreenSession.currentSensorRotation).assertEqual(0);
    })

    it('SCBScreenSession_rotationChangeByWindow15', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();

      let rotateReasonDescription: string = 'lock';
      let sensorRotation: number = 90;
      scbScreenSession.currentSensorRotation = 90;
      scbScreenSession.setEnableRotate(false, 'test1');
      scbScreenSession.rotationChangeByWindow(sensorRotation, rotateReasonDescription);
      expect(scbScreenSession.currentSensorRotation).assertEqual(90);
    })

    it('SCBScreenSession_rotationChangeByWindow16', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();

      let rotateReasonDescription: string = 'lock';
      let sensorRotation: number = 90;
      scbScreenSession.currentSensorRotation = 180;
      scbScreenSession.setEnableRotate(false, 'test1');
      scbScreenSession.rotationChangeByWindow(sensorRotation, rotateReasonDescription);
      expect(scbScreenSession.currentSensorRotation).assertEqual(180);
    })

    it('SCBScreenSession_rotationChangeByWindow17', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();

      let rotateReasonDescription: string = 'lock';
      let sensorRotation: number = 90;
      scbScreenSession.currentSensorRotation = 270;
      scbScreenSession.setEnableRotate(false, 'test1');
      scbScreenSession.rotationChangeByWindow(sensorRotation, rotateReasonDescription);
      expect(scbScreenSession.currentSensorRotation).assertEqual(270);
    })

    it('SCBScreenSession_rotationChangeByWindow18', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();

      let rotateReasonDescription: string = 'lock';
      let sensorRotation: number = 180;
      scbScreenSession.currentSensorRotation = 0;
      scbScreenSession.setEnableRotate(false, 'test1');
      scbScreenSession.rotationChangeByWindow(sensorRotation, rotateReasonDescription);
      expect(scbScreenSession.currentSensorRotation).assertEqual(0);
    })

    it('SCBScreenSession_rotationChangeByWindow19', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();

      let rotateReasonDescription: string = 'lock';
      let sensorRotation: number = 180;
      scbScreenSession.currentSensorRotation = 90;
      scbScreenSession.setEnableRotate(false, 'test1');
      scbScreenSession.rotationChangeByWindow(sensorRotation, rotateReasonDescription);
      expect(scbScreenSession.currentSensorRotation).assertEqual(90);
    })

    it('SCBScreenSession_rotationChangeByWindow20', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();

      let rotateReasonDescription: string = 'lock';
      let sensorRotation: number = 180;
      scbScreenSession.currentSensorRotation = 180;
      scbScreenSession.setEnableRotate(false, 'test1');
      scbScreenSession.rotationChangeByWindow(sensorRotation, rotateReasonDescription);
      expect(scbScreenSession.currentSensorRotation).assertEqual(180);
    })

    it('SCBScreenSession_rotationChangeByWindow21', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();

      let rotateReasonDescription: string = 'lock';
      let sensorRotation: number = 180;
      scbScreenSession.currentSensorRotation = 270;
      scbScreenSession.setEnableRotate(false, 'test1');
      scbScreenSession.rotationChangeByWindow(sensorRotation, rotateReasonDescription);
      expect(scbScreenSession.currentSensorRotation).assertEqual(270);
    })

    it('SCBScreenSession_rotationChangeByWindow22', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();

      let rotateReasonDescription: string = 'lock';
      let sensorRotation: number = 270;
      scbScreenSession.currentSensorRotation = 0;
      scbScreenSession.setEnableRotate(false, 'test1');
      scbScreenSession.rotationChangeByWindow(sensorRotation, rotateReasonDescription);
      expect(scbScreenSession.currentSensorRotation).assertEqual(0);
    })

    it('SCBScreenSession_rotationChangeByWindow23', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();

      let rotateReasonDescription: string = 'lock';
      let sensorRotation: number = 270;
      scbScreenSession.currentSensorRotation = 90;
      scbScreenSession.setEnableRotate(false, 'test1');
      scbScreenSession.rotationChangeByWindow(sensorRotation, rotateReasonDescription);
      expect(scbScreenSession.currentSensorRotation).assertEqual(90);
    })

    it('SCBScreenSession_rotationChangeByWindow24', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();

      let rotateReasonDescription: string = 'lock';
      let sensorRotation: number = 270;
      scbScreenSession.currentSensorRotation = 180;
      scbScreenSession.setEnableRotate(false, 'test1');
      scbScreenSession.rotationChangeByWindow(sensorRotation, rotateReasonDescription);
      expect(scbScreenSession.currentSensorRotation).assertEqual(180);
    })

    it('SCBScreenSession_rotationChangeByWindow25', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();

      let rotateReasonDescription: string = 'lock';
      let sensorRotation: number = 270;
      scbScreenSession.currentSensorRotation = 270;
      scbScreenSession.setEnableRotate(false, 'test1');
      scbScreenSession.rotationChangeByWindow(sensorRotation, rotateReasonDescription);
      expect(scbScreenSession.currentSensorRotation).assertEqual(270);
    })

    it('SCBScreenSession_getTargetScreenRotationWhenAppExit_followSensorScreenProperty', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();

      let scbScreenSessionManager: SCBScreenSessionManager = screenSessionTestObj.scbScreenSessionManager;
      let mocker: MockKit = new MockKit();
      let func1: Function =
        mocker.mockFunc(scbScreenSessionManager, scbScreenSessionManager.getScreenOrientationLocked);
      when(func1)(ArgumentMatchers.any).afterReturn(false);

      scbScreenSession.currentSensorRotation = 0;

      scbScreenSession.sensorScreenProperty.rotation = 90;
      let ret: number = scbScreenSession.getTargetScreenRotationWhenAppExit();
      expect(ret).assertEqual(90);
      mocker.clear(scbScreenSessionManager);
      mocker.clear(SCBScreenSession);
    })

    it('SCBScreenSession_getTargetScreenRotationWhenAppExit_screenOrientationLocked', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();

      let scbScreenSessionManager: SCBScreenSessionManager = screenSessionTestObj.scbScreenSessionManager;
      let mocker: MockKit = new MockKit();
      let func1: Function =
        mocker.mockFunc(scbScreenSessionManager, scbScreenSessionManager.getScreenOrientationLocked);
      when(func1)(ArgumentMatchers.any).afterReturn(true);

      scbScreenSession.scbScreenProperty.rotation = 180;
      scbScreenSession.recordRotationWhenLockAutoRotation();

      let ret: number = scbScreenSession.getTargetScreenRotationWhenAppExit();
      expect(ret).assertEqual(180);
      mocker.clear(scbScreenSessionManager);
      mocker.clear(SCBScreenSession);
    })

    it('SCBScreenSession_getTargetScreenRotationWhenAppExit_PlacedRotateFriendlyDevicePlaced', 0, () => {
      expect(screenSessionTestObj).not().assertNull();
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      expect(scbScreenSession).not().assertNull();

      let scbScreenSessionManager: SCBScreenSessionManager = screenSessionTestObj.scbScreenSessionManager;
      let mocker: MockKit = new MockKit();
      let func1: Function =
        mocker.mockFunc(scbScreenSessionManager, scbScreenSessionManager.getScreenOrientationLocked);
      when(func1)(ArgumentMatchers.any).afterReturn(false);

      scbScreenSession.currentSensorRotation = -1;
      scbScreenSession.scbScreenProperty.rotation = 270;

      let ret: number = scbScreenSession.getTargetScreenRotationWhenAppExit();
      expect(ret).assertEqual(270);
      mocker.clear(scbScreenSessionManager);
      mocker.clear(SCBScreenSession);
    })

    it('SCBScreenSession_handleCacheSensorRotationChange', 0, () => {
      let scbScreenSession: SCBScreenSession = screenSessionTestObj.scbScreenSession;
      scbScreenSession.sensorScreenProperty.rotation = 90;
      scbScreenSession._pendingSensorRotationFromRecent = 270;
      scbScreenSession.handleCacheSensorRotationChange();
      expect(scbScreenSession.sensorScreenProperty.rotation).assertEqual(270);
    })
  });
}
