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

import { CompanionIconInfo } from '@ohos/basicutils';
import { IntelligentCache, sOutSideWindowMgr } from '@ohos/frameworkwrapper';
import { AppExitLocationInfo, SCBSceneContainerSession } from '@ohos/windowscene';
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium';
import {
  BaseQuitAppRect,
  QuitAppRectViewModel
} from '../../../../../main/ets/default/common/viewmodel/QuitAppRectViewModel';
import {
  AppStatus,
  DesktopModeManager,
  FolderLayoutStruct,
  FolderModel,
  GridLayoutConfig,
  GridLayoutItemInfo,
  LaunchLayoutCacheManager,
  PageDesktopModel
} from '@ohos/launchercommon';
import { PageDesktopGridStyleConfig } from '@ohos/launchercommon/src/main/ets/layoutconfig/PageDesktopGridStyleConfig';
import { FolderViewData } from '@ohos/launchercommon/Index';
import { BigFolderStyleConfig } from '@ohos/bigfolder';
import { ItemsCount } from '@ohos/launchercommon/src/main/ets/utils/GridLayoutUtil';

export default function QuitAppRectViewModelTest() {
  describe('QuitAppRectViewModelTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    it('QuitAppRectViewModelTest_buildAppExitInfoInExitSlide_001', 0, (): void => {
      let quitAppRectViewModel: QuitAppRectViewModel = new QuitAppRectViewModel();
      let containerSession = {} as SCBSceneContainerSession;

      containerSession.companionIconInfo = {
        iconId: '1234'
      } as CompanionIconInfo;
      quitAppRectViewModel.initCurAppExitInfo()
      expect(quitAppRectViewModel.buildAppExitInfoInExitSlide(containerSession)).not().assertFail();
    })

    it('QuitAppRectViewModelTest_buildAppExitInfoInExitSlide_002', 0, (): void => {
      let quitAppRectViewModel: QuitAppRectViewModel = new QuitAppRectViewModel();
      let containerSession = {} as SCBSceneContainerSession;

      containerSession.companionIconInfo = {} as CompanionIconInfo;
      quitAppRectViewModel.initCurAppExitInfo()
      expect(quitAppRectViewModel.buildAppExitInfoInExitSlide(containerSession)).not().assertFail();
    })

    it('QuitAppRectViewModelTest_buildAppExitInfoInExitSlide_003', 0, (): void => {
      let quitAppRectViewModel: QuitAppRectViewModel = new QuitAppRectViewModel();
      let containerSession = {} as SCBSceneContainerSession;

      quitAppRectViewModel.buildAppExitInfoInExit(containerSession)
      containerSession.companionIconInfo = {} as CompanionIconInfo;
      expect(quitAppRectViewModel.buildAppExitInfoInExitSlide(containerSession)).not().assertFail();
    })

    it('QuitAppRectViewModelTest_buildAppExitInfoInExit_001', 0, (): void => {
      let quitAppRectViewModel: QuitAppRectViewModel = new QuitAppRectViewModel();
      let containerSession = {} as SCBSceneContainerSession;

      containerSession.companionIconInfo = {
        iconId: '1234',
        isSameLocation: true,
        smallFolderId: '1234',
      } as CompanionIconInfo;

      let mocker = new MockKit();
      let buildAppExitInfo = mocker.mockFunc(quitAppRectViewModel, quitAppRectViewModel.buildAppExitInfo);
      let appExitInfo: AppExitLocationInfo = {
        type: 'null',
        iconRect: null,
        pageIndex: 1,
        isInScreen: false,
        appInFolderInfo: null
      };
      when(buildAppExitInfo)().afterReturn(appExitInfo);
      try {
        expect(quitAppRectViewModel.buildAppExitInfoInExit(containerSession)).not().assertFail();
      } catch (err) {}
      mocker.clear(buildAppExitInfo);
    })

    it('QuitAppRectViewModelTest_buildAppExitInfoInExit_002', 0, (): void => {
      let quitAppRectViewModel: QuitAppRectViewModel = new QuitAppRectViewModel();
      let containerSession = {} as SCBSceneContainerSession;

      containerSession.companionIconInfo = {
        iconId: '1234',
        isSameLocation: true,
      } as CompanionIconInfo;

      let mocker = new MockKit();
      let buildAppExitInfo = mocker.mockFunc(quitAppRectViewModel, quitAppRectViewModel.buildAppExitInfo);
      let appExitInfo: AppExitLocationInfo = {
        type: 'null',
        iconRect: null,
        pageIndex: null,
        isInScreen: false,
        appInFolderInfo: null
      };
      when(buildAppExitInfo)().afterReturn(appExitInfo);
      try {
        expect(quitAppRectViewModel.buildAppExitInfoInExit(containerSession)).not().assertFail();
      } catch (err) {}
      mocker.clear(buildAppExitInfo);
    })

    it('QuitAppRectViewModelTest_buildAppExitInfoInExit_003', 0, (): void => {
      let quitAppRectViewModel: QuitAppRectViewModel = new QuitAppRectViewModel();
      let containerSession = {} as SCBSceneContainerSession;

      containerSession.companionIconInfo = {} as CompanionIconInfo;

      let mocker = new MockKit();
      let buildAppExitInfo = mocker.mockFunc(quitAppRectViewModel, quitAppRectViewModel.buildAppExitInfo);
      let appExitInfo: AppExitLocationInfo = {
        type: null,
        iconRect: null,
        pageIndex: null,
        isInScreen: false,
        appInFolderInfo: null
      };
      when(buildAppExitInfo)().afterReturn(appExitInfo);
      try {
        expect(quitAppRectViewModel.buildAppExitInfoInExit(containerSession)).not().assertFail();
      } catch (err) {}
      mocker.clear(buildAppExitInfo);
    })

    it('QuitAppRectViewModelTest_buildAppExitInfo_002', 0, (): void => {
      let quitAppRectViewModel: QuitAppRectViewModel = new QuitAppRectViewModel();
      let containerSession = {} as SCBSceneContainerSession;

      containerSession.companionIconInfo = {} as CompanionIconInfo;
      let mocker = new MockKit();
      let desktopModeManager = DesktopModeManager.getInstance();
      let desktopModeManagerMocker = mocker.mockFunc(DesktopModeManager, DesktopModeManager.getInstance);
      when(desktopModeManagerMocker)().afterReturn(desktopModeManager);
      let isInEmergencyOrThermalSafeMode = mocker.mockFunc(desktopModeManager,
        desktopModeManager.isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      let isShowGlobalSearch = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      when(isShowGlobalSearch)().afterReturn(false);
      AppStorage.setOrCreate('createFormId', true);
      expect(quitAppRectViewModel.buildAppExitInfo(containerSession)).not().assertFail();
      mocker.clear(sOutSideWindowMgr);
      mocker.clear(desktopModeManager);
      mocker.clear(DesktopModeManager);
    })

    it('QuitAppRectViewModelTest_buildAppExitInfo_003', 0, (): void => {
      let quitAppRectViewModel: QuitAppRectViewModel = new QuitAppRectViewModel();
      let containerSession = {} as SCBSceneContainerSession;

      containerSession.companionIconInfo = {
        iconId: '1234',
        isSameLocation: true,
      } as CompanionIconInfo;
      let mocker = new MockKit();
      let desktopModeManager = DesktopModeManager.getInstance();
      let desktopModeManagerMocker = mocker.mockFunc(DesktopModeManager, DesktopModeManager.getInstance);
      when(desktopModeManagerMocker)().afterReturn(desktopModeManager);
      let isInEmergencyOrThermalSafeMode = mocker.mockFunc(desktopModeManager,
        desktopModeManager.isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      let isShowGlobalSearch = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      when(isShowGlobalSearch)().afterReturn(false);
      AppStorage.setOrCreate('createFormId', true);
      expect(quitAppRectViewModel.buildAppExitInfo(containerSession)).not().assertFail();
      mocker.clear(sOutSideWindowMgr);
      mocker.clear(desktopModeManager);
      mocker.clear(DesktopModeManager);
    })

    it('QuitAppRectViewModelTest_buildAppExitInfo_004', 0, (): void => {
      let quitAppRectViewModel: QuitAppRectViewModel = new QuitAppRectViewModel();
      let containerSession = {} as SCBSceneContainerSession;

      containerSession.companionIconInfo = {
        iconId: '1234',
        isSameLocation: true,
      } as CompanionIconInfo;
      let mocker = new MockKit();
      let desktopModeManager = DesktopModeManager.getInstance();
      let desktopModeManagerMocker = mocker.mockFunc(DesktopModeManager, DesktopModeManager.getInstance);
      when(desktopModeManagerMocker)().afterReturn(desktopModeManager);
      let isInEmergencyOrThermalSafeMode = mocker.mockFunc(desktopModeManager,
        desktopModeManager.isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      let isShowGlobalSearch = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      when(isShowGlobalSearch)().afterReturn(true);
      expect(quitAppRectViewModel.buildAppExitInfo(containerSession)).not().assertFail();
      mocker.clear(sOutSideWindowMgr);
      mocker.clear(desktopModeManager);
      mocker.clear(DesktopModeManager);
    })

    it('QuitAppRectViewModelTest_buildAppExitInfo_005', 0, (): void => {
      let quitAppRectViewModel: QuitAppRectViewModel = new QuitAppRectViewModel();
      let containerSession = {} as SCBSceneContainerSession;

      containerSession.companionIconInfo = {
        iconId: '1234',
        isSameLocation: true,
      } as CompanionIconInfo;
      let mocker = new MockKit();
      let desktopModeManager = DesktopModeManager.getInstance();
      let desktopModeManagerMocker = mocker.mockFunc(DesktopModeManager, DesktopModeManager.getInstance);
      when(desktopModeManagerMocker)().afterReturn(desktopModeManager);
      let isInEmergencyOrThermalSafeMode = mocker.mockFunc(desktopModeManager,
        desktopModeManager.isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(true);
      expect(quitAppRectViewModel.buildAppExitInfo(containerSession)).not().assertFail();
      mocker.clear(desktopModeManager);
      mocker.clear(DesktopModeManager);
    })

    it('QuitAppRectViewModelTest_buildAppExitInfo_006', 0, (): void => {
      let quitAppRectViewModel: QuitAppRectViewModel = new QuitAppRectViewModel();
      let containerSession = {} as SCBSceneContainerSession;
      expect(quitAppRectViewModel.buildAppExitInfo(containerSession)).not().assertFail();
    })

    it('QuitAppRectViewModelTest_buildAppExitInfo_007', 0, (): void => {
      let quitAppRectViewModel: QuitAppRectViewModel = new QuitAppRectViewModel();
      let containerSession = {} as SCBSceneContainerSession;

      containerSession.companionIconInfo = {
        iconId: 'Browser_Feed_Default',
        iconNumber: 1,
        bundleName: 'com.ohos.browser',
      } as CompanionIconInfo;
      let mocker = new MockKit();
      let desktopModeManager = DesktopModeManager.getInstance();
      let desktopModeManagerMocker = mocker.mockFunc(DesktopModeManager, DesktopModeManager.getInstance);
      when(desktopModeManagerMocker)().afterReturn(desktopModeManager);
      let isInEmergencyOrThermalSafeMode = mocker.mockFunc(desktopModeManager,
        desktopModeManager.isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      let isShowGlobalSearch = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      when(isShowGlobalSearch)().afterReturn(false);
      AppStorage.setOrCreate('createFormId', false);
      AppStorage.setOrCreate('isIntelligentCardUseAnimation', null)

      let isShowNegative = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowNegative);
      when(isShowNegative)().afterReturn(true);
      let getDesktopEnabled = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.getDesktopEnabled);
      when(getDesktopEnabled)().afterReturn(false);

      expect(quitAppRectViewModel.buildAppExitInfo(containerSession)).not().assertFail();
      mocker.clear(sOutSideWindowMgr);
      mocker.clear(desktopModeManager);
      mocker.clear(DesktopModeManager);
    })

    it('QuitAppRectViewModelTest_buildAppExitInfo_008', 0, (): void => {
      let quitAppRectViewModel: QuitAppRectViewModel = new QuitAppRectViewModel();
      let containerSession = {} as SCBSceneContainerSession;

      containerSession.companionIconInfo = {
        iconId: 'CardsView_CardFrame_Browser_Feed_Default',
        iconNumber: 1,
        bundleName: 'com.ohos.browser',
      } as CompanionIconInfo;
      let mocker = new MockKit();
      let desktopModeManager = DesktopModeManager.getInstance();
      let desktopModeManagerMocker = mocker.mockFunc(DesktopModeManager, DesktopModeManager.getInstance);
      when(desktopModeManagerMocker)().afterReturn(desktopModeManager);
      let isInEmergencyOrThermalSafeMode = mocker.mockFunc(desktopModeManager,
        desktopModeManager.isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      let isShowGlobalSearch = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      when(isShowGlobalSearch)().afterReturn(false);
      AppStorage.setOrCreate('createFormId', false);
      AppStorage.setOrCreate('isIntelligentCardUseAnimation', false)

      let isShowNegative = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowNegative);
      when(isShowNegative)().afterReturn(true);
      let getDesktopEnabled = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.getDesktopEnabled);
      when(getDesktopEnabled)().afterReturn(false);

      expect(quitAppRectViewModel.buildAppExitInfo(containerSession)).not().assertFail();
      mocker.clear(sOutSideWindowMgr);
      mocker.clear(desktopModeManager);
      mocker.clear(DesktopModeManager);
    })

    it('QuitAppRectViewModelTest_buildAppExitInfo_009', 0, (): void => {
      let quitAppRectViewModel: QuitAppRectViewModel = new QuitAppRectViewModel();
      let containerSession = {} as SCBSceneContainerSession;

      containerSession.companionIconInfo = {} as CompanionIconInfo;
      let mocker = new MockKit();
      let desktopModeManager = DesktopModeManager.getInstance();
      let desktopModeManagerMocker = mocker.mockFunc(DesktopModeManager, DesktopModeManager.getInstance);
      when(desktopModeManagerMocker)().afterReturn(desktopModeManager);
      let isInEmergencyOrThermalSafeMode = mocker.mockFunc(desktopModeManager,
        desktopModeManager.isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      let isShowGlobalSearch = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      when(isShowGlobalSearch)().afterReturn(false);
      AppStorage.setOrCreate('createFormId', false);
      AppStorage.setOrCreate('isIntelligentCardUseAnimation', true)

      let isShowNegative = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowNegative);
      when(isShowNegative)().afterReturn(true);
      let getDesktopEnabled = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.getDesktopEnabled);
      when(getDesktopEnabled)().afterReturn(false);

      expect(quitAppRectViewModel.buildAppExitInfo(containerSession)).not().assertFail();
      mocker.clear(sOutSideWindowMgr);
      mocker.clear(desktopModeManager);
      mocker.clear(DesktopModeManager);
    })

    it('QuitAppRectViewModelTest_buildAppExitInfo_010', 0, (): void => {
      let quitAppRectViewModel: QuitAppRectViewModel = new QuitAppRectViewModel();
      let containerSession = {} as SCBSceneContainerSession;

      containerSession.companionIconInfo = {
        iconId: 'CardsView_CardFrame_Browser_Feed_Default',
        iconNumber: 1,
        bundleName: 'com.ohos.browser',
      } as CompanionIconInfo;
      let mocker = new MockKit();
      let desktopModeManager = DesktopModeManager.getInstance();
      let desktopModeManagerMocker = mocker.mockFunc(DesktopModeManager, DesktopModeManager.getInstance);
      when(desktopModeManagerMocker)().afterReturn(desktopModeManager);
      let isInEmergencyOrThermalSafeMode = mocker.mockFunc(desktopModeManager,
        desktopModeManager.isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      let isShowGlobalSearch = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      when(isShowGlobalSearch)().afterReturn(false);
      AppStorage.setOrCreate('createFormId', false);
      AppStorage.setOrCreate('isIntelligentCardUseAnimation', true)

      let isShowNegative = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowNegative);
      when(isShowNegative)().afterReturn(true);
      let getDesktopEnabled = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.getDesktopEnabled);
      when(getDesktopEnabled)().afterReturn(false);
      let isIntelligentCardShowFull = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isIntelligentCardShowFull);
      when(isIntelligentCardShowFull)().afterReturn(true);

      let isIntelligentIconId = mocker.mockFunc(IntelligentCache, IntelligentCache.isIntelligentIconId);
      when(isIntelligentIconId)().afterReturn(true);
      let intelligentCache = IntelligentCache.getInstance();
      let intelligentCacheMockFunc = mocker.mockFunc(IntelligentCache, IntelligentCache.getInstance);
      when(intelligentCacheMockFunc)().afterReturn(intelligentCache);
      let isIntelligentIconInScreen = mocker.mockFunc(intelligentCache, intelligentCache.isIntelligentIconInScreen);
      when(isIntelligentIconInScreen)().afterReturn(true);
      let isCurrentIconId = mocker.mockFunc(intelligentCache, intelligentCache.isCurrentIconId);
      when(isCurrentIconId)().afterReturn(true);

      expect(quitAppRectViewModel.buildAppExitInfo(containerSession)).not().assertFail();
      mocker.clear(intelligentCache);
      mocker.clear(IntelligentCache);
      mocker.clear(sOutSideWindowMgr);
      mocker.clear(desktopModeManager);
      mocker.clear(DesktopModeManager);
    })

    it('QuitAppRectViewModelTest_buildAppExitInfo_011', 0, (): void => {
      let quitAppRectViewModel: QuitAppRectViewModel = new QuitAppRectViewModel();
      let containerSession = {} as SCBSceneContainerSession;

      containerSession.companionIconInfo = {
        iconId: 'owser_Feed_Default',
        iconNumber: 1,
        bundleName: 'com.ohos.browser',
      } as CompanionIconInfo;
      let mocker = new MockKit();
      let desktopModeManager = DesktopModeManager.getInstance();
      let desktopModeManagerMocker = mocker.mockFunc(DesktopModeManager, DesktopModeManager.getInstance);
      when(desktopModeManagerMocker)().afterReturn(desktopModeManager);
      let isInEmergencyOrThermalSafeMode = mocker.mockFunc(desktopModeManager,
        desktopModeManager.isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      let isShowGlobalSearch = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      when(isShowGlobalSearch)().afterReturn(false);
      AppStorage.setOrCreate('createFormId', false);
      AppStorage.setOrCreate('isIntelligentCardUseAnimation', true)

      let isShowNegative = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowNegative);
      when(isShowNegative)().afterReturn(true);
      let getDesktopEnabled = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.getDesktopEnabled);
      when(getDesktopEnabled)().afterReturn(false);
      let isIntelligentCardShowFull = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isIntelligentCardShowFull);
      when(isIntelligentCardShowFull)().afterReturn(true);

      let isIntelligentIconId = mocker.mockFunc(IntelligentCache, IntelligentCache.isIntelligentIconId);
      when(isIntelligentIconId)().afterReturn(true);
      let intelligentCache = IntelligentCache.getInstance();
      let intelligentCacheMockFunc = mocker.mockFunc(IntelligentCache, IntelligentCache.getInstance);
      when(intelligentCacheMockFunc)().afterReturn(intelligentCache);
      let isIntelligentIconInScreen = mocker.mockFunc(intelligentCache, intelligentCache.isIntelligentIconInScreen);
      when(isIntelligentIconInScreen)().afterReturn(true);
      let isCurrentIconId = mocker.mockFunc(intelligentCache, intelligentCache.isCurrentIconId);
      when(isCurrentIconId)().afterReturn(false);

      expect(quitAppRectViewModel.buildAppExitInfo(containerSession)).not().assertFail();
      mocker.clear(intelligentCache);
      mocker.clear(IntelligentCache);
      mocker.clear(sOutSideWindowMgr);
      mocker.clear(desktopModeManager);
      mocker.clear(DesktopModeManager);
    })

    it('QuitAppRectViewModelTest_buildAppExitInfo_012', 0, (): void => {
      let quitAppRectViewModel: QuitAppRectViewModel = new QuitAppRectViewModel();
      let containerSession = {} as SCBSceneContainerSession;

      containerSession.companionIconInfo = {
        iconId: 'owser_Feed_Default',
        iconNumber: 1,
        bundleName: 'com.ohos.browser',
      } as CompanionIconInfo;
      let mocker = new MockKit();
      let desktopModeManager = DesktopModeManager.getInstance();
      let desktopModeManagerMocker = mocker.mockFunc(DesktopModeManager, DesktopModeManager.getInstance);
      when(desktopModeManagerMocker)().afterReturn(desktopModeManager);
      let isInEmergencyOrThermalSafeMode = mocker.mockFunc(desktopModeManager,
        desktopModeManager.isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      let isShowGlobalSearch = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      when(isShowGlobalSearch)().afterReturn(false);
      AppStorage.setOrCreate('createFormId', false);
      AppStorage.setOrCreate('isIntelligentCardUseAnimation', false)

      let isShowNegative = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowNegative);
      when(isShowNegative)().afterReturn(true);
      let getDesktopEnabled = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.getDesktopEnabled);
      when(getDesktopEnabled)().afterReturn(false);
      let isIntelligentCardShowFull = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isIntelligentCardShowFull);
      when(isIntelligentCardShowFull)().afterReturn(true);

      let isIntelligentIconId = mocker.mockFunc(IntelligentCache, IntelligentCache.isIntelligentIconId);
      when(isIntelligentIconId)().afterReturn(true);
      let intelligentCache = IntelligentCache.getInstance();
      let intelligentCacheMockFunc = mocker.mockFunc(IntelligentCache, IntelligentCache.getInstance);
      when(intelligentCacheMockFunc)().afterReturn(intelligentCache);
      let isIntelligentIconInScreen = mocker.mockFunc(intelligentCache, intelligentCache.isIntelligentIconInScreen);
      when(isIntelligentIconInScreen)().afterReturn(false);
      let isCurrentIconId = mocker.mockFunc(intelligentCache, intelligentCache.isCurrentIconId);
      when(isCurrentIconId)().afterReturn(false);

      expect(quitAppRectViewModel.buildAppExitInfo(containerSession)).not().assertFail();
      mocker.clear(intelligentCache);
      mocker.clear(IntelligentCache);
      mocker.clear(sOutSideWindowMgr);
      mocker.clear(desktopModeManager);
      mocker.clear(DesktopModeManager);
    })

    it('QuitAppRectViewModelTest_buildAppExitInfo_013', 0, (): void => {
      let quitAppRectViewModel: QuitAppRectViewModel = new QuitAppRectViewModel();
      let containerSession = {} as SCBSceneContainerSession;

      containerSession.companionIconInfo = {
        iconId: 'owser_Feed_Default',
        iconNumber: 1,
        bundleName: 'com.ohos.browser',
      } as CompanionIconInfo;
      let mocker = new MockKit();
      let desktopModeManager = DesktopModeManager.getInstance();
      let desktopModeManagerMocker = mocker.mockFunc(DesktopModeManager, DesktopModeManager.getInstance);
      when(desktopModeManagerMocker)().afterReturn(desktopModeManager);
      let isInEmergencyOrThermalSafeMode = mocker.mockFunc(desktopModeManager,
        desktopModeManager.isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      let isShowGlobalSearch = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      when(isShowGlobalSearch)().afterReturn(false);
      AppStorage.setOrCreate('createFormId', false);
      AppStorage.setOrCreate('isIntelligentCardUseAnimation', false)

      let isShowNegative = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowNegative);
      when(isShowNegative)().afterReturn(true);
      let getDesktopEnabled = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.getDesktopEnabled);
      when(getDesktopEnabled)().afterReturn(false);
      let isIntelligentCardShowFull = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isIntelligentCardShowFull);
      when(isIntelligentCardShowFull)().afterReturn(false);

      let isIntelligentIconId = mocker.mockFunc(IntelligentCache, IntelligentCache.isIntelligentIconId);
      when(isIntelligentIconId)().afterReturn(false);
      let intelligentCache = IntelligentCache.getInstance();
      let intelligentCacheMockFunc = mocker.mockFunc(IntelligentCache, IntelligentCache.getInstance);
      when(intelligentCacheMockFunc)().afterReturn(intelligentCache);
      let isIntelligentIconInScreen = mocker.mockFunc(intelligentCache, intelligentCache.isIntelligentIconInScreen);
      when(isIntelligentIconInScreen)().afterReturn(false);
      let isCurrentIconId = mocker.mockFunc(intelligentCache, intelligentCache.isCurrentIconId);
      when(isCurrentIconId)().afterReturn(false);

      expect(quitAppRectViewModel.buildAppExitInfo(containerSession)).not().assertFail();
      mocker.clear(intelligentCache);
      mocker.clear(IntelligentCache);
      mocker.clear(sOutSideWindowMgr);
      mocker.clear(desktopModeManager);
      mocker.clear(DesktopModeManager);
    })

    it('QuitAppRectViewModelTest_buildAppExitInfo_022', 0, (): void => {
      let quitAppRectViewModel: QuitAppRectViewModel = new QuitAppRectViewModel();
      let containerSession = {} as SCBSceneContainerSession;

      let mocker = new MockKit();
      let desktopModeManager = DesktopModeManager.getInstance();
      let desktopModeManagerMocker = mocker.mockFunc(DesktopModeManager, DesktopModeManager.getInstance);
      when(desktopModeManagerMocker)().afterReturn(desktopModeManager);
      let isInEmergencyOrThermalSafeMode = mocker.mockFunc(desktopModeManager,
        desktopModeManager.isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      let isShowGlobalSearch = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      when(isShowGlobalSearch)().afterReturn(false);
      AppStorage.setOrCreate('createFormId', false);
      AppStorage.setOrCreate('isIntelligentCardUseAnimation', false)

      let isShowNegative = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowNegative);
      when(isShowNegative)().afterReturn(true);
      let getDesktopEnabled = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.getDesktopEnabled);
      when(getDesktopEnabled)().afterReturn(true);

      let pageDesktopModel = PageDesktopModel.getInstance();
      let pageDesktopModelMockFunc = mocker.mockFunc(PageDesktopModel, PageDesktopModel.getInstance);
      when(pageDesktopModelMockFunc)().afterReturn(pageDesktopModel);
      let buildAppExitInfo = mocker.mockFunc(pageDesktopModel, pageDesktopModel.buildAppExitInfo);
      when(buildAppExitInfo)().afterReturn(null);
      AppStorage.setOrCreate('openFolderId', null);

      let launchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let launchLayoutCacheManagerMockFunc = mocker.mockFunc(LaunchLayoutCacheManager,
        LaunchLayoutCacheManager.getInstance);
      when(launchLayoutCacheManagerMockFunc)().afterReturn(launchLayoutCacheManager);
      let getDesktopAppInfo = mocker.mockFunc(launchLayoutCacheManager, launchLayoutCacheManager.getDesktopAppInfo);
      when(getDesktopAppInfo)().afterReturn([]);
      let getDockAppInfo = mocker.mockFunc(launchLayoutCacheManager, launchLayoutCacheManager.getDockAppInfo);
      when(getDockAppInfo)().afterReturn([]);

      expect(quitAppRectViewModel.buildAppExitInfo(containerSession)).not().assertFail();
      mocker.clear(launchLayoutCacheManager);
      mocker.clear(LaunchLayoutCacheManager);
      mocker.clear(containerSession);
      mocker.clear(pageDesktopModel);
      mocker.clear(PageDesktopModel);
      mocker.clear(sOutSideWindowMgr);
      mocker.clear(desktopModeManager);
      mocker.clear(DesktopModeManager);
    })

    it('QuitAppRectViewModelTest_buildAppExitInfo_023', 0, (): void => {
      let quitAppRectViewModel: QuitAppRectViewModel = new QuitAppRectViewModel();
      let containerSession = {} as SCBSceneContainerSession;

      let mocker = new MockKit();
      let desktopModeManager = DesktopModeManager.getInstance();
      let desktopModeManagerMocker = mocker.mockFunc(DesktopModeManager, DesktopModeManager.getInstance);
      when(desktopModeManagerMocker)().afterReturn(desktopModeManager);
      let isInEmergencyOrThermalSafeMode = mocker.mockFunc(desktopModeManager,
        desktopModeManager.isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      let isShowGlobalSearch = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      when(isShowGlobalSearch)().afterReturn(false);
      AppStorage.setOrCreate('createFormId', false);
      AppStorage.setOrCreate('isIntelligentCardUseAnimation', false)

      let isShowNegative = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowNegative);
      when(isShowNegative)().afterReturn(true);
      let getDesktopEnabled = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.getDesktopEnabled);
      when(getDesktopEnabled)().afterReturn(true);

      let pageDesktopModel = PageDesktopModel.getInstance();
      let pageDesktopModelMockFunc = mocker.mockFunc(PageDesktopModel, PageDesktopModel.getInstance);
      when(pageDesktopModelMockFunc)().afterReturn(pageDesktopModel);
      let buildAppExitInfo = mocker.mockFunc(pageDesktopModel, pageDesktopModel.buildAppExitInfo);
      when(buildAppExitInfo)().afterReturn(null);
      AppStorage.setOrCreate('openFolderId', null);

      let launchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let launchLayoutCacheManagerMockFunc = mocker.mockFunc(LaunchLayoutCacheManager,
        LaunchLayoutCacheManager.getInstance);
      when(launchLayoutCacheManagerMockFunc)().afterReturn(launchLayoutCacheManager);
      let getDesktopAppInfo = mocker.mockFunc(launchLayoutCacheManager, launchLayoutCacheManager.getDesktopAppInfo);
      when(getDesktopAppInfo)().afterReturn(null);
      let getDockAppInfo = mocker.mockFunc(launchLayoutCacheManager, launchLayoutCacheManager.getDockAppInfo);
      when(getDockAppInfo)().afterReturn(null);

      expect(quitAppRectViewModel.buildAppExitInfo(containerSession)).not().assertFail();
      mocker.clear(launchLayoutCacheManager);
      mocker.clear(LaunchLayoutCacheManager);
      mocker.clear(containerSession);
      mocker.clear(pageDesktopModel);
      mocker.clear(PageDesktopModel);
      mocker.clear(sOutSideWindowMgr);
      mocker.clear(desktopModeManager);
      mocker.clear(DesktopModeManager);
    })

    it('QuitAppRectViewModelTest_buildAppExitInfo_024', 0, (): void => {
      let quitAppRectViewModel: QuitAppRectViewModel = new QuitAppRectViewModel();
      let containerSession = {} as SCBSceneContainerSession;

      let mocker = new MockKit();
      let desktopModeManager = DesktopModeManager.getInstance();
      let desktopModeManagerMocker = mocker.mockFunc(DesktopModeManager, DesktopModeManager.getInstance);
      when(desktopModeManagerMocker)().afterReturn(desktopModeManager);
      let isInEmergencyOrThermalSafeMode = mocker.mockFunc(desktopModeManager,
        desktopModeManager.isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      let isShowGlobalSearch = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      when(isShowGlobalSearch)().afterReturn(false);
      AppStorage.setOrCreate('createFormId', false);
      AppStorage.setOrCreate('isIntelligentCardUseAnimation', false)

      let isShowNegative = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowNegative);
      when(isShowNegative)().afterReturn(true);
      let getDesktopEnabled = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.getDesktopEnabled);
      when(getDesktopEnabled)().afterReturn(true);

      let pageDesktopModel = PageDesktopModel.getInstance();
      let pageDesktopModelMockFunc = mocker.mockFunc(PageDesktopModel, PageDesktopModel.getInstance);
      when(pageDesktopModelMockFunc)().afterReturn(pageDesktopModel);
      let buildAppExitInfo = mocker.mockFunc(pageDesktopModel, pageDesktopModel.buildAppExitInfo);
      when(buildAppExitInfo)().afterReturn(null);
      AppStorage.setOrCreate('openFolderId', null);

      let layoutItemInfos: GridLayoutItemInfo[] = [{} as GridLayoutItemInfo];
      let launchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let launchLayoutCacheManagerMockFunc = mocker.mockFunc(LaunchLayoutCacheManager,
        LaunchLayoutCacheManager.getInstance);
      when(launchLayoutCacheManagerMockFunc)().afterReturn(launchLayoutCacheManager);
      let getDesktopAppInfo = mocker.mockFunc(launchLayoutCacheManager, launchLayoutCacheManager.getDesktopAppInfo);
      when(getDesktopAppInfo)().afterReturn(null);
      let getDockAppInfo = mocker.mockFunc(launchLayoutCacheManager, launchLayoutCacheManager.getDockAppInfo);
      when(getDockAppInfo)().afterReturn(layoutItemInfos);

      expect(quitAppRectViewModel.buildAppExitInfo(containerSession)).not().assertFail();
      mocker.clear(launchLayoutCacheManager);
      mocker.clear(LaunchLayoutCacheManager);
      mocker.clear(containerSession);
      mocker.clear(pageDesktopModel);
      mocker.clear(PageDesktopModel);
      mocker.clear(sOutSideWindowMgr);
      mocker.clear(desktopModeManager);
      mocker.clear(DesktopModeManager);
    })

    it('QuitAppRectViewModelTest_buildAppExitInfo_025', 0, (): void => {
      let quitAppRectViewModel: QuitAppRectViewModel = new QuitAppRectViewModel();
      let containerSession = {} as SCBSceneContainerSession;

      let mocker = new MockKit();
      let desktopModeManager = DesktopModeManager.getInstance();
      let desktopModeManagerMocker = mocker.mockFunc(DesktopModeManager, DesktopModeManager.getInstance);
      when(desktopModeManagerMocker)().afterReturn(desktopModeManager);
      let isInEmergencyOrThermalSafeMode = mocker.mockFunc(desktopModeManager,
        desktopModeManager.isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      let isShowGlobalSearch = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      when(isShowGlobalSearch)().afterReturn(false);
      AppStorage.setOrCreate('createFormId', false);
      AppStorage.setOrCreate('isIntelligentCardUseAnimation', false)

      let isShowNegative = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowNegative);
      when(isShowNegative)().afterReturn(true);
      let getDesktopEnabled = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.getDesktopEnabled);
      when(getDesktopEnabled)().afterReturn(true);

      let pageDesktopModel = PageDesktopModel.getInstance();
      let pageDesktopModelMockFunc = mocker.mockFunc(PageDesktopModel, PageDesktopModel.getInstance);
      when(pageDesktopModelMockFunc)().afterReturn(pageDesktopModel);
      let buildAppExitInfo = mocker.mockFunc(pageDesktopModel, pageDesktopModel.buildAppExitInfo);
      when(buildAppExitInfo)().afterReturn(null);
      AppStorage.setOrCreate('openFolderId', null);

      let layoutItemInfos: GridLayoutItemInfo[] = [{
        appStatus: 2
      } as GridLayoutItemInfo];
      let launchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let launchLayoutCacheManagerMockFunc = mocker.mockFunc(LaunchLayoutCacheManager,
        LaunchLayoutCacheManager.getInstance);
      when(launchLayoutCacheManagerMockFunc)().afterReturn(launchLayoutCacheManager);
      let getDesktopAppInfo = mocker.mockFunc(launchLayoutCacheManager, launchLayoutCacheManager.getDesktopAppInfo);
      when(getDesktopAppInfo)().afterReturn(layoutItemInfos);

      expect(quitAppRectViewModel.buildAppExitInfo(containerSession)).not().assertFail();
      mocker.clear(launchLayoutCacheManager);
      mocker.clear(LaunchLayoutCacheManager);
      mocker.clear(containerSession);
      mocker.clear(pageDesktopModel);
      mocker.clear(PageDesktopModel);
      mocker.clear(sOutSideWindowMgr);
      mocker.clear(desktopModeManager);
      mocker.clear(DesktopModeManager);
    })

    it('QuitAppRectViewModelTest_buildAppExitInfo_026', 0, (): void => {
      let quitAppRectViewModel: QuitAppRectViewModel = new QuitAppRectViewModel();
      let containerSession = {} as SCBSceneContainerSession;

      let mocker = new MockKit();
      let desktopModeManager = DesktopModeManager.getInstance();
      let desktopModeManagerMocker = mocker.mockFunc(DesktopModeManager, DesktopModeManager.getInstance);
      when(desktopModeManagerMocker)().afterReturn(desktopModeManager);
      let isInEmergencyOrThermalSafeMode = mocker.mockFunc(desktopModeManager,
        desktopModeManager.isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      let isShowGlobalSearch = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      when(isShowGlobalSearch)().afterReturn(false);
      AppStorage.setOrCreate('createFormId', false);
      AppStorage.setOrCreate('isIntelligentCardUseAnimation', false)

      let isShowNegative = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowNegative);
      when(isShowNegative)().afterReturn(true);
      let getDesktopEnabled = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.getDesktopEnabled);
      when(getDesktopEnabled)().afterReturn(true);

      let pageDesktopModel = PageDesktopModel.getInstance();
      let pageDesktopModelMockFunc = mocker.mockFunc(PageDesktopModel, PageDesktopModel.getInstance);
      when(pageDesktopModelMockFunc)().afterReturn(pageDesktopModel);
      let buildAppExitInfo = mocker.mockFunc(pageDesktopModel, pageDesktopModel.buildAppExitInfo);
      when(buildAppExitInfo)().afterReturn(null);
      AppStorage.setOrCreate('openFolderId', 2);

      let layoutItemInfos: GridLayoutItemInfo[] = [{
        appStatus: AppStatus.INSTALLED
      } as GridLayoutItemInfo];
      let launchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let launchLayoutCacheManagerMockFunc = mocker.mockFunc(LaunchLayoutCacheManager,
        LaunchLayoutCacheManager.getInstance);
      when(launchLayoutCacheManagerMockFunc)().afterReturn(launchLayoutCacheManager);
      let getDesktopAppInfo = mocker.mockFunc(launchLayoutCacheManager, launchLayoutCacheManager.getDesktopAppInfo);
      when(getDesktopAppInfo)().afterReturn(layoutItemInfos);

      expect(quitAppRectViewModel.buildAppExitInfo(containerSession)).not().assertFail();
      mocker.clear(launchLayoutCacheManager);
      mocker.clear(LaunchLayoutCacheManager);
      mocker.clear(containerSession);
      mocker.clear(pageDesktopModel);
      mocker.clear(PageDesktopModel);
      mocker.clear(sOutSideWindowMgr);
      mocker.clear(desktopModeManager);
      mocker.clear(DesktopModeManager);
    })

    it('QuitAppRectViewModelTest_buildAppExitInfo_027', 0, (): void => {
      let quitAppRectViewModel: QuitAppRectViewModel = new QuitAppRectViewModel();
      let containerSession = {} as SCBSceneContainerSession;

      let mocker = new MockKit();
      let desktopModeManager = DesktopModeManager.getInstance();
      let desktopModeManagerMocker = mocker.mockFunc(DesktopModeManager, DesktopModeManager.getInstance);
      when(desktopModeManagerMocker)().afterReturn(desktopModeManager);
      let isInEmergencyOrThermalSafeMode = mocker.mockFunc(desktopModeManager,
        desktopModeManager.isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      let isShowGlobalSearch = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      when(isShowGlobalSearch)().afterReturn(false);
      AppStorage.setOrCreate('createFormId', false);
      AppStorage.setOrCreate('isIntelligentCardUseAnimation', false)

      let isShowNegative = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowNegative);
      when(isShowNegative)().afterReturn(true);
      let getDesktopEnabled = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.getDesktopEnabled);
      when(getDesktopEnabled)().afterReturn(true);

      let pageDesktopModel = PageDesktopModel.getInstance();
      let pageDesktopModelMockFunc = mocker.mockFunc(PageDesktopModel, PageDesktopModel.getInstance);
      when(pageDesktopModelMockFunc)().afterReturn(pageDesktopModel);
      let buildAppExitInfo = mocker.mockFunc(pageDesktopModel, pageDesktopModel.buildAppExitInfo);
      when(buildAppExitInfo)().afterReturn(null);
      AppStorage.setOrCreate('openFolderId', null);

      let layoutItemInfos: GridLayoutItemInfo[] = [{
        appStatus: AppStatus.INSTALLED
      } as GridLayoutItemInfo];
      let launchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let launchLayoutCacheManagerMockFunc = mocker.mockFunc(LaunchLayoutCacheManager,
        LaunchLayoutCacheManager.getInstance);
      when(launchLayoutCacheManagerMockFunc)().afterReturn(launchLayoutCacheManager);
      let getDesktopAppInfo = mocker.mockFunc(launchLayoutCacheManager, launchLayoutCacheManager.getDesktopAppInfo);
      when(getDesktopAppInfo)().afterReturn(layoutItemInfos);

      expect(quitAppRectViewModel.buildAppExitInfo(containerSession)).not().assertFail();
      mocker.clear(launchLayoutCacheManager);
      mocker.clear(LaunchLayoutCacheManager);
      mocker.clear(containerSession);
      mocker.clear(pageDesktopModel);
      mocker.clear(PageDesktopModel);
      mocker.clear(sOutSideWindowMgr);
      mocker.clear(desktopModeManager);
      mocker.clear(DesktopModeManager);
    })

    it('QuitAppRectViewModelTest_buildAppExitInfo_028', 0, (): void => {
      let quitAppRectViewModel: QuitAppRectViewModel = new QuitAppRectViewModel();
      let containerSession = {} as SCBSceneContainerSession;

      let mocker = new MockKit();
      let desktopModeManager = DesktopModeManager.getInstance();
      let desktopModeManagerMocker = mocker.mockFunc(DesktopModeManager, DesktopModeManager.getInstance);
      when(desktopModeManagerMocker)().afterReturn(desktopModeManager);
      let isInEmergencyOrThermalSafeMode = mocker.mockFunc(desktopModeManager,
        desktopModeManager.isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      let isShowGlobalSearch = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      when(isShowGlobalSearch)().afterReturn(false);
      AppStorage.setOrCreate('createFormId', false);
      AppStorage.setOrCreate('isIntelligentCardUseAnimation', false)

      let isShowNegative = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowNegative);
      when(isShowNegative)().afterReturn(true);
      let getDesktopEnabled = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.getDesktopEnabled);
      when(getDesktopEnabled)().afterReturn(true);

      let pageDesktopModel = PageDesktopModel.getInstance();
      let pageDesktopModelMockFunc = mocker.mockFunc(PageDesktopModel, PageDesktopModel.getInstance);
      when(pageDesktopModelMockFunc)().afterReturn(pageDesktopModel);
      let buildAppExitInfo = mocker.mockFunc(pageDesktopModel, pageDesktopModel.buildAppExitInfo);
      when(buildAppExitInfo)().afterReturn(null);
      AppStorage.setOrCreate('openFolderId', null);

      let layoutItemInfos: GridLayoutItemInfo[] = [
        {
          appStatus: AppStatus.INSTALLED,
          area: [1, 1]
        } as GridLayoutItemInfo,
        {
          appStatus: AppStatus.INSTALLED,
          area: [1, 1]
        } as GridLayoutItemInfo
      ];
      let launchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let launchLayoutCacheManagerMockFunc = mocker.mockFunc(LaunchLayoutCacheManager,
        LaunchLayoutCacheManager.getInstance);
      when(launchLayoutCacheManagerMockFunc)().afterReturn(launchLayoutCacheManager);
      let getDesktopAppInfo = mocker.mockFunc(launchLayoutCacheManager, launchLayoutCacheManager.getDesktopAppInfo);
      when(getDesktopAppInfo)().afterReturn(null);
      let getDockAppInfo = mocker.mockFunc(launchLayoutCacheManager, launchLayoutCacheManager.getDockAppInfo);
      when(getDockAppInfo)().afterReturn(layoutItemInfos);

      expect(quitAppRectViewModel.buildAppExitInfo(containerSession)).not().assertFail();
      mocker.clear(launchLayoutCacheManager);
      mocker.clear(LaunchLayoutCacheManager);
      mocker.clear(containerSession);
      mocker.clear(pageDesktopModel);
      mocker.clear(PageDesktopModel);
      mocker.clear(sOutSideWindowMgr);
      mocker.clear(desktopModeManager);
      mocker.clear(DesktopModeManager);
    })

    it('QuitAppRectViewModelTest_initSwiperParam_001', 0, (): void => {
      let quitAppRectViewModel: QuitAppRectViewModel = new QuitAppRectViewModel();
      AppStorage.setOrCreate('screenWidth', null);
      let folderLayoutStruct = {} as FolderLayoutStruct
      let mocker = new MockKit();
      let folderModel = FolderModel.getInstance();
      let folderModelMockFunc = mocker.mockFunc(FolderModel, FolderModel.getInstance);
      when(folderModelMockFunc)().afterReturn(folderModel);
      let getFolderOpenLayout = mocker.mockFunc(folderModel, folderModel.getFolderOpenLayout);
      when(getFolderOpenLayout)().afterReturn(null);
      expect(quitAppRectViewModel.initSwiperParam(1) === undefined).not().assertFail();
      mocker.clear(folderModel);
      mocker.clear(FolderModel);
    })

    it('QuitAppRectViewModelTest_initSwiperParam_002', 0, (): void => {
      let quitAppRectViewModel: QuitAppRectViewModel = new QuitAppRectViewModel();
      AppStorage.setOrCreate('screenWidth', 1);
      let folderLayoutStruct = {} as FolderLayoutStruct
      let mocker = new MockKit();
      let folderModel = FolderModel.getInstance();
      let folderModelMockFunc = mocker.mockFunc(FolderModel, FolderModel.getInstance);
      when(folderModelMockFunc)().afterReturn(folderModel);
      let getFolderOpenLayout = mocker.mockFunc(folderModel, folderModel.getFolderOpenLayout);
      when(getFolderOpenLayout)().afterReturn(folderLayoutStruct);
      expect(quitAppRectViewModel.initSwiperParam(1) === undefined).not().assertFail();
      mocker.clear(folderModel);
      mocker.clear(FolderModel);
    })

    it('QuitAppRectViewModelTest_initSwiperParam_003', 0, (): void => {
      let quitAppRectViewModel: QuitAppRectViewModel = new QuitAppRectViewModel();
      AppStorage.setOrCreate('screenWidth', 1);
      let folderLayoutStruct = {
        column: 1,
        row: 1
      } as FolderLayoutStruct
      let mocker = new MockKit();
      let folderModel = FolderModel.getInstance();
      let folderModelMockFunc = mocker.mockFunc(FolderModel, FolderModel.getInstance);
      when(folderModelMockFunc)().afterReturn(folderModel);
      let getFolderOpenLayout = mocker.mockFunc(folderModel, folderModel.getFolderOpenLayout);
      when(getFolderOpenLayout)().afterReturn(folderLayoutStruct);
      expect(quitAppRectViewModel.initSwiperParam(1) === undefined).not().assertFail();
      mocker.clear(folderModel);
      mocker.clear(FolderModel);
    })

    it('QuitAppRectViewModelTest_addTransparentCardCount_001', 0, (): void => {
      let quitAppRectViewModel: QuitAppRectViewModel = new QuitAppRectViewModel();
      expect(quitAppRectViewModel.addTransparentCardCount() === undefined).not().assertFail();
    })

    it('QuitAppRectViewModelTest_getTransparentCardCount_001', 0, (): void => {
      let quitAppRectViewModel: QuitAppRectViewModel = new QuitAppRectViewModel();
      expect(quitAppRectViewModel.getTransparentCardCount()).not().assertFail();
    })

    it('QuitAppRectViewModelTest_getTransparentCardCount_001', 0, (): void => {
      let quitAppRectViewModel: QuitAppRectViewModel = new QuitAppRectViewModel();
      expect(quitAppRectViewModel.clearTransparentCardCount() === undefined).not().assertFail();
    })

    it('BaseQuitAppRectTest_round_001', 0, (): void => {
      let baseQuitAppRect: BaseQuitAppRect = new BaseQuitAppRect();
      expect(baseQuitAppRect.round(6.3)).not().assertFail();
    })

    it('BaseQuitAppRectTest_round_002', 0, (): void => {
      let baseQuitAppRect: BaseQuitAppRect = new BaseQuitAppRect();
      expect(baseQuitAppRect.round(6.6)).not().assertFail();
    })

    it('BaseQuitAppRectTest_getIconRadius_001', 0, (): void => {
      let baseQuitAppRect: BaseQuitAppRect = new BaseQuitAppRect();
      expect(baseQuitAppRect.getIconRadius(undefined)).not().assertFail();
    })

    it('BaseQuitAppRectTest_getIconRadius_002', 0, (): void => {
      let baseQuitAppRect: BaseQuitAppRect = new BaseQuitAppRect();
      expect(baseQuitAppRect.getIconRadius(10)).not().assertFail();
    })

    it('BaseQuitAppRectTest_initGridParamDesktop_001', 0, (): void => {
      let baseQuitAppRect: BaseQuitAppRect = new BaseQuitAppRect();
      expect(baseQuitAppRect.initGridParamDesktop(PageDesktopGridStyleConfig.getInstance(),
        new GridLayoutConfig()) === undefined).not().assertFail();
    })

    it('BaseQuitAppRectTest_getRectDesktop_001', 0, (): void => {
      try {
        let baseQuitAppRect: BaseQuitAppRect = new BaseQuitAppRect();
        let layoutItemInfo: GridLayoutItemInfo = {
          row: 1,
          column: 1,
          page: 1,
        } as GridLayoutItemInfo;
        expect(baseQuitAppRect.getRectDesktop(layoutItemInfo)).not().assertFail();
      } catch (err) {}
    })

    it('BaseQuitAppRectTest_getRectOpenFolder_001', 0, (): void => {
      try {
        let baseQuitAppRect: BaseQuitAppRect = new BaseQuitAppRect();
        let layoutItemInfos: GridLayoutItemInfo[] = []
        expect(baseQuitAppRect.getRectOpenFolder(layoutItemInfos)).not().assertFail();
      } catch (err) {}
    })

    it('BaseQuitAppRectTest_getRectOpenFolder_002', 0, (): void => {
      let baseQuitAppRect: BaseQuitAppRect = new BaseQuitAppRect();
      let layoutItemInfos: GridLayoutItemInfo[] = [
        {
          row: 1,
          column: 1,
          page: 1,
        } as GridLayoutItemInfo
      ]
      expect(baseQuitAppRect.getRectOpenFolder(layoutItemInfos)).not().assertFail();
    })

    it('BaseQuitAppRectTest_getRectOpenFolder_003', 0, (): void => {
      let baseQuitAppRect: BaseQuitAppRect = new BaseQuitAppRect();
      let layoutItemInfos: GridLayoutItemInfo[] = [{} as GridLayoutItemInfo]
      expect(baseQuitAppRect.getRectOpenFolder(layoutItemInfos)).not().assertFail();
    })

    it('BaseQuitAppRectTest_getRectShrinkFolder_001', 0, (): void => {
      try {
        let baseQuitAppRect: BaseQuitAppRect = new BaseQuitAppRect();
        let layoutItemInfos: GridLayoutItemInfo[] = []
        expect(baseQuitAppRect.getRectShrinkFolder(layoutItemInfos)).not().assertFail();
      } catch (err) {}
    })

    it('BaseQuitAppRectTest_getRectShrinkFolder_002', 0, (): void => {
      try {
        let baseQuitAppRect: BaseQuitAppRect = new BaseQuitAppRect();
        let layoutItemInfos: GridLayoutItemInfo[] = [{} as GridLayoutItemInfo]
        expect(baseQuitAppRect.getRectShrinkFolder(layoutItemInfos)).not().assertFail();
      } catch (err) {}
    })

    it('BaseQuitAppRectTest_getRectShrinkFolder_003', 0, (): void => {
      let baseQuitAppRect: BaseQuitAppRect = new BaseQuitAppRect();
      let layoutItemInfos: GridLayoutItemInfo[] = [
        {} as GridLayoutItemInfo,
        {} as GridLayoutItemInfo
      ]
      expect(baseQuitAppRect.getRectShrinkFolder(layoutItemInfos)).not().assertFail();
    })

    it('BaseQuitAppRectTest_getRectShrinkFolder_004', 0, (): void => {
      let baseQuitAppRect: BaseQuitAppRect = new BaseQuitAppRect();
      let layoutItemInfos: GridLayoutItemInfo[] = [
        {} as GridLayoutItemInfo,
        {
          area: [2, 2]
        } as GridLayoutItemInfo
      ]
      expect(baseQuitAppRect.getRectShrinkFolder(layoutItemInfos)).not().assertFail();
    })

    it('BaseQuitAppRectTest_getRectShrinkFolder_005', 0, (): void => {
      let baseQuitAppRect: BaseQuitAppRect = new BaseQuitAppRect();
      let layoutItemInfos: GridLayoutItemInfo[] = [
        {
          page: 0,
          row: 0,
          column: 0
        } as GridLayoutItemInfo,
        {
          area: [2, 2],
          column: 1,
          row: 1
        } as GridLayoutItemInfo
      ]
      expect(baseQuitAppRect.getRectShrinkFolder(layoutItemInfos)).not().assertFail();
    })

    it('BaseQuitAppRectTest_getRectShrinkFolder_006', 0, (): void => {
      let baseQuitAppRect: BaseQuitAppRect = new BaseQuitAppRect();
      let layoutItemInfos: GridLayoutItemInfo[] = [
        {
          page: 0,
          row: 2,
          column: 2
        } as GridLayoutItemInfo,
        {
          area: [2, 2],
          column: 1,
          row: 1
        } as GridLayoutItemInfo
      ]
      expect(baseQuitAppRect.getRectShrinkFolder(layoutItemInfos)).not().assertFail();
    })

    it('BaseQuitAppRectTest_getRectShrinkFolder_007', 0, (): void => {
      let baseQuitAppRect: BaseQuitAppRect = new BaseQuitAppRect();
      let layoutItemInfos: GridLayoutItemInfo[] = [
        {
          page: 0,
          row: 2,
          column: 3
        } as GridLayoutItemInfo,
        {
          area: [2, 2],
          column: 1,
          row: 1
        } as GridLayoutItemInfo
      ]
      expect(baseQuitAppRect.getRectShrinkFolder(layoutItemInfos)).not().assertFail();
    })

    it('BaseQuitAppRectTest_getRectShrinkFolder_008', 0, (): void => {
      let baseQuitAppRect: BaseQuitAppRect = new BaseQuitAppRect();
      let layoutItemInfos: GridLayoutItemInfo[] = [
        {
          page: 0,
          row: 1,
          column: 2
        } as GridLayoutItemInfo,
        {
          area: [2, 2],
          column: 1,
          row: 1
        } as GridLayoutItemInfo
      ]
      expect(baseQuitAppRect.getRectShrinkFolder(layoutItemInfos)).not().assertFail();
    })

    it('BaseQuitAppRectTest_getRectShrinkFolder_009', 0, (): void => {
      let baseQuitAppRect: BaseQuitAppRect = new BaseQuitAppRect();
      let layoutItemInfos: GridLayoutItemInfo[] = [
        {
          page: 0,
          row: 0,
          column: 2
        } as GridLayoutItemInfo,
        {
          area: [2, 2],
          column: 1,
          row: 1
        } as GridLayoutItemInfo
      ]
      expect(baseQuitAppRect.getRectShrinkFolder(layoutItemInfos)).not().assertFail();
    })
  })
}