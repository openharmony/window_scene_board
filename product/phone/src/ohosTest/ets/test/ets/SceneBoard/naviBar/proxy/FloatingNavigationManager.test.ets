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
  FloatingNavigationManager
} from '@ohos/phonebase/src/main/ets/SceneBoard/naviBar/proxy/FloatingNavigationManager';
import { rpc } from '@kit.IPCKit';
import { DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper';
import { DesktopModeEnum, SystemBarChangeType } from '@ohos/launchercommon';
import { SCBScreenSessionManager, ScenePanelState } from '@ohos/windowscene';
import { SCBNaviBarCallBack } from '@ohos/phonebase/src/main/ets/SceneBoard/naviBar/proxy/SCBNaviBarCallBack';

export default function FloatingNavigationManagerTest() {
  describe('FloatingNavigationManagerTest', () => {
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

    it('FloatingNavigationManager_setExchangeBtnStatus_0', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      (floatingNavigationManager as object)['switchStatus'] = false;
      floatingNavigationManager.setExchangeBtnStatus('test');
      expect(floatingNavigationManager.setExchangeBtnStatus('test') === undefined).assertTrue();
    });

    it('FloatingNavigationManager_setExchangeBtnStatus_1', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      (floatingNavigationManager as object)['switchStatus'] = true;
      floatingNavigationManager.setExchangeBtnStatus('test');
      expect(floatingNavigationManager.setExchangeBtnStatus('test') === undefined).assertTrue();
    });

    it('FloatingNavigationManager_getExchangeBtnStatus', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      (floatingNavigationManager as object)['exchangeBtnStatus'] = 'undefined';
      expect(floatingNavigationManager.getExchangeBtnStatus() === 'undefined').assertTrue();
    });

    it('FloatingNavigationManager_setIsHiddenScene_0', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      (floatingNavigationManager as object)['switchStatus'] = false;
      floatingNavigationManager.setIsHiddenScene(false);
      expect(floatingNavigationManager.setIsHiddenScene(false) === undefined).assertTrue();
    });

    it('FloatingNavigationManager_setIsHiddenScene_1', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      (floatingNavigationManager as object)['switchStatus'] = true;
      floatingNavigationManager.setIsHiddenScene(true);
      expect(floatingNavigationManager.setIsHiddenScene(true) === undefined).assertTrue();
    });

    it('FloatingNavigationManager_setDesktopMode', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager.setDesktopMode(DesktopModeEnum.BASE_MODE);
      expect(floatingNavigationManager.setDesktopMode(DesktopModeEnum.BASE_MODE) === undefined).assertTrue();
    });

    it('FloatingNavigationManager_registersSwitchChangeCallBack', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager.registersSwitchChangeCallBack(() => {});
      expect(floatingNavigationManager.registersSwitchChangeCallBack(() => {}) === undefined).assertTrue();
    });

    it('FloatingNavigationManager_unregistersSwitchChangeCallBack', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager.unregistersSwitchChangeCallBack();
      expect(floatingNavigationManager.unregistersSwitchChangeCallBack() === undefined).assertTrue();
    });

    it('FloatingNavigationManager_isFloNavNeedShow', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      (floatingNavigationManager as object)['isFloNavNeedShow']();
      expect((floatingNavigationManager as object)['isFloNavNeedShow']() !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setShowVerifyImmersiveState', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      (floatingNavigationManager as object)['isGestureEnable'] = true;
      floatingNavigationManager.setShowVerifyImmersiveState();
      expect((floatingNavigationManager as object)['isFloNavNeedShow']() !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_sendFloatingNavIsInApp_1', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager.registersSwitchChangeCallBack(() => {});
      floatingNavigationManager.setSwitchStatus(false);
      (floatingNavigationManager as object)['proxy'] = undefined;
      (floatingNavigationManager as object)['sendFloatingNavIsInApp'](true);
      expect((floatingNavigationManager as object)['sendFloatingNavIsInApp'](true) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_sendFloatingNavIsInApp_2', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager.registersSwitchChangeCallBack(() => {});
      floatingNavigationManager.setSwitchStatus(true);
      (floatingNavigationManager as object)['proxy'] = undefined;
      (floatingNavigationManager as object)['sendFloatingNavIsInApp'](true);
      expect((floatingNavigationManager as object)['sendFloatingNavIsInApp'](true) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_sendFloatingNavIsInApp_3', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager.registersSwitchChangeCallBack(() => {});
      floatingNavigationManager.setSwitchStatus(true);
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      (floatingNavigationManager as object)['proxy'] = proxy;
      (floatingNavigationManager as object)['sendFloatingNavIsInApp'](false);
      expect((floatingNavigationManager as object)['sendFloatingNavIsInApp'](false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_sendFloatingNavLockStatus_1', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager.registersSwitchChangeCallBack(() => {});
      floatingNavigationManager.setSwitchStatus(false);
      (floatingNavigationManager as object)['proxy'] = undefined;
      (floatingNavigationManager as object)['sendFloatingNavLockStatus']();
      expect((floatingNavigationManager as object)['sendFloatingNavLockStatus']() !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_sendFloatingNavLockStatus_2', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager.registersSwitchChangeCallBack(() => {});
      floatingNavigationManager.setSwitchStatus(true);
      (floatingNavigationManager as object)['proxy'] = undefined;
      (floatingNavigationManager as object)['sendFloatingNavLockStatus'](true);
      expect((floatingNavigationManager as object)['sendFloatingNavLockStatus']() !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_sendFloatingNavLockStatus_3', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager.registersSwitchChangeCallBack(() => {});
      floatingNavigationManager.setSwitchStatus(true);
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      (floatingNavigationManager as object)['proxy'] = proxy;
      (floatingNavigationManager as object)['sendFloatingNavLockStatus'](false);
      expect((floatingNavigationManager as object)['sendFloatingNavLockStatus']() !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_isInAppStatus', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      (floatingNavigationManager as object)['isInMultiWindowMode'] = true;
      expect((floatingNavigationManager as object)['isInAppStatus']() === true).assertTrue();
    });

    it('FloatingNavigationManager_setIsInMultiWindowMode', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      expect(floatingNavigationManager.setIsInMultiWindowMode(true) === undefined).assertTrue();
    });

    it('FloatingNavigationManager_setWallpaperDegree', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      expect(floatingNavigationManager.setWallpaperDegree(1) === undefined).assertTrue();
    });

    it('FloatingNavigationManager_setIsScreenLock', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      expect(floatingNavigationManager.setIsScreenLock(true) === undefined).assertTrue();
    });

    it('FloatingNavigationManager_connectFloatingNavAbility_1', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager.registersSwitchChangeCallBack(() => {});
      floatingNavigationManager.setSwitchStatus(false);
      floatingNavigationManager.connectFloatingNavAbility();
      expect(floatingNavigationManager.connectFloatingNavAbility() === undefined).assertTrue();
    });

    it('FloatingNavigationManager_connectFloatingNavAbility_2', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager.registersSwitchChangeCallBack(() => {});
      floatingNavigationManager.setSwitchStatus(true);
      (floatingNavigationManager as object)['proxy'] = undefined;
      expect(floatingNavigationManager.connectFloatingNavAbility() === undefined).assertTrue();
    });

    it('FloatingNavigationManager_connectFloatingNavAbility_3', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager.registersSwitchChangeCallBack(() => {});
      floatingNavigationManager.setSwitchStatus(true);
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      floatingNavigationManager['isConnecting'] = true;
      expect(floatingNavigationManager.connectFloatingNavAbility() === undefined).assertTrue();
    });

    it('FloatingNavigationManager_connectFloatingNavAbility_4', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager.registersSwitchChangeCallBack(() => {});
      floatingNavigationManager.setSwitchStatus(true);
      (floatingNavigationManager as object)['proxy'] = undefined;
      floatingNavigationManager['isConnecting'] = false;
      floatingNavigationManager['isGestureEnable'] = false;
      expect(floatingNavigationManager.connectFloatingNavAbility() === undefined).assertTrue();
    });

    it('FloatingNavigationManager_connectFloatingNavAbility_5', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager.registersSwitchChangeCallBack(() => {});
      floatingNavigationManager.setSwitchStatus(true);
      (floatingNavigationManager as object)['proxy'] = undefined;
      floatingNavigationManager['isConnecting'] = false;
      floatingNavigationManager['isGestureEnable'] = true;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(GlobalContext, GlobalContext.getContext().connectServiceExtensionAbility);
      when(mockFunc)(ArgumentMatchers.any).afterThrow('err');
      expect(floatingNavigationManager.connectFloatingNavAbility() === undefined).assertTrue();
      mocker.ignoreMock(GlobalContext, GlobalContext.getContext().connectServiceExtensionAbility);
    });

    it('FloatingNavigationManager_connectFloatingNavAbility_6', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager.registersSwitchChangeCallBack(() => {});
      floatingNavigationManager.setSwitchStatus(true);
      (floatingNavigationManager as object)['proxy'] = undefined;
      floatingNavigationManager['isConnecting'] = false;
      floatingNavigationManager['isGestureEnable'] = true;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(GlobalContext, GlobalContext.getContext().connectServiceExtensionAbility);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(1);
      expect(floatingNavigationManager.connectFloatingNavAbility() === undefined).assertTrue();
      mocker.ignoreMock(GlobalContext, GlobalContext.getContext().connectServiceExtensionAbility);
    });

    it('FloatingNavigationManager_reConnectFloatingNavAbility_1', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager.registersSwitchChangeCallBack(() => {});
      floatingNavigationManager.setSwitchStatus(false);
      expect(floatingNavigationManager['reConnectFloatingNavAbility']() === undefined).assertTrue();
    });

    it('FloatingNavigationManager_reConnectFloatingNavAbility_2', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager.registersSwitchChangeCallBack(() => {});
      floatingNavigationManager.setSwitchStatus(true);
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.EMERGENCY_MODE;
      expect(floatingNavigationManager['reConnectFloatingNavAbility']() === undefined).assertTrue();
    });

    it('FloatingNavigationManager_reConnectFloatingNavAbility_3', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager.registersSwitchChangeCallBack(() => {});
      floatingNavigationManager.setSwitchStatus(true);
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      floatingNavigationManager['retryCount'] = 20;
      expect(floatingNavigationManager['reConnectFloatingNavAbility']() === undefined).assertTrue();
    });

    it('FloatingNavigationManager_reConnectFloatingNavAbility_4', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager.registersSwitchChangeCallBack(() => {});
      floatingNavigationManager.setSwitchStatus(true);
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      floatingNavigationManager['retryCount'] = 1;
      expect(floatingNavigationManager['reConnectFloatingNavAbility']() === undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavStatus_1', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager.registersSwitchChangeCallBack(() => {});
      floatingNavigationManager.setSwitchStatus(false);
      expect(floatingNavigationManager.setFloatingNavStatus(true, true) === undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavStatus_2', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager.registersSwitchChangeCallBack(() => {});
      floatingNavigationManager.setSwitchStatus(true);
      expect(floatingNavigationManager.setFloatingNavStatus(true, true) === undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavStatus_3', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager.registersSwitchChangeCallBack(() => {});
      floatingNavigationManager.setSwitchStatus(true);
      floatingNavigationManager['isHiddenScene'] = false;
      expect(floatingNavigationManager.setFloatingNavStatus(true, true) === undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavStatus_4', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager.registersSwitchChangeCallBack(() => {});
      floatingNavigationManager.setSwitchStatus(true);
      expect(floatingNavigationManager.setFloatingNavStatus(false, false) === undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_1', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      (floatingNavigationManager as object)['proxy'] = undefined;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](true, true) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_2', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(false);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](true, true) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_3', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](true, true) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_4', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_5', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_6', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_7', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_8', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_9', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_10', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_11', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_12', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_13', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_14', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_15', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_16', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_17', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_18', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_19', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_20', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_21', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_22', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_23', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_24', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_25', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_26', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_27', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_28', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_29', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_30', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_31', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_32', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_33', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_34', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_35', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_36', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_37', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_38', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_39', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_40', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_41', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_setFloatingNavVisibleOrHidden_42', 0, async () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack('');
      floatingNavigationManager['proxy'] = proxy;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockFunc1)().afterReturn(true);
      floatingNavigationManager['isScreenLock'] = false;
      floatingNavigationManager['desktopMode'] = DesktopModeEnum.BASE_MODE;
      expect(floatingNavigationManager['setFloatingNavVisibleOrHidden'](false, false) !== undefined).assertTrue();
    });

    it('FloatingNavigationManager_checkShowFloatingNavigation_1', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager['switchStatus'] = false;
      expect(floatingNavigationManager.checkShowFloatingNavigation(false) === undefined).assertTrue();
    });

    it('FloatingNavigationManager_checkShowFloatingNavigation_2', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager['switchStatus'] = true;
      floatingNavigationManager['isShowFloatingNav'] = true;
      floatingNavigationManager['isTimerRunning'] = false;
      expect(floatingNavigationManager.checkShowFloatingNavigation(false) === undefined).assertTrue();
    });

    it('FloatingNavigationManager_checkShowFloatingNavigation_3', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager['switchStatus'] = true;
      floatingNavigationManager['isShowFloatingNav'] = true;
      floatingNavigationManager['isTimerRunning'] = true;
      expect(floatingNavigationManager.checkShowFloatingNavigation(false) === undefined).assertTrue();
    });

    it('FloatingNavigationManager_checkShowFloatingNavigation_4', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager['switchStatus'] = true;
      floatingNavigationManager['isShowFloatingNav'] = false;
      floatingNavigationManager['isTimerRunning'] = true;
      expect(floatingNavigationManager.checkShowFloatingNavigation(false) === undefined).assertTrue();
    });

    it('FloatingNavigationManager_checkShowFloatingNavigation_5', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager['switchStatus'] = true;
      floatingNavigationManager['isTimerRunning'] = true;
      expect(floatingNavigationManager.checkShowFloatingNavigation(true) === undefined).assertTrue();
    });

    it('FloatingNavigationManager_checkShowFloatingNavigation_6', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager['switchStatus'] = true;
      floatingNavigationManager['isTimerRunning'] = false;
      floatingNavigationManager['isShowFloatingNav'] = true;
      expect(floatingNavigationManager.checkShowFloatingNavigation(true) === undefined).assertTrue();
    });

    it('FloatingNavigationManager_slideShowFloatingNavigation_1', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager['switchStatus'] = false;
      expect(floatingNavigationManager.slideShowFloatingNavigation() === undefined).assertTrue();
    });

    it('FloatingNavigationManager_slideShowFloatingNavigation_2', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager['switchStatus'] = true;
      expect(floatingNavigationManager.slideShowFloatingNavigation() === undefined).assertTrue();
    });

    it('FloatingNavigationManager_notifyFloatingNavImmerseStatus_1', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager['isShowFloatingNav'] = false;
      expect(floatingNavigationManager.notifyFloatingNavImmerseStatus(4) === undefined).assertTrue();
    });

    it('FloatingNavigationManager_notifyFloatingNavImmerseStatus_2', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager['isShowFloatingNav'] = true;
      expect(floatingNavigationManager.notifyFloatingNavImmerseStatus(4) === undefined).assertTrue();
    });

    it('FloatingNavigationManager_notifyFloatingNavImmerseStatus_3', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager['isShowFloatingNav'] = true;
      expect(floatingNavigationManager.notifyFloatingNavImmerseStatus(1) === undefined).assertTrue();
    });

    it('FloatingNavigationManager_setScenePanelState_1', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      expect(floatingNavigationManager.setScenePanelState(ScenePanelState.RECENT) === undefined).assertTrue();
    });

    it('FloatingNavigationManager_setScenePanelState_2', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      expect(floatingNavigationManager.setScenePanelState(ScenePanelState.HOME) === undefined).assertTrue();
    });

    it('FloatingNavigationManager_setIsGestureEnable_1', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager['isGestureEnable'] = true;
      expect(floatingNavigationManager.setIsGestureEnable(true, "") === undefined).assertTrue();
    });

    it('FloatingNavigationManager_setIsGestureEnable_2', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager['isGestureEnable'] = false;
      floatingNavigationManager['isGestureEnable'] = true;
      expect(floatingNavigationManager.setIsGestureEnable(true, "") === undefined).assertTrue();
    });

    it('FloatingNavigationManager_setIsGestureEnable_3', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager['isGestureEnable'] = false;
      floatingNavigationManager['isGestureEnable'] = false;
      expect(floatingNavigationManager.setIsGestureEnable(true, "") === undefined).assertTrue();
    });

    it('FloatingNavigationManager_setIsGestureEnable_4', 0, () => {
      let floatingNavigationManager = new FloatingNavigationManager();
      floatingNavigationManager['isGestureEnable'] = true;
      expect(floatingNavigationManager.setIsGestureEnable(false, "") === undefined).assertTrue();
    });
  });
}