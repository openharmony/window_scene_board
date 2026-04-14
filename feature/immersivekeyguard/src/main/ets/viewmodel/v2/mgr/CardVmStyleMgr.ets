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

import { ConfigurationConstant } from '@kit.AbilityKit';
import { LogDomain, Logger } from '@ohos/basicutils';
import { ConfigurationEvent } from '@ohos/frameworkwrapper';
import {
  ISlState,
  OneMirrorStaticStateType,
  ScreenBp,
  SlMainStateType,
  SlStaticStateType,
  ClockStaticStateType,
  SlSubStateType,
  StateChange,
  WProperty,
  WAnimProperty,
  WBaseProperty,
} from '@ohos/screenlockcommon';
import {
  CmpPosWrapper,
  WidgetCacheState,
  WidgetStyleStateV2,
  WidgetAnimStateV2
} from '@ohos/screenlockcommon/Index';
import {
  IBaseState,
  SlStateId,
  SlStateProperty,
  StateModeId,
  V2StateChange,
  LimitMap,
  SlCardBindStPt,
  SlCardStaticStPt,
  StateType
} from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { ImmersiveType } from '@ohos/systemuicommon';
import { CardShowType } from '../../../common/constants/ImmCardConst';
import { CardCacheSuffix, CardStyleSuffix, CARD_ALL_TYPE } from '../../../common/constants/ImmCardConst';
import { ImmersiveComHelper } from '../../../common/helper/ImmersiveComHelper';
import { ImmersiveTraceHelper } from '../../../common/helper/ImmersiveTraceHelper';
import { IImmersiveCardAnimVm } from '../../../common/interface/IImmersiveCardAnimVm';
import { IImmersiveCardVm } from '../../../common/interface/IImmersiveCardVm';
import { IImmersiveNtfVmInjector } from '../../../common/interface/IImmersiveNtfVmInjector';
import { IImmItemHelperVm } from '../../../common/interface/IImmItemHelperVm';
import { IImmStyleConfigHelper } from '../../../common/interface/IImmStyleConfigHelper';
import { ISolidVisualControl } from '../../../common/interface/ISolidVisualControl';
import { SlCardBindStateV2 } from '../../../model/data/v2/SlCardBindStateV2';
import { SlCardStaticStateV2 } from '../../../model/data/v2/SlCardStaticStateV2';
import { ImmCardItemGesture } from '../gesture/ImmCardItemGesture';
import { ImmCardLiveCardGesture } from '../gesture/ImmCardLiveCardGesture';
import { BaseVmStyleMgr, V2StateUnique } from './BaseVmStyleMgr';

const TAG = 'CardVmStyleMgr';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

// 条目样式需刷新属性集
const ITEM_STYLE_PT: WBaseProperty[] = [WBaseProperty.BORDER_RADIUS_TL, WBaseProperty.ENABLE,
  WBaseProperty.POINT_LIGHT, WBaseProperty.BACKGROUND_COLOR, WBaseProperty.BG_BRIGHTNESS_INNER];

// 条目inner样式需刷新属性集
const ITEM_INNER_STYLE_PT: WBaseProperty[] = [WBaseProperty.BACKGROUND_COLOR, WBaseProperty.ALPHA];

// 条目背景样式需刷新属性集
const ITEM_BG_STYLE_PT: WBaseProperty[] = [WBaseProperty.ALPHA];

// 条目实况卡片样式需刷新属性集
const ITEM_LIVE_STYLE_PT: WBaseProperty[] = [WBaseProperty.BORDER_RADIUS_TL, WBaseProperty.MARGIN_L,
  WBaseProperty.MARGIN_R, WBaseProperty.MARGIN_B, WBaseProperty.BACKGROUND_COLOR, WBaseProperty.BG_BLUR_STYLE,
  WBaseProperty.Z_INDEX, WBaseProperty.BG_BRIGHTNESS_INNER, WBaseProperty.COLOR_FILTER, WBaseProperty.MARK_ANCHOR,
  WBaseProperty.PADDING_L, WBaseProperty.PADDING_R, WBaseProperty.PADDING_B];

// 条目实况卡片线性渐变背景样式需刷新属性集
const ITEM_LINEAR_BG_STYLE_PT: WBaseProperty[] = [WBaseProperty.BACKGROUND_COLOR, WBaseProperty.LINEAR_GRADIENT];

// 条目实况卡片提亮背景样式需刷新属性集
const ITEM_BRIGHT_BG_STYLE_PT: WBaseProperty[] = [WBaseProperty.BACKGROUND_COLOR, WBaseProperty.BG_BRIGHTNESS_INNER,
  WBaseProperty.BG_BLUR_STYLE];

// 条目实况卡片副文本样式需刷新属性集
const ITEM_LIVE_RICH_STYLE_PT: WBaseProperty[] = [WBaseProperty.BACKGROUND_COLOR];

