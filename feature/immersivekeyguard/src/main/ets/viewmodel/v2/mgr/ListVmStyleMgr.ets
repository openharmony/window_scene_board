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
import {
  SlMainStateType,
  SlSubStateType,
  StateChange,
  WProperty,
  ISlState,
  SlStaticStateType,
  ScreenBp,
  WAnimProperty,
  OneMirrorStaticStateType,
  ScreenLockApi,
  WBaseProperty,
  ClockStaticStateType
} from '@ohos/screenlockcommon';
import { WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import {
  SlStateProperty,
  V2StateChange,
  StateType,
  SlStateId,
  IBaseState,
  StateModeId,
  SlListStaticStPt
} from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { ImmersiveType, ImmersiveTypeScene } from '@ohos/systemuicommon';
import { ImmersiveComHelper } from '../../../common/helper/ImmersiveComHelper';
import { ListStyleSuffix } from '../../../common/constants/ImmListConst';
import { IImmersiveListVm } from '../../../common/interface/IImmersiveListVm';
import { IImmersiveNtfVmInjector } from '../../../common/interface/IImmersiveNtfVmInjector';
import { IImmItemHelperVm } from '../../../common/interface/IImmItemHelperVm';
import { IImmersivePanelVm } from '../../../common/interface/IImmersivePanelVm';
import { IImmStyleConfigHelper } from '../../../common/interface/IImmStyleConfigHelper';
import { BaseVmStyleMgr, V2StateUnique } from './BaseVmStyleMgr';
import { DownPosition } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';
import { NotificationArray } from '@ohos/systemuicommon/src/main/ets/model/NotificationBase';
import { ConfigurationEvent } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { ImmColorVm } from '../../../common/color/ImmColorVm';
import { IImmersiveWholeAnimVm } from '../../../common/interface/IImmersiveWholeAnimVm';
import { IImmersiveCardVm } from '../../../common/interface/IImmersiveCardVm';
import { ImmComAnimScene } from '../../../common/constants/ImmComConst';
import { SlListStaticStateV2 } from '../../../model/data/v2/SlListStaticStateV2';
import { ISolidVisualControl } from '../../../common/interface/ISolidVisualControl';
import { IImmersiveNtfSettingDialogVm } from '../../../common/interface/IImmersiveNtfSettingDialogVm';
import { IImmSilenceVm } from '../../../common/interface/IImmSilenceVm';
import { IImmersiveNtfPinTopVm } from '../../../common/interface/IImmersiveNtfPinTopVm';

const TAG = 'ListVmStyleMgr';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

// 条目样式需刷新属性集
const ITEM_STYLE_PT: WBaseProperty[] = [WBaseProperty.BORDER_RADIUS_TL, WBaseProperty.BACKGROUND_COLOR,
  WBaseProperty.BG_BRIGHTNESS_INNER, WBaseProperty.SHADOW, WBaseProperty.POINT_LIGHT];

// 条目主副文本样式需刷新属性集
const ITEM_TITLE_CONTENT_STYLE_PT: WBaseProperty[] = [WBaseProperty.FONT_COLOR, WBaseProperty.FG_BRIGHTNESS];

// 扩展区主副文本样式需要刷新属性集
const EXT_TITLE_CONTENT_STYLE_PT: WBaseProperty[] = [WBaseProperty.FONT_COLOR];

// 扩展区分割线样式需要刷新属性集
const EXT_DIVIDER_STYLE_PT: WBaseProperty[] = [WBaseProperty.FILL_COLOR, WBaseProperty.ALPHA,
  WBaseProperty.FG_BRIGHTNESS];

// 扩展区服务按钮样式需要刷新属性集
const EXT_ACTION_STYLE_PT: WBaseProperty[] = [WBaseProperty.FONT_COLOR, WBaseProperty.ALPHA];

// 扩展区鉴权按钮样式需要刷新属性集
const EXT_AUTHOR_STYLE_PT: WBaseProperty[] = [WBaseProperty.FONT_COLOR, WBaseProperty.ALPHA,
  WBaseProperty.BRIGHTNESS, WBaseProperty.BACKGROUND_COLOR];

// 条目小图标样式需要刷新属性集
const ITEM_ICON_STYLE_PT: WBaseProperty[] = [WBaseProperty.ALPHA, WBaseProperty.VISIBILITY,
  WBaseProperty.BACKGROUND_COLOR, WBaseProperty.COLOR_FILTER];

// 条目时间样式需要刷新属性集
const ITEM_TIME_STYLE_PT: WBaseProperty[] = [WBaseProperty.VISIBILITY];

// 系统实况副文本样式需要刷新属性集
const SYS_CONTENT_STYLE_PT: WBaseProperty[] = [WBaseProperty.FG_BRIGHTNESS, WBaseProperty.FOREGROUND_COLOR];

// 系统实况按钮、进度条样式需要刷新属性集
const SYS_BTN_PROGRESS_STYLE_PT: WBaseProperty[] = [WBaseProperty.ALPHA];

// 扩展区样式需要刷新属性集
const EXT_STYLE_PT: WBaseProperty[] = [WBaseProperty.ALPHA];

// 取餐卡片扩展区副文本样式需要刷新属性集
const EXT_PICKUP_CON_STYLE_PT: WBaseProperty[] = [WBaseProperty.FONT_SIZE, WBaseProperty.MARGIN_B,
  WBaseProperty.FONT_WEIGHT];

// 比分卡片扩展区计时文本样式需要刷新属性集
const EXT_SCORE_TIMER_STYLE_PT: WBaseProperty[] = [WBaseProperty.WIDTH];

// 三方实况辅助区文本样式需要刷新属性集
const OTHER_EXT_VIEW_TEXT_STYLE_PT: WBaseProperty[] = [WBaseProperty.FONT_COLOR, WBaseProperty.ALPHA,
  WBaseProperty.FG_BRIGHTNESS, WBaseProperty.RENDER_GROUP];

// 三方实况辅助区文本带wantAgent样式需要刷新属性集
const OTHER_EXT_VIEW_TEXT_WANT_STYLE_PT: WBaseProperty[] = [WBaseProperty.ALPHA];

// 三方实况辅助区按钮样式需要刷新属性集
const OTHER_EXT_VIEW_BUTTON_STYLE_PT: WBaseProperty[] = [WBaseProperty.BACKGROUND_COLOR,
  WBaseProperty.BG_BRIGHTNESS_INNER, WBaseProperty.ALPHA];

/**
 * 列表业务样式管理器
 */
export class ListVmStyleMgr extends BaseVmStyleMgr {
  /**
   * V1状态，屏幕断点刷新
   */
  private readonly onScreenBpChange = (state?: ISlState): void => {
    this.updateListWidth();
    this.updateListPadding();
    this.updateAllItemStyle();
  };

  /**
   * V1状态，时钟高度切换
   */
  private readonly onClockRegionChange = (state?: ISlState): void => {
    this.updateListPadding();
  };

  /**
   * V1状态，时钟可见性切换
   */
  private readonly onClockVisibleChange = (state?: ISlState): void => {
    this.updateListPadding();
  };

  /**
   * V1状态，锁屏界面全局触摸点更新
   */
  private readonly onSlPanelDownGlobalChange = (state?: ISlState): void => {
    let downPosition = state?.getSlState(SlStaticStateType.SL_PANEL_DOWN_GLOBAL) as DownPosition;
    this.getImmersivePanelVm().setPanelGlobalDownPosition(downPosition);
  }

  /**
   * V1状态属性监听集
   */
  private readonly v1StateChange: Map<SlMainStateType, Map<SlSubStateType, StateChange>> = new Map();

  /**
   * V2状态，列表动效状态动效中切换
   */
  private readonly onListAnimChange = (state?: IBaseState): void => {
    this.updateListVisibility();
  };

  /**
   * V2状态，列表条目背景纯色颜色切换
   */
  private readonly onItemSolidChange = (state?: IBaseState): void => {
    // 刷新条目背景基色
    let itemBgColor = this.getListStaticSt()?.getItemBgSolidColor();
    this.getImmColorVm()?.updateScreenLockColor(itemBgColor);
  };

  /**
   * V2状态属性监听集
   */
  private readonly v2StateChange: Map<string, Map<SlStateProperty | WProperty, V2StateChange>> = new Map();

  /**
   * 系统是否深色模式
   */
  private isModeDark: boolean = false;

  /**
   * 系统Configuration配置回调
   */
  private readonly onConfigurationChange = (event: ConfigurationEvent) => {
    this.isModeDark = event?.config?.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
    // 刷新状态模式
    this.updateStateModeId();
  };

  /**
   * V1状态，一镜到底动效进度变化
   */
  private readonly onOneMirrorAnimProgressChange = (state?: ISlState): void => {
    this.updateStateModeId();
    this.resetItem();
  };

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
      [SlStaticStateType.CLOCK_COLLAPSE_SHOW_REGION, this.onClockRegionChange], // 时钟高度监听
      [SlStaticStateType.SL_PANEL_DOWN_GLOBAL, this.onSlPanelDownGlobalChange], // 锁屏面板触摸点监听
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
    // 列表动效状态
    this.v2StateChange.set(this.getV2Key(StateType.ANIM, SlStateId.SL_LIST_STATE), new Map([
      [WAnimProperty.ANIMATING, this.onListAnimChange], // 动效中监听
    ]));
    // 列表静态状态
    this.v2StateChange.set(this.getV2Key(StateType.STATIC, SlStateId.SL_LIST_STATE), new Map([
      [SlListStaticStPt.PT_ITEM_SOLID_BG_COLOR, this.onItemSolidChange], // 条目背景纯色
    ]));
  }

  /**
   * 纯色样式控制器
   *
   * @returns 纯色控制器
   */
  protected getSolidVisualControl(): ISolidVisualControl | undefined {
    return this.getListStaticSt();
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
      {stateType: StateType.ANIM, stateId: SlStateId.SL_LIST_STATE},
      {stateType: StateType.STATIC, stateId: SlStateId.SL_LIST_STATE},
    ];
  }

  /**
   * V2状态属性监听集
   *
   * @param unique 状态标识
   * @returns 属性监听集
   */
  protected getV2StateChange(unique: V2StateUnique): Map<SlStateProperty | WProperty, V2StateChange> | undefined {
    return this.v2StateChange.get(this.getV2Key(unique.stateType, unique.stateId));
  }

  /**
   * 沉浸状态切换回调
   *
   * @param immType 当前沉浸状态
   */
  protected onImmersiveTypeChange(immType: ImmersiveType): void {
    log.showInfo(TAG, `onImmersiveTypeChange: ${immType}`);
    this.updateListEnable();
    this.updateListVisibility();
  }

  /**
   * 初始化
   */
  init(): void {
    super.init();
    this.eventMgr.on(ConfigurationEvent, this.onConfigurationChange);
    // 锁屏时，设置为默认状态，默认进沉浸态了则无需处理
    if (!this.getImmState().isImmersive()) {
      this.setDefaultImmState();
    }
  }

  /**
   * 条目图标点击事件
   *
   * @param groupKey 点击条目标识
   */
  public onItemIconClick(groupKey: string): void {
    // 数据安全性检测
    let cardData = this.getImmCardVm()?.getImmValidData(groupKey);
    if (!cardData) {
      log.showWarn(TAG, `onItemIconClick data err: ${groupKey}`);
      return;
    }
    // UIExtension数据，解锁安全校验，请求解锁
    if (cardData.isUiExtensionCard() && !this.isOsAccountUnlocked()) {
      log.showWarn(TAG, `onItemIconClick ui extension locked: ${groupKey}`);
      ScreenLockApi.requestUnlock();
      return;
    }
    // 列表过渡沉浸态，动效过渡
    this.setCurImmData(groupKey);
    this.switchImmState(ImmersiveType.TYPE_IMMERSIVE, ImmersiveTypeScene.SCENE_LIST_ITEM_CLICK);
    this.getWholeAnimVm()?.startHybridAnim({
      animScene: ImmComAnimScene.ANIM_LIST_CARD,
      skipGroupKey: groupKey
    });
    log.showWarn(TAG, `onItemIconClick list to card: ${groupKey}`);
  }

  /**
   * 关联条目状态刷新
   *
   * @param groupKey 分组标识
   */
  public updateAllItemStyle(groupKey?: string): void {
    this.updateListItemStyle(groupKey);
    this.updateListExtTitleContentStyle(groupKey);
    this.updateListExtDividerStyle(groupKey);
    this.updateListExtActionStyle(groupKey);
    this.updateListExtAuthorStyle(groupKey);
    this.updateListItemIconStyle(groupKey);
    this.updateListItemTimeStyle(groupKey);
    this.updateListSysLiveStyle(groupKey);
    this.updateListOtherLiveExtendStyle(groupKey);
    this.updateListExtViewTextButtonStyle(groupKey);
  }

  /**
   * 刷新条目默认样式
   * 影响参数：屏幕断点,状态模式
   *
   * @param groupKey 条目标识
   */
  public updateListItemStyle(groupKey?: string): void {
    let staticSt = this.getV1State(SlMainStateType.SL_STATIC_STATE);
    let screenBp = staticSt?.getSlState(SlStaticStateType.SCREEN_BP) as ScreenBp;
    let itemCfStyle = this.getStyleCfHelper()?.getListItemStyle(ListStyleSuffix.ITEM_COMMON_STYLE, screenBp?.bpSplice);
    let titleCfStyle = this.getStyleCfHelper()?.getListItemStyle(ListStyleSuffix.ITEM_TITLE_STYLE, screenBp?.bpSplice);
    let conCfStyle = this.getStyleCfHelper()?.getListItemStyle(ListStyleSuffix.ITEM_CONTENT_STYLE, screenBp?.bpSplice);
    let comStyleH = this.getItemHelperVm()?.getListStyleH(ListStyleSuffix.ITEM_COMMON_STYLE);
    let titleStyleH = this.getItemHelperVm()?.getListStyleH(ListStyleSuffix.ITEM_TITLE_STYLE);
    let conStyleH = this.getItemHelperVm()?.getListStyleH(ListStyleSuffix.ITEM_CONTENT_STYLE);
    // 单条目刷新
    if (groupKey) {
      let itemStyle = comStyleH?.getItemSt(groupKey);
      let titleStyle = titleStyleH?.getItemSt(groupKey);
      let conStyle = conStyleH?.getItemSt(groupKey);
      ITEM_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, itemStyle, itemCfStyle));
      ITEM_TITLE_CONTENT_STYLE_PT.forEach((pt) => {
        this.setStyleProperty(pt, titleStyle, titleCfStyle);
        this.setStyleProperty(pt, conStyle, conCfStyle);
      });
    } else {
      // 全条目刷新
      this.getListData()?.forEach((ntf) => {
        let itemStyle = comStyleH?.getItemSt(ntf?.groupKey);
        let titleStyle = titleStyleH?.getItemSt(ntf?.groupKey);
        let conStyle = conStyleH?.getItemSt(ntf?.groupKey);
        ITEM_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, itemStyle, itemCfStyle));
        ITEM_TITLE_CONTENT_STYLE_PT.forEach((pt) => {
          this.setStyleProperty(pt, titleStyle, titleCfStyle);
          this.setStyleProperty(pt, conStyle, conCfStyle);
        });
      });
    }
  }

  /**
   * 刷新三方实况扩展区标题、内容文本样式
   * 影响参数：屏幕断点,状态模式
   *
   * @param groupKey 条目标识
   */
  public updateListExtTitleContentStyle(groupKey?: string): void {
    let screenBp = this.getScreenBp();
    let titleCfStyle = this.getStyleCfHelper()?.getListItemStyle(ListStyleSuffix.EXT_TITLE_STYLE, screenBp?.bpSplice);
    let titleStyleH = this.getItemHelperVm()?.getListStyleH(ListStyleSuffix.EXT_TITLE_STYLE);
    let conCfStyle = this.getStyleCfHelper()?.getListItemStyle(ListStyleSuffix.EXT_CONTENT_STYLE, screenBp?.bpSplice);
    let conStyleH = this.getItemHelperVm()?.getListStyleH(ListStyleSuffix.EXT_CONTENT_STYLE);
    // 单条目刷新
    if (groupKey) {
      let titleStyle = titleStyleH?.getItemSt(groupKey);
      let conStyle = conStyleH?.getItemSt(groupKey);
      EXT_TITLE_CONTENT_STYLE_PT.forEach((pt) => {
        this.setStyleProperty(pt, titleStyle, titleCfStyle);
        this.setStyleProperty(pt, conStyle, conCfStyle);
      });
    } else {
      // 全条目刷新
      this.getListData()?.forEach((ntf) => {
        let titleStyle = titleStyleH?.getItemSt(ntf?.groupKey);
        let conStyle = conStyleH?.getItemSt(ntf?.groupKey);
        EXT_TITLE_CONTENT_STYLE_PT.forEach((pt) => {
          this.setStyleProperty(pt, titleStyle, titleCfStyle);
          this.setStyleProperty(pt, conStyle, conCfStyle);
        });
      });
    }
  }

  /**
   * 刷新三方实况扩展区分割线样式
   * 影响参数：屏幕断点,状态模式
   *
   * @param groupKey 条目标识
   */
  public updateListExtDividerStyle(groupKey?: string): void {
    let screenBp = this.getScreenBp();
    let divCfStyle = this.getStyleCfHelper()?.getListItemStyle(ListStyleSuffix.EXT_DIVIDER_STYLE, screenBp?.bpSplice);
    let dividerStyleH = this.getItemHelperVm()?.getListStyleH(ListStyleSuffix.EXT_DIVIDER_STYLE);
    // 单条目刷新
    if (groupKey) {
      let dividerStyle = dividerStyleH?.getItemSt(groupKey);
      EXT_DIVIDER_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, dividerStyle, divCfStyle));
    } else {
      // 全条目刷新
      this.getListData()?.forEach((ntf) => {
        let dividerStyle = dividerStyleH?.getItemSt(ntf?.groupKey);
        EXT_DIVIDER_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, dividerStyle, divCfStyle));
      });
    }
  }

  /**
   * 刷新三方实况扩展区服务按钮样式
   * 影响参数：屏幕断点,状态模式
   *
   * @param groupKey 条目标识
   */
  public updateListExtActionStyle(groupKey?: string): void {
    let screenBp = this.getScreenBp();
    let actionCfStyle = this.getStyleCfHelper()?.getListItemStyle(ListStyleSuffix.EXT_ACTION_STYLE, screenBp?.bpSplice);
    let actionStyleH = this.getItemHelperVm()?.getListStyleH(ListStyleSuffix.EXT_ACTION_STYLE);
    // 单条目刷新
    if (groupKey) {
      let actionStyle = actionStyleH?.getItemSt(groupKey);
      EXT_ACTION_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, actionStyle, actionCfStyle));
    } else {
      // 全条目刷新
      this.getListData()?.forEach((ntf) => {
        let actionStyle = actionStyleH?.getItemSt(ntf?.groupKey);
        EXT_ACTION_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, actionStyle, actionCfStyle));
      });
    }
  }

  /**
   * 刷新三方实况扩展区鉴权按钮样式
   * 影响参数：屏幕断点,状态模式
   *
   * @param groupKey 条目标识
   */
  public updateListExtAuthorStyle(groupKey?: string): void {
    let screenBp = this.getScreenBp();
    let authorCfStyle = this.getStyleCfHelper()?.getListItemStyle(ListStyleSuffix.EXT_AUTHOR_STYLE, screenBp?.bpSplice);
    let authorStyleH = this.getItemHelperVm()?.getListStyleH(ListStyleSuffix.EXT_AUTHOR_STYLE);
    // 单条目刷新
    if (groupKey) {
      let authorStyle = authorStyleH?.getItemSt(groupKey);
      EXT_AUTHOR_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, authorStyle, authorCfStyle));
    } else {
      // 全条目刷新
      this.getListData()?.forEach((ntf) => {
        let authorStyle = authorStyleH?.getItemSt(ntf?.groupKey);
        EXT_AUTHOR_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, authorStyle, authorCfStyle));
      });
    }
  }

  /**
   * 刷新列表三方实况扩展区样式
   * 影响参数：状态模式
   *
   * @param groupKey 条目标识
   */
  public updateListOtherLiveExtendStyle(groupKey?: string): void {
    let screenBp = this.getScreenBp();
    let defaultStyle =
      this.getStyleCfHelper()?.getListItemStyle(ListStyleSuffix.OTHER_LIVE_EXTEND_STYLE, screenBp?.bpSplice);
    let comStyleH = this.getItemHelperVm()?.getListStyleH(ListStyleSuffix.OTHER_LIVE_EXTEND_STYLE);
    let pickupConCfgStyle =
      this.getStyleCfHelper()?.getListItemStyle(ListStyleSuffix.EXT_PICKUP_CON_STYLE, screenBp?.bpSplice);
    let pickupConStyleH = this.getItemHelperVm()?.getListStyleH(ListStyleSuffix.EXT_PICKUP_CON_STYLE);
    let scoreTimerCfgStyle =
      this.getStyleCfHelper()?.getListItemStyle(ListStyleSuffix.EXT_SCORE_TIMER_STYLE, screenBp?.bpSplice);
    let scoreTimerStyleH = this.getItemHelperVm()?.getListStyleH(ListStyleSuffix.EXT_SCORE_TIMER_STYLE);
    // 单条目刷新
    if (groupKey) {
      let extStyle = comStyleH?.getItemSt(groupKey);
      EXT_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, extStyle, defaultStyle));
      let pickupConStyle = pickupConStyleH?.getItemSt(groupKey);
      EXT_PICKUP_CON_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, pickupConStyle, pickupConCfgStyle));
      let scoreTimerStyle = scoreTimerStyleH?.getItemSt(groupKey);
      EXT_SCORE_TIMER_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, scoreTimerStyle, scoreTimerCfgStyle));
    } else {
      // 全条目刷新
      this.getListData()?.forEach((ntf) => {
        let extStyle = comStyleH?.getItemSt(ntf?.groupKey);
        EXT_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, extStyle, defaultStyle));
        let pickupConStyle = pickupConStyleH?.getItemSt(ntf?.groupKey);
        EXT_PICKUP_CON_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, pickupConStyle, pickupConCfgStyle));
        let scoreTimerStyle = scoreTimerStyleH?.getItemSt(ntf?.groupKey);
        EXT_SCORE_TIMER_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, scoreTimerStyle, scoreTimerCfgStyle));
      });
    }
  }

  /**
   * 刷新条目Icon样式
   * 影响参数：屏幕断点,状态模式
   *
   * @param groupKey 条目标识
   */
  public updateListItemIconStyle(groupKey?: string): void {
    log.showWarn(TAG, `updateListItemIconStyle stateModeId=${this.stateModeId}`)
    let staticSt = this.getV1State(SlMainStateType.SL_STATIC_STATE);
    let screenBp = staticSt?.getSlState(SlStaticStateType.SCREEN_BP) as ScreenBp;
    let defaultStyle = this.getStyleCfHelper()?.getListItemStyle(ListStyleSuffix.ITEM_ICON_STYLE, screenBp?.bpSplice);
    let comStyleH = this.getItemHelperVm()?.getListStyleH(ListStyleSuffix.ITEM_ICON_STYLE);
    // 单条目刷新
    if (groupKey) {
      let iconStyle = comStyleH?.getItemSt(groupKey);
      ITEM_ICON_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, iconStyle, defaultStyle));
    } else {
      // 全条目刷新
      this.getListData()?.forEach((ntf) => {
        let iconStyle = comStyleH?.getItemSt(ntf?.groupKey);
        ITEM_ICON_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, iconStyle, defaultStyle));
      });
    }
  }

  /**
   * 刷新列表普通通知时间文本样式
   * 影响参数：屏幕断点,状态模式
   *
   * @param groupKey 条目标识
   */
  public updateListItemTimeStyle(groupKey?: string): void {
    let screenBp = this.getScreenBp();
    let defaultStyle = this.getStyleCfHelper()?.getListItemStyle(ListStyleSuffix.ITEM_TIME_STYLE, screenBp?.bpSplice);
    let comStyleH = this.getItemHelperVm()?.getListStyleH(ListStyleSuffix.ITEM_TIME_STYLE);
    // 单条目刷新
    if (groupKey) {
      let timeStyle = comStyleH?.getItemSt(groupKey);
      ITEM_TIME_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, timeStyle, defaultStyle));
    } else {
      // 全条目刷新
      this.getListData()?.forEach((ntf) => {
        let timeStyle = comStyleH?.getItemSt(ntf?.groupKey);
        ITEM_TIME_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, timeStyle, defaultStyle));
      });
    }
  }

  /**
   * 刷新列表系统实况样式
   * 影响参数：屏幕断点,状态模式
   *
   * @param groupKey 条目标识
   */
  public updateListSysLiveStyle(groupKey?: string): void {
    let screenBp = this.getScreenBp();
    let defaultStyle =
      this.getStyleCfHelper()?.getListItemStyle(ListStyleSuffix.SYS_LIVE_BUTTON_STYLE, screenBp?.bpSplice);
    let comStyleH = this.getItemHelperVm()?.getListStyleH(ListStyleSuffix.SYS_LIVE_BUTTON_STYLE);
    let progressCfgStyle =
      this.getStyleCfHelper()?.getListItemStyle(ListStyleSuffix.SYS_LIVE_PROGRESS_STYLE, screenBp?.bpSplice);
    let progressStyleH = this.getItemHelperVm()?.getListStyleH(ListStyleSuffix.SYS_LIVE_PROGRESS_STYLE);
    let contentCfgStyle =
      this.getStyleCfHelper()?.getListItemStyle(ListStyleSuffix.SYS_LIVE_CONTENT_STYLE, screenBp?.bpSplice);
    let contentStyleH = this.getItemHelperVm()?.getListStyleH(ListStyleSuffix.SYS_LIVE_CONTENT_STYLE);
    // 单条目刷新
    if (groupKey) {
      let sysBtnStyle = comStyleH?.getItemSt(groupKey);
      let sysProgressStyle = progressStyleH?.getItemSt(groupKey);
      SYS_BTN_PROGRESS_STYLE_PT.forEach((pt) => {
        this.setStyleProperty(pt, sysBtnStyle, defaultStyle);
        this.setStyleProperty(pt, sysProgressStyle, progressCfgStyle);
      });
      let contentStyle = contentStyleH?.getItemSt(groupKey);
      SYS_CONTENT_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, contentStyle, contentCfgStyle));
    } else {
      // 全条目刷新
      this.getListData()?.forEach((ntf) => {
        let sysBtnStyle = comStyleH?.getItemSt(ntf?.groupKey);
        let sysProgressStyle = progressStyleH?.getItemSt(ntf?.groupKey);
        SYS_BTN_PROGRESS_STYLE_PT.forEach((pt) => {
          this.setStyleProperty(pt, sysBtnStyle, defaultStyle);
          this.setStyleProperty(pt, sysProgressStyle, progressCfgStyle);
        });
        let contentStyle = contentStyleH?.getItemSt(ntf?.groupKey);
        SYS_CONTENT_STYLE_PT.forEach((pt) => this.setStyleProperty(pt, contentStyle, contentCfgStyle));
      });
    }
  }

  /**
   * 刷新三方实况辅助区文本及按钮样式
   * 影响参数：状态模式
   *
   * @param groupKey 条目标识
   */
  public updateListExtViewTextButtonStyle(groupKey?: string): void {
    let screenBp = this.getScreenBp();
    let textCfStyle =
      this.getStyleCfHelper()?.getListItemStyle(ListStyleSuffix.OTHER_EXT_VIEW_TEXT_STYLE, screenBp?.bpSplice);
    let textStyleH = this.getItemHelperVm()?.getListStyleH(ListStyleSuffix.OTHER_EXT_VIEW_TEXT_STYLE);
    let textWantCfStyle =
      this.getStyleCfHelper()?.getListItemStyle(ListStyleSuffix.OTHER_EXT_VIEW_WANT_STYLE, screenBp?.bpSplice);
    let textWantStyleH = this.getItemHelperVm()?.getListStyleH(ListStyleSuffix.OTHER_EXT_VIEW_WANT_STYLE);
    let buttonCfStyle =
      this.getStyleCfHelper()?.getListItemStyle(ListStyleSuffix.OTHER_EXT_VIEW_BTN_STYLE, screenBp?.bpSplice);
    let buttonStyleH = this.getItemHelperVm()?.getListStyleH(ListStyleSuffix.OTHER_EXT_VIEW_BTN_STYLE);
    // 单条目刷新
    if (groupKey) {
      let textStyle = textStyleH?.getItemSt(groupKey);
      let textWantStyle = textWantStyleH.getItemSt(groupKey);
      let buttonStyle = buttonStyleH?.getItemSt(groupKey);
      OTHER_EXT_VIEW_TEXT_STYLE_PT.forEach((pt) => {
        this.setStyleProperty(pt, textStyle, textCfStyle);
      });
      OTHER_EXT_VIEW_TEXT_WANT_STYLE_PT.forEach((pt) => {
        this.setStyleProperty(pt, textWantStyle, textWantCfStyle);
      });
      OTHER_EXT_VIEW_BUTTON_STYLE_PT.forEach((pt) => {
        this.setStyleProperty(pt, buttonStyle, buttonCfStyle);
      });
    } else {
      // 全条目刷新
      this.getListData()?.forEach((ntf) => {
        let textStyle = textStyleH?.getItemSt(ntf?.groupKey);
        let textWantStyle = textWantStyleH.getItemSt(ntf?.groupKey);
        let buttonStyle = buttonStyleH?.getItemSt(ntf?.groupKey);
        OTHER_EXT_VIEW_TEXT_STYLE_PT.forEach((pt) => {
          this.setStyleProperty(pt, textStyle, textCfStyle);
        });
        OTHER_EXT_VIEW_TEXT_WANT_STYLE_PT.forEach((pt) => {
          this.setStyleProperty(pt, textWantStyle, textWantCfStyle);
        });
        OTHER_EXT_VIEW_BUTTON_STYLE_PT.forEach((pt) => {
          this.setStyleProperty(pt, buttonStyle, buttonCfStyle);
        });
      });
    }
  }

  /**
   * 重置条目状态，包括恢复侧滑的条目、收起组通知和关闭设置菜单
   */
  public resetItem(): void {
    this.getListVm().getSlNtfList()?.forEach((ntf) => {
      // 恢复侧滑的条目
      let swipeVm = this.vmInjector?.getSwipeVm(ntf);
      if (swipeVm?.offsetX !== 0) {
        swipeVm?.resetOffsetX(true);
      }
      // 收起展开的组通知
      let groupVm = this.vmInjector?.getNormalGroupVm(ntf);
      if (groupVm?.isExpanded) {
        groupVm?.collapseGroup();
      }
    })
    // 收起设置菜单
    this.getSettingDialog()?.hide();
    if (this.getSilenceDialog()?.isShowFlag) {
      this.getSilenceDialog()?.hide();
    }
    if (this.getPinTopDialog()?.isShow) {
      this.getPinTopDialog()?.onCancel();
    }
  }

  /**
   * 切换状态模式
   * 影响参数：系统深浅色模式，AOD场景
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
    // 状态模式切换，更新相关样式配置
    this.updateAllItemStyle();
  }

  /**
   * 刷新列表可交互状态
   * 影响参数：沉浸状态
   */
  private updateListEnable(): void {
    // 显示列表态则可交互
    let isShowList = this.immersiveState.isShowList();
    let style = this.getRootStyleSt();
    if (style?.isEnable() !== isShowList) {
      log.showInfo(TAG, `refreshListEnable isEnable: ${isShowList}`);
      style?.setEnable(isShowList);
    }
  }

  /**
   * 刷新列表可见性
   * 影响参数：动效中状态，沉浸状态
   */
  private updateListVisibility(): void {
    let listVisibility = this.getListVisibility();
    let style = this.getRootStyleSt();
    if (style?.getVisibility() !== listVisibility) {
      log.showInfo(TAG, `refreshListVisibility listVisibility: ${listVisibility}`);
      style?.setVisibility(listVisibility);
      // 通知展开状态，更新back手势使能
      if (listVisibility === Visibility.Visible) {
        ImmersiveComHelper.enableBackGesture(true);
      }
    }
  }

  /**
   * 列表可见性
   *
   * @returns 可见性
   */
  private getListVisibility(): Visibility {
    // 动效期间，保持可见
    if (this.getListVm()?.getSlAnimState()?.isWidgetAnimating()) {
      return Visibility.Visible;
    }
    // 沉浸列表态，保持可见
    return this.immersiveState?.isShowList() ? Visibility.Visible : Visibility.Hidden;
  }

  /**
   * 刷新列表宽度
   * 影响参数：屏幕断点
   */
  private updateListWidth(): void {
    let staticSt = this.getV1State(SlMainStateType.SL_STATIC_STATE);
    let screenBp = staticSt?.getSlState(SlStaticStateType.SCREEN_BP) as ScreenBp;
    let defaultStyle = this.getStyleCfHelper()?.getListRootStyle(screenBp?.bpSplice);
    let listConfig = this.getStyleCfHelper()?.getListConfig(screenBp?.bpSplice);
    let screenWidth = screenBp?.screenWidth ?? 0;
    let columnWidth = defaultStyle?.getWidth() ?? '100%';
    let gutterCf = listConfig?.getGutterConfig();
    if (gutterCf) {
      columnWidth = gutterCf.getColumnWidth(screenWidth);
    }
    this.getRootStyleSt()?.setWidth(columnWidth);
    log.showInfo(TAG, `updateListWidth columnWidth: ${columnWidth}`);
  }

  /**
   * 刷新列表间距
   * 影响参数：屏幕断点，时钟收起态高度，时钟可见性
   */
  private updateListPadding(): void {
    let screenBp = this.getScreenBp();
    let defaultStyle = this.getStyleCfHelper()?.getListRootStyle(screenBp?.bpSplice);
    let listConfig = this.getStyleCfHelper()?.getListConfig(screenBp?.bpSplice);
    let clockHeight = this.getClockHeight();
    // 时钟高度不存在时，或三方主题时钟不可见时，取默认配置高度
    if (clockHeight === 0 || !this.isClockVisible()) {
      clockHeight = listConfig?.getTopClockHeight() ?? 0;
    }
    let toolsHeight = listConfig?.getBottomToolsHeight() ?? 0;
    let resultTop = clockHeight + (defaultStyle?.getPaddingT() ?? 0);
    let paddingB = (defaultStyle?.getPaddingB() ?? 0);
    let resultBottom = toolsHeight + paddingB;
    // 刷新列表间距
    let style = this.getRootStyleSt();
    if (style?.getPaddingT() !== resultTop) {
      style?.setPaddingT(resultTop);
      log.showInfo(TAG, `refreshListPadding top: ${resultTop}`);
    }
    style?.setPaddingB(resultBottom)
      .setPaddingL(defaultStyle?.getPaddingL())
      .setPaddingR(defaultStyle?.getPaddingR());
    this.getListVm().getSlStaticState().setStateValue(SlListStaticStPt.PT_MESH_PADDING_B, paddingB);
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

  private getListData(): NotificationArray {
    return this.getListVm()?.getSlNtfList();
  }

  private getRootStyleSt(): WidgetStyleStateV2 {
    return this.getListVm()?.getSlStyleState();
  }

  private getListStaticSt(): SlListStaticStateV2 {
    return this.getListVm()?.getSlStaticState();
  }

  private getListVm(): IImmersiveListVm {
    return this.vmInjector?.getImmersiveListVm();
  }

  private getStyleCfHelper(): IImmStyleConfigHelper {
    return this.vmInjector?.getImmStyleConfigHelper();
  }

  private getItemHelperVm(): IImmItemHelperVm {
    return this.vmInjector?.getImmItemHelperVm();
  }

  private getImmersivePanelVm(): IImmersivePanelVm {
    return this.vmInjector?.getPanelVm();
  }

  private getImmColorVm(): ImmColorVm {
    return this.vmInjector?.getColorVm();
  }

  private getWholeAnimVm(): IImmersiveWholeAnimVm {
    return this.vmInjector?.getImmersiveWholeAnimVm();
  }

  private getImmCardVm(): IImmersiveCardVm {
    return this.vmInjector?.getImmersiveCardVm();
  }

  private getSettingDialog(): IImmersiveNtfSettingDialogVm | undefined {
    return this.vmInjector?.getSettingDiagVm();
  }

  private getSilenceDialog(): IImmSilenceVm | undefined {
    return this.vmInjector?.getSilenceVm();
  }

  private getPinTopDialog(): IImmersiveNtfPinTopVm | undefined {
    return this.vmInjector?.getPinTopDialogVm();
  }
}