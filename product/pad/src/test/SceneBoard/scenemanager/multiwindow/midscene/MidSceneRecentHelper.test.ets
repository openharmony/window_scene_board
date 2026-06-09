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
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneSession,
  SCBScreenProperty
} from '@ohos/windowscene';

import { describe, it, Level, expect, MockKit, when, ArgumentMatchers, beforeEach, afterEach } from '@ohos/hypium';
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  SCBMidSceneCallback,
  UIConfig
} from '../../../../../main/ets/SceneBoard/scenemanager/midscene/SCBMidSceneCallback';
import { MidSceneFSM } from '../../../../../main/ets/SceneBoard/scenemanager/midscene/MidSceneFSM';
import {
  MidSceneData,
  MidSceneExitReason,
  MidSceneStep
} from '../../../../../main/ets/SceneBoard/scenemanager/midscene/MidSceneData';
import { RecentLayoutManager } from '../../../../../main/ets/SceneBoard/recent/common/RecentLayoutManager';
import { ReflectionUtils } from '../ReflectionUtils';
import { MidSceneManager } from '../../../../../main/ets/SceneBoard/scenemanager/midscene/MidSceneManager';
import {
  MidSceneGestureType
} from '../../../../../main/ets/SceneBoard/scenemanager/midscene/MidSceneRecentHelper';

let screenProperty: SCBScreenProperty = new SCBScreenProperty();
let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
let session: sceneSessionManager.SceneSession = sceneSessionManager.requestSceneSession({
  bundleName: sceneInfo.bundleName,
  moduleName: sceneInfo.moduleName,
  abilityName: sceneInfo.abilityName,
  appIndex: sceneInfo.appIndex,
  persistentId: sceneInfo.persistentId,
  screenId: sceneInfo.screenId
}, sceneInfo.want);
let scbSceneSession: SCBSceneSession = new SCBSceneSession(session, sceneInfo);
let primarySession: SCBSceneSession =
  new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
let container: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
let mocker: MockKit = new MockKit();
let midSceneManager = MidSceneManager.getInstance(screenProperty);
let midSceneData0: MidSceneData = new MidSceneData(28);
let midSceneData1: MidSceneData = new MidSceneData(29);
let midSceneData2: MidSceneData = new MidSceneData(30);
let callback: SCBMidSceneCallback = {
  toStable(): void {
  },
  exitFromUnstable(reason: MidSceneExitReason): void {
  },
  toWaitingAdd(isInMidScene: boolean): void {
  },
  toWaitingReplace(): void {
  },
  addFromIcon(session: SCBSceneSession): void {
  },
  addFromOther(session: SCBSceneSession): void {
  },
  replaceInFilledState(session: SCBSceneSession): void {
  },
  toNonMidScene():void{

  },
  getUIConfig(): UIConfig {
    return new UIConfig()
  },
};
(container.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container, callback);
let midSceneContext = (container.sessionData.midSceneFSM as MidSceneFSM).context;

let initAll = () => {
  screenProperty.width = 2224;
  screenProperty.height = 2224;
  container.isMidScene = true;
  container.midSceneMap.set(28, scbSceneSession);
  container.midSceneMap.set(29, scbSceneSession);
  container.midSceneMap.set(30, scbSceneSession);
  midSceneContext.l2r = [];
  midSceneContext.l2r.push(midSceneData0);
  midSceneContext.l2r.push(midSceneData1);
  midSceneContext.l2r.push(midSceneData2);
  midSceneContext.anchorIndex = 1;
  midSceneData0.inclined = true;
  midSceneData1.inclined = false;
  midSceneData2.inclined = true;
  midSceneData0.step = MidSceneStep.SMALL;
  midSceneData1.step = MidSceneStep.LARGE;
  midSceneData2.step = MidSceneStep.SMALL;
}


export default function MidSceneRecentHelperTest() {
  describe('MidSceneRecentHelperTest', (): void => {
    beforeEach((): void => {
      initAll();
      let midSceneManagerFunc: Function = mocker.mockFunc(midSceneManager, midSceneManager.isSupportMidScene);
      when(midSceneManagerFunc)(ArgumentMatchers.any).afterReturn(true);
    });
    afterEach((): void => {
      mocker.clear(midSceneManager);
    });
    notifyFollowHandTest_01();
    notifyFollowHandCancelTest_01();
    notifyEnterRecentTest_01();
    notifyEnterRecentTest_02();
    notifyEnterDesktopStartTest_01();
    notifyEnterDesktopFinishTest_01();
    notifyStartFromRecentTest_01();
    notifyQuickSwitchTest_01();
    notifyOtherTest_01();
    getMidSceneInfoListTest_01();
    MidSceneRecentHelperTest_01();
    MidSceneRecentHelperTest_02();
  });
}

function notifyFollowHandTest_01() {
  it('notifyFollowHandTest_001', Level.LEVEL0, (): void => {
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.FOLLOW_HAND, screenProperty, container);
    expect(container.isActive).assertFalse();
  });
}

function notifyFollowHandCancelTest_01() {
  it('notifyFollowHandCancelTest_001', Level.LEVEL0, (): void => {
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.FOLLOW_HAND_CANCEL, screenProperty, container);
    expect(container.isActive).assertFalse();
  });
}

function notifyEnterRecentTest_01() {
  it('notifyEnterRecentTest_001', Level.LEVEL0, (): void => {
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, container);
    expect(container.isActive).assertFalse();
  });
  it('notifyEnterRecentTest_002', Level.LEVEL0, (): void => {
    container.midSceneMap.clear();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, container);
    expect(container.isActive).assertFalse();
  });
  it('notifyEnterRecentTest_003', Level.LEVEL0, (): void => {
    container.midSceneMap.clear();
    container.midSceneMap.set(29, scbSceneSession);
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, container);
    expect(container.isActive).assertFalse();
  });
  it('notifyEnterRecentTest_004', Level.LEVEL0, (): void => {
    let midSceneContext = (container.sessionData.midSceneFSM as MidSceneFSM).context;
    for (let midSceneData of midSceneContext.l2r) {
      midSceneData.step = MidSceneStep.SMALL;
    }
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, container);
    expect(container.isActive).assertFalse();
  });
  it('notifyEnterRecentTest_005', Level.LEVEL0, (): void => {
    let midSceneContext = (container.sessionData.midSceneFSM as MidSceneFSM).context;
    for (let midSceneData of midSceneContext.l2r) {
      midSceneData.step = MidSceneStep.SMALL;
    }
    midSceneContext.l2r[0].width = 20;
    let mockFunc: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getScale);
    when(mockFunc)(ArgumentMatchers.any).afterReturn(1);
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, container);
    expect(container.isActive).assertFalse();
    mocker.clear(RecentLayoutManager);
  });
}

function notifyEnterRecentTest_02() {
  it('notifyEnterRecentTest_006', Level.LEVEL0, (): void => {
    container.midSceneMap.clear();
    let midSceneData: MidSceneData = new MidSceneData(29);
    container.midSceneMap.set(29, scbSceneSession);
    let midSceneContext = (container.sessionData.midSceneFSM as MidSceneFSM).context;
    midSceneContext.l2r.splice(0, 1, midSceneData);
    for (let midSceneData of midSceneContext.l2r) {
      midSceneData.step = MidSceneStep.SMALL;
      midSceneData.width = 20;
    }
    let mockFunc: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getScale);
    when(mockFunc)(ArgumentMatchers.any).afterReturn(1);
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, container);
    expect(container.isActive).assertFalse();
    mocker.clear(RecentLayoutManager);
  });
  it('notifyEnterRecentTest_007', Level.LEVEL0, (): void => {
    let midSceneContext = (container.sessionData.midSceneFSM as MidSceneFSM).context;
    midSceneContext.l2r[0].step = MidSceneStep.LARGE;
    midSceneContext.l2r[0].width = 2224;
    midSceneContext.l2r[1].step = MidSceneStep.SMALL;
    midSceneContext.l2r[1].width = 10;
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, container);
    expect(container.isActive).assertFalse();
  });
  it('notifyEnterRecentTest_008', Level.LEVEL0, (): void => {
    let mockFunc: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getScale);
    when(mockFunc)(ArgumentMatchers.any).afterReturn(0);
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, container);
    expect(container.isActive).assertFalse();
    mocker.clear(RecentLayoutManager);
  });
}

function notifyEnterDesktopStartTest_01() {
  it('notifyEnterDesktopStartTest_001', Level.LEVEL0, (): void => {
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_DESKTOP_START, screenProperty, container);
    expect(container.isActive).assertFalse();
  });
}

function notifyEnterDesktopFinishTest_01() {
  it('notifyEnterDesktopFinishTest_001', Level.LEVEL0, (): void => {
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_DESKTOP_FINISH, screenProperty, container);
    expect(container.isActive).assertFalse();
  });
}

function notifyStartFromRecentTest_01() {
  it('notifyStartFromRecentTest_001', Level.LEVEL0, (): void => {
    MidSceneManager.getInstance(screenProperty).recentHelper?.notifyMidSceneAnimFromGesture(
      MidSceneGestureType.START_FROM_RECENT, screenProperty, container);
    expect(container.isActive).assertFalse();
  });
  it('notifyStartFromRecentTest_002', Level.LEVEL0, (): void => {
    container.midSceneMap.clear();
    MidSceneManager.getInstance(screenProperty).recentHelper?.notifyMidSceneAnimFromGesture(
      MidSceneGestureType.START_FROM_RECENT, screenProperty, container);
    expect(container.isActive).assertFalse();
  });
}

function notifyQuickSwitchTest_01() {
  it('notifyQuickSwitchTest_001', Level.LEVEL0, (): void => {
    MidSceneManager.getInstance(screenProperty).recentHelper?.doQuickSwitchAnim(screenProperty, container, container);
    let toContainer = null;
    MidSceneManager.getInstance(screenProperty).recentHelper?.doQuickSwitchAnim(screenProperty, container, toContainer);
    expect(container.isActive).assertFalse();
  });
}

function notifyOtherTest_01() {
  it('notifyOtherTest_001', Level.LEVEL0, (): void => {
    screenProperty.width = 0;
    screenProperty.height = 0;
    MidSceneManager.getInstance(screenProperty).recentHelper?.notifyMidSceneAnimFromGesture(10, screenProperty,
      container);
    expect(container.isActive).assertFalse();
  });
  it('notifyOtherTest_002', Level.LEVEL0, (): void => {
    screenProperty.width = 0;
    MidSceneManager.getInstance(screenProperty).recentHelper?.notifyMidSceneAnimFromGesture(10, screenProperty,
      container);
    expect(container.isActive).assertFalse();
  });
  it('notifyOtherTest_003', Level.LEVEL0, (): void => {
    screenProperty.height = 0;
    MidSceneManager.getInstance(screenProperty).recentHelper?.notifyMidSceneAnimFromGesture(10, screenProperty,
      container);
    expect(container.isActive).assertFalse();
  });

  it('notifyOtherTest_004', Level.LEVEL0, (): void => {
    MidSceneManager.getInstance(screenProperty).recentHelper?.notifyMidSceneAnimFromGesture(10, screenProperty,
      container);
    expect(container.isActive).assertFalse();
  });
  it('notifyOtherTest_005', Level.LEVEL0, (): void => {
    container.isMidScene = false;
    MidSceneManager.getInstance(screenProperty).recentHelper?.notifyMidSceneAnimFromGesture(10, screenProperty,
      container);
    expect(container.isActive).assertFalse();
  });
  it('notifyOtherTest_006', Level.LEVEL0, (): void => {
    MidSceneManager.getInstance(screenProperty).recentHelper?.notifyMidSceneAnimFromGesture(10, screenProperty, null);
    expect(container.isActive).assertFalse();
  });
}

function getMidSceneInfoListTest_01() {
  it('getMidSceneInfoListTest_001', Level.LEVEL0, (): void => {
    MidSceneManager.getInstance(screenProperty).recentHelper?.getMidSceneInfoList(container);
    expect(container.isActive).assertFalse();
  });
  it('getMidSceneInfoListTest_002', Level.LEVEL0, (): void => {
    let midSceneContext = (container.sessionData.midSceneFSM as MidSceneFSM).context;
    ReflectionUtils.setProperty(midSceneContext.l2r[1], 'persistentId', 78);
    MidSceneManager.getInstance(screenProperty).recentHelper?.getMidSceneInfoList(container);
    expect(container.isActive).assertFalse();
  });
  it('getMidSceneInfoListTest_003', Level.LEVEL0, (): void => {
    let midSceneContext = (container.sessionData.midSceneFSM as MidSceneFSM).context;
    ReflectionUtils.setProperty(midSceneContext.l2r[0], 'persistentId', 78);
    MidSceneManager.getInstance(screenProperty).recentHelper?.getMidSceneInfoList(container);
    expect(container.isActive).assertFalse();
  });
  it('getMidSceneInfoListTest_004', Level.LEVEL0, (): void => {
    container.isMidScene = false;
    MidSceneManager.getInstance(screenProperty).recentHelper?.getMidSceneInfoList(container);
    expect(container.isActive).assertFalse();
  });
  it('getMidSceneInfoListTest_005', Level.LEVEL0, (): void => {
    let midSceneManagerTemp = MidSceneManager.getInstance(screenProperty);
    let midSceneManagerFunc: Function = mocker.mockFunc(midSceneManagerTemp, midSceneManagerTemp.isSupportMidScene);
    when(midSceneManagerFunc)(ArgumentMatchers.any).afterReturn(false);
    MidSceneManager.getInstance(screenProperty).recentHelper?.getMidSceneInfoList(container);
    expect(container.isActive).assertFalse();
    mocker.clear(midSceneManagerTemp);
  });
  it('getMidSceneInfoListTest_006', Level.LEVEL0, (): void => {
    let midSceneManagerTemp = MidSceneManager.getInstance(screenProperty);
    let midSceneManagerFunc: Function = mocker.mockFunc(midSceneManagerTemp, midSceneManagerTemp.isSupportMidScene);
    when(midSceneManagerFunc)(ArgumentMatchers.any).afterReturn(false);
    container.isMidScene = false;
    MidSceneManager.getInstance(screenProperty).recentHelper?.getMidSceneInfoList(container);
    expect(container.isActive).assertFalse();
    mocker.clear(midSceneManagerTemp);
  });
}