// 三方实况标题文本样式需刷新属性集
const OTHER_TITLE_STYLE_PT: WBaseProperty[] = [WBaseProperty.FONT_WEIGHT, WBaseProperty.FONT_SIZE,
  WBaseProperty.FONT_COLOR];

// 三方实况内容文本样式需刷新属性集
const OTHER_CONTENT_STYLE_PT: WBaseProperty[] = [WBaseProperty.FONT_SIZE, WBaseProperty.FONT_COLOR];

// 系统实况标题文、内容本样式需刷新属性集
const SYS_TITLE_CONTENT_STYLE_PT: WBaseProperty[] = [WBaseProperty.FONT_WEIGHT, WBaseProperty.FONT_SIZE,
  WBaseProperty.FONT_COLOR, WBaseProperty.FG_BRIGHTNESS, WBaseProperty.FOREGROUND_COLOR];

// 预览大图样式需刷新属性集
const PREVIEW_STYLE_PT: WBaseProperty[] = [WBaseProperty.ALPHA];

// 授权框样式需刷新属性集
const AUTHOR_STYLE_PT: WBaseProperty[] = [WBaseProperty.MAX_FONT_SCALE, WBaseProperty.WIDTH, WBaseProperty.MARGIN_L,
  WBaseProperty.MARGIN_R, WBaseProperty.MARGIN_T, WBaseProperty.MARGIN_B, WBaseProperty.BACKGROUND_COLOR];

// 扩展区样式需刷新属性集
const EXT_STYLE_PT: WBaseProperty[] = [WBaseProperty.ALPHA];

// 扩展区文本样式需刷新属性集
const EXT_TEXT_STYLE_PT: WBaseProperty[] = [WBaseProperty.FONT_COLOR, WBaseProperty.FG_BRIGHTNESS];

// 扩展区按钮样式需刷新属性集
const EXT_BTN_STYLE_PT: WBaseProperty[] = [WBaseProperty.BACKGROUND_COLOR, WBaseProperty.BG_BRIGHTNESS_INNER,
  WBaseProperty.ALPHA];

// loading样式需刷新属性集
const LOADING_STYLE_PT: WBaseProperty[] = [WBaseProperty.BACKGROUND_COLOR, WBaseProperty.WIDTH, WBaseProperty.HEIGHT,
  WBaseProperty.ITEM_SPACE];

/**
 * 沉浸大卡业务样式管理器
 */
export class CardVmStyleMgr extends BaseVmStyleMgr {
  /**
   * 系统是否深色模式
   */
  private isModeDark: boolean = false;

  /**
   * 沉浸大卡条目动态手势
   */
  protected readonly itemGestureModifier: LimitMap<CardShowType, ImmCardItemGesture> = new LimitMap();

  /**
   * 沉浸大卡实况卡片动态手势
   */
  protected readonly liveGestureModifier: LimitMap<CardShowType, ImmCardLiveCardGesture> = new LimitMap();

  /**
   * 系统Configuration配置回调
   */
  private readonly onConfigurationChange = (event: ConfigurationEvent) => {
    this.isModeDark = event?.config?.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
    // 刷新状态模式
    this.updateStateModeId();
    // 刷新纯色深色模式
    this.getCardStaticSt()?.setDarkMode(this.isModeDark);
  };

  /**
   * V1状态，屏幕断点刷新
   */
  private readonly onScreenBpChange = (state?: ISlState): void => {
    this.updateFixConfig();
    this.updateRootSize();
    this.updateRootPadding();
    this.updateItemStyle();
    this.updateInnerStyle();
    this.updateLiveStyle();
    this.updateLiveArrowStyle();
    this.updateAuthStyle();
    this.updateBackBtnStyle();
    this.updateTitleContentStyle();
    this.updateSysTitleContentStyle();
    this.updateOtherExtensionStyle();
    this.updateExtLoadingStyle();
  };

  /**
   * V1状态，时钟高度切换
   */
  private readonly onClockRegionChange = (state?: ISlState): void => {
    this.updateRootPadding();
  };

  /**
   * V1状态，时钟可见性切换
   */
  private readonly onClockVisibleChange = (state?: ISlState): void => {
    this.updateRootPadding();
  };

  /**
   * V1状态属性监听集
   */
  private readonly v1StateChange: Map<SlMainStateType, Map<SlSubStateType, StateChange>> = new Map();

  /**
   * V1状态，一镜到底动效进度变化
   */
  private readonly onOneMirrorAnimProgressChange = (state?: ISlState): void => {
    this.updateStateModeId();
  };

  /**
   * V2状态属性监听集
   */
  private readonly v2StateChange: Map<string, Map<SlStateProperty | WProperty, V2StateChange>> = new Map();

  /**
   * V2状态，沉浸态根布局动效中状态
   */
  private readonly onCardAnimChange = (state?: IBaseState): void => {
    this.updateCardVisibility();
  };

