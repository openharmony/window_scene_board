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

import { curves } from '@kit.ArkUI';
import { WDefault } from '@ohos/screenlockcommon';
import {
  AnimEvent,
  ComponentPosition,
  WidgetAnimStateV2,
  WidgetStyleStateV2
} from '@ohos/screenlockcommon/Index';
import {
  ImmListConst,
  ListAnimScene,
  ListAnimSuffix,
  ListCacheSuffix,
  ListStyleSuffix
} from '../../../common/constants/ImmListConst';
import { IImmersiveExtendVm } from '../../../common/interface/IImmersiveExtendVm';
import { IImmersiveListAnimVm } from '../../../common/interface/IImmersiveListAnimVm';
import { IImmersiveListVm } from '../../../common/interface/IImmersiveListVm';
import { IImmItemAnimStHelper } from '../../../common/interface/IImmItemAnimStHelper';
import { IImmItemCacheStHelper } from '../../../common/interface/IImmItemCacheStHelper';
import { IImmItemStyleStHelper } from '../../../common/interface/IImmItemStyleStHelper';
import { SlListBindStateV2 } from '../../../model/data/v2/SlListBindStateV2';
import { SlListStaticStateV2 } from '../../../model/data/v2/SlListStaticStateV2';
import { ImmAnimBaseMgrV2 } from './ImmAnimBaseManagerV2';

const MIN = WDefault.MIN_VALUE;

/**
 * 沉浸列表模块动效管理业务
 */
export class ImmListAnimMgrV2 extends ImmAnimBaseMgrV2 implements IImmersiveListAnimVm {
  /**
   * 根布局动效
   *
   * @returns 动效
   */
  public getRootAnimSt(): WidgetAnimStateV2 {
    return this.getSlAnim() as WidgetAnimStateV2;
  }

  /**
   * 条目通用动效
   *
   * @param groupKey 条目标识
   * @returns 动效
   */
  public getItemComAnimSt(groupKey: string): WidgetAnimStateV2 | undefined {
    return this.getItemComAnimH()?.getItemSt(groupKey);
  }

  /**
   * 条目阴影组件动效
   *
   * @param groupKey 条目标识
   * @returns 动效
   */
  public getItemShadowAnimSt(groupKey: string): WidgetAnimStateV2 | undefined {
    return this.getItemShadowAnimH()?.getItemSt(groupKey);
  }

  /**
   * 条目翻转动效
   *
   * @param groupKey 条目标识
   * @returns 动效
   */
  public getItemFoldAnimSt(groupKey: string): WidgetAnimStateV2 | undefined {
    return this.getItemFoldAnimH()?.getItemSt(groupKey);
  }

  /**
   * 条目inner动效
   *
   * @param groupKey 条目标识
   * @returns 动效
   */
  public getItemInnerAnimSt(groupKey: string): WidgetAnimStateV2 | undefined {
    return this.getItemInnerAnimH()?.getItemSt(groupKey);
  }

  /**
   * 条目背景动效
   *
   * @param groupKey 条目标识
   * @returns 动效
   */
  public getItemBgAnimSt(groupKey: string): WidgetAnimStateV2 | undefined {
    return this.getItemBgAnimH()?.getItemSt(groupKey);
  }

  /**
   * 列表根布局样式
   *
   * @returns 根布局样式
   */
  public getRootStyle(): WidgetStyleStateV2 | undefined {
    return this.getSlStyle()
  }

  /**
   * 条目通用样式
   *
   * @param groupKey 条目标识
   * @returns 样式
   */
  public getItemComStyle(groupKey: string): WidgetStyleStateV2 | undefined {
    return this.getItemComStyleH()?.getItemSt(groupKey);
  }

  /**
   * 列表根布局位置
   *
   * @returns 根布局位置
   */
  public getRootPos(): ComponentPosition | undefined {
    return this.getSlCache()?.getWidgetPosition();
  }

  /**
   * 列表条目位置
   *
   * @param groupKey 条目唯一标识
   * @returns 条目位置
   */
  public getItemPos(groupKey: string): ComponentPosition | undefined {
    return this.getItemComCacheH()?.getItemSt(groupKey)?.getWidgetPosition();
  }

  /**
   * 列表数据总长度
   *
   * @returns 数据大小
   */
  public getListDataSize(): number {
    return this.getSlStatic()?.getListData()?.length ?? 0;
  }

  /**
   * 获取沉浸列表条目间距
   *
   * @returns 条目间距
   */
  public getListItemSpace(): number {
    return this.getSlStatic()?.getItemSpace() ?? 0;
  }

