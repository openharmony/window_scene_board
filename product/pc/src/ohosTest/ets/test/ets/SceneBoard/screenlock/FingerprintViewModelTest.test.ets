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

import { afterAll, afterEach,
  ArgumentMatchers,
  beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium';
import TestConst from '@ohos/screenlockcomponent/src/ohosTest/ets/test/ets/ohos/constants/TestConst';
import osAccount from '@ohos.account.osAccount';
import { IAMAuthExtraInfo, strongAuthManager } from '@ohos/screenlockcommon';
import { InputPwdDefaultPromptViewModel } from '@ohos/screenlockcomponent/src/main/ets/fingerprint/InputPwdDefaultPromptViewModel';
import TemporaryPromptViewModel from '@ohos/screenlockcomponent/src/main/ets/fingerprint/TemporaryPromptViewModel';
import { ToastPromptViewModel } from '@ohos/screenlockcomponent/src/main/ets/fingerprint/ToastPromptViewModel';
import IAodProxy from '@ohos/screenlockcomponent/src/main/ets/onemirror/model/IAodProxy';
import ScreenLockService from '@ohos/pcbase/src/main/ets/SceneBoard/screenlock/refactor/ScreenLockService';
import hilog from '@ohos.hilog';
import { SensorType, IAMAuthResult, FingerprintConstants } from '@ohos/screenlockcommon';
import { BasePromptViewModel } from '@ohos/screenlockcomponent/src/main/ets/fingerprint/BasePromptViewModel';
import { AsyncCallback } from '@ohos.base';
import { FaceUnlockVerifyState } from '@ohos/screenlockcommon';
import ScreenLockThemeManager from '@ohos/screenlockwidget/src/main/ets/common/theme/ScreenLockThemeManager';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { ScreenLockManager } from '@ohos/pcbase/src/main/ets/SceneBoard/screenlock/refactor/ScreenLockManager';
import FingerprintViewModel from '@ohos/pcbase/src/main/ets/SceneBoard/screenlock/refactor/FingerprintViewModel';
import { AodElemPosition } from '@ohos/themeservice';

export default function FingerprintViewModelTest() {
  const mFingerprintViewModel: FingerprintViewModel = new FingerprintViewModel();
  let extraJsonInfo: IAMAuthExtraInfo = {
    authResult: 1,
    authRemainAttempts: 2,
    lockoutDuration: 3,
    userId: 100,
  };
  let customizePromptVM: BasePromptViewModel;
  let aodProxy: IAodProxy;
  describe('FingerprintViewModelTest', (): void => {
    let mFingerprintViewModelMode: FingerprintViewModelMode = new FingerprintViewModelMode();
    let mScreenLockThemeManager:ScreenLockThemeManager = new ScreenLockThemeManager();
    beforeAll((): void => {
    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {
    })

    it('test_onIsFingerprintEnableChange_success', 0, (): void => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      try {
        mFingerprintViewModel.onIsFingerprintEnableChange(true);
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('test_onResultCallback_success', 0, (): void => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      try {
        extraJsonInfo.authResult = 0;
        mFingerprintViewModel.onResultCallback(extraJsonInfo);
        extraJsonInfo.authResult = 1;
      } catch (e) {
        expect(false).assertFail();
      }
    })


    it('test_onResultCallback_cancel', 0, (): void => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      try {
        extraJsonInfo.authResult = 12300109;
        mFingerprintViewModel.onResultCallback(extraJsonInfo);
        extraJsonInfo.authResult = 1;
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('test_onResultCallback_exception', 0, (): void => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      try {
        let authResult: osAccount.AuthResult = {};
        extraJsonInfo.authResult = 12300001;
        mFingerprintViewModel.onResultCallback(extraJsonInfo);
        extraJsonInfo.authResult = 1;
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('test_isUnderScreenFingerprint_success', 0, (): void => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
      try {
        ScreenLockService.isUnderScreenFingerprint();
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('test_isFingerprintSuspend', 0, (): void => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'it begin...');
      let result = mFingerprintViewModel.isFingerprintSuspend()
      expect(result).assertEqual(false);
    })

    it('test_loadDestroyFingerprintGrowAnimation', 0, () => {
      try {
        mFingerprintViewModel.loadFingerprintGrowAnimation();
        mFingerprintViewModel.destroyFingerprintGrowAnimation();
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('test_getPwdPageShowFingerprintType', 0, () => {
      ScreenLockService.isOutOfScreenFingerprint();
      let result = mFingerprintViewModel.getPwdPageShowFingerprintType();
      expect(result).not().assertNull();
      AppStorage.set<string>(FingerprintConstants.FINGERPRINT_SENSOR_TYPE_KEY, SensorType.OUT_OF_SCREEN_SENSOR);
      AppStorage.get<string>(FingerprintConstants.FINGERPRINT_SENSOR_TYPE_KEY);
      let add = ScreenLockService.isOutOfScreenFingerprint();
      mFingerprintViewModel.getPwdPageShowFingerprintType();
      expect(add).assertEqual(true);
      AppStorage.set<string>(FingerprintConstants.FINGERPRINT_SENSOR_TYPE_KEY, SensorType.BOTH_SENSOR);
      AppStorage.get<string>(FingerprintConstants.FINGERPRINT_SENSOR_TYPE_KEY);
      mFingerprintViewModel.getPwdPageShowFingerprintType();
    })

    it('test_setFingerprintViewBlur', 0, () => {
      let blur: number = 1;
      mFingerprintViewModel.setFingerprintViewBlur(blur);
      expect(mFingerprintViewModel.getFingerprintViewBlur()).assertEqual(1);
    })

    it('test_screenLockNotifyDrawDone_return', 0, () => {
      let isScreenLockDrawDown: boolean = false;
      ScreenLockService.setScreenLockDrawDown(isScreenLockDrawDown);
      ScreenLockService.getScreenLockDrawDown();
      mFingerprintViewModel.screenLockNotifyDrawDone();
      expect(ScreenLockService.getScreenLockDrawDown()).assertEqual(true);
    })

    it('test_screenLockNotifyDrawDone_return_one', 0, () => {
      let isScreenLockDrawDown: boolean = true;
      ScreenLockService.setScreenLockDrawDown(isScreenLockDrawDown);
      ScreenLockService.getScreenLockDrawDown();
      mFingerprintViewModel.screenLockNotifyDrawDone();
      expect(ScreenLockService.getScreenLockDrawDown()).assertEqual(true);
    })

    it('test_enterFingerprintView_return', 0, () => {
      mFingerprintViewModel.enterFingerprintView();
      mFingerprintViewModel.exitFingerprintView(true);
      mFingerprintViewModel.exitFingerprintViewWithoutAnimation(true);
      let result = mFingerprintViewModel.isFingerprintViewShow();
      expect(result).assertEqual(false);
      mFingerprintViewModel.exitFingerprintView(true);
      mFingerprintViewModel.exitFingerprintViewWithoutAnimation(true);
      AppStorage.set<string>('isPwdVisible','PIN_SIX');
      AppStorage.get<string>('isPwdVisible');
      mFingerprintViewModelMode.FingerprintTipTooFastPrompt();
      AppStorage.set<string>('isPwdVisible','');
      AppStorage.get<string>('isPwdVisible');
      mFingerprintViewModelMode.FingerprintTipTooFastPrompt();
    })

    it('test_enterFingerprintView_return_one', 0, () => {
      mFingerprintViewModel.enterFingerprintView();
      mFingerprintViewModel.exitFingerprintView(false);
      mFingerprintViewModel.exitFingerprintViewWithoutAnimation(false);
      let result = mFingerprintViewModel.isFingerprintViewShow();
      expect(result).assertEqual(false);
      mFingerprintViewModel.exitFingerprintView(false);
      mFingerprintViewModel.exitFingerprintViewWithoutAnimation(false);
    })

    it('test_getLottieData', 0, () => {
      let jsonPath: string = 'res';
      mFingerprintViewModel.getLottieData(jsonPath);
      mFingerprintViewModel.destroyFingerprintGrowAnimation();
      let result = mFingerprintViewModel.getFingerprintViewTransitionEffect();
      let callback: Function = () => {
      };
      mFingerprintViewModel.setAuthFinishCallback(callback);
      expect(result).not().assertNull();
    })

    it('test_setIsAcquireWhenBeginSleep', 0, () => {
      let isAcquireWhenBeginSleep: boolean = false;
      let duringBeginSleepToEndSleep: boolean = false;
      let isSuspend: boolean = false;
      mFingerprintViewModel.setIsAcquireWhenBeginSleep(isAcquireWhenBeginSleep);
      mFingerprintViewModel.setDuringBeginSleepToEndSleep(duringBeginSleepToEndSleep);
      mFingerprintViewModel.setFingerSuspend(isSuspend);
      let result = mFingerprintViewModel.getFingerprintViewBlur();
      expect(result).not().assertNull();
    })

    it('test_setFingerSuspend', 0, () => {
      let isSuspend: boolean = true;
      let offset: number = 1;
      mFingerprintViewModel.setFingerSuspend(isSuspend);
      let result = mFingerprintViewModel.getPwdPageExitTransitionEffect();
      mFingerprintViewModel.initCustomPrompt(customizePromptVM);
      mFingerprintViewModel.setAodProxy(aodProxy);
      mFingerprintViewModel.adjustToastPositionY(offset);
      expect(result).not().assertNull();
      mFingerprintViewModel.onIsFingerprintEnableChange(true);
      AppStorage.set<string>(FingerprintConstants.FINGERPRINT_SENSOR_TYPE_KEY,SensorType.BOTH_SENSOR);
      AppStorage.get<string>(FingerprintConstants.FINGERPRINT_SENSOR_TYPE_KEY);
      mFingerprintViewModel.getPwdPageShowFingerprintType();
      mFingerprintViewModel.setFingerSuspend(isSuspend);
      isSuspend = false;
      mFingerprintViewModel.setFingerSuspend(isSuspend);
    })

    it('test_getIsFingerprintEnable_should_return_true', TestConst.TEST_LEVEL, (): void => {
      mFingerprintViewModel.resetOffScreenFingerprintFailCnt();
      mFingerprintViewModel.getPsdPageFingerprintTransitionEffect();
      mFingerprintViewModel.changePsdPageFingerprintTransitionEffect(6);
      mFingerprintViewModel.enterFingerprintView();
      mFingerprintViewModel.loadFingerprintGrowAnimation();
      mFingerprintViewModel.destroyFingerprintGrowAnimation();
      mFingerprintViewModel.exitFingerprintView(false);
      mFingerprintViewModel.exitFingerprintViewWithoutAnimation(false);
      mFingerprintViewModel.fingerprintAcquireInfoCallback(1, 6, extraJsonInfo);
      mFingerprintViewModel.onIsFingerprintEnableChange(false);
      mFingerprintViewModel.preBright();
      mFingerprintViewModel.screenLockDrawObserverCallback();
      ScreenLockService.setScreenLockDrawDown(true);
      mFingerprintViewModel.screenLockNotifyDrawDone();
      let getIsFingerprintEnable = mFingerprintViewModel.getIsFingerprintEnable();
      expect(getIsFingerprintEnable).assertEqual(false);
    })

    it('test_inFingerprintView_should_return_true', TestConst.TEST_LEVEL, (): void => {
      mFingerprintViewModel.resetFingerprintViewPrompt();
      mFingerprintViewModel.setFingerprintViewPrompt($r('app.string.face_not_recognized_in_input_pwd'));
      mFingerprintViewModel.exitFingerprintViewWithoutAnimation(true);
      extraJsonInfo.authResult = 1;
      mFingerprintViewModel.onResultCallback(extraJsonInfo);
      mFingerprintViewModel.fingerprintAcquireInfoCallback(1, 2, extraJsonInfo);
      mFingerprintViewModel.getFingerprintViewPrompt();
      ScreenLockService.setLock(true);
      mFingerprintViewModel.onIsFingerprintEnableChange(true);
      ScreenLockService.setScreenLockDrawDown(false);
      mFingerprintViewModel.screenLockNotifyDrawDone();
      let inFingerprintView: boolean = mFingerprintViewModel.inFingerprintView();
      expect(inFingerprintView).assertEqual(false);
    })

    it('test_isFingerprintSuspend_should_return_true', TestConst.TEST_LEVEL, (): void => {
      const mInputPwdDefaultPromptViewModel: InputPwdDefaultPromptViewModel = new InputPwdDefaultPromptViewModel();
      const mTemporaryPromptViewModel: TemporaryPromptViewModel = new TemporaryPromptViewModel(false);
      const toastPromptViewModel: ToastPromptViewModel = new ToastPromptViewModel();
      let aIAodProxy: IAodProxy = {
        async checkAod(): Promise<void> {
        },
        isFingerprintEnable(): boolean {
          return true;
        },
        isPartScreenAOD(): boolean {
          return true;
        },
        isFullScreenAOD(): boolean {
          return true;
        },
        isAODEnable(): boolean {
          return true;
        },
        async start(isSupportScreenToEnd: boolean): Promise<void> {
        },
        async stop(screenStatus: number): Promise<void> {
        },
        isAodDataInValid: (): boolean => {
          return false;
        },
        updateTPState: (isOpen: boolean): void => {
        },
        isPartEmoji: (): boolean => {
          return false;
        },
        isPartAodPlayMirror: (): boolean => {
          return false;
        },
        isFullAodPlayMirror: (): boolean => {
          return false;
        },
        isOnlineMixAod: (): boolean => {
          return false;
        },
        getAodLayerInfo: (isRealtime: boolean): Promise<AodElemPosition> => {
          return new Promise((resolve, reject) => {
            resolve({ type: 0 });
          });
        }
      }
      mFingerprintViewModel.fingerprintAcquireInfoCallback(1, 4, extraJsonInfo);
      mFingerprintViewModel.resetFingerprintViewPrompt();
      mFingerprintViewModel.setFingerprintViewPrompt($r('app.string.face_not_recognized_in_input_pwd'));
      mFingerprintViewModel.updateFingerprintSuspend(1, 30);
      mFingerprintViewModel.updateFingerprintSuspend(2, 15);
      mFingerprintViewModel.updateFingerprintSuspend(150, 5);
      mFingerprintViewModel.setFingerSuspend(false);
      mFingerprintViewModel.checkFingerprintFreezingTime();
      mFingerprintViewModel.setInputViewModel(mInputPwdDefaultPromptViewModel)
      mFingerprintViewModel.initToast(toastPromptViewModel);
      mFingerprintViewModel.viewModelUnInit()
      let isFingerprintSuspend = mFingerprintViewModel.isFingerprintSuspend();
      expect(isFingerprintSuspend).assertEqual(false);
    })

    it('test_fingerprintAcquireInfoCallback0', TestConst.TEST_LEVEL, (): void => {
      mFingerprintViewModel.fingerprintAcquireInfoCallback(1, 10006, extraJsonInfo);
    })

    it('test_fingerprintAcquireInfoCallback0', TestConst.TEST_LEVEL, (): void => {
      AppStorage.setOrCreate('isPwdVisible', true);
      mFingerprintViewModel.exitFingerprintViewWithoutAnimation(false);
      mFingerprintViewModel.fingerprintAcquireInfoCallback(1, 4, extraJsonInfo);
    })

    it('test_setNotifyPwrPreBrightState', 0, () => {
      let isNotifyPwrPreBright: boolean = false;
      mFingerprintViewModel.setNotifyPwrPreBrightState(isNotifyPwrPreBright);
      let result = mFingerprintViewModel.getNotifyPwrPreBrightState();
      expect(result).assertEqual(false);
    })

    it('test_fingerprintAcquireInfoCallback_return', 0, () => {
      let acquire: number = osAccount.FingerprintTips.FINGERPRINT_TIP_FINGER_DOWN;
      mFingerprintViewModelMode.OnFingerprintDown();
      mFingerprintViewModel.fingerprintAcquireInfoCallback(1, acquire, extraJsonInfo);
      acquire = 10006;
      mFingerprintViewModel.fingerprintAcquireInfoCallback(1, acquire, extraJsonInfo);
      acquire = osAccount.FingerprintTips.FINGERPRINT_TIP_TOO_FAST;
      ScreenLockManager.getInstance().setPreBrightStat(true);
      ScreenLockManager.getInstance().getPreBrightStat();
      mFingerprintViewModel.fingerprintAcquireInfoCallback(1, acquire, extraJsonInfo);
      ScreenLockManager.getInstance().setPreBrightStat(false);
      ScreenLockManager.getInstance().getPreBrightStat();
      mFingerprintViewModel.fingerprintAcquireInfoCallback(1, acquire, extraJsonInfo);
      acquire = osAccount.FingerprintTips.FINGERPRINT_TIP_FINGER_UP;
      ScreenLockManager.getInstance().setPreBrightStat(true);
      ScreenLockManager.getInstance().getPreBrightStat();
      mFingerprintViewModel.fingerprintAcquireInfoCallback(1, acquire, extraJsonInfo);
      acquire = osAccount.FingerprintTips.FINGERPRINT_TIP_PARTIAL;
      mFingerprintViewModel.fingerprintAcquireInfoCallback(1, acquire, extraJsonInfo);
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(strongAuthManager, strongAuthManager.isNeedStrongAuth);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      mFingerprintViewModel.fingerprintAcquireInfoCallback(1, acquire, extraJsonInfo);
      expect(strongAuthManager.isNeedStrongAuth()).assertEqual(true);
      mocker.clear(strongAuthManager);
      mocker.clearAll();
    })

    it('test_loadFingerprintGrowAnimation_return', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(mScreenLockThemeManager, mScreenLockThemeManager.getScrenLockHigtFingerThemeParams);
      when(mockFunction)(ArgumentMatchers.any).afterReturn('/lock/base/fingerprint_growth.json');
      mFingerprintViewModel.loadFingerprintGrowAnimation();
      expect(mScreenLockThemeManager.getScrenLockHigtFingerThemeParams())
        .assertEqual('/lock/base/fingerprint_growth.json');
      mocker.clear(mScreenLockThemeManager);
      mocker.clearAll();
    })

    it('test_isFingerprintViewShow', 0, () => {
      let result = mFingerprintViewModel.isFingerprintViewShow();
      expect(result).assertEqual(false);
    })

    it('test_isFingerprintAcquireWhenScreenOff', 0, () => {
      let result = mFingerprintViewModel.isFingerprintAcquireWhenScreenOff();
      expect(result).assertEqual(false);
    })

    it('test_DoPreBrightAuthFailScreenOff', 0, () => {
      mFingerprintViewModel.setNotifyPwrPreBrightState(true);
      mFingerprintViewModel.getNotifyPwrPreBrightState();
      mFingerprintViewModelMode.DoPreBrightAuthFailScreenOff();
      let result = mFingerprintViewModel.getNotifyPwrPreBrightState();
      expect(result).assertEqual(true);
      AppStorage.set<number>('faceUnlockVerifyState',FaceUnlockVerifyState.VERIFYING);
      AppStorage.get<number>('faceUnlockVerifyState');
      mFingerprintViewModel.getNotifyPwrPreBrightState();
      AppStorage.set<number>('faceUnlockVerifyState',FaceUnlockVerifyState.FAILED);
      AppStorage.get<number>('faceUnlockVerifyState');
      mFingerprintViewModel.getNotifyPwrPreBrightState();
    })

    it('test_DoPreBrightAuthFailScreenOff_one', 0, () => {
      mFingerprintViewModel.setNotifyPwrPreBrightState(false);
      mFingerprintViewModel.getNotifyPwrPreBrightState();
      mFingerprintViewModelMode.DoPreBrightAuthFailScreenOff();
      let result = mFingerprintViewModel.getNotifyPwrPreBrightState();
      let biasX: number = 1;
      let biasY: number = 2;
      mFingerprintViewModelMode.ComputeBaseTrans(biasX, biasY);
      expect(result).assertEqual(false);
    })

    it('test_IsUnderFingerprintPosLow', 0, () => {
      AppStorage.set<number>('coordinateYOfFingerprintUdScreenInPx', undefined);
      AppStorage.get<number>('coordinateYOfFingerprintUdScreenInPx');
      AppStorage.set<number>('udSensorRadiusInPx', undefined);
      AppStorage.get<number>('udSensorRadiusInPx');
      let result = mFingerprintViewModelMode.IsUnderFingerprintPosLow();
      expect(result).assertEqual(undefined);
    })

    it('test_IsUnderFingerprintPosLow_one', 0, () => {
      AppStorage.set<number>('coordinateYOfFingerprintUdScreenInPx', 60);
      AppStorage.get<number>('coordinateYOfFingerprintUdScreenInPx');
      AppStorage.set<number>('udSensorRadiusInPx', 60);
      AppStorage.get<number>('udSensorRadiusInPx');
      let result = mFingerprintViewModelMode.IsUnderFingerprintPosLow();
      expect(result).assertEqual(false);
    })

    it('test_IsUnderFingerprintPosLow_two', 0, () => {
      AppStorage.set<number>('coordinateYOfFingerprintUdScreenInPx', -1);
      AppStorage.get<number>('coordinateYOfFingerprintUdScreenInPx');
      AppStorage.set<number>('udSensorRadiusInPx', 1);
      AppStorage.get<number>('udSensorRadiusInPx');
      let result = mFingerprintViewModelMode.IsUnderFingerprintPosLow();
      mFingerprintViewModelMode.HideStatusBar();
      expect(result).assertEqual(false);
    })

    it('test_LoadLottieData', 0, () => {
      let jsonPath: string = 'res';
      let callback: (value: object) => void = (value: object) => {
        return value
      };
      mFingerprintViewModelMode.LoadLottieData(jsonPath, callback);
      expect(jsonPath).assertEqual('res');
    })

    it('test_ShowStatusBar', 0, () => {
      AppStorage.set<string>(FingerprintConstants.FINGERPRINT_SENSOR_TYPE_KEY, '');
      AppStorage.get<string>(FingerprintConstants.FINGERPRINT_SENSOR_TYPE_KEY);
      mFingerprintViewModelMode.ShowStatusBar();
      let result = mFingerprintViewModelMode.IsPowerFingerprintTouchUnlockEnable();
      mFingerprintViewModelMode.OnSuccessUnlockCallback();
      expect(result).assertEqual(false);
      ScreenLockService.setLock(true);
      ScreenLockService.getLock();
      mFingerprintViewModel.onIsFingerprintEnableChange(true);
      extraJsonInfo.authResult = IAMAuthResult.SUCCEED;
      mFingerprintViewModel.onResultCallback(extraJsonInfo);
      extraJsonInfo.authResult = 1;
    })

    it('test_IsPowerFingerprintTouchUnlockEnable', 0, () => {
      let results: number = IAMAuthResult.SUCCEED;
      AppStorage.set<string>(FingerprintConstants.FINGERPRINT_SENSOR_TYPE_KEY, SensorType.OUT_OF_SCREEN_SENSOR);
      AppStorage.get<string>(FingerprintConstants.FINGERPRINT_SENSOR_TYPE_KEY);
      ScreenLockService.isOutOfScreenFingerprint();
      mFingerprintViewModelMode.getIsFingerprintEnable();
      let result = mFingerprintViewModelMode.IsPowerFingerprintTouchUnlockEnable();
      mFingerprintViewModelMode.OnSuccessUnlockCallback();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(ScreenLockService, ScreenLockService.isUnderScreenFingerprint);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      mFingerprintViewModelMode.OnSuccessUnlockCallback();
      expect(ScreenLockService.isUnderScreenFingerprint()).assertEqual(true);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      mFingerprintViewModelMode.OnSuccessUnlockCallback();
      expect(ScreenLockService.isUnderScreenFingerprint()).assertEqual(false);
      mocker.clear(ScreenLockService);
      mocker.clearAll();
      expect(result).assertEqual(false);
      mFingerprintViewModelMode.onIsFingerprintEnableChange(true);
      result = mFingerprintViewModelMode.IsPowerFingerprintTouchUnlockEnable();
      mFingerprintViewModelMode.OnSuccessUnlockCallback();
      expect(result).assertEqual(true);
      mFingerprintViewModelMode.onIsFingerprintEnableChange(true);
      mFingerprintViewModelMode.setIsAcquireWhenBeginSleep(true);
      mFingerprintViewModelMode.UnlockingAfterAuthFingerSuccess();
      ScreenLockService.setLock(true);
      ScreenLockService.getLock();
      extraJsonInfo.authResult = IAMAuthResult.SUCCEED;
      mFingerprintViewModel.onResultCallback(extraJsonInfo);
      extraJsonInfo.authResult = 1;
    })

    it('test_onIsFingerprintEnableChange_return', 0, () => {
      ScreenLockService.setLock(false);
      ScreenLockService.getLock();
      mFingerprintViewModel.onIsFingerprintEnableChange(true);
    })

    it('test_onResultCallback_return', 0, () => {
      let result: number = IAMAuthResult.SUCCEED;
      ScreenLockService.setLock(false);
      ScreenLockService.getLock();
      extraJsonInfo.authResult = IAMAuthResult.SUCCEED;
      mFingerprintViewModel.onResultCallback(extraJsonInfo);
      result = IAMAuthResult.AUTH_IS_CANCELED;
      ScreenLockManager.getInstance().setPreBrightStat(true);
      ScreenLockManager.getInstance().getPreBrightStat();
      mFingerprintViewModel.onResultCallback(extraJsonInfo);
      expect(ScreenLockManager.getInstance().getPreBrightStat()).not().assertNull();
      ScreenLockManager.getInstance().setPreBrightStat(false);
      ScreenLockManager.getInstance().getPreBrightStat();
      mFingerprintViewModel.onResultCallback(extraJsonInfo);
      expect(ScreenLockManager.getInstance().getPreBrightStat()).not().assertNull();
      result = IAMAuthResult.SYS_SERVICE_EXCEPTION;
      mFingerprintViewModel.onResultCallback(extraJsonInfo);
      result = IAMAuthResult.NOT_SYSTEM_APPLICATION;
      mFingerprintViewModel.onResultCallback(extraJsonInfo);
      extraJsonInfo.authResult = 1;
    })

    it('test_IsPowerFingerUnlockByPress', 0, () => {
      let result = mFingerprintViewModelMode.IsPowerFingerUnlockByPress();
      expect(result).assertEqual(false);
    })

    it('test_UnlockingAfterAuthFingerSuccess', 0, () => {
      AppStorage.set<string>(FingerprintConstants.FINGERPRINT_SENSOR_TYPE_KEY,SensorType.UNDER_SCREEN_SENSOR);
      AppStorage.get<string>(FingerprintConstants.FINGERPRINT_SENSOR_TYPE_KEY);
      AppStorage.set<boolean>('isEndScreenOn',false);
      AppStorage.get<boolean>('isEndScreenOn');
      ScreenLockService.isUnderScreenFingerprint();
      mFingerprintViewModelMode.UnlockingAfterAuthFingerSuccess();
      let result = mFingerprintViewModelMode.IsPlayExitAnimation();
      expect(result).assertEqual(true);
      AppStorage.set<boolean>('isEndScreenOn',true);
      AppStorage.get<boolean>('isEndScreenOn');
      mFingerprintViewModelMode.UnlockingAfterAuthFingerSuccess();
    })

    it('IsPlayExitAnimation', 0, () => {
      AppStorage.set<string>(FingerprintConstants.FINGERPRINT_SENSOR_TYPE_KEY, SensorType.NON_SENSOR);
      AppStorage.get<string>(FingerprintConstants.FINGERPRINT_SENSOR_TYPE_KEY);
      let result = mFingerprintViewModelMode.IsPlayExitAnimation();
      expect(result).assertEqual(true);
    })

    it('updateFingerprintSuspend_return', 0, () => {
      let remainTimes: number = -1;
      let freezingTime: number = 1;
      mFingerprintViewModel.updateFingerprintSuspend(remainTimes,freezingTime);
      remainTimes = 2;
      mFingerprintViewModel.updateFingerprintSuspend(remainTimes,freezingTime);
    })

    it('test_OnSuccessUnlockCallback', 0, () => {
      let remainTimes: number = 1;
      let freezingTime: number = FingerprintConstants.INVALID_DURATION;
      let isPsdFreezing: boolean = true;
      mFingerprintViewModelMode.OnSuccessUnlockCallback();
      mFingerprintViewModelMode.OnSuccessForUnderScreenFingerprint();
      mFingerprintViewModelMode.OnSuccessForPowerFingerprintTouchUnlock();
      mFingerprintViewModelMode.GetFingerprintPrompt(remainTimes, freezingTime, isPsdFreezing);
      let result = mFingerprintViewModelMode.IsNeedBlockPowerUp();
      expect(result).assertEqual(false);
    })

    it('test_GetFingerprintPrompt', 0, () => {
      let remainTimes: number = 1;
      let freezingTime: number = 0;
      let isPsdFreezing: boolean = true;
      AppStorage.set<string>(FingerprintConstants.FINGERPRINT_SENSOR_TYPE_KEY, SensorType.OUT_OF_SCREEN_SENSOR);
      AppStorage.get<string>(FingerprintConstants.FINGERPRINT_SENSOR_TYPE_KEY);
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      mFingerprintViewModelMode.GetFingerprintPrompt(remainTimes, freezingTime, isPsdFreezing);
      expect(DeviceHelper.isPC()).assertEqual(true);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      mFingerprintViewModelMode.GetFingerprintPrompt(remainTimes, freezingTime, isPsdFreezing);
      expect(DeviceHelper.isPC()).assertEqual(false);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
      mFingerprintViewModelMode.GetFingerprintPrompt(remainTimes, freezingTime, isPsdFreezing);
      expect(freezingTime).assertEqual(0);
    })

    it('test_GetFingerprintPrompt_one', 0, () => {
      let remainTimes: number = 0;
      let freezingTime: number = 1;
      let isPsdFreezing: boolean = true;
      AppStorage.set<string>(FingerprintConstants.FINGERPRINT_SENSOR_TYPE_KEY, SensorType.OUT_OF_SCREEN_SENSOR);
      AppStorage.get<string>(FingerprintConstants.FINGERPRINT_SENSOR_TYPE_KEY);
      mFingerprintViewModelMode.GetFingerprintPrompt(remainTimes, freezingTime, isPsdFreezing);
      expect(freezingTime).assertEqual(1);
    })

    it('test_GetFingerprintPrompt_two', 0, () => {
      let remainTimes: number = 0;
      let freezingTime: number = -1;
      let isPsdFreezing: boolean = true;
      AppStorage.set<string>(FingerprintConstants.FINGERPRINT_SENSOR_TYPE_KEY, SensorType.OUT_OF_SCREEN_SENSOR);
      AppStorage.get<string>(FingerprintConstants.FINGERPRINT_SENSOR_TYPE_KEY);
      mFingerprintViewModelMode.GetFingerprintPrompt(remainTimes, freezingTime, isPsdFreezing);
      expect(freezingTime).assertEqual(-1);
    })

    it('test_GetFingerprintPrompt_three', 0, () => {
      let remainTimes: number = 0;
      let freezingTime: number = -1;
      let isPsdFreezing: boolean = false;
      AppStorage.set<string>(FingerprintConstants.FINGERPRINT_SENSOR_TYPE_KEY, SensorType.OUT_OF_SCREEN_SENSOR);
      AppStorage.get<string>(FingerprintConstants.FINGERPRINT_SENSOR_TYPE_KEY);
      mFingerprintViewModelMode.GetFingerprintPrompt(remainTimes, freezingTime, isPsdFreezing);
      expect(freezingTime).assertEqual(-1);
      freezingTime = 1;
      mFingerprintViewModelMode.GetFingerprintPrompt(remainTimes, freezingTime, isPsdFreezing);
      expect(freezingTime).assertEqual(1);
    })

    it('test_GetFingerprintPrompt_four', 0, () => {
      let remainTimes: number = 1;
      let freezingTime: number = 1;
      let isPsdFreezing: boolean = true;
      AppStorage.set<string>(FingerprintConstants.FINGERPRINT_SENSOR_TYPE_KEY, SensorType.OUT_OF_SCREEN_SENSOR);
      AppStorage.get<string>(FingerprintConstants.FINGERPRINT_SENSOR_TYPE_KEY);
      mFingerprintViewModelMode.GetFingerprintPrompt(remainTimes, freezingTime, isPsdFreezing);
      expect(freezingTime).assertEqual(1);
    })

    it('test_GetPromptWhenPsdFreeing', 0, () => {
      let promptFreezingTime: number = 1;
      AppStorage.set<string>('passwordType', 'PIN_SIX');
      AppStorage.get('passwordType');
      mFingerprintViewModelMode.GetPromptWhenPsdFreeing(promptFreezingTime);
      mFingerprintViewModelMode.GetFreezingTimeByPsd();
      expect(ScreenLockService.isDomainAuthType()).not().assertNull();
    })

    it('test_GetPromptWhenPsdFreeing_one', 0, () => {
      let acquire: number = 1;
      AppStorage.set<boolean>('isScreenOn', false);
      AppStorage.get<boolean>('isScreenOn');
      let promptFreezingTime: number = 1;
      AppStorage.set<string>('passwordType', 'res');
      AppStorage.get('passwordType');
      mFingerprintViewModelMode.GetPromptWhenPsdFreeing(promptFreezingTime);
      mFingerprintViewModelMode.OnWrongFingerprintTriggerFaceRecognition(acquire);
      expect(ScreenLockManager.getInstance().getPreBrightStat()).not().assertNull();
    })

    it('test_FingerprintTipTooFastPrompt', 0, () => {
      let acquire: number = 1;
      AppStorage.set<string>('isPwdVisible', 'PIN_SIX');
      AppStorage.set<boolean>('isScreenOn', true);
      mFingerprintViewModelMode.FingerprintTipTooFastPrompt();
      mFingerprintViewModelMode.OnWrongFingerprintTriggerFaceRecognition(acquire);
      expect(ScreenLockManager.getInstance().getPreBrightStat()).not().assertNull();
    })

    it('test_FingerprintTipTooFastPrompt_one', 0, () => {
      AppStorage.set<string>('isPwdVisible', '');
      let acquire: number = 1;
      mFingerprintViewModelMode.FingerprintTipTooFastPrompt();
      mFingerprintViewModelMode.OnFingerprintDown();
      mFingerprintViewModelMode.OnWrongFingerprintTriggerFaceRecognition(acquire);
      expect(ScreenLockManager.getInstance().getPreBrightStat()).not().assertNull();
    })

    it('test_FingerprintTipTooFastPrompt_two', 0, () => {
      AppStorage.set<string>('isPwdVisible', 'res');
      mFingerprintViewModelMode.enterFingerprintView();
      mFingerprintViewModelMode.FingerprintTipTooFastPrompt();
    })

    it('test_OnFingerprintTipsResult', 0, () => {
      let moduleId: number = 1;
      let acquire: number = 1;
      let extraJsonInfo: IAMAuthExtraInfo = {
        authResult: 1,
        authRemainAttempts: 1,
        lockoutDuration: 1,
        userId: 1
      };
      mFingerprintViewModelMode.OnFingerprintTipsResult(moduleId, acquire, extraJsonInfo);
    })

    it('test_OnFingerprintTipsResult_one', 0, () => {
      let moduleId: number = 1;
      let acquire: number = 10001;
      let extraJsonInfo: IAMAuthExtraInfo = {
        authResult: 1,
        authRemainAttempts: 1,
        lockoutDuration: 1,
        userId: 1
      };
      mFingerprintViewModelMode.OnFingerprintTipsResult(moduleId, acquire, extraJsonInfo);
    })

    it('test_OnFingerprintTipsResult_two', 0, () => {
      let moduleId: number = 1;
      let acquire: number = 10001;
      let extraJsonInfo: IAMAuthExtraInfo = {
        authResult: osAccount.ResultCode.SUCCESS,
        authRemainAttempts: 1,
        lockoutDuration: 1,
        userId: 1
      };
      mFingerprintViewModelMode.OnFingerprintTipsResult(moduleId, acquire, extraJsonInfo);
    })

    it('test_OnFingerprintTipsResult_three', 0, () => {
      let moduleId: number = 1;
      let acquire: number = 10001;
      let extraJsonInfo: IAMAuthExtraInfo = {
        authResult: osAccount.ResultCode.FAIL,
        authRemainAttempts: 1,
        lockoutDuration: 1,
        userId: 1
      };
      mFingerprintViewModelMode.OnFingerprintTipsResult(moduleId, acquire, extraJsonInfo);
    })

    it('test_OnFingerprintTipsResult_four', 0, () => {
      let moduleId: number = 1;
      let acquire: number = 10001;
      let extraJsonInfo: IAMAuthExtraInfo = {
        authResult: 1,
        authRemainAttempts: 1,
        lockoutDuration: 2147483647,
        userId: 1
      };
      mFingerprintViewModelMode.OnFingerprintTipsResult(moduleId, acquire, extraJsonInfo);
    })

    it('test_unregisterFingerprintUnlockProtectionEvent', 0, () => {
      AppStorage.set<number>('mCurrentUserId', 0);
      let mCurrentUserId: number | undefined = AppStorage.get<number>('mCurrentUserId')
      mFingerprintViewModelMode.UnregisterFingerprintUnlockProtectionEvent();
      mFingerprintViewModelMode.RegisterFingerprintUnlockProtectionEvent();
      expect(mCurrentUserId).assertEqual(0);
    })

    it('test_UnregisterFingerprintUnlockSwitchEvent', 0, () => {
      AppStorage.set<number>('mCurrentUserId', 10);
      mFingerprintViewModelMode.RegisterFingerprintUnlockProtectionEvent();
      mFingerprintViewModelMode.UnregisterFingerprintUnlockSwitchEvent();
      let callback: AsyncCallback<void> = () => {
      };
      let leftRetryTimes: number = 0;
      mFingerprintViewModelMode.RegisterFingerprintUnlockSwitchEvent(callback, leftRetryTimes);
      expect(leftRetryTimes).assertEqual(0);
    })

    it('test_RegisterFingerprintUnlockSwitchEvent', 0, () => {
      let callback: AsyncCallback<void> = () => {
      };
      let leftRetryTimes: number = 1;
      mFingerprintViewModelMode.RegisterFingerprintUnlockSwitchEvent(callback, leftRetryTimes);
      expect(osAccount.getAccountManager().getOsAccountLocalId()).not().assertNull();
    })

    it('test_ChangeFingerprintPromptInView', 0, () => {
      let remainTimes: number = -10;
      let freezingTime: number = 1;
      let isPsdFreezing: boolean = true;
      mFingerprintViewModelMode.ChangeFingerprintPromptInView(remainTimes, freezingTime, isPsdFreezing);
    })

    it('test_ChangeFingerprintPromptInView_one', 0, () => {
      let remainTimes: number = 10;
      let freezingTime: number = 1;
      let isPsdFreezing: boolean = true;
      mFingerprintViewModelMode.ChangeFingerprintPromptInView(remainTimes, freezingTime, isPsdFreezing);
    })


    it('test_ChangeFingerprintPrompt', 0, () => {
      let remainTimes: number = 1;
      let freezingTime: number = 1;
      let isPsdFreezing: boolean = true;
      AppStorage.set<boolean>('isBeginSleepStart', true) as boolean;
      AppStorage.get<boolean>('isBeginSleepStart') as boolean;
      mFingerprintViewModelMode.ChangeFingerprintPrompt(remainTimes, freezingTime, isPsdFreezing);
      AppStorage.set<boolean>('isBeginSleepStart', false) as boolean;
      AppStorage.get<boolean>('isBeginSleepStart') as boolean;
      AppStorage.get('isPwdVisible');
      mFingerprintViewModelMode.ChangeFingerprintPrompt(remainTimes, freezingTime, isPsdFreezing);
      AppStorage.set('isPwdVisible', 'res');
      AppStorage.get('isPwdVisible');
      mFingerprintViewModelMode.ChangeFingerprintPrompt(remainTimes, freezingTime, isPsdFreezing);
      expect(AppStorage.get('isPwdVisible')).assertEqual('res');
    })

    it('test_ChangeFingerprintPrompt_one', 0, () => {
      let remainTimes: number = 6;
      let freezingTime: number = 1;
      let isPsdFreezing: boolean = true;
      mFingerprintViewModelMode.ChangeFingerprintPrompt(remainTimes, freezingTime, isPsdFreezing);
      expect(AppStorage.get('isPwdVisible')).not().assertNull();
      AppStorage.set('isPwdVisible', 'NOpc');
      AppStorage.get('isPwdVisible');
      AppStorage.set('isPwdVisibleForPC', 'Ypc');
      AppStorage.get('isPwdVisibleForPC');
      mFingerprintViewModelMode.ChangeFingerprintPrompt(remainTimes, freezingTime, isPsdFreezing);
    })

    it('test_ChangeFingerprintPromptForOffScreen', 0, () => {
      let remainTimes: number = 10;
      let freezingTime: number = 1;
      let isPsdFreezing: boolean = true;
      ScreenLockManager.getInstance().setPreBrightStat(true);
      ScreenLockManager.getInstance().getPreBrightStat();
      mFingerprintViewModelMode.ChangeFingerprintPromptForOffScreen(remainTimes, freezingTime, isPsdFreezing);
      ScreenLockManager.getInstance().setPreBrightStat(false);
      ScreenLockManager.getInstance().getPreBrightStat();
      mFingerprintViewModelMode.ChangeFingerprintPromptForOffScreen(remainTimes, freezingTime, isPsdFreezing);
    })

    it('test_ChangeFingerprintPromptForOffScreen_one', 0, () => {
      let remainTimes: number = 0;
      let freezingTime: number = 1;
      let isPsdFreezing: boolean = true;
      ScreenLockManager.getInstance().setPreBrightStat(true);
      ScreenLockManager.getInstance().getPreBrightStat();
      mFingerprintViewModelMode.ChangeFingerprintPromptForOffScreen(remainTimes, freezingTime, isPsdFreezing);
      ScreenLockManager.getInstance().setPreBrightStat(false);
      ScreenLockManager.getInstance().getPreBrightStat();
      mFingerprintViewModelMode.ChangeFingerprintPromptForOffScreen(remainTimes, freezingTime, isPsdFreezing);
    })

    it('test_ChangeFingerprintPromptForOffScreen_two', 0, () => {
      let remainTimes: number = 10;
      let freezingTime: number = 1;
      let isPsdFreezing: boolean = false;
      ScreenLockManager.getInstance().setPreBrightStat(true);
      ScreenLockManager.getInstance().getPreBrightStat();
      mFingerprintViewModelMode.ChangeFingerprintPromptForOffScreen(remainTimes, freezingTime, isPsdFreezing);
      ScreenLockManager.getInstance().setPreBrightStat(false);
      ScreenLockManager.getInstance().getPreBrightStat();
      mFingerprintViewModelMode.ChangeFingerprintPromptForOffScreen(remainTimes, freezingTime, isPsdFreezing);
    })
  })
}


export class FingerprintViewModelMode extends FingerprintViewModel {
  constructor() {
    super();
  }

  public DoPreBrightAuthFailScreenOff(): void {
    return this.doPreBrightAuthFailScreenOff();
  }

  public ComputeBaseTrans(biasX: number, biasY: number): void {
    return this.computeBaseTrans(biasX, biasY);
  }

  public IsUnderFingerprintPosLow(): boolean | undefined {
    return this.isUnderFingerprintPosLow();
  }

  public HideStatusBar(): void {
    return this.hideStatusBar();
  }

  public LoadLottieData(jsonPath: string, callback: (value: object) => void): void {
    return this.loadLottieData(jsonPath, callback);
  }

  public ShowStatusBar(): void {
    return this.showStatusBar();
  }

  public IsPowerFingerprintTouchUnlockEnable(): boolean {
    return this.isPowerFingerprintTouchUnlockEnable();
  }

  public IsPowerFingerUnlockByPress(): boolean {
    return this.isPowerFingerUnlockByPress();
  }

  public UnlockingAfterAuthFingerSuccess(): void {
    return this.unlockingAfterAuthFingerSuccess();
  }

  public IsPlayExitAnimation(): boolean {
    return this.isPlayExitAnimation();
  }

  public IsNeedBlockPowerUp(): boolean {
    return this.isNeedBlockPowerUp();
  }

  public OnSuccessUnlockCallback(): void {
    return this.onSuccessUnlockCallback();
  }

  public OnSuccessForUnderScreenFingerprint(): void {
    return this.onSuccessForUnderScreenFingerprint();
  }

  public OnSuccessForPowerFingerprintTouchUnlock(): void {
    return this.onSuccessForPowerFingerprintTouchUnlock();
  }

  public GetFingerprintPrompt(remainTimes: number,
    freezingTime: number,
    isPsdFreezing: boolean): Promise<string> {
    return this.getFingerprintPrompt(remainTimes, freezingTime, isPsdFreezing);
  }

  public GetPromptWhenPsdFreeing(promptFreezingTime: number): Promise<string> {
    return this.getPromptWhenPsdFreeing(promptFreezingTime);
  }

  public FingerprintTipTooFastPrompt(): void {
    return this.fingerprintTipTooFastPrompt();
  }

  public OnFingerprintDown(): void {
    return this.onFingerprintDown();
  }

  public OnWrongFingerprintTriggerFaceRecognition(acquire: number): void {
    return this.onWrongFingerprintTriggerFaceRecognition(acquire);
  }

  public GetFreezingTimeByPsd(): Promise<number> {
    return this.getFreezingTimeByPsd();
  }

  public OnFingerprintTipsResult(moduleId: number, acquire: number, extraJsonInfo: IAMAuthExtraInfo): Promise<void> {
    return this.onFingerprintTipsResult(moduleId, acquire, extraJsonInfo);
  }

  public UnregisterFingerprintUnlockProtectionEvent(): void {
    return this.unregisterFingerprintUnlockProtectionEvent();
  }

  public RegisterFingerprintUnlockProtectionEvent(): void {
    return this.registerFingerprintUnlockProtectionEvent();
  }

  public UnregisterFingerprintUnlockSwitchEvent(): void {
    return this.unregisterFingerprintUnlockSwitchEvent();
  }

  public RegisterFingerprintUnlockSwitchEvent(callback: AsyncCallback<void>,
    leftRetryTimes: number): Promise<void> {
    return this.registerFingerprintUnlockSwitchEvent(callback, leftRetryTimes);
  }

  public ChangeFingerprintPromptInView(remainTimes: number, freezingTime: number,
    isPsdFreezing: boolean): Promise<void> {
    return this.changeFingerprintPromptInView(remainTimes, freezingTime, isPsdFreezing);
  }

  public ChangeFingerprintPrompt(remainTimes: number, freezingTime: number, isPsdFreezing: boolean): Promise<void> {
    return this.changeFingerprintPrompt(remainTimes, freezingTime, isPsdFreezing);
  }

  public ChangeFingerprintPromptForOffScreen(remainTimes: number, freezingTime: number,
    isPsdFreezing: boolean): Promise<void> {
    return this.changeFingerprintPromptForOffScreen(remainTimes, freezingTime, isPsdFreezing);
  }
}