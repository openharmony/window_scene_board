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

import { LogDomain, Logger } from '@ohos/basicutils';
import {
  ClockStaticStateType,
  CommonConstants,
  ISlState,
  OneMirrorStaticStateType,
  SlBindStateType,
  SlMainStateType,
  SlStaticStateType,
  SlSubStateType,
  StateChange,
  WAnimProperty,
  WProperty,
  WBaseProperty,
} from '@ohos/screenlockcommon';
import {
  CmpPosWrapper,
  ComponentPosition,
  WidgetAnimStateV2,
  WidgetCacheState,
  WidgetStyleStateV2
} from '@ohos/screenlockcommon/Index';
import {
  IBaseState,
  SlStateId,
  SlStateProperty,
  StateModeId,
  StateType,
  V2StateChange,
  SlCapStaticStPt,
  SlCapBindStPt,
  SlCardStaticStPt
} from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { ImmersiveType } from '@ohos/systemuicommon';
import {
  CAP_ALL_TYPE,
  CapStyleSuffix,
  CapCacheSuffix,
  CapAnimSuffix,
  CapShowType
} from '../../../common/constants/ImmCapConst';
import { ImmersiveComHelper } from '../../../common/helper/ImmersiveComHelper';
import { IImmCapRemindVm } from '../../../common/interface/IImmCapRemindVm';
import { IImmersiveCapVm } from '../../../common/interface/IImmersiveCapVm';
import { IImmersiveNtfVmInjector } from '../../../common/interface/IImmersiveNtfVmInjector';
import { IImmItemHelperVm } from '../../../common/interface/IImmItemHelperVm';
import { IImmStyleConfigHelper } from '../../../common/interface/IImmStyleConfigHelper';
import { ISolidVisualControl } from '../../../common/interface/ISolidVisualControl';
import { SlCapWidgetBindState } from '../../../model/data/SlCapWidgetBindState';
import { SlCapBindStateV2 } from '../../../model/data/v2/SlCapBindStateV2';
import { SlCapStaticStateV2 } from '../../../model/data/v2/SlCapStaticStateV2';
import { BaseVmStyleMgr, V2StateUnique } from './BaseVmStyleMgr';

const TAG = 'CapVmStyleMgr';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

// 默认显示按钮数
const BTN_DEFAULT_COUNT = 1;

// 条目样式需刷新属性集
const ITEM_STYLE_PT: WBaseProperty[] = [WBaseProperty.HEIGHT, WBaseProperty.PADDING_L, WBaseProperty.PADDING_R,
  WBaseProperty.BORDER_RADIUS_TL, WBaseProperty.MARGIN_T, WBaseProperty.MARGIN_L, WBaseProperty.MARGIN_R,
  WBaseProperty.VISIBILITY, WBaseProperty.ENABLE, WBaseProperty.ACCESSIBILITY_LEVEL, WBaseProperty.POINT_LIGHT,
  WBaseProperty.BACKGROUND_COLOR, WBaseProperty.BG_BRIGHTNESS_INNER, WBaseProperty.USE_EFFECT, WBaseProperty.Z_INDEX];

// 主副文本样式需刷新属性集
const TITLE_CONTENT_TEXT_STYLE_PT: WBaseProperty[] = [WBaseProperty.FONT_SIZE, WBaseProperty.MIN_FONT_SIZE,
  WBaseProperty.MIN_FONT_SCALE, WBaseProperty.MAX_FONT_SCALE, WBaseProperty.HEIGHT, WBaseProperty.MARGIN_L,
  WBaseProperty.MARGIN_R, WBaseProperty.FONT_COLOR, WBaseProperty.FG_BRIGHTNESS];

// 大图标样式需刷新属性集
const LARGE_ICON_STYLE_PT: WBaseProperty[] = [WBaseProperty.WIDTH, WBaseProperty.HEIGHT, WBaseProperty.COLOR_FILTER,
  WBaseProperty.BORDER_RADIUS_TL, WBaseProperty.MARGIN_T, WBaseProperty.MARGIN_B, WBaseProperty.ALPHA];

// 小图标样式需刷新属性集
const SMALL_ICON_STYLE_PT: WBaseProperty[] = [WBaseProperty.WIDTH, WBaseProperty.HEIGHT,
  WBaseProperty.BORDER_RADIUS_TL, WBaseProperty.BORDER_RADIUS_TR, WBaseProperty.BORDER_RADIUS_BL,
  WBaseProperty.BORDER_RADIUS_BR, WBaseProperty.OFFSET, WBaseProperty.ALPHA];

