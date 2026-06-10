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

import { SlCardBindStPt, SlStateId } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { SlViewBindState } from '@ohos/screenlockcommon/Index';

/**
 * 沉浸大卡UI绑定状态管理器
 */
@ObservedV2
export class SlCardBindStateV2 extends SlViewBindState<SlCardBindStPt> {
  // 沉浸态返回按钮是否显示
  @Trace private _isBackBtnEnable: boolean = false;
  // 实况样式是否开启模糊背景（小外屏扩展适配）
  @Trace private _isLiveBgBlurEnable: boolean = false;
  // 实况样式是否开启顶部箭头（小外屏扩展适配）
  @Trace private _isLiveArrowEnable: boolean = false;
  // 通用布局中内容是否占满全屏（小外屏扩展适配）
  @Trace private _isContentFullEnable: boolean = false;
  // 定位权限授权提醒布局中是否隐藏图标（小外屏扩展适配）
  @Trace private _isHideAuthImg: boolean = false;
  // 通用布局中条目点击事件是否内部实况卡片处理（小外屏扩展适配）
  @Trace private _isItemClickInner: boolean = false;
  // 沉浸态是否屏蔽条目手势事件（小外屏扩展适配）
  @Trace private _isDisableItemGesture: boolean = false;
  // 沉浸态是否开启实况卡片手势事件（小外屏扩展适配）
  @Trace private _isEnableLiveGesture: boolean = false;
  // 大卡条目是否隐藏背景（小外屏扩展适配）
  @Trace private _isHideItemBg: boolean = false;
  // 实况卡片是否收拢底部隐藏，true收拢（小外屏扩展适配）
  @Trace private _isLiveCardFold: boolean = false;

  protected constructor() {
    super(SlStateId.SL_CARD_STATE);
  }

  protected initSetMethods(): void {
    super.initSetMethods();
    this.addSetMethod(SlCardBindStPt.PT_BACK_BTN, this.setBackBtnEnable);
    this.addSetMethod(SlCardBindStPt.PT_LIVE_BG_BLUR, this.setLiveBgBlurEnable);
    this.addSetMethod(SlCardBindStPt.PT_LIVE_ARROW, this.setLiveArrowEnable);
    this.addSetMethod(SlCardBindStPt.PT_CONTENT_FULL, this.setContentFullEnable);
    this.addSetMethod(SlCardBindStPt.PT_HIDE_AUTH_IMG, this.setHideAuthImg);
    this.addSetMethod(SlCardBindStPt.PT_HIDE_ITEM_BG, this.setHideItemBg);
    this.addSetMethod(SlCardBindStPt.PT_ITEM_CLICK_INNER, this.setItemClickInner);
    this.addSetMethod(SlCardBindStPt.PT_DISABLE_ITEM_GESTURE, this.setItemGestureDisable);
    this.addSetMethod(SlCardBindStPt.PT_ENABLE_LIVE_GESTURE, this.setLiveGestureEnable);
  }

  protected initGetMethods(): void {
    super.initGetMethods();
    this.addGetMethod(SlCardBindStPt.PT_LIVE_CARD_FOLD, this.isLiveCardFold);
  }

