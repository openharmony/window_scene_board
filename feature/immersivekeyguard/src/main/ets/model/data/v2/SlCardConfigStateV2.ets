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

import { SlCardConfigStPt, SlStateId } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { ColumnGutter, SlConfigBaseState } from '@ohos/screenlockcommon/Index';

// 根据栅格宽度计算栅格高度
export type CalcGutterHeight = (gutterWidth: number) => number;

/**
 * 沉浸大卡配置状态管理器
 */
export class SlCardConfigStateV2 extends SlConfigBaseState<SlCardConfigStPt, SlCardConfigStateV2> {
  // 顶部时钟占用高度，配置高度
  private _topClockHeight: number = 0;
  // 底部小工具占用高度，配置高度
  private _bottomToolsHeight: number = 0;
  // 栅格计算配置，赋值则按栅格计算宽度
  private _gutterConfig?: ColumnGutter;
  // 栅格计算时是否使用屏幕高度作为基准
  private _isGutterByHeight: boolean = false;
  // 以栅格宽度计算栅格高度
  private _calcGutterHeight?: CalcGutterHeight;
  // 沉浸态返回按钮是否显示
  private _isBackBtnEnable: boolean = false;
  // 实况样式是否开启模糊背景（小外屏扩展适配）
  private _isLiveBgBlurEnable: boolean = false;
  // 实况样式是否开启顶部箭头（小外屏扩展适配）
  private _isLiveArrowEnable: boolean = false;
  // 通用布局中内容是否占满全屏（小外屏扩展适配）
  private _isContentFullEnable: boolean = false;
  // 定位权限授权提醒布局中是否隐藏图标（小外屏扩展适配）
  private _isHideAuthImg: boolean = false;
  // 大卡条目是否隐藏背景（小外屏扩展适配）
  private _isHideItemBg: boolean = false;
  // 通用布局中条目点击事件是否内部实况卡片处理（小外屏扩展适配）
  private _isItemClickInner: boolean = false;
  // 实况样式位置记录是否开启（小外屏扩展适配）
  private _isCachePosEnable: boolean = false;
  // 顶部时钟高度监听是否关闭
  private _isClockHeightDisable: boolean = false;
  // 沉浸大卡条目手势是否关闭
  private _isItemGestureDisable: boolean = false;
  // 沉浸大卡实况卡卡片是否开启
  private _isLiveGestureEnable: boolean = false;
  // 折叠小外屏状态
  private _isFoldOuter: boolean = false;

  protected constructor() {
    super(SlStateId.SL_CARD_STATE);
  }

  protected initSetMethods(): void {
    super.initSetMethods();
    this.addSetMethod(SlCardConfigStPt.PT_TOP_CLOCK_HEIGHT, this.setTopClockHeight);
    this.addSetMethod(SlCardConfigStPt.PT_BOTTOM_TOOLS_HEIGHT, this.setBottomToolsHeight);
    this.addSetMethod(SlCardConfigStPt.PT_GUTTER_HEIGHT, this.setGutterHeightEnable);
    this.addSetMethod(SlCardConfigStPt.PT_GUTTER_CONFIG, this.setGutterConfig);
    this.addSetMethod(SlCardConfigStPt.PT_BACK_BTN, this.setBackBtnEnable);
    this.addSetMethod(SlCardConfigStPt.PT_LIVE_BG_BLUR, this.setLiveBgBlurEnable);
    this.addSetMethod(SlCardConfigStPt.PT_LIVE_ARROW, this.setLiveArrowEnable);
    this.addSetMethod(SlCardConfigStPt.PT_CONTENT_FULL, this.setContentFullEnable);
    this.addSetMethod(SlCardConfigStPt.PT_HIDE_AUTH_IMG, this.setHideAuthImg);
    this.addSetMethod(SlCardConfigStPt.PT_HIDE_ITEM_BG, this.setHideItemBg);
    this.addSetMethod(SlCardConfigStPt.PT_ITEM_CLICK_INNER, this.setItemClickInner);
    this.addSetMethod(SlCardConfigStPt.PT_LIVE_CACHE_POS, this.setLiveCachePosEnable);
    this.addSetMethod(SlCardConfigStPt.PT_CLOCK_HEIGHT_DISABLE, this.setClockHeightDisable);
    this.addSetMethod(SlCardConfigStPt.PT_DISABLE_ITEM_GESTURE, this.setItemGestureDisable);
    this.addSetMethod(SlCardConfigStPt.PT_FOLD_OUTER_STATE, this.setFoldOuter);
  }

