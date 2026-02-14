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
let sceneInfo: SCBSceneInfo;
let sceneSession: SCBSceneSession;
let containerSession: SCBSceneContainerSession;
let containerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
let sideEdgeBarManager: SCBSideEdgeBarManager = SCBSideEdgeBarManager.getInstance();

export function SCBSideEdgeBarTest() {
  describe('SCBSideEdgeBarTest', () => {
    beforeAll(() => {
      sceneInfo = new SCBSceneInfo('testSideEdge', 'testSideEdge', 'testSideEdge');
      sceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      screenProp = new SCBScreenProperty();
      screenProp.width = 2200;
      screenProp.height = 2244;
      containerSession = new SCBSceneContainerSession(sceneSession, screenProp);
      containerSessionList.add(containerSession);
    })
    SCBSideEdgeBarTest_getInstance();
    SCBSideEdgeBarTest_getSideEdgeBarOptions();
    SCBSideEdgeBarTest_updateSideEdgeBarRect();
    SCBSideEdgeBarTest_handleSwipe();
    SCBSideEdgeBarTest_updateResponseRegion();
    SCBSideEdgeBarTest_handleClick();
    SCBSideEdgeBarTest_destroySidebarIfNeed();
    SCBSideEdgeBarTest_destroySidebarByCleanAll();
    SCBSideEdgeBarTest_destroySidebarWhenQuitFullSceneMode();
    SCBSideEdgeBarTest_destroySidebarAndExitSessionIfNeed();
    SCBSideEdgeBarTest_showSideEdgeBar();
    SCBSideEdgeBarTest_hideSideEdgeBar();
    SCBSideEdgeBarTest_notifyScreenPropertyChange();
    SCBSideEdgeBarTest_isInSideBar();
    SCBSideEdgeBarTest_lock();
  })
}

function SCBSideEdgeBarTest_getInstance() {
  it('SCBSideEdgeBarManagerTest_getInstance', Level.LEVEL0, (): void => {
    let instance: SCBSideEdgeBarManager = SCBSideEdgeBarManager.getInstance();
    expect(instance !== null).assertTrue();
    expect(containerSession !== null).assertTrue();
    expect(containerSessionList.isEmpty()).assertFalse();
  });
}

function SCBSideEdgeBarTest_getSideEdgeBarOptions() {
  it('SCBSideEdgeBarTest_getSideEdgeBarOptions', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    expect(sideEdgeBarOptions.persistentId === -1).assertTrue();
    sideEdgeBarOptions.persistentId = 1;
    expect(sideEdgeBarOptions.borderRadius === 1).assertTrue();
    expect(sideEdgeBarOptions.borderRadius === 16).assertTrue();
    expect(sideEdgeBarOptions.posY === 96).assertTrue();
    expect(sideEdgeBarOptions.width === 20).assertTrue();
    expect(sideEdgeBarOptions.height === 104).assertTrue();
    expect(sideEdgeBarOptions.displayState === SCBSideEdgeBarDisplayState.NONE).assertTrue();
    expect(sideEdgeBarOptions.height === 104).assertTrue();
    expect(sideEdgeBarOptions.posX > -1000).assertTrue();
  });
}

function SCBSideEdgeBarTest_updateSideEdgeBarRect01() {
  it('SCBSideEdgeBarTest_updateSideEdgeBarRect01', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(ScreenLockService, ScreenLockService.getLock);
    when(mockFunc)().afterReturn(true);
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.persistentId = 10;
    sideEdgeBarOptions.posY = 328;
    sideEdgeBarOptions.posX = 125;
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.HIDDEN;
    sideEdgeBarManager.updateSideEdgeBarRect(screenProp);
    let viewController = viewMgrPolicy.getViewController(ViewType.SIDE_EDGE_BAR) as BaseViewController;
    expect(viewController !== null).assertTrue();
    expect(sideEdgeBarOptions !== null).assertTrue();
    expect(sideEdgeBarOptions.posY !== 100).assertTrue();
  });
}

