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

import { BaseState, SlCardChildId, SlStateId, SlStateMgr } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { WidgetAnimStateV2,
  WidgetStyleStateV2,
  WidgetCacheState,
  SlComStaticStateV2,
  SlComBindStateV2,
  slComStaticSt,
  slComBindSt } from '@ohos/screenlockcommon/Index';
import { SlListStaticStateV2,
  SlListBindStateV2,
  SlCapStaticStateV2,
  SlCapBindStateV2,
  SlCardStaticStateV2,
  SlCardBindStateV2,
  SlImmBindStateV2,
  slImmBindSt,
  ImmColorVm } from '@ohos/immersivekeyguard';
import { slV2Config } from './SlV2ConfigHelper';

/**
 * 锁屏状态取用
 */
class SlV2StateHelper {
  // 状态管理分类
  private readonly slStateMgr: SlStateMgr = SlStateMgr.MGR_COMMON;
  // 锁屏通用静态状态管理器
  private slComStaticState?: SlComStaticStateV2;
  // 锁屏通用UI绑定状态管理器
  private slComBindState?: SlComBindStateV2;
  // 沉浸模块整体UI状态管理器
  private slImmBindState?: SlImmBindStateV2;
  // 沉浸列表静态状态管理器
  private slListStaticState?: SlListStaticStateV2;
  // 沉浸列表UI绑定状态管理器
  private slListBindState?: SlListBindStateV2;
  // 沉浸列表动效状态管理器
  private slListAnimState?: WidgetAnimStateV2;
  // 沉浸列表UI属性样式状态管理器
  private slListStyleState?: WidgetStyleStateV2;
  // 沉浸列表其他缓存状态管理器
  private slListCacheState?: WidgetCacheState;
  // 沉浸胶囊静态状态管理器
  private slCapStaticState?: SlCapStaticStateV2;
  // 沉浸胶囊UI绑定状态管理器
  private slCapBindState?: SlCapBindStateV2;
  // 沉浸胶囊动效状态管理器
  private slCapAnimState?: WidgetAnimStateV2;
  // 沉浸胶囊UI属性样式状态管理器
  private slCapStyleState?: WidgetStyleStateV2;
  // 沉浸胶囊其他缓存状态管理器
  private slCapCacheState?: WidgetCacheState;
  // 沉浸大卡静态状态管理器
  private slCardStaticState?: SlCardStaticStateV2;
  // 沉浸大卡UI绑定状态管理器
  private slCardBindState?: SlCardBindStateV2;
  // 沉浸大卡动效状态管理器
  private slCardAnimState?: WidgetAnimStateV2;
  // 沉浸大卡UI属性样式状态管理器
  private slCardStyleState?: WidgetStyleStateV2;
  // 沉浸大卡其他缓存状态管理器
  private slCardCacheState?: WidgetCacheState;

  constructor(stateMgr?: SlStateMgr) {
    if (stateMgr) {
      this.slStateMgr = stateMgr;
    }
  }

  /**
   * 状态管理分类
   *
   * @returns 分类
   */
  public getSlStateMgr(): SlStateMgr {
    return this.slStateMgr;
  }

  /**
   * 锁屏通用静态状态
   *
   * @returns 通用状态
   */
  public getSlComStaticState(): SlComStaticStateV2 {
    if (!this.slComStaticState) {
      this.slComStaticState = slComStaticSt;
    }
    return this.slComStaticState;
  }

  /**
   * 锁屏通用UI绑定状态
   *
   * @returns 通用状态
   */
  public getSlComBindState(): SlComBindStateV2 {
    if (!this.slComBindState) {
      this.slComBindState = slComBindSt;
    }
    return this.slComBindState;
  }

  /**
   * 沉浸模块通用UI绑定状态
   *
   * @returns 通用状态
   */
  public getSlImmBindState(): SlImmBindStateV2 {
    if (!this.slImmBindState) {
      this.slImmBindState = slImmBindSt;
    }
    return this.slImmBindState;
  }

  /**
   * 沉浸列表静态状态
   *
   * @returns 列表状态
   */
  public getSlListStaticState(): SlListStaticStateV2 {
    if (!this.slListStaticState) {
      this.slListStaticState = BaseState.wrap(SlListStaticStateV2);
    }
    return this.slListStaticState;
  }

  /**
   * 沉浸列表UI绑定状态
   *
   * @returns 列表状态
   */
  public getSlListBindState(): SlListBindStateV2 {
    if (!this.slListBindState) {
      this.slListBindState = BaseState.wrap(SlListBindStateV2);
    }
    return this.slListBindState;
  }

  /**
   * 沉浸列表动效状态
   *
   * @returns 列表状态
   */
  public getSlListAnimState(): WidgetAnimStateV2 {
    if (!this.slListAnimState) {
      this.slListAnimState = BaseState.wrap(WidgetAnimStateV2, SlStateId.SL_LIST_STATE);
    }
    return this.slListAnimState;
  }

  /**
   * 沉浸列表UI属性样式状态
   *
   * @returns 列表状态
   */
  public getSlListStyleState(): WidgetStyleStateV2 {
    if (!this.slListStyleState) {
      this.slListStyleState = BaseState.wrap(WidgetStyleStateV2, SlStateId.SL_LIST_STATE);
    }
    return this.slListStyleState;
  }