  protected getTarInstance(): SlCardConfigStateV2 {
    return this;
  }

  /**
   * 赋值顶部时钟配置高度
   *
   * @param height 高度
   * @returns 链式
   */
  public setTopClockHeight(height: number): SlCardConfigStateV2 {
    let result = height ?? 0;
    if (this._topClockHeight !== result) {
      this._topClockHeight = result;
      this.notifyStateChange(SlCardConfigStPt.PT_TOP_CLOCK_HEIGHT);
    }
    return this;
  }

  /**
   * 取值顶部时钟配置高度
   *
   * @returns 高度
   */
  public getTopClockHeight(): number {
    return this._topClockHeight;
  }

  /**
   * 赋值底部小工具配置高度
   *
   * @param height 高度
   * @returns 链式
   */
  public setBottomToolsHeight(height: number): SlCardConfigStateV2 {
    let result = height ?? 0;
    if (this._bottomToolsHeight !== result) {
      this._bottomToolsHeight = result;
      this.notifyStateChange(SlCardConfigStPt.PT_BOTTOM_TOOLS_HEIGHT);
    }
    return this;
  }

  /**
   * 取值底部小工具配置高度
   *
   * @returns 高度
   */
  public getBottomToolsHeight(): number {
    return this._bottomToolsHeight;
  }

  /**
   * 沉浸态宽度栅格计算以屏幕高度为基准
   *
   * @param isEnable true以屏幕高度计算栅格
   * @returns 链式
   */
  public setGutterHeightEnable(isEnable?: boolean): SlCardConfigStateV2 {
    let result = isEnable ?? false;
    if (this._isGutterByHeight !== result) {
      this._isGutterByHeight = result;
      this.notifyStateChange(SlCardConfigStPt.PT_GUTTER_HEIGHT);
    }
    return this;
  }

  /**
   * 沉浸态宽度栅格计算以屏幕高度为基准
   *
   * @returns true以屏幕高度计算栅格
   */
  public isGutterHeightEnable(): boolean {
    return this._isGutterByHeight;
  }

  /**
   * 赋值栅格计算配置
   *
   * @param gutter 栅格配置
   */
  public setGutterConfig(gutter?: ColumnGutter): SlCardConfigStateV2 {
    if (this._gutterConfig !== gutter) {
      this._gutterConfig = gutter;
      this.notifyStateChange(SlCardConfigStPt.PT_GUTTER_CONFIG);
    }
    return this;
  }

  /**
   * 栅格计算配置
   *
   * @returns 栅格配置
   */
  public getGutterConfig(): ColumnGutter | undefined {
    return this._gutterConfig;
  }

  /**
   * 赋值栅格高度计算配置
   *
   * @param calc 栅格高度计算
   */
  public setCalcGutterHeight(calc?: CalcGutterHeight): SlCardConfigStateV2 {
    if (this._calcGutterHeight !== calc) {
      this._calcGutterHeight = calc;
      this.notifyStateChange(SlCardConfigStPt.PT_GUTTER_CALC_HEIGHT);
    }
    return this;
  }

  /**
   * 栅格高度计算配置
   *
   * @returns 栅格高度计算
   */
  public getCalcGutterHeight(): CalcGutterHeight | undefined {
    return this._calcGutterHeight;
  }

