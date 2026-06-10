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
  CcmOption,
  SlAreaType,
  SlPositionType,
  SlVisualConfigManager,
  SlVisualControl,
  SolidColorListener
} from '@ohos/screenlockcommon';
import { MethodMap, SlCardStaticStPt, SlStateId } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { SlViewStaticState, WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import { ISolidVisualControl } from '../../../common/interface/ISolidVisualControl';
import { ImmCardDataArray } from './ImmCardDataArray';

/**
 * 沉浸大卡静态状态管理器
 */
export class SlCardStaticStateV2 extends SlViewStaticState<SlCardStaticStPt> implements ISolidVisualControl {
  // 沉浸大卡数据集
  private readonly _cardData: ImmCardDataArray = new ImmCardDataArray();

  // 纯色赋值函数集
  private _solidSetMethod?: MethodMap<SlCardStaticStateV2>;

  // 当前显示为沉浸大卡的通知groupKey
  private groupKeyOfShowing?: string;

  // 实况样式位置记录是否开启（小外屏扩展适配）
  private _isCachePosEnable: boolean = false;

  // 沉浸大卡纯色模式下背景颜色
  private _cardSolidBgColor?: ResourceColor;

  // 系统是否深色模式
  private _isDarkMode: boolean = false;

  // 折叠小外屏状态
  private _isFoldOuter: boolean = false;

  // 实况卡片是否收拢状态
  private _isLiveCardFold: boolean = false;

  // 监听纯色模式刷新，触发大卡元素颜色刷新
  private readonly _solidListener: SolidColorListener = {
    onColorChange: () => this.updateInnerSolidColor()
  }

  protected constructor() {
    super(SlStateId.SL_CARD_STATE);
  }

  protected init(): void {
    this._solidSetMethod = new MethodMap(this);
    super.init();
  }

  protected initSetMethods(): void {
    super.initSetMethods();
    this.addSetMethod(SlCardStaticStPt.PT_LIVE_CACHE_POS, this.setLiveCachePosEnable);
    this.addSetMethod(SlCardStaticStPt.PT_FOLD_OUTER_STATE, this.setFoldOuter);
    this._solidSetMethod?.addSetMethod(SlCardStaticStPt.PT_CARD_SOLID_BG_COLOR, this.setCardSolidBgColor);
  }

  protected initGetMethods(): void {
    super.initGetMethods();
    this.addGetMethod(SlCardStaticStPt.PT_GROUP_KEY_OF_SHOWING, this.getGroupKeyOfShowing);
    this.addGetMethod(SlCardStaticStPt.PT_FOLD_OUTER_STATE, this.isFoldOuter);
    this.addGetMethod(SlCardStaticStPt.PT_LIVE_CARD_FOLD, this.isLiveCardFold);
  }

  /**
   * 纯色模式开关
   *
   * @returns true纯色模式开启
   */
  public isSolidEnable(): boolean {
    return SlVisualConfigManager.getInstance().getEnable(CcmOption.SOLID, SlAreaType.IMMERSIVE_CARD);
  }

  /**
   * 禁用提亮开关
   *
   * @returns true禁用提亮
   */
  public isDisableBright(): boolean {
    return !SlVisualControl.getInstance().getEnable(CcmOption.BRIGHT, SlAreaType.IMMERSIVE_CARD);
  }

  /**
   * 纯色业务管理
   */
  public solidInit(): void {
    // 监听大卡区域纯色颜色切换
    if (this.isSolidEnable()) {
      this.updateInnerSolidColor();
      SlVisualControl.getInstance().registerSolidListener(SlAreaType.IMMERSIVE_CARD, this._solidListener);
    }
  }

  /**
   * 纯色业务管理
   */
  public solidDestroy(): void {
    if (this.isSolidEnable()) {
      SlVisualControl.getInstance().unregisterSolidListener(SlAreaType.IMMERSIVE_CARD, this._solidListener);
    }
  }

  /**
   * 刷新纯色样式
   *
   * @param solidStyle 纯色样式
   */
  public updateSolidColor(solidStyle: WidgetStyleStateV2): void {
    this._solidSetMethod?.callSetMethod(solidStyle?.getConfigId(), solidStyle);
  }

  /**
   * 取值大卡数据
   *
   * @returns 数据集
   */
  public getCardData(): ImmCardDataArray {
    return this._cardData;
  }

  /**
   * 通用样式中底部实况样式位置记录开关
   *
   * @param isEnable true开启位置记录
   * @returns 链式
   */
  public setLiveCachePosEnable(isEnable?: boolean): SlCardStaticStateV2 {
    let result = isEnable ?? false;
    if (this._isCachePosEnable !== result) {
      this._isCachePosEnable = result;
      this.notifyStateChange(SlCardStaticStPt.PT_LIVE_CACHE_POS);
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
   * 折叠小外屏状态
   *
   * @param isOuter true小外屏
   * @returns 链式
   */
  public setFoldOuter(isOuter?: boolean): SlCardStaticStateV2 {
    let result = isOuter ?? false;
    if (this._isFoldOuter !== result) {
      this._isFoldOuter = result;
      this.notifyStateChange(SlCardStaticStPt.PT_FOLD_OUTER_STATE);
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

  /**
   * 设置显示为沉浸大卡的通知groupKey
   *
   * @param groupKey 沉浸大卡的groupKey
   * @returns true值切换
   */
  public setGroupKeyOfShowing(groupKey?: string): boolean {
    if (this.groupKeyOfShowing !== groupKey) {
      this.groupKeyOfShowing = groupKey;
      this.notifyStateChange(SlCardStaticStPt.PT_GROUP_KEY_OF_SHOWING);
      return true;
    }
    return false;
  }

  /**
   * 取值显示为大卡的groupKey
   *
   * @returns groupKey
   */
  public getGroupKeyOfShowing(): string | undefined {
    return this.groupKeyOfShowing;
  }

  /**
   * 是否实况卡片收拢，用户操作静态状态记录
   *
   * @param isFold true收拢
   * @returns true 状态切换
   */
  public setLiveCardFold(isFold?: boolean): boolean {
    let result = isFold ?? false;
    if (this._isLiveCardFold !== result) {
      this._isLiveCardFold = result;
      this.notifyStateChange(SlCardStaticStPt.PT_LIVE_CARD_FOLD);
      return true;
    }
    return false;
  }

  /**
   * 是否实况卡片收拢
   *
   * @returns true收拢
   */
  public isLiveCardFold(): boolean {
    return this._isLiveCardFold;
  }

  /**
   * 切换深色模式状态
   *
   * @param isDarkMode true开启深色模式
   */
  public setDarkMode(isDarkMode: boolean = false): void {
    // 深色模式切换，刷新纯色颜色
    if (this._isDarkMode !== isDarkMode) {
      this._isDarkMode = isDarkMode;
      this.updateInnerSolidColor();
    }
  }

  private updateInnerSolidColor(): void {
    // 刷新纯色模式颜色，受纯色计算、深色模式影响
    if (!this.isSolidEnable()) {
      return;
    }
    // 沉浸大卡背景颜色
    let cardBgColor = this.getSolidColor(SlPositionType.SL_IMMERSIVE_CARD_BG);
    if (this._cardSolidBgColor !== cardBgColor) {
      this._cardSolidBgColor = cardBgColor;
      this.notifyStateChange(SlCardStaticStPt.PT_CARD_SOLID_BG_COLOR);
    }
  }

  private getSolidColor(posType: SlPositionType): ResourceColor | undefined {
    // 对应业务纯色颜色
    return SlVisualControl.getInstance().getVisualArgs(posType)?.getSolidColor(this._isDarkMode);
  }

  private setCardSolidBgColor(solidStyle: WidgetStyleStateV2): void {
    // 赋值沉浸大卡背景纯色
    solidStyle?.setBgColor(this._cardSolidBgColor);
  }
}