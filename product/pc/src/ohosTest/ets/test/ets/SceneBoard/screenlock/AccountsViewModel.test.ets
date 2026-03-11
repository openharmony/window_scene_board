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

import ScreenLockService from '@ohos/pcbase/src/main/ets/SceneBoard/screenlock/refactor/ScreenLockService';
import { AuthSubType } from '@ohos/screenlockcommon';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import AccountsViewModel, {ModelType } from '@ohos/pcbase/src/main/ets/SceneBoard/screenlock/vm/AccountsViewModel';

export default function AccountsViewModelTest() {
  describe('AccountsViewModelTest', () => {
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

    it('onInputChange', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let accountsVM: AccountsViewModel = new AccountsViewModel();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      accountsVM.onInputChange('a', AuthSubType.PIN_MIXED);
      expect(accountsVM.passwordMixArr.length > 0).assertTrue();
      accountsVM.onInputChange('', AuthSubType.PIN_MIXED);
      expect(accountsVM.passwordMixArr.length === 0).assertTrue();
    })

    it('onDelKeyLongPress', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let accountsVM: AccountsViewModel = new AccountsViewModel();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      accountsVM.onDelKeyLongPress();
      expect(accountsVM.passwordMixArr.length === 0).assertTrue();
    })

    it('handleKeyEvent', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let accountsVM: AccountsViewModel = new AccountsViewModel();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      let keyEvent = {
        keyCode: 2000,
        keyText: 'KEYCODE_0',
        type: KeyType.Up
      } as KeyEvent;
      accountsVM.handleKeyEvent(keyEvent, ModelType.PIN_AUTH_TYPE);

      keyEvent = {
        keyCode: 2000,
        keyText: 'KEYCODE_0',
        type: KeyType.Down
      } as KeyEvent;
      ScreenLockService.isScreenOn = false;
      accountsVM.handleKeyEvent(keyEvent, ModelType.PIN_AUTH_TYPE);
      ScreenLockService.isScreenOn = true;
      accountsVM.handleKeyEvent(keyEvent, ModelType.PIN_AUTH_TYPE);
      accountsVM.handleKeyEvent(keyEvent, ModelType.DOMAIN_AUTH_TYPE);
      accountsVM.handleKeyEvent(keyEvent, ModelType.OTHER_USER_TYPE);
      accountsVM.handleKeyEvent(keyEvent, 3);
    })

    it('clearPassword', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let accountsVM: AccountsViewModel = new AccountsViewModel();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      accountsVM.clearPassword();
      expect(accountsVM.passwordMixArr.length === 0).assertTrue();
    })

    it('dispatchOtherUserEvent', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let accountsVM: AccountsViewModel = new AccountsViewModel();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      let keyEvent = {
        keyCode: 2054,
        keyText: 'KEYCODE_ENTER',
        type: KeyType.Down
      } as KeyEvent;
      accountsVM.dispatchOtherUserEvent(keyEvent);

      keyEvent = {
        keyCode: 2119,
        keyText: 'KEYCODE_NUMPAD_ENTER',
        type: KeyType.Down
      } as KeyEvent;
      accountsVM.dispatchOtherUserEvent(keyEvent);

      keyEvent = {
        keyCode: 2120,
        keyText: 'KEYCODE_NUMPAD_EQUALS',
        type: KeyType.Down
      } as KeyEvent;
      accountsVM.dispatchOtherUserEvent(keyEvent);
    })

    it('onUserClick', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let accountsVM: AccountsViewModel = new AccountsViewModel();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      accountsVM.onUserClick(100);
    })

    it('dispatchAuthTypeChangeEvent', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let accountsVM: AccountsViewModel = new AccountsViewModel();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      let keyEvent = {
        keyCode: 2054,
        keyText: 'KEYCODE_ENTER',
        type: KeyType.Down
      } as KeyEvent;
      accountsVM.dispatchAuthTypeChangeEvent(keyEvent, true);

      keyEvent = {
        keyCode: 2119,
        keyText: 'KEYCODE_NUMPAD_ENTER',
        type: KeyType.Down
      } as KeyEvent;
      accountsVM.dispatchAuthTypeChangeEvent(keyEvent, true);

      keyEvent = {
        keyCode: 2120,
        keyText: 'KEYCODE_NUMPAD_EQUALS',
        type: KeyType.Down
      } as KeyEvent;
      accountsVM.dispatchAuthTypeChangeEvent(keyEvent, true);
    })

    it('ViewModelInit', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let accountsVM: AccountsViewModel = new AccountsViewModel();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      accountsVM.ViewModelInit();
      expect(accountsVM.prompt === null).assertTrue();
    })

    it('dispatchKeyEvent', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let accountsVM: AccountsViewModel = new AccountsViewModel();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      let keyEvent = {
        keyCode: 2054,
        keyText: 'KEYCODE_ENTER',
        type: KeyType.Down
      } as KeyEvent;
      accountsVM.dispatchKeyEvent(keyEvent, 100);
    })

    it('passwordKeyEvent', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let accountsVM: AccountsViewModel = new AccountsViewModel();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      let keyEvent = {
        keyCode: 2054,
        keyText: 'KEYCODE_ENTER',
        type: KeyType.Up
      } as KeyEvent;
      accountsVM.passwordKeyEvent(keyEvent, 100);

      keyEvent = {
        keyCode: 2054,
        keyText: 'KEYCODE_ENTER',
        type: KeyType.Down
      } as KeyEvent;
      accountsVM.passwordKeyEvent(keyEvent, 100);


      keyEvent = {
        keyCode: 2000,
        keyText: 'KEYCODE_0',
        type: KeyType.Down
      } as KeyEvent;
      accountsVM.passwordKeyEvent(keyEvent, 100);
    })

    it('getScreenDensity', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let accountsVM: AccountsViewModel = new AccountsViewModel();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      accountsVM.getScreenDensity();
    })

    it('countdown', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let accountsVM: AccountsViewModel = new AccountsViewModel();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      accountsVM.countdown();
    })

    it('bindCountdown', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let accountsVM: AccountsViewModel = new AccountsViewModel();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      accountsVM.bindCountdown();
    })

    it('changePrompt', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let accountsVM: AccountsViewModel = new AccountsViewModel();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      accountsVM.changePrompt(3, 2000, () => {});
      accountsVM.changePrompt(3, -1, () => {});
      accountsVM.changePrompt(0, 2000, () => {});
      accountsVM.changePrompt(0, -1, () => {});
      accountsVM.changePrompt(6, -1, () => {});
    })

    it('getWillLockTxt', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let accountsVM: AccountsViewModel = new AccountsViewModel();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      accountsVM.getWillLockTxt(3, 3000, () => {});
    })

    it('getFreezingTimeNm', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let accountsVM: AccountsViewModel = new AccountsViewModel();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      accountsVM.getFreezingTimeNm(5000);
      accountsVM.getFreezingTimeNm(60000);
      accountsVM.getFreezingTimeNm(65000);
    })

    it('updateStorage', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let accountsVM: AccountsViewModel = new AccountsViewModel();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      accountsVM.updateStorage(() => {});
    })

    it('checkFreezingTime', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let accountsVM: AccountsViewModel = new AccountsViewModel();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      accountsVM.checkFreezingTime(() => {});
    })

    it('clearTimeOutTask', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let accountsVM: AccountsViewModel = new AccountsViewModel();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      // accountsVM.timeoutTask = 100;
      accountsVM.clearTimeOutTask();
    })

    it('clearPrompt', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let accountsVM: AccountsViewModel = new AccountsViewModel();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      accountsVM.clearPrompt();
      expect(accountsVM.prompt === null).assertTrue();
    })

    it('switchToPwdPageReport', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let accountsVM: AccountsViewModel = new AccountsViewModel();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      accountsVM.switchToPwdPageReport();
    })

    it('isNeedLimitLogging', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let accountsVM: AccountsViewModel = new AccountsViewModel();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(accountsVM.isNeedLimitLogging()).assertFalse();
      AccountsViewModel.userLoggedAmount = 4;
      expect(accountsVM.isNeedLimitLogging()).assertTrue();
    })

    /**
     * 检查是否可以解锁
     */
    it('isCanUnlock', 0, isCanUnlock);
  })
}

function isCanUnlock() {
  let accountsVM: AccountsViewModel = new AccountsViewModel();

  AppStorage.setOrCreate('accountSwitch', true);
  expect(accountsVM.isCanUnlock()).assertFalse();

  AppStorage.setOrCreate('accountSwitch', false);
  AppStorage.setOrCreate('remoteLocked', true);
  expect(accountsVM.isCanUnlock()).assertFalse();

  AppStorage.setOrCreate('accountSwitch', false);
  AppStorage.setOrCreate('remoteLocked', false);
  ScreenLockService.isScreenOn = false;
  expect(accountsVM.isCanUnlock()).assertFalse();

  AppStorage.setOrCreate('accountSwitch', false);
  AppStorage.setOrCreate('remoteLocked', false);
  ScreenLockService.isScreenOn = true;
  AppStorage.setOrCreate('isBeginSleepStart', true);
  expect(accountsVM.isCanUnlock()).assertFalse();

  AppStorage.setOrCreate('accountSwitch', false);
  AppStorage.setOrCreate('remoteLocked', false);
  ScreenLockService.isScreenOn = true;
  AppStorage.setOrCreate('isBeginSleepStart', false);
  expect(accountsVM.isCanUnlock()).assertTrue();
}