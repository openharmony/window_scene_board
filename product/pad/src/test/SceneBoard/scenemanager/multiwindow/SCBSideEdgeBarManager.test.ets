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
  SCBSceneContainerSession,
  SCBPropertyChangeReason,
  SCBSceneContainerSessionArray,
  SCBScenePanelManager,
  SCBSceneInfo,
  SCBSceneSessionManager,
  SCBSceneSession,
  SCBScreenProperty,
  SCBSideEdgeBarDisplayState,
} from '@ohos/windowscene';
import { BaseViewController } from '@ohos/frameworkcommon';
import { viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { ArgumentMatchers, beforeAll, describe, expect, it, Level, MockKit, when } from '@ohos/hypium';
import ScreenLockService from '@ohos/screenlockcommon/src/main/ets/base/ScreenLockService';
import { SCBSideEdgeBarManager } from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBSideEdgeBarManager';

let screenProp: SCBScreenProperty;
let sceneSession: SCBSceneSession;
let sceneInfo: SCBSceneInfo;
let containerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
let containerSession: SCBSceneContainerSession;
let sideEdgeBarManager: SCBSideEdgeBarManager = SCBSideEdgeBarManager.getInstance();
let screenWidth: number = 1260;
let screenHeight: number = 2540;
export function SCBSideEdgeBarManagerTest() {
  describe('SCBSideEdgeBarManagerTest', () => {
    beforeAll(() => {
      sceneInfo = new SCBSceneInfo('testSideEdge', 'testSideEdge', 'testSideEdge');
      sceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      screenProp = new SCBScreenProperty();
      screenProp.width = screenWidth;
      screenProp.height = screenHeight;
      containerSession = new SCBSceneContainerSession(sceneSession, screenProp);
      containerSessionList.add(containerSession);
    })
    SCBSideEdgeBarMgrTest_getSideEdgeBarOptions();
    SCBSideEdgeBarMgrTest_getInstance();
    SCBSideEdgeBarMgrTest_updateSideEdgeBarRect();
    SCBSideEdgeBarMgrTest_updateResponseRegion();
    SCBSideEdgeBarMgrTest_handleSwipe();
    SCBSideEdgeBarMgrTest_handleClick();
    SCBSideEdgeBarMgrTest_destroySidebarByCleanAll();
    SCBSideEdgeBarMgrTest_destroySidebarIfNeed();
    SCBSideEdgeBarMgrTest_destroySidebarWhenQuitFullSceneMode();
    SCBSideEdgeBarMgrTest_showSideEdgeBar();
    SCBSideEdgeBarMgrTest_destroySidebarAndExitSessionIfNeed();
    SCBSideEdgeBarMgrTest_hideSideEdgeBar();
    SCBSideEdgeBarMgrTest_isInSideBar();
    SCBSideEdgeBarMgrTest_notifyScreenPropertyChange();
    SCBSideEdgeBarMgrTest_lock();
  })
}

function SCBSideEdgeBarMgrTest_getInstance() {
  it('SCBSideEdgeBarMgrTest_getInstance', Level.LEVEL0, (): void => {
    expect(containerSession !== null).assertTrue();
    let instance: SCBSideEdgeBarManager = SCBSideEdgeBarManager.getInstance();
    expect(instance !== null).assertTrue();
    expect(containerSessionList.isEmpty()).assertFalse();
    expect(containerSession.screenProperty.width === screenWidth).assertTrue();
    expect(containerSession.screenProperty.height === screenHeight).assertTrue();
  });
}

function SCBSideEdgeBarMgrTest_getSideEdgeBarOptions() {
  it('SCBSideEdgeBarMgrTest_getSideEdgeBarOptions', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    expect(sideEdgeBarOptions.persistentId === -1).assertTrue();
    sideEdgeBarOptions.persistentId = 101;
    expect(sideEdgeBarOptions.persistentId === 101).assertTrue();
    expect(sideEdgeBarOptions.posY === 96).assertTrue();
    expect(sideEdgeBarOptions.width === 20).assertTrue();
    expect(sideEdgeBarOptions.displayState === SCBSideEdgeBarDisplayState.NONE).assertTrue();
    expect(sideEdgeBarOptions.height === 104).assertTrue();
    expect(sideEdgeBarOptions.posX > -1000).assertTrue();
    expect(sideEdgeBarOptions.height === 104).assertTrue();
    expect(sideEdgeBarOptions.borderRadius === 16).assertTrue();
  });
}