function MidSceneRecentHelperTest_01() {
  it('newMidSceneRecentHelperTest_001', Level.LEVEL0, (): void => {
    container.midSceneMap.clear();
    let midSceneContext = (container.sessionData.midSceneFSM as MidSceneFSM).context;
    midSceneContext.l2r[0].step = MidSceneStep.SMALL;
    midSceneContext.l2r[0].inclined = true;
    midSceneContext.l2r[1].step = MidSceneStep.LARGE;
    midSceneContext.l2r[0].inclined = false;
    midSceneContext.l2r[2].step = MidSceneStep.SMALL;
    midSceneContext.l2r[0].inclined = true;
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, container);
    expect(container.isActive).assertFalse();
    expect(midSceneContext.l2r[0].step).assertEqual(MidSceneStep.SMALL);
    expect(midSceneContext.l2r[1].step).assertEqual(MidSceneStep.LARGE);
    expect(midSceneContext.l2r[2].step).assertEqual(MidSceneStep.SMALL);
    expect(midSceneContext.l2r[0].inclined).assertTrue();
    expect(midSceneContext.l2r[1].inclined).assertFalse();
    expect(midSceneContext.l2r[2].inclined).assertTrue();
    let scbDividerParam = container.dividerParam;
    scbDividerParam.init();
    expect(scbDividerParam.primary.translateY === 0).assertTrue();
    expect(scbDividerParam.primary.translateX === 0).assertTrue();
    expect(scbDividerParam.primary.touchTranslateX === 0).assertTrue();
    expect(scbDividerParam.primary.touchTranslateY === 0).assertTrue();
    expect(scbDividerParam.secondary.touchTranslateX === 0).assertTrue();
    expect(scbDividerParam.secondary.touchTranslateY === 0).assertTrue();
    expect(scbDividerParam.primary.opacity === 1).assertTrue();
    expect(scbDividerParam.primary.blurScale === 0).assertTrue();
    expect(scbDividerParam.secondary.opacity === 1).assertTrue();
    expect(scbDividerParam.secondary.blurScale === 0).assertTrue();
    expect(scbDividerParam.primary.rotateX === 0).assertTrue();
    expect(scbDividerParam.primary.rotateY === 0).assertTrue();
    expect(scbDividerParam.primary.rotateZ === 0).assertTrue();
    expect(scbDividerParam.primary.rotateAngle === 0).assertTrue();
    expect(scbDividerParam.primary.rotateCenterX === 0).assertTrue();
    expect(scbDividerParam.primary.rotateCenterY === 0).assertTrue();
    expect(scbDividerParam.secondary.rotateX === 0).assertTrue();
    expect(scbDividerParam.secondary.rotateZ === 0).assertTrue();
    expect(scbDividerParam.secondary.rotateAngle === 0).assertTrue();
    expect(scbDividerParam.secondary.rotateCenterX === 0).assertTrue();
    expect(scbDividerParam.secondary.rotateCenterY === 0).assertTrue();
    expect(scbDividerParam.blackBackgroundOpacity === 0).assertTrue();
    expect(scbDividerParam.splitOrderIsNotReverse === true).assertTrue();
    expect(scbDividerParam.primary.posX === '0%').assertTrue();
    expect(scbDividerParam.primary.posY === '0%').assertTrue();
    expect(scbDividerParam.secondary.posX === '0%').assertTrue();
    expect(scbDividerParam.secondary.posY === '0%').assertTrue();
    expect(scbDividerParam.primary.blurRadius === -1).assertTrue();
    expect(scbDividerParam.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_002', Level.LEVEL0, (): void => {
    container.init();
    let scbDividerParam = container.dividerParam;
    scbDividerParam.init();

    expect(container.needRenderTranslate.translateX === 0).assertTrue();
    expect(container.needRenderTranslate.translateY === 0).assertTrue();
    expect(container.needRenderScale.scaleX === 1).assertTrue();
    expect(container.needRenderScale.scaleY === 1).assertTrue();
    expect(container.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(container.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(container.needRenderScale.centerX === '50%').assertTrue();
    expect(container.needRenderScale.centerY === '50%').assertTrue();
    expect(container.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(container.needRenderPos.posX === 0).assertTrue();
    expect(container.needRenderPos.posY === 0).assertTrue();
    expect(container.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(container.iconAlpha === 0).assertTrue();
    expect(container.iconAlpha === 0).assertTrue();
    expect(container.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(container.needRenderVisibility.visibility === true).assertTrue();
    expect(container.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(container.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(container.intelligentScene === 1).assertTrue();

    expect(scbDividerParam.primary.translateY === 0).assertTrue();
    expect(scbDividerParam.primary.translateX === 0).assertTrue();
    expect(scbDividerParam.primary.touchTranslateX === 0).assertTrue();
    expect(scbDividerParam.primary.touchTranslateY === 0).assertTrue();
    expect(scbDividerParam.secondary.touchTranslateX === 0).assertTrue();
    expect(scbDividerParam.secondary.touchTranslateY === 0).assertTrue();
    expect(scbDividerParam.primary.opacity === 1).assertTrue();
    expect(scbDividerParam.primary.blurScale === 0).assertTrue();
    expect(scbDividerParam.secondary.opacity === 1).assertTrue();
    expect(scbDividerParam.secondary.blurScale === 0).assertTrue();
    expect(scbDividerParam.primary.rotateX === 0).assertTrue();
    expect(scbDividerParam.primary.rotateY === 0).assertTrue();
    expect(scbDividerParam.primary.rotateZ === 0).assertTrue();
    expect(scbDividerParam.primary.rotateAngle === 0).assertTrue();
    expect(scbDividerParam.primary.rotateCenterX === 0).assertTrue();
    expect(scbDividerParam.primary.rotateCenterY === 0).assertTrue();
    expect(scbDividerParam.secondary.rotateX === 0).assertTrue();
    expect(scbDividerParam.secondary.rotateZ === 0).assertTrue();
    expect(scbDividerParam.secondary.rotateAngle === 0).assertTrue();
    expect(scbDividerParam.secondary.rotateCenterX === 0).assertTrue();
    expect(scbDividerParam.secondary.rotateCenterY === 0).assertTrue();
    expect(scbDividerParam.blackBackgroundOpacity === 0).assertTrue();
    expect(scbDividerParam.splitOrderIsNotReverse === true).assertTrue();
    expect(scbDividerParam.primary.posX === '0%').assertTrue();
    expect(scbDividerParam.primary.posY === '0%').assertTrue();
    expect(scbDividerParam.secondary.posX === '0%').assertTrue();
    expect(scbDividerParam.secondary.posY === '0%').assertTrue();
    expect(scbDividerParam.primary.blurRadius === -1).assertTrue();
    expect(scbDividerParam.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_002', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    containerSession.init();
    let dividerParam = containerSession.dividerParam;
    dividerParam.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, containerSession);

    expect(dividerParam.primary.translateY === 0).assertTrue();
    expect(dividerParam.primary.translateX === 0).assertTrue();
    expect(dividerParam.primary.touchTranslateX === 0).assertTrue();
    expect(dividerParam.primary.touchTranslateY === 0).assertTrue();
    expect(dividerParam.secondary.touchTranslateX === 0).assertTrue();
    expect(dividerParam.secondary.touchTranslateY === 0).assertTrue();
    expect(containerSession.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(containerSession.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(containerSession.needRenderScale.centerX === '50%').assertTrue();
    expect(containerSession.needRenderScale.centerY === '50%').assertTrue();
    expect(containerSession.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(containerSession.needRenderPos.posX === 0).assertTrue();
    expect(containerSession.needRenderPos.posY === 0).assertTrue();
    expect(dividerParam.primary.opacity === 1).assertTrue();
    expect(dividerParam.primary.blurScale === 0).assertTrue();
    expect(dividerParam.secondary.opacity === 1).assertTrue();
    expect(dividerParam.secondary.blurScale === 0).assertTrue();
    expect(dividerParam.primary.rotateX === 0).assertTrue();
    expect(dividerParam.primary.rotateY === 0).assertTrue();
    expect(dividerParam.primary.rotateZ === 0).assertTrue();
    expect(dividerParam.primary.rotateAngle === 0).assertTrue();
    expect(dividerParam.primary.rotateCenterX === 0).assertTrue();
    expect(dividerParam.primary.rotateCenterY === 0).assertTrue();
    expect(dividerParam.secondary.rotateX === 0).assertTrue();
    expect(dividerParam.secondary.rotateZ === 0).assertTrue();
    expect(containerSession.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(containerSession.iconAlpha === 0).assertTrue();
    expect(containerSession.iconAlpha === 0).assertTrue();
    expect(containerSession.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(containerSession.intelligentScene === 1).assertTrue();

    expect(containerSession.needRenderTranslate.translateX === 0).assertTrue();
    expect(containerSession.needRenderTranslate.translateY === 0).assertTrue();
    expect(containerSession.needRenderScale.scaleX === 1).assertTrue();
    expect(containerSession.needRenderScale.scaleY === 1).assertTrue();
    expect(dividerParam.secondary.rotateAngle === 0).assertTrue();
    expect(dividerParam.secondary.rotateCenterX === 0).assertTrue();
    expect(dividerParam.secondary.rotateCenterY === 0).assertTrue();
    expect(dividerParam.blackBackgroundOpacity === 0).assertTrue();
    expect(dividerParam.splitOrderIsNotReverse === true).assertTrue();
    expect(dividerParam.primary.posX === '0%').assertTrue();
    expect(dividerParam.primary.posY === '0%').assertTrue();
    expect(containerSession.needRenderVisibility.visibility === true).assertTrue();
    expect(containerSession.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(containerSession.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(dividerParam.secondary.posX === '0%').assertTrue();
    expect(dividerParam.secondary.posY === '0%').assertTrue();
    expect(dividerParam.primary.blurRadius === -1).assertTrue();
    expect(dividerParam.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_003', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let scbContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    scbContainerSession.init();
    let primaryDividerParam = scbContainerSession.dividerParam;
    primaryDividerParam.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty,
      scbContainerSession);

    expect(scbContainerSession.needRenderTranslate.translateX === 0).assertTrue();
    expect(scbContainerSession.needRenderTranslate.translateY === 0).assertTrue();
    expect(scbContainerSession.needRenderScale.scaleX === 1).assertTrue();
    expect(scbContainerSession.needRenderScale.scaleY === 1).assertTrue();
    expect(scbContainerSession.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(scbContainerSession.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(scbContainerSession.needRenderScale.centerX === '50%').assertTrue();
    expect(scbContainerSession.needRenderScale.centerY === '50%').assertTrue();
    expect(primaryDividerParam.primary.blurScale === 0).assertTrue();
    expect(primaryDividerParam.secondary.opacity === 1).assertTrue();
    expect(primaryDividerParam.secondary.blurScale === 0).assertTrue();
    expect(primaryDividerParam.primary.rotateX === 0).assertTrue();
    expect(primaryDividerParam.primary.rotateY === 0).assertTrue();
    expect(primaryDividerParam.primary.rotateZ === 0).assertTrue();
    expect(primaryDividerParam.primary.rotateAngle === 0).assertTrue();
    expect(primaryDividerParam.primary.rotateCenterX === 0).assertTrue();
    expect(primaryDividerParam.primary.rotateCenterY === 0).assertTrue();
    expect(scbContainerSession.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(scbContainerSession.needRenderVisibility.visibility === true).assertTrue();
    expect(scbContainerSession.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(primaryDividerParam.secondary.rotateX === 0).assertTrue();
    expect(primaryDividerParam.secondary.rotateZ === 0).assertTrue();
    expect(primaryDividerParam.secondary.rotateAngle === 0).assertTrue();
    expect(primaryDividerParam.secondary.rotateCenterX === 0).assertTrue();
    expect(primaryDividerParam.secondary.rotateCenterY === 0).assertTrue();
    expect(primaryDividerParam.blackBackgroundOpacity === 0).assertTrue();
    expect(primaryDividerParam.splitOrderIsNotReverse === true).assertTrue();
    expect(primaryDividerParam.primary.posX === '0%').assertTrue();
    expect(scbContainerSession.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(scbContainerSession.intelligentScene === 1).assertTrue();

    expect(scbContainerSession.needRenderPos.posX === 0).assertTrue();
    expect(scbContainerSession.needRenderPos.posY === 0).assertTrue();
    expect(scbContainerSession.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(scbContainerSession.iconAlpha === 0).assertTrue();
    expect(scbContainerSession.iconAlpha === 0).assertTrue();
    expect(scbContainerSession.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(primaryDividerParam.primary.translateY === 0).assertTrue();
    expect(primaryDividerParam.primary.translateX === 0).assertTrue();
    expect(primaryDividerParam.primary.touchTranslateX === 0).assertTrue();
    expect(primaryDividerParam.primary.touchTranslateY === 0).assertTrue();
    expect(primaryDividerParam.secondary.touchTranslateX === 0).assertTrue();
    expect(primaryDividerParam.secondary.touchTranslateY === 0).assertTrue();
    expect(primaryDividerParam.primary.opacity === 1).assertTrue();
    expect(primaryDividerParam.primary.posY === '0%').assertTrue();
    expect(primaryDividerParam.secondary.posX === '0%').assertTrue();
    expect(primaryDividerParam.secondary.posY === '0%').assertTrue();
    expect(primaryDividerParam.primary.blurRadius === -1).assertTrue();
    expect(primaryDividerParam.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_004', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer.init();
    let testDividerParam = testContainer.dividerParam;
    testDividerParam.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer);

    expect(testContainer.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer.needRenderPos.posX === 0).assertTrue();
    expect(testContainer.needRenderPos.posY === 0).assertTrue();
    expect(testContainer.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer.iconAlpha === 0).assertTrue();
    expect(testContainer.iconAlpha === 0).assertTrue();
    expect(testContainer.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer.intelligentScene === 1).assertTrue();

    expect(testDividerParam.primary.translateY === 0).assertTrue();
    expect(testDividerParam.primary.translateX === 0).assertTrue();
    expect(testDividerParam.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam.primary.opacity === 1).assertTrue();
    expect(testDividerParam.primary.blurScale === 0).assertTrue();
    expect(testDividerParam.secondary.opacity === 1).assertTrue();
    expect(testDividerParam.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam.primary.rotateX === 0).assertTrue();
    expect(testDividerParam.primary.rotateY === 0).assertTrue();
    expect(testDividerParam.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam.primary.posX === '0%').assertTrue();
    expect(testDividerParam.primary.posY === '0%').assertTrue();
    expect(testDividerParam.secondary.posX === '0%').assertTrue();
    expect(testDividerParam.secondary.posY === '0%').assertTrue();
    expect(testDividerParam.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_005', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer01: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer01.init();
    let testDividerParam01 = testContainer01.dividerParam;
    testDividerParam01.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer01);

    expect(testContainer01.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer01.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer01.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer01.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer01.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer01.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer01.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer01.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer01.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer01.needRenderPos.posX === 0).assertTrue();
    expect(testContainer01.needRenderPos.posY === 0).assertTrue();
    expect(testContainer01.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer01.iconAlpha === 0).assertTrue();
    expect(testContainer01.iconAlpha === 0).assertTrue();
    expect(testContainer01.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer01.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer01.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer01.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer01.intelligentScene === 1).assertTrue();

    expect(testDividerParam01.primary.translateY === 0).assertTrue();
    expect(testDividerParam01.primary.translateX === 0).assertTrue();
    expect(testDividerParam01.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam01.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam01.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam01.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam01.primary.opacity === 1).assertTrue();
    expect(testDividerParam01.primary.blurScale === 0).assertTrue();
    expect(testDividerParam01.secondary.opacity === 1).assertTrue();
    expect(testDividerParam01.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam01.primary.rotateX === 0).assertTrue();
    expect(testDividerParam01.primary.rotateY === 0).assertTrue();
    expect(testDividerParam01.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam01.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam01.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam01.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam01.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam01.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam01.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam01.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam01.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam01.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam01.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam01.primary.posX === '0%').assertTrue();
    expect(testDividerParam01.primary.posY === '0%').assertTrue();
    expect(testDividerParam01.secondary.posX === '0%').assertTrue();
    expect(testDividerParam01.secondary.posY === '0%').assertTrue();
    expect(testDividerParam01.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam01.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_006', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer02: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer02.init();
    let testDividerParam02 = testContainer02.dividerParam;
    testDividerParam02.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer02);

    expect(testContainer02.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer02.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer02.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer02.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer02.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer02.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer02.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer02.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer02.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer02.needRenderPos.posX === 0).assertTrue();
    expect(testContainer02.needRenderPos.posY === 0).assertTrue();
    expect(testContainer02.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer02.iconAlpha === 0).assertTrue();
    expect(testContainer02.iconAlpha === 0).assertTrue();
    expect(testContainer02.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer02.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer02.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer02.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer02.intelligentScene === 1).assertTrue();

    expect(testDividerParam02.primary.translateY === 0).assertTrue();
    expect(testDividerParam02.primary.translateX === 0).assertTrue();
    expect(testDividerParam02.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam02.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam02.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam02.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam02.primary.opacity === 1).assertTrue();
    expect(testDividerParam02.primary.blurScale === 0).assertTrue();
    expect(testDividerParam02.secondary.opacity === 1).assertTrue();
    expect(testDividerParam02.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam02.primary.rotateX === 0).assertTrue();
    expect(testDividerParam02.primary.rotateY === 0).assertTrue();
    expect(testDividerParam02.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam02.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam02.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam02.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam02.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam02.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam02.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam02.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam02.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam02.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam02.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam02.primary.posX === '0%').assertTrue();
    expect(testDividerParam02.primary.posY === '0%').assertTrue();
    expect(testDividerParam02.secondary.posX === '0%').assertTrue();
    expect(testDividerParam02.secondary.posY === '0%').assertTrue();
    expect(testDividerParam02.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam02.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_007', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer03: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer03.init();
    let testDividerParam03 = testContainer03.dividerParam;
    testDividerParam03.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer03);

    expect(testContainer03.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer03.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer03.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer03.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer03.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer03.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer03.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer03.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer03.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer03.needRenderPos.posX === 0).assertTrue();
    expect(testContainer03.needRenderPos.posY === 0).assertTrue();
    expect(testContainer03.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer03.iconAlpha === 0).assertTrue();
    expect(testContainer03.iconAlpha === 0).assertTrue();
    expect(testContainer03.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer03.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer03.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer03.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer03.intelligentScene === 1).assertTrue();

    expect(testDividerParam03.primary.translateY === 0).assertTrue();
    expect(testDividerParam03.primary.translateX === 0).assertTrue();
    expect(testDividerParam03.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam03.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam03.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam03.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam03.primary.opacity === 1).assertTrue();
    expect(testDividerParam03.primary.blurScale === 0).assertTrue();
    expect(testDividerParam03.secondary.opacity === 1).assertTrue();
    expect(testDividerParam03.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam03.primary.rotateX === 0).assertTrue();
    expect(testDividerParam03.primary.rotateY === 0).assertTrue();
    expect(testDividerParam03.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam03.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam03.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam03.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam03.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam03.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam03.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam03.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam03.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam03.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam03.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam03.primary.posX === '0%').assertTrue();
    expect(testDividerParam03.primary.posY === '0%').assertTrue();
    expect(testDividerParam03.secondary.posX === '0%').assertTrue();
    expect(testDividerParam03.secondary.posY === '0%').assertTrue();
    expect(testDividerParam03.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam03.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_008', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer04: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer04.init();
    let testDividerParam04 = testContainer04.dividerParam;
    testDividerParam04.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer04);

    expect(testContainer04.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer04.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer04.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer04.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer04.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer04.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer04.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer04.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer04.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer04.needRenderPos.posX === 0).assertTrue();
    expect(testContainer04.needRenderPos.posY === 0).assertTrue();
    expect(testContainer04.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer04.iconAlpha === 0).assertTrue();
    expect(testContainer04.iconAlpha === 0).assertTrue();
    expect(testContainer04.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer04.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer04.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer04.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer04.intelligentScene === 1).assertTrue();

    expect(testDividerParam04.primary.translateY === 0).assertTrue();
    expect(testDividerParam04.primary.translateX === 0).assertTrue();
    expect(testDividerParam04.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam04.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam04.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam04.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam04.primary.opacity === 1).assertTrue();
    expect(testDividerParam04.primary.blurScale === 0).assertTrue();
    expect(testDividerParam04.secondary.opacity === 1).assertTrue();
    expect(testDividerParam04.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam04.primary.rotateX === 0).assertTrue();
    expect(testDividerParam04.primary.rotateY === 0).assertTrue();
    expect(testDividerParam04.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam04.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam04.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam04.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam04.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam04.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam04.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam04.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam04.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam04.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam04.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam04.primary.posX === '0%').assertTrue();
    expect(testDividerParam04.primary.posY === '0%').assertTrue();
    expect(testDividerParam04.secondary.posX === '0%').assertTrue();
    expect(testDividerParam04.secondary.posY === '0%').assertTrue();
    expect(testDividerParam04.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam04.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_009', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer05: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer05.init();
    let testDividerParam05 = testContainer05.dividerParam;
    testDividerParam05.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer05);

    expect(testContainer05.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer05.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer05.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer05.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer05.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer05.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer05.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer05.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer05.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer05.needRenderPos.posX === 0).assertTrue();
    expect(testContainer05.needRenderPos.posY === 0).assertTrue();
    expect(testContainer05.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer05.iconAlpha === 0).assertTrue();
    expect(testContainer05.iconAlpha === 0).assertTrue();
    expect(testContainer05.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer05.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer05.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer05.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer05.intelligentScene === 1).assertTrue();

    expect(testDividerParam05.primary.translateY === 0).assertTrue();
    expect(testDividerParam05.primary.translateX === 0).assertTrue();
    expect(testDividerParam05.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam05.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam05.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam05.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam05.primary.opacity === 1).assertTrue();
    expect(testDividerParam05.primary.blurScale === 0).assertTrue();
    expect(testDividerParam05.secondary.opacity === 1).assertTrue();
    expect(testDividerParam05.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam05.primary.rotateX === 0).assertTrue();
    expect(testDividerParam05.primary.rotateY === 0).assertTrue();
    expect(testDividerParam05.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam05.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam05.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam05.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam05.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam05.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam05.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam05.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam05.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam05.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam05.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam05.primary.posX === '0%').assertTrue();
    expect(testDividerParam05.primary.posY === '0%').assertTrue();
    expect(testDividerParam05.secondary.posX === '0%').assertTrue();
    expect(testDividerParam05.secondary.posY === '0%').assertTrue();
    expect(testDividerParam05.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam05.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_010', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer06: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer06.init();
    let testDividerParam06 = testContainer06.dividerParam;
    testDividerParam06.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer06);

    expect(testContainer06.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer06.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer06.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer06.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer06.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer06.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer06.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer06.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer06.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer06.needRenderPos.posX === 0).assertTrue();
    expect(testContainer06.needRenderPos.posY === 0).assertTrue();
    expect(testContainer06.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer06.iconAlpha === 0).assertTrue();
    expect(testContainer06.iconAlpha === 0).assertTrue();
    expect(testContainer06.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer06.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer06.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer06.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer06.intelligentScene === 1).assertTrue();

    expect(testDividerParam06.primary.translateY === 0).assertTrue();
    expect(testDividerParam06.primary.translateX === 0).assertTrue();
    expect(testDividerParam06.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam06.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam06.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam06.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam06.primary.opacity === 1).assertTrue();
    expect(testDividerParam06.primary.blurScale === 0).assertTrue();
    expect(testDividerParam06.secondary.opacity === 1).assertTrue();
    expect(testDividerParam06.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam06.primary.rotateX === 0).assertTrue();
    expect(testDividerParam06.primary.rotateY === 0).assertTrue();
    expect(testDividerParam06.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam06.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam06.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam06.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam06.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam06.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam06.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam06.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam06.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam06.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam06.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam06.primary.posX === '0%').assertTrue();
    expect(testDividerParam06.primary.posY === '0%').assertTrue();
    expect(testDividerParam06.secondary.posX === '0%').assertTrue();
    expect(testDividerParam06.secondary.posY === '0%').assertTrue();
    expect(testDividerParam06.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam06.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_011', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer07: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer07.init();
    let testDividerParam07 = testContainer07.dividerParam;
    testDividerParam07.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer07);

    expect(testContainer07.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer07.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer07.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer07.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer07.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer07.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer07.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer07.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer07.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer07.needRenderPos.posX === 0).assertTrue();
    expect(testContainer07.needRenderPos.posY === 0).assertTrue();
    expect(testContainer07.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer07.iconAlpha === 0).assertTrue();
    expect(testContainer07.iconAlpha === 0).assertTrue();
    expect(testContainer07.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer07.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer07.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer07.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer07.intelligentScene === 1).assertTrue();

    expect(testDividerParam07.primary.translateY === 0).assertTrue();
    expect(testDividerParam07.primary.translateX === 0).assertTrue();
    expect(testDividerParam07.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam07.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam07.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam07.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam07.primary.opacity === 1).assertTrue();
    expect(testDividerParam07.primary.blurScale === 0).assertTrue();
    expect(testDividerParam07.secondary.opacity === 1).assertTrue();
    expect(testDividerParam07.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam07.primary.rotateX === 0).assertTrue();
    expect(testDividerParam07.primary.rotateY === 0).assertTrue();
    expect(testDividerParam07.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam07.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam07.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam07.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam07.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam07.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam07.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam07.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam07.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam07.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam07.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam07.primary.posX === '0%').assertTrue();
    expect(testDividerParam07.primary.posY === '0%').assertTrue();
    expect(testDividerParam07.secondary.posX === '0%').assertTrue();
    expect(testDividerParam07.secondary.posY === '0%').assertTrue();
    expect(testDividerParam07.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam07.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_012', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer08: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer08.init();
    let testDividerParam08 = testContainer08.dividerParam;
    testDividerParam08.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer08);

    expect(testContainer08.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer08.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer08.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer08.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer08.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer08.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer08.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer08.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer08.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer08.needRenderPos.posX === 0).assertTrue();
    expect(testContainer08.needRenderPos.posY === 0).assertTrue();
    expect(testContainer08.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer08.iconAlpha === 0).assertTrue();
    expect(testContainer08.iconAlpha === 0).assertTrue();
    expect(testContainer08.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer08.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer08.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer08.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer08.intelligentScene === 1).assertTrue();

    expect(testDividerParam08.primary.translateY === 0).assertTrue();
    expect(testDividerParam08.primary.translateX === 0).assertTrue();
    expect(testDividerParam08.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam08.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam08.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam08.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam08.primary.opacity === 1).assertTrue();
    expect(testDividerParam08.primary.blurScale === 0).assertTrue();
    expect(testDividerParam08.secondary.opacity === 1).assertTrue();
    expect(testDividerParam08.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam08.primary.rotateX === 0).assertTrue();
    expect(testDividerParam08.primary.rotateY === 0).assertTrue();
    expect(testDividerParam08.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam08.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam08.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam08.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam08.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam08.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam08.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam08.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam08.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam08.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam08.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam08.primary.posX === '0%').assertTrue();
    expect(testDividerParam08.primary.posY === '0%').assertTrue();
    expect(testDividerParam08.secondary.posX === '0%').assertTrue();
    expect(testDividerParam08.secondary.posY === '0%').assertTrue();
    expect(testDividerParam08.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam08.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_013', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer09: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer09.init();
    let testDividerParam09 = testContainer09.dividerParam;
    testDividerParam09.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer09);

    expect(testContainer09.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer09.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer09.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer09.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer09.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer09.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer09.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer09.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer09.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer09.needRenderPos.posX === 0).assertTrue();
    expect(testContainer09.needRenderPos.posY === 0).assertTrue();
    expect(testContainer09.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer09.iconAlpha === 0).assertTrue();
    expect(testContainer09.iconAlpha === 0).assertTrue();
    expect(testContainer09.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer09.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer09.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer09.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer09.intelligentScene === 1).assertTrue();

    expect(testDividerParam09.primary.translateY === 0).assertTrue();
    expect(testDividerParam09.primary.translateX === 0).assertTrue();
    expect(testDividerParam09.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam09.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam09.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam09.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam09.primary.opacity === 1).assertTrue();
    expect(testDividerParam09.primary.blurScale === 0).assertTrue();
    expect(testDividerParam09.secondary.opacity === 1).assertTrue();
    expect(testDividerParam09.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam09.primary.rotateX === 0).assertTrue();
    expect(testDividerParam09.primary.rotateY === 0).assertTrue();
    expect(testDividerParam09.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam09.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam09.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam09.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam09.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam09.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam09.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam09.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam09.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam09.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam09.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam09.primary.posX === '0%').assertTrue();
    expect(testDividerParam09.primary.posY === '0%').assertTrue();
    expect(testDividerParam09.secondary.posX === '0%').assertTrue();
    expect(testDividerParam09.secondary.posY === '0%').assertTrue();
    expect(testDividerParam09.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam09.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_014', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer10: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer10.init();
    let testDividerParam10 = testContainer10.dividerParam;
    testDividerParam10.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer10);

    expect(testContainer10.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer10.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer10.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer10.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer10.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer10.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer10.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer10.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer10.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer10.needRenderPos.posX === 0).assertTrue();
    expect(testContainer10.needRenderPos.posY === 0).assertTrue();
    expect(testContainer10.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer10.iconAlpha === 0).assertTrue();
    expect(testContainer10.iconAlpha === 0).assertTrue();
    expect(testContainer10.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer10.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer10.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer10.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer10.intelligentScene === 1).assertTrue();

    expect(testDividerParam10.primary.translateY === 0).assertTrue();
    expect(testDividerParam10.primary.translateX === 0).assertTrue();
    expect(testDividerParam10.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam10.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam10.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam10.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam10.primary.opacity === 1).assertTrue();
    expect(testDividerParam10.primary.blurScale === 0).assertTrue();
    expect(testDividerParam10.secondary.opacity === 1).assertTrue();
    expect(testDividerParam10.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam10.primary.rotateX === 0).assertTrue();
    expect(testDividerParam10.primary.rotateY === 0).assertTrue();
    expect(testDividerParam10.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam10.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam10.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam10.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam10.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam10.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam10.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam10.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam10.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam10.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam10.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam10.primary.posX === '0%').assertTrue();
    expect(testDividerParam10.primary.posY === '0%').assertTrue();
    expect(testDividerParam10.secondary.posX === '0%').assertTrue();
    expect(testDividerParam10.secondary.posY === '0%').assertTrue();
    expect(testDividerParam10.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam10.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_015', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer11: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer11.init();
    let testDividerParam11 = testContainer11.dividerParam;
    testDividerParam11.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer11);

    expect(testContainer11.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer11.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer11.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer11.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer11.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer11.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer11.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer11.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer11.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer11.needRenderPos.posX === 0).assertTrue();
    expect(testContainer11.needRenderPos.posY === 0).assertTrue();
    expect(testContainer11.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer11.iconAlpha === 0).assertTrue();
    expect(testContainer11.iconAlpha === 0).assertTrue();
    expect(testContainer11.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer11.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer11.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer11.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer11.intelligentScene === 1).assertTrue();

    expect(testDividerParam11.primary.translateY === 0).assertTrue();
    expect(testDividerParam11.primary.translateX === 0).assertTrue();
    expect(testDividerParam11.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam11.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam11.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam11.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam11.primary.opacity === 1).assertTrue();
    expect(testDividerParam11.primary.blurScale === 0).assertTrue();
    expect(testDividerParam11.secondary.opacity === 1).assertTrue();
    expect(testDividerParam11.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam11.primary.rotateX === 0).assertTrue();
    expect(testDividerParam11.primary.rotateY === 0).assertTrue();
    expect(testDividerParam11.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam11.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam11.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam11.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam11.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam11.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam11.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam11.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam11.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam11.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam11.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam11.primary.posX === '0%').assertTrue();
    expect(testDividerParam11.primary.posY === '0%').assertTrue();
    expect(testDividerParam11.secondary.posX === '0%').assertTrue();
    expect(testDividerParam11.secondary.posY === '0%').assertTrue();
    expect(testDividerParam11.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam11.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_016', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer12: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer12.init();
    let testDividerParam12 = testContainer12.dividerParam;
    testDividerParam12.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer12);

    expect(testContainer12.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer12.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer12.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer12.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer12.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer12.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer12.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer12.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer12.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer12.needRenderPos.posX === 0).assertTrue();
    expect(testContainer12.needRenderPos.posY === 0).assertTrue();
    expect(testContainer12.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer12.iconAlpha === 0).assertTrue();
    expect(testContainer12.iconAlpha === 0).assertTrue();
    expect(testContainer12.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer12.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer12.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer12.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer12.intelligentScene === 1).assertTrue();

    expect(testDividerParam12.primary.translateY === 0).assertTrue();
    expect(testDividerParam12.primary.translateX === 0).assertTrue();
    expect(testDividerParam12.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam12.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam12.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam12.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam12.primary.opacity === 1).assertTrue();
    expect(testDividerParam12.primary.blurScale === 0).assertTrue();
    expect(testDividerParam12.secondary.opacity === 1).assertTrue();
    expect(testDividerParam12.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam12.primary.rotateX === 0).assertTrue();
    expect(testDividerParam12.primary.rotateY === 0).assertTrue();
    expect(testDividerParam12.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam12.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam12.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam12.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam12.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam12.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam12.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam12.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam12.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam12.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam12.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam12.primary.posX === '0%').assertTrue();
    expect(testDividerParam12.primary.posY === '0%').assertTrue();
    expect(testDividerParam12.secondary.posX === '0%').assertTrue();
    expect(testDividerParam12.secondary.posY === '0%').assertTrue();
    expect(testDividerParam12.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam12.secondary.blurRadius === -1).assertTrue();
  });
}

function MidSceneRecentHelperTest_02() {
  it('newMidSceneRecentHelperTest_017', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer17: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer17.init();
    let testDividerParam17 = testContainer17.dividerParam;
    testDividerParam17.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer17);

    expect(testContainer17.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer17.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer17.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer17.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer17.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer17.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer17.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer17.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer17.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer17.needRenderPos.posX === 0).assertTrue();
    expect(testContainer17.needRenderPos.posY === 0).assertTrue();
    expect(testContainer17.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer17.iconAlpha === 0).assertTrue();
    expect(testContainer17.iconAlpha === 0).assertTrue();
    expect(testContainer17.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer17.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer17.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer17.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer17.intelligentScene === 1).assertTrue();

    expect(testDividerParam17.primary.translateY === 0).assertTrue();
    expect(testDividerParam17.primary.translateX === 0).assertTrue();
    expect(testDividerParam17.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam17.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam17.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam17.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam17.primary.opacity === 1).assertTrue();
    expect(testDividerParam17.primary.blurScale === 0).assertTrue();
    expect(testDividerParam17.secondary.opacity === 1).assertTrue();
    expect(testDividerParam17.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam17.primary.rotateX === 0).assertTrue();
    expect(testDividerParam17.primary.rotateY === 0).assertTrue();
    expect(testDividerParam17.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam17.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam17.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam17.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam17.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam17.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam17.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam17.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam17.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam17.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam17.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam17.primary.posX === '0%').assertTrue();
    expect(testDividerParam17.primary.posY === '0%').assertTrue();
    expect(testDividerParam17.secondary.posX === '0%').assertTrue();
    expect(testDividerParam17.secondary.posY === '0%').assertTrue();
    expect(testDividerParam17.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam17.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_018', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer18: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer18.init();
    let testDividerParam18 = testContainer18.dividerParam;
    testDividerParam18.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer18);

    expect(testContainer18.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer18.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer18.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer18.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer18.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer18.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer18.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer18.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer18.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer18.needRenderPos.posX === 0).assertTrue();
    expect(testContainer18.needRenderPos.posY === 0).assertTrue();
    expect(testContainer18.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer18.iconAlpha === 0).assertTrue();
    expect(testContainer18.iconAlpha === 0).assertTrue();
    expect(testContainer18.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer18.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer18.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer18.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer18.intelligentScene === 1).assertTrue();

    expect(testDividerParam18.primary.translateY === 0).assertTrue();
    expect(testDividerParam18.primary.translateX === 0).assertTrue();
    expect(testDividerParam18.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam18.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam18.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam18.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam18.primary.opacity === 1).assertTrue();
    expect(testDividerParam18.primary.blurScale === 0).assertTrue();
    expect(testDividerParam18.secondary.opacity === 1).assertTrue();
    expect(testDividerParam18.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam18.primary.rotateX === 0).assertTrue();
    expect(testDividerParam18.primary.rotateY === 0).assertTrue();
    expect(testDividerParam18.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam18.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam18.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam18.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam18.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam18.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam18.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam18.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam18.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam18.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam18.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam18.primary.posX === '0%').assertTrue();
    expect(testDividerParam18.primary.posY === '0%').assertTrue();
    expect(testDividerParam18.secondary.posX === '0%').assertTrue();
    expect(testDividerParam18.secondary.posY === '0%').assertTrue();
    expect(testDividerParam18.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam18.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_019', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer19: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer19.init();
    let testDividerParam19 = testContainer19.dividerParam;
    testDividerParam19.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer19);

    expect(testContainer19.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer19.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer19.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer19.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer19.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer19.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer19.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer19.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer19.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer19.needRenderPos.posX === 0).assertTrue();
    expect(testContainer19.needRenderPos.posY === 0).assertTrue();
    expect(testContainer19.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer19.iconAlpha === 0).assertTrue();
    expect(testContainer19.iconAlpha === 0).assertTrue();
    expect(testContainer19.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer19.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer19.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer19.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer19.intelligentScene === 1).assertTrue();

    expect(testDividerParam19.primary.translateY === 0).assertTrue();
    expect(testDividerParam19.primary.translateX === 0).assertTrue();
    expect(testDividerParam19.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam19.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam19.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam19.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam19.primary.opacity === 1).assertTrue();
    expect(testDividerParam19.primary.blurScale === 0).assertTrue();
    expect(testDividerParam19.secondary.opacity === 1).assertTrue();
    expect(testDividerParam19.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam19.primary.rotateX === 0).assertTrue();
    expect(testDividerParam19.primary.rotateY === 0).assertTrue();
    expect(testDividerParam19.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam19.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam19.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam19.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam19.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam19.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam19.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam19.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam19.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam19.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam19.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam19.primary.posX === '0%').assertTrue();
    expect(testDividerParam19.primary.posY === '0%').assertTrue();
    expect(testDividerParam19.secondary.posX === '0%').assertTrue();
    expect(testDividerParam19.secondary.posY === '0%').assertTrue();
    expect(testDividerParam19.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam19.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_020', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer20: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer20.init();
    let testDividerParam20 = testContainer20.dividerParam;
    testDividerParam20.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer20);

    expect(testContainer20.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer20.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer20.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer20.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer20.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer20.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer20.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer20.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer20.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer20.needRenderPos.posX === 0).assertTrue();
    expect(testContainer20.needRenderPos.posY === 0).assertTrue();
    expect(testContainer20.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer20.iconAlpha === 0).assertTrue();
    expect(testContainer20.iconAlpha === 0).assertTrue();
    expect(testContainer20.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer20.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer20.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer20.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer20.intelligentScene === 1).assertTrue();

    expect(testDividerParam20.primary.translateY === 0).assertTrue();
    expect(testDividerParam20.primary.translateX === 0).assertTrue();
    expect(testDividerParam20.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam20.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam20.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam20.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam20.primary.opacity === 1).assertTrue();
    expect(testDividerParam20.primary.blurScale === 0).assertTrue();
    expect(testDividerParam20.secondary.opacity === 1).assertTrue();
    expect(testDividerParam20.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam20.primary.rotateX === 0).assertTrue();
    expect(testDividerParam20.primary.rotateY === 0).assertTrue();
    expect(testDividerParam20.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam20.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam20.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam20.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam20.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam20.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam20.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam20.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam20.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam20.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam20.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam20.primary.posX === '0%').assertTrue();
    expect(testDividerParam20.primary.posY === '0%').assertTrue();
    expect(testDividerParam20.secondary.posX === '0%').assertTrue();
    expect(testDividerParam20.secondary.posY === '0%').assertTrue();
    expect(testDividerParam20.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam20.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_021', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer21: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer21.init();
    let testDividerParam21 = testContainer21.dividerParam;
    testDividerParam21.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer21);

    expect(testContainer21.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer21.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer21.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer21.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer21.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer21.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer21.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer21.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer21.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer21.needRenderPos.posX === 0).assertTrue();
    expect(testContainer21.needRenderPos.posY === 0).assertTrue();
    expect(testContainer21.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer21.iconAlpha === 0).assertTrue();
    expect(testContainer21.iconAlpha === 0).assertTrue();
    expect(testContainer21.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer21.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer21.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer21.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer21.intelligentScene === 1).assertTrue();

    expect(testDividerParam21.primary.translateY === 0).assertTrue();
    expect(testDividerParam21.primary.translateX === 0).assertTrue();
    expect(testDividerParam21.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam21.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam21.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam21.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam21.primary.opacity === 1).assertTrue();
    expect(testDividerParam21.primary.blurScale === 0).assertTrue();
    expect(testDividerParam21.secondary.opacity === 1).assertTrue();
    expect(testDividerParam21.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam21.primary.rotateX === 0).assertTrue();
    expect(testDividerParam21.primary.rotateY === 0).assertTrue();
    expect(testDividerParam21.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam21.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam21.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam21.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam21.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam21.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam21.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam21.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam21.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam21.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam21.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam21.primary.posX === '0%').assertTrue();
    expect(testDividerParam21.primary.posY === '0%').assertTrue();
    expect(testDividerParam21.secondary.posX === '0%').assertTrue();
    expect(testDividerParam21.secondary.posY === '0%').assertTrue();
    expect(testDividerParam21.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam21.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_022', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer22: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer22.init();
    let testDividerParam22 = testContainer22.dividerParam;
    testDividerParam22.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer22);

    expect(testContainer22.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer22.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer22.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer22.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer22.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer22.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer22.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer22.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer22.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer22.needRenderPos.posX === 0).assertTrue();
    expect(testContainer22.needRenderPos.posY === 0).assertTrue();
    expect(testContainer22.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer22.iconAlpha === 0).assertTrue();
    expect(testContainer22.iconAlpha === 0).assertTrue();
    expect(testContainer22.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer22.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer22.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer22.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer22.intelligentScene === 1).assertTrue();

    expect(testDividerParam22.primary.translateY === 0).assertTrue();
    expect(testDividerParam22.primary.translateX === 0).assertTrue();
    expect(testDividerParam22.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam22.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam22.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam22.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam22.primary.opacity === 1).assertTrue();
    expect(testDividerParam22.primary.blurScale === 0).assertTrue();
    expect(testDividerParam22.secondary.opacity === 1).assertTrue();
    expect(testDividerParam22.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam22.primary.rotateX === 0).assertTrue();
    expect(testDividerParam22.primary.rotateY === 0).assertTrue();
    expect(testDividerParam22.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam22.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam22.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam22.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam22.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam22.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam22.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam22.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam22.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam22.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam22.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam22.primary.posX === '0%').assertTrue();
    expect(testDividerParam22.primary.posY === '0%').assertTrue();
    expect(testDividerParam22.secondary.posX === '0%').assertTrue();
    expect(testDividerParam22.secondary.posY === '0%').assertTrue();
    expect(testDividerParam22.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam22.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_023', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer23: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer23.init();
    let testDividerParam23 = testContainer23.dividerParam;
    testDividerParam23.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer23);

    expect(testContainer23.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer23.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer23.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer23.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer23.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer23.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer23.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer23.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer23.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer23.needRenderPos.posX === 0).assertTrue();
    expect(testContainer23.needRenderPos.posY === 0).assertTrue();
    expect(testContainer23.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer23.iconAlpha === 0).assertTrue();
    expect(testContainer23.iconAlpha === 0).assertTrue();
    expect(testContainer23.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer23.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer23.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer23.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer23.intelligentScene === 1).assertTrue();

    expect(testDividerParam23.primary.translateY === 0).assertTrue();
    expect(testDividerParam23.primary.translateX === 0).assertTrue();
    expect(testDividerParam23.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam23.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam23.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam23.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam23.primary.opacity === 1).assertTrue();
    expect(testDividerParam23.primary.blurScale === 0).assertTrue();
    expect(testDividerParam23.secondary.opacity === 1).assertTrue();
    expect(testDividerParam23.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam23.primary.rotateX === 0).assertTrue();
    expect(testDividerParam23.primary.rotateY === 0).assertTrue();
    expect(testDividerParam23.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam23.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam23.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam23.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam23.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam23.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam23.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam23.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam23.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam23.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam23.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam23.primary.posX === '0%').assertTrue();
    expect(testDividerParam23.primary.posY === '0%').assertTrue();
    expect(testDividerParam23.secondary.posX === '0%').assertTrue();
    expect(testDividerParam23.secondary.posY === '0%').assertTrue();
    expect(testDividerParam23.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam23.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_024', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer24: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer24.init();
    let testDividerParam24 = testContainer24.dividerParam;
    testDividerParam24.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer24);

    expect(testContainer24.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer24.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer24.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer24.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer24.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer24.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer24.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer24.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer24.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer24.needRenderPos.posX === 0).assertTrue();
    expect(testContainer24.needRenderPos.posY === 0).assertTrue();
    expect(testContainer24.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer24.iconAlpha === 0).assertTrue();
    expect(testContainer24.iconAlpha === 0).assertTrue();
    expect(testContainer24.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer24.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer24.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer24.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer24.intelligentScene === 1).assertTrue();

    expect(testDividerParam24.primary.translateY === 0).assertTrue();
    expect(testDividerParam24.primary.translateX === 0).assertTrue();
    expect(testDividerParam24.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam24.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam24.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam24.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam24.primary.opacity === 1).assertTrue();
    expect(testDividerParam24.primary.blurScale === 0).assertTrue();
    expect(testDividerParam24.secondary.opacity === 1).assertTrue();
    expect(testDividerParam24.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam24.primary.rotateX === 0).assertTrue();
    expect(testDividerParam24.primary.rotateY === 0).assertTrue();
    expect(testDividerParam24.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam24.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam24.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam24.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam24.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam24.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam24.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam24.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam24.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam24.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam24.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam24.primary.posX === '0%').assertTrue();
    expect(testDividerParam24.primary.posY === '0%').assertTrue();
    expect(testDividerParam24.secondary.posX === '0%').assertTrue();
    expect(testDividerParam24.secondary.posY === '0%').assertTrue();
    expect(testDividerParam24.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam24.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_025', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer25: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer25.init();
    let testDividerParam25 = testContainer25.dividerParam;
    testDividerParam25.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer25);

    expect(testContainer25.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer25.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer25.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer25.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer25.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer25.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer25.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer25.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer25.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer25.needRenderPos.posX === 0).assertTrue();
    expect(testContainer25.needRenderPos.posY === 0).assertTrue();
    expect(testContainer25.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer25.iconAlpha === 0).assertTrue();
    expect(testContainer25.iconAlpha === 0).assertTrue();
    expect(testContainer25.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer25.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer25.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer25.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer25.intelligentScene === 1).assertTrue();

    expect(testDividerParam25.primary.translateY === 0).assertTrue();
    expect(testDividerParam25.primary.translateX === 0).assertTrue();
    expect(testDividerParam25.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam25.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam25.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam25.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam25.primary.opacity === 1).assertTrue();
    expect(testDividerParam25.primary.blurScale === 0).assertTrue();
    expect(testDividerParam25.secondary.opacity === 1).assertTrue();
    expect(testDividerParam25.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam25.primary.rotateX === 0).assertTrue();
    expect(testDividerParam25.primary.rotateY === 0).assertTrue();
    expect(testDividerParam25.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam25.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam25.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam25.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam25.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam25.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam25.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam25.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam25.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam25.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam25.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam25.primary.posX === '0%').assertTrue();
    expect(testDividerParam25.primary.posY === '0%').assertTrue();
    expect(testDividerParam25.secondary.posX === '0%').assertTrue();
    expect(testDividerParam25.secondary.posY === '0%').assertTrue();
    expect(testDividerParam25.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam25.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_026', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer26: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer26.init();
    let testDividerParam26 = testContainer26.dividerParam;
    testDividerParam26.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer26);

    expect(testContainer26.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer26.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer26.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer26.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer26.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer26.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer26.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer26.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer26.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer26.needRenderPos.posX === 0).assertTrue();
    expect(testContainer26.needRenderPos.posY === 0).assertTrue();
    expect(testContainer26.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer26.iconAlpha === 0).assertTrue();
    expect(testContainer26.iconAlpha === 0).assertTrue();
    expect(testContainer26.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer26.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer26.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer26.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer26.intelligentScene === 1).assertTrue();

    expect(testDividerParam26.primary.translateY === 0).assertTrue();
    expect(testDividerParam26.primary.translateX === 0).assertTrue();
    expect(testDividerParam26.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam26.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam26.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam26.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam26.primary.opacity === 1).assertTrue();
    expect(testDividerParam26.primary.blurScale === 0).assertTrue();
    expect(testDividerParam26.secondary.opacity === 1).assertTrue();
    expect(testDividerParam26.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam26.primary.rotateX === 0).assertTrue();
    expect(testDividerParam26.primary.rotateY === 0).assertTrue();
    expect(testDividerParam26.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam26.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam26.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam26.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam26.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam26.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam26.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam26.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam26.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam26.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam26.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam26.primary.posX === '0%').assertTrue();
    expect(testDividerParam26.primary.posY === '0%').assertTrue();
    expect(testDividerParam26.secondary.posX === '0%').assertTrue();
    expect(testDividerParam26.secondary.posY === '0%').assertTrue();
    expect(testDividerParam26.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam26.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_027', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer27: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer27.init();
    let testDividerParam27 = testContainer27.dividerParam;
    testDividerParam27.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer27);

    expect(testContainer27.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer27.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer27.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer27.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer27.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer27.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer27.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer27.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer27.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer27.needRenderPos.posX === 0).assertTrue();
    expect(testContainer27.needRenderPos.posY === 0).assertTrue();
    expect(testContainer27.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer27.iconAlpha === 0).assertTrue();
    expect(testContainer27.iconAlpha === 0).assertTrue();
    expect(testContainer27.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer27.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer27.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer27.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer27.intelligentScene === 1).assertTrue();

    expect(testDividerParam27.primary.translateY === 0).assertTrue();
    expect(testDividerParam27.primary.translateX === 0).assertTrue();
    expect(testDividerParam27.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam27.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam27.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam27.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam27.primary.opacity === 1).assertTrue();
    expect(testDividerParam27.primary.blurScale === 0).assertTrue();
    expect(testDividerParam27.secondary.opacity === 1).assertTrue();
    expect(testDividerParam27.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam27.primary.rotateX === 0).assertTrue();
    expect(testDividerParam27.primary.rotateY === 0).assertTrue();
    expect(testDividerParam27.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam27.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam27.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam27.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam27.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam27.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam27.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam27.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam27.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam27.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam27.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam27.primary.posX === '0%').assertTrue();
    expect(testDividerParam27.primary.posY === '0%').assertTrue();
    expect(testDividerParam27.secondary.posX === '0%').assertTrue();
    expect(testDividerParam27.secondary.posY === '0%').assertTrue();
    expect(testDividerParam27.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam27.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_028', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer28: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer28.init();
    let testDividerParam28 = testContainer28.dividerParam;
    testDividerParam28.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer28);

    expect(testContainer28.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer28.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer28.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer28.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer28.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer28.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer28.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer28.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer28.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer28.needRenderPos.posX === 0).assertTrue();
    expect(testContainer28.needRenderPos.posY === 0).assertTrue();
    expect(testContainer28.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer28.iconAlpha === 0).assertTrue();
    expect(testContainer28.iconAlpha === 0).assertTrue();
    expect(testContainer28.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer28.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer28.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer28.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer28.intelligentScene === 1).assertTrue();

    expect(testDividerParam28.primary.translateY === 0).assertTrue();
    expect(testDividerParam28.primary.translateX === 0).assertTrue();
    expect(testDividerParam28.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam28.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam28.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam28.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam28.primary.opacity === 1).assertTrue();
    expect(testDividerParam28.primary.blurScale === 0).assertTrue();
    expect(testDividerParam28.secondary.opacity === 1).assertTrue();
    expect(testDividerParam28.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam28.primary.rotateX === 0).assertTrue();
    expect(testDividerParam28.primary.rotateY === 0).assertTrue();
    expect(testDividerParam28.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam28.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam28.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam28.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam28.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam28.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam28.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam28.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam28.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam28.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam28.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam28.primary.posX === '0%').assertTrue();
    expect(testDividerParam28.primary.posY === '0%').assertTrue();
    expect(testDividerParam28.secondary.posX === '0%').assertTrue();
    expect(testDividerParam28.secondary.posY === '0%').assertTrue();
    expect(testDividerParam28.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam28.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_029', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer29: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer29.init();
    let testDividerParam29 = testContainer29.dividerParam;
    testDividerParam29.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer29);

    expect(testContainer29.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer29.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer29.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer29.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer29.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer29.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer29.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer29.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer29.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer29.needRenderPos.posX === 0).assertTrue();
    expect(testContainer29.needRenderPos.posY === 0).assertTrue();
    expect(testContainer29.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer29.iconAlpha === 0).assertTrue();
    expect(testContainer29.iconAlpha === 0).assertTrue();
    expect(testContainer29.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer29.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer29.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer29.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer29.intelligentScene === 1).assertTrue();

    expect(testDividerParam29.primary.translateY === 0).assertTrue();
    expect(testDividerParam29.primary.translateX === 0).assertTrue();
    expect(testDividerParam29.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam29.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam29.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam29.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam29.primary.opacity === 1).assertTrue();
    expect(testDividerParam29.primary.blurScale === 0).assertTrue();
    expect(testDividerParam29.secondary.opacity === 1).assertTrue();
    expect(testDividerParam29.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam29.primary.rotateX === 0).assertTrue();
    expect(testDividerParam29.primary.rotateY === 0).assertTrue();
    expect(testDividerParam29.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam29.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam29.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam29.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam29.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam29.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam29.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam29.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam29.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam29.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam29.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam29.primary.posX === '0%').assertTrue();
    expect(testDividerParam29.primary.posY === '0%').assertTrue();
    expect(testDividerParam29.secondary.posX === '0%').assertTrue();
    expect(testDividerParam29.secondary.posY === '0%').assertTrue();
    expect(testDividerParam29.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam29.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_030', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer30: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer30.init();
    let testDividerParam30 = testContainer30.dividerParam;
    testDividerParam30.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer30);

    expect(testContainer30.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer30.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer30.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer30.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer30.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer30.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer30.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer30.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer30.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer30.needRenderPos.posX === 0).assertTrue();
    expect(testContainer30.needRenderPos.posY === 0).assertTrue();
    expect(testContainer30.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer30.iconAlpha === 0).assertTrue();
    expect(testContainer30.iconAlpha === 0).assertTrue();
    expect(testContainer30.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer30.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer30.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer30.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer30.intelligentScene === 1).assertTrue();

    expect(testDividerParam30.primary.translateY === 0).assertTrue();
    expect(testDividerParam30.primary.translateX === 0).assertTrue();
    expect(testDividerParam30.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam30.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam30.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam30.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam30.primary.opacity === 1).assertTrue();
    expect(testDividerParam30.primary.blurScale === 0).assertTrue();
    expect(testDividerParam30.secondary.opacity === 1).assertTrue();
    expect(testDividerParam30.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam30.primary.rotateX === 0).assertTrue();
    expect(testDividerParam30.primary.rotateY === 0).assertTrue();
    expect(testDividerParam30.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam30.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam30.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam30.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam30.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam30.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam30.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam30.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam30.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam30.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam30.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam30.primary.posX === '0%').assertTrue();
    expect(testDividerParam30.primary.posY === '0%').assertTrue();
    expect(testDividerParam30.secondary.posX === '0%').assertTrue();
    expect(testDividerParam30.secondary.posY === '0%').assertTrue();
    expect(testDividerParam30.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam30.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_031', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer31: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer31.init();
    let testDividerParam31 = testContainer31.dividerParam;
    testDividerParam31.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer31);

    expect(testContainer31.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer31.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer31.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer31.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer31.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer31.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer31.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer31.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer31.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer31.needRenderPos.posX === 0).assertTrue();
    expect(testContainer31.needRenderPos.posY === 0).assertTrue();
    expect(testContainer31.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer31.iconAlpha === 0).assertTrue();
    expect(testContainer31.iconAlpha === 0).assertTrue();
    expect(testContainer31.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer31.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer31.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer31.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer31.intelligentScene === 1).assertTrue();

    expect(testDividerParam31.primary.translateY === 0).assertTrue();
    expect(testDividerParam31.primary.translateX === 0).assertTrue();
    expect(testDividerParam31.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam31.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam31.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam31.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam31.primary.opacity === 1).assertTrue();
    expect(testDividerParam31.primary.blurScale === 0).assertTrue();
    expect(testDividerParam31.secondary.opacity === 1).assertTrue();
    expect(testDividerParam31.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam31.primary.rotateX === 0).assertTrue();
    expect(testDividerParam31.primary.rotateY === 0).assertTrue();
    expect(testDividerParam31.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam31.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam31.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam31.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam31.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam31.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam31.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam31.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam31.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam31.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam31.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam31.primary.posX === '0%').assertTrue();
    expect(testDividerParam31.primary.posY === '0%').assertTrue();
    expect(testDividerParam31.secondary.posX === '0%').assertTrue();
    expect(testDividerParam31.secondary.posY === '0%').assertTrue();
    expect(testDividerParam31.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam31.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_032', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer32: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer32.init();
    let testDividerParam32 = testContainer32.dividerParam;
    testDividerParam32.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer32);

    expect(testContainer32.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer32.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer32.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer32.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer32.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer32.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer32.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer32.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer32.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer32.needRenderPos.posX === 0).assertTrue();
    expect(testContainer32.needRenderPos.posY === 0).assertTrue();
    expect(testContainer32.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer32.iconAlpha === 0).assertTrue();
    expect(testContainer32.iconAlpha === 0).assertTrue();
    expect(testContainer32.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer32.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer32.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer32.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer32.intelligentScene === 1).assertTrue();

    expect(testDividerParam32.primary.translateY === 0).assertTrue();
    expect(testDividerParam32.primary.translateX === 0).assertTrue();
    expect(testDividerParam32.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam32.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam32.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam32.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam32.primary.opacity === 1).assertTrue();
    expect(testDividerParam32.primary.blurScale === 0).assertTrue();
    expect(testDividerParam32.secondary.opacity === 1).assertTrue();
    expect(testDividerParam32.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam32.primary.rotateX === 0).assertTrue();
    expect(testDividerParam32.primary.rotateY === 0).assertTrue();
    expect(testDividerParam32.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam32.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam32.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam32.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam32.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam32.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam32.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam32.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam32.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam32.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam32.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam32.primary.posX === '0%').assertTrue();
    expect(testDividerParam32.primary.posY === '0%').assertTrue();
    expect(testDividerParam32.secondary.posX === '0%').assertTrue();
    expect(testDividerParam32.secondary.posY === '0%').assertTrue();
    expect(testDividerParam32.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam32.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_033', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer33: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer33.init();
    let testDividerParam33 = testContainer33.dividerParam;
    testDividerParam33.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer33);

    expect(testContainer33.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer33.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer33.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer33.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer33.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer33.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer33.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer33.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer33.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer33.needRenderPos.posX === 0).assertTrue();
    expect(testContainer33.needRenderPos.posY === 0).assertTrue();
    expect(testContainer33.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer33.iconAlpha === 0).assertTrue();
    expect(testContainer33.iconAlpha === 0).assertTrue();
    expect(testContainer33.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer33.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer33.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer33.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer33.intelligentScene === 1).assertTrue();

    expect(testDividerParam33.primary.translateY === 0).assertTrue();
    expect(testDividerParam33.primary.translateX === 0).assertTrue();
    expect(testDividerParam33.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam33.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam33.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam33.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam33.primary.opacity === 1).assertTrue();
    expect(testDividerParam33.primary.blurScale === 0).assertTrue();
    expect(testDividerParam33.secondary.opacity === 1).assertTrue();
    expect(testDividerParam33.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam33.primary.rotateX === 0).assertTrue();
    expect(testDividerParam33.primary.rotateY === 0).assertTrue();
    expect(testDividerParam33.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam33.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam33.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam33.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam33.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam33.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam33.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam33.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam33.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam33.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam33.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam33.primary.posX === '0%').assertTrue();
    expect(testDividerParam33.primary.posY === '0%').assertTrue();
    expect(testDividerParam33.secondary.posX === '0%').assertTrue();
    expect(testDividerParam33.secondary.posY === '0%').assertTrue();
    expect(testDividerParam33.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam33.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_034', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer34: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer34.init();
    let testDividerParam34 = testContainer34.dividerParam;
    testDividerParam34.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer34);

    expect(testContainer34.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer34.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer34.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer34.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer34.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer34.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer34.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer34.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer34.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer34.needRenderPos.posX === 0).assertTrue();
    expect(testContainer34.needRenderPos.posY === 0).assertTrue();
    expect(testContainer34.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer34.iconAlpha === 0).assertTrue();
    expect(testContainer34.iconAlpha === 0).assertTrue();
    expect(testContainer34.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer34.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer34.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer34.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer34.intelligentScene === 1).assertTrue();

    expect(testDividerParam34.primary.translateY === 0).assertTrue();
    expect(testDividerParam34.primary.translateX === 0).assertTrue();
    expect(testDividerParam34.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam34.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam34.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam34.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam34.primary.opacity === 1).assertTrue();
    expect(testDividerParam34.primary.blurScale === 0).assertTrue();
    expect(testDividerParam34.secondary.opacity === 1).assertTrue();
    expect(testDividerParam34.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam34.primary.rotateX === 0).assertTrue();
    expect(testDividerParam34.primary.rotateY === 0).assertTrue();
    expect(testDividerParam34.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam34.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam34.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam34.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam34.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam34.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam34.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam34.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam34.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam34.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam34.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam34.primary.posX === '0%').assertTrue();
    expect(testDividerParam34.primary.posY === '0%').assertTrue();
    expect(testDividerParam34.secondary.posX === '0%').assertTrue();
    expect(testDividerParam34.secondary.posY === '0%').assertTrue();
    expect(testDividerParam34.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam34.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_035', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer35: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer35.init();
    let testDividerParam35 = testContainer35.dividerParam;
    testDividerParam35.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer35);

    expect(testContainer35.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer35.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer35.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer35.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer35.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer35.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer35.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer35.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer35.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer35.needRenderPos.posX === 0).assertTrue();
    expect(testContainer35.needRenderPos.posY === 0).assertTrue();
    expect(testContainer35.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer35.iconAlpha === 0).assertTrue();
    expect(testContainer35.iconAlpha === 0).assertTrue();
    expect(testContainer35.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer35.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer35.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer35.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer35.intelligentScene === 1).assertTrue();

    expect(testDividerParam35.primary.translateY === 0).assertTrue();
    expect(testDividerParam35.primary.translateX === 0).assertTrue();
    expect(testDividerParam35.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam35.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam35.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam35.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam35.primary.opacity === 1).assertTrue();
    expect(testDividerParam35.primary.blurScale === 0).assertTrue();
    expect(testDividerParam35.secondary.opacity === 1).assertTrue();
    expect(testDividerParam35.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam35.primary.rotateX === 0).assertTrue();
    expect(testDividerParam35.primary.rotateY === 0).assertTrue();
    expect(testDividerParam35.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam35.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam35.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam35.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam35.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam35.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam35.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam35.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam35.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam35.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam35.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam35.primary.posX === '0%').assertTrue();
    expect(testDividerParam35.primary.posY === '0%').assertTrue();
    expect(testDividerParam35.secondary.posX === '0%').assertTrue();
    expect(testDividerParam35.secondary.posY === '0%').assertTrue();
    expect(testDividerParam35.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam35.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_036', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer36: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer36.init();
    let testDividerParam36 = testContainer36.dividerParam;
    testDividerParam36.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer36);

    expect(testContainer36.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer36.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer36.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer36.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer36.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer36.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer36.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer36.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer36.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer36.needRenderPos.posX === 0).assertTrue();
    expect(testContainer36.needRenderPos.posY === 0).assertTrue();
    expect(testContainer36.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer36.iconAlpha === 0).assertTrue();
    expect(testContainer36.iconAlpha === 0).assertTrue();
    expect(testContainer36.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer36.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer36.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer36.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer36.intelligentScene === 1).assertTrue();

    expect(testDividerParam36.primary.translateY === 0).assertTrue();
    expect(testDividerParam36.primary.translateX === 0).assertTrue();
    expect(testDividerParam36.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam36.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam36.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam36.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam36.primary.opacity === 1).assertTrue();
    expect(testDividerParam36.primary.blurScale === 0).assertTrue();
    expect(testDividerParam36.secondary.opacity === 1).assertTrue();
    expect(testDividerParam36.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam36.primary.rotateX === 0).assertTrue();
    expect(testDividerParam36.primary.rotateY === 0).assertTrue();
    expect(testDividerParam36.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam36.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam36.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam36.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam36.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam36.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam36.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam36.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam36.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam36.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam36.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam36.primary.posX === '0%').assertTrue();
    expect(testDividerParam36.primary.posY === '0%').assertTrue();
    expect(testDividerParam36.secondary.posX === '0%').assertTrue();
    expect(testDividerParam36.secondary.posY === '0%').assertTrue();
    expect(testDividerParam36.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam36.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_037', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer37: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer37.init();
    let testDividerParam37 = testContainer37.dividerParam;
    testDividerParam37.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer37);

    expect(testContainer37.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer37.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer37.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer37.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer37.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer37.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer37.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer37.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer37.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer37.needRenderPos.posX === 0).assertTrue();
    expect(testContainer37.needRenderPos.posY === 0).assertTrue();
    expect(testContainer37.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer37.iconAlpha === 0).assertTrue();
    expect(testContainer37.iconAlpha === 0).assertTrue();
    expect(testContainer37.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer37.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer37.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer37.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer37.intelligentScene === 1).assertTrue();

    expect(testDividerParam37.primary.translateY === 0).assertTrue();
    expect(testDividerParam37.primary.translateX === 0).assertTrue();
    expect(testDividerParam37.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam37.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam37.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam37.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam37.primary.opacity === 1).assertTrue();
    expect(testDividerParam37.primary.blurScale === 0).assertTrue();
    expect(testDividerParam37.secondary.opacity === 1).assertTrue();
    expect(testDividerParam37.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam37.primary.rotateX === 0).assertTrue();
    expect(testDividerParam37.primary.rotateY === 0).assertTrue();
    expect(testDividerParam37.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam37.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam37.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam37.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam37.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam37.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam37.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam37.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam37.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam37.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam37.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam37.primary.posX === '0%').assertTrue();
    expect(testDividerParam37.primary.posY === '0%').assertTrue();
    expect(testDividerParam37.secondary.posX === '0%').assertTrue();
    expect(testDividerParam37.secondary.posY === '0%').assertTrue();
    expect(testDividerParam37.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam37.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_038', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer38: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer38.init();
    let testDividerParam38 = testContainer38.dividerParam;
    testDividerParam38.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer38);

    expect(testContainer38.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer38.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer38.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer38.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer38.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer38.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer38.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer38.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer38.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer38.needRenderPos.posX === 0).assertTrue();
    expect(testContainer38.needRenderPos.posY === 0).assertTrue();
    expect(testContainer38.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer38.iconAlpha === 0).assertTrue();
    expect(testContainer38.iconAlpha === 0).assertTrue();
    expect(testContainer38.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer38.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer38.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer38.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer38.intelligentScene === 1).assertTrue();

    expect(testDividerParam38.primary.translateY === 0).assertTrue();
    expect(testDividerParam38.primary.translateX === 0).assertTrue();
    expect(testDividerParam38.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam38.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam38.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam38.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam38.primary.opacity === 1).assertTrue();
    expect(testDividerParam38.primary.blurScale === 0).assertTrue();
    expect(testDividerParam38.secondary.opacity === 1).assertTrue();
    expect(testDividerParam38.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam38.primary.rotateX === 0).assertTrue();
    expect(testDividerParam38.primary.rotateY === 0).assertTrue();
    expect(testDividerParam38.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam38.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam38.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam38.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam38.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam38.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam38.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam38.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam38.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam38.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam38.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam38.primary.posX === '0%').assertTrue();
    expect(testDividerParam38.primary.posY === '0%').assertTrue();
    expect(testDividerParam38.secondary.posX === '0%').assertTrue();
    expect(testDividerParam38.secondary.posY === '0%').assertTrue();
    expect(testDividerParam38.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam38.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_039', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer39: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer39.init();
    let testDividerParam39 = testContainer39.dividerParam;
    testDividerParam39.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer39);

    expect(testContainer39.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer39.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer39.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer39.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer39.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer39.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer39.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer39.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer39.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer39.needRenderPos.posX === 0).assertTrue();
    expect(testContainer39.needRenderPos.posY === 0).assertTrue();
    expect(testContainer39.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer39.iconAlpha === 0).assertTrue();
    expect(testContainer39.iconAlpha === 0).assertTrue();
    expect(testContainer39.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer39.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer39.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer39.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer39.intelligentScene === 1).assertTrue();

    expect(testDividerParam39.primary.translateY === 0).assertTrue();
    expect(testDividerParam39.primary.translateX === 0).assertTrue();
    expect(testDividerParam39.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam39.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam39.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam39.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam39.primary.opacity === 1).assertTrue();
    expect(testDividerParam39.primary.blurScale === 0).assertTrue();
    expect(testDividerParam39.secondary.opacity === 1).assertTrue();
    expect(testDividerParam39.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam39.primary.rotateX === 0).assertTrue();
    expect(testDividerParam39.primary.rotateY === 0).assertTrue();
    expect(testDividerParam39.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam39.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam39.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam39.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam39.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam39.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam39.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam39.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam39.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam39.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam39.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam39.primary.posX === '0%').assertTrue();
    expect(testDividerParam39.primary.posY === '0%').assertTrue();
    expect(testDividerParam39.secondary.posX === '0%').assertTrue();
    expect(testDividerParam39.secondary.posY === '0%').assertTrue();
    expect(testDividerParam39.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam39.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_040', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer40: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer40.init();
    let testDividerParam40 = testContainer40.dividerParam;
    testDividerParam40.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer40);

    expect(testContainer40.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer40.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer40.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer40.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer40.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer40.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer40.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer40.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer40.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer40.needRenderPos.posX === 0).assertTrue();
    expect(testContainer40.needRenderPos.posY === 0).assertTrue();
    expect(testContainer40.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer40.iconAlpha === 0).assertTrue();
    expect(testContainer40.iconAlpha === 0).assertTrue();
    expect(testContainer40.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer40.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer40.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer40.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer40.intelligentScene === 1).assertTrue();

    expect(testDividerParam40.primary.translateY === 0).assertTrue();
    expect(testDividerParam40.primary.translateX === 0).assertTrue();
    expect(testDividerParam40.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam40.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam40.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam40.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam40.primary.opacity === 1).assertTrue();
    expect(testDividerParam40.primary.blurScale === 0).assertTrue();
    expect(testDividerParam40.secondary.opacity === 1).assertTrue();
    expect(testDividerParam40.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam40.primary.rotateX === 0).assertTrue();
    expect(testDividerParam40.primary.rotateY === 0).assertTrue();
    expect(testDividerParam40.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam40.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam40.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam40.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam40.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam40.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam40.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam40.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam40.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam40.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam40.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam40.primary.posX === '0%').assertTrue();
    expect(testDividerParam40.primary.posY === '0%').assertTrue();
    expect(testDividerParam40.secondary.posX === '0%').assertTrue();
    expect(testDividerParam40.secondary.posY === '0%').assertTrue();
    expect(testDividerParam40.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam40.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_041', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer41: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer41.init();
    let testDividerParam41 = testContainer41.dividerParam;
    testDividerParam41.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer41);

    expect(testContainer41.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer41.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer41.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer41.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer41.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer41.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer41.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer41.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer41.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer41.needRenderPos.posX === 0).assertTrue();
    expect(testContainer41.needRenderPos.posY === 0).assertTrue();
    expect(testContainer41.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer41.iconAlpha === 0).assertTrue();
    expect(testContainer41.iconAlpha === 0).assertTrue();
    expect(testContainer41.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer41.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer41.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer41.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer41.intelligentScene === 1).assertTrue();

    expect(testDividerParam41.primary.translateY === 0).assertTrue();
    expect(testDividerParam41.primary.translateX === 0).assertTrue();
    expect(testDividerParam41.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam41.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam41.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam41.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam41.primary.opacity === 1).assertTrue();
    expect(testDividerParam41.primary.blurScale === 0).assertTrue();
    expect(testDividerParam41.secondary.opacity === 1).assertTrue();
    expect(testDividerParam41.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam41.primary.rotateX === 0).assertTrue();
    expect(testDividerParam41.primary.rotateY === 0).assertTrue();
    expect(testDividerParam41.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam41.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam41.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam41.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam41.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam41.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam41.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam41.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam41.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam41.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam41.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam41.primary.posX === '0%').assertTrue();
    expect(testDividerParam41.primary.posY === '0%').assertTrue();
    expect(testDividerParam41.secondary.posX === '0%').assertTrue();
    expect(testDividerParam41.secondary.posY === '0%').assertTrue();
    expect(testDividerParam41.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam41.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_042', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer42: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer42.init();
    let testDividerParam42 = testContainer42.dividerParam;
    testDividerParam42.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer42);

    expect(testContainer42.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer42.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer42.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer42.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer42.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer42.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer42.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer42.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer42.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer42.needRenderPos.posX === 0).assertTrue();
    expect(testContainer42.needRenderPos.posY === 0).assertTrue();
    expect(testContainer42.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer42.iconAlpha === 0).assertTrue();
    expect(testContainer42.iconAlpha === 0).assertTrue();
    expect(testContainer42.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer42.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer42.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer42.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer42.intelligentScene === 1).assertTrue();

    expect(testDividerParam42.primary.translateY === 0).assertTrue();
    expect(testDividerParam42.primary.translateX === 0).assertTrue();
    expect(testDividerParam42.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam42.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam42.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam42.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam42.primary.opacity === 1).assertTrue();
    expect(testDividerParam42.primary.blurScale === 0).assertTrue();
    expect(testDividerParam42.secondary.opacity === 1).assertTrue();
    expect(testDividerParam42.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam42.primary.rotateX === 0).assertTrue();
    expect(testDividerParam42.primary.rotateY === 0).assertTrue();
    expect(testDividerParam42.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam42.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam42.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam42.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam42.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam42.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam42.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam42.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam42.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam42.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam42.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam42.primary.posX === '0%').assertTrue();
    expect(testDividerParam42.primary.posY === '0%').assertTrue();
    expect(testDividerParam42.secondary.posX === '0%').assertTrue();
    expect(testDividerParam42.secondary.posY === '0%').assertTrue();
    expect(testDividerParam42.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam42.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_043', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer43: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer43.init();
    let testDividerParam43 = testContainer43.dividerParam;
    testDividerParam43.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer43);

    expect(testContainer43.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer43.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer43.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer43.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer43.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer43.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer43.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer43.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer43.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer43.needRenderPos.posX === 0).assertTrue();
    expect(testContainer43.needRenderPos.posY === 0).assertTrue();
    expect(testContainer43.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer43.iconAlpha === 0).assertTrue();
    expect(testContainer43.iconAlpha === 0).assertTrue();
    expect(testContainer43.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer43.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer43.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer43.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer43.intelligentScene === 1).assertTrue();

    expect(testDividerParam43.primary.translateY === 0).assertTrue();
    expect(testDividerParam43.primary.translateX === 0).assertTrue();
    expect(testDividerParam43.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam43.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam43.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam43.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam43.primary.opacity === 1).assertTrue();
    expect(testDividerParam43.primary.blurScale === 0).assertTrue();
    expect(testDividerParam43.secondary.opacity === 1).assertTrue();
    expect(testDividerParam43.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam43.primary.rotateX === 0).assertTrue();
    expect(testDividerParam43.primary.rotateY === 0).assertTrue();
    expect(testDividerParam43.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam43.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam43.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam43.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam43.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam43.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam43.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam43.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam43.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam43.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam43.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam43.primary.posX === '0%').assertTrue();
    expect(testDividerParam43.primary.posY === '0%').assertTrue();
    expect(testDividerParam43.secondary.posX === '0%').assertTrue();
    expect(testDividerParam43.secondary.posY === '0%').assertTrue();
    expect(testDividerParam43.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam43.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_044', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer44: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer44.init();
    let testDividerParam44 = testContainer44.dividerParam;
    testDividerParam44.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer44);

    expect(testContainer44.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer44.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer44.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer44.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer44.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer44.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer44.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer44.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer44.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer44.needRenderPos.posX === 0).assertTrue();
    expect(testContainer44.needRenderPos.posY === 0).assertTrue();
    expect(testContainer44.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer44.iconAlpha === 0).assertTrue();
    expect(testContainer44.iconAlpha === 0).assertTrue();
    expect(testContainer44.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer44.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer44.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer44.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer44.intelligentScene === 1).assertTrue();

    expect(testDividerParam44.primary.translateY === 0).assertTrue();
    expect(testDividerParam44.primary.translateX === 0).assertTrue();
    expect(testDividerParam44.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam44.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam44.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam44.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam44.primary.opacity === 1).assertTrue();
    expect(testDividerParam44.primary.blurScale === 0).assertTrue();
    expect(testDividerParam44.secondary.opacity === 1).assertTrue();
    expect(testDividerParam44.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam44.primary.rotateX === 0).assertTrue();
    expect(testDividerParam44.primary.rotateY === 0).assertTrue();
    expect(testDividerParam44.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam44.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam44.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam44.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam44.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam44.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam44.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam44.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam44.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam44.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam44.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam44.primary.posX === '0%').assertTrue();
    expect(testDividerParam44.primary.posY === '0%').assertTrue();
    expect(testDividerParam44.secondary.posX === '0%').assertTrue();
    expect(testDividerParam44.secondary.posY === '0%').assertTrue();
    expect(testDividerParam44.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam44.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_045', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer45: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer45.init();
    let testDividerParam45 = testContainer45.dividerParam;
    testDividerParam45.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer45);

    expect(testContainer45.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer45.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer45.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer45.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer45.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer45.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer45.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer45.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer45.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer45.needRenderPos.posX === 0).assertTrue();
    expect(testContainer45.needRenderPos.posY === 0).assertTrue();
    expect(testContainer45.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer45.iconAlpha === 0).assertTrue();
    expect(testContainer45.iconAlpha === 0).assertTrue();
    expect(testContainer45.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer45.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer45.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer45.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer45.intelligentScene === 1).assertTrue();

    expect(testDividerParam45.primary.translateY === 0).assertTrue();
    expect(testDividerParam45.primary.translateX === 0).assertTrue();
    expect(testDividerParam45.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam45.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam45.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam45.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam45.primary.opacity === 1).assertTrue();
    expect(testDividerParam45.primary.blurScale === 0).assertTrue();
    expect(testDividerParam45.secondary.opacity === 1).assertTrue();
    expect(testDividerParam45.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam45.primary.rotateX === 0).assertTrue();
    expect(testDividerParam45.primary.rotateY === 0).assertTrue();
    expect(testDividerParam45.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam45.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam45.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam45.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam45.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam45.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam45.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam45.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam45.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam45.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam45.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam45.primary.posX === '0%').assertTrue();
    expect(testDividerParam45.primary.posY === '0%').assertTrue();
    expect(testDividerParam45.secondary.posX === '0%').assertTrue();
    expect(testDividerParam45.secondary.posY === '0%').assertTrue();
    expect(testDividerParam45.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam45.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_046', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer46: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer46.init();
    let testDividerParam46 = testContainer46.dividerParam;
    testDividerParam46.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer46);

    expect(testContainer46.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer46.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer46.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer46.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer46.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer46.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer46.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer46.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer46.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer46.needRenderPos.posX === 0).assertTrue();
    expect(testContainer46.needRenderPos.posY === 0).assertTrue();
    expect(testContainer46.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer46.iconAlpha === 0).assertTrue();
    expect(testContainer46.iconAlpha === 0).assertTrue();
    expect(testContainer46.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer46.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer46.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer46.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer46.intelligentScene === 1).assertTrue();

    expect(testDividerParam46.primary.translateY === 0).assertTrue();
    expect(testDividerParam46.primary.translateX === 0).assertTrue();
    expect(testDividerParam46.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam46.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam46.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam46.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam46.primary.opacity === 1).assertTrue();
    expect(testDividerParam46.primary.blurScale === 0).assertTrue();
    expect(testDividerParam46.secondary.opacity === 1).assertTrue();
    expect(testDividerParam46.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam46.primary.rotateX === 0).assertTrue();
    expect(testDividerParam46.primary.rotateY === 0).assertTrue();
    expect(testDividerParam46.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam46.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam46.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam46.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam46.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam46.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam46.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam46.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam46.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam46.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam46.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam46.primary.posX === '0%').assertTrue();
    expect(testDividerParam46.primary.posY === '0%').assertTrue();
    expect(testDividerParam46.secondary.posX === '0%').assertTrue();
    expect(testDividerParam46.secondary.posY === '0%').assertTrue();
    expect(testDividerParam46.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam46.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_047', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer47: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer47.init();
    let testDividerParam47 = testContainer47.dividerParam;
    testDividerParam47.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer47);

    expect(testContainer47.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer47.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer47.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer47.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer47.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer47.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer47.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer47.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer47.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer47.needRenderPos.posX === 0).assertTrue();
    expect(testContainer47.needRenderPos.posY === 0).assertTrue();
    expect(testContainer47.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer47.iconAlpha === 0).assertTrue();
    expect(testContainer47.iconAlpha === 0).assertTrue();
    expect(testContainer47.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer47.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer47.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer47.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer47.intelligentScene === 1).assertTrue();

    expect(testDividerParam47.primary.translateY === 0).assertTrue();
    expect(testDividerParam47.primary.translateX === 0).assertTrue();
    expect(testDividerParam47.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam47.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam47.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam47.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam47.primary.opacity === 1).assertTrue();
    expect(testDividerParam47.primary.blurScale === 0).assertTrue();
    expect(testDividerParam47.secondary.opacity === 1).assertTrue();
    expect(testDividerParam47.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam47.primary.rotateX === 0).assertTrue();
    expect(testDividerParam47.primary.rotateY === 0).assertTrue();
    expect(testDividerParam47.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam47.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam47.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam47.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam47.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam47.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam47.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam47.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam47.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam47.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam47.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam47.primary.posX === '0%').assertTrue();
    expect(testDividerParam47.primary.posY === '0%').assertTrue();
    expect(testDividerParam47.secondary.posX === '0%').assertTrue();
    expect(testDividerParam47.secondary.posY === '0%').assertTrue();
    expect(testDividerParam47.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam47.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_048', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer48: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer48.init();
    let testDividerParam48 = testContainer48.dividerParam;
    testDividerParam48.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer48);

    expect(testContainer48.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer48.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer48.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer48.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer48.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer48.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer48.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer48.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer48.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer48.needRenderPos.posX === 0).assertTrue();
    expect(testContainer48.needRenderPos.posY === 0).assertTrue();
    expect(testContainer48.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer48.iconAlpha === 0).assertTrue();
    expect(testContainer48.iconAlpha === 0).assertTrue();
    expect(testContainer48.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer48.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer48.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer48.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer48.intelligentScene === 1).assertTrue();

    expect(testDividerParam48.primary.translateY === 0).assertTrue();
    expect(testDividerParam48.primary.translateX === 0).assertTrue();
    expect(testDividerParam48.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam48.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam48.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam48.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam48.primary.opacity === 1).assertTrue();
    expect(testDividerParam48.primary.blurScale === 0).assertTrue();
    expect(testDividerParam48.secondary.opacity === 1).assertTrue();
    expect(testDividerParam48.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam48.primary.rotateX === 0).assertTrue();
    expect(testDividerParam48.primary.rotateY === 0).assertTrue();
    expect(testDividerParam48.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam48.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam48.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam48.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam48.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam48.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam48.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam48.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam48.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam48.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam48.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam48.primary.posX === '0%').assertTrue();
    expect(testDividerParam48.primary.posY === '0%').assertTrue();
    expect(testDividerParam48.secondary.posX === '0%').assertTrue();
    expect(testDividerParam48.secondary.posY === '0%').assertTrue();
    expect(testDividerParam48.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam48.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_049', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer49: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer49.init();
    let testDividerParam49 = testContainer49.dividerParam;
    testDividerParam49.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer49);

    expect(testContainer49.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer49.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer49.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer49.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer49.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer49.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer49.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer49.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer49.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer49.needRenderPos.posX === 0).assertTrue();
    expect(testContainer49.needRenderPos.posY === 0).assertTrue();
    expect(testContainer49.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer49.iconAlpha === 0).assertTrue();
    expect(testContainer49.iconAlpha === 0).assertTrue();
    expect(testContainer49.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer49.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer49.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer49.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer49.intelligentScene === 1).assertTrue();

    expect(testDividerParam49.primary.translateY === 0).assertTrue();
    expect(testDividerParam49.primary.translateX === 0).assertTrue();
    expect(testDividerParam49.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam49.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam49.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam49.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam49.primary.opacity === 1).assertTrue();
    expect(testDividerParam49.primary.blurScale === 0).assertTrue();
    expect(testDividerParam49.secondary.opacity === 1).assertTrue();
    expect(testDividerParam49.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam49.primary.rotateX === 0).assertTrue();
    expect(testDividerParam49.primary.rotateY === 0).assertTrue();
    expect(testDividerParam49.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam49.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam49.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam49.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam49.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam49.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam49.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam49.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam49.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam49.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam49.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam49.primary.posX === '0%').assertTrue();
    expect(testDividerParam49.primary.posY === '0%').assertTrue();
    expect(testDividerParam49.secondary.posX === '0%').assertTrue();
    expect(testDividerParam49.secondary.posY === '0%').assertTrue();
    expect(testDividerParam49.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam49.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_050', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer50: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer50.init();
    let testDividerParam50 = testContainer50.dividerParam;
    testDividerParam50.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer50);

    expect(testContainer50.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer50.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer50.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer50.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer50.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer50.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer50.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer50.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer50.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer50.needRenderPos.posX === 0).assertTrue();
    expect(testContainer50.needRenderPos.posY === 0).assertTrue();
    expect(testContainer50.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer50.iconAlpha === 0).assertTrue();
    expect(testContainer50.iconAlpha === 0).assertTrue();
    expect(testContainer50.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer50.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer50.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer50.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer50.intelligentScene === 1).assertTrue();

    expect(testDividerParam50.primary.translateY === 0).assertTrue();
    expect(testDividerParam50.primary.translateX === 0).assertTrue();
    expect(testDividerParam50.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam50.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam50.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam50.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam50.primary.opacity === 1).assertTrue();
    expect(testDividerParam50.primary.blurScale === 0).assertTrue();
    expect(testDividerParam50.secondary.opacity === 1).assertTrue();
    expect(testDividerParam50.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam50.primary.rotateX === 0).assertTrue();
    expect(testDividerParam50.primary.rotateY === 0).assertTrue();
    expect(testDividerParam50.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam50.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam50.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam50.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam50.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam50.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam50.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam50.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam50.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam50.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam50.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam50.primary.posX === '0%').assertTrue();
    expect(testDividerParam50.primary.posY === '0%').assertTrue();
    expect(testDividerParam50.secondary.posX === '0%').assertTrue();
    expect(testDividerParam50.secondary.posY === '0%').assertTrue();
    expect(testDividerParam50.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam50.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_051', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer51: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer51.init();
    let testDividerParam51 = testContainer51.dividerParam;
    testDividerParam51.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer51);

    expect(testContainer51.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer51.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer51.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer51.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer51.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer51.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer51.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer51.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer51.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer51.needRenderPos.posX === 0).assertTrue();
    expect(testContainer51.needRenderPos.posY === 0).assertTrue();
    expect(testContainer51.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer51.iconAlpha === 0).assertTrue();
    expect(testContainer51.iconAlpha === 0).assertTrue();
    expect(testContainer51.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer51.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer51.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer51.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer51.intelligentScene === 1).assertTrue();

    expect(testDividerParam51.primary.translateY === 0).assertTrue();
    expect(testDividerParam51.primary.translateX === 0).assertTrue();
    expect(testDividerParam51.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam51.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam51.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam51.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam51.primary.opacity === 1).assertTrue();
    expect(testDividerParam51.primary.blurScale === 0).assertTrue();
    expect(testDividerParam51.secondary.opacity === 1).assertTrue();
    expect(testDividerParam51.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam51.primary.rotateX === 0).assertTrue();
    expect(testDividerParam51.primary.rotateY === 0).assertTrue();
    expect(testDividerParam51.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam51.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam51.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam51.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam51.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam51.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam51.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam51.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam51.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam51.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam51.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam51.primary.posX === '0%').assertTrue();
    expect(testDividerParam51.primary.posY === '0%').assertTrue();
    expect(testDividerParam51.secondary.posX === '0%').assertTrue();
    expect(testDividerParam51.secondary.posY === '0%').assertTrue();
    expect(testDividerParam51.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam51.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_052', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer52: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer52.init();
    let testDividerParam52 = testContainer52.dividerParam;
    testDividerParam52.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer52);

    expect(testContainer52.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer52.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer52.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer52.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer52.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer52.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer52.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer52.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer52.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer52.needRenderPos.posX === 0).assertTrue();
    expect(testContainer52.needRenderPos.posY === 0).assertTrue();
    expect(testContainer52.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer52.iconAlpha === 0).assertTrue();
    expect(testContainer52.iconAlpha === 0).assertTrue();
    expect(testContainer52.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer52.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer52.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer52.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer52.intelligentScene === 1).assertTrue();

    expect(testDividerParam52.primary.translateY === 0).assertTrue();
    expect(testDividerParam52.primary.translateX === 0).assertTrue();
    expect(testDividerParam52.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam52.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam52.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam52.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam52.primary.opacity === 1).assertTrue();
    expect(testDividerParam52.primary.blurScale === 0).assertTrue();
    expect(testDividerParam52.secondary.opacity === 1).assertTrue();
    expect(testDividerParam52.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam52.primary.rotateX === 0).assertTrue();
    expect(testDividerParam52.primary.rotateY === 0).assertTrue();
    expect(testDividerParam52.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam52.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam52.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam52.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam52.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam52.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam52.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam52.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam52.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam52.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam52.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam52.primary.posX === '0%').assertTrue();
    expect(testDividerParam52.primary.posY === '0%').assertTrue();
    expect(testDividerParam52.secondary.posX === '0%').assertTrue();
    expect(testDividerParam52.secondary.posY === '0%').assertTrue();
    expect(testDividerParam52.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam52.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_053', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer53: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer53.init();
    let testDividerParam53 = testContainer53.dividerParam;
    testDividerParam53.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer53);

    expect(testContainer53.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer53.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer53.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer53.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer53.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer53.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer53.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer53.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer53.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer53.needRenderPos.posX === 0).assertTrue();
    expect(testContainer53.needRenderPos.posY === 0).assertTrue();
    expect(testContainer53.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer53.iconAlpha === 0).assertTrue();
    expect(testContainer53.iconAlpha === 0).assertTrue();
    expect(testContainer53.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer53.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer53.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer53.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer53.intelligentScene === 1).assertTrue();

    expect(testDividerParam53.primary.translateY === 0).assertTrue();
    expect(testDividerParam53.primary.translateX === 0).assertTrue();
    expect(testDividerParam53.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam53.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam53.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam53.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam53.primary.opacity === 1).assertTrue();
    expect(testDividerParam53.primary.blurScale === 0).assertTrue();
    expect(testDividerParam53.secondary.opacity === 1).assertTrue();
    expect(testDividerParam53.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam53.primary.rotateX === 0).assertTrue();
    expect(testDividerParam53.primary.rotateY === 0).assertTrue();
    expect(testDividerParam53.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam53.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam53.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam53.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam53.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam53.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam53.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam53.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam53.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam53.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam53.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam53.primary.posX === '0%').assertTrue();
    expect(testDividerParam53.primary.posY === '0%').assertTrue();
    expect(testDividerParam53.secondary.posX === '0%').assertTrue();
    expect(testDividerParam53.secondary.posY === '0%').assertTrue();
    expect(testDividerParam53.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam53.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_054', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer54: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer54.init();
    let testDividerParam54 = testContainer54.dividerParam;
    testDividerParam54.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer54);

    expect(testContainer54.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer54.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer54.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer54.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer54.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer54.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer54.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer54.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer54.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer54.needRenderPos.posX === 0).assertTrue();
    expect(testContainer54.needRenderPos.posY === 0).assertTrue();
    expect(testContainer54.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer54.iconAlpha === 0).assertTrue();
    expect(testContainer54.iconAlpha === 0).assertTrue();
    expect(testContainer54.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer54.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer54.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer54.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer54.intelligentScene === 1).assertTrue();

    expect(testDividerParam54.primary.translateY === 0).assertTrue();
    expect(testDividerParam54.primary.translateX === 0).assertTrue();
    expect(testDividerParam54.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam54.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam54.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam54.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam54.primary.opacity === 1).assertTrue();
    expect(testDividerParam54.primary.blurScale === 0).assertTrue();
    expect(testDividerParam54.secondary.opacity === 1).assertTrue();
    expect(testDividerParam54.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam54.primary.rotateX === 0).assertTrue();
    expect(testDividerParam54.primary.rotateY === 0).assertTrue();
    expect(testDividerParam54.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam54.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam54.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam54.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam54.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam54.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam54.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam54.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam54.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam54.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam54.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam54.primary.posX === '0%').assertTrue();
    expect(testDividerParam54.primary.posY === '0%').assertTrue();
    expect(testDividerParam54.secondary.posX === '0%').assertTrue();
    expect(testDividerParam54.secondary.posY === '0%').assertTrue();
    expect(testDividerParam54.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam54.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_055', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer55: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer55.init();
    let testDividerParam55 = testContainer55.dividerParam;
    testDividerParam55.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer55);

    expect(testContainer55.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer55.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer55.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer55.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer55.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer55.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer55.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer55.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer55.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer55.needRenderPos.posX === 0).assertTrue();
    expect(testContainer55.needRenderPos.posY === 0).assertTrue();
    expect(testContainer55.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer55.iconAlpha === 0).assertTrue();
    expect(testContainer55.iconAlpha === 0).assertTrue();
    expect(testContainer55.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer55.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer55.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer55.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer55.intelligentScene === 1).assertTrue();

    expect(testDividerParam55.primary.translateY === 0).assertTrue();
    expect(testDividerParam55.primary.translateX === 0).assertTrue();
    expect(testDividerParam55.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam55.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam55.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam55.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam55.primary.opacity === 1).assertTrue();
    expect(testDividerParam55.primary.blurScale === 0).assertTrue();
    expect(testDividerParam55.secondary.opacity === 1).assertTrue();
    expect(testDividerParam55.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam55.primary.rotateX === 0).assertTrue();
    expect(testDividerParam55.primary.rotateY === 0).assertTrue();
    expect(testDividerParam55.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam55.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam55.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam55.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam55.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam55.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam55.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam55.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam55.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam55.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam55.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam55.primary.posX === '0%').assertTrue();
    expect(testDividerParam55.primary.posY === '0%').assertTrue();
    expect(testDividerParam55.secondary.posX === '0%').assertTrue();
    expect(testDividerParam55.secondary.posY === '0%').assertTrue();
    expect(testDividerParam55.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam55.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_056', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer56: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer56.init();
    let testDividerParam56 = testContainer56.dividerParam;
    testDividerParam56.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer56);

    expect(testContainer56.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer56.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer56.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer56.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer56.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer56.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer56.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer56.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer56.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer56.needRenderPos.posX === 0).assertTrue();
    expect(testContainer56.needRenderPos.posY === 0).assertTrue();
    expect(testContainer56.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer56.iconAlpha === 0).assertTrue();
    expect(testContainer56.iconAlpha === 0).assertTrue();
    expect(testContainer56.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer56.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer56.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer56.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer56.intelligentScene === 1).assertTrue();

    expect(testDividerParam56.primary.translateY === 0).assertTrue();
    expect(testDividerParam56.primary.translateX === 0).assertTrue();
    expect(testDividerParam56.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam56.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam56.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam56.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam56.primary.opacity === 1).assertTrue();
    expect(testDividerParam56.primary.blurScale === 0).assertTrue();
    expect(testDividerParam56.secondary.opacity === 1).assertTrue();
    expect(testDividerParam56.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam56.primary.rotateX === 0).assertTrue();
    expect(testDividerParam56.primary.rotateY === 0).assertTrue();
    expect(testDividerParam56.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam56.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam56.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam56.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam56.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam56.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam56.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam56.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam56.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam56.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam56.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam56.primary.posX === '0%').assertTrue();
    expect(testDividerParam56.primary.posY === '0%').assertTrue();
    expect(testDividerParam56.secondary.posX === '0%').assertTrue();
    expect(testDividerParam56.secondary.posY === '0%').assertTrue();
    expect(testDividerParam56.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam56.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_057', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer57: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer57.init();
    let testDividerParam57 = testContainer57.dividerParam;
    testDividerParam57.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer57);

    expect(testContainer57.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer57.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer57.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer57.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer57.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer57.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer57.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer57.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer57.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer57.needRenderPos.posX === 0).assertTrue();
    expect(testContainer57.needRenderPos.posY === 0).assertTrue();
    expect(testContainer57.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer57.iconAlpha === 0).assertTrue();
    expect(testContainer57.iconAlpha === 0).assertTrue();
    expect(testContainer57.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer57.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer57.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer57.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer57.intelligentScene === 1).assertTrue();

    expect(testDividerParam57.primary.translateY === 0).assertTrue();
    expect(testDividerParam57.primary.translateX === 0).assertTrue();
    expect(testDividerParam57.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam57.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam57.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam57.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam57.primary.opacity === 1).assertTrue();
    expect(testDividerParam57.primary.blurScale === 0).assertTrue();
    expect(testDividerParam57.secondary.opacity === 1).assertTrue();
    expect(testDividerParam57.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam57.primary.rotateX === 0).assertTrue();
    expect(testDividerParam57.primary.rotateY === 0).assertTrue();
    expect(testDividerParam57.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam57.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam57.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam57.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam57.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam57.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam57.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam57.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam57.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam57.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam57.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam57.primary.posX === '0%').assertTrue();
    expect(testDividerParam57.primary.posY === '0%').assertTrue();
    expect(testDividerParam57.secondary.posX === '0%').assertTrue();
    expect(testDividerParam57.secondary.posY === '0%').assertTrue();
    expect(testDividerParam57.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam57.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_058', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer58: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer58.init();
    let testDividerParam58 = testContainer58.dividerParam;
    testDividerParam58.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer58);

    expect(testContainer58.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer58.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer58.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer58.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer58.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer58.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer58.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer58.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer58.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer58.needRenderPos.posX === 0).assertTrue();
    expect(testContainer58.needRenderPos.posY === 0).assertTrue();
    expect(testContainer58.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer58.iconAlpha === 0).assertTrue();
    expect(testContainer58.iconAlpha === 0).assertTrue();
    expect(testContainer58.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer58.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer58.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer58.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer58.intelligentScene === 1).assertTrue();

    expect(testDividerParam58.primary.translateY === 0).assertTrue();
    expect(testDividerParam58.primary.translateX === 0).assertTrue();
    expect(testDividerParam58.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam58.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam58.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam58.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam58.primary.opacity === 1).assertTrue();
    expect(testDividerParam58.primary.blurScale === 0).assertTrue();
    expect(testDividerParam58.secondary.opacity === 1).assertTrue();
    expect(testDividerParam58.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam58.primary.rotateX === 0).assertTrue();
    expect(testDividerParam58.primary.rotateY === 0).assertTrue();
    expect(testDividerParam58.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam58.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam58.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam58.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam58.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam58.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam58.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam58.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam58.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam58.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam58.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam58.primary.posX === '0%').assertTrue();
    expect(testDividerParam58.primary.posY === '0%').assertTrue();
    expect(testDividerParam58.secondary.posX === '0%').assertTrue();
    expect(testDividerParam58.secondary.posY === '0%').assertTrue();
    expect(testDividerParam58.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam58.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_059', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer59: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer59.init();
    let testDividerParam59 = testContainer59.dividerParam;
    testDividerParam59.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer59);

    expect(testContainer59.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer59.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer59.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer59.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer59.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer59.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer59.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer59.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer59.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer59.needRenderPos.posX === 0).assertTrue();
    expect(testContainer59.needRenderPos.posY === 0).assertTrue();
    expect(testContainer59.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer59.iconAlpha === 0).assertTrue();
    expect(testContainer59.iconAlpha === 0).assertTrue();
    expect(testContainer59.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer59.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer59.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer59.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer59.intelligentScene === 1).assertTrue();

    expect(testDividerParam59.primary.translateY === 0).assertTrue();
    expect(testDividerParam59.primary.translateX === 0).assertTrue();
    expect(testDividerParam59.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam59.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam59.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam59.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam59.primary.opacity === 1).assertTrue();
    expect(testDividerParam59.primary.blurScale === 0).assertTrue();
    expect(testDividerParam59.secondary.opacity === 1).assertTrue();
    expect(testDividerParam59.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam59.primary.rotateX === 0).assertTrue();
    expect(testDividerParam59.primary.rotateY === 0).assertTrue();
    expect(testDividerParam59.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam59.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam59.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam59.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam59.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam59.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam59.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam59.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam59.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam59.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam59.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam59.primary.posX === '0%').assertTrue();
    expect(testDividerParam59.primary.posY === '0%').assertTrue();
    expect(testDividerParam59.secondary.posX === '0%').assertTrue();
    expect(testDividerParam59.secondary.posY === '0%').assertTrue();
    expect(testDividerParam59.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam59.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_060', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer60: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer60.init();
    let testDividerParam60 = testContainer60.dividerParam;
    testDividerParam60.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer60);

    expect(testContainer60.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer60.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer60.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer60.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer60.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer60.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer60.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer60.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer60.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer60.needRenderPos.posX === 0).assertTrue();
    expect(testContainer60.needRenderPos.posY === 0).assertTrue();
    expect(testContainer60.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer60.iconAlpha === 0).assertTrue();
    expect(testContainer60.iconAlpha === 0).assertTrue();
    expect(testContainer60.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer60.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer60.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer60.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer60.intelligentScene === 1).assertTrue();

    expect(testDividerParam60.primary.translateY === 0).assertTrue();
    expect(testDividerParam60.primary.translateX === 0).assertTrue();
    expect(testDividerParam60.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam60.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam60.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam60.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam60.primary.opacity === 1).assertTrue();
    expect(testDividerParam60.primary.blurScale === 0).assertTrue();
    expect(testDividerParam60.secondary.opacity === 1).assertTrue();
    expect(testDividerParam60.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam60.primary.rotateX === 0).assertTrue();
    expect(testDividerParam60.primary.rotateY === 0).assertTrue();
    expect(testDividerParam60.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam60.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam60.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam60.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam60.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam60.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam60.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam60.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam60.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam60.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam60.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam60.primary.posX === '0%').assertTrue();
    expect(testDividerParam60.primary.posY === '0%').assertTrue();
    expect(testDividerParam60.secondary.posX === '0%').assertTrue();
    expect(testDividerParam60.secondary.posY === '0%').assertTrue();
    expect(testDividerParam60.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam60.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_061', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer61: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer61.init();
    let testDividerParam61 = testContainer61.dividerParam;
    testDividerParam61.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer61);

    expect(testContainer61.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer61.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer61.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer61.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer61.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer61.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer61.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer61.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer61.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer61.needRenderPos.posX === 0).assertTrue();
    expect(testContainer61.needRenderPos.posY === 0).assertTrue();
    expect(testContainer61.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer61.iconAlpha === 0).assertTrue();
    expect(testContainer61.iconAlpha === 0).assertTrue();
    expect(testContainer61.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer61.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer61.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer61.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer61.intelligentScene === 1).assertTrue();

    expect(testDividerParam61.primary.translateY === 0).assertTrue();
    expect(testDividerParam61.primary.translateX === 0).assertTrue();
    expect(testDividerParam61.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam61.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam61.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam61.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam61.primary.opacity === 1).assertTrue();
    expect(testDividerParam61.primary.blurScale === 0).assertTrue();
    expect(testDividerParam61.secondary.opacity === 1).assertTrue();
    expect(testDividerParam61.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam61.primary.rotateX === 0).assertTrue();
    expect(testDividerParam61.primary.rotateY === 0).assertTrue();
    expect(testDividerParam61.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam61.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam61.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam61.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam61.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam61.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam61.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam61.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam61.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam61.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam61.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam61.primary.posX === '0%').assertTrue();
    expect(testDividerParam61.primary.posY === '0%').assertTrue();
    expect(testDividerParam61.secondary.posX === '0%').assertTrue();
    expect(testDividerParam61.secondary.posY === '0%').assertTrue();
    expect(testDividerParam61.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam61.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_062', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer62: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer62.init();
    let testDividerParam62 = testContainer62.dividerParam;
    testDividerParam62.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer62);

    expect(testContainer62.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer62.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer62.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer62.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer62.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer62.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer62.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer62.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer62.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer62.needRenderPos.posX === 0).assertTrue();
    expect(testContainer62.needRenderPos.posY === 0).assertTrue();
    expect(testContainer62.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer62.iconAlpha === 0).assertTrue();
    expect(testContainer62.iconAlpha === 0).assertTrue();
    expect(testContainer62.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer62.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer62.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer62.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer62.intelligentScene === 1).assertTrue();

    expect(testDividerParam62.primary.translateY === 0).assertTrue();
    expect(testDividerParam62.primary.translateX === 0).assertTrue();
    expect(testDividerParam62.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam62.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam62.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam62.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam62.primary.opacity === 1).assertTrue();
    expect(testDividerParam62.primary.blurScale === 0).assertTrue();
    expect(testDividerParam62.secondary.opacity === 1).assertTrue();
    expect(testDividerParam62.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam62.primary.rotateX === 0).assertTrue();
    expect(testDividerParam62.primary.rotateY === 0).assertTrue();
    expect(testDividerParam62.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam62.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam62.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam62.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam62.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam62.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam62.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam62.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam62.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam62.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam62.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam62.primary.posX === '0%').assertTrue();
    expect(testDividerParam62.primary.posY === '0%').assertTrue();
    expect(testDividerParam62.secondary.posX === '0%').assertTrue();
    expect(testDividerParam62.secondary.posY === '0%').assertTrue();
    expect(testDividerParam62.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam62.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_063', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer63: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer63.init();
    let testDividerParam63 = testContainer63.dividerParam;
    testDividerParam63.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer63);

    expect(testContainer63.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer63.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer63.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer63.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer63.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer63.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer63.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer63.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer63.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer63.needRenderPos.posX === 0).assertTrue();
    expect(testContainer63.needRenderPos.posY === 0).assertTrue();
    expect(testContainer63.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer63.iconAlpha === 0).assertTrue();
    expect(testContainer63.iconAlpha === 0).assertTrue();
    expect(testContainer63.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer63.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer63.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer63.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer63.intelligentScene === 1).assertTrue();

    expect(testDividerParam63.primary.translateY === 0).assertTrue();
    expect(testDividerParam63.primary.translateX === 0).assertTrue();
    expect(testDividerParam63.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam63.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam63.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam63.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam63.primary.opacity === 1).assertTrue();
    expect(testDividerParam63.primary.blurScale === 0).assertTrue();
    expect(testDividerParam63.secondary.opacity === 1).assertTrue();
    expect(testDividerParam63.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam63.primary.rotateX === 0).assertTrue();
    expect(testDividerParam63.primary.rotateY === 0).assertTrue();
    expect(testDividerParam63.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam63.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam63.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam63.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam63.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam63.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam63.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam63.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam63.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam63.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam63.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam63.primary.posX === '0%').assertTrue();
    expect(testDividerParam63.primary.posY === '0%').assertTrue();
    expect(testDividerParam63.secondary.posX === '0%').assertTrue();
    expect(testDividerParam63.secondary.posY === '0%').assertTrue();
    expect(testDividerParam63.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam63.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_064', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer64: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer64.init();
    let testDividerParam64 = testContainer64.dividerParam;
    testDividerParam64.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer64);

    expect(testContainer64.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer64.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer64.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer64.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer64.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer64.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer64.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer64.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer64.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer64.needRenderPos.posX === 0).assertTrue();
    expect(testContainer64.needRenderPos.posY === 0).assertTrue();
    expect(testContainer64.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer64.iconAlpha === 0).assertTrue();
    expect(testContainer64.iconAlpha === 0).assertTrue();
    expect(testContainer64.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer64.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer64.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer64.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer64.intelligentScene === 1).assertTrue();

    expect(testDividerParam64.primary.translateY === 0).assertTrue();
    expect(testDividerParam64.primary.translateX === 0).assertTrue();
    expect(testDividerParam64.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam64.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam64.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam64.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam64.primary.opacity === 1).assertTrue();
    expect(testDividerParam64.primary.blurScale === 0).assertTrue();
    expect(testDividerParam64.secondary.opacity === 1).assertTrue();
    expect(testDividerParam64.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam64.primary.rotateX === 0).assertTrue();
    expect(testDividerParam64.primary.rotateY === 0).assertTrue();
    expect(testDividerParam64.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam64.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam64.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam64.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam64.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam64.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam64.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam64.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam64.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam64.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam64.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam64.primary.posX === '0%').assertTrue();
    expect(testDividerParam64.primary.posY === '0%').assertTrue();
    expect(testDividerParam64.secondary.posX === '0%').assertTrue();
    expect(testDividerParam64.secondary.posY === '0%').assertTrue();
    expect(testDividerParam64.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam64.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_065', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer65: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer65.init();
    let testDividerParam65 = testContainer65.dividerParam;
    testDividerParam65.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer65);

    expect(testContainer65.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer65.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer65.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer65.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer65.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer65.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer65.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer65.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer65.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer65.needRenderPos.posX === 0).assertTrue();
    expect(testContainer65.needRenderPos.posY === 0).assertTrue();
    expect(testContainer65.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer65.iconAlpha === 0).assertTrue();
    expect(testContainer65.iconAlpha === 0).assertTrue();
    expect(testContainer65.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer65.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer65.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer65.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer65.intelligentScene === 1).assertTrue();

    expect(testDividerParam65.primary.translateY === 0).assertTrue();
    expect(testDividerParam65.primary.translateX === 0).assertTrue();
    expect(testDividerParam65.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam65.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam65.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam65.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam65.primary.opacity === 1).assertTrue();
    expect(testDividerParam65.primary.blurScale === 0).assertTrue();
    expect(testDividerParam65.secondary.opacity === 1).assertTrue();
    expect(testDividerParam65.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam65.primary.rotateX === 0).assertTrue();
    expect(testDividerParam65.primary.rotateY === 0).assertTrue();
    expect(testDividerParam65.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam65.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam65.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam65.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam65.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam65.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam65.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam65.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam65.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam65.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam65.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam65.primary.posX === '0%').assertTrue();
    expect(testDividerParam65.primary.posY === '0%').assertTrue();
    expect(testDividerParam65.secondary.posX === '0%').assertTrue();
    expect(testDividerParam65.secondary.posY === '0%').assertTrue();
    expect(testDividerParam65.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam65.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_066', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer66: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer66.init();
    let testDividerParam66 = testContainer66.dividerParam;
    testDividerParam66.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer66);

    expect(testContainer66.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer66.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer66.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer66.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer66.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer66.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer66.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer66.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer66.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer66.needRenderPos.posX === 0).assertTrue();
    expect(testContainer66.needRenderPos.posY === 0).assertTrue();
    expect(testContainer66.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer66.iconAlpha === 0).assertTrue();
    expect(testContainer66.iconAlpha === 0).assertTrue();
    expect(testContainer66.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer66.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer66.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer66.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer66.intelligentScene === 1).assertTrue();

    expect(testDividerParam66.primary.translateY === 0).assertTrue();
    expect(testDividerParam66.primary.translateX === 0).assertTrue();
    expect(testDividerParam66.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam66.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam66.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam66.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam66.primary.opacity === 1).assertTrue();
    expect(testDividerParam66.primary.blurScale === 0).assertTrue();
    expect(testDividerParam66.secondary.opacity === 1).assertTrue();
    expect(testDividerParam66.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam66.primary.rotateX === 0).assertTrue();
    expect(testDividerParam66.primary.rotateY === 0).assertTrue();
    expect(testDividerParam66.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam66.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam66.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam66.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam66.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam66.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam66.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam66.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam66.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam66.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam66.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam66.primary.posX === '0%').assertTrue();
    expect(testDividerParam66.primary.posY === '0%').assertTrue();
    expect(testDividerParam66.secondary.posX === '0%').assertTrue();
    expect(testDividerParam66.secondary.posY === '0%').assertTrue();
    expect(testDividerParam66.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam66.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_067', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer67: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer67.init();
    let testDividerParam67 = testContainer67.dividerParam;
    testDividerParam67.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer67);

    expect(testContainer67.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer67.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer67.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer67.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer67.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer67.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer67.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer67.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer67.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer67.needRenderPos.posX === 0).assertTrue();
    expect(testContainer67.needRenderPos.posY === 0).assertTrue();
    expect(testContainer67.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer67.iconAlpha === 0).assertTrue();
    expect(testContainer67.iconAlpha === 0).assertTrue();
    expect(testContainer67.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer67.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer67.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer67.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer67.intelligentScene === 1).assertTrue();

    expect(testDividerParam67.primary.translateY === 0).assertTrue();
    expect(testDividerParam67.primary.translateX === 0).assertTrue();
    expect(testDividerParam67.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam67.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam67.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam67.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam67.primary.opacity === 1).assertTrue();
    expect(testDividerParam67.primary.blurScale === 0).assertTrue();
    expect(testDividerParam67.secondary.opacity === 1).assertTrue();
    expect(testDividerParam67.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam67.primary.rotateX === 0).assertTrue();
    expect(testDividerParam67.primary.rotateY === 0).assertTrue();
    expect(testDividerParam67.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam67.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam67.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam67.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam67.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam67.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam67.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam67.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam67.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam67.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam67.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam67.primary.posX === '0%').assertTrue();
    expect(testDividerParam67.primary.posY === '0%').assertTrue();
    expect(testDividerParam67.secondary.posX === '0%').assertTrue();
    expect(testDividerParam67.secondary.posY === '0%').assertTrue();
    expect(testDividerParam67.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam67.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_068', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer68: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer68.init();
    let testDividerParam68 = testContainer68.dividerParam;
    testDividerParam68.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer68);

    expect(testContainer68.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer68.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer68.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer68.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer68.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer68.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer68.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer68.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer68.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer68.needRenderPos.posX === 0).assertTrue();
    expect(testContainer68.needRenderPos.posY === 0).assertTrue();
    expect(testContainer68.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer68.iconAlpha === 0).assertTrue();
    expect(testContainer68.iconAlpha === 0).assertTrue();
    expect(testContainer68.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer68.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer68.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer68.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer68.intelligentScene === 1).assertTrue();

    expect(testDividerParam68.primary.translateY === 0).assertTrue();
    expect(testDividerParam68.primary.translateX === 0).assertTrue();
    expect(testDividerParam68.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam68.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam68.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam68.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam68.primary.opacity === 1).assertTrue();
    expect(testDividerParam68.primary.blurScale === 0).assertTrue();
    expect(testDividerParam68.secondary.opacity === 1).assertTrue();
    expect(testDividerParam68.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam68.primary.rotateX === 0).assertTrue();
    expect(testDividerParam68.primary.rotateY === 0).assertTrue();
    expect(testDividerParam68.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam68.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam68.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam68.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam68.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam68.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam68.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam68.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam68.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam68.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam68.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam68.primary.posX === '0%').assertTrue();
    expect(testDividerParam68.primary.posY === '0%').assertTrue();
    expect(testDividerParam68.secondary.posX === '0%').assertTrue();
    expect(testDividerParam68.secondary.posY === '0%').assertTrue();
    expect(testDividerParam68.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam68.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_069', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer69: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer69.init();
    let testDividerParam69 = testContainer69.dividerParam;
    testDividerParam69.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer69);

    expect(testContainer69.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer69.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer69.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer69.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer69.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer69.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer69.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer69.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer69.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer69.needRenderPos.posX === 0).assertTrue();
    expect(testContainer69.needRenderPos.posY === 0).assertTrue();
    expect(testContainer69.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer69.iconAlpha === 0).assertTrue();
    expect(testContainer69.iconAlpha === 0).assertTrue();
    expect(testContainer69.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer69.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer69.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer69.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer69.intelligentScene === 1).assertTrue();

    expect(testDividerParam69.primary.translateY === 0).assertTrue();
    expect(testDividerParam69.primary.translateX === 0).assertTrue();
    expect(testDividerParam69.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam69.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam69.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam69.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam69.primary.opacity === 1).assertTrue();
    expect(testDividerParam69.primary.blurScale === 0).assertTrue();
    expect(testDividerParam69.secondary.opacity === 1).assertTrue();
    expect(testDividerParam69.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam69.primary.rotateX === 0).assertTrue();
    expect(testDividerParam69.primary.rotateY === 0).assertTrue();
    expect(testDividerParam69.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam69.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam69.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam69.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam69.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam69.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam69.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam69.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam69.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam69.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam69.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam69.primary.posX === '0%').assertTrue();
    expect(testDividerParam69.primary.posY === '0%').assertTrue();
    expect(testDividerParam69.secondary.posX === '0%').assertTrue();
    expect(testDividerParam69.secondary.posY === '0%').assertTrue();
    expect(testDividerParam69.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam69.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_070', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer70: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer70.init();
    let testDividerParam70 = testContainer70.dividerParam;
    testDividerParam70.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer70);

    expect(testContainer70.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer70.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer70.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer70.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer70.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer70.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer70.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer70.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer70.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer70.needRenderPos.posX === 0).assertTrue();
    expect(testContainer70.needRenderPos.posY === 0).assertTrue();
    expect(testContainer70.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer70.iconAlpha === 0).assertTrue();
    expect(testContainer70.iconAlpha === 0).assertTrue();
    expect(testContainer70.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer70.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer70.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer70.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer70.intelligentScene === 1).assertTrue();

    expect(testDividerParam70.primary.translateY === 0).assertTrue();
    expect(testDividerParam70.primary.translateX === 0).assertTrue();
    expect(testDividerParam70.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam70.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam70.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam70.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam70.primary.opacity === 1).assertTrue();
    expect(testDividerParam70.primary.blurScale === 0).assertTrue();
    expect(testDividerParam70.secondary.opacity === 1).assertTrue();
    expect(testDividerParam70.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam70.primary.rotateX === 0).assertTrue();
    expect(testDividerParam70.primary.rotateY === 0).assertTrue();
    expect(testDividerParam70.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam70.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam70.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam70.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam70.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam70.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam70.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam70.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam70.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam70.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam70.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam70.primary.posX === '0%').assertTrue();
    expect(testDividerParam70.primary.posY === '0%').assertTrue();
    expect(testDividerParam70.secondary.posX === '0%').assertTrue();
    expect(testDividerParam70.secondary.posY === '0%').assertTrue();
    expect(testDividerParam70.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam70.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_071', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer71: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer71.init();
    let testDividerParam71 = testContainer71.dividerParam;
    testDividerParam71.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer71);

    expect(testContainer71.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer71.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer71.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer71.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer71.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer71.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer71.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer71.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer71.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer71.needRenderPos.posX === 0).assertTrue();
    expect(testContainer71.needRenderPos.posY === 0).assertTrue();
    expect(testContainer71.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer71.iconAlpha === 0).assertTrue();
    expect(testContainer71.iconAlpha === 0).assertTrue();
    expect(testContainer71.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer71.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer71.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer71.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer71.intelligentScene === 1).assertTrue();

    expect(testDividerParam71.primary.translateY === 0).assertTrue();
    expect(testDividerParam71.primary.translateX === 0).assertTrue();
    expect(testDividerParam71.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam71.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam71.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam71.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam71.primary.opacity === 1).assertTrue();
    expect(testDividerParam71.primary.blurScale === 0).assertTrue();
    expect(testDividerParam71.secondary.opacity === 1).assertTrue();
    expect(testDividerParam71.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam71.primary.rotateX === 0).assertTrue();
    expect(testDividerParam71.primary.rotateY === 0).assertTrue();
    expect(testDividerParam71.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam71.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam71.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam71.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam71.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam71.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam71.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam71.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam71.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam71.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam71.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam71.primary.posX === '0%').assertTrue();
    expect(testDividerParam71.primary.posY === '0%').assertTrue();
    expect(testDividerParam71.secondary.posX === '0%').assertTrue();
    expect(testDividerParam71.secondary.posY === '0%').assertTrue();
    expect(testDividerParam71.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam71.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_072', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer72: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer72.init();
    let testDividerParam72 = testContainer72.dividerParam;
    testDividerParam72.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer72);

    expect(testContainer72.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer72.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer72.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer72.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer72.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer72.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer72.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer72.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer72.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer72.needRenderPos.posX === 0).assertTrue();
    expect(testContainer72.needRenderPos.posY === 0).assertTrue();
    expect(testContainer72.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer72.iconAlpha === 0).assertTrue();
    expect(testContainer72.iconAlpha === 0).assertTrue();
    expect(testContainer72.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer72.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer72.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer72.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer72.intelligentScene === 1).assertTrue();

    expect(testDividerParam72.primary.translateY === 0).assertTrue();
    expect(testDividerParam72.primary.translateX === 0).assertTrue();
    expect(testDividerParam72.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam72.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam72.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam72.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam72.primary.opacity === 1).assertTrue();
    expect(testDividerParam72.primary.blurScale === 0).assertTrue();
    expect(testDividerParam72.secondary.opacity === 1).assertTrue();
    expect(testDividerParam72.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam72.primary.rotateX === 0).assertTrue();
    expect(testDividerParam72.primary.rotateY === 0).assertTrue();
    expect(testDividerParam72.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam72.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam72.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam72.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam72.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam72.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam72.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam72.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam72.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam72.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam72.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam72.primary.posX === '0%').assertTrue();
    expect(testDividerParam72.primary.posY === '0%').assertTrue();
    expect(testDividerParam72.secondary.posX === '0%').assertTrue();
    expect(testDividerParam72.secondary.posY === '0%').assertTrue();
    expect(testDividerParam72.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam72.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_073', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer73: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer73.init();
    let testDividerParam73 = testContainer73.dividerParam;
    testDividerParam73.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer73);

    expect(testContainer73.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer73.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer73.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer73.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer73.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer73.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer73.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer73.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer73.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer73.needRenderPos.posX === 0).assertTrue();
    expect(testContainer73.needRenderPos.posY === 0).assertTrue();
    expect(testContainer73.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer73.iconAlpha === 0).assertTrue();
    expect(testContainer73.iconAlpha === 0).assertTrue();
    expect(testContainer73.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer73.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer73.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer73.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer73.intelligentScene === 1).assertTrue();

    expect(testDividerParam73.primary.translateY === 0).assertTrue();
    expect(testDividerParam73.primary.translateX === 0).assertTrue();
    expect(testDividerParam73.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam73.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam73.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam73.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam73.primary.opacity === 1).assertTrue();
    expect(testDividerParam73.primary.blurScale === 0).assertTrue();
    expect(testDividerParam73.secondary.opacity === 1).assertTrue();
    expect(testDividerParam73.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam73.primary.rotateX === 0).assertTrue();
    expect(testDividerParam73.primary.rotateY === 0).assertTrue();
    expect(testDividerParam73.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam73.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam73.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam73.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam73.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam73.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam73.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam73.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam73.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam73.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam73.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam73.primary.posX === '0%').assertTrue();
    expect(testDividerParam73.primary.posY === '0%').assertTrue();
    expect(testDividerParam73.secondary.posX === '0%').assertTrue();
    expect(testDividerParam73.secondary.posY === '0%').assertTrue();
    expect(testDividerParam73.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam73.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_074', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer74: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer74.init();
    let testDividerParam74 = testContainer74.dividerParam;
    testDividerParam74.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer74);

    expect(testContainer74.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer74.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer74.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer74.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer74.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer74.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer74.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer74.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer74.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer74.needRenderPos.posX === 0).assertTrue();
    expect(testContainer74.needRenderPos.posY === 0).assertTrue();
    expect(testContainer74.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer74.iconAlpha === 0).assertTrue();
    expect(testContainer74.iconAlpha === 0).assertTrue();
    expect(testContainer74.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer74.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer74.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer74.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer74.intelligentScene === 1).assertTrue();

    expect(testDividerParam74.primary.translateY === 0).assertTrue();
    expect(testDividerParam74.primary.translateX === 0).assertTrue();
    expect(testDividerParam74.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam74.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam74.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam74.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam74.primary.opacity === 1).assertTrue();
    expect(testDividerParam74.primary.blurScale === 0).assertTrue();
    expect(testDividerParam74.secondary.opacity === 1).assertTrue();
    expect(testDividerParam74.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam74.primary.rotateX === 0).assertTrue();
    expect(testDividerParam74.primary.rotateY === 0).assertTrue();
    expect(testDividerParam74.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam74.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam74.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam74.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam74.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam74.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam74.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam74.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam74.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam74.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam74.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam74.primary.posX === '0%').assertTrue();
    expect(testDividerParam74.primary.posY === '0%').assertTrue();
    expect(testDividerParam74.secondary.posX === '0%').assertTrue();
    expect(testDividerParam74.secondary.posY === '0%').assertTrue();
    expect(testDividerParam74.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam74.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_075', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer75: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer75.init();
    let testDividerParam75 = testContainer75.dividerParam;
    testDividerParam75.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer75);

    expect(testContainer75.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer75.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer75.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer75.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer75.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer75.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer75.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer75.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer75.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer75.needRenderPos.posX === 0).assertTrue();
    expect(testContainer75.needRenderPos.posY === 0).assertTrue();
    expect(testContainer75.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer75.iconAlpha === 0).assertTrue();
    expect(testContainer75.iconAlpha === 0).assertTrue();
    expect(testContainer75.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer75.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer75.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer75.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer75.intelligentScene === 1).assertTrue();

    expect(testDividerParam75.primary.translateY === 0).assertTrue();
    expect(testDividerParam75.primary.translateX === 0).assertTrue();
    expect(testDividerParam75.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam75.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam75.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam75.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam75.primary.opacity === 1).assertTrue();
    expect(testDividerParam75.primary.blurScale === 0).assertTrue();
    expect(testDividerParam75.secondary.opacity === 1).assertTrue();
    expect(testDividerParam75.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam75.primary.rotateX === 0).assertTrue();
    expect(testDividerParam75.primary.rotateY === 0).assertTrue();
    expect(testDividerParam75.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam75.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam75.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam75.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam75.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam75.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam75.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam75.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam75.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam75.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam75.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam75.primary.posX === '0%').assertTrue();
    expect(testDividerParam75.primary.posY === '0%').assertTrue();
    expect(testDividerParam75.secondary.posX === '0%').assertTrue();
    expect(testDividerParam75.secondary.posY === '0%').assertTrue();
    expect(testDividerParam75.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam75.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_076', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer76: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer76.init();
    let testDividerParam76 = testContainer76.dividerParam;
    testDividerParam76.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer76);

    expect(testContainer76.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer76.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer76.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer76.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer76.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer76.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer76.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer76.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer76.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer76.needRenderPos.posX === 0).assertTrue();
    expect(testContainer76.needRenderPos.posY === 0).assertTrue();
    expect(testContainer76.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer76.iconAlpha === 0).assertTrue();
    expect(testContainer76.iconAlpha === 0).assertTrue();
    expect(testContainer76.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer76.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer76.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer76.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer76.intelligentScene === 1).assertTrue();

    expect(testDividerParam76.primary.translateY === 0).assertTrue();
    expect(testDividerParam76.primary.translateX === 0).assertTrue();
    expect(testDividerParam76.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam76.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam76.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam76.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam76.primary.opacity === 1).assertTrue();
    expect(testDividerParam76.primary.blurScale === 0).assertTrue();
    expect(testDividerParam76.secondary.opacity === 1).assertTrue();
    expect(testDividerParam76.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam76.primary.rotateX === 0).assertTrue();
    expect(testDividerParam76.primary.rotateY === 0).assertTrue();
    expect(testDividerParam76.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam76.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam76.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam76.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam76.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam76.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam76.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam76.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam76.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam76.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam76.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam76.primary.posX === '0%').assertTrue();
    expect(testDividerParam76.primary.posY === '0%').assertTrue();
    expect(testDividerParam76.secondary.posX === '0%').assertTrue();
    expect(testDividerParam76.secondary.posY === '0%').assertTrue();
    expect(testDividerParam76.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam76.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_077', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer77: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer77.init();
    let testDividerParam77 = testContainer77.dividerParam;
    testDividerParam77.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer77);

    expect(testContainer77.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer77.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer77.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer77.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer77.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer77.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer77.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer77.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer77.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer77.needRenderPos.posX === 0).assertTrue();
    expect(testContainer77.needRenderPos.posY === 0).assertTrue();
    expect(testContainer77.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer77.iconAlpha === 0).assertTrue();
    expect(testContainer77.iconAlpha === 0).assertTrue();
    expect(testContainer77.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer77.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer77.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer77.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer77.intelligentScene === 1).assertTrue();

    expect(testDividerParam77.primary.translateY === 0).assertTrue();
    expect(testDividerParam77.primary.translateX === 0).assertTrue();
    expect(testDividerParam77.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam77.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam77.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam77.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam77.primary.opacity === 1).assertTrue();
    expect(testDividerParam77.primary.blurScale === 0).assertTrue();
    expect(testDividerParam77.secondary.opacity === 1).assertTrue();
    expect(testDividerParam77.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam77.primary.rotateX === 0).assertTrue();
    expect(testDividerParam77.primary.rotateY === 0).assertTrue();
    expect(testDividerParam77.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam77.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam77.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam77.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam77.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam77.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam77.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam77.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam77.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam77.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam77.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam77.primary.posX === '0%').assertTrue();
    expect(testDividerParam77.primary.posY === '0%').assertTrue();
    expect(testDividerParam77.secondary.posX === '0%').assertTrue();
    expect(testDividerParam77.secondary.posY === '0%').assertTrue();
    expect(testDividerParam77.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam77.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_078', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer78: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer78.init();
    let testDividerParam78 = testContainer78.dividerParam;
    testDividerParam78.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer78);

    expect(testContainer78.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer78.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer78.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer78.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer78.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer78.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer78.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer78.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer78.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer78.needRenderPos.posX === 0).assertTrue();
    expect(testContainer78.needRenderPos.posY === 0).assertTrue();
    expect(testContainer78.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer78.iconAlpha === 0).assertTrue();
    expect(testContainer78.iconAlpha === 0).assertTrue();
    expect(testContainer78.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer78.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer78.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer78.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer78.intelligentScene === 1).assertTrue();

    expect(testDividerParam78.primary.translateY === 0).assertTrue();
    expect(testDividerParam78.primary.translateX === 0).assertTrue();
    expect(testDividerParam78.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam78.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam78.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam78.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam78.primary.opacity === 1).assertTrue();
    expect(testDividerParam78.primary.blurScale === 0).assertTrue();
    expect(testDividerParam78.secondary.opacity === 1).assertTrue();
    expect(testDividerParam78.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam78.primary.rotateX === 0).assertTrue();
    expect(testDividerParam78.primary.rotateY === 0).assertTrue();
    expect(testDividerParam78.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam78.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam78.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam78.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam78.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam78.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam78.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam78.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam78.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam78.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam78.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam78.primary.posX === '0%').assertTrue();
    expect(testDividerParam78.primary.posY === '0%').assertTrue();
    expect(testDividerParam78.secondary.posX === '0%').assertTrue();
    expect(testDividerParam78.secondary.posY === '0%').assertTrue();
    expect(testDividerParam78.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam78.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_079', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer79: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer79.init();
    let testDividerParam79 = testContainer79.dividerParam;
    testDividerParam79.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer79);

    expect(testContainer79.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer79.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer79.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer79.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer79.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer79.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer79.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer79.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer79.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer79.needRenderPos.posX === 0).assertTrue();
    expect(testContainer79.needRenderPos.posY === 0).assertTrue();
    expect(testContainer79.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer79.iconAlpha === 0).assertTrue();
    expect(testContainer79.iconAlpha === 0).assertTrue();
    expect(testContainer79.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer79.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer79.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer79.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer79.intelligentScene === 1).assertTrue();

    expect(testDividerParam79.primary.translateY === 0).assertTrue();
    expect(testDividerParam79.primary.translateX === 0).assertTrue();
    expect(testDividerParam79.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam79.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam79.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam79.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam79.primary.opacity === 1).assertTrue();
    expect(testDividerParam79.primary.blurScale === 0).assertTrue();
    expect(testDividerParam79.secondary.opacity === 1).assertTrue();
    expect(testDividerParam79.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam79.primary.rotateX === 0).assertTrue();
    expect(testDividerParam79.primary.rotateY === 0).assertTrue();
    expect(testDividerParam79.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam79.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam79.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam79.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam79.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam79.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam79.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam79.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam79.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam79.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam79.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam79.primary.posX === '0%').assertTrue();
    expect(testDividerParam79.primary.posY === '0%').assertTrue();
    expect(testDividerParam79.secondary.posX === '0%').assertTrue();
    expect(testDividerParam79.secondary.posY === '0%').assertTrue();
    expect(testDividerParam79.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam79.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_080', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer80: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer80.init();
    let testDividerParam80 = testContainer80.dividerParam;
    testDividerParam80.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer80);

    expect(testContainer80.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer80.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer80.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer80.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer80.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer80.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer80.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer80.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer80.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer80.needRenderPos.posX === 0).assertTrue();
    expect(testContainer80.needRenderPos.posY === 0).assertTrue();
    expect(testContainer80.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer80.iconAlpha === 0).assertTrue();
    expect(testContainer80.iconAlpha === 0).assertTrue();
    expect(testContainer80.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer80.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer80.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer80.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer80.intelligentScene === 1).assertTrue();

    expect(testDividerParam80.primary.translateY === 0).assertTrue();
    expect(testDividerParam80.primary.translateX === 0).assertTrue();
    expect(testDividerParam80.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam80.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam80.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam80.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam80.primary.opacity === 1).assertTrue();
    expect(testDividerParam80.primary.blurScale === 0).assertTrue();
    expect(testDividerParam80.secondary.opacity === 1).assertTrue();
    expect(testDividerParam80.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam80.primary.rotateX === 0).assertTrue();
    expect(testDividerParam80.primary.rotateY === 0).assertTrue();
    expect(testDividerParam80.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam80.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam80.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam80.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam80.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam80.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam80.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam80.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam80.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam80.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam80.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam80.primary.posX === '0%').assertTrue();
    expect(testDividerParam80.primary.posY === '0%').assertTrue();
    expect(testDividerParam80.secondary.posX === '0%').assertTrue();
    expect(testDividerParam80.secondary.posY === '0%').assertTrue();
    expect(testDividerParam80.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam80.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_081', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer81: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer81.init();
    let testDividerParam81 = testContainer81.dividerParam;
    testDividerParam81.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer81);

    expect(testContainer81.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer81.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer81.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer81.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer81.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer81.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer81.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer81.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer81.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer81.needRenderPos.posX === 0).assertTrue();
    expect(testContainer81.needRenderPos.posY === 0).assertTrue();
    expect(testContainer81.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer81.iconAlpha === 0).assertTrue();
    expect(testContainer81.iconAlpha === 0).assertTrue();
    expect(testContainer81.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer81.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer81.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer81.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer81.intelligentScene === 1).assertTrue();

    expect(testDividerParam81.primary.translateY === 0).assertTrue();
    expect(testDividerParam81.primary.translateX === 0).assertTrue();
    expect(testDividerParam81.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam81.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam81.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam81.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam81.primary.opacity === 1).assertTrue();
    expect(testDividerParam81.primary.blurScale === 0).assertTrue();
    expect(testDividerParam81.secondary.opacity === 1).assertTrue();
    expect(testDividerParam81.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam81.primary.rotateX === 0).assertTrue();
    expect(testDividerParam81.primary.rotateY === 0).assertTrue();
    expect(testDividerParam81.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam81.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam81.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam81.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam81.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam81.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam81.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam81.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam81.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam81.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam81.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam81.primary.posX === '0%').assertTrue();
    expect(testDividerParam81.primary.posY === '0%').assertTrue();
    expect(testDividerParam81.secondary.posX === '0%').assertTrue();
    expect(testDividerParam81.secondary.posY === '0%').assertTrue();
    expect(testDividerParam81.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam81.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_082', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer82: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer82.init();
    let testDividerParam82 = testContainer82.dividerParam;
    testDividerParam82.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer82);

    expect(testContainer82.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer82.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer82.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer82.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer82.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer82.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer82.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer82.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer82.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer82.needRenderPos.posX === 0).assertTrue();
    expect(testContainer82.needRenderPos.posY === 0).assertTrue();
    expect(testContainer82.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer82.iconAlpha === 0).assertTrue();
    expect(testContainer82.iconAlpha === 0).assertTrue();
    expect(testContainer82.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer82.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer82.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer82.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer82.intelligentScene === 1).assertTrue();

    expect(testDividerParam82.primary.translateY === 0).assertTrue();
    expect(testDividerParam82.primary.translateX === 0).assertTrue();
    expect(testDividerParam82.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam82.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam82.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam82.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam82.primary.opacity === 1).assertTrue();
    expect(testDividerParam82.primary.blurScale === 0).assertTrue();
    expect(testDividerParam82.secondary.opacity === 1).assertTrue();
    expect(testDividerParam82.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam82.primary.rotateX === 0).assertTrue();
    expect(testDividerParam82.primary.rotateY === 0).assertTrue();
    expect(testDividerParam82.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam82.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam82.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam82.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam82.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam82.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam82.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam82.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam82.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam82.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam82.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam82.primary.posX === '0%').assertTrue();
    expect(testDividerParam82.primary.posY === '0%').assertTrue();
    expect(testDividerParam82.secondary.posX === '0%').assertTrue();
    expect(testDividerParam82.secondary.posY === '0%').assertTrue();
    expect(testDividerParam82.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam82.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_083', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer83: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer83.init();
    let testDividerParam83 = testContainer83.dividerParam;
    testDividerParam83.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer83);

    expect(testContainer83.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer83.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer83.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer83.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer83.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer83.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer83.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer83.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer83.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer83.needRenderPos.posX === 0).assertTrue();
    expect(testContainer83.needRenderPos.posY === 0).assertTrue();
    expect(testContainer83.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer83.iconAlpha === 0).assertTrue();
    expect(testContainer83.iconAlpha === 0).assertTrue();
    expect(testContainer83.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer83.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer83.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer83.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer83.intelligentScene === 1).assertTrue();

    expect(testDividerParam83.primary.translateY === 0).assertTrue();
    expect(testDividerParam83.primary.translateX === 0).assertTrue();
    expect(testDividerParam83.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam83.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam83.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam83.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam83.primary.opacity === 1).assertTrue();
    expect(testDividerParam83.primary.blurScale === 0).assertTrue();
    expect(testDividerParam83.secondary.opacity === 1).assertTrue();
    expect(testDividerParam83.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam83.primary.rotateX === 0).assertTrue();
    expect(testDividerParam83.primary.rotateY === 0).assertTrue();
    expect(testDividerParam83.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam83.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam83.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam83.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam83.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam83.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam83.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam83.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam83.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam83.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam83.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam83.primary.posX === '0%').assertTrue();
    expect(testDividerParam83.primary.posY === '0%').assertTrue();
    expect(testDividerParam83.secondary.posX === '0%').assertTrue();
    expect(testDividerParam83.secondary.posY === '0%').assertTrue();
    expect(testDividerParam83.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam83.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_084', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer84: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer84.init();
    let testDividerParam84 = testContainer84.dividerParam;
    testDividerParam84.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer84);

    expect(testContainer84.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer84.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer84.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer84.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer84.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer84.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer84.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer84.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer84.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer84.needRenderPos.posX === 0).assertTrue();
    expect(testContainer84.needRenderPos.posY === 0).assertTrue();
    expect(testContainer84.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer84.iconAlpha === 0).assertTrue();
    expect(testContainer84.iconAlpha === 0).assertTrue();
    expect(testContainer84.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer84.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer84.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer84.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer84.intelligentScene === 1).assertTrue();

    expect(testDividerParam84.primary.translateY === 0).assertTrue();
    expect(testDividerParam84.primary.translateX === 0).assertTrue();
    expect(testDividerParam84.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam84.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam84.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam84.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam84.primary.opacity === 1).assertTrue();
    expect(testDividerParam84.primary.blurScale === 0).assertTrue();
    expect(testDividerParam84.secondary.opacity === 1).assertTrue();
    expect(testDividerParam84.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam84.primary.rotateX === 0).assertTrue();
    expect(testDividerParam84.primary.rotateY === 0).assertTrue();
    expect(testDividerParam84.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam84.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam84.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam84.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam84.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam84.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam84.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam84.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam84.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam84.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam84.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam84.primary.posX === '0%').assertTrue();
    expect(testDividerParam84.primary.posY === '0%').assertTrue();
    expect(testDividerParam84.secondary.posX === '0%').assertTrue();
    expect(testDividerParam84.secondary.posY === '0%').assertTrue();
    expect(testDividerParam84.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam84.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_085', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer85: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer85.init();
    let testDividerParam85 = testContainer85.dividerParam;
    testDividerParam85.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer85);

    expect(testContainer85.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer85.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer85.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer85.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer85.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer85.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer85.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer85.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer85.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer85.needRenderPos.posX === 0).assertTrue();
    expect(testContainer85.needRenderPos.posY === 0).assertTrue();
    expect(testContainer85.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer85.iconAlpha === 0).assertTrue();
    expect(testContainer85.iconAlpha === 0).assertTrue();
    expect(testContainer85.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer85.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer85.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer85.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer85.intelligentScene === 1).assertTrue();

    expect(testDividerParam85.primary.translateY === 0).assertTrue();
    expect(testDividerParam85.primary.translateX === 0).assertTrue();
    expect(testDividerParam85.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam85.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam85.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam85.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam85.primary.opacity === 1).assertTrue();
    expect(testDividerParam85.primary.blurScale === 0).assertTrue();
    expect(testDividerParam85.secondary.opacity === 1).assertTrue();
    expect(testDividerParam85.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam85.primary.rotateX === 0).assertTrue();
    expect(testDividerParam85.primary.rotateY === 0).assertTrue();
    expect(testDividerParam85.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam85.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam85.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam85.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam85.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam85.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam85.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam85.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam85.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam85.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam85.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam85.primary.posX === '0%').assertTrue();
    expect(testDividerParam85.primary.posY === '0%').assertTrue();
    expect(testDividerParam85.secondary.posX === '0%').assertTrue();
    expect(testDividerParam85.secondary.posY === '0%').assertTrue();
    expect(testDividerParam85.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam85.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_086', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer86: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer86.init();
    let testDividerParam86 = testContainer86.dividerParam;
    testDividerParam86.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer86);

    expect(testContainer86.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer86.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer86.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer86.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer86.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer86.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer86.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer86.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer86.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer86.needRenderPos.posX === 0).assertTrue();
    expect(testContainer86.needRenderPos.posY === 0).assertTrue();
    expect(testContainer86.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer86.iconAlpha === 0).assertTrue();
    expect(testContainer86.iconAlpha === 0).assertTrue();
    expect(testContainer86.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer86.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer86.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer86.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer86.intelligentScene === 1).assertTrue();

    expect(testDividerParam86.primary.translateY === 0).assertTrue();
    expect(testDividerParam86.primary.translateX === 0).assertTrue();
    expect(testDividerParam86.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam86.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam86.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam86.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam86.primary.opacity === 1).assertTrue();
    expect(testDividerParam86.primary.blurScale === 0).assertTrue();
    expect(testDividerParam86.secondary.opacity === 1).assertTrue();
    expect(testDividerParam86.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam86.primary.rotateX === 0).assertTrue();
    expect(testDividerParam86.primary.rotateY === 0).assertTrue();
    expect(testDividerParam86.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam86.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam86.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam86.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam86.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam86.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam86.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam86.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam86.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam86.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam86.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam86.primary.posX === '0%').assertTrue();
    expect(testDividerParam86.primary.posY === '0%').assertTrue();
    expect(testDividerParam86.secondary.posX === '0%').assertTrue();
    expect(testDividerParam86.secondary.posY === '0%').assertTrue();
    expect(testDividerParam86.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam86.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_087', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer87: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer87.init();
    let testDividerParam87 = testContainer87.dividerParam;
    testDividerParam87.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer87);

    expect(testContainer87.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer87.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer87.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer87.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer87.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer87.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer87.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer87.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer87.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer87.needRenderPos.posX === 0).assertTrue();
    expect(testContainer87.needRenderPos.posY === 0).assertTrue();
    expect(testContainer87.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer87.iconAlpha === 0).assertTrue();
    expect(testContainer87.iconAlpha === 0).assertTrue();
    expect(testContainer87.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer87.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer87.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer87.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer87.intelligentScene === 1).assertTrue();

    expect(testDividerParam87.primary.translateY === 0).assertTrue();
    expect(testDividerParam87.primary.translateX === 0).assertTrue();
    expect(testDividerParam87.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam87.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam87.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam87.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam87.primary.opacity === 1).assertTrue();
    expect(testDividerParam87.primary.blurScale === 0).assertTrue();
    expect(testDividerParam87.secondary.opacity === 1).assertTrue();
    expect(testDividerParam87.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam87.primary.rotateX === 0).assertTrue();
    expect(testDividerParam87.primary.rotateY === 0).assertTrue();
    expect(testDividerParam87.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam87.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam87.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam87.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam87.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam87.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam87.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam87.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam87.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam87.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam87.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam87.primary.posX === '0%').assertTrue();
    expect(testDividerParam87.primary.posY === '0%').assertTrue();
    expect(testDividerParam87.secondary.posX === '0%').assertTrue();
    expect(testDividerParam87.secondary.posY === '0%').assertTrue();
    expect(testDividerParam87.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam87.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_088', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer88: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer88.init();
    let testDividerParam88 = testContainer88.dividerParam;
    testDividerParam88.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer88);

    expect(testContainer88.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer88.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer88.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer88.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer88.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer88.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer88.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer88.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer88.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer88.needRenderPos.posX === 0).assertTrue();
    expect(testContainer88.needRenderPos.posY === 0).assertTrue();
    expect(testContainer88.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer88.iconAlpha === 0).assertTrue();
    expect(testContainer88.iconAlpha === 0).assertTrue();
    expect(testContainer88.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer88.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer88.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer88.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer88.intelligentScene === 1).assertTrue();

    expect(testDividerParam88.primary.translateY === 0).assertTrue();
    expect(testDividerParam88.primary.translateX === 0).assertTrue();
    expect(testDividerParam88.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam88.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam88.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam88.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam88.primary.opacity === 1).assertTrue();
    expect(testDividerParam88.primary.blurScale === 0).assertTrue();
    expect(testDividerParam88.secondary.opacity === 1).assertTrue();
    expect(testDividerParam88.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam88.primary.rotateX === 0).assertTrue();
    expect(testDividerParam88.primary.rotateY === 0).assertTrue();
    expect(testDividerParam88.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam88.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam88.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam88.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam88.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam88.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam88.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam88.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam88.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam88.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam88.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam88.primary.posX === '0%').assertTrue();
    expect(testDividerParam88.primary.posY === '0%').assertTrue();
    expect(testDividerParam88.secondary.posX === '0%').assertTrue();
    expect(testDividerParam88.secondary.posY === '0%').assertTrue();
    expect(testDividerParam88.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam88.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_089', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer89: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer89.init();
    let testDividerParam89 = testContainer89.dividerParam;
    testDividerParam89.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer89);

    expect(testContainer89.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer89.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer89.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer89.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer89.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer89.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer89.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer89.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer89.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer89.needRenderPos.posX === 0).assertTrue();
    expect(testContainer89.needRenderPos.posY === 0).assertTrue();
    expect(testContainer89.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer89.iconAlpha === 0).assertTrue();
    expect(testContainer89.iconAlpha === 0).assertTrue();
    expect(testContainer89.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer89.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer89.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer89.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer89.intelligentScene === 1).assertTrue();

    expect(testDividerParam89.primary.translateY === 0).assertTrue();
    expect(testDividerParam89.primary.translateX === 0).assertTrue();
    expect(testDividerParam89.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam89.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam89.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam89.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam89.primary.opacity === 1).assertTrue();
    expect(testDividerParam89.primary.blurScale === 0).assertTrue();
    expect(testDividerParam89.secondary.opacity === 1).assertTrue();
    expect(testDividerParam89.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam89.primary.rotateX === 0).assertTrue();
    expect(testDividerParam89.primary.rotateY === 0).assertTrue();
    expect(testDividerParam89.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam89.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam89.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam89.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam89.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam89.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam89.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam89.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam89.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam89.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam89.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam89.primary.posX === '0%').assertTrue();
    expect(testDividerParam89.primary.posY === '0%').assertTrue();
    expect(testDividerParam89.secondary.posX === '0%').assertTrue();
    expect(testDividerParam89.secondary.posY === '0%').assertTrue();
    expect(testDividerParam89.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam89.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_090', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer90: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer90.init();
    let testDividerParam90 = testContainer90.dividerParam;
    testDividerParam90.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer90);

    expect(testContainer90.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer90.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer90.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer90.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer90.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer90.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer90.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer90.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer90.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer90.needRenderPos.posX === 0).assertTrue();
    expect(testContainer90.needRenderPos.posY === 0).assertTrue();
    expect(testContainer90.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer90.iconAlpha === 0).assertTrue();
    expect(testContainer90.iconAlpha === 0).assertTrue();
    expect(testContainer90.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer90.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer90.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer90.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer90.intelligentScene === 1).assertTrue();

    expect(testDividerParam90.primary.translateY === 0).assertTrue();
    expect(testDividerParam90.primary.translateX === 0).assertTrue();
    expect(testDividerParam90.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam90.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam90.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam90.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam90.primary.opacity === 1).assertTrue();
    expect(testDividerParam90.primary.blurScale === 0).assertTrue();
    expect(testDividerParam90.secondary.opacity === 1).assertTrue();
    expect(testDividerParam90.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam90.primary.rotateX === 0).assertTrue();
    expect(testDividerParam90.primary.rotateY === 0).assertTrue();
    expect(testDividerParam90.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam90.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam90.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam90.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam90.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam90.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam90.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam90.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam90.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam90.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam90.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam90.primary.posX === '0%').assertTrue();
    expect(testDividerParam90.primary.posY === '0%').assertTrue();
    expect(testDividerParam90.secondary.posX === '0%').assertTrue();
    expect(testDividerParam90.secondary.posY === '0%').assertTrue();
    expect(testDividerParam90.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam90.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_091', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer91: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer91.init();
    let testDividerParam91 = testContainer91.dividerParam;
    testDividerParam91.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer91);

    expect(testContainer91.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer91.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer91.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer91.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer91.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer91.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer91.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer91.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer91.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer91.needRenderPos.posX === 0).assertTrue();
    expect(testContainer91.needRenderPos.posY === 0).assertTrue();
    expect(testContainer91.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer91.iconAlpha === 0).assertTrue();
    expect(testContainer91.iconAlpha === 0).assertTrue();
    expect(testContainer91.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer91.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer91.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer91.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer91.intelligentScene === 1).assertTrue();

    expect(testDividerParam91.primary.translateY === 0).assertTrue();
    expect(testDividerParam91.primary.translateX === 0).assertTrue();
    expect(testDividerParam91.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam91.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam91.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam91.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam91.primary.opacity === 1).assertTrue();
    expect(testDividerParam91.primary.blurScale === 0).assertTrue();
    expect(testDividerParam91.secondary.opacity === 1).assertTrue();
    expect(testDividerParam91.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam91.primary.rotateX === 0).assertTrue();
    expect(testDividerParam91.primary.rotateY === 0).assertTrue();
    expect(testDividerParam91.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam91.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam91.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam91.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam91.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam91.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam91.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam91.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam91.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam91.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam91.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam91.primary.posX === '0%').assertTrue();
    expect(testDividerParam91.primary.posY === '0%').assertTrue();
    expect(testDividerParam91.secondary.posX === '0%').assertTrue();
    expect(testDividerParam91.secondary.posY === '0%').assertTrue();
    expect(testDividerParam91.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam91.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_092', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer92: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer92.init();
    let testDividerParam92 = testContainer92.dividerParam;
    testDividerParam92.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer92);

    expect(testContainer92.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer92.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer92.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer92.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer92.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer92.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer92.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer92.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer92.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer92.needRenderPos.posX === 0).assertTrue();
    expect(testContainer92.needRenderPos.posY === 0).assertTrue();
    expect(testContainer92.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer92.iconAlpha === 0).assertTrue();
    expect(testContainer92.iconAlpha === 0).assertTrue();
    expect(testContainer92.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer92.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer92.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer92.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer92.intelligentScene === 1).assertTrue();

    expect(testDividerParam92.primary.translateY === 0).assertTrue();
    expect(testDividerParam92.primary.translateX === 0).assertTrue();
    expect(testDividerParam92.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam92.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam92.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam92.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam92.primary.opacity === 1).assertTrue();
    expect(testDividerParam92.primary.blurScale === 0).assertTrue();
    expect(testDividerParam92.secondary.opacity === 1).assertTrue();
    expect(testDividerParam92.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam92.primary.rotateX === 0).assertTrue();
    expect(testDividerParam92.primary.rotateY === 0).assertTrue();
    expect(testDividerParam92.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam92.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam92.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam92.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam92.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam92.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam92.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam92.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam92.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam92.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam92.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam92.primary.posX === '0%').assertTrue();
    expect(testDividerParam92.primary.posY === '0%').assertTrue();
    expect(testDividerParam92.secondary.posX === '0%').assertTrue();
    expect(testDividerParam92.secondary.posY === '0%').assertTrue();
    expect(testDividerParam92.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam92.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_093', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer93: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer93.init();
    let testDividerParam93 = testContainer93.dividerParam;
    testDividerParam93.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer93);

    expect(testContainer93.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer93.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer93.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer93.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer93.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer93.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer93.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer93.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer93.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer93.needRenderPos.posX === 0).assertTrue();
    expect(testContainer93.needRenderPos.posY === 0).assertTrue();
    expect(testContainer93.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer93.iconAlpha === 0).assertTrue();
    expect(testContainer93.iconAlpha === 0).assertTrue();
    expect(testContainer93.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer93.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer93.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer93.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer93.intelligentScene === 1).assertTrue();

    expect(testDividerParam93.primary.translateY === 0).assertTrue();
    expect(testDividerParam93.primary.translateX === 0).assertTrue();
    expect(testDividerParam93.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam93.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam93.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam93.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam93.primary.opacity === 1).assertTrue();
    expect(testDividerParam93.primary.blurScale === 0).assertTrue();
    expect(testDividerParam93.secondary.opacity === 1).assertTrue();
    expect(testDividerParam93.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam93.primary.rotateX === 0).assertTrue();
    expect(testDividerParam93.primary.rotateY === 0).assertTrue();
    expect(testDividerParam93.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam93.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam93.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam93.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam93.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam93.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam93.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam93.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam93.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam93.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam93.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam93.primary.posX === '0%').assertTrue();
    expect(testDividerParam93.primary.posY === '0%').assertTrue();
    expect(testDividerParam93.secondary.posX === '0%').assertTrue();
    expect(testDividerParam93.secondary.posY === '0%').assertTrue();
    expect(testDividerParam93.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam93.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_094', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer94: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer94.init();
    let testDividerParam94 = testContainer94.dividerParam;
    testDividerParam94.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer94);

    expect(testContainer94.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer94.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer94.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer94.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer94.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer94.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer94.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer94.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer94.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer94.needRenderPos.posX === 0).assertTrue();
    expect(testContainer94.needRenderPos.posY === 0).assertTrue();
    expect(testContainer94.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer94.iconAlpha === 0).assertTrue();
    expect(testContainer94.iconAlpha === 0).assertTrue();
    expect(testContainer94.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer94.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer94.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer94.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer94.intelligentScene === 1).assertTrue();

    expect(testDividerParam94.primary.translateY === 0).assertTrue();
    expect(testDividerParam94.primary.translateX === 0).assertTrue();
    expect(testDividerParam94.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam94.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam94.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam94.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam94.primary.opacity === 1).assertTrue();
    expect(testDividerParam94.primary.blurScale === 0).assertTrue();
    expect(testDividerParam94.secondary.opacity === 1).assertTrue();
    expect(testDividerParam94.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam94.primary.rotateX === 0).assertTrue();
    expect(testDividerParam94.primary.rotateY === 0).assertTrue();
    expect(testDividerParam94.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam94.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam94.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam94.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam94.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam94.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam94.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam94.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam94.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam94.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam94.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam94.primary.posX === '0%').assertTrue();
    expect(testDividerParam94.primary.posY === '0%').assertTrue();
    expect(testDividerParam94.secondary.posX === '0%').assertTrue();
    expect(testDividerParam94.secondary.posY === '0%').assertTrue();
    expect(testDividerParam94.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam94.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_095', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer95: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer95.init();
    let testDividerParam95 = testContainer95.dividerParam;
    testDividerParam95.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer95);

    expect(testContainer95.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer95.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer95.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer95.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer95.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer95.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer95.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer95.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer95.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer95.needRenderPos.posX === 0).assertTrue();
    expect(testContainer95.needRenderPos.posY === 0).assertTrue();
    expect(testContainer95.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer95.iconAlpha === 0).assertTrue();
    expect(testContainer95.iconAlpha === 0).assertTrue();
    expect(testContainer95.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer95.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer95.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer95.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer95.intelligentScene === 1).assertTrue();

    expect(testDividerParam95.primary.translateY === 0).assertTrue();
    expect(testDividerParam95.primary.translateX === 0).assertTrue();
    expect(testDividerParam95.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam95.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam95.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam95.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam95.primary.opacity === 1).assertTrue();
    expect(testDividerParam95.primary.blurScale === 0).assertTrue();
    expect(testDividerParam95.secondary.opacity === 1).assertTrue();
    expect(testDividerParam95.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam95.primary.rotateX === 0).assertTrue();
    expect(testDividerParam95.primary.rotateY === 0).assertTrue();
    expect(testDividerParam95.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam95.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam95.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam95.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam95.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam95.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam95.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam95.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam95.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam95.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam95.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam95.primary.posX === '0%').assertTrue();
    expect(testDividerParam95.primary.posY === '0%').assertTrue();
    expect(testDividerParam95.secondary.posX === '0%').assertTrue();
    expect(testDividerParam95.secondary.posY === '0%').assertTrue();
    expect(testDividerParam95.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam95.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_096', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer96: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer96.init();
    let testDividerParam96 = testContainer96.dividerParam;
    testDividerParam96.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer96);

    expect(testContainer96.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer96.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer96.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer96.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer96.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer96.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer96.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer96.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer96.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer96.needRenderPos.posX === 0).assertTrue();
    expect(testContainer96.needRenderPos.posY === 0).assertTrue();
    expect(testContainer96.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer96.iconAlpha === 0).assertTrue();
    expect(testContainer96.iconAlpha === 0).assertTrue();
    expect(testContainer96.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer96.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer96.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer96.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer96.intelligentScene === 1).assertTrue();

    expect(testDividerParam96.primary.translateY === 0).assertTrue();
    expect(testDividerParam96.primary.translateX === 0).assertTrue();
    expect(testDividerParam96.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam96.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam96.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam96.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam96.primary.opacity === 1).assertTrue();
    expect(testDividerParam96.primary.blurScale === 0).assertTrue();
    expect(testDividerParam96.secondary.opacity === 1).assertTrue();
    expect(testDividerParam96.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam96.primary.rotateX === 0).assertTrue();
    expect(testDividerParam96.primary.rotateY === 0).assertTrue();
    expect(testDividerParam96.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam96.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam96.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam96.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam96.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam96.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam96.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam96.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam96.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam96.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam96.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam96.primary.posX === '0%').assertTrue();
    expect(testDividerParam96.primary.posY === '0%').assertTrue();
    expect(testDividerParam96.secondary.posX === '0%').assertTrue();
    expect(testDividerParam96.secondary.posY === '0%').assertTrue();
    expect(testDividerParam96.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam96.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_097', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer97: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer97.init();
    let testDividerParam97 = testContainer97.dividerParam;
    testDividerParam97.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer97);

    expect(testContainer97.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer97.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer97.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer97.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer97.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer97.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer97.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer97.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer97.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer97.needRenderPos.posX === 0).assertTrue();
    expect(testContainer97.needRenderPos.posY === 0).assertTrue();
    expect(testContainer97.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer97.iconAlpha === 0).assertTrue();
    expect(testContainer97.iconAlpha === 0).assertTrue();
    expect(testContainer97.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer97.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer97.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer97.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer97.intelligentScene === 1).assertTrue();

    expect(testDividerParam97.primary.translateY === 0).assertTrue();
    expect(testDividerParam97.primary.translateX === 0).assertTrue();
    expect(testDividerParam97.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam97.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam97.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam97.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam97.primary.opacity === 1).assertTrue();
    expect(testDividerParam97.primary.blurScale === 0).assertTrue();
    expect(testDividerParam97.secondary.opacity === 1).assertTrue();
    expect(testDividerParam97.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam97.primary.rotateX === 0).assertTrue();
    expect(testDividerParam97.primary.rotateY === 0).assertTrue();
    expect(testDividerParam97.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam97.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam97.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam97.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam97.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam97.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam97.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam97.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam97.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam97.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam97.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam97.primary.posX === '0%').assertTrue();
    expect(testDividerParam97.primary.posY === '0%').assertTrue();
    expect(testDividerParam97.secondary.posX === '0%').assertTrue();
    expect(testDividerParam97.secondary.posY === '0%').assertTrue();
    expect(testDividerParam97.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam97.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_098', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer98: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer98.init();
    let testDividerParam98 = testContainer98.dividerParam;
    testDividerParam98.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer98);

    expect(testContainer98.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer98.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer98.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer98.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer98.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer98.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer98.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer98.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer98.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer98.needRenderPos.posX === 0).assertTrue();
    expect(testContainer98.needRenderPos.posY === 0).assertTrue();
    expect(testContainer98.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer98.iconAlpha === 0).assertTrue();
    expect(testContainer98.iconAlpha === 0).assertTrue();
    expect(testContainer98.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer98.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer98.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer98.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer98.intelligentScene === 1).assertTrue();

    expect(testDividerParam98.primary.translateY === 0).assertTrue();
    expect(testDividerParam98.primary.translateX === 0).assertTrue();
    expect(testDividerParam98.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam98.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam98.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam98.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam98.primary.opacity === 1).assertTrue();
    expect(testDividerParam98.primary.blurScale === 0).assertTrue();
    expect(testDividerParam98.secondary.opacity === 1).assertTrue();
    expect(testDividerParam98.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam98.primary.rotateX === 0).assertTrue();
    expect(testDividerParam98.primary.rotateY === 0).assertTrue();
    expect(testDividerParam98.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam98.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam98.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam98.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam98.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam98.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam98.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam98.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam98.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam98.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam98.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam98.primary.posX === '0%').assertTrue();
    expect(testDividerParam98.primary.posY === '0%').assertTrue();
    expect(testDividerParam98.secondary.posX === '0%').assertTrue();
    expect(testDividerParam98.secondary.posY === '0%').assertTrue();
    expect(testDividerParam98.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam98.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_099', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer99: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer99.init();
    let testDividerParam99 = testContainer99.dividerParam;
    testDividerParam99.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer99);

    expect(testContainer99.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer99.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer99.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer99.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer99.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer99.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer99.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer99.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer99.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer99.needRenderPos.posX === 0).assertTrue();
    expect(testContainer99.needRenderPos.posY === 0).assertTrue();
    expect(testContainer99.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer99.iconAlpha === 0).assertTrue();
    expect(testContainer99.iconAlpha === 0).assertTrue();
    expect(testContainer99.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer99.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer99.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer99.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer99.intelligentScene === 1).assertTrue();

    expect(testDividerParam99.primary.translateY === 0).assertTrue();
    expect(testDividerParam99.primary.translateX === 0).assertTrue();
    expect(testDividerParam99.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam99.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam99.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam99.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam99.primary.opacity === 1).assertTrue();
    expect(testDividerParam99.primary.blurScale === 0).assertTrue();
    expect(testDividerParam99.secondary.opacity === 1).assertTrue();
    expect(testDividerParam99.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam99.primary.rotateX === 0).assertTrue();
    expect(testDividerParam99.primary.rotateY === 0).assertTrue();
    expect(testDividerParam99.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam99.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam99.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam99.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam99.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam99.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam99.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam99.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam99.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam99.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam99.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam99.primary.posX === '0%').assertTrue();
    expect(testDividerParam99.primary.posY === '0%').assertTrue();
    expect(testDividerParam99.secondary.posX === '0%').assertTrue();
    expect(testDividerParam99.secondary.posY === '0%').assertTrue();
    expect(testDividerParam99.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam99.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_100', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer100: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer100.init();
    let testDividerParam100 = testContainer100.dividerParam;
    testDividerParam100.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer100);

    expect(testContainer100.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer100.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer100.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer100.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer100.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer100.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer100.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer100.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer100.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer100.needRenderPos.posX === 0).assertTrue();
    expect(testContainer100.needRenderPos.posY === 0).assertTrue();
    expect(testContainer100.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer100.iconAlpha === 0).assertTrue();
    expect(testContainer100.iconAlpha === 0).assertTrue();
    expect(testContainer100.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer100.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer100.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer100.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer100.intelligentScene === 1).assertTrue();

    expect(testDividerParam100.primary.translateY === 0).assertTrue();
    expect(testDividerParam100.primary.translateX === 0).assertTrue();
    expect(testDividerParam100.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam100.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam100.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam100.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam100.primary.opacity === 1).assertTrue();
    expect(testDividerParam100.primary.blurScale === 0).assertTrue();
    expect(testDividerParam100.secondary.opacity === 1).assertTrue();
    expect(testDividerParam100.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam100.primary.rotateX === 0).assertTrue();
    expect(testDividerParam100.primary.rotateY === 0).assertTrue();
    expect(testDividerParam100.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam100.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam100.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam100.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam100.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam100.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam100.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam100.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam100.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam100.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam100.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam100.primary.posX === '0%').assertTrue();
    expect(testDividerParam100.primary.posY === '0%').assertTrue();
    expect(testDividerParam100.secondary.posX === '0%').assertTrue();
    expect(testDividerParam100.secondary.posY === '0%').assertTrue();
    expect(testDividerParam100.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam100.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_101', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer101: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer101.init();
    let testDividerParam101 = testContainer101.dividerParam;
    testDividerParam101.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer101);

    expect(testContainer101.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer101.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer101.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer101.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer101.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer101.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer101.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer101.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer101.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer101.needRenderPos.posX === 0).assertTrue();
    expect(testContainer101.needRenderPos.posY === 0).assertTrue();
    expect(testContainer101.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer101.iconAlpha === 0).assertTrue();
    expect(testContainer101.iconAlpha === 0).assertTrue();
    expect(testContainer101.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer101.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer101.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer101.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer101.intelligentScene === 1).assertTrue();

    expect(testDividerParam101.primary.translateY === 0).assertTrue();
    expect(testDividerParam101.primary.translateX === 0).assertTrue();
    expect(testDividerParam101.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam101.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam101.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam101.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam101.primary.opacity === 1).assertTrue();
    expect(testDividerParam101.primary.blurScale === 0).assertTrue();
    expect(testDividerParam101.secondary.opacity === 1).assertTrue();
    expect(testDividerParam101.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam101.primary.rotateX === 0).assertTrue();
    expect(testDividerParam101.primary.rotateY === 0).assertTrue();
    expect(testDividerParam101.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam101.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam101.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam101.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam101.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam101.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam101.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam101.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam101.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam101.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam101.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam101.primary.posX === '0%').assertTrue();
    expect(testDividerParam101.primary.posY === '0%').assertTrue();
    expect(testDividerParam101.secondary.posX === '0%').assertTrue();
    expect(testDividerParam101.secondary.posY === '0%').assertTrue();
    expect(testDividerParam101.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam101.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_102', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer102: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer102.init();
    let testDividerParam102 = testContainer102.dividerParam;
    testDividerParam102.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer102);

    expect(testContainer102.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer102.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer102.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer102.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer102.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer102.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer102.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer102.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer102.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer102.needRenderPos.posX === 0).assertTrue();
    expect(testContainer102.needRenderPos.posY === 0).assertTrue();
    expect(testContainer102.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer102.iconAlpha === 0).assertTrue();
    expect(testContainer102.iconAlpha === 0).assertTrue();
    expect(testContainer102.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer102.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer102.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer102.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer102.intelligentScene === 1).assertTrue();

    expect(testDividerParam102.primary.translateY === 0).assertTrue();
    expect(testDividerParam102.primary.translateX === 0).assertTrue();
    expect(testDividerParam102.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam102.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam102.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam102.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam102.primary.opacity === 1).assertTrue();
    expect(testDividerParam102.primary.blurScale === 0).assertTrue();
    expect(testDividerParam102.secondary.opacity === 1).assertTrue();
    expect(testDividerParam102.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam102.primary.rotateX === 0).assertTrue();
    expect(testDividerParam102.primary.rotateY === 0).assertTrue();
    expect(testDividerParam102.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam102.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam102.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam102.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam102.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam102.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam102.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam102.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam102.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam102.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam102.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam102.primary.posX === '0%').assertTrue();
    expect(testDividerParam102.primary.posY === '0%').assertTrue();
    expect(testDividerParam102.secondary.posX === '0%').assertTrue();
    expect(testDividerParam102.secondary.posY === '0%').assertTrue();
    expect(testDividerParam102.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam102.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_103', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer103: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer103.init();
    let testDividerParam103 = testContainer103.dividerParam;
    testDividerParam103.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer103);

    expect(testContainer103.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer103.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer103.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer103.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer103.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer103.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer103.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer103.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer103.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer103.needRenderPos.posX === 0).assertTrue();
    expect(testContainer103.needRenderPos.posY === 0).assertTrue();
    expect(testContainer103.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer103.iconAlpha === 0).assertTrue();
    expect(testContainer103.iconAlpha === 0).assertTrue();
    expect(testContainer103.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer103.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer103.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer103.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer103.intelligentScene === 1).assertTrue();

    expect(testDividerParam103.primary.translateY === 0).assertTrue();
    expect(testDividerParam103.primary.translateX === 0).assertTrue();
    expect(testDividerParam103.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam103.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam103.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam103.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam103.primary.opacity === 1).assertTrue();
    expect(testDividerParam103.primary.blurScale === 0).assertTrue();
    expect(testDividerParam103.secondary.opacity === 1).assertTrue();
    expect(testDividerParam103.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam103.primary.rotateX === 0).assertTrue();
    expect(testDividerParam103.primary.rotateY === 0).assertTrue();
    expect(testDividerParam103.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam103.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam103.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam103.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam103.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam103.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam103.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam103.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam103.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam103.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam103.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam103.primary.posX === '0%').assertTrue();
    expect(testDividerParam103.primary.posY === '0%').assertTrue();
    expect(testDividerParam103.secondary.posX === '0%').assertTrue();
    expect(testDividerParam103.secondary.posY === '0%').assertTrue();
    expect(testDividerParam103.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam103.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_104', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer104: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer104.init();
    let testDividerParam104 = testContainer104.dividerParam;
    testDividerParam104.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer104);

    expect(testContainer104.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer104.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer104.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer104.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer104.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer104.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer104.needRenderScale.centerX === '104%').assertTrue();
    expect(testContainer104.needRenderScale.centerY === '104%').assertTrue();
    expect(testContainer104.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer104.needRenderPos.posX === 0).assertTrue();
    expect(testContainer104.needRenderPos.posY === 0).assertTrue();
    expect(testContainer104.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer104.iconAlpha === 0).assertTrue();
    expect(testContainer104.iconAlpha === 0).assertTrue();
    expect(testContainer104.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer104.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer104.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer104.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer104.intelligentScene === 1).assertTrue();

    expect(testDividerParam104.primary.translateY === 0).assertTrue();
    expect(testDividerParam104.primary.translateX === 0).assertTrue();
    expect(testDividerParam104.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam104.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam104.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam104.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam104.primary.opacity === 1).assertTrue();
    expect(testDividerParam104.primary.blurScale === 0).assertTrue();
    expect(testDividerParam104.secondary.opacity === 1).assertTrue();
    expect(testDividerParam104.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam104.primary.rotateX === 0).assertTrue();
    expect(testDividerParam104.primary.rotateY === 0).assertTrue();
    expect(testDividerParam104.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam104.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam104.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam104.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam104.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam104.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam104.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam104.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam104.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam104.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam104.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam104.primary.posX === '0%').assertTrue();
    expect(testDividerParam104.primary.posY === '0%').assertTrue();
    expect(testDividerParam104.secondary.posX === '0%').assertTrue();
    expect(testDividerParam104.secondary.posY === '0%').assertTrue();
    expect(testDividerParam104.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam104.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_105', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer105: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer105.init();
    let testDividerParam105 = testContainer105.dividerParam;
    testDividerParam105.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer105);

    expect(testContainer105.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer105.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer105.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer105.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer105.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer105.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer105.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer105.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer105.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer105.needRenderPos.posX === 0).assertTrue();
    expect(testContainer105.needRenderPos.posY === 0).assertTrue();
    expect(testContainer105.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer105.iconAlpha === 0).assertTrue();
    expect(testContainer105.iconAlpha === 0).assertTrue();
    expect(testContainer105.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer105.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer105.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer105.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer105.intelligentScene === 1).assertTrue();

    expect(testDividerParam105.primary.translateY === 0).assertTrue();
    expect(testDividerParam105.primary.translateX === 0).assertTrue();
    expect(testDividerParam105.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam105.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam105.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam105.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam105.primary.opacity === 1).assertTrue();
    expect(testDividerParam105.primary.blurScale === 0).assertTrue();
    expect(testDividerParam105.secondary.opacity === 1).assertTrue();
    expect(testDividerParam105.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam105.primary.rotateX === 0).assertTrue();
    expect(testDividerParam105.primary.rotateY === 0).assertTrue();
    expect(testDividerParam105.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam105.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam105.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam105.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam105.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam105.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam105.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam105.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam105.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam105.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam105.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam105.primary.posX === '0%').assertTrue();
    expect(testDividerParam105.primary.posY === '0%').assertTrue();
    expect(testDividerParam105.secondary.posX === '0%').assertTrue();
    expect(testDividerParam105.secondary.posY === '0%').assertTrue();
    expect(testDividerParam105.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam105.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_106', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer106: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer106.init();
    let testDividerParam106 = testContainer106.dividerParam;
    testDividerParam106.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer106);

    expect(testContainer106.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer106.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer106.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer106.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer106.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer106.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer106.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer106.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer106.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer106.needRenderPos.posX === 0).assertTrue();
    expect(testContainer106.needRenderPos.posY === 0).assertTrue();
    expect(testContainer106.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer106.iconAlpha === 0).assertTrue();
    expect(testContainer106.iconAlpha === 0).assertTrue();
    expect(testContainer106.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer106.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer106.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer106.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer106.intelligentScene === 1).assertTrue();

    expect(testDividerParam106.primary.translateY === 0).assertTrue();
    expect(testDividerParam106.primary.translateX === 0).assertTrue();
    expect(testDividerParam106.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam106.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam106.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam106.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam106.primary.opacity === 1).assertTrue();
    expect(testDividerParam106.primary.blurScale === 0).assertTrue();
    expect(testDividerParam106.secondary.opacity === 1).assertTrue();
    expect(testDividerParam106.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam106.primary.rotateX === 0).assertTrue();
    expect(testDividerParam106.primary.rotateY === 0).assertTrue();
    expect(testDividerParam106.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam106.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam106.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam106.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam106.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam106.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam106.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam106.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam106.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam106.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam106.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam106.primary.posX === '0%').assertTrue();
    expect(testDividerParam106.primary.posY === '0%').assertTrue();
    expect(testDividerParam106.secondary.posX === '0%').assertTrue();
    expect(testDividerParam106.secondary.posY === '0%').assertTrue();
    expect(testDividerParam106.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam106.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_107', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer107: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer107.init();
    let testDividerParam107 = testContainer107.dividerParam;
    testDividerParam107.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer107);

    expect(testContainer107.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer107.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer107.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer107.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer107.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer107.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer107.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer107.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer107.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer107.needRenderPos.posX === 0).assertTrue();
    expect(testContainer107.needRenderPos.posY === 0).assertTrue();
    expect(testContainer107.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer107.iconAlpha === 0).assertTrue();
    expect(testContainer107.iconAlpha === 0).assertTrue();
    expect(testContainer107.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer107.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer107.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer107.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer107.intelligentScene === 1).assertTrue();

    expect(testDividerParam107.primary.translateY === 0).assertTrue();
    expect(testDividerParam107.primary.translateX === 0).assertTrue();
    expect(testDividerParam107.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam107.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam107.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam107.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam107.primary.opacity === 1).assertTrue();
    expect(testDividerParam107.primary.blurScale === 0).assertTrue();
    expect(testDividerParam107.secondary.opacity === 1).assertTrue();
    expect(testDividerParam107.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam107.primary.rotateX === 0).assertTrue();
    expect(testDividerParam107.primary.rotateY === 0).assertTrue();
    expect(testDividerParam107.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam107.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam107.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam107.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam107.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam107.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam107.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam107.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam107.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam107.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam107.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam107.primary.posX === '0%').assertTrue();
    expect(testDividerParam107.primary.posY === '0%').assertTrue();
    expect(testDividerParam107.secondary.posX === '0%').assertTrue();
    expect(testDividerParam107.secondary.posY === '0%').assertTrue();
    expect(testDividerParam107.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam107.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_108', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer108: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer108.init();
    let testDividerParam108 = testContainer108.dividerParam;
    testDividerParam108.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer108);

    expect(testContainer108.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer108.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer108.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer108.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer108.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer108.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer108.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer108.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer108.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer108.needRenderPos.posX === 0).assertTrue();
    expect(testContainer108.needRenderPos.posY === 0).assertTrue();
    expect(testContainer108.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer108.iconAlpha === 0).assertTrue();
    expect(testContainer108.iconAlpha === 0).assertTrue();
    expect(testContainer108.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer108.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer108.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer108.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer108.intelligentScene === 1).assertTrue();

    expect(testDividerParam108.primary.translateY === 0).assertTrue();
    expect(testDividerParam108.primary.translateX === 0).assertTrue();
    expect(testDividerParam108.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam108.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam108.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam108.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam108.primary.opacity === 1).assertTrue();
    expect(testDividerParam108.primary.blurScale === 0).assertTrue();
    expect(testDividerParam108.secondary.opacity === 1).assertTrue();
    expect(testDividerParam108.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam108.primary.rotateX === 0).assertTrue();
    expect(testDividerParam108.primary.rotateY === 0).assertTrue();
    expect(testDividerParam108.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam108.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam108.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam108.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam108.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam108.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam108.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam108.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam108.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam108.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam108.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam108.primary.posX === '0%').assertTrue();
    expect(testDividerParam108.primary.posY === '0%').assertTrue();
    expect(testDividerParam108.secondary.posX === '0%').assertTrue();
    expect(testDividerParam108.secondary.posY === '0%').assertTrue();
    expect(testDividerParam108.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam108.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_109', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer109: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer109.init();
    let testDividerParam109 = testContainer109.dividerParam;
    testDividerParam109.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer109);

    expect(testContainer109.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer109.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer109.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer109.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer109.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer109.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer109.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer109.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer109.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer109.needRenderPos.posX === 0).assertTrue();
    expect(testContainer109.needRenderPos.posY === 0).assertTrue();
    expect(testContainer109.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer109.iconAlpha === 0).assertTrue();
    expect(testContainer109.iconAlpha === 0).assertTrue();
    expect(testContainer109.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer109.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer109.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer109.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer109.intelligentScene === 1).assertTrue();

    expect(testDividerParam109.primary.translateY === 0).assertTrue();
    expect(testDividerParam109.primary.translateX === 0).assertTrue();
    expect(testDividerParam109.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam109.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam109.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam109.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam109.primary.opacity === 1).assertTrue();
    expect(testDividerParam109.primary.blurScale === 0).assertTrue();
    expect(testDividerParam109.secondary.opacity === 1).assertTrue();
    expect(testDividerParam109.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam109.primary.rotateX === 0).assertTrue();
    expect(testDividerParam109.primary.rotateY === 0).assertTrue();
    expect(testDividerParam109.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam109.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam109.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam109.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam109.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam109.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam109.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam109.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam109.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam109.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam109.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam109.primary.posX === '0%').assertTrue();
    expect(testDividerParam109.primary.posY === '0%').assertTrue();
    expect(testDividerParam109.secondary.posX === '0%').assertTrue();
    expect(testDividerParam109.secondary.posY === '0%').assertTrue();
    expect(testDividerParam109.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam109.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_110', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer110: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer110.init();
    let testDividerParam110 = testContainer110.dividerParam;
    testDividerParam110.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer110);

    expect(testContainer110.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer110.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer110.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer110.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer110.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer110.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer110.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer110.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer110.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer110.needRenderPos.posX === 0).assertTrue();
    expect(testContainer110.needRenderPos.posY === 0).assertTrue();
    expect(testContainer110.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer110.iconAlpha === 0).assertTrue();
    expect(testContainer110.iconAlpha === 0).assertTrue();
    expect(testContainer110.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer110.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer110.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer110.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer110.intelligentScene === 1).assertTrue();

    expect(testDividerParam110.primary.translateY === 0).assertTrue();
    expect(testDividerParam110.primary.translateX === 0).assertTrue();
    expect(testDividerParam110.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam110.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam110.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam110.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam110.primary.opacity === 1).assertTrue();
    expect(testDividerParam110.primary.blurScale === 0).assertTrue();
    expect(testDividerParam110.secondary.opacity === 1).assertTrue();
    expect(testDividerParam110.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam110.primary.rotateX === 0).assertTrue();
    expect(testDividerParam110.primary.rotateY === 0).assertTrue();
    expect(testDividerParam110.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam110.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam110.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam110.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam110.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam110.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam110.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam110.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam110.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam110.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam110.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam110.primary.posX === '0%').assertTrue();
    expect(testDividerParam110.primary.posY === '0%').assertTrue();
    expect(testDividerParam110.secondary.posX === '0%').assertTrue();
    expect(testDividerParam110.secondary.posY === '0%').assertTrue();
    expect(testDividerParam110.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam110.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_111', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer111: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer111.init();
    let testDividerParam111 = testContainer111.dividerParam;
    testDividerParam111.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer111);

    expect(testContainer111.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer111.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer111.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer111.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer111.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer111.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer111.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer111.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer111.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer111.needRenderPos.posX === 0).assertTrue();
    expect(testContainer111.needRenderPos.posY === 0).assertTrue();
    expect(testContainer111.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer111.iconAlpha === 0).assertTrue();
    expect(testContainer111.iconAlpha === 0).assertTrue();
    expect(testContainer111.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer111.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer111.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer111.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer111.intelligentScene === 1).assertTrue();

    expect(testDividerParam111.primary.translateY === 0).assertTrue();
    expect(testDividerParam111.primary.translateX === 0).assertTrue();
    expect(testDividerParam111.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam111.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam111.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam111.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam111.primary.opacity === 1).assertTrue();
    expect(testDividerParam111.primary.blurScale === 0).assertTrue();
    expect(testDividerParam111.secondary.opacity === 1).assertTrue();
    expect(testDividerParam111.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam111.primary.rotateX === 0).assertTrue();
    expect(testDividerParam111.primary.rotateY === 0).assertTrue();
    expect(testDividerParam111.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam111.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam111.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam111.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam111.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam111.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam111.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam111.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam111.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam111.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam111.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam111.primary.posX === '0%').assertTrue();
    expect(testDividerParam111.primary.posY === '0%').assertTrue();
    expect(testDividerParam111.secondary.posX === '0%').assertTrue();
    expect(testDividerParam111.secondary.posY === '0%').assertTrue();
    expect(testDividerParam111.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam111.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_112', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer112: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer112.init();
    let testDividerParam112 = testContainer112.dividerParam;
    testDividerParam112.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer112);

    expect(testContainer112.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer112.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer112.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer112.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer112.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer112.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer112.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer112.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer112.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer112.needRenderPos.posX === 0).assertTrue();
    expect(testContainer112.needRenderPos.posY === 0).assertTrue();
    expect(testContainer112.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer112.iconAlpha === 0).assertTrue();
    expect(testContainer112.iconAlpha === 0).assertTrue();
    expect(testContainer112.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer112.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer112.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer112.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer112.intelligentScene === 1).assertTrue();

    expect(testDividerParam112.primary.translateY === 0).assertTrue();
    expect(testDividerParam112.primary.translateX === 0).assertTrue();
    expect(testDividerParam112.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam112.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam112.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam112.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam112.primary.opacity === 1).assertTrue();
    expect(testDividerParam112.primary.blurScale === 0).assertTrue();
    expect(testDividerParam112.secondary.opacity === 1).assertTrue();
    expect(testDividerParam112.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam112.primary.rotateX === 0).assertTrue();
    expect(testDividerParam112.primary.rotateY === 0).assertTrue();
    expect(testDividerParam112.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam112.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam112.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam112.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam112.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam112.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam112.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam112.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam112.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam112.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam112.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam112.primary.posX === '0%').assertTrue();
    expect(testDividerParam112.primary.posY === '0%').assertTrue();
    expect(testDividerParam112.secondary.posX === '0%').assertTrue();
    expect(testDividerParam112.secondary.posY === '0%').assertTrue();
    expect(testDividerParam112.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam112.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_113', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer113: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer113.init();
    let testDividerParam113 = testContainer113.dividerParam;
    testDividerParam113.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer113);

    expect(testContainer113.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer113.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer113.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer113.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer113.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer113.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer113.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer113.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer113.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer113.needRenderPos.posX === 0).assertTrue();
    expect(testContainer113.needRenderPos.posY === 0).assertTrue();
    expect(testContainer113.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer113.iconAlpha === 0).assertTrue();
    expect(testContainer113.iconAlpha === 0).assertTrue();
    expect(testContainer113.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer113.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer113.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer113.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer113.intelligentScene === 1).assertTrue();

    expect(testDividerParam113.primary.translateY === 0).assertTrue();
    expect(testDividerParam113.primary.translateX === 0).assertTrue();
    expect(testDividerParam113.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam113.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam113.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam113.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam113.primary.opacity === 1).assertTrue();
    expect(testDividerParam113.primary.blurScale === 0).assertTrue();
    expect(testDividerParam113.secondary.opacity === 1).assertTrue();
    expect(testDividerParam113.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam113.primary.rotateX === 0).assertTrue();
    expect(testDividerParam113.primary.rotateY === 0).assertTrue();
    expect(testDividerParam113.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam113.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam113.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam113.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam113.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam113.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam113.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam113.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam113.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam113.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam113.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam113.primary.posX === '0%').assertTrue();
    expect(testDividerParam113.primary.posY === '0%').assertTrue();
    expect(testDividerParam113.secondary.posX === '0%').assertTrue();
    expect(testDividerParam113.secondary.posY === '0%').assertTrue();
    expect(testDividerParam113.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam113.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_114', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer114: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer114.init();
    let testDividerParam114 = testContainer114.dividerParam;
    testDividerParam114.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer114);

    expect(testContainer114.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer114.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer114.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer114.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer114.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer114.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer114.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer114.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer114.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer114.needRenderPos.posX === 0).assertTrue();
    expect(testContainer114.needRenderPos.posY === 0).assertTrue();
    expect(testContainer114.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer114.iconAlpha === 0).assertTrue();
    expect(testContainer114.iconAlpha === 0).assertTrue();
    expect(testContainer114.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer114.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer114.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer114.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer114.intelligentScene === 1).assertTrue();

    expect(testDividerParam114.primary.translateY === 0).assertTrue();
    expect(testDividerParam114.primary.translateX === 0).assertTrue();
    expect(testDividerParam114.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam114.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam114.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam114.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam114.primary.opacity === 1).assertTrue();
    expect(testDividerParam114.primary.blurScale === 0).assertTrue();
    expect(testDividerParam114.secondary.opacity === 1).assertTrue();
    expect(testDividerParam114.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam114.primary.rotateX === 0).assertTrue();
    expect(testDividerParam114.primary.rotateY === 0).assertTrue();
    expect(testDividerParam114.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam114.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam114.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam114.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam114.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam114.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam114.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam114.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam114.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam114.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam114.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam114.primary.posX === '0%').assertTrue();
    expect(testDividerParam114.primary.posY === '0%').assertTrue();
    expect(testDividerParam114.secondary.posX === '0%').assertTrue();
    expect(testDividerParam114.secondary.posY === '0%').assertTrue();
    expect(testDividerParam114.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam114.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_115', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer115: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer115.init();
    let testDividerParam115 = testContainer115.dividerParam;
    testDividerParam115.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer115);

    expect(testContainer115.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer115.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer115.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer115.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer115.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer115.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer115.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer115.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer115.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer115.needRenderPos.posX === 0).assertTrue();
    expect(testContainer115.needRenderPos.posY === 0).assertTrue();
    expect(testContainer115.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer115.iconAlpha === 0).assertTrue();
    expect(testContainer115.iconAlpha === 0).assertTrue();
    expect(testContainer115.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer115.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer115.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer115.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer115.intelligentScene === 1).assertTrue();

    expect(testDividerParam115.primary.translateY === 0).assertTrue();
    expect(testDividerParam115.primary.translateX === 0).assertTrue();
    expect(testDividerParam115.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam115.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam115.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam115.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam115.primary.opacity === 1).assertTrue();
    expect(testDividerParam115.primary.blurScale === 0).assertTrue();
    expect(testDividerParam115.secondary.opacity === 1).assertTrue();
    expect(testDividerParam115.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam115.primary.rotateX === 0).assertTrue();
    expect(testDividerParam115.primary.rotateY === 0).assertTrue();
    expect(testDividerParam115.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam115.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam115.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam115.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam115.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam115.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam115.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam115.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam115.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam115.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam115.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam115.primary.posX === '0%').assertTrue();
    expect(testDividerParam115.primary.posY === '0%').assertTrue();
    expect(testDividerParam115.secondary.posX === '0%').assertTrue();
    expect(testDividerParam115.secondary.posY === '0%').assertTrue();
    expect(testDividerParam115.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam115.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_116', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer116: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer116.init();
    let testDividerParam116 = testContainer116.dividerParam;
    testDividerParam116.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer116);

    expect(testContainer116.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer116.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer116.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer116.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer116.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer116.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer116.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer116.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer116.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer116.needRenderPos.posX === 0).assertTrue();
    expect(testContainer116.needRenderPos.posY === 0).assertTrue();
    expect(testContainer116.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer116.iconAlpha === 0).assertTrue();
    expect(testContainer116.iconAlpha === 0).assertTrue();
    expect(testContainer116.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer116.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer116.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer116.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer116.intelligentScene === 1).assertTrue();

    expect(testDividerParam116.primary.translateY === 0).assertTrue();
    expect(testDividerParam116.primary.translateX === 0).assertTrue();
    expect(testDividerParam116.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam116.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam116.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam116.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam116.primary.opacity === 1).assertTrue();
    expect(testDividerParam116.primary.blurScale === 0).assertTrue();
    expect(testDividerParam116.secondary.opacity === 1).assertTrue();
    expect(testDividerParam116.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam116.primary.rotateX === 0).assertTrue();
    expect(testDividerParam116.primary.rotateY === 0).assertTrue();
    expect(testDividerParam116.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam116.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam116.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam116.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam116.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam116.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam116.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam116.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam116.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam116.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam116.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam116.primary.posX === '0%').assertTrue();
    expect(testDividerParam116.primary.posY === '0%').assertTrue();
    expect(testDividerParam116.secondary.posX === '0%').assertTrue();
    expect(testDividerParam116.secondary.posY === '0%').assertTrue();
    expect(testDividerParam116.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam116.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_117', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer117: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer117.init();
    let testDividerParam117 = testContainer117.dividerParam;
    testDividerParam117.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer117);

    expect(testContainer117.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer117.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer117.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer117.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer117.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer117.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer117.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer117.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer117.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer117.needRenderPos.posX === 0).assertTrue();
    expect(testContainer117.needRenderPos.posY === 0).assertTrue();
    expect(testContainer117.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer117.iconAlpha === 0).assertTrue();
    expect(testContainer117.iconAlpha === 0).assertTrue();
    expect(testContainer117.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer117.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer117.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer117.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer117.intelligentScene === 1).assertTrue();

    expect(testDividerParam117.primary.translateY === 0).assertTrue();
    expect(testDividerParam117.primary.translateX === 0).assertTrue();
    expect(testDividerParam117.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam117.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam117.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam117.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam117.primary.opacity === 1).assertTrue();
    expect(testDividerParam117.primary.blurScale === 0).assertTrue();
    expect(testDividerParam117.secondary.opacity === 1).assertTrue();
    expect(testDividerParam117.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam117.primary.rotateX === 0).assertTrue();
    expect(testDividerParam117.primary.rotateY === 0).assertTrue();
    expect(testDividerParam117.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam117.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam117.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam117.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam117.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam117.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam117.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam117.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam117.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam117.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam117.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam117.primary.posX === '0%').assertTrue();
    expect(testDividerParam117.primary.posY === '0%').assertTrue();
    expect(testDividerParam117.secondary.posX === '0%').assertTrue();
    expect(testDividerParam117.secondary.posY === '0%').assertTrue();
    expect(testDividerParam117.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam117.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_118', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer118: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer118.init();
    let testDividerParam118 = testContainer118.dividerParam;
    testDividerParam118.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer118);

    expect(testContainer118.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer118.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer118.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer118.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer118.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer118.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer118.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer118.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer118.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer118.needRenderPos.posX === 0).assertTrue();
    expect(testContainer118.needRenderPos.posY === 0).assertTrue();
    expect(testContainer118.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer118.iconAlpha === 0).assertTrue();
    expect(testContainer118.iconAlpha === 0).assertTrue();
    expect(testContainer118.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer118.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer118.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer118.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer118.intelligentScene === 1).assertTrue();

    expect(testDividerParam118.primary.translateY === 0).assertTrue();
    expect(testDividerParam118.primary.translateX === 0).assertTrue();
    expect(testDividerParam118.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam118.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam118.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam118.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam118.primary.opacity === 1).assertTrue();
    expect(testDividerParam118.primary.blurScale === 0).assertTrue();
    expect(testDividerParam118.secondary.opacity === 1).assertTrue();
    expect(testDividerParam118.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam118.primary.rotateX === 0).assertTrue();
    expect(testDividerParam118.primary.rotateY === 0).assertTrue();
    expect(testDividerParam118.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam118.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam118.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam118.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam118.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam118.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam118.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam118.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam118.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam118.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam118.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam118.primary.posX === '0%').assertTrue();
    expect(testDividerParam118.primary.posY === '0%').assertTrue();
    expect(testDividerParam118.secondary.posX === '0%').assertTrue();
    expect(testDividerParam118.secondary.posY === '0%').assertTrue();
    expect(testDividerParam118.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam118.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_119', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer119: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer119.init();
    let testDividerParam119 = testContainer119.dividerParam;
    testDividerParam119.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer119);

    expect(testContainer119.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer119.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer119.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer119.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer119.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer119.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer119.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer119.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer119.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer119.needRenderPos.posX === 0).assertTrue();
    expect(testContainer119.needRenderPos.posY === 0).assertTrue();
    expect(testContainer119.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer119.iconAlpha === 0).assertTrue();
    expect(testContainer119.iconAlpha === 0).assertTrue();
    expect(testContainer119.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer119.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer119.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer119.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer119.intelligentScene === 1).assertTrue();

    expect(testDividerParam119.primary.translateY === 0).assertTrue();
    expect(testDividerParam119.primary.translateX === 0).assertTrue();
    expect(testDividerParam119.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam119.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam119.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam119.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam119.primary.opacity === 1).assertTrue();
    expect(testDividerParam119.primary.blurScale === 0).assertTrue();
    expect(testDividerParam119.secondary.opacity === 1).assertTrue();
    expect(testDividerParam119.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam119.primary.rotateX === 0).assertTrue();
    expect(testDividerParam119.primary.rotateY === 0).assertTrue();
    expect(testDividerParam119.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam119.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam119.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam119.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam119.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam119.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam119.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam119.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam119.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam119.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam119.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam119.primary.posX === '0%').assertTrue();
    expect(testDividerParam119.primary.posY === '0%').assertTrue();
    expect(testDividerParam119.secondary.posX === '0%').assertTrue();
    expect(testDividerParam119.secondary.posY === '0%').assertTrue();
    expect(testDividerParam119.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam119.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_120', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer120: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer120.init();
    let testDividerParam120 = testContainer120.dividerParam;
    testDividerParam120.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer120);

    expect(testContainer120.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer120.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer120.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer120.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer120.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer120.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer120.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer120.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer120.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer120.needRenderPos.posX === 0).assertTrue();
    expect(testContainer120.needRenderPos.posY === 0).assertTrue();
    expect(testContainer120.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer120.iconAlpha === 0).assertTrue();
    expect(testContainer120.iconAlpha === 0).assertTrue();
    expect(testContainer120.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer120.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer120.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer120.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer120.intelligentScene === 1).assertTrue();

    expect(testDividerParam120.primary.translateY === 0).assertTrue();
    expect(testDividerParam120.primary.translateX === 0).assertTrue();
    expect(testDividerParam120.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam120.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam120.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam120.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam120.primary.opacity === 1).assertTrue();
    expect(testDividerParam120.primary.blurScale === 0).assertTrue();
    expect(testDividerParam120.secondary.opacity === 1).assertTrue();
    expect(testDividerParam120.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam120.primary.rotateX === 0).assertTrue();
    expect(testDividerParam120.primary.rotateY === 0).assertTrue();
    expect(testDividerParam120.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam120.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam120.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam120.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam120.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam120.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam120.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam120.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam120.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam120.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam120.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam120.primary.posX === '0%').assertTrue();
    expect(testDividerParam120.primary.posY === '0%').assertTrue();
    expect(testDividerParam120.secondary.posX === '0%').assertTrue();
    expect(testDividerParam120.secondary.posY === '0%').assertTrue();
    expect(testDividerParam120.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam120.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_121', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer121: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer121.init();
    let testDividerParam121 = testContainer121.dividerParam;
    testDividerParam121.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer121);

    expect(testContainer121.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer121.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer121.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer121.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer121.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer121.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer121.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer121.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer121.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer121.needRenderPos.posX === 0).assertTrue();
    expect(testContainer121.needRenderPos.posY === 0).assertTrue();
    expect(testContainer121.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer121.iconAlpha === 0).assertTrue();
    expect(testContainer121.iconAlpha === 0).assertTrue();
    expect(testContainer121.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer121.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer121.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer121.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer121.intelligentScene === 1).assertTrue();

    expect(testDividerParam121.primary.translateY === 0).assertTrue();
    expect(testDividerParam121.primary.translateX === 0).assertTrue();
    expect(testDividerParam121.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam121.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam121.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam121.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam121.primary.opacity === 1).assertTrue();
    expect(testDividerParam121.primary.blurScale === 0).assertTrue();
    expect(testDividerParam121.secondary.opacity === 1).assertTrue();
    expect(testDividerParam121.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam121.primary.rotateX === 0).assertTrue();
    expect(testDividerParam121.primary.rotateY === 0).assertTrue();
    expect(testDividerParam121.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam121.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam121.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam121.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam121.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam121.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam121.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam121.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam121.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam121.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam121.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam121.primary.posX === '0%').assertTrue();
    expect(testDividerParam121.primary.posY === '0%').assertTrue();
    expect(testDividerParam121.secondary.posX === '0%').assertTrue();
    expect(testDividerParam121.secondary.posY === '0%').assertTrue();
    expect(testDividerParam121.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam121.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_122', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer122: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer122.init();
    let testDividerParam122 = testContainer122.dividerParam;
    testDividerParam122.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer122);

    expect(testContainer122.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer122.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer122.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer122.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer122.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer122.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer122.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer122.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer122.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer122.needRenderPos.posX === 0).assertTrue();
    expect(testContainer122.needRenderPos.posY === 0).assertTrue();
    expect(testContainer122.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer122.iconAlpha === 0).assertTrue();
    expect(testContainer122.iconAlpha === 0).assertTrue();
    expect(testContainer122.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer122.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer122.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer122.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer122.intelligentScene === 1).assertTrue();

    expect(testDividerParam122.primary.translateY === 0).assertTrue();
    expect(testDividerParam122.primary.translateX === 0).assertTrue();
    expect(testDividerParam122.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam122.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam122.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam122.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam122.primary.opacity === 1).assertTrue();
    expect(testDividerParam122.primary.blurScale === 0).assertTrue();
    expect(testDividerParam122.secondary.opacity === 1).assertTrue();
    expect(testDividerParam122.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam122.primary.rotateX === 0).assertTrue();
    expect(testDividerParam122.primary.rotateY === 0).assertTrue();
    expect(testDividerParam122.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam122.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam122.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam122.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam122.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam122.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam122.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam122.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam122.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam122.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam122.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam122.primary.posX === '0%').assertTrue();
    expect(testDividerParam122.primary.posY === '0%').assertTrue();
    expect(testDividerParam122.secondary.posX === '0%').assertTrue();
    expect(testDividerParam122.secondary.posY === '0%').assertTrue();
    expect(testDividerParam122.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam122.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_123', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer123: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer123.init();
    let testDividerParam123 = testContainer123.dividerParam;
    testDividerParam123.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer123);

    expect(testContainer123.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer123.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer123.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer123.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer123.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer123.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer123.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer123.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer123.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer123.needRenderPos.posX === 0).assertTrue();
    expect(testContainer123.needRenderPos.posY === 0).assertTrue();
    expect(testContainer123.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer123.iconAlpha === 0).assertTrue();
    expect(testContainer123.iconAlpha === 0).assertTrue();
    expect(testContainer123.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer123.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer123.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer123.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer123.intelligentScene === 1).assertTrue();

    expect(testDividerParam123.primary.translateY === 0).assertTrue();
    expect(testDividerParam123.primary.translateX === 0).assertTrue();
    expect(testDividerParam123.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam123.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam123.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam123.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam123.primary.opacity === 1).assertTrue();
    expect(testDividerParam123.primary.blurScale === 0).assertTrue();
    expect(testDividerParam123.secondary.opacity === 1).assertTrue();
    expect(testDividerParam123.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam123.primary.rotateX === 0).assertTrue();
    expect(testDividerParam123.primary.rotateY === 0).assertTrue();
    expect(testDividerParam123.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam123.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam123.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam123.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam123.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam123.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam123.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam123.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam123.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam123.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam123.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam123.primary.posX === '0%').assertTrue();
    expect(testDividerParam123.primary.posY === '0%').assertTrue();
    expect(testDividerParam123.secondary.posX === '0%').assertTrue();
    expect(testDividerParam123.secondary.posY === '0%').assertTrue();
    expect(testDividerParam123.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam123.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_124', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer124: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer124.init();
    let testDividerParam124 = testContainer124.dividerParam;
    testDividerParam124.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer124);

    expect(testContainer124.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer124.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer124.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer124.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer124.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer124.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer124.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer124.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer124.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer124.needRenderPos.posX === 0).assertTrue();
    expect(testContainer124.needRenderPos.posY === 0).assertTrue();
    expect(testContainer124.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer124.iconAlpha === 0).assertTrue();
    expect(testContainer124.iconAlpha === 0).assertTrue();
    expect(testContainer124.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer124.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer124.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer124.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer124.intelligentScene === 1).assertTrue();

    expect(testDividerParam124.primary.translateY === 0).assertTrue();
    expect(testDividerParam124.primary.translateX === 0).assertTrue();
    expect(testDividerParam124.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam124.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam124.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam124.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam124.primary.opacity === 1).assertTrue();
    expect(testDividerParam124.primary.blurScale === 0).assertTrue();
    expect(testDividerParam124.secondary.opacity === 1).assertTrue();
    expect(testDividerParam124.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam124.primary.rotateX === 0).assertTrue();
    expect(testDividerParam124.primary.rotateY === 0).assertTrue();
    expect(testDividerParam124.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam124.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam124.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam124.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam124.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam124.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam124.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam124.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam124.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam124.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam124.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam124.primary.posX === '0%').assertTrue();
    expect(testDividerParam124.primary.posY === '0%').assertTrue();
    expect(testDividerParam124.secondary.posX === '0%').assertTrue();
    expect(testDividerParam124.secondary.posY === '0%').assertTrue();
    expect(testDividerParam124.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam124.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_125', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer125: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer125.init();
    let testDividerParam125 = testContainer125.dividerParam;
    testDividerParam125.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer125);

    expect(testContainer125.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer125.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer125.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer125.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer125.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer125.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer125.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer125.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer125.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer125.needRenderPos.posX === 0).assertTrue();
    expect(testContainer125.needRenderPos.posY === 0).assertTrue();
    expect(testContainer125.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer125.iconAlpha === 0).assertTrue();
    expect(testContainer125.iconAlpha === 0).assertTrue();
    expect(testContainer125.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer125.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer125.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer125.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer125.intelligentScene === 1).assertTrue();

    expect(testDividerParam125.primary.translateY === 0).assertTrue();
    expect(testDividerParam125.primary.translateX === 0).assertTrue();
    expect(testDividerParam125.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam125.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam125.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam125.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam125.primary.opacity === 1).assertTrue();
    expect(testDividerParam125.primary.blurScale === 0).assertTrue();
    expect(testDividerParam125.secondary.opacity === 1).assertTrue();
    expect(testDividerParam125.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam125.primary.rotateX === 0).assertTrue();
    expect(testDividerParam125.primary.rotateY === 0).assertTrue();
    expect(testDividerParam125.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam125.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam125.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam125.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam125.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam125.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam125.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam125.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam125.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam125.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam125.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam125.primary.posX === '0%').assertTrue();
    expect(testDividerParam125.primary.posY === '0%').assertTrue();
    expect(testDividerParam125.secondary.posX === '0%').assertTrue();
    expect(testDividerParam125.secondary.posY === '0%').assertTrue();
    expect(testDividerParam125.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam125.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_126', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer126: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer126.init();
    let testDividerParam126 = testContainer126.dividerParam;
    testDividerParam126.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer126);

    expect(testContainer126.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer126.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer126.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer126.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer126.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer126.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer126.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer126.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer126.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer126.needRenderPos.posX === 0).assertTrue();
    expect(testContainer126.needRenderPos.posY === 0).assertTrue();
    expect(testContainer126.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer126.iconAlpha === 0).assertTrue();
    expect(testContainer126.iconAlpha === 0).assertTrue();
    expect(testContainer126.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer126.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer126.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer126.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer126.intelligentScene === 1).assertTrue();

    expect(testDividerParam126.primary.translateY === 0).assertTrue();
    expect(testDividerParam126.primary.translateX === 0).assertTrue();
    expect(testDividerParam126.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam126.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam126.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam126.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam126.primary.opacity === 1).assertTrue();
    expect(testDividerParam126.primary.blurScale === 0).assertTrue();
    expect(testDividerParam126.secondary.opacity === 1).assertTrue();
    expect(testDividerParam126.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam126.primary.rotateX === 0).assertTrue();
    expect(testDividerParam126.primary.rotateY === 0).assertTrue();
    expect(testDividerParam126.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam126.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam126.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam126.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam126.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam126.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam126.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam126.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam126.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam126.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam126.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam126.primary.posX === '0%').assertTrue();
    expect(testDividerParam126.primary.posY === '0%').assertTrue();
    expect(testDividerParam126.secondary.posX === '0%').assertTrue();
    expect(testDividerParam126.secondary.posY === '0%').assertTrue();
    expect(testDividerParam126.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam126.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_127', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer127: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer127.init();
    let testDividerParam127 = testContainer127.dividerParam;
    testDividerParam127.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer127);

    expect(testContainer127.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer127.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer127.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer127.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer127.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer127.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer127.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer127.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer127.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer127.needRenderPos.posX === 0).assertTrue();
    expect(testContainer127.needRenderPos.posY === 0).assertTrue();
    expect(testContainer127.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer127.iconAlpha === 0).assertTrue();
    expect(testContainer127.iconAlpha === 0).assertTrue();
    expect(testContainer127.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer127.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer127.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer127.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer127.intelligentScene === 1).assertTrue();

    expect(testDividerParam127.primary.translateY === 0).assertTrue();
    expect(testDividerParam127.primary.translateX === 0).assertTrue();
    expect(testDividerParam127.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam127.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam127.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam127.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam127.primary.opacity === 1).assertTrue();
    expect(testDividerParam127.primary.blurScale === 0).assertTrue();
    expect(testDividerParam127.secondary.opacity === 1).assertTrue();
    expect(testDividerParam127.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam127.primary.rotateX === 0).assertTrue();
    expect(testDividerParam127.primary.rotateY === 0).assertTrue();
    expect(testDividerParam127.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam127.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam127.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam127.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam127.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam127.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam127.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam127.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam127.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam127.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam127.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam127.primary.posX === '0%').assertTrue();
    expect(testDividerParam127.primary.posY === '0%').assertTrue();
    expect(testDividerParam127.secondary.posX === '0%').assertTrue();
    expect(testDividerParam127.secondary.posY === '0%').assertTrue();
    expect(testDividerParam127.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam127.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_128', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer128: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer128.init();
    let testDividerParam128 = testContainer128.dividerParam;
    testDividerParam128.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer128);

    expect(testContainer128.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer128.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer128.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer128.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer128.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer128.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer128.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer128.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer128.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer128.needRenderPos.posX === 0).assertTrue();
    expect(testContainer128.needRenderPos.posY === 0).assertTrue();
    expect(testContainer128.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer128.iconAlpha === 0).assertTrue();
    expect(testContainer128.iconAlpha === 0).assertTrue();
    expect(testContainer128.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer128.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer128.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer128.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer128.intelligentScene === 1).assertTrue();

    expect(testDividerParam128.primary.translateY === 0).assertTrue();
    expect(testDividerParam128.primary.translateX === 0).assertTrue();
    expect(testDividerParam128.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam128.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam128.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam128.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam128.primary.opacity === 1).assertTrue();
    expect(testDividerParam128.primary.blurScale === 0).assertTrue();
    expect(testDividerParam128.secondary.opacity === 1).assertTrue();
    expect(testDividerParam128.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam128.primary.rotateX === 0).assertTrue();
    expect(testDividerParam128.primary.rotateY === 0).assertTrue();
    expect(testDividerParam128.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam128.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam128.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam128.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam128.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam128.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam128.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam128.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam128.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam128.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam128.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam128.primary.posX === '0%').assertTrue();
    expect(testDividerParam128.primary.posY === '0%').assertTrue();
    expect(testDividerParam128.secondary.posX === '0%').assertTrue();
    expect(testDividerParam128.secondary.posY === '0%').assertTrue();
    expect(testDividerParam128.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam128.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_129', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer129: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer129.init();
    let testDividerParam129 = testContainer129.dividerParam;
    testDividerParam129.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer129);

    expect(testContainer129.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer129.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer129.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer129.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer129.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer129.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer129.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer129.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer129.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer129.needRenderPos.posX === 0).assertTrue();
    expect(testContainer129.needRenderPos.posY === 0).assertTrue();
    expect(testContainer129.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer129.iconAlpha === 0).assertTrue();
    expect(testContainer129.iconAlpha === 0).assertTrue();
    expect(testContainer129.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer129.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer129.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer129.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer129.intelligentScene === 1).assertTrue();

    expect(testDividerParam129.primary.translateY === 0).assertTrue();
    expect(testDividerParam129.primary.translateX === 0).assertTrue();
    expect(testDividerParam129.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam129.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam129.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam129.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam129.primary.opacity === 1).assertTrue();
    expect(testDividerParam129.primary.blurScale === 0).assertTrue();
    expect(testDividerParam129.secondary.opacity === 1).assertTrue();
    expect(testDividerParam129.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam129.primary.rotateX === 0).assertTrue();
    expect(testDividerParam129.primary.rotateY === 0).assertTrue();
    expect(testDividerParam129.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam129.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam129.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam129.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam129.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam129.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam129.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam129.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam129.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam129.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam129.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam129.primary.posX === '0%').assertTrue();
    expect(testDividerParam129.primary.posY === '0%').assertTrue();
    expect(testDividerParam129.secondary.posX === '0%').assertTrue();
    expect(testDividerParam129.secondary.posY === '0%').assertTrue();
    expect(testDividerParam129.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam129.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_130', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer130: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer130.init();
    let testDividerParam130 = testContainer130.dividerParam;
    testDividerParam130.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer130);

    expect(testContainer130.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer130.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer130.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer130.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer130.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer130.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer130.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer130.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer130.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer130.needRenderPos.posX === 0).assertTrue();
    expect(testContainer130.needRenderPos.posY === 0).assertTrue();
    expect(testContainer130.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer130.iconAlpha === 0).assertTrue();
    expect(testContainer130.iconAlpha === 0).assertTrue();
    expect(testContainer130.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer130.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer130.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer130.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer130.intelligentScene === 1).assertTrue();

    expect(testDividerParam130.primary.translateY === 0).assertTrue();
    expect(testDividerParam130.primary.translateX === 0).assertTrue();
    expect(testDividerParam130.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam130.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam130.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam130.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam130.primary.opacity === 1).assertTrue();
    expect(testDividerParam130.primary.blurScale === 0).assertTrue();
    expect(testDividerParam130.secondary.opacity === 1).assertTrue();
    expect(testDividerParam130.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam130.primary.rotateX === 0).assertTrue();
    expect(testDividerParam130.primary.rotateY === 0).assertTrue();
    expect(testDividerParam130.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam130.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam130.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam130.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam130.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam130.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam130.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam130.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam130.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam130.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam130.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam130.primary.posX === '0%').assertTrue();
    expect(testDividerParam130.primary.posY === '0%').assertTrue();
    expect(testDividerParam130.secondary.posX === '0%').assertTrue();
    expect(testDividerParam130.secondary.posY === '0%').assertTrue();
    expect(testDividerParam130.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam130.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_131', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer131: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer131.init();
    let testDividerParam131 = testContainer131.dividerParam;
    testDividerParam131.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer131);

    expect(testContainer131.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer131.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer131.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer131.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer131.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer131.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer131.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer131.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer131.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer131.needRenderPos.posX === 0).assertTrue();
    expect(testContainer131.needRenderPos.posY === 0).assertTrue();
    expect(testContainer131.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer131.iconAlpha === 0).assertTrue();
    expect(testContainer131.iconAlpha === 0).assertTrue();
    expect(testContainer131.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer131.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer131.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer131.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer131.intelligentScene === 1).assertTrue();

    expect(testDividerParam131.primary.translateY === 0).assertTrue();
    expect(testDividerParam131.primary.translateX === 0).assertTrue();
    expect(testDividerParam131.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam131.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam131.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam131.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam131.primary.opacity === 1).assertTrue();
    expect(testDividerParam131.primary.blurScale === 0).assertTrue();
    expect(testDividerParam131.secondary.opacity === 1).assertTrue();
    expect(testDividerParam131.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam131.primary.rotateX === 0).assertTrue();
    expect(testDividerParam131.primary.rotateY === 0).assertTrue();
    expect(testDividerParam131.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam131.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam131.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam131.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam131.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam131.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam131.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam131.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam131.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam131.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam131.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam131.primary.posX === '0%').assertTrue();
    expect(testDividerParam131.primary.posY === '0%').assertTrue();
    expect(testDividerParam131.secondary.posX === '0%').assertTrue();
    expect(testDividerParam131.secondary.posY === '0%').assertTrue();
    expect(testDividerParam131.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam131.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_132', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer132: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer132.init();
    let testDividerParam132 = testContainer132.dividerParam;
    testDividerParam132.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer132);

    expect(testContainer132.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer132.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer132.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer132.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer132.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer132.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer132.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer132.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer132.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer132.needRenderPos.posX === 0).assertTrue();
    expect(testContainer132.needRenderPos.posY === 0).assertTrue();
    expect(testContainer132.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer132.iconAlpha === 0).assertTrue();
    expect(testContainer132.iconAlpha === 0).assertTrue();
    expect(testContainer132.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer132.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer132.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer132.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer132.intelligentScene === 1).assertTrue();

    expect(testDividerParam132.primary.translateY === 0).assertTrue();
    expect(testDividerParam132.primary.translateX === 0).assertTrue();
    expect(testDividerParam132.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam132.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam132.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam132.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam132.primary.opacity === 1).assertTrue();
    expect(testDividerParam132.primary.blurScale === 0).assertTrue();
    expect(testDividerParam132.secondary.opacity === 1).assertTrue();
    expect(testDividerParam132.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam132.primary.rotateX === 0).assertTrue();
    expect(testDividerParam132.primary.rotateY === 0).assertTrue();
    expect(testDividerParam132.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam132.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam132.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam132.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam132.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam132.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam132.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam132.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam132.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam132.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam132.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam132.primary.posX === '0%').assertTrue();
    expect(testDividerParam132.primary.posY === '0%').assertTrue();
    expect(testDividerParam132.secondary.posX === '0%').assertTrue();
    expect(testDividerParam132.secondary.posY === '0%').assertTrue();
    expect(testDividerParam132.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam132.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_133', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer133: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer133.init();
    let testDividerParam133 = testContainer133.dividerParam;
    testDividerParam133.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer133);

    expect(testContainer133.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer133.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer133.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer133.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer133.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer133.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer133.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer133.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer133.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer133.needRenderPos.posX === 0).assertTrue();
    expect(testContainer133.needRenderPos.posY === 0).assertTrue();
    expect(testContainer133.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer133.iconAlpha === 0).assertTrue();
    expect(testContainer133.iconAlpha === 0).assertTrue();
    expect(testContainer133.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer133.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer133.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer133.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer133.intelligentScene === 1).assertTrue();

    expect(testDividerParam133.primary.translateY === 0).assertTrue();
    expect(testDividerParam133.primary.translateX === 0).assertTrue();
    expect(testDividerParam133.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam133.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam133.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam133.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam133.primary.opacity === 1).assertTrue();
    expect(testDividerParam133.primary.blurScale === 0).assertTrue();
    expect(testDividerParam133.secondary.opacity === 1).assertTrue();
    expect(testDividerParam133.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam133.primary.rotateX === 0).assertTrue();
    expect(testDividerParam133.primary.rotateY === 0).assertTrue();
    expect(testDividerParam133.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam133.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam133.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam133.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam133.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam133.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam133.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam133.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam133.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam133.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam133.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam133.primary.posX === '0%').assertTrue();
    expect(testDividerParam133.primary.posY === '0%').assertTrue();
    expect(testDividerParam133.secondary.posX === '0%').assertTrue();
    expect(testDividerParam133.secondary.posY === '0%').assertTrue();
    expect(testDividerParam133.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam133.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_134', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer134: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer134.init();
    let testDividerParam134 = testContainer134.dividerParam;
    testDividerParam134.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer134);

    expect(testContainer134.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer134.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer134.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer134.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer134.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer134.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer134.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer134.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer134.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer134.needRenderPos.posX === 0).assertTrue();
    expect(testContainer134.needRenderPos.posY === 0).assertTrue();
    expect(testContainer134.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer134.iconAlpha === 0).assertTrue();
    expect(testContainer134.iconAlpha === 0).assertTrue();
    expect(testContainer134.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer134.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer134.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer134.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer134.intelligentScene === 1).assertTrue();

    expect(testDividerParam134.primary.translateY === 0).assertTrue();
    expect(testDividerParam134.primary.translateX === 0).assertTrue();
    expect(testDividerParam134.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam134.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam134.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam134.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam134.primary.opacity === 1).assertTrue();
    expect(testDividerParam134.primary.blurScale === 0).assertTrue();
    expect(testDividerParam134.secondary.opacity === 1).assertTrue();
    expect(testDividerParam134.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam134.primary.rotateX === 0).assertTrue();
    expect(testDividerParam134.primary.rotateY === 0).assertTrue();
    expect(testDividerParam134.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam134.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam134.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam134.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam134.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam134.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam134.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam134.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam134.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam134.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam134.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam134.primary.posX === '0%').assertTrue();
    expect(testDividerParam134.primary.posY === '0%').assertTrue();
    expect(testDividerParam134.secondary.posX === '0%').assertTrue();
    expect(testDividerParam134.secondary.posY === '0%').assertTrue();
    expect(testDividerParam134.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam134.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_135', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer135: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer135.init();
    let testDividerParam135 = testContainer135.dividerParam;
    testDividerParam135.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer135);

    expect(testContainer135.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer135.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer135.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer135.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer135.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer135.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer135.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer135.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer135.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer135.needRenderPos.posX === 0).assertTrue();
    expect(testContainer135.needRenderPos.posY === 0).assertTrue();
    expect(testContainer135.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer135.iconAlpha === 0).assertTrue();
    expect(testContainer135.iconAlpha === 0).assertTrue();
    expect(testContainer135.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer135.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer135.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer135.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer135.intelligentScene === 1).assertTrue();

    expect(testDividerParam135.primary.translateY === 0).assertTrue();
    expect(testDividerParam135.primary.translateX === 0).assertTrue();
    expect(testDividerParam135.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam135.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam135.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam135.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam135.primary.opacity === 1).assertTrue();
    expect(testDividerParam135.primary.blurScale === 0).assertTrue();
    expect(testDividerParam135.secondary.opacity === 1).assertTrue();
    expect(testDividerParam135.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam135.primary.rotateX === 0).assertTrue();
    expect(testDividerParam135.primary.rotateY === 0).assertTrue();
    expect(testDividerParam135.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam135.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam135.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam135.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam135.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam135.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam135.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam135.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam135.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam135.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam135.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam135.primary.posX === '0%').assertTrue();
    expect(testDividerParam135.primary.posY === '0%').assertTrue();
    expect(testDividerParam135.secondary.posX === '0%').assertTrue();
    expect(testDividerParam135.secondary.posY === '0%').assertTrue();
    expect(testDividerParam135.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam135.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_136', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer136: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer136.init();
    let testDividerParam136 = testContainer136.dividerParam;
    testDividerParam136.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer136);

    expect(testContainer136.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer136.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer136.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer136.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer136.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer136.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer136.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer136.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer136.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer136.needRenderPos.posX === 0).assertTrue();
    expect(testContainer136.needRenderPos.posY === 0).assertTrue();
    expect(testContainer136.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer136.iconAlpha === 0).assertTrue();
    expect(testContainer136.iconAlpha === 0).assertTrue();
    expect(testContainer136.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer136.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer136.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer136.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer136.intelligentScene === 1).assertTrue();

    expect(testDividerParam136.primary.translateY === 0).assertTrue();
    expect(testDividerParam136.primary.translateX === 0).assertTrue();
    expect(testDividerParam136.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam136.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam136.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam136.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam136.primary.opacity === 1).assertTrue();
    expect(testDividerParam136.primary.blurScale === 0).assertTrue();
    expect(testDividerParam136.secondary.opacity === 1).assertTrue();
    expect(testDividerParam136.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam136.primary.rotateX === 0).assertTrue();
    expect(testDividerParam136.primary.rotateY === 0).assertTrue();
    expect(testDividerParam136.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam136.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam136.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam136.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam136.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam136.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam136.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam136.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam136.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam136.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam136.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam136.primary.posX === '0%').assertTrue();
    expect(testDividerParam136.primary.posY === '0%').assertTrue();
    expect(testDividerParam136.secondary.posX === '0%').assertTrue();
    expect(testDividerParam136.secondary.posY === '0%').assertTrue();
    expect(testDividerParam136.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam136.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_137', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer137: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer137.init();
    let testDividerParam137 = testContainer137.dividerParam;
    testDividerParam137.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer137);

    expect(testContainer137.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer137.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer137.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer137.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer137.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer137.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer137.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer137.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer137.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer137.needRenderPos.posX === 0).assertTrue();
    expect(testContainer137.needRenderPos.posY === 0).assertTrue();
    expect(testContainer137.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer137.iconAlpha === 0).assertTrue();
    expect(testContainer137.iconAlpha === 0).assertTrue();
    expect(testContainer137.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer137.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer137.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer137.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer137.intelligentScene === 1).assertTrue();

    expect(testDividerParam137.primary.translateY === 0).assertTrue();
    expect(testDividerParam137.primary.translateX === 0).assertTrue();
    expect(testDividerParam137.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam137.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam137.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam137.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam137.primary.opacity === 1).assertTrue();
    expect(testDividerParam137.primary.blurScale === 0).assertTrue();
    expect(testDividerParam137.secondary.opacity === 1).assertTrue();
    expect(testDividerParam137.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam137.primary.rotateX === 0).assertTrue();
    expect(testDividerParam137.primary.rotateY === 0).assertTrue();
    expect(testDividerParam137.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam137.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam137.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam137.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam137.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam137.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam137.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam137.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam137.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam137.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam137.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam137.primary.posX === '0%').assertTrue();
    expect(testDividerParam137.primary.posY === '0%').assertTrue();
    expect(testDividerParam137.secondary.posX === '0%').assertTrue();
    expect(testDividerParam137.secondary.posY === '0%').assertTrue();
    expect(testDividerParam137.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam137.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_138', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer138: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer138.init();
    let testDividerParam138 = testContainer138.dividerParam;
    testDividerParam138.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer138);

    expect(testContainer138.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer138.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer138.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer138.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer138.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer138.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer138.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer138.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer138.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer138.needRenderPos.posX === 0).assertTrue();
    expect(testContainer138.needRenderPos.posY === 0).assertTrue();
    expect(testContainer138.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer138.iconAlpha === 0).assertTrue();
    expect(testContainer138.iconAlpha === 0).assertTrue();
    expect(testContainer138.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer138.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer138.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer138.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer138.intelligentScene === 1).assertTrue();

    expect(testDividerParam138.primary.translateY === 0).assertTrue();
    expect(testDividerParam138.primary.translateX === 0).assertTrue();
    expect(testDividerParam138.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam138.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam138.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam138.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam138.primary.opacity === 1).assertTrue();
    expect(testDividerParam138.primary.blurScale === 0).assertTrue();
    expect(testDividerParam138.secondary.opacity === 1).assertTrue();
    expect(testDividerParam138.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam138.primary.rotateX === 0).assertTrue();
    expect(testDividerParam138.primary.rotateY === 0).assertTrue();
    expect(testDividerParam138.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam138.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam138.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam138.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam138.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam138.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam138.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam138.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam138.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam138.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam138.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam138.primary.posX === '0%').assertTrue();
    expect(testDividerParam138.primary.posY === '0%').assertTrue();
    expect(testDividerParam138.secondary.posX === '0%').assertTrue();
    expect(testDividerParam138.secondary.posY === '0%').assertTrue();
    expect(testDividerParam138.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam138.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_139', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer139: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer139.init();
    let testDividerParam139 = testContainer139.dividerParam;
    testDividerParam139.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer139);

    expect(testContainer139.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer139.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer139.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer139.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer139.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer139.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer139.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer139.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer139.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer139.needRenderPos.posX === 0).assertTrue();
    expect(testContainer139.needRenderPos.posY === 0).assertTrue();
    expect(testContainer139.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer139.iconAlpha === 0).assertTrue();
    expect(testContainer139.iconAlpha === 0).assertTrue();
    expect(testContainer139.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer139.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer139.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer139.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer139.intelligentScene === 1).assertTrue();

    expect(testDividerParam139.primary.translateY === 0).assertTrue();
    expect(testDividerParam139.primary.translateX === 0).assertTrue();
    expect(testDividerParam139.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam139.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam139.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam139.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam139.primary.opacity === 1).assertTrue();
    expect(testDividerParam139.primary.blurScale === 0).assertTrue();
    expect(testDividerParam139.secondary.opacity === 1).assertTrue();
    expect(testDividerParam139.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam139.primary.rotateX === 0).assertTrue();
    expect(testDividerParam139.primary.rotateY === 0).assertTrue();
    expect(testDividerParam139.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam139.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam139.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam139.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam139.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam139.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam139.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam139.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam139.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam139.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam139.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam139.primary.posX === '0%').assertTrue();
    expect(testDividerParam139.primary.posY === '0%').assertTrue();
    expect(testDividerParam139.secondary.posX === '0%').assertTrue();
    expect(testDividerParam139.secondary.posY === '0%').assertTrue();
    expect(testDividerParam139.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam139.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_140', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer140: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer140.init();
    let testDividerParam140 = testContainer140.dividerParam;
    testDividerParam140.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer140);

    expect(testContainer140.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer140.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer140.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer140.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer140.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer140.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer140.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer140.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer140.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer140.needRenderPos.posX === 0).assertTrue();
    expect(testContainer140.needRenderPos.posY === 0).assertTrue();
    expect(testContainer140.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer140.iconAlpha === 0).assertTrue();
    expect(testContainer140.iconAlpha === 0).assertTrue();
    expect(testContainer140.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer140.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer140.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer140.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer140.intelligentScene === 1).assertTrue();

    expect(testDividerParam140.primary.translateY === 0).assertTrue();
    expect(testDividerParam140.primary.translateX === 0).assertTrue();
    expect(testDividerParam140.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam140.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam140.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam140.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam140.primary.opacity === 1).assertTrue();
    expect(testDividerParam140.primary.blurScale === 0).assertTrue();
    expect(testDividerParam140.secondary.opacity === 1).assertTrue();
    expect(testDividerParam140.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam140.primary.rotateX === 0).assertTrue();
    expect(testDividerParam140.primary.rotateY === 0).assertTrue();
    expect(testDividerParam140.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam140.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam140.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam140.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam140.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam140.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam140.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam140.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam140.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam140.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam140.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam140.primary.posX === '0%').assertTrue();
    expect(testDividerParam140.primary.posY === '0%').assertTrue();
    expect(testDividerParam140.secondary.posX === '0%').assertTrue();
    expect(testDividerParam140.secondary.posY === '0%').assertTrue();
    expect(testDividerParam140.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam140.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_141', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer141: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer141.init();
    let testDividerParam141 = testContainer141.dividerParam;
    testDividerParam141.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer141);

    expect(testContainer141.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer141.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer141.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer141.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer141.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer141.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer141.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer141.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer141.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer141.needRenderPos.posX === 0).assertTrue();
    expect(testContainer141.needRenderPos.posY === 0).assertTrue();
    expect(testContainer141.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer141.iconAlpha === 0).assertTrue();
    expect(testContainer141.iconAlpha === 0).assertTrue();
    expect(testContainer141.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer141.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer141.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer141.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer141.intelligentScene === 1).assertTrue();

    expect(testDividerParam141.primary.translateY === 0).assertTrue();
    expect(testDividerParam141.primary.translateX === 0).assertTrue();
    expect(testDividerParam141.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam141.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam141.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam141.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam141.primary.opacity === 1).assertTrue();
    expect(testDividerParam141.primary.blurScale === 0).assertTrue();
    expect(testDividerParam141.secondary.opacity === 1).assertTrue();
    expect(testDividerParam141.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam141.primary.rotateX === 0).assertTrue();
    expect(testDividerParam141.primary.rotateY === 0).assertTrue();
    expect(testDividerParam141.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam141.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam141.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam141.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam141.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam141.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam141.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam141.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam141.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam141.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam141.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam141.primary.posX === '0%').assertTrue();
    expect(testDividerParam141.primary.posY === '0%').assertTrue();
    expect(testDividerParam141.secondary.posX === '0%').assertTrue();
    expect(testDividerParam141.secondary.posY === '0%').assertTrue();
    expect(testDividerParam141.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam141.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_142', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer142: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer142.init();
    let testDividerParam142 = testContainer142.dividerParam;
    testDividerParam142.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer142);

    expect(testContainer142.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer142.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer142.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer142.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer142.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer142.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer142.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer142.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer142.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer142.needRenderPos.posX === 0).assertTrue();
    expect(testContainer142.needRenderPos.posY === 0).assertTrue();
    expect(testContainer142.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer142.iconAlpha === 0).assertTrue();
    expect(testContainer142.iconAlpha === 0).assertTrue();
    expect(testContainer142.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer142.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer142.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer142.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer142.intelligentScene === 1).assertTrue();

    expect(testDividerParam142.primary.translateY === 0).assertTrue();
    expect(testDividerParam142.primary.translateX === 0).assertTrue();
    expect(testDividerParam142.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam142.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam142.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam142.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam142.primary.opacity === 1).assertTrue();
    expect(testDividerParam142.primary.blurScale === 0).assertTrue();
    expect(testDividerParam142.secondary.opacity === 1).assertTrue();
    expect(testDividerParam142.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam142.primary.rotateX === 0).assertTrue();
    expect(testDividerParam142.primary.rotateY === 0).assertTrue();
    expect(testDividerParam142.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam142.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam142.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam142.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam142.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam142.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam142.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam142.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam142.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam142.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam142.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam142.primary.posX === '0%').assertTrue();
    expect(testDividerParam142.primary.posY === '0%').assertTrue();
    expect(testDividerParam142.secondary.posX === '0%').assertTrue();
    expect(testDividerParam142.secondary.posY === '0%').assertTrue();
    expect(testDividerParam142.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam142.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_143', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer143: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer143.init();
    let testDividerParam143 = testContainer143.dividerParam;
    testDividerParam143.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer143);

    expect(testContainer143.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer143.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer143.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer143.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer143.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer143.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer143.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer143.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer143.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer143.needRenderPos.posX === 0).assertTrue();
    expect(testContainer143.needRenderPos.posY === 0).assertTrue();
    expect(testContainer143.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer143.iconAlpha === 0).assertTrue();
    expect(testContainer143.iconAlpha === 0).assertTrue();
    expect(testContainer143.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer143.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer143.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer143.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer143.intelligentScene === 1).assertTrue();

    expect(testDividerParam143.primary.translateY === 0).assertTrue();
    expect(testDividerParam143.primary.translateX === 0).assertTrue();
    expect(testDividerParam143.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam143.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam143.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam143.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam143.primary.opacity === 1).assertTrue();
    expect(testDividerParam143.primary.blurScale === 0).assertTrue();
    expect(testDividerParam143.secondary.opacity === 1).assertTrue();
    expect(testDividerParam143.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam143.primary.rotateX === 0).assertTrue();
    expect(testDividerParam143.primary.rotateY === 0).assertTrue();
    expect(testDividerParam143.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam143.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam143.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam143.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam143.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam143.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam143.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam143.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam143.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam143.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam143.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam143.primary.posX === '0%').assertTrue();
    expect(testDividerParam143.primary.posY === '0%').assertTrue();
    expect(testDividerParam143.secondary.posX === '0%').assertTrue();
    expect(testDividerParam143.secondary.posY === '0%').assertTrue();
    expect(testDividerParam143.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam143.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_144', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer144: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer144.init();
    let testDividerParam144 = testContainer144.dividerParam;
    testDividerParam144.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer144);

    expect(testContainer144.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer144.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer144.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer144.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer144.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer144.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer144.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer144.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer144.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer144.needRenderPos.posX === 0).assertTrue();
    expect(testContainer144.needRenderPos.posY === 0).assertTrue();
    expect(testContainer144.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer144.iconAlpha === 0).assertTrue();
    expect(testContainer144.iconAlpha === 0).assertTrue();
    expect(testContainer144.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer144.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer144.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer144.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer144.intelligentScene === 1).assertTrue();

    expect(testDividerParam144.primary.translateY === 0).assertTrue();
    expect(testDividerParam144.primary.translateX === 0).assertTrue();
    expect(testDividerParam144.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam144.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam144.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam144.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam144.primary.opacity === 1).assertTrue();
    expect(testDividerParam144.primary.blurScale === 0).assertTrue();
    expect(testDividerParam144.secondary.opacity === 1).assertTrue();
    expect(testDividerParam144.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam144.primary.rotateX === 0).assertTrue();
    expect(testDividerParam144.primary.rotateY === 0).assertTrue();
    expect(testDividerParam144.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam144.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam144.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam144.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam144.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam144.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam144.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam144.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam144.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam144.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam144.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam144.primary.posX === '0%').assertTrue();
    expect(testDividerParam144.primary.posY === '0%').assertTrue();
    expect(testDividerParam144.secondary.posX === '0%').assertTrue();
    expect(testDividerParam144.secondary.posY === '0%').assertTrue();
    expect(testDividerParam144.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam144.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_145', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer145: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer145.init();
    let testDividerParam145 = testContainer145.dividerParam;
    testDividerParam145.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer145);

    expect(testContainer145.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer145.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer145.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer145.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer145.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer145.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer145.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer145.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer145.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer145.needRenderPos.posX === 0).assertTrue();
    expect(testContainer145.needRenderPos.posY === 0).assertTrue();
    expect(testContainer145.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer145.iconAlpha === 0).assertTrue();
    expect(testContainer145.iconAlpha === 0).assertTrue();
    expect(testContainer145.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer145.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer145.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer145.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer145.intelligentScene === 1).assertTrue();

    expect(testDividerParam145.primary.translateY === 0).assertTrue();
    expect(testDividerParam145.primary.translateX === 0).assertTrue();
    expect(testDividerParam145.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam145.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam145.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam145.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam145.primary.opacity === 1).assertTrue();
    expect(testDividerParam145.primary.blurScale === 0).assertTrue();
    expect(testDividerParam145.secondary.opacity === 1).assertTrue();
    expect(testDividerParam145.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam145.primary.rotateX === 0).assertTrue();
    expect(testDividerParam145.primary.rotateY === 0).assertTrue();
    expect(testDividerParam145.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam145.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam145.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam145.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam145.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam145.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam145.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam145.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam145.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam145.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam145.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam145.primary.posX === '0%').assertTrue();
    expect(testDividerParam145.primary.posY === '0%').assertTrue();
    expect(testDividerParam145.secondary.posX === '0%').assertTrue();
    expect(testDividerParam145.secondary.posY === '0%').assertTrue();
    expect(testDividerParam145.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam145.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_146', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer146: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer146.init();
    let testDividerParam146 = testContainer146.dividerParam;
    testDividerParam146.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer146);

    expect(testContainer146.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer146.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer146.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer146.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer146.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer146.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer146.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer146.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer146.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer146.needRenderPos.posX === 0).assertTrue();
    expect(testContainer146.needRenderPos.posY === 0).assertTrue();
    expect(testContainer146.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer146.iconAlpha === 0).assertTrue();
    expect(testContainer146.iconAlpha === 0).assertTrue();
    expect(testContainer146.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer146.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer146.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer146.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer146.intelligentScene === 1).assertTrue();

    expect(testDividerParam146.primary.translateY === 0).assertTrue();
    expect(testDividerParam146.primary.translateX === 0).assertTrue();
    expect(testDividerParam146.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam146.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam146.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam146.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam146.primary.opacity === 1).assertTrue();
    expect(testDividerParam146.primary.blurScale === 0).assertTrue();
    expect(testDividerParam146.secondary.opacity === 1).assertTrue();
    expect(testDividerParam146.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam146.primary.rotateX === 0).assertTrue();
    expect(testDividerParam146.primary.rotateY === 0).assertTrue();
    expect(testDividerParam146.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam146.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam146.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam146.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam146.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam146.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam146.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam146.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam146.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam146.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam146.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam146.primary.posX === '0%').assertTrue();
    expect(testDividerParam146.primary.posY === '0%').assertTrue();
    expect(testDividerParam146.secondary.posX === '0%').assertTrue();
    expect(testDividerParam146.secondary.posY === '0%').assertTrue();
    expect(testDividerParam146.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam146.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_147', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer147: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer147.init();
    let testDividerParam147 = testContainer147.dividerParam;
    testDividerParam147.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer147);

    expect(testContainer147.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer147.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer147.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer147.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer147.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer147.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer147.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer147.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer147.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer147.needRenderPos.posX === 0).assertTrue();
    expect(testContainer147.needRenderPos.posY === 0).assertTrue();
    expect(testContainer147.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer147.iconAlpha === 0).assertTrue();
    expect(testContainer147.iconAlpha === 0).assertTrue();
    expect(testContainer147.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer147.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer147.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer147.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer147.intelligentScene === 1).assertTrue();

    expect(testDividerParam147.primary.translateY === 0).assertTrue();
    expect(testDividerParam147.primary.translateX === 0).assertTrue();
    expect(testDividerParam147.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam147.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam147.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam147.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam147.primary.opacity === 1).assertTrue();
    expect(testDividerParam147.primary.blurScale === 0).assertTrue();
    expect(testDividerParam147.secondary.opacity === 1).assertTrue();
    expect(testDividerParam147.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam147.primary.rotateX === 0).assertTrue();
    expect(testDividerParam147.primary.rotateY === 0).assertTrue();
    expect(testDividerParam147.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam147.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam147.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam147.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam147.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam147.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam147.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam147.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam147.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam147.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam147.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam147.primary.posX === '0%').assertTrue();
    expect(testDividerParam147.primary.posY === '0%').assertTrue();
    expect(testDividerParam147.secondary.posX === '0%').assertTrue();
    expect(testDividerParam147.secondary.posY === '0%').assertTrue();
    expect(testDividerParam147.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam147.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_148', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer148: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer148.init();
    let testDividerParam148 = testContainer148.dividerParam;
    testDividerParam148.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer148);

    expect(testContainer148.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer148.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer148.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer148.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer148.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer148.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer148.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer148.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer148.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer148.needRenderPos.posX === 0).assertTrue();
    expect(testContainer148.needRenderPos.posY === 0).assertTrue();
    expect(testContainer148.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer148.iconAlpha === 0).assertTrue();
    expect(testContainer148.iconAlpha === 0).assertTrue();
    expect(testContainer148.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer148.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer148.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer148.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer148.intelligentScene === 1).assertTrue();

    expect(testDividerParam148.primary.translateY === 0).assertTrue();
    expect(testDividerParam148.primary.translateX === 0).assertTrue();
    expect(testDividerParam148.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam148.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam148.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam148.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam148.primary.opacity === 1).assertTrue();
    expect(testDividerParam148.primary.blurScale === 0).assertTrue();
    expect(testDividerParam148.secondary.opacity === 1).assertTrue();
    expect(testDividerParam148.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam148.primary.rotateX === 0).assertTrue();
    expect(testDividerParam148.primary.rotateY === 0).assertTrue();
    expect(testDividerParam148.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam148.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam148.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam148.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam148.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam148.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam148.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam148.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam148.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam148.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam148.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam148.primary.posX === '0%').assertTrue();
    expect(testDividerParam148.primary.posY === '0%').assertTrue();
    expect(testDividerParam148.secondary.posX === '0%').assertTrue();
    expect(testDividerParam148.secondary.posY === '0%').assertTrue();
    expect(testDividerParam148.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam148.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_149', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer149: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer149.init();
    let testDividerParam149 = testContainer149.dividerParam;
    testDividerParam149.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer149);

    expect(testContainer149.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer149.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer149.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer149.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer149.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer149.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer149.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer149.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer149.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer149.needRenderPos.posX === 0).assertTrue();
    expect(testContainer149.needRenderPos.posY === 0).assertTrue();
    expect(testContainer149.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer149.iconAlpha === 0).assertTrue();
    expect(testContainer149.iconAlpha === 0).assertTrue();
    expect(testContainer149.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer149.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer149.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer149.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer149.intelligentScene === 1).assertTrue();

    expect(testDividerParam149.primary.translateY === 0).assertTrue();
    expect(testDividerParam149.primary.translateX === 0).assertTrue();
    expect(testDividerParam149.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam149.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam149.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam149.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam149.primary.opacity === 1).assertTrue();
    expect(testDividerParam149.primary.blurScale === 0).assertTrue();
    expect(testDividerParam149.secondary.opacity === 1).assertTrue();
    expect(testDividerParam149.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam149.primary.rotateX === 0).assertTrue();
    expect(testDividerParam149.primary.rotateY === 0).assertTrue();
    expect(testDividerParam149.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam149.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam149.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam149.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam149.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam149.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam149.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam149.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam149.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam149.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam149.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam149.primary.posX === '0%').assertTrue();
    expect(testDividerParam149.primary.posY === '0%').assertTrue();
    expect(testDividerParam149.secondary.posX === '0%').assertTrue();
    expect(testDividerParam149.secondary.posY === '0%').assertTrue();
    expect(testDividerParam149.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam149.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_150', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer150: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer150.init();
    let testDividerParam150 = testContainer150.dividerParam;
    testDividerParam150.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer150);

    expect(testContainer150.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer150.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer150.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer150.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer150.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer150.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer150.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer150.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer150.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer150.needRenderPos.posX === 0).assertTrue();
    expect(testContainer150.needRenderPos.posY === 0).assertTrue();
    expect(testContainer150.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer150.iconAlpha === 0).assertTrue();
    expect(testContainer150.iconAlpha === 0).assertTrue();
    expect(testContainer150.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer150.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer150.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer150.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer150.intelligentScene === 1).assertTrue();

    expect(testDividerParam150.primary.translateY === 0).assertTrue();
    expect(testDividerParam150.primary.translateX === 0).assertTrue();
    expect(testDividerParam150.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam150.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam150.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam150.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam150.primary.opacity === 1).assertTrue();
    expect(testDividerParam150.primary.blurScale === 0).assertTrue();
    expect(testDividerParam150.secondary.opacity === 1).assertTrue();
    expect(testDividerParam150.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam150.primary.rotateX === 0).assertTrue();
    expect(testDividerParam150.primary.rotateY === 0).assertTrue();
    expect(testDividerParam150.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam150.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam150.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam150.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam150.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam150.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam150.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam150.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam150.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam150.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam150.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam150.primary.posX === '0%').assertTrue();
    expect(testDividerParam150.primary.posY === '0%').assertTrue();
    expect(testDividerParam150.secondary.posX === '0%').assertTrue();
    expect(testDividerParam150.secondary.posY === '0%').assertTrue();
    expect(testDividerParam150.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam150.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_151', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer151: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer151.init();
    let testDividerParam151 = testContainer151.dividerParam;
    testDividerParam151.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer151);

    expect(testContainer151.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer151.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer151.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer151.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer151.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer151.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer151.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer151.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer151.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer151.needRenderPos.posX === 0).assertTrue();
    expect(testContainer151.needRenderPos.posY === 0).assertTrue();
    expect(testContainer151.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer151.iconAlpha === 0).assertTrue();
    expect(testContainer151.iconAlpha === 0).assertTrue();
    expect(testContainer151.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer151.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer151.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer151.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer151.intelligentScene === 1).assertTrue();

    expect(testDividerParam151.primary.translateY === 0).assertTrue();
    expect(testDividerParam151.primary.translateX === 0).assertTrue();
    expect(testDividerParam151.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam151.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam151.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam151.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam151.primary.opacity === 1).assertTrue();
    expect(testDividerParam151.primary.blurScale === 0).assertTrue();
    expect(testDividerParam151.secondary.opacity === 1).assertTrue();
    expect(testDividerParam151.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam151.primary.rotateX === 0).assertTrue();
    expect(testDividerParam151.primary.rotateY === 0).assertTrue();
    expect(testDividerParam151.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam151.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam151.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam151.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam151.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam151.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam151.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam151.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam151.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam151.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam151.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam151.primary.posX === '0%').assertTrue();
    expect(testDividerParam151.primary.posY === '0%').assertTrue();
    expect(testDividerParam151.secondary.posX === '0%').assertTrue();
    expect(testDividerParam151.secondary.posY === '0%').assertTrue();
    expect(testDividerParam151.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam151.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_152', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer152: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer152.init();
    let testDividerParam152 = testContainer152.dividerParam;
    testDividerParam152.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer152);

    expect(testContainer152.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer152.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer152.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer152.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer152.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer152.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer152.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer152.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer152.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer152.needRenderPos.posX === 0).assertTrue();
    expect(testContainer152.needRenderPos.posY === 0).assertTrue();
    expect(testContainer152.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer152.iconAlpha === 0).assertTrue();
    expect(testContainer152.iconAlpha === 0).assertTrue();
    expect(testContainer152.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer152.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer152.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer152.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer152.intelligentScene === 1).assertTrue();

    expect(testDividerParam152.primary.translateY === 0).assertTrue();
    expect(testDividerParam152.primary.translateX === 0).assertTrue();
    expect(testDividerParam152.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam152.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam152.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam152.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam152.primary.opacity === 1).assertTrue();
    expect(testDividerParam152.primary.blurScale === 0).assertTrue();
    expect(testDividerParam152.secondary.opacity === 1).assertTrue();
    expect(testDividerParam152.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam152.primary.rotateX === 0).assertTrue();
    expect(testDividerParam152.primary.rotateY === 0).assertTrue();
    expect(testDividerParam152.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam152.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam152.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam152.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam152.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam152.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam152.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam152.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam152.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam152.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam152.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam152.primary.posX === '0%').assertTrue();
    expect(testDividerParam152.primary.posY === '0%').assertTrue();
    expect(testDividerParam152.secondary.posX === '0%').assertTrue();
    expect(testDividerParam152.secondary.posY === '0%').assertTrue();
    expect(testDividerParam152.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam152.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_153', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer153: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer153.init();
    let testDividerParam153 = testContainer153.dividerParam;
    testDividerParam153.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer153);

    expect(testContainer153.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer153.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer153.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer153.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer153.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer153.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer153.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer153.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer153.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer153.needRenderPos.posX === 0).assertTrue();
    expect(testContainer153.needRenderPos.posY === 0).assertTrue();
    expect(testContainer153.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer153.iconAlpha === 0).assertTrue();
    expect(testContainer153.iconAlpha === 0).assertTrue();
    expect(testContainer153.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer153.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer153.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer153.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer153.intelligentScene === 1).assertTrue();

    expect(testDividerParam153.primary.translateY === 0).assertTrue();
    expect(testDividerParam153.primary.translateX === 0).assertTrue();
    expect(testDividerParam153.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam153.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam153.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam153.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam153.primary.opacity === 1).assertTrue();
    expect(testDividerParam153.primary.blurScale === 0).assertTrue();
    expect(testDividerParam153.secondary.opacity === 1).assertTrue();
    expect(testDividerParam153.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam153.primary.rotateX === 0).assertTrue();
    expect(testDividerParam153.primary.rotateY === 0).assertTrue();
    expect(testDividerParam153.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam153.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam153.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam153.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam153.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam153.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam153.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam153.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam153.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam153.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam153.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam153.primary.posX === '0%').assertTrue();
    expect(testDividerParam153.primary.posY === '0%').assertTrue();
    expect(testDividerParam153.secondary.posX === '0%').assertTrue();
    expect(testDividerParam153.secondary.posY === '0%').assertTrue();
    expect(testDividerParam153.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam153.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_154', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer154: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer154.init();
    let testDividerParam154 = testContainer154.dividerParam;
    testDividerParam154.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer154);

    expect(testContainer154.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer154.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer154.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer154.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer154.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer154.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer154.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer154.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer154.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer154.needRenderPos.posX === 0).assertTrue();
    expect(testContainer154.needRenderPos.posY === 0).assertTrue();
    expect(testContainer154.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer154.iconAlpha === 0).assertTrue();
    expect(testContainer154.iconAlpha === 0).assertTrue();
    expect(testContainer154.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer154.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer154.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer154.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer154.intelligentScene === 1).assertTrue();

    expect(testDividerParam154.primary.translateY === 0).assertTrue();
    expect(testDividerParam154.primary.translateX === 0).assertTrue();
    expect(testDividerParam154.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam154.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam154.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam154.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam154.primary.opacity === 1).assertTrue();
    expect(testDividerParam154.primary.blurScale === 0).assertTrue();
    expect(testDividerParam154.secondary.opacity === 1).assertTrue();
    expect(testDividerParam154.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam154.primary.rotateX === 0).assertTrue();
    expect(testDividerParam154.primary.rotateY === 0).assertTrue();
    expect(testDividerParam154.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam154.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam154.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam154.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam154.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam154.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam154.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam154.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam154.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam154.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam154.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam154.primary.posX === '0%').assertTrue();
    expect(testDividerParam154.primary.posY === '0%').assertTrue();
    expect(testDividerParam154.secondary.posX === '0%').assertTrue();
    expect(testDividerParam154.secondary.posY === '0%').assertTrue();
    expect(testDividerParam154.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam154.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_155', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer155: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer155.init();
    let testDividerParam155 = testContainer155.dividerParam;
    testDividerParam155.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer155);

    expect(testContainer155.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer155.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer155.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer155.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer155.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer155.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer155.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer155.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer155.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer155.needRenderPos.posX === 0).assertTrue();
    expect(testContainer155.needRenderPos.posY === 0).assertTrue();
    expect(testContainer155.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer155.iconAlpha === 0).assertTrue();
    expect(testContainer155.iconAlpha === 0).assertTrue();
    expect(testContainer155.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer155.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer155.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer155.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer155.intelligentScene === 1).assertTrue();

    expect(testDividerParam155.primary.translateY === 0).assertTrue();
    expect(testDividerParam155.primary.translateX === 0).assertTrue();
    expect(testDividerParam155.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam155.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam155.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam155.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam155.primary.opacity === 1).assertTrue();
    expect(testDividerParam155.primary.blurScale === 0).assertTrue();
    expect(testDividerParam155.secondary.opacity === 1).assertTrue();
    expect(testDividerParam155.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam155.primary.rotateX === 0).assertTrue();
    expect(testDividerParam155.primary.rotateY === 0).assertTrue();
    expect(testDividerParam155.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam155.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam155.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam155.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam155.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam155.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam155.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam155.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam155.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam155.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam155.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam155.primary.posX === '0%').assertTrue();
    expect(testDividerParam155.primary.posY === '0%').assertTrue();
    expect(testDividerParam155.secondary.posX === '0%').assertTrue();
    expect(testDividerParam155.secondary.posY === '0%').assertTrue();
    expect(testDividerParam155.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam155.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_156', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer156: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer156.init();
    let testDividerParam156 = testContainer156.dividerParam;
    testDividerParam156.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer156);

    expect(testContainer156.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer156.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer156.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer156.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer156.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer156.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer156.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer156.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer156.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer156.needRenderPos.posX === 0).assertTrue();
    expect(testContainer156.needRenderPos.posY === 0).assertTrue();
    expect(testContainer156.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer156.iconAlpha === 0).assertTrue();
    expect(testContainer156.iconAlpha === 0).assertTrue();
    expect(testContainer156.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer156.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer156.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer156.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer156.intelligentScene === 1).assertTrue();

    expect(testDividerParam156.primary.translateY === 0).assertTrue();
    expect(testDividerParam156.primary.translateX === 0).assertTrue();
    expect(testDividerParam156.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam156.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam156.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam156.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam156.primary.opacity === 1).assertTrue();
    expect(testDividerParam156.primary.blurScale === 0).assertTrue();
    expect(testDividerParam156.secondary.opacity === 1).assertTrue();
    expect(testDividerParam156.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam156.primary.rotateX === 0).assertTrue();
    expect(testDividerParam156.primary.rotateY === 0).assertTrue();
    expect(testDividerParam156.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam156.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam156.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam156.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam156.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam156.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam156.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam156.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam156.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam156.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam156.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam156.primary.posX === '0%').assertTrue();
    expect(testDividerParam156.primary.posY === '0%').assertTrue();
    expect(testDividerParam156.secondary.posX === '0%').assertTrue();
    expect(testDividerParam156.secondary.posY === '0%').assertTrue();
    expect(testDividerParam156.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam156.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_157', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer157: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer157.init();
    let testDividerParam157 = testContainer157.dividerParam;
    testDividerParam157.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer157);

    expect(testContainer157.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer157.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer157.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer157.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer157.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer157.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer157.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer157.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer157.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer157.needRenderPos.posX === 0).assertTrue();
    expect(testContainer157.needRenderPos.posY === 0).assertTrue();
    expect(testContainer157.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer157.iconAlpha === 0).assertTrue();
    expect(testContainer157.iconAlpha === 0).assertTrue();
    expect(testContainer157.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer157.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer157.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer157.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer157.intelligentScene === 1).assertTrue();

    expect(testDividerParam157.primary.translateY === 0).assertTrue();
    expect(testDividerParam157.primary.translateX === 0).assertTrue();
    expect(testDividerParam157.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam157.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam157.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam157.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam157.primary.opacity === 1).assertTrue();
    expect(testDividerParam157.primary.blurScale === 0).assertTrue();
    expect(testDividerParam157.secondary.opacity === 1).assertTrue();
    expect(testDividerParam157.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam157.primary.rotateX === 0).assertTrue();
    expect(testDividerParam157.primary.rotateY === 0).assertTrue();
    expect(testDividerParam157.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam157.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam157.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam157.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam157.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam157.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam157.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam157.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam157.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam157.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam157.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam157.primary.posX === '0%').assertTrue();
    expect(testDividerParam157.primary.posY === '0%').assertTrue();
    expect(testDividerParam157.secondary.posX === '0%').assertTrue();
    expect(testDividerParam157.secondary.posY === '0%').assertTrue();
    expect(testDividerParam157.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam157.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_158', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer158: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer158.init();
    let testDividerParam158 = testContainer158.dividerParam;
    testDividerParam158.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer158);

    expect(testContainer158.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer158.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer158.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer158.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer158.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer158.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer158.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer158.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer158.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer158.needRenderPos.posX === 0).assertTrue();
    expect(testContainer158.needRenderPos.posY === 0).assertTrue();
    expect(testContainer158.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer158.iconAlpha === 0).assertTrue();
    expect(testContainer158.iconAlpha === 0).assertTrue();
    expect(testContainer158.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer158.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer158.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer158.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer158.intelligentScene === 1).assertTrue();

    expect(testDividerParam158.primary.translateY === 0).assertTrue();
    expect(testDividerParam158.primary.translateX === 0).assertTrue();
    expect(testDividerParam158.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam158.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam158.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam158.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam158.primary.opacity === 1).assertTrue();
    expect(testDividerParam158.primary.blurScale === 0).assertTrue();
    expect(testDividerParam158.secondary.opacity === 1).assertTrue();
    expect(testDividerParam158.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam158.primary.rotateX === 0).assertTrue();
    expect(testDividerParam158.primary.rotateY === 0).assertTrue();
    expect(testDividerParam158.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam158.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam158.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam158.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam158.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam158.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam158.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam158.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam158.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam158.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam158.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam158.primary.posX === '0%').assertTrue();
    expect(testDividerParam158.primary.posY === '0%').assertTrue();
    expect(testDividerParam158.secondary.posX === '0%').assertTrue();
    expect(testDividerParam158.secondary.posY === '0%').assertTrue();
    expect(testDividerParam158.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam158.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_159', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer159: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer159.init();
    let testDividerParam159 = testContainer159.dividerParam;
    testDividerParam159.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer159);

    expect(testContainer159.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer159.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer159.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer159.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer159.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer159.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer159.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer159.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer159.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer159.needRenderPos.posX === 0).assertTrue();
    expect(testContainer159.needRenderPos.posY === 0).assertTrue();
    expect(testContainer159.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer159.iconAlpha === 0).assertTrue();
    expect(testContainer159.iconAlpha === 0).assertTrue();
    expect(testContainer159.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer159.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer159.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer159.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer159.intelligentScene === 1).assertTrue();

    expect(testDividerParam159.primary.translateY === 0).assertTrue();
    expect(testDividerParam159.primary.translateX === 0).assertTrue();
    expect(testDividerParam159.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam159.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam159.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam159.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam159.primary.opacity === 1).assertTrue();
    expect(testDividerParam159.primary.blurScale === 0).assertTrue();
    expect(testDividerParam159.secondary.opacity === 1).assertTrue();
    expect(testDividerParam159.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam159.primary.rotateX === 0).assertTrue();
    expect(testDividerParam159.primary.rotateY === 0).assertTrue();
    expect(testDividerParam159.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam159.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam159.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam159.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam159.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam159.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam159.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam159.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam159.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam159.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam159.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam159.primary.posX === '0%').assertTrue();
    expect(testDividerParam159.primary.posY === '0%').assertTrue();
    expect(testDividerParam159.secondary.posX === '0%').assertTrue();
    expect(testDividerParam159.secondary.posY === '0%').assertTrue();
    expect(testDividerParam159.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam159.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_160', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer160: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer160.init();
    let testDividerParam160 = testContainer160.dividerParam;
    testDividerParam160.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer160);

    expect(testContainer160.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer160.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer160.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer160.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer160.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer160.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer160.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer160.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer160.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer160.needRenderPos.posX === 0).assertTrue();
    expect(testContainer160.needRenderPos.posY === 0).assertTrue();
    expect(testContainer160.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer160.iconAlpha === 0).assertTrue();
    expect(testContainer160.iconAlpha === 0).assertTrue();
    expect(testContainer160.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer160.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer160.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer160.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer160.intelligentScene === 1).assertTrue();

    expect(testDividerParam160.primary.translateY === 0).assertTrue();
    expect(testDividerParam160.primary.translateX === 0).assertTrue();
    expect(testDividerParam160.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam160.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam160.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam160.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam160.primary.opacity === 1).assertTrue();
    expect(testDividerParam160.primary.blurScale === 0).assertTrue();
    expect(testDividerParam160.secondary.opacity === 1).assertTrue();
    expect(testDividerParam160.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam160.primary.rotateX === 0).assertTrue();
    expect(testDividerParam160.primary.rotateY === 0).assertTrue();
    expect(testDividerParam160.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam160.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam160.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam160.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam160.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam160.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam160.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam160.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam160.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam160.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam160.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam160.primary.posX === '0%').assertTrue();
    expect(testDividerParam160.primary.posY === '0%').assertTrue();
    expect(testDividerParam160.secondary.posX === '0%').assertTrue();
    expect(testDividerParam160.secondary.posY === '0%').assertTrue();
    expect(testDividerParam160.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam160.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_161', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer161: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer161.init();
    let testDividerParam161 = testContainer161.dividerParam;
    testDividerParam161.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer161);

    expect(testContainer161.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer161.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer161.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer161.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer161.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer161.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer161.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer161.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer161.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer161.needRenderPos.posX === 0).assertTrue();
    expect(testContainer161.needRenderPos.posY === 0).assertTrue();
    expect(testContainer161.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer161.iconAlpha === 0).assertTrue();
    expect(testContainer161.iconAlpha === 0).assertTrue();
    expect(testContainer161.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer161.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer161.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer161.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer161.intelligentScene === 1).assertTrue();

    expect(testDividerParam161.primary.translateY === 0).assertTrue();
    expect(testDividerParam161.primary.translateX === 0).assertTrue();
    expect(testDividerParam161.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam161.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam161.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam161.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam161.primary.opacity === 1).assertTrue();
    expect(testDividerParam161.primary.blurScale === 0).assertTrue();
    expect(testDividerParam161.secondary.opacity === 1).assertTrue();
    expect(testDividerParam161.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam161.primary.rotateX === 0).assertTrue();
    expect(testDividerParam161.primary.rotateY === 0).assertTrue();
    expect(testDividerParam161.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam161.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam161.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam161.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam161.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam161.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam161.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam161.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam161.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam161.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam161.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam161.primary.posX === '0%').assertTrue();
    expect(testDividerParam161.primary.posY === '0%').assertTrue();
    expect(testDividerParam161.secondary.posX === '0%').assertTrue();
    expect(testDividerParam161.secondary.posY === '0%').assertTrue();
    expect(testDividerParam161.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam161.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_162', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer162: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer162.init();
    let testDividerParam162 = testContainer162.dividerParam;
    testDividerParam162.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer162);

    expect(testContainer162.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer162.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer162.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer162.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer162.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer162.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer162.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer162.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer162.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer162.needRenderPos.posX === 0).assertTrue();
    expect(testContainer162.needRenderPos.posY === 0).assertTrue();
    expect(testContainer162.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer162.iconAlpha === 0).assertTrue();
    expect(testContainer162.iconAlpha === 0).assertTrue();
    expect(testContainer162.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer162.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer162.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer162.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer162.intelligentScene === 1).assertTrue();

    expect(testDividerParam162.primary.translateY === 0).assertTrue();
    expect(testDividerParam162.primary.translateX === 0).assertTrue();
    expect(testDividerParam162.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam162.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam162.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam162.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam162.primary.opacity === 1).assertTrue();
    expect(testDividerParam162.primary.blurScale === 0).assertTrue();
    expect(testDividerParam162.secondary.opacity === 1).assertTrue();
    expect(testDividerParam162.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam162.primary.rotateX === 0).assertTrue();
    expect(testDividerParam162.primary.rotateY === 0).assertTrue();
    expect(testDividerParam162.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam162.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam162.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam162.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam162.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam162.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam162.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam162.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam162.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam162.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam162.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam162.primary.posX === '0%').assertTrue();
    expect(testDividerParam162.primary.posY === '0%').assertTrue();
    expect(testDividerParam162.secondary.posX === '0%').assertTrue();
    expect(testDividerParam162.secondary.posY === '0%').assertTrue();
    expect(testDividerParam162.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam162.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_163', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer163: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer163.init();
    let testDividerParam163 = testContainer163.dividerParam;
    testDividerParam163.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer163);

    expect(testContainer163.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer163.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer163.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer163.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer163.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer163.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer163.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer163.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer163.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer163.needRenderPos.posX === 0).assertTrue();
    expect(testContainer163.needRenderPos.posY === 0).assertTrue();
    expect(testContainer163.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer163.iconAlpha === 0).assertTrue();
    expect(testContainer163.iconAlpha === 0).assertTrue();
    expect(testContainer163.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer163.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer163.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer163.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer163.intelligentScene === 1).assertTrue();

    expect(testDividerParam163.primary.translateY === 0).assertTrue();
    expect(testDividerParam163.primary.translateX === 0).assertTrue();
    expect(testDividerParam163.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam163.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam163.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam163.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam163.primary.opacity === 1).assertTrue();
    expect(testDividerParam163.primary.blurScale === 0).assertTrue();
    expect(testDividerParam163.secondary.opacity === 1).assertTrue();
    expect(testDividerParam163.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam163.primary.rotateX === 0).assertTrue();
    expect(testDividerParam163.primary.rotateY === 0).assertTrue();
    expect(testDividerParam163.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam163.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam163.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam163.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam163.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam163.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam163.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam163.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam163.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam163.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam163.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam163.primary.posX === '0%').assertTrue();
    expect(testDividerParam163.primary.posY === '0%').assertTrue();
    expect(testDividerParam163.secondary.posX === '0%').assertTrue();
    expect(testDividerParam163.secondary.posY === '0%').assertTrue();
    expect(testDividerParam163.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam163.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_164', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer164: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer164.init();
    let testDividerParam164 = testContainer164.dividerParam;
    testDividerParam164.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer164);

    expect(testContainer164.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer164.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer164.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer164.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer164.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer164.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer164.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer164.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer164.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer164.needRenderPos.posX === 0).assertTrue();
    expect(testContainer164.needRenderPos.posY === 0).assertTrue();
    expect(testContainer164.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer164.iconAlpha === 0).assertTrue();
    expect(testContainer164.iconAlpha === 0).assertTrue();
    expect(testContainer164.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer164.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer164.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer164.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer164.intelligentScene === 1).assertTrue();

    expect(testDividerParam164.primary.translateY === 0).assertTrue();
    expect(testDividerParam164.primary.translateX === 0).assertTrue();
    expect(testDividerParam164.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam164.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam164.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam164.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam164.primary.opacity === 1).assertTrue();
    expect(testDividerParam164.primary.blurScale === 0).assertTrue();
    expect(testDividerParam164.secondary.opacity === 1).assertTrue();
    expect(testDividerParam164.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam164.primary.rotateX === 0).assertTrue();
    expect(testDividerParam164.primary.rotateY === 0).assertTrue();
    expect(testDividerParam164.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam164.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam164.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam164.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam164.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam164.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam164.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam164.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam164.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam164.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam164.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam164.primary.posX === '0%').assertTrue();
    expect(testDividerParam164.primary.posY === '0%').assertTrue();
    expect(testDividerParam164.secondary.posX === '0%').assertTrue();
    expect(testDividerParam164.secondary.posY === '0%').assertTrue();
    expect(testDividerParam164.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam164.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_165', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer165: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer165.init();
    let testDividerParam165 = testContainer165.dividerParam;
    testDividerParam165.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer165);

    expect(testContainer165.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer165.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer165.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer165.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer165.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer165.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer165.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer165.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer165.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer165.needRenderPos.posX === 0).assertTrue();
    expect(testContainer165.needRenderPos.posY === 0).assertTrue();
    expect(testContainer165.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer165.iconAlpha === 0).assertTrue();
    expect(testContainer165.iconAlpha === 0).assertTrue();
    expect(testContainer165.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer165.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer165.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer165.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer165.intelligentScene === 1).assertTrue();

    expect(testDividerParam165.primary.translateY === 0).assertTrue();
    expect(testDividerParam165.primary.translateX === 0).assertTrue();
    expect(testDividerParam165.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam165.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam165.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam165.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam165.primary.opacity === 1).assertTrue();
    expect(testDividerParam165.primary.blurScale === 0).assertTrue();
    expect(testDividerParam165.secondary.opacity === 1).assertTrue();
    expect(testDividerParam165.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam165.primary.rotateX === 0).assertTrue();
    expect(testDividerParam165.primary.rotateY === 0).assertTrue();
    expect(testDividerParam165.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam165.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam165.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam165.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam165.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam165.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam165.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam165.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam165.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam165.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam165.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam165.primary.posX === '0%').assertTrue();
    expect(testDividerParam165.primary.posY === '0%').assertTrue();
    expect(testDividerParam165.secondary.posX === '0%').assertTrue();
    expect(testDividerParam165.secondary.posY === '0%').assertTrue();
    expect(testDividerParam165.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam165.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_166', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer166: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer166.init();
    let testDividerParam166 = testContainer166.dividerParam;
    testDividerParam166.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer166);

    expect(testContainer166.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer166.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer166.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer166.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer166.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer166.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer166.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer166.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer166.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer166.needRenderPos.posX === 0).assertTrue();
    expect(testContainer166.needRenderPos.posY === 0).assertTrue();
    expect(testContainer166.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer166.iconAlpha === 0).assertTrue();
    expect(testContainer166.iconAlpha === 0).assertTrue();
    expect(testContainer166.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer166.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer166.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer166.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer166.intelligentScene === 1).assertTrue();

    expect(testDividerParam166.primary.translateY === 0).assertTrue();
    expect(testDividerParam166.primary.translateX === 0).assertTrue();
    expect(testDividerParam166.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam166.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam166.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam166.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam166.primary.opacity === 1).assertTrue();
    expect(testDividerParam166.primary.blurScale === 0).assertTrue();
    expect(testDividerParam166.secondary.opacity === 1).assertTrue();
    expect(testDividerParam166.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam166.primary.rotateX === 0).assertTrue();
    expect(testDividerParam166.primary.rotateY === 0).assertTrue();
    expect(testDividerParam166.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam166.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam166.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam166.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam166.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam166.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam166.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam166.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam166.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam166.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam166.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam166.primary.posX === '0%').assertTrue();
    expect(testDividerParam166.primary.posY === '0%').assertTrue();
    expect(testDividerParam166.secondary.posX === '0%').assertTrue();
    expect(testDividerParam166.secondary.posY === '0%').assertTrue();
    expect(testDividerParam166.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam166.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_167', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer167: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer167.init();
    let testDividerParam167 = testContainer167.dividerParam;
    testDividerParam167.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer167);

    expect(testContainer167.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer167.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer167.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer167.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer167.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer167.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer167.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer167.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer167.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer167.needRenderPos.posX === 0).assertTrue();
    expect(testContainer167.needRenderPos.posY === 0).assertTrue();
    expect(testContainer167.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer167.iconAlpha === 0).assertTrue();
    expect(testContainer167.iconAlpha === 0).assertTrue();
    expect(testContainer167.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer167.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer167.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer167.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer167.intelligentScene === 1).assertTrue();

    expect(testDividerParam167.primary.translateY === 0).assertTrue();
    expect(testDividerParam167.primary.translateX === 0).assertTrue();
    expect(testDividerParam167.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam167.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam167.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam167.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam167.primary.opacity === 1).assertTrue();
    expect(testDividerParam167.primary.blurScale === 0).assertTrue();
    expect(testDividerParam167.secondary.opacity === 1).assertTrue();
    expect(testDividerParam167.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam167.primary.rotateX === 0).assertTrue();
    expect(testDividerParam167.primary.rotateY === 0).assertTrue();
    expect(testDividerParam167.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam167.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam167.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam167.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam167.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam167.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam167.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam167.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam167.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam167.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam167.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam167.primary.posX === '0%').assertTrue();
    expect(testDividerParam167.primary.posY === '0%').assertTrue();
    expect(testDividerParam167.secondary.posX === '0%').assertTrue();
    expect(testDividerParam167.secondary.posY === '0%').assertTrue();
    expect(testDividerParam167.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam167.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_168', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer168: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer168.init();
    let testDividerParam168 = testContainer168.dividerParam;
    testDividerParam168.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer168);

    expect(testContainer168.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer168.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer168.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer168.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer168.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer168.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer168.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer168.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer168.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer168.needRenderPos.posX === 0).assertTrue();
    expect(testContainer168.needRenderPos.posY === 0).assertTrue();
    expect(testContainer168.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer168.iconAlpha === 0).assertTrue();
    expect(testContainer168.iconAlpha === 0).assertTrue();
    expect(testContainer168.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer168.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer168.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer168.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer168.intelligentScene === 1).assertTrue();

    expect(testDividerParam168.primary.translateY === 0).assertTrue();
    expect(testDividerParam168.primary.translateX === 0).assertTrue();
    expect(testDividerParam168.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam168.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam168.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam168.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam168.primary.opacity === 1).assertTrue();
    expect(testDividerParam168.primary.blurScale === 0).assertTrue();
    expect(testDividerParam168.secondary.opacity === 1).assertTrue();
    expect(testDividerParam168.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam168.primary.rotateX === 0).assertTrue();
    expect(testDividerParam168.primary.rotateY === 0).assertTrue();
    expect(testDividerParam168.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam168.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam168.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam168.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam168.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam168.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam168.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam168.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam168.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam168.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam168.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam168.primary.posX === '0%').assertTrue();
    expect(testDividerParam168.primary.posY === '0%').assertTrue();
    expect(testDividerParam168.secondary.posX === '0%').assertTrue();
    expect(testDividerParam168.secondary.posY === '0%').assertTrue();
    expect(testDividerParam168.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam168.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_169', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer169: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer169.init();
    let testDividerParam169 = testContainer169.dividerParam;
    testDividerParam169.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer169);

    expect(testContainer169.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer169.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer169.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer169.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer169.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer169.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer169.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer169.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer169.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer169.needRenderPos.posX === 0).assertTrue();
    expect(testContainer169.needRenderPos.posY === 0).assertTrue();
    expect(testContainer169.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer169.iconAlpha === 0).assertTrue();
    expect(testContainer169.iconAlpha === 0).assertTrue();
    expect(testContainer169.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer169.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer169.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer169.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer169.intelligentScene === 1).assertTrue();

    expect(testDividerParam169.primary.translateY === 0).assertTrue();
    expect(testDividerParam169.primary.translateX === 0).assertTrue();
    expect(testDividerParam169.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam169.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam169.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam169.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam169.primary.opacity === 1).assertTrue();
    expect(testDividerParam169.primary.blurScale === 0).assertTrue();
    expect(testDividerParam169.secondary.opacity === 1).assertTrue();
    expect(testDividerParam169.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam169.primary.rotateX === 0).assertTrue();
    expect(testDividerParam169.primary.rotateY === 0).assertTrue();
    expect(testDividerParam169.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam169.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam169.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam169.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam169.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam169.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam169.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam169.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam169.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam169.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam169.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam169.primary.posX === '0%').assertTrue();
    expect(testDividerParam169.primary.posY === '0%').assertTrue();
    expect(testDividerParam169.secondary.posX === '0%').assertTrue();
    expect(testDividerParam169.secondary.posY === '0%').assertTrue();
    expect(testDividerParam169.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam169.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_170', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer170: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer170.init();
    let testDividerParam170 = testContainer170.dividerParam;
    testDividerParam170.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer170);

    expect(testContainer170.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer170.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer170.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer170.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer170.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer170.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer170.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer170.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer170.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer170.needRenderPos.posX === 0).assertTrue();
    expect(testContainer170.needRenderPos.posY === 0).assertTrue();
    expect(testContainer170.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer170.iconAlpha === 0).assertTrue();
    expect(testContainer170.iconAlpha === 0).assertTrue();
    expect(testContainer170.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer170.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer170.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer170.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer170.intelligentScene === 1).assertTrue();

    expect(testDividerParam170.primary.translateY === 0).assertTrue();
    expect(testDividerParam170.primary.translateX === 0).assertTrue();
    expect(testDividerParam170.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam170.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam170.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam170.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam170.primary.opacity === 1).assertTrue();
    expect(testDividerParam170.primary.blurScale === 0).assertTrue();
    expect(testDividerParam170.secondary.opacity === 1).assertTrue();
    expect(testDividerParam170.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam170.primary.rotateX === 0).assertTrue();
    expect(testDividerParam170.primary.rotateY === 0).assertTrue();
    expect(testDividerParam170.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam170.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam170.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam170.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam170.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam170.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam170.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam170.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam170.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam170.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam170.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam170.primary.posX === '0%').assertTrue();
    expect(testDividerParam170.primary.posY === '0%').assertTrue();
    expect(testDividerParam170.secondary.posX === '0%').assertTrue();
    expect(testDividerParam170.secondary.posY === '0%').assertTrue();
    expect(testDividerParam170.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam170.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_171', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer171: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer171.init();
    let testDividerParam171 = testContainer171.dividerParam;
    testDividerParam171.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer171);

    expect(testContainer171.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer171.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer171.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer171.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer171.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer171.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer171.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer171.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer171.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer171.needRenderPos.posX === 0).assertTrue();
    expect(testContainer171.needRenderPos.posY === 0).assertTrue();
    expect(testContainer171.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer171.iconAlpha === 0).assertTrue();
    expect(testContainer171.iconAlpha === 0).assertTrue();
    expect(testContainer171.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer171.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer171.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer171.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer171.intelligentScene === 1).assertTrue();

    expect(testDividerParam171.primary.translateY === 0).assertTrue();
    expect(testDividerParam171.primary.translateX === 0).assertTrue();
    expect(testDividerParam171.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam171.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam171.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam171.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam171.primary.opacity === 1).assertTrue();
    expect(testDividerParam171.primary.blurScale === 0).assertTrue();
    expect(testDividerParam171.secondary.opacity === 1).assertTrue();
    expect(testDividerParam171.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam171.primary.rotateX === 0).assertTrue();
    expect(testDividerParam171.primary.rotateY === 0).assertTrue();
    expect(testDividerParam171.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam171.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam171.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam171.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam171.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam171.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam171.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam171.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam171.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam171.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam171.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam171.primary.posX === '0%').assertTrue();
    expect(testDividerParam171.primary.posY === '0%').assertTrue();
    expect(testDividerParam171.secondary.posX === '0%').assertTrue();
    expect(testDividerParam171.secondary.posY === '0%').assertTrue();
    expect(testDividerParam171.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam171.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_172', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer172: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer172.init();
    let testDividerParam172 = testContainer172.dividerParam;
    testDividerParam172.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer172);

    expect(testContainer172.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer172.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer172.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer172.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer172.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer172.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer172.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer172.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer172.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer172.needRenderPos.posX === 0).assertTrue();
    expect(testContainer172.needRenderPos.posY === 0).assertTrue();
    expect(testContainer172.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer172.iconAlpha === 0).assertTrue();
    expect(testContainer172.iconAlpha === 0).assertTrue();
    expect(testContainer172.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer172.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer172.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer172.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer172.intelligentScene === 1).assertTrue();

    expect(testDividerParam172.primary.translateY === 0).assertTrue();
    expect(testDividerParam172.primary.translateX === 0).assertTrue();
    expect(testDividerParam172.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam172.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam172.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam172.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam172.primary.opacity === 1).assertTrue();
    expect(testDividerParam172.primary.blurScale === 0).assertTrue();
    expect(testDividerParam172.secondary.opacity === 1).assertTrue();
    expect(testDividerParam172.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam172.primary.rotateX === 0).assertTrue();
    expect(testDividerParam172.primary.rotateY === 0).assertTrue();
    expect(testDividerParam172.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam172.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam172.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam172.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam172.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam172.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam172.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam172.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam172.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam172.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam172.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam172.primary.posX === '0%').assertTrue();
    expect(testDividerParam172.primary.posY === '0%').assertTrue();
    expect(testDividerParam172.secondary.posX === '0%').assertTrue();
    expect(testDividerParam172.secondary.posY === '0%').assertTrue();
    expect(testDividerParam172.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam172.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_173', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer173: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer173.init();
    let testDividerParam173 = testContainer173.dividerParam;
    testDividerParam173.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer173);

    expect(testContainer173.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer173.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer173.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer173.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer173.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer173.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer173.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer173.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer173.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer173.needRenderPos.posX === 0).assertTrue();
    expect(testContainer173.needRenderPos.posY === 0).assertTrue();
    expect(testContainer173.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer173.iconAlpha === 0).assertTrue();
    expect(testContainer173.iconAlpha === 0).assertTrue();
    expect(testContainer173.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer173.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer173.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer173.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer173.intelligentScene === 1).assertTrue();

    expect(testDividerParam173.primary.translateY === 0).assertTrue();
    expect(testDividerParam173.primary.translateX === 0).assertTrue();
    expect(testDividerParam173.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam173.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam173.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam173.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam173.primary.opacity === 1).assertTrue();
    expect(testDividerParam173.primary.blurScale === 0).assertTrue();
    expect(testDividerParam173.secondary.opacity === 1).assertTrue();
    expect(testDividerParam173.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam173.primary.rotateX === 0).assertTrue();
    expect(testDividerParam173.primary.rotateY === 0).assertTrue();
    expect(testDividerParam173.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam173.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam173.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam173.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam173.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam173.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam173.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam173.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam173.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam173.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam173.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam173.primary.posX === '0%').assertTrue();
    expect(testDividerParam173.primary.posY === '0%').assertTrue();
    expect(testDividerParam173.secondary.posX === '0%').assertTrue();
    expect(testDividerParam173.secondary.posY === '0%').assertTrue();
    expect(testDividerParam173.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam173.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_174', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer174: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer174.init();
    let testDividerParam174 = testContainer174.dividerParam;
    testDividerParam174.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer174);

    expect(testContainer174.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer174.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer174.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer174.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer174.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer174.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer174.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer174.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer174.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer174.needRenderPos.posX === 0).assertTrue();
    expect(testContainer174.needRenderPos.posY === 0).assertTrue();
    expect(testContainer174.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer174.iconAlpha === 0).assertTrue();
    expect(testContainer174.iconAlpha === 0).assertTrue();
    expect(testContainer174.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer174.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer174.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer174.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer174.intelligentScene === 1).assertTrue();

    expect(testDividerParam174.primary.translateY === 0).assertTrue();
    expect(testDividerParam174.primary.translateX === 0).assertTrue();
    expect(testDividerParam174.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam174.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam174.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam174.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam174.primary.opacity === 1).assertTrue();
    expect(testDividerParam174.primary.blurScale === 0).assertTrue();
    expect(testDividerParam174.secondary.opacity === 1).assertTrue();
    expect(testDividerParam174.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam174.primary.rotateX === 0).assertTrue();
    expect(testDividerParam174.primary.rotateY === 0).assertTrue();
    expect(testDividerParam174.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam174.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam174.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam174.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam174.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam174.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam174.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam174.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam174.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam174.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam174.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam174.primary.posX === '0%').assertTrue();
    expect(testDividerParam174.primary.posY === '0%').assertTrue();
    expect(testDividerParam174.secondary.posX === '0%').assertTrue();
    expect(testDividerParam174.secondary.posY === '0%').assertTrue();
    expect(testDividerParam174.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam174.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_175', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer175: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer175.init();
    let testDividerParam175 = testContainer175.dividerParam;
    testDividerParam175.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer175);

    expect(testContainer175.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer175.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer175.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer175.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer175.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer175.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer175.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer175.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer175.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer175.needRenderPos.posX === 0).assertTrue();
    expect(testContainer175.needRenderPos.posY === 0).assertTrue();
    expect(testContainer175.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer175.iconAlpha === 0).assertTrue();
    expect(testContainer175.iconAlpha === 0).assertTrue();
    expect(testContainer175.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer175.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer175.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer175.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer175.intelligentScene === 1).assertTrue();

    expect(testDividerParam175.primary.translateY === 0).assertTrue();
    expect(testDividerParam175.primary.translateX === 0).assertTrue();
    expect(testDividerParam175.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam175.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam175.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam175.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam175.primary.opacity === 1).assertTrue();
    expect(testDividerParam175.primary.blurScale === 0).assertTrue();
    expect(testDividerParam175.secondary.opacity === 1).assertTrue();
    expect(testDividerParam175.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam175.primary.rotateX === 0).assertTrue();
    expect(testDividerParam175.primary.rotateY === 0).assertTrue();
    expect(testDividerParam175.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam175.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam175.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam175.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam175.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam175.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam175.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam175.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam175.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam175.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam175.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam175.primary.posX === '0%').assertTrue();
    expect(testDividerParam175.primary.posY === '0%').assertTrue();
    expect(testDividerParam175.secondary.posX === '0%').assertTrue();
    expect(testDividerParam175.secondary.posY === '0%').assertTrue();
    expect(testDividerParam175.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam175.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_176', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer176: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer176.init();
    let testDividerParam176 = testContainer176.dividerParam;
    testDividerParam176.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer176);

    expect(testContainer176.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer176.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer176.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer176.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer176.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer176.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer176.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer176.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer176.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer176.needRenderPos.posX === 0).assertTrue();
    expect(testContainer176.needRenderPos.posY === 0).assertTrue();
    expect(testContainer176.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer176.iconAlpha === 0).assertTrue();
    expect(testContainer176.iconAlpha === 0).assertTrue();
    expect(testContainer176.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer176.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer176.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer176.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer176.intelligentScene === 1).assertTrue();

    expect(testDividerParam176.primary.translateY === 0).assertTrue();
    expect(testDividerParam176.primary.translateX === 0).assertTrue();
    expect(testDividerParam176.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam176.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam176.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam176.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam176.primary.opacity === 1).assertTrue();
    expect(testDividerParam176.primary.blurScale === 0).assertTrue();
    expect(testDividerParam176.secondary.opacity === 1).assertTrue();
    expect(testDividerParam176.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam176.primary.rotateX === 0).assertTrue();
    expect(testDividerParam176.primary.rotateY === 0).assertTrue();
    expect(testDividerParam176.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam176.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam176.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam176.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam176.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam176.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam176.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam176.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam176.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam176.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam176.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam176.primary.posX === '0%').assertTrue();
    expect(testDividerParam176.primary.posY === '0%').assertTrue();
    expect(testDividerParam176.secondary.posX === '0%').assertTrue();
    expect(testDividerParam176.secondary.posY === '0%').assertTrue();
    expect(testDividerParam176.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam176.secondary.blurRadius === -1).assertTrue();
  });

  it('newMidSceneRecentHelperTest_177', Level.LEVEL0, (): void => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let testContainer177: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    testContainer177.init();
    let testDividerParam177 = testContainer177.dividerParam;
    testDividerParam177.init();
    MidSceneManager.getInstance(screenProperty)
      .recentHelper?.notifyMidSceneAnimFromGesture(MidSceneGestureType.ENTER_RECENT, screenProperty, testContainer177);

    expect(testContainer177.needRenderTranslate.translateX === 0).assertTrue();
    expect(testContainer177.needRenderTranslate.translateY === 0).assertTrue();
    expect(testContainer177.needRenderScale.scaleX === 1).assertTrue();
    expect(testContainer177.needRenderScale.scaleY === 1).assertTrue();
    expect(testContainer177.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(testContainer177.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(testContainer177.needRenderScale.centerX === '50%').assertTrue();
    expect(testContainer177.needRenderScale.centerY === '50%').assertTrue();
    expect(testContainer177.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(testContainer177.needRenderPos.posX === 0).assertTrue();
    expect(testContainer177.needRenderPos.posY === 0).assertTrue();
    expect(testContainer177.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(testContainer177.iconAlpha === 0).assertTrue();
    expect(testContainer177.iconAlpha === 0).assertTrue();
    expect(testContainer177.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(testContainer177.needRenderVisibility.visibility === true).assertTrue();
    expect(testContainer177.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(testContainer177.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(testContainer177.intelligentScene === 1).assertTrue();

    expect(testDividerParam177.primary.translateY === 0).assertTrue();
    expect(testDividerParam177.primary.translateX === 0).assertTrue();
    expect(testDividerParam177.primary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam177.primary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam177.secondary.touchTranslateX === 0).assertTrue();
    expect(testDividerParam177.secondary.touchTranslateY === 0).assertTrue();
    expect(testDividerParam177.primary.opacity === 1).assertTrue();
    expect(testDividerParam177.primary.blurScale === 0).assertTrue();
    expect(testDividerParam177.secondary.opacity === 1).assertTrue();
    expect(testDividerParam177.secondary.blurScale === 0).assertTrue();
    expect(testDividerParam177.primary.rotateX === 0).assertTrue();
    expect(testDividerParam177.primary.rotateY === 0).assertTrue();
    expect(testDividerParam177.primary.rotateZ === 0).assertTrue();
    expect(testDividerParam177.primary.rotateAngle === 0).assertTrue();
    expect(testDividerParam177.primary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam177.primary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam177.secondary.rotateX === 0).assertTrue();
    expect(testDividerParam177.secondary.rotateZ === 0).assertTrue();
    expect(testDividerParam177.secondary.rotateAngle === 0).assertTrue();
    expect(testDividerParam177.secondary.rotateCenterX === 0).assertTrue();
    expect(testDividerParam177.secondary.rotateCenterY === 0).assertTrue();
    expect(testDividerParam177.blackBackgroundOpacity === 0).assertTrue();
    expect(testDividerParam177.splitOrderIsNotReverse === true).assertTrue();
    expect(testDividerParam177.primary.posX === '0%').assertTrue();
    expect(testDividerParam177.primary.posY === '0%').assertTrue();
    expect(testDividerParam177.secondary.posX === '0%').assertTrue();
    expect(testDividerParam177.secondary.posY === '0%').assertTrue();
    expect(testDividerParam177.primary.blurRadius === -1).assertTrue();
    expect(testDividerParam177.secondary.blurRadius === -1).assertTrue();
  });
}