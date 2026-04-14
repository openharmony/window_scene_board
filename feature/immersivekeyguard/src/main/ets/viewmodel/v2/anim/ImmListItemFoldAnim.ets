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

import { WBaseProperty, WDefault } from '@ohos/screenlockcommon';
import { BaseState } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { AnimEvent, AnimMgr, CmpPosWrapper, WidgetAnimStateV2, WidgetCacheState } from '@ohos/screenlockcommon/Index';
import { NotificationArray } from '@ohos/systemuicommon/newTsIndex';
import { ListAnimScene, ListAnimSuffix, ListCacheSuffix } from '../../../common/constants/ImmListConst';
import { IImmComVm } from '../../../common/interface/IImmComVm';
import { IImmersiveNtfVmInjector } from '../../../common/interface/IImmersiveNtfVmInjector';
import { IImmItemAnimStHelper } from '../../../common/interface/IImmItemAnimStHelper';
import { IImmItemCacheStHelper } from '../../../common/interface/IImmItemCacheStHelper';
import { SlListStaticStateV2 } from '../../../model/data/v2/SlListStaticStateV2';

// 堆叠效果参数集
const FOLD_ANIM_PT: WBaseProperty[] = [
  WBaseProperty.SCALE_X,
  WBaseProperty.SCALE_Y,
  WBaseProperty.SCALE_CENTER_Y,
  WBaseProperty.TRAN_Y,
  WBaseProperty.CLIP_H,
  WBaseProperty.CLIP_OFFSET_Y,
  WBaseProperty.Z_INDEX,
  WBaseProperty.ENABLE,
];

const MIN = WDefault.MIN_VALUE;
const MAX = WDefault.MAX_VALUE;
// 可见条目最小透明度
const FOLD_ALPHA_MIN = 0.5;
// 条目最小缩放值
const FOLD_SCALE_MIN = 0.9;
// 条目透明度误差阈值，允许触摸
const FOLD_ALPHA_RATE = 0.05;
// 数值相等误差阈值
const FOLD_EQUALS_RATE = 0.005;
// 列表最大高度误差
const LIST_HEIGHT_RATE = 0.5;
// 条目较低层级
const ITEM_Z_INDEX_LOW = -1;
// 条目最低层级
const ITEM_Z_INDEX_MIN = -2;
// 不可见条目最小裁剪高度
const CLIP_MIN_HEIGHT = 50;
// 条目最大允许显示高度
const ITEM_MAX_HEIGHT = 144;

// 堆叠位置参数
interface FoldRect {
  listTop: number;
  listBottom: number;
  itemTop: number;
  itemBottom: number;
  itemHeight: number;
  itemSpace: number;
  startIndex: number;
  endIndex: number;
}

// 异常位置参数
const INVALID_RECT: FoldRect = {
  listTop: 0,
  listBottom: 0,
  itemTop: -1,
  itemBottom: 0,
  itemHeight: 0,
  itemSpace: 0,
  startIndex: -1,
  endIndex: -1,
};

// 默认位置参数
const DEFAULT_RECT: FoldRect = {
  listTop: 0,
  listBottom: 0,
  itemTop: 0,
  itemBottom: 0,
  itemHeight: 0,
  itemSpace: 0,
  startIndex: 0,
  endIndex: 0,
};

/**
 * 沉浸列表条目堆叠动效
 */
export class ImmListItemFoldAnim {
  // 临时堆叠参数
  private readonly itemFoldParam: WidgetAnimStateV2 = BaseState.wrap(WidgetAnimStateV2, 'temp');

  // 记录上一次堆叠参数
  private readonly preFoldParam: WidgetAnimStateV2 = BaseState.wrap(WidgetAnimStateV2, 'pre');

  // 业务注入器
  private readonly vmInjector: IImmersiveNtfVmInjector;

  // 动效执行器
  private animExeMgr?: AnimMgr;

  // 列表模块静态状态
  private listStaticSt?: SlListStaticStateV2;

  // 列表模块数据集
  private listData?: NotificationArray;

  // 列表模块缓存状态
  private listCacheSt?: WidgetCacheState;

  // 条目堆叠动效
  private itemFoldSt?: WidgetAnimStateV2;

  // 通知分组标识
  private groupKey?: string;

  // 条目索引
  private itemIndex: number = -1;

  // 透明度延时ID
  private alphaDelayId?: number;

  // 条目上次计算堆叠的位置
  private preItemRect: FoldRect = INVALID_RECT;

