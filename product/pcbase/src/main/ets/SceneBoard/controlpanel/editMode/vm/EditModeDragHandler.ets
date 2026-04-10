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
import { curves } from '@kit.ArkUI';
import List from '@ohos.util.List';
import { LogDomain, Logger } from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';
import { EditModeDragIface } from '../interfaces/EditModeIface';
import { EditModeDragViewData } from '../viewData/EditModeDragViewData';


const TAG = 'EditModeDragHandler';
const log: Logger = Logger.getLogHelper(LogDomain.SCB);
const SPRING_CURVE: ICurve = curves.interpolatingSpring(0, 1, 400, 38);
const TOUCH_MOVE_SPRING_CURVE: ICurve = curves.responsiveSpringMotion(0.05, 1, 0);
const MIN_MOVE_SPEED = 0.05;
const MIN_VALID_COUNT = 1;

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

export class EditModeDragHandler implements EditModeDragIface {
  private itemWidth: number;
  private itemHeight: number;
  private itemColumNumber: number;
  private dragItems: string[] = [];
  private dragRefOffsetX: number = 0;
  private dragRefOffsetY: number = 0;
  private viewData: EditModeDragViewData;
  private moveOperationList: List<conditionOperation> = new List();
  private startDrag: boolean = false;
  private dragStartPosX: number = 0;
  private dragStartPosY: number = 0;
  private lastDragPosX: number = 0;
  private lastDragPosY: number = 0;
  private speedValidCount: number = 0;
  private lastDragTime: number = 0;
  private isEditMode: boolean = false;
  private context?: UIContext;

  constructor(
    viewData: EditModeDragViewData,
    itemWidth: number,
    itemHeight: number,
    itemColumNumber: number,
    context: UIContext) {
    this.context = context;
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

  public isDragAble(toggleSlot: string): boolean {
    return !this.viewData.dragItem || this.viewData.dragItem === toggleSlot;
  }

  public onDragStart(x: number, y: number, toggleSlot: string): void {
    if (this.startDrag) {
      return;
    }
    this.startDrag = true;
    this.viewData.dragItem = toggleSlot;
    AppStorage.setOrCreate<string>('currentDragSlotItem', toggleSlot);
    this.dragStartPosX = x;
    this.dragStartPosY = y;
    this.lastDragPosX = x;
    this.lastDragPosY = y;
    this.dragRefOffsetX = 0;
    this.dragRefOffsetY = 0;
    log.showInfo(TAG, TAG, `onDragStart ${toggleSlot} ${x} ${y}`);
  }

  public onDragMove(x: number, y: number, toggleSlot: string): void {
    if (this.viewData.dragItem !== toggleSlot) {
      log.showError(TAG, `onDragMove not dragItem: ${this.viewData.dragItem} ${toggleSlot}`);
      return;
    }
    const dragOffsetX: number = x - this.dragStartPosX;
    const dragOffsetY: number = y - this.dragStartPosY;
    if (this.isMoveFast(x, y)) {
      return;
    }
    this.context?.animateTo({ curve: TOUCH_MOVE_SPRING_CURVE }, () => {
      this.viewData.offsetX = dragOffsetX - this.dragRefOffsetX;
      this.viewData.offsetY = dragOffsetY - this.dragRefOffsetY;
    });
    log.showDebug(TAG, 'onActionUpdateForDrag move [%{public}d, %{public}d]', this.viewData.offsetX, this.viewData.offsetY);
    this.dragMoveAnimate();
  }

  private dragMoveAnimate(): void {
    try {
      let dragIndex = this.dragItems.indexOf(this.viewData.dragItem);
      this.context?.animateTo({ curve: SPRING_CURVE }, () => {
        for (let index = 0; index < this.moveOperationList.length; index++) {
          if (this.moveOperationList.get(index).condition(dragIndex)) {
            this.moveOperationList.get(index).operation(dragIndex);
            return;
          }
        }
      });
    } catch (err) {
      log.error(TAG, 'dragMoveAnimate error');
    }
  }

  public onDragEnd(): void {
    this.startDrag = false;
    this.dragStartPosX = 0;
    this.dragStartPosY = 0;
    this.lastDragPosX = 0;
    this.lastDragPosY = 0;
    AppStorage.setOrCreate<string>('currentDragSlotItem', '');
    this.dragEndAnimate();
  }

  private dragEndAnimate(): void {
    this.context?.animateTo({ curve: SPRING_CURVE }, () => {
      this.viewData.dragItem = '';
      this.viewData.offsetX = 0;
      this.viewData.offsetY = 0;
    });
  }

  private isMoveFast(x: number, y: number): boolean {
    // calculate the move speed
    const nowTime = Date.now();
    const speed = Math.hypot(x - this.lastDragPosX, y - this.lastDragPosY) / (nowTime - this.lastDragTime);
    log.showInfo(TAG, `calculateSpeed x: %{public}d, y: %{public}d, lastDragY: %{public}d, lastDragX: %{public}d,
      nowTime: %{public}s, lastDragTime: %{public}s, speed: %{public}d`, x, y, this.lastDragPosY, this.lastDragPosX,
      nowTime, this.lastDragTime, speed);
    this.lastDragPosX = x;
    this.lastDragPosY = y;
    this.lastDragTime = nowTime;
    if (typeof speed === 'number' && speed < MIN_MOVE_SPEED) {
      // 过滤拖拽速度在挤位阈值上下波动的场景
      this.speedValidCount++;
      return this.speedValidCount >= MIN_VALID_COUNT;
    }
    this.speedValidCount = 0;
    return false;
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
        return index + this.itemColumNumber < this.dragItems.length;
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

  private moveItem = (fromIndex: number, toIndex: number) => {
    if (fromIndex >= this.dragItems.length || toIndex >= this.dragItems.length) {
      return;
    }
    if (fromIndex < 0 || toIndex < 0) {
      return;
    }
    let tmp = this.dragItems.splice(fromIndex, 1)
    this.dragItems.splice(toIndex, 0, tmp[0]);
  }

  // 向下移一格，位置（index）移动到（index + this.itemColumNumber），需要判断isSupportDown
  private moveDown = (index: number) => {
    this.viewData.offsetY -= this.itemHeight;
    this.dragRefOffsetY += this.itemHeight;
    log.showInfo(TAG, `moveDown index:${index}, offsetY:${this.viewData.offsetY}, dragRefOffsetY: ${this.dragRefOffsetY}`);
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
    log.showInfo(TAG, `moveUp index:${index},  offsetY:${this.viewData.offsetY}, dragRefOffsetY: ${this.dragRefOffsetY}`);
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
    log.showInfo(TAG, `moveLeft index:${index}, offsetX:${this.viewData.offsetX}, dragRefOffsetX: ${this.dragRefOffsetX}`);
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
    log.showInfo(TAG, `moveRight index:${index},  offsetX:${this.viewData.offsetX}, dragRefOffsetX: ${this.dragRefOffsetX}`);
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
    let length = this.dragItems.length;
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
        index + this.itemColumNumber == this.dragItems.length); // 最后一个开关
    } else {
      return this.isSupportRight(index) && (index + this.itemColumNumber + 1 <= this.dragItems.length);
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
        log.showInfo(TAG, `isSupportRightUp return since offsetIndex:${offsetIndex}`);
        return false;
      }
      let length = this.dragItems.length;
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
      return this.isSupportLeft(index) && (index + this.itemColumNumber + 1 <= this.dragItems.length);
    }

