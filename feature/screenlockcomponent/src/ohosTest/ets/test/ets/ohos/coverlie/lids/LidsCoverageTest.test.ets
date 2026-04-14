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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium';
import Constants from '../../../../../../../main/ets/common/Constants';
import NumKeyBoardViewModel
  from '../../../../../../../../../screenlockcomponent/src/main/ets/password/viewmodel/NumKeyBoardViewModel';
import { PasswordLayoutConfig } from '../../../../../../../main/ets/password/common/PasswordLayoutConfig';
import { DigitalKeyboardItem } from '../../../../../../../main/ets/password/common/DigitalKeyboardItem';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import PasswordViewModel from "../../../../../../../../../../product/pcbase/src/main/ets/SceneBoard/screenlock/vm/PasswordViewModel";
import { DeviceHelper } from '@ohos/frameworkwrapper';

export default function LidsCoverageTestOne() {

  describe('LidsCoverageTestOne', (): void => {
    let mNumKeyBoardViewModel: NumKeyBoardViewModel = new NumKeyBoardViewModel();
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
    let event: TouchEvent = {
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
      touches: [{
        y: 100,
        id: 0,
        displayX: 11,
        displayY: 12,
        windowX: 13,
        windowY: 14,
        type: TouchType.Up,
        screenX: 10,
        screenY: 10,
        x: 100
      }],
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
      preventDefault: (): void => {
      },
    };
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_getHotZoneWith_return', 0, (): void => {
      let mock = new MockKit();
      let mockFunc = mock.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let resA = mNumKeyBoardViewModel.getHotZoneWith();
      expect(resA).not().assertNull();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let resB = mNumKeyBoardViewModel.getHotZoneWith();
      expect(resB).not().assertNull();
      mock.clear(DeviceHelper)
    })

    it('test_getHotZoneHeightMargin_return', 0, (): void => {
      let mock = new MockKit();
      let mockFunc = mock.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let resA = mNumKeyBoardViewModel.getHotZoneHeightMargin();
      expect(resA).not().assertNull();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let resB = mNumKeyBoardViewModel.getHotZoneHeightMargin();
      expect(resB).not().assertNull();
      mock.clear(DeviceHelper)
    })

    it('test_cancelTouch', 0, (): void => {
      let event: TouchEvent = {
        touches: [{
          y: -999999999
        } as TouchObject]
      } as TouchEvent;
      let resA = mNumKeyBoardViewModel.cancelTouch(event);
      expect(resA).assertTrue();
    })

    it('test_cancelTouch_return', 0, (): void => {
      let passwordLayoutConfig: PasswordLayoutConfig = new PasswordLayoutConfig();
      mNumKeyBoardViewModel.setPasswordLayoutConfig(passwordLayoutConfig);
      let result = mNumKeyBoardViewModel.cancelTouch(event);
      expect(result).assertEqual(true);
    })

    it('test_onKeyClick_return', 0, (): void => {
      let item: DigitalKeyboardItem = {
        index: 11,
        row1: $r('app.string.psd_back'),
        row2: '',
        row3: $r('app.string.psd_back'),
        biasX: 1,
        biasY: 3,
        turnNum: 3,
        value: Constants.GO_BACK,
        bkg: false,
        needAnimation: true
      };
      let resA: Object = (mNumKeyBoardViewModel as object)['onKeyClick'](item);
      expect(resA === null).assertFalse();
      item.value = Constants.EMERGENCY_CALL;
      let resB: Object = (mNumKeyBoardViewModel as object)['onKeyClick'](item);
      expect(resB === null).assertFalse();
    })

    it('test_getKeyboardIndex_return', 0, (): void => {
      let resA: Object = (mNumKeyBoardViewModel as object)['getKeyboardIndex'](KeyCode.KEYCODE_DEL);
      expect(resA === -1).assertTrue();

      let resB: Object = (mNumKeyBoardViewModel as object)['getKeyboardIndex'](KeyCode.KEYCODE_GRAVE);
      expect(resB !== null).assertTrue();
    })

    it('test_onKeyUp_return', 0, (): void => {
      let keyEvent: KeyEvent = {
        type: KeyType.Down,
        keyCode: 0,
        keyText: '',
        keySource: KeySource.Unknown,
        deviceId: 0,
        metaKey: 0,
        timestamp: 0,
        stopPropagation: () => {
          throw new Error('Function not implemented.');
        },
        intentionCode: 1
      }
      let resA: Object = (mNumKeyBoardViewModel as object)['onKeyUp'](keyEvent);
      expect(resA === null).assertFalse();

    })

    it('test_onKeyDelPressCallback_return', 0, (): void => {
      let resA: Object = (mNumKeyBoardViewModel as object)['onKeyDelPressCallback'](true);
      expect(resA === null).assertFalse();
    })

    it('test_onKeyClickItem_return', 0, (): void => {
      let item: DigitalKeyboardItem = {
        index: 9,
        row1: 'Emergency',
        row2: '',
        row3: $r('app.string.emergency_call'),
        biasX: -1,
        biasY: 3,
        turnNum: 3,
        value: Constants.EMERGENCY_CALL,
        bkg: false,
        needAnimation: true
      };
      let resA: Object = (mNumKeyBoardViewModel as object)['onKeyClickItem'](item, false);
      expect(resA === null).assertFalse();
      item.value = Constants.GO_BACK;
      let resB: Object = (mNumKeyBoardViewModel as object)['onKeyClickItem'](item, true);
      expect(resB === null).assertFalse();
      item.value = Constants.DEL_PWD;
      let resC: Object = (mNumKeyBoardViewModel as object)['onKeyClickItem'](item, true);
      expect(resC === null).assertFalse();
    })

    it('test_NumKeyOnKeyEventUp_return', 0, (): void => {
      let keyEvent: KeyEvent = {
        type: KeyType.Down,
        keyCode: 0,
        keyText: '',
        keySource: KeySource.Unknown,
        deviceId: 0,
        metaKey: 0,
        timestamp: 0,
        stopPropagation: () => {
          throw new Error('Function not implemented.');
        },
        intentionCode: 1
      }
      keyEvent.keyCode = KeyCode.KEYCODE_SHIFT_LEFT;
      let resA: Object = (mNumKeyBoardViewModel as object)['NumKeyOnKeyEventUp'](false, ()=>{}, ()=>{}, true, keyEvent);
      expect(resA === null).assertFalse();
      keyEvent.keyCode = KeyCode.KEYCODE_SHIFT_RIGHT;
      let resB: Object = (mNumKeyBoardViewModel as object)['NumKeyOnKeyEventUp'](false, ()=>{}, ()=>{}, true, keyEvent);
      expect(resB === null).assertFalse();
      keyEvent.keyCode = KeyCode.KEYCODE_TAB;
      let resC: Object = (mNumKeyBoardViewModel as object)['NumKeyOnKeyEventUp'](false, ()=>{}, ()=>{}, true, keyEvent);
      expect(resC === null).assertFalse();
      keyEvent.keyCode = KeyCode.KEYCODE_ENTER;
      let resD: Object = (mNumKeyBoardViewModel as object)['NumKeyOnKeyEventUp'](true, ()=>{}, true, true, keyEvent);
      expect(resD === null).assertFalse();
      keyEvent.keyCode = KeyCode.KEYCODE_NUMPAD_ENTER;
      let tmp: DigitalKeyboardItem = {
        index: 9,
        row1: 'Emergency',
        row2: '',
        row3: $r('app.string.emergency_call'),
        biasX: -1,
        biasY: 3,
        turnNum: 3,
        value: Constants.EMERGENCY_CALL,
        bkg: false,
        needAnimation: true
      };
      (mNumKeyBoardViewModel as object)["currentFocusBtnItem"] = tmp;
      let resE: Object = (mNumKeyBoardViewModel as object)['NumKeyOnKeyEventUp'](false, ()=>{}, true, true, keyEvent);
      expect(resE === null).assertFalse();
      (mNumKeyBoardViewModel as object)["currentFocusBtnItem"] = null;
      let resF: Object = (mNumKeyBoardViewModel as object)['NumKeyOnKeyEventUp'](true, ()=>{}, true, true, keyEvent);
      expect(resF === null).assertFalse();
    })

    it('test_NumKeyOnKeyEventDown_return', 0, (): void => {
      let keyEvent: KeyEvent = {
        type: KeyType.Down,
        keyCode: 0,
        keyText: '',
        keySource: KeySource.Unknown,
        deviceId: 0,
        metaKey: 0,
        timestamp: 0,
        stopPropagation: () => {
          throw new Error('Function not implemented.');
        },
        intentionCode: 1
      }
      keyEvent.keyCode = KeyCode.KEYCODE_SHIFT_LEFT;
      let resA: Object = (mNumKeyBoardViewModel as object)['NumKeyOnKeyEventDown'](keyEvent);
      expect(resA === null).assertFalse();
      keyEvent.keyCode = KeyCode.KEYCODE_SHIFT_RIGHT;
      let resB: Object = (mNumKeyBoardViewModel as object)['NumKeyOnKeyEventDown'](keyEvent);
      expect(resB === null).assertFalse();
    })

    it('test_NumKeyOnKeyEvent_return', 0, (): void => {
      let keyEvent: KeyEvent = {
        type: KeyType.Down,
        keyCode: 0,
        keyText: '',
        keySource: KeySource.Unknown,
        deviceId: 0,
        metaKey: 0,
        timestamp: 0,
        stopPropagation: (): void => {
          throw new Error('Function not implemented.');
        },
        intentionCode: undefined
      }
      let tmp: PasswordViewModel = new PasswordViewModel();
      (mNumKeyBoardViewModel as object)["viewModel"] = tmp;
      let resA = mNumKeyBoardViewModel.NumKeyOnKeyEvent(true, ()=>{}, ()=>{}, keyEvent);
      expect(resA === null).assertFalse();
      (mNumKeyBoardViewModel as object)["viewModel"] = null;
      let resB = mNumKeyBoardViewModel.NumKeyOnKeyEvent(true, ()=>{}, ()=>{}, keyEvent);
      expect(resB === null).assertFalse();
      keyEvent.type = KeyType.Down;
      let resC = mNumKeyBoardViewModel.NumKeyOnKeyEvent(true, ()=>{}, ()=>{}, keyEvent);
      expect(resC === null).assertFalse();
    })

    it('test_NumKeyOnTouchEvent_return', 0, (): void => {
      let item: DigitalKeyboardItem = {
        index: 9,
        row1: 'Emergency',
        row2: '',
        row3: $r('app.string.emergency_call'),
        biasX: -1,
        biasY: 3,
        turnNum: 3,
        value: Constants.EMERGENCY_CALL,
        bkg: false,
        needAnimation: true
      };
      let tmp: PasswordViewModel = new PasswordViewModel();
      (mNumKeyBoardViewModel as object)["viewModel"] = tmp;
      let resA = mNumKeyBoardViewModel.NumKeyOnTouchEvent(item, [], ()=>{});
      expect(resA === null).assertFalse();
      (mNumKeyBoardViewModel as object)["viewModel"] = null;

      let resB = mNumKeyBoardViewModel.NumKeyOnTouchEvent(item, [], ()=>{}, event);
      expect(resB === null).assertFalse();
      event.type = TouchType.Move;
      let resC = mNumKeyBoardViewModel.NumKeyOnTouchEvent(item, [], ()=>{}, event);
      expect(resC === null).assertFalse();
      event.type = 1;
      let resD = mNumKeyBoardViewModel.NumKeyOnTouchEvent(item, [], ()=>{}, event);
      expect(resD === null).assertFalse();
      event.type = 3;
      let resE = mNumKeyBoardViewModel.NumKeyOnTouchEvent(item, [], ()=>{}, event);
      expect(resE === null).assertFalse();
      event.type = 0;
      let resF = mNumKeyBoardViewModel.NumKeyOnTouchEvent(item, [], ()=>{}, event);
      expect(resF === null).assertFalse();
    })
  })
}
