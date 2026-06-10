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
  GestureNavigationEvent,
  NavigationType,
  gestureNavigationObserver,
  GestureNavigationState,
  SCBScreenProperty,
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
  when,
} from '@ohos/hypium';

import { NavbarWindowManager } from
  '@ohos/phonebase/src/main/ets/SceneBoard/gesturenavigation/navbar/viewmodel/NavbarWindowManager';
import { SCBGestureNavBarViewModel } from '@ohos/phonebase/src/main/ets/SceneBoard/gesturenavigation/SCBGestureNavBarViewModel';
import { BaseViewController } from '@ohos/frameworkcommon';
import { DeviceHelper } from '@ohos/frameworkwrapper';

export default function NavbarWindowManagerTest() {
  describe('NavbarWindowManagerTest', () => {
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

    let navBarViewModel: SCBGestureNavBarViewModel = new SCBGestureNavBarViewModel();
    let navbarWindowManager: NavbarWindowManager = navBarViewModel.windowManager;

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

    let gestureEvent: GestureEvent = {
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
      offsetY: 0,
      angle: 0,
      speed: 0,
      scale: 0,
      pinchCenterX: 0,
      pinchCenterY: 0,
      velocityX: 0,
      velocityY: 0,
      velocity: 0
    };

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

    it('NavbarWindowManagerTest_init_1', 0, (): void => {
      let viewController: BaseViewController = new BaseViewController('SCBGestureNavBar');
      let persistentId: number = 10;
      expect(navbarWindowManager.init(viewController, persistentId) === undefined).assertTrue();
    })

    it('NavbarWindowManagerTest_release_1', 0, (): void => {
      expect(navbarWindowManager.release() === undefined).assertTrue();
    })

    it('NavbarWindowManagerTest_registerGestureNavigationEvent_1', 0, (): void => {
      expect((navbarWindowManager as object)['registerGestureNavigationEvent']() === undefined).assertTrue();
    })

    it('NavbarWindowManagerTest_registerGestureNavigationEvent_2', 0, (): void => {
      (navbarWindowManager as object)['registerGestureNavigationEvent']();
      expect(gestureNavigationObserver.sendGestureNavigationEvent(GestureNavigationState.START,
        NavigationType.GESTURE) === undefined).assertTrue();
    })

    it('NavbarWindowManagerTest_registerGestureNavigationEvent_2', 0, (): void => {
      (navbarWindowManager as object)['registerGestureNavigationEvent']();
      expect(gestureNavigationObserver.sendGestureNavigationEvent(GestureNavigationState.START,
        NavigationType.FLOATING) === undefined).assertTrue();
    })

    it('NavbarWindowManagerTest_getPersistentId_1', 0, (): void => {
      expect(navbarWindowManager.persistentId === 0).assertTrue();
    })

    it('NavbarWindowManagerTest_getPersistentId_2', 0, (): void => {
      let viewController: BaseViewController = new BaseViewController('SCBGestureNavBar');
      navbarWindowManager.init(viewController, 10);
      expect(navbarWindowManager.persistentId === 10).assertTrue();
    })

    it('NavbarWindowManagerTest_setScreenProperty_1', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.width = 100;
      screenProperty.height = 100;
      (navbarWindowManager as object)['screenWidth'] = 50;
      (navbarWindowManager as object)['screenHeight'] = 50;
      expect(navbarWindowManager.setScreenProperty(screenProperty) !== undefined).assertTrue();
    })

    it('NavbarWindowManagerTest_setScreenProperty_2', 0, (): void => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.width = 100;
      screenProperty.height = 100;
      (navbarWindowManager as object)['screenWidth'] = 100;
      (navbarWindowManager as object)['screenHeight'] = 100;
      expect(navbarWindowManager.setScreenProperty(screenProperty) !== undefined).assertTrue();
    })

    it('NavbarWindowManagerTest_setWindowHeight_1', 0, (): void => {
      expect(navbarWindowManager.setWindowHeight(100) !== undefined).assertTrue();
    })

    it('NavbarWindowManagerTest_setWindowHeight_2', 0, (): void => {
      navbarWindowManager.setWindowHeight(100);
      expect(navbarWindowManager.setWindowHeight(100) !== undefined).assertTrue();
    })

    it('NavbarWindowManagerTest_setWindowHeight_3', 0, (): void => {
      navbarWindowManager.setWindowHeight(100);
      expect(navbarWindowManager.setWindowHeight(200) !== undefined).assertTrue();
    })

    it('NavbarWindowManagerTest_setResponseRegionHeight_1', 0, (): void => {
      expect(navbarWindowManager.setResponseRegionHeight(100) !== undefined).assertTrue();
    })

    it('NavbarWindowManagerTest_setResponseRegionHeight_2', 0, (): void => {
      navbarWindowManager.setResponseRegionHeight(100);
      expect(navbarWindowManager.setResponseRegionHeight(100) !== undefined).assertTrue();
    })

    it('NavbarWindowManagerTest_setResponseRegionHeight_3', 0, (): void => {
      navbarWindowManager.setResponseRegionHeight(100);
      expect(navbarWindowManager.setResponseRegionHeight(200) !== undefined).assertTrue();
    })

    it('NavbarWindowManagerTest_setExtraHeight_1', 0, (): void => {
      expect(navbarWindowManager.setExtraHeight(100) !== undefined).assertTrue();
    })

    it('NavbarWindowManagerTest_setExtraHeight_2', 0, (): void => {
      navbarWindowManager.setExtraHeight(100);
      expect(navbarWindowManager.setExtraHeight(100) !== undefined).assertTrue();
    })

    it('NavbarWindowManagerTest_setExtraHeight_3', 0, (): void => {
      navbarWindowManager.setExtraHeight(100);
      expect(navbarWindowManager.setExtraHeight(200) !== undefined).assertTrue();
    })

    it('NavbarWindowManagerTest_isWindowFullScreen_1', 0, (): void => {
      (navbarWindowManager as object)['isWindowPortraitFullScreen'] = true;
      (navbarWindowManager as object)['isWindowHorizontalFullScreen'] = true;
      expect(navbarWindowManager.isWindowFullScreen(false, false) !== undefined).assertTrue();
    })

    it('NavbarWindowManagerTest_isWindowFullScreen_2', 0, (): void => {
      (navbarWindowManager as object)['isWindowPortraitFullScreen'] = true;
      (navbarWindowManager as object)['isWindowHorizontalFullScreen'] = true;
      expect(navbarWindowManager.isWindowFullScreen(true, true) !== undefined).assertTrue();
    })

    it('NavbarWindowManagerTest_isWindowFullScreen_3', 0, (): void => {
      (navbarWindowManager as object)['isWindowPortraitFullScreen'] = true;
      (navbarWindowManager as object)['isWindowHorizontalFullScreen'] = true;
      expect(navbarWindowManager.isWindowFullScreen(false, true) !== undefined).assertTrue();
    })

    it('NavbarWindowManagerTest_isWindowFullScreen_4', 0, (): void => {
      (navbarWindowManager as object)['isWindowPortraitFullScreen'] = true;
      (navbarWindowManager as object)['isWindowHorizontalFullScreen'] = true;
      expect(navbarWindowManager.isWindowFullScreen(true, false) !== undefined).assertTrue();
    })

    it('NavbarWindowManagerTest_updateWindowSize_1', 0, (): void => {
      expect((navbarWindowManager as object)['updateWindowSize']() === undefined).assertTrue();
    })

    it('NavbarWindowManagerTest_updateWindowSize_2', 0, (): void => {
      let viewController: BaseViewController = new BaseViewController('SCBGestureNavBar');
      navbarWindowManager.init(viewController, 10);
      expect((navbarWindowManager as object)['updateWindowSize']() === undefined).assertTrue();
    })

    it('NavbarWindowManagerTest_updateResponseRegion_1', 0, (): void => {
      expect((navbarWindowManager as object)['updateResponseRegion']() === undefined).assertTrue();
    })

    it('NavbarWindowManagerTest_getLandscapeWindowWidthPercent_1', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((navbarWindowManager as object)['getLandscapeWindowWidthPercent']() !== undefined).assertTrue();
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPad);
    })

    it('NavbarWindowManagerTest_getLandscapeWindowWidthPercent_2', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect((navbarWindowManager as object)['getLandscapeWindowWidthPercent']() !== undefined).assertTrue();
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPad);
    })

    it('NavbarWindowManagerTest_resetChangeFlags_1', 0, (): void => {
      expect((navbarWindowManager as object)['resetChangeFlags']() === undefined).assertTrue();
    })

    it('NavbarWindowManagerTest_update_1', 0, (): void => {
      (navbarWindowManager as object)['isScreenChanged'] = false;
      (navbarWindowManager as object)['isWindowChanged'] = false;
      (navbarWindowManager as object)['isRegionChanged'] = false;
      expect(navbarWindowManager.update() === undefined).assertTrue();
    })

    it('NavbarWindowManagerTest_update_2', 0, (): void => {
      (navbarWindowManager as object)['isScreenChanged'] = false;
      (navbarWindowManager as object)['isWindowChanged'] = false;
      (navbarWindowManager as object)['isRegionChanged'] = false;
      expect(navbarWindowManager.update(false) === undefined).assertTrue();
    })

    it('NavbarWindowManagerTest_update_3', 0, (): void => {
      (navbarWindowManager as object)['isScreenChanged'] = false;
      (navbarWindowManager as object)['isWindowChanged'] = false;
      (navbarWindowManager as object)['isRegionChanged'] = false;
      (navbarWindowManager as object)['screenWidth'] = 1000;
      (navbarWindowManager as object)['screenHeight'] = 500;
      (navbarWindowManager as object)['isWindowFullScreen_'] = false;
      expect(navbarWindowManager.update(true) === undefined).assertTrue();
    })

    it('NavbarWindowManagerTest_update_4', 0, (): void => {
      (navbarWindowManager as object)['isScreenChanged'] = false;
      (navbarWindowManager as object)['isWindowChanged'] = false;
      (navbarWindowManager as object)['isRegionChanged'] = false;
      (navbarWindowManager as object)['screenWidth'] = 1000;
      (navbarWindowManager as object)['screenHeight'] = 500;
      (navbarWindowManager as object)['isWindowFullScreen_'] = true;
      expect(navbarWindowManager.update(true) === undefined).assertTrue();
    })

    it('NavbarWindowManagerTest_update_4', 0, (): void => {
      (navbarWindowManager as object)['isScreenChanged'] = false;
      (navbarWindowManager as object)['isWindowChanged'] = false;
      (navbarWindowManager as object)['isRegionChanged'] = false;
      (navbarWindowManager as object)['screenWidth'] = 1000;
      (navbarWindowManager as object)['screenHeight'] = 500;
      (navbarWindowManager as object)['isWindowFullScreen_'] = true;
      expect(navbarWindowManager.update(true) === undefined).assertTrue();
    })

    it('NavbarWindowManagerTest_update_4', 0, (): void => {
      (navbarWindowManager as object)['isScreenChanged'] = false;
      (navbarWindowManager as object)['isWindowChanged'] = false;
      (navbarWindowManager as object)['isRegionChanged'] = false;
      (navbarWindowManager as object)['screenWidth'] = 1000;
      (navbarWindowManager as object)['screenHeight'] = 500;
      (navbarWindowManager as object)['isWindowFullScreen_'] = false;
      expect(navbarWindowManager.update(true) === undefined).assertTrue();
    })

    it('NavbarWindowManagerTest_update_4', 0, (): void => {
      (navbarWindowManager as object)['isScreenChanged'] = true;
      (navbarWindowManager as object)['isWindowChanged'] = false;
      (navbarWindowManager as object)['isRegionChanged'] = false;
      (navbarWindowManager as object)['screenWidth'] = 1000;
      (navbarWindowManager as object)['screenHeight'] = 500;
      (navbarWindowManager as object)['isWindowFullScreen_'] = false;
      expect(navbarWindowManager.update(false) === undefined).assertTrue();
    })
  })
}