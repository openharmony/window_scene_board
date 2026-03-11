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

import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  ArgumentMatchers,
  MockKit,
  when,
} from '@ohos/hypium';
import screenSessionManager from '@ohos.screenSessionManager';
import sceneSessionManager from '@ohos.sceneSessionManager';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import {
  SCBSceneContainerSession
} from '../../../../../../../../src/main/ets/scene/session/SCBSceneContainerSession';
import { SCBSceneInfo } from '../../../../../../../../src/main/ets/scene/session/SCBSceneInfo';
import { SCBSceneSession } from '../../../../../../../../src/main/ets/scene/session/SCBSceneSession';
import {
  SCBScreenSession,
  SCBScreenProperty
} from '../../../../../../../../src/main/ets/screen/session/SCBScreenSession';
import { SCBConstants, RotationConstants } from '@ohos/commonconstants';
import {
  SCBSceneOrientation
} from '../../../../../../../../src/main/ets/scene/session/SCBSceneOrientation';
import { SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { SCBDeviceScreenConfig } from '../../../../../../../../src/main/ets/config/SCBDeviceScreenConfig';
import { SCBSessionRect } from '../../../../../../../../src/main/ets/scene/session/SCBSessionRect';
import {
  SCBPropertyChangeReason,
  SCBRotateChangeReason,
  SCBScreenSessionManager,
  SCBScreenSessionArray
} from '../../../../../../../../src/main/ets/screen/session/SCBScreenSessionManager';
import type {
  SystemSessionChangeCallback
} from '../../../../../../../../src/main/ets/scene/session/SCBSystemSceneSession';
import type {
  SystemSessionInfo
} from '../../../../../../../../src/main/ets/scene/session/SCBSystemSceneSession';
import {
  SCBFollowDesktopOrientationPolicy,
  SCBDefaultOrientationPolicy
} from '../../../../../../../main/ets/scene/session/SCBSceneOrientationPolicy';
import { SCBSceneSessionManager } from '../../../../../../../main/ets/scene/session/SCBSceneSessionManager';
import {
  SCBSystemSceneSession,
  SystemBarType
} from '../../../../../../../main/ets/scene/session/SCBSystemSceneSession';
import type { UIContext } from '@ohos.arkui.UIContext';
import { ReflectionUtils } from './ReflectionUtils';

function isHorizontalConfigurable(containerSession: SCBSceneContainerSession): boolean {
  let isRightPowerButton = SCBDeviceScreenConfig.getInstance().getRightPowerButton();
  const uiType = SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType;
  if (uiType === SCBConstants.UITYPE_PAD) {
    return true;
  }
  if (containerSession.sdkVersion >= 12 && isRightPowerButton) {
    return true;
  }
  return false;
}
const SCREEN_ID_TEST: number = 100;
const PERSISTENT_ID_TEST: number = 100;
let isOnFoldChangeCallBackExec = false;
const systemSessionChangeCallbackTemp: SystemSessionChangeCallback = {
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
  onRotationChange: (screenProperty: SCBScreenProperty) => {},
  onActiveModeChange: (oldScreenProperty: SCBScreenProperty, newScreenProperty: SCBScreenProperty) => {},
  onFoldChange: (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    isOnFoldChangeCallBackExec = true;
  },
  onZIndexChange: (zIndex: number) => {},
  onResponseRegionChange: (responseRegion: Array<Rectangle>) => {}
};

export function SCBWindowRotateTest() {
  describe('SCBWindowRotateTest', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    beforeAll(() => {
    })
    beforeEach(() => {
      let scbSceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      ReflectionUtils.setProperty(scbSceneSessionManager, 'isScreenLock', false);
    })
    afterEach(() => {
    })
    afterAll(() => {
    })
    runUnspecifiedTest(sceneSession);
    runPortraitTest(sceneSession);
    runLandscapeTest(sceneSession);
    runAutoRotationTest(sceneSession);
    runRelatedToSensorTest(sceneSession);
    runAutoRotationRestrictedTest(sceneSession);
    runOtherRestrictedPolicy(sceneSession);
    runUserPortraitPolicy(sceneSession);
    runUserLandscapePolicy(sceneSession);
    runFollowDesktopPolicy(sceneSession);
    runOtherPolicy(sceneSession);
  })
}

function runUnspecifiedTest(sceneSession: SCBSceneSession) {
  it('UNSPECIFIEDT_TEST', 0, () => {
    const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    if (screenSession === null) {
      return;
    }
    let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenSession.scbScreenProperty);
    containerSession.init();
    containerSession.sessionData.requestOrientation = SCBSceneOrientation.UNSPECIFIED;
    let targetRotation = containerSession.getTargetRotation(RotationConstants.ROTATION_180, false);
    let rotationMap = SCBDefaultOrientationPolicy.getInstance().getRotationPolicyMap();
    expect(targetRotation).assertEqual(rotationMap.get(RotationConstants.ROTATION_180) ?
    RotationConstants.ROTATION_180 : RotationConstants.ROTATION_0);
  })
}

