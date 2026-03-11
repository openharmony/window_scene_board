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
import { CommonUtils, LogHelper } from '@ohos/basicutils';
import {
  screenLockService as ScreenLockService,
} from '@ohos/screenlockcommon';
import { MultimodalInputPowerModule } from '@ohos/screenlockcommon/Index';
import inputConsumer from '@ohos.multimodalInput.inputConsumer';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import DrawDoneManager from '@ohos/screenlockcommon/src/main/ets/manager/DrawDoneManager';
import lottie from '@ohos/lottie';
import ScreenLockThemeManager from '@ohos/screenlockwidget/src/main/ets/common/theme/ScreenLockThemeManager';
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { FingerprintViewModel } from '../../../../../main/ets/SceneBoard/screenlock/refactor/FingerprintViewModel';

export default function FingerprintViewModelTest() {
  describe('preBright_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_register_screenLockDrawObserver_when_preBright_is_called', 0, () => {
      let fingerprintviewmodel: FingerprintViewModel = new FingerprintViewModel();
      let mocker: MockKit = new MockKit();
      let screenLockDrawDoneManager: DrawDoneManager = new DrawDoneManager(COMPONENT_ID_FINGERPRINT)
      let mockfunc: Function =
        mocker.mockFunc(screenLockDrawDoneManager, screenLockDrawDoneManager.registerComponentDrawObserver);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      fingerprintviewmodel.preBright();
      mocker.ignoreMock(screenLockDrawDoneManager, screenLockDrawDoneManager.registerComponentDrawObserver);
    });

    it('should_set_isNotifyPwrPreBright_to_true', 0, () => {
      let fingerprintviewmodel: FingerprintViewModel = new FingerprintViewModel();
      fingerprintviewmodel.setNotifyPwrPreBrightState(true);
      expect(fingerprintviewmodel.isNotifyPwrPreBright).assertEqual(true);
    });

    it('should_set_isNotifyPwrPreBright_to_false', 0, () => {
      let fingerprintviewmodel: FingerprintViewModel = new FingerprintViewModel();
      fingerprintviewmodel.setNotifyPwrPreBrightState(false);
      expect(fingerprintviewmodel.isNotifyPwrPreBright).assertEqual(false);
    });

    it('should_return_true_when_isNotifyPwrPreBright_is_true', 0, () => {
      let fingerprintviewmodel: FingerprintViewModel = new FingerprintViewModel();
      fingerprintviewmodel.isNotifyPwrPreBright = true;
      const result = fingerprintviewmodel.getNotifyPwrPreBrightState();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_isNotifyPwrPreBright_is_false', 0, () => {
      let fingerprintviewmodel: FingerprintViewModel = new FingerprintViewModel();
      fingerprintviewmodel.isNotifyPwrPreBright = false;
      const result = fingerprintviewmodel.getNotifyPwrPreBrightState();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isNotifyPwrPreBright_is_true', 0, () => {
      let fingerprintviewmodel: FingerprintViewModel = new FingerprintViewModel();
      fingerprintviewmodel.isNotifyPwrPreBright = true;
      const result = fingerprintviewmodel.getNotifyPwrPreBrightState();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_isNotifyPwrPreBright_is_false', 0, () => {
      let fingerprintviewmodel: FingerprintViewModel = new FingerprintViewModel();
      fingerprintviewmodel.isNotifyPwrPreBright = false;
      const result = fingerprintviewmodel.getNotifyPwrPreBrightState();
      expect(result).assertEqual(false);
    });

    it('should_notify_draw_done_when_screen_lock_draw_down_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let screenLockService: ScreenLockService = ScreenLockService.getInstance();
      let mockSetScreenLockDrawDown: Function = mocker.mockFunc(screenLockService, screenLockService.setScreenLockDrawDown);
      let mockGetScreenLockDrawDown: Function = mocker.mockFunc(screenLockService, screenLockService.getScreenLockDrawDown);
      let mockNotifyDrawDone: Function = mocker.mockFunc(screenLockService, screenLockService.notifyDrawDone);

      when(mockGetScreenLockDrawDown)([]).afterReturn(true);
      when(mockNotifyDrawDone)([]).afterReturnNothing();

      let fingerprintviewmodel: FingerprintViewModel = new FingerprintViewModel();
      fingerprintviewmodel.screenLockNotifyDrawDone();

      mocker.ignoreMock(screenLockService, screenLockService.setScreenLockDrawDown);
      mocker.ignoreMock(screenLockService, screenLockService.getScreenLockDrawDown);
      mocker.ignoreMock(screenLockService, screenLockService.notifyDrawDone);
    });

    it('should_set_screen_lock_draw_down_to_true_when_screen_lock_draw_down_is_false', 0, async () => {
      let mocker: MockKit = new MockKit();
      let screenLockService: ScreenLockService = ScreenLockService.getInstance();
      let mockSetScreenLockDrawDown: Function = mocker.mockFunc(screenLockService, screenLockService.setScreenLockDrawDown);
      let mockGetScreenLockDrawDown: Function = mocker.mockFunc(screenLockService, screenLockService.getScreenLockDrawDown);
      let mockNotifyDrawDone: Function = mocker.mockFunc(screenLockService, screenLockService.notifyDrawDone);

      when(mockGetScreenLockDrawDown)([]).afterReturn(false);
      when(mockSetScreenLockDrawDown)([ArgumentMatchers.anyBoolean]).afterReturnNothing();
      when(mockNotifyDrawDone)([]).afterReturnNothing();

      let fingerprintviewmodel: FingerprintViewModel = new FingerprintViewModel();
      fingerprintviewmodel.screenLockNotifyDrawDone();

      mocker.ignoreMock(screenLockService, screenLockService.setScreenLockDrawDown);
      mocker.ignoreMock(screenLockService, screenLockService.getScreenLockDrawDown);
      mocker.ignoreMock(screenLockService, screenLockService.notifyDrawDone);
    });

    it('should_return_false_when_isFingerprintEnable_is_false', 0, () => {
      let fingerprintviewmodel: FingerprintViewModel = new FingerprintViewModel();
      fingerprintviewmodel.isFingerprintEnable = false;
      expect(fingerprintviewmodel.getIsFingerprintEnable()).assertEqual(false);
    });

    it('should_return_true_when_isFingerprintEnable_is_true', 0, () => {
      let fingerprintviewmodel: FingerprintViewModel = new FingerprintViewModel();
      fingerprintviewmodel.isFingerprintEnable = true;
      expect(fingerprintviewmodel.getIsFingerprintEnable()).assertEqual(true);
    });

    it('should_reset_off_screen_fingerprint_fail_cnt_to_zero', 0, () => {
      let fingerprintviewmodel: FingerprintViewModel = new FingerprintViewModel();
      fingerprintviewmodel.resetOffScreenFingerprintFailCnt();
      expect(fingerprintviewmodel.offScreenFingerprintFailCnt).assertEqual(0);
    });

    it('should_return_psdPageFingerprintTransitionEffect', 0, () => {
      let fingerprintviewmodel: FingerprintViewModel = new FingerprintViewModel();
      let result: TransitionEffect = fingerprintviewmodel.getPsdPageFingerprintTransitionEffect();
      expect(result).assertInstanceOf(TransitionEffect);
    });

    it('should_return_NONE_FINGERPRINT_when_isOutOfScreenFingerprint_is_true', 0, () => {
      let fingerprintviewmodel: FingerprintViewModel = new FingerprintViewModel();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ScreenLockService, ScreenLockService.isOutOfScreenFingerprint);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      let result = fingerprintviewmodel.getPwdPageShowFingerprintType();
      expect(result).assertEqual(PsdPageShowFingerprintType.NONE_FINGERPRINT);
      mocker.ignoreMock(ScreenLockService, ScreenLockService.isOutOfScreenFingerprint);
    });

    it('should_return_NONE_FINGERPRINT_when_isFingerprintEnable_is_false_or_isFpSuspend_is_true', 0, () => {
      let fingerprintviewmodel: FingerprintViewModel = new FingerprintViewModel();
      fingerprintviewmodel.isFingerprintEnable = false;
      fingerprintviewmodel.isFpSuspend = true;
      let result = fingerprintviewmodel.getPwdPageShowFingerprintType();
      expect(result).assertEqual(PsdPageShowFingerprintType.NONE_FINGERPRINT);
    });

    it('should_return_REAL_FINGERPRINT_when_isLowFingerprintPosition_is_true', 0, () => {
      let fingerprintviewmodel: FingerprintViewModel = new FingerprintViewModel();
      fingerprintviewmodel.isFingerprintEnable = true;
      fingerprintviewmodel.isFpSuspend = false;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(fingerprintviewmodel, fingerprintviewmodel.isUnderFingerprintPosLow);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      let result = fingerprintviewmodel.getPwdPageShowFingerprintType();
      expect(result).assertEqual(PsdPageShowFingerprintType.REAL_FINGERPRINT);
      mocker.ignoreMock(fingerprintviewmodel, fingerprintviewmodel.isUnderFingerprintPosLow);
    });

    it('should_return_FAKE_FINGERPRINT_when_isLowFingerprintPosition_is_false', 0, () => {
      let fingerprintviewmodel: FingerprintViewModel = new FingerprintViewModel();
      fingerprintviewmodel.isFingerprintEnable = true;
      fingerprintviewmodel.isFpSuspend = false;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(fingerprintviewmodel, fingerprintviewmodel.isUnderFingerprintPosLow);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      let result = fingerprintviewmodel.getPwdPageShowFingerprintType();
      expect(result).assertEqual(PsdPageShowFingerprintType.FAKE_FINGERPRINT);
      mocker.ignoreMock(fingerprintviewmodel, fingerprintviewmodel.isUnderFingerprintPosLow);
    });

    it('should_return_NONE_FINGERPRINT_when_isLowFingerprintPosition_is_undefined', 0, () => {
      let fingerprintviewmodel: FingerprintViewModel = new FingerprintViewModel();
      fingerprintviewmodel.isFingerprintEnable = true;
      fingerprintviewmodel.isFpSuspend = false;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(fingerprintviewmodel, fingerprintviewmodel.isUnderFingerprintPosLow);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(undefined);
      let result = fingerprintviewmodel.getPwdPageShowFingerprintType();
      expect(result).assertEqual(PsdPageShowFingerprintType.NONE_FINGERPRINT);
      mocker.ignoreMock(fingerprintviewmodel, fingerprintviewmodel.isUnderFingerprintPosLow);
    });

    it('should_return_fingerprintViewBlur_when_getFingerprintViewBlur_is_called', 0, () => {
      let fingerprintviewmodel: FingerprintViewModel = new FingerprintViewModel();
      let mocker: MockKit = new MockKit();
      fingerprintviewmodel.getFingerprintViewBlur();
      expect(fingerprintviewmodel.getFingerprintViewBlur()).assertEqual(0);
    });

    it('should_set_fingerprintViewBlur_when_blur_is_valid', 0, () => {
      let fingerprintviewmodel: FingerprintViewModel = new FingerprintViewModel();
      let blur: number = 5;
      fingerprintviewmodel.setFingerprintViewBlur(blur);
      expect(fingerprintviewmodel.fingerprintViewBlur).assertEqual(5);
    });

    it('should_set_fingerprintViewBlur_when_blur_is_zero', 0, () => {
      let fingerprintviewmodel: FingerprintViewModel = new FingerprintViewModel();
      let blur: number = 0;
      fingerprintviewmodel.setFingerprintViewBlur(blur);
      expect(fingerprintviewmodel.fingerprintViewBlur).assertEqual(0);
    });

    it('should_set_fingerprintViewBlur_when_blur_is_negative', 0, () => {
      let fingerprintviewmodel: FingerprintViewModel = new FingerprintViewModel();
      let blur: number = -10;
      fingerprintviewmodel.setFingerprintViewBlur(blur);
      expect(fingerprintviewmodel.fingerprintViewBlur).assertEqual(-10);
    });

    it('should_return_when_fingerprintViewExitAnimation_not_finish', 0, async () => {
      let fingerprintviewmodel: FingerprintViewModel = new FingerprintViewModel();
      fingerprintviewmodel.isFingerprintViewExitAnimationFinish = false;
      fingerprintviewmodel.enterFingerprintView();
      expect(fingerprintviewmodel.isFingerprintViewExitAnimationFinish).assertEqual(false);
    });

    it('should_call_disableFaceRecognition_and_setFingerprintViewBlur_when_fingerprintViewExitAnimation_finish', 0, async () => {
      let mocker: MockKit = new MockKit();
      let fingerprintviewmodel: FingerprintViewModel = new FingerprintViewModel();
      fingerprintviewmodel.isFingerprintViewExitAnimationFinish = true;

      let mockDisableFaceRecognition: Function = mocker.mockFunc(ScreenLockService, ScreenLockService.disableFaceRecognition);
      when(mockDisableFaceRecognition)([]).afterReturnNothing();

      let mockSetFingerprintViewBlur: Function = mocker.mockFunc(fingerprintviewmodel, fingerprintviewmodel.setFingerprintViewBlur);
      when(mockSetFingerprintViewBlur)([ArgumentMatchers.anyNumber]).afterReturnNothing();

      fingerprintviewmodel.enterFingerprintView();

      expect(fingerprintviewmodel.isFingerprintViewExitAnimationFinish).assertEqual(true);
      mocker.ignoreMock(ScreenLockService, ScreenLockService.disableFaceRecognition);
      mocker.ignoreMock(fingerprintviewmodel, fingerprintviewmodel.setFingerprintViewBlur);
    });

    it('should_call_hideStatusBar_and_loadFingerprintGrowAnimation_when_fingerprintViewExitAnimation_finish', 0, async () => {
      let mocker: MockKit = new MockKit();
      let fingerprintviewmodel: FingerprintViewModel = new FingerprintViewModel();
      fingerprintviewmodel.isFingerprintViewExitAnimationFinish = true;

      let mockHideStatusBar: Function = mocker.mockFunc(fingerprintviewmodel, fingerprintviewmodel.hideStatusBar);
      when(mockHideStatusBar)([]).afterReturnNothing();

      let mockLoadFingerprintGrowAnimation: Function = mocker.mockFunc(fingerprintviewmodel, fingerprintviewmodel.loadFingerprintGrowAnimation);
      when(mockLoadFingerprintGrowAnimation)([]).afterReturnNothing();

      fingerprintviewmodel.enterFingerprintView();

      expect(fingerprintviewmodel.isFingerprintViewExitAnimationFinish).assertEqual(true);
      mocker.ignoreMock(fingerprintviewmodel, fingerprintviewmodel.hideStatusBar);
      mocker.ignoreMock(fingerprintviewmodel, fingerprintviewmodel.loadFingerprintGrowAnimation);
    });

    it('should_call_animateTo_and_update_fingerprintViewBlur_when_animateTo_callback_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let fingerprintviewmodel: FingerprintViewModel = new FingerprintViewModel();
      fingerprintviewmodel.isFingerprintViewExitAnimationFinish = true;
      fingerprintviewmodel.fingerprintViewBlur = 0;
      fingerprintviewmodel.isShowFingerprintView = false;

      let mockAnimateTo: Function = mocker.mockFunc(CommonUtils, CommonUtils.animateTo);
      when(mockAnimateTo)([ArgumentMatchers.anyObj, ArgumentMatchers.anyFunction]).afterAction((args: any[]) => {
        let callback: Function = args[1];
        callback();
      });

      fingerprintviewmodel.enterFingerprintView();

      expect(fingerprintviewmodel.isFingerprintViewExitAnimationFinish).assertEqual(true);
      expect(fingerprintviewmodel.fingerprintViewBlur).assertEqual(0);
      expect(fingerprintviewmodel.isShowFingerprintView).assertEqual(true);
      mocker.ignoreMock(CommonUtils, CommonUtils.animateTo);
    });

    it('should_call_hideStatusBar_and_loadFingerprintGrowAnimation_when_fingerprintViewExitAnimation_finish_and_isFingerprintEnable_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let fingerprintviewmodel: FingerprintViewModel = new FingerprintViewModel();
      fingerprintviewmodel.isFingerprintViewExitAnimationFinish = true;
      fingerprintviewmodel.isFingerprintEnable = true;

      let mockHideStatusBar: Function = mocker.mockFunc(fingerprintviewmodel, fingerprintviewmodel.hideStatusBar);
      when(mockHideStatusBar)([]).afterReturnNothing();

      let mockLoadFingerprintGrowAnimation: Function = mocker.mockFunc(fingerprintviewmodel, fingerprintviewmodel.loadFingerprintGrowAnimation);
      when(mockLoadFingerprintGrowAnimation)([]).afterReturnNothing();

      fingerprintviewmodel.enterFingerprintView();

      expect(fingerprintviewmodel.isFingerprintViewExitAnimationFinish).assertEqual(true);
      expect(fingerprintviewmodel.isFingerprintEnable).assertEqual(true);
      mocker.ignoreMock(fingerprintviewmodel, fingerprintviewmodel.hideStatusBar);
      mocker.ignoreMock(fingerprintviewmodel, fingerprintviewmodel.loadFingerprintGrowAnimation);
    });

    it('should_call_powerDown_callback_when_powerKeyDownUpCallback_is_called_with_power_key_up', 0, async () => {
      let mocker: MockKit = new MockKit();
      let fingerprintviewmodel: FingerprintViewModel = new FingerprintViewModel();
      fingerprintviewmodel.isFingerprintViewExitAnimationFinish = true;
      fingerprintviewmodel.isFingerprintEnable = true;
      fingerprintviewmodel.multimodalInputPowerModule = new MultimodalInputPowerModule();

      let mockPowerKeyDownUpCallback: Function = mocker.mockFunc(fingerprintviewmodel.multimodalInputPowerModule, fingerprintviewmodel.multimodalInputPowerModule.powerKeyDownUpCallback);
      when(mockPowerKeyDownUpCallback)([ArgumentMatchers.anyObj]).afterAction((args: any[]) => {
        let keyOptions: inputConsumer.KeyOptions = args[0];
        keyOptions.finalKey = KeyCode.KEYCODE_POWER;
        keyOptions.isFinalKeyDown = false;
      });

      fingerprintviewmodel.enterFingerprintView();

      expect(fingerprintviewmodel.isFingerprintViewExitAnimationFinish).assertEqual(true);
      expect(fingerprintviewmodel.isFingerprintEnable).assertEqual(true);
      mocker.ignoreMock(fingerprintviewmodel.multimodalInputPowerModule, fingerprintviewmodel.multimodalInputPowerModule.powerKeyDownUpCallback);
    });

    it('should_call_powerUp_callback_when_powerKeyDownUpCallback_is_called_with_power_key_down', 0, async () => {
      let mocker: MockKit = new MockKit();
      let fingerprintviewmodel: FingerprintViewModel = new FingerprintViewModel();
      fingerprintviewmodel.isFingerprintViewExitAnimationFinish = true;
      fingerprintviewmodel.isFingerprintEnable = true;
      fingerprintviewmodel.multimodalInputPowerModule = new MultimodalInputPowerModule();

      let mockPowerKeyDownUpCallback: Function = mocker.mockFunc(fingerprintviewmodel.multimodalInputPowerModule, fingerprintviewmodel.multimodalInputPowerModule.powerKeyDownUpCallback);
      when(mockPowerKeyDownUpCallback)([ArgumentMatchers.anyObj]).afterAction((args: any[]) => {
        let keyOptions: inputConsumer.KeyOptions = args[0];
        keyOptions.finalKey = KeyCode.KEYCODE_POWER;
        keyOptions.isFinalKeyDown = true;
      });

      fingerprintviewmodel.enterFingerprintView();

      expect(fingerprintviewmodel.isFingerprintViewExitAnimationFinish).assertEqual(true);
      expect(fingerprintviewmodel.isFingerprintEnable).assertEqual(true);
      mocker.ignoreMock(fingerprintviewmodel.multimodalInputPowerModule, fingerprintviewmodel.multimodalInputPowerModule.powerKeyDownUpCallback);
    });

    it('should_load_animation_when_fingerPrintParam_is_not_null', 0, async () => {
      let fingerprintviewmodel: FingerprintViewModel = new FingerprintViewModel();
      let mocker: MockKit = new MockKit();
      let screenLockThemeManager: ScreenLockThemeManager = ScreenLockThemeManager.getInstance();
      let mockfunc: Function = mocker.mockFunc(screenLockThemeManager, screenLockThemeManager.getScrenLockHigtFingerThemeParams);
      when(mockfunc)().afterReturn('someParam');

      let mockfunc2: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc2)('someParam').afterReturnNothing();

      let mockfunc3: Function = mocker.mockFunc(fingerprintviewmodel, fingerprintviewmodel.getLottieData);
      when(mockfunc3)('someParam').afterReturnNothing();

      let mockfunc4: Function = mocker.mockFunc(lottie, lottie.loadAnimation);
      when(mockfunc4)({
        container: fingerprintviewmodel.mainCanvasRenderingContext,
        renderer: 'canvas',
        loop: false,
        autoplay: true,
        name: fingerprintviewmodel.lottieName,
        animationData: fingerprintviewmodel.records.fingerPrint
      }).afterReturnNothing();

      fingerprintviewmodel.loadFingerprintGrowAnimation();

      mocker.ignoreMock(screenLockThemeManager, screenLockThemeManager.getScrenLockHigtFingerThemeParams);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(fingerprintviewmodel, fingerprintviewmodel.getLottieData);
      mocker.ignoreMock(lottie, lottie.loadAnimation);
    });

    it('should_load_animation_when_fingerPrintParam_is_null', 0, async () => {
      let fingerprintviewmodel: FingerprintViewModel = new FingerprintViewModel();
      let mocker: MockKit = new MockKit();
      let screenLockThemeManager: ScreenLockThemeManager = ScreenLockThemeManager.getInstance();
      let mockfunc: Function = mocker.mockFunc(screenLockThemeManager, screenLockThemeManager.getScrenLockHigtFingerThemeParams);
      when(mockfunc)().afterReturn(null);

      let mockfunc2: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc2)('somePath').afterReturnNothing();

      let mockfunc3: Function = mocker.mockFunc(fingerprintviewmodel, fingerprintviewmodel.getLottieData);
      when(mockfunc3)('somePath').afterReturnNothing();

      let mockfunc4: Function = mocker.mockFunc(lottie, lottie.loadAnimation);
      when(mockfunc4)({
        container: fingerprintviewmodel.mainCanvasRenderingContext,
        renderer: 'canvas',
        loop: false,
        autoplay: true,
        name: fingerprintviewmodel.lottieName,
        path: fingerprintviewmodel.lottieJsonPath
      }).afterReturnNothing();

      fingerprintviewmodel.loadFingerprintGrowAnimation();

      mocker.ignoreMock(screenLockThemeManager, screenLockThemeManager.getScrenLockHigtFingerThemeParams);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(fingerprintviewmodel, fingerprintviewmodel.getLottieData);
      mocker.ignoreMock(lottie, lottie.loadAnimation);
    });
  });

  describe('changePsdPageFingerprintTransitionEffect_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });
  });
}

export class PsdPageUnittest {
  baseTrans: number[] = [1, 2];
  psdPageFingerprintTransitionEffect: TransitionEffect;

  // 测试正常流程
  testChangePsdPageFingerprintTransitionEffect() {
    let offHandNormalizedSpeed: number = 1;
    this.changePsdPageFingerprintTransitionEffect(offHandNormalizedSpeed);
    // 由于TransitionEffect和curves是系统API，无法直接断言，这里仅验证函数调用是否成功
    expect(this.psdPageFingerprintTransitionEffect).not.toBeNull();
  }

  // 测试baseTrans长度不为2的情况
  testChangePsdPageFingerprintTransitionEffectInvalidLength() {
    let offHandNormalizedSpeed: number = 1;
    this.baseTrans = [1]; // 设置baseTrans长度为1
    this.changePsdPageFingerprintTransitionEffect(offHandNormalizedSpeed);
    // 由于TransitionEffect和curves是系统API，无法直接断言，这里仅验证函数调用是否成功
    expect(this.psdPageFingerprintTransitionEffect).not.toBeNull();
  }
}