// 小图标背景样式需刷新属性集
const SMALL_ICON_BG_STYLE_PT: WBaseProperty[] = [WBaseProperty.WIDTH, WBaseProperty.HEIGHT,
  WBaseProperty.BORDER_RADIUS_TL, WBaseProperty.BORDER_RADIUS_TR, WBaseProperty.BORDER_RADIUS_BL,
  WBaseProperty.BORDER_RADIUS_BR, WBaseProperty.OFFSET, WBaseProperty.VISIBILITY, WBaseProperty.BACKGROUND_COLOR];

// 小图标样式需刷新属性集
const SMALL_ICON_REVERSE_STYLE_PT: WBaseProperty[] = [WBaseProperty.WIDTH, WBaseProperty.HEIGHT, WBaseProperty.OFFSET,
  WBaseProperty.FILL_COLOR];

// 小图标背景样式需刷新属性集
const SMALL_ICON_BG_REVERSE_STYLE_PT: WBaseProperty[] = [WBaseProperty.WIDTH, WBaseProperty.HEIGHT,
  WBaseProperty.BORDER_RADIUS_TL, WBaseProperty.BORDER_RADIUS_TR, WBaseProperty.BORDER_RADIUS_BL,
  WBaseProperty.BORDER_RADIUS_BR, WBaseProperty.OFFSET, WBaseProperty.VISIBILITY, WBaseProperty.BACKGROUND_COLOR,
  WBaseProperty.ALPHA];

// 扩展区通用样式需刷新属性集
const EXT_COM_STYLE_PT: WBaseProperty[] = [WBaseProperty.ITEM_SPACE, WBaseProperty.WIDTH, WBaseProperty.HEIGHT,
  WBaseProperty.MARGIN_L, WBaseProperty.MARGIN_T, WBaseProperty.MARGIN_B, WBaseProperty.ALPHA];

// 扩展区文本样式需刷新属性集
const EXT_TEXT_STYLE_PT: WBaseProperty[] = [WBaseProperty.WIDTH, WBaseProperty.HEIGHT, WBaseProperty.MAX_FONT_SIZE,
  WBaseProperty.MIN_FONT_SIZE, WBaseProperty.FONT_COLOR, WBaseProperty.FG_BRIGHTNESS];

// 扩展区按钮样式需刷新属性集
const EXT_BTN_STYLE_PT: WBaseProperty[] = [WBaseProperty.HEIGHT, WBaseProperty.BG_WIDTH, WBaseProperty.BG_HEIGHT,
  WBaseProperty.MARGIN_L, WBaseProperty.MARGIN_T, WBaseProperty.BACKGROUND_COLOR, WBaseProperty.BG_BRIGHTNESS_INNER,
  WBaseProperty.ALPHA];

// 胶囊按钮样式需刷新属性集
const BTN_STYLE_PT: WBaseProperty[] = [WBaseProperty.WIDTH, WBaseProperty.HEIGHT, WBaseProperty.BACKGROUND_COLOR,
  WBaseProperty.BG_BRIGHTNESS_INNER, WBaseProperty.ALPHA];

/**
 * 胶囊业务样式管理器
 */
export class CapVmStyleMgr extends BaseVmStyleMgr {
  /**
   * V1状态，屏幕断点刷新
   */
  private readonly onScreenBpChange = (state?: ISlState): void => {
    this.updateCapSize();
    this.updateCapShowNum();
    this.updateItemStyle();
    this.updateTitleContentStyle();
    this.updateIconStyle();
    this.updateIconReverseStyle();
    this.updateExtensionStyle();
    this.updateBtnStyle();
  };

  /**
   * V1状态，壁纸深浅色切换
   */
  private readonly onWallpaperLightChange = (state?: ISlState): void => {
    this.updateStateModeId();
  };

  /**
   * V1状态，一镜到底动效进度变化
   */
  private readonly onOneMirrorAnimProgressChange = (state?: ISlState): void => {
    this.updateStateModeId();
    // 记录AOD状态
    this.getCapRemindVm()?.onAodStateChange(this.isAOD());
  };

  /**
   * V1状态属性监听集
   */
  private readonly v1StateChange: Map<SlMainStateType, Map<SlSubStateType, StateChange>> = new Map();

