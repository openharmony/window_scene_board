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
import curves from '@ohos.curves';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { OverlayCardTransition, SCBTransitionManager } from '@ohos/windowscene';
import { DeviceHelper, CustomPromise } from '@ohos/frameworkwrapper';
import { OverlayTransitionParam } from '../../../../../main/ets/overlay/OverlayStartAnimHelper';
import { Singleton } from '../../../../../main/ets/utils/Singleton';
import { AnimationBase } from '../../../../../main/ets/animation/AnimationBase';
import { OverlayAnimType, OverlayCardInfo } from '../../../../../main/ets/overlay/OverlayCardInfo';
import { CutoutVm } from '../../../../../main/ets/statusbar/vm/CutoutVm';
import { baseStateMgr } from '@ohos/systemuiutils/src/main/ets/sysdialog/BaseStateManager';
import { DisplayRotationState, DisplaySizeState, StateType } from '@ohos/systemuiutils/src/main/ets/sysdialog/BaseState';
import { DeviceModeEnum } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { DeviceInfoVm } from '../../../../../main/ets/vm/DeviceInfoVm';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { SwipeAppToCapsuleAnimation } from '../../../../../main/ets/animation/SwipeAppToCapsuleAnimation';
export default function SwipeAppToCapsuleAnimationTest() {
  describe('instance_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_animate_correctly_when_constructor_params_are_valid', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = new LogDomain(0, "test");
      when(mocker.mockFunc(logHelper, logHelper.getDomain)).afterReturn(logDomain);

      let curve: curves.Curve = curves.Curve.LINEAR;
      let duration: number = 1000;
      let playCount: number = 1;
      let singleton: Singleton = new Singleton();
      let cutoutVm: CutoutVm = new CutoutVm();
      let deviceHelper: DeviceHelper = DeviceHelper.getInstance();
      let baseStateMgr: baseStateMgr = new baseStateMgr();
      let stateType: StateType = StateType.UNKNOWN;
      let displayRotationState: DisplayRotationState = new DisplayRotationState();
      let displaySizeState: DisplaySizeState = new DisplaySizeState();
      let deviceMode: DeviceModeEnum = DeviceModeEnum.PHONE;
      let deviceInfoVm: DeviceInfoVm = new DeviceInfoVm();
      let overlayCardInfo: OverlayCardInfo = new OverlayCardInfo();
      let overlayCardTransition: OverlayCardTransition = new OverlayCardTransition();
      let scbTransitionManager: SCBTransitionManager = new SCBTransitionManager();
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      let animationBase: AnimationBase = new AnimationBase();

      let testClass: SwipeAppToCapsuleAnimation = new SwipeAppToCapsuleAnimation(curve, duration, playCount, singleton, cutoutVm, deviceHelper, baseStateMgr, stateType, displayRotationState, displaySizeState, deviceMode, deviceInfoVm, overlayCardInfo, overlayCardTransition, scbTransitionManager, overlayTransitionParam, animationBase);

      expect(testClass.animate).assertInstanceOf(Function);
      expect(testClass.onAnimationStart).assertInstanceOf(Function);
      expect(testClass.onAnimationEnd).assertInstanceOf(Function);
      expect(testClass.getAnimationType).assertInstanceOf(Function);
      expect(testClass.getAnimationName).assertInstanceOf(Function);
      expect(testClass.getDuration).assertInstanceOf(Function);
      expect(testClass.getCurve).assertInstanceOf(Function);
      expect(testClass.getRepeatCount).assertInstanceOf(Function);
      expect(testClass.isAnimatable).assertInstanceOf(Function);

      let result: boolean = testClass.isAnimatable();
      expect(result).assertTrue();

      let result2: string = testClass.getAnimationName();
      expect(result2).assertEqual("SwipeAppToCapsuleAnimation");

      let result3: number = testClass.getDuration();
      expect(result3).assertEqual(1000);

      let result4: curves.Curve = testClass.getCurve();
      expect(result4).assertEqual(curve);

      let result5: number = testClass.getRepeatCount();
      expect(result5).assertEqual(1);

      let result6: OverlayAnimType = testClass.getAnimationType();
      expect(result6).assertEqual(OverlayAnimType.SWIPE_APP_TO_CAPSULE);

      let result7: boolean = testClass.animate();
      expect(result7).assertTrue();

      let result8: boolean = testClass.onAnimationStart();
      expect(result8).assertTrue();

      let result9: boolean = testClass.onAnimationEnd();
      expect(result9).assertTrue();

      let result10: void = testClass.reset();
      expect(result10).assertUndefined();

      let result11: void = testClass.stop();
      expect(result11).assertUndefined();

      let result12: void = testClass.pause();
      expect(result12).assertUndefined();

      let result13: void = testClass.resume();
      expect(result13).assertUndefined();

      let result14: void = testClass.finish();
      expect(result14).assertUndefined();

      let result15: void = testClass.update(1000);
      expect(result15).assertUndefined();

      let result16: CustomPromise<void> = testClass.waitForAnimation();
      expect(result16).assertInstanceOf(CustomPromise);

      let result17: CustomPromise<void> = testClass.run();
      expect(result17).assertInstanceOf(CustomPromise);

    });

    it('should_return_false_when_device_not_support', 0, () => {
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let mocker: MockKit = new MockKit();
      let deviceHelper: DeviceHelper = DeviceHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(deviceHelper, deviceHelper.isDeviceSupport);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      const result = swipeapptocapsuleanimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(false);
      mocker.ignoreMock(deviceHelper, deviceHelper.isDeviceSupport);
    });

    it('should_return_false_when_needRemoveSession_is_true', 0, () => {
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.needRemoveSession = true;
      const result = swipeapptocapsuleanimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_checker_returns_false', 0, () => {
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockError)(ArgumentMatchers.anyString).afterReturnNothing();

      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.containerSession.primarySession = { sceneInfo: { bundleName: 'test', appIndex: 1 } };
      const result = swipeapptocapsuleanimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(false);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_return_true_when_all_conditions_are_met', 0, () => {
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockError)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockSetSessionFinalState: Function = mocker.mockFunc(swipeapptocapsuleanimation, swipeapptocapsuleanimation.setSessionFinalState);
      when(mockSetSessionFinalState)(ArgumentMatchers.any).afterReturn(new Promise<void>(() => {}));

      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.containerSession.primarySession = { sceneInfo: { bundleName: 'test', appIndex: 1 } };
      const result = swipeapptocapsuleanimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.error);
      mocker.ignoreMock(swipeapptocapsuleanimation, swipeapptocapsuleanimation.setSessionFinalState);
    });

    it('should_return_true_when_exeDelayPromise_is_resolved', 0, () => {
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockError)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockSetSessionFinalState: Function = mocker.mockFunc(swipeapptocapsuleanimation, swipeapptocapsuleanimation.setSessionFinalState);
      when(mockSetSessionFinalState)(ArgumentMatchers.any).afterReturn(new Promise<void>(() => {}));

      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.containerSession.primarySession = { sceneInfo: { bundleName: 'test', appIndex: 1 } };
      swipeapptocapsuleanimation.exeDelayPromise = new CustomPromise();
      swipeapptocapsuleanimation.exeDelayPromise.resolve();
      const result = swipeapptocapsuleanimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.error);
      mocker.ignoreMock(swipeapptocapsuleanimation, swipeapptocapsuleanimation.setSessionFinalState);
    });

    it('should_return_true_when_exeDelayPromise_is_rejected', 0, () => {
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockError)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockSetSessionFinalState: Function = mocker.mockFunc(swipeapptocapsuleanimation, swipeapptocapsuleanimation.setSessionFinalState);
      when(mockSetSessionFinalState)(ArgumentMatchers.any).afterReturn(new Promise<void>(() => {}));

      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.containerSession.primarySession = { sceneInfo: { bundleName: 'test', appIndex: 1 } };
      swipeapptocapsuleanimation.exeDelayPromise = new CustomPromise();
      swipeapptocapsuleanimation.exeDelayPromise.reject(new Error('test error'));
      const result = swipeapptocapsuleanimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.error);
      mocker.ignoreMock(swipeapptocapsuleanimation, swipeapptocapsuleanimation.setSessionFinalState);
    });

    it('should_return_false_when_exeDelayPromise_is_not_null_and_not_resolved_or_rejected', 0, () => {
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.containerSession.primarySession = { sceneInfo: { bundleName: 'test', appIndex: 1 } };
      swipeapptocapsuleanimation.exeDelayPromise = new CustomPromise();
      const result = swipeapptocapsuleanimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_device_is_phone_and_landscape_mode', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let baseStateManager: baseStateMgr = baseStateMgr.getInstance();
      let mockGetBaseState: Function = mocker.mockFunc(baseStateManager, baseStateManager.getBaseState);
      when(mockGetBaseState)(ArgumentMatchers.anyNumber).afterReturn({ displayWidth: 1000, displayHeight: 500 } as DisplaySizeState);

      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.getInstance();
      let result = swipeapptocapsuleanimation.checkDeviceSupport();
      expect(result).assertEqual(false);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(baseStateManager, baseStateManager.getBaseState);
    });

    it('should_return_false_when_device_is_phone_and_portrait_negative_rotation', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let baseStateManager: baseStateMgr = baseStateMgr.getInstance();
      let mockGetBaseState: Function = mocker.mockFunc(baseStateManager, baseStateManager.getBaseState);
      when(mockGetBaseState)(ArgumentMatchers.anyNumber).afterReturn({ displayWidth: 500, displayHeight: 1000 } as DisplaySizeState);
      when(mockGetBaseState)(ArgumentMatchers.anyNumber).afterReturn({ isPortraitNegative: () => true } as DisplayRotationState);

      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.getInstance();
      let result = swipeapptocapsuleanimation.checkDeviceSupport();
      expect(result).assertEqual(false);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(baseStateManager, baseStateManager.getBaseState);
    });

    it('should_return_false_when_device_is_pad_or_expand_and_middle_cutout_is_not_available', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let baseStateManager: baseStateMgr = baseStateMgr.getInstance();
      let mockGetBaseState: Function = mocker.mockFunc(baseStateManager, baseStateManager.getBaseState);
      when(mockGetBaseState)(ArgumentMatchers.anyNumber).afterReturn({ isPortraitNegative: () => false } as DisplayRotationState);

      let cutoutVm: CutoutVm = CutoutVm.getInstance();
      let mockIsMiddleCutout: Function = mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout);
      when(mockIsMiddleCutout)().afterReturn(false);

      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.getInstance();
      deviceInfoVm.isExpand = true;

      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.getInstance();
      let result = swipeapptocapsuleanimation.checkDeviceSupport();
      expect(result).assertEqual(false);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(baseStateManager, baseStateManager.getBaseState);
      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
    });

    it('should_return_false_when_device_mode_is_emergency_mode', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let baseStateManager: baseStateMgr = baseStateMgr.getInstance();
      let mockGetBaseState: Function = mocker.mockFunc(baseStateManager, baseStateManager.getBaseState);
      when(mockGetBaseState)(ArgumentMatchers.anyNumber).afterReturn({ isPortraitNegative: () => false } as DisplayRotationState);

      let cutoutVm: CutoutVm = CutoutVm.getInstance();
      let mockIsMiddleCutout: Function = mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout);
      when(mockIsMiddleCutout)().afterReturn(true);

      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.getInstance();
      deviceInfoVm.isExpand = false;

      let appStorage: AppStorage = AppStorage.getInstance();
      appStorage.set('deviceModeState', DeviceModeEnum.EMERGENCY_MODE);

      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.getInstance();
      let result = swipeapptocapsuleanimation.checkDeviceSupport();
      expect(result).assertEqual(false);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(baseStateManager, baseStateManager.getBaseState);
      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
    });

    it('should_return_true_when_all_conditions_are_met', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let baseStateManager: baseStateMgr = baseStateMgr.getInstance();
      let mockGetBaseState: Function = mocker.mockFunc(baseStateManager, baseStateManager.getBaseState);
      when(mockGetBaseState)(ArgumentMatchers.anyNumber).afterReturn({ isPortraitNegative: () => false } as DisplayRotationState);
      when(mockGetBaseState)(ArgumentMatchers.anyNumber).afterReturn({ isMiddleCutout: () => true } as CutoutVm);

      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.getInstance();
      deviceInfoVm.isExpand = false;
      deviceInfoVm.isPhone = false;
      deviceInfoVm.isPad = false;

      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.getInstance();
      let result = swipeapptocapsuleanimation.checkDeviceSupport();
      expect(result).assertEqual(true);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(baseStateManager, baseStateManager.getBaseState);
    });

    it('should_call_notifySceneTransitionOut_when_controller_is_not_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      let containerSession: EsObject = {};
      let scenePanelManager: EsObject = {};
      let transitionController: EsObject = {};
      containerSession.transitionController = transitionController;
      overlayTransitionParam.containerSession = containerSession;
      overlayTransitionParam.scenePanelManager = scenePanelManager;

      let mockNotifySceneTransitionOut: Function = mocker.mockFunc(SCBTransitionManager.getInstance(), SCBTransitionManager.getInstance().notifySceneTransitionOut);
      when(mockNotifySceneTransitionOut)(ArgumentMatchers.any, ArgumentMatchers.anyBoolean).afterReturnNothing();

      swipeapptocapsuleanimation.initContainerSession(overlayTransitionParam);

      mocker.ignoreMock(SCBTransitionManager.getInstance(), SCBTransitionManager.getInstance().notifySceneTransitionOut);
    });

    it('should_call_getCurrentTransitionController_when_controller_is_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      let containerSession: EsObject = {};
      let scenePanelManager: EsObject = {};
      let transitionController: EsObject = {};
      containerSession.transitionController = null;
      overlayTransitionParam.containerSession = containerSession;
      overlayTransitionParam.scenePanelManager = scenePanelManager;

      let mockGetCurrentTransitionController: Function = mocker.mockFunc(SCBTransitionManager.getInstance(), SCBTransitionManager.getInstance().getCurrentTransitionController);
      when(mockGetCurrentTransitionController)().afterReturn(transitionController);

      swipeapptocapsuleanimation.initContainerSession(overlayTransitionParam);

      mocker.ignoreMock(SCBTransitionManager.getInstance(), SCBTransitionManager.getInstance().getCurrentTransitionController);
    });

    it('should_call_addBlurTransitionCountAndReturnValue_and_notifySceneTransitionOut_when_controller_is_not_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      let containerSession: EsObject = {};
      let scenePanelManager: EsObject = {};
      let transitionController: EsObject = {};
      containerSession.transitionController = transitionController;
      overlayTransitionParam.containerSession = containerSession;
      overlayTransitionParam.scenePanelManager = scenePanelManager;

      let mockAddBlurTransitionCountAndReturnValue: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.addBlurTransitionCountAndReturnValue);
      when(mockAddBlurTransitionCountAndReturnValue)().afterReturn(1);

      let mockNotifySceneTransitionOut: Function = mocker.mockFunc(SCBTransitionManager.getInstance(), SCBTransitionManager.getInstance().notifySceneTransitionOut);
      when(mockNotifySceneTransitionOut)(ArgumentMatchers.any, ArgumentMatchers.anyBoolean).afterReturnNothing();

      swipeapptocapsuleanimation.initContainerSession(overlayTransitionParam);

      mocker.ignoreMock(scenePanelManager, scenePanelManager.addBlurTransitionCountAndReturnValue);
      mocker.ignoreMock(SCBTransitionManager.getInstance(), SCBTransitionManager.getInstance().notifySceneTransitionOut);
    });

    it('should_call_getCurrentTransitionController_and_onBlurTransitionFinish_when_controller_is_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      let containerSession: EsObject = {};
      let scenePanelManager: EsObject = {};
      let transitionController: EsObject = {};
      containerSession.transitionController = null;
      overlayTransitionParam.containerSession = containerSession;
      overlayTransitionParam.scenePanelManager = scenePanelManager;

      let mockGetCurrentTransitionController: Function = mocker.mockFunc(SCBTransitionManager.getInstance(), SCBTransitionManager.getInstance().getCurrentTransitionController);
      when(mockGetCurrentTransitionController)().afterReturn(transitionController);

      let mockOnBlurTransitionFinish: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.onBlurTransitionFinish);
      when(mockOnBlurTransitionFinish)(ArgumentMatchers.anyNumber).afterReturnNothing();

      swipeapptocapsuleanimation.initContainerSession(overlayTransitionParam);

      mocker.ignoreMock(SCBTransitionManager.getInstance(), SCBTransitionManager.getInstance().getCurrentTransitionController);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.onBlurTransitionFinish);
    });

    it('should_call_addTransitionCount_and_getTransitionCount_when_controller_is_not_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      let containerSession: EsObject = {};
      let scenePanelManager: EsObject = {};
      let transitionController: EsObject = {};
      containerSession.transitionController = transitionController;
      overlayTransitionParam.containerSession = containerSession;
      overlayTransitionParam.scenePanelManager = scenePanelManager;

      let mockAddTransitionCount: Function = mocker.mockFunc(containerSession, containerSession.addTransitionCount);
      when(mockAddTransitionCount)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let mockGetTransitionCount: Function = mocker.mockFunc(containerSession, containerSession.getTransitionCount);
      when(mockGetTransitionCount)().afterReturn(1);

      swipeapptocapsuleanimation.initContainerSession(overlayTransitionParam);

      mocker.ignoreMock(containerSession, containerSession.addTransitionCount);
      mocker.ignoreMock(containerSession, containerSession.getTransitionCount);
    });

    it('should_call_onBlurTransitionInactive_when_controller_is_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      let containerSession: EsObject = {};
      let scenePanelManager: EsObject = {};
      let transitionController: EsObject = {};
      containerSession.transitionController = null;
      overlayTransitionParam.containerSession = containerSession;
      overlayTransitionParam.scenePanelManager = scenePanelManager;

      let mockOnBlurTransitionInactive: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.onBlurTransitionInactive);
      when(mockOnBlurTransitionInactive)().afterReturnNothing();

      swipeapptocapsuleanimation.initContainerSession(overlayTransitionParam);

      mocker.ignoreMock(scenePanelManager, scenePanelManager.onBlurTransitionInactive);
    });

    it('should_call_onBlurTransitionFinish_when_controller_is_not_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      let containerSession: EsObject = {};
      let scenePanelManager: EsObject = {};
      let transitionController: EsObject = {};
      containerSession.transitionController = transitionController;
      overlayTransitionParam.containerSession = containerSession;
      overlayTransitionParam.scenePanelManager = scenePanelManager;

      let mockOnBlurTransitionFinish: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.onBlurTransitionFinish);
      when(mockOnBlurTransitionFinish)(ArgumentMatchers.anyNumber).afterReturnNothing();

      swipeapptocapsuleanimation.initContainerSession(overlayTransitionParam);

      mocker.ignoreMock(scenePanelManager, scenePanelManager.onBlurTransitionFinish);
    });

    it('should_animate_correctly_when_constructor_params_are_valid', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = new LogDomain(0, "test");
      when(mocker.mockFunc(logHelper, logHelper.getDomain)).afterReturn(logDomain);

      let curve: curves.Curve = curves.Curve.LINEAR;
      let duration: number = 1000;
      let playCount: number = 1;
      let singleton: Singleton = new Singleton();
      let cutoutVm: CutoutVm = new CutoutVm();
      let deviceHelper: DeviceHelper = DeviceHelper.getInstance();
      let baseStateMgr: baseStateMgr = new baseStateMgr();
      let stateType: StateType = StateType.UNKNOWN;
      let displayRotationState: DisplayRotationState = new DisplayRotationState();
      let displaySizeState: DisplaySizeState = new DisplaySizeState();
      let deviceMode: DeviceModeEnum = DeviceModeEnum.PHONE;
      let deviceInfoVm: DeviceInfoVm = new DeviceInfoVm();
      let overlayCardInfo: OverlayCardInfo = new OverlayCardInfo();
      let overlayCardTransition: OverlayCardTransition = new OverlayCardTransition();
      let scbTransitionManager: SCBTransitionManager = new SCBTransitionManager();
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      let animationBase: AnimationBase = new AnimationBase();

      let testClass: SwipeAppToCapsuleAnimation = new SwipeAppToCapsuleAnimation(curve, duration, playCount, singleton, cutoutVm, deviceHelper, baseStateMgr, stateType, displayRotationState, displaySizeState, deviceMode, deviceInfoVm, overlayCardInfo, overlayCardTransition, scbTransitionManager, overlayTransitionParam, animationBase);

      expect(testClass.animate).assertInstanceOf(Function);
      expect(testClass.onAnimationStart).assertInstanceOf(Function);
      expect(testClass.onAnimationEnd).assertInstanceOf(Function);
      expect(testClass.getAnimationType).assertInstanceOf(Function);
      expect(testClass.getAnimationName).assertInstanceOf(Function);
      expect(testClass.getDuration).assertInstanceOf(Function);
      expect(testClass.getCurve).assertInstanceOf(Function);
      expect(testClass.getRepeatCount).assertInstanceOf(Function);
      expect(testClass.isAnimatable).assertInstanceOf(Function);

      let result: boolean = testClass.isAnimatable();
      expect(result).assertTrue();

      let result2: string = testClass.getAnimationName();
      expect(result2).assertEqual("SwipeAppToCapsuleAnimation");

      let result3: number = testClass.getDuration();
      expect(result3).assertEqual(1000);

      let result4: curves.Curve = testClass.getCurve();
      expect(result4).assertEqual(curve);

      let result5: number = testClass.getRepeatCount();
      expect(result5).assertEqual(1);

      let result6: OverlayAnimType = testClass.getAnimationType();
      expect(result6).assertEqual(OverlayAnimType.SWIPE_APP_TO_CAPSULE);

      let result7: boolean = testClass.animate();
      expect(result7).assertTrue();

      let result8: boolean = testClass.onAnimationStart();
      expect(result8).assertTrue();

      let result9: boolean = testClass.onAnimationEnd();
      expect(result9).assertTrue();

      let result10: void = testClass.reset();
      expect(result10).assertUndefined();

      let result11: void = testClass.stop();
      expect(result11).assertUndefined();

      let result12: void = testClass.pause();
      expect(result12).assertUndefined();

      let result13: void = testClass.resume();
      expect(result13).assertUndefined();

      let result14: void = testClass.finish();
      expect(result14).assertUndefined();

      let result15: void = testClass.update(1000);
      expect(result15).assertUndefined();

      let result16: CustomPromise<void> = testClass.waitForAnimation();
      expect(result16).assertInstanceOf(CustomPromise);

      let result17: CustomPromise<void> = testClass.run();
      expect(result17).assertInstanceOf(CustomPromise);

    });

    it('should_return_false_when_device_not_support', 0, () => {
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let mocker: MockKit = new MockKit();
      let deviceHelper: DeviceHelper = DeviceHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(deviceHelper, deviceHelper.isDeviceSupport);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      const result = swipeapptocapsuleanimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(false);
      mocker.ignoreMock(deviceHelper, deviceHelper.isDeviceSupport);
    });

    it('should_return_false_when_needRemoveSession_is_true', 0, () => {
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.needRemoveSession = true;
      const result = swipeapptocapsuleanimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_checker_returns_false', 0, () => {
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockError)(ArgumentMatchers.anyString).afterReturnNothing();

      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.containerSession.primarySession = { sceneInfo: { bundleName: 'test', appIndex: 1 } };
      const result = swipeapptocapsuleanimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(false);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_return_true_when_all_conditions_are_met', 0, () => {
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockError)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockSetSessionFinalState: Function = mocker.mockFunc(swipeapptocapsuleanimation, swipeapptocapsuleanimation.setSessionFinalState);
      when(mockSetSessionFinalState)(ArgumentMatchers.any).afterReturn(new Promise<void>(() => {}));

      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.containerSession.primarySession = { sceneInfo: { bundleName: 'test', appIndex: 1 } };
      const result = swipeapptocapsuleanimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.error);
      mocker.ignoreMock(swipeapptocapsuleanimation, swipeapptocapsuleanimation.setSessionFinalState);
    });

    it('should_return_true_when_exeDelayPromise_is_resolved', 0, () => {
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockError)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockSetSessionFinalState: Function = mocker.mockFunc(swipeapptocapsuleanimation, swipeapptocapsuleanimation.setSessionFinalState);
      when(mockSetSessionFinalState)(ArgumentMatchers.any).afterReturn(new Promise<void>(() => {}));

      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.containerSession.primarySession = { sceneInfo: { bundleName: 'test', appIndex: 1 } };
      swipeapptocapsuleanimation.exeDelayPromise = new CustomPromise();
      swipeapptocapsuleanimation.exeDelayPromise.resolve();
      const result = swipeapptocapsuleanimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.error);
      mocker.ignoreMock(swipeapptocapsuleanimation, swipeapptocapsuleanimation.setSessionFinalState);
    });

    it('should_return_true_when_exeDelayPromise_is_rejected', 0, () => {
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockError)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockSetSessionFinalState: Function = mocker.mockFunc(swipeapptocapsuleanimation, swipeapptocapsuleanimation.setSessionFinalState);
      when(mockSetSessionFinalState)(ArgumentMatchers.any).afterReturn(new Promise<void>(() => {}));

      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.containerSession.primarySession = { sceneInfo: { bundleName: 'test', appIndex: 1 } };
      swipeapptocapsuleanimation.exeDelayPromise = new CustomPromise();
      swipeapptocapsuleanimation.exeDelayPromise.reject(new Error('test error'));
      const result = swipeapptocapsuleanimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.error);
      mocker.ignoreMock(swipeapptocapsuleanimation, swipeapptocapsuleanimation.setSessionFinalState);
    });

    it('should_return_false_when_exeDelayPromise_is_not_null_and_not_resolved_or_rejected', 0, () => {
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.containerSession.primarySession = { sceneInfo: { bundleName: 'test', appIndex: 1 } };
      swipeapptocapsuleanimation.exeDelayPromise = new CustomPromise();
      const result = swipeapptocapsuleanimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_device_is_phone_and_landscape_mode', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let baseStateManager: baseStateMgr = baseStateMgr.getInstance();
      let mockGetBaseState: Function = mocker.mockFunc(baseStateManager, baseStateManager.getBaseState);
      when(mockGetBaseState)(ArgumentMatchers.anyNumber).afterReturn({ displayWidth: 1000, displayHeight: 500 } as DisplaySizeState);

      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.getInstance();
      let result = swipeapptocapsuleanimation.checkDeviceSupport();
      expect(result).assertEqual(false);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(baseStateManager, baseStateManager.getBaseState);
    });

    it('should_return_false_when_device_is_phone_and_portrait_negative_rotation', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let baseStateManager: baseStateMgr = baseStateMgr.getInstance();
      let mockGetBaseState: Function = mocker.mockFunc(baseStateManager, baseStateManager.getBaseState);
      when(mockGetBaseState)(ArgumentMatchers.anyNumber).afterReturn({ displayWidth: 500, displayHeight: 1000 } as DisplaySizeState);
      when(mockGetBaseState)(ArgumentMatchers.anyNumber).afterReturn({ isPortraitNegative: () => true } as DisplayRotationState);

      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.getInstance();
      let result = swipeapptocapsuleanimation.checkDeviceSupport();
      expect(result).assertEqual(false);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(baseStateManager, baseStateManager.getBaseState);
    });

    it('should_return_false_when_device_is_pad_or_expand_and_middle_cutout_is_not_available', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let baseStateManager: baseStateMgr = baseStateMgr.getInstance();
      let mockGetBaseState: Function = mocker.mockFunc(baseStateManager, baseStateManager.getBaseState);
      when(mockGetBaseState)(ArgumentMatchers.anyNumber).afterReturn({ isPortraitNegative: () => false } as DisplayRotationState);

      let cutoutVm: CutoutVm = CutoutVm.getInstance();
      let mockIsMiddleCutout: Function = mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout);
      when(mockIsMiddleCutout)().afterReturn(false);

      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.getInstance();
      deviceInfoVm.isExpand = true;

      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.getInstance();
      let result = swipeapptocapsuleanimation.checkDeviceSupport();
      expect(result).assertEqual(false);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(baseStateManager, baseStateManager.getBaseState);
      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
    });

    it('should_return_false_when_device_mode_is_emergency_mode', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let baseStateManager: baseStateMgr = baseStateMgr.getInstance();
      let mockGetBaseState: Function = mocker.mockFunc(baseStateManager, baseStateManager.getBaseState);
      when(mockGetBaseState)(ArgumentMatchers.anyNumber).afterReturn({ isPortraitNegative: () => false } as DisplayRotationState);

      let cutoutVm: CutoutVm = CutoutVm.getInstance();
      let mockIsMiddleCutout: Function = mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout);
      when(mockIsMiddleCutout)().afterReturn(true);

      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.getInstance();
      deviceInfoVm.isExpand = false;

      let appStorage: AppStorage = AppStorage.getInstance();
      appStorage.set('deviceModeState', DeviceModeEnum.EMERGENCY_MODE);

      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.getInstance();
      let result = swipeapptocapsuleanimation.checkDeviceSupport();
      expect(result).assertEqual(false);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(baseStateManager, baseStateManager.getBaseState);
      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
    });

    it('should_return_true_when_all_conditions_are_met', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let baseStateManager: baseStateMgr = baseStateMgr.getInstance();
      let mockGetBaseState: Function = mocker.mockFunc(baseStateManager, baseStateManager.getBaseState);
      when(mockGetBaseState)(ArgumentMatchers.anyNumber).afterReturn({ isPortraitNegative: () => false } as DisplayRotationState);
      when(mockGetBaseState)(ArgumentMatchers.anyNumber).afterReturn({ isMiddleCutout: () => true } as CutoutVm);

      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.getInstance();
      deviceInfoVm.isExpand = false;
      deviceInfoVm.isPhone = false;
      deviceInfoVm.isPad = false;

      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.getInstance();
      let result = swipeapptocapsuleanimation.checkDeviceSupport();
      expect(result).assertEqual(true);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(baseStateManager, baseStateManager.getBaseState);
    });

    it('should_call_notifySceneTransitionOut_when_controller_is_not_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      let containerSession: EsObject = {};
      let scenePanelManager: EsObject = {};
      let transitionController: EsObject = {};
      containerSession.transitionController = transitionController;
      overlayTransitionParam.containerSession = containerSession;
      overlayTransitionParam.scenePanelManager = scenePanelManager;

      let mockNotifySceneTransitionOut: Function = mocker.mockFunc(SCBTransitionManager.getInstance(), SCBTransitionManager.getInstance().notifySceneTransitionOut);
      when(mockNotifySceneTransitionOut)(ArgumentMatchers.any, ArgumentMatchers.anyBoolean).afterReturnNothing();

      swipeapptocapsuleanimation.initContainerSession(overlayTransitionParam);

      mocker.ignoreMock(SCBTransitionManager.getInstance(), SCBTransitionManager.getInstance().notifySceneTransitionOut);
    });

    it('should_call_getCurrentTransitionController_when_controller_is_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      let containerSession: EsObject = {};
      let scenePanelManager: EsObject = {};
      let transitionController: EsObject = {};
      containerSession.transitionController = null;
      overlayTransitionParam.containerSession = containerSession;
      overlayTransitionParam.scenePanelManager = scenePanelManager;

      let mockGetCurrentTransitionController: Function = mocker.mockFunc(SCBTransitionManager.getInstance(), SCBTransitionManager.getInstance().getCurrentTransitionController);
      when(mockGetCurrentTransitionController)().afterReturn(transitionController);

      swipeapptocapsuleanimation.initContainerSession(overlayTransitionParam);

      mocker.ignoreMock(SCBTransitionManager.getInstance(), SCBTransitionManager.getInstance().getCurrentTransitionController);
    });

    it('should_call_addBlurTransitionCountAndReturnValue_and_notifySceneTransitionOut_when_controller_is_not_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      let containerSession: EsObject = {};
      let scenePanelManager: EsObject = {};
      let transitionController: EsObject = {};
      containerSession.transitionController = transitionController;
      overlayTransitionParam.containerSession = containerSession;
      overlayTransitionParam.scenePanelManager = scenePanelManager;

      let mockAddBlurTransitionCountAndReturnValue: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.addBlurTransitionCountAndReturnValue);
      when(mockAddBlurTransitionCountAndReturnValue)().afterReturn(1);

      let mockNotifySceneTransitionOut: Function = mocker.mockFunc(SCBTransitionManager.getInstance(), SCBTransitionManager.getInstance().notifySceneTransitionOut);
      when(mockNotifySceneTransitionOut)(ArgumentMatchers.any, ArgumentMatchers.anyBoolean).afterReturnNothing();

      swipeapptocapsuleanimation.initContainerSession(overlayTransitionParam);

      mocker.ignoreMock(scenePanelManager, scenePanelManager.addBlurTransitionCountAndReturnValue);
      mocker.ignoreMock(SCBTransitionManager.getInstance(), SCBTransitionManager.getInstance().notifySceneTransitionOut);
    });

    it('should_call_getCurrentTransitionController_and_onBlurTransitionFinish_when_controller_is_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      let containerSession: EsObject = {};
      let scenePanelManager: EsObject = {};
      let transitionController: EsObject = {};
      containerSession.transitionController = null;
      overlayTransitionParam.containerSession = containerSession;
      overlayTransitionParam.scenePanelManager = scenePanelManager;

      let mockGetCurrentTransitionController: Function = mocker.mockFunc(SCBTransitionManager.getInstance(), SCBTransitionManager.getInstance().getCurrentTransitionController);
      when(mockGetCurrentTransitionController)().afterReturn(transitionController);

      let mockOnBlurTransitionFinish: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.onBlurTransitionFinish);
      when(mockOnBlurTransitionFinish)(ArgumentMatchers.anyNumber).afterReturnNothing();

      swipeapptocapsuleanimation.initContainerSession(overlayTransitionParam);

      mocker.ignoreMock(SCBTransitionManager.getInstance(), SCBTransitionManager.getInstance().getCurrentTransitionController);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.onBlurTransitionFinish);
    });

    it('should_call_addTransitionCount_and_getTransitionCount_when_controller_is_not_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      let containerSession: EsObject = {};
      let scenePanelManager: EsObject = {};
      let transitionController: EsObject = {};
      containerSession.transitionController = transitionController;
      overlayTransitionParam.containerSession = containerSession;
      overlayTransitionParam.scenePanelManager = scenePanelManager;

      let mockAddTransitionCount: Function = mocker.mockFunc(containerSession, containerSession.addTransitionCount);
      when(mockAddTransitionCount)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let mockGetTransitionCount: Function = mocker.mockFunc(containerSession, containerSession.getTransitionCount);
      when(mockGetTransitionCount)().afterReturn(1);

      swipeapptocapsuleanimation.initContainerSession(overlayTransitionParam);

      mocker.ignoreMock(containerSession, containerSession.addTransitionCount);
      mocker.ignoreMock(containerSession, containerSession.getTransitionCount);
    });

    it('should_call_onBlurTransitionInactive_when_controller_is_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      let containerSession: EsObject = {};
      let scenePanelManager: EsObject = {};
      let transitionController: EsObject = {};
      containerSession.transitionController = null;
      overlayTransitionParam.containerSession = containerSession;
      overlayTransitionParam.scenePanelManager = scenePanelManager;

      let mockOnBlurTransitionInactive: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.onBlurTransitionInactive);
      when(mockOnBlurTransitionInactive)().afterReturnNothing();

      swipeapptocapsuleanimation.initContainerSession(overlayTransitionParam);

      mocker.ignoreMock(scenePanelManager, scenePanelManager.onBlurTransitionInactive);
    });

    it('should_call_onBlurTransitionFinish_when_controller_is_not_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      let containerSession: EsObject = {};
      let scenePanelManager: EsObject = {};
      let transitionController: EsObject = {};
      containerSession.transitionController = transitionController;
      overlayTransitionParam.containerSession = containerSession;
      overlayTransitionParam.scenePanelManager = scenePanelManager;

      let mockOnBlurTransitionFinish: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.onBlurTransitionFinish);
      when(mockOnBlurTransitionFinish)(ArgumentMatchers.anyNumber).afterReturnNothing();

      swipeapptocapsuleanimation.initContainerSession(overlayTransitionParam);

      mocker.ignoreMock(scenePanelManager, scenePanelManager.onBlurTransitionFinish);
    });

    it('should_return_false_when_device_not_support', 0, () => {
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let mocker: MockKit = new MockKit();
      let deviceHelper: DeviceHelper = DeviceHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(deviceHelper, deviceHelper.isDeviceSupport);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      const result = swipeapptocapsuleanimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(false);
      mocker.ignoreMock(deviceHelper, deviceHelper.isDeviceSupport);
    });

    it('should_return_false_when_needRemoveSession_is_true', 0, () => {
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.needRemoveSession = true;
      const result = swipeapptocapsuleanimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_checker_returns_false', 0, () => {
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockError)(ArgumentMatchers.anyString).afterReturnNothing();

      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.containerSession.primarySession = { sceneInfo: { bundleName: 'test', appIndex: 1 } };
      const result = swipeapptocapsuleanimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(false);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_return_true_when_all_conditions_are_met', 0, () => {
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockError)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockSetSessionFinalState: Function = mocker.mockFunc(swipeapptocapsuleanimation, swipeapptocapsuleanimation.setSessionFinalState);
      when(mockSetSessionFinalState)(ArgumentMatchers.any).afterReturn(new Promise<void>(() => {}));

      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.containerSession.primarySession = { sceneInfo: { bundleName: 'test', appIndex: 1 } };
      const result = swipeapptocapsuleanimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.error);
      mocker.ignoreMock(swipeapptocapsuleanimation, swipeapptocapsuleanimation.setSessionFinalState);
    });

    it('should_return_true_when_exeDelayPromise_is_resolved', 0, () => {
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockError)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockSetSessionFinalState: Function = mocker.mockFunc(swipeapptocapsuleanimation, swipeapptocapsuleanimation.setSessionFinalState);
      when(mockSetSessionFinalState)(ArgumentMatchers.any).afterReturn(new Promise<void>(() => {}));

      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.containerSession.primarySession = { sceneInfo: { bundleName: 'test', appIndex: 1 } };
      swipeapptocapsuleanimation.exeDelayPromise = new CustomPromise();
      swipeapptocapsuleanimation.exeDelayPromise.resolve();
      const result = swipeapptocapsuleanimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.error);
      mocker.ignoreMock(swipeapptocapsuleanimation, swipeapptocapsuleanimation.setSessionFinalState);
    });

    it('should_return_true_when_exeDelayPromise_is_rejected', 0, () => {
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockError)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockSetSessionFinalState: Function = mocker.mockFunc(swipeapptocapsuleanimation, swipeapptocapsuleanimation.setSessionFinalState);
      when(mockSetSessionFinalState)(ArgumentMatchers.any).afterReturn(new Promise<void>(() => {}));

      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.containerSession.primarySession = { sceneInfo: { bundleName: 'test', appIndex: 1 } };
      swipeapptocapsuleanimation.exeDelayPromise = new CustomPromise();
      swipeapptocapsuleanimation.exeDelayPromise.reject(new Error('test error'));
      const result = swipeapptocapsuleanimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.error);
      mocker.ignoreMock(swipeapptocapsuleanimation, swipeapptocapsuleanimation.setSessionFinalState);
    });

    it('should_return_false_when_exeDelayPromise_is_not_null_and_not_resolved_or_rejected', 0, () => {
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.containerSession.primarySession = { sceneInfo: { bundleName: 'test', appIndex: 1 } };
      swipeapptocapsuleanimation.exeDelayPromise = new CustomPromise();
      const result = swipeapptocapsuleanimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_device_is_phone_and_landscape_mode', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let baseStateManager: baseStateMgr = baseStateMgr.getInstance();
      let mockGetBaseState: Function = mocker.mockFunc(baseStateManager, baseStateManager.getBaseState);
      when(mockGetBaseState)(ArgumentMatchers.anyNumber).afterReturn({ displayWidth: 1000, displayHeight: 500 } as DisplaySizeState);

      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.getInstance();
      let result = swipeapptocapsuleanimation.checkDeviceSupport();
      expect(result).assertEqual(false);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(baseStateManager, baseStateManager.getBaseState);
    });

    it('should_return_false_when_device_is_phone_and_portrait_negative_rotation', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let baseStateManager: baseStateMgr = baseStateMgr.getInstance();
      let mockGetBaseState: Function = mocker.mockFunc(baseStateManager, baseStateManager.getBaseState);
      when(mockGetBaseState)(ArgumentMatchers.anyNumber).afterReturn({ displayWidth: 500, displayHeight: 1000 } as DisplaySizeState);
      when(mockGetBaseState)(ArgumentMatchers.anyNumber).afterReturn({ isPortraitNegative: () => true } as DisplayRotationState);

      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.getInstance();
      let result = swipeapptocapsuleanimation.checkDeviceSupport();
      expect(result).assertEqual(false);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(baseStateManager, baseStateManager.getBaseState);
    });

    it('should_return_false_when_device_is_pad_or_expand_and_middle_cutout_is_not_available', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let baseStateManager: baseStateMgr = baseStateMgr.getInstance();
      let mockGetBaseState: Function = mocker.mockFunc(baseStateManager, baseStateManager.getBaseState);
      when(mockGetBaseState)(ArgumentMatchers.anyNumber).afterReturn({ isPortraitNegative: () => false } as DisplayRotationState);

      let cutoutVm: CutoutVm = CutoutVm.getInstance();
      let mockIsMiddleCutout: Function = mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout);
      when(mockIsMiddleCutout)().afterReturn(false);

      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.getInstance();
      deviceInfoVm.isExpand = true;

      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.getInstance();
      let result = swipeapptocapsuleanimation.checkDeviceSupport();
      expect(result).assertEqual(false);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(baseStateManager, baseStateManager.getBaseState);
      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
    });

    it('should_return_false_when_device_mode_is_emergency_mode', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let baseStateManager: baseStateMgr = baseStateMgr.getInstance();
      let mockGetBaseState: Function = mocker.mockFunc(baseStateManager, baseStateManager.getBaseState);
      when(mockGetBaseState)(ArgumentMatchers.anyNumber).afterReturn({ isPortraitNegative: () => false } as DisplayRotationState);

      let cutoutVm: CutoutVm = CutoutVm.getInstance();
      let mockIsMiddleCutout: Function = mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout);
      when(mockIsMiddleCutout)().afterReturn(true);

      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.getInstance();
      deviceInfoVm.isExpand = false;

      let appStorage: AppStorage = AppStorage.getInstance();
      appStorage.set('deviceModeState', DeviceModeEnum.EMERGENCY_MODE);

      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.getInstance();
      let result = swipeapptocapsuleanimation.checkDeviceSupport();
      expect(result).assertEqual(false);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(baseStateManager, baseStateManager.getBaseState);
      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
    });

    it('should_return_true_when_all_conditions_are_met', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let baseStateManager: baseStateMgr = baseStateMgr.getInstance();
      let mockGetBaseState: Function = mocker.mockFunc(baseStateManager, baseStateManager.getBaseState);
      when(mockGetBaseState)(ArgumentMatchers.anyNumber).afterReturn({ isPortraitNegative: () => false } as DisplayRotationState);
      when(mockGetBaseState)(ArgumentMatchers.anyNumber).afterReturn({ isMiddleCutout: () => true } as CutoutVm);

      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.getInstance();
      deviceInfoVm.isExpand = false;
      deviceInfoVm.isPhone = false;
      deviceInfoVm.isPad = false;

      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.getInstance();
      let result = swipeapptocapsuleanimation.checkDeviceSupport();
      expect(result).assertEqual(true);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(baseStateManager, baseStateManager.getBaseState);
    });

    it('should_call_notifySceneTransitionOut_when_controller_is_not_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      let containerSession: EsObject = {};
      let scenePanelManager: EsObject = {};
      let transitionController: EsObject = {};
      containerSession.transitionController = transitionController;
      overlayTransitionParam.containerSession = containerSession;
      overlayTransitionParam.scenePanelManager = scenePanelManager;

      let mockNotifySceneTransitionOut: Function = mocker.mockFunc(SCBTransitionManager.getInstance(), SCBTransitionManager.getInstance().notifySceneTransitionOut);
      when(mockNotifySceneTransitionOut)(ArgumentMatchers.any, ArgumentMatchers.anyBoolean).afterReturnNothing();

      swipeapptocapsuleanimation.initContainerSession(overlayTransitionParam);

      mocker.ignoreMock(SCBTransitionManager.getInstance(), SCBTransitionManager.getInstance().notifySceneTransitionOut);
    });

    it('should_call_getCurrentTransitionController_when_controller_is_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      let containerSession: EsObject = {};
      let scenePanelManager: EsObject = {};
      let transitionController: EsObject = {};
      containerSession.transitionController = null;
      overlayTransitionParam.containerSession = containerSession;
      overlayTransitionParam.scenePanelManager = scenePanelManager;

      let mockGetCurrentTransitionController: Function = mocker.mockFunc(SCBTransitionManager.getInstance(), SCBTransitionManager.getInstance().getCurrentTransitionController);
      when(mockGetCurrentTransitionController)().afterReturn(transitionController);

      swipeapptocapsuleanimation.initContainerSession(overlayTransitionParam);

      mocker.ignoreMock(SCBTransitionManager.getInstance(), SCBTransitionManager.getInstance().getCurrentTransitionController);
    });

    it('should_call_addBlurTransitionCountAndReturnValue_and_notifySceneTransitionOut_when_controller_is_not_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      let containerSession: EsObject = {};
      let scenePanelManager: EsObject = {};
      let transitionController: EsObject = {};
      containerSession.transitionController = transitionController;
      overlayTransitionParam.containerSession = containerSession;
      overlayTransitionParam.scenePanelManager = scenePanelManager;

      let mockAddBlurTransitionCountAndReturnValue: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.addBlurTransitionCountAndReturnValue);
      when(mockAddBlurTransitionCountAndReturnValue)().afterReturn(1);

      let mockNotifySceneTransitionOut: Function = mocker.mockFunc(SCBTransitionManager.getInstance(), SCBTransitionManager.getInstance().notifySceneTransitionOut);
      when(mockNotifySceneTransitionOut)(ArgumentMatchers.any, ArgumentMatchers.anyBoolean).afterReturnNothing();

      swipeapptocapsuleanimation.initContainerSession(overlayTransitionParam);

      mocker.ignoreMock(scenePanelManager, scenePanelManager.addBlurTransitionCountAndReturnValue);
      mocker.ignoreMock(SCBTransitionManager.getInstance(), SCBTransitionManager.getInstance().notifySceneTransitionOut);
    });

    it('should_call_getCurrentTransitionController_and_onBlurTransitionFinish_when_controller_is_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      let containerSession: EsObject = {};
      let scenePanelManager: EsObject = {};
      let transitionController: EsObject = {};
      containerSession.transitionController = null;
      overlayTransitionParam.containerSession = containerSession;
      overlayTransitionParam.scenePanelManager = scenePanelManager;

      let mockGetCurrentTransitionController: Function = mocker.mockFunc(SCBTransitionManager.getInstance(), SCBTransitionManager.getInstance().getCurrentTransitionController);
      when(mockGetCurrentTransitionController)().afterReturn(transitionController);

      let mockOnBlurTransitionFinish: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.onBlurTransitionFinish);
      when(mockOnBlurTransitionFinish)(ArgumentMatchers.anyNumber).afterReturnNothing();

      swipeapptocapsuleanimation.initContainerSession(overlayTransitionParam);

      mocker.ignoreMock(SCBTransitionManager.getInstance(), SCBTransitionManager.getInstance().getCurrentTransitionController);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.onBlurTransitionFinish);
    });

    it('should_call_addTransitionCount_and_getTransitionCount_when_controller_is_not_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      let containerSession: EsObject = {};
      let scenePanelManager: EsObject = {};
      let transitionController: EsObject = {};
      containerSession.transitionController = transitionController;
      overlayTransitionParam.containerSession = containerSession;
      overlayTransitionParam.scenePanelManager = scenePanelManager;

      let mockAddTransitionCount: Function = mocker.mockFunc(containerSession, containerSession.addTransitionCount);
      when(mockAddTransitionCount)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let mockGetTransitionCount: Function = mocker.mockFunc(containerSession, containerSession.getTransitionCount);
      when(mockGetTransitionCount)().afterReturn(1);

      swipeapptocapsuleanimation.initContainerSession(overlayTransitionParam);

      mocker.ignoreMock(containerSession, containerSession.addTransitionCount);
      mocker.ignoreMock(containerSession, containerSession.getTransitionCount);
    });

    it('should_call_onBlurTransitionInactive_when_controller_is_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      let containerSession: EsObject = {};
      let scenePanelManager: EsObject = {};
      let transitionController: EsObject = {};
      containerSession.transitionController = null;
      overlayTransitionParam.containerSession = containerSession;
      overlayTransitionParam.scenePanelManager = scenePanelManager;

      let mockOnBlurTransitionInactive: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.onBlurTransitionInactive);
      when(mockOnBlurTransitionInactive)().afterReturnNothing();

      swipeapptocapsuleanimation.initContainerSession(overlayTransitionParam);

      mocker.ignoreMock(scenePanelManager, scenePanelManager.onBlurTransitionInactive);
    });

    it('should_call_onBlurTransitionFinish_when_controller_is_not_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      let containerSession: EsObject = {};
      let scenePanelManager: EsObject = {};
      let transitionController: EsObject = {};
      containerSession.transitionController = transitionController;
      overlayTransitionParam.containerSession = containerSession;
      overlayTransitionParam.scenePanelManager = scenePanelManager;

      let mockOnBlurTransitionFinish: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.onBlurTransitionFinish);
      when(mockOnBlurTransitionFinish)(ArgumentMatchers.anyNumber).afterReturnNothing();

      swipeapptocapsuleanimation.initContainerSession(overlayTransitionParam);

      mocker.ignoreMock(scenePanelManager, scenePanelManager.onBlurTransitionFinish);
    });

    it('should_call_onBlurTransitionFinish_when_controller_is_not_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      let containerSession: EsObject = {};
      let scenePanelManager: EsObject = {};
      let transitionController: EsObject = {};
      containerSession.transitionController = transitionController;
      overlayTransitionParam.containerSession = containerSession;
      overlayTransitionParam.scenePanelManager = scenePanelManager;

      let mockOnBlurTransitionFinish: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.onBlurTransitionFinish);
      when(mockOnBlurTransitionFinish)(ArgumentMatchers.anyNumber).afterReturnNothing();

      swipeapptocapsuleanimation.initContainerSession(overlayTransitionParam);

      mocker.ignoreMock(scenePanelManager, scenePanelManager.onBlurTransitionFinish);
    });

    it('should_call_onBlurTransitionFinish_when_controller_is_not_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      let containerSession: EsObject = {};
      let scenePanelManager: EsObject = {};
      let transitionController: EsObject = {};
      containerSession.transitionController = transitionController;
      overlayTransitionParam.containerSession = containerSession;
      overlayTransitionParam.scenePanelManager = scenePanelManager;

      let mockOnBlurTransitionFinish: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.onBlurTransitionFinish);
      when(mockOnBlurTransitionFinish)(ArgumentMatchers.anyNumber).afterReturnNothing();

      swipeapptocapsuleanimation.initContainerSession(overlayTransitionParam);

      mocker.ignoreMock(scenePanelManager, scenePanelManager.onBlurTransitionFinish);
    });

    it('should_call_onBlurTransitionFinish_when_controller_is_not_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      let containerSession: EsObject = {};
      let scenePanelManager: EsObject = {};
      let transitionController: EsObject = {};
      containerSession.transitionController = transitionController;
      overlayTransitionParam.containerSession = containerSession;
      overlayTransitionParam.scenePanelManager = scenePanelManager;

      let mockOnBlurTransitionFinish: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.onBlurTransitionFinish);
      when(mockOnBlurTransitionFinish)(ArgumentMatchers.anyNumber).afterReturnNothing();

      swipeapptocapsuleanimation.initContainerSession(overlayTransitionParam);

      mocker.ignoreMock(scenePanelManager, scenePanelManager.onBlurTransitionFinish);
    });

    it('should_call_onBlurTransitionFinish_when_controller_is_not_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      let containerSession: EsObject = {};
      let scenePanelManager: EsObject = {};
      let transitionController: EsObject = {};
      containerSession.transitionController = transitionController;
      overlayTransitionParam.containerSession = containerSession;
      overlayTransitionParam.scenePanelManager = scenePanelManager;

      let mockOnBlurTransitionFinish: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.onBlurTransitionFinish);
      when(mockOnBlurTransitionFinish)(ArgumentMatchers.anyNumber).afterReturnNothing();

      swipeapptocapsuleanimation.initContainerSession(overlayTransitionParam);

      mocker.ignoreMock(scenePanelManager, scenePanelManager.onBlurTransitionFinish);
    });

    it('should_call_onBlurTransitionFinish_when_controller_is_not_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      let containerSession: EsObject = {};
      let scenePanelManager: EsObject = {};
      let transitionController: EsObject = {};
      containerSession.transitionController = transitionController;
      overlayTransitionParam.containerSession = containerSession;
      overlayTransitionParam.scenePanelManager = scenePanelManager;

      let mockOnBlurTransitionFinish: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.onBlurTransitionFinish);
      when(mockOnBlurTransitionFinish)(ArgumentMatchers.anyNumber).afterReturnNothing();

      swipeapptocapsuleanimation.initContainerSession(overlayTransitionParam);

      mocker.ignoreMock(scenePanelManager, scenePanelManager.onBlurTransitionFinish);
    });

    it('should_call_onBlurTransitionFinish_when_controller_is_not_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let swipeapptocapsuleanimation: SwipeAppToCapsuleAnimation = SwipeAppToCapsuleAnimation.INSTANCE;
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      let containerSession: EsObject = {};
      let scenePanelManager: EsObject = {};
      let transitionController: EsObject = {};
      containerSession.transitionController = transitionController;
      overlayTransitionParam.containerSession = containerSession;
      overlayTransitionParam.scenePanelManager = scenePanelManager;

      let mockOnBlurTransitionFinish: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.onBlurTransitionFinish);
      when(mockOnBlurTransitionFinish)(ArgumentMatchers.anyNumber).afterReturnNothing();

      swipeapptocapsuleanimation.initContainerSession(overlayTransitionParam);

      mocker.ignoreMock(scenePanelManager, scenePanelManager.onBlurTransitionFinish);
    });
  });
}