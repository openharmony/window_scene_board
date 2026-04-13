/*
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
import { CommonConstants } from '../constants/CommonConstants';
import GridLayoutUtil, { ItemsCount } from '../utils/GridLayoutUtil';

const TAG = 'FolderViewData';
const LOG: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
/**
 * 设置Grid行列的基本单位
 */
const TEMPLATE_UNIT: string = '1fr ';
const OFFSET_STACK_LEFT: number = 3;

@Observed
export class FolderViewData {
  private readonly itemParamDefault: ItemEffectParam = new ItemEffectParam();
  public scaleX: number = 1;
  public scaleY: number = 1;
  public folderRadius: number = 0;
  public folderHeight: number = 0;
  public folderWidth: number = 0;
  public gridWidth: number = 0;
  public gridHeight: number = 0;
  public alignContent: Alignment = Alignment.Center;
  public rowsTemplate: string = '1fr 1fr 1fr';
  public columnsTemplate: string = '1fr 1fr 1fr';
  // 文件夹显示的图标数量（包含每个堆叠图标）
  public showMaxCount: number = 11;
  public isNeedUpdate: boolean = false;
  /**
   * 调整大小/回弹等动效是否正在执行， 在动效开始时设置为 true, 动效结束的时候设置为false
   */
  public isAnimating: boolean = false;
  public isAdjusting: boolean = false;
  public offsetX: number = 0;
  public offsetY: number = 0;
  public nameTransX: number = 0;
  public nameTransY: number = 0;
  public itemTransX: number = 0;
  public itemTransY: number = 0;
  public isReverseX: boolean = false;
  public isReverseY: boolean = false;
  public itemAnimParamArray: ItemEffectParam[] = [];
  public countInRow: number = 3;
  public countInColumn: number = 3;
  public rowIndex: number = 0;
  public columnIndex: number = 0;
  public area: number[] = [2, 2];
  public isZoomOut: boolean = true;

  /**
   * 初始化文件夹宽高
   *
   * @param width 宽度
   * @param height 高度
   */
  public initSize(width: number, height: number): void {
    this.folderWidth = width;
    this.folderHeight = height;
    this.setGridSize(width, height);
  }

  /**
   * 设置文件夹区域显示属性
   *
   * @param area
   */
  public setArea(area: number[]): void {
    this.countInRow = GridLayoutUtil.getCountPerRowInFolder(area);
    this.countInColumn = GridLayoutUtil.getCountPerColumnInFolder(area);
    this.area = area;
    this.columnsTemplate = this.getTemplate(this.countInRow);
    this.rowsTemplate = this.getTemplate(this.countInColumn);
    this.showMaxCount = this.countInRow * this.countInColumn;
    LOG.showInfo(`setArea:${area}, countInRow=${this.countInRow}, countInColumn=${this.countInColumn}`);
  }

  /**
   * 设置Grid的大小
   *
   * @param width 宽度
   * @param height 高度
   */
  public setGridSize(width: number, height: number): void {
    this.gridWidth = width;
    this.gridHeight = height;
  }

  /**
   * 设置文件夹在页面上的位置
   *
   * @param row 行号
   * @param column 列号
   */
  public setGridIndex(row: number, column: number): void {
    this.rowIndex = row;
    this.columnIndex = column;
  }

  public reset(): void {
    this.itemAnimParamArray = [];
  }

  public isLayout4X2(): boolean {
    return this.countInRow === ItemsCount.SIZE_4.valueOf();
  }

  /**
   * 根据显示个数获取Grid的模板
   *
   * @param value 显示的个数
   * @returns Grid模板
   */
  public getTemplate(value: number): string {
    let template: string = '';
    for (let i = 0; i < value; i++) {
      template += TEMPLATE_UNIT;
    }
    return template.trim();
  }

  /**
   * 拖动过程中元素在X方向的位移
   *
   * @param index 索引
   * @returns X方向位移
   */
  public getItemTransX(index: number): number {
    let columnIndex: number = index % this.countInRow;
    if (this.isReverseX) {
      return (this.countInRow - 1 - columnIndex) * this.itemTransX;
    } else {
      return columnIndex * this.itemTransX;
    }
  }

  /**
   * 拖动过程中元素在Y方向的位移
   *
   * @param index 索引
   * @returns Y方向位移
   */
  public getItemTransY(index: number): number {
    let rowIndex: number = Math.floor(index / this.countInRow);
    if (this.isReverseY) {
      return (this.countInColumn - 1 - rowIndex) * this.itemTransY;
    } else {
      return rowIndex * this.itemTransY;
    }
  }

  /**
   * 大小变换时各元素动效
   *
   * @param index 索引
   * @returns 对应元素上树的动效
   */
  public getItemEffect(index: number): TransitionEffect {
    return this.getItemZoomParam(index).effect;
  }

  /**
   * 大小变换时各元素动效过程的zIndex
   *
   * @param index 索引
   * @returns 对应元素的zIndex
   */
  public getItemZIndex(index: number, defaultValue: number): number {
    if (!this.isAdjusting) {
      return defaultValue;
    }
    if (!this.itemAnimParamArray || this.itemAnimParamArray.length === 0) {
      return defaultValue;
    }
    return this.getItemZoomParam(index).zIndex;
  }

  public getItemZoomParam(index: number): ItemEffectParam {
    if (!this.isAdjusting) {
      return this.itemParamDefault;
    }
    if (!this.itemAnimParamArray || this.itemAnimParamArray.length === 0) {
      return this.itemParamDefault;
    }
    let length: number = this.itemAnimParamArray.length;
    let realIndex: number = index >= length ? (this.isZoomOut ? length - OFFSET_STACK_LEFT : length - 1) : index;
    return this.itemAnimParamArray[realIndex];
  }
}

export class ItemEffectParam {
  public zIndex: number = 0;
  public effect: TransitionEffect = TransitionEffect.IDENTITY;
}