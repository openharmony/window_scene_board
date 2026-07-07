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

import { ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { ResUtils, SCBSceneSessionManager } from '@ohos/windowscene';
import { ClockStaticData } from '../model/data/ClockStaticData';
import {
  ClockBindStateType,
  GlobalStatusCache,
  ISlStateChangeListener,
  KeyguardStatusService,
  slClockOneShotToDesktopService,
  SlSubStateType,
  slWallpaperMgr,
  StatusCacheConst,
  ScreenOnOffService,
  SlBindStateType,
  OneMirrorStaticStateType,
} from '@ohos/screenlockcommon';
import { BaseState, CommonUtil } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import {
  DisplayModeChangeListener,
  EDIT_CLOCK_MODE,
  EDIT_FORM_MODE_DETAIL,
  EDIT_FORM_MODE_MAIN,
  EDIT_FULL_MODE,
  EDIT_GUIDE_MODE,
  NONE_EDIT_MODE
} from '@ohos/screenlockcommon/Index';
import { ClockWidgetModel } from '../viewmodel/ClockWidgetModel';
import {
  ClockBuilderStyle,
  clockLayoutParam,
  ClockLayoutParam,
  DEFAULT_MERGE_MARGIN,
  ElementConf
} from '../common/ClockLayoutParam';
import { aodClockHelper, clockLayoutHelper } from '../common/ClockLayoutHelper';
import { ClockLayout, ClockTextAlign, BatteryLayout } from '../../common/WidgetParam';
import { ClockAnimData } from '../model/data/ClockAnimData';
import { ClockBindData } from '../model/data/ClockBindData';
import { clockData, ClockData, ClockDataListener } from '../model/data/ClockData';
import { VisibleKeyWrapper } from '../common/SignFormKey';
import { ImmersiveAodStyle, immersiveKgMgr, ImmersiveState } from '@ohos/systemuicommon';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/Index';
import AdminManagerModel from '../viewmodel/AdminManagerModel';
import { BusinessError } from '@kit.BasicServicesKit';
import { DynamicFontSize, sFontScaleUtil } from '../../common/utils/FontScaleUtil';
import { AccessibilityUtil } from '@ohos/screenlockcommon/src/main/ets/utils/AccessibilityUtil';
import { SlClockBindState } from '../model/data/SlClockBindState';
import { SlClockStaticState } from '../model/data/SlClockStaticState';
import { SignWidget } from './SignWidget';
import { LengthMetrics } from '@ohos.arkui.node';
import { UDFontAdapterUtil } from '../common/UDFontAdapterUtil';
import { AnimScene } from '../viewmodel/viewanim/ClockWidgetAnimManager';
import {
  AodBatteryConstants,
  BatteryPosition,
  ClockConstants,
  ART_SIGN_SHADOW_STYLE,
  ART_SIGN_SHADOW_STYLE_AOD,
  DATE_SHADOW_STYLE
} from '../common/ClockConstants';
import { PowerStatusEnum, PowerStatusMonitor, WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { SlSignBindState } from '../model/data/SlSignBindState';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import { SlMainStateType, SlStaticStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { SlWidgetId } from '@ohos/screenlockcommon/src/main/ets/constants/SlWidgetConst';
import { CLOCK_DEFAULT_FOREGROUND_COLOR } from '../../editsheet/models/AnyClock';
import { UseScene, ConfigType } from '../../common/adapter/Constans';
import { ClockAdapter, ClockAdapterFactory } from '../adapter/ClockAdapter';
import i18n from '@ohos.i18n';
import { DateTimeI18NUtil } from '../common/DateTimeI18NUtil';

const TAG = 'ClockWidget';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const SIGNATURE_MAX_LENGTH: number = 200;
const SIGNATURE_MIN_WIDTH: number = 189;
const CHAR_CLOCK_SEPARATOR: string = ':';
const BLENDMODE_SRC_OVER: number = 1000;
const BLENDMODE_DESTINATION_IN: number = 7;
const DEFAULT_VALUE: number = 1;
const AOD_CLOCK_WIDGET = 'Aod_ClockWidget';
const AOD_CLOCK_WIDGET_LONG_TAKE = 'Aod_ClockWidget_PartialLongTake';
const AOD_BATTERY_LUNAR_OFFSET_BY_MOUNTAIN_CLOCK_LAYOUT_SPECIAL = 46;
const AOD_BATTERY_OFFSET_BY_MOUNTAIN_CLOCK_LAYOUT_SPECIAL = -78;
const AOD_BATTERY_OFFSET_BY_MOUNTAIN_CLOCK_LAYOUT_SPECIAL_LEAP = -93;

/**
 * 用于时钟监听时钟样式变化，立即更新时钟样式数据
 */
export interface ClockChangeListen {
  onClockChange: (clockLayout: ClockLayout) => void;
}

interface ClockTextParam {
  text: string;
  id: string;
  fontSize: number;
  fontSizeScale?: number;
  position: Position;
  anchor?: Position;
  isClockShadow: boolean;
}

@Component
export struct ClockWidget {
  /**
   * 时钟组件适配器，组件使用方传入，组件内置默认适配器
   */
  clockAdapter: ClockAdapter = ClockAdapterFactory.wrapper(UseScene.DEFAULT_SCENE);

  /**
   * 时钟组件业务管理类，生命周期跟随ClockAdapter，并且内置数据管理器
   */
  private mClockViewModel: ClockWidgetModel = this.clockAdapter.getClockWidgetModel();

  /**
   * 获取时钟数据管理器
   */
  private dataManager = this.mClockViewModel.getDataManager();

  /**
   * 签名布局状态管理
   */
  @State slSignBindState: SlSignBindState = this.dataManager.getSlSignBindState();

  /**
   * 时钟组件UI样式状态管理
   */
  @State slClockBindCtrl: SlClockBindState = this.dataManager.getSlClockBindState();

  /**
   * 时钟组件静态状态管理
   */
  @State slClockStaticCtrl: SlClockStaticState = this.dataManager.getSlClockStaticState();

  /**
   * 时钟组件动效状态管理
   */
  @State slClockAnimCtrl: WidgetAnimState = BaseState.wrap(WidgetAnimState, TAG);

  /**
   * 时钟内部动效状态管理
   */
  @State clockAnimData: ClockAnimData = this.mClockViewModel.getClockAnimData();

  /**
   * 时钟组件内部动态状态统一管理
   */
  @State clockBindState: ClockBindData = this.mClockViewModel.getClockBindState();

  /**
   * 企业签名
   */
  @State enterpriseSignatureText: string = '';

  @StorageProp('EdmAdminEnable') @Watch('onEdmAdminEnableUpdated') edmAdminEnable: boolean = false;

  @State lunarDate: string = '';
  @State clockTime: string = '';
  @State dateStr: ResourceStr = '';
  @State bigDateStr: ResourceStr = '';
  @State weekStr: ResourceStr = '';
  @State editStatus: boolean = false;
  @State layoutParam : ClockLayoutParam = clockLayoutParam;
  @State isScreenOn: boolean = ScreenOnOffService.getInstance().isScreenOn;
  @State immersiveState: ImmersiveState = immersiveKgMgr.getImmersiveDisplayState();
  @State fontScale: DynamicFontSize = sFontScaleUtil.realDynamicSize;
  @State signatureWidth: Length | undefined = undefined;
  @Prop isPosterShadow: boolean = false;
  @State contentColor: string = ''
  // await AigcWallpaperColorManager.getLightDegree(pixelMap);
  /**
   * Aod显示样式
   */
  @State aodStyle: ImmersiveAodStyle | undefined = immersiveKgMgr.getOneMirrorState().getAodStyle(true);

  private data: ClockData | null = clockData;
  private clockStyleChangeListeners?: ClockChangeListen[];
  private listener: ClockDataListener = {
    onChanged: () => {
      this.lunarDate = this.data?.lunarDate ?? '';
      this.clockBindState.setTimeAccessibility(this.data?.timeAccessibility ?? '');
      this.clockTime = this.data?.clockTime ?? '';
      this.dateStr = this.data?.dateStr ?? '';
      this.bigDateStr = this.data?.bigDateStr ?? '';
      let weekStrTemp = this.data?.weekStr ?? '';
      if (this.weekStr !== weekStrTemp) {
        this.weekStr = weekStrTemp;
      }
      this.mClockViewModel.updateDateWeekLunarStr(this.dateStr, this.bigDateStr, this.weekStr, this.lunarDate);
      if (this.isScreenOn) {
        log.showInfo(`onClockDataChange with time ${this.clockTime}, date ${this.dateStr} or ${this.bigDateStr}, ` +
          `week ${this.weekStr} and lunar date ${this.lunarDate}`);
      }
    }
  }

  private screenOnStatusChangeCallback = () => {
    log.showInfo(`${this.slClockStaticCtrl.getClockViewId()} onScreenOn`);
    this.data?.updateTime();
    this.isScreenOn = GlobalStatusCache.getInstance().getStatus(StatusCacheConst.SCREEN_ON_KEY,
      ScreenOnOffService.getInstance().isScreenOn) as boolean;
  };

  private displayModeChangeCallback: DisplayModeChangeListener = {
    onDisplayModeChange: (newMode: number) => {
      if (this.isEnterThemeEditor(this.clockBindState.getDisplayMode(), newMode)) {
        log.showInfo('enter edit mode ');
        if (this.mClockViewModel.getIsNotificationExpand() || KeyguardStatusService.isSlGreetMode()) {
          this.mClockViewModel.updateClockCollapseState(true);
        }
      } else if (this.isExitThemeEditor(this.clockBindState.getDisplayMode(), newMode)) {
        if (this.mClockViewModel.getIsNotificationExpand()) {
          log.showInfo('recover clock to collapse');
          this.mClockViewModel.updateClockCollapseState(false);
        }
      }
      this.clockBindState.setDisplayMode(newMode);
      this.editStatus = this.clockBindState.getDisplayMode() === EDIT_GUIDE_MODE ||
        this.clockBindState.getDisplayMode() === EDIT_FULL_MODE ||
        this.clockBindState.getDisplayMode() === EDIT_CLOCK_MODE;
    }
  };

  /**
   * 监听到beginWakeUp事件时及时刷新时钟时间
   */
  private handleBeginWakeUp = (): void => {
    log.showDebug('handle begin wakeUp');
    clockData.updateTime();
    animateToImmediately({ duration: 0 }, () => {});
  }

  private isEnterThemeEditor(oldMode: number, newMode: number): boolean {
    return oldMode === NONE_EDIT_MODE && newMode === EDIT_GUIDE_MODE;
  }

  private isExitThemeEditor(oldMode: number, newMode: number) {
    return newMode === NONE_EDIT_MODE &&
      (oldMode === EDIT_GUIDE_MODE ||
        oldMode === EDIT_FULL_MODE ||
        oldMode === EDIT_CLOCK_MODE ||
        oldMode === EDIT_FORM_MODE_MAIN ||
        oldMode === EDIT_FORM_MODE_DETAIL);
  }

  /**
   * 时钟样式状态监听器
   */
  private clockStyleListener: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_CLOCK_WG_BIND_STATE,
    onSlStateChange: (mainType: SlMainStateType, subType?: SlSubStateType): void => {
      if (subType === ClockBindStateType.POSITION_X || subType === ClockBindStateType.POSITION_Y ||
        subType === ClockBindStateType.FONT_FAMILY || subType === ClockBindStateType.TEXT_ALIGN) {
        this.onParamUpdated();
      }
    }
  };

  /**
   * 锁屏状态监听
   */
  private slBindStateTypeListener: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_BIND_STATE,
    onSlStateChange: (mainType: SlMainStateType, subType?: SlSubStateType): void => {
      if (subType === SlBindStateType.DISABLE_CLOCK_SHADOW) {
        const slBindState = slUiStateMgr.getSlState(SlMainStateType.SL_BIND_STATE);
        let disableClockShadow = slBindState?.getSlState(SlBindStateType.DISABLE_CLOCK_SHADOW);
        this.slClockBindCtrl.setTextShadow(!disableClockShadow);
      }
    }
  };

  /**
   * 时钟颜色状态监听器
   */
  private clockTextColorListener: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_CLOCK_WG_BIND_STATE,
    onSlStateChange: (mainType: SlMainStateType, subType?: SlSubStateType): void => {
      if (subType === ClockBindStateType.TEXT_COLOR || subType === ClockBindStateType.STROKE_COLOR) {
        this.mClockViewModel.updateTextColorOnStyleChange(this.getBrightTextColor() as string);
        this.slClockStaticCtrl?.setChangeColorState(this.slClockBindCtrl.getClockStrokeColor() !==
          CLOCK_DEFAULT_FOREGROUND_COLOR);
        this.updateClockStyle();
      }
    }
  };

  /**
   * 时钟布局状态监听器
   */
  private clockLayoutListener: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_CLOCK_WG_BIND_STATE,
    onSlStateChange: (mainType: SlMainStateType, subType?: SlSubStateType): void => {
      if (subType === ClockBindStateType.CLOCK_LAYOUT) {
        log.showInfo(`${this.slClockStaticCtrl.getClockViewId()} ` +
          `onClockLayoutUpdated Position ${this.slClockBindCtrl.getClockLayout()}`);
        UDFontAdapterUtil.handleLayoutChange(this.slClockBindCtrl.getClockLayout());
        this.onClockChange(this.slClockBindCtrl.getClockLayout());
      }
    }
  };

  /**
   * 时钟签名状态监听器
   */
  private clockSignatureListener: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_CLOCK_WG_BIND_STATE,
    onSlStateChange: (mainType: SlMainStateType, subType?: SlSubStateType): void => {
      if (subType === ClockBindStateType.SIGNATURE_VISIBLE || subType === ClockBindStateType.SIGNATURE_TEXT) {
        log.showWarn(`onSignatureTextChanged ${this.slClockBindCtrl.getSignatureVisible()} : ` +
          `${this.slClockBindCtrl.getSignatureText()?.length}`);
        this.updateEnterpriseSignatureText();
        this.onParamUpdated();
      }
    }
  };

  async aboutToAppear(): Promise<void> {
    this.populateDataFromAdapter();
    let isLock = slUiStateMgr.getSlState(SlMainStateType.SL_STATIC_STATE)
    ?.getSlState(SlStaticStateType.SL_HOST_STATE) as boolean ?? true;
    if ((this.slClockStaticCtrl.getClockViewId() === AOD_CLOCK_WIDGET ||
      this.isPartialLongTakeAodStyle()) && !isLock) {
      log.showWarn('screen lock state is unlock, no need init aod clock widget.');
      return;
    }
    if (this.slClockStaticCtrl.getIsPreviewPage()) {
      this.mClockViewModel.setClockHelper(aodClockHelper);
    }
    this.mClockViewModel.setIsNeedRefreshClockLayout(!!this.slClockStaticCtrl?.getIsNeedRefreshClockLayout());
    this.mClockViewModel.setClockViewId(this.slClockStaticCtrl.getClockViewId(),
      this.slClockStaticCtrl.getClockViewId() === ClockConstants.COMPONENT_ID_DIGITAL_VIEW);
    this.mClockViewModel.getClockStaticState().isSubScreen = this.slClockStaticCtrl.getIsSubScreen();
    this.mClockViewModel.getClockStaticState().subScreenGridWidth = this.slClockStaticCtrl.getSubScreenGridWidth();
    this.mClockViewModel.initViewModel(this.displayModeChangeCallback, this.slClockStaticCtrl.getClockViewId());
    this.mClockViewModel.setImmersivePanelRelated(!!this.slClockStaticCtrl?.getHasNtfRelatedAnimation());
    this.updateEnterpriseSignatureText();
    this.mClockViewModel.updateClockElementVisible(this.isSignatureVisible(), this.slClockStaticCtrl.getLunarVisible(),
      this.slClockStaticCtrl.getDateVisible());
    if (this.isNeedRefreshLayoutParam()) {
      GlobalStatusCache.getInstance().subscribe(StatusCacheConst.SCREEN_ON_KEY, this.screenOnStatusChangeCallback);
    } else {
      this.layoutParam = new ClockLayoutParam();
    }
    this.data?.registerDataChanged(this.listener);
    this.dataManager.registerSlStateChangeListener(this.clockStyleListener);
    slUiStateMgr.registerSlStateChangeListener(this.slBindStateTypeListener);
    this.dataManager.registerSlStateChangeListener(this.clockTextColorListener);
    this.dataManager.registerSlStateChangeListener(this.clockLayoutListener);
    this.dataManager.registerSlStateChangeListener(this.clockSignatureListener);
    if (!this.isPartialLongTakeAodStyle()) {
      this.mClockViewModel.setClockLayoutParam(this.layoutParam);
    }
    UDFontAdapterUtil.handleLayoutChange(this.slClockBindCtrl.getClockLayout());
    UDFontAdapterUtil.handleFontChange(this.slClockBindCtrl.getFontFamily());
    this.mClockViewModel.updateClockLayout(this.slClockBindCtrl.getClockLayout(), this.slClockBindCtrl.getPositionX(),
      this.slClockBindCtrl.getPositionY());
    this.mClockViewModel.updateClockLayoutParam();
    this.mClockViewModel.updateTextColorOnStyleChange(this.getBrightTextColor() as string);
    this.clockStyleChangeListeners?.push(this);
    this.updateClockStyle();
    this.mClockViewModel?.initClockOneShotAnim();
    PowerStatusMonitor.getInstance().subscribe(PowerStatusEnum.BEGIN_WAKE_UP, this.handleBeginWakeUp);
    this.slClockStaticCtrl.setIsClockMarginNeedAnim(true);
    //获取锁屏壁纸的亮度等级
    this.contentColor = await SCBSceneSessionManager.getInstance().updateLockViewColor()
    log.showInfo(`${this.slClockStaticCtrl.getClockViewId()} aboutToAppear ` +
      `clockLayout: ${this.slClockBindCtrl.getClockLayout()}` +
      `, textShadow:${this.slClockBindCtrl.getTextShadow()}` +
      `, blurEffect: ${this.slClockBindCtrl.getTextBlurEffect()}, textColor: ${this.slClockBindCtrl.getTextColor()}` +
      `, sign:${this.getSignatureText()?.length ?? 0} this.aodStyle?.isAod = ${this.aodStyle?.isAod}` +
      `, isExpand: ${ClockStaticData.sIsClockWidgetExpand}` +
      `, isToDesktop: ${this.mClockViewModel.getClockStaticState().isClockToCollapseOnDesktop}`);
  }

  private populateDataFromAdapter(): void {
    this.mClockViewModel = this.clockAdapter.getClockWidgetModel();
    this.dataManager = this.mClockViewModel.getDataManager();
    this.slSignBindState = this.dataManager.getSlSignBindState();
    this.slClockBindCtrl = this.dataManager.getSlClockBindState();
    this.slClockStaticCtrl = this.dataManager.getSlClockStaticState();
    this.slClockAnimCtrl = this.slClockStaticCtrl.getSlClockAnimCtrl();
    this.clockAnimData = this.mClockViewModel.getClockAnimData();
    this.clockBindState = this.mClockViewModel.getClockBindState();
  }

  private isSignatureTextShow() : boolean {
    if (this.slClockBindCtrl.getSignatureText() !== '' && this.slClockBindCtrl.getSignatureVisible()) {
      return true;
    }
    return false;
  }

  private isNeedRefreshLayoutParam(): boolean {
    return this.slClockStaticCtrl.getClockViewId() === ClockConstants.COMPONENT_ID_DIGITAL_VIEW ||
      ((this.slClockStaticCtrl.getClockViewId() === AOD_CLOCK_WIDGET || this.isPartialLongTakeAodStyle()) &&
        !DeviceHelper.isPadOr2in1PcType() && (!this.slClockStaticCtrl.getIsPreviewPage() ||
      this.isPartialLongTakeAodStyle()));
  }

  private onEdmAdminEnableUpdated(): void {
    log.showWarn(`onEdmAdminEnableUpdated :${this.edmAdminEnable}`);
    this.mClockViewModel.updateEnterpriseSignVisible(this.edmAdminEnable);
    this.updateEnterpriseSignatureText(true);
  }

  private updateClockStyle(): void {
    this.slClockBindCtrl?.setChangeColorState(this.slClockStaticCtrl?.getChangeColorState() ?? false);
    this.mClockViewModel.setBackgroundColor(this.getBrightTextColor());
    this.mClockViewModel.updateClockBrightnessOption();
  }

  private getBrightTextColor(): ResourceColor {
    if (!this.slClockBindCtrl.getEnableBright()) {
      return this.slClockBindCtrl.getTextColor();
    }
    return BrightnessOptionUtils.changeColor(this.slClockBindCtrl.getTextColor()) ??
    this.slClockBindCtrl.getTextColor();
  }

  private onParamUpdated(): void {
    log.showWarn(`${this.slClockStaticCtrl.getClockViewId()} onParamUpdated Position` +
      ` ${this.slClockBindCtrl.getPositionX()}, ${this.slClockBindCtrl.getSignatureVisible()}, ` +
      `${this.slClockBindCtrl.getSignatureText()?.length}`);
    this.mClockViewModel.updateClockElementVisible(this.isSignatureVisible(), this.slClockStaticCtrl.getLunarVisible(),
      this.slClockStaticCtrl.getDateVisible());
    this.mClockViewModel.updateFontFamily(this.slClockBindCtrl.getFontFamily());
    this.mClockViewModel.updateClockLayout(this.slClockBindCtrl.getClockLayout(), this.slClockBindCtrl.getPositionX(),
      this.slClockBindCtrl.getPositionY());
  }

  onClockChange = (clockLayout: ClockLayout): void => {
    log.showInfo(`${this.slClockStaticCtrl.getClockViewId()} onClockChange Position ${clockLayout}`);
    this.mClockViewModel.updateClockLayoutByManualEdit(clockLayout);
  }

  aboutToDisappear(): void {
    log.showDebug(`${this.slClockStaticCtrl.getClockViewId()} aboutToDisappear`);
    PowerStatusMonitor.getInstance().unsubscribe(PowerStatusEnum.BEGIN_WAKE_UP, this.handleBeginWakeUp);
    ArrayUtils.deleteArr(this.clockStyleChangeListeners, this);
    if (this.isNeedRefreshLayoutParam()) {
      GlobalStatusCache.getInstance().unsubscribe(StatusCacheConst.SCREEN_ON_KEY, this.screenOnStatusChangeCallback);
    }
    this.data?.unregisterDataChanged(this.listener);
    this.dataManager.unregisterSlStateChangeListener(this.clockStyleListener);
    slUiStateMgr.unregisterSlStateChangeListener(this.slBindStateTypeListener);
    this.dataManager.unregisterSlStateChangeListener(this.clockTextColorListener);
    this.dataManager.unregisterSlStateChangeListener(this.clockLayoutListener);
    this.dataManager.unregisterSlStateChangeListener(this.clockSignatureListener);
    this.data = null;
    this.mClockViewModel.destroyViewModel();
  }

  /**
   * 获取签名对齐方案
   * @param conf 当前时钟的布局参数
   * @returns 签名对齐参数
   */
  private getAlignment(conf: ElementConf): Alignment {
    let textAlign = conf.dynamicTextAlign ?? conf.textAlign;
    switch (textAlign) {
      case ClockTextAlign.LEFT:
        return RTLUtil.isRTL() ? Alignment.End : Alignment.Start;
      case ClockTextAlign.RIGHT:
        return RTLUtil.isRTL() ? Alignment.Start : Alignment.End;
      case ClockTextAlign.CENTER:
      default:
        return Alignment.Center;
    }
  }

  private getTimeFontWeight(): FontWeight | undefined { // 时间文本字重
    if (UDFontAdapterUtil.isSupportByFont(this.slClockBindCtrl.getFontFamily())) {
      return undefined;
    }
    let family = clockLayoutHelper.adapterTimeViewFontFamily(this.slClockBindCtrl.getFontFamily());
    return this.mClockViewModel.getClockStaticState().getTimeFontWeight(family);
  }

  private isSignVisible(): boolean { // 签名可见性
    return this.slClockBindCtrl.getSignatureVisible() || this.mClockViewModel.getClockStaticState().getSignVisible();
  }

  private isValidSignText(): boolean {
    return (this.getSignatureText()?.length ?? 0) > 0
  }

  private isSignatureVisible(): boolean {
    return (this.slClockBindCtrl.getSignatureVisible() ||
      this.mClockViewModel.getClockStaticState().isEnterpriseSignVisible) && this.isValidSignText();
  }

  private getWidgetOffset(conf: ElementConf): Position { // 组件偏移
    if (this.isAodBatteryShow() && conf.aodOffset) {
      return conf.aodOffset;
    }
    let offsetForOneShot = this.clockBindState.textOffSets.get(conf.id);
    if (offsetForOneShot) {
      return offsetForOneShot;
    }

    let defaultOffset = conf.offset;
    if (conf.dynamicOffset) { // 动态偏移
      defaultOffset = conf.dynamicOffset;
    }
    if (conf.dynamicDyMap) { // 相对偏移，只受签名可见性影响
      const isSignVisible = this.isSignatureVisible();
      const hasFormCard = this.slClockBindCtrl?.hasAddedFormCard() ?? false;
      let key = VisibleKeyWrapper.getKey({
        isSignVisible: isSignVisible,
        isFormVisible: hasFormCard && !this.slClockBindCtrl.getIsSmallOuter()
      });
      let dy = conf.dynamicDyMap.getProperty(key) ?? 0;
      return { x: defaultOffset.x, y: (defaultOffset.y as number) + dy };
    }
    return defaultOffset; // 默认位移
  }

  private getClockTextAnchor(conf: ElementConf): Position | undefined {
    if (this.slClockBindCtrl.getClockLayout() >= 200) {
      return conf.anchor;
    }

    return undefined;
  }

  private getWidgetAnchor(conf: ElementConf): Position { // 组件锚点
    if (this.isAodBatteryShow() && conf.aodAnchor) {
      return conf.aodAnchor;
    }
    return conf.dynamicAnchor ?? conf.anchor;
  }

  private getSeparatorVisibility(isLine: boolean): Visibility { // 分隔符组件是否可见
    let isShow = this.layoutParam.separatorConf.isShow &&
      (isLine ? this.layoutParam.gridParam.specialSeparator : !this.layoutParam.gridParam.specialSeparator);
    let isAnimating = isLine ? this.clockAnimData.lineSeparatorAnimating : this.clockAnimData.pointSeparatorAnimating;
    if (isShow || isAnimating) {
      return Visibility.Visible;
    }
    return Visibility.Hidden;
  }

  private getSeparatorAlpha(isLine: boolean): number | undefined { // 分隔符组件透明度
    let isAnimating = isLine ? this.clockAnimData.lineSeparatorAnimating : this.clockAnimData.pointSeparatorAnimating;
    if (isAnimating) {
      return isLine ? this.clockAnimData.lineSeparatorAlpha : this.clockAnimData.pointSeparatorAlpha;
    }
    return undefined;
  }

  private getSignScale(): ScaleOptions | undefined { // 签名组件整体缩放
    let bindScaleValue: number | undefined = this.slSignBindState?.getLayoutScale();
    if (!bindScaleValue) {
      bindScaleValue = 1;
    }
    let fontSizeScale: number | undefined = this.layoutParam.signConf.fontSizeScale;
    if (!fontSizeScale) {
      fontSizeScale = 1;
    }
    return {
      x: bindScaleValue * fontSizeScale,
      y: bindScaleValue * fontSizeScale,
      centerX: this.layoutParam.signConf.anchor.x?.toString(),
      centerY: this.layoutParam.signConf.anchor.y?.toString(),
    };
  }

  private getAodBatteryScale(): number { // AodBattery组件缩放比例
    if (this.slClockBindCtrl.getIsSmallOuter()) {
      return AodBatteryConstants.AOD_BATTERY_SMALL_FOLD_SCALE;
    }
    return AodBatteryConstants.AOD_BATTERY_DEFAULT_SCALE;
  }

  private getOpacity(): number { // 签名组件透明度
    if (this.aodStyle?.isAod || this.slClockStaticCtrl.getIsPreviewPage()) {
      // aod签名组件透明度由 this.clockBindState.noTimeViewOpacity 控制, getOpacity不进行处理
      return 1;
    }
    return this.slSignBindState?.getLayoutOpacity() ?? 1;
  }

  private getFontColor(): ResourceColor | undefined {
    return this.mClockViewModel.getFontColor({
      slClockAnimCtrl: this.slClockAnimCtrl,
      slClockBindCtrl: this.slClockBindCtrl,
      slClockStaticCtrl: this.slClockStaticCtrl,
      textBlurEffect: this.slClockBindCtrl.getTextBlurEffect(),
      staticState: this.mClockViewModel.getClockStaticState()
    });
  }

  private getBackgroundColor(): ResourceColor | undefined {
    return this.mClockViewModel.getBackgroundColor({
      slClockAnimCtrl: this.slClockAnimCtrl,
      slClockBindCtrl: this.slClockBindCtrl,
      slClockStaticCtrl: this.slClockStaticCtrl,
      textBlurEffect: this.slClockBindCtrl.getTextBlurEffect(),
      staticState: this.mClockViewModel.getClockStaticState()
    });
  }

  private getBrightnessOption(): BrightnessOptions | undefined {
    if (!this.slClockBindCtrl.getEnableBright()) {
      return undefined;
    }
    let brightnessOptions: BrightnessOptions;
    if (this.slClockAnimCtrl?.isSceneAnimating() && !this.mClockViewModel.isImmersiveScene(this.slClockAnimCtrl)) {
      brightnessOptions = this.slClockAnimCtrl.getFgBrightness() ??
      BrightnessOptionUtils.aodTimeLightOptionForFillColor;
    } else {
      brightnessOptions = this.slClockBindCtrl?.getBrightness() ?? BrightnessOptionUtils.keyguardTimeLightOption;
      brightnessOptions = this.slClockBindCtrl?.getRemoveBrightness() && brightnessOptions ?
        this.removeBrightnessByChangeFraction(brightnessOptions) : brightnessOptions;
    }
    if (brightnessOptions.fraction >= 1) {
      log.showWarn(`getBrightnessOption fraction : ${brightnessOptions.fraction}`);
    }
    return brightnessOptions;
  }

  private removeBrightnessByChangeFraction(brightnessOptions: BrightnessOptions): BrightnessOptions {
    return {
      rate: brightnessOptions.rate,
      lightUpDegree: brightnessOptions.lightUpDegree,
      cubicCoeff: brightnessOptions.cubicCoeff,
      quadCoeff: brightnessOptions.quadCoeff,
      saturation: brightnessOptions.saturation,
      posRGB: brightnessOptions.posRGB,
      negRGB: brightnessOptions.negRGB,
      fraction: 0.90
    };
  }

  private getVp(fontSize: number): string {
    return `${fontSize}vp`;
  }

  private getSignatureText(): string {
    const signatureText: string =
      (this.enterpriseSignatureText ? this.enterpriseSignatureText : this.slClockBindCtrl.getSignatureText())?.slice(0,
        SIGNATURE_MAX_LENGTH);
    return signatureText;
  }

  private isShowSignature(): boolean {
    if (!this.isPartialLongTakeAodStyle() &&
    this.immersiveState.isImmersive() && this.clockBindState.getDisplayMode() === NONE_EDIT_MODE) {
      return false;
    }

    if (!this.isScreenOn && !this.aodStyle?.isAod) {
      return false;
    }

    if (this.slClockBindCtrl.getIsSmallOuter()) {
      return false;
    }

    return !!(this.isSignatureTextShow() ||
      (this.enterpriseSignatureText && this.enterpriseSignatureText !== '' && !this.isArtSignLayout()));
  }

  private getAccessibilityBigDateStr(): string {
    if (typeof (this.dateStr) === 'string') {
      return this.dateStr;
    } else {
      return ResUtils.getInnerString(this.dateStr);
    }
  }

  /**
   * 艺术签名字体只支持中英文，当系统语言是非中英文时，日期、星期用系统默认字体
   *
   * @returns
   */
  private getAdapterFontFamily(): string | Resource | undefined {
    if (this.slClockBindCtrl?.getClockLayout() >= 200) {
      return DateTimeI18NUtil.isArtSupportLanguage() ? this.slClockBindCtrl?.getFontFamily() : undefined;
    }
    return this.getDigitFontFamily();
  }

  private getFontFamily(): string | Resource | undefined {
    if (this.slClockBindCtrl?.getClockLayout() >= 200) {
      return clockLayoutHelper?.adapterTimeViewFontFamily(this.slClockBindCtrl?.getFontFamily());
    }
    return this.getDigitFontFamily();
  }

  private getDigitFontFamily(): string | Resource | undefined {
    if (this.slClockStaticCtrl?.getAllShowConfigFont()) {
      return clockLayoutHelper.adapterTimeViewFontFamily(this.slClockBindCtrl?.getFontFamily());
    }
    return undefined;
  }

  @Builder
  DateViewBuilder(style: ClockBuilderStyle) { // 日期组件
    if (this.clockBindState.isShowLargeDate) {
      Text(this.bigDateStr)
        .id(`date_large_${style.sceneId}`)
        .fontColor(this.getFontColor())
        .fontFamily(clockLayoutHelper.adapterTimeViewFontFamily(this.slClockBindCtrl.getFontFamily()))
        .fontSize(this.getVp(this.layoutParam.dateConf.fontSize))
        .fontWeight(this.getTimeFontWeight())
        .offset(style.offset)
        .markAnchor(style.anchor)
        .draggable(false)
        .clip(false)
        // 元素共享组件继承父组件位移等属性
        .geometryTransition(this.clockAnimData.dateGeoId, { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
        .transition(this.clockAnimData.dateTransition)
        // ss10属性来保证数字竖排对齐
        .fontFeature('\"ss10\" on')
        .accessibilityText(this.getAccessibilityBigDateStr())
        .opacity(this.clockBindState.noTimeViewOpacity)
        .scale(style.fontScale)
        .textShadow(this.getTextShadowEnable() ? this.getTextShadowStyle(true) : undefined)
    } else {
      Row() {
        Text(this.dateStr)
          .id(`date_normal_${style.sceneId}`)
          .fontColor(this.getFontColor())
          .fontSize(this.layoutParam.dateConf.fontSize)
          .fontFamily(this.getAdapterFontFamily())
          .minFontScale(sFontScaleUtil.minFontSize)
          .maxFontScale(sFontScaleUtil.maxClockFontSize)
          .fontWeight(FontWeight.Medium)
          .draggable(false)
          .clip(false)
          .geometryTransition(this.clockAnimData.dateGeoId, { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
          .transition(this.clockAnimData.dateTransition)
          .accessibilityText(this.getAccessibilityBigDateStr())
          .opacity(this.clockBindState.noTimeViewOpacity)
      }
      .direction(Direction.Ltr)
      .offset(style.offset)
      .markAnchor(style.anchor)
      .scale(style.fontScale)
      .shadow(this.getTextShadowEnable() ? this.getTextShadowStyle(true) : undefined)
    }
  }

  @Builder
  WeekViewBuilder(style: ClockBuilderStyle) { // 星期组件
    Row() {
      Text(this.weekStr)
        .id(`week_${style.sceneId}`)
        .fontColor(this.getFontColor())
        .fontSize(this.layoutParam.weekConf.fontSize)
        .fontFamily(this.getAdapterFontFamily())
        .minFontScale(sFontScaleUtil.minFontSize)
        .maxFontScale(sFontScaleUtil.maxClockFontSize)
        .fontWeight(FontWeight.Medium)
        .draggable(false)
        .clip(false)
        .geometryTransition(this.clockAnimData.weekGeoId, { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
        .transition(TransitionEffect.IDENTITY)
        .opacity(this.clockBindState.noTimeViewOpacity)

    }
    .direction(Direction.Ltr)
    .offset(style.offset)
    .markAnchor(style.anchor)
    .scale(style.fontScale)
    .shadow(this.getTextShadowEnable() ? this.getTextShadowStyle(true) : undefined)
  }

  @Builder
  LunarViewBuilder(style: ClockBuilderStyle) { // 农历组件
    Row() {
      if (ClockData.isChinese) {
        Text(this.lunarDate)
          .id(`lunar_${style.sceneId}`)
          .fontColor(this.getFontColor())
          .fontSize(this.layoutParam.lunarConf.fontSize)
          .fontFamily(this.getFontFamily())
          .minFontScale(sFontScaleUtil.minFontSize)
          .maxFontScale(sFontScaleUtil.maxClockFontSize)
          .fontWeight(FontWeight.Medium)
          .draggable(false)
          .clip(false)
          .geometryTransition(this.clockAnimData.lunarGeoId, { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
          .transition(TransitionEffect.IDENTITY)
          .opacity(this.clockBindState.noTimeViewOpacity)
          .offset({
            x: this.getAodBatteryLunarOffset(),
          })
      }
    }
    .direction(Direction.Ltr)
    .offset(style.offset)
    .markAnchor(style.anchor)
    .scale(style.fontScale)
    .shadow(this.getTextShadowEnable() ? this.getTextShadowStyle(true) : undefined)
  }

  @Builder
  BatteryBuilder(style: ClockBuilderStyle) { // 艺术签名样式电量组件
  }

  @Builder
  MergeViewBuilder(style: ClockBuilderStyle) { // 日期、星期、农历合并显示组件
    Row( { space: DEFAULT_MERGE_MARGIN } ) {
      if (style.isMergeDate) {
        this.DateViewBuilder({
          sceneId: style.sceneId,
          isMergeDate: true
        })
      }

      if (style.isMergeWeek) {
        this.WeekViewBuilder({
          sceneId: style.sceneId,
          isMergeWeek: true
        })
      }

      if (style.isMergeLunar) {
        this.LunarViewBuilder({
          sceneId: style.sceneId,
          isMergeLunar: true
        })
      }
    }
    .onSizeChange((oldSize, newSize) => {
      this.signatureWidth = Math.max(SIGNATURE_MIN_WIDTH, Number(newSize.width));
    })
    // 整体位置控制
    .offset(style.offset)
    .markAnchor(style.anchor)
    .transition(TransitionEffect.IDENTITY)
    .scale(style.fontScale)
  }

  /**
   * 锁屏数字时钟文本布局
   *
   * @param clockTextParam
   */
  @Builder
  ClockTextBuilder(clockTextParam: ClockTextParam) {
    Text(clockTextParam.text)
      .id(clockTextParam.id)
      .fontColor(this.getFontColor())
      .fontFamily(clockLayoutHelper.adapterTimeViewFontFamily(this.slClockBindCtrl.getFontFamily()))
      .fontSize(this.getVp(clockTextParam.fontSize))
      .scale({
        x: clockTextParam.fontSizeScale,
        y: clockTextParam.fontSizeScale,
        centerX: 0,
        centerY: 0
      })
      .fontWeight(this.getTimeFontWeight())
      .position(clockTextParam.position)
      .markAnchor(clockTextParam.anchor)
      .draggable(false)
      .clip(false)
      .accessibilityLevel(AccessibilityUtil.isAccessibilityMode() ? 'no' : 'auto')
      // ss10属性来保证数字竖排对齐，例如时间10:01
      .fontFeature('\"ss10\" on')
      .textShadow(this.getTextShadowEnable() ? this.getTextShadowStyle() : undefined)
  }

  @Builder
  TimeViewBuilder(isClockShadow: boolean = false) { // 时钟组件
    Stack() {
      this.ClockTextBuilder({
        text: this.clockTime.slice(0, 1),
        id: `${this.slClockStaticCtrl.getTextViewIdPrefix()}_0_0`,
        fontSize: this.clockBindState.fontSizeAfterSlideUp ?
        this.clockBindState.fontSizeAfterSlideUp : this.layoutParam.hourConf0.fontSize,
        fontSizeScale: this.layoutParam.hourConf0.fontSizeScale,
        position: this.getWidgetOffset(this.layoutParam.hourConf0),
        anchor: this.getClockTextAnchor(this.layoutParam.hourConf0),
        isClockShadow: isClockShadow
      });

      this.ClockTextBuilder({
        text: this.clockTime.slice(1, 2),
        id: `${this.slClockStaticCtrl.getTextViewIdPrefix()}_0_1`,
        fontSize: this.clockBindState.fontSizeAfterSlideUp ?
        this.clockBindState.fontSizeAfterSlideUp : this.layoutParam.hourConf1.fontSize,
        fontSizeScale: this.layoutParam.hourConf1.fontSizeScale,
        position: this.getWidgetOffset(this.layoutParam.hourConf1),
        anchor: this.getClockTextAnchor(this.layoutParam.hourConf1),
        isClockShadow: isClockShadow
      });
      // 线分隔符
      Line()
        .width(this.getVp(this.clockBindState.lineSeparatorHeight))
        .height('2vp')
        .backgroundColor(this.getFontColor())
        .position(this.getWidgetOffset(this.layoutParam.separatorConf))
        .markAnchor(this.getClockTextAnchor(this.layoutParam.separatorConf))
        .rotate({ angle: 135 })
        .opacity(this.getSeparatorAlpha(true))
        .visibility(this.getSeparatorVisibility(true))
        .accessibilityLevel(AccessibilityUtil.isAccessibilityMode() ? 'no' : 'auto')
      // 点分隔符
      Text(CHAR_CLOCK_SEPARATOR)
        .id(`${ClockConstants.COMPONENT_ID_DIGITAL_TEXT_VIEW}_separator_1`)
        .fontColor(this.getFontColor())
        .fontFamily(clockLayoutHelper.adapterTimeViewFontFamily(this.slClockBindCtrl.getFontFamily()))
        .fontSize(this.getVp(this.clockBindState.fontSizeAfterSlideUp ?
        this.clockBindState.fontSizeAfterSlideUp : this.layoutParam.separatorConf.fontSize))
        .scale({
          x: this.layoutParam.separatorConf.fontSizeScale,
          y: this.layoutParam.separatorConf.fontSizeScale,
          centerX: 0,
          centerY: 0
        })
        .fontWeight(this.getTimeFontWeight())
        .position(this.getWidgetOffset(this.layoutParam.separatorConf))
        .markAnchor(this.getClockTextAnchor(this.layoutParam.separatorConf))
        .opacity(this.getSeparatorAlpha(false))
        .transition(TransitionEffect.IDENTITY)
        .visibility(this.getSeparatorVisibility(false))
        .draggable(false)
        .clip(false)
        .accessibilityLevel(AccessibilityUtil.isAccessibilityMode() ? 'no' : 'auto')
        .textShadow(this.getTextShadowEnable() ? this.getTextShadowStyle() : undefined)

      this.ClockTextBuilder({
        text: this.clockTime.slice(3, 4),
        id: `${this.slClockStaticCtrl.getTextViewIdPrefix()}_1_0`,
        fontSize: this.clockBindState.fontSizeAfterSlideUp ?
        this.clockBindState.fontSizeAfterSlideUp : this.layoutParam.minuteConf0.fontSize,
        fontSizeScale: this.layoutParam.minuteConf0.fontSizeScale,
        position: this.getWidgetOffset(this.layoutParam.minuteConf0),
        anchor: this.getClockTextAnchor(this.layoutParam.minuteConf0),
        isClockShadow: isClockShadow
      });

      this.ClockTextBuilder({
        text: this.clockTime.slice(4, 5),
        id: `${this.slClockStaticCtrl.getTextViewIdPrefix()}_1_1`,
        fontSize: this.clockBindState.fontSizeAfterSlideUp ?
        this.clockBindState.fontSizeAfterSlideUp : this.layoutParam.minuteConf1.fontSize,
        fontSizeScale: this.layoutParam.minuteConf1.fontSizeScale,
        position: this.getWidgetOffset(this.layoutParam.minuteConf1),
        anchor: this.getClockTextAnchor(this.layoutParam.minuteConf1),
        isClockShadow: isClockShadow
      });
    }
    .id(isClockShadow ? 'shadow_clock' : 'normal_clock')
    .width(`${clockLayoutHelper.alignSizeForAod(vp2px(this.layoutParam.gridParam.maxWidthSize))}px`)
    .height(`${clockLayoutHelper.alignSizeForAod(vp2px(this.layoutParam.gridParam.maxHeightSize))}px`)
    .alignContent(Alignment.TopStart)
    .clip(false)
    .accessibilityGroup(true)
    .scale(this.clockBindState.scaleOptions)
    .accessibilityText(this.clockBindState.getTimeAccessibility())
    .opacity(this.clockBindState.timeViewOpacity)
  }

  @Builder
  MultiLineTimeViewBuilder() { // 日期、星期、农历多行布局
    Stack({ alignContent: RTLUtil.isRTL() ? Alignment.TopEnd : Alignment.TopStart }) {
      this.MergeViewBuilder({
        sceneId: 'multiline',
        isMergeDate: true,
        isMergeWeek: true,
        offset: this.getWidgetOffset(this.layoutParam.dateConf),
        anchor: this.getWidgetAnchor(this.layoutParam.dateConf),
        fontScale: {
          x: this.layoutParam.dateConf.fontSizeScale,
          y: this.layoutParam.dateConf.fontSizeScale,
          centerX: this.layoutParam.dateConf.anchor?.x?.toString(),
          centerY: this.layoutParam.dateConf.anchor?.y?.toString()
        }
      })

      this.LunarViewBuilder({
        sceneId: 'multiline',
        offset: this.getWidgetOffset(this.layoutParam.lunarConf),
        anchor: this.getWidgetAnchor(this.layoutParam.lunarConf),
        fontScale: {
          x: this.layoutParam.dateConf.fontSizeScale,
          y: this.layoutParam.dateConf.fontSizeScale,
          centerX: this.layoutParam.dateConf.anchor?.x?.toString(),
          centerY: this.layoutParam.dateConf.anchor?.y?.toString()
        }
      })
    }
    .onSizeChange((oldSize, newSize) => {
      this.signatureWidth = Math.max(SIGNATURE_MIN_WIDTH, Number(newSize.width));
    })
    .id('date_lunar')
    .width('100%')
    .height('100%')
    .clip(false)
    .transition(TransitionEffect.IDENTITY)
  }

  @Builder
  SeparateLineTimeViewBuilder() { // 日期、星期、农历离散布局
    Stack({ alignContent: RTLUtil.isRTL() ? Alignment.TopEnd : Alignment.TopStart }) {
      this.DateViewBuilder({
        sceneId: 'sep',
        offset: this.getWidgetOffset(this.layoutParam.dateConf),
        anchor: this.getWidgetAnchor(this.layoutParam.dateConf),
        fontScale: {
          x: this.layoutParam.dateConf.fontSizeScale,
          y: this.layoutParam.dateConf.fontSizeScale,
          centerX: this.layoutParam.dateConf.anchor?.x?.toString(),
          centerY: this.layoutParam.dateConf.anchor?.y?.toString(),
        }
      })

      if (this.shouldMergeWeekLunarInSeparate()) {
        this.MergeViewBuilder({
          sceneId: 'sep_dynamic',
          isMergeWeek: true,
          isMergeLunar: true,
          offset: this.getWidgetOffset(this.layoutParam.weekConf),
          anchor: this.getWidgetAnchor(this.layoutParam.weekConf),
          fontScale: {
            x: this.layoutParam.weekConf.fontSizeScale,
            y: this.layoutParam.weekConf.fontSizeScale,
            centerX: this.layoutParam.weekConf.anchor?.x?.toString(),
            centerY: this.layoutParam.weekConf.anchor?.y?.toString(),
          }
        })
      } else {
        this.WeekViewBuilder({
          sceneId: 'sep',
          offset: this.getWidgetOffset(this.layoutParam.weekConf),
          anchor: this.getWidgetAnchor(this.layoutParam.weekConf),
          fontScale: {
            x: this.layoutParam.weekConf.fontSizeScale,
            y: this.layoutParam.weekConf.fontSizeScale,
            centerX: this.layoutParam.weekConf.anchor?.x?.toString(),
            centerY: this.layoutParam.weekConf.anchor?.y?.toString(),
          }
        })

        this.LunarViewBuilder({
          sceneId: 'sep',
          offset: this.getWidgetOffset(this.layoutParam.lunarConf),
          anchor: this.getWidgetAnchor(this.layoutParam.lunarConf),
          fontScale: {
            x: this.layoutParam.lunarConf.fontSizeScale,
            y: this.layoutParam.lunarConf.fontSizeScale,
            centerX: this.layoutParam.lunarConf.anchor?.x?.toString(),
            centerY: this.layoutParam.lunarConf.anchor?.y?.toString(),
          }
        })
      }
      if (this.isAodBatteryShow() && this.clockBindState.batteryPosition === BatteryPosition.SEPARATE) {
        this.BatteryBuilder({
          sceneId: 'sep',
          offset: this.getWidgetOffset(this.layoutParam.batteryConf),
          anchor: this.getWidgetAnchor(this.layoutParam.batteryConf),
          isBatteryVisible: this.isAodBatteryShow()
        })
      }
    }
    .onSizeChange((oldSize, newSize) => {
      this.signatureWidth = Math.max(SIGNATURE_MIN_WIDTH, Number(newSize.width));
    })
    .id('date_lunar_sep')
    .width('100%')
    .height('100%')
    .clip(false)
    .transition(TransitionEffect.IDENTITY)
    .opacity(this.clockBindState.noTimeViewOpacity)
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      // blend 底图层级
      Stack() {
        Stack() {
        }
        .useEffect(this.slClockBindCtrl.getTextBlurEffect())
        .width('100%')
        .height('100%')
        .accessibilityLevel('no')

        if (this.slClockBindCtrl.getTextBlurEffect() && this.slClockBindCtrl.getEnableBright()) {
          Column() {
          }
          .width('100%')
          .height('100%')
          // .backgroundColor(this.getBackgroundColor())
          .backgroundColor(this.contentColor) //目前的壁纸由我们自己实现，所以没法检测主题颜色，需要自行检测
          .visualEffect(this.getVisualEffect())
          .accessibilityLevel('no')
        }
        // blend 抠图层级
        Stack({ alignContent: RTLUtil.isRTL() ? Alignment.TopEnd : Alignment.TopStart }) {
          this.TimeViewBuilder()
          if (this.clockBindState.isDateSeparatorStyle()) {
            this.SeparateLineTimeViewBuilder()
          } else if (this.clockBindState.isDateSingleLineStyle()) {
            this.MergeViewBuilder({
              sceneId: 'one_line',
              isMergeDate: true,
              isMergeWeek: true,
              isMergeLunar: true,
              offset: this.getWidgetOffset(this.layoutParam.dateConf),
              anchor: this.getWidgetAnchor(this.layoutParam.dateConf),
              fontScale: {
                x: this.layoutParam.dateConf.fontSizeScale,
                y: this.layoutParam.dateConf.fontSizeScale,
                centerX: this.layoutParam.dateConf.anchor?.x?.toString(),
                centerY: this.layoutParam.dateConf.anchor?.y?.toString()
              }
            })
          } else {
            this.MultiLineTimeViewBuilder()
          }

          if (this.isShowSignature()) {
            SignWidget({
              signMaxWidth: this.layoutParam.signConf.maxWidth ?? '100%',
              signText: this.getSignatureText(),
              signFontColor: this.getFontColor(),
              signFontSize: this.layoutParam.signConf.fontSize,
              signMinFontScale: sFontScaleUtil.minFontSize,
              signMaxFontScale: sFontScaleUtil.maxClockFontSize,
              signAlpha: this.getOpacity() * this.clockBindState.noTimeViewOpacity,
              signScale: this.getSignScale(),
              signTextAlign: this.getAlignment(this.layoutParam.signConf),
              signOffset: this.getWidgetOffset(this.layoutParam.signConf),
              signAnchor: this.getWidgetAnchor(this.layoutParam.signConf),
              isPreviewPage: this.slClockStaticCtrl.getIsPreviewPage(),
              aodBatteryIconVisibility: this.getSignAodBatteryVisibility(),
              isNotificationVisible: this.slClockBindCtrl.getIsNotificationVisible(),
              isShowAodBattery: this.slClockStaticCtrl.getShowAodBattery(),
              aodSignMaxWidth: this.slClockStaticCtrl.getAodSignMaxWidth(),
              aodBatteryOffset: this.slClockStaticCtrl.getAodBatteryOffset(),
              isFullBatteryLayout: this.isFullBatteryLayout(),
            })
          }

          if (this.isPartBatteryLayout() && !this.isArtSignLayout()) {
            this.BatteryBuilder({
              sceneId: '_part',
              anchor: this.layoutParam.batteryConf.anchor,
              offset: this.getWidgetOffset(this.layoutParam.batteryConf),
              isBatteryVisible: this.isPartAodBatteryShow(),
            })
          }
        }
        // .blendMode(this.slClockBindCtrl.getTextBlurEffect() ? BLENDMODE_DESTINATION_IN : BlendMode.NORMAL,
        //   this.slClockBindCtrl.getTextBlurEffect() ? BlendApplyType.OFFSCREEN : BlendApplyType.FAST)
        .blendMode(this.slClockBindCtrl.getTextBlurEffect() ? BLENDMODE_DESTINATION_IN : BlendMode.SRC_OVER,
          this.slClockBindCtrl.getTextBlurEffect() ? BlendApplyType.OFFSCREEN : BlendApplyType.FAST)
        .width(`${clockLayoutHelper.alignSizeForAod(vp2px(this.layoutParam.gridParam.maxWidthSize))}px`)
        .height(`${clockLayoutHelper.alignSizeForAod(vp2px(this.layoutParam.gridParam.maxHeightSize))}px`)
        .accessibilityLevel('yes')
      }
      // .blendMode(this.slClockBindCtrl.getTextBlurEffect() ? BLENDMODE_SRC_OVER : BlendMode.NORMAL)
      .blendMode(this.slClockBindCtrl.getTextBlurEffect() ? BLENDMODE_SRC_OVER : BlendMode.SRC_OVER)
      .width(`${clockLayoutHelper.alignSizeForAod(vp2px(this.layoutParam.gridParam.maxWidthSize))}px`)
      .height(`${clockLayoutHelper.alignSizeForAod(vp2px(this.layoutParam.gridParam.maxHeightSize))}px`)
    }
    .id(this.slClockStaticCtrl.getClockViewId())
    .width(`${clockLayoutHelper.alignSizeForAod(vp2px(this.layoutParam.gridParam.gridWidthSize))}px`)
    .height(`${clockLayoutHelper.alignSizeForAod(vp2px(this.layoutParam.gridParam.gridHeightSize))}px`)
    .clip((!this.layoutParam.gridParam.isTimeSeparate && !this.getTextShadowEnable()))
    .onAreaChange((oldValue, newValue: Area) => {
      if (this.slClockStaticCtrl.getClockViewId() === ClockConstants.COMPONENT_ID_DIGITAL_VIEW &&
        !this.mClockViewModel.getClockStaticState().isClockToCollapseOnDesktop) {
        if (ClockStaticData.sIsClockWidgetExpand) {
          this.slClockStaticCtrl?.setClockExpandRectInfo(newValue);
        } else {
          this.slClockStaticCtrl?.setClockCollapseRectInfo(newValue);
        }
      }
    })
    .margin(this.getClockMargin())
    .translate({
      x: this.clockBindState.clockOffsetX,
      y: this.clockBindState.clockOffsetY
    })
    .scale(this.getClockScale())
    .opacity(this.getClockOpacity())
    .blur(this.getClockBlur(), undefined, { disableSystemAdaptation: true })
    .shadow(this.aodStyle?.isAod ? ClockConstants.DEFAULT_CLOCK_SHADOW_OPTION : this.getShadowOption())
  }

  private getClockScale(): ScaleOptions {
    if ((this.slClockAnimCtrl?.isSceneAnimating(AnimScene.SCENE_INTO_IMMERSIVE) ||
      this.slClockAnimCtrl?.isSceneAnimating(AnimScene.SCENE_EXIT_IMMERSIVE)) &&
      this.slClockStaticCtrl.getClockViewId() !== AOD_CLOCK_WIDGET) {
      return {
        x: this.slClockAnimCtrl.getScaleX() ?? DEFAULT_VALUE,
        y: this.slClockAnimCtrl.getScaleY() ?? DEFAULT_VALUE
      }
    }
    return {x: DEFAULT_VALUE, y: DEFAULT_VALUE};
  }

  private getClockOpacity(): number {
    if ((this.slClockAnimCtrl?.isSceneAnimating(AnimScene.SCENE_INTO_IMMERSIVE) ||
    this.slClockAnimCtrl?.isSceneAnimating(AnimScene.SCENE_EXIT_IMMERSIVE)) &&
      this.slClockStaticCtrl.getClockViewId() !== AOD_CLOCK_WIDGET) {
      log.showWarn(`getClockOpacity : ${this.slClockAnimCtrl.getAlpha()}`);
      return this.slClockAnimCtrl.getAlpha() ?? DEFAULT_VALUE;
    }
    return DEFAULT_VALUE;
  }

  private getClockBlur(): number {
    if ((this.slClockAnimCtrl?.isSceneAnimating(AnimScene.SCENE_INTO_IMMERSIVE) ||
      this.slClockAnimCtrl?.isSceneAnimating(AnimScene.SCENE_EXIT_IMMERSIVE)) &&
      this.slClockStaticCtrl.getClockViewId() !== AOD_CLOCK_WIDGET) {
      return this.slClockAnimCtrl.getBlur() ?? 0;
    }
    return 0;
  }

  private getShadowOption(): ShadowOptions | undefined {
    if (!ClockConstants.SHADOW_RADIUS.has(this.slClockBindCtrl.getClockDegree())) {
      return undefined;
    }
    // 完全屏蔽时钟阴影，去除阴影
    if (!this.slClockBindCtrl.getShadowSwitch()) {
      return undefined;
    }
    // 当前暂态时钟阴影不可用，透明化当前阴影
    if (!this.slClockBindCtrl.getTextShadow()) {
      return ClockConstants.DEFAULT_CLOCK_SHADOW_OPTION;
    }
    return {
      radius: ClockConstants.SHADOW_RADIUS.get(this.slClockBindCtrl.getClockDegree()) ?? ClockConstants.ZERO,
      color: ClockConstants.SHADOW_COLOR.get(this.slClockBindCtrl.getClockDegree()) ??
      ClockConstants.DEFAULT_CLOCK_SHADOW_COLOR,
      fill: ClockConstants.FILL_CLOCK_SHADOW
    };
  }

  private updateEnterpriseSignatureText(isEdmAdminEnableChange?: boolean): void {
    AdminManagerModel.getInstance().getEnterpriseDeviceSignatureText().then((data) => {
      if (data) {
        this.enterpriseSignatureText = data;
        if (this.isSignatureTextShow()) {
          this.enterpriseSignatureText = this.enterpriseSignatureText + ' - ' + this.slClockBindCtrl.getSignatureText();
        }
      } else {
        this.enterpriseSignatureText = '';
      }
      if (isEdmAdminEnableChange) {
        this.onParamUpdated();
      }
    }).catch((err: BusinessError) => {
      log.showError(`getEnterpriseDeviceSignatureText failed! err.code: ${err.code}`);
    })
  }

  private getAodBatteryLunarOffset(): number {
    if (!this.isFullBatteryLayout()) {
      return 0;
    }
    // 第七款时钟样式下，电池图标显示时，农历需要偏移
    if (this.slClockBindCtrl.getClockLayout() === ClockLayout.MOUNTAIN_CLOCK_LAYOUT_SPECIAL &&
      (this.getLunarAodBatteryVisibility() === Visibility.Visible)  &&
    this.mClockViewModel.getIsClockWidgetExpand() && this.slClockBindCtrl.getIsNotificationVisible()) {
      return this.slClockBindCtrl.getIsSmallOuter() ?
        AodBatteryConstants.LUNAR_OFFSET_BY_MOUNTAIN_CLOCK_SPECIAL_FOR_SMALL_FOLD :
        AOD_BATTERY_LUNAR_OFFSET_BY_MOUNTAIN_CLOCK_LAYOUT_SPECIAL;
    }
    return 0;
  }

  private getAodBatteryOffset(): number {
    if (this.slClockBindCtrl.getClockLayout() !== ClockLayout.MOUNTAIN_CLOCK_LAYOUT_SPECIAL ||
      !this.mClockViewModel.getIsClockWidgetExpand() || RTLUtil.isRTL()) {
      return 0;
    }
    // 第七款时钟样式下，电池图标需要偏移到农历的左侧显示
    if (this.slClockBindCtrl.getIsSmallOuter()) {
      return this.isLeapMonth() ? AodBatteryConstants.AOD_BATTERY_OFFSET_BY_MOUNTAIN_CLOCK_SPECIAL_FOR_LEAP :
      AodBatteryConstants.AOD_BATTERY_OFFSET_BY_MOUNTAIN_CLOCK_SPECIAL_FOR_SMALL_FOLD;
    }
    return this.isLeapMonth() ? AOD_BATTERY_OFFSET_BY_MOUNTAIN_CLOCK_LAYOUT_SPECIAL_LEAP :
      AOD_BATTERY_OFFSET_BY_MOUNTAIN_CLOCK_LAYOUT_SPECIAL;
  }

  // 签名组件下的电池图标可见性
  private getSignAodBatteryVisibility(): Visibility {
    if (this.isPartialLongTakeAodStyle()) {
      return Visibility.None;
    }

    if (this.isPartBatteryLayout() && this.slClockBindCtrl.getClockExpandOnAodAnim()) {
      return Visibility.None;
    }

    if (!this.isMountainClockLayoutSeperator()) {
      return Visibility.None;
    }

    if (!this.mClockViewModel.getIsClockWidgetExpand()) {
      return Visibility.None;
    }

    if (!this.isShowSignature()) {
      return Visibility.None;
    }
    return this.getAodBatteryVisibility();
  }

  // 农历组件下的电池图标可见性
  private getLunarAodBatteryVisibility(): Visibility {
    if (this.isMountainClockLayoutSeperator() && this.mClockViewModel.getIsClockWidgetExpand() &&
      this.isShowSignature()) {
      return Visibility.None;
    }
    return this.getAodBatteryVisibility();
  }

  private isMountainClockLayoutSeperator(): boolean {
    return [ClockLayout.MOUNTAIN_CLOCK_LAYOUT_SEPERATOR,
      ClockLayout.MOUNTAIN_CLOCK_REVERSE_LAYOUT_SEPERATOR].includes(this.slClockBindCtrl.getClockLayout());
  }

  // 是否为农历闰月
  private isLeapMonth(): boolean {
    const calendar: i18n.Calendar = i18n.getCalendar('zh-Hans', 'chinese');
    calendar.setTime(Date.now());
    return calendar.get('is_leap_month') === 1;
  }

  // 艺术签名样式电池图标可见性
  private getArtSignAodBatteryVisibility(): Visibility {
    if (!this.isArtSignLayout()) {
      return Visibility.None;
    }
    return this.getAodBatteryVisibility();
  }

  private isArtSignLayout(): boolean {
    return this.slClockBindCtrl.getClockLayout() >= 200;
  }

  // 艺术签名AOD电池图标是否显示
  private isAodBatteryShow(): boolean {
    return this.getArtSignAodBatteryVisibility() === Visibility.Visible && this.slClockStaticCtrl.getShowAodBattery() &&
    this.slClockBindCtrl.getIsNotificationVisible();
  }

  private isPartAodBatteryShow(): boolean {
    return this.getAodBatteryVisibility() === Visibility.Visible;
  }

  private getAodBatteryVisibility(): Visibility {
    if (this.slClockStaticCtrl.getIsPreviewPage() || this.slClockStaticCtrl.getClockViewId() === AOD_CLOCK_WIDGET ||
    this.isPartialLongTakeAodStyle()) {
      return Visibility.Visible;
    }
    return this.slClockBindCtrl?.getBatteryVisibility() ?? Visibility.None;
  }

  private isPartialLongTakeAodStyle(): boolean {
    return this.slClockStaticCtrl.getClockViewId() === AOD_CLOCK_WIDGET_LONG_TAKE;
  }

  /**
   * 是否是全屏数字时钟样式电量布局
   * @returns boolean
   */
  public isFullBatteryLayout(): boolean {
    return this.slClockBindCtrl.getBatteryLayout() === BatteryLayout.FULL_AOD_LAYOUT;
  }

  /**
   * 是否是局部数字时钟样式电量布局
   * @returns boolean
   */
  public isPartBatteryLayout(): boolean {
    return this.slClockBindCtrl.getBatteryLayout() === BatteryLayout.PART_AOD_LAYOUT;
  }


  /**
   * 限定需要在分离样式合并星期、农历显示场景：
   * 1 在艺术签名样式中，将星期、农历合并显示配置为true场景
   * 2 传统数字时钟，动态个性签名显示场景
   *
   * @returns true需要显示为合并样式
   */
  private shouldMergeWeekLunarInSeparate(): boolean {
    if (this.mClockViewModel.getClockStaticState().getCurGrid()?.isMergeWeekLunar) {
      return this.clockBindState.isMergeWeekLunar;
    }
    return this.clockBindState.isMergeWeekLunar && this.isShowSignature();
  }

  private getVisualEffect(): VisualEffect | undefined {
    let brightness: BrightnessOptions | undefined = this.getBrightnessOption();
    if (!brightness) {
      return undefined;
    }
    return CommonUtil.translateBrightnessToVisualEffect(brightness);
  }

  private getClockMargin(): Length | Padding | LocalizedPadding {
    let marginLeft = this.clockBindState.clockMarginLeft;
    let marginTop = this.clockBindState.clockMarginTop;
    if (this.isArtSignLayout()) {
      marginLeft += this.slClockBindCtrl.getLeftDynamicMargin();
      marginTop += this.slClockBindCtrl.getTopDynamicMargin();
    }
    return {
      start: LengthMetrics.vp(marginLeft),
      top: LengthMetrics.vp(marginTop)
    }
  }

  private getTextShadowEnable(): boolean {
    // 模糊未使能且美学参数中需要阴影时，开启阴影
    return this.isPosterShadow && !this.slClockBindCtrl.getTextBlurEffect();
  }

  private getTextShadowStyle(isDate: boolean = false): ShadowOptions {
    if (this.aodStyle?.isAod) {
      return ART_SIGN_SHADOW_STYLE_AOD;
    }
    return isDate ? DATE_SHADOW_STYLE : ART_SIGN_SHADOW_STYLE;
  }
}