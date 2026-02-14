/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { afterEach, ArgumentMatchers, beforeAll, beforeEach, describe, expect, it, MockKit, when } from "@ohos/hypium";
import {
  RotationPropertyHolder,
  SCBRotationController } from "../../../../../../main/ets/rotation/SCBRotationController";
import {
  SCBContainerRotationReason,
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray} from "../../../../../../main/ets/scene/session/SCBSceneContainerSession";
import { SCBScreenProperty, SCBScreenSession } from "../../../../../../main/ets/screen/session/SCBScreenSession";
import screenSessionManager from '@ohos.screenSessionManager';
import sceneSessionManager from '@ohos.sceneSessionManager';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { SCBSceneInfo } from "../../../../../../main/ets/scene/session/SCBSceneInfo";
import { SCBSceneSession } from "../../../../../../main/ets/scene/session/SCBSceneSession";
import { SCBWindowRotateController } from "../../../../../../main/ets/scene/manager/SCBWindowRotateController";
import { SCBScreenSessionManager } from "../../../../../../main/ets/screen/session/SCBScreenSessionManager";
import { ReflectionUtils } from "../utils/ReflectionUtils";

let rotationController: SCBRotationController = new SCBRotationController();
let screenProperty: SCBScreenProperty = new SCBScreenProperty();
let mocker = new MockKit();
let isDesktopRotatable = false;
let windowRotateController = SCBWindowRotateController.getInstance();
let screenManager = SCBScreenSessionManager.getInstance()

let setExpandStartContainerSessionCallbackCount = 0;
let interruptPipAnimWithFloatRotationCallbackCount = 0;
let clearRecentStartNotifyRotationCallbackCount = 0;
let handleSplitScreenCallbackCount = 0;
let prepareRotationBeforeAnimationCallbackCount = 0;
let showDividerAfterRotationCallbackCount = 0;
let updateNeedScrollClipRotateFinishCallbackCount = 0;
let setFloatAnimateStatusCallbackCount = 0;
let showWallpaperAfterRotateCallbackCount = 0;
let updateFloatContainerWithScreenChangeCallbackCount = 0;
let notifyUpdateScenePanelWhenRotateCallbackCount = 0;
let getPanelNameCallbackCount = 0;
let updateFloatAfterRotationAnimateCallbackCount = 0;
let updateBlackBackgroundStateCallbackCount = 0;
let setKeyboardRotationFlagCallbackCount = 0;
let coverSensorRotationCallbackCount = 0;
let handleFloatWhenExitSceneCallbackCount = 0;
let clearExitSceneNotifyRotationCallbackCount = 0;
let getMattesLockStateCallbackCount = 0;

/**
 * RotationPropertyHolder viewModel inner implement
 */
let viewModelRotationPropertyHolder: RotationPropertyHolder = {
  getScreenProperty: (): SCBScreenProperty => {
    return screenProperty;
  },
  getContainerSessionList: (): SCBSceneContainerSessionArray => {
    return new SCBSceneContainerSessionArray();
  },
  getFloatingSessionList: (): SCBSceneContainerSessionArray => {
    return new SCBSceneContainerSessionArray();
  }
}

/*
 * SCBRotationController callback
 */
let setExpandStartContainerSessionCallback =
  (containerSession: SCBSceneContainerSession | null) => { setExpandStartContainerSessionCallbackCount++; };

let interruptPipAnimWithFloatRotationCallback = () => { interruptPipAnimWithFloatRotationCallbackCount++; };

let clearRecentStartNotifyRotationCallback = () => { clearRecentStartNotifyRotationCallbackCount++; };

let handleSplitScreenCallback = (containerSession: SCBSceneContainerSession | null,
    screenProperty: SCBScreenProperty, needHideKeyboard: boolean) => { handleSplitScreenCallbackCount++; };

let prepareRotationBeforeAnimationCallback = (rotation: number) => { prepareRotationBeforeAnimationCallbackCount++; };

let showDividerAfterRotationCallback = (containerSession: SCBSceneContainerSession | null,
  rotateDuration: number) => { showDividerAfterRotationCallbackCount++; };

