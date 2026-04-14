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

const TAG = 'ImmUeDataHelper';

export enum UeDataComp {
  // 列表0层组件
  LIST_ZERO = 'L0',
  // 列表1层组件
  LIST_ONE = 'L1',
  // 胶囊0层组件
  CAP_ZERO = 'C0',
  // 胶囊1层组件
  CAP_ONE = 'C1'
}

export enum UeDataType {
  OPACITY = 'op',
  VISIBILITY = 'vi'
}

export class ImmUeDataHelper {
  // 单例
  private static instance: ImmUeDataHelper;

  /**
   * 私有构造
   */
  private constructor() {
  }

  // 影响通知是否可见的参数，包括透明度和可见性
  private visualParams: Map<string, number | undefined> = new Map();

  public static getInstance(): ImmUeDataHelper {
    if(!ImmUeDataHelper.instance) {
      ImmUeDataHelper.instance = new ImmUeDataHelper();
    }
    return ImmUeDataHelper.instance;
  }

  public setVisualParam(comp: UeDataComp, type: UeDataType, value: number | undefined): void {
    let key: string = `${comp}_${type}`;
    this.visualParams.set(key, value);
  }

  /**
   * 获取拼接后的可见性参数信息字符串
   *
   * @returns 可见性参数信息
   */
  public getVisualParams(): string {
    let res: string = '';
    if (this.visualParams.size === 0) {
      return res;
    }
    this.visualParams.forEach((value, key) => {
      res += `${key}_${value}_`;
    });
    return res;
  }
}

