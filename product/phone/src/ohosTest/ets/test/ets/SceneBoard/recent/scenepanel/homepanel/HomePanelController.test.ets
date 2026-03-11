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
import { FSM, SCBScenePanelManager, SCBScreenProperty } from '@ohos/windowscene';
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
import { HomePanelController } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/homepanel/HomePanelController';
import screenSessionManager from '@ohos.screenSessionManager';
import { DesktopMode, ViewManager, HiEditModeDataEnterType, HiEditModeDataExitType } from '@ohos/launchercommon';
import { sOutSideWindowMgr } from '@ohos/frameworkwrapper';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import { editModeManager } from '@ohos/launchercommon/src/main/ets/editmode/model/EditModeManager';

export default function HomePanelControllerTest() {
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
  let scbScenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
  let viewManager = ViewManager.getInstance();
  let sceneSessionManager = SCBSceneSessionManager.getInstance();
  let homePanelController: HomePanelController = new HomePanelController();

  describe('HomePanelControllerTest', () => {
    beforeAll(() => {

    })
    beforeEach(() => {

    })
    afterEach(() => {

    })
    afterAll(() => {

    })

    it('HomePanelController_enterFirstHomePage_01', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isDesktopNeedProcessGesture: Function = mocker.mockFunc(viewManager, viewManager.isDesktopNeedProcessGesture);
      when(isDesktopNeedProcessGesture)(ArgumentMatchers.any).afterReturn(true);
      let isShowGlobalSearch: Function = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      when(isShowGlobalSearch)(ArgumentMatchers.any).afterReturn(true);
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      let mockFunc1 : Function = mocker.mockFunc(manager, manager.isDesktopNeedProcessFloatWindow);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc2 : Function = mocker.mockFunc(manager, manager.getSystemSceneSessionWithId);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      let res = manager.processSystemBackEvent();
      expect(res).assertFalse();
      mocker.ignoreMock(manager, manager.isDesktopNeedProcessFloatWindow);
      editModeManager.changeDesktopMode(DesktopMode.EDIT_MODE, HiEditModeDataEnterType.ENTER_PINCH);
      homePanelController.enterFirstHomePage(0);
      mocker.ignoreMock(viewManager, viewManager.isDesktopNeedProcessGesture);
      mocker.ignoreMock(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      mocker.ignoreMock(manager, manager.isDesktopNeedProcessFloatWindow);
      mocker.ignoreMock(manager, manager.getSystemSceneSessionWithId);
      expect(homePanelController).not().assertNull();
    })

    it('HomePanelController_enterFirstHomePage_01_2', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isDesktopNeedProcessGesture: Function = mocker.mockFunc(viewManager, viewManager.isDesktopNeedProcessGesture);
      when(isDesktopNeedProcessGesture)(ArgumentMatchers.any).afterReturn(true);
      let isShowGlobalSearch: Function = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      when(isShowGlobalSearch)(ArgumentMatchers.any).afterReturn(true);
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      let mockFunc1 : Function = mocker.mockFunc(manager, manager.isDesktopNeedProcessFloatWindow);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      let res = manager.processSystemBackEvent();
      expect(res).assertFalse();
      mocker.ignoreMock(manager, manager.isDesktopNeedProcessFloatWindow);
      editModeManager.changeDesktopMode(DesktopMode.EDIT_MODE, HiEditModeDataEnterType.ENTER_PINCH);
      homePanelController.enterFirstHomePage(0);
      mocker.ignoreMock(viewManager, viewManager.isDesktopNeedProcessGesture);
      mocker.ignoreMock(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      mocker.ignoreMock(manager, manager.isDesktopNeedProcessFloatWindow);
      expect(homePanelController).not().assertNull();
    })

    it('HomePanelController_enterFirstHomePage_02', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isDesktopNeedProcessGesture: Function = mocker.mockFunc(viewManager, viewManager.isDesktopNeedProcessGesture);
      when(isDesktopNeedProcessGesture)(ArgumentMatchers.any).afterReturn(true);
      let isShowGlobalSearch: Function = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      when(isShowGlobalSearch)(ArgumentMatchers.any).afterReturn(false);
      editModeManager.changeDesktopMode(DesktopMode.NORMAL_MODE, HiEditModeDataExitType.EXIT_FULLY_OCCLUSION);
      homePanelController.enterFirstHomePage(0);
      mocker.ignoreMock(viewManager, viewManager.isDesktopNeedProcessGesture);
      mocker.ignoreMock(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      expect(homePanelController).not().assertNull();
    })

    it('HomePanelController_enterFirstHomePage_03', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isDesktopNeedProcessGesture: Function = mocker.mockFunc(viewManager, viewManager.isDesktopNeedProcessGesture);
      when(isDesktopNeedProcessGesture)(ArgumentMatchers.any).afterReturn(false);
      let isShowGlobalSearch: Function = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      when(isShowGlobalSearch)(ArgumentMatchers.any).afterReturn(false);
      editModeManager.changeDesktopMode(DesktopMode.NORMAL_MODE, HiEditModeDataExitType.EXIT_FULLY_OCCLUSION);
      let processSystemHomeEvent: Function = mocker.mockFunc(sceneSessionManager, sceneSessionManager.processSystemHomeEvent);
      when(processSystemHomeEvent)(ArgumentMatchers.any).afterReturn(true);
      homePanelController.enterFirstHomePage(0);
      mocker.ignoreMock(viewManager, viewManager.isDesktopNeedProcessGesture);
      mocker.ignoreMock(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      mocker.ignoreMock(sceneSessionManager, sceneSessionManager.processSystemHomeEvent);
      expect(homePanelController).not().assertNull();
    })

    it('HomePanelController_enterFirstHomePage_04', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isDesktopNeedProcessGesture: Function = mocker.mockFunc(viewManager, viewManager.isDesktopNeedProcessGesture);
      when(isDesktopNeedProcessGesture)(ArgumentMatchers.any).afterReturn(false);
      let isShowGlobalSearch: Function = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      when(isShowGlobalSearch)(ArgumentMatchers.any).afterReturn(false);
      editModeManager.changeDesktopMode(DesktopMode.NORMAL_MODE, HiEditModeDataExitType.EXIT_FULLY_OCCLUSION);
      let processSystemHomeEvent: Function = mocker.mockFunc(sceneSessionManager, sceneSessionManager.processSystemHomeEvent);
      when(processSystemHomeEvent)(ArgumentMatchers.any).afterReturn(false);
      homePanelController.enterFirstHomePage(0);
      mocker.ignoreMock(viewManager, viewManager.isDesktopNeedProcessGesture);
      mocker.ignoreMock(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      mocker.ignoreMock(sceneSessionManager, sceneSessionManager.processSystemHomeEvent);
      expect(homePanelController).not().assertNull();
    })
  })
}