  /**
   * 列表可见条目起始索引
   *
   * @returns 起始索引
   */
  public getItemStartIndex(): number {
    return this.getSlStatic()?.getStartIndex() ?? ImmListConst.INVALID_INDEX;
  }

  /**
   * 列表可见条目结束索引
   *
   * @returns 结束索引
   */
  public getItemEndIndex(): number {
    return this.getSlStatic()?.getEndIndex() ?? ImmListConst.INVALID_INDEX;
  }

  /**
   * 目标索引条目的标识
   *
   * @param itemIndex 目标索引
   * @returns 条目标识
   */
  public getItemGroupKey(itemIndex: number): string | undefined {
    return this.getSlStatic()?.getListData()?.[itemIndex]?.groupKey;
  }

  /**
   * 通知列表对齐方式变化动效
   *
   * @param isReachMax 是否最大栅格
   * @param endValue 动效终点值
   */
  public startListAlignAnim(isReachMax: boolean, endValue: AnimEvent): void {
    let delay = isReachMax ? (this.getClockAnim()?.getClockAnimDelay() ?? MIN) : MIN;
    let animParam: AnimateParam = { delay: delay, curve: curves.interpolatingSpring(0, 1, 228, 24.5) };
    this.getAnimExeMgr()?.animateTo({ mainScene: ListAnimScene.ANIM_LIST_ALIGN_CHANGE,
      oriParam: animParam, oriEvent: endValue });
  }

  /**
   * 启动列表数据刷新动效
   *
   * @param endValue 动效终值
   */
  public startListDataAnim(endValue: AnimEvent): void {
    let scene = ListAnimScene.ANIM_LIST_DATA_CHANGE;
    let animParam: AnimateParam = { duration: 350, curve: Curve.Friction,
      onFinish: () => this.getSlStatic()?.setItemFoldAnim({ scene: scene }) };
    // 堆叠效果跟随动效过渡
    this.getSlStatic()?.setItemFoldAnim({ scene: scene, animParam: animParam });
    this.getAnimExeMgr()?.animateTo({ mainScene: scene,
      oriParam: animParam, oriEvent: endValue });
  }

  /**
   * 列表静态状态
   *
   * @returns 静态状态
   */
  protected getSlStatic(): SlListStaticStateV2 {
    return super.getSlStatic() as SlListStaticStateV2;
  }

  /**
   * 列表UI绑定状态
   *
   * @returns UI绑定状态
   */
  protected getSlBind(): SlListBindStateV2 {
    return super.getSlBind() as SlListBindStateV2;
  }

  /**
   * 扩展业务管理器
   *
   * @returns 扩展业务
   */
  protected getExtendVm(): IImmersiveExtendVm | undefined {
    return this.getListVm();
  }

  private getListVm(): IImmersiveListVm | undefined {
    return this.getVmInjector()?.getImmersiveListVm();
  }

  private getItemComAnimH(): IImmItemAnimStHelper | undefined {
    return this.getVmInjector()?.getImmItemHelperVm().getListAnimH(ListAnimSuffix.ITEM_COMMON_ANIM);
  }

  private getItemShadowAnimH(): IImmItemAnimStHelper | undefined {
    return this.getVmInjector()?.getImmItemHelperVm().getListAnimH(ListAnimSuffix.ITEM_SHADOW_ANIM);
  }

  private getItemFoldAnimH(): IImmItemAnimStHelper | undefined {
    return this.getVmInjector()?.getImmItemHelperVm().getListAnimH(ListAnimSuffix.ITEM_FOLD_ANIM);
  }

  private getItemInnerAnimH(): IImmItemAnimStHelper | undefined {
    return this.getVmInjector()?.getImmItemHelperVm().getListAnimH(ListAnimSuffix.ITEM_INNER_ANIM);
  }

  private getItemBgAnimH(): IImmItemAnimStHelper | undefined {
    return this.getVmInjector()?.getImmItemHelperVm().getListAnimH(ListAnimSuffix.ITEM_BG_ANIM);
  }

  private getItemComStyleH(): IImmItemStyleStHelper | undefined {
    return this.getVmInjector()?.getImmItemHelperVm().getListStyleH(ListStyleSuffix.ITEM_COMMON_STYLE);
  }

  private getItemComCacheH(): IImmItemCacheStHelper | undefined {
    return this.getVmInjector()?.getImmItemHelperVm().getListCacheH(ListCacheSuffix.ITEM_COMMON_CACHE);
  }
}