let updateNeedScrollClipRotateFinishCallback = () => { updateNeedScrollClipRotateFinishCallbackCount++; };

let setFloatAnimateStatusCallback = (animateStatus: boolean) => { setFloatAnimateStatusCallbackCount++; };

let showWallpaperAfterRotateCallback = (animateStatus: boolean) => { showWallpaperAfterRotateCallbackCount++; };

let updateFloatContainerWithScreenChangeCallback = (screenProperty: SCBScreenProperty,
reason: SCBContainerRotationReason) => { updateFloatContainerWithScreenChangeCallbackCount++; };

let notifyUpdateScenePanelWhenRotateCallback =
  (screenProperty: SCBScreenProperty) => { notifyUpdateScenePanelWhenRotateCallbackCount++; };

let getPanelNameCallback = (): string => {
  getPanelNameCallbackCount++;
  return '';
};

let updateFloatAfterRotationAnimateCallback = () => { updateFloatAfterRotationAnimateCallbackCount++; };

let updateBlackBackgroundStateCallback = (blackBackgroundState: boolean) => { updateBlackBackgroundStateCallbackCount++; };

let setKeyboardRotationFlagCallback = (isRotating: boolean) => { setKeyboardRotationFlagCallbackCount++; };

let coverSensorRotationCallback = (screenSession: SCBScreenSession) => { coverSensorRotationCallbackCount++; };

let handleFloatWhenExitSceneCallback = (reason?: SCBContainerRotationReason) => { handleFloatWhenExitSceneCallbackCount++; };

let clearExitSceneNotifyRotationCallback = () => { clearExitSceneNotifyRotationCallbackCount++; };

let getMattesLockStateCallback = (): boolean => {
  getMattesLockStateCallbackCount++;
  return true;
};


