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
import { ViewType, GlobalContext } from '@ohos/frameworkwrapper';
import { LogDomain, Logger } from '@ohos/basicutils';
import { BaseViewController } from '@ohos/frameworkcommon';
import { SCBScreenProperty } from '@ohos/windowscene';
import {
  QuickToggleController
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/QuickToggleController';
import { ToggleData } from '@ohos/controlcentercomponent/src/main/ets/com/ohos/common/Constants';
import { EditModeModel } from '../model/EditModeModel';
import { EditModeBar } from './EditModeBar';
import { EditModePanelVm } from '../vm/EditModePanelVm';
import { EditModeGrid } from './EditModeGrid';
import { EditModeGridVm } from '../vm/EditModeGridVm';
import { EditModePromptStyle } from '../style/EditModeStyle';
import { EditModeBarViewData } from '../viewData/EditModeBarViewData';
import { EditModeBarVm } from '../vm/EditModeBarVm';
import { EditModeGridData } from '../viewData/EditModeGridViewData';

const TAG = 'SCBControlEditView';
const log: Logger = Logger.getLogHelper(LogDomain.SCB);

@Component
export struct SCBControlEditView {
  private persistentId: number = 0;
  @Link screenProp: SCBScreenProperty;
  @StorageLink('QuickToggleData') @Watch('onToggleDataChange') toggleData: ToggleData =
    QuickToggleController.getInstance().getToggleData();
  @StorageLink('isLock') @Watch('onLock') isLock: boolean = true;
  @Provide castDialogIsOpen: boolean = false;
  @Provide superDeviceDialogIsOpen: boolean = false;
  @Provide microphoneDialogIsOpen: boolean = false;
  // 编辑页Vm
  private editModeVm: EditModeModel = new EditModeModel();
  // 二级菜单
  private viewController: BaseViewController = new BaseViewController(
    ViewType.EDIT_MODE_PANEL, this.screenProp.screenId);
  private editModePanelVm: EditModePanelVm = new EditModePanelVm(this.viewController);
  // 编辑页Bar
  @State editModeBarViewData: EditModeBarViewData = new EditModeBarViewData();
  private editModeBarVm: EditModeBarVm = new EditModeBarVm(this.editModeBarViewData);
  // 编辑页选中图标
  @State selectedGridViewData: EditModeGridData = new EditModeGridData();
  private selectedGridVm: EditModeGridVm = new EditModeGridVm(this.selectedGridViewData, true);
  // 编辑页待选图标
  @State candidateGridViewData: EditModeGridData = new EditModeGridData();
  private candidateGridVm: EditModeGridVm = new EditModeGridVm(this.candidateGridViewData, false);

  aboutToAppear(): void {
    log.showInfo(TAG, 'SCBControlEditView aboutToAppear');
    this.viewController.updateId(this.persistentId);
    this.editModeVm.initEditModeVm({
      editModeBarVm: this.editModeBarVm,
      editModePanelVm: this.editModePanelVm,
      editModeSelectedGridVm: this.selectedGridVm,
      editModeCandidateGridVm: this.candidateGridVm,
      screenProperty: this.screenProp,
    });
    this.onToggleDataChange();
    let initToggleDataBridger = GlobalContext.getInstance().getObject('initToggleDataBridger');
    if (initToggleDataBridger) {
      (initToggleDataBridger as Function)();
    }
  }

  aboutToDisappear(): void {
    log.showInfo(TAG, 'SCBControlEditView aboutToDisappear');
    this.editModeVm.destroyEditModeVm();
  }

  onToggleDataChange(): void {
    log.showInfo(TAG, `onToggleDataChange quickToggle ${this.toggleData.quickToggle.toString()}`);
    log.showInfo(TAG, `onToggleDataChange otherToggle ${this.toggleData.otherToggle.toString()}`);
    this.editModeVm.updateEditModeGridData(this.toggleData.quickToggle, true);
    this.editModeVm.updateEditModeGridData(this.toggleData.otherToggle, false);
    this.editModeVm.refreshLayout();
  }

  onLock(): void {
    if (this.isLock) {
      this.editModeVm.onLockScreen();
    }
  }

  @Builder
  editModeBar() {
    EditModeBar({
      viewData: this.editModeBarViewData,
      editModeBarVm: this.editModeBarVm,
    })
  }

  @Builder
  editModeSelectedGrid() {
    EditModeGrid({
      viewData: this.selectedGridViewData,
      editModeGridVm: this.selectedGridVm,
      isSelectedGrid: true,
    })
  }

  @Builder
  editModePrompt() {
    Row() {
      Text($r('app.string.edit_mode_panel_prompt'))
        .fontSize(EditModePromptStyle.getInstance().size)
        .fontFamily('HarmonyHeiTi')
        .fontWeight(FontWeight.Medium)
        .fontColor(EditModePromptStyle.getInstance().contentColor)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .textAlign(TextAlign.Center)
        .width(EditModePromptStyle.getInstance().width)
    }
    .padding(EditModePromptStyle.getInstance().margin)
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  editModePreviewGrid() {
    EditModeGrid({
      viewData: this.candidateGridViewData,
      editModeGridVm: this.candidateGridVm,
      isSelectedGrid: false,
    })
  }

  build() {
    Column() {
      // 编辑栏
      this.editModeBar()

      // 编辑页选中数据
      this.editModeSelectedGrid()

      // 编辑页提示语
      this.editModePrompt()

      // 编辑页预览数据
      this.editModePreviewGrid()
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
  }
}