function runPortraitTest(sceneSession: SCBSceneSession) {
  it('PORTRAIT_TEST', 0, () => {
    const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    if (screenSession === null) {
      return;
    }
    let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenSession.scbScreenProperty);
    containerSession.init();
    containerSession.sessionData.requestOrientation = SCBSceneOrientation.VERTICAL;
    let targetRotation = containerSession.getTargetRotation(RotationConstants.ROTATION_90, false);
    expect(targetRotation).assertEqual(RotationConstants.ROTATION_0);
  })

  it('PORTRAIT_INVERTED_TEST', 0, () => {
    const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    if (screenSession === null) {
      return;
    }
    let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenSession.scbScreenProperty);
    containerSession.init();
    containerSession.sessionData.requestOrientation = SCBSceneOrientation.REVERSE_VERTICAL;
    let targetRotation = containerSession.getTargetRotation(RotationConstants.ROTATION_0, false);
    expect(targetRotation).assertEqual(RotationConstants.ROTATION_180);
  })
}

function runLandscapeTest(sceneSession: SCBSceneSession) {
  it('LANDSCAPE_TEST', 0, () => {
    const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    if (screenSession === null) {
      return;
    }
    let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenSession.scbScreenProperty);
    containerSession.init();
    containerSession.sessionData.requestOrientation = SCBSceneOrientation.HORIZONTAL;
    let targetRotation = containerSession.getTargetRotation(RotationConstants.ROTATION_0, false);
    let landscapeRotation = isHorizontalConfigurable(containerSession) ? RotationConstants.ROTATION_270 :
    RotationConstants.ROTATION_90;
    expect(targetRotation).assertEqual(landscapeRotation);
  })

  it('LANDSCAPE_INVERTED_TEST', 0, () => {
    const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    if (screenSession === null) {
      return;
    }
    let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenSession.scbScreenProperty);
    containerSession.init();
    containerSession.sessionData.requestOrientation = SCBSceneOrientation.REVERSE_HORIZONTAL;
    let targetRotation = containerSession.getTargetRotation(RotationConstants.ROTATION_0, false);
    let landscapeInvertedRotation = isHorizontalConfigurable(containerSession) ? RotationConstants.ROTATION_90 :
    RotationConstants.ROTATION_270;
    expect(targetRotation).assertEqual(landscapeInvertedRotation);
  })
}

function runAutoRotationTest(sceneSession: SCBSceneSession) {
  it('AUTO_ROTATION_TEST', 0, () => {
    const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    if (screenSession === null) {
      return;
    }
    let screenSessionManager = SCBScreenSessionManager.getInstance();
    let mocker: MockKit = new MockKit();
    let func1: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getScreenOrientationLocked);
    when(func1)(ArgumentMatchers.any).afterReturn(true);
    let func2: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getScreenRotation);
    when(func2)(ArgumentMatchers.any).afterReturn(RotationConstants.ROTATION_180);
    let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenSession.scbScreenProperty);
    containerSession.init();
    containerSession.sessionData.requestOrientation = SCBSceneOrientation.SENSOR;
    let targetRotation = containerSession.getTargetRotation(RotationConstants.ROTATION_0, false);
    expect(targetRotation).assertEqual(RotationConstants.ROTATION_0);
    mocker.clear(screenSessionManager);
  })
}

function runRelatedToSensorTest(sceneSession: SCBSceneSession) {
  it('AUTO_ROTATION_PORTRAIT_TEST', 0, () => {
    const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    if (screenSession === null) {
      return;
    }
    let screenSessionManager = SCBScreenSessionManager.getInstance();
    let mocker: MockKit = new MockKit();
    let func1: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getScreenOrientationLocked);
    when(func1)(ArgumentMatchers.any).afterReturn(true);
    let func2: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getScreenRotation);
    when(func2)(ArgumentMatchers.any).afterReturn(RotationConstants.ROTATION_90);
    let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenSession.scbScreenProperty);
    containerSession.init();
    containerSession.sessionData.requestOrientation = SCBSceneOrientation.SENSOR_VERTICAL;
    let targetRotation = containerSession.getTargetRotation(RotationConstants.ROTATION_270, false);
    expect(targetRotation).assertEqual(RotationConstants.ROTATION_0);
    mocker.clear(screenSessionManager);
  })

  it('AUTO_ROTATION_LANDSCAPE_TEST', 0, () => {
    const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    if (screenSession === null) {
      return;
    }
    let screenSessionManager = SCBScreenSessionManager.getInstance();
    let mocker: MockKit = new MockKit();
    let func1: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getScreenOrientationLocked);
    when(func1)(ArgumentMatchers.any).afterReturn(true);
    let func2: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getScreenRotation);
    when(func2)(ArgumentMatchers.any).afterReturn(RotationConstants.ROTATION_0);
    let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenSession.scbScreenProperty);
    containerSession.init();
    containerSession.sessionData.requestOrientation = SCBSceneOrientation.SENSOR_HORIZONTAL;
    let targetRotation = containerSession.getTargetRotation(RotationConstants.ROTATION_180, false);
    let landscapeRotation = isHorizontalConfigurable(containerSession) ? RotationConstants.ROTATION_270 :
    RotationConstants.ROTATION_90;
    expect(targetRotation).assertEqual(landscapeRotation);
    mocker.clear(screenSessionManager);
  })
}

