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

import { AppStorageUtil, TraceUtil } from '@ohos/basicutils';
import {
  DeviceHelper,
  GlobalSearchStatus,
  IconResourceManager,
  localEventManager,
  sOutSideWindowMgr,
  viewMgrPolicy,
  ViewType
} from '@ohos/frameworkwrapper';
import { ScenePanelState } from '@ohos/windowscene';
import { afterAll, afterEach,
  ArgumentMatchers,
  beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium'
import {
  AppModel,
  folderLayoutUtil,
  GridLayoutItemInfo,
  launcherAbilityManager,
  RdbStoreManager,
  SwiperLoadManager } from '@ohos/launchercommon/src/main/ets/TsIndex'
import { SCBDesktopViewModel } from '@ohos/phonebase/src/main/ets/SceneBoard/systemscene/viewmodel/SCBDesktopViewModel'
import SmartDockModel from '@ohos/smartdock/src/main/ets/default/model/SmartDockModel';
import { PageDesktopViewModel } from '@ohos/pagedesktop'

export function SCBDesktopViewModelTest() {
  describe('SCBDesktopViewModelTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterAll((): void => {
    })

    afterEach((): void => {
    })

    it('test_initFirstPage', 0, () => {
      let desktopViewModelTest: SCBDesktopViewModel = SCBDesktopViewModel.getInstance();
      let userId: number = 1;
      launcherAbilityManager.setCurrentUserId(userId);
      desktopViewModelTest.initFirstPage();
      expect(desktopViewModelTest !== undefined).assertTrue();
    });

    it("getInstance", 0, async(done:Function) => {
      SCBDesktopViewModel.getInstance();
      let desktopViewModelTest: SCBDesktopViewModel = SCBDesktopViewModel.getInstance();
      expect(desktopViewModelTest).not().assertUndefined();
      done();
    })

    it("changeToLoadDesktop1", 0, async(done:Function) => {
      let desktopViewModelTest: SCBDesktopViewModel = SCBDesktopViewModel.getInstance();
      await desktopViewModelTest.changeToLoadDesktop();
      expect(desktopViewModelTest['mDesktopLoader']).not().assertEqual(undefined);
      done();
    })

    it("changeToLoadDesktop2", 0, async(done:Function) => {
      let desktopViewModelTest: SCBDesktopViewModel = SCBDesktopViewModel.getInstance();
      desktopViewModelTest.updateDesktopModel(1)
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(desktopViewModelTest, desktopViewModelTest['refreshDesktopData']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(desktopViewModelTest['mDesktopLoader'], desktopViewModelTest['mDesktopLoader'].loadDesktopLayout);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));
      let mockFunction2: Function =
        mocker.mockFunc(desktopViewModelTest, desktopViewModelTest['refreshDockData']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(Promise.resolve());
      let mockFunction3: Function =
        mocker.mockFunc(localEventManager, localEventManager.sendLocalEventSticky);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      await desktopViewModelTest.changeToLoadDesktop();
      expect(desktopViewModelTest['mDesktopLoader']).not().assertEqual(undefined);
      mocker.clear(desktopViewModelTest);
      mocker.clear(desktopViewModelTest['mDesktopLoader']);
      mocker.clear(localEventManager);
      mocker.clearAll();
      done();
    })

    it("changeToLoadDesktop3", 0, async(done:Function) => {
      let desktopViewModelTest: SCBDesktopViewModel = SCBDesktopViewModel.getInstance();
      desktopViewModelTest.updateDesktopModel(1)
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(desktopViewModelTest, desktopViewModelTest['refreshDesktopData']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(desktopViewModelTest['mDesktopLoader'], desktopViewModelTest['mDesktopLoader'].loadDesktopLayout);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));
      let mockFunction2: Function =
        mocker.mockFunc(desktopViewModelTest['mDesktopLoader'], desktopViewModelTest['mDesktopLoader'].loadPageCount);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(Promise.resolve(1));
      let mockFunction3: Function =
        mocker.mockFunc(desktopViewModelTest['mPageDesktopLayoutConfig'], desktopViewModelTest['mPageDesktopLayoutConfig'].loadDataFromConfiguration);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction4: Function =
        mocker.mockFunc(desktopViewModelTest, desktopViewModelTest['refreshDockData']);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(Promise.resolve());
      await desktopViewModelTest.changeToLoadDesktop();
      expect(desktopViewModelTest['mDesktopLoader']).not().assertEqual(undefined);
      mocker.clear(desktopViewModelTest);
      mocker.clear(desktopViewModelTest['mDesktopLoader']);
      mocker.clear(desktopViewModelTest['mPageDesktopLayoutConfig']);
      mocker.clearAll();
      done();
    })

    it("refreshDockData", 0, async(done:Function) => {
      let desktopViewModelTest: SCBDesktopViewModel = SCBDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(SmartDockModel.getInstance(), SmartDockModel.getInstance()['setResetDock']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(SmartDockModel.getInstance(), SmartDockModel.getInstance()['reSetDockCenter']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(SmartDockModel.getInstance(), SmartDockModel.getInstance()['clearResidentList']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction3: Function =
        mocker.mockFunc(SmartDockModel.getInstance(), SmartDockModel.getInstance()['getResidentList']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(Promise.resolve());
      let mockFunction4: Function =
        mocker.mockFunc(folderLayoutUtil, folderLayoutUtil.initFolderLayoutConfig);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(undefined);
      await desktopViewModelTest['refreshDockData'];
      expect(desktopViewModelTest).not().assertEqual(undefined);
      mocker.clear(SmartDockModel.getInstance());
      mocker.clear(folderLayoutUtil);
      mocker.clearAll();
      done();
    })

    it("refreshDesktopData1", 0, async(done:Function) => {
      let desktopViewModelTest: SCBDesktopViewModel = SCBDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(SwiperLoadManager.getInstance(), SwiperLoadManager.getInstance()['clearSwiperPages']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(PageDesktopViewModel.getInstance(), PageDesktopViewModel.getInstance()['initAfterModelChange']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      expect(desktopViewModelTest).not().assertEqual(undefined);
      mocker.clear(SwiperLoadManager.getInstance());
      mocker.clear(DeviceHelper);
      mocker.clear(PageDesktopViewModel.getInstance());
      mocker.clearAll();
      done();
    })

    it("refreshDesktopData2", 0, async(done:Function) => {
      let desktopViewModelTest: SCBDesktopViewModel = SCBDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(SwiperLoadManager.getInstance(), SwiperLoadManager.getInstance()['clearSwiperPages']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(PageDesktopViewModel.getInstance(), PageDesktopViewModel.getInstance()['initAfterModelChange']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      expect(desktopViewModelTest).not().assertEqual(undefined);
      mocker.clear(SwiperLoadManager.getInstance());
      mocker.clear(DeviceHelper);
      mocker.clear(PageDesktopViewModel.getInstance());
      mocker.clearAll();
      done();
    })

    it("screenChangeRotationNoAnim1", 0, async(done:Function) => {
      let desktopViewModelTest: SCBDesktopViewModel = SCBDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(AppStorageUtil,AppStorageUtil.setOrCreate);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(desktopViewModelTest,desktopViewModelTest['isPadUiType']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction2: Function =
        mocker.mockFunc(PageDesktopViewModel.getInstance(), PageDesktopViewModel.getInstance()['changeCurrentLayoutCache']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction3: Function =
        mocker.mockFunc(localEventManager,localEventManager.sendLocalEventSticky);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction4: Function =
        mocker.mockFunc(desktopViewModelTest,desktopViewModelTest['closeFolderImmediately']);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(undefined);
      expect(desktopViewModelTest).not().assertEqual(undefined);
      mocker.clear(AppStorageUtil);
      mocker.clear(desktopViewModelTest);
      mocker.clear(PageDesktopViewModel.getInstance());
      mocker.clear(localEventManager);
      mocker.clearAll();
      done();
    })

    it("screenChangeRotationNoAnim2", 0, async(done:Function) => {
      let desktopViewModelTest: SCBDesktopViewModel = SCBDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(AppStorageUtil,AppStorageUtil.setOrCreate);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(desktopViewModelTest,desktopViewModelTest['isPadUiType']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction2: Function =
        mocker.mockFunc(PageDesktopViewModel.getInstance(), PageDesktopViewModel.getInstance()['changeCurrentLayoutCache']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction3: Function =
        mocker.mockFunc(localEventManager,localEventManager.sendLocalEventSticky);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction4: Function =
        mocker.mockFunc(desktopViewModelTest,desktopViewModelTest['closeFolderImmediately']);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(undefined);
      expect(desktopViewModelTest).not().assertEqual(undefined);
      mocker.clear(AppStorageUtil);
      mocker.clear(desktopViewModelTest);
      mocker.clear(PageDesktopViewModel.getInstance());
      mocker.clear(localEventManager);
      mocker.clearAll();
      done();
    })

    it("screenChangeRotationNoAnimTest", 0, async(done:Function) => {
      let desktopViewModelTest: SCBDesktopViewModel = SCBDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let appStorageFunction: Function = mocker.mockFunc(AppStorage, AppStorage.setOrCreate);
      let isPadUiTypeFunction: Function =
        mocker.mockFunc(desktopViewModelTest,desktopViewModelTest['isPadUiType']);
      let changeCurrentLayoutCacheFunction: Function =
        mocker.mockFunc(PageDesktopViewModel.getInstance(), PageDesktopViewModel.getInstance()['changeCurrentLayoutCache']);
      let localEventManagerFunction: Function =
        mocker.mockFunc(localEventManager,localEventManager.sendLocalEventSticky);
      let closeFolderImmediatelyFunction: Function =
        mocker.mockFunc(desktopViewModelTest,desktopViewModelTest['closeFolderImmediately']);
      when(appStorageFunction)(ArgumentMatchers.any).afterReturn(undefined);
      when(localEventManagerFunction)(ArgumentMatchers.any).afterReturn(undefined);
      when(changeCurrentLayoutCacheFunction)(ArgumentMatchers.any).afterReturn(undefined);
      when(closeFolderImmediatelyFunction)(ArgumentMatchers.any).afterReturn(undefined);
      when(isPadUiTypeFunction)(ArgumentMatchers.any).afterReturn(false);
      desktopViewModelTest.screenChangeRotationNoAnim(false,true);
      desktopViewModelTest.screenChangeRotationNoAnim(false,false);
      when(isPadUiTypeFunction)(ArgumentMatchers.any).afterReturn(true);
      desktopViewModelTest.screenChangeRotationNoAnim(false,true);
      desktopViewModelTest.screenChangeRotationNoAnim(false,false);
      expect(desktopViewModelTest).not().assertEqual(undefined);
      mocker.clear(AppStorage);
      mocker.clear(desktopViewModelTest);
      mocker.clear(PageDesktopViewModel.getInstance());
      mocker.clear(localEventManager);
      mocker.clearAll();
      done();
    })

    it("isPadUiType", 0, async(done:Function) => {
      let desktopViewModelTest: SCBDesktopViewModel = SCBDesktopViewModel.getInstance();
      let result = desktopViewModelTest.isPadUiType();
      expect(result).assertEqual(false);
      done();
    })

    it("singleDisplaySwitch1", 0, async(done:Function) => {
      let desktopViewModelTest: SCBDesktopViewModel = SCBDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      desktopViewModelTest['singleDisplaySwitch']();
      expect(desktopViewModelTest).not().assertEqual(undefined);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
      done();
    })

    it("singleDisplaySwitch2", 0, async(done:Function) => {
      let desktopViewModelTest: SCBDesktopViewModel = SCBDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function =
        mocker.mockFunc(AppStorage,AppStorage.get);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction2: Function =
        mocker.mockFunc(localEventManager,localEventManager.sendLocalEvent);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      desktopViewModelTest['singleDisplaySwitch']();
      expect(desktopViewModelTest).not().assertEqual(undefined);
      mocker.clear(DeviceHelper);
      mocker.clear(AppStorage);
      mocker.clear(localEventManager);
      mocker.clearAll();
      done();
    })

    it("singleDisplaySwitch3", 0, async(done:Function) => {
      let desktopViewModelTest: SCBDesktopViewModel = SCBDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function =
        mocker.mockFunc(AppStorage,AppStorage.get);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction2: Function =
        mocker.mockFunc(localEventManager,localEventManager.sendLocalEvent);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      desktopViewModelTest['singleDisplaySwitch']();
      expect(desktopViewModelTest).not().assertEqual(undefined);
      mocker.clear(DeviceHelper);
      mocker.clear(AppStorage);
      mocker.clear(localEventManager);
      mocker.clearAll();
      done();
    })

    it("skipFoldExpandAnimation1", 0, async(done:Function) => {
      let desktopViewModelTest: SCBDesktopViewModel = SCBDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(viewMgrPolicy,viewMgrPolicy.isViewShowing);
      when(mockFunction)(ViewType.KEYGUARD).afterReturn(true);
      let result = desktopViewModelTest.skipFoldExpandAnimation(1);
      expect(result).assertEqual(true);
      mocker.clear(viewMgrPolicy);
      mocker.clearAll();
      done();
    })

    it("skipFoldExpandAnimation2", 0, async(done:Function) => {
      let desktopViewModelTest: SCBDesktopViewModel = SCBDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(viewMgrPolicy,viewMgrPolicy.isViewShowing);
      when(mockFunction)(ViewType.KEYGUARD).afterReturn(false);
      let result = desktopViewModelTest.skipFoldExpandAnimation(ScenePanelState.FULLSCENE);
      expect(result).assertEqual(true);
      mocker.clear(viewMgrPolicy);
      mocker.clearAll();
      done();
    })

    it("skipFoldExpandAnimation3", 0, async(done:Function) => {
      let desktopViewModelTest: SCBDesktopViewModel = SCBDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(viewMgrPolicy,viewMgrPolicy.isViewShowing);
      when(mockFunction)(ViewType.KEYGUARD).afterReturn(false);
      let mockFunction1: Function =
        mocker.mockFunc(viewMgrPolicy,viewMgrPolicy.isViewShowing);
      when(mockFunction1)(ViewType.NEGATIVE_SCREEN).afterReturn(true);
      let mockFunction2: Function =
        mocker.mockFunc(sOutSideWindowMgr,sOutSideWindowMgr.isShowNegative);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(true);
      let result = desktopViewModelTest.skipFoldExpandAnimation(ScenePanelState.HOME);
      expect(result).assertEqual(true);
      mocker.clear(viewMgrPolicy);
      mocker.clear(sOutSideWindowMgr);
      mocker.clearAll();
      done();
    })

    it("skipFoldExpandAnimation4", 0, async(done:Function) => {
      let desktopViewModelTest: SCBDesktopViewModel = SCBDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(viewMgrPolicy,viewMgrPolicy.isViewShowing);
      when(mockFunction)(ViewType.KEYGUARD).afterReturn(false);
      let mockFunction1: Function =
        mocker.mockFunc(viewMgrPolicy,viewMgrPolicy.isViewShowing);
      when(mockFunction1)(ViewType.NEGATIVE_SCREEN).afterReturn(false);
      let mockFunction2: Function =
        mocker.mockFunc(sOutSideWindowMgr,sOutSideWindowMgr.isShowNegative);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(false);
      let result = desktopViewModelTest.skipFoldExpandAnimation(ScenePanelState.HOME);
      expect(result).assertEqual(false);
      mocker.clear(viewMgrPolicy);
      mocker.clear(sOutSideWindowMgr);
      mocker.clearAll();
      done();
    })

    it("skipFoldExpandAnimation5", 0, async(done:Function) => {
      let desktopViewModelTest: SCBDesktopViewModel = SCBDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(viewMgrPolicy,viewMgrPolicy.isViewShowing);
      when(mockFunction)(ViewType.KEYGUARD).afterReturn(false);
      let mockFunction1: Function =
        mocker.mockFunc(viewMgrPolicy,viewMgrPolicy.isViewShowing);
      when(mockFunction1)(ViewType.NEGATIVE_SCREEN).afterReturn(false);
      let mockFunction2: Function =
        mocker.mockFunc(sOutSideWindowMgr,sOutSideWindowMgr.isShowNegative);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction3: Function =
        mocker.mockFunc(sOutSideWindowMgr,sOutSideWindowMgr.getGlobalSearchStatus);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(GlobalSearchStatus.HIDE);
      let mockFunction4: Function =
        mocker.mockFunc(viewMgrPolicy,viewMgrPolicy.isViewShowing);
      when(mockFunction4)(ViewType.GLOBAL_SEARCH).afterReturn(true);
      let result = desktopViewModelTest.skipFoldExpandAnimation(ScenePanelState.HOME);
      expect(result).assertEqual(true);
      mocker.clear(viewMgrPolicy);
      mocker.clear(sOutSideWindowMgr);
      mocker.clearAll();
      done();
    })

    it("skipFoldExpandAnimation6", 0, async(done:Function) => {
      let desktopViewModelTest: SCBDesktopViewModel = SCBDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(viewMgrPolicy,viewMgrPolicy.isViewShowing);
      when(mockFunction)(ViewType.KEYGUARD).afterReturn(false);
      let mockFunction1: Function =
        mocker.mockFunc(viewMgrPolicy,viewMgrPolicy.isViewShowing);
      when(mockFunction1)(ViewType.NEGATIVE_SCREEN).afterReturn(false);
      let mockFunction2: Function =
        mocker.mockFunc(sOutSideWindowMgr,sOutSideWindowMgr.isShowNegative);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction3: Function =
        mocker.mockFunc(sOutSideWindowMgr,sOutSideWindowMgr.getGlobalSearchStatus);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(GlobalSearchStatus.BACK_OUT);
      let mockFunction4: Function =
        mocker.mockFunc(viewMgrPolicy,viewMgrPolicy.isViewShowing);
      when(mockFunction4)(ViewType.GLOBAL_SEARCH).afterReturn(false);
      let result = desktopViewModelTest.skipFoldExpandAnimation(ScenePanelState.HOME);
      expect(result).assertEqual(false);
      mocker.clear(viewMgrPolicy);
      mocker.clear(sOutSideWindowMgr);
      mocker.clearAll();
      done();
    })

    it("initFirstPage1", 0, async(done:Function) => {
      let desktopViewModelTest: SCBDesktopViewModel = SCBDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(AppModel.getInstance(),AppModel.getInstance().getUserId);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(10);
      let mockFunction1: Function =
        mocker.mockFunc(TraceUtil,TraceUtil.startTrace);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(TraceUtil,TraceUtil.endTrace);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction3: Function =
        mocker.mockFunc(RdbStoreManager.getInstance(),RdbStoreManager.getInstance().queryFirstPageAndDockApplication);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(Promise.resolve([]));
      await desktopViewModelTest.initFirstPage();
      expect(desktopViewModelTest).not().assertEqual(undefined);
      mocker.clear(AppModel.getInstance());
      mocker.clear(TraceUtil);
      mocker.clear(RdbStoreManager.getInstance());
      mocker.clearAll();
      done();
    })

    it("initFirstPage2", 0, async(done:Function) => {
      let desktopViewModelTest: SCBDesktopViewModel = SCBDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(AppModel.getInstance(),AppModel.getInstance().getUserId);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(10);
      let mockFunction1: Function =
        mocker.mockFunc(TraceUtil,TraceUtil.startTrace);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(TraceUtil,TraceUtil.endTrace);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      let grid = new GridLayoutItemInfo()
      grid.bundleName = 'bundleName';
      grid.moduleName = 'moduleName';
      grid.abilityName = 'abilityName';
      let mockFunction3: Function =
        mocker.mockFunc(RdbStoreManager.getInstance(),RdbStoreManager.getInstance().queryFirstPageAndDockApplication);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(Promise.resolve([grid,grid]));
      let mockFunction4: Function =
        mocker.mockFunc(IconResourceManager.getInstance(),IconResourceManager.getInstance().getCombIcon);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(undefined);
      await desktopViewModelTest.initFirstPage();
      expect(desktopViewModelTest).not().assertEqual(undefined);
      mocker.clear(AppModel.getInstance());
      mocker.clear(TraceUtil);
      mocker.clear(RdbStoreManager.getInstance());
      mocker.clear(IconResourceManager.getInstance());
      mocker.clearAll();
      done();
    })

    it("initFirstPage3", 0, async(done:Function) => {
      let desktopViewModelTest: SCBDesktopViewModel = SCBDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(AppModel.getInstance(),AppModel.getInstance().getUserId);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(10);
      let mockFunction1: Function =
        mocker.mockFunc(TraceUtil,TraceUtil.startTrace);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(TraceUtil,TraceUtil.endTrace);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      let grid = new GridLayoutItemInfo()
      grid.bundleName = 'bundleName';
      grid.moduleName = 'moduleName';
      grid.abilityName = 'abilityName';
      let mockFunction3: Function =
        mocker.mockFunc(RdbStoreManager.getInstance(),RdbStoreManager.getInstance().queryFirstPageAndDockApplication);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(Promise.resolve([grid,grid]));
      let mockFunction4: Function =
        mocker.mockFunc(IconResourceManager.getInstance(),IconResourceManager.getInstance().getCombIcon);
      when(mockFunction4)(ArgumentMatchers.any).afterThrow('error');
      await desktopViewModelTest.initFirstPage();
      expect(desktopViewModelTest).not().assertEqual(undefined);
      mocker.clear(AppModel.getInstance());
      mocker.clear(TraceUtil);
      mocker.clear(RdbStoreManager.getInstance());
      mocker.clear(IconResourceManager.getInstance());
      mocker.clearAll();
      done();
    })
  })
}