function SCBSideEdgeBarTest_updateSideEdgeBarRect() {
  it('SCBSideEdgeBarManagerTest_updateSideEdgeBarRect', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(ScreenLockService, ScreenLockService.getLock);
    when(mockFunc)().afterReturn(false);
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.persistentId = 7;
    sideEdgeBarOptions.posX = 433;
    sideEdgeBarOptions.posY = 577;
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.NONE;
    sideEdgeBarManager.updateSideEdgeBarRect(screenProp);
    expect(sideEdgeBarOptions !== null).assertTrue();
    expect(sideEdgeBarOptions.posY === 577).assertTrue();
  });
}

function SCBSideEdgeBarTest_updateResponseRegion() {
  it('SCBSideEdgeBarManagerTest_updateResponseRegion', Level.LEVEL0, (): void => {
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
    expect(containerSession.screenProperty.width > 2000).assertTrue();
    expect(containerSession.screenProperty.height > 2200).assertTrue();
    expect(containerSession.primarySession !== null).assertTrue();
    expect(containerSession.isFloat).assertFalse();
    expect(containerSession.isSplit).assertFalse();
    expect(containerSession.needRenderScale.scaleX === 1).assertFalse();
    expect(containerSession.needRenderScale.scaleY === 1).assertFalse();
    expect(containerSession.needRenderScale.centerX === '50%').assertTrue();
    expect(containerSession.needRenderScale.centerY === '50%').assertTrue();
    expect(containerSession.needRenderPos.posX === 0).assertTrue();
    expect(containerSession.needRenderPos.posY === 0).assertTrue();
    expect(containerSession.needRenderShowInRecent).assertFalse();
  });

  it('SCBSideEdgeBarManagerTest_updateResponseRegion_01', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.SHOW;
    sideEdgeBarOptions.posX = -100;
    sideEdgeBarManager.updateResponseRegion(screenProp);
    expect(sideEdgeBarOptions.posX > -1000).assertTrue();
    containerSession.initAll();
    expect(containerSession.dividerParam.primary.translateX === 0).assertTrue();
    expect(containerSession.dividerParam.blackBackgroundOpacity === 0).assertTrue();
    expect(containerSession.dividerParam.dividerAlpha === 0).assertTrue();
    expect(containerSession.dividerParam.primary.touchTranslateX === 0).assertTrue();
    expect(containerSession.dividerParam.primary.touchTranslateY === 0).assertTrue();
    expect(containerSession.dividerParam.secondary.touchTranslateX === 0).assertTrue();
    expect(containerSession.dividerParam.secondary.touchTranslateY === 0).assertTrue();
    expect(containerSession.dividerParam.primary.opacity === 1).assertTrue();
    expect(containerSession.dividerParam.primary.blurScale === 0).assertTrue();
    expect(containerSession.dividerParam.secondary.opacity === 1).assertTrue();
    expect(containerSession.dividerParam.secondary.blurScale === 0).assertTrue();
    expect(containerSession.dividerParam.primary.rotateX === 0).assertTrue();
    expect(containerSession.dividerParam.primary.rotateY === 0).assertTrue();
    expect(containerSession.dividerParam.primary.rotateZ === 0).assertTrue();
    expect(containerSession.dividerParam.primary.rotateAngle === 0).assertTrue();
    expect(containerSession.dividerParam.primary.rotateCenterX === 0).assertTrue();
    expect(containerSession.dividerParam.primary.rotateCenterY === 0).assertTrue();
    expect(containerSession.dividerParam.secondary.rotateX === 0).assertTrue();
    expect(containerSession.dividerParam.secondary.rotateZ === 0).assertTrue();
    expect(containerSession.dividerParam.secondary.rotateAngle === 0).assertTrue();
    expect(containerSession.dividerParam.secondary.rotateCenterX === 0).assertTrue();
    expect(containerSession.dividerParam.secondary.rotateCenterY === 0).assertTrue();
    expect(containerSession.dividerParam.blackBackgroundOpacity === 0).assertTrue();
    expect(containerSession.dividerParam.splitOrderIsNotReverse === true).assertTrue();
    expect(containerSession.dividerParam.primary.posX === '0%').assertTrue();
    expect(containerSession.dividerParam.primary.posY === '0%').assertTrue();
    expect(containerSession.dividerParam.secondary.posX === '0%').assertTrue();
    expect(containerSession.dividerParam.secondary.posY === '0%').assertTrue();
    expect(containerSession.dividerParam.primary.blurRadius === -1).assertTrue();
    expect(containerSession.dividerParam.secondary.blurRadius === -1).assertTrue();
  });
}