  // 即将滑动距离
  private willOffset: number = MIN;

  constructor(vmInjector: IImmersiveNtfVmInjector) {
    this.vmInjector = vmInjector;
    // 标识初次，触发检测通过
    this.preFoldParam.setClipHeight(-1);
  }

  /**
   * 条目位置切换回调
   *
   * @param groupKey 条目数据分组标识
   * @param index 条目索引
   * @param willOffset 即将滑动距离
   */
  public onItemAreaChange(groupKey: string, index: number, willOffset: number = MIN): void {
    // 记录即将滑动间距
    this.willOffset = willOffset;
    if (this.groupKey !== groupKey) {
      this.groupKey = groupKey;
      this.itemFoldSt = this.getItemFoldHelper()?.getItemSt(groupKey);
    }
    this.itemIndex = index;
    this.updateItemFoldState();
  }

  /**
   * 列表根布局高度变化
   */
  public onListRootSizeChange(): void {
    this.willOffset = MIN;
    this.updateItemFoldState();
  }

  private updateItemFoldState(): void {
    // 参数异常
    let listHeight = this.getListCacheSt()?.getWidgetPosition()?.height ?? MIN;
    if (listHeight === MIN || !Boolean(this.groupKey) || this.itemIndex === -1) {
      return;
    }
    let staticSt = this.getListStaticSt();
    // 列表高度未达到最大高度，条目无堆叠效果；完全可见的条目无堆叠效果
    let maxHeight = staticSt?.getListMaxHeight() ?? MIN;
    if (listHeight < maxHeight - LIST_HEIGHT_RATE) {
      this.clearFoldParamPt();
      this.setFoldParam();
      this.preItemRect = INVALID_RECT;
      return;
    }
    let curRect = this.getSafeFoldRect(this.itemIndex);
    // 此次位置和上一次位置无变化，无需重复计算
    if (this.valueEquals(this.preItemRect.itemTop, curRect.itemTop) &&
      this.valueEquals(this.preItemRect.itemHeight, curRect.itemHeight) &&
      this.valueEquals(this.preItemRect.listBottom, curRect.listBottom)) {
      return;
    }
    // 记录此次位置
    this.preItemRect = curRect;
    if (this.checkFullShow(curRect)) {
      return;
    }
    if (this.checkFullHide(curRect)) {
      return;
    }
    // 优先判断两头超出场景
    if (this.checkTopBottomHalfShow(curRect)) {
      return;
    }
    if (this.checkTopHalfShow(curRect)) {
      return;
    }
    this.checkBottomHalfShow(curRect);
  }

  private checkFullHide(curRect: FoldRect): boolean {
    // 条目完全超出
    if (curRect.itemHeight === MIN) {
      this.itemFoldParam.setScaleX(FOLD_SCALE_MIN).setScaleY(FOLD_SCALE_MIN).setScaleCenterY()
        .setClipOffsetY(MIN).setClipHeight(CLIP_MIN_HEIGHT).setZIndex(ITEM_Z_INDEX_MIN).setEnable(false).setAlpha(MIN);
      // 顶部完全超出
      if (this.itemIndex < curRect.startIndex) {
        this.itemFoldParam.setTranY(ITEM_MAX_HEIGHT);
      } else {
        // 底部完全超出
        this.itemFoldParam.setTranY(-ITEM_MAX_HEIGHT);
      }
      this.setFoldParam();
      return true;
    }
    // 条目完全超出顶部、完全超出底部，则保持最小裁切高度、位移列表边缘、最小缩放、隐藏
    if (curRect.itemBottom <= curRect.listTop - curRect.itemSpace) {
      // 当条目高度超出最大限制时，按最大限制计算位置
      let realTop = Math.max(curRect.itemTop, curRect.itemBottom - ITEM_MAX_HEIGHT);
      // 裁切时，偏移量仅去掉超出最大限制的部分
      let offsetY = Math.max(MIN, realTop - curRect.itemTop);
      // 缩放中心以条目最大高度中心为准
      let scaleCenterY = (realTop + (curRect.itemBottom - realTop) / 2) - curRect.itemTop;
      this.itemFoldParam.setScaleX(FOLD_SCALE_MIN).setScaleY(FOLD_SCALE_MIN).setScaleCenterY(scaleCenterY)
        .setTranY(curRect.listTop - realTop).setClipOffsetY(offsetY).setClipHeight(CLIP_MIN_HEIGHT)
        .setZIndex(ITEM_Z_INDEX_MIN).setEnable(false).setAlpha(MIN);
      this.setFoldParam();
      return true;
    }
    if (curRect.itemTop >= curRect.listBottom + curRect.itemSpace) {
      // 当条目高度超出最大限制时，按最大限制计算位置
      let realBottom = Math.min(curRect.itemBottom, curRect.itemTop + ITEM_MAX_HEIGHT);
      // 裁切时，偏移量按实际裁切高度计算
      let offsetY = Math.max(MIN, realBottom - curRect.itemTop - CLIP_MIN_HEIGHT);
      // 缩放中心以条目最大高度中心为准
      let scaleCenterY = (realBottom - curRect.itemTop) / 2;
      this.itemFoldParam.setScaleX(FOLD_SCALE_MIN).setScaleY(FOLD_SCALE_MIN).setScaleCenterY(scaleCenterY)
        .setTranY(curRect.listBottom - realBottom).setClipOffsetY(offsetY).setClipHeight(CLIP_MIN_HEIGHT)
        .setZIndex(ITEM_Z_INDEX_MIN).setEnable(false).setAlpha(MIN);
      this.setFoldParam();
      return true;
    }
    return false;
  }

