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

import { AccessibilityUtil, WBaseProperty } from '@ohos/screenlockcommon';
import { StateModeId } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { AnimEvent } from '@ohos/screenlockcommon/Index';
import {
  ImmersiveType,
  ImmersiveTypeScene,
  LiveViewRequestEnterImmersiveEvent,
  LiveViewRequestExitImmersiveEvent
} from '@ohos/systemuicommon';
import { ResUtils } from '@ohos/windowscene';
import { CardShowType } from '../../../../common/constants/ImmCardConst';
import { CardStyleSuffix, CARD_ALL_TYPE } from '../../../../common/constants/ImmCardConst';
import { IImmersiveDataVm } from '../../../../common/interface/IImmersiveDataVm';
import { ImmCardLiveCardGesture } from '../../gesture/ImmCardLiveCardGesture';
import { CardVmStyleMgr } from '../CardVmStyleMgr';

// 返回按钮样式需刷新属性集
const BACK_BTN_STYLE_PT: WBaseProperty[] = [WBaseProperty.WIDTH, WBaseProperty.HEIGHT, WBaseProperty.BG_WIDTH,
  WBaseProperty.BG_HEIGHT, WBaseProperty.BG_EFFECT, WBaseProperty.MARGIN_L, WBaseProperty.MARGIN_T,
  WBaseProperty.BORDER_RADIUS_TL, WBaseProperty.ACCESSIBILITY_LEVEL, WBaseProperty.ACCESSIBILITY_TEXT,
  WBaseProperty.FG_BRIGHTNESS, WBaseProperty.FOREGROUND_COLOR, WBaseProperty.BACKGROUND_COLOR,
  WBaseProperty.BG_BRIGHTNESS_INNER, WBaseProperty.ALPHA];

// 实况卡片箭头样式需刷新属性集
const LIVE_ARROW_STYLE_PT: WBaseProperty[] = [WBaseProperty.WIDTH, WBaseProperty.HEIGHT, WBaseProperty.FILL_COLOR,
  WBaseProperty.MARGIN_T, WBaseProperty.MARGIN_B, WBaseProperty.ACCESSIBILITY_TEXT, WBaseProperty.IMG_SRC];

// 实况卡片收拢复位延时任务时长
const LIVE_FOLD_DELAY_TIME: number = 400;

/**
 * 外屏沉浸大卡业务样式管理器
 */
export class OuterCardVmStyleMgr extends CardVmStyleMgr {
  // 实况卡片收拢延时任务ID
  private foldDelayId?: number;

  /**
   * 实况列表进入沉浸态
   */
  private readonly onLiveListEnterImm = (event: LiveViewRequestEnterImmersiveEvent) => {
    let groupKey = this.getGroupKeyByHashcode(event?.hashCode);
    if (groupKey) {
      this.getCardVm()?.onLiveListToImmCard?.(groupKey, ImmersiveTypeScene.SCENE_LIVE_LIST_CARD);
    }
  };

  /**
   * 沉浸态退出到实况列表
   */
  private readonly onImmExitLiveList = (event: LiveViewRequestExitImmersiveEvent) => {
    this.getCardVm()?.onExitImmState(false, ImmersiveTypeScene.SCENE_LIVE_CAP_LIST);
  };

  /**
   * 初始化
   */
  public init(): void {
    super.init();
    this.eventMgr.on(LiveViewRequestEnterImmersiveEvent, this.onLiveListEnterImm)
      .on(LiveViewRequestExitImmersiveEvent, this.onImmExitLiveList);
  }

  /**
   * 刷新实况卡片收起/展开状态，用户操作状态
   *
   * @param isFold true 收拢
   * @param isAnim true 动效过渡
   */
  public updateStaticLiveFoldSt(isFold: boolean, isAnim: boolean = false): void {
    if (this.getCardStaticSt()?.setLiveCardFold(isFold) && isAnim) {
      // 用户操作，无障碍播报提醒
      AccessibilityUtil.sendAccessibility(isFold ?
        ResUtils.getInnerString($r('app.string.immersive_card_tip_status_down')) :
        ResUtils.getInnerString($r('app.string.immersive_card_tip_status_up')));
    }
    this.updateBindLiveFoldSt(isAnim);
  }

  /**
   * 收拢状态复位
   *
   * @param isDelay true延时复位
   */
  public resetLiveFoldSt(isDelay: boolean = false): void {
    this.clearLiveFoldDelay();
    if (isDelay) {
      this.foldDelayId = setTimeout(() => {
        this.clearLiveFoldDelay();
        this.updateStaticLiveFoldSt(false, false);
      }, LIVE_FOLD_DELAY_TIME);
    } else {
      this.updateStaticLiveFoldSt(false, false);
    }
  }