function SCBSideEdgeBarTest_handleSwipe() {
  it('SCBSideEdgeBarManagerTest_handleSwipe_01', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.persistentId = 1;
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.HIDDEN;
    sideEdgeBarOptions.posX = 123;
    sideEdgeBarOptions.posY = 456;
    sideEdgeBarManager.handleSwipe();
    expect(sideEdgeBarOptions.posX > -1000).assertTrue();
  });
  it('SCBSideEdgeBarManagerTest_handleSwipe_02', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.HIDDEN;
    sideEdgeBarOptions.posX = 123;
    sideEdgeBarOptions.posY = 456;
    sideEdgeBarOptions.persistentId = 1;
    sideEdgeBarManager.handleSwipe();
    expect(sideEdgeBarOptions.posX > -1000).assertTrue();
  });
  it('SCBSideEdgeBarManagerTest_handleSwipe_03', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.HIDDEN;
    sideEdgeBarOptions.posX = 123;
    sideEdgeBarOptions.posY = 456;
    sideEdgeBarOptions.persistentId = 1;
    let scbSceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
    let topContainerSession :SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProp);
    let mocker: MockKit = new MockKit();
    let mockGetTopContainerSessionFunction:Function =
      mocker.mockFunc(scbSceneSessionManager, scbSceneSessionManager.getContainerSessionList().getTopActiveSession);
    when(mockGetTopContainerSessionFunction)(ArgumentMatchers.any).afterReturn(topContainerSession);
    topContainerSession.isMidScene = false;
    sideEdgeBarManager.handleSwipe();
    expect(sideEdgeBarOptions.posX > -1000).assertTrue();
    mocker.clear(scbSceneSessionManager);
  });

  it('SCBSideEdgeBarManagerTest_handleSwipe_04', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.HIDDEN;
    sideEdgeBarOptions.persistentId = 1;
    sideEdgeBarOptions.posX = 100;
    sideEdgeBarOptions.posY = 100;
    let scbSceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
    let mocker: MockKit = new MockKit();
    let mockGetTopContainerSessionFunction:Function =
      mocker.mockFunc(scbSceneSessionManager, scbSceneSessionManager.getContainerSessionList().getTopActiveSession);
    when(mockGetTopContainerSessionFunction)(ArgumentMatchers.any).afterReturn(null);
    sideEdgeBarManager.handleSwipe();
    expect(sideEdgeBarOptions.posX > -1000).assertTrue();
    mocker.clear(scbSceneSessionManager);
  });
}

function SCBSideEdgeBarTest_handleClick() {
  it('SCBSideEdgeBarManagerTest_handleClick', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.persistentId = 123;
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.SHOW;
    sideEdgeBarOptions.posX = 100;
    sideEdgeBarOptions.posY = 100;
    sideEdgeBarManager.handleClick();
    expect(sideEdgeBarOptions.posX > -1000).assertTrue();
  });
  it('SCBSideEdgeBarManagerTest_handleClick_02', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.persistentId = 123;
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.SHOW;
    sideEdgeBarOptions.posX = 100;
    sideEdgeBarOptions.posY = 100;
    let scbSceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
    let topContainerSession :SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProp);
    topContainerSession.isMidScene = true;
    let mocker: MockKit = new MockKit();
    let mockGetTopContainerSessionFunction:Function =
      mocker.mockFunc(scbSceneSessionManager, scbSceneSessionManager.getContainerSessionList()?.getTopActiveSession);
    when(mockGetTopContainerSessionFunction)(ArgumentMatchers.any).afterReturn(topContainerSession);
    sideEdgeBarManager.handleClick();
    expect(sideEdgeBarOptions.posX === 100).assertTrue();
    mocker.clear(scbSceneSessionManager);
  });
  it('SCBSideEdgeBarManagerTest_handleClick_03', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.persistentId = 1;
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.HIDDEN;
    sideEdgeBarOptions.posX = 100;
    sideEdgeBarOptions.posY = 100;
    let topContainerSession :SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProp);
    topContainerSession.isMidScene = false;
    let scbSceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
    let mocker: MockKit = new MockKit();
    let mockGetTopContainerSessionFunction:Function =
      mocker.mockFunc(scbSceneSessionManager, scbSceneSessionManager.getContainerSessionList()?.getTopActiveSession);
    when(mockGetTopContainerSessionFunction)(ArgumentMatchers.any).afterReturn(topContainerSession);
    sideEdgeBarManager.handleClick();
    expect(sideEdgeBarOptions.posY === 100).assertTrue();
    mocker.clear(scbSceneSessionManager);
  });
  it('SCBSideEdgeBarManagerTest_handleClick_04', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.persistentId = 147;
    sideEdgeBarOptions.posX = 100;
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.HIDDEN;
    sideEdgeBarOptions.posY = 100;
    let scbSceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
    let mocker: MockKit = new MockKit();
    let mockGetTopContainerSessionFunction:Function =
      mocker.mockFunc(scbSceneSessionManager, scbSceneSessionManager.getContainerSessionList()?.getTopActiveSession);
    when(mockGetTopContainerSessionFunction)(ArgumentMatchers.any).afterReturn(null);
    sideEdgeBarManager.handleClick();
    expect(sideEdgeBarOptions.persistentId === 147).assertTrue();
    mocker.clear(scbSceneSessionManager);
  });
}