export default function SCBRotationControllerTest() {
  describe('SCBRotationControllerTest', () => {
    beforeAll(() => {
      rotationController.setRotationPropertyHolder(viewModelRotationPropertyHolder);
      registerRotationCallback();
    });
    beforeEach(() => {
      let func1 = mocker.mockFunc(windowRotateController, windowRotateController.isDesktopRotatable);
      let func2: Function = mocker.mockFunc(screenManager, screenManager.getScreenSession);
      when(func1)(ArgumentMatchers.any).afterReturn(() => { return isDesktopRotatable; });
      when(func2)(ArgumentMatchers.any).afterReturn(() => { return new SCBScreenSession(buildScreenSession()); });
    });
    afterEach(() => {
      clearCount();
      screenProperty.rotation = 0;
      isDesktopRotatable = false;
    });

    it('shouldInvokeSetExpandStartContainerSessionCallbackOnce', 0, () => {
      isDesktopRotatable = true;
      rotationController.startSceneWithRotationIfNeed(buildContainer(), true);
      afterInvoke();
      expect(setExpandStartContainerSessionCallbackCount).assertEqual(1);
    });

    it('shouldCallClearRecentStartNotifyRotationCallbackOnce', 0, () => {
      isDesktopRotatable = false;
      ReflectionUtils.setProperty(windowRotateController, 'currRotation', -1);
      rotationController.startSceneWithRotationIfNeed(buildContainer(), true);
      afterInvoke();
      expect(clearRecentStartNotifyRotationCallbackCount).assertEqual(1);
    });

    it('shouldCallInterruptPipAnimWithFloatRotationCallbackOnce', 0, () => {
      isDesktopRotatable = false;
      ReflectionUtils.setProperty(windowRotateController, 'currRotation', -1);
      screenProperty.rotation = 90;
      rotationController.exitSceneWithRotationRecover(buildContainer(), SCBContainerRotationReason.SCREEN_ROTATION);
      afterInvoke();
      expect(interruptPipAnimWithFloatRotationCallbackCount).assertEqual(1);
      expect(screenProperty.rotation).assertEqual(90);
    });

    it('shouldCallHandleSplitScreenCallbackOnce', 0, () => {
      rotationController.handleSplitScreen(null, screenProperty, true);
      expect(handleSplitScreenCallbackCount).assertEqual(1);
    });

    it('shouldCallPrepareRotationBeforeAnimationCallbackOnce', 0, () => {
      rotationController.prepareRotationBeforeAnimation(1);
      expect(prepareRotationBeforeAnimationCallbackCount).assertEqual(1);
    });

    it('shouldCallShowDividerAfterRotationCallbackOnce', 0, () => {
      rotationController.showDividerAfterRotation(null, 1);
      expect(showDividerAfterRotationCallbackCount).assertEqual(1);
    });

    it('shouldCallUpdateNeedScrollClipRotateFinishCallbackOnce', 0, () => {
      rotationController.updateNeedScrollClipRotateFinish();
      expect(updateNeedScrollClipRotateFinishCallbackCount).assertEqual(1);
    });

    it('shouldCallSetFloatAnimateStatusCallbackOnce', 0, () => {
      rotationController.setFloatAnimateStatus(true);
      expect(setFloatAnimateStatusCallbackCount).assertEqual(1);
    });

    it('shouldCallShowWallpaperAfterRotateCallbackOnce', 0, () => {
      rotationController.showWallpaperAfterRotate(true);
      expect(showWallpaperAfterRotateCallbackCount).assertEqual(1);
    });

    it('shouldCallUpdateFloatContainerWithScreenChangeCallbackOnce', 0, () => {
      rotationController.updateFloatContainerWithScreenChange(screenProperty, SCBContainerRotationReason.SCREEN_ROTATION);
      expect(updateFloatContainerWithScreenChangeCallbackCount).assertEqual(1);
    });

    it('shouldCallNotifyUpdateScenePanelWhenRotateCallbackOnce', 0, () => {
      rotationController.notifyUpdateScenePanelWhenRotate(screenProperty);
      ReflectionUtils.useFunc(rotationController, 'notifyUpdateScenePanelWhenRotate', screenProperty);
      expect(notifyUpdateScenePanelWhenRotateCallbackCount).assertEqual(1);
    });

    it('shouldCallGetPanelNameCallbackOnce', 0, () => {
      rotationController.getPanelName();
      expect(getPanelNameCallbackCount).assertEqual(1);
    });

    it('shouldCallUpdateFloatAfterRotationAnimateCallbackOnce', 0, () => {
      rotationController.updateFloatAfterRotationAnimate();
      expect(updateFloatAfterRotationAnimateCallbackCount).assertEqual(1);
    });

    it('shouldCallUpdateBlackBackgroundStateCallbackOnce', 0, () => {
      rotationController.updateBlackBackgroundState(true);
      expect(updateBlackBackgroundStateCallbackCount).assertEqual(1);
    });

    it('shouldCallSetKeyboardRotationFlagCallbackOnce', 0, () => {
      rotationController.setKeyboardRotationFlag(true);
      expect(setKeyboardRotationFlagCallbackCount).assertEqual(1);
    });

    it('shouldCallCoverSensorRotationCallbackOnce', 0, () => {
      rotationController.coverSensorRotation(new SCBScreenSession(buildScreenSession()));
      expect(coverSensorRotationCallbackCount).assertEqual(1);
    });

    it('shouldCallHandleFloatWhenExitSceneCallbackOnce', 0, () => {
      rotationController.handleFloatWhenExitScene();
      ReflectionUtils.useFunc(rotationController, 'handleFloatWhenExitScene');
      expect(handleFloatWhenExitSceneCallbackCount).assertEqual(1);
    });

    it('shouldCallClearExitSceneNotifyRotationCallbackOnce', 0, () => {
      rotationController.clearExitSceneNotifyRotation();
      expect(clearExitSceneNotifyRotationCallbackCount).assertEqual(1);
    });

    it('shouldCallGetMattesLockStateCallbackOnce', 0, () => {
      rotationController.getMattesLockState();
      expect(getMattesLockStateCallbackCount).assertEqual(1);
    });
  });
}

function afterInvoke(): void {
  ReflectionUtils.setProperty(windowRotateController, 'currRotation', 0);
  mocker.clear(windowRotateController);
  mocker.clear(screenManager);
}