  /**
   * V2状态，胶囊动效状态动效中切换
   */
  private readonly onCapAnimChange = (state?: IBaseState): void => {
    this.updateCapVisibility();
  };

  /**
   * V2状态，强提醒胶囊动效状态动效中切换
   */
  private readonly onRemindCapAnimChange = (state?: IBaseState): void => {
    let remindSt = this.getItemComAnim(CapShowType.CAP_REMIND);
    this.getCapRemindVm()?.onRemindAnimStChange(remindSt?.isWidgetAnimating());
  };

  /**
   * V2状态，胶囊按钮纯色颜色切换
   */
  private readonly onCapBtnSolidChange = (state?: IBaseState): void => {
    this.updateBtnStyle();
  };

  /**
   * V2状态，胶囊条目纯色颜色切换
   */
  private readonly onCapItemBgSolidChange = (state?: IBaseState): void => {
    this.updateItemStyle();
  };

  /**
   * V2状态，胶囊主副文本纯色颜色切换
   */
  private readonly onCapTitleContentSolidChange = (state?: IBaseState): void => {
    this.updateTitleContentStyle();
  };

  /**
   * V2状态，胶囊扩展区文本纯色颜色切换
   */
  private readonly onCapExtSolidChange = (state?: IBaseState): void => {
    this.updateExtensionStyle();
  };

  /**
   * V2状态，胶囊强提醒状态切换
   */
  private readonly onCapRemindStateChange = (state?: IBaseState): void => {
    this.updateCapRemindState();
  };

  /**
   * V2状态，沉浸态显示数据切换
   */
  private readonly onShowingImmCardChange = (state?: IBaseState): void => {
    this.updateImmCardData();
  };

  /**
   * V2状态属性监听集
   */
  private readonly v2StateChange: Map<string, Map<SlStateProperty | WProperty, V2StateChange>> = new Map();

  /**
   * 沉浸状态
   */
  private immType?: ImmersiveType;

  /**
   * 当前正在显示的沉浸大卡数据分组标识
   */
  private immCardShowing?: string;

  constructor(vmInjector: IImmersiveNtfVmInjector) {
    super(vmInjector);
    this.initV1StateChange();
    this.initV2StateChange();
  }

  /**
   * V1状态属性监听初始化
   */
  private initV1StateChange(): void {
    // 锁屏通用静态状态
    this.v1StateChange.set(SlMainStateType.SL_STATIC_STATE, new Map([
      [SlStaticStateType.SCREEN_BP, this.onScreenBpChange], // 屏幕断点监听
    ]));
    // 锁屏通用UI绑定状态
    this.v1StateChange.set(SlMainStateType.SL_BIND_STATE, new Map([
      [SlBindStateType.IS_USING_IMMERSIVE_WALL_PAPER, this.onWallpaperLightChange], // 沉浸壁纸使用态
      [SlBindStateType.SL_WALLPAPER_LIGHT, this.onWallpaperLightChange], // 锁屏壁纸深浅色
    ]));
    // 时钟静态状态
    this.v1StateChange.set(SlMainStateType.SL_CLOCK_WG_STATIC_STATE, new Map([
      [ClockStaticStateType.BRIGHTNESS, this.onWallpaperLightChange], // 提亮度切换
    ]));
    // 一镜到底状态
    this.v1StateChange.set(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE, new Map([
      [OneMirrorStaticStateType.PT_AOD_STATE, this.onOneMirrorAnimProgressChange], // 一镜到底状态变化
    ]));
  }