  /**
   * 沉浸态返回按钮显示开关
   *
   * @param isEnable true开启返回按钮
   * @returns 链式
   */
  public setBackBtnEnable(isEnable?: boolean): SlCardBindStateV2 {
    let result = isEnable ?? false;
    if (this._isBackBtnEnable !== result) {
      this._isBackBtnEnable = result;
      this.notifyStateChange(SlCardBindStPt.PT_BACK_BTN);
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
  public setLiveBgBlurEnable(isEnable?: boolean): SlCardBindStateV2 {
    let result = isEnable ?? false;
    if (this._isLiveBgBlurEnable !== result) {
      this._isLiveBgBlurEnable = result;
      this.notifyStateChange(SlCardBindStPt.PT_LIVE_BG_BLUR);
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
  public setLiveArrowEnable(isEnable?: boolean): SlCardBindStateV2 {
    let result = isEnable ?? false;
    if (this._isLiveArrowEnable !== result) {
      this._isLiveArrowEnable = result;
      this.notifyStateChange(SlCardBindStPt.PT_LIVE_ARROW);
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
  public setContentFullEnable(isEnable?: boolean): SlCardBindStateV2 {
    let result = isEnable ?? false;
    if (this._isContentFullEnable !== result) {
      this._isContentFullEnable = result;
      this.notifyStateChange(SlCardBindStPt.PT_CONTENT_FULL);
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
  public setHideAuthImg(isHideImg?: boolean): SlCardBindStateV2 {
    let result = isHideImg ?? false;
    if (this._isHideAuthImg !== result) {
      this._isHideAuthImg = result;
      this.notifyStateChange(SlCardBindStPt.PT_HIDE_AUTH_IMG);
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
   * 条目点击事件是否设置在内部实况卡片上
   *
   * @param isInner true内部实况卡片点击事件
   * @returns 链式
   */
  public setItemClickInner(isInner?: boolean): SlCardBindStateV2 {
    let result = isInner ?? false;
    if (this._isItemClickInner !== result) {
      this._isItemClickInner = result;
      this.notifyStateChange(SlCardBindStPt.PT_ITEM_CLICK_INNER);
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
   * 沉浸态手势开关
   *
   * @param isDisable true关闭手势
   * @returns 链式
   */
  public setItemGestureDisable(isDisable?: boolean): SlCardBindStateV2 {
    let result = isDisable ?? false;
    if (this._isDisableItemGesture !== result) {
      this._isDisableItemGesture = result;
      this.notifyStateChange(SlCardBindStPt.PT_DISABLE_ITEM_GESTURE);
    }
    return this;
  }

  /**
   * 沉浸态是否屏蔽手势
   *
   * @returns true屏蔽手势
   */
  public isItemDisableGesture(): boolean {
    return this._isDisableItemGesture;
  }

  /**
   * 沉浸态实况卡片手势开关
   *
   * @param isEnable true开启手势
   * @returns 链式
   */
  public setLiveGestureEnable(isEnable?: boolean): SlCardBindStateV2 {
    let result = isEnable ?? false;
    if (this._isEnableLiveGesture !== result) {
      this._isEnableLiveGesture = result;
      this.notifyStateChange(SlCardBindStPt.PT_ENABLE_LIVE_GESTURE);
    }
    return this;
  }

  /**
   * 沉浸态是否屏蔽手势
   *
   * @returns true屏蔽手势
   */
  public isLiveEnableGesture(): boolean {
    return this._isEnableLiveGesture;
  }

  /**
   * 是否隐藏条目背景
   *
   * @param isHideBg true隐藏背景
   * @returns 链式
   */
  public setHideItemBg(isHideBg?: boolean): SlCardBindStateV2 {
    let result = isHideBg ?? false;
    if (this._isHideItemBg !== result) {
      this._isHideItemBg = result;
      this.notifyStateChange(SlCardBindStPt.PT_HIDE_ITEM_BG);
    }
    return this;
  }

  /**
   * 是否隐藏条目背景
   *
   * @returns true隐藏背景
   */
  public isHideItemBg(): boolean {
    return this._isHideItemBg;
  }

  /**
   * 是否实况卡片收拢
   *
   * @param isFold true收拢
   * @returns 链式
   */
  public setLiveCardFold(isFold?: boolean): SlCardBindStateV2 {
    let result = isFold ?? false;
    if (this._isLiveCardFold !== result) {
      this._isLiveCardFold = result;
      this.notifyStateChange(SlCardBindStPt.PT_LIVE_CARD_FOLD);
    }
    return this;
  }

  /**
   * 是否实况卡片收拢
   *
   * @returns true收拢
   */
  public isLiveCardFold(): boolean {
    return this._isLiveCardFold;
  }
}