  /**
   * V2状态，大卡条目纯色颜色切换
   */
  private readonly onCardItemBgSolidChange = (state?: IBaseState): void => {
    this.updateItemStyle();
  };

  /**
   * V2状态，沉浸大卡条目动态手势禁用状态
   */
  private readonly onItemDisableGestureChange = (state?: IBaseState): void => {
    // 刷新动态手势
    let isDisableGesture = this.getCardBindSt()?.isItemDisableGesture() ?? false;
    this.itemGestureModifier.forEach((gesture) => gesture.updateGestureDisable(isDisableGesture));
  };

  /**
   * V2状态，沉浸大卡实况卡片动态手势启用状态
   */
  private readonly onLiveEnableGestureChange = (state?: IBaseState): void => {
    // 刷新动态手势
    let isEnableGesture = this.getCardBindSt()?.isLiveEnableGesture() ?? false;
    this.liveGestureModifier.forEach((gesture) => gesture.updateGestureEnable(isEnableGesture));
  };

  /**
   * V2状态，实况卡片收拢/展开状态切换
   */
  protected readonly onLiveFoldStChange = (state?: IBaseState): void => {
    this.updateLiveFoldState();
  };

  constructor(vmInjector: IImmersiveNtfVmInjector) {
    super(vmInjector);
    this.initV1StateChange();
    this.initV2StateChange();
    this.createGestureModifier();
  }

  /**
   * V1状态属性监听初始化
   */
  private initV1StateChange(): void {
    // 锁屏通用静态状态
    this.v1StateChange.set(SlMainStateType.SL_STATIC_STATE, new Map([
      [SlStaticStateType.SCREEN_BP, this.onScreenBpChange], // 屏幕断点监听
      [SlStaticStateType.CLOCK_NO_SIGN_SHOW_REGION, this.onClockRegionChange], // 时钟高度监听
    ]));
    // 一镜到底状态
    this.v1StateChange.set(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE, new Map([
      [OneMirrorStaticStateType.PT_AOD_STATE, this.onOneMirrorAnimProgressChange], // 一镜到底状态变化
    ]));
    // 时钟静态状态
    this.v1StateChange.set(SlMainStateType.SL_CLOCK_WG_STATIC_STATE, new Map([
      [ClockStaticStateType.CLOCK_VISIBLE_STATE, this.onClockVisibleChange], // 时钟可见性状态变化
    ]));
  }

  /**
   * V2状态属性监听初始化
   */
  private initV2StateChange(): void {
    // 大卡动效状态
    this.v2StateChange.set(this.getV2Key(StateType.ANIM, SlStateId.SL_CARD_STATE), new Map([
      [WAnimProperty.ANIMATING, this.onCardAnimChange], // 动效中监听
    ]));
    // 大卡UI绑定状态
    this.v2StateChange.set(this.getV2Key(StateType.BIND, SlStateId.SL_CARD_STATE), new Map([
      [SlCardBindStPt.PT_DISABLE_ITEM_GESTURE, this.onItemDisableGestureChange], // 手势禁用切换
      [SlCardBindStPt.PT_ENABLE_LIVE_GESTURE, this.onLiveEnableGestureChange], // 手势启用切换
      [SlCardBindStPt.PT_LIVE_CARD_FOLD, this.onLiveFoldStChange], // 实况卡片收拢/展开切换
    ]));
    // 大卡静态业务状态
    this.v2StateChange.set(this.getV2Key(StateType.STATIC, SlStateId.SL_CARD_STATE), new Map([
      [SlCardStaticStPt.PT_CARD_SOLID_BG_COLOR, this.onCardItemBgSolidChange], // 大卡条目纯色切换
    ]));
  }

  /**
   * 初始化
   */
  init(): void {
    super.init();
    this.eventMgr.on(ConfigurationEvent, this.onConfigurationChange);
  }

  /**
   * 请求退出沉浸态
   */
  public requestExitImmersive(): void {
    if (this.getImmState().isImmersive()) {
      log.showWarn(TAG, 'request exit immersive.');
      this.switchImmState(this.getBeforeImmState().immersiveType, undefined, true);
    }
  }

  /**
   * 刷新实况卡片收起/展开状态，用户操作状态
   *
   * @param isFold true 收拢
   * @param isAnim true 动效过渡
   */
  public updateStaticLiveFoldSt(isFold: boolean, isAnim: boolean = false): void {
    // 子类操作
  }

  /**
   * 实况卡片收拢状态复位
   *
   * @param isDelay 是否延时复位
   */
  public resetLiveFoldSt(isDelay: boolean = false): void {
    // 子类操作
  }

