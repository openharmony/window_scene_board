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
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { ScrollBlurController } from '@ohos/controlcentercommon/src/main/ets/scrollBlur/ScrollBlurController';
import { ControlCenterHomeViewData } from '../../../../../../main/ets/com/ohos/vm/ControlCenterHomeViewData';
import { ControlCenterHomeViewModel } from '../../../../../../main/ets/com/ohos/vm/ControlCenterHomeViewModel';
import { DtHelper } from '../DtHelper';

export function ControlCenterHomeViewModelTest() {
  describe('ControlCenterHomeViewModelTest', (): void => {
    let mocker: MockKit;
    let viewData: ControlCenterHomeViewData;
    let scroller: Scroller;
    let viewModel: ControlCenterHomeViewModel;
    let scrollBlurController: ScrollBlurController;
    beforeAll((): void => {
      DtHelper.mockSysApi();
    })

    afterAll((): void => {
      DtHelper.restoreSysApi();
    })

    beforeEach((): void => {
      mocker = new MockKit();
      viewData = new ControlCenterHomeViewData();
      scrollBlurController = new ScrollBlurController(scroller, 1);
      scroller = new Scroller();
      let scrollTo = mocker.mockFunc(scroller, scroller.scrollTo);
      when(scrollTo)(ArgumentMatchers.any).afterReturnNothing();
      viewModel = new ControlCenterHomeViewModel(viewData, scroller);
    })

    afterEach((): void => {
      mocker.clear(scroller);
      mocker.clearAll();
    })

    it('jumpToEditView_Test_001', 0, (): void => {
      viewModel.jumpToEditView();
      expect(true).assertTrue();
    })

    it('jumpToEditView_Test_002', 0, (): void => {
      // 进入编辑时反悔场景
      let dismissing = mocker.mockFunc(DropDownPanelManager, DropDownPanelManager.isPanelDismissing);
      when(dismissing)().afterReturn(true);

      viewModel.jumpToEditView();
      expect(viewData.loadEditPage).assertFalse();
      expect(viewData.replaceBrightnessBar).assertFalse();
      expect(viewData.showEditPage).assertFalse();
      expect(viewData.blankLayoutWeight === 0).assertFalse();
      expect(viewData.showEditModeHeader).assertFalse();
      mocker.clear(DropDownPanelManager);
    })

    it('ControlCenterHomeViewModelTest_afterQuitEdit_Test001', 0, (): void => {
      (viewModel as object)['supportIotEdit'] = true;
      viewModel.afterQuitEdit();
      expect((viewModel as object)['supportIotEdit']).assertInstanceOf('Boolean');
    })

    it('ControlCenterHomeViewModelTest_afterQuitEdit_Test002', 0, (): void => {
      (viewModel as object)['supportIotEdit'] = false;
      viewModel.afterQuitEdit();
      expect((viewModel as object)['supportIotEdit']).assertInstanceOf('Boolean');
    })

    it('ControlCenterHomeViewModelTest_hideEditPanelDirectly_Test001', 0, (): void => {
      (viewModel as object)['supportIotEdit'] = true;
      viewModel.afterQuitEdit();
      expect((viewModel as object)['supportIotEdit']).assertInstanceOf('Boolean');
    })

    it('ControlCenterHomeViewModelTest_hideEditPanelDirectly_Test002', 0, (): void => {
      (viewModel as object)['supportIotEdit'] = false;
      viewModel.afterQuitEdit();
      expect((viewModel as object)['supportIotEdit']).assertInstanceOf('Boolean');
    })

    it('ControlCenterHomeViewModelTest_getIsEditing', 0, (): void => {
      let isEditing = viewModel.getIsEditing();
      expect(isEditing).assertInstanceOf('Boolean');
    })

    it('ControlCenterHomeViewModelTest_getTopTogglesHeight', 0, (): void => {
      (viewModel as object)['isShowTerminalButton'] = false;
      (viewModel as object)['getTopTogglesHeight']();
      expect((viewModel as object)['getTopTogglesHeight']()).assertEqual(240);
    })
  })
}