function SCBSideEdgeBarTest_destroySidebarIfNeed() {
  it('SCBSideEdgeBarManagerTest_destroySidebarIfNeed', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.persistentId = 1;
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.HIDDEN;
    sideEdgeBarManager.destroySidebarIfNeed(1);
    expect(sideEdgeBarOptions.posX > -1000).assertTrue();
    sideEdgeBarManager.destroySidebarIfNeed(3);
    let viewController = viewMgrPolicy.getViewController(ViewType.SIDE_EDGE_BAR) as BaseViewController;
    expect(viewController.visible).assertTrue();
  });
}

function SCBSideEdgeBarTest_destroySidebarByCleanAll() {
  it('SCBSideEdgeBarManagerTest_destroySidebarByCleanAll', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.persistentId = 1;
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.HIDDEN;
    sideEdgeBarManager.destroySidebarByCleanAll();
    expect(sideEdgeBarOptions.posX > -1000).assertTrue();
    let viewController = viewMgrPolicy.getViewController(ViewType.SIDE_EDGE_BAR) as BaseViewController;
    expect(viewController.visible).assertFalse();
  });
}

function SCBSideEdgeBarTest_destroySidebarWhenQuitFullSceneMode() {
  it('SCBSideEdgeBarManagerTest_destroySidebarWhenQuitFullSceneMode', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    let instance: SCBScenePanelManager = SCBScenePanelManager.getInstance();
    let mocker: MockKit = new MockKit();
    let mockFunc1: Function = mocker.mockFunc(instance, instance.getFloatingSessionList);
    when(mockFunc1)().afterReturn(containerSessionList);
    sideEdgeBarOptions.persistentId = -1000;
    sideEdgeBarManager.destroySidebarWhenQuitFullSceneMode();
    sideEdgeBarOptions.persistentId = -1;
    sideEdgeBarManager.destroySidebarWhenQuitFullSceneMode();
    sideEdgeBarOptions.persistentId = sceneSession.session.persistentId;
    sideEdgeBarManager.destroySidebarWhenQuitFullSceneMode();
    expect(containerSession.isActive).assertTrue();
    mocker.clear(instance);
  });
}

function SCBSideEdgeBarTest_destroySidebarAndExitSessionIfNeed() {
  it('SCBSideEdgeBarManagerTest_destroySidebarAndExitSessionIfNeed', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.HIDDEN;
    sideEdgeBarOptions.persistentId = sceneSession.session.persistentId;
    sideEdgeBarManager.destroySidebarAndExitSessionIfNeed(sceneSession);
    expect(sideEdgeBarOptions.persistentId === -1).assertTrue();
    expect(sceneSession.isActive).assertFalse();
    sideEdgeBarOptions.persistentId = sceneSession.session.persistentId + 1;
    sideEdgeBarManager.destroySidebarAndExitSessionIfNeed(sceneSession);
    expect(sceneSession.isActive).assertTrue();
  });
}