    let length = this.dragItems.length;
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
        log.showInfo(TAG, `isSupportLeftUp return since offsetIndex:${offsetIndex}`);
        return false;
      }
      let length = this.dragItems.length;
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
    if (toIndex >= this.dragItems.length) {
      log.showInfo(TAG, `isSupportLeftDownSteps toIndex:${toIndex} exceed length`);
      return false;
    }
    let length = this.dragItems.length;
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
    if (toIndex >= this.dragItems.length) {
      log.showInfo(TAG, `isSupportRightDownSteps toIndex:${toIndex} exceed length`);
      return false;
    }
    let length = this.dragItems.length;
    return this.isSupportRight(index) &&
      Math.floor(index / this.itemColumNumber) + 1 == Math.floor((length - 1) / this.itemColumNumber);
  }

  private moveUpRightSteps = (index: number) => {
    let offsetIndex = Math.floor((this.viewData.offsetX - this.itemWidth / 2) / this.itemWidth);
    let toIndex = index - this.itemColumNumber + 1 + offsetIndex;
    // 移动后在一排，return
    if (Math.floor(toIndex / this.itemColumNumber) == Math.floor(index / this.itemColumNumber)) {
      log.showInfo(TAG, `moveUpRightSteps same column return`);
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
      log.showInfo(TAG, `moveUpLeftSteps same column return`);
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
      let length = this.dragItems.length;
      return this.isSupportUp(index) && (index + 1 == length && !((index + 1) / this.itemColumNumber == 0));
    }
  }

  // 支持左上
  private isSupportUpLeftSteps = (index: number): boolean => {
    if (this.isRTL()) {
      let length = this.dragItems.length;
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
    log.showInfo(TAG, `${move} index:${index},  offsetX:${this.viewData.offsetX}, offsetY:${this.viewData.offsetY},` +
      `dragRefOffsetX: ${this.dragRefOffsetX}, dragRefOffsetY: ${this.dragRefOffsetY}`);
  }

  private printMoveStepsInfo = (move: string, from: number, to: number) => {
    log.showInfo(TAG, `${move} from:${from}, to:${to}, offsetX:${this.viewData.offsetX}, offsetY:${this.viewData.offsetY},` +
      `dragRefOffsetX: ${this.dragRefOffsetX}, dragRefOffsetY: ${this.dragRefOffsetY}`);
  }

  private isRTL = (): boolean => {
    return RTLUtil.isRTL();
  }

  public setToggleDragItems(toggleDragItems: string[]): void {
    this.dragItems = toggleDragItems;
  }

  public setIsEditMode(isEditMode: boolean): void {
    this.isEditMode = isEditMode;
  }

  public getToggleDragItems(): string[] {
    return this.dragItems;
  }
}