  /**
   * 沉浸列表缓存状态
   *
   * @returns 列表状态
   */
  public getSlListCacheState(): WidgetCacheState {
    if (!this.slListCacheState) {
      this.slListCacheState = BaseState.wrap(WidgetCacheState, SlStateId.SL_LIST_STATE);
    }
    return this.slListCacheState;
  }

  /**
   * 沉浸胶囊静态状态
   *
   * @returns 胶囊状态
   */
  public getSlCapStaticState(): SlCapStaticStateV2 {
    if (!this.slCapStaticState) {
      this.slCapStaticState = BaseState.wrap(SlCapStaticStateV2);
    }
    return this.slCapStaticState;
  }

  /**
   * 沉浸胶囊UI绑定状态
   *
   * @returns 胶囊状态
   */
  public getSlCapBindState(): SlCapBindStateV2 {
    if (!this.slCapBindState) {
      this.slCapBindState = BaseState.wrap(SlCapBindStateV2);
    }
    return this.slCapBindState;
  }

  /**
   * 沉浸胶囊动效状态
   *
   * @returns 胶囊状态
   */
  public getSlCapAnimState(): WidgetAnimStateV2 {
    if (!this.slCapAnimState) {
      this.slCapAnimState = BaseState.wrap(WidgetAnimStateV2, SlStateId.SL_CAP_STATE);
    }
    return this.slCapAnimState;
  }

  /**
   * 沉浸胶囊UI属性样式状态
   *
   * @returns 胶囊状态
   */
  public getSlCapStyleState(): WidgetStyleStateV2 {
    if (!this.slCapStyleState) {
      this.slCapStyleState = BaseState.wrap(WidgetStyleStateV2, SlStateId.SL_CAP_STATE);
    }
    return this.slCapStyleState;
  }

  /**
   * 沉浸胶囊缓存状态
   *
   * @returns 胶囊状态
   */
  public getSlCapCacheState(): WidgetCacheState {
    if (!this.slCapCacheState) {
      this.slCapCacheState = BaseState.wrap(WidgetCacheState, SlStateId.SL_CAP_STATE);
    }
    return this.slCapCacheState;
  }

  /**
   * 沉浸大卡静态状态
   *
   * @returns 大卡状态
   */
  public getSlCardStaticState(): SlCardStaticStateV2 {
    if (!this.slCardStaticState) {
      this.slCardStaticState = BaseState.wrap(SlCardStaticStateV2);
    }
    return this.slCardStaticState;
  }

  /**
   * 沉浸大卡UI绑定状态
   *
   * @returns 大卡状态
   */
  public getSlCardBindState(): SlCardBindStateV2 {
    if (!this.slCardBindState) {
      this.slCardBindState = BaseState.wrap(SlCardBindStateV2);
    }
    return this.slCardBindState;
  }

  /**
   * 沉浸大卡动效状态
   *
   * @returns 大卡状态
   */
  public getSlCardAnimState(): WidgetAnimStateV2 {
    if (!this.slCardAnimState) {
      this.slCardAnimState = BaseState.wrap(WidgetAnimStateV2, SlStateId.SL_CARD_STATE);
      // 同步添加子状态
      this.slCardAnimState?.addChildState(BaseState.wrap(WidgetAnimStateV2, SlCardChildId.ID_CARD_BG))
        .addChildState(BaseState.wrap(WidgetAnimStateV2, SlCardChildId.ID_CARD_PREVIEW));
    }
    return this.slCardAnimState;
  }

  /**
   * 沉浸大卡UI属性样式状态
   *
   * @returns 大卡状态
   */
  public getSlCardStyleState(): WidgetStyleStateV2 {
    if (!this.slCardStyleState) {
      this.slCardStyleState = BaseState.wrap(WidgetStyleStateV2, SlStateId.SL_CARD_STATE);
      // 同步添加子状态
      this.slCardStyleState?.addChildState(BaseState.wrap(WidgetStyleStateV2, SlCardChildId.ID_CARD_BG))
        .addChildState(BaseState.wrap(WidgetStyleStateV2, SlCardChildId.ID_CARD_PREVIEW));
    }
    return this.slCardStyleState;
  }

  /**
   * 沉浸大卡缓存状态
   *
   * @returns 大卡状态
   */
  public getSlCardCacheState(): WidgetCacheState {
    if (!this.slCardCacheState) {
      this.slCardCacheState = BaseState.wrap(WidgetCacheState, SlStateId.SL_CARD_STATE);
    }
    return this.slCardCacheState;
  }

  /**
   * 状态样式初始化配置
   */
  public initStyleConfig(): void {
    slV2Config.initStyleConfig(this.slStateMgr);
    // 同步初始化颜色提亮配置
    ImmColorVm.getInstance().init();
  }
}

// 单例，通用状态辅助工具
export const slV2ComStHelper: SlV2StateHelper = new SlV2StateHelper();

// 单例，小外屏状态辅助工具
export const slV2OuterStHelper: SlV2StateHelper = new SlV2StateHelper(SlStateMgr.MGR_OUTER_SCREEN);