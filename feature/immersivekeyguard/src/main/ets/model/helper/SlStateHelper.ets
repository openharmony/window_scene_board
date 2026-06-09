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

import { IBaseState,
  LimitMap,
  SlStateBaseMgr,
  SlStateId,
  SlStateMgr,
  StateType } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import {
  SlStateCmMgr,
  WidgetAnimStateV2,
  WidgetStyleStateV2,
  WidgetCacheState
} from '@ohos/screenlockcommon/Index';
import { SlCapBindStateV2 } from '../data/v2/SlCapBindStateV2';
import { SlCapStaticStateV2 } from '../data/v2/SlCapStaticStateV2';
import { SlCardBindStateV2 } from '../data/v2/SlCardBindStateV2';
import { SlCardStaticStateV2 } from '../data/v2/SlCardStaticStateV2';
import { SlImmBindStateV2 } from '../data/v2/SlImmBindStateV2';
import { SlListBindStateV2 } from '../data/v2/SlListBindStateV2';
import { SlListStaticStateV2 } from '../data/v2/SlListStaticStateV2';

const TAG = 'SlStateHelper_immersive';

// 限制大小
const LIMIT_MAX = 10;

/**
 * 状态辅助工具
 */
export class SlStateHelper {
  // 单例集
  private static instance: LimitMap<SlStateMgr, SlStateHelper> = new LimitMap(TAG, LIMIT_MAX);

  // 状态管理器名称
  private mgrName: SlStateMgr;

  /**
   * 私有构造
   *
   * @param mgrName 状态管理器名
   */
  private constructor(mgrName: SlStateMgr) {
    this.mgrName = mgrName;
  }

  /**
   * 状态管理器
   *
   * @returns 管理器
   */
  private getMgr(): SlStateBaseMgr {
    let mgr = SlStateBaseMgr.getMgr(this.mgrName);
    // 默认通用管理器
    if (!mgr) {
      mgr = SlStateCmMgr.getInstance();
    }
    return mgr;
  }

  /**
   * 获取状态
   *
   * @param stateType 状态类型
   * @param stateId 状态标示
   * @returns 状态
   */
  public getSlState(stateType: StateType, stateId: SlStateId): IBaseState | undefined {
    return this.getMgr().getState(stateType, stateId);
  }

  /**
   * 锁屏模块通用静态状态
   *
   * @returns 通用状态
   */
  public getComStaticState(): IBaseState | undefined {
    return this.getSlState(StateType.STATIC, SlStateId.SL_COM_STATE);
  }

  /**
   * 锁屏模块通用UI绑定状态
   *
   * @returns 通用状态
   */
  public getComBindState(): IBaseState | undefined {
    return this.getSlState(StateType.BIND, SlStateId.SL_COM_STATE);
  }

  /**
   * 沉浸模块整体静态状态
   *
   * @returns 沉浸状态
   */
  public getImmStaticState(): IBaseState {
    return this.getSlState(StateType.STATIC, SlStateId.SL_IMMERSIVE_STATE) as IBaseState;
  }

  /**
   * 沉浸模块整体UI绑定状态
   *
   * @returns 沉浸状态
   */
  public getImmBindState(): SlImmBindStateV2 {
    return this.getSlState(StateType.BIND, SlStateId.SL_IMMERSIVE_STATE) as SlImmBindStateV2;
  }

  /**
   * 沉浸模块整体动效状态
   *
   * @returns 沉浸状态
   */
  public getImmAnimState(): WidgetAnimStateV2 {
    return this.getSlState(StateType.ANIM, SlStateId.SL_IMMERSIVE_STATE) as WidgetAnimStateV2;
  }

  /**
   * 沉浸模块整体属性样式状态
   *
   * @returns 沉浸状态
   */
  public getImmStyleState(): WidgetStyleStateV2 {
    return this.getSlState(StateType.STYLE, SlStateId.SL_IMMERSIVE_STATE) as WidgetStyleStateV2;
  }

  /**
   * 沉浸模块整体缓存状态
   *
   * @returns 沉浸状态
   */
  public getImmCacheState(): WidgetCacheState {
    return this.getSlState(StateType.CACHE, SlStateId.SL_IMMERSIVE_STATE) as WidgetCacheState;
  }

  /**
   * 沉浸列表静态状态
   *
   * @returns 列表状态
   */
  public getListStaticState(): SlListStaticStateV2 {
    return this.getSlState(StateType.STATIC, SlStateId.SL_LIST_STATE) as SlListStaticStateV2;
  }

