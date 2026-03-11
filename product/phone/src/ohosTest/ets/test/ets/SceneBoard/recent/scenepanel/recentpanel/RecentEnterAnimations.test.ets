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
  NeedRenderBlurRadius,
  NeedRenderShowInRecent,
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneInfo,
  SCBScenePanelManager,
  SCBSceneSession,
  SCBScreenProperty
} from '@ohos/windowscene';
import {
  RecentEnterAnimations
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentEnterAnimations';
import sceneSessionManager from '@ohos.sceneSessionManager';
import screenSessionManager from '@ohos.screenSessionManager';
import { recentLayoutConfigInstance } from '@ohos/recents';
import { commonEventManager } from '@kit.BasicServicesKit';
import {
  RecentEnterCallback
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentCallbacks';
import {
  MultiRecentPositionArray
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/common/RecentLayoutManager';
import {
  recentRuntimeInstance
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentRuntimeModel';
import {
  RecentLayoutCalculatorFactory
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/common/RecentLayoutCalculatorFactory';

export default function RecentEnterAnimationsTest() {
  describe('RecentEnterAnimationsTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

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
    event.fingerList[0] = {
      globalX: 1,
      globalY: 2,
      id: 1,
      localX: 1,
      localY: 2,
      displayX: 1,
      displayY: 2
    };
    event.fingerList[1] = {
      globalX: 1,
      globalY: 2,
      id: 1,
      localX: 1,
      localY: 2,
      displayX: 1,
      displayY: 2
    };
    let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
    let screenProp: screenSessionManager.ScreenProperty = {
      rotation: 1,
      bounds: {
        left: 1,
        top: 1,
        width: 1,
        height: 1,
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
    let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
    let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
    let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
    let primarySession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
    let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
    let scbSceneContainer: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
    totalContainerSessionList.add(scbSceneContainer);
    totalContainerSessionList.add(scbSceneContainer);
    let recentLayoutConfig = recentLayoutConfigInstance;

    it('RecentEnterAnimations_init_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentEnterAnimations.init();
      expect(totalContainerSessionList[0]?.needRenderShowInRecent.showInRecent).assertEqual(false);
    })
    it('RecentEnterAnimations_getCurrentIdx_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let idx = recentEnterAnimations.getCurrentIdx();
      expect(idx).assertLargerOrEqual(-1);
    })

    it('RecentEnterAnimations_getFollowingEndIdx_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentEnterAnimations.getFollowingEndIdx();
      expect(0).assertLargerOrEqual(0);
    })

    it('RecentEnterAnimations_interruptOtherAnimations_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let currentIdx: Function = mocker.mockFunc(recentEnterAnimations, recentEnterAnimations.getCurrentIdx);
      when(currentIdx)(ArgumentMatchers.any).afterReturn(0);
      let followingEndIdx: Function = mocker.mockFunc(recentEnterAnimations, recentEnterAnimations.getFollowingEndIdx);
      when(followingEndIdx)(ArgumentMatchers.any).afterReturn(0);
      recentEnterAnimations.interruptOtherAnimations(false);
      expect((recentEnterAnimations as object)['currentScaleX']).assertEqual(0);
      mocker.ignoreMock(recentEnterAnimations, recentEnterAnimations.getCurrentIdx);
      mocker.ignoreMock(recentEnterAnimations, recentEnterAnimations.getFollowingEndIdx);
    })

    it('RecentEnterAnimations_interruptOtherAnimations_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let currentIdx: Function = mocker.mockFunc(recentEnterAnimations, recentEnterAnimations.getCurrentIdx);
      when(currentIdx)(ArgumentMatchers.any).afterReturn(1);
      let followingEndIdx: Function = mocker.mockFunc(recentEnterAnimations, recentEnterAnimations.getFollowingEndIdx);
      when(followingEndIdx)(ArgumentMatchers.any).afterReturn(0);
      recentEnterAnimations.interruptOtherAnimations(false);
      expect((recentEnterAnimations as object)['currentScaleX']).assertEqual(0);
      mocker.ignoreMock(recentEnterAnimations, recentEnterAnimations.getCurrentIdx);
      mocker.ignoreMock(recentEnterAnimations, recentEnterAnimations.getFollowingEndIdx);
    })

    it('RecentEnterAnimations_interruptOtherAnimations_test_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let currentIdx: Function = mocker.mockFunc(recentEnterAnimations, recentEnterAnimations.getCurrentIdx);
      when(currentIdx)(ArgumentMatchers.any).afterReturn(0);
      let followingEndIdx: Function = mocker.mockFunc(recentEnterAnimations, recentEnterAnimations.getFollowingEndIdx);
      when(followingEndIdx)(ArgumentMatchers.any).afterReturn(0);
      recentEnterAnimations.interruptOtherAnimations(true);
      expect((recentEnterAnimations as object)['currentScaleX']).assertEqual(0);
      mocker.ignoreMock(recentEnterAnimations, recentEnterAnimations.getCurrentIdx);
      mocker.ignoreMock(recentEnterAnimations, recentEnterAnimations.getFollowingEndIdx);
    })

    it('RecentEnterAnimations_interruptOtherAnimations_test_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let currentIdx: Function = mocker.mockFunc(recentEnterAnimations, recentEnterAnimations.getCurrentIdx);
      when(currentIdx)(ArgumentMatchers.any).afterReturn(1);
      let followingEndIdx: Function = mocker.mockFunc(recentEnterAnimations, recentEnterAnimations.getFollowingEndIdx);
      when(followingEndIdx)(ArgumentMatchers.any).afterReturn(0);
      recentEnterAnimations.interruptOtherAnimations(true);
      expect((recentEnterAnimations as object)['currentScaleX']).assertEqual(0);
      mocker.ignoreMock(recentEnterAnimations, recentEnterAnimations.getCurrentIdx);
      mocker.ignoreMock(recentEnterAnimations, recentEnterAnimations.getFollowingEndIdx);
    })

    it('RecentEnterAnimations_getFinalRecentW_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let recentW = recentEnterAnimations.getFinalRecentW();
      expect(recentW).assertInstanceOf('Number');
    })

    it('RecentEnterAnimations_getRecentTranslateX_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let recentTranslateX = recentEnterAnimations.getRecentTranslateX();
      expect(recentTranslateX).assertEqual(0);
    })

    it('RecentEnterAnimations_setContainerSessionTranslate_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentEnterAnimations.setContainerSessionTranslate(scbSceneContainer, 1, 1, '');
      expect(totalContainerSessionList[0]?.needRenderTranslate.translateX).assertEqual(1);
    })

    it('RecentEnterAnimations_setContainerSessionScale_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentEnterAnimations.setContainerSessionScale(scbSceneContainer, 1, 1, '');
      expect(totalContainerSessionList[0]?.needRenderScale.scaleX).assertEqual(1);
    })

    it('RecentEnterAnimations_enterAppFarViewAnimations_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentEnterAnimations.enterAppFarViewAnimations();
      expect(totalContainerSessionList[0]?.needRenderScale.scaleX).assertEqual(1);
    })

    it('RecentEnterAnimations_getFollowingStartIdx_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let followingStartIdx = recentEnterAnimations.getFollowingStartIdx();
      expect(followingStartIdx).assertEqual(0);
    })

    it('RecentEnterAnimations_getEnterStartIdx_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let enterStartIdx = recentEnterAnimations.getEnterStartIdx();
      expect(enterStartIdx).assertLargerOrEqual(0);
    })

    it('RecentEnterAnimations_getEnterEndIdx_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let enterEndIdx = recentEnterAnimations.getEnterEndIdx();
      expect(enterEndIdx).assertLargerOrEqual(0);
    })

    it('RecentEnterAnimations_updateFollowingIdx_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentEnterAnimations.updateFollowingIdx(true, totalContainerSessionList);
      expect((recentEnterAnimations as object)['currentScaleX']).assertEqual(0);
    })

    it('RecentEnterAnimations_updateFollowingIdx_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentEnterAnimations.updateFollowingIdx(false, totalContainerSessionList);
      expect(recentEnterAnimations).not().assertNull();
    })

    it('RecentEnterAnimations_playTitleAppearAnimations_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentEnterAnimations.playTitleAppearAnimations(false);
      expect(recentEnterAnimations).not().assertNull();
    })

    it('RecentEnterAnimations_playTitleAppearAnimations_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentEnterAnimations.playTitleAppearAnimations(true);
      expect((recentEnterAnimations as object)['currentScaleX']).assertEqual(0);
    })

    it('RecentEnterAnimations_updateEnterIdx_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(true);
      recentEnterAnimations.updateEnterIdx(false, false);
      expect((recentEnterAnimations as object)['currentScaleX']).assertEqual(0);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentEnterAnimations_updateEnterIdx_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(true);
      recentEnterAnimations.updateEnterIdx(false, true);
      expect((recentEnterAnimations as object)['currentScaleX']).assertEqual(0);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentEnterAnimations_updateEnterIdx_test_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(true);
      recentEnterAnimations.updateEnterIdx(true, false);
      expect((recentEnterAnimations as object)['currentScaleX']).assertEqual(0);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentEnterAnimations_updateEnterIdx_test_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(true);
      recentEnterAnimations.updateEnterIdx(true, true);
      expect((recentEnterAnimations as object)['currentScaleX']).assertEqual(0);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentEnterAnimations_updateEnterIdx_test_05', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      recentEnterAnimations.updateEnterIdx(false, false);
      expect((recentEnterAnimations as object)['currentScaleX']).assertEqual(0);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentEnterAnimations_updateEnterIdx_test_06', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      recentEnterAnimations.updateEnterIdx(false, true);
      expect((recentEnterAnimations as object)['currentScaleX']).assertEqual(0);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentEnterAnimations_updateEnterIdx_test_07', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      recentEnterAnimations.updateEnterIdx(true, false);
      expect((recentEnterAnimations as object)['currentScaleX']).assertEqual(0);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentEnterAnimations_updateEnterIdx_test_08', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      recentEnterAnimations.updateEnterIdx(true, true);
      expect((recentEnterAnimations as object)['currentScaleX']).assertEqual(0);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentEnterAnimations_setShowRecentIfNeed_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let currentIdx: Function = mocker.mockFunc(recentEnterAnimations, recentEnterAnimations.getCurrentIdx);
      when(currentIdx)(ArgumentMatchers.any).afterReturn(8);
      let followingEndIdx: Function = mocker.mockFunc(recentEnterAnimations, recentEnterAnimations.getFollowingEndIdx);
      when(followingEndIdx)(ArgumentMatchers.any).afterReturn(0);
      recentEnterAnimations.setShowRecentIfNeed();
      expect((recentEnterAnimations as object)['currentScaleX']).assertEqual(0);
    })

    it('RecentEnterAnimations_setShowRecentIfNeed_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let currentIdx: Function = mocker.mockFunc(recentEnterAnimations, recentEnterAnimations.getCurrentIdx);
      when(currentIdx)(ArgumentMatchers.any).afterReturn(0);
      let followingEndIdx: Function = mocker.mockFunc(recentEnterAnimations, recentEnterAnimations.getFollowingEndIdx);
      when(followingEndIdx)(ArgumentMatchers.any).afterReturn(8);
      recentEnterAnimations.setShowRecentIfNeed();
      expect((recentEnterAnimations as object)['currentScaleX']).assertEqual(0);
    })

    it('RecentEnterAnimations_setShowRecentIfNeed_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let currentIdx: Function = mocker.mockFunc(recentEnterAnimations, recentEnterAnimations.getCurrentIdx);
      when(currentIdx)(ArgumentMatchers.any).afterReturn(0);
      let followingEndIdx: Function = mocker.mockFunc(recentEnterAnimations, recentEnterAnimations.getFollowingEndIdx);
      when(followingEndIdx)(ArgumentMatchers.any).afterReturn(8);
      recentEnterAnimations.setShowRecentIfNeed();
      expect((recentEnterAnimations as object)['currentScaleX']).assertEqual(0);
    })

    it('RecentEnterAnimations_publishRecentEvent_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let options: commonEventManager.CommonEventPublishData = {
        bundleName: 'com.ohos.inputmethod',
        data: 'ENTER'
      };
      commonEventManager.publish('RECENT_EVENT_FOR_INPUT', options, () => {
      });
      recentEnterAnimations.publishRecentEvent(true);
      expect((recentEnterAnimations as object)['currentScaleX']).assertEqual(0);
    })

    it('RecentEnterAnimations_publishRecentEvent_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let options: commonEventManager.CommonEventPublishData = {
        bundleName: 'com.ohos.inputmethod',
        data: 'EXIT'
      };
      commonEventManager.publish('RECENT_EVENT_FOR_INPUT', options, () => {
      });
      recentEnterAnimations.publishRecentEvent(false);
      expect((recentEnterAnimations as object)['currentScaleX']).assertEqual(0);
    })

    it('RecentEnterAnimations_updateRecentParmForFollowing_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      recentEnterAnimations.updateRecentParmForFollowing(0, 0, true);
      expect((recentEnterAnimations as object)['currentScaleX']).not().assertEqual(0);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentEnterAnimations_updateRecentParmForFollowing_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      recentEnterAnimations.updateRecentParmForFollowing(0, 0, false);
      expect((recentEnterAnimations as object)['currentScaleX']).not().assertEqual(0);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentEnterAnimations_updateRecentParmForFollowing_test_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let screenProp: screenSessionManager.ScreenProperty = {
        rotation: 1,
        bounds: {
          left: 10,
          top: 10,
          width: 10,
          height: 10,
          radius: 10,
        },
        fakeBounds: {
          left: 10,
          top: 10,
          width: 10,
          height: 10,
          radius: 10
        },
        isFakeInUse: false,
        rsId: 0,
      };
      scbScreenProperty.update(screenProp);
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      recentEnterAnimations.updateRecentParmForFollowing(0, 10, true);
      expect((recentEnterAnimations as object)['currentScaleX']).not().assertEqual(0);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentEnterAnimations_followingAnimateToRecentFromApp_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentEnterAnimations.followingAnimateToRecentFromApp(0);
      expect((recentEnterAnimations as object)['currentScaleX']).not().assertEqual(0);
    })

    it('RecentEnterAnimations_inheritFollowingBeforeEnter_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      recentEnterAnimations.inheritFollowingBeforeEnter(true , 0);
      expect((recentEnterAnimations as object)['currentScaleX']).not().assertEqual(0);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentEnterAnimations_inheritFollowingBeforeEnter_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      recentEnterAnimations.inheritFollowingBeforeEnter(false, 0);
      expect((recentEnterAnimations as object)['currentScaleX']).not().assertEqual(0);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentEnterAnimations_getCurrentScaleX_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let idx = recentEnterAnimations.getCurrentScaleX();
      expect(idx).assertLargerOrEqual(0);
    })

    it('RecentEnterAnimations_getCurrentScaleY_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let idx = recentEnterAnimations.getCurrentScaleY();
      expect(idx).assertLargerOrEqual(0);
    })

    it('init_test01', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      (recentEnterAnimations as object)['init']();
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('init_test02', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      recentEnterAnimations.init();
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('updateRecentParmForFollowing_test01', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      (recentEnterAnimations as object)['updateRecentParmForFollowing']();
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('interruptOtherAnimations_test01', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      (recentEnterAnimations as object)['interruptOtherAnimations']();
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('interruptOtherAnimations_test04', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      (recentEnterAnimations as object)['followingStartIdx'] = 0;
      (recentEnterAnimations as object)['followingEndIdx'] = 2;
      (recentEnterAnimations as object)['currentIdx'] = 1;
      recentEnterAnimations.interruptOtherAnimations(false);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('interruptOtherAnimations_test05', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      (recentEnterAnimations as object)['followingStartIdx'] = 0;
      (recentEnterAnimations as object)['followingEndIdx'] = 2;
      (recentEnterAnimations as object)['currentIdx'] = 5;
      recentEnterAnimations.interruptOtherAnimations(false);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('followingAnimateToRecentFromApp_test01', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      (recentEnterAnimations as object)['followingAnimateToRecentFromApp']();
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('followingAnimateToRecentFromApp_test02', 0, (): void => {
      let screenProp: screenSessionManager.ScreenProperty = {
        rotation: 1,
        bounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        fakeBounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        isFakeInUse: true,
        rsId: 0,
      };
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      scbScreenProperty.update(screenProp);
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('resetPreviousSessionBlurRadius_test01', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.length = 0;
      (recentEnterAnimations as object)['resetPreviousSessionBlurRadius'](totalContainerSessionList);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('resetPreviousSessionBlurRadius_test02', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.length = 5;
      (recentEnterAnimations as object)['resetPreviousSessionBlurRadius'](totalContainerSessionList);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('resetContainerSessionBlurRadius_test01', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      (recentEnterAnimations as object)['resetContainerSessionBlurRadius']();
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('resetContainerSessionBlurRadius_test01', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let primarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let scbSceneContainer: SCBSceneContainerSession =
        new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
      (recentEnterAnimations as object)['resetContainerSessionBlurRadius'](scbSceneContainer);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('followingAnimateToRecentFromHome_test01', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      (recentEnterAnimations as object)['followingAnimateToRecentFromHome']();
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('setContainerSessionTranslate_test01', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      (recentEnterAnimations as object)['setContainerSessionTranslate']();
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('setContainerSessionScale_test01', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      (recentEnterAnimations as object)['setContainerSessionScale']();
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('startForegroundBlurAnimation_test01', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.length = 0;
      (recentEnterAnimations as object)['isNewStyle'] = false;
      recentEnterAnimations.startForegroundBlurAnimation(true);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('startForegroundBlurAnimation_test02', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.length = 0;
      (recentEnterAnimations as object)['isNewStyle'] = true;
      recentEnterAnimations.startForegroundBlurAnimation(true);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun)().afterReturn(totalContainerSessionList);
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('startForegroundBlurAnimation_test03', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.length = 5;
      (recentEnterAnimations as object)['isNewStyle'] = true;
      (recentEnterAnimations as object)['currentIdx'] = 4;
      recentEnterAnimations.startForegroundBlurAnimation(true);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun)().afterReturn(totalContainerSessionList);
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('startForegroundBlurAnimation_test04', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.length = 5;
      (recentEnterAnimations as object)['isNewStyle'] = true;
      (recentEnterAnimations as object)['currentIdx'] = 9;
      recentEnterAnimations.startForegroundBlurAnimation(true);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun)().afterReturn(totalContainerSessionList);
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('startForegroundBlurAnimation_test05', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.length = 5;
      (recentEnterAnimations as object)['isNewStyle'] = true;
      recentEnterAnimations.startForegroundBlurAnimation(false);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun)().afterReturn(totalContainerSessionList);
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('initOtherContainerSessionsForMultiRow_test01', 0, (): void => {
      let mock = new MockKit();
      let getSceneContainerSessionListForView =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(getSceneContainerSessionListForView)(ArgumentMatchers.any).afterReturn(undefined);
      recentEnterAnimations.initOtherContainerSessionsForMultiRow();
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('initOtherContainerSessionsForMultiRow_test02', 0, (): void => {
      let mock = new MockKit();
      let getSceneContainerSessionListForView =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(getSceneContainerSessionListForView)(ArgumentMatchers.any).afterReturn(totalContainerSessionList);
      (recentEnterAnimations as object)['enterStartIdx'] = 0;
      (recentEnterAnimations as object)['followingStartIdx'] = 1;
      (recentEnterAnimations as object)['enterEndIdx'] = 1;
      (recentEnterAnimations as object)['followingEndIdx'] = 0;
      recentEnterAnimations.initOtherContainerSessionsForMultiRow();
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('updateFollowingIdx_test01', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      (recentEnterAnimations as object)['updateFollowingIdx']();
      expect(recentEnterAnimations).not().assertUndefined();
    })


    it('playTitleAppearAnimations_test01', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      (recentEnterAnimations as object)['playTitleAppearAnimations']();
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('playTitleAppearAnimations_test02', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.length = 5;
      (recentEnterAnimations as object)['isNewStyle'] = false;
      (recentEnterAnimations as object)['enterStartIdx'] = 1;
      (recentEnterAnimations as object)['enterEndIdx'] = 4;
      recentEnterAnimations.playTitleAppearAnimations(true);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('playTitleAppearAnimations_test03', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.length = 5;
      (recentEnterAnimations as object)['isNewStyle'] = false;
      (recentEnterAnimations as object)['enterStartIdx'] = 1;
      (recentEnterAnimations as object)['enterEndIdx'] = 4;
      recentEnterAnimations.playTitleAppearAnimations(false);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('playTitleAppearAnimations_test04', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.length = 5;
      (recentEnterAnimations as object)['isNewStyle'] = true;
      recentEnterAnimations.playTitleAppearAnimations(false);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('playTitleAppearAnimations_test05', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.length = 5;
      (recentEnterAnimations as object)['isNewStyle'] = true;
      (recentEnterAnimations as object)['enterStartIdx'] = 1;
      (recentEnterAnimations as object)['enterEndIdx'] = 4;
      recentEnterAnimations.playTitleAppearAnimations(false);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('inheritFollowingBeforeEnter_test01', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      (recentEnterAnimations as object)['inheritFollowingBeforeEnter']();
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('inheritFollowingBeforeEnter_test02', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.length = 5;
      recentEnterAnimations.inheritFollowingBeforeEnter(false, 1);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('inheritFollowingContainerSession_test01', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      (recentEnterAnimations as object)['inheritFollowingContainerSession']();
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('inheritFollowingContainerSession_test02', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let primarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let scbSceneContainer: SCBSceneContainerSession =
        new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
      (recentEnterAnimations as object)['inheritFollowingContainerSession'](scbSceneContainer, 1, 2);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('updateMultiRowEnterIndex_test01', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.length = 5;
      (recentEnterAnimations as object)['currentIdx'] = 4;
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun)().afterReturn(totalContainerSessionList);
      (recentEnterAnimations as object)['updateMultiRowEnterIndex'](true, true);
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('updateMultiRowEnterIndex_test02', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.length = 5;
      (recentEnterAnimations as object)['currentIdx'] = 14;
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun)().afterReturn(totalContainerSessionList);
      (recentEnterAnimations as object)['updateMultiRowEnterIndex'](true, true);
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('updateMultiRowEnterIndex_test03', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.length = 5;
      (recentEnterAnimations as object)['currentIdx'] = 13;
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun)().afterReturn(totalContainerSessionList);
      (recentEnterAnimations as object)['updateMultiRowEnterIndex'](true, true);
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('updateSingleRowEnterIndex_test01', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.length = 5;
      (recentEnterAnimations as object)['currentIdx'] = 4;
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun)().afterReturn(totalContainerSessionList);
      (recentEnterAnimations as object)['updateSingleRowEnterIndex'](true, true);
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('updateSingleRowEnterIndex_test02', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.length = 5;
      (recentEnterAnimations as object)['currentIdx'] = 14;
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun)().afterReturn(totalContainerSessionList);
      (recentEnterAnimations as object)['updateSingleRowEnterIndex'](true, true);
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('setShowRecentIfNeed_test01', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      (recentEnterAnimations as object)['setShowRecentIfNeed']();
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('setShowRecentIfNeed_test02', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let primarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let scbSceneContainer: SCBSceneContainerSession =
        new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
      totalContainerSessionList.add(scbSceneContainer);
      totalContainerSessionList.add(scbSceneContainer);
      (recentEnterAnimations as object)['followingStartIdx'] = 0;
      (recentEnterAnimations as object)['followingEndIdx'] = 3;
      (recentEnterAnimations as object)['currentIdx'] = 6;
      (recentEnterAnimations as object)['setShowRecentIfNeed']();
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('setShowRecentIfNeed_test03', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let primarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let scbSceneContainer: SCBSceneContainerSession =
        new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
      totalContainerSessionList.add(scbSceneContainer);
      totalContainerSessionList.add(scbSceneContainer);
      (recentEnterAnimations as object)['followingStartIdx'] = 0;
      (recentEnterAnimations as object)['followingEndIdx'] = 3;
      (recentEnterAnimations as object)['currentIdx'] = 1;
      (recentEnterAnimations as object)['setShowRecentIfNeed']();
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('setShowRecentIfNeed_test04', 0, (): void => {
      let mock = new MockKit();
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun1)().afterReturn(undefined);
      recentEnterAnimations.setShowRecentIfNeed();
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('initNotCurrentContainerSession_test01', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      (recentEnterAnimations as object)['initNotCurrentContainerSession']();
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('initNotCurrentContainerSession_test02', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let primarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let scbSceneContainer: SCBSceneContainerSession =
        new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
      (recentEnterAnimations as object)['initNotCurrentContainerSession'](scbSceneContainer, 1, 2);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('initCurrentContainerSession_test01', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      (recentEnterAnimations as object)['initCurrentContainerSession']();
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('initCurrentContainerSession_test02', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let primarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let scbSceneContainer: SCBSceneContainerSession =
        new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
      (recentEnterAnimations as object)['initCurrentContainerSession'](scbSceneContainer);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('restoreContainerSessionIfNeed_test01', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let screenProp: screenSessionManager.ScreenProperty = {
        rotation: 1,
        bounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        fakeBounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        isFakeInUse: true,
        rsId: 0,
      };
      scbScreenProperty.update(screenProp);
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let primarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let scbSceneContainer: SCBSceneContainerSession =
        new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
      let needRenderShowInRecent: NeedRenderShowInRecent = new NeedRenderShowInRecent();
      totalContainerSessionList.add(scbSceneContainer);
      totalContainerSessionList.add(scbSceneContainer);
      (needRenderShowInRecent as object)['_showInRecent'] = true;
      (scenePanelManager as object)['containerSessionList'] = totalContainerSessionList;
      (scenePanelManager as object)['containerListForTheView'] = totalContainerSessionList;
      (scbSceneContainer as object)['_isActive'] = false;
      (recentEnterAnimations as object)['restoreContainerSessionIfNeed'](0);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('restoreContainerSessionIfNeed_test02', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let screenProp: screenSessionManager.ScreenProperty = {
        rotation: 1,
        bounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        fakeBounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        isFakeInUse: true,
        rsId: 0,
      };
      scbScreenProperty.update(screenProp);
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let primarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let scbSceneContainer: SCBSceneContainerSession =
        new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
      let needRenderShowInRecent: NeedRenderShowInRecent = new NeedRenderShowInRecent();
      totalContainerSessionList.add(scbSceneContainer);
      totalContainerSessionList.add(scbSceneContainer);
      (needRenderShowInRecent as object)['_showInRecent'] = true;
      (scenePanelManager as object)['containerSessionList'] = totalContainerSessionList;
      (scenePanelManager as object)['containerListForTheView'] = totalContainerSessionList;
      (scbSceneContainer as object)['_isActive'] = true;
      (recentEnterAnimations as object)['restoreContainerSessionIfNeed'](0);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('restoreContainerSessionIfNeed_test03', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let screenProp: screenSessionManager.ScreenProperty = {
        rotation: 1,
        bounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        fakeBounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        isFakeInUse: true,
        rsId: 0,
      };
      scbScreenProperty.update(screenProp);
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let primarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let scbSceneContainer: SCBSceneContainerSession =
        new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
      let needRenderShowInRecent: NeedRenderShowInRecent = new NeedRenderShowInRecent();
      totalContainerSessionList.add(scbSceneContainer);
      totalContainerSessionList.add(scbSceneContainer);
      (needRenderShowInRecent as object)['_showInRecent'] = false;
      (scenePanelManager as object)['containerSessionList'] = totalContainerSessionList;
      (scenePanelManager as object)['containerListForTheView'] = totalContainerSessionList;
      (recentEnterAnimations as object)['restoreContainerSessionIfNeed'](0);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('restoreContainerSessionIfNeed_test04', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let screenProp: screenSessionManager.ScreenProperty = {
        rotation: 1,
        bounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        fakeBounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        isFakeInUse: true,
        rsId: 0,
      };
      scbScreenProperty.update(screenProp);
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let primarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let scbSceneContainer: SCBSceneContainerSession =
        new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
      scbSceneContainer.needRenderShowInRecent.setShowInRecentWithDfx(true,
        'restoreContainerSessionIfNeed_test04', 'test');
      (scbSceneContainer as object)['_isActive'] = false;
      totalContainerSessionList.add(scbSceneContainer);
      totalContainerSessionList.add(scbSceneContainer);
      totalContainerSessionList.length = 3;
      (scenePanelManager as object)['containerSessionList'] = totalContainerSessionList;
      (scenePanelManager as object)['containerListForTheView'] = totalContainerSessionList;
      (recentEnterAnimations as object)['restoreContainerSessionIfNeed'](0);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('setEnterAppIdleAnimationParams_test01', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let screenProp: screenSessionManager.ScreenProperty = {
        rotation: 1,
        bounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        fakeBounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        isFakeInUse: true,
        rsId: 0,
      };
      scbScreenProperty.update(screenProp);
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let primarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let scbSceneContainer: SCBSceneContainerSession =
        new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
      totalContainerSessionList.add(scbSceneContainer);
      totalContainerSessionList.add(scbSceneContainer);
      (scenePanelManager as object)['containerSessionList'] = totalContainerSessionList;
      (scenePanelManager as object)['containerListForTheView'] = totalContainerSessionList;
      (recentEnterAnimations as object)['setEnterAppIdleAnimationParams'](-1);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('recordEnterRecentAnimationEndLogs_test01', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let screenProp: screenSessionManager.ScreenProperty = {
        rotation: 1,
        bounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        fakeBounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        isFakeInUse: true,
        rsId: 0,
      };
      scbScreenProperty.update(screenProp);
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      (recentEnterAnimations as object)['recordEnterRecentAnimationEndLogs'](true);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('recordEnterRecentAnimationEndLogs_test02', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let screenProp: screenSessionManager.ScreenProperty = {
        rotation: 1,
        bounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        fakeBounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        isFakeInUse: true,
        rsId: 0,
      };
      scbScreenProperty.update(screenProp);
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      (recentEnterAnimations as object)['recordEnterRecentAnimationEndLogs'](false);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('recordEnterRecentAnimationStartLogs_test01', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let screenProp: screenSessionManager.ScreenProperty = {
        rotation: 1,
        bounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        fakeBounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        isFakeInUse: true,
        rsId: 0,
      };
      scbScreenProperty.update(screenProp);
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      (recentEnterAnimations as object)['recordEnterRecentAnimationStartLogs'](false);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('recordEnterRecentAnimationStartLogs_test02', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let screenProp: screenSessionManager.ScreenProperty = {
        rotation: 1,
        bounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        fakeBounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        isFakeInUse: true,
        rsId: 0,
      };
      scbScreenProperty.update(screenProp);
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      (recentEnterAnimations as object)['recordEnterRecentAnimationStartLogs'](true);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('updateScaleAndRadiusInAnimation_test01', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let screenProp: screenSessionManager.ScreenProperty = {
        rotation: 1,
        bounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        fakeBounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        isFakeInUse: true,
        rsId: 0,
      };
      scbScreenProperty.update(screenProp);
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let primarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let scbSceneContainer: SCBSceneContainerSession =
        new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
      totalContainerSessionList.add(scbSceneContainer);
      totalContainerSessionList.add(scbSceneContainer);
      (scenePanelManager as object)['containerSessionList'] = totalContainerSessionList;
      (scenePanelManager as object)['containerListForTheView'] = totalContainerSessionList;
      (recentEnterAnimations as object)['updateScaleAndRadiusInAnimation'](1, 1);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('updateScaleAndRadiusInAnimation_test02', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let screenProp: screenSessionManager.ScreenProperty = {
        rotation: 1,
        bounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        fakeBounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        isFakeInUse: true,
        rsId: 0,
      };
      scbScreenProperty.update(screenProp);
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      (scenePanelManager as object)['containerSessionList'] = totalContainerSessionList;
      (scenePanelManager as object)['containerListForTheView'] = totalContainerSessionList;
      (recentEnterAnimations as object)['updateTranslateInAnimation'](1, 1);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('updateTranslateInAnimation_test01', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let screenProp: screenSessionManager.ScreenProperty = {
        rotation: 1,
        bounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        fakeBounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        isFakeInUse: true,
        rsId: 0,
      };
      scbScreenProperty.update(screenProp);
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let multiRecentPositionArray: MultiRecentPositionArray = new MultiRecentPositionArray();
      (scenePanelManager as object)['containerSessionList'] = totalContainerSessionList;
      (scenePanelManager as object)['containerListForTheView'] = totalContainerSessionList;
      (recentEnterAnimations as object)['updateTranslateInAnimation'](false, 1, multiRecentPositionArray);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('updateTranslateInAnimation_test02', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let screenProp: screenSessionManager.ScreenProperty = {
        rotation: 1,
        bounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        fakeBounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        isFakeInUse: true,
        rsId: 0,
      };
      scbScreenProperty.update(screenProp);
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let primarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let scbSceneContainer: SCBSceneContainerSession =
        new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
      totalContainerSessionList.add(scbSceneContainer);
      totalContainerSessionList.add(scbSceneContainer);
      let multiRecentPositionArray: MultiRecentPositionArray = new MultiRecentPositionArray();
      (scenePanelManager as object)['containerSessionList'] = totalContainerSessionList;
      (scenePanelManager as object)['containerListForTheView'] = totalContainerSessionList;
      (recentEnterAnimations as object)['updateTranslateInAnimation'](true, 1, multiRecentPositionArray);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('startEnterRecentAnimation_test01', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let callback: RecentEnterCallback = {
        onFinish: (animationNum, isFromNavigationCallback) => {
        }
      };
      let screenProp: screenSessionManager.ScreenProperty = {
        rotation: 1,
        bounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        fakeBounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        isFakeInUse: true,
        rsId: 0,
      };
      scbScreenProperty.update(screenProp);
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      (scenePanelManager as object)['screenProperty'] = scbScreenProperty;
      let mock: MockKit = new MockKit();
      let mockFunc: Function =
        mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFunc)().afterReturn(true);
      recentEnterAnimations.startEnterRecentAnimation(true, false, false, callback);
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('startEnterRecentAnimation_test02', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let callback: RecentEnterCallback = {
        onFinish: (animationNum, isFromNavigationCallback) => {
        }
      };
      let screenProp: screenSessionManager.ScreenProperty = {
        rotation: 1,
        bounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        fakeBounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        isFakeInUse: true,
        rsId: 0,
      };
      scbScreenProperty.update(screenProp);
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      (scenePanelManager as object)['screenProperty'] = scbScreenProperty;
      let mock: MockKit = new MockKit();
      let mockFunc: Function =
        mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFunc)().afterReturn(false);
      recentEnterAnimations.startEnterRecentAnimation(true, false, false, callback);
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('publishRecentEvent_test01', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let screenProp: screenSessionManager.ScreenProperty = {
        rotation: 1,
        bounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        fakeBounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        isFakeInUse: true,
        rsId: 0,
      };
      scbScreenProperty.update(screenProp);
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      (scenePanelManager as object)['containerSessionList'] = totalContainerSessionList;
      (scenePanelManager as object)['containerListForTheView'] = totalContainerSessionList;
      (scenePanelManager as object)['_isActive'] = false;
      recentEnterAnimations.publishRecentEvent(true);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('publishRecentEvent_test02', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let screenProp: screenSessionManager.ScreenProperty = {
        rotation: 1,
        bounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        fakeBounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        isFakeInUse: true,
        rsId: 0,
      };
      scbScreenProperty.update(screenProp);
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      (scenePanelManager as object)['containerSessionList'] = totalContainerSessionList;
      (scenePanelManager as object)['containerListForTheView'] = totalContainerSessionList;
      (scenePanelManager as object)['_isActive'] = false;
      recentEnterAnimations.publishRecentEvent(false);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('printFollowEndLog_test01', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let screenProp: screenSessionManager.ScreenProperty = {
        rotation: 1,
        bounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        fakeBounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        isFakeInUse: true,
        rsId: 0,
      };
      scbScreenProperty.update(screenProp);
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      (scenePanelManager as object)['containerSessionList'] = totalContainerSessionList;
      (scenePanelManager as object)['containerListForTheView'] = totalContainerSessionList;
      recentEnterAnimations.printFollowEndLog();
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('printFollowEndLog_test02', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let screenProp: screenSessionManager.ScreenProperty = {
        rotation: 1,
        bounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        fakeBounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        isFakeInUse: true,
        rsId: 0,
      };
      scbScreenProperty.update(screenProp);
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
      let primarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let scbSceneContainer: SCBSceneContainerSession =
        new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
      totalContainerSessionList.add(scbSceneContainer);
      totalContainerSessionList.add(scbSceneContainer);
      (scenePanelManager as object)['containerSessionList'] = totalContainerSessionList;
      (scenePanelManager as object)['containerListForTheView'] = totalContainerSessionList;
      recentEnterAnimations.printFollowEndLog();
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('RecentEnterAnimations_getRecentWidth_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      recentEnterAnimations.getRecentWidth(1, scbScreenProperty, 0);
      expect((recentEnterAnimations as object)['currentScaleX']).not().assertEqual(0);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentEnterAnimations_initSingleRowTranslateY_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let scbSceneContainer1: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
      totalContainerSessionList.push(scbSceneContainer1);
      let scbSceneContainer2: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
      totalContainerSessionList.push(scbSceneContainer2);
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      (recentEnterAnimations as object)['currentScaleX'] = 1;
      recentRuntimeInstance.notRemovingSessionList[1].isFloat = true;
      recentEnterAnimations.initSingleRowTranslateY(0);
      expect(recentEnterAnimations).not().assertUndefined();
      recentRuntimeInstance.notRemovingSessionList[1].isFloat = false;
    })

    it('RecentEnterAnimations_getSessionListLength_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentEnterAnimations.initSessionListLength();
      recentEnterAnimations.getSessionListLength();
      expect((recentEnterAnimations as object)['currentScaleX']).not().assertEqual(0);
    })

    it('RecentEnterAnimations_initSessionListLength_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentEnterAnimations.initSessionListLength();
      expect((recentEnterAnimations as object)['currentScaleX']).not().assertEqual(0);
    })

    it('RecentEnterAnimations_printFollowStartLog_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentEnterAnimations.printFollowStartLog();
      expect((recentEnterAnimations as object)['currentScaleX']).not().assertEqual(0);
    })

    it('RecentEnterAnimations_printFollowEndLog_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentEnterAnimations.printFollowEndLog();
      expect((recentEnterAnimations as object)['currentScaleX']).not().assertEqual(0);
    })

    it('RecentEnterAnimations_startEnterRecentAnimation_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let enterRecentFinishCallback: RecentEnterCallback = {
        onFinish: (animationNum: number, isFromNavigationCallback: boolean) => {}
      }
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      recentEnterAnimations.startEnterRecentAnimation(true, true, true, enterRecentFinishCallback);
      expect((recentEnterAnimations as object)['currentScaleX']).not().assertEqual(0);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentEnterAnimations_startEnterRecentAnimation_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let enterRecentFinishCallback: RecentEnterCallback = {
        onFinish: (animationNum: number, isFromNavigationCallback: boolean) => {}
      }
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(true);
      recentEnterAnimations.startEnterRecentAnimation(true, true, true, enterRecentFinishCallback);
      expect((recentEnterAnimations as object)['currentScaleX']).not().assertEqual(0);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('interruptOtherAnimations_test_01', 0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      (scbSceneContainer as object)['_isActive'] = true;
      scbSceneContainer.primarySession = primarySession;
      scbSceneContainer.primarySession.isTopmost = false;
      totalContainerSessionList.push(scbSceneContainer);
      totalContainerSessionList.push(scbSceneContainer);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun)().afterReturn(undefined);
      recentEnterAnimations.interruptOtherAnimations(false);
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('interruptOtherAnimations_test_02', 0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      (scbSceneContainer as object)['_isActive'] = true;
      scbSceneContainer.primarySession = primarySession;
      scbSceneContainer.primarySession.isTopmost = false;
      totalContainerSessionList.push(scbSceneContainer);
      totalContainerSessionList.push(scbSceneContainer);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun)().afterReturn(totalContainerSessionList);
      (recentEnterAnimations as object)['followingStartIdx'] = 1;
      (recentEnterAnimations as object)['followingEndIdx'] = 1;
      (recentEnterAnimations as object)['currentIdx'] = 1;
      recentEnterAnimations.interruptOtherAnimations(false);
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('interruptOtherAnimations_test_03', 0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      (scbSceneContainer as object)['_isActive'] = true;
      scbSceneContainer.primarySession = primarySession;
      scbSceneContainer.primarySession.isTopmost = false;
      totalContainerSessionList.push(scbSceneContainer);
      totalContainerSessionList.push(scbSceneContainer);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun)().afterReturn(totalContainerSessionList);
      (recentEnterAnimations as object)['followingStartIdx'] = 0;
      (recentEnterAnimations as object)['followingEndIdx'] = 1;
      (recentEnterAnimations as object)['currentIdx'] = 1;
      recentEnterAnimations.interruptOtherAnimations(true);
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('initFromQuickSwitch_test_01', 0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      (scbSceneContainer as object)['_isActive'] = true;
      scbSceneContainer.primarySession = primarySession;
      scbSceneContainer.primarySession.isTopmost = false;
      scbSceneContainer.needRenderShowInRecent.setShowInRecentWithDfx(false, 'initFromQuickSwitch_test_01',
        'initFromQuickSwitch_test_01');
      totalContainerSessionList.push(scbSceneContainer);
      totalContainerSessionList.push(scbSceneContainer);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun)().afterReturn(totalContainerSessionList);
      (recentEnterAnimations as object)['followingStartIdx'] = 0;
      (recentEnterAnimations as object)['followingEndIdx'] = 1;
      (recentEnterAnimations as object)['currentIdx'] = 1;
      recentEnterAnimations.initFromQuickSwitch();
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('initFromQuickSwitch_test_02', 0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      (scbSceneContainer as object)['_isActive'] = true;
      scbSceneContainer.primarySession = primarySession;
      scbSceneContainer.primarySession.isTopmost = false;
      scbSceneContainer.needRenderShowInRecent.setShowInRecentWithDfx(true, 'initFromQuickSwitch_test_01',
        'initFromQuickSwitch_test_01');
      totalContainerSessionList.push(scbSceneContainer);
      totalContainerSessionList.push(scbSceneContainer);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun)().afterReturn(totalContainerSessionList);
      (recentEnterAnimations as object)['followingStartIdx'] = 0;
      (recentEnterAnimations as object)['followingEndIdx'] = 1;
      (recentEnterAnimations as object)['currentIdx'] = 1;
      recentEnterAnimations.initFromQuickSwitch();
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('followingAnimateToRecentFromApp_test_01', 0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      (scbSceneContainer as object)['_isActive'] = true;
      scbSceneContainer.primarySession = primarySession;
      scbSceneContainer.primarySession.isTopmost = false;
      totalContainerSessionList.push(scbSceneContainer);
      totalContainerSessionList.push(scbSceneContainer);
      recentEnterAnimations.followingAnimateToRecentFromApp(1);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('followingAnimateToRecentFromAppWithGestureEvent_test_01', 0, (): void => {
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun)().afterReturn(undefined);
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('followingAnimateToRecentFromAppWithGestureEvent_test_02', 0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let scbSceneContainer1: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
      totalContainerSessionList.push(scbSceneContainer1);
      let scbSceneContainer2: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
      totalContainerSessionList.push(scbSceneContainer2);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun)().afterReturn(totalContainerSessionList);
      (scbSceneContainer2 as object)['_isActive'] = true;
      (recentEnterAnimations as object)['isNewStyle'] = true;
      (recentEnterAnimations as object)['followingStartIdx'] = 0;
      (recentEnterAnimations as object)['followingEndIdx'] = 3;
      recentEnterAnimations.followingAnimateToRecentFromAppWithGestureEvent(event);
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('followingAnimateToRecentFromAppWithGestureEvent_test_03', 0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let scbSceneContainer1: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
      totalContainerSessionList.push(scbSceneContainer1);
      let scbSceneContainer2: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
      totalContainerSessionList.push(scbSceneContainer2);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun)().afterReturn(totalContainerSessionList);
      (scbSceneContainer2 as object)['_isActive'] = true;
      (recentEnterAnimations as object)['isNewStyle'] = false;
      (recentEnterAnimations as object)['followingStartIdx'] = 0;
      (recentEnterAnimations as object)['followingEndIdx'] = 3;
      recentEnterAnimations.followingAnimateToRecentFromAppWithGestureEvent(event);
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('resetContainerSessionBlurRadius_test_01', 0, (): void => {
      let needRenderBlurRadius1: NeedRenderBlurRadius = new NeedRenderBlurRadius();
      (needRenderBlurRadius1 as object)['_blurRadius'] = 1;
      scbSceneContainer.needRenderBlurRadius = needRenderBlurRadius1;
      (recentEnterAnimations as object)['resetContainerSessionBlurRadius'](scbSceneContainer);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('followingAnimateToRecentFromHome_test_01', 0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      (scbSceneContainer as object)['_isActive'] = true;
      scbSceneContainer.primarySession = primarySession;
      scbSceneContainer.primarySession.isTopmost = false;
      totalContainerSessionList.push(scbSceneContainer);
      totalContainerSessionList.push(scbSceneContainer);
      recentEnterAnimations.followingAnimateToRecentFromHome();
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('enterAppFarViewAnimations_test_01', 0, (): void => {
      (recentEnterAnimations as object)['enterAppFarViewAnimations']();
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('enterAppFarViewAnimations_test_02', 0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      (scbSceneContainer as object)['_isActive'] = true;
      scbSceneContainer.primarySession = primarySession;
      scbSceneContainer.primarySession.isTopmost = false;
      totalContainerSessionList.push(scbSceneContainer);
      totalContainerSessionList.push(scbSceneContainer);
      recentEnterAnimations.enterAppFarViewAnimations();
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('enterAppFarViewAnimations_test_03', 0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      (scbSceneContainer as object)['_isActive'] = true;
      scbSceneContainer.primarySession = primarySession;
      scbSceneContainer.primarySession.isTopmost = false;
      totalContainerSessionList.push(scbSceneContainer);
      recentEnterAnimations.enterAppFarViewAnimations();
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('updateFollowingIdx_test_01', 0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      (scbSceneContainer as object)['_isActive'] = true;
      scbSceneContainer.primarySession = primarySession;
      scbSceneContainer.primarySession.isTopmost = false;
      totalContainerSessionList.push(scbSceneContainer);
      totalContainerSessionList.push(scbSceneContainer);
      recentEnterAnimations.updateFollowingIdx(true, totalContainerSessionList);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('updateFollowingIdx_test_02', 0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      (scbSceneContainer as object)['_isActive'] = true;
      scbSceneContainer.primarySession = primarySession;
      scbSceneContainer.primarySession.isTopmost = false;
      totalContainerSessionList.push(scbSceneContainer);
      recentEnterAnimations.updateFollowingIdx(true, totalContainerSessionList);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('initContainerSessionForMultiRow_test_01', 0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let scbSceneContainer1: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
      totalContainerSessionList.push(scbSceneContainer1);
      let mock = new MockKit();
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun1)().afterReturn(totalContainerSessionList);
      (recentEnterAnimations as object)['initContainerSessionForMultiRow'](1);
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('initContainerSessionForMultiRow_test_02', 0, (): void => {
      let mock = new MockKit();
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun1)().afterReturn(totalContainerSessionList);
      (recentEnterAnimations as object)['initContainerSessionForMultiRow'](0);
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('updateMultiRowEnterIndex_test_01', 0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      (scbSceneContainer as object)['_isActive'] = true;
      scbSceneContainer.primarySession = primarySession;
      scbSceneContainer.primarySession.isTopmost = false;
      totalContainerSessionList.push(scbSceneContainer);
      totalContainerSessionList.push(scbSceneContainer);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun)().afterReturn(totalContainerSessionList);
      (recentEnterAnimations as object)['currentIdx'] = 1;
      (recentEnterAnimations as object)['updateMultiRowEnterIndex'](true, false);
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('updateMultiRowEnterIndex_test_02', 0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      (scbSceneContainer as object)['_isActive'] = true;
      scbSceneContainer.primarySession = primarySession;
      scbSceneContainer.primarySession.isTopmost = false;
      totalContainerSessionList.push(scbSceneContainer);
      totalContainerSessionList.push(scbSceneContainer);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun)().afterReturn(totalContainerSessionList);
      (recentEnterAnimations as object)['currentIdx'] = 1;
      (recentEnterAnimations as object)['updateMultiRowEnterIndex'](false, false);
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('updateSingleRowEnterIndex_test_01', 0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      (scbSceneContainer as object)['_isActive'] = true;
      scbSceneContainer.primarySession = primarySession;
      scbSceneContainer.primarySession.isTopmost = false;
      totalContainerSessionList.push(scbSceneContainer);
      totalContainerSessionList.push(scbSceneContainer);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun)().afterReturn(totalContainerSessionList);
      (recentEnterAnimations as object)['currentIdx'] = 1;
      (recentEnterAnimations as object)['updateSingleRowEnterIndex'](true, false);
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('updateEnterIdx_test_01', 0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      (scbSceneContainer as object)['_isActive'] = true;
      scbSceneContainer.primarySession = primarySession;
      scbSceneContainer.primarySession.isTopmost = false;
      totalContainerSessionList.push(scbSceneContainer);
      totalContainerSessionList.push(scbSceneContainer);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      let mockFun1 =
        mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(totalContainerSessionList);
      when(mockFun1)().afterReturn(false);
      (recentEnterAnimations as object)['currentIdx'] = 1;
      (recentEnterAnimations as object)['updateEnterIdx'](true, false);
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('initNotCurrentContainerSession_test_01', 0, (): void => {
      (recentEnterAnimations as object)['initNotCurrentContainerSession']();
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('initCurrentContainerSession_test_01', 0, (): void => {
      (recentEnterAnimations as object)['initCurrentContainerSession'](scbSceneContainer);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('setEnterAppIdleAnimationParams_test_0002', 0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      (scbSceneContainer as object)['_isActive'] = true;
      (recentEnterAnimations as object)['enterStartIdx'] = 0;
      (recentEnterAnimations as object)['enterEndIdx'] = 1;
      scbSceneContainer.primarySession = primarySession;
      scbSceneContainer.primarySession.isTopmost = false;
      totalContainerSessionList.push(scbSceneContainer);
      totalContainerSessionList.push(scbSceneContainer);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun)().afterReturn(totalContainerSessionList);
      (recentEnterAnimations as object)['setEnterAppIdleAnimationParams'](0);
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('setEnterAppIdleAnimationParams_test_0003', 0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      (scbSceneContainer as object)['_isActive'] = true;
      (recentEnterAnimations as object)['enterStartIdx'] = 0;
      (recentEnterAnimations as object)['enterEndIdx'] = 1;
      scbSceneContainer.primarySession = primarySession;
      scbSceneContainer.primarySession.isTopmost = false;
      totalContainerSessionList.push(scbSceneContainer);
      totalContainerSessionList.push(scbSceneContainer);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun)().afterReturn(totalContainerSessionList);
      (recentEnterAnimations as object)['setEnterAppIdleAnimationParams'](9);
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('setEnterAppIdleAnimationParams_test_0004', 0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      (scbSceneContainer as object)['_isActive'] = true;
      (recentEnterAnimations as object)['enterStartIdx'] = 0;
      (recentEnterAnimations as object)['enterEndIdx'] = 1;
      scbSceneContainer.primarySession = primarySession;
      scbSceneContainer.primarySession.isTopmost = false;
      totalContainerSessionList.push(scbSceneContainer);
      totalContainerSessionList.push(scbSceneContainer);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun)().afterReturn(totalContainerSessionList);
      (recentEnterAnimations as object)['setEnterAppIdleAnimationParams'](1);
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('startSingleRowDropAnimation_test_0001', 0, (): void => {
      let screenProperty = new SCBScreenProperty();
      screenProperty.width = 100;
      screenProperty.height = 100;
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentEnterAnimations: RecentEnterAnimations = new RecentEnterAnimations(scenePanelManager);
      let x: number = 0;
      let recentEnterCallback: RecentEnterCallback = {
        onFinish: (animationNum: number, isFromNavigationCallback: boolean): void => {
          x = x + 1;
        }
      }
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.push(scbSceneContainer);
      totalContainerSessionList.push(scbSceneContainer);
      totalContainerSessionList.push(scbSceneContainer);
      (recentEnterAnimations as object)['enterStartIdx'] = 0;
      (recentEnterAnimations as object)['enterEndIdx'] = 1;
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getScreenProperty);
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun)().afterReturn(scbScreenProperty);
      when(mockFun1)().afterReturn(totalContainerSessionList);
      (recentEnterAnimations as object)['startSingleRowDropAnimation'](true, true, false, recentEnterCallback);
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getScreenProperty);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('startSingleRowDropAnimation_test_0002', 0, (): void => {
      let x: number = 0;
      let recentEnterCallback: RecentEnterCallback = {
        onFinish: (animationNum: number, isFromNavigationCallback: boolean): void => {
          x = x + 1;
        }
      }
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let needRenderShowInRecent1: NeedRenderShowInRecent = new NeedRenderShowInRecent();
      (scbSceneContainer as object)['_showInRecent'] = false;
      (needRenderShowInRecent1 as object)['_isActive'] = true;
      (recentEnterAnimations as object)['enterStartIdx'] = 0;
      (recentEnterAnimations as object)['enterEndIdx'] = 1;
      (recentEnterAnimations as object)['_isActive'] = false;
      scbSceneContainer.primarySession = primarySession;
      scbSceneContainer.primarySession.isTopmost = false;
      scbSceneContainer.needRenderShowInRecent = needRenderShowInRecent1;
      totalContainerSessionList.push(scbSceneContainer);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun)().afterReturn(totalContainerSessionList);
      (recentEnterAnimations as object)['startSingleRowDropAnimation'](true, true, false, recentEnterCallback);
      expect(recentEnterAnimations).not().assertUndefined();
      (recentEnterAnimations as object)['_isActive'] = true;
      (recentEnterAnimations as object)['startSingleRowDropAnimation'](false, true, true, recentEnterCallback);
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('startSingleRowDropAnimation_test_0003', 0, (): void => {
      let x: number = 0;
      let recentEnterCallback: RecentEnterCallback = {
        onFinish: (animationNum: number, isFromNavigationCallback: boolean): void => {
          x = x + 1;
        }
      }
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let needRenderShowInRecent1: NeedRenderShowInRecent = new NeedRenderShowInRecent();
      (scbSceneContainer as object)['_showInRecent'] = false;
      (needRenderShowInRecent1 as object)['_isActive'] = true;
      (recentEnterAnimations as object)['enterStartIdx'] = 0;
      (recentEnterAnimations as object)['enterEndIdx'] = 1;
      (recentEnterAnimations as object)['_isActive'] = false;
      scbSceneContainer.primarySession = primarySession;
      scbSceneContainer.primarySession.isTopmost = false;
      scbSceneContainer.needRenderShowInRecent = needRenderShowInRecent1;
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun)().afterReturn(totalContainerSessionList);
      (recentEnterAnimations as object)['startSingleRowDropAnimation'](true, true, false, recentEnterCallback);
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('startSingleRowDropAnimation_test_0004', 0, (): void => {
      let x: number = 0;
      let recentEnterCallback: RecentEnterCallback = {
        onFinish: (animationNum: number, isFromNavigationCallback: boolean): void => {
          x = x + 1;
        }
      }
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.push(scbSceneContainer);
      totalContainerSessionList.push(scbSceneContainer);
      totalContainerSessionList.push(scbSceneContainer);
      (recentEnterAnimations as object)['enterStartIdx'] = 0;
      (recentEnterAnimations as object)['enterEndIdx'] = 1;
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getScreenProperty);
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun)().afterReturn(scbScreenProperty);
      when(mockFun1)().afterReturn(totalContainerSessionList);
      let isScreenVertical =
        mock.mockFunc(scbScreenProperty, scbScreenProperty.isScreenVertical);
      when(isScreenVertical)().afterReturn(true);
      let getFloatingSessionListForView =
        mock.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionListForView);
      when(getFloatingSessionListForView)().afterReturn(totalContainerSessionList);
      (recentEnterAnimations as object)['startSingleRowDropAnimation'](false, true, true, recentEnterCallback);
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getScreenProperty);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      mock.ignoreMock(scbScreenProperty, scbScreenProperty.isScreenVertical);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getFloatingSessionListForView);
    })

    it('prepareToFarAwayFollowingAnimate_test_01', 0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.push(scbSceneContainer);
      totalContainerSessionList.push(scbSceneContainer);
      totalContainerSessionList.push(scbSceneContainer);
      (recentEnterAnimations as object)['isNewStyle'] = true;
      (recentEnterAnimations as object)['followingStartIdx'] = 0;
      (recentEnterAnimations as object)['followingEndIdx'] = 4;
      let mock = new MockKit();
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun1)().afterReturn(totalContainerSessionList);
      recentEnterAnimations.prepareToFarAwayFollowingAnimate(event, 0.5);
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('prepareToFarAwayFollowingAnimate_test_02', 0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.push(scbSceneContainer);
      totalContainerSessionList.push(scbSceneContainer);
      totalContainerSessionList.push(scbSceneContainer);
      (recentEnterAnimations as object)['isNewStyle'] = false;
      (recentEnterAnimations as object)['followingStartIdx'] = 0;
      (recentEnterAnimations as object)['followingEndIdx'] = 4;
      let mock = new MockKit();
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun1)().afterReturn(totalContainerSessionList);
      recentEnterAnimations.prepareToFarAwayFollowingAnimate(event, 0.5);
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('getFinalOffsetXForScroll_test_01', 0, (): void => {
      let mock = new MockKit();
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun1)().afterReturn(totalContainerSessionList);
      let isNeedMultiRowLayout: Function =
        mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(true);
      let recentLayoutCalculator = RecentLayoutCalculatorFactory.getRecentLayoutCalculatorInstance(scenePanelManager);
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentEnterAnimations.getFinalOffsetXForScroll(false, false, recentLayoutCalculator);
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('getFinalOffsetXForScroll_test_02', 0, (): void => {
      let mock = new MockKit();
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun1)().afterReturn(totalContainerSessionList);
      let isNeedMultiRowLayout: Function =
        mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)().afterReturn(false);
      let recentLayoutCalculator = RecentLayoutCalculatorFactory.getRecentLayoutCalculatorInstance(scenePanelManager);
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentEnterAnimations.getFinalOffsetXForScroll(true, true, recentLayoutCalculator);
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('enterAppFromRecentFollowing_test_01', 0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.push(scbSceneContainer);
      totalContainerSessionList.push(scbSceneContainer);
      totalContainerSessionList.push(scbSceneContainer);
      (scbSceneContainer as object)['_isActive'] = false;
      let mock = new MockKit();
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun1)().afterReturn(totalContainerSessionList);
      recentEnterAnimations.enterAppFromRecentFollowing();
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('enterAppFromRecentFollowing_test_02', 0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.push(scbSceneContainer);
      totalContainerSessionList.push(scbSceneContainer);
      totalContainerSessionList.push(scbSceneContainer);
      (scbSceneContainer as object)['_isActive'] = true;
      let mock = new MockKit();
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun1)().afterReturn(totalContainerSessionList);
      recentEnterAnimations.enterAppFromRecentFollowing();
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('enterHomeFromRecentFollowingAnimation_test_01', 0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.push(scbSceneContainer);
      totalContainerSessionList.push(scbSceneContainer);
      totalContainerSessionList.push(scbSceneContainer);
      (scbSceneContainer as object)['_isActive'] = false;
      (recentEnterAnimations as object)['followingStartIdx'] = 0;
      (recentEnterAnimations as object)['followingEndIdx'] = 3;
      (recentEnterAnimations as object)['currentIdx'] = 2;
      let mock = new MockKit();
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun1)().afterReturn(totalContainerSessionList);
      recentEnterAnimations.enterHomeFromRecentFollowingAnimation();
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('enterHomeFromRecentFollowingAnimation_test_02', 0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.push(scbSceneContainer);
      totalContainerSessionList.push(scbSceneContainer);
      totalContainerSessionList.push(scbSceneContainer);
      let tempScbSceneContainer: SCBSceneContainerSession =
        new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
      tempScbSceneContainer.needRenderShowInRecent.setShowInRecentWithDfx(false,
        'enterHomeFromRecentFollowingAnimation_test_02', 'test');
      totalContainerSessionList.push(tempScbSceneContainer);
      (scbSceneContainer as object)['_isActive'] = false;
      (recentEnterAnimations as object)['followingStartIdx'] = 0;
      (recentEnterAnimations as object)['followingEndIdx'] = 3;
      (recentEnterAnimations as object)['currentIdx'] = 3;
      let mock = new MockKit();
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun1)().afterReturn(totalContainerSessionList);
      recentEnterAnimations.enterHomeFromRecentFollowingAnimation();
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('recordStartEnterRecentLogs_test_01', 0, (): void => {
      recentEnterAnimations.recordStartEnterRecentLogs(true);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('recordStartEnterRecentLogs_test_02', 0, (): void => {
      recentEnterAnimations.recordStartEnterRecentLogs(false);
      expect(recentEnterAnimations).not().assertUndefined();
    })

    it('recordEndEnterRecentLogs_test_01', 0, (): void => {
      let mock = new MockKit();
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun1)().afterReturn(new SCBSceneContainerSessionArray());
      recentEnterAnimations.recordEndEnterRecentLogs();
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
    })

    it('recordEndEnterRecentLogs_test_02', 0, (): void => {
      let mock = new MockKit();
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      when(mockFun1)().afterReturn(totalContainerSessionList);
      let getNotShowRecentList =
        mock.mockFunc(scenePanelManager, scenePanelManager.getNotShowRecentList);
      when(getNotShowRecentList)().afterReturn(totalContainerSessionList);
      recentEnterAnimations.recordEndEnterRecentLogs();
      expect(recentEnterAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionListForView);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getNotShowRecentList);
    })
  })
}
