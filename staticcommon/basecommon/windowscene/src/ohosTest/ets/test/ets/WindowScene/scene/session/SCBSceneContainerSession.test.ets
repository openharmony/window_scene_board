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
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium'
import {
  SCBSceneSessionManager,
  NeedRenderTranslate,
  NeedRenderPos,
  NeedRenderZIndex,
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneSession,
  SCBScreenProperty,
  SCBSceneMode,
  PreferMultiWindowOrientation,
  SCBSceneContainerSessionArray,
  SCBSessionRect,
  SCBContainerRotationReason,
  SCBPropertyChangeReason,
  ScbNumber,
  SCBSpecificSession,
  SCBScreenSessionManager,
  SCBScreenSession,
} from '../../../../../../../..';
import {  RectInfo } from '@ohos/basicutils';
import { SCBTransitionManager } from '../../../../../../../main/ets/animation/SCBTransitionManager';
import { CommonConstants } from '../../../../../../../../../../launchercommon/src/main/ets/constants/CommonConstants';
import { SceneParam, SCBDividerParam } from '../../../../../../../main/ets/TsIndex';
import sceneSessionManager from '@ohos.sceneSessionManager';
import screenSessionManager from '@ohos.screenSessionManager';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { ReflectionUtils } from './ReflectionUtils';
import { RotationConstants } from '@ohos/commonconstants';

const WINDOW_SCALE: number = 0.2;
const WINDOW_SCALEX: number = 0.035;
const WINDOW_SCALEY: number = 0.035;

interface SceneSessionTest {
  persistentId: number;
};

interface SCBSpecificSessionTest {
  session: SceneSessionTest;
  subSessionList: Array<SCBSpecificSessionTest>;
}

