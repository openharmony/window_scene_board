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

import { effectKit } from '@kit.ArkGraphics2D';
import { LogDomain, Logger } from '@ohos/basicutils';
import {
  SlVisualConfigManager,
  CcmOption,
  SlAreaType,
  SlVisualControl,
  SolidColorListener
} from '@ohos/screenlockcommon';
import { SlStateId, SlListStaticStPt } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { SlViewStaticState, WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import { NotificationArray } from '@ohos/systemuicommon/newTsIndex';
import { ImmersivePfmConstant } from '../../../common/anim/ImmersiveAnimConstants';
import { ImmListConst } from '../../../common/constants/ImmListConst';
import { ImmersiveTraceHelper } from '../../../common/helper/ImmersiveTraceHelper';
import { ISolidVisualControl } from '../../../common/interface/ISolidVisualControl';

const TAG = 'SlListStaticStateV2';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

// 触顶偏移误差
const TOP_OFFSET = 0.01;

// 列表堆叠效果动效过渡参数
export interface FoldAnimParam {
  // 动效过渡场景
  scene?: string;
  // 动效过渡曲线参数
  animParam?: AnimateParam;
}

/**
 * 沉浸列表静态状态管理器
 */
export class SlListStaticStateV2 extends SlViewStaticState<SlListStaticStPt> implements ISolidVisualControl {
  // 沉浸列表滑动控制器
  private readonly _listScroller: Scroller = new Scroller();

  // 沉浸列表数据集
  private readonly _listData: NotificationArray = new NotificationArray();

  // 沉浸列表条目预加载个数
  private readonly _itemCacheCount: number = 4;

  // 沉浸列表条目间距
  private readonly _itemSpace: number = 8;

  // 沉浸列表滑动跟手转换率
  private readonly _scrollFriction: number = 0.9;

  // 沉浸列表最大高度，vp
  private _listMaxHeight: number = 0;

  // 是否拦截锁屏事件，默认拦截
  private _isStopPropagation: boolean = true;

  // 可见条目起始索引
  private _startIndex: number = ImmListConst.INVALID_INDEX;

  // 可见条目结束索引
  private _endIndex: number = ImmListConst.INVALID_INDEX;

  // 当前列表是否正在滑动
  private _isListScrolling: boolean = false;

  // 是否开启滑动偏移值检测
  private _isCheckWillOffset: boolean = false;

  // 列表即将滑动位移累加值
  private _listWillOffset: number = 0;

  // 列表条目翻转折叠更新时动效过渡曲线
  private _itemFoldAnim: FoldAnimParam = {};

  // 列表网格底部边距
  private _meshPaddingB?: number = 0;

  // 列表条目纯色模式下背景颜色
  private _itemSolidBgColor?: effectKit.Color;

  // 监听纯色模式刷新，触发大卡元素颜色刷新
  private readonly _solidListener: SolidColorListener = {
    onColorChange: () => this.updateInnerSolidColor()
  }

  protected constructor() {
    super(SlStateId.SL_LIST_STATE);
  }

  protected initSetMethods(): void {
    super.initSetMethods();
    this.addSetMethod(SlListStaticStPt.PT_ITEM_FOLD_ANIM, this.setItemFoldAnim);
    this.addSetMethod(SlListStaticStPt.PT_MESH_PADDING_B, this.setMeshPaddingB);
  }

  protected initGetMethods(): void {
    super.initGetMethods();
    this.addGetMethod(SlListStaticStPt.PT_ITEM_SPACE, this.getItemSpace);
    this.addGetMethod(SlListStaticStPt.PT_LIST_SCROLLER, this.getListScroller);
    this.addGetMethod(SlListStaticStPt.PT_LIST_MAX_HEIGHT, this.getListMaxHeight);
    this.addGetMethod(SlListStaticStPt.PT_STOP_PROPAGATION, this.getListMaxHeight);
    this.addGetMethod(SlListStaticStPt.PT_START_INDEX, this.getStartIndex);
    this.addGetMethod(SlListStaticStPt.PT_END_INDEX, this.getEndIndex);
    this.addGetMethod(SlListStaticStPt.PT_MESH_PADDING_B, this.getMeshPaddingB);
  }

  /**
   * 纯色模式开关
   *
   * @returns true纯色模式开启
   */
  public isSolidEnable(): boolean {
    return SlVisualConfigManager.getInstance().getEnable(CcmOption.SOLID, SlAreaType.NTF_LIST);
  }

  /**
   * 禁用提亮开关
   *
   * @returns true禁用提亮
   */
  public isDisableBright(): boolean {
    return !SlVisualConfigManager.getInstance().getEnable(CcmOption.BRIGHT, SlAreaType.NTF_LIST);
  }

  /**
   * 纯色业务管理
   */
  public solidInit(): void {
    // 监听大卡区域纯色颜色切换
    if (this.isSolidEnable()) {
      this.updateInnerSolidColor();
      SlVisualControl.getInstance().registerSolidListener(SlAreaType.NTF_LIST, this._solidListener);
    }
  }

  /**
   * 纯色业务管理
   */
  public solidDestroy(): void {
    if (this.isSolidEnable()) {
      SlVisualControl.getInstance().unregisterSolidListener(SlAreaType.NTF_LIST, this._solidListener);
    }
  }

  /**
   * 刷新纯色样式
   *
   * @param solidStyle 纯色样式
   */
  public updateSolidColor(solidStyle: WidgetStyleStateV2): void {
  }

  /**
   * 获取沉浸列表数据集
   *
   * @returns 数据集
   */
  public getListData(): NotificationArray {
    return this._listData;
  }

  /**
   * 获取列表滑动控制器
   *
   * @returns 滑动控制器
   */
  public getListScroller(): Scroller {
    return this._listScroller;
  }

  /**
   * 获取沉浸列表条目间距
   *
   * @returns 条目间距
   */
  public getItemSpace(): number {
    return this._itemSpace;
  }

  /**
   * 获取沉浸列表条目预加载个数
   *
   * @returns 预加载个数
   */
  public getItemCacheCount(): number {
    return this._itemCacheCount;
  }

  /**
   * 获取沉浸列表滑动跟手转换率
   *
   * @returns 跟手转换率
   */
  public getScrollFriction(): number {
    return this._scrollFriction;
  }

  /**
   * 列表初始滑动偏移量
   *
   * @returns 初始滑动偏移量
   */
  public getInitScrollOffset(): number {
    return -this._itemSpace;
  }

  /**
   * 列表当前滑动偏移量
   *
   * @returns 当前滑动偏移量
   */
  public getCurScrollOffset(): number {
    return this._listScroller.currentOffset()?.yOffset ?? this.getInitScrollOffset();
  }

  /**
   * 判断列表是否已触顶
   *
   * @returns true已触顶
   */
  public isListAtTop(): boolean {
    let initOffset = this.getInitScrollOffset();
    let curOffset = this.getCurScrollOffset();
    return curOffset <= (initOffset + TOP_OFFSET);
  }

  /**
   * 判断列表是否已触底
   *
   * @returns true已触底
   */
  public isListAtEnd(): boolean {
    return this.getListScroller().isAtEnd() ?? false;
  }

  /**
   * 列表滚动到顶部
   */
  public scrollListToTop(): void {
    const listLength: number = this._listData.length;
    if (listLength == 0) {
      return;
    }
    this.getListScroller().scrollTo({ xOffset: 0, yOffset: this.getInitScrollOffset() });
  }

  /**
   * 列表滚动到底部
   */
  public scrollListToBottom(): void {
    const listLength: number = this._listData.length;
    if (listLength == 0) {
      return;
    }
    this.getListScroller().scrollEdge(Edge.Bottom);
  }

  /**
   * 设置列表最大高度
   *
   * @param maxHeight 最大高度
   */
  public setListMaxHeight(maxHeight: number): void {
    let result = maxHeight ?? 0;
    if (this._listMaxHeight !== result) {
      this._listMaxHeight = result;
      this.notifyStateChange(SlListStaticStPt.PT_LIST_MAX_HEIGHT);
      log.showInfo(TAG, `setListMaxHeight: ${maxHeight}, ${this.splicePrint()}`);
    }
  }

  /**
   * 获取列表最大高度
   *
   * @returns 最大高度
   */
  public getListMaxHeight(): number {
    return this._listMaxHeight;
  }

  /**
   * 设置是否拦截锁屏事件
   *
   * @param isStop true拦截事件
   * @param reason 原因
   */
  public setStopPropagation(isStop: boolean, reason?: string): void {
    let result = isStop ?? false;
    if (this._isStopPropagation !== result) {
      this._isStopPropagation = result;
      this.notifyStateChange(SlListStaticStPt.PT_STOP_PROPAGATION);
      log.showInfo(TAG, `setStopPropagation: ${isStop}, ${this.splicePrint(reason)}`);
    }
  }

  /**
   * 当前列表是否拦截锁屏事件
   *
   * @returns true拦截事件
   */
  public isStopPropagation(): boolean {
    return this._isStopPropagation;
  }

  /**
   * 设置列表可见条目起始索引
   *
   * @param startIndex 起始索引
   */
  public setStartIndex(startIndex: number): void {
    let result = startIndex ?? ImmListConst.INVALID_INDEX;
    if (this._startIndex !== result) {
      this._startIndex = result;
      this.notifyStateChange(SlListStaticStPt.PT_START_INDEX);
    }
  }

  /**
   * 当前可见条目起始索引
   *
   * @returns 起始索引
   */
  public getStartIndex(): number {
    return this._startIndex;
  }

  /**
   * 设置列表可见条目结束索引
   *
   * @param endIndex 结束索引
   */
  public setEndIndex(endIndex: number): void {
    let result = endIndex ?? ImmListConst.INVALID_INDEX;
    if (this._endIndex !== result) {
      this._endIndex = result;
      this.notifyStateChange(SlListStaticStPt.PT_END_INDEX);
    }
  }

  /**
   * 当前可见条目结束索引
   *
   * @returns 结束索引
   */
  public getEndIndex(): number {
    return this._endIndex;
  }

  /**
   * 滑动偏移累加
   *
   * @param offset 当次偏移值
   */
  public addWillOffset(offset: number): void {
    this._listWillOffset += offset;
  }

  /**
   * 重置滑动偏移值
   */
  public resetWillOffset(): void {
    this._listWillOffset = 0;
  }

  /**
   * 取当前滑动偏移累加值
   *
   * @returns 偏移累加值
   */
  public getWillOffset(): number {
    return this._listWillOffset;
  }

  /**
   * 设置列表当前滑动状态
   *
   * @param isScrolling 结束索引
   */
  public setListScrolling(isScrolling: boolean): void {
    let result = isScrolling ?? false;
    if (this._isListScrolling !== result) {
      this._isListScrolling = result;
      this.notifyStateChange(SlListStaticStPt.PT_LIST_SCROLLING);
      // 滑动打点
      if (isScrolling) {
        ImmersiveTraceHelper.startPMoveTrace(ImmersivePfmConstant.SCENE_LIST_SWIPE_ANIM);
      } else {
        ImmersiveTraceHelper.endPMoveTrace(ImmersivePfmConstant.SCENE_LIST_SWIPE_ANIM);
      }
    }
    // 当开启滑动时，如果当前已触顶，则需要判断初始的滑动方向
    this._isCheckWillOffset = result && this.isListAtTop();
  }

  /**
   * 当前列表是否正在滑动
   *
   * @returns true正在滑动
   */
  public isListScrolling(): boolean {
    return this._isListScrolling;
  }

  /**
   * 滑动检测标志位复位
   */
  public resetCheckWillOffset(): void {
    this._isCheckWillOffset = false;
  }

  /**
   * 是否检测滑动方向
   *
   * @returns true检测滑动方向
   */
  public isCheckWillOffset(): boolean {
    return this._isCheckWillOffset;
  }

  /**
   * 赋值条目折叠翻转过渡时动效曲线
   *
   * @param foldAnim 动效参数
   */
  public setItemFoldAnim(foldAnim?: FoldAnimParam): void {
    if (this.checkFoldAnimChange(foldAnim)) {
      this.notifyStateChange(SlListStaticStPt.PT_ITEM_FOLD_ANIM);
    }
  }

  /**
   * 强制清空条目堆叠动效曲线
   */
  public clearItemFoldAnim(): void {
    if (this._itemFoldAnim.animParam) {
      this._itemFoldAnim.scene = undefined;
      this._itemFoldAnim.animParam = undefined;
      this.notifyStateChange(SlListStaticStPt.PT_ITEM_FOLD_ANIM);
    }
  }

  /**
   * 取值条目折叠翻转动效曲线
   *
   * @returns 动效曲线
   */
  public getItemFoldAnim(): AnimateParam | undefined {
    return this._itemFoldAnim?.animParam;
  }

  /**
   * 设置列表网格底部边距
   *
   * @param meshPaddingB 网格底部边距
   */
  public setMeshPaddingB(meshPaddingB: number): void {
    if (this._meshPaddingB !== meshPaddingB) {
      this._meshPaddingB = meshPaddingB;
      this.notifyStateChange(SlListStaticStPt.PT_MESH_PADDING_B);
    }
  }

  /**
   * 取值列表网格底部边距
   *
   * @returns 底部边距
   */
  public getMeshPaddingB(): number | undefined {
    return this._meshPaddingB;
  }

  /**
   * 条目背景纯色
   *
   * @returns 背景纯色
   */
  public getItemBgSolidColor(): effectKit.Color | undefined {
    return this._itemSolidBgColor;
  }

  private checkFoldAnimChange(foldAnim?: FoldAnimParam): boolean {
    // 对比是否接纳堆叠动效参数；无场景，不允许刷新
    if (!foldAnim?.scene) {
      return false;
    }
    // 现有参数无场景，可以接纳任意场景动效参数
    if (!this._itemFoldAnim.scene) {
      if (this._itemFoldAnim.animParam !== foldAnim?.animParam) {
        this.setFoldAnimate(foldAnim?.animParam);
        this._itemFoldAnim.scene = foldAnim?.scene;
        return true;
      }
      return false;
    }
    // 现有参数有场景，必须场景相同，才允许切换动效参数
    if (this._itemFoldAnim.scene !== foldAnim?.scene) {
      return false;
    }
    if (this._itemFoldAnim.animParam !== foldAnim?.animParam) {
      this.setFoldAnimate(foldAnim?.animParam);
    }
    // 无动效曲线了，则无需保留场景
    if (!this._itemFoldAnim.animParam) {
      this._itemFoldAnim.scene = undefined;
    }
    return true;
  }

  private setFoldAnimate(anim?: AnimateParam): void {
    // 取消动效曲线
    if (!anim) {
      this._itemFoldAnim.animParam = undefined;
      return;
    }
    // 真实动效曲线，只取曲线值
    this._itemFoldAnim.animParam = { delay: anim.delay, duration: anim.duration, curve: anim.curve };
  }

  private updateInnerSolidColor(): void {
    // 刷新纯色模式颜色，受纯色计算、深色模式影响
    if (!this.isSolidEnable()) {
      return;
    }
    // 条目背景颜色
    let itemBgColor = this.getSolidColor();
    if (this._itemSolidBgColor !== itemBgColor) {
      this._itemSolidBgColor = itemBgColor;
      this.notifyStateChange(SlListStaticStPt.PT_ITEM_SOLID_BG_COLOR);
    }
  }

  private getSolidColor(): effectKit.Color | undefined {
    // 对应业务纯色颜色
    return SlVisualControl.getInstance().getCurBackColorByType(SlAreaType.NTF_LIST);
  }
}