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
import { ArrayUtils, CommonUtils } from '@ohos/basicutils';
import { AnimValue, BaseConstants } from '@ohos/systemuicommon';
import { ImmersiveAnimKey, ImmersiveAnimScene } from '../../common/anim/ImmersiveAnimConstants';
import { ImmersiveAnimInfo } from '../../model/data/anim/ImmersiveAnimInfo'
import { AnimStyleType, ImmersiveAnimStyle } from '../../model/data/anim/ImmersiveAnimStyle';
import { NotificationEntryArray } from '../viewdata/NotificationEntryArray';
import { NtfListBindState, NtfListStaticState } from '../viewdata/NtfListState';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { NotificationAnimationParas } from '@ohos/notificationcomponent/src/main/ets/common/NotificationAnimationParas';
import curves from '@ohos.curves';
import { BaseState } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { Runnable } from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/base/Runnable';
import { NotificationStateManager } from '@ohos/screenlockcommon';
import { interruptHelper } from '../../common/helper/ImmersiveInterruptHelper';
import { CmpPosWrapper, ComponentPosition, WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { NotificationConfig } from '@ohos/notificationcomponent/src/main/ets/common/NotificationConfig';
const TAG = 'ImmersiveListAnimManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const MIN = AnimValue.VALUE_MIN;
const MAX = AnimValue.VALUE_MAX;
const HALF = BaseConstants.DIVIDE;
const INVALID_SIZE = -1;
const ITEM_ALPHA_RATE = 0.05; // 条目触摸事件开启允许的误差
const ITEM_PARAS_SCALE_MIN = 0.9; // 条目滑动翻转时最小缩放值
const ITEM_PARAS_ALPHA_MIN = 0.5; // 条目滑动翻转时最小透明度值
const GROUP_ITEM_MIN_HEIGHT = 144; // 组通知展开后最小可见高度
const CLIP_MIN_HEIGHT = 5; // 不可见条目最小裁剪高度
const ITEM_Z_INDEX_MIN = -2; // 条目层级最低
const ITEM_Z_INDEX_LOW = -1; // 条目层级低
const ITEM_Z_INDEX_NORMAL = 0; // 条目层级正常
const ALIGN_DELAY = 80; // 对齐方式动效时延
const ITEM_MAX_HEIGHT = 500; // 列表item最大变化高度
const EMPTY_POSITION: ComponentPosition = { globalX: 0, globalY: 0, width: 0, height: 0 }; // 无数据时可见区域

export interface ListAnimParas { // 列表跟手滑动参数
  offset?: number; // 即将滑动偏移
  sizeChangeItem?: string; // 大小切换条目标识
  oldSize?: number; // 切换前大小
  newSize?: number; // 切换后大小
  isResolveWait?: boolean; // 是否释放动效等待
  isFromScroll?: boolean; // 是否滑动翻转
}

interface StartItemTop { // 第一个可见条目位置
  startIndex: number;
  startTop: number;
  isInvalid: boolean; // 无效数据
}

interface ItemAnimParas { // 条目跟手滑动参数
  listTop: number;
  listHeight: number;
  itemSpace: number;
  itemAnim?: NotificationAnimationParas;
  preItemParas?: ItemAnimParas;
  itemTop: number;
  itemHeight: number;
  itemHashcode?: string; // 条目标识
  isInvalid?: boolean; // 是否无效刷新
  followAnim?: AnimateParam; // 跟随动效
  isReverse?: boolean; // 反序场景

  // 动效生效参数
  alpha?: number;
  scale?: number;
  scaleCenterY?: number;
  tranY?: number;
  clipHeight?: number;
  clipOffsetY?: number;
  zIndex?: number;
  isEnable?: boolean;
}

/**
 * 沉浸锁屏列表动效管理
 */
export class ImmersiveListAnimManager {
  /**
   * 列表根布局动效映射
   */
  private rootAnimState: ImmersiveAnimInfo = new ImmersiveAnimInfo(ImmersiveAnimKey.IMMERSIVE_LIST_ROOT,
    new ImmersiveAnimStyle());

  /**
   * 沉浸锁屏列表数据
   */
  private immersiveListData?: NotificationEntryArray;

  /**
   * 沉浸列表静态状态
   */
  private listStaticState?: NtfListStaticState;

  /**
   * 沉浸列表动态绑定状态
   */
  private listBindState?: NtfListBindState;

  /**
   * 设置沉浸锁屏列表数据
   *
   * @param list 列表数据
   */
  setImmersiveListData(list: NotificationEntryArray): void {
    this.immersiveListData = list;
  }

  /**
   * 设置沉浸列表静态状态
   *
   * @param state 状态
   */
  setListStaticState(state: NtfListStaticState): void {
    this.listStaticState = state;
  }

  /**
   * 设置沉浸列表动态绑定状态
   *
   * @param state 状态
   */
  setListBindState(state: NtfListBindState): void {
    this.listBindState = state;
  }

  /**
   * 列表可见起始索引
   *
   * @returns 起始索引
   */
  getStartIndex(): number {
    return this.listStaticState?.startItemIndex ?? BaseConstants.INVALID_INDEX;
  }

  /**
   * 列表可见结束索引
   *
   * @returns 结束索引
   */
  getEndIndex(): number {
    return this.listStaticState?.endItemIndex ?? BaseConstants.INVALID_INDEX;
  }

  /**
   * 列表数据
   *
   * @returns 列表数据
   */
  getListData(): NotificationEntryArray | undefined {
    return this.immersiveListData;
  }

  /**
   * 列表数据长度
   *
   * @returns 列表数据长度
   */
  getListDataSize(): number {
    return this.immersiveListData?.length ?? 0;
  }

  /**
   * 条目唯一标示
   *
   * @param index 索引
   * @returns 唯一标示
   */
  getItemHashcode(index: number): string | undefined {
    return this.immersiveListData?.[index]?.getGroupKey();
  }

  /**
   * 获取根组件动效UI样式
   *
   * @returns UI样式
   */
  getRootAnimStyle(): ImmersiveAnimStyle {
    return this.rootAnimState.getComponentAnimStyle();
  }

  /**
   * 设置根组件动效UI样式对应值
   *
   * @param type 样式类型
   * @param value 值
   */
  setRootStyleValue(type: AnimStyleType, value?: number): void {
    this.getRootAnimStyle()?.bindStyle(type, value);
  }

  /**
   * 获取根组件动效状态
   *
   * @returns 动效状态
   */
  getRootAnimState(): WidgetAnimState {
    return this.rootAnimState.getWidgetAnimState();
  }

  /**
   * 获取子组件动效UI样式
   *
   * @param hashcode 标示
   * @returns UI样式
   */
  getChildAnimStyle(hashcode: string): ImmersiveAnimStyle {
    return this.getChildInfo(hashcode).getComponentAnimStyle();
  }

  /**
   * 设置子组件动效UI样式对应值
   *
   * @param hashcode 标示
   * @param styleType 样式类型
   * @param value 值
   */
  setChildStyleValue(hashcode: string, styleType: AnimStyleType, value?: number): void {
    this.getChildAnimStyle(hashcode)?.bindStyle(styleType, value);
  }

  /**
   * 获取子组件动效状态
   *
   * @param hashcode 标识
   * @returns 动效状态
   */
  getChildAnimState(hashcode: string): WidgetAnimState {
    return this.getChildInfo(hashcode).getWidgetAnimState();
  }

  /**
   * 移除子组件动效
   *
   * @param hashcode 标示
   */
  removeChildAnimState(hashcode: string): void {
    this.rootAnimState.removeChildAnimInfo(hashcode);
  }

  /**
   * 设置根组件显示位置
   *
   * @param area 显示位置
   */
  setRootViewArea(area?: Area | SizeOptions): void {
    this.rootAnimState.setComponentArea(area);
  }

  /**
   * 获取根组件显示位置
   *
   * @returns 显示位置
   */
  getRootViewPosition(): ComponentPosition {
    if (ArrayUtils.isEmpty(this.immersiveListData)) {
      return EMPTY_POSITION;
    }
    return this.rootAnimState.getComponentPosition();
  }

  /**
   * 设置子组件显示位置
   *
   * @param hashcode 标示
   * @param area 显示位置
   */
  setChildViewArea(hashcode: string, area?: Area | SizeOptions): void {
    this.getChildInfo(hashcode)?.setComponentArea(area);
  }

  /**
   * 获取子组件显示位置
   *
   * @param hashcode 标示
   * @returns 显示位置
   */
  getChildViewPosition(hashcode: string): ComponentPosition | undefined {
    return this.getChildInfo(hashcode)?.getComponentPosition();
  }

  /**
   * 设置列表根组件动效中状态
   *
   * @param isAnimating 是否动效中
   * @param animScene 动效场景
   */
  setRootAnimating(isAnimating: boolean, animScene?: ImmersiveAnimScene): void {
    // 标示列表是否动效中
    this.getRootAnimState().setAnimScene({ isAnimating: isAnimating, animScene: animScene });
  }

  /**
   * 设置列表子组件动效中状态
   *
   * @param isAnimating 是否动效中
   * @param animScene 动效场景
   * @param hashcode 参与动效的子组件集
   */
  setChildAnimating(isAnimating: boolean, animScene: ImmersiveAnimScene, ...hashcode: string[]): void {
    // 标示列表是否动效中
    hashcode?.forEach((hash) => {
      this.getChildAnimState(hash)?.setAnimScene({ isAnimating: isAnimating, animScene: animScene });
    });
  }

  /**
   * 临时关闭item模糊效果
   *
   * @param hashcode item标示
   * @param disableEffect 关闭模糊
   */
  updateDisableEffect(hashcode: string, disableEffect?: boolean): void {
    let animPara = this.listBindState?.getNtfAnimPara(hashcode);
    animPara?.updateDisableEffect(disableEffect);
  }

  updateLongClickAnim(isLongClick?: boolean): void { // 长按动效状态
    this.listStaticState?.updateLongClickAnim(isLongClick);
  }

  /**
   * 条目转换后的位置
   *
   * @param hashcode 标识
   * @returns 转换后位置
   */
  transformItemPosition(hashcode: string): CmpPosWrapper {
    let itemState = this.getChildAnimState(hashcode);
    let innerState = itemState?.getChildState(hashcode);
    let itemPos = CmpPosWrapper.wrapper(this.getChildViewPosition(hashcode));
    let halfHeight = itemPos.getCmpHeight() / HALF;
    let animPara = this.listBindState?.getNtfAnimPara(hashcode);
    let animTranY = animPara?.ntfItemTranslateY ?? MIN;
    let animScale = animPara?.clearAnimScale ?? MAX;
    let animScaleCenterY = animPara?.itemScaleCenterY ?? halfHeight;
    let animClipHeight = animPara?.ntfItemClipHeight ?? MIN;
    let animOffsetY = animPara?.ntfItemClipOffsetY ?? MIN;
    let innerOffsetY = -animOffsetY - animTranY; // 内部偏移来保证内容复位
    innerState?.setMarginT(innerOffsetY);
    let itemOffsetY = animOffsetY + animTranY; // 外部偏移来保证可见内容位置不变
    itemState?.setMarginT(itemOffsetY);
    let scaleOffsetY = (animScaleCenterY - animOffsetY) * (MAX - animScale); // 纵轴缩放后偏移
    let resultWidth = itemPos.getCmpWidth() * animScale;
    let resulHeight = animClipHeight * animScale;
    let tarPosition: ComponentPosition = {
      globalX: itemPos.getCmpGlobalX() + (itemPos.getCmpWidth() - resultWidth) / HALF,
      globalY: itemPos.getCmpGlobalY() + itemOffsetY + (animClipHeight - resulHeight) / HALF,
      width: resultWidth,
      height: resulHeight + scaleOffsetY
    };
    return CmpPosWrapper.wrapper(tarPosition);
  }

  /**
   * 条目缩放纵轴中心
   *
   * @param hashcode 标识
   * @returns 缩放中心
   */
  getItemScaleCenterY(hashcode: string): number | undefined {
    return this.listBindState?.getNtfAnimPara(hashcode)?.itemScaleCenterY;
  }

  /**
   * 通知列表对齐方式变化动效
   *
   * @param isReachMax 是否最大栅格
   * @param endValue 动效终点值
   */
  startListAlignAnim(isReachMax: boolean, endValue: Runnable): void {
    this.listStaticState?.setListHeightChange(true); // 记录列表高度变化
    let scene = ImmersiveAnimScene.SCENE_LIST_ALIGN_CHANGE;
    let delay = isReachMax && NotificationStateManager.notificationState.isClockAnimDelay ? ALIGN_DELAY : MIN;
    let animPara = this.getAnimCure(scene, { delay: delay });
    animateTo(animPara, () => endValue?.());
  }

  /**
   * 列表高度变化，标示条目翻转需动效过渡
   */
  onListHeightChange(): void {
    if (!this.listStaticState?.itemUpdateAnim) {
      this.listStaticState?.updateItemAnim(this.getAnimCure(ImmersiveAnimScene.SCENE_LIST_ALIGN_CHANGE));
    }
  }

  /**
   * 刷新列表滑动动效参数
   *
   * @param paras 场景入参
   */
  async updateListAnimParas(paras: ListAnimParas = {}): Promise<void> {
    let rootPara: ItemAnimParas = await this.checkAnimParas(paras);
    if (rootPara.isInvalid) {
      return;
    }
    // 以第一个可见条目为分界线
    let startItem = this.getStartItemTop();
    if (startItem.isInvalid) {
      return;
    }
    let offset = paras.offset ?? MIN;
    let itemTop = startItem.startTop - offset;
    if (startItem.startIndex > MIN) { // 分界线前，反向遍历
      for (let i = startItem.startIndex - MAX; i >= MIN; i--) {
        let itemPara: ItemAnimParas = { itemTop: itemTop, itemHeight: MIN, isReverse: true,
          itemSpace: rootPara.itemSpace, listTop: rootPara.listTop, listHeight: rootPara.listHeight };
        itemTop = this.pkgItemAnimParas(i, itemPara, rootPara) ?? itemTop;
      }
    }
    itemTop = startItem.startTop - offset;
    let preItem: ItemAnimParas | undefined = undefined; // 记录前一个item
    let listSize = ArrayUtils.getSize(this.immersiveListData);
    for (let i = startItem.startIndex; i < listSize; i++) { // 分界线后，正向遍历
      let itemPara: ItemAnimParas = { itemTop: itemTop, itemHeight: MIN, preItemParas: preItem,
        itemSpace: rootPara.itemSpace, listTop: rootPara.listTop, listHeight: rootPara.listHeight };
      itemTop = this.pkgItemAnimParas(i, itemPara, rootPara) ?? itemTop;
      preItem = itemPara; // 指针下移
    }
  }

  private pkgItemAnimParas(index: number, itemPara: ItemAnimParas, rootPara: ItemAnimParas): number | undefined {
    let itemHashcode = this.immersiveListData?.[index]?.getGroupKey();
    if (!itemHashcode) {
      return undefined;
    }
    let itemAnim = this.listBindState?.getNtfAnimPara(itemHashcode);
    let itemH = this.getItemHeight(itemHashcode);
    // 反序场景计算条目顶部后使用
    let itemTop = itemPara.isReverse ? itemPara.itemTop - rootPara.itemSpace - itemH : itemPara.itemTop;
    itemPara.itemAnim = itemAnim;
    itemPara.itemTop = itemTop;
    itemPara.itemHeight = itemH;
    if (rootPara.followAnim) { // 其他条目跟随裁切动效
      animateToImmediately(rootPara.followAnim, () => this.checkItemAnimParas(itemPara));
    } else {
      this.checkItemAnimParas(itemPara);
    }
    // 正序场景，使用后计算条目顶部
    if (!itemPara.isReverse) {
      itemTop += (itemH + rootPara.itemSpace);
    }
    return itemTop;
  }

  private async checkAnimParas(paras: ListAnimParas): Promise<ItemAnimParas> { // 检测动效参数有效性
    let itemSpace = this.listStaticState?.itemSpace ?? MIN;
    let rootPara: ItemAnimParas = { itemTop: MIN, itemHeight: MIN, itemSpace: itemSpace,
      listTop: itemSpace, listHeight: MIN }
    let rootPos = CmpPosWrapper.wrapper(this.getRootViewPosition());
    if (!rootPos.isPosValid() || !this.listStaticState) { // 初始化未完成
      rootPara.isInvalid = true;
      return rootPara;
    }
    let oldHeight = paras.oldSize ?? INVALID_SIZE;
    let newHeight = paras.newSize ?? INVALID_SIZE;
    if (oldHeight >= MIN && oldHeight === newHeight) { // 异常高度，高度无变化，无需刷新
      rootPara.isInvalid = true;
      return rootPara;
    }
    let followAnim = this.listStaticState.itemUpdateAnim; // 提前记录动效参数
    if (interruptHelper.ntfItemAnimIt.hasInterrupt()) { //通知列表堆叠动效打断器存在才需等待
      await interruptHelper.ntfItemAnimIt.awaitInterrupt(); // 整体动效等待
    }
    if (paras.isResolveWait) { // 释放动效等待
      this.listStaticState.itemChangeParas?.resolveClipAnimWait();
    }
    if (!paras.isFromScroll) { // 滑动场景无需等待
      await this.listStaticState.itemChangeParas?.startClipAnimWait(); // 动效等待
    }
    this.listStaticState.updateChangeItemParas(); // 重置size切换条目
    // 列表高度不固定时，条目高度切换场景及时补充列表高度
    let itemHeightChange = this.listBindState?.listHeight ? 0 : ITEM_MAX_HEIGHT;
    let rootHeight = CmpPosWrapper.wrapper(this.getRootViewPosition()).getCmpHeight(); // 最新高度
    rootPara.listHeight = rootHeight - itemSpace * HALF + itemHeightChange; // 排除顶部底部间距
    rootPara.itemHeight = newHeight; // 高度变化的条目
    rootPara.itemHashcode = paras.sizeChangeItem;
    if (followAnim) { // 优先使用列表整体动效
      rootPara.followAnim = followAnim;
      if (paras.isResolveWait) { // 释放动效时，同步重置动效参数
        this.listStaticState.updateItemAnim();
      }
    }
    return rootPara;
  }

  private getStartItemTop(): StartItemTop { // 可见条目相对父组件顶部位置
    let startIndex = this.listStaticState?.startItemIndex ?? MIN;
    if (startIndex === INVALID_SIZE) {
      return { startIndex: startIndex, startTop: MIN, isInvalid: true }
    }
    let itemRect = this.listStaticState?.getListItemRect(startIndex);
    let itemHeight = itemRect?.height ?? MIN;
    let itemSpace = this.listStaticState?.itemSpace ?? MIN;
    if (itemHeight !== MIN) { // 数据有效
      return { startIndex: startIndex, startTop: itemRect?.y ?? itemSpace, isInvalid: false };
    }
    // 数据无效，取下一个条目
    startIndex++;
    itemRect = this.listStaticState?.getListItemRect(startIndex);
    itemHeight = itemRect?.height ?? MIN;
    return { startIndex: startIndex, startTop: itemRect?.y ?? itemSpace, isInvalid: itemHeight <= MIN };
  }

  private getItemHeight(hashcode: string): number {
    let itemHeight = CmpPosWrapper.wrapper(this.getChildViewPosition(hashcode)).getCmpHeight();
    return itemHeight;
  }

  private checkItemAnimParas(paras: ItemAnimParas): void { // 单条目跟手滑动参数
    let listBottom = paras.listTop + paras.listHeight;
    let itemBottom = paras.itemTop + paras.itemHeight;
    let itemShowHeight = itemBottom - paras.listTop; // 相对顶部可见区域
    if (paras.itemTop >= paras.listTop && itemBottom <= listBottom) { // 完全可见的条目
      paras.clipHeight = paras.itemHeight;
      this.updateItemAnimParas(paras, paras.itemAnim);
      let preItem = paras.preItemParas;
      let preItemAnim = preItem?.itemAnim;
      if (preItem && preItemAnim && preItemAnim.ntfItemTranslateY > MIN) { // 前一个条目底部不允许超出当前条目底部
        let preTranTop = preItem.itemTop + preItemAnim.ntfItemTranslateY;
        let preTranBottom = preTranTop + preItem.itemHeight;
        let preShowHeight = preTranBottom - paras.listTop;
        let scaleCenterY = preItem.scaleCenterY ?? MIN;
        let scale = preItem.scale ?? MAX;
        // 前一条目过高，裁剪底部在缩放中心以上，则裁剪底部继续上移
        let preClipHeight = this.getClipHeightByScale(Math.min(preShowHeight, itemShowHeight), scaleCenterY, scale);
        preItemAnim.updateClipHeight(preClipHeight);
      }
      return;
    }
    let isOverTop = itemBottom + paras.itemSpace < paras.listTop;
    if (isOverTop || paras.itemTop - paras.itemSpace > listBottom) { // 完全不可见的条目
      paras.alpha = MIN;
      paras.clipHeight = CLIP_MIN_HEIGHT;
      paras.clipOffsetY = isOverTop ? paras.itemHeight - CLIP_MIN_HEIGHT : MIN;
      paras.zIndex = ITEM_Z_INDEX_MIN;
      paras.tranY = isOverTop ? paras.listTop - itemBottom : listBottom - paras.itemTop;
      this.updateItemAnimParas(paras, paras.itemAnim);
      return;
    }
    this.checkHalfShowItemAnimParas(paras); // 部分可见的条目
  }

  private checkHalfShowItemAnimParas(paras: ItemAnimParas): void { // 半条目显示检测
    let itemHeight = paras.itemHeight;
    let listBottom = paras.listTop + paras.listHeight;
    let itemBottom = paras.itemTop + itemHeight;
    let itemShowHeight = itemBottom - paras.listTop; // 相对顶部可见区域
    let tarShowHeight = paras.itemAnim?.isGroupExpanded ?
    Math.min(GROUP_ITEM_MIN_HEIGHT, itemHeight) : itemHeight; // 顶部/底部目标可见高度，组通知展开状态允许截断
    let isFullShow = itemShowHeight > tarShowHeight; // 可见区域充足，暂不开启位移，组通知展开场景
    let isTopHalfShow = paras.itemTop < paras.listTop && itemBottom < listBottom;
    if (isTopHalfShow) { // 顶部部分可见条目
      paras.clipHeight = isFullShow ? Math.min(itemShowHeight, paras.listHeight) : tarShowHeight; // 条目不允许超出列表高度
      paras.tranY = isFullShow ? MIN : tarShowHeight - itemShowHeight;
      paras.clipOffsetY = Math.max(paras.listTop - paras.itemTop - paras.tranY, MIN);
    } else { // 底部部分可见条目
      itemShowHeight = listBottom - Math.max(paras.itemTop, paras.listTop);
      isFullShow = itemShowHeight > tarShowHeight;
      paras.clipHeight = isFullShow ? Math.min(itemShowHeight, paras.listHeight) : tarShowHeight;
      paras.tranY = isFullShow ? MIN : listBottom - tarShowHeight - paras.itemTop;
      if (isFullShow) { // List顶部底部同时超出场景
        paras.clipOffsetY = Math.max(paras.listTop - paras.itemTop, MIN);
      }
    }
    if (!isFullShow) { // 部分可见时，计算缩放进度
      let progress = Math.abs(paras.tranY) / tarShowHeight;
      paras.alpha = MAX + (ITEM_PARAS_ALPHA_MIN - MAX) * progress;
      paras.scale = MAX + (ITEM_PARAS_SCALE_MIN - MAX) * progress;
      let halfHeight = tarShowHeight / HALF;
      paras.scaleCenterY = isTopHalfShow ? (itemHeight - halfHeight) : halfHeight;
      paras.isEnable = MAX - paras.alpha < ITEM_ALPHA_RATE; // 误差内均允许touch触摸
      let preItem = paras.preItemParas;
      if (!isTopHalfShow && preItem) { // 底部卡片部分可见时，裁剪顶部跟随上一个条目的顶部裁剪
        let preShowHeight = listBottom - preItem.itemTop;
        let scaleCenterY = paras.scaleCenterY ?? MIN;
        let scale = paras.scale ?? MAX;
        paras.clipHeight = this.getClipHeightByScale(Math.min(tarShowHeight, preShowHeight), scaleCenterY, scale);
        paras.clipOffsetY = tarShowHeight - paras.clipHeight;
      }
    }
    paras.zIndex = isFullShow ? ITEM_Z_INDEX_NORMAL : ITEM_Z_INDEX_LOW;
    this.updateItemAnimParas(paras, paras.itemAnim);
  }

  /**
   * 计算裁切底部超出缩放中心后的裁切高度
   *
   * @param clipHeight 当前裁切底部
   * @param scaleCenterY 缩放中心
   * @param scale 缩放值
   * @returns 新的裁切高度
   */
  private getClipHeightByScale(clipHeight: number, scaleCenterY: number, scale: number): number {
    if (clipHeight <= scaleCenterY && scale > MIN) {
      clipHeight = scaleCenterY + (clipHeight - scaleCenterY) / scale;
    }
    return clipHeight;
  }

  private async updateItemAnimParas(itemParas: ItemAnimParas, animParas?: NotificationAnimationParas): Promise<void> {
    // 动效参数刷新
    animParas?.updateAlpha(itemParas.alpha ?? MAX).updateScale(itemParas.scale ?? MAX)
      .updateScaleCenterY(itemParas.scaleCenterY)
      .updateTranY(itemParas.tranY ?? MIN)
      .updateZIndex(itemParas.zIndex ?? ITEM_Z_INDEX_NORMAL)
      .updateItemTouchEnable(itemParas?.isEnable ?? true)
      .updateClipHeight(itemParas.clipHeight ?? MIN)
      .updateClipOffsetY(itemParas.clipOffsetY ?? MIN);
  }

  /**
   * 获取子组件动效
   *
   * @param hashcode 标示
   * @returns 子组件动效
   */
  private getChildInfo(hashcode: string): ImmersiveAnimInfo {
    let childInfo = this.rootAnimState.getChildAnimInfo(hashcode);
    if (CommonUtils.isInvalid(childInfo)) {
      childInfo = new ImmersiveAnimInfo(hashcode, this.createChildStyle());
      // 子组件多加一层
      childInfo.getWidgetAnimState().addChildState(BaseState.wrap<WidgetAnimState>(WidgetAnimState, hashcode));
      this.rootAnimState.addChildAnimInfo(childInfo);
    }
    return childInfo;
  }

  /**
   * 创建默认样式
   *
   * @returns UI样式
   */
  private createChildStyle(): ImmersiveAnimStyle {
    // 列表卡片默认动效样式
    return new ImmersiveAnimStyle()
      .bindStyle(AnimStyleType.RADIUS, NotificationConfig.BORDER_RADIUS)
      .bindStyle(AnimStyleType.PADDING_TOP, 12)
      .bindStyle(AnimStyleType.PADDING_LEFT, 12);
  }

  private getAnimCure(scene: ImmersiveAnimScene, preCure?: AnimateParam): AnimateParam { // 动效曲线
    let result: AnimateParam = preCure ?? {};
    switch (scene) {
      case ImmersiveAnimScene.SCENE_LIST_ALIGN_CHANGE:
        result.curve = curves.interpolatingSpring(0, 1, 228, 24.5);
        return result;
      default:
        return result;
    }
  }
}