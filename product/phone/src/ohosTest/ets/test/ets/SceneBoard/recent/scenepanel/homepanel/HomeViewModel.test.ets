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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level, MockKit, when } from '@ohos/hypium';
import { SCBScenePanelManager, SCBScreenProperty } from '@ohos/windowscene';
import { HomeViewModel } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/homepanel/HomeViewModel';

export default function HomeViewModelTest() {
  describe('HomeViewModelTest', () => {
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

    it('HomeViewModelTest_onEnterHome_test_01', Level.LEVEL0, (): void => {
      HomeViewModel.getInstance().onEnterHome(false);
      expect(HomeViewModel.getInstance()).not().assertUndefined();
    })
    it('HomeViewModelTest_onEnterHome_test_02', Level.LEVEL0, (): void => {
      HomeViewModel.getInstance().onEnterHome(true);
      expect(HomeViewModel.getInstance()).not().assertUndefined();
    })

    it('HomeViewModelTest_onEnterHome_test_03', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      HomeViewModel.getInstance().onEnterHome(true);
      expect(HomeViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
    })

    it('HomeViewModelTest_onEnterHome_test_04', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      HomeViewModel.getInstance().onEnterHome(false);
      expect(HomeViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
    })

    it('HomeViewModelTest_onEnterHome_test_05', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      HomeViewModel.getInstance().onEnterHome(true);
      expect(HomeViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
    })

    it('HomeViewModelTest_onEnterHome_test_06', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      HomeViewModel.getInstance().onEnterHome(false);
      expect(HomeViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
    })

    it('HomeViewModelTest_onHomeIdleUpdate_test_01', Level.LEVEL0, (): void => {
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
        offsetY: 5,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      HomeViewModel.getInstance().onHomeIdleUpdate(event.offsetY);
      expect(HomeViewModel.getInstance()).not().assertUndefined();
    })
    it('HomeViewModelTest_onHomeIdleUpdate_test_02', Level.LEVEL0, (): void => {
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
        offsetY: 15,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      HomeViewModel.getInstance().onHomeIdleUpdate(event.offsetY);
      expect(HomeViewModel.getInstance()).not().assertUndefined();
    })
    it('HomeViewModelTest_onHomeIdleUpdate_test_03', Level.LEVEL0, (): void => {
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
        offsetY: 25,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      HomeViewModel.getInstance().onHomeIdleUpdate(event.offsetY);
      expect(HomeViewModel.getInstance()).not().assertUndefined();
    })
    it('HomeViewModelTest_onHomeIdleUpdate_test_01', Level.LEVEL0, (): void => {
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
        offsetY: 150,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      HomeViewModel.getInstance().onHomeIdleUpdate(event.offsetY);
      expect(HomeViewModel.getInstance()).not().assertUndefined();
    })
    it('HomeViewModelTest_onOverViewFollowingUpdate_test_01', Level.LEVEL0, (): void => {
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
        offsetX: 10,
        offsetY: 10,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      HomeViewModel.getInstance().onOverViewFollowingUpdate(event.offsetX, event.offsetY, true);
      expect(HomeViewModel.getInstance()).not().assertUndefined();
    })
    it('HomeViewModelTest_onOverViewFollowingUpdate_test_02', Level.LEVEL0, (): void => {
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
        offsetX: 20,
        offsetY: 20,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      HomeViewModel.getInstance().onOverViewFollowingUpdate(event.offsetX, event.offsetY, true);
      expect(HomeViewModel.getInstance()).not().assertUndefined();
    })
    it('HomeViewModelTest_onOverViewFollowingUpdate_test_03', Level.LEVEL0, (): void => {
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
        offsetX: 40,
        offsetY: 40,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      HomeViewModel.getInstance().onOverViewFollowingUpdate(event.offsetX, event.offsetY, true);
      expect(HomeViewModel.getInstance()).not().assertUndefined();
    })
    it('HomeViewModelTest_onOverViewFollowingUpdate_test_04', Level.LEVEL0, (): void => {
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
        offsetX: 5,
        offsetY: 5,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      HomeViewModel.getInstance().onOverViewFollowingUpdate(event.offsetX, event.offsetY, false);
      expect(HomeViewModel.getInstance()).not().assertUndefined();
    })
    it('HomeViewModelTest_onOverViewFollowingUpdate_test_05', Level.LEVEL0, (): void => {
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
        offsetX: 5,
        offsetY: 5,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      HomeViewModel.getInstance().onOverViewFollowingUpdate(event.offsetX, event.offsetY, false);
      expect(HomeViewModel.getInstance()).not().assertUndefined();
    })
    it('HomeViewModelTest_onOverViewFollowingUpdate_test_06', Level.LEVEL0, (): void => {
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
        offsetX: 40,
        offsetY: 40,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      HomeViewModel.getInstance().onOverViewFollowingUpdate(event.offsetX, event.offsetY, false);
      expect(HomeViewModel.getInstance()).not().assertUndefined();
    })

    it('HomeViewModelTest_doFollowingAnimateToRecentFromHome_test_01', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      HomeViewModel.getInstance().doFollowingAnimateToRecentFromHome();
      expect(HomeViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
    })

    it('HomeViewModelTest_doFollowingAnimateToRecentFromHome_test_02', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      HomeViewModel.getInstance().doFollowingAnimateToRecentFromHome();
      expect(HomeViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
    })

    it('HomeViewModelTest_doFollowingAnimateToRecentFromHome_test_03', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      HomeViewModel.getInstance().doFollowingAnimateToRecentFromHome();
      expect(HomeViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
    })

    it('HomeViewModelTest_updateDesktopScale_test_01', Level.LEVEL0, (): void => {
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
        offsetX: 40,
        offsetY: 40,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      let homeViewModel: HomeViewModel = HomeViewModel.getInstance();
      (homeViewModel as object)['updateDesktopScale'](event.offsetY);
      expect(homeViewModel).not().assertUndefined();
    })

    it('HomeViewModelTest_updateDesktopScale_test_02', Level.LEVEL0, (): void => {
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
        offsetX: 40,
        offsetY: 40,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      let homeViewModel: HomeViewModel = HomeViewModel.getInstance();
      (homeViewModel as object)['updateDesktopScale'](event.offsetY);
      expect(homeViewModel).not().assertUndefined();
    })

    it('HomeViewModelTest_updateDesktopScale_test_03', Level.LEVEL0, (): void => {
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
        offsetX: 40,
        offsetY: 40,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      let homeViewModel: HomeViewModel = HomeViewModel.getInstance();
      (homeViewModel as object)['updateDesktopScale'](event.offsetY);
      expect(homeViewModel).not().assertUndefined();
    })
    it('HomeViewModelTest_updateDesktopScale_test_04', Level.LEVEL0, (): void => {
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
        offsetX: 400,
        offsetY: 400,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      let homeViewModel: HomeViewModel = HomeViewModel.getInstance();
      (homeViewModel as object)['updateDesktopScale'](event.offsetY);
      expect(homeViewModel).not().assertUndefined();
    })

    it('HomeViewModelTest_updateDesktopScale_test_05', Level.LEVEL0, (): void => {
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
        offsetX: 400,
        offsetY: 400,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      let homeViewModel: HomeViewModel = HomeViewModel.getInstance();
      (homeViewModel as object)['updateDesktopScale'](event.offsetY);
      expect(homeViewModel).not().assertUndefined();
    })

    it('HomeViewModelTest_updateDesktopScale_test_06', Level.LEVEL0, (): void => {
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
        offsetX: 400,
        offsetY: 400,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      let homeViewModel: HomeViewModel = HomeViewModel.getInstance();
      (homeViewModel as object)['updateDesktopScale'](event.offsetY);
      expect(homeViewModel).not().assertUndefined();
    })

    it('HomeViewModelTest_updateDesktopScale_test_07', Level.LEVEL0, (): void => {
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
        offsetX: 400,
        offsetY: 400,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      let homeViewModel: HomeViewModel = HomeViewModel.getInstance();
      (homeViewModel as object)['updateDesktopScale'](event.offsetY);
      expect(homeViewModel).not().assertUndefined();
    })

    it('HomeViewModelTest_updateDesktopScale_test_08', Level.LEVEL0, (): void => {
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
        offsetX: 400,
        offsetY: 400,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      let homeViewModel: HomeViewModel = HomeViewModel.getInstance();
      (homeViewModel as object)['updateDesktopScale'](event.offsetY);
      expect(homeViewModel).not().assertUndefined();
    })

    it('HomeViewModelTest_updateDesktopScale_test_09', Level.LEVEL0, (): void => {
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
        offsetX: 400,
        offsetY: 400,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      let homeViewModel: HomeViewModel = HomeViewModel.getInstance();
      (homeViewModel as object)['updateDesktopScale'](event.offsetY);
      expect(homeViewModel).not().assertUndefined();
    })

    it('HomeViewModelTest_updateDesktopScale_test_10', Level.LEVEL0, (): void => {
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
        offsetX: 400,
        offsetY: 400,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      let homeViewModel: HomeViewModel = HomeViewModel.getInstance();
      (homeViewModel as object)['updateDesktopScale'](event.offsetY);
      expect(homeViewModel).not().assertUndefined();
    })

    it('HomeViewModelTest_updateDesktopScale_test_11', Level.LEVEL0, (): void => {
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
        offsetX: 400,
        offsetY: 400,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      let homeViewModel: HomeViewModel = HomeViewModel.getInstance();
      (homeViewModel as object)['updateDesktopScale'](event.offsetY);
      expect(homeViewModel).not().assertUndefined();
    })

    it('HomeViewModelTest_updateDesktopScale_test_12', Level.LEVEL0, (): void => {
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
        offsetX: 400,
        offsetY: 400,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      let homeViewModel: HomeViewModel = HomeViewModel.getInstance();
      (homeViewModel as object)['updateDesktopScale'](event.offsetY);
      expect(homeViewModel).not().assertUndefined();
    })

    it('HomeViewModelTest_updateDesktopScale_test_13', Level.LEVEL0, (): void => {
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
        offsetX: 400,
        offsetY: 400,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      let homeViewModel: HomeViewModel = HomeViewModel.getInstance();
      (homeViewModel as object)['updateDesktopScale'](event.offsetY);
      expect(homeViewModel).not().assertUndefined();
    })

    it('HomeViewModelTest_updateDesktopScale_test_14', Level.LEVEL0, (): void => {
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
        offsetX: 400,
        offsetY: 400,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      let homeViewModel: HomeViewModel = HomeViewModel.getInstance();
      (homeViewModel as object)['updateDesktopScale'](event.offsetY);
      expect(homeViewModel).not().assertUndefined();
    })

    it('HomeViewModelTest_exitOverViewFromFollowing_test_01', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      HomeViewModel.getInstance().exitOverViewFromFollowing();
      expect(HomeViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
    })

    it('HomeViewModelTest_enterQuickSwitchIdle_test_01', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      HomeViewModel.getInstance().enterQuickSwitchIdle(20, 5, () => {
      });
      expect(HomeViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
    })

    it('HomeViewModelTest_enterQuickSwitchIdle_test_02', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      HomeViewModel.getInstance().enterQuickSwitchIdle(100, 5, () => {
      });
      expect(HomeViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
    })

    it('HomeViewModelTest_enterQuickSwitchIdle_test_03', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      HomeViewModel.getInstance().enterQuickSwitchIdle(100, 0, () => {
      });
      expect(HomeViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
    })

    it('HomeViewModelTest_enterQuickSwitchIdle_test_04', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      HomeViewModel.getInstance().enterQuickSwitchIdle(20, 0, () => {
      });
      expect(HomeViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
    })

    it('HomeViewModelTest_updateSceneContainerWhenEnterQuickSwitchIdle_test_01', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      HomeViewModel.getInstance().updateSceneContainerWhenEnterQuickSwitchIdle();
      expect(HomeViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
    })

    it('HomeViewModelTest_updateSceneContainerWhenEnterQuickSwitchIdle_test_02', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      HomeViewModel.getInstance().updateSceneContainerWhenEnterQuickSwitchIdle();
      expect(HomeViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
    })

    it('HomeViewModelTest_updateSceneContainerWhenEnterQuickSwitchIdle_test_03', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      HomeViewModel.getInstance().updateSceneContainerWhenEnterQuickSwitchIdle();
      expect(HomeViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
    })

    it('HomeViewModelTest_updateSceneContainerWhenEnterQuickSwitchIdle_test_04', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockGetScreenProperty: Function =
        mocker.mockFunc(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockGetScreenProperty)().afterReturn(new SCBScreenProperty());
      HomeViewModel.getInstance().updateSceneContainerWhenEnterQuickSwitchIdle();
      expect(HomeViewModel.getInstance()).not().assertUndefined();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(), SCBScenePanelManager.getInstance().getScreenProperty);
    })
  })
}