  /**
   * 沉浸列表UI绑定状态
   *
   * @returns 列表状态
   */
  public getListBindState(): SlListBindStateV2 {
    return this.getSlState(StateType.BIND, SlStateId.SL_LIST_STATE) as SlListBindStateV2;
  }

  /**
   * 沉浸列表动效状态
   *
   * @returns 列表状态
   */
  public getListAnimState(): WidgetAnimStateV2 {
    return this.getSlState(StateType.ANIM, SlStateId.SL_LIST_STATE) as WidgetAnimStateV2;
  }

  /**
   * 沉浸列表UI属性样式状态
   *
   * @returns 列表状态
   */
  public getListStyleState(): WidgetStyleStateV2 {
    return this.getSlState(StateType.STYLE, SlStateId.SL_LIST_STATE) as WidgetStyleStateV2;
  }

  /**
   * 沉浸列表缓存状态
   *
   * @returns 列表状态
   */
  public getListCacheState(): WidgetCacheState {
    return this.getSlState(StateType.CACHE, SlStateId.SL_LIST_STATE) as WidgetCacheState;
  }

  /**
   * 沉浸胶囊静态状态
   *
   * @returns 胶囊状态
   */
  public getCapStaticState(): SlCapStaticStateV2 {
    return this.getSlState(StateType.STATIC, SlStateId.SL_CAP_STATE) as SlCapStaticStateV2;
  }

  /**
   * 沉浸胶囊UI绑定状态
   *
   * @returns 胶囊状态
   */
  public getCapBindState(): SlCapBindStateV2 {
    return this.getSlState(StateType.BIND, SlStateId.SL_CAP_STATE) as SlCapBindStateV2;
  }

  /**
   * 沉浸胶囊动效状态
   *
   * @returns 胶囊状态
   */
  public getCapAnimState(): WidgetAnimStateV2 {
    return this.getSlState(StateType.ANIM, SlStateId.SL_CAP_STATE) as WidgetAnimStateV2;
  }

  /**
   * 沉浸胶囊UI属性样式状态
   *
   * @returns 胶囊状态
   */
  public getCapStyleState(): WidgetStyleStateV2 {
    return this.getSlState(StateType.STYLE, SlStateId.SL_CAP_STATE) as WidgetStyleStateV2;
  }

  /**
   * 沉浸胶囊缓存状态
   *
   * @returns 胶囊状态
   */
  public getCapCacheState(): WidgetCacheState {
    return this.getSlState(StateType.CACHE, SlStateId.SL_CAP_STATE) as WidgetCacheState;
  }

  /**
   * 沉浸大卡静态状态
   *
   * @returns 大卡状态
   */
  public getCardStaticState(): SlCardStaticStateV2 {
    return this.getSlState(StateType.STATIC, SlStateId.SL_CARD_STATE) as SlCardStaticStateV2;
  }

  /**
   * 沉浸大卡UI绑定状态
   *
   * @returns 大卡状态
   */
  public getCardBindState(): SlCardBindStateV2 {
    return this.getSlState(StateType.BIND, SlStateId.SL_CARD_STATE) as SlCardBindStateV2;
  }

  /**
   * 沉浸大卡动效状态
   *
   * @returns 大卡状态
   */
  public getCardAnimState(): WidgetAnimStateV2 {
    return this.getSlState(StateType.ANIM, SlStateId.SL_CARD_STATE) as WidgetAnimStateV2;
  }

  /**
   * 沉浸大卡UI属性样式状态
   *
   * @returns 大卡状态
   */
  public getCardStyleState(): WidgetStyleStateV2 {
    return this.getSlState(StateType.STYLE, SlStateId.SL_CARD_STATE) as WidgetStyleStateV2;
  }

  /**
   * 沉浸大卡缓存状态
   *
   * @returns 大卡状态
   */
  public getCardCacheState(): WidgetCacheState {
    return this.getSlState(StateType.CACHE, SlStateId.SL_CARD_STATE) as WidgetCacheState;
  }

  /**
   * 获取实例
   *
   * @param mgrName 状态管理器名
   * @returns 状态辅助实例
   */
  public static getInstance(mgrName: SlStateMgr = SlStateMgr.MGR_COMMON): SlStateHelper {
    let helper = SlStateHelper.instance.get(mgrName);
    if (!helper) {
      helper = new SlStateHelper(mgrName);
      SlStateHelper.instance.set(mgrName, helper);
    }
    return helper;
  }
}