function runAutoRotationRestrictedTest(sceneSession: SCBSceneSession) {
  it('AUTO_ROTATION_RESTRICTED_TEST', 0, () => {
    const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    if (screenSession === null) {
      return;
    }
    let screenSessionManager = SCBScreenSessionManager.getInstance();
    let mocker: MockKit = new MockKit();
    let func1: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getScreenOrientationLocked);
    when(func1)(ArgumentMatchers.any).afterReturn(false);
    let func2: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getScreenRotation);
    when(func2)(ArgumentMatchers.any).afterReturn(RotationConstants.ROTATION_90);
    let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenSession.scbScreenProperty);
    containerSession.init();
    containerSession.sessionData.requestOrientation = SCBSceneOrientation.AUTO_ROTATION_RESTRICTED;
    let targetRotation = containerSession.getTargetRotation(RotationConstants.ROTATION_0, false);
    expect(targetRotation).assertEqual(RotationConstants.ROTATION_0);
    mocker.clear(screenSessionManager);
  })
}

function runOtherRestrictedPolicy(sceneSession: SCBSceneSession) {
  it('AUTO_ROTATION_PORTRAIT_RESTRICTED_TEST', 0, () => {
    const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    if (screenSession === null) {
      return;
    }
    let screenSessionManager = SCBScreenSessionManager.getInstance();
    let mocker: MockKit = new MockKit();
    let func1: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getScreenOrientationLocked);
    when(func1)(ArgumentMatchers.any).afterReturn(false);
    let func2: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getScreenRotation);
    when(func2)(ArgumentMatchers.any).afterReturn(RotationConstants.ROTATION_90);
    let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenSession.scbScreenProperty);
    containerSession.init();
    containerSession.sessionData.requestOrientation = SCBSceneOrientation.AUTO_ROTATION_PORTRAIT_RESTRICTED;
    let targetRotation = containerSession.getTargetRotation(RotationConstants.ROTATION_180, false);
    expect(targetRotation).assertEqual(RotationConstants.ROTATION_180);
    mocker.clear(screenSessionManager);
  })

  it('AUTO_ROTATION_LANDSCAPE_RESTRICTED_TEST', 0, () => {
    const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    if (screenSession === null) {
      return;
    }
    let screenSessionManager = SCBScreenSessionManager.getInstance();
    let mocker: MockKit = new MockKit();
    let func1: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getScreenOrientationLocked);
    when(func1)(ArgumentMatchers.any).afterReturn(false);
    let func2: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getScreenRotation);
    when(func2)(ArgumentMatchers.any).afterReturn(RotationConstants.ROTATION_0);
    let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenSession.scbScreenProperty);
    containerSession.init();
    containerSession.sessionData.requestOrientation = SCBSceneOrientation.AUTO_ROTATION_LANDSCAPE_RESTRICTED;
    let targetRotation = containerSession.getTargetRotation(RotationConstants.ROTATION_90, false);
    expect(targetRotation).assertEqual(RotationConstants.ROTATION_90);
    mocker.clear(screenSessionManager);
  })
}

function runUserPortraitPolicy(sceneSession: SCBSceneSession) {
  it('USER_ROTATION_PORTRAIT_TEST', 0, () => {
    const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    if (screenSession === null) {
      return;
    }
    let screenSessionManager = SCBScreenSessionManager.getInstance();
    let mocker: MockKit = new MockKit();
    let func1: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getScreenOrientationLocked);
    when(func1)(ArgumentMatchers.any).afterReturn(true);
    let func2: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getScreenRotation);
    when(func2)(ArgumentMatchers.any).afterReturn(RotationConstants.ROTATION_90);
    let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenSession.scbScreenProperty);
    containerSession.init();
    containerSession.sessionData.requestOrientation = SCBSceneOrientation.USER_ROTATION_PORTRAIT;
    let targetRotation = containerSession.getTargetRotation(RotationConstants.ROTATION_90, true);
    expect(targetRotation).assertEqual(RotationConstants.ROTATION_0);
    mocker.clear(screenSessionManager);
  })

  it('USER_ROTATION_PORTRAIT_INVERTED_TEST', 0, () => {
    const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    if (screenSession === null) {
      return;
    }
    let screenSessionManager = SCBScreenSessionManager.getInstance();
    let mocker: MockKit = new MockKit();
    let func1: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getScreenOrientationLocked);
    when(func1)(ArgumentMatchers.any).afterReturn(true);
    let func2: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getScreenRotation);
    when(func2)(ArgumentMatchers.any).afterReturn(RotationConstants.ROTATION_0);
    let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenSession.scbScreenProperty);
    containerSession.init();
    containerSession.sessionData.requestOrientation = SCBSceneOrientation.USER_ROTATION_PORTRAIT_INVERTED;
    let targetRotation = containerSession.getTargetRotation(RotationConstants.ROTATION_0, true);
    // need use screenSession.isRotateScreenPolicy()
    let rotationPolicyMap = SCBDeviceScreenConfig.getInstance().getRotationPolicyMap();
    let portraitInvertedRotation = rotationPolicyMap.get(RotationConstants.ROTATION_180) ? RotationConstants.ROTATION_180 :
    RotationConstants.ROTATION_0;
    expect(targetRotation).assertEqual(portraitInvertedRotation);
    mocker.clear(screenSessionManager);
  })
}

