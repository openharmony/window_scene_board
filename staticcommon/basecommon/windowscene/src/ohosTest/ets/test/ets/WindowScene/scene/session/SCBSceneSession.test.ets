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
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  ArgumentMatchers,
  when,
  Level,
} from '@ohos/hypium';
import { SCBSceneInfo,
  SCBSceneSession,
  SCBSceneMemoryInfo,
  SCBScreenSession,
  SCBScreenProperty,
  SCBSceneMode,
  ScbNumber,
  SCBSessionCbType,
  SCBSessionRect,
  SCBSessionEventId,
  SCBSceneSessionManager,
  SCBScreenSessionManager,
  SCBSceneContainerSession,
  SCBSpecificSceneSessionList,
} from '../../../../../../../..';
import { DeviceHelper, SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { image } from '@kit.ImageKit';
import BundleManager from '@ohos.bundle.bundleManager';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { ReflectionUtils } from './ReflectionUtils';
import screenSessionManager from '@ohos.screenSessionManager';
import { AbilityConstant } from '@kit.AbilityKit';
import type { UIContext } from '@ohos.arkui.UIContext';
import { SCBWindowMovePointerPosition } from '../../../../../../../main/ets/scene/session/SCBSceneSession';
import {
  SceneDataOfMissionManagement,
  SceneStateOfBasic,
  SceneDataCategory,
  SceneStateCategory
} from '../../../../../../../main/ets/scene/SceneModuleIndex';
import {
  SessionDisplayChangeReason,
  SessionChangeInfo
} from '@ohos/windowscene';

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

interface WindowSceneConfig {
  uiType:string;
};
 
interface SCBWindowSceneConfigTest {
  windowSceneConfig: WindowSceneConfig;
};
const TAG = 'SCBSceneSession';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
 
enum SubWindowModalType {
  TYPE_UNDEFINED,
  TYPE_NORMAL,
  TYPE_DIALOG,
  TYPE_WINDOW_MODALITY,
  TYPE_TOAST,
  TYPE_APPLICATION_MODALITY
}

class SCBSceneSessionDataInner {
  supportWindowModes: BundleManager.SupportWindowMode[] = [];
  /**
   * Indicates whether the multi-window is being debugged. If true, force app support multi-window mode.
   */
  debugMultiWindow: boolean = false;
  /**
   * Offset X of the WindowScene associated with the session
   */
  windowOffsetX: number = 0;

  /**
   * Offset Y of the WindowScene associated with the session
   */
  windowOffsetY: number = 0;
  lastEventId: SCBSessionEventId = SCBSessionEventId.EVENT_UNDEFINED;

  nativeCacheRefAvailable: boolean = true; // after request destruction and clear cache will be unavailable.
}
 
interface SceneSessionTest {
  subWindowAppModalType: number;
  subWindowModalType: SubWindowModalType;
  persistentId: number;
};

export function SCBSceneSessionTest() {
  describe('SCBSceneSessionTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })
    it('getFocus', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

      expect(sceneSession.getFocused()).assertEqual(false);
      expect(sceneSession.getFocusable()).assertEqual(true);
    })

    it('getVisibility', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

      expect(sceneSession.getVisibility()).assertEqual(true);
      sceneSession.setVisibility(false);
      expect(sceneSession.getVisibility()).assertEqual(false);
    })

    it('updateFloatingScale', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      sceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FLOATING);
      sceneSession.updateFloatingScale(1.0);
      sceneSession.updateFloatingScale(1.0, false);
    })

    it('isInSceneMode', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

      let modes: SCBSceneMode[] = [SCBSceneMode.FULLSCREEN];
      expect(sceneSession.isInSceneMode()).assertEqual(false);
      expect(sceneSession.isInSceneMode(...modes)).assertEqual(true);
    })

    it('initFloatingSceneOnTransferSessionTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.width = 100;
      screenProperty.height = 100;
      scbSceneSession.initFloatingSceneOnTransferSession(screenProperty);
      expect(scbSceneSession.floatBorderRadius).assertEqual(0);
      expect(scbSceneSession.translateX).assertEqual(0);
      expect(scbSceneSession.translateY).assertEqual(0);
      expect(scbSceneSession.positionX.getPx()).assertEqual(0);
      expect(scbSceneSession.positionY.getPx()).assertEqual(0);
      expect(scbSceneSession.width.getPx()).assertEqual(100);
      expect(scbSceneSession.height.getPx()).assertEqual(100);
      expect(scbSceneSession.opacity).assertEqual(1);
      expect(scbSceneSession.scaleX).assertEqual(1);
      expect(scbSceneSession.scaleY).assertEqual(1);
      expect(scbSceneSession.sceneInfo.windowMode).assertEqual(SCBSceneMode.FULLSCREEN);
    })

    it('setNumberTest_1', 0, () => {
      let scbNum: ScbNumber = new ScbNumber(0);
      scbNum.setNumber(0);
      expect(scbNum.getPx()).assertEqual(0);
    })

    it('setNumberTest_2', 0, () => {
      let scbNum: ScbNumber = new ScbNumber(0);
      scbNum.setNumber(1);
      expect(scbNum.getPx()).assertEqual(1);
    })

    it('registerOnUpdateSessionLabelCallbackTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let callback: Function = () => {};
      scbSceneSession.registerOnUpdateSessionLabelCallback(callback);
      expect(scbSceneSession.sessionData.onUpdateSessionLabelCallback).assertEqual(callback);
    })

    it('registerOnWindowShadowEnableChangeCallbackTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let callback: Function = () => {};
      scbSceneSession.registerOnWindowShadowEnableChangeCallback(callback);
      expect(scbSceneSession.sessionData.onWindowShadowEnableChangeCallback).assertEqual(callback);
    })

    it('unRegisterOnWindowShadowEnableChangeCallbackTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let callback: Function = () => {};
      scbSceneSession.registerOnWindowShadowEnableChangeCallback(callback);
      expect(scbSceneSession.sessionData.onWindowShadowEnableChangeCallback).assertEqual(callback);
      scbSceneSession.unRegisterOnWindowShadowEnableChangeCallback();
      expect(scbSceneSession.sessionData.onWindowShadowEnableChangeCallback).assertNull();
    })

    it('registerOnUpdateSessionIconCallbackTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let callback: Function = () => {};
      scbSceneSession.registerOnUpdateSessionIconCallback(callback);
      expect(scbSceneSession.sessionData.onUpdateSessionIconCallback).assertEqual(callback);
    })

    it('unRegisterOnUpdateSessionLabelCallbackTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let callback: Function = () => {};
      scbSceneSession.registerOnUpdateSessionLabelCallback(callback);
      expect(scbSceneSession.sessionData.onUpdateSessionLabelCallback).assertEqual(callback);
      scbSceneSession.unRegisterOnUpdateSessionLabelCallback();
      expect(scbSceneSession.sessionData.onUpdateSessionLabelCallback).assertNull();
    })

    it('unRegisterOnUpdateSessionIconCallbackTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let callback: Function = () => {};
      scbSceneSession.registerOnUpdateSessionIconCallback(callback);
      expect(scbSceneSession.sessionData.onUpdateSessionIconCallback).assertEqual(callback);
      scbSceneSession.unRegisterOnUpdateSessionIconCallback();
      expect(scbSceneSession.sessionData.onUpdateSessionIconCallback).assertNull();
    })

    it('registerCreateSubSessionCallbackTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let callback: Function = () => {};
      scbSceneSession.registerCreateSubSessionCallback(callback);
      expect(scbSceneSession.sessionData.createSubSessionCallback).assertEqual(callback);
    })

    it('registerCreateDialogCallbackTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let callback: Function = () => {};
      scbSceneSession.registerCreateDialogCallback(callback);
      expect(scbSceneSession.sessionData.createDialogCallback).assertEqual(callback);
    })

    it('registerSessionTitleActionCallbackTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let result = -1;
      let callback: Function = () => {
        result = 1;
      };
      scbSceneSession.recover();
      scbSceneSession.registerSessionTitleActionCallback(callback);
      let callbackArray: Function[] | undefined = scbSceneSession.sessionTitleActionCallbackMap.get(0);
      expect(callbackArray).not().assertUndefined();
      expect(callbackArray![0]).assertEqual(callback);
      expect(result).assertEqual(1);
    })

    it('registerSessionRectChangeCallbackTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let callback: Function = () => {};
      scbSceneSession.registerSessionRectChangeCallback(callback);
      expect(scbSceneSession.sessionRectChangeCallbackMap.get(0)).assertEqual(callback);
    })

    it('unregisterSessionRectChangeCallbackTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let callback: Function = () => {};
      scbSceneSession.registerSessionRectChangeCallback(callback);
      expect(scbSceneSession.sessionRectChangeCallbackMap.get(0)).assertEqual(callback);
      scbSceneSession.unregisterSessionRectChangeCallback();
      expect(scbSceneSession.sessionRectChangeCallbackMap.get(0)).assertEqual(undefined);
    })

    it('registerNeedAvoidCallbackTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let callback: Function = () => {};
      scbSceneSession.registerNeedAvoidCallback(callback);
      expect(scbSceneSession.sessionData.needAvoidCallback).assertEqual(callback);
    })

    it('registerKeyboardOffsetCallbackTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let callback: Function = () => {};
      scbSceneSession.registerKeyboardOffsetCallback(callback);
      expect(scbSceneSession.sessionData.keyboardOffsetCallback).assertEqual(callback);
    })

    it('registerKeyboardOffsetCallbackTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let callback: Function = () => {};
      scbSceneSession.registerKeyboardOffsetCallback(callback);
      expect(scbSceneSession.sessionData.keyboardOffsetCallback).assertEqual(callback);
    })

    it('registerSessionTouchableChangeCallbackTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let callback: Function = () => {};
      scbSceneSession.registerSessionTouchableChangeCallback(callback);
      expect(scbSceneSession.sessionData.sessionTouchableChangeCallback).assertEqual(callback);
    })

    it('registerSessionShowWhenLockedChangeCallbackTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let callback: Function = () => {};
      scbSceneSession.registerSessionShowWhenLockedChangeCallback(callback);
      expect(scbSceneSession.sessionData.sessionShowWhenLockedChangeCallback).assertEqual(callback);
    })

    it('registerSessionSystemBarPropertyCallbackTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let callback: Function = () => {};
      scbSceneSession.registerSessionSystemBarPropertyCallback(callback);
      expect(scbSceneSession.sessionData.systemBarPropertyCallback).assertEqual(callback);
    })

    it('registerWindowDragHotAreaCallbackTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let callback: Function = () => {};
      scbSceneSession.registerWindowDragHotAreaCallback(callback);
      expect(scbSceneSession.windowDragHotAreaCallbackMap.get(0)).assertEqual(callback);
    })

    it('onTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let callback: Function = () => {};
      scbSceneSession.on(SCBSessionCbType.RECOVER, callback);
      expect(scbSceneSession.callbackMap.size).assertEqual(1);
      expect(scbSceneSession.callbackMap.get(SCBSessionCbType.RECOVER)).assertEqual(callback);
    })

    it('setFocusedTest01', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      expect(scbSceneSession.isFocused).assertFalse();
      scbSceneSession.setFocused(true);
      expect(scbSceneSession.isFocused).assertTrue();
    })

    it('setFocusedTest02', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      expect(scbSceneSession.isFocused).assertFalse();
      scbSceneSession.isFocusable = false;
      scbSceneSession.setFocused(true);
      expect(scbSceneSession.isFocused).assertFalse();
    })

    it('setTouchableTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      expect(scbSceneSession.isTouchable).assertTrue();
      scbSceneSession.setTouchable(true);
      expect(scbSceneSession.isFocused).assertFalse();
    })

    it('setFloatCornerRadiusConfigTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      expect(scbSceneSession.floatBorderRadius).assertEqual(0);
      SCBWindowSceneConfig.getInstance().windowSceneConfig.floatCornerRadius = 100;
      scbSceneSession.setFloatCornerRadiusConfig();
      expect(scbSceneSession.floatBorderRadius).assertEqual(0);
    })

    it('setWindowShadowConfigTest01', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      SCBWindowSceneConfig.getInstance().windowSceneConfig.focusedShadow.offsetX = 10;
      SCBWindowSceneConfig.getInstance().windowSceneConfig.focusedShadow.offsetY = 20;
      SCBWindowSceneConfig.getInstance().windowSceneConfig.focusedShadow.radius = 30;
      SCBWindowSceneConfig.getInstance().windowSceneConfig.unfocusedShadow.offsetX = 100;
      SCBWindowSceneConfig.getInstance().windowSceneConfig.unfocusedShadow.offsetY = 200;
      SCBWindowSceneConfig.getInstance().windowSceneConfig.unfocusedShadow.radius = 300;
      scbSceneSession.setWindowShadowConfig();
      expect(scbSceneSession.shadowConfig.offsetX).assertEqual(0);
      expect(scbSceneSession.shadowConfig.offsetY).assertEqual(0);
      expect(scbSceneSession.shadowConfig.radius).assertEqual(0);
      scbSceneSession.setFocused(true);
      scbSceneSession.setWindowShadowConfig();
      expect(scbSceneSession.shadowConfig.offsetX).assertEqual(0);
      expect(scbSceneSession.shadowConfig.offsetY).assertEqual(0);
      expect(scbSceneSession.shadowConfig.radius).assertEqual(0);
    })

    it('setWindowShadowConfigTest02', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      SCBWindowSceneConfig.getInstance().windowSceneConfig.focusedShadow.offsetX = 10;
      SCBWindowSceneConfig.getInstance().windowSceneConfig.focusedShadow.offsetY = 20;
      SCBWindowSceneConfig.getInstance().windowSceneConfig.focusedShadow.radius = 30;
      SCBWindowSceneConfig.getInstance().windowSceneConfig.unfocusedShadow.offsetX = 100;
      SCBWindowSceneConfig.getInstance().windowSceneConfig.unfocusedShadow.offsetY = 200;
      SCBWindowSceneConfig.getInstance().windowSceneConfig.unfocusedShadow.radius = 300;
      scbSceneSession.isHideShadow = true;
      scbSceneSession.setWindowShadowConfig();
      expect(scbSceneSession.shadowConfig.offsetX).assertEqual(0);
      expect(scbSceneSession.shadowConfig.offsetY).assertEqual(0);
      expect(scbSceneSession.shadowConfig.radius).assertEqual(0);
      scbSceneSession.setFocused(true);
      scbSceneSession.setWindowShadowConfig();
      expect(scbSceneSession.shadowConfig.offsetX).assertEqual(0);
      expect(scbSceneSession.shadowConfig.offsetY).assertEqual(0);
      expect(scbSceneSession.shadowConfig.radius).assertEqual(0);
    })

    it('setWindowShadowConfigTest03', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      SCBWindowSceneConfig.getInstance().windowSceneConfig.focusedShadow.offsetX = 10;
      SCBWindowSceneConfig.getInstance().windowSceneConfig.focusedShadow.offsetY = 20;
      SCBWindowSceneConfig.getInstance().windowSceneConfig.focusedShadow.radius = 30;
      SCBWindowSceneConfig.getInstance().windowSceneConfig.unfocusedShadow.offsetX = 100;
      SCBWindowSceneConfig.getInstance().windowSceneConfig.unfocusedShadow.offsetY = 200;
      SCBWindowSceneConfig.getInstance().windowSceneConfig.unfocusedShadow.radius = 300;
      scbSceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FLOATING);
      scbSceneSession.setWindowShadowConfig();
      expect(scbSceneSession.shadowConfig.offsetX).assertEqual(100);
      expect(scbSceneSession.shadowConfig.offsetY).assertEqual(200);
      expect(scbSceneSession.shadowConfig.radius).assertEqual(300);
      scbSceneSession.setFocused(true);
      scbSceneSession.setWindowShadowConfig();
      expect(scbSceneSession.shadowConfig.offsetX).assertEqual(10);
      expect(scbSceneSession.shadowConfig.offsetY).assertEqual(20);
      expect(scbSceneSession.shadowConfig.radius).assertEqual(30);
    })

    it('clearImmersiveDataTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      scbSceneSession.sessionData._isSystemBarPropertyApplied = true;
      scbSceneSession.sessionData.isSetStatusBarColor = true;
      scbSceneSession.sessionData.isSetStatusBarEnable = true;
      scbSceneSession.clearImmersiveData();
      expect(scbSceneSession.sessionData._isSystemBarPropertyApplied).assertFalse();
      expect(scbSceneSession.sessionData.isSetStatusBarColor).assertFalse();
      expect(scbSceneSession.sessionData.isSetStatusBarEnable).assertFalse();
    })

    it('setIsClearSessionTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      expect(scbSceneSession.sceneInfo.isClearSession).assertFalse();
      scbSceneSession.setIsClearSession(true);
      expect(scbSceneSession.sceneInfo.isClearSession).assertTrue();
    })

    it('setSizeTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      expect(scbSceneSession.width.getPx()).assertEqual(0);
      expect(scbSceneSession.height.getPx()).assertEqual(0);
      scbSceneSession.setSize(new ScbNumber(10), new ScbNumber(20));
      expect(scbSceneSession.width.getPx()).assertEqual(10);
      expect(scbSceneSession.height.getPx()).assertEqual(20);
    })

    it('setPosTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      expect(scbSceneSession.positionX.getPx()).assertEqual(0);
      expect(scbSceneSession.positionY.getPx()).assertEqual(0);
      scbSceneSession.setPos(new ScbNumber(10), new ScbNumber(20));
      expect(scbSceneSession.positionX.getPx()).assertEqual(10);
      expect(scbSceneSession.positionY.getPx()).assertEqual(20);
    })

    it('setTranTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      expect(scbSceneSession.translateX).assertEqual(0);
      expect(scbSceneSession.translateY).assertEqual(0);
      scbSceneSession.setTran(10, 20);
      expect(scbSceneSession.translateX).assertEqual(10);
      expect(scbSceneSession.translateY).assertEqual(20);
    })

    it('initSceneStateTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      scbSceneSession.initSceneState();
      expect(scbSceneSession.translateX).assertEqual(0);
      expect(scbSceneSession.translateY).assertEqual(0);
      expect(scbSceneSession.scaleX).assertEqual(1);
      expect(scbSceneSession.scaleY).assertEqual(1);
      expect(scbSceneSession.opacity).assertEqual(1.0);
    })

    it('saveLastRectTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      scbSceneSession.currRect = new SCBSessionRect(10, 20, 30, 40);
      scbSceneSession.saveLastRect();
      expect(scbSceneSession.translateX).assertEqual(0);
      expect(scbSceneSession.translateY).assertEqual(0);
      expect(scbSceneSession.scaleX).assertEqual(1);
      expect(scbSceneSession.scaleY).assertEqual(1);
      expect(scbSceneSession.opacity).assertEqual(1.0);
    })

    it('saveSessionMovingStateTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      expect(scbSceneSession.isSessionMoving).assertFalse();
      scbSceneSession.saveSessionMovingState(true);
      expect(scbSceneSession.isSessionMoving).assertTrue();
    })

    it('initFloatingSceneOnTransferSessionTest01', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.width = 10;
      screenProperty.height = 20;
      scbSceneSession.initFloatingSceneOnTransferSession(screenProperty, false);
      expect(scbSceneSession.floatBorderRadius).assertEqual(0);
      expect(scbSceneSession.translateX).assertEqual(0);
      expect(scbSceneSession.translateY).assertEqual(0);
      expect(scbSceneSession.positionX.getPx()).assertEqual(0);
      expect(scbSceneSession.positionY.getPx()).assertEqual(0);
      expect(scbSceneSession.visibility).assertTrue();
      expect(scbSceneSession.opacity).assertEqual(1);
      expect(scbSceneSession.scaleX).assertEqual(1);
      expect(scbSceneSession.scaleY).assertEqual(1);
      expect(scbSceneSession.width.getPx()).assertEqual(0);
      expect(scbSceneSession.height.getPx()).assertEqual(0);
    })

    it('initFloatingSceneOnTransferSessionTest02', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.width = 10;
      screenProperty.height = 20;
      scbSceneSession.initFloatingSceneOnTransferSession(screenProperty, true);
      expect(scbSceneSession.floatBorderRadius).assertEqual(0);
      expect(scbSceneSession.translateX).assertEqual(0);
      expect(scbSceneSession.translateY).assertEqual(0);
      expect(scbSceneSession.positionX.getPx()).assertEqual(0);
      expect(scbSceneSession.positionY.getPx()).assertEqual(0);
      expect(scbSceneSession.visibility).assertTrue();
      expect(scbSceneSession.opacity).assertEqual(1);
      expect(scbSceneSession.scaleX).assertEqual(1);
      expect(scbSceneSession.scaleY).assertEqual(1);
      expect(scbSceneSession.width.getPx()).assertEqual(10);
      expect(scbSceneSession.height.getPx()).assertEqual(20);
    })

    it('setZOrderTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      expect(scbSceneSession.sessionInfo.zOrder).assertEqual(0);
      scbSceneSession.setZOrder(10);
      expect(scbSceneSession.sessionInfo.zOrder).assertEqual(10);
    })

    it('setTemporarilyShowWhenLockedTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      expect(scbSceneSession.sessionData.isTemporarilyShowWhenLocked).assertFalse();
      scbSceneSession.setTemporarilyShowWhenLocked(true);
      expect(scbSceneSession.sessionData.isTemporarilyShowWhenLocked).assertTrue();
    })

    it('setIsClosingTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      expect(scbSceneSession.sessionData.isClosing).assertFalse();
      scbSceneSession.setIsClosing(true);
      expect(scbSceneSession.sessionData.isClosing).assertTrue();
    })

    it('setShowAboveKeyguardTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      expect(scbSceneSession.sessionData.isShowAboveKeyguard).assertFalse();
      scbSceneSession.setShowAboveKeyguard(true);
      expect(scbSceneSession.sessionData.isShowAboveKeyguard).assertTrue();
    })

    it('setFocusableTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      expect(scbSceneSession.getFocusable()).assertTrue();
      scbSceneSession.setFocusable(false);
      expect(scbSceneSession.getFocusable()).assertFalse();
    })

    it('setVisibilityTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      expect(scbSceneSession.getVisibility()).assertTrue();
      scbSceneSession.setVisibility(false);
      expect(scbSceneSession.getVisibility()).assertFalse();
    })

    it('setVisibilityTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      expect(scbSceneSession.getVisibility()).assertTrue();
      scbSceneSession.setVisibility(false);
      expect(scbSceneSession.getVisibility()).assertFalse();
    })

    it('calcSessionRectAfterRotationTest01', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      scbSceneSession.width = new ScbNumber(10);
      scbSceneSession.height = new ScbNumber(20);
      scbSceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      scbSceneSession.calcSessionRectAfterRotation(screenProperty);
      expect(scbSceneSession.width.getPx()).assertEqual(20);
      expect(scbSceneSession.height.getPx()).assertEqual(10);
    })

    it('calcSessionRectAfterRotationTest02', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      scbSceneSession.width = new ScbNumber(10);
      scbSceneSession.height = new ScbNumber(20);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.width = 1;
      screenProperty.height = 2
      scbSceneSession.calcSessionRectAfterRotation(screenProperty);
      expect(scbSceneSession.width.getPx()).assertEqual(20);
      expect(scbSceneSession.height.getPx()).assertEqual(10);
    })

    it('calcSessionRectAfterRotationTest03', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      scbSceneSession.width = new ScbNumber(10);
      scbSceneSession.height = new ScbNumber(20);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.width = 100;
      screenProperty.height = 200;
      scbSceneSession.calcSessionRectAfterRotation(screenProperty);
      expect(scbSceneSession.width.getPx()).assertEqual(20);
      expect(scbSceneSession.height.getPx()).assertEqual(10);
    })

    it('calcSessionRectAfterRotationTest04', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      scbSceneSession.width = new ScbNumber(10);
      scbSceneSession.height = new ScbNumber(20);
      scbSceneSession.positionX = new ScbNumber(-1);
      scbSceneSession.positionY = new ScbNumber(-1);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      scbSceneSession.calcSessionRectAfterRotation(screenProperty);
      expect(scbSceneSession.positionX.getPx()).assertEqual(-1);
      expect(scbSceneSession.positionY.getPx()).assertEqual(-1);
    })

    it('calcSessionRectAfterRotationTest05', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      scbSceneSession.width = new ScbNumber(10);
      scbSceneSession.height = new ScbNumber(20);
      scbSceneSession.positionX = new ScbNumber(1);
      scbSceneSession.positionY = new ScbNumber(1);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.width = 10;
      screenProperty.height = 20;
      scbSceneSession.calcSessionRectAfterRotation(screenProperty);
      expect(scbSceneSession.positionX.getPx()).assertEqual(1);
      expect(scbSceneSession.positionY.getPx()).assertEqual(1);
    })

    it('calcSessionRectAfterRotationTest06', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      scbSceneSession.width = new ScbNumber(10);
      scbSceneSession.height = new ScbNumber(20);
      scbSceneSession.positionX = new ScbNumber(1);
      scbSceneSession.positionY = new ScbNumber(1);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.width = 30;
      screenProperty.height = 30;
      scbSceneSession.calcSessionRectAfterRotation(screenProperty);
      expect(scbSceneSession.positionX.getPx()).assertEqual(1);
      expect(scbSceneSession.positionY.getPx()).assertEqual(1);
    })

    it('getTransitionAnimationConfigTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      expect(scbSceneSession.getTransitionAnimationConfig(sceneSessionManager.WindowTransitionType.DESTROY)).assertUndefined();
      let animation: sceneSessionManager.TransitionAnimation = {
        config: {
          curve: sceneSessionManager.WindowAnimationCurve.LINEAR,
          duration: 3000
        },
        opacity: 0
      }
      scbSceneSession.sessionData.transitionAnimationConfig.set(sceneSessionManager.WindowTransitionType.DESTROY, animation);
      expect(scbSceneSession.getTransitionAnimationConfig(sceneSessionManager.WindowTransitionType.DESTROY)).not().assertUndefined();
    })

    it('calcSessionRectAfterActiveModeChangeTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      scbSceneSession.width = new ScbNumber(10);
      scbSceneSession.height = new ScbNumber(20);
      let oldProperty: SCBScreenProperty = new SCBScreenProperty();
      oldProperty.width = 1;
      oldProperty.height = 2;
      let newProperty: SCBScreenProperty = new SCBScreenProperty();
      newProperty.width = 10;
      newProperty.height = 20;
      scbSceneSession.calcSessionRectAfterActiveModeChange(oldProperty, newProperty);
      expect(scbSceneSession.width.getPx()).assertEqual(100);
      expect(scbSceneSession.height.getPx()).assertEqual(200);
    })

    it('calcSessionRectAfterFoldChangeTest01', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      scbSceneSession.width = new ScbNumber(100);
      scbSceneSession.height = new ScbNumber(200);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.width = 10;
      screenProperty.height = 20;
      screenProperty.rotation = 30;
      scbSceneSession.calcSessionRectAfterFoldChange(screenProperty);
      expect(scbSceneSession.width.getPx()).assertEqual(10);
      expect(scbSceneSession.height.getPx()).assertEqual(20);
      expect(scbSceneSession.currentRotation).assertEqual(30);
    })

    it('calcSessionRectAfterFoldChangeTest02', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      scbSceneSession.width = new ScbNumber(100);
      scbSceneSession.height = new ScbNumber(200);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.width = 300;
      screenProperty.height = 300;
      scbSceneSession.calcSessionRectAfterFoldChange(screenProperty);
      expect(scbSceneSession.width.getPx()).assertEqual(100);
      expect(scbSceneSession.height.getPx()).assertEqual(200);
    })

    it('calcSessionRectAfterFoldChangeTest03', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      scbSceneSession.width = new ScbNumber(100);
      scbSceneSession.height = new ScbNumber(200);
      scbSceneSession.positionX = new ScbNumber(-1);
      scbSceneSession.positionY = new ScbNumber(-1);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.width = 300;
      screenProperty.height = 300;
      scbSceneSession.calcSessionRectAfterFoldChange(screenProperty);
      expect(scbSceneSession.positionX.getPx()).assertEqual(0);
      expect(scbSceneSession.positionY.getPx()).assertEqual(0);
    })

    it('calcSessionRectAfterFoldChangeTest04', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      scbSceneSession.width = new ScbNumber(100);
      scbSceneSession.height = new ScbNumber(200);
      scbSceneSession.positionX = new ScbNumber(10);
      scbSceneSession.positionY = new ScbNumber(10);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.width = 100;
      screenProperty.height = 200;
      scbSceneSession.calcSessionRectAfterFoldChange(screenProperty);
      expect(scbSceneSession.positionX.getPx()).assertEqual(0);
      expect(scbSceneSession.positionY.getPx()).assertEqual(0);
    })

    it('calcSessionRectAfterFoldChangeTest05', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      scbSceneSession.width = new ScbNumber(100);
      scbSceneSession.height = new ScbNumber(200);
      scbSceneSession.positionX = new ScbNumber(10);
      scbSceneSession.positionY = new ScbNumber(10);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.width = 300;
      screenProperty.height = 300;
      scbSceneSession.calcSessionRectAfterFoldChange(screenProperty);
      expect(scbSceneSession.positionX.getPx()).assertEqual(10);
      expect(scbSceneSession.positionY.getPx()).assertEqual(10);
    })

    it('updateRectTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let lastRect: SCBSessionRect = scbSceneSession.currRect;
      scbSceneSession.updateRect(new ScbNumber(10), new ScbNumber(20), new ScbNumber(30), new ScbNumber(40));
      expect(scbSceneSession.currRect.left.getPx()).assertEqual(10);
      expect(scbSceneSession.currRect.top.getPx()).assertEqual(20);
      expect(scbSceneSession.currRect.width.getPx()).assertEqual(30);
      expect(scbSceneSession.currRect.height.getPx()).assertEqual(40);
      expect(scbSceneSession.currRect === lastRect).assertFail();
    })

    it('updateRectTest01', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let currRectLinked: boolean = true;
      scbSceneSession.updateRect(new ScbNumber(10), new ScbNumber(20), new ScbNumber(30), new ScbNumber(40),
        sceneSessionManager.SessionSizeChangeReason.DRAG_END, currRectLinked);
      expect(scbSceneSession.currRect.left.getPx()).assertEqual(10);
      expect(scbSceneSession.currRect.top.getPx()).assertEqual(20);
      expect(scbSceneSession.currRect.width.getPx()).assertEqual(30);
      expect(scbSceneSession.currRect.height.getPx()).assertEqual(40);
    })

    it('isInSceneModeTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      expect(scbSceneSession.isInSceneMode(SCBSceneMode.UNDEFINED)).assertFalse();
      expect(scbSceneSession.isInSceneMode(SCBSceneMode.UNDEFINED, SCBSceneMode.FULLSCREEN)).assertTrue();
      expect(scbSceneSession.isInSceneMode(SCBSceneMode.FULLSCREEN)).assertTrue();
      expect(scbSceneSession.isInSceneMode(SCBSceneMode.FULLSCREEN, SCBSceneMode.PRIMARY)).assertTrue();
    })

    it('registerInteractiveStateChangeCallbackTest01', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let isCalled = false;
      let stateValue = false;
      let callback = (state: boolean) => {
        isCalled = true;
        stateValue = state;
      };
      scbSceneSession.registerInteractiveStateChangeCallback(callback);
      scbSceneSession.notifyInteractiveStateChange(true);
      expect(isCalled).assertTrue();
      expect(stateValue).assertTrue();
    })

    it('unregisterInteractiveStateChangeCallbackTest02', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let isCalled = false;
      let stateValue = false;
      let callback = (state: boolean) => {
        isCalled = true;
        stateValue = state;
      };
      scbSceneSession.registerInteractiveStateChangeCallback(callback);
      scbSceneSession.unregisterInteractiveStateChangeCallback();
      scbSceneSession.notifyInteractiveStateChange(true);
      expect(isCalled).assertFalse();
      expect(stateValue).assertFalse();
    })

    it('addRefCountTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      expect(scbSceneSession.getRefCount()).assertEqual(0);
      scbSceneSession.addRefCount();
      expect(scbSceneSession.getRefCount()).assertEqual(1);
      scbSceneSession.addRefCount();
      expect(scbSceneSession.getRefCount()).assertEqual(2);
      scbSceneSession.addRefCount();
      expect(scbSceneSession.getRefCount()).assertEqual(3);
    })

    it('decRefCountTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      scbSceneSession.addRefCount();
      scbSceneSession.addRefCount();
      expect(scbSceneSession.getRefCount()).assertEqual(2);
      scbSceneSession.decRefCount();
      expect(scbSceneSession.getRefCount()).assertEqual(1);
      scbSceneSession.decRefCount();
      expect(scbSceneSession.getRefCount()).assertEqual(0);
    })

    it('addRefCountTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      expect(scbSceneSession.getRefCount()).assertEqual(0);
      scbSceneSession.addRefCount();
      expect(scbSceneSession.getRefCount()).assertEqual(1);
      scbSceneSession.addRefCount();
      expect(scbSceneSession.getRefCount()).assertEqual(2);
      scbSceneSession.addRefCount();
      expect(scbSceneSession.getRefCount()).assertEqual(3);
    })

    it("registerSessionFocusedChangeCallbackTest", 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let isCalled = false;
      let isFocused = false;
      let callback = (focused: boolean) => {
        isCalled = true;
        isFocused = focused;
      };
      scbSceneSession.registerSessionFocusedChangeCallback(callback);
      scbSceneSession.setFocused(true);
      expect(isCalled).assertTrue();
      expect(isFocused).assertTrue();
    })

    it("unRegisterSessionFocusedChangeCallbackTest", 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let isCalled = false;
      let isFocused = false;
      let callback = (focused: boolean) => {
        isCalled = true;
        isFocused = focused;
      };
      scbSceneSession.registerInteractiveStateChangeCallback(callback);
      scbSceneSession.unregisterInteractiveStateChangeCallback();
      scbSceneSession.setFocused(true);
      expect(isCalled).assertFalse();
      expect(isFocused).assertFalse();
    })

    it('unRegisterAllTest01', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let func = () => {};
      scbSceneSession.sessionRectChangeCallbackMap.set(0, func);
      scbSceneSession.sessionData.createDialogCallback = func;
      scbSceneSession.sessionData.needAvoidCallback = func;
      scbSceneSession.sessionData.sessionTouchableChangeCallback = func;
      scbSceneSession.windowDragHotAreaCallbackMap.set(0, func);
      scbSceneSession.sessionData.onUpdateSessionIconCallback = func;
      scbSceneSession.unRegisterAll();
      expect(scbSceneSession.sessionRectChangeCallbackMap.get(0)).assertEqual(undefined);
      expect(scbSceneSession.sessionData.createDialogCallback).assertNull();
      expect(scbSceneSession.sessionData.needAvoidCallback).assertNull();
      expect(scbSceneSession.sessionData.sessionTouchableChangeCallback).assertNull();
      expect(scbSceneSession.windowDragHotAreaCallbackMap.get(0)).assertEqual(undefined);
      expect(scbSceneSession.sessionData.onUpdateSessionIconCallback).assertNull();
    })

    it('unRegisterAllTest02', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      scbSceneSession.addRefCount();
      let func = () => {};
      scbSceneSession.sessionRectChangeCallbackMap.set(0, func);
      scbSceneSession.sessionData.createDialogCallback = func;
      scbSceneSession.sessionData.needAvoidCallback = func;
      scbSceneSession.sessionData.sessionTouchableChangeCallback = func;
      scbSceneSession.windowDragHotAreaCallbackMap.set(0, func);
      scbSceneSession.sessionData.onUpdateSessionIconCallback = func;
      scbSceneSession.unRegisterAll();
      expect(scbSceneSession.sessionRectChangeCallbackMap.get(0)).assertEqual(func);
      expect(scbSceneSession.sessionData.createDialogCallback).assertEqual(func);
      expect(scbSceneSession.sessionData.needAvoidCallback).assertEqual(func);
      expect(scbSceneSession.sessionData.sessionTouchableChangeCallback).assertEqual(func);
      expect(scbSceneSession.windowDragHotAreaCallbackMap.get(0)).assertEqual(func);
      expect(scbSceneSession.sessionData.onUpdateSessionIconCallback).assertEqual(func);
    })

    it('isInSplitTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      scbSceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.PRIMARY);
      expect(scbSceneSession.isInSplit()).assertTrue();
      scbSceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.SECONDARY);
      expect(scbSceneSession.isInSplit()).assertTrue();
      scbSceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.UNDEFINED);
      expect(scbSceneSession.isInSplit()).assertFalse();
      scbSceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
      expect(scbSceneSession.isInSplit()).assertFalse();
      scbSceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FLOATING);
      expect(scbSceneSession.isInSplit()).assertFalse();
      scbSceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.PIP);
      expect(scbSceneSession.isInSplit()).assertFalse();
    })

    it('isInFloatTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      scbSceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.UNDEFINED);
      expect(scbSceneSession.isInFloat()).assertFalse();
      scbSceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FLOATING);
      expect(scbSceneSession.isInFloat()).assertTrue();
      scbSceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.PIP);
      expect(scbSceneSession.isInFloat()).assertFalse();
    })

    it('setStatusBarEnableTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      expect(scbSceneSession.sessionData.isSetStatusBarEnable).assertFalse();
      scbSceneSession.setStatusBarEnable(true);
      expect(scbSceneSession.sessionData.isSetStatusBarEnable).assertTrue();
    })

    it('setIsSetStatusBarColorTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      expect(scbSceneSession.sessionData.isSetStatusBarColor).assertFalse();
      scbSceneSession.setIsSetStatusBarColor(true);
      expect(scbSceneSession.sessionData.isSetStatusBarColor).assertTrue();
    })

    it('setIsDisplayLandTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      expect(scbSceneSession.sessionData.isDisplayLand).assertFalse();
      scbSceneSession.setIsDisplayLand(true);
      expect(scbSceneSession.sessionData.isDisplayLand).assertTrue();
    })

    it('splitSwitchTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      sceneInfo.screenId = 0;
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let actionId = SCBSessionEventId.EVENT_UNDEFINED;
      let callback: Function = (actId: number) => {
        actionId = actId;
      };
      scbSceneSession.registerSessionTitleActionCallback(callback, sceneInfo.screenId);
      scbSceneSession.splitSwitch();
      expect(actionId).assertEqual(SCBSessionEventId.EVENT_SPLIT_SWITCH);
      scbSceneSession.sceneInfo.screenId = 1;
      actionId = SCBSessionEventId.EVENT_UNDEFINED;
      scbSceneSession.splitSwitch();
      expect(actionId).assertEqual(SCBSessionEventId.EVENT_UNDEFINED);
    });

    it('splitPositionRecoverTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      sceneInfo.screenId = 0;
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let actionId = SCBSessionEventId.EVENT_UNDEFINED;
      let callback: Function = (actId: number) => {
        actionId = actId;
      };
      scbSceneSession.registerSessionTitleActionCallback(callback, sceneInfo.screenId);
      scbSceneSession.splitPositionRecover();
      expect(actionId).assertEqual(SCBSessionEventId.EVENT_SPLIT_POSITION_RECOVER);
      scbSceneSession.sceneInfo.screenId = 1;
      actionId = SCBSessionEventId.EVENT_UNDEFINED;
      scbSceneSession.splitPositionRecover();
      expect(actionId).assertEqual(SCBSessionEventId.EVENT_UNDEFINED);
    });

    it('splitStateRestorationTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      sceneInfo.screenId = 0;
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let actionId = SCBSessionEventId.EVENT_UNDEFINED;
      let callback: Function = (actId: number) => {
        actionId = actId;
      };
      scbSceneSession.registerSessionTitleActionCallback(callback, sceneInfo.screenId);
      scbSceneSession.splitStateRestoration();
      expect(actionId).assertEqual(SCBSessionEventId.EVENT_SPLIT_STATE_RESTORATION);
      scbSceneSession.sceneInfo.screenId = 1;
      actionId = SCBSessionEventId.EVENT_UNDEFINED;
      scbSceneSession.splitStateRestoration();
      expect(actionId).assertEqual(SCBSessionEventId.EVENT_UNDEFINED);
    });

    it('maximizeTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      sceneInfo.screenId = 0;
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let actionId = SCBSessionEventId.EVENT_UNDEFINED;
      let callback: Function = (actId: number) => {
        actionId = actId;
      };
      scbSceneSession.registerSessionTitleActionCallback(callback, sceneInfo.screenId);
      scbSceneSession.maximize();
      expect(actionId).assertEqual(SCBSessionEventId.EVENT_MAXIMIZE);
      scbSceneSession.sceneInfo.screenId = 1;
      actionId = SCBSessionEventId.EVENT_UNDEFINED;
      scbSceneSession.maximize();
      expect(actionId).assertEqual(SCBSessionEventId.EVENT_UNDEFINED);
    });

    it('maximizeFloatingTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      sceneInfo.screenId = 0;
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let actionId = SCBSessionEventId.EVENT_UNDEFINED;
      let callback: Function = (actId: number) => {
        actionId = actId;
      };
      scbSceneSession.registerSessionTitleActionCallback(callback, sceneInfo.screenId);
      scbSceneSession.maximizeFloating();
      expect(actionId).assertEqual(SCBSessionEventId.EVENT_MAXIMIZE_FLOATING);
      scbSceneSession.sceneInfo.screenId = 1;
      actionId = SCBSessionEventId.EVENT_UNDEFINED;
      scbSceneSession.maximizeFloating();
      expect(actionId).assertEqual(SCBSessionEventId.EVENT_UNDEFINED);
    });

    it('recoverTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      sceneInfo.screenId = 0;
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let actionId = SCBSessionEventId.EVENT_UNDEFINED;
      let callback: Function = (actId: number) => {
        actionId = actId;
      };
      scbSceneSession.registerSessionTitleActionCallback(callback, sceneInfo.screenId);
      scbSceneSession.recover();
      expect(actionId).assertEqual(SCBSessionEventId.EVENT_RECOVER);
      scbSceneSession.sceneInfo.screenId = 1;
      actionId = SCBSessionEventId.EVENT_UNDEFINED;
      scbSceneSession.recover();
      expect(actionId).assertEqual(SCBSessionEventId.EVENT_UNDEFINED);
    });

    it('splitSecondaryTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      sceneInfo.screenId = 0;
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let actionId = SCBSessionEventId.EVENT_UNDEFINED;
      let callback: Function = (actId: number) => {
        actionId = actId;
      };
      scbSceneSession.registerSessionTitleActionCallback(callback, sceneInfo.screenId);
      scbSceneSession.splitSecondary();
      expect(actionId).assertEqual(SCBSessionEventId.EVENT_SPLIT_SECONDARY);
      scbSceneSession.sceneInfo.screenId = 1;
      actionId = SCBSessionEventId.EVENT_UNDEFINED;
      scbSceneSession.splitSecondary();
      expect(actionId).assertEqual(SCBSessionEventId.EVENT_UNDEFINED);
    });

    it('splitPrimaryTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      sceneInfo.screenId = 0;
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let actionId = SCBSessionEventId.EVENT_UNDEFINED;
      let callback: Function = (actId: number) => {
        actionId = actId;
      };
      scbSceneSession.registerSessionTitleActionCallback(callback, sceneInfo.screenId);
      scbSceneSession.splitPrimary();
      expect(actionId).assertEqual(SCBSessionEventId.EVENT_SPLIT_PRIMARY);
      scbSceneSession.sceneInfo.screenId = 1;
      actionId = SCBSessionEventId.EVENT_UNDEFINED;
      scbSceneSession.splitPrimary();
      expect(actionId).assertEqual(SCBSessionEventId.EVENT_UNDEFINED);
    });

    it('onSessionRectChangeTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      sceneInfo.screenId = 0;
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let rect :sceneSessionManager.SessionRect = {posX_ : 100, posY_ : 200, width_ : 300, height_ : 400};
      let reason :sceneSessionManager.SessionSizeChangeReason = sceneSessionManager.SessionSizeChangeReason.MOVE;
      let displayId = -1;
      let result = -1;
      let callback: Function = () => {
        result = 1;
      };
      let callback2: Function = () => {
        result = 2;
      };
      scbSceneSession.registerSessionRectChangeCallback(callback, sceneInfo.screenId);
      ReflectionUtils.useFunc(scbSceneSession, 'onSessionRectChange', rect, reason, displayId);
      expect(result).assertEqual(1);
      displayId = 1;
      scbSceneSession.registerSessionRectChangeCallback(callback2, displayId);
      ReflectionUtils.useFunc(scbSceneSession, 'onSessionRectChange', rect, reason, displayId);
      expect(result).assertEqual(2);
    });

    it('onPcAppInPadSessionRectChangeTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      sceneInfo.screenId = 0;
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.width = 2000;
      screenProperty.height = 1000;
      let containerSession = new SCBSceneContainerSession(scbSceneSession, screenProperty);
      let rect :sceneSessionManager.SessionRect = {posX_ : 100, posY_ : 200, width_ : 300, height_ : 400};
      let reason :sceneSessionManager.SessionSizeChangeReason = sceneSessionManager.SessionSizeChangeReason.RESIZE;
      let mocker: MockKit = new MockKit();
      let obj = SCBSceneSessionManager.getInstance();
      let mockFunc: Function = mocker.mockFunc(obj, obj.getSceneContainerSessionFromScenePanel);
      when(mockFunc)(0).afterReturn(containerSession);
      containerSession.isFloat = true;
      ReflectionUtils.useFunc(scbSceneSession, 'processPcAppResize', rect, reason);
      expect(containerSession.width.getPx()).assertEqual(rect.width_);
    });

    it('createToSceneInfoTest', 0, () => {
      let cSceneInfo: sceneSessionManager.SceneInfo = {
        bundleName: 'bundleName_createToSceneInfoTest',
        moduleName: 'moduleName_createToSceneInfoTest',
        abilityName: "abilityName_createToSceneInfoTest",
        appIndex: 1,
        persistentId: 1001,
        isCalledRightlyByCallerId: true
      };
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo(cSceneInfo.bundleName,
        cSceneInfo.moduleName, cSceneInfo.abilityName, cSceneInfo.appIndex);
      let cSceneSession: sceneSessionManager.SceneSession = sceneSessionManager.requestSceneSession(scbSceneInfo);
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(cSceneSession, scbSceneInfo);

      const toSceneInfo: SCBSceneInfo = ReflectionUtils.useFunc(scbSceneSession, 'createToSceneInfo', cSceneInfo);
      expect(toSceneInfo.bundleName).assertEqual(cSceneInfo.bundleName);
      expect(toSceneInfo.moduleName).assertEqual(cSceneInfo.moduleName);
      expect(toSceneInfo.abilityName).assertEqual(cSceneInfo.abilityName);
      expect(toSceneInfo.appIndex).assertEqual(cSceneInfo.appIndex);
      expect(toSceneInfo.isCalledRightlyByCallerId).assertEqual(cSceneInfo.isCalledRightlyByCallerId);

      cSceneInfo.windowMode = AbilityConstant.WindowMode.WINDOW_MODE_FULLSCREEN;
      const toSceneInfo2: SCBSceneInfo = ReflectionUtils.useFunc(scbSceneSession, 'createToSceneInfo', cSceneInfo);
      expect(toSceneInfo2.windowMode).assertEqual(cSceneInfo.windowMode);

      cSceneInfo.windowMode = AbilityConstant.WindowMode.WINDOW_MODE_FLOATING;
      const toSceneInfo3: SCBSceneInfo = ReflectionUtils.useFunc(scbSceneSession, 'createToSceneInfo', cSceneInfo);
      expect(toSceneInfo3.windowMode).assertEqual(cSceneInfo.windowMode);

      cSceneInfo.windowMode = AbilityConstant.WindowMode.WINDOW_MODE_SPLIT_PRIMARY;
      const toSceneInfo4: SCBSceneInfo = ReflectionUtils.useFunc(scbSceneSession, 'createToSceneInfo', cSceneInfo);
      expect(toSceneInfo4.windowMode).assertEqual(cSceneInfo.windowMode);

      cSceneInfo.windowMode = AbilityConstant.WindowMode.WINDOW_MODE_SPLIT_SECONDARY;
      const toSceneInfo5: SCBSceneInfo = ReflectionUtils.useFunc(scbSceneSession, 'createToSceneInfo', cSceneInfo);
      expect(toSceneInfo5.windowMode).assertEqual(cSceneInfo.windowMode);
    });

    it('onPendingSceneSessionActivationTest', 0, () => {
      let cSceneInfo: sceneSessionManager.SceneInfo = {
        bundleName: 'bundleName',
        moduleName: 'moduleName',
        abilityName: "abilityName",
        appIndex: 1
      };
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let cSceneSession: sceneSessionManager.SceneSession = sceneSessionManager.requestSceneSession(scbSceneInfo);
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(cSceneSession, scbSceneInfo);

      const managerInstance = SCBSceneSessionManager.getInstance();
      ReflectionUtils.useFunc(scbSceneSession, 'onPendingSceneSessionActivation', cSceneInfo);

      cSceneInfo.callState = 1;
      ReflectionUtils.useFunc(scbSceneSession, 'onPendingSceneSessionActivation', cSceneInfo);
      cSceneInfo.callState = 0;

      let mocker: MockKit = new MockKit();
      let onPendingCastScene: Function = mocker.mockFunc(managerInstance, managerInstance.onPendingCastScene);
      when(onPendingCastScene)(ArgumentMatchers.any).afterReturn(true);
      ReflectionUtils.useFunc(scbSceneSession, 'onPendingSceneSessionActivation', cSceneInfo);
      when(onPendingCastScene)(ArgumentMatchers.any).afterReturn(false);

      cSceneSession.screenId = managerInstance.mainScreenId + 1;
      let hasVirtualScreenStartSceneFunc: Function = mocker.mockFunc(
        managerInstance, managerInstance.hasVirtualScreenStartSceneFunc);
      when(hasVirtualScreenStartSceneFunc)(ArgumentMatchers.any).afterReturn(true);
      ReflectionUtils.useFunc(scbSceneSession, 'onPendingSceneSessionActivation', cSceneInfo);
      when(hasVirtualScreenStartSceneFunc)(ArgumentMatchers.any).afterReturn(false);
      cSceneSession.screenId = managerInstance.mainScreenId;

      let screenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      let getScreenSession: Function = mocker.mockFunc(
        screenSessionManager, screenSessionManager.getScreenSession);
      let testPtr : UIContext;
      let screenSession: screenSessionManager.ScreenSession = {
        screenId: 101,
        name: 'testScreen',
        on: (): void => {},
        setScreenRotationLocked: (): void => {},
        loadContent: (): void => {},
        setTouchEnabled: (): void => {},
        getScreenUIContext: (): UIContext => {
          return testPtr;
        }
      };
      let scbScreenSession: SCBScreenSession = new SCBScreenSession(screenSession);
      scbScreenSession.session.name = 'SubScreen';
      when(getScreenSession)(ArgumentMatchers.any).afterReturn(scbScreenSession);
      let isSmallFoldProduct: Function = mocker.mockFunc(
        DeviceHelper, DeviceHelper.isSmallFoldProduct);
      when(isSmallFoldProduct)(ArgumentMatchers.any).afterReturn(true);
      ReflectionUtils.useFunc(scbSceneSession, 'onPendingSceneSessionActivation', cSceneInfo);
      mocker.clear(screenSessionManager);
    });

    it('requestChangeUIAbilityVisibilityBySCBTest', 0, () => {
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let cSceneSession: sceneSessionManager.SceneSession = sceneSessionManager.requestSceneSession(scbSceneInfo);
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(cSceneSession, scbSceneInfo);
      ReflectionUtils.useFunc(scbSceneSession, 'requestChangeUIAbilityVisibilityBySCB', false);
    });

    it('onChangeSessionVisibilityWithStatusBarTest', 0, () => {
      let cSceneInfo: sceneSessionManager.SceneInfo = {
        bundleName: 'bundleName',
        moduleName: 'moduleName',
        abilityName: "abilityName",
        appIndex: 1
      };
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let cSceneSession: sceneSessionManager.SceneSession = sceneSessionManager.requestSceneSession(scbSceneInfo);
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(cSceneSession, scbSceneInfo);
      ReflectionUtils.useFunc(scbSceneSession, 'onChangeSessionVisibilityWithStatusBar', cSceneInfo, false);
    });

    it('setBufferAvailableCallback', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let func: Function = (): boolean => {
        return true;
      };
      scbSceneSession.setBufferAvailableCallback(func);
      scbSceneSession.isBufferAvailable = true;
      scbSceneSession.setBufferAvailableCallback(func);
      expect(scbSceneSession.bufferAvailableCallbackList.length).assertLargerOrEqual(0);
    });
 
    it('onBufferAvailableChange', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      ReflectionUtils.useFunc(scbSceneSession, 'onBufferAvailableChange', true);
      let func1: Function = (): boolean => {
        return true;
      };
      let func2: Function = (): boolean => {
        return true;
      };
      scbSceneSession.bufferAvailableCallbackList.push(func1);
      scbSceneSession.bufferAvailableCallbackList.push(func2);
      ReflectionUtils.useFunc(scbSceneSession, 'onBufferAvailableChange', true);
      expect(scbSceneSession.bufferAvailableCallbackList.length).assertEqual(0);
 
      scbSceneSession.sessionData._isSystemBarPropertyApplied = true;
      ReflectionUtils.useFunc(scbSceneSession, 'onBufferAvailableChange', false);
    });
 
    it('setBufferAvailableCallbackEnable', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      scbSceneSession.setBufferAvailableCallbackEnable(true);
    });
 
    it('setZOrderTest02', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(null), sceneInfo);
      scbSceneSession.setZOrder(10);
      expect(scbSceneSession.sessionInfo.zOrder).assertEqual(10);
    });
 
    it('setZOrderTest03', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      expect(scbSceneSession.sessionInfo.zOrder).assertEqual(0);
      scbSceneSession.setZOrder(0);
      expect(scbSceneSession.sessionInfo.zOrder).assertEqual(0);
    });
 
    it('calcSessionRectAfterActiveModeChangeTest02', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      scbSceneSession.currRect.width = new ScbNumber(10);
      scbSceneSession.currRect.height = new ScbNumber(20);
      let oldProperty: SCBScreenProperty = new SCBScreenProperty();
      oldProperty.width = 1;
      oldProperty.height = 2;
      let newProperty: SCBScreenProperty = new SCBScreenProperty();
      newProperty.width = 10;
      newProperty.height = 20;
      // mock
      let mocker: MockKit = new MockKit();
      let mockFunc1 = mocker.mockFunc(SCBWindowSceneConfig, SCBWindowSceneConfig.getInstance);
      let windowSceneConfig: WindowSceneConfig = {
        uiType:'pc'
      };
      let scbWindowSceneConfigTest:SCBWindowSceneConfigTest = {
        windowSceneConfig
      };
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(scbWindowSceneConfigTest);
 
      scbSceneSession.calcSessionRectAfterActiveModeChange(oldProperty, newProperty);
      expect(scbSceneSession.currRect.width.getPx()).assertEqual(100);
      expect(scbSceneSession.currRect.height.getPx()).assertEqual(200);
    });
 
    it('updateFloatingScale02', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      // SCBSceneMode == UNDEFINED
      sceneSession.updateFloatingScale(1.0);
    });
 
    it('isInSceneMode02', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
 
      let modes: SCBSceneMode[] = [SCBSceneMode.UNDEFINED];
      expect(sceneSession.isInSceneMode(...modes)).assertEqual(false);
    });
 
    it('isSupportSplitMode', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
 
      // mock UITYPE_PC and PORTRAITWINDOW
      let mocker: MockKit = new MockKit();
      let mockFunc1 = mocker.mockFunc(SCBWindowSceneConfig, SCBWindowSceneConfig.getInstance);
      let windowSceneConfig: WindowSceneConfig = {
        uiType:'pc'
      };
      let scbWindowSceneConfigTest: SCBWindowSceneConfigTest = {
        windowSceneConfig
      };
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(scbWindowSceneConfigTest);
      sceneSession.pcWindowShowType = 1;
      expect(sceneSession.isSupportSplitMode()).assertFalse();
 
      // mock not pc and DEFAULTWINDOW and debugMultiWindow = false
      sceneSession.pcWindowShowType = 0;
      sceneSession.isPcAppInPad = true;
      let mocker2: MockKit = new MockKit();
      let mockFunc2 = mocker2.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().isPcMode);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      expect(sceneSession.isSupportSplitMode()).assertFalse();
 
      sceneSession.isPcAppInPad = false;
      expect(sceneSession.isSupportSplitMode()).assertFalse();
    });
 
    it('updateRectWithSubWindow', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.width = 100;
      screenProperty.height = 100;
      sceneSession.updateRectWithSubWindow(new ScbNumber(10), new ScbNumber(10), new ScbNumber(20), new ScbNumber(20), screenProperty);
    });
 
    it('updateSizeChangeReason', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      sceneSession.updateSizeChangeReason(null);
 
      let scbSceneSessionNull: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(null), sceneInfo);
      scbSceneSessionNull.updateSizeChangeReason(null);
    });
 
    it('setBlank', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      sceneSession.setBlank(true);

      let scbSceneSessionNull: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(null), sceneInfo);
      scbSceneSessionNull.setBlank(true);
    });
 
    it('setAnsUnsetFrameLayoutFinishCallbackTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let func: Function = (): boolean => {
        return true;
      };
      sceneSession.setFrameLayoutFinishCallback(func);
      sceneSession.unsetFrameLayoutFinishCallback();
    });
 
    it('updateCurRectForOneStepSplit', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.width = 100;
      screenProperty.height = 100;
      sceneSession.updateCurRectForOneStepSplit(screenProperty, true, 0);
      sceneSession.updateCurRectForOneStepSplit(screenProperty, false, 0);
    });
 
    it('refreshMultiWindowDebugInfo', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      sceneSession.refreshMultiWindowDebugInfo();
    });
 
    it('setWindowOffset', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      // X==0,Y==0
      sceneSession.setWindowOffset(0, 0);
 
      // X!=0,Y!=0
      sceneSession.setWindowOffset(1, 1);
 
      // Session is null
      let scbSceneSessionNull: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(null), sceneInfo);
      scbSceneSessionNull.setWindowOffset(1, 1);
    });
 
    it('setCompatibleModeEnableInPad', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      sceneSession.setCompatibleModeEnableInPad(true);
 
      // Session is null
      let scbSceneSessionNull: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(null), sceneInfo);
      scbSceneSessionNull.setCompatibleModeEnableInPad(true);
    });
 
    it('registerAndUnregisterForegroundCallbackTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let func: () => void = () => {};
      sceneSession.registerForegroundCallback(func);
      sceneSession.unregisterForegroundCallback();
    });
 
    it('registerAndUnregisterSessionStateChange', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let func: () => void = () => {};
      sceneSession.registerSessionStateChange(func);
      sceneSession.unregisterSessionStateChange();
    });
 
    it('onCreateSpecificSession', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
 
      let sceneSessionTest: SceneSessionTest = {
        subWindowAppModalType: 0,
        persistentId: 123,
        subWindowModalType: SubWindowModalType.TYPE_UNDEFINED
      };
      ReflectionUtils.useFunc(scbSceneSession, 'onCreateSpecificSession', sceneSessionTest)

      let func: Function = (ss: SCBSceneSession, s: SceneSessionTest): boolean => {
        return true;
      };
      scbSceneSession.sessionData.createSubSessionCallback = func;
      ReflectionUtils.useFunc(scbSceneSession, 'onCreateSpecificSession', sceneSessionTest)
 
      scbSceneSession.isForegroundInteractive = false;
      ReflectionUtils.useFunc(scbSceneSession, 'onCreateSpecificSession', sceneSessionTest)
    });
 
    it('onSessionStateChange', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
 
      // sessionStateChangeCallback == null
      ReflectionUtils.useFunc(sceneSession, 'onSessionStateChange', 0);
 
      // sessionStateChangeCallback != null and case default
      let func: (state: number) => void = () => {};
      sceneSession.sessionData.createSubSessionCallback = func;
      ReflectionUtils.useFunc(sceneSession, 'onSessionStateChange', 0);
 
      // case STATE_FOREGROUND and isShowWhenLocked == false and foregroundCallback == undefind
      ReflectionUtils.useFunc(sceneSession, 'onSessionStateChange', 2);
      // case STATE_FOREGROUND and isShowWhenLocked == true and foregroundCallback == undefind
      sceneSession.sessionData.isShowWhenLocked = true;
      ReflectionUtils.useFunc(sceneSession, 'onSessionStateChange', 2);
 
      // case STATE_BACKGROUND and isShowWhenLocked == true and isAutoStartPiP == false
      ReflectionUtils.useFunc(sceneSession, 'onSessionStateChange', 5);
      // case STATE_BACKGROUND and isShowWhenLocked == false and isAutoStartPiP == true
      sceneSession.sessionData.isShowWhenLocked = false;
      sceneSession.isAutoStartPiP = true;
      ReflectionUtils.useFunc(sceneSession, 'onSessionStateChange', 5);
 
      // session == null
      let sceneSessionNull: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(null), sceneInfo);
      ReflectionUtils.useFunc(sceneSessionNull, 'onSessionStateChange', 0);
    });
 
    it('onSessionEvent', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
 
      // eventId == EVENT_MAXIMIZE
      ReflectionUtils.useFunc(sceneSession, 'onSessionEvent', 100, null);
      // eventId == EVENT_MINIMIZE
      ReflectionUtils.useFunc(sceneSession, 'onSessionEvent', 102, null);
      // eventId == EVENT_CLOSE
      ReflectionUtils.useFunc(sceneSession, 'onSessionEvent', 103, null);
      // eventId == EVENT_MAXIMIZE_FLOATING
      ReflectionUtils.useFunc(sceneSession, 'onSessionEvent', 106, null);
      sceneSession.sceneInfo.updateWindowModeAndSync(101);
      ReflectionUtils.useFunc(sceneSession, 'onSessionEvent', 106, null);
      sceneSession.sceneInfo.updateWindowModeAndSync(100);
      ReflectionUtils.useFunc(sceneSession, 'onSessionEvent', 106, null);
      // eventId == EVENT_RECOVER
      ReflectionUtils.useFunc(sceneSession, 'onSessionEvent', 101, null);
      // eventId == EVENT_START_MOVE
      ReflectionUtils.useFunc(sceneSession, 'onSessionEvent', 104, null);
      // eventId == EVENT_DRAG_START
      ReflectionUtils.useFunc(sceneSession, 'onSessionEvent', 111, null);
      // eventId == EVENT_END_MOVE
      ReflectionUtils.useFunc(sceneSession, 'onSessionEvent', 105, null);
      // eventId == EVENT_DRAG
      ReflectionUtils.useFunc(sceneSession, 'onSessionEvent', 112, null);
      // eventId == EVENT_SPLIT_PRIMARY
      ReflectionUtils.useFunc(sceneSession, 'onSessionEvent', 109, null);
      // eventId == EVENT_SPLIT_SECONDARY
      ReflectionUtils.useFunc(sceneSession, 'onSessionEvent', 110, null);
      ReflectionUtils.useFunc(sceneSession, 'onSessionEvent', 0, null);
    });
 
    it('onSessionFocusableChange', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      ReflectionUtils.useFunc(sceneSession, 'onSessionFocusableChange', true);
      expect(sceneSession.isFocusable).assertTrue();
    });
 
    it('onSessionTouchableChange', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      ReflectionUtils.useFunc(sceneSession, 'onSessionTouchableChange', true);
      expect(sceneSession.isTouchable).assertTrue();
      sceneSession.sessionData.sessionTouchableChangeCallback = (flag: boolean)=>{};
      ReflectionUtils.useFunc(sceneSession, 'onSessionTouchableChange', true);
    });
 
    it('onSessionTopmostChange', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      ReflectionUtils.useFunc(sceneSession, 'onSessionTopmostChange', false);
      ReflectionUtils.useFunc(sceneSession, 'onSessionTopmostChange', true);
      expect(sceneSession.isTopmost).assertTrue();
    });
 
    it('onSessionShowWhenLockedChange', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      ReflectionUtils.useFunc(sceneSession, 'onSessionShowWhenLockedChange', false);
 
      // mock isScreenLocked == true
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().isScreenLocked);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      // sessionData.isShowWhenLocked == false and isShowWhenLocked = true
      ReflectionUtils.useFunc(sceneSession, 'onSessionTopmostChange', true);
 
      // sessionData.isShowWhenLocked == true and isShowWhenLocked = false
      sceneSession.sessionData.isShowWhenLocked = true;
      sceneSession.sessionData.sessionShowWhenLockedChangeCallback = (flag: boolean): void => {};
      ReflectionUtils.useFunc(sceneSession, 'onSessionTopmostChange', false);
    });
 
    it('onClick', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      ReflectionUtils.useFunc(sceneSession, 'onClick');
      ReflectionUtils.useFunc(sceneSession, 'onClick', false, false);
    });
 
    it('onNeedAvoid', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      ReflectionUtils.useFunc(sceneSession, 'onNeedAvoid', true);
      expect(sceneSession.needAvoid).assertTrue();
      sceneSession.sessionData.needAvoidCallback = (flag: boolean):void => {};
      ReflectionUtils.useFunc(sceneSession, 'onNeedAvoid', true);
    });

    it('registerSessionDisplayChangeCallbackTest', 0, async (done: Function) => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let callback: Function = (reason: SessionDisplayChangeReason, sessionChangeInfo: SessionChangeInfo) => {};
      scbSceneSession.registerSessionDisplayChangeCallback(callback());
      expect(scbSceneSession !== undefined).assertTrue();
      done();
    });

    it('unregisterSessionDisplayChangeCallbackTest', 0, async (done: Function) => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let callback: Function = (reason: SessionDisplayChangeReason, sessionChangeInfo: SessionChangeInfo) => {};
      scbSceneSession.registerSessionDisplayChangeCallback(callback());
      scbSceneSession.unregisterSessionDisplayChangeCallback(callback());
      expect(scbSceneSession !== undefined).assertTrue();
      done();
    });

    it('registerUpdateDragHotAreaAnimConfigCallbackTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let callback: Function = () => {};
      scbSceneSession.registerUpdateDragHotAreaAnimConfigCallback(callback);
      expect(scbSceneSession.updateDragHotAreaAnimConfigCallbackMap.get(0)).assertEqual(callback);
    })

    it('unregisterUpdateDragHotAreaAnimConfigCallbackTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let callback: Function = () => {};
      scbSceneSession.registerUpdateDragHotAreaAnimConfigCallback(callback);
      expect(scbSceneSession.updateDragHotAreaAnimConfigCallbackMap.get(0)).assertEqual(callback);
      scbSceneSession.unregisterUpdateDragHotAreaAnimConfigCallback();
      expect(scbSceneSession.updateDragHotAreaAnimConfigCallbackMap.get(0)).assertEqual(undefined);
    })

    it('updateDragHotAreaAnimConfigNotInCurrentScreenTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let result1 = false;
      let result2 = false;
      let callback1: Function = (isShow: boolean) => {
        result1 = isShow;
      };
      let callback2: Function = (isShow: boolean) => {
        result2 = isShow;
      };
      scbSceneSession.registerUpdateDragHotAreaAnimConfigCallback(callback1, 0);
      scbSceneSession.registerUpdateDragHotAreaAnimConfigCallback(callback2, 11);
      scbSceneSession.updateDragHotAreaAnimConfigNotInCurrentScreen(true, 0);
      expect(result1).assertFalse();
      expect(result2).assertTrue();
    });

    it('getAnimCountTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      scbSceneSession.addAnimCount();
      expect(scbSceneSession.getAnimCount()).assertEqual(1);
    });

    it('addAnimCountTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      scbSceneSession.addAnimCount();
      scbSceneSession.addAnimCount();
      expect(scbSceneSession.getAnimCount()).assertEqual(2);
    });

    it('clearAnimCountTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      scbSceneSession.addAnimCount();
      scbSceneSession.clearAnimCount();
      expect(scbSceneSession.getAnimCount()).assertEqual(0);
    });

    it('getAnimationPropertyTest', Level.LEVEL0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      sceneSession.sessionData.animationProperty = { targetScale: 1.5 };
      expect(sceneSession.getAnimationProperty()).not().assertUndefined();
      expect(sceneSession.getAnimationProperty()?.targetScale).assertEqual(1.5);
    });

    it('resetAnimationPropertyTest', Level.LEVEL0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      sceneSession.sessionData.animationProperty = { targetScale: 1.5 };
      sceneSession.resetAnimationProperty();
      expect(sceneSession.sessionData.animationProperty).assertUndefined();
    });

    it('getAnimationOptionTest', Level.LEVEL0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      sceneSession.sessionData.animationOption =
        { curve: sceneSessionManager.WindowAnimationCurve.LINEAR, duration: 100 };
      expect(sceneSession.getAnimationOption()).not().assertUndefined();
      expect(sceneSession.getAnimationOption()?.curve).assertEqual(sceneSessionManager.WindowAnimationCurve.LINEAR);
      expect(sceneSession.getAnimationOption()?.duration).assertEqual(100);
    });
  })

  describe('SCBSceneSession_useSCBSceneMemoryInfo_testSuite', () => {
    let sceneMemoryInfo: SCBSceneMemoryInfo =
      new SCBSceneMemoryInfo(SCBSceneMode.UNDEFINED, false, false, -1, -1);

    it('test_whenSetSceneMemoryRect_thenSuccess', Level.LEVEL0, () => {
      let currRect: SCBSessionRect = new SCBSessionRect(1, 1, 1, 1);
      sceneMemoryInfo.setSceneMemoryRect(currRect, currRect);
      expect(sceneMemoryInfo.currRect.left.getPx()).assertEqual(1);
    });

    it('test_whenClearSceneMemoryInfo_thenSuccess', Level.LEVEL0, () => {
      sceneMemoryInfo.clearSceneMemoryInfo();
      expect(sceneMemoryInfo.currRect.left.getPx()).assertEqual(0);
    });
  });

  describe('SCBSceneSession_setUid_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenSetUid_thenSuccess', Level.LEVEL0, () => {
      sceneSession.setUid(111);
      expect(sceneSession.getUid).assertEqual(111);
    });
  });

  describe('SCBSceneSession_isMaximizeFloating_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenisMaximizeFloatingIsTrue_thenReturnTrue', Level.LEVEL0, () => {
      sceneSession.sessionData.isMaximizeFloating = true;
      expect(sceneSession.isMaximizeFloating).assertTrue();
    });
  });

  describe('SCBSceneSession_pendingRemove_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenPendingRemoveIsTrue_thenReturnTrue', Level.LEVEL0, () => {
      sceneSession.sessionData.pendingRemove = true;
      expect(sceneSession.pendingRemove).assertTrue();
    });
  });

  describe('SCBSceneSession_isLastSplit_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenIsLastSplitIsTrue_thenReturnTrue', Level.LEVEL0, () => {
      sceneSession.sessionData.isLastSplit = true;
      expect(sceneSession.isLastSplit).assertTrue();
    });
  });

  describe('SCBSceneSession_needBackToOneStep_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenNeedBackToOneStepIsTrue_thenReturnTrue', Level.LEVEL0, () => {
      sceneSession.sessionData.needBackToOneStep = true;
      expect(sceneSession.needBackToOneStep).assertTrue();
    });
  });

  describe('SCBSceneSession_isSetStatusBarColor_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenIsSetStatusBarColorIsTrue_thenReturnTrue', Level.LEVEL0, () => {
      sceneSession.sessionData.isSetStatusBarColor = true;
      expect(sceneSession.isSetStatusBarColor).assertTrue();
    });
  });

  describe('SCBSceneSession_isSetStatusBarEnable_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenIsSetStatusBarEnable_thenReturnTrue', Level.LEVEL0, () => {
      sceneSession.sessionData.isSetStatusBarEnable = true;
      expect(sceneSession.isSetStatusBarEnable).assertTrue();
    });
  });

  describe('SCBSceneSession_isFollowAppColorMode_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenIsFollowAppColorModeIsTrue_thenReturnTrue', Level.LEVEL0, () => {
      sceneSession.sessionData.isFollowAppColorMode = true;
      expect(sceneSession.isFollowAppColorMode).assertTrue();
    });
  });

  describe('SCBSceneSession_isResizeableInCompatibleMode_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenIsResizeableInCompatibleModeIsTrue_thenReturnTrue', Level.LEVEL0, () => {
      sceneSession.sessionData.isResizeableInCompatibleMode = true;
      expect(sceneSession.isResizeableInCompatibleMode).assertTrue();
    });
  });

  describe('SCBSceneSession_needMaxWithoutAnim_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenNeedMaxWithoutAnimIsTrue_thenReturnTrue', Level.LEVEL0, () => {
      sceneSession.sessionData.needMaxWithoutAnim = true;
      expect(sceneSession.needMaxWithoutAnim).assertTrue();
    });
  });

  describe('SCBSceneSession_updateSceneInfo_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneInfo2: SCBSceneInfo = new SCBSceneInfo('testBundle2', 'testModule2', 'testAbility2');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenUpdateSceneInfo_thenSuccess', Level.LEVEL0, () => {
      sceneSession.updateSceneInfo(sceneInfo2);
      expect(sceneSession.sceneInfo.bundleName).assertEqual('testBundle2');
    });
  });

  describe('SCBSceneSession_updateSessionCompatibleModeStatus_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenIsSupportCompatibleModeIsNotSame_thenUpdateSuccess', Level.LEVEL0, () => {
      ReflectionUtils.setProperty(sceneSession, 'isSupportCompatibleMode', false);
      ReflectionUtils.useFunc(sceneSession, 'updateSessionCompatibleModeStatus', true, true);
      expect(sceneSession.isSupportCompatibleMode).assertTrue();
    });
  });

  describe('SCBSceneSession_isStartFailWhenGrayAppIcon_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenStartFailIsFalse_thenReturnFalse', Level.LEVEL0, () => {
      let ret: boolean = ReflectionUtils.useFunc(sceneSession, 'isStartFailWhenGrayAppIcon', false, sceneInfo);
      expect(ret).assertFalse();
    });
  });

  describe('SCBSceneSession_updateAppUseControl_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenIsNeedControlIsTrue_thenUpdateSuccess', Level.LEVEL0, () => {
      ReflectionUtils.useFunc(sceneSession, 'updateAppUseControl', 1, true);
      expect(sceneSession.useControlList.length).assertEqual(1);
    });
  });

  describe('SCBSceneSession_initUseControlSession_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenIsNeedControlIsTrue_thenUpdateSuccess', Level.LEVEL0, () => {
      ReflectionUtils.useFunc(sceneSession, 'initUseControlSession');
      expect(sceneSession.useControlSession).not().assertNull();
    });
  });

  describe('SCBSceneSession_destroyUseControlSession_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenIsNeedControlIsTrue_thenUpdateSuccess', Level.LEVEL0, () => {
      ReflectionUtils.useFunc(sceneSession, 'initUseControlSession');
      ReflectionUtils.useFunc(sceneSession, 'destroyUseControlSession');
      expect(sceneSession.useControlSession).assertNull();
    });
  });

  describe('SCBSceneSession_updateShouldBlockPowerKeyAsync_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenAbilityInfoListIsNotNull_thenUpdateSuccess', Level.LEVEL0, () => {
      sceneSession.updateShouldBlockPowerKey();
      expect(sceneSession.hasBlockPowerKeyPermission).assertFalse();
    });
  });

  describe('SCBSceneSession_updateBlockPowerPersion_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenabilityInfoListIsNull_thenUpdateSuccess', Level.LEVEL0, () => {
      ReflectionUtils.useFunc(sceneSession, 'updateBlockPowerPersion', []);
      expect(sceneSession.hasBlockPowerKeyPermission).assertFalse();
    });
  });

  describe('SCBSceneSession_screenPropertyChangeCallback_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenIsDisplayLandIsTrue_thenUpdateSuccess', Level.LEVEL0, () => {
      sceneSession.setIsDisplayLand(true);
      ReflectionUtils.useFunc(sceneSession, 'screenPropertyChangeCallback');
      expect(sceneSession.isDisplayLand).assertFalse();
    });
  });

  describe('SCBSceneSession_onIsLandscapeMultiWindowChange_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenIsDisplayLandIsTrue_thenUpdateSuccess', Level.LEVEL0, () => {
      sceneSession.setIsDisplayLand(true);
      ReflectionUtils.useFunc(sceneSession, 'screenPropertyChangeCallback');
      expect(sceneSession.isDisplayLand).assertFalse();
    });
  });

  describe('SCBSceneSession_onUpdateSessionLabel_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenIsDisplayLandIsTrue_thenUpdateSuccess', Level.LEVEL0, () => {
      ReflectionUtils.useFunc(sceneSession, 'onUpdateSessionLabel', 'test');
      expect(sceneSession.sessionLabel).assertEqual('test');
    });
  });

  describe('SCBSceneSession_onUpdateSessionIcon_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenOnUpdateSessionIconCallbackIsNotNull_thenUpdateSuccess', Level.LEVEL0, () => {
      let iconPath = '/file';
      const onUpdateSessionIconCallback = (path: string) => {
        iconPath = path;
      }
      sceneSession.sessionData.onUpdateSessionIconCallback = onUpdateSessionIconCallback;
      ReflectionUtils.useFunc(sceneSession, 'onUpdateSessionIcon', '/file2');
      expect(iconPath).assertEqual('/file2');
    });
  });

  describe('SCBSceneSession_onUpdateSessionLabelAndIcon_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenOnUpdateSessionLabelAndIconCallbackIsNotNull_thenUpdateSuccess', Level.LEVEL0, () => {
      let labelText = 'label';
      const onUpdateSessionLabelAndIconCallback = (label: string, icon: image.PixelMap) => {
        labelText = label;
      }
      sceneSession.sessionData.onUpdateSessionLabelAndIconCallback = onUpdateSessionLabelAndIconCallback;
      let color = new ArrayBuffer(1);
      let opts: image.InitializationOptions = { editable: true, pixelFormat: 3, size: { height: 1, width: 1 } };
      ReflectionUtils.useFunc(sceneSession, 'onUpdateSessionLabelAndIcon', 'label2', image.createPixelMap(color, opts));
      expect(labelText).assertEqual('label2');
    });
  });

  describe('SCBSceneSession_setSessionTouchable_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenSessionIsNotNull_thenSetSuccess', Level.LEVEL0, () => {
      sceneSession.setSessionTouchable(true);
      expect(sceneSession.isTouchable).assertTrue();
    });
  });

  describe('SCBSceneSession_setUseStartingWindowAboveLocked_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenSessionIsNotNull_thenSetSuccess', Level.LEVEL0, () => {
      sceneSession.setUseStartingWindowAboveLocked(true);
      expect(sceneSession.session).not().assertNull();
    });
  });

  describe('SCBSceneSession_registerOnUpdateSessionLabelAndIconCallback_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenRegisterCallback_thenRegisterSuccess', Level.LEVEL0, () => {
      const callback = () => {}
      sceneSession.registerOnUpdateSessionLabelAndIconCallback(callback);
      expect(sceneSession.sessionData.onUpdateSessionLabelAndIconCallback).not().assertNull();
    });
  });

  describe('SCBSceneSession_unRegisterOnUpdateSessionLabelAndIconCallback_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenUnRegisterCallback_thenUnRegisterSuccess', Level.LEVEL0, () => {
      const callback = () => {};
      sceneSession.registerOnUpdateSessionLabelAndIconCallback(callback);
      sceneSession.unRegisterOnUpdateSessionLabelAndIconCallback();
      expect(sceneSession.sessionData.onUpdateSessionLabelAndIconCallback).assertNull();
    });
  });

  describe('SCBSceneSession_unRegisterSessionTitleActionCallback_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenOnUpdateSessionIconCallbackIsNotNull_thenUpdateSuccess', Level.LEVEL0, () => {
      const callback = () => {};
      const screenId = 233;
      sceneSession.registerSessionTitleActionCallback(callback, screenId);
      expect(sceneSession.sessionTitleActionCallbackMap.has(screenId)).assertTrue();

      sceneSession.unRegisterSessionTitleActionCallback(callback, screenId);
      expect(sceneSession.sessionTitleActionCallbackMap.has(screenId)).assertFalse();
    });
  });

  describe('SCBSceneSession_registerClickModalWindowOutsideCallback_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenClickModalWindowOutsideCallbackIsNotNull_thenRegisterSuccess', Level.LEVEL0, () => {
      const callback = () => {};
      sceneSession.registerClickModalWindowOutsideCallback(callback);
      expect(sceneSession.sessionData.clickModalWindowOutsideCallback).not().assertNull();
    });
  });

  describe('SCBSceneSession_unRegisterSessionFocusedChangeCallback_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenUnRegisterSessionFocusedChangeCallback_thenUnRegisterSuccess', Level.LEVEL0, () => {
      let curr = false;
      const callback = (isFocused: boolean) => {
        curr = isFocused;
      };
      sceneSession.registerSessionFocusedChangeCallback(callback);
      ReflectionUtils.useFunc(sceneSession, 'sessionFocusedChangeCallback', true);
      expect(curr).assertTrue();
      sceneSession.unRegisterSessionFocusedChangeCallback();
      let changeCallback: Function | undefined = ReflectionUtils.getProperty(sceneSession, 'sessionFocusedChangeCallback');
      expect(changeCallback).assertUndefined();
    });
  });

  describe('SCBSceneSession_resetWindowEffect_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenResetWindowEffect_thenFloatBorderRadiusIsZero', Level.LEVEL0, () => {
      sceneSession.floatBorderRadius = 1;
      sceneSession.resetWindowEffect();
      expect(sceneSession.floatBorderRadius).assertEqual(0);
    });
  });

  describe('SCBSceneSession_setExitSplitOnBackground_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenSessionIsNull_thenSetFail', Level.LEVEL0, () => {
      sceneSession.setExitSplitOnBackground(true, 'test');
      expect(sceneSession.session).not().assertNull();
    });
  });

  describe('SCBSceneSession_traverseSubListToNotifyForegroundInteractiveStatus_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenSubSessionListIsNull_thenNotifySuccess', Level.LEVEL0, () => {
      let subSessionList: SCBSpecificSceneSessionList = new SCBSpecificSceneSessionList();
      sceneSession.traverseSubListToNotifyForegroundInteractiveStatus(subSessionList, true);
      expect(sceneSession.session).not().assertNull();
    });
  });

  describe('SCBSceneSession_clearSessionData_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenSessionDataIsExist_thenClearSuccess', Level.LEVEL0, () => {
      sceneSession.sessionData.currentRotation = 1;
      sceneSession.clearSessionData();
      expect(sceneSession.sessionData.currentRotation).assertEqual(0);
    });
  });

  describe('SCBSceneSession_restorePrevCompatibleScale_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenCompatibleScaled_thenRestoreSuccess', Level.LEVEL0, () => {
      ReflectionUtils.setProperty(sceneSession, 'preCompatibleScale', 2);
      sceneSession.restorePrevCompatibleScale();
      expect(ReflectionUtils.getProperty(sceneSession, 'compatibleScale')).assertEqual(2);
    });
  });

  describe('SCBSceneSession_getScaleXAndYWithCompatibleScale_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenCompatibleScaleIsExist_thenGetSuccess', Level.LEVEL0, () => {
      sceneSession.pcWindowShowType = 1;
      let scaleX = sceneSession.getScaleXWithCompatibleScale();
      expect(scaleX).assertEqual(3);

      let scaleY = sceneSession.getScaleYWithCompatibleScale();
      expect(scaleY).assertEqual(3);
    });
  });

  describe('SCBSceneSession_setScaleXAndY_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenSetScale_thenSuccess', Level.LEVEL0, () => {
      sceneSession.setScaleX(3);
      expect(ReflectionUtils.getProperty(sceneSession, 'scaleX')).assertEqual(3);

      sceneSession.setScaleY(4);
      expect(ReflectionUtils.getProperty(sceneSession, 'scaleY')).assertEqual(4);
    });
  });

  describe('SCBSceneSession_saveSessionDragingState_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenSaveState_thenSuccess', Level.LEVEL0, () => {
      sceneSession.saveSessionDragingState(true);
      expect(sceneSession.isSessionDraging).assertTrue();
    });
  });

  describe('SCBSceneSession_resetLastEventId_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenResetLastEventId_thenSuccess', Level.LEVEL0, () => {
      let sessionDataInner: SCBSceneSessionDataInner = ReflectionUtils.getProperty(sceneSession, 'sessionDataInner');
      ReflectionUtils.setProperty(sessionDataInner, 'lastEventId', SCBSessionEventId.EVENT_MAXIMIZE);
      sceneSession.resetLastEventId();
      let eventId: SCBSessionEventId = ReflectionUtils.getProperty(sessionDataInner, 'lastEventId');
      expect(eventId).assertEqual(SCBSessionEventId.EVENT_UNDEFINED);
    });
  });

  describe('SCBSceneSession_onSplitPartnerMoving_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenSplitPartnerMovingCallbackMapIsNotNull_thenCallbackSuccess', Level.LEVEL0, () => {
      let text = 'test';
      const screenId = 233;
      let callback = () => {
        text = 'called';
      }
      let callbackArray: Function[] = [];
      callbackArray.push(callback);
      sceneSession.splitPartnerMovingCallbackMap.set(screenId, callbackArray)

      sceneSession.sceneInfo.screenId = screenId;
      sceneSession.onSplitPartnerMoving();
      expect(text).assertEqual('called');
    });
  });

  describe('SCBSceneSession_setStartMovePointerPosition_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenPointerPositionIsExist_thenSetSuccess', Level.LEVEL0, () => {
      let position = new SCBWindowMovePointerPosition();
      position.pointerPosX = 1;
      sceneSession.setStartMovePointerPosition(position);
      expect(sceneSession.startMovePointerPos.pointerPosX).assertEqual(1);
    });
  });

  describe('SCBSceneSession_setNeedSyncSessionRect_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenIsNeedIsTrue_thenSetSuccess', Level.LEVEL0, () => {
      sceneSession.setNeedSyncSessionRect(true);
      expect(sceneSession.session).not().assertNull();
    });
  });

  describe('SCBSceneSession_onFrameLayoutFinish_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenFrameLayoutFinishCallbackIsExist_thenTouchCallbackSuccess', Level.LEVEL0, () => {
      let text = 'test';
      let callback = () => {
        text = 'called';
      }
      sceneSession.frameLayoutFinishCallback = callback;
      ReflectionUtils.useFunc(sceneSession, 'onFrameLayoutFinish');
      expect(text).assertEqual('called');
    });
  });

  describe('SCBSceneSession_onFullScreenWaterfallModeChange_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

  });

  describe('SCBSceneSession_setFullScreenWaterfallMode_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

  });

  describe('SCBSceneSession_onClickModalWindowOutside_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenCallbackIsExist_thenCallSuccess', Level.LEVEL0, () => {
      let text = 'test';
      let callback = () => {
        text = 'called';
      }
      sceneSession.sessionData.clickModalWindowOutsideCallback = callback;
      ReflectionUtils.useFunc(sceneSession, 'onClickModalWindowOutside');
      expect(text).assertEqual('called');
    });
  });

  describe('SCBSceneSession_onSessionMainWindowTopmostChange_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenIsMainWindowTopmost_thenUpdateSuccess', Level.LEVEL0, () => {
      ReflectionUtils.useFunc(sceneSession, 'onSessionMainWindowTopmostChange', true);
      expect(sceneSession.isMainWindowTopmost).assertTrue();
    });
  });

  describe('SCBSceneSession_getHasBlockPowerKeyPermission_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenHasBlockPowerKeyPermissionIsTrue_thenReturnTrue', Level.LEVEL0, () => {
      sceneSession.hasBlockPowerKeyPermission = 1;
      expect(sceneSession.getHasBlockPowerKeyPermission()).assertEqual(1);
    });
  });

  describe('SCBSceneSession_setSystemFocusableAndIsMidScene_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenParamIsTrue_thenSetSuccess', Level.LEVEL0, () => {
      sceneSession.setSystemFocusable(true);
      sceneSession.setIsMidScene(true);
      expect(sceneSession.session).not().assertNull();
    });
  });

  describe('SCBSceneSession_onSessionDisplayIdChange_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenDisplayIdChange_thenUpdateTargetDisplayId', Level.LEVEL0, () => {
      let text = 'test';
      let callback = () => {
        text = 'called';
      }
      let ssm = SCBSceneSessionManager.getInstance();
      ssm.registerSessionDisplayChangeCallback(callback);
      sceneSession.onSessionDisplayIdChange(233);
      expect(text).assertEqual('called');
    });
  });

  describe('SCBSceneSession_updateDisplayId_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenDisplayIdExist_thenUpdateSuccess', Level.LEVEL0, () => {
      sceneSession.updateDisplayId(233);
      expect(sceneSession.session.screenId).assertEqual(233);
    });
  });

  describe('SCBSceneSession_setOcclusionAlpha_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenAlphaExist_thenSetSuccess', Level.LEVEL0, () => {
      sceneSession.setOcclusionAlpha(233);
      expect(sceneSession.session).not().assertNull();
    });
  });

  describe('SCBSceneSession_resetOcclusionAlpha_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenResetOcclusionAlpha_thenResetSuccess', Level.LEVEL0, () => {
      sceneSession.resetOcclusionAlpha();
      expect(sceneSession.session).not().assertNull();
    });
  });

  describe('SCBSceneSession_removeBlank_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenRemoveBlank_thenRemoveSuccess', Level.LEVEL0, () => {
      sceneSession.removeBlank();
      expect(sceneSession.session).not().assertNull();
    });
  });

  describe('SCBSceneSession_addSnapshot_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenAddSnapshot_thenAddSuccess', Level.LEVEL0, () => {
      sceneSession.addSnapshot();
      expect(sceneSession.session).not().assertNull();
    });
  });

  describe('SCBSceneSession_removeSnapshot_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenAddSnapshot_thenAddSuccess', Level.LEVEL0, () => {
      sceneSession.addSnapshot();
      expect(sceneSession.session).not().assertNull();
    });
  });

  describe('SCBSceneSession_updateCurRectForMultiWindowToFull_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenUpdateCurRect_thenUpdateSuccess', Level.LEVEL0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.width = 100;
      screenProperty.height = 100;
      sceneSession.updateCurRectForMultiWindowToFull(screenProperty);
      expect(sceneSession.currRect.width.getPx()).assertEqual(100);
    });
  });

  describe('SCBSceneSession_isFocusedOnSpecificSceneSessionList_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenNotFocus_thenReturnFalse', Level.LEVEL0, () => {
      let res: boolean = ReflectionUtils.useFunc(sceneSession, 'isFocusedOnSpecificSceneSessionList', new SCBSpecificSceneSessionList())
      expect(res).assertFalse();
    });
  });

  describe('SCBSceneSession_sessionSnapshot_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_saveSessionSnapshotSync', Level.LEVEL0, () => {
      sceneSession.saveSessionSnapshotSync();
      expect(sceneSession.maskSnapShotImage).assertNull();
    });

    it('test_setSnapshotOpacity', Level.LEVEL0, () => {
      sceneSession.setSnapshotOpacity(0.5);
      expect(sceneSession.snapshotOpacity).assertEqual(0.5);
    });

    it('test_setEnableShowOneHandModeSnapshot', Level.LEVEL0, () => {
      sceneSession.setEnableShowOneHandModeSnapshot(true);
      expect(sceneSession.enableShowOneHandModeSnapshot).assertEqual(true);
    });
  });

  describe('SCBSceneSession_windowLayoutEvent_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_windowLayoutEvent_0', Level.LEVEL0, () => {
      let eventId: SCBSessionEventId = SCBSessionEventId.EVENT_MAXIMIZE;
      sceneSession.windowLayoutEvent(eventId);
      expect(sceneSession.sceneInfo.windowMode).assertEqual(SCBSceneMode.FULLSCREEN);
    });

    it('test_windowLayoutEvent_1', Level.LEVEL0, () => {
      let eventId: SCBSessionEventId = SCBSessionEventId.EVENT_MINIMIZE;
      sceneSession.windowLayoutEvent(eventId);
      expect(sceneSession.sessionData.isFocused).assertEqual(false);
    });
  });

  describe('SCBSceneSession_RegisterDataAndState_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenSceneSessionCreateRegisterData_thenSuccess', Level.LEVEL0, () => {
      sceneSession.registerData(new SceneDataOfMissionManagement());
      let mmData: SceneDataOfMissionManagement =
        sceneSession.getData(SceneDataCategory.MISSION_MANAGEMENT) as SceneDataOfMissionManagement;
      expect(mmData.isNewWant).assertTrue();
      expect(mmData.isShowWhenLocked).assertFalse();
      expect(mmData.isActive).assertFalse();
      expect(mmData.isShowAboveKeyguard).assertFalse();
      expect(mmData.isTemporarilyShowWhenLocked).assertFalse();
      expect(mmData.isForegrounding).assertFalse();
      expect(mmData.pendingRemove).assertFalse();
      expect(mmData.foregroundingTimeoutTaskId).assertEqual(-1);
    });

    it('test_whenSceneSessionCreateRegisterState_thenSuccess', Level.LEVEL0, () => {
      sceneSession.registerState(new SceneStateOfBasic(sceneSession));
      let basicState: SceneStateOfBasic = sceneSession.getState(SceneStateCategory.BASIC) as SceneStateOfBasic;
      let testNumber = new ScbNumber();

      expect(basicState.width).assertEqual(testNumber);
      expect(basicState.height).assertEqual(testNumber);
      expect(basicState.visibility).assertTrue();
    });
  });
}