  private checkFullShow(curRect: FoldRect): boolean {
    // 条目未超出列表顶部、底部，条目无堆叠效果
    if (!(curRect.itemTop >= curRect.listTop && curRect.itemBottom <= curRect.listBottom)) {
      return false;
    }
    this.clearFoldParamPt();
    // 切割高度保持有值
    this.itemFoldParam.setClipHeight(curRect.itemHeight);
    this.setFoldParam();
    // 同步检验上一个、下一个条目是否重叠
    let preIndex = this.itemIndex - MAX;
    let preRect = this.getSafeFoldRect(preIndex);
    if (preRect.itemTop < preRect.listTop && preRect.itemHeight > MIN) {
      // 重新计算上一个条目的切割高度
      let preGroupKey = this.getListData()?.[preIndex]?.groupKey;
      let preFoldSt = this.getItemFoldHelper()?.getItemSt(preGroupKey);
      let tranY = preFoldSt?.getTranY() ?? MIN;
      let offsetY = preFoldSt?.getClipOffsetY() ?? MIN;
      let preTranBottom = preRect.itemBottom + tranY;
      let preTranTop = preRect.itemTop + tranY + offsetY;
      let clipHeight = Math.min(preTranBottom, curRect.itemBottom) - preTranTop;
      preFoldSt?.setClipHeight(clipHeight);
      return true;
    }
    let nextIndex = this.itemIndex + MAX;
    let nextRect = this.getSafeFoldRect(nextIndex);
    if (nextRect.itemBottom > nextRect.listBottom && nextRect.itemHeight > MIN) {
      // 重新计算下一个条目的切割高度
      let nextGroupKey = this.getListData()?.[nextIndex]?.groupKey;
      let nextFoldSt = this.getItemFoldHelper()?.getItemSt(nextGroupKey);
      let realBottom = Math.min(nextRect.itemBottom, nextRect.itemTop + ITEM_MAX_HEIGHT);
      let tranY = nextFoldSt?.getTranY() ?? MIN;
      let nextTranTop = nextRect.itemTop + tranY;
      let realTranBottom = realBottom + tranY;
      let clipHeight = Math.max(realTranBottom, curRect.listBottom) - Math.max(nextTranTop, curRect.itemTop);
      nextFoldSt?.setClipHeight(clipHeight);
    }
    return true;
  }

