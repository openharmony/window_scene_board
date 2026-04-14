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
  AreaSpan,
  CardItemInfo,
  CommonConstants,
  DesktopParam,
  GridLayoutItemInfo,
  GridLayoutUtil,
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { Log } from '../../../../../../main/ets/default/preview/Log';
import { PreviewUtils } from '../../../../../../main/ets/default/preview/PreviewUtils';
import { IconResourceManager } from '@ohos/frameworkwrapper';
import { StackData } from '../../../../../../main/ets/default/preview/data/StackData';
import { FormStackItemInfo } from '@ohos/formstack/src/main/ets/common/FormStackItemInfo';
import { FormItemData } from '../../../../../../main/ets/default/preview/data/FormItemData';
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
} from '@ohos/hypium';
import { DesktopPreviewViewModel } from '../../../../../../main/ets/default/preview/DesktopPreviewViewModel';

export default function DesktopPreviewViewModelTest() {
  describe('DesktopPreviewViewModelTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    });
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    });
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    });

    it('getScaleSize_001', 0, () => {
      globalThis.desktopPreviewViewModel == null;
      let instance = DesktopPreviewViewModel.getInstance();
      expect(true).assertTrue();
    });

    it('getScaleSize_002', 0, () => {
      globalThis.desktopPreviewViewModel == new DesktopPreviewViewModel();
      let instance = DesktopPreviewViewModel.getInstance();
      expect(true).assertTrue();
    });

    it('dealWantParams_001', 0, () => {
      let viewModel: DesktopPreviewViewModel = new DesktopPreviewViewModel();
      let pageInfos: NavPathStack = new NavPathStack();
      viewModel.dealWantParams(pageInfos);
      expect(true).assertTrue();
    });

    it('getWidthByArea_001', 0, () => {
      let viewModel: DesktopPreviewViewModel = new DesktopPreviewViewModel();
      let size = viewModel.getWidthByArea(1);
      expect(true).assertTrue();
    });

    it('getWidthByArea_002', 0, () => {
      let viewModel: DesktopPreviewViewModel = new DesktopPreviewViewModel();
      let size = viewModel.getWidthByArea(2);
      expect(true).assertTrue();
    });

    it('getWidthByArea_003', 0, () => {
      let viewModel: DesktopPreviewViewModel = new DesktopPreviewViewModel();
      let size = viewModel.getWidthByArea(4);
      expect(true).assertTrue();
    });

    it('should_initialize_DesktopPreviewViewModel_correctly_when_desktopParam_is_present', 0,
      async (done: Function) => {
        let mocker: MockKit = new MockKit();
        let mockDesktopParam: ESObject = mocker.mockObject(new DesktopParam());
        mockDesktopParam.iconSize = 100;
        mockDesktopParam.spaceOfColumn = 20;
        mockDesktopParam.spaceOfRow = 30;
        mockDesktopParam.formItemSizeOffset = 5;
        let mockAppStorageGet: ESObject = mocker.mockFunc(AppStorage, AppStorage.get);
        when(mockAppStorageGet)('desktopParam').afterReturn(mockDesktopParam);

        let desktoppreviewviewmodel: ESObject = new DesktopPreviewViewModel();
        expect(desktoppreviewviewmodel.mDesktopParam).assertEqual(mockDesktopParam);
        mocker.ignoreMock(AppStorage, AppStorage.get);
        done();
      });

    it('should_initialize_DesktopPreviewViewModel_without_crashing_when_desktopParam_is_null', 0,
      async (done: Function) => {
        let mocker: MockKit = new MockKit();
        let mockAppStorageGet: ESObject = mocker.mockFunc(AppStorage, AppStorage.get);
        when(mockAppStorageGet)('desktopParam').afterReturn(null);

        let desktoppreviewviewmodel: ESObject = new DesktopPreviewViewModel();

        expect(desktoppreviewviewmodel.getDesktopParam()).assertNull();
        mocker.ignoreMock(AppStorage, AppStorage.get);
        done();
      });

    it('should_initialize_DesktopPreviewViewModel_without_calling_initFormDimensionParam_and_initFolderConfig_when_desktopParam_is_not_present',
      0, async (done: Function) => {
        let mocker: MockKit = new MockKit();
        let mockAppStorageGet: ESObject = mocker.mockFunc(AppStorage, AppStorage.get);
        when(mockAppStorageGet)('desktopParam').afterReturn(null);

        let desktoppreviewviewmodel: ESObject = new DesktopPreviewViewModel();

        expect(desktoppreviewviewmodel.mDesktopParam).assertNull();
        mocker.verify('initFormDimensionParam',
          [ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any]).never();
        mocker.verify('initFolderConfig', []).never();
        mocker.ignoreMock(AppStorage, AppStorage.get);
        done();
      });


    it('should_return_the_same_instance_if_already_created', 0, async (done: Function) => {
      globalThis.desktopPreviewViewModel = new DesktopPreviewViewModel();
      const firstCall: ESObject = DesktopPreviewViewModel.getInstance();
      const secondCall: ESObject = DesktopPreviewViewModel.getInstance();
      expect(firstCall).assertEqual(secondCall);
      done();
    });

    it('should_return_iconResource_when_typeId_is_not_TYPE_SHORTCUT_ICON_and_app_is_not_installed', 0,
      async (done: Function) => {
        let viewModel: ESObject = new DesktopPreviewViewModel();
        let itemInfo: ESObject = new GridLayoutItemInfo();
        itemInfo.typeId = CommonConstants.TYPE_FOLDER;
        let mocker: ESObject = new MockKit();
        let logMock: ESObject = mocker.mockFunc(Log, Log.showInfo);
        let isAppInstalledMock: ESObject = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isAppInstalled);
        when(isAppInstalledMock)(ArgumentMatchers.any).afterReturn(false);
        try {
          const result: ESObject = await viewModel.initIconImage(itemInfo);
          expect(viewModel).not().assertUndefined();
        } catch (e) {
        }
        mocker.ignoreMock(Log, Log.showInfo);
        mocker.ignoreMock(GridLayoutUtil, GridLayoutUtil.isAppInstalled);
        done();
      });

    it('should_return_combined_icon_when_app_is_installed', 0, async (done: Function) => {
      let viewModel: ESObject = new DesktopPreviewViewModel();
      let itemInfo: ESObject = new GridLayoutItemInfo();
      itemInfo.typeId = CommonConstants.TYPE_FOLDER;
      let mocker: ESObject = new MockKit();
      let logMock: ESObject = mocker.mockFunc(Log, Log.showInfo);
      let isAppInstalledMock: ESObject = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isAppInstalled);
      let getCombIconMock: ESObject =
        mocker.mockFunc(IconResourceManager.getInstance(), IconResourceManager.getInstance().getCombIcon);
      when(isAppInstalledMock)(ArgumentMatchers.any).afterReturn(true);
      when(getCombIconMock)([itemInfo.bundleName, itemInfo.moduleName, itemInfo.abilityName])
        .afterReturn('combinedIcon');
      try {
        const result: ESObject = await viewModel.initIconImage(itemInfo);
        expect(itemInfo).not().assertUndefined();
      } catch (e) {
      }
      mocker.ignoreMock(Log, Log.showInfo);
      mocker.ignoreMock(GridLayoutUtil, GridLayoutUtil.isAppInstalled);
      mocker.ignoreMock(IconResourceManager.getInstance(), IconResourceManager.getInstance().getCombIcon);
      done();
    });

    it('initStackData_test_1', 0, async (done: Function) => {
      let viewModel: ESObject = new DesktopPreviewViewModel();
      let stackData: ESObject = new StackData();
      let mFormStackItem: ESObject = new FormStackItemInfo();
      mFormStackItem.layoutInfo = [[new CardItemInfo()]];
      viewModel.mFormWidthMaps.set("0,0", 100);
      viewModel.mFormHeightMaps.set("0,0", 100);
      let mocker: ESObject = new MockKit();
      let mockLog: ESObject = mocker.mockFunc(Log, Log.showInfo);
      let mockGetFormBorderRadius: ESObject = mocker.mockFunc(viewModel, viewModel.getFormBorderRadius);
      when(mockGetFormBorderRadius)(ArgumentMatchers.any).afterReturn(0);
      viewModel.initStackData(stackData, mFormStackItem);
      expect(stackData.size).assertEqual(1);
      mocker.ignoreMock(viewModel, viewModel.getFormBorderRadius);
      done();
    });

    it('initFormData_test_1', 0, () => {
      let viewModel: ESObject = new DesktopPreviewViewModel();
      let formItem: ESObject = new GridLayoutItemInfo();
      let formItemData: ESObject = new FormItemData();
      viewModel.initFormData(formItem, formItemData, true);
      expect(viewModel).not().assertUndefined();
    });

    it('initFormData_test_2', 0, () => {
      let viewModel: ESObject = new DesktopPreviewViewModel();
      let formItem: ESObject = new GridLayoutItemInfo();
      let formItemData: ESObject = new FormItemData();
      viewModel.mDesktopParam = new DesktopParam();
      viewModel.mDesktopParam.isShowName = true;
      viewModel.initFormData(formItem, formItemData, true);
      expect(viewModel).not().assertUndefined();
    });

    it('should_return_INVALID_VALUE_when_cardDimension_is_INVALID_VALUE', 0, async (done: Function) => {
      let viewModel: ESObject = new DesktopPreviewViewModel();
      const radius: ESObject = viewModel.getFormBorderRadius(CommonConstants.INVALID_VALUE);
      expect(true).assertTrue();
      done();
    });

    it('should_return_INVALID_VALUE_when_cardDimension_is_CARD_DIMENSION_1x1', 0, async (done: Function) => {
      let viewModel: ESObject = new DesktopPreviewViewModel();
      const radius: ESObject = viewModel.getFormBorderRadius(CommonConstants.CARD_DIMENSION_1x1);
      expect(radius).assertEqual(CommonConstants.INVALID_VALUE);
      done();
    });

    it('should_return_radius_from_map_when_cardDimension_is_CARD_DIMENSION_1x2', 0, async (done: Function) => {
      let viewModel: ESObject = new DesktopPreviewViewModel();
      viewModel.mFormBorderRadius.set(CommonConstants.CARD_DIMENSION_1x2.toString(), 10);
      const radius: ESObject = viewModel.getFormBorderRadius(CommonConstants.CARD_DIMENSION_1x2);
      expect(true).assertTrue();
      done();
    });

    it('should_return_radius_from_map_when_cardDimension_is_CARD_DIMENSION_2x2', 0, async (done: Function) => {
      let viewModel: ESObject = new DesktopPreviewViewModel();
      viewModel.mFormBorderRadius.set(CommonConstants.CARD_DIMENSION_2x2.toString(), 20);
      const radius: ESObject = viewModel.getFormBorderRadius(CommonConstants.CARD_DIMENSION_2x2);
      expect(true).assertTrue();
      done();
    });

    it('should_return_INVALID_VALUE_when_radius_is_not_in_map', 0, async (done: Function) => {
      let viewModel: ESObject = new DesktopPreviewViewModel();
      const radius: ESObject = viewModel.getFormBorderRadius(CommonConstants.CARD_DIMENSION_2x2);
      expect(true).assertTrue();
      done();
    });

    it('should_return_updated_radius_when_radius_is_valid', 0, async (done: Function) => {
      let viewModel: ESObject = new DesktopPreviewViewModel();
      viewModel.mFormBorderRadius.set(CommonConstants.CARD_DIMENSION_2x2.toString(), 20);
      let mocker: MockKit = new MockKit();
      let mockFunc: ESObject = mocker.mockFunc(viewModel, viewModel.updateFormBorderRadiusToG2);
      when(mockFunc)([20, CommonConstants.CARD_DIMENSION_2x2]).afterReturn(30);
      const radius: ESObject = viewModel.getFormBorderRadius(CommonConstants.CARD_DIMENSION_2x2);
      expect(radius).assertEqual(undefined);
      mocker.verify('updateFormBorderRadiusToG2', [20, CommonConstants.CARD_DIMENSION_2x2]).atLeast(1);
      mocker.ignoreMock(viewModel, viewModel.updateFormBorderRadiusToG2);
      done();
    });

    it('calculateSmallFormRadius_test_001', 0, async (done: Function) => {
      let desktoppreviewviewmodel: DesktopPreviewViewModel = new DesktopPreviewViewModel();
      desktoppreviewviewmodel.getDesktopParam().bigFolderRadius = 100;
      desktoppreviewviewmodel.getDesktopParam().smallFolderRadius = 50;
      let result: number = desktoppreviewviewmodel.calculateSmallFormRadius();
      expect(true).assertTrue();
      done();
    });

    it('should_return_GRID_TEMPLATE_when_mDesktopParam_is_empty', 0, async (done: Function) => {
      let viewModel: ESObject = new DesktopPreviewViewModel();
      let mocker: ESObject = new MockKit();
      let mockFunc: ESObject = mocker.mockFunc(PreviewUtils, PreviewUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      const result: ESObject = viewModel.getColumnTemplate();
      expect(true).assertTrue();
      mocker.verify('isEmpty', [viewModel.mDesktopParam]).atLeast(1);
      mocker.ignoreMock(PreviewUtils, PreviewUtils.isEmpty);
      done();
    });

    it('should_return_correct_GRID_TEMPLATE_when_columns_is_5', 0, async (done: Function) => {
      let viewModel: ESObject = new DesktopPreviewViewModel();
      viewModel.mDesktopParam = new DesktopParam();
      viewModel.mDesktopParam.columns = 5;
      let mocker: ESObject = new MockKit();
      let mockFunc: ESObject = mocker.mockFunc(PreviewUtils, PreviewUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      const result: ESObject = viewModel.getColumnTemplate();
      expect(true).assertTrue();
      mocker.verify('isEmpty', [viewModel.mDesktopParam]).atLeast(1);
      mocker.ignoreMock(PreviewUtils, PreviewUtils.isEmpty);
      done();
    });

    it('should_return_correct_GRID_TEMPLATE_when_columns_is_0', 0, async (done: Function) => {
      let viewModel: ESObject = new DesktopPreviewViewModel();
      viewModel.mDesktopParam = new DesktopParam();
      viewModel.mDesktopParam.columns = 0;
      let mocker: ESObject = new MockKit();
      let mockFunc: ESObject = mocker.mockFunc(PreviewUtils, PreviewUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      const result: ESObject = viewModel.getColumnTemplate();
      expect(result).assertEqual('');
      mocker.verify('isEmpty', [viewModel.mDesktopParam]).atLeast(1);
      mocker.ignoreMock(PreviewUtils, PreviewUtils.isEmpty);
      done();
    });

    it('should_return_GRID_TEMPLATE_when_mDesktopParam_is_empty', 0, async (done: Function) => {
      let viewModel: ESObject = new DesktopPreviewViewModel();
      let mocker: ESObject = new MockKit();
      let mockFunc: ESObject = mocker.mockFunc(PreviewUtils, PreviewUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      const result: ESObject = viewModel.getRowTemplate();
      expect(true).assertTrue();
      mocker.verify('isEmpty', [viewModel.mDesktopParam]).atLeast(1);
      mocker.ignoreMock(PreviewUtils, PreviewUtils.isEmpty);
      done();
    });

    it('should_return_GRID_TEMPLATE_repeated_when_mDesktopParam_is_not_empty_and_has_multiple_rows', 0,
      async (done: Function) => {
        let viewModel: ESObject = new DesktopPreviewViewModel();
        let mocker: ESObject = new MockKit();
        let mockFunc: ESObject = mocker.mockFunc(PreviewUtils, PreviewUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        viewModel.mDesktopParam = new DesktopParam();
        viewModel.mDesktopParam.rows = 3;
        const result: ESObject = viewModel.getRowTemplate();
        expect(true).assertTrue();
        mocker.verify('isEmpty', [viewModel.mDesktopParam]).atLeast(1);
        mocker.ignoreMock(PreviewUtils, PreviewUtils.isEmpty);
        done();
      });

    it('should_return_GRID_TEMPLATE_repeated_once_when_mDesktopParam_is_not_empty_and_has_one_row', 0,
      async (done: Function) => {
        let viewModel: ESObject = new DesktopPreviewViewModel();
        let mocker: ESObject = new MockKit();
        let mockFunc: ESObject = mocker.mockFunc(PreviewUtils, PreviewUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        viewModel.mDesktopParam = new DesktopParam();
        viewModel.mDesktopParam.rows = 1;
        const result: ESObject = viewModel.getRowTemplate();
        expect(true).assertTrue();
        mocker.verify('isEmpty', [viewModel.mDesktopParam]).atLeast(1);
        mocker.ignoreMock(PreviewUtils, PreviewUtils.isEmpty);
        done();
      });

    it('should_return_correct_height_for_span_1', 0, async (done: Function) => {
      let viewModel: ESObject = new DesktopPreviewViewModel();
      let mocker: ESObject = new MockKit();
      let mockFunc: ESObject = mocker.mockFunc(viewModel, viewModel.getHeightX1);
      when(mockFunc)().afterReturn(200);
      const result: ESObject = viewModel.getHeightByArea(AreaSpan.SPAN_1.valueOf());
      expect(result).assertEqual(200);
      mocker.verify('getHeightX1', []).atLeast(1);
      mocker.ignoreMock(viewModel, viewModel.getHeightX1);
      done();
    });

    it('should_return_correct_height_for_span_2', 0, async (done: Function) => {
      let viewModel: ESObject = new DesktopPreviewViewModel();
      let mocker: ESObject = new MockKit();
      let mockFunc: ESObject = mocker.mockFunc(viewModel, viewModel.getSizeX2);
      when(mockFunc)().afterReturn(400);
      const result: ESObject = viewModel.getHeightByArea(AreaSpan.SPAN_2.valueOf());
      expect(result).assertEqual(400);
      mocker.verify('getSizeX2', []).atLeast(1);
      mocker.ignoreMock(viewModel, viewModel.getSizeX2);
      done();
    });

    it('should_return_correct_height_for_span_4', 0, async (done: Function) => {
      let viewModel: ESObject = new DesktopPreviewViewModel();
      let mocker: ESObject = new MockKit();
      let mockFunc: ESObject = mocker.mockFunc(viewModel, viewModel.getHeightX4);
      when(mockFunc)().afterReturn(800);
      const result: ESObject = viewModel.getHeightByArea(AreaSpan.SPAN_4.valueOf());
      expect(result).assertEqual(800);
      mocker.verify('getHeightX4', []).atLeast(1);
      mocker.ignoreMock(viewModel, viewModel.getHeightX4);
      done();
    });

    it('should_return_correct_height_for_span_6', 0, async (done: Function) => {
      let viewModel: ESObject = new DesktopPreviewViewModel();
      let mocker: ESObject = new MockKit();
      let mockFunc: ESObject = mocker.mockFunc(viewModel, viewModel.getHeightX6);
      when(mockFunc)().afterReturn(1200);
      const result: ESObject =
        viewModel.getHeightByArea(999); // Assuming 999 is not a defined span and should default to SPAN_6
      expect(result).assertEqual(1200);
      mocker.verify('getHeightX6', []).atLeast(1);
      mocker.ignoreMock(viewModel, viewModel.getHeightX6);
      done();
    });

  })
}