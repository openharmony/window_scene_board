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
import { BaseState, SlStateMgr, StateType } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { WidgetCacheState } from '@ohos/screenlockcommon/Index';
import { CapCacheSuffix } from '../../../common/constants/ImmCapConst';
import { ICapItemCacheStHelper } from '../../../common/interface/ICapItemCacheStHelper';
import { ImmCapItemBaseHelper } from './ImmCapItemBaseHelper';

/**
 * 沉浸胶囊条目缓存状态辅助工具基类
 */
export class ImmCapItemCacheHelper extends ImmCapItemBaseHelper<WidgetCacheState>
  implements ICapItemCacheStHelper {
  // 缓存后缀
  private readonly _suffix: CapCacheSuffix;

  constructor(mgrName: SlStateMgr, suffix: CapCacheSuffix) {
    super(mgrName);
    this._suffix = suffix;
  }

  /**
   * 复写状态类型，缓存类型
   *
   * @returns 状态类型
   */
  protected getStateType(): StateType {
    return StateType.ANIM;
  }

  /**
   * 缓存后缀区分
   *
   * @returns 后缀
   */
  protected getStSuffix(): CapCacheSuffix {
    return this._suffix;
  }

  /**
   * 复写创建状态实例，缓存实例
   *
   * @param childKey 状态标识
   * @returns 实例
   */
  protected createChildState(childKey: string): WidgetCacheState {
    return BaseState.wrap(WidgetCacheState, childKey);
  }
}