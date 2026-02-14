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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when } from '@ohos/hypium';
import { WindowEvent, PluginRequestEvent, ScreenLockEvent } from '../../../../../../../main/ets/TsIndex';

export function EventsTest() {
  describe('EventsTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('WindowEvent_isWindowStartShow', 0, (): void => {
      let mWindowEvt: WindowEvent = new WindowEvent();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(mWindowEvt, mWindowEvt.isWindowShow);
      when(mockFunc)().afterReturn(true);
      expect(mWindowEvt.isWindowStartShow()).assertInstanceOf('Boolean');
      expect(mWindowEvt.isWindowEndShow()).assertInstanceOf('Boolean');
      mocker.clear(mWindowEvt);
    })

    it('WindowEvent_isWindowEndShow', 0, (): void => {
      let mWindowEvt: WindowEvent = new WindowEvent();
      expect(mWindowEvt.isWindowEndShow()).assertInstanceOf('Boolean');
    })

    it('PluginRequestEvent_setIsVisible', 0, (): void => {
      let mPluginRequestEvt: PluginRequestEvent = new PluginRequestEvent();
      expect(mPluginRequestEvt.setIsVisible(false) === undefined).assertTrue();
    })

    it('ScreenLockEvent_isSecureAndLocked', 0, (): void => {
      let mScreenLockEvt: ScreenLockEvent = new ScreenLockEvent();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(mScreenLockEvt, mScreenLockEvt.isSecureStatus);
      when(mockFunc)().afterReturn(true);
      expect(mScreenLockEvt.isSecureStatus()).assertInstanceOf('Boolean');
      mocker.clear(mScreenLockEvt);
    });

    it('should_return_this_when_setWindowName_is_called_with_valid_windowName', 0, () => {
      let windowevent: WindowEvent = new WindowEvent();
      let result: WindowEvent = windowevent.setWindowName("valid_windowName");
      expect(result).assertEqual(windowevent);
    });

    it('should_return_true_when_windowName_matches_winName', 0, () => {
      let windowevent: WindowEvent = new WindowEvent();
      windowevent.windowName = "testWindow";
      const result = windowevent.isMatchName("testWindow");
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_windowName_does_not_match_winName', 0, () => {
      let windowevent: WindowEvent = new WindowEvent();
      windowevent.windowName = "testWindow";
      const result = windowevent.isMatchName("otherWindow");
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_eventType_is_hide', 0, () => {
      let windowEvent: WindowEvent = new WindowEvent();
      windowEvent.eventType = WindowEvent.EVENT_TYPE_HIDE;
      const result = windowEvent.isWindowHide();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_eventType_is_not_hide', 0, () => {
      let windowEvent: WindowEvent = new WindowEvent();
      windowEvent.eventType = WindowEvent.EVENT_TYPE_SHOW;
      const result = windowEvent.isWindowHide();
      expect(result).assertEqual(false);
    });
  })
}
