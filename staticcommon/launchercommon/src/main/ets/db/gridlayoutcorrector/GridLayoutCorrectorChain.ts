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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { AbstractGridLayoutCorrector } from './AbstractGridLayoutCorrector';
import { AbnormalItemCorrector } from './AbnormalItemCorrector';
import { DuplicatePositionCorrector } from './DuplicatePositionCorrector';
import { FieldNotNullCorrector } from './FieldNotNullCorrector';
import { DirtyFormStackCorrector } from './DirtyFormStackCorrector';
import { DirtyFormCorrector } from './DirtyFormCorrector';
import { ShortcutChangeCorrector } from './ShortcutChangeCorrector';
import { NoImageItemCorrector } from './NoImageItemCorrector';

const TAG = 'GridLayoutCorrectorChain';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class GridLayoutCorrectorChain {

  private static sInstance: GridLayoutCorrectorChain;

  private gridLayoutCorrectors: AbstractGridLayoutCorrector[] = [];

  /**
   * GridLayoutCorrectorManager instance
   *
   * @return GridLayoutCorrectorManager instance
   */
  public static getInstance(): GridLayoutCorrectorChain {
    if (!GridLayoutCorrectorChain.sInstance) {
      GridLayoutCorrectorChain.sInstance = new GridLayoutCorrectorChain();
    }
    return GridLayoutCorrectorChain.sInstance;
  }

  public initCorrectorChain(): void {
    this.addGridLayoutCorrector(new FieldNotNullCorrector());
    this.addGridLayoutCorrector(new AbnormalItemCorrector());
    this.addGridLayoutCorrector(new DuplicatePositionCorrector());
    this.addGridLayoutCorrector(new DirtyFormStackCorrector());
    this.addGridLayoutCorrector(new ShortcutChangeCorrector());
    this.addGridLayoutCorrector(new NoImageItemCorrector());
  }

  /**
   * 添加桌面布局数据矫正器
   *
   * @param gridLayoutCorrector
   */
  public addGridLayoutCorrector(gridLayoutCorrector: AbstractGridLayoutCorrector): boolean {
    this.gridLayoutCorrectors.push(gridLayoutCorrector);
    return true;
  }

  /**
   * 处理桌面布局数据纠正
   *
   * @param gridLayoutCorrector
   */
  public handleData(girdLayoutInfo: GridLayoutItemInfo[], isOuter?:boolean): void {
    log.showInfo('handleData girdLayoutInfo length=%{public}d', girdLayoutInfo.length);
    for (let i = 0; i < this.gridLayoutCorrectors.length; i++) {
      this.gridLayoutCorrectors[i].handleData(girdLayoutInfo, isOuter);
    }
  }

  public clearCorrectorChain(): void {
    this.gridLayoutCorrectors = [];
  }
}

export const gridLayoutCorrector: GridLayoutCorrectorChain = GridLayoutCorrectorChain.getInstance();