  /**
   * V2状态属性监听初始化
   */
  private initV2StateChange(): void {
    // 胶囊动效状态
    this.v2StateChange.set(this.getV2Key(StateType.ANIM, SlStateId.SL_CAP_STATE), new Map([
      [WAnimProperty.ANIMATING, this.onCapAnimChange], // 动效中监听
    ]));
    // 胶囊静态业务状态
    this.v2StateChange.set(this.getV2Key(StateType.STATIC, SlStateId.SL_CAP_STATE), new Map([
      [SlCapStaticStPt.PT_BTN_SOLID_BG_COLOR, this.onCapBtnSolidChange], // 按钮纯色切换
      [SlCapStaticStPt.PT_MAIN_CAP_SOLID_BG_COLOR, this.onCapItemBgSolidChange], // 条目纯色切换
      [SlCapStaticStPt.PT_SHADOW_CAP_SOLID_BG_COLOR, this.onCapItemBgSolidChange], // 条目纯色切换
      [SlCapStaticStPt.PT_MAIN_CAP_SOLID_FG_COLOR, this.onCapTitleContentSolidChange], // 主副文本纯色切换
      [SlCapStaticStPt.PT_SHADOW_CAP_SOLID_FG_COLOR, this.onCapTitleContentSolidChange], // 主副文本纯色切换
      [SlCapStaticStPt.PT_EXT_TEXT_SOLID_FG_COLOR, this.onCapExtSolidChange], // 扩展区纯色切换
      [SlCapStaticStPt.PT_EXT_BTN_SOLID_BG_COLOR, this.onCapExtSolidChange], // 扩展区纯色切换
    ]));
    // 胶囊UI绑定业务状态
    this.v2StateChange.set(this.getV2Key(StateType.BIND, SlStateId.SL_CAP_STATE), new Map([
      [SlCapBindStPt.PT_CAP_REMIND, this.onCapRemindStateChange], // 强提醒状态切换
    ]));
    // 沉浸大卡静态业务状态
    this.v2StateChange.set(this.getV2Key(StateType.STATIC, SlStateId.SL_CARD_STATE), new Map([
      [SlCardStaticStPt.PT_GROUP_KEY_OF_SHOWING, this.onShowingImmCardChange], // 当前显示沉浸态切换
    ]));
  }

  public init(): void {
    super.init();
    // 强提醒胶囊动效监听
    let remindSt = this.getItemComAnim(CapShowType.CAP_REMIND);
    if (remindSt) {
      this.registerItemV2StListener(remindSt, WAnimProperty.ANIMATING, this.onRemindCapAnimChange);
    }
  }

  public destroy(): void {
    super.destroy();
    let remindSt = this.getItemComAnim(CapShowType.CAP_REMIND);
    if (remindSt) {
      this.unregisterItemV2StListener(remindSt, WAnimProperty.ANIMATING);
    }
  }

  /**
   * 纯色样式控制器
   *
   * @returns 纯色控制器
   */
  protected getSolidVisualControl(): ISolidVisualControl | undefined {
    return this.getCapStaticSt();
  }

