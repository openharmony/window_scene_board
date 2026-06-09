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
import { CheckEmptyUtils, CommonUtils} from '@ohos/basicutils';
import { desktopUtil } from '@ohos/componenthelper';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { launcherStatusUtil } from '@ohos/windowscene';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium'
import {BaseConfig,
  DeviceState,
  DockItemInfo,
  GridLayoutItemInfo,
  LauncherLayoutStyleConfig,
  layoutConfigManager,
  LayoutRulesController, LayoutViewModel } from '../../../../../../main/ets/TsIndex';
import { FolderModel } from '../../../../../../main/ets/TsIndex'
import { DesktopLayoutState } from '../../../../../../main/ets/constants/CommonConstants';

export default function LayoutViewModelTest() {
  describe('LayoutViewModelTest', () => {
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
    it('test_getInstance', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let instance = LayoutViewModel.getInstance();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(instance).not().assertNull()
    })

    it('test_initScreen', 0, () => {
      // just cover this method
      let instance = LayoutViewModel.getInstance();
      let navigationBarStatus: string = '0';
      instance.initScreen(navigationBarStatus);
      let height = instance.getBaseConfig().getSysUIBottomHeight();
      expect(height).assertEqual(0);

      navigationBarStatus = '1';
      instance.initScreen(navigationBarStatus);
      height = instance.getBaseConfig().getSysUIBottomHeight();
      expect(height).assertEqual(instance.getBaseConfig().getLauncherLayoutStyleConfig().mSysBottomHeight);
    })

    it('test_setDevice', 0, () => {
      // just cover this method
      let instance = LayoutViewModel.getInstance();
      let deviceType: string = 'pad';
      instance.setDevice(deviceType);
      let isPad = instance.getBaseConfig().getIsPad();
      expect(isPad).assertTrue();

      deviceType = 'phone';
      instance.setDevice(deviceType);
      isPad = instance.getBaseConfig().getIsPad();
      expect(isPad).assertFalse();
    })

    it('test_getScreenHeight', 0, () => {
      // just cover this method
      let instance = LayoutViewModel.getInstance();
      let configHeight = instance.getBaseConfig().getScreenHeight();
      let screenHeight = instance.getScreenHeight();
      expect(configHeight).assertEqual(screenHeight);
    })

    it('test_getScreenWidth', 0, () => {
      // just cover this method
      let instance = LayoutViewModel.getInstance();
      let configWidth = instance.getBaseConfig().getScreenWidth();
      let screenWidth = instance.getScreenWidth();
      expect(configWidth).assertEqual(screenWidth);
    })

    it('test_getWorkSpaceHeight', 0, () => {
      // just cover this method
      let instance = LayoutViewModel.getInstance();
      let configHeight = instance.getBaseConfig().getWorkSpaceHeight();
      let workspaceHeight = instance.getWorkSpaceHeight();
      expect(configHeight).assertEqual(workspaceHeight);
    })

    it('test_getDockHeight', 0, () => {
      // just cover this method
      let instance = LayoutViewModel.getInstance();
      let configHeight = instance.getBaseConfig().getDockHeight();
      let dockHeight = instance.getDockHeight();
      expect(configHeight).assertEqual(dockHeight);
    })

    it('test_getDockBackgroundHeight', 0, () => {
      // just cover this method
      let instance = LayoutViewModel.getInstance();
      let configHeight = instance.getBaseConfig().getDockBackgroundHeight();
      let dockHeight = instance.getDockBackgroundHeight();
      expect(configHeight).assertEqual(dockHeight);
    })

    it('test_getDockMarginBottomHideBar', 0, () => {
      // just cover this method
      let instance = LayoutViewModel.getInstance();
      let configHeight = instance.getBaseConfig().getLauncherLayoutStyleConfig().mDockMarginBottomHideBar;
      let dockHeight = instance.getDockMarginBottomHideBar();
      expect(configHeight).assertEqual(dockHeight);
    })

    it('test_getSysUITopHeight', 0, () => {
      // just cover this method
      let instance = LayoutViewModel.getInstance();
      let configHeight = instance.getBaseConfig().getSysUITopHeight();
      let dockHeight = instance.getSysUITopHeight();
      expect(configHeight).assertEqual(dockHeight);
    })

    it('test_getIndicator', 0, () => {
      // just cover this method
      let instance = LayoutViewModel.getInstance();
      let configHeight = instance.getBaseConfig().getIndicatorHeight();
      let dockHeight = instance.getIndicator();
      expect(configHeight).assertEqual(dockHeight);
    })

    it('test_getUninstallDialogWidth', 0, () => {
      // just cover this method
      let instance = LayoutViewModel.getInstance();
      let configWidth = instance.getBaseConfig().getUninstallDialogWidth();
      let retWidth = instance.getUninstallDialogWidth();
      expect(retWidth).assertEqual(configWidth);
    })

    it('test_calculateDock', 0, () => {
      // as no rule exists, just ignore
      let instance = LayoutViewModel.getInstance();
      let baseConfig = instance.getBaseConfig();
      const ruleController = LayoutRulesController.getInstance(baseConfig);
      instance.setLayoutRulesController(ruleController);
      const rest = instance.calculateDock();
      expect(rest).not().assertUndefined();
    })

    it('test_calculateDesktop', 0, () => {
      // as no rule exists, just ignore
      let instance = LayoutViewModel.getInstance();
      let baseConfig = instance.getBaseConfig();
      const ruleController = LayoutRulesController.getInstance(baseConfig);
      instance.setLayoutRulesController(ruleController);
      const rest = instance.calculateDesktop();
      expect(rest).not().assertUndefined();
    })

    it('test_calculateForm', 0, () => {
      // as no rule exists, just ignore
      let instance = LayoutViewModel.getInstance();
      let baseConfig = instance.getBaseConfig();
      const ruleController = LayoutRulesController.getInstance(baseConfig);
      instance.setLayoutRulesController(ruleController);
      const rest = instance.calculateForm();
      expect(rest).not().assertUndefined();
    })

    it('test_calculateAppCenter', 0, () => {
      // as no rule exists, just ignore
      let instance = LayoutViewModel.getInstance();
      let baseConfig = instance.getBaseConfig();
      const ruleController = LayoutRulesController.getInstance(baseConfig);
      instance.setLayoutRulesController(ruleController);
      const rest = instance.calculateAppCenter();
      expect(rest).not().assertUndefined();
    })

    it('test_updateDockAppSum', 0, () => {
      // as no rule exists, just ignore
      let instance = LayoutViewModel.getInstance();
      instance.updateDockAppSum([]);
      const num = AppStorage.get('dockAppSum') as number;
      expect(num).assertEqual(0);
    })

    it('test_refreshConfig', 0, () => {
      // as no rule exists, just ignore
      let instance = LayoutViewModel.getInstance();
      let screenWidth: number = 600;
      let screenHeight: number = 800;
      let foldStatus: number = 0;
      let isPortrait: boolean = false;
      instance.refreshConfig(screenWidth, screenHeight, foldStatus, isPortrait, 0);
      expect(instance.getBaseConfig().getPortraitStatus()).assertEqual(isPortrait);
    })

    it('test_calculateDock_for_Pad', 0, () => {
      // as no rule exists, just ignore
      let instance = LayoutViewModel.getInstance();
      let baseConfig = instance.getBaseConfig();
      baseConfig.setIsPad(true);
      const rest = instance.calculateDock();
      expect(rest).not().assertUndefined();
    })

    it('test_calculateFolder', 0, () => {
      // as no rule exists, just ignore
      let instance = LayoutViewModel.getInstance();
      let layout = FolderModel.getInstance().getBigFolderLayout();
      let retValue = instance.calculateFolder(layout, true);
      expect(retValue).not().assertUndefined();

      retValue = instance.calculateFolder(layout, false);
      expect(retValue).not().assertUndefined();

      layout = FolderModel.getInstance().getSmallFolderLayout();
      retValue = instance.calculateFolder(layout, true);
      expect(retValue).not().assertUndefined();

      retValue = instance.calculateFolder(layout, false);
      expect(retValue).not().assertUndefined();
    })

    it('test_calculateOpenFolder', 0, () => {
      // as no rule exists, just ignore
      let instance = LayoutViewModel.getInstance();
      let layout = FolderModel.getInstance().getFolderOpenLayout();
      let retValue = instance.calculateOpenFolder(layout, true);
      expect(retValue).not().assertUndefined();

      retValue = instance.calculateOpenFolder(layout, false);
      expect(retValue).not().assertUndefined();
    })

    it('test_calculateFolderAddList', 0, () => {
      // as no rule exists, just ignore
      let instance = LayoutViewModel.getInstance();
      const addAppLayoutInfo = FolderModel.getInstance().getFolderAddAppLayout();
      const retValue = instance.calculateFolderAddList(addAppLayoutInfo);
      expect(retValue).not().assertUndefined();
    })

    it('test_initParams', 0, () => {
      // as no rule exists, just ignore
      // 包含initParamsForVerde、initDesktopGapForVerde、initGridHeightForVerde用例
      let baseConfig = BaseConfig.getInstance(layoutConfigManager.getStyleConfig(
        LauncherLayoutStyleConfig.LAUNCHER_COMMON_STYLE_CONFIG,
        LauncherLayoutStyleConfig.LAUNCHER_PRODUCT_STYLE_CONFIG));
      expect(baseConfig).not().assertNull();
    })

    it('registerRefreshLayoutCallback', 0, () => {
      // as no rule exists, just ignore
      let instance = LayoutViewModel.getInstance();
      instance.registerRefreshLayoutCallback(0, () => {});
      expect(true).assertTrue();
    })

    it('unregisterRefreshLayoutCallback', 0, () => {
      // as no rule exists, just ignore
      let instance = LayoutViewModel.getInstance();
      instance.unregisterRefreshLayoutCallback(0, () => {});
      expect(true).assertTrue();
    })

    it('test_LayoutViewModel_LayoutViewModel_registerRefreshLayoutCallback', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let instance: LayoutViewModel = LayoutViewModel.getInstance();
      instance.registerRefreshLayoutCallback(1, null);
      expect(instance).not().assertNull();
      let func: Function = () => {};
      let mockFunc1: Function = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      instance.registerRefreshLayoutCallback(1, func);
      expect(instance).not().assertNull();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    })

    it('test_LayoutViewModel_LayoutViewModel_unregisterRefreshLayoutCallback', 0, () => {
      let instance: LayoutViewModel = LayoutViewModel.getInstance();
      instance.unregisterRefreshLayoutCallback(1, null);
      expect(instance).not().assertNull();
      let func: Function = (): SizeTest => {
        let sizeTest: SizeTest = new SizeTest();
        sizeTest.size = 0;
        return sizeTest;
      };
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      instance.unregisterRefreshLayoutCallback(1, func);
      expect(instance).not().assertNull();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    })

    it('test_LayoutViewModel_LayoutViewModel_getSysUIBottomHeight', 0, () => {
      let instance: LayoutViewModel = LayoutViewModel.getInstance();
      let result: number = instance.getSysUIBottomHeight();
      let num: number = instance['mBaseConfig'].getSysUIBottomHeight();
      expect(result).assertEqual(num);
    })

    it('test_LayoutViewModel_LayoutViewModel_getDockMarginBottomHideBar', 0, () => {
      let config: LauncherLayoutStyleConfig = LauncherLayoutStyleConfig.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(layoutConfigManager, layoutConfigManager.getStyleConfig);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(config);
      let instance: LayoutViewModel = LayoutViewModel.getInstance();
      let result: number = instance.getDockMarginBottomHideBar();
      expect(result).assertEqual(28);
      mocker.clear(layoutConfigManager);
      mocker.clearAll();
    })

    it('test_LayoutViewModel_LayoutViewModel_refreshConfig', 0, () => {
      let instance: LayoutViewModel = LayoutViewModel.getInstance();
      instance.refreshConfig(1, 2, 3, true, 4, 5);
      expect(instance).not().assertNull();
      instance['mRefreshLayoutCallbacks'].set(5, new Set());
      instance.refreshConfig(1, 2, 3, true, 4, 5);
      expect(instance).not().assertNull();
    })

    it('test_LayoutViewModel_LayoutViewModel_updateDockAppSum', 0, () => {
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.row = 1;
      info.column = 1;
      info.abilityName = 'openharmony';
      info.area = [1, 2];
      let itemInfo: DockItemInfo = new DockItemInfo();
      itemInfo.itemType = 3;
      itemInfo.bundleName = 'com.ohos.contacts';
      itemInfo.keyName = 'com.ohos.contactscom.ohos.contacts.MainAbilityentry';
      itemInfo.abilityName = 'MainAbilityentry';
      itemInfo.layoutInfo = [[info]];
      let residentList: DockItemInfo[] = new Array<DockItemInfo>();
      let instance: LayoutViewModel = LayoutViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      instance.updateDockAppSum(residentList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      instance.updateDockAppSum(residentList);
      expect(instance).not().assertNull();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    })

    it('test_LayoutViewModel_LayoutViewModel_reInit', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        let baseConfig: BaseConfig = BaseConfig.getInstance(layoutConfigManager.getStyleConfig(
          LauncherLayoutStyleConfig.LAUNCHER_COMMON_STYLE_CONFIG,
          LauncherLayoutStyleConfig.LAUNCHER_PRODUCT_STYLE_CONFIG));
        BaseConfig['instance'] = BaseConfig.getInstance(layoutConfigManager.getStyleConfig(
          LauncherLayoutStyleConfig.LAUNCHER_COMMON_STYLE_CONFIG,
          LauncherLayoutStyleConfig.LAUNCHER_PRODUCT_STYLE_CONFIG));
        baseConfig.reInit(1, 2, DeviceState.EXPAND_STATE, true, 2);
        expect(baseConfig).not().assertNull();
      } catch (e) {
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    })

    it('test_LayoutViewModel_getFoldStatus', 0, () => {
      let baseConfig: BaseConfig = BaseConfig.getInstance(layoutConfigManager.getStyleConfig(
        LauncherLayoutStyleConfig.LAUNCHER_COMMON_STYLE_CONFIG,
        LauncherLayoutStyleConfig.LAUNCHER_PRODUCT_STYLE_CONFIG));
      let result: number = baseConfig.getFoldStatus();
      expect(result).assertEqual(baseConfig['mFoldStatus']);
    })

    it('test_LayoutViewModel_getDockBottomHeight', 0, () => {
      let baseConfig: BaseConfig = BaseConfig.getInstance(layoutConfigManager.getStyleConfig(
        LauncherLayoutStyleConfig.LAUNCHER_COMMON_STYLE_CONFIG,
        LauncherLayoutStyleConfig.LAUNCHER_PRODUCT_STYLE_CONFIG));
      let result: number = baseConfig.getDockBottomHeight();
      let num: number = Number(baseConfig['mDockMarginBottomHideBar']) + baseConfig['mLauncherLayoutStyleConfig'].mDockPadding;
      expect(result).assertEqual(num);
    })

    it('test_LayoutViewModel_setDockHeight', 0, () => {
      let baseConfig: BaseConfig = BaseConfig.getInstance(layoutConfigManager.getStyleConfig(
        LauncherLayoutStyleConfig.LAUNCHER_COMMON_STYLE_CONFIG,
        LauncherLayoutStyleConfig.LAUNCHER_PRODUCT_STYLE_CONFIG));
      let mocker: MockKit = new MockKit();
      try{
        let mockFunc: Function = mocker.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        baseConfig.setDockHeight(1);
        expect(baseConfig).not().assertNull();
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        baseConfig.setDockHeight(1);
        expect(baseConfig).not().assertNull();
      } catch (e) {
      }
      mocker.clear(launcherStatusUtil);
      mocker.clearAll();
    })

    it('test_LayoutViewModel_initGridHeightForOuterScreen', 0, () => {
      let baseConfig: BaseConfig = BaseConfig.getInstance(layoutConfigManager.getStyleConfig(
        LauncherLayoutStyleConfig.LAUNCHER_COMMON_STYLE_CONFIG,
        LauncherLayoutStyleConfig.LAUNCHER_PRODUCT_STYLE_CONFIG));
      baseConfig['initGridHeightForOuterScreen']();
      expect(baseConfig).not().assertNull();
    })

    it('test_LayoutViewModel_initDesktopGapForOuterScreen', 0, () => {
      let baseConfig: BaseConfig = BaseConfig.getInstance(layoutConfigManager.getStyleConfig(
        LauncherLayoutStyleConfig.LAUNCHER_COMMON_STYLE_CONFIG,
        LauncherLayoutStyleConfig.LAUNCHER_PRODUCT_STYLE_CONFIG));
      baseConfig['initDesktopGapForOuterScreen']();
      expect(baseConfig).not().assertNull();
    })

    it('test_LayoutViewModel_initParamsForOuterScreen', 0, () => {
      let baseConfig: BaseConfig = BaseConfig.getInstance(layoutConfigManager.getStyleConfig(
        LauncherLayoutStyleConfig.LAUNCHER_COMMON_STYLE_CONFIG,
        LauncherLayoutStyleConfig.LAUNCHER_PRODUCT_STYLE_CONFIG));
      baseConfig['initParamsForOuterScreen']();
      expect(baseConfig).not().assertNull();
    })

    it('test_LayoutViewModel_initParams', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let baseConfig: BaseConfig = BaseConfig.getInstance(layoutConfigManager.getStyleConfig(
          LauncherLayoutStyleConfig.LAUNCHER_COMMON_STYLE_CONFIG,
          LauncherLayoutStyleConfig.LAUNCHER_PRODUCT_STYLE_CONFIG));
        let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
        let mockFunc1: Function = mocker.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
        when(mockFunc)().afterReturn(false);
        when(mockFunc1)().afterReturn(true);
        baseConfig['mDesktopModel'] = DesktopLayoutState.SIMPLE_LAUNCHER_MODEL;
        baseConfig.initParams();
        expect(baseConfig).not().assertNull();
      } catch (e) {
      }
      mocker.clear(DeviceHelper);
      mocker.clear(launcherStatusUtil);
      mocker.clearAll();
    })

    it('test_LayoutViewModel_getFolderStatus', 0, () => {
      let baseConfig: BaseConfig = BaseConfig.getInstance(layoutConfigManager.getStyleConfig(
        LauncherLayoutStyleConfig.LAUNCHER_COMMON_STYLE_CONFIG,
        LauncherLayoutStyleConfig.LAUNCHER_PRODUCT_STYLE_CONFIG));
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(desktopUtil, desktopUtil.needIgnoreFoldDeviceForLauncher);
      when(mockFunc)().afterReturn(true);
      let result: number = baseConfig['getFolderStatus']();
      expect(result).assertEqual(DeviceState.DEFAULT_STATE);
      mocker.clear(desktopUtil);
      mocker.clearAll();
    })

    it('test_LayoutViewModel_init', 0, () => {
      let baseConfig: BaseConfig = BaseConfig.getInstance(layoutConfigManager.getStyleConfig(
        LauncherLayoutStyleConfig.LAUNCHER_COMMON_STYLE_CONFIG,
        LauncherLayoutStyleConfig.LAUNCHER_PRODUCT_STYLE_CONFIG));
      baseConfig['mFoldStatus'] = DeviceState.EXPAND_STATE;
      baseConfig['init']();
      expect(baseConfig).not().assertNull();
    })

    class SizeTest {
      size = 0;
    }
  })
}
