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
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneInfo,
  SCBScenePanelManager,
  SCBSceneSession,
  SCBScreenProperty
} from '@ohos/windowscene';
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  QuickSwitchAnimations
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/quickswitchpanel/QuickSwitchAnimations';
import {
  RecentNotShow
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentNotShow';
import screenSessionManager from '@ohos.screenSessionManager';
import { AnimateExArgsType } from '@ohos/windowscene/Index';

export default function QuickSwitchAnimationsTest() {
  describe('QuickSwitchAnimationsTest', (): void => {
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
    let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
    let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName1', 'moduleName1', 'abilityName1');
    let primarySession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
    let scbSceneContainer: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
    let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
    totalContainerSessionList.add(scbSceneContainer);
    let secondScbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName2', 'moduleName2', 'abilityName2');
    let secondPrimarySession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(secondScbSceneInfo), secondScbSceneInfo);
    let secondScbSceneContainer2: SCBSceneContainerSession = new SCBSceneContainerSession(secondPrimarySession, new SCBScreenProperty());
    totalContainerSessionList.add(secondScbSceneContainer2);
    let screenProp1: screenSessionManager.ScreenProperty = {
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
    let scbScreenProperty1: SCBScreenProperty = new SCBScreenProperty();
    scbScreenProperty1.update(screenProp1);

    it('QuickSwitchAnimations_setVisibilityWhenFoldStatusChange_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      quickSwitchAnimations.setVisibilityWhenFoldStatusChange(totalContainerSessionList);
      expect(totalContainerSessionList[0]?.needRenderTranslate.translateX).assertEqual(0);
    })

    it('QuickSwitchAnimations_init_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      quickSwitchAnimations.init();
      expect(totalContainerSessionList[0]?.needRenderShowInRecent.showInRecent).assertEqual(false);
    })

    it('QuickSwitchAnimations_updateParmForFollowing_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      quickSwitchAnimations.updateParmForFollowing(0);
      expect(totalContainerSessionList[0]?.needRenderScale.scaleX).assertEqual(1);
    })

    it('QuickSwitchAnimations_initSessionsForUpdate_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      quickSwitchAnimations.initSessionsForUpdate(scbSceneContainer, 0, 0);
      expect(scbSceneContainer.needRenderVisibility.visibility).assertEqual(true);
    })

    it('QuickSwitchAnimations_createEnterQuickSwitchIdleAnimation_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let secondScbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName2', 'moduleName2', 'abilityName2');
      let secondPrimarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(secondScbSceneInfo), secondScbSceneInfo);
      let secondScbSceneContainer: SCBSceneContainerSession =
        new SCBSceneContainerSession(secondPrimarySession, new SCBScreenProperty());
      (secondScbSceneContainer as object)['isNewStyle'] = true;
      (quickSwitchAnimations as object)['createEnterQuickSwitchIdleAnimation']();
      expect(secondScbSceneContainer).not().assertUndefined();
    })

    it('QuickSwitchAnimations_createEnterQuickSwitchIdleAnimation_test02', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let secondScbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName2', 'moduleName2', 'abilityName2');
      let secondPrimarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(secondScbSceneInfo), secondScbSceneInfo);
      let secondScbSceneContainer: SCBSceneContainerSession =
        new SCBSceneContainerSession(secondPrimarySession, new SCBScreenProperty());
      (secondScbSceneContainer as object)['isNewStyle'] = false;
      (quickSwitchAnimations as object)['createEnterQuickSwitchIdleAnimation']();
      expect(secondScbSceneContainer).not().assertUndefined();
    })

    it('QuickSwitchAnimations_setVisibilityWhenFoldStatusChange_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let res: object = (quickSwitchAnimations as object)['setVisibilityWhenFoldStatusChange']();
      expect(res === null).assertFalse();
    })

    it('QuickSwitchAnimations_setVisibilityWhenFoldStatusChange_test02', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let secondScbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName2', 'moduleName2', 'abilityName2');
      let secondPrimarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(secondScbSceneInfo), secondScbSceneInfo);
      let secondScbSceneContainer: SCBSceneContainerSession =
        new SCBSceneContainerSession(secondPrimarySession, new SCBScreenProperty());
      (secondScbSceneContainer as object)['_isActive'] = false;
      let res = quickSwitchAnimations.setVisibilityWhenFoldStatusChange(totalContainerSessionList);
      expect(res === null).assertFalse();
    })

    it('QuickSwitchAnimations_setVisibilityWhenFoldStatusChange_test03', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let res = quickSwitchAnimations.setVisibilityWhenFoldStatusChange(totalContainerSessionList);
      expect(res === null).assertFalse();
    })

    it('QuickSwitchAnimations_sceneContainerTransitionForQuickSwitch_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      (quickSwitchAnimations as object)['sceneContainerTransitionForQuickSwitch']();
      expect(quickSwitchAnimations).not().assertUndefined();
    })

    it('QuickSwitchAnimations_enterAppFromQuickSwitchFollowing_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      quickSwitchAnimations.enterAppFromQuickSwitchFollowing(2);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSession);
      when(mockFun)().afterReturn(false);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSession);
    })

    it('QuickSwitchAnimations_enterAppFromQuickSwitchFollowing_test02', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      quickSwitchAnimations.enterAppFromQuickSwitchFollowing(2);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSession);
      when(mockFun)().afterReturn(true);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSession);
    })

    it('QuickSwitchAnimations_enterSwitchView_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      quickSwitchAnimations.enterSwitchView(true, 1, 2, (...args: AnimateExArgsType[]) => {
      });
      expect(quickSwitchAnimations).not().assertUndefined();
    })

    it('QuickSwitchAnimations_enterSwitchView_test02', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      quickSwitchAnimations.enterSwitchView(false, 1, 2, (...args: AnimateExArgsType[]) => {
      });
      expect(quickSwitchAnimations).not().assertUndefined();
    })

    it('QuickSwitchAnimations_setContainerSessionScale_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      (quickSwitchAnimations as object)['setContainerSessionScale']();
      expect(quickSwitchAnimations).not().assertUndefined();
    })

    it('QuickSwitchAnimations_setContainerSessionScale_test02', 0, (): void => {
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName1', 'moduleName1', 'abilityName1');
      let primarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let scbSceneContainer: SCBSceneContainerSession =
        new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
      (quickSwitchAnimations as object)['setContainerSessionScale'](scbSceneContainer, 1, 2);
      expect(quickSwitchAnimations).not().assertUndefined();
    })

    it('QuickSwitchAnimations_setContainerSessionTrans_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      (quickSwitchAnimations as object)['setContainerSessionTrans']();
      expect(quickSwitchAnimations).not().assertUndefined();
    })

    it('QuickSwitchAnimations_setContainerSessionTrans_test02', 0, (): void => {
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName1', 'moduleName1', 'abilityName1');
      let primarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let scbSceneContainer: SCBSceneContainerSession =
        new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
      (quickSwitchAnimations as object)['setContainerSessionTrans'](scbSceneContainer, 1, 2);
      expect(quickSwitchAnimations).not().assertUndefined();
    })

    it('QuickSwitchAnimations_init_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      (quickSwitchAnimations as object)['init']();
      expect(quickSwitchAnimations).not().assertUndefined();
    })

    it('QuickSwitchAnimations_init_test02', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      quickSwitchAnimations.init();
      expect(quickSwitchAnimations).not().assertUndefined();
    })

    it('QuickSwitchAnimations_updateParmForFollowing_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      (quickSwitchAnimations as object)['updateParmForFollowing']();
      expect(quickSwitchAnimations).not().assertUndefined();
    })

    it('QuickSwitchAnimations_interruptAllContainerAnimations_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      (quickSwitchAnimations as object)['interruptAllContainerAnimations']();
      expect(quickSwitchAnimations).not().assertUndefined();
    })

    it('QuickSwitchAnimations_interruptAllContainerAnimations_test02', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      quickSwitchAnimations.interruptAllContainerAnimations();
      expect(quickSwitchAnimations).not().assertUndefined();
    })

    it('QuickSwitchAnimations_interruptOtherContainerAnimations_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      (quickSwitchAnimations as object)['interruptOtherContainerAnimations']();
      expect(quickSwitchAnimations).not().assertUndefined();
    })

    it('QuickSwitchAnimations_interruptOtherContainerAnimations_test02', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      quickSwitchAnimations.interruptOtherContainerAnimations();
      expect(quickSwitchAnimations).not().assertUndefined();
    })

    it('QuickSwitchAnimations_updateSwitchViewFromApp_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      quickSwitchAnimations.updateSwitchViewFromApp(event);
      expect(quickSwitchAnimations).not().assertUndefined();
    })

    it('QuickSwitchAnimations_initSessionsForUpdate_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      (quickSwitchAnimations as object)['initSessionsForUpdate']();
      expect(quickSwitchAnimations).not().assertUndefined();
    })

    it('QuickSwitchAnimations_initSessionsForUpdate_test02', 0, (): void => {
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName1', 'moduleName1', 'abilityName1');
      let primarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let scbSceneContainer: SCBSceneContainerSession =
        new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      quickSwitchAnimations.initSessionsForUpdate(scbSceneContainer, 1, 2);
      expect(quickSwitchAnimations).not().assertUndefined();
    })

    it('QuickSwitchAnimations_interruptQuickSwitchAnimationWhenExitApp_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      quickSwitchAnimations.interruptQuickSwitchAnimationWhenExitApp(-1);
      expect(quickSwitchAnimations).not().assertUndefined();
    })

    it('QuickSwitchAnimations_prepareContainerSession_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      (quickSwitchAnimations as object)['prepareContainerSession']();
      expect(quickSwitchAnimations).not().assertUndefined();
    })

    it('QuickSwitchAnimations_prepareContainerSession_test02', 0, (): void => {
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName1', 'moduleName1', 'abilityName1');
      let primarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let scbSceneContainer: SCBSceneContainerSession =
        new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
      (scbSceneContainer as object)['_isActive'] = true;
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      (quickSwitchAnimations as object)['prepareContainerSession'](1, scbSceneContainer);
      expect(quickSwitchAnimations).not().assertUndefined();
    })

    it('QuickSwitchAnimations_prepareContainerSession_test03', 0, (): void => {
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName1', 'moduleName1', 'abilityName1');
      let primarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let scbSceneContainer: SCBSceneContainerSession =
        new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
      (scbSceneContainer as object)['_isActive'] = false;
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      (quickSwitchAnimations as object)['prepareContainerSession'](1, scbSceneContainer);
      expect(quickSwitchAnimations).not().assertUndefined();
    })

    it('QuickSwitchAnimations_restoreContainerSessionIfNeed_test01', 0, (): void => {
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName1', 'moduleName1', 'abilityName1');
      let primarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let scbSceneContainer: SCBSceneContainerSession =
        new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
      scenePanelManager.addSceneContainerSession(scbSceneContainer);
      (scbSceneContainer as object)['_isActive'] = false;
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      (quickSwitchAnimations as object)['restoreContainerSessionIfNeed']();
      expect(quickSwitchAnimations).not().assertUndefined();
    })

    it('QuickSwitchAnimations_updateIdx_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(0);
      (quickSwitchAnimations as object)['updateIdx'](true);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
    })

    it('QuickSwitchAnimations_updateIdx_test02', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(20);
      (quickSwitchAnimations as object)['updateIdx'](true);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
    })

    it('QuickSwitchAnimations_updateIdx_test03', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(20);
      (quickSwitchAnimations as object)['updateIdx'](false);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
    })

    it('QuickSwitchAnimations_getQuickSwitchToContainer_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(-1);
      quickSwitchAnimations.getQuickSwitchToContainer(1);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
    })

    it('QuickSwitchAnimations_getQuickSwitchToContainer_test02', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(1);
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(false);
      quickSwitchAnimations.getQuickSwitchToContainer(1);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
    })

    it('QuickSwitchAnimations_getQuickSwitchToContainer_test03', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(1);
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(true);
      quickSwitchAnimations.getQuickSwitchToContainer(1);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
    })

    it('QuickSwitchAnimations_getQuickSwitchToContainer_test04', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(1);
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(true);
      quickSwitchAnimations.getQuickSwitchToContainer(-1);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
    })

    it('QuickSwitchAnimations_getQuickSwitchToContainer_test05', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(1);
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(true);
      quickSwitchAnimations.getQuickSwitchToContainer(100);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
    })

    it('QuickSwitchAnimations_getQuickSwitchToContainer_test06', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(1);
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(true);
      quickSwitchAnimations.getQuickSwitchToContainer(150);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
    })

    it('QuickSwitchAnimations_getQuickSwitchToContainer_test07', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(1);
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(true);
      quickSwitchAnimations.getQuickSwitchToContainer(180);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
    })

    it('QuickSwitchAnimations_getQuickSwitchToContainer_test08', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(1);
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(true);
      quickSwitchAnimations.getQuickSwitchToContainer(200);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
    })

    it('QuickSwitchAnimations_getQuickSwitchToContainer_test09', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(1);
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(true);
      quickSwitchAnimations.getQuickSwitchToContainer(210);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
    })

    it('QuickSwitchAnimations_getQuickSwitchToContainer_test10', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(1);
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(true);
      quickSwitchAnimations.getQuickSwitchToContainer(220);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
    })

    it('QuickSwitchAnimations_getQuickSwitchToContainer_test11', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(1);
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(true);
      quickSwitchAnimations.getQuickSwitchToContainer(230);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
    })

    it('QuickSwitchAnimations_getQuickSwitchToContainer_test12', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(1);
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(true);
      quickSwitchAnimations.getQuickSwitchToContainer(240);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
    })

    it('QuickSwitchAnimations_getQuickSwitchToContainer_test13', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(1);
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(true);
      quickSwitchAnimations.getQuickSwitchToContainer(260);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
    })

    it('QuickSwitchAnimations_getQuickSwitchToContainer_test14', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(1);
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(true);
      quickSwitchAnimations.getQuickSwitchToContainer(280);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
    })

    it('QuickSwitchAnimations_getQuickSwitchToContainer_test15', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(1);
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(true);
      quickSwitchAnimations.getQuickSwitchToContainer(300);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
    })

    it('QuickSwitchAnimations_getQuickSwitchToContainer_test16', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(1);
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(true);
      quickSwitchAnimations.getQuickSwitchToContainer(320);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
    })

    it('QuickSwitchAnimations_getQuickSwitchToContainer_test17', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(1);
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(true);
      quickSwitchAnimations.getQuickSwitchToContainer(360);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
    })

    it('QuickSwitchAnimations_getQuickSwitchToContainer_test18', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(1);
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(true);
      quickSwitchAnimations.getQuickSwitchToContainer(380);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
    })

    it('QuickSwitchAnimations_getQuickSwitchToContainer_test19', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(1);
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(true);
      quickSwitchAnimations.getQuickSwitchToContainer(400);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
    })

    it('QuickSwitchAnimations_getQuickSwitchToContainer_test20', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(1);
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(true);
      quickSwitchAnimations.getQuickSwitchToContainer(420);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
    })

    it('QuickSwitchAnimations_getQuickSwitchToContainer_test21', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(1);
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(true);
      quickSwitchAnimations.getQuickSwitchToContainer(430);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
    })

    it('QuickSwitchAnimations_getQuickSwitchToContainer_test22', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(1);
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(true);
      quickSwitchAnimations.getQuickSwitchToContainer(450);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
    })

    it('QuickSwitchAnimations_getQuickSwitchToContainer_test23', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(1);
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(true);
      quickSwitchAnimations.getQuickSwitchToContainer(460);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
    })

    it('QuickSwitchAnimations_getQuickSwitchToContainer_test24', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(1);
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(true);
      quickSwitchAnimations.getQuickSwitchToContainer(480);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
    })

    it('QuickSwitchAnimations_getQuickSwitchToContainer_test25', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(1);
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(true);
      quickSwitchAnimations.getQuickSwitchToContainer(500);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
    })

    it('QuickSwitchAnimations_getQuickSwitchToContainer_test26', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(1);
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(true);
      quickSwitchAnimations.getQuickSwitchToContainer(520);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
    })

    it('QuickSwitchAnimations_getQuickSwitchToContainer_test27', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(1);
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(true);
      quickSwitchAnimations.getQuickSwitchToContainer(550);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
    })

    it('QuickSwitchAnimations_getQuickSwitchToContainer_test28', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(1);
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(true);
      quickSwitchAnimations.getQuickSwitchToContainer(560);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
    })

    it('QuickSwitchAnimations_getQuickSwitchToContainer_test29', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(1);
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(true);
      quickSwitchAnimations.getQuickSwitchToContainer(580);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
    })

    it('QuickSwitchAnimations_getQuickSwitchToContainer_test30', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(1);
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(true);
      quickSwitchAnimations.getQuickSwitchToContainer(600);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
    })

    it('QuickSwitchAnimations_getQuickSwitchToContainer_test31', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(1);
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(true);
      quickSwitchAnimations.getQuickSwitchToContainer(620);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
    })

    it('QuickSwitchAnimations_getQuickSwitchToContainer_test32', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(1);
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(true);
      quickSwitchAnimations.getQuickSwitchToContainer(640);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
    })

    it('QuickSwitchAnimations_getQuickSwitchToContainer_test33', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(1);
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(true);
      quickSwitchAnimations.getQuickSwitchToContainer(660);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
    })

    it('QuickSwitchAnimations_getQuickSwitchToContainer_test34', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      when(mockFun)().afterReturn(1);
      let mockFun1 =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(true);
      quickSwitchAnimations.getQuickSwitchToContainer(680);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSessionIndex);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().isInRange);
    })

    it('createEnterQuickSwitchIdleAnimation_test01', 0, (): void => {
      (quickSwitchAnimations as object)['isNewStyle'] = true;
      (quickSwitchAnimations as object)['createEnterQuickSwitchIdleAnimation']();
      expect(quickSwitchAnimations).not().assertUndefined();
    })

    it('enterSwitchView_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      scbSceneContainer.isMidScene = true;
      scbSceneContainer.isSplit = true;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopSession);
      when(mockFun)().afterReturn(scbSceneContainer);
      quickSwitchAnimations.enterSwitchView(false, 1, 2, (...args: AnimateExArgsType[]) => {
      });
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopSession);
      mock.clearAll();
    })

    it('setVisibilityWhenFoldStatusChange_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let needRenderShowInRecent: NeedRenderShowInRecent = new NeedRenderShowInRecent();
      (needRenderShowInRecent as object)['_showInRecent'] = true;
      scbSceneContainer.needRenderShowInRecent = needRenderShowInRecent;
      (scbSceneContainer as object)['_isActive'] = false;
      quickSwitchAnimations.setVisibilityWhenFoldStatusChange(totalContainerSessionList);
      expect(scenePanelManager).not().assertUndefined();
    })

    it('sceneContainerTransitionForQuickSwitch_test03', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      (quickSwitchAnimations as object)['sceneContainerTransitionForQuickSwitch'](null, scbSceneContainer);
      expect(quickSwitchAnimations).not().assertUndefined();
    })

    it('enterAppFromQuickSwitchFollowing_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      let mock = new MockKit();
      let mockFun =
        mock.mockFunc(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSession);
      when(mockFun)().afterReturn(scbSceneContainer);
      quickSwitchAnimations.enterAppFromQuickSwitchFollowing(2);
      expect(quickSwitchAnimations).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getSceneContainerSessionList().getTopActiveSession);
    })

    it('interruptAllContainerAnimations_test03', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      (quickSwitchAnimations as object)['startIndex'] = 0;
      (quickSwitchAnimations as object)['endIndex'] = 3;
      (quickSwitchAnimations as object)['currentIdx'] = 2;
      quickSwitchAnimations.interruptAllContainerAnimations();
      expect(quickSwitchAnimations).not().assertUndefined();
    })

    it('initSessionsForUpdate_test_01', 0, (): void => {
      (quickSwitchAnimations as object)['initSessionsForUpdate'](0, 0);
      expect(quickSwitchAnimations).not().assertUndefined();
    })

    it('restoreContainerSessionIfNeed_test01', 0, (): void => {
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName1', 'moduleName1', 'abilityName1');
      let primarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let scbSceneContainer: SCBSceneContainerSession =
        new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
      scenePanelManager.addSceneContainerSession(scbSceneContainer);
      (scbSceneContainer as object)['_isActive'] = true;
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      (quickSwitchAnimations as object)['restoreContainerSessionIfNeed']();
      expect(quickSwitchAnimations).not().assertUndefined();
    })

    it('removeNotShowSession_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      (quickSwitchAnimations as object)['startIndex'] = 0;
      (quickSwitchAnimations as object)['endIndex'] = 3;
      (quickSwitchAnimations as object)['currentIdx'] = 2;
      let recentNotShow = new RecentNotShow(scenePanelManager);
      quickSwitchAnimations.removeNotShowSession(recentNotShow);
      expect(quickSwitchAnimations).not().assertUndefined();
    })

    it('removeNotShowSession_test02', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      (quickSwitchAnimations as object)['startIndex'] = 0;
      (quickSwitchAnimations as object)['endIndex'] = 3;
      (quickSwitchAnimations as object)['currentIdx'] = -1;
      let recentNotShow = new RecentNotShow(scenePanelManager);
      quickSwitchAnimations.removeNotShowSession(recentNotShow);
      expect(quickSwitchAnimations).not().assertUndefined();
    })

    it('removePendingRemoveSessions_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      quickSwitchAnimations.removePendingRemoveSessions();
      expect(quickSwitchAnimations).not().assertUndefined();
    })

    it('getFinalRecentW_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      quickSwitchAnimations.getFinalRecentW();
      expect(quickSwitchAnimations).not().assertUndefined();
    })

    it('getRecentTranslateX_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      quickSwitchAnimations.getRecentTranslateX();
      expect(quickSwitchAnimations).not().assertUndefined();
    })

    it('getRecentWidth_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty1);
      let quickSwitchAnimations: QuickSwitchAnimations = new QuickSwitchAnimations(scenePanelManager);
      quickSwitchAnimations.getRecentWidth(0, scbScreenProperty1, 0);
      expect(quickSwitchAnimations).not().assertUndefined();
    })
  })
}