  /**
   * V1状态监听类型集
   *
   * @returns 状态集
   */
  protected getV1StateListenerTypes(): SlMainStateType[] {
    return [
      SlMainStateType.SL_STATIC_STATE,
      SlMainStateType.SL_BIND_STATE,
      SlMainStateType.SL_CLOCK_WG_STATIC_STATE,
      SlMainStateType.SL_ONE_MIRROR_STATIC_STATE,
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
    return [{stateType: StateType.ANIM, stateId: SlStateId.SL_CAP_STATE},
      {stateType: StateType.STATIC, stateId: SlStateId.SL_CAP_STATE},
      {stateType: StateType.STATIC, stateId: SlStateId.SL_CARD_STATE},
      {stateType: StateType.BIND, stateId: SlStateId.SL_CAP_STATE}];
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
    log.showWarn(TAG, `onImmersiveTypeChange immType is ${immType}, ${this.immType}`);
    if (this.immType === immType) {
      return;
    }
    // 记录是否沉浸态切换
    let hasImmCard = this.immType === ImmersiveType.TYPE_IMMERSIVE || immType === ImmersiveType.TYPE_IMMERSIVE;
    this.immType = immType;
    // 沉浸态切换，刷新胶囊数据
    if (hasImmCard) {
      this.getCapVm().updateCapsuleData();
    }
    // 记录是否胶囊态
    this.getCapRemindVm()?.onCapStateChange(immType === ImmersiveType.TYPE_CAPSULE);
    // 更新胶囊的可见性
    this.updateCapVisibility();
  }

  /**
   * 刷新胶囊条目位置
   * 影响参数：条目样式，根组件位置
   */
  public updateItemPos(): void {
    let rootPos = CmpPosWrapper.wrapper(this.getRootCacheSt()?.getWidgetPosition());
    // 根组件未初始化
    if (!rootPos.isPosValid()) {
      return;
    }
    let rootWidth = rootPos.getCmpWidth();
    let rootPosX = rootPos.getCmpGlobalX();
    let rootPosY = rootPos.getCmpGlobalY();
    let helperVm = this.getItemHelperVm();
    CAP_ALL_TYPE.forEach((capType) => {
      let itemStyle = helperVm?.getCapStyleH(CapStyleSuffix.ITEM_COMMON_STYLE).getItemSt(capType);
      let itemCache = helperVm?.getCapCacheH(CapCacheSuffix.ITEM_COMMON_CACHE).getItemSt(capType);
      let marginL = itemStyle?.getMarginL() ?? 0;
      let marginR = itemStyle?.getMarginR() ?? 0;
      let marginT = itemStyle?.getMarginT() ?? 0;
      let itemHeight = (itemStyle?.getHeight() as number) ?? 0;
      // 条目胶囊位置转换
      let itemPos: ComponentPosition = {
        width: rootWidth - marginL - marginR,
        height: itemHeight,
        globalX: rootPosX + marginL,
        globalY: rootPosY + marginT
      };
      itemCache?.setWidgetPosition(itemPos);
    });
  }

  /**
   * 刷新胶囊可见性
   * 影响参数：动效中状态，沉浸状态
   */
  private updateCapVisibility(): void {
    let capVisibility = this.getCapVisibility();
    let style = this.getRootStyleSt();
    if (style?.getVisibility() === capVisibility) {
      return;
    }

    log.showInfo(TAG, `refresh capsule Visibility capVisibility: ${capVisibility}`);
    style?.setVisibility(capVisibility);
    // 胶囊态，更新back手势使能
    if (this.immersiveState?.isCapsule() && capVisibility === Visibility.Visible) {
      ImmersiveComHelper.enableBackGesture(false);
    }
  }

  /**
   * 胶囊可见性
   *
   * @returns 可见性
   */
  private getCapVisibility(): Visibility {
    // 动效期间保持可见
    if (this.getRootAnimSt()?.isWidgetAnimating()) {
      return Visibility.Visible;
    }
    // 胶囊态，保持可见
    return this.immersiveState?.isShowCapsule() ? Visibility.Visible : Visibility.Hidden;
  }

  /**
   * 切换状态模式
   * 影响参数：壁纸深浅色模式,AOD一镜到底
   */
  private updateStateModeId(): void {
    let stateMode = this.calcStateModeId();
    if (this.stateModeId === stateMode) {
      return;
    }
    // 清除旧模式，添加新模式
    this.removeStModeId(this.stateModeId);
    this.addStModeId(stateMode);
    this.stateModeId = stateMode;
    // 兼容播控，浅色壁纸时压暗
    this.getCapBindStV1()?.setCapDarkMode(stateMode === StateModeId.LIGHT);
    log.showInfo(TAG, `updateStateModeId stateMode: ${stateMode}`);
    // 状态模式切换，更新相关样式配置
    this.updateItemStyle();
    this.updateTitleContentStyle();
    this.updateIconStyle();
    this.updateIconReverseStyle();
    this.updateExtensionStyle();
    this.updateBtnStyle();
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
    let clockSt = this.getV1State(SlMainStateType.SL_CLOCK_WG_STATIC_STATE);
    let slBindSt = this.getV1State(SlMainStateType.SL_BIND_STATE);
    // 提亮度
    let bright = clockSt?.getSlState(ClockStaticStateType.BRIGHTNESS) as number ?? -1;
    let isSlWallpaperUsing = slBindSt?.getSlState(SlBindStateType.IS_USING_IMMERSIVE_WALL_PAPER) as boolean ?? false;
    let isWallpaperLight = slBindSt?.getSlState(SlBindStateType.SL_WALLPAPER_LIGHT) as boolean ?? false;
    // 使用壁纸自身深浅色标识
    if (isSlWallpaperUsing || bright < 0) {
      return isWallpaperLight ? StateModeId.LIGHT : StateModeId.DARK;
    }
    // 提亮度存在时，比较阈值
    return bright < CommonConstants.BRIGHT_NESS_DEFAULT ? StateModeId.LIGHT : StateModeId.DARK;
  }

  /**
   * 刷新胶囊宽高
   * 影响参数：屏幕断点
   */
  private updateCapSize(): void {
    // 计算胶囊宽度
    let screenBp = this.getScreenBp();
    let defaultStyle = this.getStyleCfHelper()?.getCapRootStyle(screenBp?.bpSplice);
    let capCfg = this.getStyleCfHelper()?.getCapConfig(screenBp?.bpSplice);
    let marginL = defaultStyle.getMarginL() ?? 0;
    let marginR = defaultStyle.getMarginR() ?? 0;
    // 边距范围0~1，则按宽度占比计算胶囊宽度；其他范围则按vp值计算胶囊宽度
    let screenW = capCfg?.isUseHeightCal() ? (screenBp?.screenHeight ?? 0) : (screenBp?.screenWidth ?? 0);
    let capWidth = screenW;
    if ((marginL > 0 && marginL < 1) && (marginR > 0 && marginR < 1)) {
      capWidth = screenW * (1 - marginL - marginR);
    } else {
      capWidth = screenW - marginL - marginR;
    }
    this.getRootStyleSt()?.setWidth(capWidth).setHeight(defaultStyle.getHeight())
      .setBorderRadius(defaultStyle.getBorderRadiusTL());
    log.showInfo(TAG, `updateCapSize width: ${capWidth}, ${screenBp?.bpSplice}, ${marginL}, ${marginR}`);
  }

  /**
   * 刷新胶囊显示个数
   * 影响参数：屏幕断点
   */
  private updateCapShowNum(): void {
    // 计算胶囊显示个数
    let screenBp = this.getScreenBp();
    let capCf = this.getStyleCfHelper()?.getCapConfig(screenBp?.bpSplice);
    let btnCount = capCf?.getShowBtnCount() ?? BTN_DEFAULT_COUNT;
    this.getCapBindSt()?.setShowBtnCount(btnCount);
    log.showInfo(TAG, `updateCapShowNum btnCount: ${btnCount}`);
  }

  /**
   * 更新胶囊条目样式
   * 影响参数：屏幕断点，状态模式，胶囊强提醒
   */
  private updateItemStyle(): void {
    let screenBp = this.getScreenBp();
    let cfHelper = this.getStyleCfHelper();
    let comStyleH = this.getItemHelperVm()?.getCapStyleH(CapStyleSuffix.ITEM_COMMON_STYLE);
    CAP_ALL_TYPE.forEach((capType) => {
      // 条目样式预置
      let itemCfgStyle = cfHelper?.getCapItemStyle(capType, screenBp?.bpSplice);
      // 优先刷新纯色模式样式的配置
      this.updateSolidCfgStyle(itemCfgStyle);
      let itemStyle = comStyleH?.getItemSt(capType);
      ITEM_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, itemStyle, itemCfgStyle));
    });
    // 条目样式刷新完成，刷新条目位置
    this.updateItemPos();
  }

  /**
   * 更新通用胶囊布局文本样式
   * 影响参数：屏幕断点，状态模式
   */
  private updateTitleContentStyle(): void {
    let screenBp = this.getScreenBp();
    let cfHelper = this.getStyleCfHelper();
    let titleCfgStyle = cfHelper.getCapComViewStyle(CapStyleSuffix.ITEM_MAIN_TEXT_STYLE, screenBp?.bpSplice);
    let contentCfgStyle = cfHelper.getCapComViewStyle(CapStyleSuffix.ITEM_SECONDARY_TEXT_STYLE, screenBp?.bpSplice);
    let titleH = this.getItemHelperVm()?.getCapStyleH(CapStyleSuffix.ITEM_MAIN_TEXT_STYLE);
    let contentH = this.getItemHelperVm()?.getCapStyleH(CapStyleSuffix.ITEM_SECONDARY_TEXT_STYLE);
    // 优先刷新纯色模式样式的配置
    this.updateSolidCfgStyle(titleCfgStyle);
    this.updateSolidCfgStyle(contentCfgStyle);
    CAP_ALL_TYPE.forEach((capType) => {
      // 主文本样式预置
      let titleStyle = titleH?.getItemSt(capType);
      TITLE_CONTENT_TEXT_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, titleStyle, titleCfgStyle));
      // 副文本样式配置
      let contentStyle = contentH?.getItemSt(capType);
      TITLE_CONTENT_TEXT_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, contentStyle, contentCfgStyle));
    });
  }

  /**
   * 更新通用胶囊布局图标样式
   * 影响参数：屏幕断点，AOD状态模式
   */
  private updateIconStyle(): void {
    let screenBp = this.getScreenBp();
    let cfHelper = this.getStyleCfHelper();
    let lIconCfgStyle = cfHelper.getCapComViewStyle(CapStyleSuffix.ITEM_LARGE_ICON_STYLE, screenBp?.bpSplice);
    let sIconCfgStyle = cfHelper.getCapComViewStyle(CapStyleSuffix.ITEM_SMALL_ICON_STYLE, screenBp?.bpSplice);
    let sIconBgCfgStyle = cfHelper.getCapComViewStyle(CapStyleSuffix.ITEM_SMALL_ICON_BG_STYLE, screenBp?.bpSplice);
    let lIconStyleH = this.getItemHelperVm()?.getCapStyleH(CapStyleSuffix.ITEM_LARGE_ICON_STYLE);
    let sIconStyleH = this.getItemHelperVm()?.getCapStyleH(CapStyleSuffix.ITEM_SMALL_ICON_STYLE);
    let sIconBgStyleH = this.getItemHelperVm()?.getCapStyleH(CapStyleSuffix.ITEM_SMALL_ICON_BG_STYLE);
    CAP_ALL_TYPE.forEach((capType) => {
      // 大图标样式预置
      let lIconStyle = lIconStyleH?.getItemSt(capType);
      LARGE_ICON_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, lIconStyle, lIconCfgStyle));
      // 小图标样式预置
      let sIconStyle = sIconStyleH?.getItemSt(capType);
      SMALL_ICON_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, sIconStyle, sIconCfgStyle));
      // 小图标背景样式预置
      let sIconBgStyle = sIconBgStyleH?.getItemSt(capType);
      SMALL_ICON_BG_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, sIconBgStyle, sIconBgCfgStyle));
    });
  }

  /**
   * 更新通用胶囊布局图标样式
   * 影响参数：屏幕断点，AOD状态模式
   */
  private updateIconReverseStyle(): void {
    let screenBp = this.getScreenBp();
    let cfHelper = this.getStyleCfHelper();
    let sIconBgReverseSuffix = CapStyleSuffix.ITEM_SMALL_ICON_BG_REVERSE_STYLE;
    let sIconCfgStyle = cfHelper.getCapComViewStyle(CapStyleSuffix.ITEM_SMALL_ICON_REVERSE_STYLE, screenBp?.bpSplice);
    let sIconBgCfgStyle = cfHelper.getCapComViewStyle(sIconBgReverseSuffix, screenBp?.bpSplice);
    let sIconStyleH = this.getItemHelperVm()?.getCapStyleH(CapStyleSuffix.ITEM_SMALL_ICON_REVERSE_STYLE);
    let sIconBgStyleH = this.getItemHelperVm()?.getCapStyleH(sIconBgReverseSuffix);
    CAP_ALL_TYPE.forEach((capType) => {
      // 小图标样式预置
      let sIconStyle = sIconStyleH?.getItemSt(capType);
      SMALL_ICON_REVERSE_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, sIconStyle, sIconCfgStyle));
      // 小图标背景样式预置
      let sIconBgStyle = sIconBgStyleH?.getItemSt(capType);
      SMALL_ICON_BG_REVERSE_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, sIconBgStyle, sIconBgCfgStyle));
    });
  }

  /**
   * 更新通用胶囊布局扩展区样式
   * 影响参数：屏幕断点，AOD状态模式
   */
  private updateExtensionStyle(): void {
    let screenBp = this.getScreenBp();
    let cfHelper = this.getStyleCfHelper();
    let extCfgStyle = cfHelper.getCapComViewStyle(CapStyleSuffix.ITEM_EXTENSION_STYLE, screenBp?.bpSplice);
    let extTextCfgStyle = cfHelper.getCapComViewStyle(CapStyleSuffix.ITEM_EXT_TEXT_STYLE, screenBp?.bpSplice);
    let extBtnCfgStyle = cfHelper.getCapComViewStyle(CapStyleSuffix.ITEM_EXT_BTN_STYLE, screenBp?.bpSplice);
    let extStyleH = this.getItemHelperVm()?.getCapStyleH(CapStyleSuffix.ITEM_EXTENSION_STYLE);
    let extTextStyleH = this.getItemHelperVm()?.getCapStyleH(CapStyleSuffix.ITEM_EXT_TEXT_STYLE);
    let extBtnStyleH = this.getItemHelperVm()?.getCapStyleH(CapStyleSuffix.ITEM_EXT_BTN_STYLE);
    // 优先刷新纯色模式样式的配置
    this.updateSolidCfgStyle(extTextCfgStyle);
    this.updateSolidCfgStyle(extBtnCfgStyle);
    CAP_ALL_TYPE.forEach((capType) => {
      // 扩展区样式预置
      let extStyle = extStyleH?.getItemSt(capType);
      EXT_COM_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, extStyle, extCfgStyle))
      // 扩展区文本样式预置
      let extTextStyle = extTextStyleH?.getItemSt(capType);
      EXT_TEXT_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, extTextStyle, extTextCfgStyle));
      // 扩展区按钮样式预置
      let extBtnStyle = extBtnStyleH?.getItemSt(capType);
      EXT_BTN_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, extBtnStyle, extBtnCfgStyle));
    });
  }

  /**
   * 更新通用胶囊布局按钮样式
   * 影响参数：屏幕断点，状态模式
   */
  private updateBtnStyle(): void {
    let screenBp = this.getScreenBp();
    let cfHelper = this.getStyleCfHelper();
    let btnCfgStyle = cfHelper.getCapComViewStyle(CapStyleSuffix.ITEM_BUTTON_STYLE, screenBp?.bpSplice);
    let btnStyleH = this.getItemHelperVm()?.getCapStyleH(CapStyleSuffix.ITEM_BUTTON_STYLE);
    // 优先刷新纯色模式样式的配置
    this.updateSolidCfgStyle(btnCfgStyle);
    CAP_ALL_TYPE.forEach((capType) => {
      // 按钮样式预置
      let btnStyle = btnStyleH?.getItemSt(capType);
      BTN_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, btnStyle, btnCfgStyle));
    });
  }

  /**
   * 刷新胶囊强提醒状态
   */
  private updateCapRemindState(): void {
    let isCapRemind = this.getCapBindSt()?.isCapRemind();
    if (isCapRemind) {
      this.addStModeId(StateModeId.REMIND);
    } else {
      this.removeStModeId(StateModeId.REMIND);
    }
    // 刷新条目样式
    this.updateItemStyle();
  }

  /**
   * 刷新沉浸大卡显示相关的胶囊数据
   */
  private updateImmCardData(): void {
    let curCardData = this.getCurImmCard();
    if (this.immCardShowing === curCardData) {
      return;
    }
    // 新数据记录为胶囊过渡大卡
    let checkData = this.getCapVm()?.getCheckCapData();
    let toCardCap = this.getCapVm()?.getCapData(curCardData);
    if (toCardCap) {
      checkData?.set(CapShowType.CAP_CARD, toCardCap);
    }
    // 旧数据记录为大卡过渡胶囊
    let backCardCap = this.getCapVm()?.getCapData(this.immCardShowing);
    if (backCardCap) {
      checkData?.set(CapShowType.CAP_CARD_BACK, backCardCap);
    }
    // 切换数据
    this.immCardShowing = curCardData;
    // 状态未切换，但沉浸态数据切换，刷新胶囊数据
    if (this.getImmState().isImmersive()) {
      this.getCapVm().updateCapsuleData();
    }
  }

  private getCapBindStV1(): SlCapWidgetBindState {
    return this.getV1State(SlMainStateType.SL_CAP_WG_BIND_STATE) as SlCapWidgetBindState;
  }

  private getCapStaticSt(): SlCapStaticStateV2 {
    return this.getCapVm()?.getSlStaticState();
  }

  private getCapBindSt(): SlCapBindStateV2 {
    return this.getCapVm()?.getSlBindState();
  }

  private getRootStyleSt(): WidgetStyleStateV2 {
    return this.getCapVm()?.getSlStyleState();
  }

  private getRootAnimSt(): WidgetAnimStateV2 {
    return this.getCapVm()?.getSlAnimState();
  }

  private getRootCacheSt(): WidgetCacheState {
    return this.getCapVm()?.getSlCacheState();
  }

  private getCapVm(): IImmersiveCapVm {
    return this.vmInjector?.getImmersiveCapVm();
  }

  private getStyleCfHelper(): IImmStyleConfigHelper {
    return this.vmInjector?.getImmStyleConfigHelper();
  }

  private getItemHelperVm(): IImmItemHelperVm {
    return this.vmInjector?.getImmItemHelperVm();
  }

  private getCapRemindVm(): IImmCapRemindVm {
    return this.vmInjector?.getImmCapRemindVm();
  }

  private getItemComAnim(capType: CapShowType): WidgetAnimStateV2 | undefined {
    return this.getItemHelperVm()?.getCapAnimH(CapAnimSuffix.ITEM_COMMON_ANIM)?.getItemSt(capType);
  }
}
