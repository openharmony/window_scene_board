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

import type { DragEvent } from 'DragControllerParam';
import {
  DragCallbackParams,
  DragEventParams,
  DragGridInfo,
  DragGridItem,
  DragGridLayout,
  DragGridPosition,
  DragPosition,
} from '../../common/type/CommonTypes';
import { SqueezeCheckResult } from '../../common/type/SqueezeTypes';

/**
 * 挤位状态类型
 */
export enum SqueezeStateType {
  MOVE_STATE = 'MOVE',
  COMBINE_STATE = 'COMBINE',
  SQUEEZE_STATE = 'SQUEEZE',
  FINISH_STATE = 'FINISH',
}

/**
 * 挤位状态机的上下文，目前主要是保存了ArkUI事件的参数
 */
export class SqueezeMachineContext {
  private dragParams: DragEventParams;
  private dragInfo: DragGridInfo;
  private dragLayout: DragGridLayout;
  private isSlowSpeed: boolean = false;
  private position: DragPosition;
  private gridPosition: DragGridPosition;
  private coveredItem: DragGridItem;
  private squeezeCheckResult: SqueezeCheckResult = SqueezeCheckResult.ERROR;

  /**
   * 设置上下文内容
   *
   * @param event ArkUI事件的入参
   * @param extraParams ArkUI事件的入参
   * @returns 上下文实例
   */
  public setDragParams(event: DragEvent, extraParams: string = ''): this {
    this.dragParams = {
      event: event,
      extraParams: extraParams,
    };
    return this;
  }

  /**
   * 设置拖拽元素信息
   *
   * @param dragItem 拖拽元素信息
   * @returns 上下文实例
   */
  public setDragInfo(dragInfo: DragGridInfo): this {
    this.dragInfo = dragInfo;
    return this;
  }

  /**
   * 获取拖拽元素信息
   *
   * @returns 拖拽元素信息
   */
  public getDragInfo(): DragGridInfo {
    return this.dragInfo;
  }

  /**
   * 设置拖拽布局信息
   *
   * @param dragLayout 拖拽布局信息
   * @returns 上下文实例
   */
  public setDragLayout(dragLayout: DragGridLayout): this {
    this.dragLayout = dragLayout;
    return this;
  }

  /**
   * 获取拖拽布局信息
   *
   * @returns 拖拽布局信息
   */
  public getDragLayout(): DragGridLayout {
    return this.dragLayout;
  }

  /**
   * 设置速度是否是慢速
   *
   * @param isSlowSpeed 速度是否是慢速
   * @returns 上下文实例
   */
  public setSlowSpeed(isSlowSpeed: boolean): this {
    this.isSlowSpeed = isSlowSpeed;
    return this;
  }

  /**
   * 获取速度是否是慢速
   *
   * @returns 速度是否是慢速
   */
  public isSlow(): boolean {
    return this.isSlowSpeed;
  }

  /**
   * 设置拖拽的坐标位置
   *
   * @param position 拖拽的坐标位置
   * @returns 上下文实例
   */
  public setPosition(position: DragPosition): this {
    this.position = position;
    return this;
  }

  /**
   * 获取拖拽的坐标位置
   *
   * @returns 拖拽的坐标位置
   */
  public getPosition(): DragPosition {
    return this.position;
  }

  /**
   * 设置拖拽的宫格位置
   *
   * @param gridPosition 拖拽的宫格位置
   * @returns 上下文实例
   */
  public setGridPosition(gridPosition: DragGridPosition): this {
    this.gridPosition = gridPosition;
    return this;
  }

  /**
   * 获取拖拽的宫格位置
   *
   * @returns 拖拽的宫格位置
   */
  public getGridPosition(): DragGridPosition {
    return this.gridPosition;
  }

  /**
   * 设置被覆盖的元素
   *
   * @param coveredItem 被覆盖的元素
   * @returns 上下文实例
   */
  public setCoveredItem(coveredItem: DragGridItem): this {
    this.coveredItem = coveredItem;
    return this;
  }

  /**
   * 获取被覆盖的元素
   *
   * @returns 被覆盖的元素
   */
  public getCoveredItem(): DragGridItem {
    return this.coveredItem;
  }

  /**
   * 设置挤位确认结果
   *
   * @param result 挤位确认结果
   * @returns 上下文实例
   */
  public setSqueezeCheckResult(result: SqueezeCheckResult): this {
    this.squeezeCheckResult = result;
    return this;
  }

  /**
   * 获取挤位确认结果
   *
   * @returns 挤位确认结果
   */
  public getSqueezeCheckResult(): SqueezeCheckResult {
    return this.squeezeCheckResult;
  }

  /**
   * 清空上下文内容
   */
  public clear(): void {
    this.dragParams = null;
    this.dragInfo = null;
    this.dragLayout = null;
    this.isSlowSpeed = false;
    this.position = null;
    this.gridPosition = null;
    this.coveredItem = null;
    this.squeezeCheckResult = SqueezeCheckResult.ERROR;
  }

  /**
   * 获取通用回调参数
   *
   * @returns 通用回调参数
   */
  public getCallbackParam(): DragCallbackParams {
    return {
      eventParams: this.dragParams,
      dragInfo: this.dragInfo,
      position: this.position,
      gridPosition: this.gridPosition,
    };
  }

  /**
   * 是否要切换到结束状态
   *
   * @returns 是否要切换到结束状态
   */
  public isFinish(): boolean {
    return this.dragParams == null;
  }

  /**
   * 获取上下文的文本描述字符串
   *
   * @returns 拼接的上下文描述内容
   */
  public toString(): string {
    return `SqueezeMachineContext position[${this.position?.x}, ${this.position?.y}] grid[${this.gridPosition?.row}, ` +
      `${this.gridPosition?.column}] isSlowSpeed:${this.isSlowSpeed} squeezeCheckResult:${this.squeezeCheckResult} `;
  }
}