export function SCBSceneContainerSessionTest() {

  describe('SCBSceneContainerSessionTest', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    let secSceneInfo: SCBSceneInfo = new SCBSceneInfo('testSecondaryBundle', 'testSecondaryModule', 'testSecondaryAbility');
    let secSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(secSceneInfo), secSceneInfo);

    let screenProperty: SCBScreenProperty = new SCBScreenProperty();

    let scbSceneContainerSessionArray = new SCBSceneContainerSessionArray();
    let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);

    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('init', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.init();

      expect(containerSession.needRenderRotate.rotateX).assertEqual(1);
      expect(containerSession.needRenderRotate.centerX).assertEqual('50%');
      expect(containerSession.needRenderRotate.centerY).assertEqual('50%');
      expect(containerSession.needRenderShowInRecent.showInRecent).assertEqual(false);
      expect(containerSession.iconAlpha).assertEqual(0);
      expect(containerSession.isDisappearing).assertEqual(false);
      expect(containerSession.needRenderTranslateIcon.translateIconX).assertEqual(0);
      expect(containerSession.needRenderTranslateIcon.translateIconY).assertEqual(0);
    });

    it('addSceneSession', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);

      expect(containerSession.primarySession).assertDeepEquals(sceneSession);
      expect(containerSession.secondarySession).assertNull();

      containerSession.addSceneSession(secSceneSession);
      expect(containerSession.secondarySession).assertDeepEquals(secSceneSession);
    });

    it('addSceneSession02', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.addSceneSession(null);

      containerSession.primarySession = sceneSession;
      containerSession.secondarySession = sceneSession;
      containerSession.addSceneSession(secSceneSession);

      containerSession.primarySession = null;
      containerSession.addSceneSession(secSceneSession);

      let sceneInfo2: SCBSceneInfo = new SCBSceneInfo('testBundle', 'SCBSceneContainerSession', 'addSceneSession');
      let sceneSession2: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo2), sceneInfo2);
      containerSession.secondarySession = sceneSession2;
      containerSession.addSceneSession(secSceneSession);
    });


    it('removeSceneSessionReturnNull', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.removeSceneSession(sceneSession);
      expect(containerSession.secondarySession).assertNull();
    });

    it('removeSceneSessionInContainer', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.addSceneSession(secSceneSession);
      containerSession.removeSceneSession(null);

      containerSession.removeSceneSession(containerSession.primarySession);

      containerSession.addSceneSession(secSceneSession);
      containerSession.removeSceneSession(containerSession.secondarySession);

      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'removeSceneSessionInContainer');
      let sceneSession1: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      containerSession.addSceneSession(secSceneSession);
      containerSession.removeSceneSession(sceneSession1);
    });

    it('isSplitViewTest', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.isSplit = false;
      expect(containerSession.isSplitView()).assertFalse();

      containerSession.isSplit = true;
      expect(containerSession.isSplitView()).assertFalse();

      containerSession.addSceneSession(secSceneSession);
      expect(containerSession.isSplitView()).assertTrue();
    });

    it('removePrimarySceneSession', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.addSceneSession(secSceneSession);
      containerSession.removeSceneSession(sceneSession);

      expect(containerSession.secondarySession).assertNull();
    });

    it('removeSecondarySceneSession', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.addSceneSession(secSceneSession);
      containerSession.removeSceneSession(sceneSession);

      expect(containerSession.secondarySession).assertNull();
    });

    it('removeSplitPrimarySceneSession', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.addSceneSession(secSceneSession);
      containerSession.removeSceneSession(sceneSession);

      expect(containerSession.primarySession).assertDeepEquals(secSceneSession);
    });

    it('addSecondarySceneSession', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.addSceneSession(secSceneSession);

      expect(containerSession.getFirstSceneSession()).assertDeepEquals(sceneSession);
      expect(containerSession.getSecondSceneSession()).assertDeepEquals(secSceneSession);
    });

    it('requestDestruction', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.addSceneSession(secSceneSession);
      containerSession.requestDestruction(true)

      expect(containerSession.getFirstSceneSession().isActive).assertFalse();
      expect(containerSession.getSecondSceneSession().isActive).assertFalse();
    });

    it('initAll', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.initAll();

      expect(containerSession.needRenderRotate.rotateX).assertEqual(1);
      expect(containerSession.needRenderRotate.centerX).assertEqual('50%');
      expect(containerSession.needRenderRotate.centerY).assertEqual('50%');
      expect(containerSession.needRenderShowInRecent.showInRecent).assertEqual(false);
      expect(containerSession.iconAlpha).assertEqual(0);
      expect(containerSession.isDisappearing).assertEqual(false);
      expect(containerSession.needRenderTranslateIcon.translateIconX).assertEqual(0);
      expect(containerSession.needRenderTranslateIcon.translateIconY).assertEqual(0);
      expect(containerSession.dividerParam.primary.translateX).assertEqual(0);
      expect(containerSession.dividerParam.primary.translateY).assertEqual(0);
      expect(containerSession.dividerParam.secondary.translateX).assertEqual(0);
      expect(containerSession.dividerParam.secondary.translateY).assertEqual(0);
      expect(containerSession.dividerParam.dividerTranslateX).assertEqual(0);
      expect(containerSession.dividerParam.dividerTranslateY).assertEqual(0);
      expect(containerSession.dividerParam.scaleX).assertEqual(1);
      expect(containerSession.dividerParam.scaleY).assertEqual(1);
      expect(containerSession.dividerParam.primary.scaleX).assertEqual(1);
      expect(containerSession.dividerParam.primary.scaleY).assertEqual(1);
      expect(containerSession.dividerParam.primary.sessionScaleX).assertEqual(1);
      expect(containerSession.dividerParam.primary.sessionScaleY).assertEqual(1);
      expect(containerSession.dividerParam.primary.posX).assertEqual('0%');
      expect(containerSession.dividerParam.primary.posY).assertEqual('0%');
      expect(containerSession.dividerParam.secondary.scaleX).assertEqual(1);
      expect(containerSession.dividerParam.secondary.scaleY).assertEqual(1);
      expect(containerSession.dividerParam.secondary.sessionScaleX).assertEqual(1);
      expect(containerSession.dividerParam.primary.sessionScaleCenterX).assertEqual(0);
      expect(containerSession.dividerParam.secondary.sessionScaleCenterX).assertEqual(0);
      expect(containerSession.dividerParam.secondary.sessionScaleY).assertEqual(1);
      expect(containerSession.dividerParam.primary.sessionScaleCenterY).assertEqual(0);
      expect(containerSession.dividerParam.secondary.sessionScaleCenterY).assertEqual(0);
      expect(containerSession.dividerParam.primary.scaleCenterX).assertEqual(0);
      expect(containerSession.dividerParam.primary.scaleCenterY).assertEqual(0);
      expect(containerSession.dividerParam.secondary.scaleCenterX).assertEqual(0);
      expect(containerSession.dividerParam.secondary.scaleCenterY).assertEqual(0);
      expect(containerSession.dividerParam.primary.zIndex).assertEqual(0);
      expect(containerSession.dividerParam.secondary.zIndex).assertEqual(0);
      expect(containerSession.dividerParam.primary.opacity).assertEqual(1);
      expect(containerSession.dividerParam.secondary.opacity).assertEqual(1);
      expect(containerSession.dividerParam.primary.blurScale).assertEqual(0);
      expect(containerSession.dividerParam.secondary.blurScale).assertEqual(0);
      expect(containerSession.dividerParam.primary.height).assertEqual('100%');
      expect(containerSession.dividerParam.primary.width).assertEqual('100%');
      expect(containerSession.dividerParam.secondary.height).assertEqual('0%');
      expect(containerSession.dividerParam.secondary.width).assertEqual('0%');
      expect(containerSession.dividerParam.primSizePct).assertEqual(1);
      expect(containerSession.dividerParam.secSizePct).assertEqual(0);
      expect(containerSession.dividerParam.secondary.posX).assertEqual('0%');
      expect(containerSession.dividerParam.secondary.posY).assertEqual('0%');
      expect(containerSession.dividerParam.splitOrderIsNotReverse).assertEqual(true);
    });

    it('getFirstSceneSession', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.addSceneSession(secSceneSession);
      containerSession.requestDestruction(true)

      expect(containerSession.getFirstSceneSession().isActive).assertFalse();
      expect(containerSession.getSecondSceneSession().isActive).assertFalse();
    });

    it('isForeground', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.addSceneSession(secSceneSession);
      containerSession.requestDestruction(true)

      expect(containerSession.isForeground()).assertFalse();
    });

    it('isBackground', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.addSceneSession(secSceneSession);
      expect(containerSession.isBackground()).assertTrue();
    });

    it('getContainerWindowMode', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.addSceneSession(secSceneSession);

      expect(containerSession.getContainerWindowMode()).assertDeepEquals(SCBSceneMode.FULLSCREEN);
    });

    it('enableShow', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.requestActivation();

      expect(containerSession.enableShow()).assertDeepEquals(true);
    });

    it('getTransitionCount', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      expect(containerSession.getTransitionCount()).assertEqual(0);
    });

    it('getTransitionCount02', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.initCompanionIconInfo(sceneInfo, null);
      // mock count === 0
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(SCBTransitionManager.getInstance(), SCBTransitionManager.getInstance().getTransitionCount);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(0);
      expect(containerSession.getTransitionCount()).assertEqual(containerSession.sessionData.transitionAnimationCount);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(1);
      expect(containerSession.getTransitionCount()).assertEqual(1);
    });

    it('addTransitionCount', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('com.ohos.intelligent', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.addTransitionCount();
    });

    it('getTargetRotation01', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      // isSplit == true
      containerSession.isSplit = true;
      expect(containerSession.getTargetRotation(0, true)).assertEqual(0);
    });

    it('getTargetRotation02', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      // isSplit == false && isOrientationUnrelatedToSensor == true
      containerSession.isSplit = false;
      // UNSPECIFIED
      expect(containerSession.getTargetRotation(0, true)).assertEqual(0);
    });

    it('getTargetRotation03', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      // isSplit == false && isOrientationUnrelatedToSensor == true
      containerSession.isSplit = false;
      // HORIZONTAL
      containerSession.sessionData.requestOrientation = 2;
      expect(containerSession.getTargetRotation(0, true)).assertEqual(90);
    });

    it('getTargetRotation04', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      // isSplit == false && isOrientationUnrelatedToSensor == true
      containerSession.isSplit = false;
      // VERTICAL
      containerSession.sessionData.requestOrientation = 1;
      expect(containerSession.getTargetRotation(0, true)).assertEqual(0);
    });

    it('getTargetRotation05', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      // isSplit == false && isOrientationUnrelatedToSensor == true
      containerSession.isSplit = false;
      // REVERSE_HORIZONTAL
      containerSession.sessionData.requestOrientation = 4;
      expect(containerSession.getTargetRotation(0, true)).assertEqual(270);
    });

    it('getTargetRotation06', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      // isSplit == false && isOrientationUnrelatedToSensor == true
      containerSession.isSplit = false;
      // REVERSE_VERTICAL
      containerSession.sessionData.requestOrientation = 3;
      expect(containerSession.getTargetRotation(0, true)).assertEqual(180);
    });

    it('getTargetRotation07', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      // isSplit == false && isOrientationUnrelatedToSensor == true
      containerSession.isSplit = false;
      // FOLLOW_RECENT
      containerSession.sessionData.requestOrientation = 12;
      expect(containerSession.getTargetRotation(0, true)).assertEqual(containerSession.screenProperty.rotation);
    });

    it('getTargetRotation08', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      // isSplit == false && isOrientationUnrelatedToSensor == true
      containerSession.isSplit = false;
      // default isOrientationUnrelatedToSensor == false and isRelatedToRotationPolicy==true
      containerSession.sessionData.requestOrientation = 18;
      expect(containerSession.getTargetRotation(0, true)).assertEqual(0);
    });

    it('getTargetRotation09', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      // isSplit == false && isOrientationUnrelatedToSensor == true
      containerSession.isSplit = false;
      // this.processOrientationRelatedToSensor test
      containerSession.sessionData.requestOrientation = 10;
      expect(containerSession.getTargetRotation(0, true)).assertEqual(90);
    });

    it('getTargetRotation_midScene_GState_rotation_locked', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let mocker: MockKit = new MockKit();
      let screenManager = SCBScreenSessionManager.getInstance();
      let testPtr : UIContext;
      let screenSession: screenSessionManager.ScreenSession = {
        screenId: 100,
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
      let isGStateFunc = mocker.mockFunc(screenManager, screenManager.isSecondaryFoldablePhoneExpandStatus);
      let isLockFunc = mocker.mockFunc(screenManager, screenManager.getScreenOrientationLocked);
      let getScreenSessionFunc = mocker.mockFunc(screenManager, screenManager.getScreenSession);
      when(isGStateFunc)(ArgumentMatchers.any).afterReturn(true);
      when(isLockFunc)(ArgumentMatchers.any).afterReturn(true);
      when(getScreenSessionFunc)(ArgumentMatchers.any).afterReturn(scbScreenSession);
      containerSession.isSplit = false;
      containerSession.isMidScene = true;
      containerSession.sessionData.requestOrientation = 10;
      scbScreenSession.scbScreenProperty.rotation = 0;
      expect(containerSession.getTargetRotation(90)).assertEqual(0);
      scbScreenSession.scbScreenProperty.rotation = 180;
      expect(containerSession.getTargetRotation(180)).assertEqual(180);
      scbScreenSession.scbScreenProperty.rotation = 90;
      expect(containerSession.getTargetRotation(0)).assertEqual(0);
      mocker.clear(screenManager);
      mocker.clearAll();
    });

    it('getTargetRotation_midScene_GState_rotation_unlocked', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let mocker: MockKit = new MockKit();
      let screenManager = SCBScreenSessionManager.getInstance();
      let testPtr : UIContext;
      let screenSession: screenSessionManager.ScreenSession = {
        screenId: 100,
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
      let isGStateFunc = mocker.mockFunc(screenManager, screenManager.isSecondaryFoldablePhoneExpandStatus);
      let isLockFunc = mocker.mockFunc(screenManager, screenManager.getScreenOrientationLocked);
      let getScreenSessionFunc = mocker.mockFunc(screenManager, screenManager.getScreenSession);
      when(isGStateFunc)(ArgumentMatchers.any).afterReturn(true);
      when(isLockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(getScreenSessionFunc)(ArgumentMatchers.any).afterReturn(scbScreenSession);
      containerSession.isSplit = false;
      containerSession.isMidScene = true;
      containerSession.sessionData.requestOrientation = 10;
      scbScreenSession.scbScreenProperty.rotation = 0;
      expect(containerSession.getTargetRotation(90)).assertEqual(0);
      expect(containerSession.getTargetRotation(180)).assertEqual(180);
      expect(containerSession.getTargetRotation(0)).assertEqual(0);
      mocker.clear(screenManager);
      mocker.clearAll();
    });

    it('notifyForegroundInteractiveStatus', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      // _isActive = false;
      containerSession.notifyForegroundInteractiveStatus(true);
      // _isActive = true;
      containerSession.requestActivation();
      containerSession.notifyForegroundInteractiveStatus(true);
      containerSession.isSplit = false;
      containerSession.notifyForegroundInteractiveStatus(true);
    });

    it('startOther', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.init();
      containerSession.startOther();

      expect(containerSession.needRenderScale.scaleX).assertEqual(WINDOW_SCALEX);
      expect(containerSession.needRenderScale.scaleY).assertEqual(WINDOW_SCALEY);
      expect(containerSession.needRenderTranslate.translateX).assertEqual(0);
      expect(containerSession.needRenderTranslate.translateY).assertEqual(-px2vp(screenProperty.height * WINDOW_SCALE));
      expect(containerSession.needRenderTranslateIcon.translateIconX).assertEqual(0);
      expect(containerSession.needRenderTranslateIcon.translateIconX).assertEqual(0);
      expect(containerSession.needRenderClip.clipHeight.getPx()).assertEqual(screenProperty.height);
      expect(containerSession.needRenderBorderRadius.topLeft).assertEqual(CommonConstants.getDeviceRadius());
      expect(containerSession.needRenderBorderRadius.topRight).assertEqual(CommonConstants.getDeviceRadius());
      expect(containerSession.needRenderBorderRadius.bottomLeft).assertEqual(CommonConstants.getDeviceRadius());
      expect(containerSession.needRenderBorderRadius.bottomRight).assertEqual(CommonConstants.getDeviceRadius());
    });

    it('updateSessionRectForSplitOnBackTest', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.addSceneSession(secSceneSession);

      containerSession.updateSessionRectForSplitOnBack(screenProperty, 90, true);
      expect(containerSession.dividerParam.secondary.rotateAngle).assertEqual(-90);
    });

    it('updateSessionRectForSplitOnBackTest01', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      // this.secondarySession == null
      containerSession.updateSessionRectForSplitOnBack(screenProperty, 90, true);
      // this.secondarySession != null and changeReason == RESIZE
      containerSession.addSceneSession(secSceneSession);
      containerSession.updateSessionRectForSplitOnBack(screenProperty, 90, false);
      expect(containerSession.dividerParam.secondary.rotateAngle).assertEqual(0);
    });

    it('updateSessionRectForSplit', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);

      let sceneInfoNew: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'updateSessionRectForPreSplit02');
      let sceneSessionNew: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfoNew), sceneInfoNew);
      let containerSessionNew: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSessionNew, screenProperty);
      // isSplit = true
      containerSession.isSplit = true;
      containerSession.updateSessionRectForSplit(containerSessionNew.screenProperty, true);

      // SplitLifeCycle.EXIT_SPLIT_TO_ONESTEP
      containerSession.isSplit = false;
      containerSession.splitParam.setLifeCycle(5);
      // this.dividerParam.isUpDownSplit() == false
      let mocker: MockKit = new MockKit();
      let scbDividerParam :SCBDividerParam = new SCBDividerParam();
      let mockFunc = mocker.mockFunc(scbDividerParam, scbDividerParam.isUpDownSplit);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      containerSession.updateSessionRectForSplit(containerSessionNew.screenProperty, true);
      // isSplit = false and isOneStepSplit = false
      containerSession.splitParam.setLifeCycle(0);
      containerSession.addSceneSession(secSceneSession);
      let screenPropertyNew: SCBScreenProperty = containerSessionNew.screenProperty;
      screenPropertyNew.height = 1000;
      containerSession.updateSessionRectForSplit(screenPropertyNew, true);
    });

    it('isOrientationRelatedToSensorLandscape', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.sessionData.requestOrientation = 10;
      expect(containerSession.isOrientationRelatedToSensorLandscape()).assertTrue();
      containerSession.sessionData.requestOrientation = 7;
      expect(containerSession.isOrientationRelatedToSensorLandscape()).assertTrue();
      containerSession.sessionData.requestOrientation = 0;
      expect(containerSession.isOrientationRelatedToSensorLandscape()).assertFalse();
    });

    it('rotateSplitInFoldIfNeededTest', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.addSceneSession(secSceneSession);

      screenProperty.rotation = 90;
      containerSession.rotateSplitInFoldIfNeeded(screenProperty);
      expect(containerSession.dividerParam.getIsVertical()).assertFalse();
    });

    it('hasFixedMultiWindowOrientationSessionTest', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      if (containerSession.primarySession !== null) {
        containerSession.primarySession.isFixedMultiWindowOrientation = false;
        expect(containerSession.hasFixedMultiWindowOrientationSession()).assertFalse();

        containerSession.primarySession.isFixedMultiWindowOrientation = true;
        expect(containerSession.hasFixedMultiWindowOrientationSession()).assertTrue();
      } else {
        expect(true).assertFalse();
      }
    });

    it('getNeedMaxSceneSessionTest', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.addSceneSession(secSceneSession);

      containerSession.primarySession?.setFocused(true);
      containerSession.secondarySession?.setFocused(false);
      expect(containerSession.getNeedMaxSceneSession()).assertDeepEquals(sceneSession);

      containerSession.primarySession?.setFocused(false);
      containerSession.secondarySession?.setFocused(true);
      expect(containerSession.getNeedMaxSceneSession()).assertDeepEquals(secSceneSession);

      containerSession.primarySession?.setFocused(false);
      containerSession.secondarySession?.setFocused(false);
      containerSession.dividerParam.splitOrderIsNotReverse = true;
      expect(containerSession.getNeedMaxSceneSession()).assertDeepEquals(sceneSession);

      containerSession.primarySession?.setFocused(false);
      containerSession.secondarySession?.setFocused(false);
      containerSession.dividerParam.splitOrderIsNotReverse = false;
      expect(containerSession.getNeedMaxSceneSession()).assertDeepEquals(secSceneSession);
    });

    it('getNeedExitSceneSessionTest', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.addSceneSession(secSceneSession);

      containerSession.primarySession?.setFocused(true);
      containerSession.secondarySession?.setFocused(false);
      expect(containerSession.getNeedExitSceneSession()).assertDeepEquals(secSceneSession);

      containerSession.primarySession?.setFocused(false);
      containerSession.secondarySession?.setFocused(true);
      expect(containerSession.getNeedExitSceneSession()).assertDeepEquals(sceneSession);

      containerSession.primarySession?.setFocused(false);
      containerSession.secondarySession?.setFocused(false);
      containerSession.dividerParam.splitOrderIsNotReverse = true;
      expect(containerSession.getNeedExitSceneSession()).assertDeepEquals(secSceneSession);

      containerSession.primarySession?.setFocused(false);
      containerSession.secondarySession?.setFocused(false);
      containerSession.dividerParam.splitOrderIsNotReverse = false;
      expect(containerSession.getNeedExitSceneSession()).assertDeepEquals(sceneSession);
    });

    it('hasLandscapeGameSessionTest', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.addSceneSession(secSceneSession);
      if (containerSession.primarySession === null || containerSession.secondarySession === null) {
        expect(true).assertFalse();
      } else {
        containerSession.primarySession.preferMultiWindowOrientation = PreferMultiWindowOrientation.LANDSCAPE;
        containerSession.secondarySession.preferMultiWindowOrientation = PreferMultiWindowOrientation.LANDSCAPE;
        expect(containerSession.hasLandscapeGameSession()).assertTrue();

        containerSession.primarySession.preferMultiWindowOrientation = PreferMultiWindowOrientation.LANDSCAPE;
        containerSession.secondarySession.preferMultiWindowOrientation = PreferMultiWindowOrientation.PORTRAIT;
        expect(containerSession.hasLandscapeGameSession()).assertTrue();

        containerSession.primarySession.preferMultiWindowOrientation = PreferMultiWindowOrientation.PORTRAIT;
        containerSession.secondarySession.preferMultiWindowOrientation = PreferMultiWindowOrientation.LANDSCAPE;
        expect(containerSession.hasLandscapeGameSession()).assertTrue();

        containerSession.primarySession.preferMultiWindowOrientation = PreferMultiWindowOrientation.PORTRAIT;
        containerSession.secondarySession.preferMultiWindowOrientation = PreferMultiWindowOrientation.PORTRAIT;
        expect(containerSession.hasLandscapeGameSession()).assertFalse();
      }
    });

    it('calculateBackToOneStepTranslateTest', 0, () => {
      try {
        let sceneInfo: SCBSceneInfo = new SCBSceneInfo('calculateBackToOneStepTranslateBundle',
          'calculateBackToOneStepTranslateMoudle', 'calculateBackToOneStepTranslateAbility');
        let scbSceneSession: SCBSceneSession = new SCBSceneSession(
          sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
        let screenProperty: SCBScreenProperty = new SCBScreenProperty();
        screenProperty.screenId = 111;
        let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, screenProperty);
        let numTest: number | undefined = scbSceneContainerSession.processOrientationRelatedToSplit(0);
        expect(numTest).assertEqual(undefined);
      } catch (e) {
        expect(false).assertFail();
      }
    });

    it('transitionOutFinishIfNeedTest', 0, () => {
      try {
        let sceneInfo: SCBSceneInfo = new SCBSceneInfo('transitionOutFinishIfNeedBundle',
          'transitionOutFinishIfNeedMoudle', 'transitionOutFinishIfNeedAbility');
        let scbSceneSession: SCBSceneSession = new SCBSceneSession(
          sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
        let screenProperty: SCBScreenProperty = new SCBScreenProperty();
        let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, screenProperty);
        let flag: boolean = scbSceneContainerSession.transitionOutFinishIfNeed(3, false, false);
        expect(flag).assertFalse();
      } catch (e) {
        expect(false).assertFail();
      }
    });

    it('setTranslateXWithDfxTest', 0, () => {
      try {
        let needRenderTranslate: NeedRenderTranslate = new NeedRenderTranslate();
        needRenderTranslate.setTranslateXWithDfx(90, 'musicMoudle', 'no', '');
      } catch (e) {
        expect(false).assertFail();
      }
    });

    it('setTranslateXTest', 0, () => {
      try {
        let needRenderTranslate: NeedRenderTranslate = new NeedRenderTranslate();
        needRenderTranslate.setTranslateX(90);
      } catch (e) {
        expect(false).assertFail();
      }
    });

    it('setTranslateYTest', 0, () => {
      try {
        let needRenderTranslate: NeedRenderTranslate = new NeedRenderTranslate();
        needRenderTranslate.setTranslateY(90);
      } catch (e) {
        expect(false).assertFail();
      }
    });

    it('translateXTest', 0, () => {
      let needRenderTranslate: NeedRenderTranslate = new NeedRenderTranslate();
      expect(needRenderTranslate.translateX).assertEqual(0);
    });
    it('translateYTest', 0, () => {
      let needRenderTranslate: NeedRenderTranslate = new NeedRenderTranslate();
      expect(needRenderTranslate.translateY).assertEqual(0);
    });
    it('setDiffBorderRadiusWithDfxTest', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.init();
      containerSession.startOther();
      containerSession.needRenderBorderRadius.setDiffBorderRadiusWithDfx(null,null,null,null);
      expect(containerSession.needRenderBorderRadius.topLeft).assertEqual(0);
      expect(containerSession.needRenderBorderRadius.topRight).assertEqual(0);
      expect(containerSession.needRenderBorderRadius.bottomLeft).assertEqual(0);
      expect(containerSession.needRenderBorderRadius.bottomRight).assertEqual(0);
      containerSession.needRenderBorderRadius.setDiffBorderRadiusWithDfx(1,1,1,1);
      expect(containerSession.needRenderBorderRadius.topLeft).assertEqual(1);
      expect(containerSession.needRenderBorderRadius.topRight).assertEqual(1);
      expect(containerSession.needRenderBorderRadius.bottomLeft).assertEqual(1);
      expect(containerSession.needRenderBorderRadius.bottomRight).assertEqual(1);
    });
    it('setDiffBorderRadiusTest', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.init();
      containerSession.startOther();
      containerSession.needRenderBorderRadius.setDiffBorderRadius(null,null,null,null);
      expect(containerSession.needRenderBorderRadius.topLeft).assertEqual(0);
      expect(containerSession.needRenderBorderRadius.topRight).assertEqual(0);
      expect(containerSession.needRenderBorderRadius.bottomLeft).assertEqual(0);
      expect(containerSession.needRenderBorderRadius.bottomRight).assertEqual(0);
      containerSession.needRenderBorderRadius.setDiffBorderRadiusWithDfx(1,1,1,1);
      expect(containerSession.needRenderBorderRadius.topLeft).assertEqual(1);
      expect(containerSession.needRenderBorderRadius.topRight).assertEqual(1);
      expect(containerSession.needRenderBorderRadius.bottomLeft).assertEqual(1);
      expect(containerSession.needRenderBorderRadius.bottomRight).assertEqual(1);
    });
    it('setPosXWithDfxTest', 0, () => {
      let needRenderPos: NeedRenderPos= new NeedRenderPos();
      needRenderPos.setPosXWithDfx(0,"moudle","check",null);
      needRenderPos.setPosXWithDfx(1,"moudle","check",null);
    });
    it('setPosYWithDfxTest', 0, () => {
      let needRenderPos: NeedRenderPos= new NeedRenderPos();
      needRenderPos.setPosYWithDfx(0,"moudle","check",null);
      needRenderPos.setPosYWithDfx(1,"moudle","check",null);
    });
    it('setZIndexTest', 0, () => {
      let needRenderZIndex: NeedRenderZIndex= new NeedRenderZIndex();
      needRenderZIndex.setZIndex(1);
      needRenderZIndex.setZIndex(0);
    });
    it('resetZIndexTest', 0, () => {
      let needRenderZIndex: NeedRenderZIndex= new NeedRenderZIndex();
      needRenderZIndex.resetZIndex();
      needRenderZIndex.setZIndex(2);
      needRenderZIndex.resetZIndex();
    });
    it('setAngleWithDfxTest', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.init();
      containerSession.needRenderRotate.setAngleWithDfx(0,'module','test',null);
      containerSession.needRenderRotate.setAngleWithDfx(1,'module','test',null);
    });
    it('setCenterXTest', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.init();
      containerSession.needRenderRotate.setCenterX('50%');
      containerSession.needRenderRotate.setCenterX('100%');
    });
    it('setCenterYTest', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.init();
      containerSession.needRenderRotate.setCenterY('50%');
      containerSession.needRenderRotate.setCenterY('100%');
    });

    it('addSceneSessionTest', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.init();
      let sceneInfo1: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession1: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo1), sceneInfo1);
      containerSession.addSceneSession(sceneSession1);
      let sceneInfo2: SCBSceneInfo = new SCBSceneInfo('','','',);
      let sceneSession2: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo2), sceneInfo2);
      containerSession.addSceneSession(sceneSession2);
      let sceneInfo3: SCBSceneInfo = new SCBSceneInfo('testBundle1', 'testModule1', 'testAbility1');
      let sceneSession3: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo3), sceneInfo3);
      containerSession.addSceneSession(sceneSession3);
      let containerSession1: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession2, screenProperty);
      containerSession1.addSceneSession(sceneSession1);
      containerSession1.addSceneSession(sceneSession2);
      containerSession1.addSceneSession(sceneSession3);
    });

    it('replaceSceneSessionTest', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.init();
      let sceneInfo1: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession1: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo1), sceneInfo1);
      let sceneInfo2: SCBSceneInfo = new SCBSceneInfo('','','',);
      let sceneSession2: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo2), sceneInfo2);
      let sceneInfo3: SCBSceneInfo = new SCBSceneInfo('testBundle1', 'testModule1', 'testAbility1');
      let sceneSession3: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo3), sceneInfo3);
      let containerSession1: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession2, screenProperty);
      containerSession.replaceSceneSession(sceneSession1,sceneSession1);
      containerSession.replaceSceneSession(sceneSession3,sceneSession1);
      containerSession.replaceSceneSession(sceneSession1,sceneSession2);
      containerSession.replaceSceneSession(sceneSession2,sceneSession1);
      containerSession.replaceSceneSession(sceneSession3,sceneSession2);

    });

    it('replaceSceneSessionTest2', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let sceneInfo1: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'replaceSceneSessionTest2');
      let sceneSession1: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo1), sceneInfo1);
      containerSession.replaceSceneSession(null, null);
      containerSession.replaceSceneSession(containerSession.primarySession, sceneSession1);
    });

    it('replaceSceneSessionTest3', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let sceneInfo1: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'replaceSceneSessionTest3');
      let sceneSession1: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo1), sceneInfo1);
      containerSession.addSceneSession(secSceneSession);
      containerSession.replaceSceneSession(containerSession.secondarySession, sceneSession1);
    });

    it('replaceSceneSessionTest4', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let sceneInfo1: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'replaceSceneSessionTest4');
      let sceneSession1: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo1), sceneInfo1);
      containerSession.addSceneSession(secSceneSession);
      containerSession.replaceSceneSession(sceneSession1, sceneSession1);
    });

    it('covertWithRotation', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.currentRotation = 90;
      let rectInfo1: RectInfo = new RectInfo();
      expect(containerSession.covertWithRotation(rectInfo1).bottom).assertEqual(rectInfo1.right);

      let rectInfo2: RectInfo = new RectInfo();
      containerSession.currentRotation = 180;
      containerSession.covertWithRotation(rectInfo2);

      containerSession.currentRotation = 270;
      let rectInfo3: RectInfo = new RectInfo();
      expect(containerSession.covertWithRotation(rectInfo3).left).assertEqual(rectInfo3.top);

      containerSession.currentRotation = 0;
      let rectInfo4: RectInfo = new RectInfo();
      expect(containerSession.covertWithRotation(rectInfo4).bottom).assertEqual(rectInfo4.bottom);
    });

    it('requestActivationByCallTest', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.requestActivationByCall(true);
      expect(containerSession.enableShow()).assertDeepEquals(true);
      containerSession.requestActivationByCall(false);
      expect(containerSession.enableShow()).assertDeepEquals(false);

    });

    it('requestBackgroundWithTransitionOutTest', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.requestBackground(true,true);
      containerSession.requestBackground(false,true);
      containerSession.requestActivationByCall(true);
      containerSession.requestBackground(true,true);
      containerSession.requestBackground(false,true);
    });

    it('requestActivationTest_01', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.requestActivation(false, 0, true);
      expect(containerSession.isActive).assertTrue();
    });
    it('requestActivationTest_02', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.requestActivation(false, 0, false);
      expect(containerSession.isActive).assertTrue();
      containerSession.requestBackground(false, false, false, true);
      expect(containerSession.isActive).assertFalse();
    });

    it('requestBackgroundTest_01', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.requestActivation(false, 0, false);
      expect(containerSession.isActive).assertTrue();
      containerSession.requestBackground(false, false, false, true);
      expect(containerSession.isActive).assertFalse();
    });
    it('requestBackgroundTest_02', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.requestActivation(false, 0, false);
      expect(containerSession.isActive).assertTrue();
      containerSession.requestBackground(false, false, false, false);
      expect(containerSession.isActive).assertFalse();
    });

    it('requestSceneBackgroundTest_01', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.requestActivation(false, 0, false);
      expect(containerSession.isActive).assertTrue();
      containerSession.requestSceneBackground(false, false, false, true);
      expect(containerSession.isActive).assertFalse();
    });
    it('requestSceneBackgroundTest_02', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.requestActivation(false, 0, false);
      expect(containerSession.isActive).assertTrue();
      containerSession.requestSceneBackground(false, false, false, false);
      expect(containerSession.isActive).assertFalse();
    });

    it('transitionOutFinishTest', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.transitionOutFinish(true);
      containerSession.transitionOutFinish(false);
    });

    it('transitionInFinishTest', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.transitionInFinish(true);
      containerSession.transitionInFinish(false);
      containerSession.clearContainerSessionData();
    });

    it('requestDestructionTest', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.requestDestruction(true,false,true,false);
      containerSession.requestDestruction(true,true,true,true);
    });

    it('requestDestructionWithTransitionOutTest', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.requestDestructionWithTransitionOut(true);
      containerSession.requestDestructionWithTransitionOut(false);
      containerSession.requestActivation();
      containerSession.requestDestructionWithTransitionOut(true,false,true,true);
      containerSession.requestDestructionWithTransitionOut(false,false,true,true);
    });

    it('getSceneSessionTupleBySceneInfoAfterDestructionTest', 0, () => {
      scbSceneContainerSessionArray.clear();
      expect(scbSceneContainerSessionArray.getSceneSessionTupleBySceneInfo(scbSceneContainerSession.primarySession?.sceneInfo, false)).assertNull();
      scbSceneContainerSessionArray.push(scbSceneContainerSession);
      scbSceneContainerSession.requestDestruction(true);
      let sessionTuple = scbSceneContainerSessionArray.getSceneSessionTupleBySceneInfo(scbSceneContainerSession.primarySession?.sceneInfo, true);
      expect(sessionTuple?.[0]).assertNull();
      expect(sessionTuple?.[1]).assertEqual(scbSceneContainerSession);
    });

    it('getSceneSessionTupleBySceneInfoBeforeDestructionTest', 0, () => {
      scbSceneContainerSessionArray.clear();
      let sceneInfo2: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession2: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo2), sceneInfo2);
      let sceneContainerSession2 = new SCBSceneContainerSession(sceneSession2, screenProperty);
      sceneContainerSession2.requestActivation();
      scbSceneContainerSessionArray.push(sceneContainerSession2);
      let sessionTuple2 = scbSceneContainerSessionArray.getSceneSessionTupleBySceneInfo(sceneInfo2, true);
      expect(sessionTuple2?.[0]).assertEqual(sceneSession2);
      expect(sessionTuple2?.[1]).assertEqual(sceneContainerSession2);
    });

    it("getSceneSessionTupleBySceneInfo01", 0, () => {
      // mock isAvailable === false
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().requestSceneSessionByCall);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(1300003);

      scbSceneContainerSessionArray.clear();
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sceneContainerSession1 = new SCBSceneContainerSession(sceneSession, screenProperty);

      let secondarySession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      secondarySession.requestSessionActivationByCall(true, true); // isAvailable === false
      sceneContainerSession1.primarySession = null;
      sceneContainerSession1.secondarySession = secondarySession;
      scbSceneContainerSessionArray.push(sceneContainerSession1);

      let filterPendingRemove = true;
      let sessionTuple = scbSceneContainerSessionArray.getSceneSessionTupleBySceneInfo(sceneInfo, filterPendingRemove);
      expect(sessionTuple?.[0]).assertEqual(null);
      expect(sessionTuple?.[1]).assertEqual(sceneContainerSession1);
    });

    it("getSceneSessionTupleBySceneInfo02", 0, () => {
      scbSceneContainerSessionArray.clear();
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

      let sceneInfo3: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'getSceneSessionTupleBySceneInfo02');
      let sceneSession3: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo3), sceneInfo3);

      let sceneContainerSession3 = new SCBSceneContainerSession(sceneSession3, screenProperty);
      sceneContainerSession3.isMidScene = true;
      sceneContainerSession3.midSceneMap.set(1, sceneSession3);
      scbSceneContainerSessionArray.push(sceneContainerSession3);

      let sceneContainerSession2 = new SCBSceneContainerSession(sceneSession, screenProperty);
      sceneContainerSession2.sessionData.pendingRemove = true;
      scbSceneContainerSessionArray.push(sceneContainerSession2);


      let sceneContainerSession1 = new SCBSceneContainerSession(sceneSession, screenProperty);
      sceneContainerSession1.isMidScene = true;
      scbSceneContainerSessionArray.push(sceneContainerSession1);

      let filterPendingRemove = true;
      let sessionTuple = scbSceneContainerSessionArray.getSceneSessionTupleBySceneInfo(sceneInfo3, filterPendingRemove);
      expect(sessionTuple?.[0]).assertEqual(sceneContainerSession3.midSceneMap.get(1));
      expect(sessionTuple?.[1]).assertEqual(sceneContainerSession3);
    });

    it('initCompanionIconInfo', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      sceneContainerSession.initCompanionIconInfo(null, null);
      sceneContainerSession.initCompanionIconInfo(sceneInfo, null);
    });

    it('getSceneSessionByPersistentIdTest', 0, () => {
      scbSceneContainerSessionArray.clear();
      expect(scbSceneContainerSessionArray.getSceneSessionByPersistentId(scbSceneContainerSession.primarySession?.session.persistentId)).assertNull();
      scbSceneContainerSessionArray.push(scbSceneContainerSession);
      expect(scbSceneContainerSessionArray.getSceneSessionByPersistentId(scbSceneContainerSession.primarySession?.session.persistentId)).assertEqual(scbSceneContainerSession.primarySession);
      expect(scbSceneContainerSessionArray.getSceneSessionByPersistentId(scbSceneContainerSession.secondarySession?.session.persistentId)).assertEqual(scbSceneContainerSession.secondarySession);
    });

    it('getSceneSessionByPersistentIdTest02', 0, () => {
      scbSceneContainerSessionArray.clear();
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sceneInfoSecond: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbilitySecond');
      let sceneSessionSecond: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfoSecond), sceneInfoSecond);
      let sceneInfoMid: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbilityMid');
      let sceneSessionMid: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfoMid), sceneInfoMid);

      let scbSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      scbSceneContainerSession.addSceneSession(sceneSessionSecond);
      scbSceneContainerSessionArray.push(scbSceneContainerSession);

      // isMidScene=true and midSceneSession.isAvailable=false
      sceneSessionMid.requestSessionActivationByCall(true, true);
      scbSceneContainerSessionArray[0].isMidScene = true;
      scbSceneContainerSessionArray[0].midSceneMap.set(sceneSessionMid.session.persistentId, sceneSessionMid);
      expect(scbSceneContainerSessionArray.getSceneSessionByPersistentId(sceneSessionMid.session.persistentId, true)).assertNull();

      // this.sessionDataInner.nativeCacheRefAvailable=false 即  .secondarySession.isAvailable === false
      scbSceneContainerSessionArray[0].secondarySession?.requestSessionActivationByCall(true, true);
      expect(scbSceneContainerSessionArray.getSceneSessionByPersistentId(scbSceneContainerSession.secondarySession?.session.persistentId, true)).assertNull();

      // .primarySession.isAvailable === false
      scbSceneContainerSessionArray[0].primarySession?.requestSessionActivationByCall(true, true);
      expect(scbSceneContainerSessionArray.getSceneSessionByPersistentId(scbSceneContainerSession.primarySession?.session.persistentId, true)).assertNull();
    });

    it('getSceneSessionCountsByBundleNameTest', 0, () => {
      expect(scbSceneContainerSessionArray.getSceneSessionCountsByBundleName("")).assertEqual(0);
      scbSceneContainerSessionArray.push(scbSceneContainerSession);
      expect(scbSceneContainerSessionArray.getSceneSessionCountsByBundleName(scbSceneContainerSession.primarySession?.sceneInfo.bundleName)).assertEqual(3);
      expect(scbSceneContainerSessionArray.getSceneSessionCountsByBundleName(scbSceneContainerSession.secondarySession?.sceneInfo.bundleName)).assertEqual(0);
    });

    it('deleteByContainerIdTest', 0, () => {
      expect(scbSceneContainerSessionArray.deleteByContainerId(-1)).assertNull();
      scbSceneContainerSessionArray.push(scbSceneContainerSession);
      expect(scbSceneContainerSessionArray.deleteByContainerId(scbSceneContainerSession.containerId)).assertEqual(scbSceneContainerSession);
    });

    it('sortByTopmostTest', 0, () => {
      scbSceneContainerSessionArray.sortByTopmost();
    });

    it('removeIfTest', 0, () => {
      expect(scbSceneContainerSessionArray.removeIf(null).length).assertEqual(0);
      scbSceneContainerSessionArray.push(scbSceneContainerSession);
      let len = scbSceneContainerSessionArray.length;
      expect(scbSceneContainerSessionArray.removeIf(() => true).length).assertEqual(len);
    });

    it('deleteWithTransitionInactiveTest', 0, () => {
      scbSceneContainerSessionArray.push(scbSceneContainerSession);
      expect(scbSceneContainerSessionArray.deleteWithTransitionInactive(scbSceneContainerSessionArray.length)).assertEqual(false);
      expect(scbSceneContainerSessionArray.deleteWithTransitionInactive(0)).assertEqual(true);
    });

    it('cloneTest', 0, () => {
      scbSceneContainerSessionArray.push(scbSceneContainerSession);
      expect(scbSceneContainerSessionArray.clone().length).assertEqual(scbSceneContainerSessionArray.length);
    });

    it('filterCloneTest', 0, () => {
      scbSceneContainerSessionArray.push(scbSceneContainerSession);
      expect(scbSceneContainerSessionArray.filterClone().length).assertEqual(scbSceneContainerSessionArray.length);
    });

    it('getTargetSessionCountAndFirstContainerTest', 0, () => {
      scbSceneContainerSessionArray.push(scbSceneContainerSession);
      expect(scbSceneContainerSessionArray.getTargetSessionCountAndFirstContainer(() => true)?.[0]).assertEqual(scbSceneContainerSessionArray.length);
      expect(scbSceneContainerSessionArray.getTargetSessionCountAndFirstContainer(() => true)?.[1]).assertEqual(scbSceneContainerSessionArray[0]);
    });

    it('filterIsNotDeletingSceneSessionsTest', 0, () => {
      scbSceneContainerSessionArray.push(scbSceneContainerSession);
      expect(scbSceneContainerSessionArray.filterIsNotDeletingSceneSessions().length).assertEqual(scbSceneContainerSessionArray.length);
    });

    it('removeDeletingSceneSessionsTest', 0, () => {
      scbSceneContainerSessionArray.push(scbSceneContainerSession);
      let length = scbSceneContainerSessionArray.length;
      scbSceneContainerSessionArray.removeDeletingSceneSessions()
      expect(scbSceneContainerSessionArray.length).assertEqual(length);
    });

    it('updateRectForFloatTest', 0, () => {
      let curSCBSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      curSCBSceneContainerSession.updateRectForFloat(new SCBSessionRect(1,1,1,1));
      expect(curSCBSceneContainerSession.width.getPx()).assertEqual(1);
      expect(curSCBSceneContainerSession.height.getPx()).assertEqual(1);
    });

    it('updateScaleForFloatTest', 0, () => {
      scbSceneContainerSession.updateScaleForFloat(0, false);
      expect(scbSceneContainerSession.floatingParam.scale).assertEqual(0);
    });

    it('mainSessionTest', 0, () => {
      let curSCBSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      expect(curSCBSceneContainerSession.mainSession).assertEqual(curSCBSceneContainerSession.primarySession);
      curSCBSceneContainerSession.primarySession = null;
      expect(curSCBSceneContainerSession.mainSession).assertEqual(curSCBSceneContainerSession.secondarySession);
      curSCBSceneContainerSession.secondarySession = null;
      expect(curSCBSceneContainerSession.mainSession).assertNull();
    });

    it('mainSessionActiveTest_0', 0, () => {
      let curSCBSceneContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(sceneSession, screenProperty);
      if (curSCBSceneContainerSession.primarySession) {
        curSCBSceneContainerSession.primarySession.sessionData.setIsActive(true);
      }
      expect(curSCBSceneContainerSession.mainSessionActive).assertEqual(curSCBSceneContainerSession.primarySession);
    });

    it('mainSessionActiveTest_1', 0, () => {
      let curSCBSceneContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(sceneSession, screenProperty);
      curSCBSceneContainerSession.primarySession = null;
      if (curSCBSceneContainerSession.secondarySession) {
        curSCBSceneContainerSession.secondarySession.sessionData.setIsActive(true);
      }
      expect(curSCBSceneContainerSession.mainSessionActive).assertEqual(curSCBSceneContainerSession.secondarySession);
    });

    it('mainSessionActiveTest_2', 0, () => {
      let curSCBSceneContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(sceneSession, screenProperty);
      curSCBSceneContainerSession.primarySession = null;
      curSCBSceneContainerSession.secondarySession = null;
      expect(curSCBSceneContainerSession.mainSession).assertNull();
    });

    it('haveActiveSessionTest', 0, () => {
      let curSCBSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      expect(curSCBSceneContainerSession.haveActiveSession()).assertTrue();
      curSCBSceneContainerSession.primarySession = null;
      expect(curSCBSceneContainerSession.haveActiveSession()).assertFalse();
      curSCBSceneContainerSession.secondarySession = null;
      expect(curSCBSceneContainerSession.haveActiveSession()).assertFalse();
    });

    it('haveActiveSessionTest02', 0, () => {
      let curSCBSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let sceneInfo1: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'replaceSceneSessionTest4');
      let sceneSession1: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo1), sceneInfo1);
      sceneSession1.sessionData.setIsActive(true);
      curSCBSceneContainerSession.midSceneMap.set(1, sceneSession1);
      expect(curSCBSceneContainerSession.haveActiveSession()).assertTrue();
    });

    it('notifyInteractiveStateChangeTest', 0, () => {
      scbSceneContainerSession.registerInteractiveStateChangeCallback(() => true);
      scbSceneContainerSession.primarySession?.registerInteractiveStateChangeCallback(() => true);
      scbSceneContainerSession.secondarySession?.registerInteractiveStateChangeCallback(() => true);
      scbSceneContainerSession.notifyInteractiveStateChange(true);

      scbSceneContainerSession.unregisterInteractiveStateChangeCallback();
      scbSceneContainerSession.primarySession?.unregisterInteractiveStateChangeCallback();
      scbSceneContainerSession.secondarySession?.unregisterInteractiveStateChangeCallback();
      scbSceneContainerSession.notifyInteractiveStateChange(false);
    });

    it('notifyInteractiveStateChangeTest01', 0, () => {
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      scbSceneContainerSession.addSceneSession(secSceneSession);
      scbSceneContainerSession.notifyInteractiveStateChange(true);

      scbSceneContainerSession.removeSceneSession(secSceneSession);
      scbSceneContainerSession.notifyInteractiveStateChange(true);

      scbSceneContainerSession.removeSceneSession(scbSceneContainerSession.primarySession);
      scbSceneContainerSession.notifyInteractiveStateChange(true);
    });

    it('changeStateAndgetStateTest', 0, () => {
      scbSceneContainerSession.changeState(0);
      expect(scbSceneContainerSession.getState()).assertEqual(0);
      scbSceneContainerSession.changeState(1);
      expect(scbSceneContainerSession.getState()).assertEqual(1);
    });

    it('getSkipRotationAndsetSkipRotationTest', 0, () => {
      scbSceneContainerSession.setSkipRotation(true);
      expect(scbSceneContainerSession.getSkipRotation()).assertTrue();
      scbSceneContainerSession.setSkipRotation(false);
      expect(scbSceneContainerSession.getSkipRotation()).assertFalse();
    });

    it('registerContainerStateChangeCallbackTest', 0, () => {
      scbSceneContainerSession.registerContainerStateChangeCallback(null);
      scbSceneContainerSession.registerContainerStateChangeCallback(() => true);
    });

    it('unregisterContainerStateChangeCallbackTest', 0, () => {
      scbSceneContainerSession.registerContainerStateChangeCallback(() => true);
      scbSceneContainerSession.unregisterContainerStateChangeCallback(() => true);
      scbSceneContainerSession.unregisterContainerStateChangeCallback(() => true);
    });

    it('updateRecentTitleViewTest', 0, () => {
      scbSceneContainerSession.setUpdateTitleViewCallback(() => true);
      scbSceneContainerSession.updateRecentTitleView();
      scbSceneContainerSession.setUpdateTitleViewCallback(null);
      scbSceneContainerSession.updateRecentTitleView();
    });

    it('addRefCountTest', 0, () => {
      let val = scbSceneContainerSession.getRefCount();
      scbSceneContainerSession.addRefCount();
      expect(val + 1).assertEqual(scbSceneContainerSession.getRefCount());
    });

    it('decRefCountTest', 0, () => {
      let val = scbSceneContainerSession.getRefCount();
      scbSceneContainerSession.decRefCount();
      expect(val - 1).assertEqual(scbSceneContainerSession.getRefCount());
    });

    it('unRegisterAllTest', 0, () => {
      scbSceneContainerSession.getRefCount();
      scbSceneContainerSession.unRegisterAll();
      scbSceneContainerSession.addRefCount();
      scbSceneContainerSession.unRegisterAll();
    });

    it('haveSessionWithPersistentIdTest', 0, () => {
      expect(scbSceneContainerSession.haveSessionWithPersistentId(scbSceneContainerSession.primarySession?.session.persistentId)).assertTrue();
      expect(scbSceneContainerSession.haveSessionWithPersistentId(scbSceneContainerSession.secondarySession?.session.persistentId)).assertTrue();
      expect(scbSceneContainerSession.haveSessionWithPersistentId(-1)).assertFalse();
      expect(scbSceneContainerSession.haveSessionWithPersistentId(scbSceneContainerSession.primarySession?.session.persistentId, false)).assertFalse();
      expect(scbSceneContainerSession.haveSessionWithPersistentId(scbSceneContainerSession.secondarySession?.session.persistentId, false)).assertTrue();
      expect(scbSceneContainerSession.haveSessionWithPersistentId(-1, false)).assertFalse();
      expect(scbSceneContainerSession.haveSessionWithPersistentId(scbSceneContainerSession.primarySession?.session.persistentId, true, false)).assertTrue();
      expect(scbSceneContainerSession.haveSessionWithPersistentId(scbSceneContainerSession.secondarySession?.session.persistentId, true, false)).assertFalse();
      expect(scbSceneContainerSession.haveSessionWithPersistentId(-1, true, false)).assertFalse();
      expect(scbSceneContainerSession.haveSessionWithPersistentId(scbSceneContainerSession.primarySession?.session.persistentId, false, false)).assertFalse();
      expect(scbSceneContainerSession.haveSessionWithPersistentId(scbSceneContainerSession.secondarySession?.session.persistentId, false, false)).assertFalse();
      expect(scbSceneContainerSession.haveSessionWithPersistentId(-1, false, false)).assertFalse();
    });

    it('getLastUsedTimestampTest', 0, () => {
      scbSceneContainerSession.updateLastUsedTimestamp(0);
      expect(scbSceneContainerSession.getLastUsedTimestamp()).assertEqual(0);
    });

    it('setActivationAtToggleHomeScenarioTest', 0, () => {
      scbSceneContainerSession.setActivationAtToggleHomeScenario();
      expect(scbSceneContainerSession.toggleHomeState).assertFalse();
      expect(scbSceneContainerSession.isActive).assertTrue();
    });

    it('removeDivierParam', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let firstSceneParam: SceneParam = new SceneParam();
      let secondSceneParam: SceneParam = new SceneParam();
      let dividerParam: SCBDividerParam = new SCBDividerParam();
      dividerParam.primary = firstSceneParam;
      dividerParam.secondary = secondSceneParam;
      containerSession.dividerParamList.push(dividerParam);
      containerSession.removeDivierParam(firstSceneParam, secondSceneParam);
    });

    it('getDividerParam', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let dividerParam: SCBDividerParam = new SCBDividerParam();
      let primaryId: number = dividerParam.primary.persistentId;
      containerSession.dividerParamList.push(dividerParam);
      expect(containerSession.getDividerParam(primaryId).primary.persistentId).assertEqual(primaryId);
      expect(containerSession.getDividerParam(123).primary.persistentId).assertEqual(0);
    });

    it('getSceneParams', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.getSceneParams();
    });

    it('removeSceneSessionFromMidScene', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.removeSceneSessionFromMidScene(sceneSession, true);
      containerSession.removeSceneSessionFromMidScene(null, true);
    });

    it('setByRectInfo', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let iconRectInfo: RectInfo = new RectInfo();
      let param: SceneParam = new SceneParam();
      containerSession.setByRectInfo(iconRectInfo, param);
    });

    it('updateContainerSessionWithRotationTest01', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let reason:SCBContainerRotationReason = SCBContainerRotationReason.SCREEN_ROTATION;
      containerSession.isFloat = true;
      containerSession.updateContainerSessionWithRotation(screenProperty, reason);
      let tmpWidth: ScbNumber = new ScbNumber(0);
      let tmpHeight: ScbNumber = new ScbNumber(0);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateContainerSessionWithRotationTest02', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let reason: SCBContainerRotationReason = SCBContainerRotationReason.SCREEN_ROTATION;
      screenProperty.rotation = 10;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.isFloat = false;
      containerSession.currentRotation = 0;
      screenProperty.rotation = 1;
      containerSession.updateContainerSessionWithRotation(screenProperty, reason);
      let tmpWidth: ScbNumber = new ScbNumber(20);
      let tmpHeight: ScbNumber = new ScbNumber(30);
      expect(containerSession.currentRotation).assertEqual(1);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateContainerSessionWithRotationTest03', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let reason: SCBContainerRotationReason = SCBContainerRotationReason.SCREEN_ROTATION;
      screenProperty.rotation = 10;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.isFloat = false;
      containerSession.currentRotation = 0;
      screenProperty.rotation = 0;
      containerSession.isSplit = true;
      containerSession.updateContainerSessionWithRotation(screenProperty, reason);
      let tmpWidth: ScbNumber = new ScbNumber(20);
      let tmpHeight: ScbNumber = new ScbNumber(30);
      expect(containerSession.currentRotation).assertEqual(0);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateContainerSessionWithRotationTest04', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let reason: SCBContainerRotationReason = SCBContainerRotationReason.EXIT_SCENE;
      screenProperty.rotation = 0;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.updateContainerSessionWithRotation(screenProperty, reason);
      let tmpWidth: ScbNumber = new ScbNumber(0);
      let tmpHeight: ScbNumber = new ScbNumber(0);
      expect(containerSession.currentRotation).assertEqual(0);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateContainerSessionWithRotationTest05', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let reason: SCBContainerRotationReason = SCBContainerRotationReason.PANEL_ROTATION;
      screenProperty.rotation = 0;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.isFloat = false;
      containerSession.currentRotation = 0;
      screenProperty.rotation = 0;
      containerSession.updateContainerSessionWithRotation(screenProperty, reason);
      let tmpWidth: ScbNumber = new ScbNumber(20);
      let tmpHeight: ScbNumber = new ScbNumber(30);
      expect(containerSession.currentRotation).assertEqual(0);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateContainerSessionWithRotationTest06', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let reason: SCBContainerRotationReason = SCBContainerRotationReason.LANDSCAPE_ONE_STEP_SCENE;
      screenProperty.rotation = 0;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.isFloat = false;
      containerSession.currentRotation = 0;
      screenProperty.rotation = 0;
      containerSession.updateContainerSessionWithRotation(screenProperty, reason);
      let tmpWidth: ScbNumber = new ScbNumber(20);
      let tmpHeight: ScbNumber = new ScbNumber(30);
      expect(containerSession.currentRotation).assertEqual(0);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateContainerSessionWithRotationTest07', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let reason: SCBContainerRotationReason = SCBContainerRotationReason.SCREEN_ROTATION;
      screenProperty.rotation = 90;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.isFloat = false;
      containerSession.currentRotation = 0;
      screenProperty.rotation = 0;
      containerSession.updateContainerSessionWithRotation(screenProperty, reason);
      let tmpWidth: ScbNumber = new ScbNumber(20);
      let tmpHeight: ScbNumber = new ScbNumber(30);
      expect(containerSession.currentRotation).assertEqual(0);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateContainerSessionWithRotationTest08', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let reason: SCBContainerRotationReason = SCBContainerRotationReason.SCREEN_ROTATION;
      screenProperty.rotation = 180;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.isFloat = false;
      containerSession.currentRotation = 0;
      screenProperty.rotation = 0;
      containerSession.updateContainerSessionWithRotation(screenProperty, reason);
      let tmpWidth: ScbNumber = new ScbNumber(20);
      let tmpHeight: ScbNumber = new ScbNumber(30);
      expect(containerSession.currentRotation).assertEqual(0);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateContainerSessionWithRotationTest09', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let reason: SCBContainerRotationReason = SCBContainerRotationReason.SCREEN_ROTATION;
      screenProperty.rotation = 270;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.isFloat = false;
      containerSession.currentRotation = 0;
      screenProperty.rotation = 0;
      containerSession.updateContainerSessionWithRotation(screenProperty, reason);
      let tmpWidth: ScbNumber = new ScbNumber(20);
      let tmpHeight: ScbNumber = new ScbNumber(30);
      expect(containerSession.currentRotation).assertEqual(0);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateContainerSessionWithRotationTest10', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let reason: SCBContainerRotationReason = SCBContainerRotationReason.SCREEN_ROTATION;
      screenProperty.rotation = 360;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.isFloat = false;
      containerSession.currentRotation = 0;
      screenProperty.rotation = 0;
      containerSession.updateContainerSessionWithRotation(screenProperty, reason);
      let tmpWidth: ScbNumber = new ScbNumber(20);
      let tmpHeight: ScbNumber = new ScbNumber(30);
      expect(containerSession.currentRotation).assertEqual(0);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateContainerSessionWithRotationTest11', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let reason: SCBContainerRotationReason = SCBContainerRotationReason.SCREEN_ROTATION;
      screenProperty.rotation = 0;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.isFloat = false;
      containerSession.currentRotation = 90;
      screenProperty.rotation = 0;
      containerSession.updateContainerSessionWithRotation(screenProperty, reason);
      let tmpWidth: ScbNumber = new ScbNumber(20);
      let tmpHeight: ScbNumber = new ScbNumber(30);
      expect(containerSession.currentRotation).assertEqual(0);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateContainerSessionWithRotationTest12', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let reason: SCBContainerRotationReason = SCBContainerRotationReason.SCREEN_ROTATION;
      screenProperty.rotation = 90;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.isFloat = false;
      containerSession.currentRotation = 90;
      screenProperty.rotation = 0;
      containerSession.updateContainerSessionWithRotation(screenProperty, reason);
      let tmpWidth: ScbNumber = new ScbNumber(20);
      let tmpHeight: ScbNumber = new ScbNumber(30);
      expect(containerSession.currentRotation).assertEqual(0);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateContainerSessionWithRotationTest13', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let reason: SCBContainerRotationReason = SCBContainerRotationReason.SCREEN_ROTATION;
      screenProperty.rotation = 180;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.isFloat = false;
      containerSession.currentRotation = 90;
      screenProperty.rotation = 0;
      containerSession.updateContainerSessionWithRotation(screenProperty, reason);
      let tmpWidth: ScbNumber = new ScbNumber(20);
      let tmpHeight: ScbNumber = new ScbNumber(30);
      expect(containerSession.currentRotation).assertEqual(0);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateContainerSessionWithRotationTest14', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let reason: SCBContainerRotationReason = SCBContainerRotationReason.SCREEN_ROTATION;
      screenProperty.rotation = 270;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.isFloat = false;
      containerSession.currentRotation = 90;
      screenProperty.rotation = 0;
      containerSession.updateContainerSessionWithRotation(screenProperty, reason);
      let tmpWidth: ScbNumber = new ScbNumber(20);
      let tmpHeight: ScbNumber = new ScbNumber(30);
      expect(containerSession.currentRotation).assertEqual(0);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateContainerSessionWithRotationTest15', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let reason: SCBContainerRotationReason = SCBContainerRotationReason.SCREEN_ROTATION;
      screenProperty.rotation = 360;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.isFloat = false;
      containerSession.currentRotation = 90;
      screenProperty.rotation = 0;
      containerSession.updateContainerSessionWithRotation(screenProperty, reason);
      let tmpWidth: ScbNumber = new ScbNumber(20);
      let tmpHeight: ScbNumber = new ScbNumber(30);
      expect(containerSession.currentRotation).assertEqual(0);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateContainerSessionWithFoldTest01', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.UNDEFINED;
      screenProperty.rotation = 1;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.updateContainerSessionWithFold(screenProperty, reason);
      let tmpWidth: ScbNumber = new ScbNumber(0);
      let tmpHeight: ScbNumber = new ScbNumber(0);
      expect(containerSession.currentRotation).assertEqual(0);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateContainerSessionWithFoldTest02', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.FOLD_SCREEN_ROTATION;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.isFloat = true;
      containerSession.updateContainerSessionWithFold(screenProperty, reason);
      let tmpWidth: ScbNumber = new ScbNumber(0);
      let tmpHeight: ScbNumber = new ScbNumber(0);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateContainerSessionWithFoldTest03', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.FOLD_LANDSCAPE_START;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.isFloat = true;
      containerSession.updateContainerSessionWithFold(screenProperty, reason);
      let tmpWidth: ScbNumber = new ScbNumber(0);
      let tmpHeight: ScbNumber = new ScbNumber(0);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateContainerSessionWithFoldTest04', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.FOLD_TO_EXPAND;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.isFloat = true;
      containerSession.updateContainerSessionWithFold(screenProperty, reason);
      let tmpWidth: ScbNumber = new ScbNumber(0);
      let tmpHeight: ScbNumber = new ScbNumber(0);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateContainerSessionWithFoldTest05', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.EXPAND_TO_FOLD;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.isFloat = true;
      containerSession.updateContainerSessionWithFold(screenProperty, reason);
      let tmpWidth: ScbNumber = new ScbNumber(0);
      let tmpHeight: ScbNumber = new ScbNumber(0);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateContainerSessionWithFoldTest06', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.UNDEFINED;
      screenProperty.rotation = 0;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.updateContainerSessionWithFold(screenProperty, reason);
      let tmpWidth: ScbNumber = new ScbNumber(0);
      let tmpHeight: ScbNumber = new ScbNumber(0);
      expect(containerSession.currentRotation).assertEqual(0);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateContainerSessionWithFoldTest07', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.FOLD_SCREEN_ROTATION;
      screenProperty.rotation = 90;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.updateContainerSessionWithFold(screenProperty, reason);
      let tmpWidth: ScbNumber = new ScbNumber(20);
      let tmpHeight: ScbNumber = new ScbNumber(30);
      expect(containerSession.currentRotation).assertEqual(90);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateContainerSessionWithFoldTest08', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.FOLD_SCREEN_ROTATION;
      screenProperty.rotation = 180;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.updateContainerSessionWithFold(screenProperty, reason);
      let tmpWidth: ScbNumber = new ScbNumber(20);
      let tmpHeight: ScbNumber = new ScbNumber(30);
      expect(containerSession.currentRotation).assertEqual(180);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateContainerSessionWithFoldTest09', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.FOLD_SCREEN_ROTATION;
      screenProperty.rotation = 270;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.updateContainerSessionWithFold(screenProperty, reason);
      let tmpWidth: ScbNumber = new ScbNumber(20);
      let tmpHeight: ScbNumber = new ScbNumber(30);
      expect(containerSession.currentRotation).assertEqual(270);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateContainerSessionWithFoldTest10', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.FOLD_SCREEN_ROTATION;
      screenProperty.rotation = 360;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.updateContainerSessionWithFold(screenProperty, reason);
      let tmpWidth: ScbNumber = new ScbNumber(20);
      let tmpHeight: ScbNumber = new ScbNumber(30);
      expect(containerSession.currentRotation).assertEqual(360);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateContainerSessionWithFoldTest11', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.FOLD_TO_EXPAND;
      screenProperty.rotation = 90;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.updateContainerSessionWithFold(screenProperty, reason);
      let tmpWidth: ScbNumber = new ScbNumber(30);
      let tmpHeight: ScbNumber = new ScbNumber(20);
      expect(containerSession.currentRotation).assertEqual(0);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateContainerSessionWithFoldTest12', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.FOLD_TO_EXPAND;
      screenProperty.rotation = 180;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.updateContainerSessionWithFold(screenProperty, reason);
      let tmpWidth: ScbNumber = new ScbNumber(20);
      let tmpHeight: ScbNumber = new ScbNumber(30);
      expect(containerSession.currentRotation).assertEqual(0);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateContainerSessionWithFoldTest13', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.FOLD_TO_EXPAND;
      screenProperty.rotation = 270;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.updateContainerSessionWithFold(screenProperty, reason);
      let tmpWidth: ScbNumber = new ScbNumber(30);
      let tmpHeight: ScbNumber = new ScbNumber(20);
      expect(containerSession.currentRotation).assertEqual(0);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateContainerSessionWithFoldTest14', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.FOLD_TO_EXPAND;
      screenProperty.rotation = 360;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.updateContainerSessionWithFold(screenProperty, reason);
      let tmpWidth: ScbNumber = new ScbNumber(20);
      let tmpHeight: ScbNumber = new ScbNumber(30);
      expect(containerSession.currentRotation).assertEqual(0);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('setMotionBlurRadiusTest', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.needRenderMotionBlur.setMotionBlurRadius(10);
      let motionBlurRadius = containerSession.needRenderMotionBlur.motionBlurRadius;
      expect(motionBlurRadius).assertEqual(10);
    });

    it('updateContainerSessionWithPhonePortraitAppTest01', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.UNDEFINED;
      screenProperty.rotation = 1;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.updateContainerSessionWithPhonePortraitApp(screenProperty, reason, 1);
      let tmpWidth: ScbNumber = new ScbNumber(0);
      let tmpHeight: ScbNumber = new ScbNumber(0);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateContainerSessionWithPhonePortraitAppTest02', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.FOLD_SCREEN_ROTATION;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.isFloat = true;
      containerSession.updateContainerSessionWithPhonePortraitApp(screenProperty, reason, 1);
      let tmpWidth: ScbNumber = new ScbNumber(0);
      let tmpHeight: ScbNumber = new ScbNumber(0);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('resetSessionRotationTest01', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.rotation = RotationConstants.ROTATION_270;
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);

      let rectInfo: RectInfo = new RectInfo(1, 2, 3, 4);
      let newRectInfo: RectInfo = containerSession.covertWithRotation(rectInfo, true);
      expect(rectInfo.left).assertEqual(newRectInfo.left);
      expect(containerSession.currentRotation).assertEqual(RotationConstants.ROTATION_0);
      containerSession.resetSessionRotation();
      expect(containerSession.currentRotation).assertEqual(RotationConstants.ROTATION_270);
    });

    it('findIndexByPersistentIdTest', 0, () => {
      scbSceneContainerSessionArray.clear();
      let index = scbSceneContainerSessionArray
        .findIndexByPersistentId(scbSceneContainerSession.primarySession?.session.persistentId);
      expect(index).assertEqual(-1);
      scbSceneContainerSessionArray.push(scbSceneContainerSession);
      index = scbSceneContainerSessionArray
        .findIndexByPersistentId(scbSceneContainerSession.primarySession?.session.persistentId);
      expect(index).assertEqual(0);
    });

    it('findByPersistentIdTest', 0, () => {
      scbSceneContainerSessionArray.clear();
      let sceneInfo3: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession3: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo3), sceneInfo3);

      let sceneContainerSession3 = new SCBSceneContainerSession(sceneSession3, screenProperty);
      sceneContainerSession3.isMidScene = true;
      sceneContainerSession3.midSceneMap.set(1, sceneSession3);
      scbSceneContainerSessionArray.push(sceneContainerSession3);
      let containerSession = scbSceneContainerSessionArray
        .findByPersistentId(sceneContainerSession3.primarySession?.session.persistentId);
      expect(containerSession).assertEqual(sceneContainerSession3);

      sceneContainerSession3.midSceneMap.clear();
      containerSession = scbSceneContainerSessionArray
        .findByPersistentId(sceneContainerSession3.primarySession?.session.persistentId);
      expect(containerSession).assertEqual(sceneContainerSession3);

      let callback: Function = () => {};
      let sceneInfo2: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let specificSession = new SCBSpecificSession(sceneSessionManager.requestSceneSession(sceneInfo2), callback);
      sceneContainerSession3.primarySession?.subSessionList.push(specificSession);

      containerSession = scbSceneContainerSessionArray
        .findByPersistentId(specificSession.session.persistentId);
      expect(containerSession).assertNull();

      let needFoundSubSession = true;
      containerSession = scbSceneContainerSessionArray
        .findByPersistentId(specificSession.session.persistentId, needFoundSubSession);
      expect(containerSession).assertEqual(sceneContainerSession3);
    });

    it('findFromSubListTest', 0, () => {
      scbSceneContainerSessionArray.clear();
      let sceneInfo3: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession3: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo3), sceneInfo3);

      let callback: Function = () => {};
      let sceneInfo2: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let specificSession = new SCBSpecificSession(sceneSessionManager.requestSceneSession(sceneInfo2), callback);

      let callback2: Function = () => {};
      let sceneInfo4: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let specificSession2 = new SCBSpecificSession(sceneSessionManager.requestSceneSession(sceneInfo4), callback2);
      sceneSession3?.subSessionList.push(specificSession);

      let result: boolean = ReflectionUtils.useFunc(scbSceneContainerSessionArray, 'findFromSubList', null,
        specificSession.session.persistentId);
      expect(result).assertFalse();

      result = ReflectionUtils.useFunc(scbSceneContainerSessionArray, 'findFromSubList', sceneSession3,
        specificSession.session.persistentId)
      expect(result).assertTrue();

      result = ReflectionUtils.useFunc(scbSceneContainerSessionArray, 'findFromSubList', sceneSession3,
        specificSession2.session.persistentId);
      expect(result).assertFalse();
    });

    it('findSubSessionTest', 0, () => {
      scbSceneContainerSessionArray.clear();
      let sceneInfo3: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession3: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo3), sceneInfo3);

      let callback: Function = () => {};
      let sceneInfo2: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      sceneInfo2.screenId = 0;
      let specificSession = new SCBSpecificSession(sceneSessionManager.requestSceneSession(sceneInfo2), callback);
      sceneSession3?.subSessionList.push(specificSession);

      let result: boolean = ReflectionUtils.useFunc(scbSceneContainerSessionArray, 'findSubSession', null, 0);
      expect(result).assertFalse();

      result = ReflectionUtils.useFunc(scbSceneContainerSessionArray, 'findSubSession', sceneSession3, 0);
      expect(result).assertTrue();

      result = ReflectionUtils.useFunc(scbSceneContainerSessionArray, 'findSubSession', sceneSession3, 1);
      expect(result).assertFalse();
    });

    it('isContainerInScreenHasSessionTest', 0, () => {
      scbSceneContainerSessionArray.clear();
      let sceneInfo3: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      sceneInfo3.screenId = 0;
      let sceneSession3: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo3), sceneInfo3);
      let sceneContainerSession3 = new SCBSceneContainerSession(sceneSession3, screenProperty);
      scbSceneContainerSessionArray.push(sceneContainerSession3);
      expect(scbSceneContainerSessionArray.isContainerInScreenHasSession(sceneContainerSession3.containerId, 0))
        .assertTrue();

      let sceneInfo4: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      sceneInfo4.screenId = 0;
      let sceneSession4: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo4), sceneInfo4);
      let sceneContainerSession4 = new SCBSceneContainerSession(sceneSession4, screenProperty);
      expect(scbSceneContainerSessionArray.isContainerInScreenHasSession(sceneContainerSession4.containerId, 0))
        .assertFalse();

      let callback: Function = () => {};
      let sceneInfo2: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      sceneInfo2.screenId = 1;
      let specificSession = new SCBSpecificSession(sceneSessionManager.requestSceneSession(sceneInfo2), callback);
      sceneSession3?.subSessionList.push(specificSession);
      expect(scbSceneContainerSessionArray.isContainerInScreenHasSession(sceneContainerSession3.containerId, 1))
        .assertTrue();
    });

    it('getSubSessionByPersistentIdTest', 0, () => {
      scbSceneContainerSessionArray.clear();
      let sceneInfo3: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession3: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo3), sceneInfo3);
      let sceneContainerSession3 = new SCBSceneContainerSession(sceneSession3, screenProperty);
      let callback: Function = () => {};
      let sceneInfo2: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let specificSession = new SCBSpecificSession(sceneSessionManager.requestSceneSession(sceneInfo2), callback);
      sceneSession3?.subSessionList.push(specificSession);
      scbSceneContainerSessionArray.push(sceneContainerSession3);

      let result: SCBSpecificSession | null = ReflectionUtils.useFunc(scbSceneContainerSessionArray,
        'getSubSessionByPersistentId', null, specificSession.session.persistentId);
      expect(result).assertNull();

      result = ReflectionUtils.useFunc(scbSceneContainerSessionArray, 'getSubSessionByPersistentId',
        sceneSession3, specificSession.session.persistentId);
      expect(result).assertEqual(specificSession);
    });

    it('getSessionByPersistentIdTest', 0, () => {
      scbSceneContainerSessionArray.clear();
      let sceneInfo3: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession3: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo3), sceneInfo3);
      sceneSession3.sceneInfo.persistentId = sceneSession3.session.persistentId;
      let sceneContainerSession3 = new SCBSceneContainerSession(sceneSession3, screenProperty);
      let callback: Function = () => {};
      let sceneInfo2: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let specificSession = new SCBSpecificSession(sceneSessionManager.requestSceneSession(sceneInfo2), callback);
      sceneSession3?.subSessionList.push(specificSession);
      scbSceneContainerSessionArray.push(sceneContainerSession3);

      expect(scbSceneContainerSessionArray.getSessionByPersistentId(sceneSession3.sceneInfo.persistentId))
        .assertEqual(sceneSession3);

      expect(scbSceneContainerSessionArray.getSessionByPersistentId(specificSession.session.persistentId))
        .assertEqual(specificSession);

      let sceneInfo4: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession4: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo4), sceneInfo4);
      expect(scbSceneContainerSessionArray.getSessionByPersistentId(sceneSession4.session.persistentId)).assertNull();
    });

    it('saveSecondarySceneSize', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.saveSecondarySceneSize();
      expect(containerSession.secondarySceneW).assertEqual(containerSession.dividerParam.secondary.width);
    });

    it('startCardForSplitAndStartCard', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.startOtherForSplit();
      let cardRectInfo: RectInfo = new RectInfo();
      ReflectionUtils.useFunc(containerSession, 'startCardForSplit', cardRectInfo);
      ReflectionUtils.useFunc(containerSession, 'startCard', cardRectInfo);
      ReflectionUtils.useFunc(containerSession, 'startApp', cardRectInfo);
      ReflectionUtils.useFunc(containerSession, 'startAppForSplit', cardRectInfo);

      cardRectInfo.left = 10;
      cardRectInfo.right = 100;
      ReflectionUtils.useFunc(containerSession, 'startCardForSplit', cardRectInfo);
      ReflectionUtils.useFunc(containerSession, 'startCard', cardRectInfo);
      ReflectionUtils.useFunc(containerSession, 'startApp', cardRectInfo);
      ReflectionUtils.useFunc(containerSession, 'startAppForSplit', cardRectInfo);
    });

    it('startOtherForQuickAccessMenu01', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);

      containerSession.screenProperty.rotation = 90;
      containerSession.startOtherForQuickAccessMenu(0, 0, 0);
      expect(containerSession).not().assertNull();
    });

    it('startOtherForQuickAccessMenu02', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);

      containerSession.currentRotation = 90;
      containerSession.startOtherForQuickAccessMenu(0, 0, 0);

      containerSession.currentRotation = 180;
      containerSession.startOtherForQuickAccessMenu(0, 0, 0);

      containerSession.currentRotation = 270;
      containerSession.startOtherForQuickAccessMenu(0, 0, 0);
      expect(containerSession).not().assertNull();
    });

    it('startOtherForQuickAccessMenu03', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);

      containerSession.currentRotation = 0;
      containerSession.startOtherForQuickAccessMenu(0, 0, 0, true);

      containerSession.currentRotation = 90;
      containerSession.startOtherForQuickAccessMenu(0, 0, 0, true);

      containerSession.currentRotation = 180;
      containerSession.startOtherForQuickAccessMenu(0, 0, 0, true);

      containerSession.currentRotation = 270;
      containerSession.startOtherForQuickAccessMenu(0, 0, 0, true);
      expect(containerSession).not().assertNull();
    });

    // ---

    it('add', 0, () => {
      scbSceneContainerSessionArray.clear();

      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      expect(scbSceneContainerSessionArray.add(scbSceneContainerSession)).assertTrue();
      expect(scbSceneContainerSessionArray.add(null)).assertFalse();
    });

    it('insert', 0, () => {
      scbSceneContainerSessionArray.clear();
      expect(scbSceneContainerSessionArray.insert(0, null)).assertFalse();

      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      expect(scbSceneContainerSessionArray.insert(1, scbSceneContainerSession)).assertFalse();

      scbSceneContainerSessionArray.add(scbSceneContainerSession);
      expect(scbSceneContainerSessionArray.insert(0, scbSceneContainerSession)).assertFalse();
    });

    it('getTopActiveSession', 0, () => {
      scbSceneContainerSessionArray.clear();
      expect(scbSceneContainerSessionArray.getTopActiveSession()).assertNull();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      scbSceneContainerSessionArray.add(scbSceneContainerSession);
      expect(scbSceneContainerSessionArray.getTopActiveSession()).assertNull();
      scbSceneContainerSession.setActivationAtToggleHomeScenario();
      expect(scbSceneContainerSessionArray.getTopActiveSession()).assertEqual(scbSceneContainerSession);
    });

    it('getTopActiveFullSession', 0, () => {
      scbSceneContainerSessionArray.clear();
      expect(scbSceneContainerSessionArray.getTopActiveFullSession()).assertNull();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      scbSceneContainerSessionArray.add(scbSceneContainerSession);
      expect(scbSceneContainerSessionArray.getTopActiveFullSession()).assertNull();
      scbSceneContainerSession.setActivationAtToggleHomeScenario();
      expect(scbSceneContainerSessionArray.getTopActiveFullSession()).assertEqual(scbSceneContainerSession);
      scbSceneContainerSession.isFloat = true;
      expect(scbSceneContainerSessionArray.getTopActiveFullSession()).assertNull();
    });

    it('getTopActiveSessionIndex', 0, () => {
      scbSceneContainerSessionArray.clear();
      expect(scbSceneContainerSessionArray.getTopActiveSessionIndex()).assertEqual(-1);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      scbSceneContainerSessionArray.add(scbSceneContainerSession);
      expect(scbSceneContainerSessionArray.getTopActiveSessionIndex()).assertEqual(-1);
      scbSceneContainerSession.setActivationAtToggleHomeScenario();
      expect(scbSceneContainerSessionArray.getTopActiveSessionIndex()).assertEqual(0);
    });

    it('getActiveSessionList', 0, () => {
      scbSceneContainerSessionArray.clear();
      expect(scbSceneContainerSessionArray.getActiveSessionList().length).assertEqual(0);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let scbSceneContainerSession02: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      scbSceneContainerSessionArray.add(scbSceneContainerSession);
      scbSceneContainerSessionArray.add(scbSceneContainerSession02);
      scbSceneContainerSession.setActivationAtToggleHomeScenario();
      scbSceneContainerSession02.setActivationAtToggleHomeScenario();
      expect(scbSceneContainerSessionArray.getActiveSessionList().length).assertEqual(2);
    });

    it('getInactiveSessionList', 0, () => {
      scbSceneContainerSessionArray.clear();
      expect(scbSceneContainerSessionArray.getInactiveSessionList().length).assertEqual(0);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let scbSceneContainerSession02: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      scbSceneContainerSessionArray.add(scbSceneContainerSession);
      scbSceneContainerSessionArray.add(scbSceneContainerSession02);
      scbSceneContainerSession02.setActivationAtToggleHomeScenario();
      expect(scbSceneContainerSessionArray.getInactiveSessionList().length).assertEqual(1);
    });

    it('getActiveSceneContainerSessionCount', 0, () => {
      scbSceneContainerSessionArray.clear();
      expect(scbSceneContainerSessionArray.getActiveSceneContainerSessionCount()).assertEqual(0);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let scbSceneContainerSession02: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      scbSceneContainerSessionArray.add(scbSceneContainerSession);
      scbSceneContainerSessionArray.add(scbSceneContainerSession02);
      scbSceneContainerSession02.setActivationAtToggleHomeScenario();
      expect(scbSceneContainerSessionArray.getActiveSceneContainerSessionCount()).assertEqual(1);
    });

    it('getSceneSessionByPersistentId', 0, () => {
      scbSceneContainerSessionArray.clear();
      expect(scbSceneContainerSessionArray.getSceneSessionByPersistentId(0, true)).assertNull();
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);

      containerSession.addSceneSession(null);
      scbSceneContainerSessionArray.add(containerSession);
      expect(scbSceneContainerSessionArray.getSceneSessionByPersistentId(0, true)).assertNull();

      containerSession.primarySession = sceneSession;
      containerSession.secondarySession = sceneSession;
      containerSession.addSceneSession(sceneSession);
      let containerSession01: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let sceneSession01: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      containerSession01.primarySession = sceneSession01;
      containerSession01.secondarySession = sceneSession01;
      containerSession01.addSceneSession(sceneSession01);
      scbSceneContainerSessionArray.add(containerSession01);
      expect(scbSceneContainerSessionArray.getSceneSessionByPersistentId(1, true)).assertNull();
    });

    it('getSessionByPersistentId', 0, () => {
      scbSceneContainerSessionArray.clear();
      expect(scbSceneContainerSessionArray.getSessionByPersistentId(0)).assertNull();
      let containerSession01: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let sceneSession01: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      containerSession01.primarySession = sceneSession01;
      containerSession01.secondarySession = sceneSession01;
      containerSession01.addSceneSession(sceneSession01);
      scbSceneContainerSessionArray.add(containerSession01);
      expect(scbSceneContainerSessionArray.getSessionByPersistentId(0)).assertEqual(sceneSession01);
      expect(scbSceneContainerSessionArray.getSessionByPersistentId(1)).assertNull();
    });

    it('requestActivation', 0, () => {
      let containerSession01: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let sceneSession01: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      containerSession01.primarySession = sceneSession01;
      containerSession01.secondarySession = sceneSession01;
      containerSession01.addSceneSession(sceneSession01);
      containerSession01.requestActivation(true, 1);
      expect(sceneSession01.isDisplayLand).assertFalse();
    });

    it('onTransitionInactiveForSplit', 0, () => {
      let containerSession01: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let sceneSession01: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      containerSession01.primarySession = sceneSession01;
      containerSession01.secondarySession = sceneSession01;
      containerSession01.addSceneSession(sceneSession01);
      containerSession01.onTransitionInactiveForSplit();
      expect(containerSession01.dividerParam.secondary.width).assertEqual('100%');
      expect(containerSession01.dividerParam.secondary.height).assertEqual('100%');
      expect(containerSession01.needRenderTranslateIcon.translateIconX).assertEqual(0);
      expect(containerSession01.needRenderTranslateIcon.translateIconY).assertEqual(0);
    });

    it('pushDiglogSessionId', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      ReflectionUtils.useFunc(sceneContainerSession, 'pushDiglogSessionId', [], sceneSession);
    });

    it('pushSubSessionId', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      ReflectionUtils.useFunc(sceneContainerSession, 'pushSubSessionId', [1, 2], null);
    });

    it('pushSessionId', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      ReflectionUtils.useFunc(sceneContainerSession, 'pushSessionId', [1, 2], null);

      ReflectionUtils.useFunc(sceneContainerSession, 'pushSessionId', [1, 2], sceneSession);
    });

    it('BuildContainerIDListNotSplitScreen', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      sceneInfo.persistentId = 123;
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sceneInfo2: SCBSceneInfo = new SCBSceneInfo('testBundle2', 'testModule2', 'testAbility2');
      sceneInfo2.persistentId = 234;
      let sceneSession2: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo2), sceneInfo2);
      let sceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      sceneContainerSession.addSceneSession(sceneSession2);
      expect(ReflectionUtils.useFunc(sceneContainerSession, 'BuildContainerIDListNotSplitScreen')[1]).assertEqual(234);

      sceneContainerSession.removeSceneSession(sceneSession2);
      sceneContainerSession.removeSceneSession(sceneSession);
      expect(ReflectionUtils.useFunc(sceneContainerSession, 'BuildContainerIDListNotSplitScreen')[0]).assertEqual(123);
    });

    it('BuildSplitScreenContainerIDList', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      sceneInfo.persistentId = 123;
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sceneInfo2: SCBSceneInfo = new SCBSceneInfo('testBundle2', 'testModule2', 'testAbility2');
      sceneInfo2.persistentId = 234;
      let sceneSession2: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo2), sceneInfo2);
      let sceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      sceneContainerSession.addSceneSession(sceneSession2);

      expect(ReflectionUtils.useFunc(sceneContainerSession, 'BuildSplitScreenContainerIDList')[1]).assertEqual(234);
      sceneContainerSession.removeSceneSession(sceneSession2);
      sceneContainerSession.removeSceneSession(sceneSession);
      expect(ReflectionUtils.useFunc(sceneContainerSession, 'BuildSplitScreenContainerIDList')[0]).assertEqual(123);
    });

    it('getSceneSessionIdList', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      expect(sceneContainerSession.getSceneSessionIdList()[0]).assertEqual(0);
      sceneContainerSession.isSplit = true;
      expect(sceneContainerSession.getSceneSessionIdList()[0]).assertEqual(0);
    });

    it('isSessionContainedInList', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      sceneInfo.persistentId = 123;
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sceneInfo2: SCBSceneInfo = new SCBSceneInfo('testBundle2', 'testModule2', 'testAbility2');
      sceneInfo2.persistentId = 234;
      let sceneSession2: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo2), sceneInfo2);
      let sceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      sceneContainerSession.addSceneSession(sceneSession2);

      expect(ReflectionUtils.useFunc(sceneContainerSession, 'isSessionContainedInList', 123, [])).assertFalse();

      let subSession2: SCBSpecificSessionTest = {
        session: {
          persistentId: 234
        },
        subSessionList: []
      };

      let subSession1: SCBSpecificSessionTest = {
        session: {
          persistentId: 123
        },
        subSessionList: [subSession2]
      };
      let subSessionList: Array<SCBSpecificSessionTest> = [subSession1];
      expect(ReflectionUtils.useFunc(sceneContainerSession, 'isSessionContainedInList', 123, subSessionList)).assertTrue();
      expect(ReflectionUtils.useFunc(sceneContainerSession, 'isSessionContainedInList', 0, subSessionList)).assertFalse();

      subSessionList.push(subSession2);
      expect(ReflectionUtils.useFunc(sceneContainerSession, 'isSessionContainedInList', 234, subSessionList)).assertTrue();
    });

    it('isMidSceneMap', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      sceneInfo.persistentId = 123;
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);

      expect(ReflectionUtils.useFunc(sceneContainerSession, 'isMidSceneMap', 123)).assertFalse();

      let sceneInfo2: SCBSceneInfo = new SCBSceneInfo('testBundle2', 'testModule2', 'testAbility2');
      let sceneSession2: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo2), sceneInfo2);
      sceneContainerSession.midSceneMap.set(123, sceneSession2);
      expect(ReflectionUtils.useFunc(sceneContainerSession, 'isMidSceneMap', 123)).assertFalse();
    });

    it('updateRecentAndContainerInfoWithFoldTest01', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let targetRotation = 0;
      let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.FOLD_SCREEN_ROTATION;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.isFloat = true;
      containerSession.updateRecentAndContainerInfoWithFold(screenProperty, reason, targetRotation);
      let tmpWidth: ScbNumber = new ScbNumber(20);
      let tmpHeight: ScbNumber = new ScbNumber(30);
      expect(containerSession.currentRotation).assertEqual(0);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateRecentAndContainerInfoWithFoldTest02', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let targetRotation = 0;
      let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.FOLD_LANDSCAPE_START;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.isFloat = true;
      containerSession.updateRecentAndContainerInfoWithFold(screenProperty, reason, targetRotation);
      let tmpWidth: ScbNumber = new ScbNumber(20);
      let tmpHeight: ScbNumber = new ScbNumber(30);
      expect(containerSession.currentRotation).assertEqual(0);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateRecentAndContainerInfoWithFoldTest03', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let targetRotation = 0;
      let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.FOLD_TO_EXPAND;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.isFloat = true;
      containerSession.updateRecentAndContainerInfoWithFold(screenProperty, reason, targetRotation);
      let tmpWidth: ScbNumber = new ScbNumber(20);
      let tmpHeight: ScbNumber = new ScbNumber(30);
      expect(containerSession.currentRotation).assertEqual(90);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateRecentAndContainerInfoWithFoldTest04', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let targetRotation = 0;
      let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.EXPAND_TO_FOLD;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.isFloat = true;
      containerSession.updateRecentAndContainerInfoWithFold(screenProperty, reason, targetRotation);
      let tmpWidth: ScbNumber = new ScbNumber(20);
      let tmpHeight: ScbNumber = new ScbNumber(30);
      expect(containerSession.currentRotation).assertEqual(90);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateRecentAndContainerInfoWithFoldTest05', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let targetRotation = 0;
      let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.UNDEFINED;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.isFloat = true;
      containerSession.updateRecentAndContainerInfoWithFold(screenProperty, reason, targetRotation);
      let tmpWidth: ScbNumber = new ScbNumber(20);
      let tmpHeight: ScbNumber = new ScbNumber(30);
      expect(containerSession.currentRotation).assertEqual(90);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateRecentAndContainerInfoWithFoldTest06', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let targetRotation = 90;
      let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.FOLD_LANDSCAPE_START;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.isFloat = true;
      containerSession.updateRecentAndContainerInfoWithFold(screenProperty, reason, targetRotation);
      let tmpWidth: ScbNumber = new ScbNumber(20);
      let tmpHeight: ScbNumber = new ScbNumber(30);
      expect(containerSession.currentRotation).assertEqual(90);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateRecentAndContainerInfoWithFoldTest07', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let targetRotation = 180;
      let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.FOLD_LANDSCAPE_START;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.isFloat = true;
      containerSession.updateRecentAndContainerInfoWithFold(screenProperty, reason, targetRotation);
      let tmpWidth: ScbNumber = new ScbNumber(20);
      let tmpHeight: ScbNumber = new ScbNumber(30);
      expect(containerSession.currentRotation).assertEqual(180);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateRecentAndContainerInfoWithFoldTest08', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let targetRotation = 270;
      let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.FOLD_LANDSCAPE_START;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.isFloat = true;
      containerSession.updateRecentAndContainerInfoWithFold(screenProperty, reason, targetRotation);
      let tmpWidth: ScbNumber = new ScbNumber(20);
      let tmpHeight: ScbNumber = new ScbNumber(30);
      expect(containerSession.currentRotation).assertEqual(270);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateRecentAndContainerInfoWithFoldTest09', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let targetRotation = 360;
      let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.FOLD_LANDSCAPE_START;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.isFloat = true;
      containerSession.updateRecentAndContainerInfoWithFold(screenProperty, reason, targetRotation);
      let tmpWidth: ScbNumber = new ScbNumber(20);
      let tmpHeight: ScbNumber = new ScbNumber(30);
      expect(containerSession.currentRotation).assertEqual(360);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateRecentAndContainerInfoWithFoldTest10', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let targetRotation = 90;
      let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.EXPAND_TO_FOLD;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.isFloat = true;
      containerSession.updateRecentAndContainerInfoWithFold(screenProperty, reason, targetRotation);
      let tmpWidth: ScbNumber = new ScbNumber(20);
      let tmpHeight: ScbNumber = new ScbNumber(30);
      expect(containerSession.currentRotation).assertEqual(90);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateRecentAndContainerInfoWithFoldTest11', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let targetRotation = 180;
      let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.EXPAND_TO_FOLD;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.isFloat = true;
      containerSession.updateRecentAndContainerInfoWithFold(screenProperty, reason, targetRotation);
      let tmpWidth: ScbNumber = new ScbNumber(20);
      let tmpHeight: ScbNumber = new ScbNumber(30);
      expect(containerSession.currentRotation).assertEqual(90);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateRecentAndContainerInfoWithFoldTest12', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let targetRotation = 270;
      let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.EXPAND_TO_FOLD;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.isFloat = true;
      containerSession.updateRecentAndContainerInfoWithFold(screenProperty, reason, targetRotation);
      let tmpWidth: ScbNumber = new ScbNumber(20);
      let tmpHeight: ScbNumber = new ScbNumber(30);
      expect(containerSession.currentRotation).assertEqual(90);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('updateRecentAndContainerInfoWithFoldTest13', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let targetRotation = 360;
      let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.EXPAND_TO_FOLD;
      screenProperty.width = 20;
      screenProperty.height = 30;
      containerSession.isFloat = true;
      containerSession.updateRecentAndContainerInfoWithFold(screenProperty, reason, targetRotation);
      let tmpWidth: ScbNumber = new ScbNumber(20);
      let tmpHeight: ScbNumber = new ScbNumber(30);
      expect(containerSession.currentRotation).assertEqual(90);
      expect(containerSession.width.getPx()).assertEqual(tmpWidth.getPx());
      expect(containerSession.height.getPx()).assertEqual(tmpHeight.getPx());
    });

    it('registerUpdateSubWindowBindingCallbackTest', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let testCallback = () => {};
      containerSession.registerUpdateSubWindowBindingCallback(0, testCallback);
      let callback: Map<number, Function> = Reflect.get(containerSession, 'updateSubWindowBindingCallbacks');
      expect(callback.get(0)).assertEqual(testCallback);
    });

    it('unRegisterUpdateSubWindowBindingCallbackTest', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let testCallback = () => {};
      let screenId: number = 1;
      containerSession.registerUpdateSubWindowBindingCallback(screenId, testCallback);
      let callbackMap: Map<number, Function> = Reflect.get(containerSession, 'updateSubWindowBindingCallbacks');
      expect(callbackMap.get(screenId)).assertEqual(testCallback);
      containerSession.unRegisterUpdateSubWindowBindingCallback(screenId);
      let newCallbackMap: Map<number, Function> = Reflect.get(containerSession, 'updateSubWindowBindingCallbacks');
      expect(newCallbackMap.get(screenId)).assertUndefined()
    });

    it('updateSubWindowBindingTest', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let num: number = 0;
      let testCallback = () => {
        num ++;
      };
      containerSession.registerUpdateSubWindowBindingCallback(0, testCallback);
      containerSession.updateSubWindowBinding(0);
      expect(num).assertEqual(1);
      containerSession.updateSubWindowBinding(0);
      expect(num).assertEqual(2);
    });

    it('updateRequestOrientation_test', 0, () => {
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let orientation = containerSession.getContainerRequestOrientation();
      containerSession.updateRequestOrientation();
      expect(containerSession.requestOrientation).assertEqual(orientation);
    });
  })

  describe('SCBSceneContainerSessionTest_findItemByPersistentId', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo),
      sceneInfo);
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let containerSessionArray = new SCBSceneContainerSessionArray();
    let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);

    it('test_whenPersistentIdIsInvalid_thenFindFailed', Level.LEVEL0, () => {
      containerSessionArray.push(containerSession);
      const res = containerSessionArray.findItemByPersistentId(-1);
      expect(res).assertEqual(null);
    });

    it('test_whenPersistentIdIsExisted_thenFindSuccess', Level.LEVEL0, () => {
      const res = containerSessionArray.findItemByPersistentId(sceneSession.sceneInfo?.persistentId);
      expect(res).assertDeepEquals(containerSession);
    });
  });
}