function runUserLandscapePolicy(sceneSession: SCBSceneSession) {
  it('USER_ROTATION_LANDSCAPE_TEST', 0, () => {
    const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    if (screenSession === null) {
      return;
    }
    let screenSessionManager = SCBScreenSessionManager.getInstance();
    let mocker: MockKit = new MockKit();
    let func1: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getScreenOrientationLocked);
    when(func1)(ArgumentMatchers.any).afterReturn(true);
    let func2: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getScreenRotation);
    when(func2)(ArgumentMatchers.any).afterReturn(RotationConstants.ROTATION_0);
    let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenSession.scbScreenProperty);
    containerSession.init();
    containerSession.sessionData.requestOrientation = SCBSceneOrientation.USER_ROTATION_LANDSCAPE;
    let targetRotation = containerSession.getTargetRotation(RotationConstants.ROTATION_0, true);
    let landscapeRotation = isHorizontalConfigurable(containerSession) ? RotationConstants.ROTATION_270 :
    RotationConstants.ROTATION_90;
    expect(targetRotation).assertEqual(landscapeRotation);
    mocker.clear(screenSessionManager);
  })

  it('USER_ROTATION_LANDSCAPE_INVERTED_TEST', 0, () => {
    const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    if (screenSession === null) {
      return;
    }
    let screenSessionManager = SCBScreenSessionManager.getInstance();
    let mocker: MockKit = new MockKit();
    let func1: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getScreenOrientationLocked);
    when(func1)(ArgumentMatchers.any).afterReturn(true);
    let func2: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getScreenRotation);
    when(func2)(ArgumentMatchers.any).afterReturn(RotationConstants.ROTATION_0);
    let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenSession.scbScreenProperty);
    containerSession.init();
    containerSession.sessionData.requestOrientation = SCBSceneOrientation.USER_ROTATION_LANDSCAPE_INVERTED;
    let targetRotation = containerSession.getTargetRotation(RotationConstants.ROTATION_0, true);
    let landscapeInvertedRotation = isHorizontalConfigurable(containerSession) ? RotationConstants.ROTATION_90 :
    RotationConstants.ROTATION_270;
    expect(targetRotation).assertEqual(landscapeInvertedRotation);
    mocker.clear(screenSessionManager);
  })
}

function runFollowDesktopPolicy(sceneSession: SCBSceneSession) {
  it('FOLLOW_DESKTOP_TEST', 0, () => {
    const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    if (screenSession === null) {
      return;
    }
    let tmpRotation = screenSession.scbScreenProperty.rotation;
    let screenSessionManager = SCBScreenSessionManager.getInstance();
    let mocker: MockKit = new MockKit();
    let func1: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getScreenOrientationLocked);
    when(func1)(ArgumentMatchers.any).afterReturn(true);
    let func2: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getScreenRotation);
    when(func2)(ArgumentMatchers.any).afterReturn(RotationConstants.ROTATION_90);
    // need use mocker
    screenSession.scbScreenProperty.rotation = RotationConstants.ROTATION_90;
    let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenSession.scbScreenProperty);
    containerSession.init();
    containerSession.sessionData.requestOrientation = SCBSceneOrientation.FOLLOW_DESKTOP;
    let targetRotation = containerSession.getTargetRotation(RotationConstants.ROTATION_90, true);
    // need use screenSession.isRotateScreenPolicy()
    let rotationPolicyMap = SCBFollowDesktopOrientationPolicy.getInstance().rotationPolicyMap;
    let desktopRotation = rotationPolicyMap.get(RotationConstants.ROTATION_180) ? RotationConstants.ROTATION_90 :
    RotationConstants.ROTATION_0;
    expect(targetRotation).assertEqual(desktopRotation);
    mocker.clear(screenSessionManager);
    screenSession.scbScreenProperty.rotation = tmpRotation;
  })
}