  /**
   * 刷新大卡条目位置
   * 影响参数：根组件位置
   */
  public updateItemPos(): void {
    let oriPos = this.getRootCacheSt()?.getWidgetPosition();
    let rootPos = CmpPosWrapper.wrapper(oriPos);
    // 根组件未初始化
    if (!rootPos.isPosValid()) {
      return;
    }
    // 条目不同类型位置相同
    let helperVm = this.getItemHelperVm();
    CARD_ALL_TYPE.forEach((cardType) => {
      let itemCache = helperVm?.getCardCacheH(CardCacheSuffix.ITEM_COMMON_CACHE).getItemSt(cardType);
      itemCache?.setWidgetPosition(oriPos);
    });
  }

  /**
   * 纯色模式控制器
   *
   * @returns 纯色控制器
   */
  protected getSolidVisualControl(): ISolidVisualControl | undefined {
    return this.getCardStaticSt();
  }

  /**
   * V1状态监听类型集
   *
   * @returns 状态集
   */
  protected getV1StateListenerTypes(): SlMainStateType[] {
    return [
      SlMainStateType.SL_STATIC_STATE,
      SlMainStateType.SL_ONE_MIRROR_STATIC_STATE,
      SlMainStateType.SL_CLOCK_WG_STATIC_STATE,
    ];
  }

  /**
   * V1状态属性监听集
   *
   * @param mainType 主类型
   * @returns 属性监听集
   */
  protected getV1StateChange(mainType: SlMainStateType): Map<SlSubStateType, StateChange> | undefined {
    return this.v1StateChange.get(mainType);
  }

  /**
   * V2状态监听类型集
   *
   * @returns 状态集
   */
  protected getV2StateListenerTypes(): V2StateUnique[] {
    return [
      {stateType: StateType.ANIM, stateId: SlStateId.SL_CARD_STATE},
      {stateType: StateType.BIND, stateId: SlStateId.SL_CARD_STATE},
      {stateType: StateType.STATIC, stateId: SlStateId.SL_CARD_STATE},
    ];
  }

  /**
   * V2状态属性监听集
   *
   * @param unique 标识
   * @returns 属性监听集
   */
  protected getV2StateChange(unique: V2StateUnique): Map<SlStateProperty | WProperty, V2StateChange> | undefined {
    return this.v2StateChange.get(this.getV2Key(unique.stateType, unique.stateId));
  }

  /**
   * 沉浸状态切换回调
   *
   * @param immType 当前状态
   */
  protected onImmersiveTypeChange(immType: ImmersiveType): void {
    log.showWarn(TAG, `onImmersiveTypeChange immType is ${immType}, ${this.vmInjector?.getStateMgr()}`);
    this.updateCardVisibility();
    let isEnterImm = immType === ImmersiveType.TYPE_IMMERSIVE;
    if (!isEnterImm) {
      // 退出沉浸态，清理数据
      this.setCurImmData();
    }
    // 刷新沉浸态壁纸
    this.updateImmWallpaper(isEnterImm);
  }

  /**
   * 沉浸大卡条目动态手势创建
   */
  protected createGestureModifier(): void {
    // 默认只需内容大卡绑定手势
    this.itemGestureModifier.set(CardShowType.CARD_CONTENT, new ImmCardItemGesture(this.vmInjector));
  }

  /**
   * 切换状态模式
   * 影响参数：系统深浅色模式，AOD场景
   */
  protected updateStateModeId(): void {
    let stateMode = this.calcStateModeId();
    if (this.stateModeId === stateMode) {
      return;
    }
    // 清除旧模式，添加新模式
    this.removeStModeId(this.stateModeId);
    this.addStModeId(stateMode);
    this.stateModeId = stateMode;
    log.showInfo(TAG, `updateStateModeId stateMode: ${stateMode}`);
    // 状态模式切换，更新相关样式配置
    this.updateItemStyle();
    this.updateInnerStyle();
    this.updateLiveStyle();
    this.updateLiveArrowStyle();
    this.updateAuthStyle();
    this.updateBackBtnStyle();
    this.updatePreviewStyle();
    this.updateTitleContentStyle();
    this.updateSysTitleContentStyle();
    this.updateOtherExtensionStyle();
    this.updateExtLoadingStyle();
  }

  /**
   * 实况卡片收拢/展开状态刷新
   */
  protected updateLiveFoldState(): void {
    // 子类处理
  }

  /**
   * 计算状态模式类型
   *
   * @returns 模式类型
   */
  private calcStateModeId(): StateModeId {
    if (this.isAOD()) {
      return StateModeId.AOD;
    }
    return this.isModeDark ? StateModeId.DARK : StateModeId.LIGHT;
  }