function SCBSideEdgeBarMgrTest_updateSideEdgeBarRect01() {
  it('SCBSideEdgeBarMgrTest_updateSideEdgeBarRect01', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(ScreenLockService, ScreenLockService.getLock);
    when(mockFunc)().afterReturn(true);
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.persistentId = 10;
    expect(sideEdgeBarOptions.persistentId === 10).assertTrue();
    sideEdgeBarOptions.posY = 328;
    sideEdgeBarOptions.posX = 125;
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.HIDDEN;
    sideEdgeBarManager.updateSideEdgeBarRect(screenProp);
    let viewController = viewMgrPolicy.getViewController(ViewType.SIDE_EDGE_BAR) as BaseViewController;
    expect(sideEdgeBarOptions !== null).assertTrue();
    expect(viewController !== null).assertTrue();
    expect(sideEdgeBarOptions.posY !== 100).assertTrue();
    expect(sideEdgeBarOptions.posY === 328).assertTrue();
    expect(sideEdgeBarOptions.posX === 125).assertTrue();
  });
}

function SCBSideEdgeBarMgrTest_updateSideEdgeBarRect() {
  it('SCBSideEdgeBarMgrTest_updateSideEdgeBarRect', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(ScreenLockService, ScreenLockService.getLock);
    when(mockFunc)().afterReturn(false);
    sideEdgeBarOptions.persistentId = 7;
    expect(sideEdgeBarOptions.persistentId === 7).assertTrue();
    sideEdgeBarOptions.posY = 577;
    sideEdgeBarOptions.posX = 433;
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.NONE;
    sideEdgeBarManager.updateSideEdgeBarRect(screenProp);
    expect(sideEdgeBarOptions.posY === 577).assertTrue();
    expect(sideEdgeBarOptions !== null).assertTrue();
  });
}