function registerRotationCallback(): void {
  rotationController.registerInterruptPipAnimWithFloatRotationFunc(interruptPipAnimWithFloatRotationCallback);
  rotationController.registerClearRecentStartNotifyRotationFunc(clearRecentStartNotifyRotationCallback);
  rotationController.registerSetExpandStartContainerSessionFunc(setExpandStartContainerSessionCallback);
  rotationController.registerHandleSplitScreenFunc(handleSplitScreenCallback);
  rotationController.registerPrepareRotationBeforeAnimationFunc(prepareRotationBeforeAnimationCallback);
  rotationController.registerShowDividerAfterRotationFunc(showDividerAfterRotationCallback);
  rotationController.registerUpdateNeedScrollClipRotateFinishFunc(updateNeedScrollClipRotateFinishCallback);
  rotationController.registerSetFloatAnimateStatusFunc(setFloatAnimateStatusCallback);
  rotationController.registerShowWallpaperAfterRotateFunc(showWallpaperAfterRotateCallback);
  rotationController.registerUpdateFloatContainerWithScreenChangeFunc(updateFloatContainerWithScreenChangeCallback);
  rotationController.registerNotifyUpdateScenePanelWhenRotateFunc(notifyUpdateScenePanelWhenRotateCallback);
  rotationController.registerGetPanelNameFunc(getPanelNameCallback);
  rotationController.registerUpdateFloatAfterRotationAnimateFunc(updateFloatAfterRotationAnimateCallback);
  rotationController.registerUpdateBlackBackgroundStateFunc(updateBlackBackgroundStateCallback);
  rotationController.registerSetKeyboardRotationFlagFunc(setKeyboardRotationFlagCallback);
  rotationController.registerCoverSensorRotationFunc(coverSensorRotationCallback);
  rotationController.registerHandleFloatWhenExitSceneFunc(handleFloatWhenExitSceneCallback);
  rotationController.registerClearExitSceneNotifyRotationFunc(clearExitSceneNotifyRotationCallback);
  rotationController.registerGetMattesLockStateFunc(getMattesLockStateCallback);
}

function clearCount(): void {
  setExpandStartContainerSessionCallbackCount = 0;
  interruptPipAnimWithFloatRotationCallbackCount = 0;
  clearRecentStartNotifyRotationCallbackCount = 0;
  handleSplitScreenCallbackCount = 0;
  prepareRotationBeforeAnimationCallbackCount = 0;
  showDividerAfterRotationCallbackCount = 0;
  updateNeedScrollClipRotateFinishCallbackCount = 0;
  setFloatAnimateStatusCallbackCount = 0;
  showWallpaperAfterRotateCallbackCount = 0;
  updateFloatContainerWithScreenChangeCallbackCount = 0;
  notifyUpdateScenePanelWhenRotateCallbackCount = 0;
  getPanelNameCallbackCount = 0;
  updateFloatAfterRotationAnimateCallbackCount = 0;
  updateBlackBackgroundStateCallbackCount = 0;
  setKeyboardRotationFlagCallbackCount = 0;
  coverSensorRotationCallbackCount = 0;
  handleFloatWhenExitSceneCallbackCount = 0;
  clearExitSceneNotifyRotationCallbackCount = 0;
  getMattesLockStateCallbackCount = 0;
}

function buildScreenSession(): screenSessionManager.ScreenSession {
  return {
    screenId: -1,
    name: 'testScreen',
    on: (type: string, callback: Function): void => undefined,
    setScreenRotationLocked: (isLocked: boolean): void => undefined,
    loadContent: (path: string, context: ServiceExtensionContext, storage?: LocalStorage): void => undefined,
    setTouchEnabled: (isTouchEnabled: boolean): void => undefined,
    getScreenUIContext: (): UIContext => {
      return sceneSessionManager.getRootSceneUIContext();
    }
  };
}

function buildContainer(): SCBSceneContainerSession {
  let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 9624);
  let sceneSession: SCBSceneSession =
    new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
  return new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
}