  private checkTopHalfShow(curRect: FoldRect): boolean {
    // 条目顶部显示一半，条目堆叠计算
    if (!(curRect.itemTop < curRect.listTop && curRect.itemBottom > curRect.listTop - curRect.itemSpace)) {
      return false;
    }
    // 当条目高度超出最大限制时，按最大限制计算位置
    let realTop = Math.max(curRect.itemTop, curRect.itemBottom - ITEM_MAX_HEIGHT);
    // 裁切时，偏移量仅去掉超出最大限制的部分
    let offsetY = Math.max(MIN, Math.min(realTop - curRect.itemTop, curRect.listTop - curRect.itemTop));
    // 缩放中心以条目最大高度中心为准
    let scaleCenterY = (realTop + (curRect.itemBottom - realTop) / 2) - curRect.itemTop;
    // 位移回条目顶部
    let tranY = Math.max(MIN, curRect.listTop - realTop);
    // 裁切高度根据下一个条目位置覆盖重叠区域进行计算
    let nextRect = this.getSafeFoldRect(this.itemIndex + MAX);
    let curTranBottom = curRect.itemBottom + tranY;
    let curTranTop = curRect.itemTop + tranY + offsetY;
    // 异常条目处理
    let nextBottom = nextRect.itemHeight === 0 ? curTranBottom : nextRect.itemBottom;
    let clipHeight = Math.min(curTranBottom, nextBottom) - curTranTop;
    // 计算进度，缩放、透明度渐变
    let tranHeight = curRect.itemBottom - realTop;
    let progress = tranHeight === MIN ? MAX : tranY / tranHeight;
    let alpha = MAX + (FOLD_ALPHA_MIN - MAX) * progress;
    let scale = MAX + (FOLD_SCALE_MIN - MAX) * progress;
    // 误差内均允许touch触摸
    let isEnable = MAX - alpha < FOLD_ALPHA_RATE;
    let zIndex = tranY === MIN ? undefined : ITEM_Z_INDEX_LOW;
    this.itemFoldParam.setScaleX(scale).setScaleY(scale).setScaleCenterY(scaleCenterY)
      .setTranY(tranY).setClipOffsetY(offsetY).setClipHeight(clipHeight)
      .setZIndex(zIndex).setEnable(isEnable).setAlpha(alpha);
    this.setFoldParam();
    return true;
  }

  private checkBottomHalfShow(curRect: FoldRect): boolean {
    // 条目底部显示一半，条目堆叠计算
    if (!(curRect.itemTop < curRect.listBottom + curRect.itemSpace && curRect.itemBottom > curRect.listBottom)) {
      return false;
    }
    // 当条目高度超出最大限制时，按最大限制计算位置
    let realBottom = Math.min(curRect.itemBottom, curRect.itemTop + ITEM_MAX_HEIGHT);
    // 缩放中心以条目最大高度中心为准
    let scaleCenterY = (realBottom - curRect.itemTop) / 2;
    // 位移回条目底部
    let tranY = Math.min(MIN, curRect.listBottom - realBottom);
    // 裁切高度根据上一个条目位置覆盖重叠区域进行计算
    let preRect = this.getSafeFoldRect(this.itemIndex - MAX);
    let curTranTop = curRect.itemTop + tranY;
    let realTranBottom = realBottom + tranY;
    // 异常条目处理
    let preTop = preRect.itemHeight === 0 ? curTranTop : preRect.itemTop;
    let clipHeight = Math.max(realTranBottom, curRect.listBottom) - Math.max(curTranTop, preTop);
    // 裁切时，偏移量按实际裁切高度计算
    let offsetY = Math.max(MIN, realBottom - curRect.itemTop - clipHeight);
    // 计算进度，缩放、透明度渐变
    let tranHeight = realBottom - curRect.itemTop;
    let progress = tranHeight === MIN ? MAX : Math.abs(tranY) / tranHeight;
    let alpha = MAX + (FOLD_ALPHA_MIN - MAX) * progress;
    let scale = MAX + (FOLD_SCALE_MIN - MAX) * progress;
    // 误差内均允许touch触摸
    let isEnable = MAX - alpha < FOLD_ALPHA_RATE;
    let zIndex = tranY === MIN ? undefined : ITEM_Z_INDEX_LOW;
    this.itemFoldParam.setScaleX(scale).setScaleY(scale).setScaleCenterY(scaleCenterY)
      .setTranY(tranY).setClipOffsetY(offsetY).setClipHeight(clipHeight)
      .setZIndex(zIndex).setEnable(isEnable).setAlpha(alpha);
    this.setFoldParam();
    return true;
  }

  private checkTopBottomHalfShow(curRect: FoldRect): boolean {
    // 最后剩余场景，条目同时跨域顶部和底部，条目保持正常可见，裁切顶部、底部超出部分即可
    if (!(curRect.itemTop < curRect.listTop && curRect.itemBottom > curRect.listBottom)) {
      return false;
    }
    let offsetY = curRect.listTop - curRect.itemTop;
    let clipHeight = curRect.listBottom - curRect.listTop;
    let scaleCenterY = offsetY + (clipHeight / 2);
    this.itemFoldParam.setScaleX().setScaleY().setScaleCenterY(scaleCenterY)
      .setTranY().setClipOffsetY(offsetY).setClipHeight(clipHeight)
      .setZIndex().setEnable(true).setAlpha();
    this.setFoldParam();
    return true;
  }

