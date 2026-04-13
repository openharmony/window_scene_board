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
import { SlStateId } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { CapAnimSuffix, CapStyleSuffix, CapCacheSuffix, CapShowType } from '../../../common/constants/ImmCapConst';
import { ImmItemBaseHelper } from './ImmItemBaseHelper';
import { IBaseNestableState } from './IBaseNestableState';

/**
 * 沉浸胶囊条目状态辅助工具基类
 */
export abstract class ImmCapItemBaseHelper<T extends IBaseNestableState<T>> extends ImmItemBaseHelper<T> {
  /**
   * 标识胶囊状态
   *
   * @returns 胶囊标识
   */
  protected getStateId(): SlStateId.SL_CAP_STATE {
    return SlStateId.SL_CAP_STATE;
  }

  /**
   * 胶囊item状态拼接后缀
   *
   * @returns 拼接后缀
   */
  protected abstract getStSuffix(): CapAnimSuffix | CapStyleSuffix | CapCacheSuffix;

  /**
   * 加入item状态
   *
   * @param capType 胶囊类型
   */
  public addItemSt(capType: CapShowType): void {
    super.addItemSt(capType);
  }

  /**
   * 移除item状态
   *
   * @param capType 胶囊类型
   */
  public removeItemSt(capType: CapShowType): void {
    super.removeItemSt(capType);
  }

  /**
   * 取值item状态
   *
   * @param capType 胶囊类型
   * @returns 状态值
   */
  public getItemSt(capType: CapShowType): T | undefined {
    return super.getItemSt(capType);
  }
}