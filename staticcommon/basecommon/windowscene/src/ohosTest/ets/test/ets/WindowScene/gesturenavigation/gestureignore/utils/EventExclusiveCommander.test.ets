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
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import {
  EventExclusiveConfig,
  EventType
} from '../../../../../../../../main/ets/gesturenavigation/gestureignore/configs/EventExclusiveConfig';
import {
  EventExclusiveCommander
} from '../../../../../../../../main/ets/gesturenavigation/gestureignore/utils/EventExclusiveCommander';

export default function EventExclusiveCommanderTest() {
  describe('EventExclusiveCommanderTest', () => {
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

    it('EventExclusiveCommander_debugSetEventExclusive_1', 0, async (done: Function) => {
      let eventExclusiveCommander: EventExclusiveCommander = new EventExclusiveCommander();
      let mocker: MockKit = new MockKit();
      let mockGetEventType: Function = mocker.mockFunc(EventExclusiveConfig, EventExclusiveConfig.getEventType);
      when(mockGetEventType)(ArgumentMatchers.any).afterReturn(EventType.NO_EXCLUSIVE);
      expect(eventExclusiveCommander['debugSetEventExclusive']([]) !== undefined).assertTrue();
      mocker.ignoreMock(EventExclusiveConfig, EventExclusiveConfig.getEventType);
      done();
    });

    it('EventExclusiveCommander_debugSetEventExclusive_2', 0, async (done: Function) => {
      let eventExclusiveCommander: EventExclusiveCommander = new EventExclusiveCommander();
      let mocker: MockKit = new MockKit();
      let mockGetEventType: Function = mocker.mockFunc(EventExclusiveConfig, EventExclusiveConfig.getEventType);
      when(mockGetEventType)(ArgumentMatchers.any).afterReturn(EventType.DESKTOP_DRAG);
      expect(eventExclusiveCommander['debugSetEventExclusive'](['NO_EXCLUSIVE', 'true']) !== undefined).assertTrue();
      mocker.ignoreMock(EventExclusiveConfig, EventExclusiveConfig.getEventType);
      done();
    });

    it('EventExclusiveCommander_debugSetEventExclusive_3', 0, async (done: Function) => {
      let eventExclusiveCommander: EventExclusiveCommander = new EventExclusiveCommander();
      let mocker: MockKit = new MockKit();
      let mockGetEventType: Function = mocker.mockFunc(EventExclusiveConfig, EventExclusiveConfig.getEventType);
      when(mockGetEventType)(ArgumentMatchers.any).afterReturn(EventType.DESKTOP_DRAG);
      expect(eventExclusiveCommander['debugSetEventExclusive'](['NO_EXCLUSIVE', 'false']) !== undefined).assertTrue();
      mocker.ignoreMock(EventExclusiveConfig, EventExclusiveConfig.getEventType);
      done();
    });

    it('EventExclusiveCommander_debugSetEventExclusive_4', 0, async (done: Function) => {
      let eventExclusiveCommander: EventExclusiveCommander = new EventExclusiveCommander();
      let mocker: MockKit = new MockKit();
      let mockGetEventType: Function = mocker.mockFunc(EventExclusiveConfig, EventExclusiveConfig.getEventType);
      when(mockGetEventType)(ArgumentMatchers.any).afterReturn(EventType.DESKTOP_DRAG);
      expect(eventExclusiveCommander['debugSetEventExclusive'](['NO_EXCLUSIVE', '1']) !== undefined).assertTrue();
      mocker.ignoreMock(EventExclusiveConfig, EventExclusiveConfig.getEventType);
      done();
    });
  })
}