function SCBSideEdgeBarMgrTest_updateResponseRegion() {
  it('SCBSideEdgeBarMgrTest_updateResponseRegion', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.persistentId = 100;
    sideEdgeBarOptions.posX = 987;
    sideEdgeBarOptions.posY = 654;
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.SHOW;
    sideEdgeBarManager.updateResponseRegion(screenProp);
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.NONE;
    sideEdgeBarManager.updateResponseRegion(screenProp);
    sideEdgeBarOptions.posX = -321;
    sideEdgeBarManager.updateResponseRegion(screenProp);
    expect(sideEdgeBarOptions.posX > -2000).assertTrue();
    expect(containerSession !== null).assertTrue();
    expect(containerSessionList.isEmpty()).assertFalse();
    containerSession.init();
    expect(containerSession.screenProperty.left === 0).assertTrue();
    expect(containerSession.screenProperty.top === 0).assertTrue();
    expect(containerSession.screenProperty.width === screenWidth).assertTrue();
    expect(containerSession.screenProperty.height === screenHeight).assertTrue();
    expect(containerSession.primarySession !== null).assertTrue();
    expect(containerSession.needRenderScale.scaleX === 1).assertFalse();
    expect(containerSession.isFloat).assertFalse();
    expect(containerSession.isSplit).assertFalse();
    expect(containerSession.needRenderPos.posX === 0).assertTrue();
    expect(containerSession.needRenderPos.posY === 0).assertTrue();
    expect(containerSession.needRenderScale.scaleY === 1).assertFalse();
    expect(containerSession.needRenderScale.centerX === '50%').assertTrue();
    expect(containerSession.needRenderScale.centerY === '50%').assertTrue();
    expect(containerSession.needRenderShowInRecent).assertFalse();
  });

  it('SCBSideEdgeBarMgrTest_updateResponseRegion_01', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.SHOW;
    sideEdgeBarOptions.posX = -200;
    sideEdgeBarManager.updateResponseRegion(screenProp);
    expect(sideEdgeBarOptions.posX > -1000).assertTrue();
    containerSession.initAll();
    expect(containerSession.dividerParam.primary.translateX === 0).assertTrue();
    expect(containerSession.dividerParam.blackBackgroundOpacity === 0).assertTrue();
    expect(containerSession.dividerParam.dividerAlpha === 0).assertTrue();
    expect(containerSession.dividerParam.primary.opacity === 1).assertTrue();
    expect(containerSession.dividerParam.primary.touchTranslateX === 0).assertTrue();
    expect(containerSession.dividerParam.primary.touchTranslateY === 0).assertTrue();
    expect(containerSession.dividerParam.secondary.touchTranslateX === 0).assertTrue();
    expect(containerSession.dividerParam.secondary.touchTranslateY === 0).assertTrue();
    expect(containerSession.dividerParam.primary.blurScale === 0).assertTrue();
    expect(containerSession.dividerParam.secondary.opacity === 1).assertTrue();
    expect(containerSession.dividerParam.secondary.blurScale === 0).assertTrue();
    expect(containerSession.dividerParam.primary.rotateAngle === 0).assertTrue();
    expect(containerSession.dividerParam.primary.rotateX === 0).assertTrue();
    expect(containerSession.dividerParam.primary.rotateY === 0).assertTrue();
    expect(containerSession.dividerParam.primary.rotateZ === 0).assertTrue();
    expect(containerSession.dividerParam.primary.rotateCenterX === 0).assertTrue();
    expect(containerSession.dividerParam.primary.rotateCenterY === 0).assertTrue();
    expect(containerSession.dividerParam.secondary.rotateAngle === 0).assertTrue();
    expect(containerSession.dividerParam.secondary.rotateCenterX === 0).assertTrue();
    expect(containerSession.dividerParam.secondary.rotateCenterY === 0).assertTrue();
    expect(containerSession.dividerParam.secondary.rotateX === 0).assertTrue();
    expect(containerSession.dividerParam.secondary.rotateZ === 0).assertTrue();
    expect(containerSession.dividerParam.splitOrderIsNotReverse === true).assertTrue();
    expect(containerSession.dividerParam.blackBackgroundOpacity === 0).assertTrue();
    expect(containerSession.dividerParam.secondary.posX === '0%').assertTrue();
    expect(containerSession.dividerParam.secondary.posY === '0%').assertTrue();
    expect(containerSession.dividerParam.primary.posX === '0%').assertTrue();
    expect(containerSession.dividerParam.primary.posY === '0%').assertTrue();
    expect(containerSession.dividerParam.primary.blurRadius === -1).assertTrue();
    expect(containerSession.dividerParam.secondary.blurRadius === -1).assertTrue();
  });
}

