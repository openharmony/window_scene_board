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
import { ListAnimSuffix, ListCacheSuffix, ListStyleSuffix } from '../../../common/constants/ImmListConst';
import { ImmItemBaseHelper } from './ImmItemBaseHelper';
import { IBaseNestableState } from './IBaseNestableState';

/**
 * 沉浸列表条目状态辅助工具基类
 */
export abstract class ImmListItemBaseHelper<T extends IBaseNestableState<T>> extends ImmItemBaseHelper<T> {
  /**
   * 标识列表状态
   *
   * @returns 列表标识
   */
  protected getStateId(): SlStateId.SL_LIST_STATE {
    return SlStateId.SL_LIST_STATE;
  }

  /**
   * 列表item状态拼接后缀
   *
   * @returns 拼接后缀
   */
  protected abstract getStSuffix(): ListAnimSuffix | ListStyleSuffix | ListCacheSuffix;
}