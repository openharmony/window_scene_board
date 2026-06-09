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
import { LogDomain, Logger } from '@ohos/basicutils';
import { ToggleComponent } from '@ohos/controlcentercommon/src/main/ets/toggle/view/NewToggleBaseComponent';
import { ToggleScene } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';
import {
  QuickToggleController
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/QuickToggleController';
import { ToggleTemplateType } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';
import { PCToggleFactory } from '../../pcStyle/PCStyleFactory';
import { EditModeActionBtnStyle, EditModeCommonStyle, EditModeStyleParam } from '../style/EditModeStyle';
import Constants from '../../common/constants';
import { EditModeGridVm } from '../vm/EditModeGridVm';
import { EditModeGridData } from '../viewData/EditModeGridViewData';
import { EditModeDragViewData } from '../viewData/EditModeDragViewData';

const TAG = 'EditModeGrid';
const log: Logger = Logger.getLogHelper(LogDomain.SCB);

@Component
export struct EditModeGrid {
  @StorageLink('isBusinessStyle') isBusinessStyle: boolean = true;
  @State viewData: EditModeGridData = new EditModeGridData();
  @State dragViewData: EditModeDragViewData = new EditModeDragViewData();
  @State toggleColumn: number = QuickToggleController.getInstance().getToggleColumn();
  @State gridButtons: string[] = [];
  private isEditMode: boolean = false;
  private isSelectedGrid: boolean = false;
  private editModeGridVm?: EditModeGridVm;
  private commonStyle: EditModeCommonStyle = EditModeCommonStyle.getInstance();

  aboutToAppear(): void {
    log.showInfo(TAG, 'EditModeGrid aboutToAppear');
    this.initGrid();
  }

  aboutToDisappear(): void {
    log.showInfo(TAG, 'EditModeGrid aboutToDisappear');
  }

  private initGrid(): void {
    this.initLayout();
    this.initData();
  }

  private initData(): void {
    // @State无法监听对象数组的变化，因此将监听对象回写到viewData里
    if (this.editModeGridVm) {
      this.editModeGridVm.initDragHandler(this.dragViewData,
        EditModeCommonStyle.getInstance().getItemWidth() +
          (this.commonStyle.getGridParam(this.isSelectedGrid).colsGap ?? 0),
        EditModeCommonStyle.getInstance().getItemHeight() +
          (this.commonStyle.getGridParam(this.isSelectedGrid).rowsGap ?? 0),
        QuickToggleController.getInstance().getToggleColumn(),
        this.getUIContext(),
      )
      this.gridButtons = this.editModeGridVm.onGetToggleData();
      this.editModeGridVm.linkToggleData(this.gridButtons);
      this.editModeGridVm.setIsEditMode(true);
    }
  }

  private handleTouchEvent(event: TouchEvent, toggleSlot: string): void {
    if (!this.isSelectedGrid) {
      return;
    }
    let dragHandler = this.editModeGridVm?.getDragHandler();
    if (!dragHandler) {
      log.showError(TAG, `${toggleSlot} onTouchEventCb dragHandler invalid`);
      return;
    }
    if (!dragHandler.isDragAble(toggleSlot)) {
      log.showInfo(TAG, `${toggleSlot} onTouchEventCb not allow to drag`);
      return;
    }
    if (!event || !event?.touches || event?.touches?.length === 0) {
      log.showInfo(TAG, 'onTouchEventCb event invalid');
      return;
    }
    const x: number = event.touches[0].displayX;
    const y: number = event.touches[0].displayY;
    if (x <= 0 || y <= 0) {
      log.showInfo(TAG, 'onTouchEventCb touch pos invalid');
      return;
    }
    if (event.type === TouchType.Down) {
      dragHandler.onDragStart(x, y, toggleSlot);
    }
    if (event.type === TouchType.Move) {
      dragHandler.onDragMove(x, y, toggleSlot);
    }
    if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
      dragHandler.onDragEnd();
    }
  }

  private initLayout(): void {
    let param: EditModeStyleParam = {
      height: this.commonStyle.getGridParam(this.isSelectedGrid).height,
      rowsGap: this.commonStyle.getGridParam(this.isSelectedGrid).rowsGap,
      margin: this.commonStyle.getGridParam(this.isSelectedGrid).margin,
      maxCount: this.commonStyle.getGridParam(this.isSelectedGrid).maxCount,
      width: this.commonStyle.getGridParam(this.isSelectedGrid).width,
      colsGap: this.commonStyle.getGridParam(this.isSelectedGrid).colsGap,
      padding: this.commonStyle.getGridParam(this.isSelectedGrid).padding,
      border: this.commonStyle.getGridParam(this.isSelectedGrid).border,
    };
    this.editModeGridVm?.updateGridLayout(param);
  }

  @Builder
  gridBuilder() {
    Grid() {
      ForEach(this.gridButtons, (toggleSlot: string, index: number) => {
        GridItem() {
          Stack({ alignContent: Alignment.TopEnd }) {
            // 这里不能拆分成builder，某则拖拽会有换位动效，可能和状态变量的同步机制有关
            ToggleComponent({
              toggleId: toggleSlot,
              toggleViewModel: QuickToggleController.getInstance().createToggleModelAndInit(toggleSlot),
              toggleStyle: PCToggleFactory.getInstance().createBasicStyle(),
              templateType: ToggleTemplateType.BASIC,
              isEditMode: this.isEditMode,
              toggleScene: ToggleScene.PC
            })
            // 用于屏蔽快捷开关的点击、拖动等事件
            Stack()
              .width('100%')
              .height('100%')
              .visibility(toggleSlot === this.dragViewData.dragItem ? Visibility.Hidden : Visibility.Visible)
            Image(this.isSelectedGrid ? $r('app.media.ic_remove') : $r('app.media.ic_add'))
              .draggable(false)
              .size(EditModeActionBtnStyle.getInstance().size)
              .margin(EditModeActionBtnStyle.getInstance().margin)
              .id(`${TAG}_Action_${this.isSelectedGrid ? 'Add' : 'Remove'}`)
              .onClick(() => {
                this.editModeGridVm?.onBtnClick(toggleSlot);
              })
              .visibility(toggleSlot === this.dragViewData.dragItem ? Visibility.Hidden : Visibility.Visible)
          }
          .width(EditModeCommonStyle.getInstance().getItemWidth())
          .height(EditModeCommonStyle.getInstance().getItemHeight())
        }
        .scale({
          x: toggleSlot === this.dragViewData.dragItem ? 1.08 : 1,
          y: toggleSlot === this.dragViewData.dragItem ? 1.08 : 1
        })
        .translate(this.dragViewData.dragItem == toggleSlot ?
          { x: this.dragViewData.offsetX, y: this.dragViewData.offsetY } :
          { x: 0, y: 0 })
        .onTouch((event: TouchEvent) => {
          this.handleTouchEvent(event, toggleSlot)
        })
        .transition(toggleSlot === this.dragViewData.dragItem ? undefined :
          TransitionEffect
            .scale({ x: 0.8, y: 0.8 })
            .combine(TransitionEffect.OPACITY)
            .animation({ duration: 250, curve: Curve.Friction }))
      }, (slot: string, index: number) => slot)
    }
    .height(this.viewData.height)
    .columnsTemplate(QuickToggleController.getInstance()
      .getToggleGridTemplate(this.toggleColumn))
    .rowsTemplate(QuickToggleController.getInstance().getToggleGridTemplate(
      Math.ceil(this.gridButtons.length / this.toggleColumn)))
    .animation({
      duration: 250,
      curve: Curve.Friction,
      playMode: PlayMode.Normal
    })
    .border(this.viewData.border)
    .width(this.viewData.width)
    .rowsGap(this.viewData.rowsGap)
    .columnsGap(this.viewData.colsGap)
    .clip(this.isSelectedGrid)
    .margin(this.viewData.margin)
    .padding(this.viewData.padding)
    .layoutDirection(GridDirection.Row)
    .id(Constants.getEditGridComponentId(this.isSelectedGrid))
  }

  build() {
    if (this.viewData.isShowing || this.isSelectedGrid) {
      this.gridBuilder()
    }
  }
}