function SCBSideEdgeBarMgrTest_handleSwipe() {
  it('SCBSideEdgeBarMgrTest_handleSwipe_01', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.persistentId = 123;
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.HIDDEN;
    sideEdgeBarOptions.posX = 111;
    sideEdgeBarOptions.posY = 222;
    sideEdgeBarManager.handleSwipe();
    expect(sideEdgeBarOptions.posX > -1000).assertTrue();
  });
  it('SCBSideEdgeBarMgrTest_handleSwipe_02', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.HIDDEN;
    sideEdgeBarOptions.persistentId = 111;
    sideEdgeBarOptions.posX = 789;
    sideEdgeBarOptions.posY = 852;
    sideEdgeBarManager.handleSwipe();
    expect(sideEdgeBarOptions.posX > -1000).assertTrue();
  });
  it('SCBSideEdgeBarMgrTest_handleSwipe_03', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.persistentId = 1;
    sideEdgeBarOptions.posX = 666;
    sideEdgeBarOptions.posY = 777;
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.HIDDEN;
    let scbSceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
    let topContainerSession :SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProp);
    let mocker: MockKit = new MockKit();
    let mockGetTopContainerSessionFunction:Function =
      mocker.mockFunc(scbSceneSessionManager, scbSceneSessionManager.getContainerSessionList().getTopActiveSession);
    when(mockGetTopContainerSessionFunction)(ArgumentMatchers.any).afterReturn(topContainerSession);
    topContainerSession.isMidScene = false;
    sideEdgeBarManager.handleSwipe();
    expect(sideEdgeBarOptions.posX > -1000).assertTrue();
    expect(sideEdgeBarOptions.persistentId === 1).assertTrue();
    mocker.clear(scbSceneSessionManager);
  });

  it('SCBSideEdgeBarMgrTest_handleSwipe_04', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.HIDDEN;
    sideEdgeBarOptions.persistentId = 1;
    sideEdgeBarOptions.posX = 200;
    sideEdgeBarOptions.posY = 200;
    let scbSceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
    let mocker: MockKit = new MockKit();
    let mockGetTopContainerSessionFunction:Function =
      mocker.mockFunc(scbSceneSessionManager, scbSceneSessionManager.getContainerSessionList().getTopActiveSession);
    when(mockGetTopContainerSessionFunction)(ArgumentMatchers.any).afterReturn(null);
    sideEdgeBarManager.handleSwipe();
    expect(sideEdgeBarOptions.persistentId === 1).assertTrue();
    expect(sideEdgeBarOptions.posX > -1000).assertTrue();
    mocker.clear(scbSceneSessionManager);
  });
}

function SCBSideEdgeBarMgrTest_handleClick() {
  it('SCBSideEdgeBarMgrTest_handleClick', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.persistentId = 123;
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.SHOW;
    sideEdgeBarOptions.posX = 400;
    sideEdgeBarOptions.posY = 400;
    sideEdgeBarManager.handleClick();
    expect(sideEdgeBarOptions.persistentId === 123).assertTrue();
    expect(sideEdgeBarOptions.posX > -1000).assertTrue();
  });
  it('SCBSideEdgeBarMgrTest_handleClick_02', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.persistentId = 123;
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.SHOW;
    sideEdgeBarOptions.posX = 300;
    sideEdgeBarOptions.posY = 400;
    let mocker: MockKit = new MockKit();
    containerSession.isMidScene = true;
    let scbSceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
    let mockGetTopContainerSessionFunction:Function =
      mocker.mockFunc(scbSceneSessionManager, scbSceneSessionManager.getContainerSessionList()?.getTopActiveSession);
    when(mockGetTopContainerSessionFunction)(ArgumentMatchers.any).afterReturn(containerSession);
    sideEdgeBarManager.handleClick();

    expect(sideEdgeBarOptions.posX === 100).assertTrue();
    mocker.clear(scbSceneSessionManager);
  });
  it('SCBSideEdgeBarMgrTest_handleClick_03', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.persistentId = 1;
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.HIDDEN;
    sideEdgeBarOptions.posX = 555;
    sideEdgeBarOptions.posY = 444;
    let mocker: MockKit = new MockKit();
    containerSession.isMidScene = false;
    let scbSceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
    let mockGetTopContainerSessionFunction:Function =
      mocker.mockFunc(scbSceneSessionManager, scbSceneSessionManager.getContainerSessionList()?.getTopActiveSession);
    when(mockGetTopContainerSessionFunction)(ArgumentMatchers.any).afterReturn(containerSession);
    sideEdgeBarManager.handleClick();
    expect(sideEdgeBarOptions.posY === 444).assertTrue();
    mocker.clear(scbSceneSessionManager);
  });
  it('SCBSideEdgeBarMgrTest_handleClick_04', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.persistentId = 258;
    sideEdgeBarOptions.posX = 963;
    sideEdgeBarOptions.posY = 963;
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.HIDDEN;
    let scbSceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
    let mocker: MockKit = new MockKit();
    let mockGetTopContainerSessionFunction:Function =
      mocker.mockFunc(scbSceneSessionManager, scbSceneSessionManager.getContainerSessionList()?.getTopActiveSession);
    when(mockGetTopContainerSessionFunction)(ArgumentMatchers.any).afterReturn(null);
    sideEdgeBarManager.handleClick();
    expect(sideEdgeBarOptions.persistentId === 258).assertTrue();
    mocker.clear(scbSceneSessionManager);
  });
}

