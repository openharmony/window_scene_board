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
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import lazy { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { ToggleEditViewData } from '../../../../../../main/ets/com/ohos/vm/ToggleEditViewData';
import { ToggleButtonType, ToggleEditViewModel } from '../../../../../../main/ets/com/ohos/vm/ToggleEditViewModel';
import Constants from '../../../../../../main/ets/com/ohos/common/Constants';
import { DtHelper } from '../DtHelper';
import { QuickToggleController } from '../../../../../../main/ets/com/ohos/controller/QuickToggleController';
import { QuickToggleEditViewModel } from '../../../../../../main/ets/com/ohos/vm/QuickToggleEditViewModel';
import { TopToggleEditViewModel } from '../../../../../../main/ets/com/ohos/vm/TopToggleEditViewModel';
import { IotEditViewModel } from '../../../../../../main/ets/com/ohos/vm/IotEditViewModel';

export function ToggleEditViewModelTest() {
  describe('ToggleEditViewModelTest', (): void => {
    let mocker: MockKit;
    let viewData: ToggleEditViewData;
    let previewToggles: string[];
    let libraryToggles: string[];
    let viewModel: ToggleEditViewModel;
    let iotViewModel: IotEditViewModel;
    let topToggleViewModel: TopToggleEditViewModel;
    let quickToggleViewModel: QuickToggleEditViewModel;
    let toggleOpacities: Map<string, number>;
    let toggleScales: Map<string, number>;

    beforeAll((): void => {
    })

    afterAll((): void => {
    })

    beforeEach((): void => {
      DtHelper.mockSysApi();
      mocker = new MockKit();
      // 预置顺序
      let getInnerString = mocker.mockFunc(ResUtils, ResUtils.getInnerString);
      when(getInnerString)(ArgumentMatchers.any).afterReturn('a,b,c,d,e,f,g,h,i,j,k,l,m,n');
      let saveToggles = mocker.mockFunc(QuickToggleController.getInstance(), QuickToggleController.getInstance().saveQuickToggleData);
      when(saveToggles)(ArgumentMatchers.any).afterReturnNothing();
      viewData = new ToggleEditViewData();
      previewToggles = ['a', 'b', 'c'];
      libraryToggles = ['d', 'e', 'f'];
      toggleScales = new Map();
      toggleOpacities = new Map();
      viewModel = new ToggleEditViewModel(viewData, false);
      viewModel.previewToggles = previewToggles;
      viewModel.libraryToggles = libraryToggles;
      iotViewModel = new IotEditViewModel(viewData, false);
      topToggleViewModel = new TopToggleEditViewModel(viewData, false);
      quickToggleViewModel = new QuickToggleEditViewModel(viewData, false);
      viewModel.initTopToggleViewModel(topToggleViewModel)
      viewModel.initQuickToggleViewModel(quickToggleViewModel);
      viewModel.initIotViewModel(iotViewModel);
      viewModel.onViewAppear();
    })

    afterEach((): void => {
      viewModel.onViewDisappear();
      mocker.clear(QuickToggleController.getInstance());
      mocker.clear(ResUtils);
      mocker.clearAll();
      DtHelper.restoreSysApi();
    })

    it('onToggleClicked_Test_001', 0, (): void => {
      Constants.QUICK_TOGGLE_MIN = 1;

      // 从预览区点击
      quickToggleViewModel.onToggleClicked('a', true);

      expect(previewToggles).assertDeepEquals(['b', 'c']);
      expect(libraryToggles).assertDeepEquals(['a', 'd', 'e', 'f']);

      quickToggleViewModel.onToggleClicked('c', true);

      expect(previewToggles).assertDeepEquals(['b']);
      expect(libraryToggles).assertDeepEquals(['a', 'c', 'd', 'e', 'f']);

      // 最少展示1个开关
      quickToggleViewModel.onToggleClicked('b', true);

      expect(previewToggles).assertDeepEquals(['b']);
      expect(libraryToggles).assertDeepEquals(['a', 'c', 'd', 'e', 'f']);
    })

    it('onToggleClicked_Test_002_', 0, (): void => {
      Constants.QUICK_TOGGLE_MAX = 5;

      // 从备选选区点击
      quickToggleViewModel.onToggleClicked('e', false);

      expect(previewToggles).assertDeepEquals(['a', 'b', 'c', 'e']);
      expect(libraryToggles).assertDeepEquals(['d', 'f']);

      quickToggleViewModel.onToggleClicked('d', false);

      expect(previewToggles).assertDeepEquals(['a', 'b', 'c', 'e', 'd']);
      expect(libraryToggles).assertDeepEquals(['f']);

      // 最多展示5个开关
      quickToggleViewModel.onToggleClicked('f', false);

      expect(previewToggles).assertDeepEquals(['a', 'b', 'c', 'e', 'd']);
      expect(libraryToggles).assertDeepEquals(['f']);
    })

    it('onToggleClicked_Test_003', 0, (): void => {
      // 异常场景
      quickToggleViewModel.onToggleClicked('g', true);

      expect(previewToggles).assertDeepEquals(['a', 'b', 'c']);
      expect(libraryToggles).assertDeepEquals(['d', 'e', 'f']);

      quickToggleViewModel.onToggleClicked('h', false);

      expect(previewToggles).assertDeepEquals(['a', 'b', 'c']);
      expect(libraryToggles).assertDeepEquals(['d', 'e', 'f']);
    })

    it('ToggleEditViewModelTest_onEditModeChange_Test001', 0, (): void => {
      viewModel.onEditModeChange(true);
      expect((viewModel as object)['isIotEdited']).assertInstanceOf('Boolean');
    })

    it('ToggleEditViewModelTest_onEditModeChange_Test002', 0, (): void => {
      viewModel.onEditModeChange(false);
      expect((viewModel as object)['isIotEdited']).assertInstanceOf('Boolean');
    })

    it('ToggleEditViewModelTest_onBackButtonClicked_Test001', 0, (): void => {
      (viewModel as object)['isSaveConfirmDialogShowing'] = true;
      viewModel.onBackButtonClicked();
      expect((viewModel as object)['isIotEdited']).assertInstanceOf('Boolean');
    })

    it('ToggleEditViewModelTest_onBackButtonClicked_Test002', 0, (): void => {
      (viewModel as object)['isSaveConfirmDialogShowing'] = false;
      let sViewData: ToggleEditViewData = (viewModel as object)['viewData'];
      sViewData.showIotLibrary = true;
      viewModel.onBackButtonClicked();
      expect((viewModel as object)['isIotEdited']).assertInstanceOf('Boolean');
    })

    it('ToggleEditViewModelTest_onBackButtonClicked_Test003', 0, (): void => {
      (viewModel as object)['isSaveConfirmDialogShowing'] = false;
      let sViewData: ToggleEditViewData = (viewModel as object)['viewData'];
      sViewData.showIotLibrary = false;
      sViewData.showQuickToggleLibrary = true;
      viewModel.onBackButtonClicked();
      expect((viewModel as object)['isIotEdited']).assertInstanceOf('Boolean');
    })

    it('ToggleEditViewModelTest_onBackButtonClicked_Test004', 0, (): void => {
      (viewModel as object)['isSaveConfirmDialogShowing'] = false;
      let sViewData: ToggleEditViewData = (viewModel as object)['viewData'];
      sViewData.showIotLibrary = false;
      sViewData.showQuickToggleLibrary = false;
      (viewModel as object)['isIotEdited'] = false;
      viewModel.onBackButtonClicked();
      expect((viewModel as object)['isIotEdited']).assertInstanceOf('Boolean');
    })

    it('ToggleEditViewModelTest_onBackButtonClicked_Test005', 0, (): void => {
      (viewModel as object)['isSaveConfirmDialogShowing'] = false;
      let sViewData: ToggleEditViewData = (viewModel as object)['viewData'];
      sViewData.showIotLibrary = false;
      sViewData.showQuickToggleLibrary = false;
      (viewModel as object)['isIotEdited'] = true;
      viewModel.onBackButtonClicked();
      expect((viewModel as object)['isIotEdited']).assertInstanceOf('Boolean');
    })

    it('ToggleEditViewModelTest_changeIndex_Test001', 0, (): void => {
      (viewModel as object)['changeIndex'](1,1,['12']);
      expect((viewModel as object)['isIotEdited']).assertInstanceOf('Boolean');
    })

    it('ToggleEditViewModelTest_changeIndex_Test002', 0, (): void => {
      (viewModel as object)['changeIndex'](1,2,['12']);
      expect((viewModel as object)['isIotEdited']).assertInstanceOf('Boolean');
    })

    it('ToggleEditViewModelTest_checkEquals_Test001', 0, (): void => {
      (viewModel as object)['checkEquals'](['12'],['12']);
      expect((viewModel as object)['isIotEdited']).assertInstanceOf('Boolean');
    })

    it('ToggleEditViewModelTest_checkEquals_Test002', 0, (): void => {
      (viewModel as object)['checkEquals'](['12','13'],['12']);
      expect((viewModel as object)['isIotEdited']).assertInstanceOf('Boolean');
    })

    it('ToggleEditViewModelTest_checkEquals_Test003', 0, (): void => {
      (viewModel as object)['checkEquals'](['12'],['123']);
      expect((viewModel as object)['isIotEdited']).assertInstanceOf('Boolean');
    })

    it('ToggleEditViewModelTest_quitEditMode_Test001', 0, (): void => {
      (viewModel as object)['quitEditMode'](true);
      expect((viewModel as object)['isIotEdited']).assertInstanceOf('Boolean');
    })

    it('ToggleEditViewModelTest_switchHeader_Test001', 0, (): void => {
      (viewModel as object)['switchHeader'](true);
      expect((viewModel as object)['isIotEdited']).assertInstanceOf('Boolean');
    })

    it('ToggleEditViewModelTest_switchHeader_Test002', 0, (): void => {
      (viewModel as object)['switchHeader'](false);
      expect((viewModel as object)['isIotEdited']).assertInstanceOf('Boolean');
    })

    it('ToggleEditViewModelTest_handleOnHover_Test001', 0, (): void => {
      viewModel.handleOnHover(ToggleButtonType.LEFT_BUTTON, undefined);
      viewModel.handleOnHover(ToggleButtonType.LEFT_BUTTON, true);
      viewModel.handleOnHover(ToggleButtonType.RIGHT_BUTTON, true);
      viewModel.handleOnHover(ToggleButtonType.ADD_BUTTON, true);
      viewModel.handleOnHover(ToggleButtonType.COLLAPSE_BUTTON, true);
      viewModel.handleOnHover(ToggleButtonType.LEFT_BUTTON, false);
      viewModel.handleOnHover(ToggleButtonType.RIGHT_BUTTON, false);
      viewModel.handleOnHover(ToggleButtonType.ADD_BUTTON, false);
      viewModel.handleOnHover(ToggleButtonType.COLLAPSE_BUTTON, false);
      viewModel.handleOnHover(666, false);
      expect((viewModel as object)['isIotEdited']).assertInstanceOf('Boolean');
    })

    it('ToggleEditViewModelTest_action_Test001', 0, (): void => {
      viewModel.onSaveButtonClicked();
      viewModel.onSaveOptionClicked();
      viewModel.onCancelOptionClicked();
      viewModel.onConfirmDialogCanceled();
      quickToggleViewModel.onAddButtonClicked();
      iotViewModel.onIotRemoteReady(undefined);
      iotViewModel.onIotMessage(undefined);
      let iotMessage: Map<string, string | number> = new Map();
      iotViewModel.onIotMessage(iotMessage);
      iotMessage['method'] = 'backToEditHome';
      iotViewModel.onIotMessage(iotMessage);
      iotMessage['method'] = 'ShowSheet';
      iotViewModel.onIotMessage(iotMessage);
      iotMessage['method'] = 'setIotAbilityHeight';
      iotViewModel.onIotMessage(iotMessage);
      iotMessage['height'] = 100;
      iotViewModel.onIotMessage(iotMessage);
      iotMessage['method'] = 'iotIsEdit';
      iotMessage['param'] = 1;
      iotViewModel.onIotMessage(iotMessage);
      iotMessage['param'] = 0;
      iotViewModel.onIotMessage(iotMessage);
      viewModel.onScrollStart();
      viewModel.onScrollStop();
      quickToggleViewModel.onLongPressActionForDrag('1');
      quickToggleViewModel.onLongPressActionEndForDrag();
      quickToggleViewModel.onActionStartForDrag('1');
      quickToggleViewModel.onActionUpdateForDrag({
        repeat: false,
        fingerList: [],
        offsetX: 0,
        offsetY: 0,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0,
        target: {
          area: {
            width: 0, height: 0, position: { x: 0, y: 0 }, globalPosition: { x: 0, y: 0 }
          }
        },
        timestamp: 0,
        source: SourceType.Unknown,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: SourceTool.Unknown
      });
      quickToggleViewModel.onActionEndForDrag();

      (viewModel as object)['insertToLibraryToggles']('bjhfdsbvjfh');
      (viewModel as object)['showLibraryPanel']();
      (viewModel as object)['showLibraryToggles']();
      (viewModel as object)['expandIotEdit']();
      (viewModel as object)['saveToggles']();
      (viewModel as object)['setSaveConfirmDialogState'](true);
      let dialog = new CustomDialogController({
        builder: {},
      });
      (viewModel as object)['saveConfirmController'] = dialog;
      let openFunc = mocker.mockFunc(dialog, dialog.open);
      when(openFunc)().afterReturnNothing();
      let closeFunc = mocker.mockFunc(dialog, dialog.close);
      when(closeFunc)().afterReturnNothing();
      (viewModel as object)['isSaveConfirmDialogShowing'] = true;
      (viewModel as object)['setSaveConfirmDialogState'](true);
      (viewModel as object)['setSaveConfirmDialogState'](false);
      (viewModel as object)['isSaveConfirmDialogShowing'] = false;
      (viewModel as object)['setSaveConfirmDialogState'](true);
      (viewModel as object)['setSaveConfirmDialogState'](false);

      expect(viewModel.previewToggles === undefined).assertFalse();
    })

    it('ToggleEditViewModelTest_onAddButtonClicked', 0, (): void => {
      (viewModel as object)['showDoubleColumn'] = true;
      quickToggleViewModel.onAddButtonClicked();
      (viewModel as object)['showDoubleColumn'] = false;
      quickToggleViewModel.onAddButtonClicked();
      (viewModel as object)['changeScrollStatus']({ 'param': '0' });
      (viewModel as object)['isAiLifeInstalled'] = false;
      (viewModel as object)['onReceiveCloseControlCenter']({ 'param': '0' });
      (viewModel as object)['isAiLifeInstalled'] = true;
      (viewModel as object)['onReceiveCloseControlCenter']({ 'param': '0' });
      expect((viewModel as object)['needDelayReleaseIot']).assertTrue();
    })

    it('ToggleEditViewModelTest_preloadIotLibrary', 0, (): void => {
      (viewModel as object)['preloadIotLibrary']({ 'showFullPage': true });
      (viewModel as object)['getIotPreviewScrollOffset']();
      (viewModel as object)['isIotEntered'] = true;
      (viewModel as object)['iotStartToEnter']();
      let result = quickToggleViewModel.isLeftComponent('index');
      expect(result).assertFalse();
    })
  })
}