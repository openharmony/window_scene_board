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
  SCBAppIconParam,
  PreBuildStage
} from '../../../../../../../..';
import { SceneParam, SCBDividerParam } from '../../../../../../../main/ets/TsIndex';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { ReflectionUtils } from './ReflectionUtils';

import {
  ContainerDataCategory,
  ContainerStateCategory,
  ContainerDataOfMissionManagement,
  ContainerStateOfBasic
} from '../../../../../../../main/ets/scene/SceneModuleIndex';
import { SCBSceneSessionArray } from '../../../../../../../main/ets/scene/session/SCBSceneContainerSession';

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

export function SCBSceneContainerSessionTest2() {

  describe('SCBSceneContainerSessionTest2', () => {
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

    it('haveSessionWithPersistentId', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      sceneInfo.persistentId = 123;
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      sceneContainerSession.addSceneSession(secSceneSession);

      let sceneInfo2: SCBSceneInfo = new SCBSceneInfo('testBundle2', 'testModule2', 'testAbility2');
      let sceneSession2: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo2), sceneInfo2);
      sceneContainerSession.midSceneMap.set(123, sceneSession2);
      expect(sceneContainerSession.haveSessionWithPersistentId(123)).assertTrue();
      expect(sceneContainerSession.haveSessionWithPersistentId(234)).assertFalse();
    });

    it('haveActiveSessionTest03', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      sceneSession.sessionData.setIsActive(true);
      let curSCBSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let sceneInfo1: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'haveActiveSessionTest03');
      let sceneSession1: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo1), sceneInfo1);
      sceneSession1.sessionData.setIsActive(false);
      curSCBSceneContainerSession.midSceneMap.set(1, sceneSession1);
      expect(curSCBSceneContainerSession.haveActiveSession()).assertTrue();
    });

    it('haveActiveSessionTest04', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let curSCBSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let sceneInfo2: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'haveActiveSessionTest04');
      let sceneSession2: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo2), sceneInfo2);
      sceneSession2.sessionData.setIsActive(true);
      curSCBSceneContainerSession.addSceneSession(sceneSession2);
      expect(curSCBSceneContainerSession.haveActiveSession()).assertTrue();
    });

    it('setNeedSyncSessionRect', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let curSCBSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let sceneInfo2: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'setNeedSyncSessionRect');
      let sceneSession2: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo2), sceneInfo2);
      curSCBSceneContainerSession.addSceneSession(sceneSession2);
      curSCBSceneContainerSession.setNeedSyncSessionRect(true);
      curSCBSceneContainerSession.removeSceneSession(sceneSession);
      curSCBSceneContainerSession.removeSceneSession(sceneSession2);
      curSCBSceneContainerSession.setNeedSyncSessionRect(true);
    });

    it('fixSecRectMinError', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);

      let sessionRect: SCBSessionRect = new SCBSessionRect();
      sessionRect.height = new ScbNumber(10);
      sessionRect.top = new ScbNumber(1);
      let screenProperty2: SCBScreenProperty = new SCBScreenProperty();
      screenProperty2.height = 2;
      ReflectionUtils.useFunc(sceneContainerSession, 'fixSecRectMinError', sessionRect, screenProperty2);

      sessionRect.height = new ScbNumber(1);
      ReflectionUtils.useFunc(sceneContainerSession, 'fixSecRectMinError', sessionRect, screenProperty2);
    });

    it('updateRectForSplit', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let sceneInfo2: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'haveActiveSessionTest04');
      let sceneSession2: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo2), sceneInfo2);
      sceneContainerSession.addSceneSession(sceneSession2);

      let screenProperty2: SCBScreenProperty = new SCBScreenProperty();
      screenProperty2.height = 2;
      ReflectionUtils.useFunc(sceneContainerSession, 'updateRectForSplit', screenProperty2);

      // this.dividerParam.isUpDownSplit() == true
      let mocker: MockKit = new MockKit();
      let scbDividerParam :SCBDividerParam = new SCBDividerParam();
      let mockFunc = mocker.mockFunc(scbDividerParam, scbDividerParam.isUpDownSplit);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      ReflectionUtils.useFunc(sceneContainerSession, 'updateRectForSplit', screenProperty2);
    });

    it('updateSessionRectForSplitDirectly', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);

      let sessionRect: SCBSessionRect = new SCBSessionRect();
      sessionRect.height = new ScbNumber(10);
      sessionRect.top = new ScbNumber(1);
      let sessionRect2: SCBSessionRect = new SCBSessionRect();
      sessionRect2.height = new ScbNumber(1);
      sessionRect2.top = new ScbNumber(1);
      let screenProperty2: SCBScreenProperty = new SCBScreenProperty();
      screenProperty2.height = 2;
      sceneContainerSession.updateSessionRectForSplitDirectly(screenProperty2, sessionRect, sessionRect2);
    });

    it('updateSizeChangeReason', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      // !persistentId && !this.isSplit
      sceneContainerSession.updateSizeChangeReason(null, null);
    });

    it('getBundleName', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let sceneInfo2: SCBSceneInfo = new SCBSceneInfo('getBundleName', 'testModule', 'getBundleName');
      let sceneSession2: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo2), sceneInfo2);
      sceneContainerSession.addSceneSession(sceneSession2);

      // this.primarySession this.secondarySession
      expect(sceneContainerSession.getBundleName()).assertEqual('testBundle,getBundleName');
      sceneContainerSession.removeSceneSession(sceneSession);
      sceneContainerSession.removeSceneSession(sceneSession2);
      expect(sceneContainerSession.getBundleName()).assertEqual('getBundleName');
    });

    it('getOneStepSplitType', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let sceneInfo2: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'getBundleName');
      let sceneSession2: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo2), sceneInfo2);
      sceneContainerSession.addSceneSession(sceneSession2);

      // !this.isOneStepSplit()
      expect(sceneContainerSession.getOneStepSplitType()).assertEqual(0);

      let mocker: MockKit = new MockKit();
      let mockFunc1 = mocker.mockFunc(sceneContainerSession, sceneContainerSession.isOneStepSplit);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      expect(sceneContainerSession.getOneStepSplitType()).assertEqual(1);
    });

    it('getSplitType', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let sceneInfo2: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'getBundleName');
      let sceneSession2: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo2), sceneInfo2);
      sceneContainerSession.addSceneSession(sceneSession2);

      // !this.isSplit
      expect(sceneContainerSession.getSplitType()).assertEqual(1);
      sceneContainerSession.isSplit = true;
      expect(sceneContainerSession.getSplitType()).assertEqual(2);
      sceneContainerSession.dividerParam.splitStyle = 0;
      expect(sceneContainerSession.getSplitType()).assertEqual(3);
    });

    it('isSplitPrimaryMode', 0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      sceneContainerSession.isSplitPrimaryMode();
    });

    it('isInRange', 0, () => {
      scbSceneContainerSessionArray.clear();
      expect(scbSceneContainerSessionArray.isInRange(1)).assertFalse();
      scbSceneContainerSessionArray.add(scbSceneContainerSession);
      expect(scbSceneContainerSessionArray.isInRange(0)).assertTrue();
    });

    it('findByContainerId', 0, () => {
      scbSceneContainerSessionArray.clear();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      expect(scbSceneContainerSessionArray.findByContainerId(0)).assertNull();
      scbSceneContainerSessionArray.add(scbSceneContainerSession);
      expect(scbSceneContainerSessionArray.findByContainerId(0)).assertNull();
    });

    it('getTopSession', 0, () => {
      scbSceneContainerSessionArray.clear();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      expect(scbSceneContainerSessionArray.getTopSession()).assertNull();
      scbSceneContainerSessionArray.add(scbSceneContainerSession);
      expect(scbSceneContainerSessionArray.getTopSession()).assertEqual(scbSceneContainerSession);
    });

    it('setVisibility', 0, () => {
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      scbSceneContainerSession.needRenderVisibility.setVisibility(true);
      expect(scbSceneContainerSession.needRenderVisibility.visibility).assertTrue()
      scbSceneContainerSession.needRenderVisibility.setVisibility(false);
      expect(scbSceneContainerSession.needRenderVisibility.visibility).assertFalse()
    });

    it('blurRadiusReset', 0, () => {
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      scbSceneContainerSession.needRenderBlurRadius.setBlurRadiusWithDfx(2, 'test', 'test', 'test');
      expect(scbSceneContainerSession.needRenderBlurRadius.blurRadius).assertEqual(2);
      scbSceneContainerSession.needRenderBlurRadius.reset();
      expect(scbSceneContainerSession.needRenderBlurRadius.blurRadius).assertEqual(-1);
    });

    it('setNeedRenderAlpha', 0, () => {
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      scbSceneContainerSession.needRenderAlpha.setNeedRenderAlpha(1);
      expect(scbSceneContainerSession.needRenderAlpha.sceneAlpha).assertEqual(1);
    });

    it('setBorderRadius', 0, () => {
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      scbSceneContainerSession.needRenderBorderRadius.setBorderRadius(1);
      expect(scbSceneContainerSession.needRenderBorderRadius.topLeft).assertEqual(1);
      expect(scbSceneContainerSession.needRenderBorderRadius.topRight).assertEqual(1);
      expect(scbSceneContainerSession.needRenderBorderRadius.bottomLeft).assertEqual(1);
      expect(scbSceneContainerSession.needRenderBorderRadius.bottomRight).assertEqual(1);
      scbSceneContainerSession.needRenderBorderRadius.setBorderRadius(1);
      expect(scbSceneContainerSession.needRenderBorderRadius.topLeft).assertEqual(1);
      expect(scbSceneContainerSession.needRenderBorderRadius.topRight).assertEqual(1);
      expect(scbSceneContainerSession.needRenderBorderRadius.bottomLeft).assertEqual(1);
      expect(scbSceneContainerSession.needRenderBorderRadius.bottomRight).assertEqual(1);
    });

    it('getDefaultBorderRadius', 0, () => {
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      scbSceneContainerSession.needRenderBorderRadius.setBorderRadius(1);
      expect(scbSceneContainerSession.needRenderBorderRadius.topLeft).assertEqual(1);
      expect(scbSceneContainerSession.needRenderBorderRadius.topRight).assertEqual(1);
      expect(scbSceneContainerSession.needRenderBorderRadius.getDefaultBorderRadius()).assertEqual(1);
      scbSceneContainerSession.needRenderBorderRadius.toString();
      expect(scbSceneContainerSession.needRenderBorderRadius.hasBorderRadius()).assertTrue();

    });

    it('setPosXTest', 0, () => {
      let needRenderPos: NeedRenderPos= new NeedRenderPos();
      needRenderPos.setPosX(1);
      expect(needRenderPos.posX).assertEqual(1);
      needRenderPos.setPosX(1);
      expect(needRenderPos.posX).assertEqual(1);
      needRenderPos.setPosX(0);
      expect(needRenderPos.posX).assertEqual(0);
    });

    it('setPosYTest', 0, () => {
      let needRenderPos: NeedRenderPos= new NeedRenderPos();
      needRenderPos.setPosY(1);
      expect(needRenderPos.posY).assertEqual(1);
      needRenderPos.setPosY(1);
      expect(needRenderPos.posY).assertEqual(1);
      needRenderPos.setPosY(0);
      expect(needRenderPos.posY).assertEqual(0);
    });

    it('setPosYTest', 0, () => {
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      scbSceneContainerSession.init();
      scbSceneContainerSession.needRenderRotate.setAngle(1);
      expect(scbSceneContainerSession.needRenderRotate.angle).assertEqual(1);

      scbSceneContainerSession.needRenderRotate.setAngle(1);
      expect(scbSceneContainerSession.needRenderRotate.angle).assertEqual(1);
      scbSceneContainerSession.needRenderRotate.setAngle(0);
      expect(scbSceneContainerSession.needRenderRotate.angle).assertEqual(0);
    });

    it('setScaleXTest', 0, () => {
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      scbSceneContainerSession.init();

      scbSceneContainerSession.needRenderScale.setScaleX(0);
      expect(scbSceneContainerSession.needRenderScale.scaleX).assertEqual(0);
      scbSceneContainerSession.needRenderScale.setScaleX(1);
      expect(scbSceneContainerSession.needRenderScale.scaleX).assertEqual(1);
      scbSceneContainerSession.needRenderScale.setScaleX(1);
      expect(scbSceneContainerSession.needRenderScale.scaleX).assertEqual(1);
    });

    it('setScaleYTest', 0, () => {
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      scbSceneContainerSession.init();

      scbSceneContainerSession.needRenderScale.setScaleY(0);
      expect(scbSceneContainerSession.needRenderScale.scaleY).assertEqual(0);
      scbSceneContainerSession.needRenderScale.setScaleY(1);
      expect(scbSceneContainerSession.needRenderScale.scaleY).assertEqual(1);
      scbSceneContainerSession.needRenderScale.setScaleY(1);
      expect(scbSceneContainerSession.needRenderScale.scaleY).assertEqual(1);
    });

    it('centerX&centerYTest', 0, () => {
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      scbSceneContainerSession.init();

      scbSceneContainerSession.needRenderScale.centerX = '60%';
      expect(scbSceneContainerSession.needRenderScale.centerX).assertEqual('60%');
      scbSceneContainerSession.needRenderScale.centerX = '50%';
      expect(scbSceneContainerSession.needRenderScale.centerX).assertEqual('50%');
      scbSceneContainerSession.needRenderScale.centerY = '50%';
      expect(scbSceneContainerSession.needRenderScale.centerY).assertEqual('50%');
    });

    it('setPreBuildStageWithDfx', 0, () => {
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      scbSceneContainerSession.init();

      let  preBuildStage = scbSceneContainerSession.needPreBuild.preBuildStage;
      scbSceneContainerSession.needPreBuild.setPreBuildStageWithDfx(preBuildStage);
      expect(scbSceneContainerSession.needPreBuild.preBuildStage).assertEqual(preBuildStage);
      scbSceneContainerSession.needPreBuild.setPreBuildStage(preBuildStage);
      expect(scbSceneContainerSession.needPreBuild.preBuildStage).assertEqual(preBuildStage);
      scbSceneContainerSession.needPreBuild.setPreBuildStage(PreBuildStage.PRE_BUILD_SCENE);
      expect(scbSceneContainerSession.needPreBuild.preBuildStage).assertEqual(PreBuildStage.PRE_BUILD_SCENE);
      scbSceneContainerSession.needPreBuild.setPreBuildStage(preBuildStage);
      expect(scbSceneContainerSession.needPreBuild.preBuildStage).assertEqual(preBuildStage);
    });

    it('setTitleViewAlpha', 0, () => {
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      scbSceneContainerSession.init();

      scbSceneContainerSession.needRenderTitleViewAlpha.setTitleViewAlpha(0);
      expect(scbSceneContainerSession.needRenderTitleViewAlpha.titleViewAlpha).assertEqual(0);
      scbSceneContainerSession.needRenderTitleViewAlpha.setTitleViewAlpha(1);
      expect(scbSceneContainerSession.needRenderTitleViewAlpha.titleViewAlpha).assertEqual(1);
      scbSceneContainerSession.needRenderTitleViewAlpha.setTitleViewAlpha(0);
      expect(scbSceneContainerSession.needRenderTitleViewAlpha.titleViewAlpha).assertEqual(0);
    });

    it('setShowRecentTitle', 0, () => {
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      scbSceneContainerSession.init();

      scbSceneContainerSession.needRenderShowRecentTitle.setShowRecentTitle(false);
      expect(scbSceneContainerSession.needRenderShowRecentTitle.showRecentTitle).assertFalse();
      scbSceneContainerSession.needRenderShowRecentTitle.setShowRecentTitle(true);
      expect(scbSceneContainerSession.needRenderShowRecentTitle.showRecentTitle).assertTrue();
      scbSceneContainerSession.needRenderShowRecentTitle.setShowRecentTitle(false);
      expect(scbSceneContainerSession.needRenderShowRecentTitle.showRecentTitle).assertFalse();
    });

    it('isShowWhenLocked', 0, () => {
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      scbSceneContainerSession.init();

      scbSceneContainerSession.isMidScene = true;
      scbSceneContainerSession.isSplit = false;
      scbSceneContainerSession.primarySession = sceneSession;
      expect(scbSceneContainerSession.isShowWhenLocked()).assertFalse();
      scbSceneContainerSession.isMidScene = false;
      expect(scbSceneContainerSession.isShowWhenLocked()).assertFalse();
    });

    it('isMainWindowTopmost', 0, () => {
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      scbSceneContainerSession.init();
      let sceneSession1: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

      scbSceneContainerSession.primarySession = sceneSession1;
      scbSceneContainerSession.primarySession.isMainWindowTopmost = false;
      expect(scbSceneContainerSession.isShowWhenLocked()).assertFalse();
      scbSceneContainerSession.primarySession.isMainWindowTopmost = true;

      scbSceneContainerSession.primarySession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FLOATING);
      expect(scbSceneContainerSession.isShowWhenLocked()).assertFalse();
    });

    it('updateCompanionIconInfo', 0, () => {
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      scbSceneContainerSession.init();
      scbSceneContainerSession.updateCompanionIconInfo(scbSceneContainerSession.transitionController);
    });

    it('removeSceneSessionFromMidSceneTest', 0, () => {
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sceneSession01: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sceneSession02: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let sCBAppIconParam: SCBAppIconParam = new SCBAppIconParam(() => {return sceneSession});

      containerSession.midAppIconParamMap.set(sceneSession.session.persistentId, sCBAppIconParam);
      containerSession.removeSceneSessionFromMidScene(null, true);
      containerSession.midAppIconParamMap.set(sceneSession.session.persistentId, sCBAppIconParam);
      containerSession.removeSceneSessionFromMidScene(sceneSession, true);
      containerSession.secondarySession = sceneSession;
      containerSession.removeSceneSessionFromMidScene(sceneSession02, true);
      containerSession.midAppIconParamMap.set(sceneSession.session.persistentId, sCBAppIconParam);
      containerSession.removeSceneSessionFromMidScene(sceneSession01, true);
    });
  });

  describe('SCBSceneContainerSession_RegisterDataAndState_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let containerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

    it('test_whenSceneContainerSessionCreateRegisterData_thenSuccess', 0, () => {
      containerSession.registerData(new ContainerDataOfMissionManagement());
      let mmData: ContainerDataOfMissionManagement =
        containerSession.getData(ContainerDataCategory.MISSION_MANAGEMENT) as ContainerDataOfMissionManagement;
      expect(mmData.isTerminating).assertFalse();
      expect(mmData.pendingRemove).assertFalse();
    });

    it('test_whenSceneContainerSessionCreateRegisterState_thenSuccess', 0, () => {
      containerSession.registerState(new ContainerStateOfBasic());
      let basicState: ContainerStateOfBasic =
        containerSession.getContainerState(ContainerStateCategory.BASIC) as ContainerStateOfBasic;
      let testNumber = new ScbNumber();

      expect(basicState.width).assertEqual(testNumber);
      expect(basicState.height).assertEqual(testNumber);
    });
  });

  describe('SCBSceneContainerSession_getSceneSessionWithoutAbilityName_testSuite', () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let containerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
    let containerSessionArray: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
    containerSessionArray.push(containerSession)

    it('test_whenPrimaryIsTargetSession_thenSuccess', 0, () => {
      let ret: SCBSceneSessionArray = containerSessionArray.getSceneSessionWithoutAbilityName(sceneInfo);

      expect(ret.length).assertEqual(1);
    });
  });
}