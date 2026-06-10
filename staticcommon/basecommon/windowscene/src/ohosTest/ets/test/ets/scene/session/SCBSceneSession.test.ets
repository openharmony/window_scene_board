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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit,
  ArgumentMatchers, when} from '@ohos/hypium';
import { SCBSceneInfo,
  SCBSceneSession,
  SCBScreenSession,
  SCBScreenProperty,
  SCBSceneMode,
  ScbNumber,
  SCBSessionCbType,
  SCBWindowSceneConfig,
  SCBSessionRect,
  SCBSessionEventId,
  SCBSceneSessionManager,
  SCBScreenSessionManager,
  SCBSceneContainerSession
} from '../../../../../../main/ets/TsIndex';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { ReflectionUtils } from './ReflectionUtils';
import screenSessionManager from '@ohos.screenSessionManager';
import { AbilityConstant } from '@kit.AbilityKit';
import { DeviceHelper } from '@ohos/frameworkwrapper';

interface WindowSceneConfig {
  uiType:string;
};
 
interface SCBWindowSceneConfigTest {
  windowSceneConfig: WindowSceneConfig;
};
 
enum SubWindowModalType {
  TYPE_UNDEFINED,
  TYPE_NORMAL,
  TYPE_DIALOG,
  TYPE_WINDOW_MODALITY,
  TYPE_TOAST,
  TYPE_APPLICATION_MODALITY
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
      expect(scbSceneSession.sessionTitleActionCallbackMap.get(0)).assertEqual(callback);
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

    it('saveSessionDragingStateTest', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      expect(scbSceneSession.isSessionDraging).assertFalse();
      scbSceneSession.saveSessionDragingState(true);
      expect(scbSceneSession.isSessionDraging).assertTrue();
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
