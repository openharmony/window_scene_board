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

import {
  IBaseState,
  SlStateBaseMgr,
  SlStateId,
  SlStateMgr,
  StateType
} from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { WidgetAnimStateV2, WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';

/**
 * 锁屏模块V2状态辅助工具
 */
export class SlV2StateHelper {
  // 实例
  private static instance: Map<SlStateMgr, SlV2StateHelper> = new Map();
  // 状态管理器名称，默认通用管理器
  private stMgrName: SlStateMgr = SlStateMgr.MGR_COMMON;
  // 状态管理器
  private stateMgr?: SlStateBaseMgr;

  // 沉浸列表根布局动效管理器
  private immListAnim?: WidgetAnimStateV2;
  // 沉浸列表根布局样式管理器
  private immListStyle?: WidgetStyleStateV2;

  // 沉浸胶囊根布局动效管理器
  private immCapAnim?: WidgetAnimStateV2;
  // 沉浸胶囊根布局样式管理器
  private immCapStyle?: WidgetStyleStateV2;

  // 沉浸大卡根布局动效管理器
  private immCardAnim?: WidgetAnimStateV2;
  // 沉浸大卡根布局样式管理器
  private immCardStyle?: WidgetStyleStateV2;

  private constructor(stMgrName: SlStateMgr = SlStateMgr.MGR_COMMON) {
    this.stMgrName = stMgrName;
  }

  /**
   * 辅助工具实例获取
   *
   * @param mgrName 管理器名称
   * @returns 辅助工具实例
   */
  public static getInstance(mgrName: SlStateMgr = SlStateMgr.MGR_COMMON): SlV2StateHelper {
    let helper = SlV2StateHelper.instance.get(mgrName);
    if (!helper) {
      helper = new SlV2StateHelper(mgrName);
      SlV2StateHelper.instance.set(mgrName, helper);
    }
    return helper;
  }

  /**
   * 取动效状态
   *
   * @param id 标识
   * @returns 动效
   */
  public getAnimSt(id: SlStateId): WidgetAnimStateV2 | undefined {
    return this.getStMgr()?.getState(StateType.ANIM, id) as WidgetAnimStateV2;
  }

  /**
   * 取样式状态
   *
   * @param id 标识
   * @returns 样式
   */
  public getStyleSt(id: SlStateId): WidgetStyleStateV2 | undefined {
    return this.getStMgr()?.getState(StateType.STYLE, id) as WidgetStyleStateV2;
  }

  /**
   * 取静态状态管理器
   *
   * @param id 标识
   * @returns 静态状态
   */
  public getStaticSt(id: SlStateId): IBaseState | undefined {
    return this.getStMgr()?.getState(StateType.STATIC, id);
  }

  /**
   * 沉浸列表动效
   *
   * @returns 动效
   */
  public getImmListAnim(): WidgetAnimStateV2 | undefined {
    if (!this.immListAnim) {
      this.immListAnim = this.getAnimSt(SlStateId.SL_LIST_STATE);
    }
    return this.immListAnim;
  }

  /**
   * 沉浸列表样式
   *
   * @returns 样式
   */
  public getImmListStyle(): WidgetStyleStateV2 | undefined {
    if (!this.immListStyle) {
      this.immListStyle = this.getStyleSt(SlStateId.SL_LIST_STATE);
    }
    return this.immListStyle;
  }

  /**
   * 沉浸胶囊动效
   *
   * @returns 动效
   */
  public getImmCapAnim(): WidgetAnimStateV2 | undefined {
    if (!this.immCapAnim) {
      this.immCapAnim = this.getAnimSt(SlStateId.SL_CAP_STATE);
    }
    return this.immCapAnim;
  }

  /**
   * 沉浸胶囊样式
   *
   * @returns 样式
   */
  public getImmCapStyle(): WidgetStyleStateV2 | undefined {
    if (!this.immCapStyle) {
      this.immCapStyle = this.getStyleSt(SlStateId.SL_CAP_STATE);
    }
    return this.immCapStyle;
  }

  /**
   * 沉浸胶囊静态状态
   *
   * @returns 静态状态
   */
  public getImmCapStatic(): IBaseState | undefined {
    return this.getStaticSt(SlStateId.SL_CAP_STATE);
  }

  /**
   * 沉浸大卡动效
   *
   * @returns 动效
   */
  public getImmCardAnim(): WidgetAnimStateV2 | undefined {
    if (!this.immCardAnim) {
      this.immCardAnim = this.getAnimSt(SlStateId.SL_CARD_STATE);
    }
    return this.immCardAnim;
  }

  /**
   * 沉浸大卡样式
   *
   * @returns 样式
   */
  public getImmCardStyle(): WidgetStyleStateV2 | undefined {
    if (!this.immCardStyle) {
      this.immCardStyle = this.getStyleSt(SlStateId.SL_CARD_STATE);
    }
    return this.immCardStyle;
  }

  private getStMgr(): SlStateBaseMgr | undefined {
    // 通用状态管理器
    if (!this.stateMgr) {
      this.stateMgr = SlStateBaseMgr.getMgr(this.stMgrName);
    }
    return this.stateMgr;
  }
}