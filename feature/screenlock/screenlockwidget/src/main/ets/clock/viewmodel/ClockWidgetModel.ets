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

import font from '@ohos.font';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  DeviceHelper,
  EventConstants,
  EventManager,
  EvtBus,
  obtainLocalEvent,
  sEventManager,
} from '@ohos/frameworkwrapper';
import {
  ClockAniAvailableFromDesktopStateWrapper,
  ClockOneShortConsts,
  ComponentCallback,
  ComponentType,
  MeshRange,
  NotificationStateManager,
  ScreenLockState,
  screenLockStateManager,
  ScreenLockToDesktopConsts,
  slClockOneShotToDesktopService,
  slWallpaperMgr,
  ScreenOnOffService,
  ScreenOnOffListener,
  SleepReason
} from '@ohos/screenlockcommon';
import {
  BaseViewModel,
  DisplayModeChangeListener,
  EDIT_FORM_MODE_DETAIL,
  EDIT_FORM_MODE_MAIN,
  EDIT_FULL_MODE,
  EDIT_GUIDE_MODE,
  NONE_EDIT_MODE,
  ScreenLockHeadManager
} from '@ohos/screenlockcommon/Index';
import {
  clockWidgetConfigManager,
} from '../common/ClockWidgetConfigManager';
import { ClockComFamily, ClockLayout } from '../../common/WidgetParam';
import { AnimationStateListener } from '../../common/utils/AnimationUtil';
import ClockWidgetMeshConfig from './ClockWidgeMeshConfig';
import { ClockLayoutParam } from '../common/ClockLayoutParam';
import { AnimScene, ClockWidgetAnimManager } from './viewanim/ClockWidgetAnimManager';
import { ClockWidgetOneShotAnimManager } from './viewanim/ClockWidgetOneShotAnimManager';
import lazy { ClockOneShotPartAnimManager } from './viewanim/ClockOneShotPartAnimManager';
import { ClockAnimData } from '../model/data/ClockAnimData';
import { ClockBindData } from '../model/data/ClockBindData';
import { ClockStaticData } from '../model/data/ClockStaticData';
import AnimationUtil from '../../editsheet/utils/AnimationUtil';
import { curves } from '@kit.ArkUI';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import {
  ClockStaticStateType,
  FormWgStaticStateType,
  SlBindStateType,
  SlMainStateType,
  SlStaticStateType,
  ClockDeskTop2AodAnimType,
} from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { systemParameter } from '@kit.BasicServicesKit';
import ScreenLockFormPanelMeshConfig from '../../form/ScreenLockFormPanelMeshConfig';
import { PageDesktopOneShotManager } from '@ohos/launchercommon/Index';
import { SlClockStaticState } from '../model/data/SlClockStaticState';
import { slStateHelper } from '../../common/utils/SlStateHelper';
import { SlClockBindState } from '../model/data/SlClockBindState';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/Index';
import {
  ScreenLockWallpaperChangeEvent
} from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/event/ImmersiveEvent';
import { ClockLayoutHelper, clockLayoutHelper } from '../common/ClockLayoutHelper';
import { HVAlign } from '../common/HorizontalVerticalAlign';
import { ISlStateChangeListener } from '@ohos/screenlockcommon/src/main/ets/interface/ISlStateChangeListener';
import { CCMParamUtil } from '../common/CCMParamUtil';
import { UDFontAdapterUtil, UDSelectEnum } from '../common/UDFontAdapterUtil';
import { immersiveKgMgr } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import AodHardwareConfig from '@ohos/screenlockcommon/src/main/ets/aod/config/AodHardwareConfig';
import { ICommand } from '../../common/command/Command';
import {
  IEvent,
  AfterClockCollapseEvent,
  SetNtfExpandCollapseEvent,
  UpdateClockParamEvent
} from '../../common/command/Event';
import { ClockHookType } from '../../common/adapter/Constans';
import { EventType, ClockInputEventType } from '../../common/command/Event';
import { IHook } from '../../common/adapter/IHook';
import { ClockDataManager } from '../commonbase/ClockDataManager';
import { ClockLayoutModifier } from '../common/ClockLayoutModifier';
import { ClockAnimEventManager } from '../common/ClockAnimEventManager';
import { BatteryPosition, ClockConstants } from '../common/ClockConstants';
import lazy { ScreenLockFoldExpandAnimUtil } from '@ohos/screenlockcommon/src/main/ets/utils/ScreenLockFoldExpandAnimUtil';

const TAG = 'ClockWidgetModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const SYSTEM_PARAM_ENTERPRISE_DEVICE: string = 'const.edm.is_enterprise_device';
const SYSTEM_PARAM_EDM_ENABLE: string = 'persist.edm.edm_enable';

const BRIGHT_NESS_DEFAULT = 1;
const AOD_CLOCK_WIDGET = 'Aod_ClockWidget';
const AOD_PREVIEW_CLOCK_WIDGET = 'AodPreviewClockWidget';
const aodBackgroundColor: ResourceColor = '#FFAFAFAF';

export enum ClockChangeType {
  CLOCK_CHANGE = 'clockChange',
  CLOCK_MOVE = 'clockMove',
}

/**
 * clock widget view model
 *
 * @since 2024-03-12
 */
export class ClockWidgetModel extends BaseViewModel implements IHook {
  // 数据管理器
  private dataManager: ClockDataManager = new ClockDataManager();


  // 时钟组件静态变量管理
  private slClockStaticCtrl: SlClockStaticState =
    this.dataManager.getSlClockStaticState();

  // 时钟组件UI样式状态管理
  private slClockBindCtrl: SlClockBindState = this.dataManager.getSlClockBindState();

  // 时钟动效状态管理
  private slClockAnimCtrl: WidgetAnimState = this.slClockStaticCtrl?.getSlClockAnimCtrl();

  // 时钟组件内部态状态统一管理
  private staticState: ClockStaticData = new ClockStaticData();

  // 时钟组件内部动态状态统一管理
  private bindState: ClockBindData = new ClockBindData();

  // 时钟内部动效状态管理
  private clockAnimData: ClockAnimData = new ClockAnimData();

  // 时钟字号、位置调节器
  private clockLayoutModifier: ClockLayoutModifier = new ClockLayoutModifier(this.bindState);

  // 时钟内部动效管理
  private animMgr: ClockWidgetAnimManager = new ClockWidgetAnimManager(this.staticState, this.bindState,
    this.clockAnimData, this.clockLayoutModifier, this.slClockAnimCtrl);

  // 时钟一镜到底动效管理
  private oneShotAnimMgr: ClockWidgetOneShotAnimManager = new ClockWidgetOneShotAnimManager(this.staticState,
    this.bindState, this.clockAnimData, this.clockLayoutModifier);

  private oneShotPartAnimMgr?: ClockOneShotPartAnimManager;

  private static sIsNotificationExpand: boolean = false;
  private static clockMeshRange: MeshRange = new MeshRange();
  private static isChangeable: boolean = true;
  private isTextDigital: boolean = false;
  private animationListener?: AnimationStateListener;
  private animationListenerOnMove?: AnimationStateListener;
  private animationListenerOnUp?: AnimationStateListener;
  private clockLayoutParam?: ClockLayoutParam;
  private isImmersivePanelRelated: boolean = false;
  private isUpdatedClockLayout: boolean = false; // 用于判断是否更新过时钟样式
  private isNeedRefreshClockLayout?: boolean; // 判断是否需要刷新时钟样式
  private clockHelper: ClockLayoutHelper = clockLayoutHelper;
  private clockEventManager: ClockAnimEventManager = new ClockAnimEventManager();
  private isScreenOff: boolean = false; // 当前熄屏状态监测（熄屏orAOD状态下屏蔽部分动效）
  private isInit: boolean = false; // 时钟是否上树

