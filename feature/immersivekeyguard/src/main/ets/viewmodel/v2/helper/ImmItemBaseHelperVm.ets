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
import { SlStateId, SlStateMgr, StateType } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { ImmCapItemBaseHelper } from './ImmCapItemBaseHelper';
import { ImmCardItemBaseHelper } from './ImmCardItemBaseHelper';
import { ImmItemBaseHelper } from './ImmItemBaseHelper';
import { ImmListItemBaseHelper } from './ImmListItemBaseHelper';
import { IBaseNestableState } from './IBaseNestableState';

/**
 * 沉浸模块条目辅助工具汇总业务基类
 */
export abstract class ImmItemBaseHelperVm {
  // 状态管理器名
  protected readonly stateMgrName: SlStateMgr;

  protected constructor(mgrName: SlStateMgr) {
    this.stateMgrName = mgrName;
  }

  /**
   * 辅助工具唯一标识
   *
   * @param id 状态名标识
   * @param type 状态类型标识
   * @param suffix 后缀标识
   */
  protected abstract getHelperKey(id: SlStateId, type: StateType, suffix: string): string;

  /**
   * 辅助工具类
   *
   * @param key 标识
   * @returns 工具类构造函数
   */
  protected abstract getHelperClazz(key: string): Function | undefined;

  /**
   * 获取目标状态辅助工具
   *
   * @param id 状态名标识
   * @param type 状态类型标识
   * @param suffix 后缀标识
   * @returns 辅助工具实例
   */
  public getStH<T extends IBaseNestableState<T>>(id: SlStateId, type: StateType, suffix: string):
    ImmItemBaseHelper<T> | undefined {
    let key = this.getHelperKey(id, type, suffix);
    let clazz = this.getHelperClazz(key);
    if (clazz) {
      return ImmItemBaseHelper.getHelper<T, ImmItemBaseHelper<T>>(clazz, this.stateMgrName, suffix);
    }
    return undefined;
  }

  /**
   * 获取沉浸列表目标状态辅助工具
   *
   * @param type 状态类型标识
   * @param suffix 后缀标识
   * @returns 辅助工具实例
   */
  public getListStH<T extends IBaseNestableState<T>>(type: StateType, suffix: string):
    ImmListItemBaseHelper<T> | undefined {
    return this.getStH(SlStateId.SL_LIST_STATE, type, suffix) as ImmListItemBaseHelper<T>;
  }

  /**
   * 获取沉浸胶囊目标状态辅助工具
   *
   * @param type 状态类型标识
   * @param suffix 后缀标识
   * @returns 辅助工具实例
   */
  public getCapStH<T extends IBaseNestableState<T>>(type: StateType, suffix: string):
    ImmCapItemBaseHelper<T> | undefined {
    return this.getStH(SlStateId.SL_CAP_STATE, type, suffix) as ImmCapItemBaseHelper<T>;
  }

  /**
   * 获取沉浸大卡目标状态辅助工具
   *
   * @param type 状态类型标识
   * @param suffix 后缀标识
   * @returns 辅助工具实例
   */
  public getCardStH<T extends IBaseNestableState<T>>(type: StateType, suffix: string):
    ImmCardItemBaseHelper<T> | undefined {
    return this.getStH(SlStateId.SL_CARD_STATE, type, suffix) as ImmCardItemBaseHelper<T>;
  }
}