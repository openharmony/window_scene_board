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
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium';
import TestConst from '@ohos/screenlockcomponent/src/ohosTest/ets/test/ets/ohos/constants/TestConst';
import accountModel, { AuthType } from '@ohos/pcbase/src/main/ets/SceneBoard/screenlock/refactor/AccountsModel';
import { osAccount } from '@kit.BasicServicesKit';
import ScreenLockService from '@ohos/pcbase/src/main/ets/SceneBoard/screenlock/refactor/ScreenLockService';
import {
  accountSwitchCallback,
  MultiKeyCode,
  OsAccountSwitchEventData
} from '@ohos/pcbase/src/main/ets/SceneBoard/screenlock/refactor/AccountsModel';
import { IntentionCode } from '@ohos.multimodalInput.intentionCode';
import { ArrayUtils } from '@ohos/basicutils';


export default function AccountsModelTest() {

  describe('AccountsModelTest', (): void => {
    let mocker: MockKit;
    let callback: accountSwitchCallback;
    beforeAll((): void => {
      mocker = new MockKit();
    })

    beforeEach((): void => {
    })

    afterEach((): void => {

    })

    afterAll((): void => {
      mocker.clearAll();
    })


    it('test_dispatchKeyEvent', TestConst.TEST_LEVEL, (): void => {
      let keyEvent = {
        keyCode: 2054,
        keyText: 'KEYCODE_ENTER',
        type: KeyType.Down
      } as KeyEvent;
      let getAccount = mocker.mockFunc(Object, AppStorage.get);
      when(getAccount)('accountSwitch').afterReturn('on');
      when(getAccount)('mCurrentUserId').afterReturn(100);
      ScreenLockService.isScreenOn = true;
      accountModel.dispatchKeyEvent(keyEvent, 100);

      when(getAccount)('mCurrentUserId').afterReturn(101);
      accountModel.dispatchKeyEvent(keyEvent, 100);

      ScreenLockService.isScreenOn = false;
      accountModel.dispatchKeyEvent(keyEvent, 100);
      let keyEvent2 = {
        keyCode: 2054,
        keyText: 'KEYCODE_ENTER',
        type: KeyType.Up
      } as KeyEvent;
      ScreenLockService.isScreenOn = true;
      accountModel.dispatchKeyEvent(keyEvent2, 100);
      expect(ScreenLockService.isScreenOn).not().assertNull();
    });

    it('test_dispatchKeyEvent_return_one', 0, (): void => {
      let keyEvent: KeyEvent = {
        type: KeyType.Up,
        keyCode: 0,
        keyText: '',
        keySource: KeySource.Unknown,
        deviceId: 0,
        metaKey: 0,
        timestamp: 0,
        stopPropagation: (): void => {
          throw new Error('Function not implemented.');
        },
        intentionCode: IntentionCode.INTENTION_UNKNOWN
      };
      let userId: number = 1;
      let oldUserId: number | undefined = AppStorage.get('mCurrentUserId');
      accountModel.dispatchKeyEvent(keyEvent, userId);
      keyEvent.type = KeyType.Down;
      keyEvent.keyCode = MultiKeyCode.ENTER;
      accountModel.dispatchKeyEvent(keyEvent, userId);
      keyEvent.keyCode = MultiKeyCode.NUMPAD_ENTER;
      AppStorage.set('accountSwitch', true);
      AppStorage.get('accountSwitch');
      accountModel.dispatchKeyEvent(keyEvent, userId);
      expect(AppStorage.get('accountSwitch')).assertEqual(true);
      AppStorage.set('accountSwitch', false);
      AppStorage.get('accountSwitch');
      AppStorage.set('mCurrentUserId', userId);
      AppStorage.get('mCurrentUserId');
      accountModel.dispatchKeyEvent(keyEvent, userId);
      expect(AppStorage.get('mCurrentUserId')).assertEqual(userId);
      AppStorage.set('mCurrentUserId', 8);
      AppStorage.get('mCurrentUserId');
      accountModel.dispatchKeyEvent(keyEvent, userId);
      keyEvent.keyCode = MultiKeyCode.DPAD_LEFT;
      accountModel.dispatchKeyEvent(keyEvent, userId);
      AppStorage.set('mCurrentUserId', oldUserId);
      AppStorage.get('mCurrentUserId');
      accountModel.dispatchKeyEvent(keyEvent, userId);
    });

    it('test_authUser_return_one', 0, async (): Promise<void> => {
      let result = 0;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(ArrayUtils, ArrayUtils.isEmpty);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      accountModel.authUser(0, 1024, 40000, () => {
        result = 1;
        expect(result).assertEqual(1);
      });
      expect(ArrayUtils.isEmpty(await osAccount.getAccountManager().getActivatedOsAccountLocalIds())).assertEqual(true);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      accountModel.authUser(0, 1024, 40000, () => {
        result = 1;
        expect(result).assertEqual(1);
      });
      mocker.clear(ArrayUtils);
      mocker.clearAll();
    });

    it('test_handlePsdExpire_return_one', 0, async (): Promise<void> => {
      let extraInfoExpire: osAccount.AuthResult = {
        pinValidityPeriod: 0,
      };
      let result: number = 0;
      accountModel.handlePsdExpire(result, extraInfoExpire);
      expect(extraInfoExpire.pinValidityPeriod).assertEqual(0);
      extraInfoExpire.pinValidityPeriod = -1;
      accountModel.handlePsdExpire(result, extraInfoExpire);
      expect(extraInfoExpire.pinValidityPeriod).assertEqual(-1);
      extraInfoExpire.pinValidityPeriod = 5;
      accountModel.handlePsdExpire(result, extraInfoExpire);
      expect(extraInfoExpire.pinValidityPeriod).assertEqual(5);
      result = 6;
      accountModel.handlePsdExpire(result, extraInfoExpire);
    });

    it('test_registerPWDInputer_return_one', 0, async (): Promise<void> => {
      let password: string = '';
      accountModel.registerPWDInputer(password);
      expect(password).not().assertNull();
    });

    it('test_isUserIdValid_return_one', 0, (): void => {
      let userId: number | undefined = undefined;
      let result = accountModel.isUserIdValid(userId);
      expect(result).assertEqual(false);
    });

    it('test_modelInit', TestConst.TEST_LEVEL, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      accountModel.modelInit();
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    });

    it('test_eventListener', TestConst.TEST_LEVEL, (): void => {
      let result = 0;
      accountModel.registerUserSwitchListener('switched', (switchEventData: OsAccountSwitchEventData) => {
        result = 1;
        expect(result).assertEqual(1);
      });
    });


    it('test_eventCancelListener', TestConst.TEST_LEVEL, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      accountModel.unRegisterUserSwitchListener('switching');
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    });

    it('test_accountEventListener', TestConst.TEST_LEVEL, (): void => {
      let result = 0;
      accountModel.accountEventListener(() => {
        result = 1;
        expect(result).assertEqual(1);
      });
    });

    it('test_updateAllUsers', TestConst.TEST_LEVEL, (): void => {
      let result = 0;
      accountModel.updateAllUsers(() => {
        result = 1;
        expect(result).assertEqual(1);
      });
      accountModel.setPageShow(true);
      accountModel.refreshCurrentAccount();
    });

    it('test_transType', TestConst.TEST_LEVEL, (): void => {

      let result = accountModel.transType(0);
      expect(result).assertEqual(osAccount.OsAccountType.ADMIN);

      let result1 = accountModel.transType(1);
      expect(result1).assertEqual(osAccount.OsAccountType.NORMAL);

      let result2 = accountModel.transType(2);
      expect(result2).assertEqual(osAccount.OsAccountType.GUEST);
    });

    it('test_transType', TestConst.TEST_LEVEL, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      accountModel.refreshCurrentAccount();
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    });

    it('test_setPageShow', TestConst.TEST_LEVEL, (): void => {
      accountModel.setPageShow(true);
      expect(accountModel.isPageShow).assertTrue()
    });

    it('test_onUserSwitch', TestConst.TEST_LEVEL, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      accountModel.onUserSwitch(0);
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    });

    it('test_onAccountSwitch', TestConst.TEST_LEVEL, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      accountModel.onAccountSwitch(0, () => {
        callback();
        expect(execute == 'success' ? true : false).not().assertNull();
      });
    });

    it('test_createUserAccount', TestConst.TEST_LEVEL, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      accountModel.createUserAccount('test', osAccount.OsAccountType.NORMAL);
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    });

    it('test_authUser', TestConst.TEST_LEVEL, (): void => {
      let result = 0;
      accountModel.authUser(0, 1024, 40000, () => {
        result = 1;
        expect(result).assertEqual(1);
      });
    });

    it('test_authUser', TestConst.TEST_LEVEL, (): void => {
      let result = 0;
      accountModel.cancelAuth('', Uint8Array.of(0), () => {
        result = 1;
        expect(result).assertEqual(1);
      });
    });

    it('test_cancelAuth_return', TestConst.TEST_LEVEL, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      accountModel.cancelAuth('', Uint8Array.of(0), callback);
      expect(execute == 'success' ? true : false).not().assertNull();
    });

    it('test_getSensorProperty', TestConst.TEST_LEVEL, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      accountModel.getSensorProperty(() => {
        callback();
        expect(execute == 'success' ? true : false).not().assertNull();
      });
    });

    it('test_getSensorProperty', TestConst.TEST_LEVEL, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      accountModel.getSensorProperty(() => {
        callback();
        expect(execute == 'success' ? true : false).not().assertNull();
      });

    });

    it('test_getSensorProperty', TestConst.TEST_LEVEL, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      accountModel.getAuthInfo(AuthType.FACE, () => {
        callback();
        expect(execute == 'success' ? true : false).not().assertNull();
      }, () => {
      });
    });

    it('test_getSensorProperty', TestConst.TEST_LEVEL, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      accountModel.getAuthInfo(AuthType.FACE, () => {
        callback();
        expect(execute == 'success' ? true : false).not().assertNull();
      }, () => {
      });
    });

    it('test_unLoadFaceUnlockEnv', TestConst.TEST_LEVEL, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      accountModel.loadFaceUnlockEnv(() => {
        callback();
        expect(execute == 'success' ? true : false).not().assertNull();
      });
      accountModel.unLoadFaceUnlockEnv(() => {
      });
    });

    it('test_getAuthType', TestConst.TEST_LEVEL, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      accountModel.getAuthType(() => {
        callback();
        expect(execute == 'success' ? true : false).not().assertNull();
      });
      accountModel.getAuthProperty(AuthType.PIN, () => {
      });
    });

    it('test_registerPWDInputer', TestConst.TEST_LEVEL, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      accountModel.unregisterInputer();
      accountModel.unregisterDomainInputer();
      accountModel.registerDomainPWDInputer('123456');
      accountModel.registerPWDInputer('123456').then(() => {
        callback();
        expect(execute == 'success' ? true : false).not().assertNull();
      });
      accountModel.registerPWDInputer('').then(() => {
      });
    });

    it('test_modelFinish', TestConst.TEST_LEVEL, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      accountModel.modelFinish();
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    });

    it('test_handlePsdExpire', TestConst.TEST_LEVEL, (): void => {
      let extraInfoExpire: osAccount.AuthResult = {
        pinValidityPeriod: 0,
      };
      let extraInfoValid: osAccount.AuthResult = {
        pinValidityPeriod: -1,
      };
      let extraInfoAvaliable: osAccount.AuthResult = {
        pinValidityPeriod: 1000,
      };
      accountModel.handlePsdExpire(0, extraInfoExpire);
      accountModel.handlePsdExpire(0, extraInfoValid);
      accountModel.handlePsdExpire(0, extraInfoAvaliable);
      accountModel.handlePsdExpire(100, extraInfoValid);
      expect(extraInfoValid).not().assertNull();
    });

    it('test_getCurrentUserId', TestConst.TEST_LEVEL, (): void => {
      let userId: Number = accountModel.getCurrentUserId();
      expect(userId).assertEqual(100);
    });

    it('test_getForegroundUserId', TestConst.TEST_LEVEL, (): void => {
      let userId: Number = accountModel.getForegroundUserId();
      expect(userId).assertEqual(100);
    });

    it('test_isUserIdValid_false', 0, (): void => {
      let userId: number = 0;
      let password: string = 'res';
      let callback: Callback<number> = ()=>{
        console.log('callback return')
      };
      let result = accountModel.isUserIdValid(userId);
      accountModel.cleanPassword();
      accountModel.unRegisterAccountEventListener();
      accountModel.registerPINSIXInputer(password);
      expect(result).assertEqual(false);
    });

    it('test_isUserIdValid_return', 0, (): void => {
      let userId: number = 1;
      let callback: Callback<void> = ()=>{
        console.log('callback return')
      };
      accountModel.updateCurrentUserId(callback);
      accountModel.clearUserInfo();
      let result = accountModel.isUserIdValid(userId);
      expect(result).assertEqual(false);
    });

    it('test_isChildModule_false', 0, (): void => {
      let result = accountModel.isChildModule();
      accountModel.updateForegroundUserInfo();
      expect(result).assertEqual(false);
    });

    it('test_getUserData_return', 0, (): void => {
      let result = accountModel.getUserData();
      expect(result).assertEqual(undefined);
    });

    it('test_getSwitchMode_return', 0, (): void => {
      let result = accountModel.getSwitchMode();
      expect(result).assertEqual('toMain');
    });

    it('test_userDeactivated_return', 0, (): void => {
      let userid: number = 10;
      let result = accountModel.userDeactivated(userid);
      expect(result).assertEqual(false);
    });

    it('test_userDeactivated_return_one', 0, (): void => {
      let userid: number = 100;
      let result = accountModel.userDeactivated(userid);
      expect(result).not().assertNull();
    });

    it('test_handleAccountSwitchCallback_return', 0, (): void => {
      let switchEventData: OsAccountSwitchEventData = {
        fromAccountId: 0,
        toAccountId: 0
      };
      accountModel.handleAccountSwitchCallback('switching',switchEventData);
      expect(switchEventData).not().assertNull();
    });

    it('test_handleAccountSwitchCallback_return_one', 0, (): void => {
      let switchEventData: OsAccountSwitchEventData = {
        fromAccountId: 0,
        toAccountId: 0
      };
      accountModel.handleAccountSwitchCallback('switched',switchEventData);
      expect(switchEventData).not().assertNull();
    });

    it('test_handleAccountSwitchCallback_return_two', 0, (): void => {
      let switchEventData: OsAccountSwitchEventData = {
        fromAccountId: 10,
        toAccountId: 20
      };
      let typeName: 'switched' | 'switching' = 'switching';
      accountModel.handleAccountSwitchCallback(typeName, switchEventData);
      typeName = 'switched';
      accountModel.handleAccountSwitchCallback(typeName, switchEventData);
      expect(typeName).assertEqual('switched');
    });

    it('test_unRegisterAccountSwitchCallback_return', 0, (): void => {
      let registerType: string = '';
      accountModel.unRegisterAccountSwitchCallback(registerType);
      expect(registerType).not().assertNull();
    });

    it('test_unRegisterAccountSwitchCallback_return_one', 0, (): void => {
      let registerType: string = 'res1';
      accountModel.unRegisterAccountSwitchCallback(registerType);
      expect(registerType).not().assertNull();
    });

    it('test_registerAccountSwitchCallback_return', 0, (): void => {
      let registerType: string = '';
      accountModel.registerAccountSwitchCallback(registerType,callback);
      expect(registerType).not().assertNull();
    });

    it('test_registerAccountSwitchCallback_return_one', 0, (): void => {
      let registerType: string = 'res1';
      accountModel.registerAccountSwitchCallback(registerType,callback);
      expect(registerType).not().assertNull();
    });
  })

}