  /**
   * 沉浸态返回按钮显示开关
   *
   * @param isEnable true开启返回按钮
   * @returns 链式
   */
  public setBackBtnEnable(isEnable?: boolean): SlCardConfigStateV2 {
    let result = isEnable ?? false;
    if (this._isBackBtnEnable !== result) {
      this._isBackBtnEnable = result;
      this.notifyStateChange(SlCardConfigStPt.PT_BACK_BTN);
    }
    return this;
  }

  /**
   * 沉浸态返回按钮显示开关
   *
   * @returns true开启返回按钮
   */
  public isBackBtnEnable(): boolean {
    return this._isBackBtnEnable;
  }

  /**
   * 通用样式中底部实况样式模糊背景开关
   *
   * @param isEnable true开启背景模糊
   * @returns 链式
   */
  public setLiveBgBlurEnable(isEnable?: boolean): SlCardConfigStateV2 {
    let result = isEnable ?? false;
    if (this._isLiveBgBlurEnable !== result) {
      this._isLiveBgBlurEnable = result;
      this.notifyStateChange(SlCardConfigStPt.PT_LIVE_BG_BLUR);
    }
    return this;
  }

  /**
   * 通用样式中底部实况样式背景模糊开关
   *
   * @returns true开启背景模糊
   */
  public isLiveBgBlurEnable(): boolean {
    return this._isLiveBgBlurEnable;
  }

  /**
   * 通用样式中底部实况样式顶部箭头开关
   *
   * @param isEnable true开启顶部箭头
   * @returns 链式
   */
  public setLiveArrowEnable(isEnable?: boolean): SlCardConfigStateV2 {
    let result = isEnable ?? false;
    if (this._isLiveArrowEnable !== result) {
      this._isLiveArrowEnable = result;
      this.notifyStateChange(SlCardConfigStPt.PT_LIVE_ARROW);
    }
    return this;
  }

  /**
   * 通用样式中底部实况样式顶部箭头开关
   *
   * @returns true开启顶部箭头
   */
  public isLiveArrowEnable(): boolean {
    return this._isLiveArrowEnable;
  }

  /**
   * 通用样式中内容占满全屏开关
   *
   * @param isEnable true开启内容全屏
   * @returns 链式
   */
  public setContentFullEnable(isEnable?: boolean): SlCardConfigStateV2 {
    let result = isEnable ?? false;
    if (this._isContentFullEnable !== result) {
      this._isContentFullEnable = result;
      this.notifyStateChange(SlCardConfigStPt.PT_CONTENT_FULL);
    }
    return this;
  }

  /**
   * 通用样式中内容占满全屏开关
   *
   * @returns true开启内容全屏
   */
  public isContentFullEnable(): boolean {
    return this._isContentFullEnable;
  }

  /**
   * 定位权限授权提醒布局中是否隐藏图标
   *
   * @param isHideImg true隐藏图标
   * @returns 链式
   */
  public setHideAuthImg(isHideImg?: boolean): SlCardConfigStateV2 {
    let result = isHideImg ?? false;
    if (this._isHideAuthImg !== result) {
      this._isHideAuthImg = result;
      this.notifyStateChange(SlCardConfigStPt.PT_HIDE_AUTH_IMG);
    }
    return this;
  }

  /**
   * 定位授权布局中是否隐藏图标
   *
   * @returns true隐藏图标
   */
  public isHideAuthImg(): boolean {
    return this._isHideAuthImg;
  }

  /**
   * 大卡条目是否隐藏背景
   *
   * @param isHideBg true隐藏背景
   * @returns 链式
   */
  public setHideItemBg(isHideBg?: boolean): SlCardConfigStateV2 {
    let result = isHideBg ?? false;
    if (this._isHideItemBg !== result) {
      this._isHideItemBg = result;
      this.notifyStateChange(SlCardConfigStPt.PT_HIDE_ITEM_BG);
    }
    return this;
  }

  /**
   * 大卡条目是否隐藏背景
   *
   * @returns true隐藏背景
   */
  public isHideItemBg(): boolean {
    return this._isHideItemBg;
  }