  private setFoldParam(): void {
    // 组件由不可见变可见时存在跳闪，透明度需延时刷新，动效场景强制跟随动效
    let preAlpha = this.itemFoldSt?.getAlpha() ?? WDefault.MAX_VALUE;
    let curAlpha = this.itemFoldParam.getAlpha() ?? WDefault.MAX_VALUE;
    let isAlphaDelay = preAlpha === MIN && curAlpha !== MIN;
    // 提前检测裁切高度有效性
    this.checkClipHeight();
    // 无参数变化，无需重复刷新
    if (!this.checkRecordFoldChange()) {
      return;
    }
    // AOD下不允许动效
    let animParam = this.getListStaticSt()?.getItemFoldAnim();
    let hasAnim: boolean = Boolean(animParam) && !this.getImmComVm()?.isAod();
    this.clearAlphaDelay();
    // 堆叠参数刷新事件
    let event: AnimEvent = () => {
      FOLD_ANIM_PT.forEach((pt) => this.itemFoldSt?.setStateValue(pt, this.itemFoldParam.getStateValue(pt)));
      if (hasAnim || !isAlphaDelay) {
        this.itemFoldSt?.setAlpha(this.itemFoldParam.getAlpha());
      } else {
        this.alphaDelayId = setTimeout(() => {
          this.clearAlphaDelay();
          this.itemFoldSt?.setAlpha(this.itemFoldParam.getAlpha());
        });
      }
    };
    // 存在动效，则动效过渡
    if (hasAnim) {
      this.getAnimMgr()?.animateToImmediately({
        mainScene: this.getFoldAnimScene(), oriParam: animParam!, oriEvent: event
      });
    } else {
      event();
    }
  }

  private getFoldAnimScene(): string {
    return `${ListAnimScene.ANIM_LIST_ITEM_FOLD}_${this.groupKey}`;
  }

  private checkClipHeight(): void {
    // 当clipHeight为undefined时，优先使用条目缓存高度
    let clipHeight = this.itemFoldParam?.getClipHeight();
    if (clipHeight !== undefined) {
      return;
    }
    let cacheSt = this.getItemCacheHelper()?.getItemSt(this.groupKey);
    let itemHeight = cacheSt?.getWidgetPosition()?.height ?? MIN;
    if (itemHeight !== MIN) {
      this.itemFoldParam.setClipHeight(itemHeight);
    }
  }

  private clearFoldParamPt(): void {
    // 清空临时参数配置
    FOLD_ANIM_PT.forEach((pt) => this.itemFoldParam.clearProperty(pt));
    this.itemFoldParam.setAlpha();
  }

  private checkRecordFoldChange(): boolean {
    // 检测堆叠效果是否切换，记录最新堆叠参数
    let hasPtChange: boolean = false;
    FOLD_ANIM_PT.forEach((pt) => {
      let newValue = this.itemFoldParam.getStateValue(pt);
      let oldValue = this.preFoldParam.getStateValue(pt);
      if (newValue !== oldValue) {
        hasPtChange = true;
      }
      this.preFoldParam.setStateValue(pt, newValue);
    });
    let newAlpha = this.itemFoldParam.getAlpha();
    let oldAlpha = this.preFoldParam.getAlpha();
    this.preFoldParam.setAlpha(newAlpha);
    if (newAlpha !== oldAlpha) {
      hasPtChange = true;
    }
    return hasPtChange;
  }

  private clearAlphaDelay(): void {
    if (this.alphaDelayId) {
      clearTimeout(this.alphaDelayId);
      this.alphaDelayId = undefined;
    }
  }