function SCBSideEdgeBarMgrTest_destroySidebarIfNeed() {
  it('SCBSideEdgeBarMgrTest_destroySidebarIfNeed', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.HIDDEN;
    sideEdgeBarOptions.persistentId = 11;
    sideEdgeBarManager.destroySidebarIfNeed(11);
    expect(sideEdgeBarOptions.posX > -800).assertTrue();
    sideEdgeBarManager.destroySidebarIfNeed(3);
    let viewController = viewMgrPolicy.getViewController(ViewType.SIDE_EDGE_BAR) as BaseViewController;
    expect(viewController.visible).assertTrue();
  });
}

function SCBSideEdgeBarMgrTest_destroySidebarByCleanAll() {
  it('SCBSideEdgeBarMgrTest_destroySidebarByCleanAll', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.HIDDEN;
    sideEdgeBarOptions.persistentId = 111;
    sideEdgeBarManager.destroySidebarByCleanAll();
    expect(sideEdgeBarOptions.posX > -500).assertTrue();
    let viewController = viewMgrPolicy.getViewController(ViewType.SIDE_EDGE_BAR) as BaseViewController;
    expect(viewController.visible).assertFalse();
  });
}

function SCBSideEdgeBarMgrTest_destroySidebarWhenQuitFullSceneMode() {
  it('SCBSideEdgeBarMgrTest_destroySidebarWhenQuitFullSceneMode', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.opacity = 1;
    sideEdgeBarOptions.borderRadius = 16;
    sideEdgeBarOptions.width = screenWidth;
    sideEdgeBarOptions.height = screenHeight;
    let instance: SCBScenePanelManager = SCBScenePanelManager.getInstance();
    let mocker: MockKit = new MockKit();
    let mockFunc1: Function = mocker.mockFunc(instance, instance.getFloatingSessionList);
    when(mockFunc1)().afterReturn(containerSessionList);
    sideEdgeBarOptions.persistentId = -500;
    sideEdgeBarManager.destroySidebarWhenQuitFullSceneMode();
    sideEdgeBarOptions.persistentId = -10;
    sideEdgeBarManager.destroySidebarWhenQuitFullSceneMode();
    sideEdgeBarOptions.persistentId = sceneSession.session.persistentId;
    sideEdgeBarManager.destroySidebarWhenQuitFullSceneMode();
    expect(containerSession.isActive).assertTrue();
    mocker.clear(instance);
  });
}

function SCBSideEdgeBarMgrTest_destroySidebarAndExitSessionIfNeed() {
  it('SCBSideEdgeBarMgrTest_destroySidebarAndExitSessionIfNeed', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.persistentId = sceneSession.session.persistentId;
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.HIDDEN;
    sideEdgeBarManager.destroySidebarAndExitSessionIfNeed(sceneSession);
    expect(sceneSession.isActive).assertFalse();
    expect(sideEdgeBarOptions.persistentId === -1).assertTrue();
    sideEdgeBarOptions.persistentId = sceneSession.session.persistentId + 10;
    sideEdgeBarManager.destroySidebarAndExitSessionIfNeed(sceneSession);
    expect(sceneSession.isActive).assertTrue();
  });
}

function SCBSideEdgeBarMgrTest_showSideEdgeBar() {
  it('SCBSideEdgeBarMgrTest_showSideEdgeBar', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.persistentId = -123;
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.NONE;
    sideEdgeBarManager.showSideEdgeBar();
    sideEdgeBarOptions.persistentId = 22;
    sideEdgeBarManager.showSideEdgeBar();
    expect(sideEdgeBarOptions.persistentId === 22).assertTrue();
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.HIDDEN;
    sideEdgeBarOptions.persistentId = 11;
    sideEdgeBarManager.receivedUnLocked();
    sideEdgeBarManager.showSideEdgeBar();
    expect(sideEdgeBarOptions.persistentId === 11).assertTrue();
    let viewController = viewMgrPolicy.getViewController(ViewType.SIDE_EDGE_BAR) as BaseViewController;
    expect(viewController.visible).assertTrue();
  });
}

