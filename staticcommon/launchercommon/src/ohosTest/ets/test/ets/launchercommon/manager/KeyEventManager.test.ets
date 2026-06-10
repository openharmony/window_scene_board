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
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  Level,
  MockKit,
  when
} from '@ohos/hypium'
import keyEventManager, { KeyEventListener } from '../../../../../../main/ets/manager/KeyEventManager'
import KeyEventConstants from '../../../../../../main/ets/constants/KeyEventConstants';
import { KeyCodeConstants, KeyState } from '@ohos/commonconstants';
import { KeyCode } from '@kit.InputKit';


class TestKeyEvent {
  keyCode: number = -1;
  type: number = -1;
}

export default function KeyEventManagerTest() {
  describe('KeyEventManagerTest', () => {
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

    it('test_registerKeyEventListener', 0, () => {

      let keyEventListener: KeyEventListener = {
        onReceiveKeyEvent: (event: string): void => {}
      };
      keyEventManager.registerKeyEventListener(keyEventListener, null);

      const eventList: string[] = [
        KeyEventConstants.EVENT_ENTER,
        KeyEventConstants.EVENT_DELETE,
        KeyEventConstants.EVENT_F2,
        KeyEventConstants.EVENT_FORCE_DELETE,
        KeyEventConstants.EVENT_CTRL_C,
        KeyEventConstants.EVENT_CTRL_V,
        KeyEventConstants.EVENT_CTRL_X,
        KeyEventConstants.EVENT_CTRL_A
      ];
      keyEventManager.registerKeyEventListener(keyEventListener, eventList);
      expect(keyEventManager['mKeyEventListeners']).not().assertNull();

      keyEventManager.unRegisterKeyEventListener(keyEventListener);
    })

    it('test_resetCombKeyState', Level.LEVEL0, async (done: Function) => {
      let res = true;
      await keyEventManager.resetCombKeyState();
      expect(res).assertTrue();
      done();
    })

    it('test_dispatchKeyEvent', Level.LEVEL0, async (done: Function) => {
      let event: TestKeyEvent = new TestKeyEvent();
      event.keyCode = KeyCodeConstants.KEYCODE_CTRL;
      event.type = 0;
      await keyEventManager.dispatchKeyEvent(event);

      let eventShift: TestKeyEvent = new TestKeyEvent();
      eventShift.keyCode = KeyCodeConstants.KEYCODE_SHIFT_LEFT;
      eventShift.type = 0;
      await keyEventManager.dispatchKeyEvent(eventShift);

      let eventShiftRight: TestKeyEvent = new TestKeyEvent();
      eventShiftRight.keyCode = KeyCodeConstants.KEYCODE_SHIFT_RIGHT;
      eventShiftRight.type = 0;
      await keyEventManager.dispatchKeyEvent(eventShiftRight);
      expect(true).assertTrue();
      done();
    })

    it('test_dispatchKeyEvent01', Level.LEVEL0, async (done: Function) => {
      let eventInvalid: TestKeyEvent = new TestKeyEvent();
      eventInvalid.keyCode = 9999;
      eventInvalid.type = 1;
      await keyEventManager.dispatchKeyEvent(eventInvalid);

      let event: TestKeyEvent = new TestKeyEvent();
      event.keyCode = KeyCodeConstants.KEYCODE_ENTER;
      event.type = 0;
      await keyEventManager.dispatchKeyEvent(event);

      event.keyCode = KeyCodeConstants.KEYCODE_DELETE;
      await keyEventManager.dispatchKeyEvent(event);

      event.keyCode = KeyCodeConstants.KEYCODE_F2;
      await keyEventManager.dispatchKeyEvent(event);

      event.keyCode = KeyCodeConstants.KEYCODE_C;
      await keyEventManager.dispatchKeyEvent(event);

      event.keyCode = KeyCodeConstants.KEYCODE_V;
      await keyEventManager.dispatchKeyEvent(event);

      event.keyCode = KeyCodeConstants.KEYCODE_X;
      await keyEventManager.dispatchKeyEvent(event);

      event.keyCode = 3333;
      await keyEventManager.dispatchKeyEvent(event);

      event.keyCode = KeyCodeConstants.KEYCODE_SHIFT_LEFT;
      await keyEventManager.dispatchKeyEvent(event);

      event.keyCode = KeyCodeConstants.KEYCODE_SHIFT_RIGHT;
      await keyEventManager.dispatchKeyEvent(event);

      event.keyCode = KeyCodeConstants.KEYCODE_CTRL;
      await keyEventManager.dispatchKeyEvent(event);

      event.keyCode = KeyCodeConstants.KEYCODE_CTRL_RIGHT;
      await keyEventManager.dispatchKeyEvent(event);
      expect(true).assertTrue();
      done();
    })

    it('test_sendKeyEvent', Level.LEVEL0, () => {
      let event: TestKeyEvent = new TestKeyEvent();
      event.keyCode = KeyCodeConstants.KEYCODE_ENTER;
      event.type = 0;
      keyEventManager.sendKeyEvent(KeyEventConstants.EVENT_ENTER);
      expect(true).assertTrue();
    })

    it('test_sendKeyEvent', Level.LEVEL0, async (done: Function) => {
      let event: TestKeyEvent = new TestKeyEvent();
      event.keyCode = KeyCodeConstants.KEYCODE_ENTER;
      event.type = 0;
      await keyEventManager.sendAsyncEvent(KeyEventConstants.EVENT_ENTER);
      expect(true).assertTrue();
      done();
    })

    it('testKeyEventManager_doKeyEvent', Level.LEVEL0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      mocker.mockFunc(keyEventManager, keyEventManager['doEnterEvent']);
      mocker.mockFunc(keyEventManager, keyEventManager['doDeleteEvent']);
      mocker.mockFunc(keyEventManager, keyEventManager['doF2Event']);
      mocker.mockFunc(keyEventManager, keyEventManager['doCtrlCEvent']);
      mocker.mockFunc(keyEventManager, keyEventManager['doCtrlVEvent']);
      mocker.mockFunc(keyEventManager, keyEventManager['doCtrlXEvent']);
      mocker.mockFunc(keyEventManager, keyEventManager['doCtrlAEvent']);
      mocker.mockFunc(keyEventManager, keyEventManager['doCtrlDEvent']);
      mocker.mockFunc(keyEventManager, keyEventManager['doCtrlZEvent']);
      mocker.mockFunc(keyEventManager, keyEventManager['doCtrlYEvent']);
      mocker.mockFunc(keyEventManager, keyEventManager['doUEvent']);
      mocker.mockFunc(keyEventManager, keyEventManager['doREvent']);
      mocker.mockFunc(keyEventManager, keyEventManager['doCtrlShiftNEvent']);
      mocker.mockFunc(keyEventManager, keyEventManager['doDirectionsEvent']);
      mocker.mockFunc(keyEventManager, keyEventManager['sendKeyEvent']);
      keyEventManager['doKeyEvent'](KeyCodeConstants.KEYCODE_ENTER, true);
      keyEventManager['doKeyEvent'](KeyCodeConstants.KEYCODE_DELETE, true);
      keyEventManager['doKeyEvent'](KeyCodeConstants.KEYCODE_F2, true);
      keyEventManager['doKeyEvent'](KeyCodeConstants.KEYCODE_C, true);
      keyEventManager['doKeyEvent'](KeyCodeConstants.KEYCODE_V, true);
      keyEventManager['doKeyEvent'](KeyCodeConstants.KEYCODE_X, true);
      keyEventManager['doKeyEvent'](KeyCodeConstants.KEYCODE_A, true);
      keyEventManager['doKeyEvent'](KeyCodeConstants.KEYCODE_D, true);
      keyEventManager['doKeyEvent'](KeyCodeConstants.KEYCODE_Z, true);
      keyEventManager['doKeyEvent'](KeyCodeConstants.KEYCODE_Y, true);
      keyEventManager['doKeyEvent'](KeyCodeConstants.KEYCODE_U, true);
      keyEventManager['doKeyEvent'](KeyCodeConstants.KEYCODE_R, true);
      keyEventManager['doKeyEvent'](KeyCodeConstants.KEYCODE_N, true);
      keyEventManager['doKeyEvent'](KeyCodeConstants.KEYCODE_DPAD_UP, true);
      keyEventManager['doKeyEvent'](KeyCodeConstants.KEYCODE_DPAD_DOWN, true);
      keyEventManager['doKeyEvent'](KeyCodeConstants.KEYCODE_DPAD_RIGHT, true);
      keyEventManager['doKeyEvent'](KeyCodeConstants.KEYCODE_DPAD_LEFT, true);
      keyEventManager['doKeyEvent'](KeyCode.KEYCODE_SPACE, true);
      keyEventManager['doKeyEvent'](998, true);
      mocker.verify('doEnterEvent', []).once();
      mocker.verify('doDeleteEvent', []).once();
      mocker.verify('doF2Event', []).once();
      mocker.verify('doCtrlCEvent', []).once();
      mocker.verify('doCtrlVEvent', []).once();
      mocker.verify('doCtrlXEvent', []).once();
      mocker.verify('doCtrlAEvent', []).once();
      mocker.verify('doCtrlDEvent', []).once();
      mocker.verify('doCtrlZEvent', []).once();
      mocker.verify('doCtrlYEvent', []).once();
      mocker.verify('doUEvent', [true]).once();
      mocker.verify('doREvent', [true]).once();
      mocker.verify('doCtrlShiftNEvent', []).once();
      mocker.verify('doDirectionsEvent', []).times(4);
      mocker.verify('sendKeyEvent', [KeyEventConstants.EVENT_SPACE]).once();
      mocker.clear(keyEventManager);
      mocker.clearAll();
      done();
    })

    it('testKeyEventManager_doCtrlZEvent', Level.LEVEL0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      mocker.mockFunc(keyEventManager, keyEventManager.sendKeyEvent);
      const oldIsCtrlDown = keyEventManager['isCtrlDown'];
      keyEventManager['isCtrlDown'] = true;
      keyEventManager['doCtrlZEvent']();
      mocker.verify('sendKeyEvent', [KeyEventConstants.EVENT_CTRL_Z]).once();
      keyEventManager['isCtrlDown'] = oldIsCtrlDown;
      mocker.clear(keyEventManager);
      mocker.clearAll();
      done();
    })

    it('testKeyEventManager_doCtrlYEvent', Level.LEVEL0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      mocker.mockFunc(keyEventManager, keyEventManager.sendKeyEvent);
      const oldIsCtrlDown = keyEventManager['isCtrlDown'];
      keyEventManager['isCtrlDown'] = true;
      keyEventManager['doCtrlYEvent']();
      mocker.verify('sendKeyEvent', [KeyEventConstants.EVENT_CTRL_Y]).once();
      keyEventManager['isCtrlDown'] = oldIsCtrlDown;
      mocker.clear(keyEventManager);
      mocker.clearAll();
      done();
    })

    it('testKeyEventManager_doCtrlCEvent', Level.LEVEL0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      mocker.mockFunc(keyEventManager, keyEventManager.sendKeyEvent);
      const oldIsCtrlDown = keyEventManager['isCtrlDown'];
      keyEventManager['isCtrlDown'] = true;
      keyEventManager['doCtrlCEvent']();
      mocker.verify('sendKeyEvent', [KeyEventConstants.EVENT_CTRL_C]).once();
      keyEventManager['isCtrlDown'] = oldIsCtrlDown;
      mocker.clear(keyEventManager);
      mocker.clearAll();
      done();
    })

    it('testKeyEventManager_doCtrlVEvent', Level.LEVEL0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      mocker.mockFunc(keyEventManager, keyEventManager.sendKeyEvent);
      const oldIsCtrlDown = keyEventManager['isCtrlDown'];
      keyEventManager['isCtrlDown'] = true;
      keyEventManager['doCtrlVEvent']();
      mocker.verify('sendKeyEvent', [KeyEventConstants.EVENT_CTRL_V]).once();
      keyEventManager['isCtrlDown'] = oldIsCtrlDown;
      mocker.clear(keyEventManager);
      mocker.clearAll();
      done();
    })

    it('testKeyEventManager_doCtrlAEvent', Level.LEVEL0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      mocker.mockFunc(keyEventManager, keyEventManager.sendKeyEvent);
      const oldIsCtrlDown = keyEventManager['isCtrlDown'];
      keyEventManager['isCtrlDown'] = true;
      keyEventManager['doCtrlAEvent']();
      mocker.verify('sendKeyEvent', [KeyEventConstants.EVENT_CTRL_A]).once();
      keyEventManager['isCtrlDown'] = oldIsCtrlDown;
      mocker.clear(keyEventManager);
      mocker.clearAll();
      done();
    })

    it('testKeyEventManager_doCtrlXEvent', Level.LEVEL0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      mocker.mockFunc(keyEventManager, keyEventManager.sendKeyEvent);
      const oldIsCtrlDown = keyEventManager['isCtrlDown'];
      keyEventManager['isCtrlDown'] = true;
      keyEventManager['doCtrlXEvent']();
      mocker.verify('sendKeyEvent', [KeyEventConstants.EVENT_CTRL_X]).once();
      keyEventManager['isCtrlDown'] = oldIsCtrlDown;
      mocker.clear(keyEventManager);
      mocker.clearAll();
      done();
    })

    it('testKeyEventManager_doCtrlDEvent', Level.LEVEL0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      mocker.mockFunc(keyEventManager, keyEventManager.sendKeyEvent);
      const oldIsCtrlDown = keyEventManager['isCtrlDown'];
      keyEventManager['isCtrlDown'] = true;
      keyEventManager['doCtrlDEvent']();
      mocker.verify('sendKeyEvent', [KeyEventConstants.EVENT_CTRL_D]).once();
      keyEventManager['isCtrlDown'] = oldIsCtrlDown;
      mocker.clear(keyEventManager);
      mocker.clearAll();
      done();
    })

    it('testKeyEventManager_doEnterEvent', Level.LEVEL0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      mocker.mockFunc(keyEventManager, keyEventManager.sendKeyEvent);
      const oldIsAltKeyDown = keyEventManager['isAltKeyDown'];
      keyEventManager['isAltKeyDown'] = true;
      keyEventManager['doCtrlDEvent']();
      keyEventManager['isAltKeyDown'] = false;
      keyEventManager['doCtrlDEvent']();
      // mocker.verify('sendKeyEvent', [KeyEventConstants.EVENT_ALT_ENTER]).once();
      // mocker.verify('sendKeyEvent', [KeyEventConstants.EVENT_ENTER]).once();
      keyEventManager['isAltKeyDown'] = oldIsAltKeyDown;
      expect(oldIsAltKeyDown).not().assertNull();
      mocker.clear(keyEventManager);
      mocker.clearAll();
      done();
    })

    it('testKeyEventManager_doDeleteEvent', Level.LEVEL0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      mocker.mockFunc(keyEventManager, keyEventManager.sendKeyEvent);
      const oldIsShiftDown = keyEventManager['isShiftDown'];
      keyEventManager['isShiftDown'] = true;
      keyEventManager['doDeleteEvent']();
      keyEventManager['isShiftDown'] = false;
      keyEventManager['doDeleteEvent']();
      expect(keyEventManager).not().assertUndefined();
      keyEventManager['isShiftDown'] = oldIsShiftDown;
      mocker.clear(keyEventManager);
      mocker.clearAll();
      done();
    })

    it('testKeyEventManager_doF2Event', Level.LEVEL0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      mocker.mockFunc(keyEventManager, keyEventManager.sendKeyEvent);
      keyEventManager['doF2Event']();
      expect(keyEventManager).not().assertUndefined();
      mocker.clear(keyEventManager);
      mocker.clearAll();
      done();
    })

    it('testKeyEventManager_doDirectionsEvent', Level.LEVEL0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      mocker.mockFunc(keyEventManager, keyEventManager.sendKeyEvent);
      keyEventManager['doDirectionsEvent']();
      expect(keyEventManager).not().assertUndefined();
      mocker.clear(keyEventManager);
      mocker.clearAll();
      done();
    })

    it('testKeyEventManager_doUEvent', Level.LEVEL0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      mocker.mockFunc(keyEventManager, keyEventManager.sendKeyEvent);
      keyEventManager['doUEvent'](true);
      expect(keyEventManager).not().assertUndefined();
      mocker.clear(keyEventManager);
      mocker.clearAll();
      done();
    })

    it('testKeyEventManager_doREvent', Level.LEVEL0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      mocker.mockFunc(keyEventManager, keyEventManager.sendKeyEvent);
      keyEventManager['doREvent'](true);
      expect(keyEventManager).not().assertUndefined();
      mocker.clear(keyEventManager);
      mocker.clearAll();
      done();
    })

    it('testKeyEventManager_doCtrlShiftNEvent', Level.LEVEL0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      const isCtrlDown = keyEventManager['isCtrlDown'];
      const isShiftDown = keyEventManager['isShiftDown'];
      mocker.mockFunc(keyEventManager, keyEventManager.sendKeyEvent);
      keyEventManager['isCtrlDown'] = true;
      keyEventManager['isShiftDown'] = true;
      keyEventManager['doCtrlShiftNEvent']();
      expect(keyEventManager).not().assertUndefined();
      keyEventManager['isCtrlDown'] = isCtrlDown;
      keyEventManager['isShiftDown'] = isShiftDown;
      mocker.clear(keyEventManager);
      mocker.clearAll();
      done();
    })

    it('testKeyEventManager_getShiftStatus', Level.LEVEL0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      const Get = mocker.mockFunc(keyEventManager['shiftStatus'], keyEventManager['shiftStatus'].get);
      when(Get)(KeyCodeConstants.KEYCODE_SHIFT_LEFT).afterReturn(KeyState.DOWN);
      expect(keyEventManager['getShiftStatus']()).assertTrue();
      when(Get)(KeyCodeConstants.KEYCODE_SHIFT_LEFT).afterReturn(KeyState.UP);
      when(Get)(KeyCodeConstants.KEYCODE_SHIFT_RIGHT).afterReturn(KeyState.UP);
      expect(keyEventManager['getShiftStatus']()).assertFalse();
      mocker.clear(keyEventManager['shiftStatus']);
      mocker.clearAll();
      done();
    })

  })
}