  protected onImmersiveTypeChange(immType: ImmersiveType): void {
    super.onImmersiveTypeChange(immType);
    // 退出沉浸态时，延时复位收拢状态
    if (!this.getImmState()?.isImmersive()) {
      this.resetLiveFoldSt(true);
    }
  }

  protected createGestureModifier(): void {
    // 小外屏仅实况卡片下滑手势
    this.liveGestureModifier.set(CardShowType.CARD_CONTENT, new ImmCardLiveCardGesture(this.vmInjector));
  }

  protected updateStateModeId(): void {
    super.updateStateModeId();
    // 同步刷新收拢/展开状态
    this.updateBindLiveFoldSt();
  }

  protected updateLiveFoldState(): void {
    // 刷新模式ID
    let isLiveFold = this.getCardBindSt()?.isLiveCardFold() ?? false;
    if (isLiveFold) {
      this.addStModeId(StateModeId.LIVE_FOLD);
    } else {
      this.removeStModeId(StateModeId.LIVE_FOLD);
    }
    // 刷新相关UI样式
    this.updateLiveStyle();
    this.updateLiveArrowStyle();
  }

  /**
   * 外屏大卡可见性
   */
  protected updateCardVisibility(): void {
    super.updateCardVisibility();
    // 同步刷新返回按钮可见性
    this.updateBackBtnVisibility();
  }

  /**
   * 刷新条目返回按钮样式
   * 影响参数：屏幕断点，深浅色、AOD等状态模式
   */
  protected updateBackBtnStyle(): void {
    let screenBp = this.getScreenBp();
    let configH = this.getStyleCfHelper();
    let defaultStyle = configH?.getCardComViewStyle(CardStyleSuffix.ITEM_BACK_STYLE, screenBp?.bpSplice);
    let backStyleH = this.getItemHelperVm()?.getCardStyleH(CardStyleSuffix.ITEM_BACK_STYLE);
    // 优先刷新纯色模式样式的配置
    this.updateSolidCfgStyle(defaultStyle);
    CARD_ALL_TYPE.forEach((type) => {
      let backStyle = backStyleH?.getItemSt(type);
      BACK_BTN_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, backStyle, defaultStyle));
    });
  }

  /**
   * 刷新实况卡片顶部箭头样式，通用大卡不涉及
   * 影响参数：屏幕断点，深浅色、AOD、收拢/展开等状态模式
   */
  protected updateLiveArrowStyle(): void {
    let screenBp = this.getScreenBp();
    let configH = this.getStyleCfHelper();
    let defaultStyle = configH?.getCardComViewStyle(CardStyleSuffix.ITEM_LIVE_ARROW_STYLE, screenBp?.bpSplice);
    let arrowStyleH = this.getItemHelperVm()?.getCardStyleH(CardStyleSuffix.ITEM_LIVE_ARROW_STYLE);
    CARD_ALL_TYPE.forEach((type) => {
      let arrowStyle = arrowStyleH?.getItemSt(type);
      LIVE_ARROW_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, arrowStyle, defaultStyle));
    });
  }

  /**
   * 刷新条目返回按钮可见性
   */
  private updateBackBtnVisibility(): void {
    let visibility = this.getImmState()?.isImmersive() ? Visibility.Visible : Visibility.None;
    let backStyleH = this.getItemHelperVm()?.getCardStyleH(CardStyleSuffix.ITEM_BACK_STYLE);
    CARD_ALL_TYPE.forEach((type) => {
      let backStyle = backStyleH?.getItemSt(type);
      backStyle?.setVisibility(visibility);
    });
  }

  private updateBindLiveFoldSt(isAnim: boolean = false): void {
    let isResultFold = this.isLiveResultFold();
    let isCurFold = this.getCardBindSt()?.isLiveCardFold();
    if (isResultFold === isCurFold) {
      return;
    }
    let endEvent: AnimEvent = () => {
      this.getCardBindSt()?.setLiveCardFold(this.isLiveResultFold());
    };
    // 动画过渡
    if (isAnim) {
      this.getCardAnimVm()?.startLiveCardFoldAnim(endEvent);
    } else {
      endEvent();
    }
  }

  private isLiveResultFold(): boolean {
    // AOD时强制展开，非AOD时按用户操作记录
    let isUserFold = this.getCardStaticSt()?.isLiveCardFold() ?? false;
    return !this.isAOD() && isUserFold;
  }

  private clearLiveFoldDelay(): void {
    if (this.foldDelayId) {
      clearTimeout(this.foldDelayId);
      this.foldDelayId = undefined;
    }
  }

  private getGroupKeyByHashcode(hashcode?: string): string | undefined {
    if (!hashcode) {
      return undefined;
    }
    let data = this.getImmDataVm()?.getNtfByHashCode(hashcode);
    return data?.groupKey;
  }

  private getImmDataVm(): IImmersiveDataVm | undefined {
    return this.vmInjector?.getImmDataVm();
  }
}