  private getSafeFoldRect(index: number): FoldRect {
    let startIndex = this.getListStaticSt()?.getStartIndex() ?? MIN;
    let endIndex = this.getListStaticSt()?.getEndIndex() ?? MIN;
    // 列表顶部、底部均存在间距
    let listHeight = this.getListCacheSt()?.getWidgetPosition()?.height ?? MIN;
    let itemSpace = this.getListStaticSt()?.getItemSpace() ?? MIN;
    let listTop = itemSpace;
    let listBottom = listHeight - listTop;
    DEFAULT_RECT.listTop = listTop;
    DEFAULT_RECT.listBottom = listBottom;
    DEFAULT_RECT.itemSpace = itemSpace;
    DEFAULT_RECT.startIndex = startIndex;
    DEFAULT_RECT.endIndex = endIndex;
    // 缓存位置
    let groupKey = this.getListData()?.[index]?.groupKey;
    let itemCache = this.getItemCacheHelper()?.getItemSt(groupKey);
    let itemPos = CmpPosWrapper.wrapper(itemCache?.getWidgetPosition());
    // 可见区域内，直接获取相对位置
    if (index >= startIndex && index <= endIndex) {
      let result = this.getFoldRect(index);
      // 如果条目高度超出缓存高度，则采用缓存高度
      if (result.itemHeight - itemPos.getCmpHeight() > LIST_HEIGHT_RATE) {
        result.itemHeight = itemPos.getCmpHeight();
        result.itemBottom = result.itemTop + result.itemHeight;
      }
      return result;
    }
    // 条目区域有效性校验
    if (!itemPos.isPosValid()) {
      return DEFAULT_RECT;
    }
    // 超出顶部可见位置一个，借助startIndex推算
    if (index === startIndex - MAX) {
      let startRect = this.getFoldRect(startIndex);
      // 当前条目在start条目上方
      startRect.itemHeight = itemPos.getCmpHeight();
      startRect.itemBottom = startRect.itemTop - startRect.itemSpace;
      startRect.itemTop = startRect.itemBottom - startRect.itemHeight;
      return startRect;
    }
    // 超出底部可见位置一个，借助endIndex推算
    if (index === endIndex + MAX) {
      let endRect = this.getFoldRect(endIndex);
      // 当前条目在end条目下方
      endRect.itemHeight = itemPos.getCmpHeight();
      endRect.itemTop = endRect.itemBottom + endRect.itemSpace;
      endRect.itemBottom = endRect.itemTop + endRect.itemHeight;
      return endRect;
    }
    return DEFAULT_RECT;
  }

  private getFoldRect(index: number): FoldRect {
    try {
      let scroller = this.getListStaticSt()?.getListScroller();
      let itemRect = scroller?.getItemRect(index);
      // 存在即将滑动距离时，算上偏移
      let itemTop = (itemRect?.y ?? MIN) - this.willOffset;
      let itemHeight = itemRect?.height ?? MIN;
      let itemBottom = itemTop + itemHeight;
      return {
        listTop: DEFAULT_RECT.listTop,
        listBottom: DEFAULT_RECT.listBottom,
        itemTop: itemTop,
        itemBottom: itemBottom,
        itemHeight: itemHeight,
        itemSpace: DEFAULT_RECT.itemSpace,
        startIndex: DEFAULT_RECT.startIndex,
        endIndex: DEFAULT_RECT.endIndex,
      };
    } catch (e) {
      return DEFAULT_RECT;
    }
  }

  private valueEquals(tar: number, other: number): boolean {
    return Math.abs(tar - other) <= FOLD_EQUALS_RATE;
  }

  private getListStaticSt(): SlListStaticStateV2 | undefined {
    if (!this.listStaticSt) {
      this.listStaticSt = this.vmInjector?.getImmersiveListVm()?.getSlStaticState();
    }
    return this.listStaticSt;
  }

  private getListCacheSt(): WidgetCacheState | undefined {
    if (!this.listCacheSt) {
      this.listCacheSt = this.vmInjector?.getImmersiveListVm()?.getSlCacheState();
    }
    return this.listCacheSt;
  }

  private getListData(): NotificationArray | undefined {
    if (!this.listData) {
      this.listData = this.vmInjector?.getImmersiveListVm()?.getSlNtfList();
    }
    return this.listData;
  }

  private getImmComVm(): IImmComVm | undefined {
    return this.vmInjector?.getImmComVm();
  }

  private getItemFoldHelper(): IImmItemAnimStHelper | undefined {
    return this.vmInjector?.getImmItemHelperVm()?.getListAnimH(ListAnimSuffix.ITEM_FOLD_ANIM);
  }

  private getItemCacheHelper(): IImmItemCacheStHelper | undefined {
    return this.vmInjector?.getImmItemHelperVm()?.getListCacheH(ListCacheSuffix.ITEM_COMMON_CACHE);
  }

  private getAnimMgr(): AnimMgr | undefined {
    if (!this.animExeMgr) {
      this.animExeMgr = this.vmInjector?.getImmersiveWholeAnimVm()?.getAnimExeMgr();
    }
    return this.animExeMgr;
  }
}