  /**
   * 刷新静态固定配置
   * 影响参数：屏幕断点
   */
  private updateFixConfig(): void {
    let staticSt = this.getV1State(SlMainStateType.SL_STATIC_STATE);
    let screenBp = staticSt?.getSlState(SlStaticStateType.SCREEN_BP) as ScreenBp;
    let cardConfig = this.getStyleCfHelper()?.getCardConfig(screenBp?.bpSplice);
    this.getCardBindSt()?.setBackBtnEnable(cardConfig?.isBackBtnEnable());
    this.getCardBindSt()?.setLiveBgBlurEnable(cardConfig?.isLiveBgBlurEnable());
    this.getCardBindSt()?.setLiveArrowEnable(cardConfig?.isLiveArrowEnable());
    this.getCardBindSt()?.setContentFullEnable(cardConfig?.isContentFullEnable());
    this.getCardBindSt()?.setHideAuthImg(cardConfig?.isHideAuthImg());
    this.getCardBindSt()?.setItemClickInner(cardConfig?.isItemCLickInner());
    this.getCardBindSt()?.setItemGestureDisable(cardConfig?.isItemDisableGesture());
    this.getCardBindSt()?.setLiveGestureEnable(cardConfig?.isLiveEnableGesture());
    this.getCardBindSt()?.setHideItemBg(cardConfig?.isHideItemBg());
    this.getCardStaticSt()?.setLiveCachePosEnable(cardConfig?.isLiveCachePosEnable());
    this.getCardStaticSt()?.setFoldOuter(cardConfig?.isFoldOuter());
  }

  /**
   * 刷新沉浸大卡root宽高
   * 影响参数：屏幕断点
   */
  private updateRootSize(): void {
    let staticSt = this.getV1State(SlMainStateType.SL_STATIC_STATE);
    let screenBp = staticSt?.getSlState(SlStaticStateType.SCREEN_BP) as ScreenBp;
    let defaultStyle = this.getStyleCfHelper()?.getCardRootStyle(screenBp?.bpSplice);
    let cardConfig = this.getStyleCfHelper()?.getCardConfig(screenBp?.bpSplice);
    let rootStyle = this.getRootStyleSt();
    let gutterCf = cardConfig?.getGutterConfig();
    let defaultWidth = defaultStyle?.getWidth() ?? '100%';
    let defaultHeight = defaultStyle?.getHeight() ?? '100%';
    // 非栅格计算场景，保持占用
    if (!gutterCf) {
      rootStyle?.setWidth(defaultWidth).setHeight(defaultHeight);
      return;
    }
    // 栅格计算宽度
    let isUseHeight = cardConfig?.isGutterHeightEnable() ?? false;
    let screenWidth = screenBp?.screenWidth ?? 0;
    let screenHeight = screenBp?.screenHeight ?? 0;
    let columnWidth = gutterCf.getColumnWidth(isUseHeight ? screenHeight : screenWidth);
    // 栅格取值高度
    let columnHeight: string | number = defaultHeight;
    let calcHeight = cardConfig?.getCalcGutterHeight();
    if (calcHeight) {
      columnHeight = calcHeight(columnWidth);
    }
    rootStyle?.setWidth(columnWidth).setHeight(columnHeight);
    log.showInfo(TAG, `updateRootSize width: ${columnWidth}, height: ${columnHeight}`);
  }

  /**
   * 刷新沉浸大卡root间距
   * 影响参数：屏幕断点，时钟收起态高度
   */
  private updateRootPadding(): void {
    let screenBp = this.getScreenBp();
    let cardStyle = this.getStyleCfHelper()?.getCardRootStyle(screenBp?.bpSplice);
    let cardConfig = this.getStyleCfHelper()?.getCardConfig(screenBp?.bpSplice);
    // 时钟高度回调开关控制
    let clockHeight = cardConfig?.getTopClockHeight() ?? 0;
    if (!cardConfig?.isClockHeightDisable()) {
      let clockRegionHeight = this.getClockHeight(true);
      if (clockRegionHeight !== 0 && this.isClockVisible()) {
        clockHeight = clockRegionHeight;
      }
    }
    let toolsHeight = cardConfig?.getBottomToolsHeight() ?? 0;
    let resultTop = clockHeight + (cardStyle?.getPaddingT() ?? 0);
    let resultBottom = toolsHeight + (cardStyle?.getPaddingB() ?? 0);
    // 刷新列表间距
    let style = this.getRootStyleSt();
    if (style?.getPaddingT() !== resultTop) {
      style?.setPaddingT(resultTop);
      log.showInfo(TAG, `refreshListPadding top: ${resultTop}`);
    }
    style?.setPaddingB(resultBottom)
      .setPaddingL(cardStyle?.getPaddingL())
      .setPaddingR(cardStyle?.getPaddingR());
  }