  /**
   * 多事件统一管理
   */
  private eventMgr: EventManager = EvtBus.createEventManager();
  private onClockStyleChanged: Callback<number> = (positionY: number) => {};
  private screenSizeChangeCallback = () => {
    log.showInfo('screen size changes');
    let isPortraitChange = this.staticState.updateScreenPortrait(); // 刷新竖屏状态
    let isFoldChange = this.staticState.updateFoldExpand(); // 刷新折叠屏展开状态
    this.isUpdatedClockLayout = false;
    this.updateClockLayout(this.staticState.clockLayout ?? ClockLayout.DEFAULT_CLOCK_LAYOUT);
    this.refreshClockLayout()
    if (this.staticState.updateDisplayScale()) { // 刷新缩放倍数
      this.bindState.updateLineSeparatorHeight(this.staticState.displayScale); // 同步刷新线分隔符高度
      this.updateClockLayoutParam();
      this.staticState.updateDynamicRegion(); // 更新显示区域
      if (this.isImmersivePanelRelated) {
        this.updateSlClockRegionState();
      }
    } else if (isPortraitChange || isFoldChange) { // 剩余场景刷新margin
      this.updateClockMargin();
    }

    if (this.isTextDigital) {
      // 折叠展开状态切换时或者横竖屏切换时，如果手指误触到屏幕造成滑动，恢复原来的状态数据
      if (this.bindState.isClockWidgetOnTouchMoving) {
        this.recoverClockAfterOneShotAnim();
      }
      // 折叠展开状态切换时，如果在执行一镜到底动效，”中断动效”并恢复原来的状态数据
      if (isFoldChange && this.oneShotAnimMgr.getIsOnOneShotAnim()) {
        this.oneShotAnimMgr.stopOneShotAnim();
      }
    }
  };
  // 服务卡片状态切换监听
  private onFormStateChange: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_FORM_WG_STATIC_STATE,
    onSlStateChange: (mainType, subType) => {
      if (subType === FormWgStaticStateType.FORM_SHOW_COUNT || subType === FormWgStaticStateType.IS_FORM_PANEL_SHOW) {
        this.checkHasFormCard();
      }
    }
  };

  // 时钟栅格监听
  private mClockChangeCallback: ComponentCallback = {
    onChange: (isClockExpand: boolean): void => {
      this.setIsNotificationExpand(!isClockExpand);
      this.updateClockCollapseState(isClockExpand);
    },
  };

  private handleNtfExpandCollapseEvent = (event: IEvent): void => {
    if (!(event instanceof SetNtfExpandCollapseEvent)) {
      return;
    }
    let realEvent = event as SetNtfExpandCollapseEvent;
    this.setIsNotificationExpand(realEvent.isExpand);
  }

  private handleUpdateClockLayoutParamEvent = (event: IEvent): void => {
    if (!(event instanceof UpdateClockParamEvent)) {
      return;
    }
    this.updateClockLayoutParam();
  }

  private handleAfterClockCollapseEvent = (event: IEvent): void => {
    if (!(event instanceof AfterClockCollapseEvent)) {
      return;
    }
    this.updateClockLayoutParam();
    this.handleClockCollapse();
  }

  private handleMap: Map<EventType, (event: IEvent) => void> = new Map([
    [ClockInputEventType.SCREEN_SIZE_CHANGE, this.screenSizeChangeCallback],
    [ClockInputEventType.NTF_EXPAND_COLLAPSE, this.handleNtfExpandCollapseEvent],
    [ClockInputEventType.UPDATE_CLOCK_PARAM_EVENT, this.handleUpdateClockLayoutParamEvent],
    [ClockInputEventType.AFTER_CLOCK_COLLAPSE_EVENT, this.handleAfterClockCollapseEvent],
  ]);

  private eventListener: ICommand = {
    execute: (event: IEvent): void => {
      let handle = this.handleMap.get(event.getEventType());
      if (handle) {
        handle(event);
      } else {
        log.showWarn(`onEventChange fail, type:${event.getEventType()}, scene:${event.getScene()}`);
      }
    }
  }

  // 时钟状态切换监听
  private onClockStateChange: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_CLOCK_WG_STATIC_STATE,
    onSlStateChange: (mainType, subType) => {
      // 锁屏时钟是否赋色
      if (subType === ClockStaticStateType.IS_CHANGE_COLOR) {
        this.updateClockBrightnessOption();
      }
    }
  };

  private powerStateChangeListener: ScreenOnOffListener = {
    onBeginSleep: (reason: SleepReason) => {
      // 开始进入熄屏模式，立刻屏蔽部分动效，防止AOD出现残影
      this.isScreenOff = true;
    },
    onEndDisplayOn: () => {
      // 完全唤醒后，恢复动效状态
      this.isScreenOff = false;
    }
  }

  private handleScreenLockWallpaperChangeEvent(clockViewId?: string): void {
    if (clockViewId === 'Aod_ClockWidget') {
      log.showDebug('Aod_ClockWidget no need updateBrightness');
      return;
    }
    let isUsingImmersiveWallpaper =
      slStateHelper.getSlBindState()?.getSlState(SlBindStateType.IS_USING_IMMERSIVE_WALL_PAPER);
    if (isUsingImmersiveWallpaper) {
      log.showInfo(`onScreenLockWallpaperChangeEvent immer: ${slWallpaperMgr.getSlWallpaperState().isLightWallpaper}`);
      this.updateClockBrightnessOption(slWallpaperMgr.getSlWallpaperState().isLightWallpaper);
      return;
    }

    let brightness = this.slClockStaticCtrl?.getBrightness();
    log.showInfo(`onScreenLockWallpaperChangeEvent theme: ${brightness}`);
    if (brightness < 0) {
      this.updateClockBrightnessOption(slWallpaperMgr.getSlWallpaperState().isLightWallpaper);
    } else {
      this.updateClockBrightnessOption(brightness < BRIGHT_NESS_DEFAULT);
    }
  }


  public initViewModel(displayModeChangeListener: DisplayModeChangeListener, clockViewId?: string): void {
    super.initViewModel(displayModeChangeListener);

    this.registerFont();
    this.staticState.isEnterpriseSignVisible = this.getEnterpriseSystemParam() || this.getEdmEnableSystemParam();
    this.staticState.updateScreenPortrait(); // 初始化竖屏状态
    this.staticState.updateFoldExpand(); // 初始化折叠屏展开状态
    if (this.staticState.updateDisplayScale()) { // 初始化缩放倍数
      this.bindState.updateLineSeparatorHeight(this.staticState.displayScale);
    }
    this.eventMgr.on(ScreenLockWallpaperChangeEvent,
      (event?: ScreenLockWallpaperChangeEvent) => { this.handleScreenLockWallpaperChangeEvent(clockViewId) });
    this.handleScreenLockWallpaperChangeEvent(clockViewId);
    if (this.isTextDigital) {
      this.setCallBackForOneShotAni();
    }
    if (this.slClockStaticCtrl.getClockViewId() === ClockConstants.COMPONENT_ID_DIGITAL_VIEW) {
      this.updateFontFamily(this.slClockBindCtrl.getFontFamily());
      slClockOneShotToDesktopService.setUpdateClockWidgetParamsOnMove((slidingDistance: number): void => {
        this.updateClockWidgetParamsOnMove(slidingDistance);
      });

      slClockOneShotToDesktopService.setPrepareForOneShotAnimOnFirstMove((): void => {
        this.prepareForOneShotAnimOnFirstMove();
      })

      slClockOneShotToDesktopService.setRecoverClockAfterOneShotAnim((): void => {
        this.recoverClockAfterOneShotAnim();
      })
    }
    let isExpand = this.slClockStaticCtrl?.getIsClockForceCollapseState();
    if (slStateHelper.getSlBindState()?.getSlState(SlBindStateType.IMMERSIVE_SHOWING_STATE)) {
      isExpand = false;
    }
    if (isExpand !== undefined) {
      log.showInfo('force set clock collapse');
      this.updateClockCollapseState(isExpand);
      this.slClockStaticCtrl?.setClockForceCollapseState(undefined);
    }
    // 服务卡片可见性初始化
    slUiStateMgr.registerSlStateChangeListener(this.onFormStateChange);
    slUiStateMgr.registerSlStateChangeListener(this.onClockStateChange);
    ScreenOnOffService.getInstance().registerObserver(this.powerStateChangeListener);
    this.checkHasFormCard();
    this.staticState.updateGridAndElementConf();
    this.updateClockLayoutParam();
    this.isInit = true;
  }

  /**
   * 时钟一镜到底动效场景监听初始化
   */
  public initClockOneShotAnim(): void {
    // 时钟一镜到底动效监听
    if (this.isTextDigital) {
      this.subscribeForOneShotAnim();
    }
  }

  // 获取数据管理器
  public getDataManager(): ClockDataManager {
    return this.dataManager;
  }



  public getHookType(): ClockHookType {
    return ClockHookType.CLOCK_WIDGET_MODEL;
  }

  public getClockAnimMgr(): ClockWidgetAnimManager {
    return this.animMgr;
  }

  public getOneShotClockAnimMgr(): ClockWidgetOneShotAnimManager {
    return this.oneShotAnimMgr;
  }

  public getEventListener(): ICommand {
    return this.eventListener;
  }




  /**
   * 触发时钟样式刷新
   */
  updateElementConfAndLayout() {
    let posX = this.staticState.clockPosition?.x as number ?? 0;
    let posY = this.staticState.clockPosition?.y as number ?? 0;
    let layout = this.staticState.clockLayout ?? ClockLayout.DEFAULT_CLOCK_LAYOUT;
    this.updateClockAlign(posX, posY, layout);
    this.staticState.updateGridAndElementConf();
    this.updateClockLayoutParam();
  }



  /**
   * 艺术签名镜像布局状态刷新,触发时钟样式刷新
   *
   * @param isUsingMirrorLayout 当前是否使用镜像布局
   */
  public updateMirrorStatus(isUsingMirrorLayout: boolean): void {
    if (this.slClockStaticCtrl.isUsingMirrorLayout() === isUsingMirrorLayout) {
      return;
    }
    this.slClockStaticCtrl.setMirrorLayout(isUsingMirrorLayout);
    log.showInfo(`updateMirrorStatus isUsingMirrorLayout:${isUsingMirrorLayout}`);
    this.updateElementConfAndLayout();
  }

  public setBackgroundColor(color: ResourceColor) {
    this.slClockStaticCtrl?.setBackgroundColor(color);
    this.slClockBindCtrl?.setBackgroundColor(color);
    log.showDebug(`setBackgroundColor = ${color}`);
  }

  /**
   * 设置时钟提亮参数
   *
   * @param isLightWallpaper
   */
  public updateClockBrightnessOption(isLightWallpaper?: boolean) {
    if (isLightWallpaper !== undefined) {
      this.slClockBindCtrl?.setLightWallpaperState(isLightWallpaper);
    } else {
      isLightWallpaper = this.slClockBindCtrl?.getLightWallpaperState();
    }
    let isChangeColor = this.slClockStaticCtrl?.getChangeColorState();
    let brightness = isLightWallpaper ? BrightnessOptionUtils.keyguardTimeDarkOption :
    BrightnessOptionUtils.keyguardTimeLightOption;
    if (isChangeColor) {
      brightness = isLightWallpaper ? BrightnessOptionUtils.keyguardTimeDarkOptionForFillColor :
      BrightnessOptionUtils.keyguardTimeLightOptionForFillColor;
    }
    if (this.slClockBindCtrl?.getClockDesktopToAod() && !this.isTextDigital) {
      brightness = BrightnessOptionUtils.aodTimeLightOptionForFillColor;
    }
    this.slClockBindCtrl?.setBrightness(brightness);
  }

  private setCallBackForOneShotAni(): void {
    slClockOneShotToDesktopService.setSetTextColorOfDesktopClock((textColor: string) => {
      log.showInfo(`oneShot screenLockService.setSetTextColorOfDesktopClock textColor = ${textColor}`)
      this.staticState.setTextColorOfDesktopClock(textColor);
    })
  }

  onMultiSceneThemeChange(): void {
    // 若主题场景切换时存在未结束的一镜到底动效，则移除动效属性，直接显示切换后的主题信息
    if (this.slClockAnimCtrl?.isSceneAnimating()) {
      let scenes = this.slClockAnimCtrl?.getSceneValues();
      log.showInfo(`onMultiSceneThemeChange clear all clock anim scenes, ${scenes}`);
      scenes?.split(',').forEach((scene) => {
        this.slClockAnimCtrl?.setAnimScene({ isAnimating: false, animScene: scene, isForceRemove: true });
      });
    }
    this.slClockAnimCtrl?.setBgColor(this.slClockStaticCtrl.getBackgroundColor());
    this.slClockAnimCtrl?.setFgBrightness(this.getClockBrightnessOptions());
  }

  private getClockBrightnessOptions(): BrightnessOptions {
    let isLightWallpaper = this.slClockBindCtrl.getLightWallpaperState();
    let isChangeColor = this.slClockStaticCtrl.getChangeColorState();

    if (isChangeColor) {
      return isLightWallpaper ? BrightnessOptionUtils.keyguardTimeDarkOptionForFillColor :
      BrightnessOptionUtils.keyguardTimeLightOptionForFillColor;
    }
    return isLightWallpaper ? BrightnessOptionUtils.keyguardTimeDarkOption :
    BrightnessOptionUtils.keyguardTimeLightOption;
  }

  public getEnterpriseSystemParam(): boolean {
    return systemParameter.getSync(SYSTEM_PARAM_ENTERPRISE_DEVICE, 'false') === 'true';
  }

  private getEdmEnableSystemParam(): boolean {
    return systemParameter.getSync(SYSTEM_PARAM_EDM_ENABLE, 'false') === 'true';
  }

  public setClockLayoutParam(clockLayoutParam: ClockLayoutParam) {
    this.clockLayoutParam = clockLayoutParam;
  }

  public destroyViewModel(): void {
    super.destroyViewModel();
    slUiStateMgr?.unregisterSlStateChangeListener(this.onFormStateChange);
    slUiStateMgr?.unregisterSlStateChangeListener(this.onClockStateChange);
    ScreenOnOffService.getInstance().unRegisterObserver(this.powerStateChangeListener);
    this.eventMgr.offAll();
    // 时钟一镜到底监听释放
    if (this.isTextDigital) {
      this.clockEventManager.unsubscribeClockEvent();
    }
    this.isInit = false;
  }

  public getClockAnimData(): ClockAnimData { // 时钟动效数据绑定
    return this.clockAnimData;
  }

  public getClockBindState(): ClockBindData { // 时钟组件动态状态管理
    return this.bindState;
  }

  public getClockStaticState(): ClockStaticData { // 时钟组件静态状态管理
    return this.staticState;
  }

  public updateClockLayout(layout: ClockLayout, x: number = this.staticState.clockPosition?.x as number,
    y: number = this.staticState.clockPosition?.y as number): void { // 布局样式切换，刷新布局参数
    let isPositionChange: boolean = x !== this.staticState.clockPosition?.x || y !== this.staticState.clockPosition?.y
    let align = this.updateClockAlign(x, y, layout);
    if (this.staticState.updateClockLayout(layout) || align || isPositionChange) { // 布局样式切换，刷新布局参数
      this.staticState.updateGridAndElementConf();
      this.updateClockLayoutParam();
      this.isUpdatedClockLayout = true;
      if (this.isImmersivePanelRelated) {
        this.updateSlClockRegionState();
      }
    }
  }

  /**
   * 刷新时钟样式
   */
  private refreshClockLayout() {
    if (this.isNeedRefreshClockLayout && !this.isUpdatedClockLayout) {
      this.staticState.updateGridAndElementConf();
      this.updateClockLayoutParam();
    }
  }

  public setIsNeedRefreshClockLayout(isNeedRefreshClock: boolean): void {
    this.isNeedRefreshClockLayout = isNeedRefreshClock;
  }

  public updateClockLayoutByManualEdit(layout: ClockLayout): void { // 更新时钟布局样式
    if (this.staticState.clockLayout === undefined || this.staticState.clockLayout === layout) { // 初次无动画
      return;
    }
    let x = this.staticState.clockPosition?.x as number ?? 0;
    let y = this.staticState.clockPosition?.y as number ?? 0;
    let align = this.updateClockAlign(x, y, layout);
    if (this.staticState.updateClockLayout(layout) || align) { // 布局样式切换，刷新布局参数
      this.staticState.updateGridAndElementConf();
      // 提前刷新日期、星期、农历当前样式
      let grid = this.staticState.getCurGrid();
      let conf = this.staticState.getCurElementConf();
      // 刷新布局参数
      this.updateDateWeekStyle();
      if (this.currentMode === NONE_EDIT_MODE || ScreenLockFoldExpandAnimUtil.getInstance().getSkipClockAnimation()) {
        log.showInfo('fold-to-expand without animation');
        this.clockLayoutParam?.initClockLayoutParam(this.staticState.displayScale, grid, conf,
          this.clockLayoutModifier);
      } else {
        log.showInfo('manual update layout with animation layout ' + layout);
        AnimationUtil.createAnimateTo(curves.interpolatingSpring(0, 1, 228, 30), 0, 100, () => {
          this.clockLayoutParam?.initClockLayoutParam(this.staticState.displayScale, grid, conf,
            this.clockLayoutModifier);
        })
      }
      // 同步更新间距
      this.updateClockMargin();
      if (this.isImmersivePanelRelated) {
        this.updateSlClockRegionState();
      }
    }
  }

  public updateTextColorOnStyleChange(textColor: string): void {
    this.staticState.setTextColorOnStyleChange(textColor);
    this.staticState.textColor = textColor;
    this.bindState.textColor = textColor;
  }

  public recoverClockAfterOneShotAnim(isResetLayout: boolean = true): void {
    log.showInfo('oneShot call recoverClockAfterOneShotAnim');
    if (isResetLayout) {
      this.slClockBindCtrl?.setClockViewOffset({
        x: this.slClockBindCtrl?.getClockWidgetLeftMargin(),
        y: this.slClockBindCtrl?.getClockWidgetTopMargin(),
      });
    }
    this.slClockStaticCtrl?.setClockExpandOnAod(false);
    this.slClockBindCtrl.setClockExpandOnAodAnim(false);
    this.bindState.updateClockOnMove(false);
    this.staticState.updateClockToCollapseOnDesktop(false);
    this.slClockBindCtrl?.setClockAodToDesktop(false);
    this.slClockBindCtrl?.setClockDesktopToAod(false);
    this.staticState.updateGridAndElementConf();
    this.clockAnimData.clearSeparatorAnim(); // 双指滑动进入合一编辑时有时候会触发进入一镜到底，在这里需要再次清除分割符动效
    if (isResetLayout) {
      this.updateClockLayoutParam();
      this.updateClockOffset();
      this.updateNoTimeViewOpacity();
      this.updateTimeViewOpacity();
      this.updateTextColor();
      this.updateTextOffSets();
      this.updateScaleOptions();
      this.updateFontSizeAfterSlideUp();
    }
    slStateHelper.getSlBindState()?.setSlState(SlBindStateType.DISABLE_CLOCK_SHADOW, false);
  }

  /**
   * 更新时钟布局参数
   */
  public updateClockLayoutParam(): void {
    let grid = this.staticState.getCurGrid();
    let conf = this.staticState.getCurElementConf();
    // 提前刷新日期、星期、农历当前样式
    this.updateDateWeekStyle();
    // 刷新布局参数
    this.clockLayoutParam?.initClockLayoutParam(this.staticState.displayScale, grid, conf, this.clockLayoutModifier);
    // 同步更新间距
    this.updateClockMargin();
  }

  private updateClockMargin(): void { // 更新时钟组件外间距，刷新UI
    if (this.staticState.updateClockViewMargin()) {
      log.showWarn(`updateClockMargin left:${this.staticState.clockMarginLeft},
       top:${this.staticState.clockMarginTop}`);
      this.bindState.clockMarginLeft = this.staticState.clockMarginLeft;
      this.bindState.clockMarginTop = this.staticState.clockMarginTop;
    }
  }

  private updateDateWeekStyle(): void { // 更新时钟组件日期、星期等样式，刷新UI
    if (this.staticState.updateDateWeekLunarStyle()) {
      this.bindState.dateWeekStyle = this.staticState.dateWeekStyle;
      this.bindState.isShowLargeDate = this.staticState.isShowLargeDate;
      this.bindState.isMergeWeekLunar = this.staticState.isMergeWeekLunar;
      this.bindState.batteryPosition = this.staticState.batteryPosition ?? BatteryPosition.SEPARATE;
    }
  }

  private updateClockOffset(): void {
    if (this.staticState.updateClockOffset()) { // 同步更新时钟组件偏移
      this.bindState.clockOffsetX = this.staticState.clockOffsetX;
      this.bindState.clockOffsetY = this.staticState.clockOffsetY;
      log.showWarn(`updateClockOffset x:${this.bindState.clockOffsetX}, y:${this.bindState.clockOffsetY}`);
    }
  }

  private updateNoTimeViewOpacity(): void {
    if (this.staticState.updateNoTimeViewOpacity()) { // 同步日历、星期、农历等透明度
      this.bindState.noTimeViewOpacity = this.staticState.noTimeViewOpacity;
    }
  }

  private updateTimeViewOpacity(): void {
    if (this.staticState.updateTimeViewOpacity()) { // 时间透明度
      this.bindState.timeViewOpacity = this.staticState.timeViewOpacity;
    }
  }

  private updateTextColor(): void {
    if (this.staticState.updateTextColor()) {
      this.bindState.textColor = this.staticState.textColor;
    }
  }

  private updateTextOffSets(): void {
    this.staticState.textOffSets.clear();
    this.bindState.textOffSets.clear();
  }

  private updateScaleOptions(): void {
    this.staticState.updateScaleOptions();
    log.showInfo(`updateScaleOptions x=${this.staticState.scaleOptions?.x} y=${this.staticState.scaleOptions?.y}`);
    this.bindState.scaleOptions = this.staticState.scaleOptions;
  }

  private updateFontSizeAfterSlideUp(): void {
    this.staticState.updateFontSizeAfterSlideUp();
    this.bindState.fontSizeAfterSlideUp = this.staticState.fontSizeAfterSlideUp;
  }

  /**
   * 更新当前时钟展开状态
   *
   * @param isExpand 是否为展开态
   */
  public updateClockCollapseState(isExpand: boolean) {
    log.showInfo(`updateClockCollapseState isExpand:${isExpand}`);
    if (this.slClockStaticCtrl.getIsExitingKg()) {
      log.showWarn('is existing kg.');
      return;
    }
    // 三方主题场景，不触发时钟动效
    if (!this.slClockStaticCtrl.getIsClockVisible() && !immersiveKgMgr.getImmersiveDisplayState().isImmersive()) {
      ClockStaticData.updateClockWidgetExpand(isExpand);
      log.showInfo('clock no need to anim.');
      return;
    }
    const isClockExpandStateChange = ClockStaticData.updateClockWidgetExpand(isExpand);
    if (isClockExpandStateChange) {
      NotificationStateManager.notificationState.isBottomAlign = ClockStaticData.sIsClockWidgetExpand;
      this.interruptPartAnim();
      if (this.oneShotPartAnimMgr !== undefined &&
        this.slClockStaticCtrl.getClockExpandOnAod()) {
        // 通知更新场景,如果是在局部AOD过程中，直接刷新参数
        log.showInfo('DeskTopToPartAod animating updateClockCollapseState');
        this.oneShotPartAnimMgr?.refreshClock2PartAod();
        return;
      }
      const isIntoSleep: boolean = ScreenOnOffService.getInstance().isIntoSleep;
      if (this.isScreenOff || isIntoSleep) { // 熄屏场景，跳过动效，直接切换样式
        log.showInfo(`Collapse anim skipped for isScreenOff ${this.isScreenOff} or isIntoSleep ${isIntoSleep}`);
        this.updateClockLayoutParam();
      } else { // 开启状态切换动效
        this.animMgr.startCollapseStateChangeAnim({
          isAnimToExpand: isExpand,
          animListener: this.animationListener
        });
      }
    }
  }

  /**
   * 设置动画执行状态的监听
   *
   * @param listener 监听类
   */
  public setAnimationListener(listener: AnimationStateListener) {
    this.animationListener = listener;
  }

  public setAnimationListenerOnMove(listener: AnimationStateListener) {
    this.animationListenerOnMove = listener;
  }

  public setAnimationListenerOnUp(listener: AnimationStateListener) {
    this.animationListenerOnUp = listener;
  }

  public onEnterHost(preState: ScreenLockState): void {
    log.showDebug('onEnterHost');
    super.onEnterHost(preState);
    this.mDisplayModeChangeListener?.onDisplayModeChange(NONE_EDIT_MODE);
    // 进入锁屏主页面后清楚时钟强制折叠标识，避免影响其它业务
    this.slClockStaticCtrl.setClockForceCollapseState(undefined);
  }

  public onEnterThemeEditor(preState: ScreenLockState): void {
    log.showDebug('onEnterThemeEditor');
    super.onEnterThemeEditor(preState);
    this.mDisplayModeChangeListener?.onDisplayModeChange(EDIT_GUIDE_MODE);
  }

  public onEnterFullEditor(preState: ScreenLockState, fullState: ScreenLockState): void {
    super.onEnterFullEditor(preState, fullState);
    this.mDisplayModeChangeListener?.onDisplayModeChange(this.currentMode);
  }

  public onEnterOtherApp(): void {
    super.onEnterOtherApp();
    this.mDisplayModeChangeListener?.onDisplayModeChange(this.currentMode);
  }

  public onEnterOtherAppBorderShow(): void {
    super.onEnterOtherAppBorderShow();
    this.mDisplayModeChangeListener?.onDisplayModeChange(this.currentMode);
  }

  public onEnterOtherAppBorderHide(): void {
    super.onEnterOtherAppBorderHide();
    this.mDisplayModeChangeListener?.onDisplayModeChange(this.currentMode);
  }

  public onClickClock(): void {
    log.showInfo(`currentMode = ${this.currentMode}`)
    if (this.currentMode === EDIT_GUIDE_MODE || this.currentMode === EDIT_FULL_MODE ||
      this.currentMode === EDIT_FORM_MODE_MAIN || this.currentMode === EDIT_FORM_MODE_DETAIL) {
      log.showInfo('click clock to full edit mode');
      screenLockStateManager.onEnterFullEditor(ScreenLockState.THEME_EDITOR_FULL_CLOCK);
    }
  }

  public initMeshRange(clockChangeCallback?: ComponentCallback): void {
    ScreenLockHeadManager.registerComponentCallback(ComponentType.CLOCK, this.clockChangeCallback);
    // 时钟栅格监听
    ClockWidgetMeshConfig.registerMeshChangeListener(this.clockMeshChange);
  }

  private subscribeForOneShotAnim(): void {
    if (this.clockEventManager.isEmpty()) {
      log.showInfo('subscribeForOneShotAnim');
      // 注册时钟解锁一镜到底
      this.clockEventManager.subscribeClockEvent(EventConstants.SCREEN_LOCK_BEGIN_SLEEP,
        (val: number) => this.handleBeginSleep(val));
      this.clockEventManager.subscribeClockEvent(ScreenLockToDesktopConsts.SLIDE_UP_TO_RESET_CLOCK_ANIMATION,
        (val: number) => this.handleSlideReset(val));
      this.clockEventManager.subscribeClockEvent(ScreenLockToDesktopConsts.FACE_TO_DESKTOP_CLOCK_ANIMATION,
        (val: number) => this.handleFaceToDesktop(val));
      this.clockEventManager.subscribeClockEvent(ScreenLockToDesktopConsts.FINGERPRINT_TO_DESKTOP_CLOCK_ANIMATION,
        (val: number) => this.handleFingerprintToDesktop(val));
      this.clockEventManager.subscribeClockEvent(ScreenLockToDesktopConsts.KEYPRESS_TO_DESKTOP_CLOCK_ANIMATION,
        (val: number) => this.handleKeypressToDesktop(val));
      this.clockEventManager.subscribeClockEvent(ScreenLockToDesktopConsts.SLIDE_UP_TO_DESKTOP_CLOCK_ANIMATION,
        (val: number) => this.handleSlideUpToDesktop(val));
      this.clockEventManager.subscribeClockEvent(ScreenLockToDesktopConsts.SLIDE_UP_TO_DO_FONTSIZE_ANIMATION,
        (val: number) => this.handleSlideUpToChangeFontSize(val));
      // 注册全屏AOD时钟一镜到底
      this.clockEventManager.subscribeClockEvent(ClockOneShortConsts.FULL_AOD_TO_DESKTOP_CLOCK_ANIMATION,
        (val: number) => this.handleFullAodToDesktop(val));
      this.clockEventManager.subscribeClockEvent(ClockOneShortConsts.DESKTOP_TO_FULL_AOD_CLOCK_ANIMATION,
        (val: number) => this.handleDesktopToFullAodAnim(val));
      // 注册局部AOD时钟一镜到底
      this.clockEventManager.subscribeClockEvent(ClockOneShortConsts.DESKTOP_TO_PART_AOD_CLOCK_ANIMATION,
        (val: number) => this.handleDesktopToPartAod(val));
      this.clockEventManager.subscribeClockEvent(ClockOneShortConsts.PART_AOD_TO_DESKTOP_CLOCK_ANIMATION,
        (val: number) => this.handlePartAodToDesktop(val));
      this.clockEventManager.subscribeClockEvent(ClockOneShortConsts.PART_AOD_TO_SL_CLOCK_ANIMATION,
        (val: number) => this.handlePartAodToSl(val));
      this.clockEventManager.subscribeClockEvent(ClockOneShortConsts.SL_TO_PART_AOD_CLOCK_ANIMATION,
        (val: number) => this.handleSlToPartAod(val));
      this.clockEventManager.subscribeClockEvent(ClockOneShortConsts.DESKTOP_TO_PART_AOD_NO_ANIM,
        (val: number) => this.handleNoMirrorToPartAod(val));

      this.clockEventManager.subscribeClockEvent(ClockOneShortConsts.NO_ANIM_PART_AOD_TO_SL,
        (val: number) => this.handleNoMirrorPartAodToSl(val));
      this.clockEventManager.subscribeClockEvent(ClockOneShortConsts.NO_ANIM_SL_TO_PART_AOD,
        (val: number) => this.handleNoMirrorToPartAod(val));
      // 从桌面灭屏，存在锁屏未上树情况，需要主动触发动效
      this.initForDesktopToAod();
    }
  }

  private handleBeginSleep(val: number): void {
    log.showInfo('oneShot receive SCREEN_LOCK_BEGIN_SLEEP');
    if (this.oneShotAnimMgr.getIsOnOneShotAnim() && !this.slClockBindCtrl?.getClockDesktopToAod()) {
      this.oneShotAnimMgr.stopOneShotAnim();
    } else if (this.bindState.isClockWidgetOnTouchMoving) {
      this.recoverClockAfterOneShotAnim();
    }
  }

  private handleSlideReset(val: number): void {
    log.showInfo('oneShot receive SLIDE_UP_TO_RESET_CLOCK_ANIMATION');
    this.interruptPartAnim();
    this.bindState.updateClockOnMove(false);
    if (this.staticState.updateClockToCollapseOnDesktop(false)) {
      // 开启状态切换动效
      this.oneShotAnimMgr.startCollapseStateChangeAnimForOneShot({
        isAnimToExpand: true,
        animListener: this.animationListenerOnUp
      }, ScreenLockToDesktopConsts.SLIDE_UP_TO_RESET_CLOCK_ANIMATION);
    }
  }

  private handleFaceToDesktop(vel: number): void {
    log.showInfo('oneShot receive FACE_TO_DESKTOP_CLOCK_ANIMATION');
    this.interruptPartAnim();
    this.recoverClockBeforeUnlockAnimIfNeed();
    slClockOneShotToDesktopService.notifyUpdateTextColorOfDesktopClock();
    PageDesktopOneShotManager.getInstance().setIsHideClockAnimation(true);
    if (this.staticState.updateClockToCollapseOnDesktop(true)) {
      // 开启状态切换动效
      this.oneShotAnimMgr.startCollapseStateChangeAnimForOneShot({
        isAnimToExpand: false,
        animListener: this.animationListener
      }, ScreenLockToDesktopConsts.FACE_TO_DESKTOP_CLOCK_ANIMATION);
    }
  }

  private handleFingerprintToDesktop(vel: number): void {
    log.showInfo('oneShot receive FINGERPRINT_TO_DESKTOP_CLOCK_ANIMATION');
    this.interruptPartAnim();
    this.recoverClockBeforeUnlockAnimIfNeed();
    slClockOneShotToDesktopService.notifyUpdateTextColorOfDesktopClock();
    PageDesktopOneShotManager.getInstance().setIsHideClockAnimation(true);
    if (this.staticState.updateClockToCollapseOnDesktop(true)) {
      // 开启状态切换动效
      this.oneShotAnimMgr.startCollapseStateChangeAnimForOneShot({
        isAnimToExpand: false,
        animListener: this.animationListener
      }, ScreenLockToDesktopConsts.FINGERPRINT_TO_DESKTOP_CLOCK_ANIMATION);
    } else if (this.bindState.isClockWidgetOnTouchMoving) { // 当人脸解锁后在屏幕上滑动，同时触发侧边指纹解锁，此时走离手动效流程
      this.oneShotAnimMgr.startCollapseStateChangeAnimOnUpForOneShot({
        isAnimToExpand: false,
        animListener: this.animationListenerOnUp
      }, 0);
      this.oneShotAnimMgr.startClockFontSizeAnimOnUpForOneShot({
        isAnimToExpand: false
      }, 0);
      this.bindState.updateClockOnMove(false);
    }
  }

  private handleKeypressToDesktop(vel: number): void {
    log.showInfo('oneShot receive KEYPRESS_TO_DESKTOP_CLOCK_ANIMATION');
    this.interruptPartAnim();
    this.recoverClockBeforeUnlockAnimIfNeed();
    slClockOneShotToDesktopService.notifyUpdateTextColorOfDesktopClock();
    PageDesktopOneShotManager.getInstance().setIsHideClockAnimation(true);
    if (this.staticState.updateClockToCollapseOnDesktop(true)) {
      // 开启状态切换动效
      this.oneShotAnimMgr.startCollapseStateChangeAnimForOneShot({
        isAnimToExpand: false,
        animListener: this.animationListener
      }, ScreenLockToDesktopConsts.KEYPRESS_TO_DESKTOP_CLOCK_ANIMATION);
    }
  }

  private handleSlideUpToDesktop(vel: number): void {
    log.showInfo('oneShot receive SLIDE_UP_TO_DESKTOP_CLOCK_ANIMATION');
    this.interruptPartAnim();
    slClockOneShotToDesktopService.notifyUpdateTextColorOfDesktopClock();
    PageDesktopOneShotManager.getInstance().setIsHideClockAnimation(true);
    this.oneShotAnimMgr.startCollapseStateChangeAnimOnUpForOneShot({
      isAnimToExpand: false,
      animListener: this.animationListenerOnUp
    }, vel);
    this.bindState.updateClockOnMove(false);
  }

  private handleSlideUpToChangeFontSize(vel: number): void {
    log.showInfo('oneShot receive SLIDE_UP_TO_DO_FONTSIZE_ANIMATION');
    this.oneShotAnimMgr.startClockFontSizeAnimOnUpForOneShot({
      isAnimToExpand: false
    }, vel);
  }

  private initForDesktopToAod(): void {
    // 消费灭屏时钟一镜到底动画事件
    let animType: ClockDeskTop2AodAnimType | undefined =
      slUiStateMgr.getSlState(SlMainStateType.SL_CLOCK_WG_STATIC_STATE)?.getSlState(
        ClockStaticStateType.DESKTOP_TO_AOD_ANIM_TYPE) as ClockDeskTop2AodAnimType;
    log.showDebug(`initForDesktopToAod animType is: ${animType}`);
    if (!animType || animType === ClockDeskTop2AodAnimType.NONE) {
      // 不支持从桌面播放时钟一镜到底
      return;
    }
    switch (animType) {
      case ClockDeskTop2AodAnimType.DESKTOP_TO_FULL_AOD:
        this.handleDesktopToFullAodAnim();
        break;
      case ClockDeskTop2AodAnimType.DESKTOP_TO_PART_AOD:
        this.handleDesktopToPartAod();
        break;
      case ClockDeskTop2AodAnimType.DESKTOP_TO_PART_AOD_NO_ANIM:
        this.handleNoMirrorToPartAod();
        break;
      default:
      // do nothing
        log.showError('initForDesktopToAod animType is invalid');
        break;
    }
  }

  private handleDesktopToFullAodAnim(vel?: number): void {
    log.showInfo(`handleDesktopToFullAodAnim ${this.staticState.isClockToCollapseOnDesktop} ${ClockStaticData.sIsClockWidgetExpand}`);
    slUiStateMgr.getSlState(SlMainStateType.SL_CLOCK_WG_STATIC_STATE)?.setSlState(
      ClockStaticStateType.DESKTOP_TO_AOD_ANIM_TYPE, ClockDeskTop2AodAnimType.NONE);
    if (this.slClockBindCtrl?.getClockAodToDesktop() || this.staticState.isClockToCollapseOnDesktop) {
      this.oneShotAnimMgr.stopOneShotAnim();
      this.recoverClockAfterOneShotAnim();
    }
    // 设置锁屏时钟到桌面时钟位置
    this.oneShotAnimMgr.setClockToCollapse();
    this.slClockBindCtrl?.setBackgroundColor(slClockOneShotToDesktopService.getTextColorOfDesktopClock());
    this.slClockAnimCtrl?.setBgColor(slClockOneShotToDesktopService.getTextColorOfDesktopClock());
    // 动效监听
    let animListener: AnimationStateListener = {
      onAnimationStart: () => {
        // 动效开启前，标记桌面到AOD
        this.slClockBindCtrl?.setClockDesktopToAod(true);
        this.slClockBindCtrl?.setCurrentAnimScene(ClockOneShortConsts.DESKTOP_TO_FULL_AOD_CLOCK_ANIMATION);
        this.animationListener?.onAnimationStart?.();
      },
      onAnimationEnd: () => {
        this.slClockBindCtrl?.setCurrentAnimScene(undefined);
        this.animationListener?.onAnimationEnd?.();
      }
    };
    this.oneShotAnimMgr.startCollapseStateChangeAnimForOneShot({
      isAnimToExpand: true,
      animListener: animListener
    }, ClockOneShortConsts.DESKTOP_TO_FULL_AOD_CLOCK_ANIMATION);
  }

  private handleFullAodToDesktop(val?: number): void {
    log.showInfo('oneShot receive FULL_AOD_TO_DESKTOP_CLOCK_ANIMATION');
    if (this.slClockBindCtrl?.getClockDesktopToAod()) {
      this.oneShotAnimMgr.stopOneShotAnim();
      this.recoverClockAfterOneShotAnim(false);
    }
    this.slClockBindCtrl?.setClockAodToDesktop(true);
    slStateHelper.getSlBindState()?.setSlState(SlBindStateType.DISABLE_CLOCK_SHADOW, true);
    slClockOneShotToDesktopService.notifyUpdateTextColorOfDesktopClock();
    PageDesktopOneShotManager.getInstance().setIsHideClockAnimation(true);
    if (this.staticState.updateClockToCollapseOnDesktop(true)) {
      this.oneShotAnimMgr.startCollapseStateChangeAnimForOneShot({
        isAnimToExpand: false,
        animListener: this.animationListener
      }, ClockOneShortConsts.FULL_AOD_TO_DESKTOP_CLOCK_ANIMATION);
    }
  }

  private getOneShotPartMgr(): ClockOneShotPartAnimManager {
    if (this.oneShotPartAnimMgr === undefined) {
      log.showError('oneShotPartAnimMgr has not init');
      this.oneShotPartAnimMgr = new ClockOneShotPartAnimManager(this.staticState,
        this.bindState, this.clockAnimData, this.clockLayoutModifier);
    }
    return this.oneShotPartAnimMgr;
  }

  private interruptPartAnim(): void {
    this.getOneShotPartMgr()?.stopOneShotAnim();
  }

  private handleDesktopToPartAod(val?: number): void {
    log.showInfo('handleDesktopToPartAod');
    this.interruptPartAnim();
    slUiStateMgr.getSlState(SlMainStateType.SL_CLOCK_WG_STATIC_STATE)?.setSlState(
      ClockStaticStateType.DESKTOP_TO_AOD_ANIM_TYPE, ClockDeskTop2AodAnimType.NONE);
    // 设置锁屏时钟到桌面时钟位置
    this.oneShotAnimMgr.setClockToCollapse();
    this.slClockBindCtrl.setBackgroundColor(slClockOneShotToDesktopService.getTextColorOfDesktopClock());
    this.slClockAnimCtrl.setBgColor(slClockOneShotToDesktopService.getTextColorOfDesktopClock());
    this.slClockStaticCtrl?.setClockExpandOnAod(true);
    // 动效监听
    let animListener: AnimationStateListener = {
      onAnimationStart: () => {
        this.slClockBindCtrl?.setClockExpandOnAodAnim(true);
        this.slClockBindCtrl?.setClockDesktopToAod(true);
        this.animationListener?.onAnimationStart?.();
      },
      onAnimationEnd: () => {
        this.animationListener?.onAnimationEnd?.();
        sEventManager.publish(obtainLocalEvent(ScreenLockToDesktopConsts.DESKTOP_TO_AOD_ANIM_FINISHED, null));
      }
    };
    this.getOneShotPartMgr()?.startClockAnimDesktop2PartAodOneShot({
      isAnimToExpand: true,
      animListener: animListener
    }, ClockOneShortConsts.DESKTOP_TO_PART_AOD_CLOCK_ANIMATION);
  }

  private handlePartAodToDesktop(val: number): void {
    log.showInfo('handlePartAodToDesktop');
    this.slClockBindCtrl?.setClockAodToDesktop(true);
    this.interruptPartAnim();
    PageDesktopOneShotManager.getInstance().setIsHideClockAnimation(true);

    this.slClockStaticCtrl?.setClockExpandOnAod(false);
    slClockOneShotToDesktopService.notifyUpdateTextColorOfDesktopClock();
    let animListener: AnimationStateListener = {
      onAnimationStart: () => {
        this.animationListener?.onAnimationStart?.();
      },
      onAnimationEnd: () => {
        this.animationListener?.onAnimationEnd?.();
        this.slClockBindCtrl?.setClockExpandOnAodAnim(false);
        this.getOneShotPartMgr()?.updatePartClockOffset(false);
      }
    };

    if (this.staticState.updateClockToCollapseOnDesktop(true)) {
      this.getOneShotPartMgr()?.startClockAnimPartAod2DesktopOneShot({
        isAnimToExpand: false,
        animListener: animListener
      }, ClockOneShortConsts.PART_AOD_TO_DESKTOP_CLOCK_ANIMATION);
    } else {
      this.slClockBindCtrl?.setClockExpandOnAodAnim(false);
      this.getOneShotPartMgr()?.updatePartClockOffset(false);
      this.slClockBindCtrl?.setClockAodToDesktop(false);
    }
  }

  private handleNoMirrorToPartAod(val?: number): void {
    this.interruptPartAnim();
    log.showInfo('handleNoMirrorToPartAod');
    slUiStateMgr.getSlState(SlMainStateType.SL_CLOCK_WG_STATIC_STATE)?.setSlState(
      ClockStaticStateType.DESKTOP_TO_AOD_ANIM_TYPE, ClockDeskTop2AodAnimType.NONE);
    this.slClockStaticCtrl?.setClockExpandOnAod(true);
    this.slClockBindCtrl.setClockExpandOnAodAnim(true);
    this.getOneShotPartMgr()?.refreshClock2PartAod();
  }

  private handleNoMirrorPartAodToSl(val?: number): void {
    this.interruptPartAnim();
    log.showInfo('handleNoMirrorPartAodToSl');
    this.recoverClockAfterOneShotAnim();
  }

  private handlePartAodToSl(val: number): void {
    log.showInfo('handlePartAodToSl');
    this.interruptPartAnim();
    this.slClockStaticCtrl?.setClockExpandOnAod(false);
    let animListener: AnimationStateListener = {
      onAnimationStart: () => {
        this.animationListener?.onAnimationStart?.();
      },
      onAnimationEnd: () => {
        this.animationListener?.onAnimationEnd?.();
        this.slClockBindCtrl?.setClockExpandOnAodAnim(false);
      }
    };

    this.getOneShotPartMgr()?.startClockAnimPartAod2SlOneShot({
      isAnimToExpand: false,
      animListener: animListener
    }, ClockOneShortConsts.PART_AOD_TO_SL_CLOCK_ANIMATION);
  }

  private handleSlToPartAod(val?: number): void {
    log.showInfo('handleSlToPartAod');
    this.interruptPartAnim();
    this.slClockStaticCtrl?.setClockExpandOnAod(true);
    this.slClockBindCtrl?.setClockExpandOnAodAnim(true);
    this.getOneShotPartMgr()?.startClockAnimSl2PartAodOneShot({
      isAnimToExpand: true,
      animListener: this.animationListener
    }, ClockOneShortConsts.SL_TO_PART_AOD_CLOCK_ANIMATION);
  }

  prepareForOneShotAnimOnFirstMove(): void {
    this.interruptPartAnim();
    if (!this.bindState.isClockWidgetOnTouchMoving) {
      this.recoverClockBeforeUnlockAnimIfNeed();
      this.staticState.updateClockToCollapseOnDesktop(true);
      this.oneShotAnimMgr.prepareForOneShotAnimOnFirstMove({
        isAnimToExpand: false,
        animListener: this.animationListenerOnMove
      })
    }
  }

  updateClockWidgetParamsOnMove(slidingDistance: number): void {
    log.showInfo(`oneShot recive updateClockWidgetParamsOnMove slidingDistance = ${slidingDistance}`);
    this.oneShotAnimMgr.startCollapseStateChangeAnimOnMoveForOneShot(false, slidingDistance)
    this.bindState.updateClockOnMove(true);
  }

  public registerClockStyleChange(clockStyleChangeCallback: Callback<number>): void {
    this.onClockStyleChanged = clockStyleChangeCallback;
  }

  /**
   * 获取当前时钟是否是展开状态
   *
   * @returns true 则为展开状态
   */
  public getIsClockWidgetExpand(): boolean {
    return ClockStaticData.sIsClockWidgetExpand;
  }

  /**
   * 获取当前通知是否是展开状态
   *
   * @returns true 则为展开状态
   */
  public getIsNotificationExpand(): boolean {
    return ClockWidgetModel.sIsNotificationExpand;
  }

  public setIsNotificationExpand(isNotificationExpand: boolean): boolean {
    return ClockWidgetModel.sIsNotificationExpand = isNotificationExpand;
  }

  public destroyMeshRange(): void {
    log.showInfo('ClockWidgetModel destroyMeshRange');
    this.onClockStyleChanged(ClockWidgetMeshConfig.clockBeginMeshY);
    ScreenLockHeadManager.unRegisterComponentCallback(ComponentType.CLOCK, this.clockChangeCallback);
    // 注销时钟栅格监听
    ClockWidgetMeshConfig.unregisterMeshChangeListener(this.clockMeshChange);
  }

  public static initClockRange() {
    ClockWidgetModel.isChangeable = !(ClockWidgetMeshConfig.minClockMeshY === ClockWidgetMeshConfig.maxClockMeshY);
    log.showInfo(`InitClockRange, minClockMesh: ${ClockWidgetMeshConfig.minClockMeshY}, maxClockMesh: ${ClockWidgetMeshConfig.maxClockMeshY},` +
      `clockTopMesh: ${ClockWidgetMeshConfig.clockTopMesh}, clockBeginMesh: ${ClockWidgetMeshConfig.clockBeginMeshY}`);
    ClockWidgetModel.clockMeshRange = new MeshRange(ClockWidgetMeshConfig.clockBeginMeshY,
      ClockWidgetMeshConfig.clockBeginMeshY + ClockWidgetMeshConfig.maxClockMeshY);
    // init从config获取
    ScreenLockHeadManager.initHeadMeshRange(ComponentType.CLOCK, ClockWidgetModel.clockMeshRange);
  }

  /**
   * 更新锁屏元素可见性
   *
   * @param signatureVisible 签名可见性
   * @param lunarVisible 农历可见性
   * @param dateVisible 日期可见性
   */
  public updateClockElementVisible(signatureVisible: boolean, lunarVisible: boolean, dateVisible: boolean) {
    let isVisibleChange = false;
    if (this.staticState.isSignVisible !== signatureVisible) {
      this.staticState.isSignVisible = signatureVisible
      this.updateDateWeekStyle();
      isVisibleChange = true;
    }
    if (this.staticState.isLunarVisible !== lunarVisible) {
      this.staticState.isLunarVisible = lunarVisible;
      isVisibleChange = true;
    }
    if (this.staticState.isDateVisible !== dateVisible) {
      this.staticState.isDateVisible = dateVisible;
      isVisibleChange = true;
    }
    if (isVisibleChange) {
      this.staticState.updateShowRegion();
      if (this.isImmersivePanelRelated) {
        this.updateSlClockRegionState();
      }
    }
  }

  /**
   * 设置沉浸面板关联性, 用于标识锁屏界面的clockWidget
   *
   * @param isImmersivePanelRelated 沉浸面板关联性
   */
  public setImmersivePanelRelated(isImmersivePanelRelated: boolean) {
    this.isImmersivePanelRelated = isImmersivePanelRelated;
  }

  private clockChangeCallback: ComponentCallback = {
    onRangeChange: (meshRange: MeshRange): void => {
      this.onMeshUsageChange(meshRange, (result) => {
        log.showInfo('onRangeChange set clock meshRange');
        ScreenLockHeadManager.setClockMeshRange(result);
      });
    }
  }

  // 时钟栅格配置参数切换
  private clockMeshChange = () => {
  };

  public async onMeshUsageChange(meshRange: MeshRange, onResultCallback: (result: MeshRange) => void): Promise<void> {
    this.printRangeInfo(meshRange);
    // meshHeight大于时钟最大高度, 做change
    let meshHeight: number = meshRange.rangeEnd - meshRange.rangeStart;
    log.showInfo(`clockMeshRange rangeStart: ${ClockWidgetModel.clockMeshRange.rangeStart}, rangeEnd: ${ClockWidgetModel.clockMeshRange.rangeEnd},` +
      `maxClockMeshY: ${ClockWidgetMeshConfig.maxClockMeshY}, isChangeable: ${ClockWidgetModel.isChangeable}, ${this.slClockStaticCtrl.getIsExitingKg()}}`);
    // 锁屏退出阶段，保持时钟不变形，避免影响动效
    if (!this.slClockStaticCtrl.getIsExitingKg()) {
      if (meshHeight <= ClockWidgetMeshConfig.maxClockMeshY && meshRange.rangeStart === 0) {
        if (meshHeight === ClockWidgetMeshConfig.maxClockMeshY && ClockWidgetModel.isChangeable) {
          this.handleClockExpand(meshRange);
        } else {
          this.mClockChangeCallback?.onChange?.(false);
          this.handleClockCollapse();
        }
      } else {
        this.handleClockExpand(meshRange);
      }
    }
    this.printRangeInfo(ClockWidgetModel.clockMeshRange);
    onResultCallback(ClockWidgetModel.clockMeshRange);
  }

  private handleClockCollapse(): void {
    log.showInfo('onMeshUsageChange need collapse')
    sEventManager.publish(obtainLocalEvent(ClockChangeType.CLOCK_CHANGE, false));
    ClockWidgetModel.clockMeshRange = new MeshRange(0, ClockWidgetMeshConfig.minClockMeshY);
    this.updateMoveDistance();
  }

  /**
   * 艺术签名暂不不显示服务卡片，卡片高度按0处理
   *
   * @returns 卡片高度
   */
  private getPanelMeshY(): number {
    return this.slClockBindCtrl.getClockLayout() >= 200 ? 0 :
    ScreenLockFormPanelMeshConfig.getPanelMeshY();
  }

  private handleClockExpand(meshRange: MeshRange): void {
    log.showInfo('onMeshUsageChange need expand');
    this.mClockChangeCallback?.onChange?.(true);
    let realY: number = ClockWidgetMeshConfig.clockBeginMeshY;
    sEventManager.publish(obtainLocalEvent(ClockChangeType.CLOCK_CHANGE, true));
    const clockMaxMesh = realY + ClockWidgetMeshConfig.maxClockMeshY;
    let clockMeshRangeEnd = meshRange.rangeEnd;
    let panelMeshY: number = this.getPanelMeshY();
    if (meshRange.rangeEnd - meshRange.rangeStart >= ClockWidgetMeshConfig.maxClockMeshY + panelMeshY &&
      panelMeshY !== 0) {
      clockMeshRangeEnd -= ScreenLockFormPanelMeshConfig.getPanelMeshY();
    }
    clockMeshRangeEnd = clockMeshRangeEnd > clockMaxMesh ? clockMaxMesh : clockMeshRangeEnd;
    let newMesh = new MeshRange(clockMeshRangeEnd - ClockWidgetMeshConfig.maxClockMeshY, clockMeshRangeEnd);
    ClockWidgetModel.clockMeshRange = this.correctClockMesh(newMesh);
    this.updateMoveDistance();
  }

  private updateMoveDistance(): void {
    // 刷新时钟偏移
    let realY: number = ClockWidgetMeshConfig.clockBeginMeshY;
    let moveDistance = Math.max(0, realY - ClockWidgetModel.clockMeshRange.rangeStart);
    if (this.slClockStaticCtrl.getClockMoveDistance() !== moveDistance) {
      log.showInfo(`updateMoveDistance moveDistance: ${moveDistance}`);
      this.slClockStaticCtrl.setClockMoveDistance(moveDistance);
    }
    sEventManager.publish(obtainLocalEvent(ClockChangeType.CLOCK_MOVE, moveDistance));
  }


  private correctClockMesh(mesh: MeshRange): MeshRange {
    if (mesh.rangeStart >= 0) {
      return mesh;
    }

    log.showWarn(`correctClockMesh start: ${mesh.rangeStart}, end:${mesh.rangeEnd}`);
    return new MeshRange(0, mesh.rangeEnd - mesh.rangeStart);
  }

  private printRangeInfo(meshRange: MeshRange) {
    log.showInfo(`onClockMeshUsageChange meshRange: ${meshRange.rangeStart}, ${meshRange.rangeEnd}`);
  }

  private checkHasFormCard(): void { // 检测服务卡片是否添加
    let hasForm: boolean = slStateHelper.getSlFormStaticState()?.getFormPanelShow() ?? false;
    let formCount: number = slStateHelper.getSlFormStaticState()?.getFormShowCount() ?? 0;
    log.showInfo(`checkHasFormCard hasForm: ${hasForm} formCount: ${formCount}`);
    // 存在服务卡片则保持底部对齐，不区分卡片是否显示
    this.slClockBindCtrl?.setHasFormCard(formCount > 0);
  }

  private registerFont(): void {
    font.registerFont({
      familyName: ClockComFamily.HARMONY_CLOCK_01,
      familySrc: $rawfile(`${ClockComFamily.HARMONY_CLOCK_01}.ttf`)
    });

    font.registerFont({
      familyName: ClockComFamily.HARMONY_CLOCK_02,
      familySrc: $rawfile(`${ClockComFamily.HARMONY_CLOCK_02}.ttf`)
    });

    font.registerFont({
      familyName: ClockComFamily.HARMONY_CLOCK_03,
      familySrc: $rawfile(`${ClockComFamily.HARMONY_CLOCK_03}.ttf`)
    });

    font.registerFont({
      familyName: ClockComFamily.HARMONY_CLOCK_04,
      familySrc: $rawfile(`${ClockComFamily.HARMONY_CLOCK_04}.ttf`)
    });

    font.registerFont({
      familyName: ClockComFamily.HARMONY_CLOCK_05,
      familySrc: $rawfile(`${ClockComFamily.HARMONY_CLOCK_05}.ttf`)
    });

    font.registerFont({
      familyName: ClockComFamily.HARMONY_CLOCK_06,
      familySrc: $rawfile(`${ClockComFamily.HARMONY_CLOCK_06}.ttf`)
    });

    font.registerFont({
      familyName: ClockComFamily.HARMONY_CLOCK_07,
      familySrc: $rawfile(`${ClockComFamily.HARMONY_CLOCK_07}.ttf`)
    });

    font.registerFont({
      familyName: ClockComFamily.HARMONY_CLOCK_08,
      familySrc: $rawfile(`${ClockComFamily.HARMONY_CLOCK_08}.ttf`)
    });

    if (CCMParamUtil.isUD()) {
      font.registerFont({
        familyName: ClockComFamily.HARMONY_CLOCK_ULT_01,
        familySrc: $rawfile(`${ClockComFamily.HARMONY_CLOCK_ULT_01}.ttf`)
      });

      font.registerFont({
        familyName: ClockComFamily.HARMONY_CLOCK_ULT_2_4,
        familySrc: $rawfile(`${ClockComFamily.HARMONY_CLOCK_ULT_2_4}.ttf`)
      });
    }
  }

  private updateSlClockRegionState() {
    let slStaticState = slStateHelper.getSlStaticState();
    slStaticState?.setSlState(SlStaticStateType.CLOCK_COLLAPSE_SHOW_REGION, this.staticState?.collapseShowRegion);
    slStaticState?.setSlState(SlStaticStateType.CLOCK_NO_SIGN_SHOW_REGION, this.staticState?.noSignShowRegion);
  }

  public updateFontFamily(fontFamily: string) {
    this.staticState.fontFamily = fontFamily;

    this.handleIfNeed(fontFamily);
  }

  private handleIfNeed(fontFamily: string) {
    if (!UDFontAdapterUtil.isUD()) {
      return;
    }

    if (UDFontAdapterUtil.isSupportByFont(fontFamily)) {
      UDFontAdapterUtil.setSceneSelected(UDSelectEnum.FONT);
    } else {
      UDFontAdapterUtil.removeSceneSelected(UDSelectEnum.FONT);
    }
    // UD场景需要触发刷新一次时钟元素参数
    this.staticState.updateGridAndElementConf();
    this.updateClockLayoutParam();
  }

  private updateClockAlign(x: number, y: number, type: ClockLayout): boolean {
    this.staticState.clockPosition = { x: x, y: y };
    let clockGrid = clockWidgetConfigManager.getExpandClockGridType(type);
    const layoutGrid = this.clockHelper.getLayoutGridAmount(this.staticState.isScreenPortrait,
        this.staticState.isSubScreen);
    let horizontalAlign = this.computeHorizontalAlign(layoutGrid.x, x, x + (clockGrid?.gridWidthAmount ?? 0));
    let verticalAlign = this.computeAlign(0, layoutGrid.y - (clockGrid?.gridHeightAmount ?? 0), y);
    if (this.staticState.horizontalAlign !== horizontalAlign || this.staticState.verticalAlign !== verticalAlign) {
      this.staticState.horizontalAlign = horizontalAlign;
      this.staticState.verticalAlign = verticalAlign;
      return true;
    }
    return false;
  }

  /**
   *
   * @param gridAmount  总网格宽度
   * @param start   当前时钟左边距 x
   * @param end   当前时钟右边距
   * @returns
   */
  private computeHorizontalAlign(gridAmount: number, start: number, end: number): HVAlign {
    if (0 !== start && gridAmount !== end || 0 === start && gridAmount === end) {
      return HVAlign.CENTER;
    } else if (gridAmount === end) {
      return HVAlign.END;
    } else {
      return HVAlign.START;
    }
  }

  private computeAlign(start: number, end: number, position: number): number {
    if (start === end) {
      return HVAlign.CENTER;
    } else if (start === position) {
      return HVAlign.START;
    } else if (end === position) {
      return HVAlign.END;
    } else {
      return HVAlign.CENTER;
    }
  }

  public setClockViewId(clockViewId: string, isTextDigital: boolean) {
    this.staticState.clockViewId = clockViewId;
    this.isTextDigital = isTextDigital;
  }

  /**
   * 更新企业签名是否展示
   *
   * @param edmAdminEnable 是否superAdmin
   */
  public updateEnterpriseSignVisible(edmAdminEnable: boolean): void {
    this.staticState.isEnterpriseSignVisible = this.getEnterpriseSystemParam() || edmAdminEnable;
  }

  private recoverClockBeforeUnlockAnimIfNeed() {
    // 在播放解锁到桌面的时钟一镜到底动效前, 如果正在播放桌面到AOD动效, 则需要先恢复时钟参数, 否则影响后续动效
    if (this.slClockBindCtrl?.getClockDesktopToAod()) {
      log.info('need recover clock before animation of unlock');
      this.recoverClockAfterOneShotAnim(false);
    }
  }

  public getTimeFontWeight(fontFamily: string): FontWeight | undefined { // 时间文本字重
    if (UDFontAdapterUtil.isSupportByFont(fontFamily)) {
      return undefined;
    }
    let family = this.clockHelper.adapterTimeViewFontFamily(fontFamily);
    return this.getClockStaticState().getTimeFontWeight(family);
  }

  public setClockHelper(clockHelper: ClockLayoutHelper) {
    this.clockHelper = clockHelper;
    this.staticState.setClockHelper(clockHelper);
  }

  getFontColor(param: ClockColorParam): ResourceColor | undefined {
    if (!param.textBlurEffect) {
      if (param.slClockBindCtrl?.getRemoveBrightness() && param.slClockBindCtrl?.getTextColorOfDesktopClock()) {
        return param.slClockBindCtrl?.getTextColorOfDesktopClock();
      }
      if (param.slClockStaticCtrl.getClockViewId() === AOD_CLOCK_WIDGET ||
          param.slClockStaticCtrl.getClockViewId() === AOD_PREVIEW_CLOCK_WIDGET) {
        return param.slClockBindCtrl.getTextColor();
      }
      return this.getBackgroundColor(param);
    }

    return BrightnessOptionUtils.brightColor;
  }

  getBackgroundColor(param: ClockColorParam): ResourceColor | undefined {
    if (this.isUseClockAnimCtrlColor(param)) {
      return param.slClockAnimCtrl?.getBgColor();
    }

    if (param.slClockBindCtrl?.getClockDesktopToAod() && param.slClockBindCtrl?.getClockAodToDesktop()) {
      // 播放时钟一镜到底动效且快速灭亮屏场景
      return param.slClockStaticCtrl?.getAodClockColor() ?? aodBackgroundColor;
    }

    if (param.slClockBindCtrl?.getRemoveBrightness()) {
      return param.slClockBindCtrl?.getTextColorOfDesktopClock();
    }

    return param.slClockBindCtrl?.getBackgroundColor();
  }

  public isImmersiveScene(slClockAnimCtrl: WidgetAnimState): boolean {
    return (slClockAnimCtrl?.isSceneAnimating(AnimScene.SCENE_INTO_IMMERSIVE) ?? false) ||
      (slClockAnimCtrl?.isSceneAnimating(AnimScene.SCENE_EXIT_IMMERSIVE) ?? false)
  }

  private isUseClockAnimCtrlColor(param: ClockColorParam): boolean {
    return (param.slClockAnimCtrl?.isSceneAnimating() || (param.slClockBindCtrl?.getClockDesktopToAod() ?? false)) &&
      param.staticState.clockViewId !== AOD_CLOCK_WIDGET && !param.slClockBindCtrl?.getClockAodToDesktop() &&
      !this.isImmersiveScene(param.slClockAnimCtrl);
  }

  /**
   * 获取时钟布局调节器
   * @returns 时钟布局调节器
   */
  public getClockLayoutModifier(): ClockLayoutModifier {
    return this.clockLayoutModifier;
  }

  /**
   * 更新日期、星期、农历数据
   * @param dateStr 日期
   * @param bigDateStr 日期
   * @param weekStr 星期
   * @param lunarDate 农历
   */
  public updateDateWeekLunarStr(dateStr: ResourceStr, bigDateStr: ResourceStr, weekStr: ResourceStr,
    lunarDate: string) {
    this.clockLayoutModifier.updateDateWeekLunarStr(dateStr, bigDateStr, weekStr, lunarDate);
  }
}

interface ClockColorParam {
  slClockAnimCtrl: WidgetAnimState;
  slClockBindCtrl: SlClockBindState;
  slClockStaticCtrl: SlClockStaticState
  textBlurEffect: boolean;
  staticState: ClockStaticData;
}