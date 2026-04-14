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
import { SlStateId, SlStateMgr, StateType } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { CapAnimSuffix,
  CapCacheSuffix,
  CapStyleSuffix,
  CAP_ALL_ANIM_SF,
  CAP_ALL_CACHE_SF,
  CAP_ALL_STYLE_SF } from '../../../common/constants/ImmCapConst';
import { CardAnimSuffix,
  CardCacheSuffix,
  CardStyleSuffix,
  CARD_ALL_ANIM_SF,
  CARD_ALL_CACHE_SF,
  CARD_ALL_STYLE_SF } from '../../../common/constants/ImmCardConst';
import { ListAnimSuffix,
  ListCacheSuffix,
  ListStyleSuffix,
  LIST_ALL_ANIM_SF,
  LIST_ALL_CACHE_SF,
  LIST_ALL_STYLE_SF } from '../../../common/constants/ImmListConst';
import { IImmItemHelperVm } from '../../../common/interface/IImmItemHelperVm';
import { ImmCapItemAnimHelper } from './ImmCapItemAnimHelper';
import { ImmCapItemCacheHelper } from './ImmCapItemCacheHelper';
import { ImmCapItemStyleHelper } from './ImmCapItemStyleHelper';
import { ImmCardItemAnimHelper } from './ImmCardItemAnimHelper';
import { ImmCardItemCacheHelper } from './ImmCardItemCacheHelper';
import { ImmCardItemStyleHelper } from './ImmCardItemStyleHelper';
import { ImmItemBaseHelperVm } from './ImmItemBaseHelperVm';
import { ImmListItemAnimHelper } from './ImmListItemAnimHelper';
import { ImmListItemCacheHelper } from './ImmListItemCacheHelper';
import { ImmListItemStyleHelper } from './ImmListItemStyleHelper';

/**
 * 唯一标示拼接
 *
 * @param id 状态名称标识
 * @param type 状态类型标识
 * @param suffix 状态后缀标识
 * @returns 唯一标识
 */
function getKey(id: SlStateId, type: StateType, suffix: string): string {
  return `${id}_${type}_${suffix}`;
}

// 沉浸模块状态辅助工具预置
let hasInitMap: boolean = false;
const IMM_ST_HELPER: Map<string, Function> = new Map();
function initImmStHelper(): void {
  if (hasInitMap) {
    return;
  }
  hasInitMap = true;
  // 列表模块状态工具初始化
  let id = SlStateId.SL_LIST_STATE;
  // 列表动效模块
  let type = StateType.ANIM;
  LIST_ALL_ANIM_SF.forEach((sf) => IMM_ST_HELPER.set(getKey(id, type, sf), ImmListItemAnimHelper));
  // 列表样式模块
  type = StateType.STYLE;
  LIST_ALL_STYLE_SF.forEach((sf) => IMM_ST_HELPER.set(getKey(id, type, sf), ImmListItemStyleHelper));
  // 列表缓存模块
  type = StateType.CACHE;
  LIST_ALL_CACHE_SF.forEach((sf) => IMM_ST_HELPER.set(getKey(id, type, sf), ImmListItemCacheHelper));

  // 胶囊模块状态工具初始化
  id = SlStateId.SL_CAP_STATE;
  // 胶囊动效模块
  type = StateType.ANIM;
  CAP_ALL_ANIM_SF.forEach((sf) => IMM_ST_HELPER.set(getKey(id, type, sf), ImmCapItemAnimHelper));
  // 胶囊样式模块
  type = StateType.STYLE;
  CAP_ALL_STYLE_SF.forEach((sf) => IMM_ST_HELPER.set(getKey(id, type, sf), ImmCapItemStyleHelper));
  // 胶囊缓存模块
  type = StateType.CACHE;
  CAP_ALL_CACHE_SF.forEach((sf) => IMM_ST_HELPER.set(getKey(id, type, sf), ImmCapItemCacheHelper));

  // 大卡模块状态工具初始化
  id = SlStateId.SL_CARD_STATE;
  // 大卡动效模块
  type = StateType.ANIM;
  CARD_ALL_ANIM_SF.forEach((sf) => IMM_ST_HELPER.set(getKey(id, type, sf), ImmCardItemAnimHelper));
  // 大卡样式模块
  type = StateType.STYLE;
  CARD_ALL_STYLE_SF.forEach((sf) => IMM_ST_HELPER.set(getKey(id, type, sf), ImmCardItemStyleHelper));
  // 大卡缓存模块
  type = StateType.CACHE;
  CARD_ALL_CACHE_SF.forEach((sf) => IMM_ST_HELPER.set(getKey(id, type, sf), ImmCardItemCacheHelper));
}