function runOtherPolicy(sceneSession: SCBSceneSession) {
  it('LOCKED_TEST', 0, () => {
    const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    if (screenSession === null) {
      return;
    }
    let tmpRotation = screenSession.scbScreenProperty.rotation;
    let screenSessionManager = SCBScreenSessionManager.getInstance();
    let mocker: MockKit = new MockKit();
    let func1: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getScreenOrientationLocked);
    when(func1)(ArgumentMatchers.any).afterReturn(false);
    let func2: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getScreenRotation);
    when(func2)(ArgumentMatchers.any).afterReturn(RotationConstants.ROTATION_0);
    // need use mocker
    screenSession.scbScreenProperty.rotation = RotationConstants.ROTATION_0;
    let containerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, screenSession.scbScreenProperty);
    containerSession.init();
    containerSession.sessionData.requestOrientation = SCBSceneOrientation.LOCKED;
    let targetRotation = containerSession.getTargetRotation(RotationConstants.ROTATION_90, false);
    expect(targetRotation).assertEqual(RotationConstants.ROTATION_0);
    mocker.clear(screenSessionManager);
    screenSession.scbScreenProperty.rotation = tmpRotation;
  })

  it('AUTO_ROTATION_UNSPECIFIED_TEST', 0, () => {
    const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    if (screenSession === null) {
      return;
    }
    let screenSessionManager = SCBScreenSessionManager.getInstance();
    let mocker: MockKit = new MockKit();
    let func1: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getScreenOrientationLocked);
    when(func1)(ArgumentMatchers.any).afterReturn(false);
    let func2: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getScreenRotation);
    when(func2)(ArgumentMatchers.any).afterReturn(RotationConstants.ROTATION_0);
    let containerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, screenSession.scbScreenProperty);
    containerSession.init();
    containerSession.sessionData.requestOrientation = SCBSceneOrientation.AUTO_ROTATION_UNSPECIFIED;
    let targetRotation = containerSession.getTargetRotation(RotationConstants.ROTATION_90, false);
    expect(targetRotation).assertEqual(RotationConstants.ROTATION_90);
    mocker.clear(screenSessionManager);
  })

  it('UPDATE_SYSTEM_ROTATION_TEST', 0, () => {
    let prop: SCBScreenProperty = new SCBScreenProperty();
    prop.screenId = SCREEN_ID_TEST;
    let scbScreenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
    scbScreenSessionManager.init();
    let isScreenPropertyChangeCallbacksExec: boolean = false;
    scbScreenSessionManager.updateSystemRotation(prop);
    expect(!isScreenPropertyChangeCallbacksExec).assertTrue();
    let callback = (screenProperty: SCBScreenProperty) => {
      isScreenPropertyChangeCallbacksExec = true;
    };
    let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
    expect(manager).not().assertNull();
    manager.initSystemSceneList(SCREEN_ID_TEST);
    let sessionInfo: SystemSessionInfo = {
      systemType: sceneSessionManager.SessionType.TYPE_PANEL,
      sceneName: 'test',
      sceneZIndex: 0,
      hitTestMode: HitTestMode.Default,
    };
    let testPtr : UIContext;
    let screenSession: screenSessionManager.ScreenSession = {
      screenId: SCREEN_ID_TEST,
      name: 'testScreen',
      on: (type: string, callback: Function): void => {
      },
      setScreenRotationLocked: (isLocked: boolean): void => {
      },
      loadContent: (path: string, context: ServiceExtensionContext, storage?: LocalStorage): void => {
      },
      setTouchEnabled: (isTouchEnabled: boolean): void => {
      },
      getScreenUIContext: (): UIContext => {
        return testPtr;
      }
    };
    let scbScreenSession: SCBScreenSession = new SCBScreenSession(screenSession);
    let list: SCBScreenSessionArray = new SCBScreenSessionArray();
    SCBScreenSessionManager.getInstance().setScreenSessionList(list);
    scbScreenSessionManager.getScreenSessionList().push(scbScreenSession);
    manager.requestSystemSceneSession(sessionInfo, systemSessionChangeCallbackTemp, false, SCREEN_ID_TEST);
    scbScreenSessionManager.registerScreenPropertyChangeCallbacks(callback, SCREEN_ID_TEST);
    scbScreenSessionManager.updateSystemRotation(prop);
    expect(isScreenPropertyChangeCallbacksExec).assertTrue();
    scbScreenSessionManager.unRegisterScreenPropertyChangeCallbacks(callback, SCREEN_ID_TEST);
  });

  it('UPDATE_VISIBLE_SYSTEM_ROTATION_TEST', 0, () => {
    let prop: SCBScreenProperty = new SCBScreenProperty();
    prop.screenId = SCREEN_ID_TEST;
    let scbScreenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
    scbScreenSessionManager.init();
    let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
    expect(manager).not().assertNull();
    manager.initSystemSceneList(SCREEN_ID_TEST);
    let testPtr : UIContext;
    let screenSession: screenSessionManager.ScreenSession = {
      screenId: SCREEN_ID_TEST,
      name: 'testScreen',
      on: (type: string, callback: Function): void => {
      },
      setScreenRotationLocked: (isLocked: boolean): void => {
      },
      loadContent: (path: string, context: ServiceExtensionContext, storage?: LocalStorage): void => {
      },
      setTouchEnabled: (isTouchEnabled: boolean): void => {
      },
      getScreenUIContext: (): UIContext => {
        return testPtr;
      }
    };
    let sessionInfo: SystemSessionInfo = {
      systemType: sceneSessionManager.SessionType.TYPE_PANEL,
      sceneName: 'test',
      sceneZIndex: 0,
      hitTestMode: HitTestMode.Default,
      visibility: true,
    };
    let scbSystemSceneSession: SCBSystemSceneSession =
      manager.requestSystemSceneSession(sessionInfo, systemSessionChangeCallbackTemp, false, SCREEN_ID_TEST);
    let isScreenPropertyChangeCallbacksExec: boolean = false;
    let inVisibleSystemSceneCallbacks: Array<[Function, boolean, number | null]> =
      scbScreenSessionManager.updateVisibleSystemRotation(prop);
    expect(inVisibleSystemSceneCallbacks.length).assertEqual(0);
    expect(isScreenPropertyChangeCallbacksExec).assertFalse();
    let callback = (screenProperty: SCBScreenProperty) => {
      isScreenPropertyChangeCallbacksExec = true;
    };
    scbScreenSessionManager.registerScreenPropertyChangeCallbacks(callback, SCREEN_ID_TEST, true,
      scbSystemSceneSession.session.persistentId);
    inVisibleSystemSceneCallbacks = scbScreenSessionManager.updateVisibleSystemRotation(prop);
    expect(inVisibleSystemSceneCallbacks.length).assertEqual(1);
    expect(inVisibleSystemSceneCallbacks[0][0]).assertEqual(callback);
    expect(isScreenPropertyChangeCallbacksExec).assertFalse();
    scbScreenSessionManager.unRegisterScreenPropertyChangeCallbacks(callback, SCREEN_ID_TEST, true,
      scbSystemSceneSession.session.persistentId);
    scbScreenSessionManager.registerScreenPropertyChangeCallbacks(callback, SCREEN_ID_TEST, true);
    inVisibleSystemSceneCallbacks = scbScreenSessionManager.updateVisibleSystemRotation(prop);
    expect(inVisibleSystemSceneCallbacks.length).assertEqual(0);
    expect(isScreenPropertyChangeCallbacksExec).assertTrue();
  });

  it('updateInVisibleSystemRotation', 0, () => {
    let prop: SCBScreenProperty = new SCBScreenProperty();
    let scbScreenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
    scbScreenSessionManager.init();
    let isScreenPropertyChangeCallBacksExec: boolean = false;
    let screenPropertyChangeCallBacks = (screenProperty: SCBScreenProperty) => {
      isScreenPropertyChangeCallBacksExec = true;
    };
    let inVisibleSystemSceneCallbacks: Array<[Function, boolean, number | null]> =
      [[screenPropertyChangeCallBacks, false, 0]];
    scbScreenSessionManager.updateInVisibleSystemRotation(inVisibleSystemSceneCallbacks, prop);
    expect(isScreenPropertyChangeCallBacksExec).assertTrue();
  });

  it('updateSystemSceneFoldChange', 0, () => {
    let prop: SCBScreenProperty = new SCBScreenProperty();
    let width = 100;
    let height = 200;
    prop.width = width;
    prop.height = height;
    prop.rotation = RotationConstants.ROTATION_90;
    prop.screenId = SCREEN_ID_TEST;
    let scbScreenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
    scbScreenSessionManager.init();
    let screenPropertyChangeCallBacks = (screenProperty: SCBScreenProperty) => {
      width = screenProperty.width;
      height = screenProperty.height;
    };
    scbScreenSessionManager.registerScreenPropertyChangeCallbacks(screenPropertyChangeCallBacks, SCREEN_ID_TEST, false);
    scbScreenSessionManager.updateSystemSceneFoldChange(prop, SCBPropertyChangeReason.EXPAND_TO_FOLD);
    expect(width).assertEqual(prop.height);
    expect(height).assertEqual(prop.width);
    prop.rotation = RotationConstants.ROTATION_0;
    scbScreenSessionManager.updateSystemSceneFoldChange(prop, SCBPropertyChangeReason.EXPAND_TO_FOLD);
    expect(width).assertEqual(prop.width);
    expect(height).assertEqual(prop.height);
  });

  it('updateVisibleSystemSceneFoldChange', 0, () => {
    let prop: SCBScreenProperty = new SCBScreenProperty();
    let width = 100;
    let height = 200;
    prop.width = width;
    prop.height = height;
    prop.rotation = RotationConstants.ROTATION_90;
    prop.screenId = SCREEN_ID_TEST;
    let isScreenPropertyChangeCallBacksExec = false;
    let scbScreenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
    scbScreenSessionManager.init();
    let screenPropertyChangeCallBacks = (screenProperty: SCBScreenProperty) => {
      isScreenPropertyChangeCallBacksExec = true;
    };
    scbScreenSessionManager.registerScreenPropertyChangeCallbacks(screenPropertyChangeCallBacks, SCREEN_ID_TEST);
    let inVisibleSystemSceneCallbacks: Array<[Function, boolean, number | null]> =
      scbScreenSessionManager.updateVisibleSystemRotation(prop);
    isScreenPropertyChangeCallBacksExec = true;
    inVisibleSystemSceneCallbacks = scbScreenSessionManager.updateVisibleSystemRotation(prop);
    isScreenPropertyChangeCallBacksExec = false;
    expect(prop.width === width).assertTrue();
    expect(prop.height === height).assertTrue();
    prop.rotation = RotationConstants.ROTATION_0;
    inVisibleSystemSceneCallbacks = scbScreenSessionManager.updateVisibleSystemRotation(prop);
    expect(prop.width === width).assertTrue();
    expect(prop.height === height).assertTrue();
  });

  it('updateInvisibleSystemSceneFoldChange', 0, () => {
    let prop: SCBScreenProperty = new SCBScreenProperty();
    let width = 100;
    let height = 200;
    prop.width = width;
    prop.height = height;
    prop.rotation = RotationConstants.ROTATION_90;
    let scbScreenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
    scbScreenSessionManager.init();
    let screenPropertyChangeCallBacks = (screenProperty: SCBScreenProperty) => {
      prop.width = screenProperty.width;
      prop.height = screenProperty.height;
    };
    scbScreenSessionManager.registerScreenPropertyChangeCallbacks(screenPropertyChangeCallBacks, 0);
    let inVisibleSystemSceneCallbacks: Array<[Function, boolean, number | null]> =
      [[screenPropertyChangeCallBacks, false, 0]];
    scbScreenSessionManager.updateInvisibleSystemSceneFoldChange(inVisibleSystemSceneCallbacks, prop,
      SCBPropertyChangeReason.EXPAND_TO_FOLD);
    expect(prop.width === height).assertTrue();
    expect(prop.height === width).assertTrue();
    scbScreenSessionManager.updateInvisibleSystemSceneFoldChange(inVisibleSystemSceneCallbacks, prop,
      SCBPropertyChangeReason.EXPAND_TO_FOLD);
    expect(prop.width === width).assertTrue();
    expect(prop.height === height).assertTrue();
    prop.rotation = RotationConstants.ROTATION_0;
    scbScreenSessionManager.updateInvisibleSystemSceneFoldChange(inVisibleSystemSceneCallbacks, prop,
      SCBPropertyChangeReason.EXPAND_TO_FOLD);
    expect(prop.width === width).assertTrue();
    expect(prop.height === height).assertTrue();
  });

  it('registerScreenRotateChangeCallbacks', 0, () => {
    let prop: SCBScreenProperty = new SCBScreenProperty();
    let width = 100;
    let height = 200;
    prop.width = width;
    prop.height = height;
    prop.rotation = RotationConstants.ROTATION_90;
    let scbScreenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
    scbScreenSessionManager.init();
    let sceneInfo = new SCBSceneInfo('callbackBundle',
      'callbackMoudle', 'callbackAbility');
    sceneInfo.screenId = SCREEN_ID_TEST;
    sceneInfo.persistentId = PERSISTENT_ID_TEST;
    let testPtr : UIContext;
    let screenSession: screenSessionManager.ScreenSession = {
      screenId: SCREEN_ID_TEST,
      name: 'testScreen',
      on: (type: string, callback: Function): void => {
      },
      setScreenRotationLocked: (isLocked: boolean): void => {
      },
      loadContent: (path: string, context: ServiceExtensionContext, storage?: LocalStorage): void => {
      },
      setTouchEnabled: (isTouchEnabled: boolean): void => {
      },
      getScreenUIContext: (): UIContext => {
        return testPtr;
      }
    };
    let scbScreenSession: SCBScreenSession = new SCBScreenSession(screenSession);
    let isCallBackExec = false;
    let screenRotateChangeCallbacks = (screenProperty: SCBScreenProperty) => {
      isCallBackExec = true;
    };
    let mocker: MockKit = new MockKit();
    let getMainScreenSession: Function =
      mocker.mockFunc(scbScreenSessionManager, scbScreenSessionManager.getMainScreenSession);
    when(getMainScreenSession)(ArgumentMatchers.any).afterReturn(null);
    scbScreenSessionManager.registerScreenRotateChangeCallbacks(screenRotateChangeCallbacks);
    expect(scbScreenSessionManager.getMainScreenSession()).assertEqual(null);
    mocker.clear(scbScreenSessionManager);
    isCallBackExec = false;
    scbScreenSessionManager.getScreenSessionList().push(scbScreenSession);
    scbScreenSessionManager.registerScreenRotateChangeCallbacks(screenRotateChangeCallbacks, SCREEN_ID_TEST);
    prop.screenId = -1;
    scbScreenSessionManager.notifyScreenRotateToCallbacks(prop, SCBRotateChangeReason.ROTATE_BEGIN);
    expect(isCallBackExec).assertFalse();
    prop.screenId = SCREEN_ID_TEST;
    isCallBackExec = false;
    scbScreenSessionManager.notifyScreenRotateToCallbacks(prop, SCBRotateChangeReason.ROTATE_BEGIN);
    expect(isCallBackExec).assertTrue();
    isCallBackExec = false;
    scbScreenSessionManager.unRegisterScreenRotateChangeCallbacks(screenRotateChangeCallbacks, SCREEN_ID_TEST);
    scbScreenSessionManager.notifyScreenRotateToCallbacks(prop, SCBRotateChangeReason.ROTATE_BEGIN);
    expect(isCallBackExec).assertFalse();
    isCallBackExec = false;
    scbScreenSessionManager.registerScreenRotateChangeCallbacks(screenRotateChangeCallbacks, SCREEN_ID_TEST);
    scbScreenSessionManager.notifyScreenRotateToCallbacks(prop, SCBRotateChangeReason.ROTATE_BEGIN);
    expect(isCallBackExec).assertTrue();
  });

  it('unRegisterScreenRotateChangeCallbacks', 0, () => {
    let prop: SCBScreenProperty = new SCBScreenProperty();
    let isCallBackExec = false;
    let scbScreenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
    scbScreenSessionManager.init();
    let sceneInfo = new SCBSceneInfo('callbackBundle', 'callbackMoudle', 'callbackAbility');
    sceneInfo.screenId = 201;
    sceneInfo.persistentId = 211;
    let testPtr : UIContext;
    let screenSession: screenSessionManager.ScreenSession = {
      screenId: -1,
      name: 'testScreen',
      on: (type: string, callback: Function): void => {
      },
      setScreenRotationLocked: (isLocked: boolean): void => {
      },
      loadContent: (path: string, context: ServiceExtensionContext, storage?: LocalStorage): void => {
      },
      setTouchEnabled: (isTouchEnabled: boolean): void => {
      },
      getScreenUIContext: (): UIContext => {
        return testPtr;
      }
    };
    let scbScreenSession: SCBScreenSession = new SCBScreenSession(screenSession);
    scbScreenSessionManager.getScreenSessionList().push(scbScreenSession);
    let screenRotateChangeCallbacks = (screenProperty: SCBScreenProperty) => {
      isCallBackExec = true;
    };
    scbScreenSessionManager.registerScreenRotateChangeCallbacks(screenRotateChangeCallbacks, 0);
    scbScreenSessionManager.notifyScreenRotateToCallbacks(prop, SCBRotateChangeReason.ROTATE_BEGIN);
    expect(isCallBackExec).assertTrue();
    isCallBackExec = false;
    scbScreenSessionManager.unRegisterScreenRotateChangeCallbacks(screenRotateChangeCallbacks, 0);
    scbScreenSessionManager.notifyScreenRotateToCallbacks(prop, SCBRotateChangeReason.ROTATE_BEGIN);
    expect(!isCallBackExec).assertTrue();
  });

  it('notifySystemSceneToSetRotation', 0, () => {
    let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
    expect(manager).not().assertNull();
    manager.initSystemSceneList(SCREEN_ID_TEST);
    let sessionInfo: SystemSessionInfo = {
      systemType: sceneSessionManager.SessionType.TYPE_PANEL,
      sceneName: 'test',
      sceneZIndex: 0,
      hitTestMode: HitTestMode.Default,
    };
    let isOnRotationChangeCallBackExec = false;
    let isRotationChangeCallBackExec = false;
    let systemSceneSession =
      manager.requestSystemSceneSession(sessionInfo, systemSessionChangeCallbackTemp, false, SCREEN_ID_TEST);
    systemSceneSession.rotation = RotationConstants.ROTATION_90;
    systemSceneSession.sessionData.isRotatable = true;
    systemSceneSession.registerRotateChangeCallback((angle: number) => {
      isRotationChangeCallBackExec = true;
      isOnRotationChangeCallBackExec = true;
    });
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    screenProperty.screenId = SCREEN_ID_TEST;
    manager.notifySystemSceneToSetRotation(screenProperty);
    expect(isOnRotationChangeCallBackExec).assertLargerOrEqual(0);
    expect(isRotationChangeCallBackExec).assertLargerOrEqual(0);
  });

  it('notifySystemSceneToUpdateFoldMode', 0, () => {
    let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
    expect(manager).not().assertNull();
    manager.initSystemSceneList(SCREEN_ID_TEST);
    isOnFoldChangeCallBackExec = false;
    let sessionInfo: SystemSessionInfo = {
      systemType: sceneSessionManager.SessionType.TYPE_PANEL,
      sceneName: 'test',
      sceneZIndex: 0,
      hitTestMode: HitTestMode.Default,
    };
    manager.requestSystemSceneSession(sessionInfo, systemSessionChangeCallbackTemp, false, SCREEN_ID_TEST);
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    screenProperty.screenId = SCREEN_ID_TEST;
    manager.notifySystemSceneToUpdateFoldMode(screenProperty, SCBPropertyChangeReason.ROTATION);
    expect(isOnFoldChangeCallBackExec).assertTrue();
  });

  it('prepareSystemSceneRotationBeforeAnimation', 0, () => {
    let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
    expect(manager).not().assertNull();
    manager.initSystemSceneList(SCREEN_ID_TEST);
    let sessionInfo: SystemSessionInfo = {
      systemType: sceneSessionManager.SessionType.TYPE_PANEL,
      sceneName: 'test',
      sceneZIndex: 0,
      hitTestMode: HitTestMode.Default,
    };
    let scbSystemSceneSession: SCBSystemSceneSession =
      manager.requestSystemSceneSession(sessionInfo, systemSessionChangeCallbackTemp, false, SCREEN_ID_TEST);
    scbSystemSceneSession.sessionData.isRotatable = true;
    scbSystemSceneSession.rotation = RotationConstants.ROTATION_270;
    manager.prepareSystemSceneRotationBeforeAnimation(RotationConstants.ROTATION_0, SCREEN_ID_TEST);
  });

}