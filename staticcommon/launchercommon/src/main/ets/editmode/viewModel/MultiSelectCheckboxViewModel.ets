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
import { LogDomain, LogHelper, } from '@ohos/basicutils';
import { AppItemInfo, EditModeUtils, FolderData } from '../../TsIndex';
import {
  CheckboxCheckState,
  CheckboxParentEnum,
  CheckboxViewState,
  MultiSelectStatus,
  type CheckboxInfoType,
  type CheckboxVmConstructorType,
  type MultiSelectListenerType
} from '../data/MultiSelectData';
import { MultiSelectStyleConfig } from '../data/MultiSelectStyleConfig';
import MultiSelectCheckboxManager from '../model/MultiSelectCheckboxManager';
import {
  ListenerItemType,
  multiSelectListenManager as multiSelectListenManger
} from '../model/MultiSelectListenerManager';
import { MultiSelectManager } from '../model/MultiSelectManager';

const TAG: string = 'MultiSelectCheckboxViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class MultiSelectCheckboxViewModel {
  private listener: MultiSelectListenerType = {
    id: ''
  };
  private checkboxInfo: CheckboxInfoType = {
    parentType: CheckboxParentEnum.App,
    parentId: '',
    rectId: '',
    belongFolderCheckboxId: '',
    parentItemInfo: new AppItemInfo(),
    iconSize: 0,
    checkState: new CheckboxCheckState(),
    radius: 0,
    isInDrag: false,
    isOuterDesktop: false
  };
  private checkboxViewState = new CheckboxViewState();

  /**
   * checkboxView 上树时候调用
   */
  public init(checkboxViewParam: CheckboxVmConstructorType): void {
    this.checkboxInfo = {
      parentType: checkboxViewParam.parentType,
      parentId: checkboxViewParam.parentId,
      rectId: checkboxViewParam.rectId,
      belongFolderCheckboxId: this.getMultiSelectBelongId(checkboxViewParam.parentType),
      parentItemInfo: checkboxViewParam.parentItemInfo,
      iconSize: EditModeUtils.convertWithDesktopScale(checkboxViewParam.iconSize),
      checkState: new CheckboxCheckState(),
      radius: EditModeUtils.convertWithDesktopScale(checkboxViewParam.radius),
      isInDrag: checkboxViewParam.isInDrag,
      isOuterDesktop: checkboxViewParam.isOuterDesktop
    };
    this.listener = this.initListener() as MultiSelectListenerType;
    multiSelectListenManger.register(this.listener);
    this.registerCheckboxInfoToManager();
    this.updateCheckboxViewState(true);
  }

  private getMultiSelectBelongId(parentType: CheckboxParentEnum): string | undefined {
    if (parentType === CheckboxParentEnum.AppInFolder) {
      return MultiSelectCheckboxManager.getInstance().openFolderParentId;
    } else {
      return undefined;
    }
  }

  /**
   * checkboxView 下树时调用
   */
  public destroy(): void {
    this.checkboxViewState.reSet();
  }

  /**
   * 反注册MultiSelectListener
   */
  public unregister(): void {
    multiSelectListenManger.unregister(this.listener);
  }

  /**
   * 返回checkbox相关的状态变量 '显示', '选中'
   * @returns
   */
  public getCheckboxShowState(): CheckboxViewState {
    return this.checkboxViewState;
  }

  /**
   * 在MultiSelectManager中注册checkboxInfo
   */
  private registerCheckboxInfoToManager() {
    MultiSelectManager.getInstance().uploadCheckboxInfo(this.checkboxInfo);
  }

  private getCheckedStatus(): boolean {
    const isChecked: boolean = this.checkboxInfo.checkState.isSelected();
    // 拖拽开始后不显示为选中状态
    return isChecked && MultiSelectManager.getInstance().getStatus().isSelectAble();
  }

  private getShowStatus(): boolean {
    // 文件夹多选框只在选中状态时显示
    let showCheckbox = MultiSelectManager.getInstance().getStatus().showCheckbox;
    if (this.checkboxInfo.parentType === CheckboxParentEnum.Folder) {
      showCheckbox = showCheckbox && this.checkboxViewState.checked;
    } else if (this.checkboxInfo.parentType === CheckboxParentEnum.AppInFolder) {
      const folderState = MultiSelectCheckboxManager.getInstance().folderState;
      if (!folderState.isOpened) {
        showCheckbox = false;
      }
    }
    return showCheckbox;
  }

  /**
   * 更新checkbox显示状态
   */
  private updateCheckboxViewState(isInit: boolean): void {
    this.checkboxViewState.setChecked(this.getCheckedStatus());
    this.setShow((isInit ? !this.checkboxInfo.isInDrag : true) && this.getShowStatus());
  }

  private setShow(isShow: boolean, withAnimate: boolean = false):void {
    if (withAnimate && isShow !== this.checkboxViewState.show) {
      animateTo({
        duration: MultiSelectStyleConfig.HIDE_CHECKBOX_DURING_GATHER_ANIMATE_DURATION,
        curve: Curve.Linear,
      }, () => {
        this.checkboxViewState.setShow(isShow);
      });
    } else {
      this.checkboxViewState.setShow(isShow);
    }
  }

  private setChecked(isShow: boolean, withAnimate: boolean = false):void {
    if (withAnimate) {
      animateTo({
        duration: MultiSelectStyleConfig.HIDE_CHECKBOX_DURING_GATHER_ANIMATE_DURATION,
        curve: Curve.Linear,
      }, () => {
        this.checkboxViewState.setShow(isShow);
      });
    } else {
      this.checkboxViewState.setShow(isShow);
    }
  }

  /**
   * 初始化多选状态事件监听
   * @returns
   */
  private initListener() {
    let listener: MultiSelectListenerType = {
      id: multiSelectListenManger.getListenerId(ListenerItemType.MULTISELECT_CHECKBOX_VIEW,
        this.checkboxInfo.parentId, this.checkboxInfo.isOuterDesktop),
      onLongPress: (): void => {
        this.setShow(false, true);
      },
      onItemDropped: (): void => {
        this.setShow(this.getShowStatus(), true);
      },
      onUpdateState: (): void => this.updateCheckboxViewState(false),
    }
    return listener;
  }

  /**
   * 显示出多选框
   */
  public show(withAnimate: boolean): void {
    this.setShow(this.getShowStatus(), withAnimate);
  }
}