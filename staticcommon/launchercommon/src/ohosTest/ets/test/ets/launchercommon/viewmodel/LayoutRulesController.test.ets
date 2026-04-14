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
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium'
import {
  LayoutRulesController,
  LayoutViewModel,
  GridLayoutConfig,
  SettingsModel,
  FolderLayoutStruct,
  StyleConstants,
  PresetStyleConstants
} from '../../../../../../main/ets/TsIndex';

export default function LayoutRulesControllerTest() {
  describe('LayoutRulesControllerTest', () => {
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
    it('test_LayoutRulesController_getInstance', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const baseConfig = LayoutViewModel.getInstance().getBaseConfig();
      const ruleController = LayoutRulesController.getInstance(baseConfig);
      expect(ruleController.calculateDock()).not().assertNull();
    })

    it('test_calculateForm_calculate_form_dimensions_correctly', 0, async () => {
      const baseConfig = LayoutViewModel.getInstance().getBaseConfig();
      const ruleController = LayoutRulesController.getInstance(baseConfig);
      let mocker: MockKit = new MockKit();
      let mockGridConfig: Function = mocker.mockFunc(SettingsModel.getInstance(),
        SettingsModel.getInstance().getGridConfig);
      let testGridConfig: GridLayoutConfig = {
        id: 10,
        layout: '3X4',
        name: '3X4',
        value: 1,
        row: 3,
        column: 4,
        checked: false
      }
      when(mockGridConfig)(ArgumentMatchers.any).afterReturn(testGridConfig);
      expect(ruleController.calculateForm()).not().assertNull();
      mocker.clear(SettingsModel);
      mocker.clearAll();
    });

    it('test_calculateForm_calculate_with_different_grid_config', 0, async () => {
      const baseConfig = LayoutViewModel.getInstance().getBaseConfig();
      const ruleController = LayoutRulesController.getInstance(baseConfig);
      let mocker: MockKit = new MockKit();

      // Mock getGridConfig返回row=2, column=5
      let mockGridConfig: Function = mocker.mockFunc(SettingsModel.getInstance(),
        SettingsModel.getInstance().getGridConfig);
      let testGridConfig: GridLayoutConfig = {
        id: 10,
        layout: '2X5',
        name: '2X5',
        value: 1,
        row: 2,
        column: 5,
        checked: false
      }
      when(mockGridConfig)(ArgumentMatchers.any).afterReturn(testGridConfig);

      // 其他mock设置，保持其他参数不变
      let mockGetDesktopGap: Function = mocker.mockFunc(baseConfig, baseConfig.getDesktopGap);
      when(mockGetDesktopGap)(ArgumentMatchers.any).afterReturn(5);

      let mockGetIconNameMarginTop: Function = mocker.mockFunc(baseConfig, baseConfig.getIconNameMarginTop);
      when(mockGetIconNameMarginTop)(ArgumentMatchers.any).afterReturn(10);

      let mockGetDesktopIconSize: Function = mocker.mockFunc(baseConfig, baseConfig.getDesktopIconSize);
      when(mockGetDesktopIconSize)(ArgumentMatchers.any).afterReturn(20);

      let mockGetGridRealHeight: Function = mocker.mockFunc(baseConfig, baseConfig.getGridRealHeight);
      when(mockGetGridRealHeight)(ArgumentMatchers.any).afterReturn(30);

      let mockGetDesktopIconNameMargin: Function = mocker.mockFunc(baseConfig, baseConfig.getDesktopIconNameMargin);
      when(mockGetDesktopIconNameMargin)(ArgumentMatchers.any).afterReturn(40);

      let mockGetGridRealWidth: Function = mocker.mockFunc(baseConfig, baseConfig.getGridRealWidth);
      when(mockGetGridRealWidth)(ArgumentMatchers.any).afterReturn(50);

      let result = ruleController.calculateForm();

      // 计算预期值
      const gridRow = 2;
      const gridColumn = 5;
      const gap = 5;
      const iconSize = 20;
      const gridRealHeight = 30;
      const gridRealWidth = 50;
      const folderSize = (30 + 5) / 2 + 20; // 35/2=17.5 +20=37.5
      const widthDimension3 = (50 + 5) / 5 * 3 + 20; //55/5=11 *3=33 +20=53
      const heightDimension4 = (30 + 5) / 2 * 3 + 20; //35/2=17.5 *3=52.5 +20=72.5

      expect(result.widthDimension1).assertEqual(folderSize);
      expect(result.heightDimension1).assertEqual(iconSize);
      expect(result.widthDimension2).assertEqual(folderSize);
      expect(result.heightDimension2).assertEqual(folderSize);
      expect(result.widthDimension3).assertEqual(widthDimension3);
      expect(result.heightDimension3).assertEqual(folderSize);
      expect(result.widthDimension4).assertEqual(widthDimension3);
      expect(result.heightDimension4).assertEqual(heightDimension4);
      expect(result.mIconNameMargin).assertEqual(40);
      expect(result.mIconNameMarginTop).assertEqual(10);

      // 恢复mock
      mocker.clear(SettingsModel);
      mocker.clear(baseConfig);
      mocker.clearAll();
    });

    it('test_calculateForm_calculate_with_zero_gap', 0, async () => {
      const baseConfig = LayoutViewModel.getInstance().getBaseConfig();
      const ruleController = LayoutRulesController.getInstance(baseConfig);
      let mocker: MockKit = new MockKit();
      let mockGridConfig: Function = mocker.mockFunc(SettingsModel.getInstance(),
        SettingsModel.getInstance().getGridConfig);
      let testGridConfig: GridLayoutConfig = {
        id: 10,
        layout: '3X4',
        name: '3X4',
        value: 1,
        row: 3,
        column: 4,
        checked: false
      }
      when(mockGridConfig)(ArgumentMatchers.any).afterReturn(testGridConfig);

      let mockGetDesktopGap: Function = mocker.mockFunc(baseConfig, baseConfig.getDesktopGap);
      when(mockGetDesktopGap)(ArgumentMatchers.any).afterReturn(0);

      let mockGetIconNameMarginTop: Function = mocker.mockFunc(baseConfig, baseConfig.getIconNameMarginTop);
      when(mockGetIconNameMarginTop)(ArgumentMatchers.any).afterReturn(10);

      let mockGetDesktopIconSize: Function = mocker.mockFunc(baseConfig, baseConfig.getDesktopIconSize);
      when(mockGetDesktopIconSize)(ArgumentMatchers.any).afterReturn(20);

      let mockGetGridRealHeight: Function = mocker.mockFunc(baseConfig, baseConfig.getGridRealHeight);
      when(mockGetGridRealHeight)(ArgumentMatchers.any).afterReturn(30);

      let mockGetDesktopIconNameMargin: Function = mocker.mockFunc(baseConfig, baseConfig.getDesktopIconNameMargin);
      when(mockGetDesktopIconNameMargin)(ArgumentMatchers.any).afterReturn(40);

      let mockGetGridRealWidth: Function = mocker.mockFunc(baseConfig, baseConfig.getGridRealWidth);
      when(mockGetGridRealWidth)(ArgumentMatchers.any).afterReturn(50);

      let result = ruleController.calculateForm();

      // 计算预期值
      const gridRow = 3;
      const gridColumn = 4;
      const gap = 0;
      const iconSize = 20;
      const gridRealHeight = 30;
      const gridRealWidth = 50;
      const folderSize = (30 + 0) / 3 + 20;
      const widthDimension3 = (50 + 0) / 4 * 3 + 20;
      const heightDimension4 = (30 + 0) / 3 * 3 + 20;

      expect(result.widthDimension1).assertEqual(30);
      expect(result.heightDimension1).assertEqual(20);
      expect(result.widthDimension2).assertEqual(30);
      expect(result.heightDimension2).assertEqual(30);
      expect(result.widthDimension3).assertEqual(57.5);
      expect(result.heightDimension3).assertEqual(30);
      expect(result.widthDimension4).assertEqual(57.5);
      expect(result.heightDimension4).assertEqual(50);

      // 恢复mock
      mocker.clear(SettingsModel);
      mocker.clear(baseConfig);
      mocker.clearAll();
    });

    it('test_calculateFolder_layout_correctly', 0, async () => {
      const baseConfig = LayoutViewModel.getInstance().getBaseConfig();
      const ruleController = LayoutRulesController.getInstance(baseConfig);
      let mocker: MockKit = new MockKit();
      let mockGridConfig: Function = mocker.mockFunc(SettingsModel.getInstance(),
        SettingsModel.getInstance().getGridConfig);
      let testGridConfig: GridLayoutConfig = {
        id: 10,
        layout: '4X3',
        name: '4X3',
        value: 1,
        row: 4,
        column: 3,
        checked: false
      }
      when(mockGridConfig)(ArgumentMatchers.any).afterReturn(testGridConfig);

      let mockGetGridRealHeight: Function = mocker.mockFunc(baseConfig, baseConfig.getGridRealHeight);
      let mockGetDesktopIconSize: Function = mocker.mockFunc(baseConfig, baseConfig.getDesktopIconSize);
      let mockGetDesktopGap: Function = mocker.mockFunc(baseConfig, baseConfig.getDesktopGap);
      let mockGetIconNameMarginTop: Function = mocker.mockFunc(baseConfig, baseConfig.getIconNameMarginTop);
      let mockGetDesktopIconNameMargin: Function = mocker.mockFunc(baseConfig, baseConfig.getDesktopIconNameMargin);
      let mockGetDesktopNameLines: Function = mocker.mockFunc(baseConfig, baseConfig.getDesktopNameLines);
      let mockGetNameHeight: Function = mocker.mockFunc(baseConfig, baseConfig.getNameHeight);

      when(mockGetGridRealHeight)(ArgumentMatchers.any).afterReturn(300);
      when(mockGetDesktopIconSize)(ArgumentMatchers.any).afterReturn(70);
      when(mockGetDesktopGap)(ArgumentMatchers.any).afterReturn(10);
      when(mockGetIconNameMarginTop)(ArgumentMatchers.any).afterReturn(3);
      when(mockGetDesktopIconNameMargin)(ArgumentMatchers.any).afterReturn(0);
      when(mockGetDesktopNameLines)(ArgumentMatchers.any).afterReturn(1);
      when(mockGetNameHeight)(ArgumentMatchers.any).afterReturn(17);

      let folderLayoutStruct: FolderLayoutStruct = new FolderLayoutStruct();
      let result = ruleController.calculateFolder(folderLayoutStruct);

      expect(result.mGridSize).assertEqual((300 + 10) / 4 + 70); //folderSize 147.5
      expect(result.mGridItemSize).assertEqual(147.5 + 17 * 1 + 3);
      expect(result.mNameHeight).assertEqual(17);
      expect(result.mNameLines).assertEqual(1);
      expect(result.mIconNameMargin).assertEqual(0);
      expect(result.mIconNameMarginTop).assertEqual(3);

      mocker.clear(SettingsModel);
      mocker.clear(baseConfig);
      mocker.clearAll();
    });

    it('test_calculateFolder_ignore_isInPreviewMode_parameter', 0, async () => {
      const baseConfig = LayoutViewModel.getInstance().getBaseConfig();
      const ruleController = LayoutRulesController.getInstance(baseConfig);
      const mocker = new MockKit();
      let mockGridConfig: Function = mocker.mockFunc(SettingsModel.getInstance(),
        SettingsModel.getInstance().getGridConfig);
      let testGridConfig: GridLayoutConfig = {
        id: 10,
        layout: '4X3',
        name: '4X3',
        value: 1,
        row: 4,
        column: 3,
        checked: false
      }
      when(mockGridConfig)(ArgumentMatchers.any).afterReturn(testGridConfig);
      // Mock基础配置
      let mockGetGridRealHeight: Function = mocker.mockFunc(baseConfig, baseConfig.getGridRealHeight);
      let mockGetDesktopIconSize: Function = mocker.mockFunc(baseConfig, baseConfig.getDesktopIconSize);
      let mockGetDesktopGap: Function = mocker.mockFunc(baseConfig, baseConfig.getDesktopGap);
      let mockGetIconNameMarginTop: Function = mocker.mockFunc(baseConfig, baseConfig.getIconNameMarginTop);
      let mockGetDesktopIconNameMargin: Function = mocker.mockFunc(baseConfig, baseConfig.getDesktopIconNameMargin);
      let mockGetDesktopNameLines: Function = mocker.mockFunc(baseConfig, baseConfig.getDesktopNameLines);
      let mockGetNameHeight: Function = mocker.mockFunc(baseConfig, baseConfig.getNameHeight);

      // mock BaseConfig的方法
      when(mockGetGridRealHeight)(ArgumentMatchers.any).afterReturn(100);
      when(mockGetDesktopIconSize)(ArgumentMatchers.any).afterReturn(20);
      when(mockGetDesktopGap)(ArgumentMatchers.any).afterReturn(5);
      when(mockGetIconNameMarginTop)(ArgumentMatchers.any).afterReturn(3);
      when(mockGetDesktopIconNameMargin)(ArgumentMatchers.any).afterReturn(4);
      when(mockGetDesktopNameLines)(ArgumentMatchers.any).afterReturn(2);
      when(mockGetNameHeight)(ArgumentMatchers.any).afterReturn(1);

      const layoutInfo = new FolderLayoutStruct();
      const resultWithPreview = ruleController.calculateFolder(layoutInfo, true);
      const resultWithoutPreview = ruleController.calculateFolder(layoutInfo);

      expect(resultWithPreview).assertDeepEquals(resultWithoutPreview);

      mocker.clear(baseConfig);
      mocker.clear(SettingsModel);
      mocker.clearAll();
    });

    it('test_calculateDesktop_desktop_layout_correctly_when_isPad_is_false', 0, async () => {
      let mocker: MockKit = new MockKit();
      const baseConfig = LayoutViewModel.getInstance().getBaseConfig();
      const ruleController = LayoutRulesController.getInstance(baseConfig);
      let mockGridConfig: Function = mocker.mockFunc(SettingsModel.getInstance(),
        SettingsModel.getInstance().getGridConfig);
      let testGridConfig: GridLayoutConfig = {
        id: 10,
        layout: '4X3',
        name: '4X3',
        value: 1,
        row: 4,
        column: 3,
        checked: false
      }
      when(mockGridConfig)(ArgumentMatchers.any).afterReturn(testGridConfig);
      let mockGetScreenWidth: Function = mocker.mockFunc(baseConfig, baseConfig.getScreenWidth);
      let mockGetWorkSpaceHeight: Function = mocker.mockFunc(baseConfig, baseConfig.getWorkSpaceHeight);
      let mockGetNameHeight: Function = mocker.mockFunc(baseConfig, baseConfig.getNameHeight);
      let mockGetIndicatorHeight: Function = mocker.mockFunc(baseConfig, baseConfig.getIndicatorHeight);
      let mockGetSysUITopHeight: Function = mocker.mockFunc(baseConfig, baseConfig.getSysUITopHeight);
      let mockGetIsPad: Function = mocker.mockFunc(baseConfig, baseConfig.getIsPad);
      let mockGetItemSize: Function = mocker.mockFunc(baseConfig, baseConfig.getItemSize);
      let mockGetDefaultDisplay: Function = mocker.mockFunc(baseConfig, baseConfig.getDefaultDisplay);
      let mockGetIconNameMarginTop: Function = mocker.mockFunc(baseConfig, baseConfig.getIconNameMarginTop);
      let mockGetItemPadding: Function = mocker.mockFunc(baseConfig, baseConfig.getItemPadding);

      // 设置densityDPI大于L_DPI_DENSITY（假设L_DPI_DENSITY=240）
      when(mockGetScreenWidth)(ArgumentMatchers.any).afterReturn(1080);
      when(mockGetWorkSpaceHeight)(ArgumentMatchers.any).afterReturn(1920);
      when(mockGetNameHeight)(ArgumentMatchers.any).afterReturn(50);
      when(mockGetIndicatorHeight)(ArgumentMatchers.any).afterReturn(50);
      when(mockGetSysUITopHeight)(ArgumentMatchers.any).afterReturn(50);
      when(mockGetIsPad)(ArgumentMatchers.any).afterReturn(false);
      when(mockGetItemSize)(ArgumentMatchers.any).afterReturn(50);
      when(mockGetDefaultDisplay)(ArgumentMatchers.any).afterReturn({
        densityDPI: 300
      }); // 密度大于阈值
      when(mockGetIconNameMarginTop)(ArgumentMatchers.any).afterReturn(10);
      when(mockGetItemPadding)(ArgumentMatchers.any).afterReturn(10);

      expect(ruleController.calculateDesktop()).not().assertNull();

      mocker.clear(baseConfig);
      mocker.clear(SettingsModel);
      mocker.clearAll();
    });

    // 测试isPad为false的情况
    it('test_calculateFolderAddList_correctly_when_isPad_is_false', 0, async () => {
      const mocker = new MockKit();
      const baseConfig = LayoutViewModel.getInstance().getBaseConfig();
      const ruleController = LayoutRulesController.getInstance(baseConfig);
      const layoutStyleConfig = baseConfig.getLauncherLayoutStyleConfig();

      // Mock所有需要的函数
      const mockScreenWidth = mocker.mockFunc(baseConfig, baseConfig.getScreenWidth);
      const mockScreenHeight = mocker.mockFunc(baseConfig, baseConfig.getScreenHeight);
      const mockSysUITopHeight = mocker.mockFunc(baseConfig, baseConfig.getSysUITopHeight);
      const mockIsPad = mocker.mockFunc(baseConfig, baseConfig.getIsPad);
      const mockIconNameMarginTop = mocker.mockFunc(baseConfig, baseConfig.getIconNameMarginTop);

      // 设置mock返回值
      when(mockScreenWidth)(ArgumentMatchers.any).afterReturn(1080);
      when(mockScreenHeight)(ArgumentMatchers.any).afterReturn(1920);
      when(mockSysUITopHeight)(ArgumentMatchers.any).afterReturn(200);
      when(mockIsPad)(ArgumentMatchers.any).afterReturn(false);
      when(mockIconNameMarginTop)(ArgumentMatchers.any).afterReturn(10);

      // 创建被测对象
      const addFolderConfig: GridLayoutConfig = {
        id: 10,
        layout: '2X4',
        name: '2X4',
        value: 1,
        row: 2,
        column: 4,
        checked: false
      };

      // 执行被测方法
      const result = ruleController.calculateFolderAddList(addFolderConfig);

      // 验证关键计算结果
      const expectedScreenColumns = PresetStyleConstants.DEFAULT_PHONE_GRID_APP_COLUMNS;
      const columnsWidth = 1080 - 2 * PresetStyleConstants.DEFAULT_SCREEN_GRID_GAP_AND_MARGIN
        - (expectedScreenColumns - 1) * PresetStyleConstants.DEFAULT_SCREEN_GRID_GAP_AND_MARGIN;
      const columnWidth = columnsWidth / expectedScreenColumns;
      const layoutWidth = columnWidth * 4 + (4 - 1) * PresetStyleConstants.DEFAULT_SCREEN_GRID_GAP_AND_MARGIN;
      const gridSize = layoutWidth - 2 * layoutStyleConfig.mFolderAddGridMargin;

      expect(result.mAddFolderGridWidth).assertEqual(gridSize);
      expect(result.mAddFolderDialogWidth).assertEqual(layoutWidth);
      expect(result.mAddFolderIconSize).assertLarger(0);

      // 还原mock
      mocker.clear(baseConfig);
      mocker.clearAll();
    });

    // 测试isPad为true的情况
    it('test_calculateFolderAddList_correctly_when_isPad_is_true', 0, async () => {
      const mocker = new MockKit();
      const baseConfig = LayoutViewModel.getInstance().getBaseConfig();
      const ruleController = LayoutRulesController.getInstance(baseConfig);
      const layoutStyleConfig = baseConfig.getLauncherLayoutStyleConfig();

      // Mock所有需要的函数
      const mockScreenWidth = mocker.mockFunc(baseConfig, baseConfig.getScreenWidth);
      const mockScreenHeight = mocker.mockFunc(baseConfig, baseConfig.getScreenHeight);
      const mockSysUITopHeight = mocker.mockFunc(baseConfig, baseConfig.getSysUITopHeight);
      const mockIsPad = mocker.mockFunc(baseConfig, baseConfig.getIsPad);
      const mockIconNameMarginTop = mocker.mockFunc(baseConfig, baseConfig.getIconNameMarginTop);

      // 设置mock返回值
      when(mockScreenWidth)(ArgumentMatchers.any).afterReturn(1200);
      when(mockScreenHeight)(ArgumentMatchers.any).afterReturn(1920);
      when(mockSysUITopHeight)(ArgumentMatchers.any).afterReturn(200);
      when(mockIsPad)(ArgumentMatchers.any).afterReturn(true);
      when(mockIconNameMarginTop)(ArgumentMatchers.any).afterReturn(10);

      // 创建被测对象
      const addFolderConfig: GridLayoutConfig = {
        id: 10,
        layout: '2X5',
        name: '2X5',
        value: 1,
        row: 2,
        column: 5,
        checked: false
      };

      // 执行被测方法
      const result = ruleController.calculateFolderAddList(addFolderConfig);

      // 验证关键计算结果
      const expectedScreenColumns = PresetStyleConstants.DEFAULT_PAD_GRID_APP_COLUMNS;
      const columnsWidth = 1200 - 2 * PresetStyleConstants.DEFAULT_SCREEN_GRID_GAP_AND_MARGIN
        - (expectedScreenColumns - 1) * PresetStyleConstants.DEFAULT_SCREEN_GRID_GAP_AND_MARGIN;
      const columnWidth = columnsWidth / expectedScreenColumns;
      const layoutWidth = columnWidth * 5 + (5 - 1) * PresetStyleConstants.DEFAULT_SCREEN_GRID_GAP_AND_MARGIN;

      expect(result.mAddFolderDialogWidth).assertEqual(layoutWidth);
      expect(result.mAddFolderGridGap).assertEqual(layoutStyleConfig.mFolderAddGridGap);

      // 还原mock
      mocker.clear(baseConfig);
      mocker.clearAll();
    });

    // 测试column为1的边界情况
    it('test_calculateFolderAddList_correctly_with_column_1', 0, async () => {
      const mocker = new MockKit();
      const baseConfig = LayoutViewModel.getInstance().getBaseConfig();
      const ruleController = LayoutRulesController.getInstance(baseConfig);
      const layoutStyleConfig = baseConfig.getLauncherLayoutStyleConfig();

      // Mock所有需要的函数
      const mockScreenWidth = mocker.mockFunc(baseConfig, baseConfig.getScreenWidth);
      const mockScreenHeight = mocker.mockFunc(baseConfig, baseConfig.getScreenHeight);
      const mockSysUITopHeight = mocker.mockFunc(baseConfig, baseConfig.getSysUITopHeight);
      const mockIsPad = mocker.mockFunc(baseConfig, baseConfig.getIsPad);
      const mockIconNameMarginTop = mocker.mockFunc(baseConfig, baseConfig.getIconNameMarginTop);

      // 设置mock返回值
      when(mockScreenWidth)(ArgumentMatchers.any).afterReturn(800);
      when(mockScreenHeight)(ArgumentMatchers.any).afterReturn(1200);
      when(mockSysUITopHeight)(ArgumentMatchers.any).afterReturn(50);
      when(mockIsPad)(ArgumentMatchers.any).afterReturn(false);
      when(mockIconNameMarginTop)(ArgumentMatchers.any).afterReturn(5);

      // 创建被测对象
      const addFolderConfig: GridLayoutConfig = {
        id: 10,
        layout: '1X1',
        name: '1X1',
        value: 1,
        row: 1,
        column: 1,
        checked: false
      };

      // 执行被测方法
      const result = ruleController.calculateFolderAddList(addFolderConfig);

      // 验证关键计算结果
      const expectedScreenColumns = PresetStyleConstants.DEFAULT_PHONE_GRID_APP_COLUMNS;
      const columnsWidth = 800 - 2 * PresetStyleConstants.DEFAULT_SCREEN_GRID_GAP_AND_MARGIN
        - (expectedScreenColumns - 1) * PresetStyleConstants.DEFAULT_SCREEN_GRID_GAP_AND_MARGIN;
      const columnWidth = columnsWidth / expectedScreenColumns;
      const layoutWidth = columnWidth * 1;
      const gridSize = layoutWidth - StyleConstants.DEFAULT_2 * layoutStyleConfig.mFolderAddGridMargin;

      expect(result.mAddFolderDialogWidth).assertEqual(layoutWidth);
      expect(result.mAddFolderItemSize).assertEqual(
        (gridSize - (1 - 1) * layoutStyleConfig.mFolderAddGridGap) / 1
      );

      // 还原mock
      mocker.clear(baseConfig);
      mocker.clearAll();
    });

    it('test_calculateDock_correctly_when_navigation_bar_status_is_false', 0, async () => {
      let mocker: MockKit = new MockKit();
      const baseConfig = LayoutViewModel.getInstance().getBaseConfig();
      const ruleController = LayoutRulesController.getInstance(baseConfig);
      const layoutStyleConfig = baseConfig.getLauncherLayoutStyleConfig();

      layoutStyleConfig.mDockItemGap = 10;
      layoutStyleConfig.mDockMarginBottom = 20;
      layoutStyleConfig.mDockMarginBottomHideBar = 30;
      layoutStyleConfig.mDockMaxRecentNumber = 5;
      layoutStyleConfig.mDockSaveMargin = 4;
      layoutStyleConfig.mDockIconSize = 6;
      layoutStyleConfig.mDockGutter = 7;
      layoutStyleConfig.mDockRadius = 8;
      layoutStyleConfig.mBackdropBlur = 10;
      layoutStyleConfig.mBackSaturation = 11;
      layoutStyleConfig.mDockPadding = 12;
      layoutStyleConfig.mMinResidentNumber = 13;

      let mockGetNavigationBarStatus: Function = mocker.mockFunc(baseConfig, baseConfig.getNavigationBarStatus);
      when(mockGetNavigationBarStatus)(ArgumentMatchers.any).afterReturn(false);

      let mockGetScreenWidth: Function = mocker.mockFunc(baseConfig, baseConfig.getScreenWidth);
      when(mockGetScreenWidth)(ArgumentMatchers.any).afterReturn(1000);

      let mockGetDockHeight: Function = mocker.mockFunc(baseConfig, baseConfig.getDockHeight);
      when(mockGetDockHeight)(ArgumentMatchers.any).afterReturn(500);

      let mockGetSysUIBottomHeight: Function = mocker.mockFunc(baseConfig, baseConfig.getSysUIBottomHeight);
      when(mockGetSysUIBottomHeight)(ArgumentMatchers.any).afterReturn(300);

      let mockGetNameHeight: Function = mocker.mockFunc(baseConfig, baseConfig.getNameHeight);
      when(mockGetNameHeight)(ArgumentMatchers.any).afterReturn(200);

      let mockGetIconNameMarginTop: Function = mocker.mockFunc(baseConfig, baseConfig.getIconNameMarginTop);
      when(mockGetIconNameMarginTop)(ArgumentMatchers.any).afterReturn(100);

      let mockGetWorkSpaceHeight: Function = mocker.mockFunc(baseConfig, baseConfig.getWorkSpaceHeight);
      when(mockGetWorkSpaceHeight)(ArgumentMatchers.any).afterReturn(800);

      let mockGetItemPadding: Function = mocker.mockFunc(baseConfig, baseConfig.getItemPadding);
      when(mockGetItemPadding)(ArgumentMatchers.any).afterReturn(10);

      let mockGetIsPad: Function = mocker.mockFunc(baseConfig, baseConfig.getIsPad);
      when(mockGetIsPad)(ArgumentMatchers.any).afterReturn(false);

      let mockDesktopGap: Function = mocker.mockFunc(baseConfig, baseConfig.getDesktopGap);
      when(mockDesktopGap)(ArgumentMatchers.any).afterReturn(5);

      let result = ruleController.calculateDock();

      expect(result.mListItemGap).assertEqual(5 + 2 * 10 + 200 + 100);
      expect(result.mMarginBottom).assertEqual(20);
      expect(result.mListItemWidth).assertEqual(6);
      expect(result.mListItemHeight).assertEqual(6);
      expect(result.mDockHeight).assertEqual(6 + 2 * 12);

      mocker.clear(baseConfig);
      mocker.clearAll();
    });

    it('test_calculateDock_correctly_when_is_pad_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      const baseConfig = LayoutViewModel.getInstance().getBaseConfig();
      const ruleController = LayoutRulesController.getInstance(baseConfig);
      const layoutStyleConfig = baseConfig.getLauncherLayoutStyleConfig();

      layoutStyleConfig.mDockItemGap = 10;
      layoutStyleConfig.mDockMarginBottom = 20;
      layoutStyleConfig.mDockMarginBottomHideBar = 30;
      layoutStyleConfig.mDockMaxRecentNumber = 5;
      layoutStyleConfig.mDockSaveMargin = 4;
      layoutStyleConfig.mDockIconSize = 6;
      layoutStyleConfig.mDockGutter = 7;
      layoutStyleConfig.mDockRadius = 8;
      layoutStyleConfig.mBackdropBlur = 10;
      layoutStyleConfig.mBackSaturation = 11;
      layoutStyleConfig.mDockPadding = 12;
      layoutStyleConfig.mMinResidentNumber = 13;

      let mockGetNavigationBarStatus: Function = mocker.mockFunc(baseConfig, baseConfig.getNavigationBarStatus);
      when(mockGetNavigationBarStatus)(ArgumentMatchers.any).afterReturn(false);

      let mockGetScreenWidth: Function = mocker.mockFunc(baseConfig, baseConfig.getScreenWidth);
      when(mockGetScreenWidth)(ArgumentMatchers.any).afterReturn(1000);

      let mockGetDockHeight: Function = mocker.mockFunc(baseConfig, baseConfig.getDockHeight);
      when(mockGetDockHeight)(ArgumentMatchers.any).afterReturn(500);

      let mockGetSysUIBottomHeight: Function = mocker.mockFunc(baseConfig, baseConfig.getSysUIBottomHeight);
      when(mockGetSysUIBottomHeight)(ArgumentMatchers.any).afterReturn(300);

      let mockGetNameHeight: Function = mocker.mockFunc(baseConfig, baseConfig.getNameHeight);
      when(mockGetNameHeight)(ArgumentMatchers.any).afterReturn(200);

      let mockGetIconNameMarginTop: Function = mocker.mockFunc(baseConfig, baseConfig.getIconNameMarginTop);
      when(mockGetIconNameMarginTop)(ArgumentMatchers.any).afterReturn(100);

      let mockGetWorkSpaceHeight: Function = mocker.mockFunc(baseConfig, baseConfig.getWorkSpaceHeight);
      when(mockGetWorkSpaceHeight)(ArgumentMatchers.any).afterReturn(800);

      let mockGetItemPadding: Function = mocker.mockFunc(baseConfig, baseConfig.getItemPadding);
      when(mockGetItemPadding)(ArgumentMatchers.any).afterReturn(10);

      let mockGetIsPad: Function = mocker.mockFunc(baseConfig, baseConfig.getIsPad);
      when(mockGetIsPad)(ArgumentMatchers.any).afterReturn(true);

      let mockGetDesktopGap: Function = mocker.mockFunc(baseConfig, baseConfig.getDesktopGap);
      when(mockGetDesktopGap)(ArgumentMatchers.any).afterReturn(20);

      let result = ruleController.calculateDock();

      expect(result.mListItemGap).assertEqual(10); // 因为isPad为true时使用原始mDockItemGap
      expect(result.mMarginBottom).assertEqual(20);
      expect(result.mMaxRecentNum).assertEqual(5);
      expect(result.mListItemWidth).assertEqual(6);
      expect(result.mListItemHeight).assertEqual(6);
      expect(result.mDockHeight).assertEqual(6 + 2 * 12);

      mocker.clear(baseConfig);
      mocker.clearAll();
    });
  })
}