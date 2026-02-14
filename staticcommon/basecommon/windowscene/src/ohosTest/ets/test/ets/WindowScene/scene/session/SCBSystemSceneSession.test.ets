/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium'
import sceneSessionManager from '@ohos.sceneSessionManager';

import {
  SCBSystemSceneSession,
  SCBSceneInfo,
  SystemSessionInfo,
  SCBPropertyChangeReason,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBSessionRect,
  SystemSessionChangeCallback,
  SCBWindowRotateController,
} from '../../../../../../../..';
import { asset } from '@kit.AssetStoreKit';
import { ReflectionUtils } from './ReflectionUtils';
import { SCBSessionInfo } from '../../../../../../../main/ets/scene/session/SCBSessionInfo';
import { RotationConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';

let systemSceneSession: SCBSystemSceneSession;
let isFoldChangeExec: boolean = false;
let isRotationChangeExec: boolean = false;
let systemSessionInfo: SystemSessionInfo;

const systemSessionChangeCallback: SystemSessionChangeCallback = {
  onActiveChange: (isActive: boolean) => {},
  onVisibilityChange: (visibility: boolean) => {},
  onFocusableChange: (isFocusable: boolean) => {},
  onHitTestModeChange: (hitTestMode: HitTestMode) => {},
  onUpdateRect: (rect: SCBSessionRect) => {},
  onTouchOutside: (x: number, y: number) => {},
  onTranslateChange: (x: number, y: number, z: number) => {},
  onBackgroundColorChange: (backgroundColor: string) => {},
  onBackdropBlurChange: (backdropBlur: number) => {},
  onBorderRadiusChange: (borderRadius: number) => {},
  onShadowChange: (radius: number, color: string, offsetX: number, offsetY: number) => {},
  onOpacityChange: (opacity: number) => {},
  onTouchableChange: (touchable: boolean) => {},
  onRotationChange: (screenProperty: SCBScreenProperty) => {isRotationChangeExec = true},
  onActiveModeChange: (oldScreenProperty : SCBScreenProperty, newScreenProperty: SCBScreenProperty) => {},
  onFoldChange: (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {isFoldChangeExec = true},
  onZIndexChange: (zIndex: number) => {},
  onResponseRegionChange: (responseRegion: Array<Rectangle>) => {}
}

class PropertyUnrelatedToBuild {
  isFocused: boolean = false;
}

class SCBSystemSceneSessionDataInner {
  property: PropertyUnrelatedToBuild = new PropertyUnrelatedToBuild();
  sessionInfo: SCBSessionInfo = new SCBSessionInfo();
  /**
   * Offset X of the WindowScene associated with the session
   */
  windowOffsetX: number = 0;

  /**
   * Offset Y of the WindowScene associated with the session
   */
  windowOffsetY: number = 0;

  /**
   * scale of the WindowScene associated with the session
   */
  scale: number = 1;
}

export function SCBSystemSceneSessionTest() {
  describe('SCBSystemSceneSessionTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      systemSessionInfo = {
        systemType: sceneSessionManager.SessionType.TYPE_UNDEFINED,
        sceneName: 'SCBGestureBackViewModelTest',
        sceneZIndex: 101,
        isFocusable: false,
        isTouchable: true,
        privacyMode: false,
        hitTestMode: HitTestMode.Default,
        isOverlayScene: true,
      };
      systemSceneSession = new SCBSystemSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), systemSessionInfo, undefined);
    })
    afterEach(() => {
    })
    afterAll(() => {
    })
    isSessionForegroundTest();

    it('setRotationTest', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let sysSceneSession = SCBSceneSessionManager.getInstance().requestSystemSceneSession(systemSessionInfo, null);
      sysSceneSession.setRotation(screenProperty);
      sysSceneSession = SCBSceneSessionManager.getInstance().requestSystemSceneSession(systemSessionInfo, systemSessionChangeCallback, false, 11);
      isRotationChangeExec = false;
      sysSceneSession.setRotation(screenProperty);
      expect(isRotationChangeExec).assertTrue();
    });

    it('changeFoldScreenTest', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.ROTATION;
      let sysSceneSession = SCBSceneSessionManager.getInstance().requestSystemSceneSession(systemSessionInfo, null);
      sysSceneSession.changeFoldScreen(screenProperty, reason);
      sysSceneSession = SCBSceneSessionManager.getInstance().requestSystemSceneSession(systemSessionInfo, systemSessionChangeCallback, false, 11);
      isFoldChangeExec = false;
      sysSceneSession.changeFoldScreen(screenProperty,reason);
      expect(isFoldChangeExec).assertTrue();
    });

    it('setFocused', 0, () => {
      systemSceneSession.setFocusable(true);
      systemSceneSession.setFocused(true);
      expect(systemSceneSession.getFocused()).assertTrue();
      systemSceneSession.setFocused(false);
      systemSceneSession.setFocusable(false);
      systemSceneSession.setFocused(true);
      expect(systemSceneSession.getFocused()).assertFalse();
    });

    it('registerInputMethodChangeListener', 0, () => {
      let inputChangeCallback : Function = () => {return 0};
      let inputChangeCallback_2 : Function = () => {return 1};
      systemSceneSession.registerInputMethodChangeListener(inputChangeCallback);
      systemSceneSession.registerInputMethodChangeListener(inputChangeCallback_2);
      expect(systemSceneSession.inputChangeCallback).assertEqual(inputChangeCallback);
    });

    it('getZOrder', 0, () => {
      expect(systemSceneSession.getZOrder()).assertEqual(systemSceneSession.getZIndex());
    })

    it('setWindowOffset', 0, () => {
      systemSceneSession.setWindowOffset(100, 200);
      systemSceneSession.setWindowOffset(100, 200);
      expect(ReflectionUtils.getProperty(ReflectionUtils.getProperty(systemSceneSession, 'sessionDataInner'), 'windowOffsetX')).assertEqual(100);
    })
  })

  describe('SCBSystemSceneSession_getFunction_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    systemSessionInfo = {
      systemType: sceneSessionManager.SessionType.TYPE_UNDEFINED,
      sceneName: 'SCBGestureBackViewModelTest',
      sceneZIndex: 101,
      isFocusable: false,
      isTouchable: true,
      privacyMode: false,
      hitTestMode: HitTestMode.Default,
      isOverlayScene: true,
    };
    systemSceneSession =
      new SCBSystemSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), systemSessionInfo, undefined);

    it('test_whenIsLandscapeStartRotatableIsTrue_thenReturnTrue', Level.LEVEL0, () => {
      systemSceneSession.sessionData.isLandscapeStartRotatable = true;
      let isLandscapeStartRotatable: boolean = systemSceneSession.isLandscapeStartRotatable;
      expect(isLandscapeStartRotatable).assertTrue();
    });

    it('test_whenTransformRectExist_thenReturnRect', Level.LEVEL0, () => {
      systemSceneSession.sessionData.transformRect = new SCBSessionRect(1, 1, 1, 1);
      let transformRect: SCBSessionRect = systemSceneSession.transformRect;
      expect(transformRect.left.getPx()).assertEqual(1);
    });

    it('test_whenAvoidRectIsExist_thenReturnTrue', Level.LEVEL0, () => {
      systemSceneSession.sessionData.avoidRect = new SCBSessionRect(2, 2, 2, 2);
      let avoidRect: SCBSessionRect | undefined = systemSceneSession.avoidRect;
      expect(avoidRect?.left.getPx()).assertEqual(2);
    });
  });

  describe('SCBSystemSceneSession_unregisterInputMethodChangeListener_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    systemSessionInfo = {
      systemType: sceneSessionManager.SessionType.TYPE_UNDEFINED,
      sceneName: 'SCBGestureBackViewModelTest',
      sceneZIndex: 101,
      isFocusable: false,
      isTouchable: true,
      privacyMode: false,
      hitTestMode: HitTestMode.Default,
      isOverlayScene: true,
    };
    systemSceneSession =
      new SCBSystemSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), systemSessionInfo, undefined);

    it('test_whenInputChangeCallbackExist_thenUnregisterSuccess', Level.LEVEL0, () => {
      systemSceneSession.inputChangeCallback = () => {
      };
      systemSceneSession.unregisterInputMethodChangeListener();
      expect(systemSceneSession.inputChangeCallback).assertNull();
    });
  });

  describe('SCBSystemSceneSession_unregisterTouchOutsideCallback_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    systemSessionInfo = {
      systemType: sceneSessionManager.SessionType.TYPE_UNDEFINED,
      sceneName: 'SCBGestureBackViewModelTest',
      sceneZIndex: 101,
      isFocusable: false,
      isTouchable: true,
      privacyMode: false,
      hitTestMode: HitTestMode.Default,
      isOverlayScene: true,
    };
    systemSceneSession =
      new SCBSystemSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), systemSessionInfo, undefined);

    it('test_whenTouchOutsideCallbackExist_thenUnregisterSuccess', Level.LEVEL0, () => {
      let callback = () => {}
      systemSceneSession.setTouchOutsideCallback(callback);
      systemSceneSession.unregisterTouchOutsideCallback();
      let touchCallback: Function | null = ReflectionUtils.getProperty(systemSceneSession, 'touchOutsideCallback');
      expect(touchCallback).assertNull();
    });
  });

  describe('SCBSystemSceneSession_setTouchOutsideCallback_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    systemSessionInfo = {
      systemType: sceneSessionManager.SessionType.TYPE_UNDEFINED,
      sceneName: 'SCBGestureBackViewModelTest',
      sceneZIndex: 101,
      isFocusable: false,
      isTouchable: true,
      privacyMode: false,
      hitTestMode: HitTestMode.Default,
      isOverlayScene: true,
    };
    systemSceneSession =
      new SCBSystemSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), systemSessionInfo, undefined);

    it('test_whenTouchOutsideCallbackExist_thenSetSuccess', Level.LEVEL0, () => {
      let text = 'test';
      let callback = () => {
        text = 'called';
      }
      systemSceneSession.setTouchOutsideCallback(callback);
      ReflectionUtils.setProperty(systemSceneSession, 'touchOutsideCallback', callback);
      systemSceneSession.notifyTouchOutside(1, 1);
      expect(systemSceneSession.hasTouchOutsideCallback()).assertTrue();
      expect(text).assertEqual('called');
    });
  });

  describe('SCBSystemSceneSession_registerAndUnregisterRotateChangeCallback_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    systemSessionInfo = {
      systemType: sceneSessionManager.SessionType.TYPE_UNDEFINED,
      sceneName: 'SCBGestureBackViewModelTest',
      sceneZIndex: 101,
      isFocusable: false,
      isTouchable: true,
      privacyMode: false,
      hitTestMode: HitTestMode.Default,
      isOverlayScene: true,
    };
    systemSceneSession =
      new SCBSystemSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), systemSessionInfo, undefined);

    it('test_whenRotationChangeCallbackExist_thenRegisterSuccess', Level.LEVEL0, () => {
      let text = 'test';
      let callback = () => {
        text = 'called';
      }
      systemSceneSession.registerRotateChangeCallback(callback);
      let rotateChangeCallback: Function = ReflectionUtils.getProperty(systemSceneSession, 'rotateChangeCallback');
      expect(rotateChangeCallback).not().assertNull();
    });

    it('test_whenRotationChangeCallbackExist_thenUnregisterSuccess', Level.LEVEL0, () => {
      systemSceneSession.unregisterRotateChangeCallback();
      let rotateChangeCallback: Function | null = ReflectionUtils.getProperty(systemSceneSession, 'rotateChangeCallback');
      expect(rotateChangeCallback).assertNull();
    });
  });

  describe('SCBSystemSceneSession_notifyInputMethodChange_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    systemSessionInfo = {
      systemType: sceneSessionManager.SessionType.TYPE_UNDEFINED,
      sceneName: 'SCBGestureBackViewModelTest',
      sceneZIndex: 101,
      isFocusable: false,
      isTouchable: true,
      privacyMode: false,
      hitTestMode: HitTestMode.Default,
      isOverlayScene: true,
    };
    systemSceneSession =
      new SCBSystemSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), systemSessionInfo, undefined);

    it('test_whenInputMethodCallbackExist_thenNotifySuccess', Level.LEVEL0, () => {
      let text = 'test';
      let callback = () => {
        text = 'called';
      }
      systemSceneSession.inputChangeCallback = callback;
      systemSceneSession.notifyInputMethodChange(1);
      expect(text).assertEqual('called');
    });
  });

  describe('SCBSystemSceneSession_registerAndUnregisterSessionStateBackgroundCallback_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    systemSessionInfo = {
      systemType: sceneSessionManager.SessionType.TYPE_UNDEFINED,
      sceneName: 'SCBGestureBackViewModelTest',
      sceneZIndex: 101,
      isFocusable: false,
      isTouchable: true,
      privacyMode: false,
      hitTestMode: HitTestMode.Default,
      isOverlayScene: true,
    };
    systemSceneSession =
      new SCBSystemSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), systemSessionInfo, undefined);

    it('test_whenCallbackExist_thenRegisterAndUnregisterSuccess', Level.LEVEL0, () => {
      let text = 'test';
      let callback = () => {
        text = 'called';
      }
      systemSceneSession.registerSessionStateBackgroundCallback('key', callback);
      let sessionStateBackgroundCallbackMap: Map<string, Function> =
        ReflectionUtils.getProperty(systemSceneSession, 'sessionStateBackgroundCallbackMap');
      let sessionStateBackgroundCallback: Function | undefined = sessionStateBackgroundCallbackMap.get('key');
      sessionStateBackgroundCallback && sessionStateBackgroundCallback();
      expect(text).assertEqual('called');

      systemSceneSession.unRegisterSessionStateBackgroundCallback('key');
      sessionStateBackgroundCallback = sessionStateBackgroundCallbackMap.get('key');
      expect(sessionStateBackgroundCallback).assertUndefined();
    });
  });

  describe('SCBSystemSceneSession_registerAndUnregisterSessionStateBackgroundDelayCallback_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    systemSessionInfo = {
      systemType: sceneSessionManager.SessionType.TYPE_UNDEFINED,
      sceneName: 'SCBGestureBackViewModelTest',
      sceneZIndex: 101,
      isFocusable: false,
      isTouchable: true,
      privacyMode: false,
      hitTestMode: HitTestMode.Default,
      isOverlayScene: true,
    };
    systemSceneSession =
      new SCBSystemSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), systemSessionInfo, undefined);

    it('test_whenCallbackExist_thenRegisterAndUnregisterSuccess', Level.LEVEL0, () => {
      let text = 'test';
      let callback = () => {
        text = 'called';
      }
      systemSceneSession.registerSessionStateBackgroundDelayCallback('key', callback);
      let sessionStateBackgroundDelayCallbackMap: Map<string, Function> =
        ReflectionUtils.getProperty(systemSceneSession, 'sessionStateBackgroundDelayCallbackMap');
      let sessionStateBackgroundDelayCallback: Function | undefined = sessionStateBackgroundDelayCallbackMap.get('key');
      sessionStateBackgroundDelayCallback && sessionStateBackgroundDelayCallback();
      expect(text).assertEqual('called');

      systemSceneSession.unRegisterSessionStateBackgroundDelayCallback('key');
      sessionStateBackgroundDelayCallback = sessionStateBackgroundDelayCallbackMap.get('key');
      expect(sessionStateBackgroundDelayCallback).assertUndefined();
    });
  });

  describe('SCBSystemSceneSession_onClick_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    systemSessionInfo = {
      systemType: sceneSessionManager.SessionType.TYPE_UNDEFINED,
      sceneName: 'SCBGestureBackViewModelTest',
      sceneZIndex: 101,
      isFocusable: false,
      isTouchable: true,
      privacyMode: false,
      hitTestMode: HitTestMode.Default,
      isOverlayScene: true,
    };
    systemSceneSession =
      new SCBSystemSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), systemSessionInfo, undefined);

    it('test_whenIsAppUseControlIsFalse_thenRequestToTopFail', Level.LEVEL0, () => {
      systemSceneSession.isAppUseControl = false;
      ReflectionUtils.useFunc(systemSceneSession, 'onClick', true, true);
      expect(systemSceneSession.isAppUseControl).assertFalse();
    });
  });

  describe('SCBSystemSceneSession_getFocusable_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    systemSessionInfo = {
      systemType: sceneSessionManager.SessionType.TYPE_UNDEFINED,
      sceneName: 'SCBGestureBackViewModelTest',
      sceneZIndex: 101,
      isFocusable: false,
      isTouchable: true,
      privacyMode: false,
      hitTestMode: HitTestMode.Default,
      isOverlayScene: true,
    };
    systemSceneSession =
      new SCBSystemSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), systemSessionInfo, undefined);

    it('test_whenIsFocusable_thenReturnTrue', Level.LEVEL0, () => {
      systemSceneSession.isFocusable = true;
      expect(systemSceneSession.getFocusable()).assertTrue();
    });
  });

  describe('SCBSystemSceneSession_getVisibility_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    systemSessionInfo = {
      systemType: sceneSessionManager.SessionType.TYPE_UNDEFINED,
      sceneName: 'SCBGestureBackViewModelTest',
      sceneZIndex: 101,
      isFocusable: false,
      isTouchable: true,
      privacyMode: false,
      hitTestMode: HitTestMode.Default,
      isOverlayScene: true,
    };
    systemSceneSession =
      new SCBSystemSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), systemSessionInfo, undefined);

    it('test_whenVisibilityIsTrue_thenReturnTrue', Level.LEVEL0, () => {
      systemSceneSession.visibility = true;
      expect(systemSceneSession.getVisibility()).assertTrue();
    });
  });

  describe('SCBSystemSceneSession_setHitTestMode_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    systemSessionInfo = {
      systemType: sceneSessionManager.SessionType.TYPE_UNDEFINED,
      sceneName: 'SCBGestureBackViewModelTest',
      sceneZIndex: 101,
      isFocusable: false,
      isTouchable: true,
      privacyMode: false,
      hitTestMode: HitTestMode.Default,
      isOverlayScene: true,
    };
    systemSceneSession =
      new SCBSystemSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), systemSessionInfo, undefined);

    it('test_whenCallbackNotExist_thenCallFail', Level.LEVEL0, () => {
      systemSceneSession.setHitTestMode(HitTestMode.None);
      expect(systemSceneSession.hitTestMode).assertEqual(HitTestMode.Default);
    });
  });

  describe('SCBSystemSceneSession_prepareSystemSceneRotationBeforeAnimation_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    systemSessionInfo = {
      systemType: sceneSessionManager.SessionType.TYPE_UNDEFINED,
      sceneName: 'SCBGestureBackViewModelTest',
      sceneZIndex: 101,
      isFocusable: false,
      isTouchable: true,
      privacyMode: false,
      hitTestMode: HitTestMode.Default,
      isOverlayScene: true,
    };
    systemSceneSession =
      new SCBSystemSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), systemSessionInfo, undefined);

    it('test_whenRotationExist_thenSetSuccess', Level.LEVEL0, () => {
      systemSceneSession.rotation = RotationConstants.ROTATION_270;
      systemSceneSession.prepareSystemSceneRotationBeforeAnimation(0);
      expect(systemSceneSession.rotation).assertEqual(-RotationConstants.ROTATION_90);
    });
  });

  describe('SCBSystemSceneSession_updateRectInPx_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    systemSessionInfo = {
      systemType: sceneSessionManager.SessionType.TYPE_UNDEFINED,
      sceneName: 'SCBGestureBackViewModelTest',
      sceneZIndex: 101,
      isFocusable: false,
      isTouchable: true,
      privacyMode: false,
      hitTestMode: HitTestMode.Default,
      isOverlayScene: true,
    };
    systemSceneSession =
      new SCBSystemSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), systemSessionInfo, undefined);

    it('test_whenCallbackNotExist_thenUpdateFail', Level.LEVEL0, () => {
      systemSceneSession.updateRectInPx(1, 1, 1, 1);
      expect(systemSceneSession.currRect.left.getPx()).assertEqual(0);
    });
  });

  describe('SCBSystemSceneSession_setTranslate_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    systemSessionInfo = {
      systemType: sceneSessionManager.SessionType.TYPE_UNDEFINED,
      sceneName: 'SCBGestureBackViewModelTest',
      sceneZIndex: 101,
      isFocusable: false,
      isTouchable: true,
      privacyMode: false,
      hitTestMode: HitTestMode.Default,
      isOverlayScene: true,
    };
    systemSceneSession =
      new SCBSystemSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), systemSessionInfo, undefined);

    it('test_whenCallbackNotExist_thenSetFail', Level.LEVEL0, () => {
      systemSceneSession.setTranslate(1, 1, 1);
      expect(systemSceneSession.translateX).assertEqual(0);
    });
  });

  describe('SCBSystemSceneSession_setBackgroundColor_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    systemSessionInfo = {
      systemType: sceneSessionManager.SessionType.TYPE_UNDEFINED,
      sceneName: 'SCBGestureBackViewModelTest',
      sceneZIndex: 101,
      isFocusable: false,
      isTouchable: true,
      privacyMode: false,
      hitTestMode: HitTestMode.Default,
      isOverlayScene: true,
    };
    systemSceneSession =
      new SCBSystemSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), systemSessionInfo, undefined);

    it('test_whenCallbackNotExist_thenSetFail', Level.LEVEL0, () => {
      systemSceneSession.setBackgroundColor('red');
      expect(systemSceneSession.backgroundColor).assertEqual('');
    });
  });

  describe('SCBSystemSceneSession_setWindowScale_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    systemSessionInfo = {
      systemType: sceneSessionManager.SessionType.TYPE_UNDEFINED,
      sceneName: 'SCBGestureBackViewModelTest',
      sceneZIndex: 101,
      isFocusable: false,
      isTouchable: true,
      privacyMode: false,
      hitTestMode: HitTestMode.Default,
      isOverlayScene: true,
    };
    systemSceneSession =
      new SCBSystemSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), systemSessionInfo, undefined);

    it('test_whenUpdateFlagIsTrue_thenSetSuccess', Level.LEVEL0, () => {
      systemSceneSession.setWindowScale(2, true);
      let sessionDataInner: SCBSystemSceneSessionDataInner =
        ReflectionUtils.getProperty(systemSceneSession, 'sessionDataInner');
      expect(sessionDataInner.scale).assertEqual(2);
    });
  });

  describe('SCBSystemSceneSession_setRotatable_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    systemSessionInfo = {
      systemType: sceneSessionManager.SessionType.TYPE_UNDEFINED,
      sceneName: 'SCBGestureBackViewModelTest',
      sceneZIndex: 101,
      isFocusable: false,
      isTouchable: true,
      privacyMode: false,
      hitTestMode: HitTestMode.Default,
      isOverlayScene: true,
    };
    systemSceneSession =
      new SCBSystemSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), systemSessionInfo, undefined);

    it('test_whenIsLandscapeStartRotatableIsFalse_thenSetSuccess', Level.LEVEL0, () => {
      systemSceneSession.sessionData.isLandscapeStartRotatable = false;
      let isDesktopRotatable: boolean = SCBWindowRotateController.getInstance().isDesktopRotatable();
      systemSceneSession.setRotatable();
      expect(systemSceneSession.sessionData.isRotatable).assertEqual(isDesktopRotatable);
    });
  });

  describe('SCBSystemSceneSession_AfterUpdateRectCallback_testSuite', () => {
    beforeEach(() => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      systemSessionInfo = {
        systemType: sceneSessionManager.SessionType.TYPE_LAUNCHER_DOCK,
        sceneName: 'SCBSmartDockTest',
        sceneZIndex: 101,
        isFocusable: false,
        isTouchable: true,
        privacyMode: false,
        hitTestMode: HitTestMode.Default,
        isOverlayScene: true,
      };
      systemSceneSession =
        new SCBSystemSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), systemSessionInfo, undefined);
    })

    it('test_AfterUpdateRectCallbackRegister', Level.LEVEL0, () => {
      let text = 'test';
      let callback = () => {
        text = 'called';
      }
      systemSceneSession.registerAfterUpdateRectCallback(callback);
      systemSceneSession.updateRectInPx(1, 1, 1, 1);
      expect(text).assertEqual('called');
    });

    it('test_AfterUpdateRectCallbackUnregister', Level.LEVEL0, () => {
      let text = 'test';
      let callback = () => {
        text = 'called';
      }
      systemSceneSession.registerAfterUpdateRectCallback(callback);
      systemSceneSession.unregisterAfterUpdateRectCallback();
      systemSceneSession.updateRectInPx(1, 1, 1, 1);
      expect(text).assertEqual('test');
    });
  });
}

function isSessionForegroundTest() {
  it('isSessionForeground', 0, () => {
    systemSceneSession.sessionData.sessionState = sceneSessionManager.SessionState.STATE_FOREGROUND;
    let ret1 = systemSceneSession.isSessionForeground();
    expect(ret1).assertTrue();

    systemSceneSession.sessionData.sessionState = sceneSessionManager.SessionState.STATE_ACTIVE;
    let ret2 = systemSceneSession.isSessionForeground();
    expect(ret2).assertTrue();

    systemSceneSession.sessionData.sessionState = sceneSessionManager.SessionState.STATE_BACKGROUND;
    let ret3 = systemSceneSession.isSessionForeground();
    expect(ret3).assertFalse();
  })
}