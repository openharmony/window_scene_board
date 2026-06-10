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

import curves from '@ohos.curves';
import { LogDomain, LogHelper} from '@ohos/basicutils';
import lazy { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { RTLUtil } from '@ohos/componenthelper';
import { CommonConstants } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import List from '@ohos.util.List';
import { ToggleEditViewData } from './ToggleEditViewData';
import { SysApiWrapper } from '../common/SysApiWrapper';
import { AccessibilityUtil } from '@ohos/screenlockcommon/src/main/ets/utils/AccessibilityUtil';
import { AccessibilityUtilExt } from '@ohos/controlcentercommon/src/main/ets/accessibility/AccessibilityUtilExt';
import {
  ControlCenterAccessibilityDataModel
} from '@ohos/controlcentercommon/src/main/ets/accessibility/AccessibilityDataModel';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { ControlCenterHiSysEventUtil } from '@ohos/controlcentercommon/src/main/ets/hiSysEvent/ControlCenterHiSysEventUtil';
import { VibratorManagerAdapter } from '@ohos/controlcentercommon/src/main/ets/adapter/VibratorManagerAdapter';

const SPRING_CURVE: ICurve = curves.interpolatingSpring(0, 1, 400, 38);
const TOUCH_MOVE_SPRING_CURVE: ICurve = curves.responsiveSpringMotion(0.05, 1, 0);
const UPDATE_THRESHOLD = 0.5;

const TAG = 'DragHelper';
const log = LogHelper.getLogHelper(LogDomain.CC, TAG);

interface conditionOperation {
  condition: Function,
  operation: Function
}

export enum MoveDirection {
  UP,
  DOWN,
  LEFT,
  RIGHT,
  UP_RIGHT,
  UP_LEFT,
  DOWN_RIGHT,
  DOWN_LEFT
}

export class DragHelper {
  private itemWidth: number;
  private itemHeight: number;
  private itemColumNumber: number;
  public previewToggles: string[] = [];
  private dragRefOffsetX: number = 0;
  private dragRefOffsetY: number = 0;
  private viewData: ToggleEditViewData;
  private lastDragOffsetX = 0;
  private lastDragOffsetY = 0;
  private moveOperationList: List<conditionOperation> = new List();

  constructor(viewData: ToggleEditViewData, itemWidth: number, itemHeight: number, itemColumNumber: number) {
    this.viewData = viewData;
    this.itemWidth = itemWidth;
    this.itemHeight = itemHeight;
    this.itemColumNumber = itemColumNumber;
    this.addMovingDown();
    this.addMovingUp();
    this.addMovingLeft();
    this.addMovingRight();
    this.addMovingDownRight();
    this.addMovingUpRight();
    this.addMovingDownLeft();
    this.addMovingUpLeft();
    // 最后一排的最后一个向右移动
    this.addMovingUpRightSteps();
    //  上面过程的逆过程
    this.addMovingDownLeftSteps();
    // 最后一排的最后一个向左移动
    this.addMovingUpLeftSteps();
    //  上面过程的逆过程
    this.addMovingDownRightSteps();
  }

  /**
   * 获取移动至目标的坐标
   *
   * @returns
   */
  private getMoveTargetIndex = (index: number, direction: MoveDirection): number => {
    switch (direction) {
      case MoveDirection.UP:
        return index - this.itemColumNumber;
      case MoveDirection.DOWN:
        return index + this.itemColumNumber;
      case MoveDirection.LEFT:
        return (this.isRTL() ? index + 1 : index - 1);
      case MoveDirection.RIGHT:
        return (this.isRTL() ? index - 1 : index + 1);
      case MoveDirection.UP_RIGHT:
        return index - this.itemColumNumber + (this.isRTL() ? - 1 : 1);
      case MoveDirection.UP_LEFT:
        return index - this.itemColumNumber - (this.isRTL() ? - 1 : 1);
      case MoveDirection.DOWN_RIGHT:
        return index + this.itemColumNumber + (this.isRTL() ? - 1 : 1)
      case MoveDirection.DOWN_LEFT:
        return index + this.itemColumNumber - (this.isRTL() ? - 1 : 1);
      default:
        break;
    }
    return index;
  }

  public updateMoveTargetIndexFun(moveTargetIndexFun: (index: number, direction: MoveDirection) => number): void {
    this.getMoveTargetIndex = moveTargetIndexFun;
  }

  private isSupportMoveSteps = (index: number, direction: MoveDirection): boolean => {
    switch (direction) {
      case MoveDirection.UP_RIGHT:
        return this.isSupportUpRightSteps(index);
      case MoveDirection.UP_LEFT:
        return this.isSupportUpLeftSteps(index);
      case MoveDirection.DOWN_RIGHT:
        return this.isSupportDownRightSteps(index);
      case MoveDirection.DOWN_LEFT:
        return this.isSupportDownLeftSteps(index);
      default:
        break;
    }
    return false;
  }

  private isSupportMove = (index: number, direction: MoveDirection): boolean => {
    switch (direction) {
      case MoveDirection.UP:
        return index - this.itemColumNumber >= 0;
      case MoveDirection.DOWN:
        return index + this.itemColumNumber < this.previewToggles.length;
      case MoveDirection.LEFT:
        return !this.isLeftmost(index);
      case MoveDirection.RIGHT:
        return !this.isRightmost(index);
      case MoveDirection.UP_RIGHT:
        return this.isSupportUpRight(index);
      case MoveDirection.UP_LEFT:
        return this.isSupportUpLeft(index);
      case MoveDirection.DOWN_RIGHT:
        return this.isSupportDownRight(index);
      case MoveDirection.DOWN_LEFT:
        return this.isSupportDownLeft(index);
      default:
        break;
    }
    return false;
  }

  public updateSupportMoveFun(supportMoveFun: (index: number, direction: MoveDirection) => boolean,
    isSupportMoveSteps: (index: number, direction: MoveDirection) => boolean): void {
    this.isSupportMove = supportMoveFun;
    this.isSupportMoveSteps = isSupportMoveSteps;
  }

  // 切换开关位置，将fromIndex放在toIndex处
  private moveItemFunc = (fromIndex: number, toIndex: number): void => {
    if (fromIndex >= this.previewToggles.length || toIndex >= this.previewToggles.length) {
      return;
    }
    if (fromIndex < 0 || toIndex < 0) {
      return;
    }
    let tmp = this.previewToggles.splice(fromIndex, 1)
    this.previewToggles.splice(toIndex, 0, tmp[0]);
    AccessibilityUtil.sendAccessibility(AccessibilityUtilExt.getToggleMoveItemText(this.itemColumNumber, toIndex));
  }

  public updateMoveItemFunc(moveItemFunc: (fromIndex: number, toIndex: number) => void): void {
    this.moveItemFunc = moveItemFunc;
  }

  private addMovingDown() {
    let isMovingDown: Function = (index: number): boolean => {
      return this.isMoveDown() && this.isXLessThanThreshold() && this.isSupportDown(index);
    }
    this.moveOperationList.add({
      condition: isMovingDown,
      operation: this.moveDown
    });
  }

  private addMovingUp() {
    let isMovingUp: Function = (index: number): boolean => {
      return this.isMoveUp() && this.isXLessThanThreshold() && this.isSupportUp(index);
    }
    this.moveOperationList.add({
      condition: isMovingUp,
      operation: this.moveUp
    });
  }

  private addMovingLeft() {
    let isMovingLeft: Function = (index: number): boolean => {
      return this.isMoveLeft() && this.isYLessThanThreshold() && this.isSupportLeft(index);
    }
    this.moveOperationList.add({
      condition: isMovingLeft,
      operation: this.moveLeft
    });
  }

  private addMovingRight() {
    let isMovingRight: Function = (index: number): boolean => {
      return this.isMoveRight() && this.isYLessThanThreshold() && this.isSupportRight(index);
    }
    this.moveOperationList.add({
      condition: isMovingRight,
      operation: this.moveRight
    });
  }

  private addMovingDownRight() {
    let isMovingDownRight: Function = (index: number): boolean => {
      return this.isMoveRight() && this.isMoveDown() && this.isSupportMove(index, MoveDirection.DOWN_RIGHT);
    }
    this.moveOperationList.add({
      condition: isMovingDownRight,
      operation: this.moveDownRight
    });
  }

  private addMovingUpRight() {
    let isMovingUpRight: Function = (index: number): boolean => {
      return this.isMoveRight() && this.isMoveUp() && this.isSupportMove(index, MoveDirection.UP_RIGHT);
    }
    this.moveOperationList.add({
      condition: isMovingUpRight,
      operation: this.moveUpRight
    });
  }

  private addMovingDownLeft() {
    let isMovingDownLeft: Function = (index: number): boolean => {
      return this.isMoveLeft() && this.isMoveDown() && this.isSupportMove(index, MoveDirection.DOWN_LEFT);
    }
    this.moveOperationList.add({
      condition: isMovingDownLeft,
      operation: this.moveDownLeft
    });
  }

  private addMovingUpLeft() {
    let isMovingUpLeft: Function = (index: number): boolean => {
      return this.isMoveLeft() && this.isMoveUp() && this.isSupportMove(index, MoveDirection.UP_LEFT);
    }
    this.moveOperationList.add({
      condition: isMovingUpLeft,
      operation: this.moveUpLeft
    });
  }

  private addMovingUpRightSteps() {
    let isMovingUpRightSteps: Function = (index: number): boolean => {
      return this.isMoveRight() && this.isMoveUp() && this.isSupportMoveSteps(index, MoveDirection.UP_RIGHT);
    }
    this.moveOperationList.add({
      condition: isMovingUpRightSteps,
      operation: this.moveUpRightSteps
    });
  }

  private addMovingUpLeftSteps() {
    let isMovingUpLeftSteps: Function = (index: number): boolean => {
      return this.isMoveLeft() && this.isMoveUp() && this.isSupportMoveSteps(index, MoveDirection.UP_LEFT);
    }
    this.moveOperationList.add({
      condition: isMovingUpLeftSteps,
      operation: this.moveUpLeftSteps
    });
  }

  private addMovingDownLeftSteps() {
    let isMovingDownLeftSteps: Function = (index: number): boolean => {
      return this.isMoveLeft() && this.isMoveDown() && this.isSupportMoveSteps(index, MoveDirection.DOWN_LEFT);
    }
    this.moveOperationList.add({
      condition: isMovingDownLeftSteps,
      operation: this.moveDownLeftSteps
    });
  }

  private addMovingDownRightSteps() {
    let isMovingDownRightSteps: Function = (index: number): boolean => {
      return this.isMoveRight() && this.isMoveDown() && this.isSupportMoveSteps(index, MoveDirection.DOWN_RIGHT);
    }
    this.moveOperationList.add({
      condition: isMovingDownRightSteps,
      operation: this.moveDownRightSteps
    });
  }

  public onLongPressActionForDrag = (item: string, getToggleName?: (slot: string) => string) => {
    SysApiWrapper.animateTo({curve: Curve.Friction, duration: 300}, () => {
      this.viewData.dragItem = item;
    });

    log.showInfo(`onLongPressActionForDrag [${this.viewData.offsetX}, ${this.viewData.offsetY}]`);
    try {
      VibratorManagerAdapter.startVibration(CommonConstants.VIBRATION_EFFECT_LIGHT,
        CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
    } catch (err) {
      log.error('onLongPressActionForDrag start vibration error');
    }
    AccessibilityUtil.sendAccessibility((getToggleName ? getToggleName(item) :
    ControlCenterAccessibilityDataModel.getInstance().get(item)) +
      ResUtils.getInnerString($r('app.string.cc_accessibility_str_edit_move_start')));
  }

  public onLongPressActionEndForDrag = (getToggleName?: (slot: string) => string) => {
    let item = this.viewData.dragItem;
    this.viewData.dragItem = '';
    this.viewData.offsetX = 0;
    this.viewData.offsetY = 0;
    log.showInfo(`onLongPressActionEndForDrag item=` + item);
    AccessibilityUtil.sendAccessibility((getToggleName ? getToggleName(item) :
    ControlCenterAccessibilityDataModel.getInstance().get(item)) +
    ResUtils.getInnerString($r('app.string.cc_accessibility_str_edit_move_end')) +
    AccessibilityUtilExt.getTogglePlaceItemText(this.itemColumNumber, this.previewToggles.indexOf(item))
    );
  };

  public onActionStartForDrag = (item: string) => {
    this.viewData.dragItem = item;
    this.dragRefOffsetX = 0;
    this.dragRefOffsetY = 0;
    this.lastDragOffsetX = 0;
    this.lastDragOffsetY = 0;
    log.showInfo(`onActionStartForDrag ${item}`);
  }

  public onActionUpdateForDrag = (event: GestureEvent) => {
    if (Math.abs(event.offsetX - this.lastDragOffsetX) < UPDATE_THRESHOLD &&
      Math.abs(event.offsetY - this.lastDragOffsetY) < UPDATE_THRESHOLD) {
      return;
    }
    this.lastDragOffsetX = event.offsetX;
    this.lastDragOffsetY = event.offsetY;
    SysApiWrapper.animateTo(
      { curve: TOUCH_MOVE_SPRING_CURVE },
      () => {
        this.viewData.offsetX = event.offsetX - this.dragRefOffsetX;
        this.viewData.offsetY = event.offsetY - this.dragRefOffsetY;
      }
    );
    log.showDebug('onActionUpdateForDrag move [%{public}d, %{public}d]', this.viewData.offsetX, this.viewData.offsetY);
    SysApiWrapper.animateTo(
      { curve: SPRING_CURVE },
      () => {this.dragMoveAnimate()});
  }

  public onActionEndForDrag = () => {
    SysApiWrapper.animateTo({ curve: SPRING_CURVE }, () => {
      this.viewData.dragItem = '';
      this.viewData.offsetX = 0;
      this.viewData.offsetY = 0;
    })
    log.showInfo(`onActionEndForDrag`);
  }

  private dragMoveAnimate = () => {
    try {
      let dragIndex = this.previewToggles.indexOf(this.viewData.dragItem);
      SysApiWrapper.animateTo({ curve: SPRING_CURVE }, () => {
        for (let index = 0; index < this.moveOperationList.length; index++) {
          if (this.moveOperationList.get(index).condition(dragIndex)) {
            this.moveOperationList.get(index).operation(dragIndex);
            return;
          }
        }
      });
    } catch (err) {
      log.error('dragMoveAnimate error');
    }

  }

  private moveItem = (fromIndex: number, toIndex: number) => {
    ControlCenterHiSysEventUtil.reportCCEditMoveSwitch({
      TIMESTAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
      NAME: this.previewToggles[fromIndex],
      OLDLOCATION: fromIndex,
      NEWLOCATION: toIndex,
    })
    this.moveItemFunc(fromIndex, toIndex);
  }

  // 向下移一格，位置（index）移动到（index + this.itemColumNumber），需要判断isSupportDown
  private moveDown = (index: number) => {
    this.viewData.offsetY -= this.itemHeight;
    this.dragRefOffsetY += this.itemHeight;
    log.showInfo(`moveDown index:${index}, offsetY:${this.viewData.offsetY}, dragRefOffsetY: ${this.dragRefOffsetY}`);
    this.moveItem(index, this.getMoveTargetIndex(index, MoveDirection.DOWN));
  }

  // 支持下滑场景
  private isSupportDown = (index: number): boolean => {
    return this.isSupportMove(index, MoveDirection.DOWN);
  }

  // 向上移一格，位置（index）移动到（index - this.itemColumNumber），需要判断isSupportUp
  private moveUp = (index: number) => {
    this.viewData.offsetY += this.itemHeight;
    this.dragRefOffsetY -= this.itemHeight;
    log.showInfo(`moveUp index:${index},  offsetY:${this.viewData.offsetY}, dragRefOffsetY: ${this.dragRefOffsetY}`);
    this.moveItem(index, this.getMoveTargetIndex(index, MoveDirection.UP));
  }

  // 支持上滑
  private isSupportUp = (index: number): boolean => {
    return this.isSupportMove(index, MoveDirection.UP);
  }

  // 向左移一格，位置（index）移动到（index - 1）/（index + 1）,需要判断isSupportLeft
  private moveLeft = (index: number) => {
    this.viewData.offsetX += this.itemWidth;
    this.dragRefOffsetX -= this.itemWidth;
    log.showInfo(`moveLeft index:${index}, offsetX:${this.viewData.offsetX}, dragRefOffsetX: ${this.dragRefOffsetX}`);
    this.moveItem(index, this.getMoveTargetIndex(index, MoveDirection.LEFT));
  }

  // 支持左滑，不在最左边
  private isSupportLeft = (index: number): boolean => {
    return this.isSupportMove(index, MoveDirection.LEFT);
  }

  private isLeftmost = (index: number): boolean => {
    return this.isRTL() ? this.isRowEnd(index) : this.isRowStart(index);
  }

  private isRowStart = (index: number): boolean => {
    return index % this.itemColumNumber == 0;
  }

  // 向右移一格，位置（index）移动到（index + 1）/（index - 1），需要判断isSupportRight
  private moveRight = (index: number) => {
    this.viewData.offsetX -= this.itemWidth;
    this.dragRefOffsetX += this.itemWidth;
    log.showInfo(`moveRight index:${index},  offsetX:${this.viewData.offsetX}, dragRefOffsetX: ${this.dragRefOffsetX}`);
    this.moveItem(index, this.getMoveTargetIndex(index, MoveDirection.RIGHT));
  }

  // 支持右滑
  private isSupportRight = (index: number): boolean => {
    return this.isSupportMove(index, MoveDirection.RIGHT);
  }

  private isRightmost = (index: number): boolean => {
    return this.isRTL() ? this.isRowStart(index) : this.isRowEnd(index);
  }

  private isRowEnd = (index: number): boolean => {
    let length = this.previewToggles.length;
    return (index + 1) % this.itemColumNumber == 0 || index == length - 1;
  }

  // 向右下移一格，位置（index）移动到（index + this.itemColumNumber +/- 1），需要判断isSupportDownRight
  private moveDownRight = (index: number) => {
    this.viewData.offsetX -= this.itemWidth;
    this.dragRefOffsetX += this.itemWidth;
    this.viewData.offsetY -= this.itemHeight;
    this.dragRefOffsetY += this.itemHeight;
    this.printMoveInfo('moveDownRight', index);
    this.moveItem(index, this.getMoveTargetIndex(index, MoveDirection.DOWN_RIGHT));
  }

  // 支持右下滑动
  private isSupportDownRight = (index: number): boolean => {
    if (this.isRTL()) {
      return this.isSupportRight(index) && (this.isSupportDown(index) ||
        index + this.itemColumNumber == this.previewToggles.length); // 最后一个开关
    } else {
      return this.isSupportRight(index) && (index + this.itemColumNumber + 1 <= this.previewToggles.length);
    }
  }

  // 向右上移一格，位置（index）移动到（index - this.itemColumNumber +/- 1），需要判断isSupportDownRight
  private moveUpRight = (index: number) => {
    this.viewData.offsetX -= this.itemWidth;
    this.dragRefOffsetX += this.itemWidth;
    this.viewData.offsetY += this.itemHeight;
    this.dragRefOffsetY -= this.itemHeight;
    this.printMoveInfo('moveUpRight', index);
    this.moveItem(index, this.getMoveTargetIndex(index, MoveDirection.UP_RIGHT));
  }

  // 支持右上滑动
  private isSupportUpRight = (index: number): boolean => {
    if (this.isRTL()) {
      return this.isSupportRight(index) && (index - 1 - this.itemColumNumber >= 0);
    } else {
      let offsetIndex = Math.floor((this.viewData.offsetX - this.itemWidth / 2) / this.itemWidth);
      // 在最后一个位置，右侧空白时，横向移动超过1个位置，不做处理
      if (offsetIndex >= 1) {
        log.showInfo(`isSupportRightUp return since offsetIndex:${offsetIndex}`);
        return false;
      }
      let length = this.previewToggles.length;
      return this.isSupportUp(index) && (this.isSupportRight(index) ||
        (index + 1 == length && !((index + 1) % this.itemColumNumber == 0))); // 最后一个开关，且不在最右侧
    }
  }

  // 向左下移一格，位置（index）移动到（index + this.itemColumNumber -/+ 1），需要判断isSupportDownLeft
  private moveDownLeft = (index: number) => {
    this.viewData.offsetX += this.itemWidth;
    this.dragRefOffsetX -= this.itemWidth;
    this.viewData.offsetY -= this.itemHeight;
    this.dragRefOffsetY += this.itemHeight;
    this.printMoveInfo('moveDownLeft', index);
    this.moveItem(index, this.getMoveTargetIndex(index, MoveDirection.DOWN_LEFT));
  }

  // 支持左下
  private isSupportDownLeft = (index: number): boolean => {
    if (this.isRTL()) {
      return this.isSupportLeft(index) && (index + this.itemColumNumber + 1 <= this.previewToggles.length);
    }

    let length = this.previewToggles.length;
    return this.isSupportLeft(index) && (this.isSupportDown(index) ||
      index + this.itemColumNumber == length); // 左下角为最后一个开关
  }

  // 向左上移一格，位置（index）移动到（index + this.itemColumNumber -/+ 1），需要判断isSupportUpLeft
  private moveUpLeft = (index: number) => {
    this.viewData.offsetX += this.itemWidth;
    this.dragRefOffsetX -= this.itemWidth;
    this.viewData.offsetY += this.itemHeight;
    this.dragRefOffsetY -= this.itemHeight;
    this.printMoveInfo('moveUpLeft', index);
    this.moveItem(index, this.getMoveTargetIndex(index, MoveDirection.UP_LEFT));
  }

  // 支持左上
  private isSupportUpLeft = (index: number): boolean => {
    if (this.isRTL()) {
      let offsetIndex = Math.floor(Math.abs(this.viewData.offsetX + this.itemWidth / 2) / this.itemWidth);
      // 在最后一个位置，左侧空白时，横向移动超过1个位置，不做处理
      if (offsetIndex >= 1) {
        log.showInfo(`isSupportLeftUp return since offsetIndex:${offsetIndex}`);
        return false;
      }
      let length = this.previewToggles.length;
      return this.isSupportUp(index) && (this.isSupportLeft(index) ||
        (index + 1 == length && !((index + 1) % this.itemColumNumber == 0))); // 最后一个开关，且不在最左侧
    } else {
      return this.isSupportLeft(index) && (index - 1 - this.itemColumNumber >= 0);
    }
  }

  // 向左下移动，最后一行开关小于3个，x方向移动距离超过1个
  private moveDownLeftSteps = (index: number): void => {
    let offsetIndex = Math.floor(Math.abs(this.viewData.offsetX + this.itemWidth / 2) / this.itemWidth);
    let toIndex = index + this.itemColumNumber - 1 - offsetIndex;
    this.viewData.offsetX += this.itemWidth * (1 + offsetIndex);
    this.dragRefOffsetX -= this.itemWidth * (1 + offsetIndex);
    this.viewData.offsetY -= this.itemHeight;
    this.dragRefOffsetY += this.itemHeight;
    this.printMoveStepsInfo('moveDownLeftSteps', index, toIndex);
    this.moveItem(index, toIndex);
  }

  // 向右下移动，最后一行开关小于3个，x方向移动距离超过1个
  private moveDownRightSteps = (index: number): void => {
    let offsetIndex = Math.floor(Math.abs(this.viewData.offsetX - this.itemWidth / 2) / this.itemWidth);
    let toIndex = index + this.itemColumNumber - 1 - offsetIndex;
    this.viewData.offsetX -= this.itemWidth * (1 + offsetIndex);
    this.dragRefOffsetX += this.itemWidth * (1 + offsetIndex);
    this.viewData.offsetY -= this.itemHeight;
    this.dragRefOffsetY += this.itemHeight;
    this.printMoveStepsInfo('moveDownRightSteps', index, toIndex);
    this.moveItem(index, toIndex);
  }

  // 支持左下
  private isSupportDownLeftSteps = (index: number): boolean => {
    if (this.isRTL()) {
      return false;
    }
    let offsetIndex = Math.floor(Math.abs(this.viewData.offsetX + this.itemWidth / 2) / this.itemWidth);
    let toIndex = index + this.itemColumNumber - 1 - offsetIndex;
    if (toIndex >= this.previewToggles.length) {
      log.showInfo(`isSupportLeftDownSteps toIndex:${toIndex} exceed length`);
      return false;
    }
    let length = this.previewToggles.length;
    return this.isSupportLeft(index) &&
      Math.floor(index / this.itemColumNumber) + 1 == Math.floor((length - 1) / this.itemColumNumber);
  }

  // 支持右下
  private isSupportDownRightSteps = (index: number): boolean => {
    if (!this.isRTL()) {
      return false;
    }
    let offsetIndex = Math.floor(Math.abs(this.viewData.offsetX - this.itemWidth / 2) / this.itemWidth);
    let toIndex = index + this.itemColumNumber - 1 - offsetIndex;
    if (toIndex >= this.previewToggles.length) {
      log.showInfo(`isSupportRightDownSteps toIndex:${toIndex} exceed length`);
      return false;
    }
    let length = this.previewToggles.length;
    return this.isSupportRight(index) &&
      Math.floor(index / this.itemColumNumber) + 1 == Math.floor((length - 1) / this.itemColumNumber);
  }

  private moveUpRightSteps = (index: number) => {
    let offsetIndex = Math.floor((this.viewData.offsetX - this.itemWidth / 2) / this.itemWidth);
    let toIndex = index - this.itemColumNumber + 1 + offsetIndex;
    // 移动后在一排，return
    if (Math.floor(toIndex / this.itemColumNumber) == Math.floor(index / this.itemColumNumber)) {
      log.showInfo(`moveUpRightSteps same column return`);
      return;
    }
    this.viewData.offsetX -= this.itemWidth * (1 + offsetIndex);
    this.dragRefOffsetX += this.itemWidth * (1 + offsetIndex);
    this.viewData.offsetY += this.itemHeight;
    this.dragRefOffsetY -= this.itemHeight;
    this.printMoveStepsInfo('moveUpRightSteps', index, toIndex);
    this.moveItem(index, toIndex);
  }

  private moveUpLeftSteps = (index: number) => {
    let offsetIndex = Math.floor(Math.abs(this.viewData.offsetX + this.itemWidth / 2) / this.itemWidth);
    let toIndex = index - this.itemColumNumber + 1 + offsetIndex;
    // 移动后在一排，return
    if (Math.floor(toIndex / this.itemColumNumber) == Math.floor(index / this.itemColumNumber)) {
      log.showInfo(`moveUpLeftSteps same column return`);
      return;
    }
    this.viewData.offsetX += this.itemWidth * (1 + offsetIndex);
    this.dragRefOffsetX -= this.itemWidth * (1 + offsetIndex);
    this.viewData.offsetY += this.itemHeight;
    this.dragRefOffsetY -= this.itemHeight;
    this.printMoveStepsInfo('moveUpLeftSteps', index, toIndex);
    this.moveItem(index, toIndex);
  }

  // 支持右上
  private isSupportUpRightSteps = (index: number): boolean => {
    if (this.isRTL()) {
      return false;
    } else {
      let length = this.previewToggles.length;
      return this.isSupportUp(index) && (index + 1 == length && !((index + 1) / this.itemColumNumber == 0));
    }
  }

  // 支持左上
  private isSupportUpLeftSteps = (index: number): boolean => {
    if (this.isRTL()) {
      let length = this.previewToggles.length;
      return this.isSupportUp(index) && (index + 1 == length && !((index + 1) / this.itemColumNumber == 0));
    } else {
      return false;
    }
  }

  private isXLessThanThreshold = () : boolean => {
    return this.viewData.offsetX <= this.itemWidth / 2 && this.viewData.offsetX >= -this.itemWidth / 2;
  }

  private isYLessThanThreshold = () : boolean => {
    return this.viewData.offsetY <= this.itemHeight / 2 && this.viewData.offsetY >= -this.itemHeight / 2;
  }

  private isMoveDown = (): boolean => {
    return this.viewData.offsetY >= this.itemHeight / 2;
  }

  private isMoveUp = (): boolean => {
    return this.viewData.offsetY <= -this.itemHeight / 2;
  }

  private isMoveLeft = (): boolean => {
    return (this.viewData.offsetX <= -this.itemWidth / 2);
  }

  private isMoveRight = (): boolean => {
    return (this.viewData.offsetX >= this.itemWidth / 2);
  }

  private printMoveInfo = (move: string, index: number) => {
    log.showInfo(`${move} index:${index},  offsetX:${this.viewData.offsetX}, offsetY:${this.viewData.offsetY},` +
      `dragRefOffsetX: ${this.dragRefOffsetX}, dragRefOffsetY: ${this.dragRefOffsetY}`);
  }

  private printMoveStepsInfo = (move: string, from: number, to: number) => {
    log.showInfo(`${move} from:${from}, to:${to}, offsetX:${this.viewData.offsetX}, offsetY:${this.viewData.offsetY},` +
      `dragRefOffsetX: ${this.dragRefOffsetX}, dragRefOffsetY: ${this.dragRefOffsetY}`);
  }

  private isRTL = (): boolean => {
    return RTLUtil.isRTL();
  }
}