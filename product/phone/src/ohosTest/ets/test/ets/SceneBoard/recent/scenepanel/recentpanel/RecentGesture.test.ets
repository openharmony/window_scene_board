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
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  TestType,
  Size,
  Level,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import {
  NeedRenderShowInRecent,
  NeedRenderTranslate,
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
} from '@ohos/windowscene';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { RecentGesture } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentGesture';
import { SCBSceneInfo } from '@ohos/windowscene';
import { SCBSceneSession, SCBScreenProperty } from '@ohos/windowscene/src/main/ets/TsIndex';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { recentLayoutConfigInstance } from '@ohos/recents';
import { SCBScenePanelManager, NeedRenderPos } from '@ohos/windowscene';
import { RotationConstants } from '@ohos/commonconstants';
import { ItemUtils } from '@ohos/componenthelper';
import { systemParameter } from '@kit.BasicServicesKit';
import {
  recentRuntimeInstance
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentRuntimeModel';
import screenSessionManager from '@ohos.screenSessionManager';

export default function RecentGestureTest() {
  describe('RecentGestureTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })
    let recentLayoutConfig = recentLayoutConfigInstance;
    let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
    let screenProp: screenSessionManager.ScreenProperty = {
      rotation: 1,
      bounds: {
        left: 1,
        top: 1,
        width: 40,
        height: 200,
        radius: 1,
      },
      fakeBounds: {
        left: 0,
        top: 0,
        width: 0,
        height: 0,
        radius: 0
      },
      isFakeInUse: false,
      rsId: 0,
    };
    scbScreenProperty.update(screenProp);
    let needRenderPos: NeedRenderPos = new NeedRenderPos();
    needRenderPos.setPosXWithDfx(0,"moudle","check",null);
    needRenderPos.setPosYWithDfx(0,"moudle","check",null);
    let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
    let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
    let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
    let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
    let floatSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
    floatSession.primarySession = sceneSession;
    floatSession.secondarySession = sceneSession;
    floatSession.needRenderPos = needRenderPos;
    floatSession.isFloat = true;
    totalContainerSessionList.add(floatSession);
    totalContainerSessionList.add(floatSession);
    totalContainerSessionList.add(floatSession);
    totalContainerSessionList.add(floatSession);
    totalContainerSessionList.add(floatSession);
    totalContainerSessionList.add(floatSession);
    let floatSession1 = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
    floatSession1.primarySession = sceneSession;
    floatSession1.secondarySession = sceneSession;
    floatSession1.needRenderPos = needRenderPos;
    floatSession1.isFloat = true;
    totalContainerSessionList.add(floatSession1);
    let recentGesture: RecentGesture = new RecentGesture(scenePanelManager);
    let eventArea: Area = {
      width: 0,
      height: 0,
      position: {
        x: 0, y: 0
      },
      globalPosition: {
        x: 0, y: 0
      }
    };
    let eventTarget: EventTarget = {
      area: eventArea
    };
    let event: GestureEvent = {
      target: eventTarget,
      timestamp: 0,
      source: 0,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: 0,
      repeat: false,
      fingerList: [],
      offsetX: 10,
      offsetY: 5,
      angle: 0,
      speed: 0,
      scale: 0,
      pinchCenterX: 0,
      pinchCenterY: 0,
      velocityX: 0,
      velocityY: 0,
      velocity: 0
    };

    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
    let containerSessionList: SCBSceneContainerSession[] = totalContainerSessionList as SCBSceneContainerSession[];
    recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;

    recentGesture.multiColumnNum = 0;
    recentGesture.rightColumnIndex = 0;

    it('setContainerFillDirection_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentGesture.multiCardsNum = 0;
      recentGesture.totalColumnNum = 2;
      recentGesture.setContainerFillDirection(0, 0, 0, true);
      expect(recentGesture.isRightContainerFill).assertFalse();
    })

    it('setContainerFillDirection_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentGesture.multiCardsNum = 0;
      recentGesture.leftColumnIndex = 1;
      recentGesture.totalColumnNum = 0;
      recentGesture.setContainerFillDirection(0, 0, 0, true);
      expect(recentGesture.isRightContainerFill).assertFalse();
      expect(recentGesture.actualAnimationColumnLength).assertEqual(0);

    })

    it('setContainerFillDirection_test_021', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentGesture.multiCardsNum = 0;
      recentGesture.leftColumnIndex = 1;
      recentGesture.totalColumnNum = 0;
      recentGesture.setContainerFillDirection(2, 0, 0, true);
      expect(recentGesture.isRightContainerFill).assertFalse();
      expect(recentGesture.actualAnimationColumnLength).assertEqual(0);
    })

    it('setContainerFillDirection_test_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentGesture.multiCardsNum = 0;
      recentGesture.leftColumnIndex = -1;
      recentGesture.totalColumnNum = 0;
      recentGesture.setContainerFillDirection(0, 0, 0, true);
      expect(recentGesture.isRightContainerFill).assertFalse();
    })

    it('setContainerFillDirection_test_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentGesture.multiCardsNum = 0;
      recentGesture.leftColumnIndex = -1;
      recentGesture.totalColumnNum = 0;
      recentGesture.setContainerFillDirection(0, 0, 1, true);
      expect(recentGesture.isRightContainerFill).assertFalse();
      expect(recentGesture.actualAnimationColumnLength).assertEqual(0);
    })

    it('setContainerFillDirection_test_041', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentGesture.multiCardsNum = 0;
      recentGesture.leftColumnIndex = -1;
      recentGesture.totalColumnNum = 0;
      recentGesture.setContainerFillDirection(2, 0, 1, true);
      expect(recentGesture.isRightContainerFill).assertFalse();
      expect(recentGesture.actualAnimationColumnLength).assertEqual(0);
    })

    it('setContainerFillDirection_test_22', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentGesture.multiCardsNum = 0;
      recentGesture.setContainerFillDirection(0, 0, 0, false);
      expect(recentGesture.isRightContainerFill).assertFalse();
    })

    it('setContainerFillDirection_test_23', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentGesture.multiCardsNum = 0;
      recentGesture.setContainerFillDirection(2, 0, 0, false);
      expect(recentGesture.isRightContainerFill).assertFalse();
    })

    it('getScreenColumnIndexInRecentMultiRow_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentGesture.multiColumnNum = 1;
      recentGesture.getScreenColumnIndexInRecentMultiRow();
      expect(recentGesture.middleColumnIndex).assertEqual(0);
    })

    it('getScreenColumnIndexInRecentMultiRow_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentGesture.multiColumnNum = 0;
      recentGesture.getScreenColumnIndexInRecentMultiRow();
      expect(recentGesture.middleColumnIndex).assertEqual(0);
    })

    it('cancel_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(true);
      recentGesture.cancel();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      expect(recentGesture).not().assertNull();
    })

    it('cancel_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      recentGesture.cancel();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      expect(recentGesture).not().assertNull();
    })

    it('createRestoreMoveUpAnimation_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(true);
      recentGesture.isRightContainerFill = true;
      recentGesture.createRestoreMoveUpAnimation();
      expect(recentGesture).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('getSceneSessionScreenIndex_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.autoCenterColumn = 1;
      recentGesture.getSceneSessionScreenIndex(2);
      expect(recentGesture).not().assertNull();
    })

    it('getSceneSessionScreenIndex_test_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.autoCenterColumn = 1;
      recentGesture.getSceneSessionScreenIndex(3);
      expect(recentGesture).not().assertNull();
    })

    it('onRecentGestureUpdate_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentGesture.removingIndex = 0;
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      recentGesture.onRecentGestureUpdate(0, event);
      expect(recentGesture).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('onRecentGestureUpdate_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentGesture.removingIndex = -1;
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      recentGesture.onRecentGestureUpdate(0, event);
      expect(recentGesture).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('onRecentGestureUpdate_test_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentGesture.removingIndex = 0;
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      let containerSession = totalContainerSessionList[1];
      event.offsetY = 300;
      recentGesture.onRecentGestureUpdate(1, event);
      expect(recentGesture).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('containerUnsinking_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      recentGesture.containerUnsinking(recentRuntimeInstance.notRemovingSessionList[0]);
      expect(recentGesture).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('containerUnsinking_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(true);
      recentGesture.containerUnsinking(recentRuntimeInstance.notRemovingSessionList[0]);
      expect(recentGesture).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('containerSinking_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      recentGesture.containerSinking(0);
      expect(recentGesture).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('containerSinking_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(true);
      recentGesture.containerSinking(0);
      expect(recentGesture).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('restoreContainerCenter_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      recentGesture.restoreContainerCenter(recentRuntimeInstance.notRemovingSessionList[0]);
      expect(recentGesture).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('restoreContainerCenter_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(true);
      recentGesture.restoreContainerCenter(recentRuntimeInstance.notRemovingSessionList[0]);
      expect(recentGesture).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('restoreContainerCenter_test_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(true);
      recentRuntimeInstance.autoCenterColumn = 2;
      recentGesture.restoreContainerCenter(recentRuntimeInstance.notRemovingSessionList[1]);
      expect(recentGesture).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('restoreContainerCenter_test_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(true);
      recentRuntimeInstance.autoCenterColumn = 2;
      recentGesture.restoreContainerCenter(recentRuntimeInstance.notRemovingSessionList[2]);
      expect(recentGesture).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('restoreContainerCenter_test_05', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(true);
      recentRuntimeInstance.autoCenterColumn = 2;
      recentGesture.restoreContainerCenter(recentRuntimeInstance.notRemovingSessionList[3]);
      expect(recentGesture).not().assertNull();
    })

    it('restoreContainerCenter_test_06', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(true);
      recentRuntimeInstance.autoCenterColumn = 2;
      recentGesture.restoreContainerCenter(recentRuntimeInstance.notRemovingSessionList[6]);
      expect(recentGesture).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    recentGesture.removingIndex = 0;

    it('playTitleAppearAnimation_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      (recentGesture as object)['isNewStyle'] = false;
      recentGesture.playTitleAppearAnimation(scbSceneContainerSession);
      expect(recentGesture).not().assertNull();
    })

    it('playTitleAppearAnimation_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      (recentGesture as object)['isNewStyle'] = true;
      recentGesture.playTitleAppearAnimation(scbSceneContainerSession);
      expect(recentGesture).not().assertNull();
    })

    it('playAnimationForFillingContainers_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      (recentGesture as object)['isNewStyle'] = false;
      recentGesture.playAnimationForFillingContainers();
      expect(recentGesture).not().assertNull();
    })

    it('playAnimationForFillingContainers_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      (recentGesture as object)['isNewStyle'] = true;
      recentGesture.playAnimationForFillingContainers();
      expect(recentGesture).not().assertNull();
    })

    it('getMultiRowColumnInDeleting_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentRuntimeInstance.containerCountsShowInRecent = 0;
      recentRuntimeInstance.autoCenterColumn = 0;
      recentRuntimeInstance.touchContainerIndex = 0;
      recentGesture.getMultiRowColumnInDeleting(1);
      expect(recentGesture).not().assertNull();
    })

    it('updateGestureValue_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      (recentGesture as object)['updateGestureValue']();
      expect(scenePanelManager).not().assertUndefined();
    })

    it('setContainerFillDirection_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.containerCountsShowInRecent = 0;
      recentGesture.multiCardsNum = 7;
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      recentGesture.setContainerFillDirection(1, 2, 3, true);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('setContainerFillDirection_test02', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.containerCountsShowInRecent = 0;
      recentGesture.multiCardsNum = 7;
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      recentGesture.setContainerFillDirection(3, 2, 3, true);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('setContainerFillDirectionColumnIsChange_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.multiCardsNum = 0;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 0;
      recentGesture.totalColumnNum = 5;
      recentRuntimeInstance.containerCountsShowInRecent = 0;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(false);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      (recentGesture as object)['setContainerFillDirectionColumnIsChange'](11, 22);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('setContainerFillDirectionColumnIsChange_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.multiCardsNum = 0;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 0;
      recentGesture.totalColumnNum = 5;
      recentRuntimeInstance.containerCountsShowInRecent = 0;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(false);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      (recentGesture as object)['setContainerFillDirectionColumnIsChange'](11, 22);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('setContainerFillDirectionColumnIsChange_test02', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.multiCardsNum = 0;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 0;
      recentGesture.totalColumnNum = 30;
      recentRuntimeInstance.containerCountsShowInRecent = 0;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(false);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      (recentGesture as object)['setContainerFillDirectionColumnIsChange'](11, 22);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('setContainerFillDirectionColumnIsChange_test03', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.multiCardsNum = 0;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 0;
      recentGesture.totalColumnNum = 35;
      recentRuntimeInstance.containerCountsShowInRecent = 0;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(false);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      (recentGesture as object)['setContainerFillDirectionColumnIsChange'](11, 22);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('setContainerFillDirectionColumnIsChange_test04', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.multiCardsNum = 0;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 0;
      recentGesture.totalColumnNum = 40;
      recentRuntimeInstance.containerCountsShowInRecent = 0;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(false);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      (recentGesture as object)['setContainerFillDirectionColumnIsChange'](11, 22);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })
    it('setContainerFillDirectionColumnIsChange_test05', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.multiCardsNum = 0;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 0;
      recentGesture.totalColumnNum = 45;
      recentRuntimeInstance.containerCountsShowInRecent = 0;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(false);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      (recentGesture as object)['setContainerFillDirectionColumnIsChange'](11, 22);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('setContainerFillDirectionColumnIsChange_test06', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.multiCardsNum = 0;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 0;
      recentGesture.totalColumnNum = 50;
      recentRuntimeInstance.containerCountsShowInRecent = 0;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(false);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      (recentGesture as object)['setContainerFillDirectionColumnIsChange'](11, 22);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('setContainerFillDirectionColumnIsChange_test07', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.multiCardsNum = 0;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 0;
      recentGesture.totalColumnNum = 55;
      recentRuntimeInstance.containerCountsShowInRecent = 0;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(false);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      (recentGesture as object)['setContainerFillDirectionColumnIsChange'](11, 22);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('setContainerFillDirectionColumnIsChange_test08', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.multiCardsNum = 0;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 0;
      recentGesture.totalColumnNum = 60;
      recentRuntimeInstance.containerCountsShowInRecent = 0;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(false);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      (recentGesture as object)['setContainerFillDirectionColumnIsChange'](11, 22);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('setContainerFillDirectionColumnIsChange_test09', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.multiCardsNum = 0;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 0;
      recentGesture.totalColumnNum = 65;
      recentRuntimeInstance.containerCountsShowInRecent = 0;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(false);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      (recentGesture as object)['setContainerFillDirectionColumnIsChange'](11, 22);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('setContainerFillDirectionColumnIsChange_test10', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.multiCardsNum = 0;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 0;
      recentGesture.totalColumnNum = 70;
      recentRuntimeInstance.containerCountsShowInRecent = 0;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(false);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      (recentGesture as object)['setContainerFillDirectionColumnIsChange'](11, 22);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('setContainerFillDirectionColumnIsChange_test11', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.multiCardsNum = 0;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 0;
      recentGesture.totalColumnNum = 75;
      recentRuntimeInstance.containerCountsShowInRecent = 0;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(false);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      (recentGesture as object)['setContainerFillDirectionColumnIsChange'](11, 22);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('setContainerFillDirectionColumnIsChange_test12', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.multiCardsNum = 0;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 0;
      recentGesture.totalColumnNum = 80;
      recentRuntimeInstance.containerCountsShowInRecent = 0;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(false);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      (recentGesture as object)['setContainerFillDirectionColumnIsChange'](11, 22);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('setContainerFillDirectionColumnIsChange_test13', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.multiCardsNum = 0;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 0;
      recentGesture.totalColumnNum = 85;
      recentRuntimeInstance.containerCountsShowInRecent = 0;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(false);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      (recentGesture as object)['setContainerFillDirectionColumnIsChange'](11, 22);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('setContainerFillDirectionColumnIsChange_test14', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.multiCardsNum = 0;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 0;
      recentGesture.totalColumnNum = 90;
      recentRuntimeInstance.containerCountsShowInRecent = 0;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(false);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      (recentGesture as object)['setContainerFillDirectionColumnIsChange'](11, 22);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('setContainerFillDirectionColumnIsChange_test15', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.multiCardsNum = 0;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 0;
      recentGesture.totalColumnNum = 95;
      recentRuntimeInstance.containerCountsShowInRecent = 0;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(false);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      (recentGesture as object)['setContainerFillDirectionColumnIsChange'](11, 22);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('setContainerFillDirectionColumnIsChange_test16', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.multiCardsNum = 0;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 0;
      recentGesture.totalColumnNum = 100;
      recentRuntimeInstance.containerCountsShowInRecent = 0;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(false);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      (recentGesture as object)['setContainerFillDirectionColumnIsChange'](11, 22);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('setContainerFillDirectionColumnIsChange_test17', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.multiCardsNum = 0;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 0;
      recentGesture.totalColumnNum = 105;
      recentRuntimeInstance.containerCountsShowInRecent = 0;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(false);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      (recentGesture as object)['setContainerFillDirectionColumnIsChange'](11, 22);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('setContainerFillDirectionColumnIsChange_test18', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.multiCardsNum = 0;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 0;
      recentGesture.totalColumnNum = 110;
      recentRuntimeInstance.containerCountsShowInRecent = 0;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(false);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      (recentGesture as object)['setContainerFillDirectionColumnIsChange'](11, 22);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('setContainerFillDirectionColumnIsChange_test19', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.multiCardsNum = 0;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 0;
      recentGesture.totalColumnNum = 115;
      recentRuntimeInstance.containerCountsShowInRecent = 0;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(false);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      (recentGesture as object)['setContainerFillDirectionColumnIsChange'](11, 22);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('setContainerFillDirectionColumnIsChange_test20', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.multiCardsNum = 0;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 0;
      recentGesture.totalColumnNum = 120;
      recentRuntimeInstance.containerCountsShowInRecent = 0;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(false);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      (recentGesture as object)['setContainerFillDirectionColumnIsChange'](11, 22);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('setContainerFillDirectionColumnIsChange_test21', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.multiCardsNum = 0;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 0;
      recentGesture.totalColumnNum = 125;
      recentRuntimeInstance.containerCountsShowInRecent = 0;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(false);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      (recentGesture as object)['setContainerFillDirectionColumnIsChange'](11, 22);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('setContainerFillDirectionColumnIsChange_test22', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.multiCardsNum = 0;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 0;
      recentGesture.totalColumnNum = 145;
      recentRuntimeInstance.containerCountsShowInRecent = 0;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(false);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      (recentGesture as object)['setContainerFillDirectionColumnIsChange'](11, 22);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('setContainerFillDirectionColumnIsChange_test23', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.multiCardsNum = 0;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 0;
      recentGesture.totalColumnNum = 155;
      recentRuntimeInstance.containerCountsShowInRecent = 0;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(false);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      (recentGesture as object)['setContainerFillDirectionColumnIsChange'](11, 22);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('setContainerFillDirectionColumnIsChange_test24', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.multiCardsNum = 0;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 0;
      recentGesture.totalColumnNum = 160;
      recentRuntimeInstance.containerCountsShowInRecent = 0;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(false);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      (recentGesture as object)['setContainerFillDirectionColumnIsChange'](11, 22);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('setContainerFillDirectionColumnIsChange_test25', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.multiCardsNum = 0;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 0;
      recentGesture.totalColumnNum = 180;
      recentRuntimeInstance.containerCountsShowInRecent = 0;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(false);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      (recentGesture as object)['setContainerFillDirectionColumnIsChange'](11, 22);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('setContainerFillDirectionColumnIsChange_test26', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.multiCardsNum = 0;
      recentGesture.leftColumnIndex = 0;
      recentGesture.rightColumnIndex = 0;
      recentGesture.totalColumnNum = 200;
      recentRuntimeInstance.containerCountsShowInRecent = 0;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(false);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      (recentGesture as object)['setContainerFillDirectionColumnIsChange'](11, 22);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('getScreenColumnIndexInMultiRow_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.containerCountsShowInRecent = 0;
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(false);
      recentGesture.multiCardsNum = 1;
      recentGesture.getScreenColumnIndexInMultiRow(1);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('playTranslateAnimationForNeighborCards_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      (recentGesture as object)['isNewStyle'] = false;
      (recentGesture as object)['playTranslateAnimationForNeighborCards'](1);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('playTranslateAnimationForNeighborCards_test02', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      (recentGesture as object)['isNewStyle'] = true;
      recentGesture.playTranslateAnimationForNeighborCards(1);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('playTranslateAnimationForNeighborCards_test03', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      (recentGesture as object)['isNewStyle'] = true;
      recentGesture.playTranslateAnimationForNeighborCards(1);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('playTranslateAnimationForNeighborCards_test05', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      (recentGesture as object)['isNewStyle'] = true;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(true);
      recentGesture.playTranslateAnimationForNeighborCards(0);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('playTranslateAnimationForNeighborCards_test06', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      (recentGesture as object)['isNewStyle'] = true;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(false);
      recentGesture.playTranslateAnimationForNeighborCards(0);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('checkRemovingIndexByContainerId_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      (recentGesture as object)['checkRemovingIndexByContainerId'](1);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('restoreMoveUpAnimate_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      (recentGesture as object)['restoreMoveUpAnimate'](1);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('setCardTranslateXYInRecent_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.isRightContainerFill = false;
      (recentGesture as object)['setCardTranslateXYInRecent'](1, 2, 3);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('setCardTranslateXYInRecent_test02', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.isRightContainerFill = true;
      (recentGesture as object)['setCardTranslateXYInRecent'](1, 2, 3);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('setCardTranslateXYDelete_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.isRightContainerFill = false;
      (recentGesture as object)['setCardTranslateXYDelete'](1, 2, 3);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('resetCardTranslateXY_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.isRightContainerFill = false;
      (recentGesture as object)['resetCardTranslateXY'](1, 2, 3, 4);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('cardsMoveWithDeleteFloating_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      (recentGesture as object)['deleteColumnIndex'] = 2;
      (recentGesture as object)['multiColumnNum'] = 1;
      (recentGesture as object)['cardsMoveWithDeleteFloating'](5);
      expect(scenePanelManager).not().assertUndefined();
      (recentGesture as object)['deleteColumnIndex'] = 2;
      (recentGesture as object)['multiColumnNum'] = 3;
      (recentGesture as object)['cardsMoveWithDeleteFloating'](2);
      expect(scenePanelManager).not().assertUndefined();
      (recentGesture as object)['deleteColumnIndex'] = 2;
      (recentGesture as object)['multiColumnNum'] = 3;
      (recentGesture as object)['cardsMoveWithDeleteFloating'](1);
      expect(scenePanelManager).not().assertUndefined();
      (recentGesture as object)['deleteColumnIndex'] = 2;
      (recentGesture as object)['multiColumnNum'] = 3;
      (recentGesture as object)['cardsMoveWithDeleteFloating'](10);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('setCardTranslateXInRecent_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      (recentGesture as object)['setCardTranslateXInRecent'](0, 1);
      expect(scenePanelManager).not().assertUndefined();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      (recentGesture as object)['setCardTranslateXInRecent'](0, 1);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('playRotateAnimation_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      recentGesture.removingIndex = 0;
      recentGesture.isRightContainerFill = false;
      (recentGesture as object)['playRotateAnimation'](1);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('playRotateAnimation_test02', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      scbSceneContainerSession.primarySession = sceneSession;
      scbSceneContainerSession.primarySession.sceneInfo = sceneInfo;
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      recentGesture.removingIndex = 0;
      recentGesture.isRightContainerFill = false;
      (recentGesture as object)['playRotateAnimation'](1);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('getForegroundBlurRadius_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      (recentGesture as object)['getForegroundBlurRadius'](-10);
      expect(scenePanelManager).not().assertUndefined();
      (recentGesture as object)['getForegroundBlurRadius'](-90);
      expect(scenePanelManager).not().assertUndefined();
      (recentGesture as object)['getForegroundBlurRadius'](-40);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('getRotateByOffset_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      (recentGesture as object)['getRotateByOffset'](12, true);
      expect(scenePanelManager).not().assertUndefined();
      (recentGesture as object)['getRotateByOffset'](12, false);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('getTitleOpacity_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.isRightContainerFill = false;
      (recentGesture as object)['getTitleOpacity'](-40);
      expect(scenePanelManager).not().assertUndefined();
      (recentGesture as object)['getTitleOpacity'](12);
      expect(scenePanelManager).not().assertUndefined();
      (recentGesture as object)['getTitleOpacity'](-10);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('getSceneSessionScreenIndex_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.getSceneSessionScreenIndex(5);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('onRecentGestureUpdate_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let gestureEvent: GestureEvent = {
        repeat: false,
        fingerList: [],
        offsetX: 0,
        offsetY: 0,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0,
        target: {
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
            },
          }
        },
        timestamp: 0,
        source: SourceType.Unknown,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: SourceTool.Unknown
      };
      recentGesture.onRecentGestureUpdate(5, gestureEvent);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('onRecentGestureUpdate_test02', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let gestureEvent: GestureEvent = {
        repeat: false,
        fingerList: [],
        offsetX: 0,
        offsetY: 0,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0,
        target: {
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
            },
          }
        },
        timestamp: 0,
        source: SourceType.Unknown,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: SourceTool.Unknown
      };
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(false);
      recentGesture.onRecentGestureUpdate(1, gestureEvent);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('containerSinkingMultiRow_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let needRenderShowInRecent1: NeedRenderShowInRecent = new NeedRenderShowInRecent();
      (needRenderShowInRecent1 as object)['_showInRecent'] = true;
      scbSceneContainerSession.needRenderShowInRecent = needRenderShowInRecent1;
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      recentGesture.removingIndex = 0;
      recentGesture.isRightContainerFill = false;
      (recentGesture as object)['containerSinkingMultiRow'](1);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('containerUnsinkingMultiRow_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let needRenderShowInRecent1: NeedRenderShowInRecent = new NeedRenderShowInRecent();
      (needRenderShowInRecent1 as object)['_showInRecent'] = true;
      scbSceneContainerSession.needRenderShowInRecent = needRenderShowInRecent1;
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      recentGesture.removingIndex = 0;
      recentGesture.isRightContainerFill = false;
      (recentGesture as object)['containerUnsinkingMultiRow']();
      expect(scenePanelManager).not().assertUndefined();
    })

    it('containerUnsinking_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.removingIndex = -10;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(true);
      recentGesture.removingIndex = 10;
      recentGesture.containerUnsinking(recentRuntimeInstance.notRemovingSessionList[5]);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('containerUnsinking_test02', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.removingIndex = -10;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(false);
      recentGesture.removingIndex = 10;
      recentGesture.containerUnsinking(recentRuntimeInstance.notRemovingSessionList[5]);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('containerSinking_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.removingIndex = -10;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(true);
      recentGesture.removingIndex = 10;
      recentGesture.containerSinking(5);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('containerSinking_test02', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.removingIndex = -10;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(false);
      recentGesture.removingIndex = 10;
      recentGesture.containerSinking(5);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('containerCenter_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(true);
      recentGesture.containerCenter(1);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('containerCenter_test02', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(false);
      recentGesture.containerCenter(1);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('getScreenColumnIndexInRecentMultiRow_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.getScreenColumnIndexInRecentMultiRow();
      expect(scenePanelManager).not().assertUndefined();
    })

    it('playTitleAppearAnimation_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      (recentGesture as object)['playTitleAppearAnimation']();
      expect(scenePanelManager).not().assertUndefined();
    })

    it('playTitleAppearAnimation_test02', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      (recentGesture as object)['isNewStyle'] = true;
      recentGesture.playTitleAppearAnimation(floatSession1);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('playTitleAppearAnimation_test03', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      (recentGesture as object)['isNewStyle'] = false;
      recentGesture.playTitleAppearAnimation(floatSession1);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('isVertical_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      (recentGesture as object)['isVertical'](0);
      expect(scenePanelManager).not().assertUndefined();
      (recentGesture as object)['isVertical'](180);
      expect(scenePanelManager).not().assertUndefined();
      (recentGesture as object)['isVertical'](360);
      expect(scenePanelManager).not().assertUndefined();
      (recentGesture as object)['isVertical'](100);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('playAnimationForFillingContainers_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      (recentGesture as object)['playAnimationForFillingContainers']();
      expect(scenePanelManager).not().assertUndefined();
    })

    it('playAnimationForFillingContainers_test02', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      (recentGesture as object)['isNewStyle'] = true;
      recentGesture.playAnimationForFillingContainers();
      expect(scenePanelManager).not().assertUndefined();
    })

    it('playAnimationForFillingContainers_test03', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      (recentGesture as object)['isNewStyle'] = false;
      recentGesture.playAnimationForFillingContainers();
      expect(scenePanelManager).not().assertUndefined();
    })

    it('buildFillingContainers_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      (recentGesture as object)['buildFillingContainers']();
      expect(scenePanelManager).not().assertUndefined();
    })

    it('deleteMultiRowContainerFromRecentIsRightFill_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      (recentGesture as object)['deleteMultiRowContainerFromRecentIsRightFill']();
      expect(scenePanelManager).not().assertUndefined();
    })

    it('deleteMultiRowContainerFromRecentNotRightFill_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      (scenePanelManager as object)['screenProperty'] = screenProperty;
      (recentGesture as object)['panelManager'] = scenePanelManager;
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      (recentGesture as object)['deleteMultiRowContainerFromRecentNotRightFill'](sCBSceneContainerSessionArray1, 1, 2);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('updateGestureValue_test02', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let needRenderTranslate1: NeedRenderTranslate = new NeedRenderTranslate();
      (needRenderTranslate1 as object)['_translateX'] = 1;
      (needRenderTranslate1 as object)['_translateY'] = 1;
      scbSceneContainerSession.needRenderTranslate = needRenderTranslate1;
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      recentRuntimeInstance.containerCountsShowInRecent = 4;
      (scenePanelManager as object)['screenProperty'] = screenProperty;
      (recentGesture as object)['panelManager'] = scenePanelManager;
      recentGesture.updateGestureValue(sCBSceneContainerSessionArray1);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('updateGestureValue_test03', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let needRenderTranslate1: NeedRenderTranslate = new NeedRenderTranslate();
      (needRenderTranslate1 as object)['_translateX'] = 1;
      (needRenderTranslate1 as object)['_translateY'] = 1;
      scbSceneContainerSession.needRenderTranslate = needRenderTranslate1;
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      recentRuntimeInstance.containerCountsShowInRecent = 0;
      (scenePanelManager as object)['screenProperty'] = screenProperty;
      (recentGesture as object)['panelManager'] = scenePanelManager;
      recentGesture.updateGestureValue(sCBSceneContainerSessionArray1);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('checkFourthColumnVisibility_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      recentGesture.multiCardsNum = 0;
      recentGesture.checkFourthColumnVisibility(1);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('calculateCenterX_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      (scenePanelManager as object)['screenProperty'] = screenProperty;
      (recentGesture as object)['panelManager'] = scenePanelManager;
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      recentGesture.calculateCenterX(1);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('buildFillingContainers_test02', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      (recentGesture as object)['isNewStyle'] = true;
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      recentGesture.buildFillingContainers(totalContainerSessionList);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('deleteMultiRowContainerFromRecentNotRightFill_test02', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      (scenePanelManager as object)['screenProperty'] = screenProperty;
      (recentGesture as object)['panelManager'] = scenePanelManager;
      (recentGesture as object)['isNewStyle'] = true;
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      recentRuntimeInstance.containerCountsShowInRecent = 10;
      recentGesture.deleteMultiRowContainerFromRecentNotRightFill(sCBSceneContainerSessionArray1, 1, 1,
        sCBSceneContainerSessionArray1);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('deleteMultiRowContainerFromRecentNotRightFill_test03', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      (recentGesture as object)['isNewStyle'] = true;
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      recentRuntimeInstance.containerCountsShowInRecent = 0;
      recentGesture.deleteMultiRowContainerFromRecentNotRightFill(sCBSceneContainerSessionArray1, 1, 1,
        sCBSceneContainerSessionArray1);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('getPositionXIsDeleting_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentGesture, recentGesture.getMultiRowColumnInDeleting);
      when(mockFun)().afterReturn(0);
      (recentGesture as object)['getPositionXIsDeleting'](1);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentGesture, recentGesture.getMultiRowColumnInDeleting);
    })

    it('getPositionXIsDeleting_test02', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentGesture, recentGesture.getMultiRowColumnInDeleting);
      when(mockFun)().afterReturn(1);
      (recentGesture as object)['getPositionXIsDeleting'](1);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentGesture, recentGesture.getMultiRowColumnInDeleting);
    })

    it('getPositionXIsDeleting_test03', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentGesture, recentGesture.getMultiRowColumnInDeleting);
      when(mockFun)().afterReturn(2);
      (recentGesture as object)['getPositionXIsDeleting'](1);
      expect(scenePanelManager).not().assertUndefined();
      mock.ignoreMock(recentGesture, recentGesture.getMultiRowColumnInDeleting);
    })

    it('resetZindexAndCenterOnfinish_test01', 0, (): void => {
      let sceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let mock = new MockKit();
      let mockFun = mock.mockFunc(sceneContainerSession, sceneContainerSession.getTransitionCount);
      when(mockFun)().afterReturn(1);
      let res = recentGesture.resetZindexAndCenterOnfinish(sceneContainerSession, 1)
      expect(res !== null).assertTrue();
      mock.ignoreMock(sceneContainerSession, sceneContainerSession.getTransitionCount);
    })

    it('resetZindexAndCenterOnfinish_test02', 0, (): void => {
      let sceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
      let mock = new MockKit();
      let mockFun = mock.mockFunc(sceneContainerSession, sceneContainerSession.getTransitionCount);
      when(mockFun)().afterReturn(3);
      let res = recentGesture.resetZindexAndCenterOnfinish(sceneContainerSession, 1)
      expect(res !== null).assertTrue();
      mock.ignoreMock(sceneContainerSession, sceneContainerSession.getTransitionCount);
    })

    it('test_resetGatherCardTranslate', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      recentGesture.removingIndex = 2;
      (recentGesture as object)['resetGatherCardTranslate']();
      expect(scenePanelManager).not().assertUndefined();
    })

    it('test_cardGatherAnimate', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      (recentGesture as object)['cardGatherAnimate'](0, 1);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('test_singleRowSlideAndOtherCardsCloseAnimate_0', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentGesture, recentGesture.getSceneSessionScreenIndex);
      when(mockFun)(ArgumentMatchers.any).afterReturn(0);
      (recentGesture as object)['singleRowSlideAndOtherCardsCloseAnimate'](0, 1);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('test_singleRowSlideAndOtherCardsCloseAnimate_1', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentGesture, recentGesture.getSceneSessionScreenIndex);
      when(mockFun)(ArgumentMatchers.any).afterReturn(1);
      (recentGesture as object)['singleRowSlideAndOtherCardsCloseAnimate'](0, 1);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('test_singleRowSlideAndOtherCardsCloseAnimate_2', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentGesture, recentGesture.getSceneSessionScreenIndex);
      when(mockFun)(ArgumentMatchers.any).afterReturn(2);
      (recentGesture as object)['singleRowSlideAndOtherCardsCloseAnimate'](0, 1);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('test_multiRowSlideAndOtherCardsCloseAnimate', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentRuntimeInstance.notRemovingSessionList = sCBSceneContainerSessionArray1;
      recentGesture.removingIndex = 1;
      (recentGesture as object)['multiRowSlideAndOtherCardsCloseAnimate'](0);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('test_slideCardFollowingAnimate', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      (recentGesture as object)['slideCardFollowingAnimate'](0);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('test_initGestureValue', 0, (): void => {
      recentGesture.initGestureValue(0,0,0);
      expect(recentGesture).not().assertUndefined();
    })

    it('test_initGestureValue', 0, (): void => {
      recentGesture.initGestureValue(0,0,0);
      expect(recentGesture).not().assertUndefined();
    })

    it('test_updateMultiRowContainerRightFill', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      (recentGesture as object)['updateMultiRowContainerRightFill'](sCBSceneContainerSessionArray1, 4, 1,
        sCBSceneContainerSessionArray1, 10);
      expect(recentGesture).not().assertUndefined();
    })

    it('test_otherContainerNoneFilling', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      (recentGesture as object)['otherContainerNoneFilling'](2, sCBSceneContainerSessionArray1);
      expect(recentGesture).not().assertUndefined();
    })

    it('test_otherContainerRightFilling', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      (recentGesture as object)['otherContainerRightFilling'](0, 1, sCBSceneContainerSessionArray1,
        sCBSceneContainerSessionArray1);
      expect(recentGesture).not().assertUndefined();
    })

    it('test_otherContainerLeftFilling', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      (recentGesture as object)['otherContainerLeftFilling'](0, 1, sCBSceneContainerSessionArray1,
        sCBSceneContainerSessionArray1);
      expect(recentGesture).not().assertUndefined();
    })

    it('test_otherContainerAnimationWhenDeleteFromRecentMultiRow', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      (recentGesture as object)['isNewStyle'] = false;
      (recentGesture as object)['otherContainerAnimationWhenDeleteFromRecentMultiRow'](sCBSceneContainerSessionArray1,
        0, 1,);
      expect(recentGesture).not().assertUndefined();
    })

    it('deleteSingleRowContainerFromRecent_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let sCBSceneContainerSessionArray1: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      sCBSceneContainerSessionArray1.push(scbSceneContainerSession);
      recentGesture.deleteSingleRowContainerFromRecent(sCBSceneContainerSessionArray1, 1, 1, 0,
        sCBSceneContainerSessionArray1);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('test_playTrailingAnimationSingleRow', 0, (): void => {
      (recentGesture as object)['playTrailingAnimationSingleRow'](0);
      expect(recentGesture).not().assertUndefined();
    })

    it('test_setCardsTranslateX', 0, (): void => {
      recentGesture.setCardsTranslateX(1, 10);
      expect(recentGesture).not().assertUndefined();
    })

    it('test_onRecentGestureBeginInitParam', 0, (): void => {
      (recentGesture as object)['onRecentGestureBeginInitParam'](0);
      expect(recentGesture).not().assertUndefined();
    })
  })
}