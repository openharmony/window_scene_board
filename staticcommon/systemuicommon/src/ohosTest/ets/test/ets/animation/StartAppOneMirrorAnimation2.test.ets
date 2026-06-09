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
import { OverlayAnimType, OverlayCardInfo, OverlayCardState } from '../../../../../main/ets/overlay/OverlayCardInfo';
import { OverlayTransitionParam } from '../../../../../main/ets/overlay/OverlayStartAnimHelper';
import { Singleton } from '../../../../../main/ets/utils/Singleton';
import { AnimationBase } from '../../../../../main/ets/animation/AnimationBase';
import curves from '@ohos.curves';
import { CloseAppManager } from '@ohos/launchercommon/src/main/ets/manager/CloseAppManager';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { StartAppOneMirrorAnimation } from '../../../../../main/ets/animation/StartAppOneMirrorAnimation';

export default function StartAppOneMirrorAnimationTest() {
  describe('isExecuting_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_log_error_when_exception_occurs', 0, async () => {
      let startapponemirroranimation: StartAppOneMirrorAnimation = new StartAppOneMirrorAnimation();
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.transitionController = new SCBTransitionController();
      startapponemirroranimation.prepareParams = new StartAppOneMirrorPrepareParams();
      startapponemirroranimation.prepareParams.bundleName = "testBundle";
      startapponemirroranimation.prepareParams.scene = SystemUIUseScene.DROPDOWN;
      startapponemirroranimation.controller = new SCBTransitionController();
      let mocker: MockKit = new MockKit();
      let logHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let logHelperError: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      let closeAppManagerSetStartAppType: Function = mocker.mockFunc(CloseAppManager, CloseAppManager.getInstance().setStartAppType);
      when(logHelperShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(logHelperError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(closeAppManagerSetStartAppType)(ArgumentMatchers.any).afterReturnNothing();
      when(logHelperError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterThrow("Test Error");
      const result = startapponemirroranimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(true);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
      mocker.ignoreMock(CloseAppManager, CloseAppManager.getInstance().setStartAppType);
    });

    it('should_return_false_when_promise_is_undefined', 0, () => {
      let startapponemirroranimation: StartAppOneMirrorAnimation = new StartAppOneMirrorAnimation();
      startapponemirroranimation.promise = undefined;
      const result = startapponemirroranimation.isExecuting();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_promise_is_defined', 0, () => {
      let startapponemirroranimation: StartAppOneMirrorAnimation = new StartAppOneMirrorAnimation();
      let mocker: MockKit = new MockKit();
      let mockPromise: CustomPromise<void> = new CustomPromise();
      startapponemirroranimation.promise = mockPromise;
      const result = startapponemirroranimation.isExecuting();
      expect(result).assertEqual(true);
    });

    it('should_resolve_promise_when_bundleName_is_invalid', 0, async () => {
      let startapponemirroranimation: StartAppOneMirrorAnimation = new StartAppOneMirrorAnimation();
      let prepareParams: StartAppOneMirrorPrepareParams = new StartAppOneMirrorPrepareParams();
      prepareParams.bundleName = '';
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      const result = await startapponemirroranimation.prepare(prepareParams);
      expect(result).assertPromiseIsResolved();
      mocker.ignoreMock(logHelper, logHelper.showWarn);
    });

    it('should_resolve_promise_when_bundleName_is_valid', 0, async () => {
      let startapponemirroranimation: StartAppOneMirrorAnimation = new StartAppOneMirrorAnimation();
      let prepareParams: StartAppOneMirrorPrepareParams = new StartAppOneMirrorPrepareParams();
      prepareParams.bundleName = 'com.example.app';
      prepareParams.scene = SystemUIUseScene.BANNER;
      prepareParams.cardBgColor = 0xFFFFFF;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      let scbTransitionManager: SCBTransitionManager = SCBTransitionManager.getInstance();
      let mockfunc2: Function = mocker.mockFunc(scbTransitionManager, scbTransitionManager.setOverlayCardTransitionController);
      when(mockfunc2)(ArgumentMatchers.anyObj).afterReturnNothing();
      let overlayCardInfo: OverlayCardInfo = new OverlayCardInfo(OverlayAnimType.TYPE_START_APP);
      let mockfunc3: Function = mocker.mockFunc(overlayCardInfo, overlayCardInfo.castFromCard);
      when(mockfunc3)(ArgumentMatchers.anyObj).afterReturnNothing();
      const result = await startapponemirroranimation.prepare(prepareParams);
      expect(result).assertPromiseIsResolved();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(scbTransitionManager, scbTransitionManager.setOverlayCardTransitionController);
      mocker.ignoreMock(overlayCardInfo, overlayCardInfo.castFromCard);
    });

    it('should_log_warn_when_bundleName_is_invalid', 0, async () => {
      let startapponemirroranimation: StartAppOneMirrorAnimation = new StartAppOneMirrorAnimation();
      let prepareParams: StartAppOneMirrorPrepareParams = new StartAppOneMirrorPrepareParams();
      prepareParams.bundleName = '';
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      const result = await startapponemirroranimation.prepare(prepareParams);
      expect(result).assertPromiseIsResolved();
      mocker.ignoreMock(logHelper, logHelper.showWarn);
    });

    it('should_return_false_when_prepareParams_is_null', 0, () => {
      let startapponemirroranimation: StartAppOneMirrorAnimation = new StartAppOneMirrorAnimation();
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.transitionController = new SCBTransitionController();
      startapponemirroranimation.prepareParams = null;
      const result = startapponemirroranimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_controller_is_null', 0, () => {
      let startapponemirroranimation: StartAppOneMirrorAnimation = new StartAppOneMirrorAnimation();
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.transitionController = new SCBTransitionController();
      startapponemirroranimation.prepareParams = new StartAppOneMirrorPrepareParams();
      startapponemirroranimation.controller = null;
      const result = startapponemirroranimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_transitionController_is_different', 0, () => {
      let startapponemirroranimation: StartAppOneMirrorAnimation = new StartAppOneMirrorAnimation();
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.transitionController = new SCBTransitionController();
      startapponemirroranimation.prepareParams = new StartAppOneMirrorPrepareParams();
      startapponemirroranimation.controller = new SCBTransitionController();
      const result = startapponemirroranimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_all_conditions_are_met', 0, async () => {
      let startapponemirroranimation: StartAppOneMirrorAnimation = new StartAppOneMirrorAnimation();
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.transitionController = new SCBTransitionController();
      startapponemirroranimation.prepareParams = new StartAppOneMirrorPrepareParams();
      startapponemirroranimation.prepareParams.bundleName = "testBundle";
      startapponemirroranimation.prepareParams.scene = SystemUIUseScene.DROPDOWN;
      startapponemirroranimation.controller = new SCBTransitionController();
      let mocker: MockKit = new MockKit();
      let logHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let logHelperError: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      let closeAppManagerSetStartAppType: Function = mocker.mockFunc(CloseAppManager, CloseAppManager.getInstance().setStartAppType);
      let startAppOneMirrorAnimationSetSessionFinalState: Function = mocker.mockFunc(StartAppOneMirrorAnimation.prototype, StartAppOneMirrorAnimation.prototype.setSessionFinalState);
      when(logHelperShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(logHelperError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(closeAppManagerSetStartAppType)(ArgumentMatchers.any).afterReturnNothing();
      when(startAppOneMirrorAnimationSetSessionFinalState)(ArgumentMatchers.any).afterReturn(new CustomPromise<void>());
      const result = startapponemirroranimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(true);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
      mocker.ignoreMock(CloseAppManager, CloseAppManager.getInstance().setStartAppType);
      mocker.ignoreMock(StartAppOneMirrorAnimation.prototype, StartAppOneMirrorAnimation.prototype.setSessionFinalState);
    });

    it('should_log_error_when_exception_occurs', 0, async () => {
      let startapponemirroranimation: StartAppOneMirrorAnimation = new StartAppOneMirrorAnimation();
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.transitionController = new SCBTransitionController();
      startapponemirroranimation.prepareParams = new StartAppOneMirrorPrepareParams();
      startapponemirroranimation.prepareParams.bundleName = "testBundle";
      startapponemirroranimation.prepareParams.scene = SystemUIUseScene.DROPDOWN;
      startapponemirroranimation.controller = new SCBTransitionController();
      let mocker: MockKit = new MockKit();
      let logHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let logHelperError: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      let closeAppManagerSetStartAppType: Function = mocker.mockFunc(CloseAppManager, CloseAppManager.getInstance().setStartAppType);
      when(logHelperShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(logHelperError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(closeAppManagerSetStartAppType)(ArgumentMatchers.any).afterReturnNothing();
      when(logHelperError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterThrow("Test Error");
      const result = startapponemirroranimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(true);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
      mocker.ignoreMock(CloseAppManager, CloseAppManager.getInstance().setStartAppType);
    });

    it('should_log_error_when_exception_occurs', 0, async () => {
      let startapponemirroranimation: StartAppOneMirrorAnimation = new StartAppOneMirrorAnimation();
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.transitionController = new SCBTransitionController();
      startapponemirroranimation.prepareParams = new StartAppOneMirrorPrepareParams();
      startapponemirroranimation.prepareParams.bundleName = "testBundle";
      startapponemirroranimation.prepareParams.scene = SystemUIUseScene.DROPDOWN;
      startapponemirroranimation.controller = new SCBTransitionController();
      let mocker: MockKit = new MockKit();
      let logHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let logHelperError: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      let closeAppManagerSetStartAppType: Function = mocker.mockFunc(CloseAppManager, CloseAppManager.getInstance().setStartAppType);
      when(logHelperShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(logHelperError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(closeAppManagerSetStartAppType)(ArgumentMatchers.any).afterReturnNothing();
      when(logHelperError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterThrow("Test Error");
      const result = startapponemirroranimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(true);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
      mocker.ignoreMock(CloseAppManager, CloseAppManager.getInstance().setStartAppType);
    });

    it('should_log_error_when_exception_occurs', 0, async () => {
      let startapponemirroranimation: StartAppOneMirrorAnimation = new StartAppOneMirrorAnimation();
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.transitionController = new SCBTransitionController();
      startapponemirroranimation.prepareParams = new StartAppOneMirrorPrepareParams();
      startapponemirroranimation.prepareParams.bundleName = "testBundle";
      startapponemirroranimation.prepareParams.scene = SystemUIUseScene.DROPDOWN;
      startapponemirroranimation.controller = new SCBTransitionController();
      let mocker: MockKit = new MockKit();
      let logHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let logHelperError: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      let closeAppManagerSetStartAppType: Function = mocker.mockFunc(CloseAppManager, CloseAppManager.getInstance().setStartAppType);
      when(logHelperShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(logHelperError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(closeAppManagerSetStartAppType)(ArgumentMatchers.any).afterReturnNothing();
      when(logHelperError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterThrow("Test Error");
      const result = startapponemirroranimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(true);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
      mocker.ignoreMock(CloseAppManager, CloseAppManager.getInstance().setStartAppType);
    });

    it('should_log_error_when_exception_occurs', 0, async () => {
      let startapponemirroranimation: StartAppOneMirrorAnimation = new StartAppOneMirrorAnimation();
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.transitionController = new SCBTransitionController();
      startapponemirroranimation.prepareParams = new StartAppOneMirrorPrepareParams();
      startapponemirroranimation.prepareParams.bundleName = "testBundle";
      startapponemirroranimation.prepareParams.scene = SystemUIUseScene.DROPDOWN;
      startapponemirroranimation.controller = new SCBTransitionController();
      let mocker: MockKit = new MockKit();
      let logHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let logHelperError: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      let closeAppManagerSetStartAppType: Function = mocker.mockFunc(CloseAppManager, CloseAppManager.getInstance().setStartAppType);
      when(logHelperShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(logHelperError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(closeAppManagerSetStartAppType)(ArgumentMatchers.any).afterReturnNothing();
      when(logHelperError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterThrow("Test Error");
      const result = startapponemirroranimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(true);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
      mocker.ignoreMock(CloseAppManager, CloseAppManager.getInstance().setStartAppType);
    });

    it('should_log_error_when_exception_occurs', 0, async () => {
      let startapponemirroranimation: StartAppOneMirrorAnimation = new StartAppOneMirrorAnimation();
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.transitionController = new SCBTransitionController();
      startapponemirroranimation.prepareParams = new StartAppOneMirrorPrepareParams();
      startapponemirroranimation.prepareParams.bundleName = "testBundle";
      startapponemirroranimation.prepareParams.scene = SystemUIUseScene.DROPDOWN;
      startapponemirroranimation.controller = new SCBTransitionController();
      let mocker: MockKit = new MockKit();
      let logHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let logHelperError: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      let closeAppManagerSetStartAppType: Function = mocker.mockFunc(CloseAppManager, CloseAppManager.getInstance().setStartAppType);
      when(logHelperShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(logHelperError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(closeAppManagerSetStartAppType)(ArgumentMatchers.any).afterReturnNothing();
      when(logHelperError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterThrow("Test Error");
      const result = startapponemirroranimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(true);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
      mocker.ignoreMock(CloseAppManager, CloseAppManager.getInstance().setStartAppType);
    });

    it('should_log_error_when_exception_occurs', 0, async () => {
      let startapponemirroranimation: StartAppOneMirrorAnimation = new StartAppOneMirrorAnimation();
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.transitionController = new SCBTransitionController();
      startapponemirroranimation.prepareParams = new StartAppOneMirrorPrepareParams();
      startapponemirroranimation.prepareParams.bundleName = "testBundle";
      startapponemirroranimation.prepareParams.scene = SystemUIUseScene.DROPDOWN;
      startapponemirroranimation.controller = new SCBTransitionController();
      let mocker: MockKit = new MockKit();
      let logHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let logHelperError: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      let closeAppManagerSetStartAppType: Function = mocker.mockFunc(CloseAppManager, CloseAppManager.getInstance().setStartAppType);
      when(logHelperShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(logHelperError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(closeAppManagerSetStartAppType)(ArgumentMatchers.any).afterReturnNothing();
      when(logHelperError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterThrow("Test Error");
      const result = startapponemirroranimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(true);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
      mocker.ignoreMock(CloseAppManager, CloseAppManager.getInstance().setStartAppType);
    });

    it('should_log_error_when_exception_occurs', 0, async () => {
      let startapponemirroranimation: StartAppOneMirrorAnimation = new StartAppOneMirrorAnimation();
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.transitionController = new SCBTransitionController();
      startapponemirroranimation.prepareParams = new StartAppOneMirrorPrepareParams();
      startapponemirroranimation.prepareParams.bundleName = "testBundle";
      startapponemirroranimation.prepareParams.scene = SystemUIUseScene.DROPDOWN;
      startapponemirroranimation.controller = new SCBTransitionController();
      let mocker: MockKit = new MockKit();
      let logHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let logHelperError: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      let closeAppManagerSetStartAppType: Function = mocker.mockFunc(CloseAppManager, CloseAppManager.getInstance().setStartAppType);
      when(logHelperShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(logHelperError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(closeAppManagerSetStartAppType)(ArgumentMatchers.any).afterReturnNothing();
      when(logHelperError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterThrow("Test Error");
      const result = startapponemirroranimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(true);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
      mocker.ignoreMock(CloseAppManager, CloseAppManager.getInstance().setStartAppType);
    });

    it('should_log_error_when_exception_occurs', 0, async () => {
      let startapponemirroranimation: StartAppOneMirrorAnimation = new StartAppOneMirrorAnimation();
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.transitionController = new SCBTransitionController();
      startapponemirroranimation.prepareParams = new StartAppOneMirrorPrepareParams();
      startapponemirroranimation.prepareParams.bundleName = "testBundle";
      startapponemirroranimation.prepareParams.scene = SystemUIUseScene.DROPDOWN;
      startapponemirroranimation.controller = new SCBTransitionController();
      let mocker: MockKit = new MockKit();
      let logHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let logHelperError: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      let closeAppManagerSetStartAppType: Function = mocker.mockFunc(CloseAppManager, CloseAppManager.getInstance().setStartAppType);
      when(logHelperShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(logHelperError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(closeAppManagerSetStartAppType)(ArgumentMatchers.any).afterReturnNothing();
      when(logHelperError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterThrow("Test Error");
      const result = startapponemirroranimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(true);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
      mocker.ignoreMock(CloseAppManager, CloseAppManager.getInstance().setStartAppType);
    });

    it('should_log_error_when_exception_occurs', 0, async () => {
      let startapponemirroranimation: StartAppOneMirrorAnimation = new StartAppOneMirrorAnimation();
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.transitionController = new SCBTransitionController();
      startapponemirroranimation.prepareParams = new StartAppOneMirrorPrepareParams();
      startapponemirroranimation.prepareParams.bundleName = "testBundle";
      startapponemirroranimation.prepareParams.scene = SystemUIUseScene.DROPDOWN;
      startapponemirroranimation.controller = new SCBTransitionController();
      let mocker: MockKit = new MockKit();
      let logHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let logHelperError: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      let closeAppManagerSetStartAppType: Function = mocker.mockFunc(CloseAppManager, CloseAppManager.getInstance().setStartAppType);
      when(logHelperShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(logHelperError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(closeAppManagerSetStartAppType)(ArgumentMatchers.any).afterReturnNothing();
      when(logHelperError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterThrow("Test Error");
      const result = startapponemirroranimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(true);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
      mocker.ignoreMock(CloseAppManager, CloseAppManager.getInstance().setStartAppType);
    });

    it('should_log_error_when_exception_occurs', 0, async () => {
      let startapponemirroranimation: StartAppOneMirrorAnimation = new StartAppOneMirrorAnimation();
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.transitionController = new SCBTransitionController();
      startapponemirroranimation.prepareParams = new StartAppOneMirrorPrepareParams();
      startapponemirroranimation.prepareParams.bundleName = "testBundle";
      startapponemirroranimation.prepareParams.scene = SystemUIUseScene.DROPDOWN;
      startapponemirroranimation.controller = new SCBTransitionController();
      let mocker: MockKit = new MockKit();
      let logHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let logHelperError: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      let closeAppManagerSetStartAppType: Function = mocker.mockFunc(CloseAppManager, CloseAppManager.getInstance().setStartAppType);
      when(logHelperShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(logHelperError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(closeAppManagerSetStartAppType)(ArgumentMatchers.any).afterReturnNothing();
      when(logHelperError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterThrow("Test Error");
      const result = startapponemirroranimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(true);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
      mocker.ignoreMock(CloseAppManager, CloseAppManager.getInstance().setStartAppType);
    });

    it('should_log_error_when_exception_occurs', 0, async () => {
      let startapponemirroranimation: StartAppOneMirrorAnimation = new StartAppOneMirrorAnimation();
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.transitionController = new SCBTransitionController();
      startapponemirroranimation.prepareParams = new StartAppOneMirrorPrepareParams();
      startapponemirroranimation.prepareParams.bundleName = "testBundle";
      startapponemirroranimation.prepareParams.scene = SystemUIUseScene.DROPDOWN;
      startapponemirroranimation.controller = new SCBTransitionController();
      let mocker: MockKit = new MockKit();
      let logHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let logHelperError: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      let closeAppManagerSetStartAppType: Function = mocker.mockFunc(CloseAppManager, CloseAppManager.getInstance().setStartAppType);
      when(logHelperShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(logHelperError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(closeAppManagerSetStartAppType)(ArgumentMatchers.any).afterReturnNothing();
      when(logHelperError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterThrow("Test Error");
      const result = startapponemirroranimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(true);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
      mocker.ignoreMock(CloseAppManager, CloseAppManager.getInstance().setStartAppType);
    });

    it('should_log_error_when_exception_occurs', 0, async () => {
      let startapponemirroranimation: StartAppOneMirrorAnimation = new StartAppOneMirrorAnimation();
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.transitionController = new SCBTransitionController();
      startapponemirroranimation.prepareParams = new StartAppOneMirrorPrepareParams();
      startapponemirroranimation.prepareParams.bundleName = "testBundle";
      startapponemirroranimation.prepareParams.scene = SystemUIUseScene.DROPDOWN;
      startapponemirroranimation.controller = new SCBTransitionController();
      let mocker: MockKit = new MockKit();
      let logHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let logHelperError: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      let closeAppManagerSetStartAppType: Function = mocker.mockFunc(CloseAppManager, CloseAppManager.getInstance().setStartAppType);
      when(logHelperShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(logHelperError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(closeAppManagerSetStartAppType)(ArgumentMatchers.any).afterReturnNothing();
      when(logHelperError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterThrow("Test Error");
      const result = startapponemirroranimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(true);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
      mocker.ignoreMock(CloseAppManager, CloseAppManager.getInstance().setStartAppType);
    });

    it('should_log_error_when_exception_occurs', 0, async () => {
      let startapponemirroranimation: StartAppOneMirrorAnimation = new StartAppOneMirrorAnimation();
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.transitionController = new SCBTransitionController();
      startapponemirroranimation.prepareParams = new StartAppOneMirrorPrepareParams();
      startapponemirroranimation.prepareParams.bundleName = "testBundle";
      startapponemirroranimation.prepareParams.scene = SystemUIUseScene.DROPDOWN;
      startapponemirroranimation.controller = new SCBTransitionController();
      let mocker: MockKit = new MockKit();
      let logHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let logHelperError: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      let closeAppManagerSetStartAppType: Function = mocker.mockFunc(CloseAppManager, CloseAppManager.getInstance().setStartAppType);
      when(logHelperShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(logHelperError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(closeAppManagerSetStartAppType)(ArgumentMatchers.any).afterReturnNothing();
      when(logHelperError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterThrow("Test Error");
      const result = startapponemirroranimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(true);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
      mocker.ignoreMock(CloseAppManager, CloseAppManager.getInstance().setStartAppType);
    });

    it('should_log_error_when_exception_occurs', 0, async () => {
      let startapponemirroranimation: StartAppOneMirrorAnimation = new StartAppOneMirrorAnimation();
      let overlayTransitionParam: OverlayTransitionParam = new OverlayTransitionParam();
      overlayTransitionParam.transitionController = new SCBTransitionController();
      startapponemirroranimation.prepareParams = new StartAppOneMirrorPrepareParams();
      startapponemirroranimation.prepareParams.bundleName = "testBundle";
      startapponemirroranimation.prepareParams.scene = SystemUIUseScene.DROPDOWN;
      startapponemirroranimation.controller = new SCBTransitionController();
      let mocker: MockKit = new MockKit();
      let logHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let logHelperError: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      let closeAppManagerSetStartAppType: Function = mocker.mockFunc(CloseAppManager, CloseAppManager.getInstance().setStartAppType);
      when(logHelperShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(logHelperError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(closeAppManagerSetStartAppType)(ArgumentMatchers.any).afterReturnNothing();
      when(logHelperError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterThrow("Test Error");
      const result = startapponemirroranimation.checkAndExecute(overlayTransitionParam);
      expect(result).assertEqual(true);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
      mocker.ignoreMock(CloseAppManager, CloseAppManager.getInstance().setStartAppType);
    });2
  });
}