  /**
   * 条目点击事件是否设置在内部实况卡片上
   *
   * @param isInner true内部实况卡片点击事件
   * @returns 链式
   */
  public setItemClickInner(isInner?: boolean): SlCardConfigStateV2 {
    let result = isInner ?? false;
    if (this._isItemClickInner !== result) {
      this._isItemClickInner = result;
      this.notifyStateChange(SlCardConfigStPt.PT_ITEM_CLICK_INNER);
    }
    return this;
  }

  /**
   * 条目点击事件是否设置在内部实况卡片上
   *
   * @returns true内部实况卡片点击事件
   */
  public isItemCLickInner(): boolean {
    return this._isItemClickInner;
  }

  /**
   * 通用样式中底部实况样式位置记录开关
   *
   * @param isEnable true开启位置记录
   * @returns 链式
   */
  public setLiveCachePosEnable(isEnable?: boolean): SlCardConfigStateV2 {
    let result = isEnable ?? false;
    if (this._isCachePosEnable !== result) {
      this._isCachePosEnable = result;
      this.notifyStateChange(SlCardConfigStPt.PT_LIVE_CACHE_POS);
    }
    return this;
  }

  /**
   * 通用样式中底部实况样式位置记录开关
   *
   * @returns true开启位置记录
   */
  public isLiveCachePosEnable(): boolean {
    return this._isCachePosEnable;
  }

  /**
   * 顶部时钟高度监听是否关闭
   *
   * @param isDisable true关闭时钟监听
   * @returns 链式
   */
  public setClockHeightDisable(isDisable?: boolean): SlCardConfigStateV2 {
    let result = isDisable ?? false;
    if (this._isClockHeightDisable !== result) {
      this._isClockHeightDisable = result;
      this.notifyStateChange(SlCardConfigStPt.PT_CLOCK_HEIGHT_DISABLE);
    }
    return this;
  }

  /**
   * 顶部时钟高度监听是否关闭
   *
   * @returns true关闭时钟监听
   */
  public isClockHeightDisable(): boolean {
    return this._isClockHeightDisable;
  }

  /**
   * 沉浸态手势开关
   *
   * @param isDisable true关闭手势
   * @returns 链式
   */
  public setItemGestureDisable(isDisable?: boolean): SlCardConfigStateV2 {
    let result = isDisable ?? false;
    if (this._isItemGestureDisable !== result) {
      this._isItemGestureDisable = result;
      this.notifyStateChange(SlCardConfigStPt.PT_DISABLE_ITEM_GESTURE);
    }
    return this;
  }

  /**
   * 沉浸态是否屏蔽手势
   *
   * @returns true屏蔽手势
   */
  public isItemDisableGesture(): boolean {
    return this._isItemGestureDisable;
  }

  /**
   * 沉浸实况卡片态手势开关
   *
   * @param isEnable true开启手势
   * @returns 链式
   */
  public setLiveGestureEnable(isEnable?: boolean): SlCardConfigStateV2 {
    let result = isEnable ?? false;
    if (this._isLiveGestureEnable !== result) {
      this._isLiveGestureEnable = result;
      this.notifyStateChange(SlCardConfigStPt.PT_ENABLE_LIVE_GESTURE);
    }
    return this;
  }

  /**
   * 沉浸态实况卡片是否启用手势
   *
   * @returns true启用手势
   */
  public isLiveEnableGesture(): boolean {
    return this._isLiveGestureEnable;
  }

  /**
   * 折叠小外屏状态
   *
   * @param isOuter true小外屏
   * @returns 链式
   */
  public setFoldOuter(isOuter?: boolean): SlCardConfigStateV2 {
    let result = isOuter ?? false;
    if (this._isFoldOuter !== result) {
      this._isFoldOuter = result;
      this.notifyStateChange(SlCardConfigStPt.PT_FOLD_OUTER_STATE);
    }
    return this;
  }

  /**
   * 折叠小外屏状态
   *
   * @returns true小外屏
   */
  public isFoldOuter(): boolean {
    return this._isFoldOuter;
  }
}