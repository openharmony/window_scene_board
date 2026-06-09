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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { CheckboxParentEnum, CheckboxParentLayoutEnum, CheckboxViewState } from '../data/MultiSelectData';
import { MultiSelectCheckboxViewModel } from '../viewModel/MultiSelectCheckboxViewModel';
import { AppItemInfo, GridLayoutItemInfo, GridLayoutUtil, EditModeUtils, CommonConstants,
  StyleConstants, editModeManager } from '../../TsIndex';
import { MultiSelectStyleConfig } from '../data/MultiSelectStyleConfig';
import { Position } from '@kit.ArkUI';

const TAG: string = 'MultiSelectCheckboxView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Component
export struct MultiSelectCheckboxView {
  /** 父组件id */
  private parentId: string = '';
  /** 父组件类型 */
  private parentType: CheckboxParentEnum = CheckboxParentEnum.App;
  /** 父组件宽度 */
  private iconSize: number = StyleConstants.DEFAULT_APP_ICON_SIZE_WIDTH;
  /** 圆角 */
  private radius: number = CommonConstants.DEFAULT_ICON_RADIUS;
  /** 用于获取范围的id */
  private rectId: string = '';
  /** 父组件的appItemInfo */
  private parentItemInfo: AppItemInfo = new AppItemInfo();
  /** 父组件布局类型 */
  private parentLayoutType: CheckboxParentLayoutEnum = CheckboxParentLayoutEnum.Relative;
  /** viewModel */
  private checkboxVm: MultiSelectCheckboxViewModel = new MultiSelectCheckboxViewModel();
  /** 多选框显示和选择状态 */
  @State checkboxViewState: CheckboxViewState = this.checkboxVm.getCheckboxShowState();
  /** 是否在落位过程中 */
  @Prop @Watch('onIsInDragChange') isInDrag: boolean = false;
  /** 是否在卸载过程中 */
  @Prop isShowCancelDialog: boolean = false;

  @Prop checkboxOpacity: number = 1;

  private isOuterDesktop: boolean = false;

  /** 获取parentLayoutType.Relative状态下的offset */
  private getRelativeOffset(): Position {
    const gap: number = this.getIconGap();
    let offset: number = this.getCheckboxSize() / 2 - gap;
    const res: Position = { x: (this.iconSize / 2) - offset, y: offset };
    return res;
  }

  /** 获取checkbox突出Icon的距离 */
  private getIconGap(): number {
    let gap: number;
    if (this.parentType === CheckboxParentEnum.Folder &&
      !GridLayoutUtil.isSmallFolder(this.parentItemInfo as Object as GridLayoutItemInfo)
    ) {
      gap = MultiSelectStyleConfig.CHECKBOX_FOLDER_GAP;
    } else {
      gap = MultiSelectStyleConfig.CHECKBOX_APP_GAP;
    }
    return EditModeUtils.recoverWithDesktopScale(gap);
  }

  private getCheckboxSize(): number {
    return EditModeUtils.recoverWithDesktopScale(editModeManager.getEditModeStyleConfig().checkboxSize)
  }

  private onIsInDragChange(): void {
    if (!this.isInDrag) {
      log.showInfo(`drop end, show checkbox`);
      this.checkboxVm.show(!this.isShowCancelDialog);
    }
  }

  aboutToDisappear(): void {
    this.checkboxVm.unregister();
    this.checkboxVm.destroy();
  }

  @Styles
  baseInfo() {
    .id(this.isOuterDesktop ? `${TAG}_${this.parentId}_OuterDesktop` : `${TAG}_${this.parentId}`)
    .size({ width: this.getCheckboxSize(), height: this.getCheckboxSize()})
    .hitTestBehavior(HitTestMode.None)
    .visibility(this.checkboxViewState.show ? Visibility.Visible : Visibility.Hidden)
    .onAppear(() => this.checkboxVm.init({
      parentItemInfo: this.parentItemInfo,
      parentType: this.parentType,
      iconSize: this.iconSize,
      rectId: this.rectId,
      parentId: this.parentId,
      radius: this.radius,
      isInDrag: this.isInDrag,
      isOuterDesktop: this.isOuterDesktop
    }))
    .accessibilityLevel('no')
    .opacity(this.checkboxOpacity)
  }

  build() {
    if (this.parentLayoutType === CheckboxParentLayoutEnum.Relative) {
      Checkbox()
        .baseInfo()
        .select(this.checkboxViewState.checked)
        .alignRules({
          middle: { anchor: this.rectId, align: HorizontalAlign.Center },
          center: { anchor: this.rectId, align: VerticalAlign.Top },
        })
        .offset(this.getRelativeOffset())
        .focusable(false)
    } else if (this.parentLayoutType === CheckboxParentLayoutEnum.Stack) {
      Checkbox()
        .baseInfo()
        .select(this.checkboxViewState.checked)
        .margin(0)
        .position({ x: this.iconSize, y: 0 })
        .markAnchor({
          x: this.getCheckboxSize() - this.getIconGap(),
          y: this.getIconGap()
        })
        .focusable(false)
    }
  }
}