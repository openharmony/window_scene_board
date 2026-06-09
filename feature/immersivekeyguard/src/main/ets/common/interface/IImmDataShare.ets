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

import { NotificationRefreshRecord, NotificationRefreshType } from '@ohos/systemuicommon/newIndex';
import { NotificationArray } from '@ohos/systemuicommon/newTsIndex';

/**
 * 沉浸模块数据共享器
 */
export interface IImmDataShare extends NotificationRefreshRecord {
  // 全量数据集
  allDataArr?: NotificationArray;
  // 新增/删除数据集
  changeDataArr?: NotificationArray;
  // 更新数据集
  updateDataArr?: NotificationArray;
}

/**
 * 数据共享器装饰器
 */
export class ImmDataShareWrap {
  private readonly dataShare: IImmDataShare;

  // 标识是否自动亮屏
  private _isAutoScreenOn: boolean = false;

  private constructor(dataShare: IImmDataShare) {
    this.dataShare = dataShare;
  }

  /**
   * 数据是否有变化
   *
   * @returns true数据变化
   */
  public isDataChange(): boolean {
    return this.dataShare?.isDataRefresh;
  }

  /**
   * 数据刷新类型
   *
   * @returns 类型
   */
  public getRefreshType(): NotificationRefreshType {
    return this.dataShare?.dataRefreshType;
  }

  /**
   * 初始化数据
   *
   * @returns true初始化
   */
  public isInit(): boolean {
    return this.dataShare?.dataRefreshType === NotificationRefreshType.DATA_INIT;
  }

  /**
   * 添加数据
   *
   * @returns true添加
   */
  public isAdd(): boolean {
    return this.dataShare?.dataRefreshType === NotificationRefreshType.DATA_ADD;
  }

  /**
   * 更新数据
   *
   * @returns true更新
   */
  public isUpdate(): boolean {
    return this.dataShare?.dataRefreshType === NotificationRefreshType.DATA_UPDATE;
  }

  /**
   * 删除数据
   *
   * @returns true删除
   */
  public isDel(): boolean {
    return this.dataShare?.dataRefreshType === NotificationRefreshType.DATA_DELETE;
  }

  /**
   * 最小变化数据集，新增/删除
   *
   * @returns 数据集
   */
  public getDataChangeArr(): NotificationArray | undefined {
    return this.dataShare?.changeDataArr;
  }

  /**
   * 最小变化数据集，更新
   *
   * @returns 数据集
   */
  public getDataUpdateArr(): NotificationArray | undefined {
    return this.dataShare?.updateDataArr;
  }

  /**
   * 全量数据集
   *
   * @returns 数据集
   */
  public getDataAllArr(): NotificationArray | undefined {
    return this.dataShare?.allDataArr;
  }

  /**
   * 标识是否自动亮屏
   *
   * @param isAutoScreenOn true自动亮屏
   */
  public setAutoScreenOn(isAutoScreenOn: boolean): void {
    this._isAutoScreenOn = isAutoScreenOn;
  }

  /**
   * 当前数据刷新是否自动亮屏
   *
   * @returns true自动亮屏
   */
  public isAutoScreenOn(): boolean {
    return this._isAutoScreenOn;
  }

  /**
   * 装饰器
   *
   * @param dataShare 原数据
   * @returns 装饰器
   */
  public static wrap(dataShare: IImmDataShare): ImmDataShareWrap {
    return new ImmDataShareWrap(dataShare);
  }
}