/**
 * 沉浸模块条目辅助工具汇总业务
 */
export class ImmItemHelperVm extends ImmItemBaseHelperVm implements IImmItemHelperVm {
  // 实例管理
  private static readonly sInstance: Map<SlStateMgr, ImmItemHelperVm> = new Map();

  private constructor(mgrName: SlStateMgr) {
    super(mgrName);
    // 初始化配置项
    initImmStHelper();
  }

  protected getHelperKey(id: SlStateId, type: StateType, suffix: string): string {
    return getKey(id, type, suffix);
  }

  protected getHelperClazz(key: string): Function | undefined {
    return IMM_ST_HELPER.get(key);
  }

  /**
   * 沉浸列表动效状态辅助工具
   *
   * @param suffix 动效后缀
   * @returns 辅助工具实例
   */
  public getListAnimH(suffix: ListAnimSuffix): ImmListItemAnimHelper {
    return this.getListStH(StateType.ANIM, suffix) as ImmListItemAnimHelper;
  }

  /**
   * 沉浸列表样式状态辅助工具
   *
   * @param suffix 样式后缀
   * @returns 辅助工具实例
   */
  public getListStyleH(suffix: ListStyleSuffix): ImmListItemStyleHelper {
    return this.getListStH(StateType.STYLE, suffix) as ImmListItemStyleHelper;
  }

  /**
   * 沉浸列表缓存状态辅助工具
   *
   * @param suffix 缓存后缀
   * @returns 辅助工具实例
   */
  public getListCacheH(suffix: ListCacheSuffix): ImmListItemCacheHelper {
    return this.getListStH(StateType.CACHE, suffix) as ImmListItemCacheHelper;
  }

  /**
   * 沉浸胶囊动效状态辅助工具
   *
   * @param suffix 动效后缀
   * @returns 辅助工具实例
   */
  public getCapAnimH(suffix: CapAnimSuffix): ImmCapItemAnimHelper {
    return this.getCapStH(StateType.ANIM, suffix) as ImmCapItemAnimHelper;
  }

  /**
   * 沉浸胶囊样式状态辅助工具
   *
   * @param suffix 样式后缀
   * @returns 辅助工具实例
   */
  public getCapStyleH(suffix: CapStyleSuffix): ImmCapItemStyleHelper {
    return this.getCapStH(StateType.STYLE, suffix) as ImmCapItemStyleHelper;
  }

  /**
   * 沉浸胶囊缓存状态辅助工具
   *
   * @param suffix 缓存后缀
   * @returns 辅助工具实例
   */
  public getCapCacheH(suffix: CapCacheSuffix): ImmCapItemCacheHelper {
    return this.getCapStH(StateType.CACHE, suffix) as ImmCapItemCacheHelper;
  }

  /**
   * 沉浸大卡动效状态辅助工具
   *
   * @param suffix 动效后缀
   * @returns 辅助工具实例
   */
  public getCardAnimH(suffix: CardAnimSuffix): ImmCardItemAnimHelper {
    return this.getCardStH(StateType.ANIM, suffix) as ImmCardItemAnimHelper;
  }

  /**
   * 沉浸大卡样式状态辅助工具
   *
   * @param suffix 样式后缀
   * @returns 辅助工具实例
   */
  public getCardStyleH(suffix: CardStyleSuffix): ImmCardItemStyleHelper {
    return this.getCardStH(StateType.STYLE, suffix) as ImmCardItemStyleHelper;
  }

  /**
   * 沉浸大卡缓存状态辅助工具
   *
   * @param suffix 缓存后缀
   * @returns 辅助工具实例
   */
  public getCardCacheH(suffix: CardCacheSuffix): ImmCardItemCacheHelper {
    return this.getCardStH(StateType.CACHE, suffix) as ImmCardItemCacheHelper;
  }

  /**
   * 实例获取
   *
   * @param mgrName 管理器名
   * @returns 实例
   */
  public static getInstance(mgrName: SlStateMgr): ImmItemHelperVm {
    let helperVm = ImmItemHelperVm.sInstance.get(mgrName);
    if (helperVm) {
      return helperVm;
    }
    helperVm = new ImmItemHelperVm(mgrName);
    ImmItemHelperVm.sInstance.set(mgrName, helperVm);
    return helperVm;
  }
}