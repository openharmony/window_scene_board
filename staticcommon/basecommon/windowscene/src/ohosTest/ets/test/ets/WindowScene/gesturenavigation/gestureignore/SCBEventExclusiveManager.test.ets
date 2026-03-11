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
import { EventType, scbEventExclusiveManager } from '../../../../../../../main/ets/TsIndex';
import {
  EventExclusiveConfig
} from '../../../../../../../main/ets/gesturenavigation/gestureignore/configs/EventExclusiveConfig';


export default function SCBEventExclusiveManagerTest() {
  describe('SCBEventExclusiveManagerTest', () => {
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

    it('SCBEventExclusiveManagerTest_registerEventExclusive_001', 0, async () => {
      let restoreCallBack = undefined;
      let caller = EventType.DESKTOP_DRAG;
      expect(scbEventExclusiveManager.registerEventExclusive(caller, restoreCallBack) === undefined).assertTrue();
    })

    it('SCBEventExclusiveManagerTest_registerEventExclusive_002', 0, async () => {
      let caller = EventType.DESKTOP_DRAG;
      let restoreCallBack = () => {
      };
      expect(scbEventExclusiveManager.registerEventExclusive(caller, restoreCallBack) === undefined).assertTrue();
    })

    it('SCBEventExclusiveManagerTest_registerEventExclusive_003', 0, async () => {
      let caller = EventType.DESKTOP_DRAG;
      let restoreCallBack = () => {
      };
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(EventExclusiveConfig, EventExclusiveConfig.getEventTypeName);
      when(mockFunction)(ArgumentMatchers.any).afterReturn('');
      expect(scbEventExclusiveManager.registerEventExclusive(caller, restoreCallBack) === undefined).assertTrue();
      mocker.ignoreMock(EventExclusiveConfig, EventExclusiveConfig.getEventTypeName);
    })

    it('SCBEventExclusiveManagerTest_unRegisterEventExclusive_001', 0, async () => {
      let caller = EventType.DESKTOP_DRAG;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(EventExclusiveConfig, EventExclusiveConfig.getEventTypeName);
      when(mockFunction)(ArgumentMatchers.any).afterReturn('');
      expect(scbEventExclusiveManager.unRegisterEventExclusive(caller) === undefined).assertTrue();
      mocker.ignoreMock(EventExclusiveConfig, EventExclusiveConfig.getEventTypeName);
    })

    it('SCBEventExclusiveManagerTest_unRegisterEventExclusive_002', 0, async () => {
      let caller = EventType.DESKTOP_DRAG;
      expect(scbEventExclusiveManager.unRegisterEventExclusive(caller) === undefined).assertTrue();
    })

    it('SCBEventExclusiveManagerTest_setEventExclusive_001', 0, () => {
      let isExclusive = true;
      let caller = EventType.DESKTOP_DRAG;
      expect(scbEventExclusiveManager.setEventExclusive(caller, isExclusive) === undefined).assertTrue();
    })

    it('SCBEventExclusiveManagerTest_setEventExclusive_002', 0, () => {
      let isExclusive = false;
      let caller = EventType.DESKTOP_DRAG;
      scbEventExclusiveManager['eventExclusiveMap'].set(EventType.DESKTOP_DRAG, [true, '0']);
      expect(scbEventExclusiveManager.setEventExclusive(caller, isExclusive) === undefined).assertTrue();
    })

    it('SCBEventExclusiveManagerTest_setEventExclusive_003', 0, () => {
      let isExclusive = false;
      let caller = EventType.DESKTOP_DRAG;
      scbEventExclusiveManager['eventExclusiveMap'].set(EventType.DESKTOP_DRAG, [false, '0']);
      expect(scbEventExclusiveManager.setEventExclusive(caller, isExclusive) === undefined).assertTrue();
    })

    it('SCBEventExclusiveManagerTest_setEventExclusive_004', 0, () => {
      let isExclusive = true;
      let caller = EventType.DESKTOP_ALL_NOTGRIDSWIPER;
      expect(scbEventExclusiveManager.setEventExclusive(caller, isExclusive) === undefined).assertTrue();
    })

    it('SCBEventExclusiveManagerTest_setEventExclusive_005', 0, () => {
      let isExclusive = false;
      let caller = EventType.DESKTOP_DRAG;
      scbEventExclusiveManager['eventExclusiveMap'].set(EventType.DESKTOP_DRAG, [true, '0']);
      expect(scbEventExclusiveManager.setEventExclusive(caller, isExclusive) === undefined).assertTrue();
    })

    it('SCBEventExclusiveManagerTest_setEventExclusive_006', 0, () => {
      let isExclusive = true;
      let caller = EventType.DESKTOP_ALL_NOTGRIDSWIPER;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(EventExclusiveConfig, EventExclusiveConfig.getEventTypeName);
      when(mockFunction)(ArgumentMatchers.any).afterReturn('');
      expect(scbEventExclusiveManager.setEventExclusive(caller, isExclusive) === undefined).assertTrue();
      mocker.ignoreMock(EventExclusiveConfig, EventExclusiveConfig.getEventTypeName);
    })

    it('SCBEventExclusiveManagerTest_getEventExclusiveByCallerTest_01', 0, () => {
      let caller = EventType.DESKTOP_ALL_NOTGRIDSWIPER;
      scbEventExclusiveManager['eventExclusiveMap'].set(EventType.DESKTOP_DRAG, [true, '0']);
      expect(scbEventExclusiveManager.getEventExclusiveByCaller(caller) !== undefined).assertTrue();
    })

    it('SCBEventExclusiveManagerTest_getEventExclusiveByCallerTest_02', 0, () => {
      let caller = EventType.DESKTOP_ALL_NOTGRIDSWIPER;
      scbEventExclusiveManager['eventExclusiveMap'].set(caller, [true, '0']);
      expect(scbEventExclusiveManager.getEventExclusiveByCaller(caller) !== undefined).assertTrue();
    })

    it('SCBEventExclusiveManagerTest_getEventExclusiveByCaller_03', 0, () => {
      let caller = EventType.DESKTOP_ALL_NOTGRIDSWIPER;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(EventExclusiveConfig, EventExclusiveConfig.getEventTypeName);
      when(mockFunction)(ArgumentMatchers.any).afterReturn('');
      expect(scbEventExclusiveManager.getEventExclusiveByCaller(caller) !== undefined).assertTrue();
      mocker.ignoreMock(EventExclusiveConfig, EventExclusiveConfig.getEventTypeName);
    })

    it('SCBEventExclusiveManagerTest_getAllEventExclusive_001', 0, () => {
      let caller = EventType.DESKTOP_ALL_NOTGRIDSWIPER;
      scbEventExclusiveManager['eventExclusiveMap'].set(caller, [true, '0']);
      expect(scbEventExclusiveManager.getAllEventExclusive() !== undefined).assertTrue();
    })

    it('SCBEventExclusiveManagerTest_getAllEventExclusive_002', 0, () => {
      let caller = EventType.DESKTOP_ALL_NOTGRIDSWIPER;
      scbEventExclusiveManager['eventExclusiveMap'].set(caller, [false, '0']);
      expect(scbEventExclusiveManager.getAllEventExclusive() !== undefined).assertTrue();
    })

    it('SCBEventExclusiveManagerTest_isExclusive_01', 0, () => {
      let caller = EventType.DESKTOP_DRAG;
      scbEventExclusiveManager['totalExclusiveBitmap'] = EventType.NO_EXCLUSIVE;
      expect(scbEventExclusiveManager.isExclusive(caller)).assertFalse();
    })

    it('SCBEventExclusiveManagerTest_isExclusive_02', 0, () => {
      let caller = EventType.DESKTOP_DRAG;
      scbEventExclusiveManager['totalExclusiveBitmap'] = EventType.DESKTOP_DRAG;
      scbEventExclusiveManager['eventExclusiveMap'].set(caller, [true, '0']);
      expect(scbEventExclusiveManager.isExclusive(caller)).assertTrue();
    })

    it('SCBEventExclusiveManagerTest_isExclusive_03', 0, () => {
      let caller = EventType.DESKTOP_DRAG;
      scbEventExclusiveManager['totalExclusiveBitmap'] = EventType.DESKTOP_DRAG;
      scbEventExclusiveManager['eventExclusiveMap'].set(EventType.NO_EXCLUSIVE, [true, '0']);
      expect(scbEventExclusiveManager.isExclusive(caller)).assertTrue();
    })

    it('SCBEventExclusiveManagerTest_isExclusive_04', 0, () => {
      let caller = EventType.DESKTOP_DRAG;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(EventExclusiveConfig, EventExclusiveConfig.getEventTypeName);
      when(mockFunction)(ArgumentMatchers.any).afterReturn('');
      expect(scbEventExclusiveManager.isExclusive(caller)).assertTrue();
      mocker.ignoreMock(EventExclusiveConfig, EventExclusiveConfig.getEventTypeName);
    })

    it('SCBEventExclusiveManagerTest_restoreAllEventExclusiveTest_001', 0, () => {
      let caller = EventType.DESKTOP_DRAG;
      scbEventExclusiveManager['eventExclusiveMap'].set(caller, [true, '0']);
      scbEventExclusiveManager['restoreCallBackMap'].clear();
      expect(scbEventExclusiveManager.restoreAllEventExclusive(caller) === undefined).assertTrue();
    })

    it('SCBEventExclusiveManagerTest_restoreAllEventExclusiveTest_002', 0, () => {
      let caller = EventType.DESKTOP_DRAG;
      scbEventExclusiveManager['eventExclusiveMap'].set(caller, [true, '0']);
      scbEventExclusiveManager['restoreCallBackMap'].set(caller, () => {
      });
      expect(scbEventExclusiveManager.restoreAllEventExclusive(caller) === undefined).assertTrue();
    })

    it('SCBEventExclusiveManagerTest_restoreAllEventExclusiveTest_003', 0, () => {
      let caller = EventType.DESKTOP_DRAG;
      scbEventExclusiveManager['eventExclusiveMap'].set(caller, [false, '0']);
      expect(scbEventExclusiveManager.restoreAllEventExclusive(caller) === undefined).assertTrue();
    })

    it('SCBEventExclusiveManagerTest_restoreAllEventExclusiveNew_001', 0, () => {
      let caller = EventType.DESKTOP_DRAG;
      scbEventExclusiveManager['eventExclusiveMap'].set(caller, [true, '0']);
      scbEventExclusiveManager['restoreCallBackMap'].clear();
      expect(scbEventExclusiveManager.restoreAllEventExclusive(caller) === undefined).assertTrue();
    })

    it('SCBEventExclusiveManagerTest_restoreAllEventExclusiveNew_002', 0, () => {
      let caller = EventType.DESKTOP_DRAG;
      scbEventExclusiveManager['eventExclusiveMap'].set(caller, [true, '0']);
      scbEventExclusiveManager['restoreCallBackMap'].set(caller, () => {
      });
      expect(scbEventExclusiveManager.restoreAllEventExclusive(caller) === undefined).assertTrue();
    })

    it('SCBEventExclusiveManagerTest_restoreAllEventExclusiveNew_003', 0, () => {
      let caller = EventType.DESKTOP_DRAG;
      scbEventExclusiveManager['eventExclusiveMap'].set(caller, [false, '0']);
      expect(scbEventExclusiveManager.restoreAllEventExclusive(caller) === undefined).assertTrue();
    })

    it('SCBEventExclusiveManagerTest_getEventExclusiveBitmap_001', 0, () => {
      let isExclusive = true;
      let caller = EventType.DESKTOP_DRAG;
      expect(scbEventExclusiveManager.setEventExclusive(caller, isExclusive) === undefined).assertTrue();
    })

    it('SCBEventExclusiveManagerTest_getEventExclusiveBitmap_002', 0, () => {
      let isExclusive = true;
      let caller = EventType.DESKTOP_SWIPER;
      expect(scbEventExclusiveManager.setEventExclusive(caller, isExclusive) === undefined).assertTrue();
    })

    it('SCBEventExclusiveManagerTest_getEventExclusiveBitmap_003', 0, () => {
      let isExclusive = true;
      let caller = EventType.GLOBALSEARCH;
      expect(scbEventExclusiveManager.setEventExclusive(caller, isExclusive) === undefined).assertTrue();
    })

    it('SCBEventExclusiveManagerTest_getEventExclusiveBitmap_004', 0, () => {
      let isExclusive = true;
      let caller = EventType.NEGATIVE_SCROLL;
      expect(scbEventExclusiveManager.setEventExclusive(caller, isExclusive) === undefined).assertTrue();
    })

    it('SCBEventExclusiveManagerTest_getEventExclusiveBitmap_005', 0, () => {
      let isExclusive = true;
      let caller = EventType.GESTURE_BACK;
      expect(scbEventExclusiveManager.setEventExclusive(caller, isExclusive) === undefined).assertTrue();
    })

    it('SCBEventExclusiveManagerTest_getEventExclusiveBitmap_006', 0, () => {
      let isExclusive = true;
      let caller = EventType.GESTURE_NAVBAR;
      expect(scbEventExclusiveManager.setEventExclusive(caller, isExclusive) === undefined).assertTrue();
    })

    it('SCBEventExclusiveManagerTest_getEventExclusiveBitmap_007', 0, () => {
      let isExclusive = true;
      let caller = EventType.GESTURE_STATUS_BAR;
      expect(scbEventExclusiveManager.setEventExclusive(caller, isExclusive) === undefined).assertTrue();
    })

    it('SCBEventExclusiveManagerTest_getEventExclusiveBitmap_008', 0, () => {
      let isExclusive = true;
      let caller = EventType.FLOATING_DRAG;
      expect(scbEventExclusiveManager.setEventExclusive(caller, isExclusive) === undefined).assertTrue();
    })

    it('SCBEventExclusiveManagerTest_getEventExclusiveBitmap_009', 0, () => {
      let isExclusive = true;
      let caller = EventType.TOUCH_FLOATINGDRAG_HOTAREA;
      expect(scbEventExclusiveManager.setEventExclusive(caller, isExclusive) === undefined).assertTrue();
    })

    it('SCBEventExclusiveManagerTest_getEventExclusiveBitmap_0010', 0, () => {
      let isExclusive = true;
      let caller = EventType.SPLIT_GESTURE;
      expect(scbEventExclusiveManager.setEventExclusive(caller, isExclusive) === undefined).assertTrue();
    })

    it('SCBEventExclusiveManagerTest_getEventExclusiveBitmap_0011', 0, () => {
      let isExclusive = true;
      let caller = EventType.RECENT_CARD_UPSLIDE;
      expect(scbEventExclusiveManager.setEventExclusive(caller, isExclusive) === undefined).assertTrue();
    })

    it('SCBEventExclusiveManagerTest_getEventExclusiveBitmap_0013', 0, () => {
      let isExclusive = true;
      let caller = EventType.APPEXIT_LANDSCAPE;
      expect(scbEventExclusiveManager.setEventExclusive(caller, isExclusive) === undefined).assertTrue();
    })

    it('SCBEventExclusiveManagerTest_getEventExclusiveBitmap_0015', 0, () => {
      let isExclusive = true;
      let caller = EventType.GESTURE_SCREENLOCK_CAMERA;
      expect(scbEventExclusiveManager.setEventExclusive(caller, isExclusive) === undefined).assertTrue();
    })

    it('SCBEventExclusiveManagerTest_restoreAllEventExclusive_001', 0, () => {
      let caller = EventType.GESTURE_SCREENLOCK_CAMERA;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(EventExclusiveConfig, EventExclusiveConfig.getEventTypeName);
      when(mockFunction)(ArgumentMatchers.any).afterReturn('');
      expect(scbEventExclusiveManager.restoreAllEventExclusive(caller) === undefined).assertTrue();
      mocker.ignoreMock(EventExclusiveConfig, EventExclusiveConfig.getEventTypeName);
    })

  })
}