function SCBSideEdgeBarTest_showSideEdgeBar() {
  it('SCBSideEdgeBarManagerTest_showSideEdgeBar', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.persistentId = -123;
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.NONE;
    sideEdgeBarManager.showSideEdgeBar();
    sideEdgeBarOptions.persistentId = 100;
    sideEdgeBarManager.showSideEdgeBar();
    expect(sideEdgeBarOptions.persistentId === 100).assertTrue();
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.HIDDEN;
    sideEdgeBarOptions.persistentId = 1;
    sideEdgeBarManager.receivedUnLocked();
    sideEdgeBarManager.showSideEdgeBar();
    expect(sideEdgeBarOptions.persistentId === 1).assertTrue();
    let viewController = viewMgrPolicy.getViewController(ViewType.SIDE_EDGE_BAR) as BaseViewController;
    expect(viewController.visible).assertTrue();
  });
}

function SCBSideEdgeBarTest_hideSideEdgeBar() {
  it('SCBSideEdgeBarManagerTest_hideSideEdgeBar', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.persistentId = 987;
    sideEdgeBarManager.hideSideEdgeBar();
    expect(sideEdgeBarOptions.persistentId === 987).assertTrue();
    let viewController = viewMgrPolicy.getViewController(ViewType.SIDE_EDGE_BAR) as BaseViewController;
    expect(viewController.visible).assertFalse();
  });
}

function SCBSideEdgeBarTest_notifyScreenPropertyChange() {
  it('SCBSideEdgeBarManagerTest_notifyScreenPropertyChange', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.persistentId = 123;
    sideEdgeBarOptions.posX = 500;
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.HIDDEN;
    sideEdgeBarManager.notifyScreenPropertyChange(screenProp, SCBPropertyChangeReason.FOLD_TO_EXPAND);
    expect(sideEdgeBarOptions.persistentId === 123).assertTrue();
    sideEdgeBarOptions.persistentId = 456;
    sideEdgeBarOptions.posX = -147;
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.HIDDEN;
    sideEdgeBarManager.notifyScreenPropertyChange(screenProp, SCBPropertyChangeReason.FOLD_TO_EXPAND);
    expect(sideEdgeBarOptions.persistentId === 456).assertTrue();
    sideEdgeBarManager.notifyScreenPropertyChange(screenProp, SCBPropertyChangeReason.UNDEFINED);
    expect(sideEdgeBarOptions.displayState === SCBSideEdgeBarDisplayState.HIDDEN).assertTrue();
  });
}

function SCBSideEdgeBarTest_isInSideBar() {
  it('SCBSideEdgeBarManagerTest_isInSideBar', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.persistentId = sceneSession.session.persistentId;
    let isInSideBar = sideEdgeBarManager.isInSideBar(sceneSession);
    expect(sideEdgeBarOptions.posX === 0).assertTrue();
    expect(isInSideBar).assertTrue();
    sideEdgeBarOptions.persistentId = sceneSession.session.persistentId + 1;
    isInSideBar = sideEdgeBarManager.isInSideBar(sceneSession);
    expect(sideEdgeBarOptions.posX === 0).assertTrue();
    expect(isInSideBar).assertFalse();
    isInSideBar = sideEdgeBarManager.isInSideBar(null);
    expect(isInSideBar).assertFalse();
    expect(sideEdgeBarOptions.posX === 0).assertTrue();
  });
}

function SCBSideEdgeBarTest_lock() {
  it('SCBSideEdgeBarManagerTest_receivedUnLocked', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.SHOW;
    sideEdgeBarOptions.persistentId = 111;
    sideEdgeBarManager.receivedUnLocked();
    let viewController = viewMgrPolicy.getViewController(ViewType.SIDE_EDGE_BAR) as BaseViewController;
    expect(sideEdgeBarOptions.persistentId === 111).assertTrue();
    expect(viewController.visible).assertTrue();
  });

  it('SCBSideEdgeBarManagerTest_receivedLocked', Level.LEVEL0, (): void => {
    let sideEdgeBarOptions = sideEdgeBarManager.getSideEdgeBarOptions();
    sideEdgeBarOptions.displayState = SCBSideEdgeBarDisplayState.HIDDEN;
    sideEdgeBarOptions.persistentId = 111;
    sideEdgeBarManager.receivedLocked();
    let viewController = viewMgrPolicy.getViewController(ViewType.SIDE_EDGE_BAR) as BaseViewController;
    expect(sideEdgeBarOptions.persistentId === 111).assertTrue();
    expect(viewController.visible).assertFalse();
  });
}