function SCBSideEdgeBarMgrTest_hideSideEdgeBar() {
  it('SCBSideEdgeBarMgrTest_hideSideEdgeBar', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.persistentId = 852;
    sideEdgeBarManager.hideSideEdgeBar();
    let viewController = viewMgrPolicy.getViewController(ViewType.SIDE_EDGE_BAR) as BaseViewController;
    expect(sideEdgeBarOptions.persistentId === 852).assertTrue();
    expect(viewController.visible).assertFalse();
  });
}

function SCBSideEdgeBarMgrTest_notifyScreenPropertyChange() {
  it('SCBSideEdgeBarMgrTest_notifyScreenPropertyChange', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.posX = 500;
    sideEdgeBarOptions.persistentId = 777;
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.HIDDEN;
    sideEdgeBarManager.notifyScreenPropertyChange(screenProp, SCBPropertyChangeReason.FOLD_TO_EXPAND);
    expect(sideEdgeBarOptions.persistentId === 777).assertTrue();
    expect(sideEdgeBarOptions.posX === 500).assertTrue();
    expect(sideEdgeBarOptions.opacity === 1).assertTrue();
    sideEdgeBarOptions.posX = -147;
    sideEdgeBarOptions.persistentId = 888;
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.HIDDEN;
    sideEdgeBarManager.notifyScreenPropertyChange(screenProp, SCBPropertyChangeReason.FOLD_TO_EXPAND);
    expect(sideEdgeBarOptions.opacity === 1).assertTrue();
    expect(sideEdgeBarOptions.persistentId === 888).assertTrue();
    sideEdgeBarManager.notifyScreenPropertyChange(screenProp, SCBPropertyChangeReason.UNDEFINED);
    expect(sideEdgeBarOptions.displayState === SCBSideEdgeBarDisplayState.HIDDEN).assertTrue();
    expect(sideEdgeBarOptions.opacity === 1).assertTrue();
  });
}

function SCBSideEdgeBarMgrTest_isInSideBar() {
  it('SCBSideEdgeBarMgrTest_isInSideBar', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.persistentId = sceneSession.session.persistentId;
    let isInSideBar = sideEdgeBarManager.isInSideBar(sceneSession);
    expect(isInSideBar).assertTrue();
    expect(sideEdgeBarOptions.posX === 0).assertTrue();
    expect(sideEdgeBarOptions.opacity === 1).assertTrue();
    sideEdgeBarOptions.persistentId = sceneSession.session.persistentId + 1;
    isInSideBar = sideEdgeBarManager.isInSideBar(sceneSession);
    expect(sideEdgeBarOptions.opacity === 1).assertTrue();
    expect(isInSideBar).assertFalse();
    isInSideBar = sideEdgeBarManager.isInSideBar(null);
    expect(isInSideBar).assertFalse();
    expect(sideEdgeBarOptions.opacity === 1).assertTrue();
  });
}

function SCBSideEdgeBarMgrTest_lock() {
  it('SCBSideEdgeBarMgrTest_receivedUnLocked', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.SHOW;
    sideEdgeBarOptions.persistentId = 456;
    sideEdgeBarOptions.opacity = 1;
    sideEdgeBarManager.receivedUnLocked();
    let viewController = viewMgrPolicy.getViewController(ViewType.SIDE_EDGE_BAR) as BaseViewController;
    expect(sideEdgeBarOptions.persistentId === 456).assertTrue();
    expect(viewController.visible).assertTrue();
  });

  it('SCBSideEdgeBarMgrTest_receivedLocked', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.HIDDEN;
    sideEdgeBarOptions.persistentId = 100;
    sideEdgeBarOptions.opacity = 0;
    sideEdgeBarManager.receivedLocked();
    let viewController = viewMgrPolicy.getViewController(ViewType.SIDE_EDGE_BAR) as BaseViewController;
    expect(sideEdgeBarOptions.persistentId === 100).assertTrue();
    expect(viewController.visible).assertFalse();
  });
}