  /**
   * 刷新沉浸大卡条目样式
   * 影响参数：屏幕断点，深浅色、AOD等状态模式
   */
  private updateItemStyle(): void {
    let screenBp = this.getScreenBp();
    let configH = this.getStyleCfHelper();
    let comStyleH = this.getItemHelperVm()?.getCardStyleH(CardStyleSuffix.ITEM_COMMON_STYLE);
    let bgCfgStyle = configH?.getCardComViewStyle(CardStyleSuffix.ITEM_BG_STYLE, screenBp?.bpSplice);
    let bgStyleH = this.getItemHelperVm()?.getCardStyleH(CardStyleSuffix.ITEM_BG_STYLE);
    CARD_ALL_TYPE.forEach((type) => {
      let defaultStyle = configH?.getCardItemStyle(type, screenBp?.bpSplice);
      // 优先刷新纯色模式样式的配置
      this.updateSolidCfgStyle(defaultStyle);
      let comStyle = comStyleH?.getItemSt(type);
      ITEM_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, comStyle, defaultStyle));
      // 绑定动态手势
      comStyle?.setGestureModifier(this.itemGestureModifier.get(type));

      // 条目背景、内容样式配置
      let bgStyle = bgStyleH?.getItemSt(type);
      ITEM_BG_STYLE_PT.forEach((pt) => {
        this.setStyleProperty(pt, bgStyle, bgCfgStyle);
      });
    });
  }

  /**
   * 刷新通用布局inner样式
   * 影响参数：屏幕断点，深浅色、AOD等状态模式
   */
  private updateInnerStyle(): void {
    let screenBp = this.getScreenBp();
    let configH = this.getStyleCfHelper();
    let defaultStyle = configH?.getCardComViewStyle(CardStyleSuffix.ITEM_INNER_STYLE, screenBp?.bpSplice);
    let innerStyleH = this.getItemHelperVm()?.getCardStyleH(CardStyleSuffix.ITEM_INNER_STYLE);
    CARD_ALL_TYPE.forEach((type) => {
      let innerStyle = innerStyleH?.getItemSt(type);
      ITEM_INNER_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, innerStyle, defaultStyle));
    });
  }

  /**
   * 刷新通用布局实况卡片样式
   * 影响参数：屏幕断点，深浅色、AOD等状态模式
   */
  protected updateLiveStyle(): void {
    let screenBp = this.getScreenBp();
    let configH = this.getStyleCfHelper();
    let defaultStyle = configH?.getCardComViewStyle(CardStyleSuffix.ITEM_LIVE_STYLE, screenBp?.bpSplice);
    let liveStyleH = this.getItemHelperVm()?.getCardStyleH(CardStyleSuffix.ITEM_LIVE_STYLE);
    let linearCfgStyle = configH?.getCardComViewStyle(CardStyleSuffix.ITEM_LINEAR_BG_STYLE, screenBp?.bpSplice);
    let linearStyleH = this.getItemHelperVm()?.getCardStyleH(CardStyleSuffix.ITEM_LINEAR_BG_STYLE);
    let brightCfgStyle = configH?.getCardComViewStyle(CardStyleSuffix.ITEM_BRIGHT_BG_STYLE, screenBp?.bpSplice);
    let brightStyleH = this.getItemHelperVm()?.getCardStyleH(CardStyleSuffix.ITEM_BRIGHT_BG_STYLE);
    let richCfgStyle = configH?.getCardComViewStyle(CardStyleSuffix.ITEM_LIVE_RICH_STYLE, screenBp?.bpSplice);
    let richStyleH = this.getItemHelperVm()?.getCardStyleH(CardStyleSuffix.ITEM_LIVE_RICH_STYLE);
    CARD_ALL_TYPE.forEach((type) => {
      let liveStyle = liveStyleH?.getItemSt(type);
      let linearStyle = linearStyleH?.getItemSt(type);
      let brightStyle = brightStyleH?.getItemSt(type);
      let richStyle = richStyleH?.getItemSt(type);
      ITEM_LIVE_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, liveStyle, defaultStyle));
      // 绑定动态手势
      liveStyle?.setGestureModifier(this.liveGestureModifier.get(type));
      ITEM_LINEAR_BG_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, linearStyle, linearCfgStyle));
      ITEM_BRIGHT_BG_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, brightStyle, brightCfgStyle));
      ITEM_LIVE_RICH_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, richStyle, richCfgStyle));
    });
  }

  /**
   * 更新通用布局文本样式
   * 影响参数：屏幕断点，状态模式
   */
  private updateTitleContentStyle(): void {
    let screenBp = this.getScreenBp();
    let cfHelper = this.getStyleCfHelper();
    let titleCfgStyle = cfHelper.getCardComViewStyle(CardStyleSuffix.ITEM_MAIN_TEXT_STYLE, screenBp?.bpSplice);
    let contentCfgStyle = cfHelper.getCardComViewStyle(CardStyleSuffix.ITEM_SECONDARY_TEXT_STYLE, screenBp?.bpSplice);
    let titleH = this.getItemHelperVm()?.getCardStyleH(CardStyleSuffix.ITEM_MAIN_TEXT_STYLE);
    let contentH = this.getItemHelperVm()?.getCardStyleH(CardStyleSuffix.ITEM_SECONDARY_TEXT_STYLE);
    CARD_ALL_TYPE.forEach((cardType) => {
      // 主文本样式预置
      let titleStyle = titleH?.getItemSt(cardType);
      OTHER_TITLE_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, titleStyle, titleCfgStyle));

      // 副文本样式配置
      let contentStyle = contentH?.getItemSt(cardType);
      OTHER_CONTENT_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, contentStyle, contentCfgStyle));
    });
  }

  /**
   * 更新导航通用布局主文本样式
   * 影响参数：屏幕断点，状态模式
   */
  private updateSysTitleContentStyle(): void {
    let screenBp = this.getScreenBp();
    let cfHelper = this.getStyleCfHelper();
    let titleCfgStyle = cfHelper.getCardComViewStyle(CardStyleSuffix.ITEM_SYS_MAIN_TEXT_STYLE, screenBp?.bpSplice);
    let titleH = this.getItemHelperVm()?.getCardStyleH(CardStyleSuffix.ITEM_SYS_MAIN_TEXT_STYLE);
    let contentCfgStyle =
      cfHelper.getCardComViewStyle(CardStyleSuffix.ITEM_SYS_SECONDARY_TEXT_STYLE, screenBp?.bpSplice);
    let contentH = this.getItemHelperVm()?.getCardStyleH(CardStyleSuffix.ITEM_SYS_SECONDARY_TEXT_STYLE);
    CARD_ALL_TYPE.forEach((cardType) => {
      // 主副文本样式预置
      let titleStyle = titleH?.getItemSt(cardType);
      let contentStyle = contentH?.getItemSt(cardType);
      SYS_TITLE_CONTENT_STYLE_PT.forEach((pt) => {
        this.setStyleProperty(pt, titleStyle, titleCfgStyle);
        this.setStyleProperty(pt, contentStyle, contentCfgStyle);
      });
    });
  }

  /**
   * 刷新通用布局定位权限授权样式
   * 影响参数：屏幕断点，深浅色、AOD等状态模式
   */
  private updateAuthStyle(): void {
    let screenBp = this.getScreenBp();
    let configH = this.getStyleCfHelper();
    let defaultStyle = configH?.getCardComViewStyle(CardStyleSuffix.ITEM_AUTH_STYLE, screenBp?.bpSplice);
    let authStyleH = this.getItemHelperVm()?.getCardStyleH(CardStyleSuffix.ITEM_AUTH_STYLE);
    CARD_ALL_TYPE.forEach((type) => {
      let authStyle = authStyleH?.getItemSt(type);
      AUTHOR_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, authStyle, defaultStyle));
    });
  }

  /**
   * 刷新条目返回按钮样式，通用大卡不涉及
   * 影响参数：屏幕断点，深浅色、AOD等状态模式
   */
  protected updateBackBtnStyle(): void {
  }

  /**
   * 刷新实况卡片顶部箭头样式，通用大卡不涉及
   * 影响参数：屏幕断点，深浅色、AOD、收拢/展开等状态模式
   */
  protected updateLiveArrowStyle(): void {
  }

  /**
   * 刷新预览图样式
   * 影响参数：深浅色、AOD等状态模式
   */
  private updatePreviewStyle(): void {
    let screenBp = this.getScreenBp();
    let configH = this.getStyleCfHelper();
    let defaultStyle = configH?.getCardComViewStyle(CardStyleSuffix.ITEM_PREVIEW_STYLE, screenBp?.bpSplice);
    let previewStyleH = this.getItemHelperVm()?.getCardStyleH(CardStyleSuffix.ITEM_PREVIEW_STYLE);
    CARD_ALL_TYPE.forEach((type) => {
      let previewStyle = previewStyleH?.getItemSt(type);
      PREVIEW_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, previewStyle, defaultStyle));
    });
  }

  /**
   * 刷新大卡可见性
   * 影响参数：动效中状态，沉浸状态
   */
  protected updateCardVisibility(): void {
    let cardVisibility = this.getCardVisibility();
    let style = this.getRootStyleSt();
    if (style?.getVisibility() !== cardVisibility) {
      log.showInfo(TAG, `refresh card Visibility cardVisibility: ${cardVisibility}, ${this.vmInjector?.getStateMgr()}`);
      ImmersiveTraceHelper.startTrace('updateCardVisibility_' + cardVisibility);
      style?.setVisibility(cardVisibility);
      ImmersiveTraceHelper.endTrace('updateCardVisibility_' + cardVisibility);
      // 列表态，更新back手势使能
      if (cardVisibility === Visibility.Visible) {
        ImmersiveComHelper.enableBackGesture(true);
      }
    }
  }

  /**
   * 更新通用三方大卡布局扩展区样式
   * 影响参数：屏幕断点，AOD状态模式
   */
  private updateOtherExtensionStyle(): void {
    let screenBp = this.getScreenBp();
    let cfHelper = this.getStyleCfHelper();
    let extCfgStyle = cfHelper.getCardComViewStyle(CardStyleSuffix.ITEM_OTHER_EXTEND_STYLE, screenBp?.bpSplice);
    let extWantCfgStyle =
      cfHelper.getCardComViewStyle(CardStyleSuffix.ITEM_OTHER_EXTEND_WANT_STYLE, screenBp?.bpSplice);
    let extTextCfgStyle =
      cfHelper.getCardComViewStyle(CardStyleSuffix.ITEM_OTHER_EXTEND_TEXT_STYLE, screenBp?.bpSplice);
    let extBtnCfgStyle = cfHelper.getCardComViewStyle(CardStyleSuffix.ITEM_OTHER_EXTEND_BTN_STYLE, screenBp?.bpSplice);
    let extStyleH = this.getItemHelperVm()?.getCardStyleH(CardStyleSuffix.ITEM_OTHER_EXTEND_STYLE);
    let extWantStyleH = this.getItemHelperVm()?.getCardStyleH(CardStyleSuffix.ITEM_OTHER_EXTEND_WANT_STYLE);
    let extTextStyleH = this.getItemHelperVm()?.getCardStyleH(CardStyleSuffix.ITEM_OTHER_EXTEND_TEXT_STYLE);
    let extBtnStyleH = this.getItemHelperVm()?.getCardStyleH(CardStyleSuffix.ITEM_OTHER_EXTEND_BTN_STYLE);
    CARD_ALL_TYPE.forEach((cardType) => {
      // 扩展区样式预置，扩展区wantAgent样式预置
      let extStyle = extStyleH?.getItemSt(cardType);
      let extWantStyle = extWantStyleH?.getItemSt(cardType);
      EXT_STYLE_PT.forEach((pt) => {
        this.setStyleProperty(pt, extStyle, extCfgStyle);
        this.setStyleProperty(pt, extWantStyle, extWantCfgStyle);
      });

      // 扩展区文本样式预置
      let extTextStyle = extTextStyleH?.getItemSt(cardType);
      EXT_TEXT_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, extTextStyle, extTextCfgStyle));

      // 扩展区按钮样式预置
      let extBtnStyle = extBtnStyleH?.getItemSt(cardType);
      EXT_BTN_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, extBtnStyle, extBtnCfgStyle));
    });
  }

  /**
   * 更新通用三方大卡uiExtension loading布局样式
   * 影响参数：屏幕断点，AOD状态模式
   */
  private updateExtLoadingStyle(): void {
    let screenBp = this.getScreenBp();
    let cfHelper = this.getStyleCfHelper();
    let extLoadingCfgStyle =
      cfHelper.getCardComViewStyle(CardStyleSuffix.ITEM_EXTENSION_LOADING_STYLE, screenBp?.bpSplice);
    let extLoadingStyleH = this.getItemHelperVm()?.getCardStyleH(CardStyleSuffix.ITEM_EXTENSION_LOADING_STYLE);
    CARD_ALL_TYPE.forEach((cardType) => {
      // 样式预置
      let loadingStyle = extLoadingStyleH?.getItemSt(cardType);
      LOADING_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, loadingStyle, extLoadingCfgStyle));
    });
  }

  /**
   * 沉浸大卡可见性
   *
   * @returns 可见性
   */
  private getCardVisibility(): Visibility {
    // 动效期间保持可见
    if (this.getRootAnimSt()?.isWidgetAnimating()) {
      return Visibility.Visible;
    }
    // 沉浸卡片态，保持可见
    return this.immersiveState?.isShowCard() ? Visibility.Visible : Visibility.Hidden;
  }

  protected getCardStaticSt(): SlCardStaticStateV2 {
    return this.getCardVm()?.getSlStaticState() as SlCardStaticStateV2;
  }

  protected getCardBindSt(): SlCardBindStateV2 {
    return this.getCardVm()?.getSlBindState() as SlCardBindStateV2;
  }

  protected getRootAnimSt(): WidgetAnimStateV2 {
    return this.getCardVm()?.getSlAnimState();
  }

  protected getRootStyleSt(): WidgetStyleStateV2 {
    return this.getCardVm()?.getSlStyleState();
  }

  protected getRootCacheSt(): WidgetCacheState {
    return this.getCardVm()?.getSlCacheState();
  }

  protected getCardVm(): IImmersiveCardVm {
    return this.vmInjector?.getImmersiveCardVm();
  }

  protected getCardAnimVm(): IImmersiveCardAnimVm {
    return this.vmInjector?.getImmersiveCardAnimVm();
  }

  protected getStyleCfHelper(): IImmStyleConfigHelper {
    return this.vmInjector?.getImmStyleConfigHelper();
  }

  protected getItemHelperVm(): IImmItemHelperVm {
    return this.vmInjector?.getImmItemHelperVm();
  }
}