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

import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import {
  SlVisualArgs,
  GlobalStatusCache,
  KeyGuardMode,
  SlAreaType,
  SlVisualControl,
  slWallpaperMgr,
  SLWallpaperState,
  StatusCacheConst,
  KeyguardStatusService,
  SolidColorListener,
  slClockOneShotToDesktopService,
  slUiStateMgr,
  SlMainStateType,
  ISlStateChangeListener,
  ClockBindStateType,
  WidgetBindStateType,
  SlSubStateType
} from '@ohos/screenlockcommon';
import { EditBindStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { ClockWidget } from '@ohos/screenlockwidget/src/main/ets/clock/view/ClockWidget';
import ClockBorderView from '@ohos/screenlockwidget/src/main/ets/editsheet/views/ClockBorderView';
import { SlWidgetId, SlWidgetZIndex } from '@ohos/screenlockcommon/src/main/ets/constants/SlWidgetConst';
import { SlClockBindState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockBindState';
import { SlClockLocateState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockLocateState';
import { SlClockStaticState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockStaticState';
import { ClockThemeHelper } from '@ohos/screenlockwidget/src/main/ets/common/helper/ClockThemeHelper';
import {
  ClockLayout,
  IThemeParam,
  LockscreenThemeConfig
} from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';
import ScreenLockThemeManager from '@ohos/screenlockwidget/src/main/ets/common/theme/ScreenLockThemeManager';
import { AnyClock,
  CLOCK_DEFAULT_FOREGROUND_COLOR } from '@ohos/screenlockwidget/src/main/ets/editsheet/models/AnyClock';
import { MainColor } from '@ohos/screenlockwidget/src/main/ets/editsheet/models/MainColor';
import { LockManifest } from '@ohos/screenlockwidget/src/main/ets/common/theme/ThemeHelperUtil';
import { MainPageVc } from '../../controller/MainPageVc';
import { ClockViewVc } from '../subviewcontrol/ClockViewVc';
import { ScreenLockThemeChangeCallback } from '@ohos/screenlockcomponent/src/main/ets/common/ScreenLockVc';
import { SlBindState } from '../../model/data/SlBindState';
import {
  SpecialModeManager,
  SpecialModeViewData
} from '@ohos/screenlockcomponent/src/main/ets/common/SpecialModeManager';
import { slStateHelper } from '../../model/helper/SlStateHelper';
import { ScreenLockSpaceAniData } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockSpaceAniOptions';
import ScreenLockSpaceAnimationViewModel
  from '@ohos/screenlockcomponent/src/main/ets/password/viewmodel/ScreenLockSpaceAnimationViewModel';
import ScreenLockFormViewModel from '@ohos/screenlockwidget/src/main/ets/form/vm/ScreenLockFormViewModel';
import MultiSceneThemeManager from '@ohos/screenlockwidget/src/main/ets/common/theme/MultiSceneThemeManager';
import { LengthMetrics } from '@kit.ArkUI';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { WBaseProperty } from '@ohos/screenlockcommon';
import { SlLockIconBindState } from '@ohos/screenlockcomponent/src/main/ets/password/viewmodel/SlLockIconBindState';
import Constants from '@ohos/screenlockcomponent/src/main/ets/common/Constants';
import { SlBindStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { ClockStaticStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import lazy { UltraScreenExpandAnimationVc } from '../subviewcontrol/UltraScreenExpandAnimationVc';
import { ClockAdapterFactory } from '@ohos/screenlockwidget/src/main/ets/clock/adapter/ClockAdapter';
import { UseScene } from '@ohos/screenlockwidget/src/main/ets/common/adapter/Constans';
import { ClockLayoutParam, clockLayoutParam } from '@ohos/screenlockwidget/src/main/ets/clock/common/ClockLayoutParam';
import { spaceAniHelper } from '@ohos/screenlockcommon/src/main/ets/manager/SpaceAniHelper';
import { AccessibilityUtil } from '@ohos/screenlockcommon/src/main/ets/utils/AccessibilityUtil';
import { slDofHelper } from '@ohos/screenlockwidget/src/main/ets/editsheet/viewmodel/DofHelper';
import { SpecialModeChangeListener } from '@ohos/screenlockcomponent';
import { ClockStaticData } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/ClockStaticData';
import { MpStateTypeUtils } from '@ohos/screenlockcommon/src/main/ets/fsm/MainPageFsm';

const TAG = 'ClockView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

@Component
export struct ClockView {
  private parentVc?: MainPageVc;
  private clockViewVc?: ClockViewVc;

  @Consume mainColor: MainColor;
  @Consume @Watch('onClockStyle') gridWidth: number;
  @Consume @Watch('onClockStyle') isEditClockUp: boolean;
  @Consume @Watch('onSmallFoldOuterChange') isSmallFoldOuterScreen: boolean = false;

  @Link @Watch('onFormChanged') formViewModel: ScreenLockFormViewModel;
  @Link displayMode: number;
  @Link lockManifestParam: LockManifest;
  @Link @Watch('onDrag') dragInfo: TranslateOptions;
  @Link @Watch('onClockStyle') clockStyle: AnyClock;
  @State layoutParam : ClockLayoutParam = clockLayoutParam;
  @State slBindState: SlBindState = slStateHelper.getSlBindState();
  @State slClockBindCtrl: SlClockBindState = slStateHelper.getSlClockBindState();
  @State @Watch('onClockStyle') slClockLocateState: SlClockLocateState = slStateHelper.getSlClockLocateState();
  @State slClockStaticCtrl: SlClockStaticState = slStateHelper.getSlClockStaticState();
  @State clockAnimState: WidgetAnimState = slStateHelper.getClockViewAnimSt();
  @State slClockAnimCtrl: WidgetAnimState = slStateHelper.getSlClockAnimCtrl();
  @State slWallpaperState: SLWallpaperState = slWallpaperMgr.getSlWallpaperState();
  @State slLockIconBindCtrl: SlLockIconBindState = slStateHelper.getSlLockIconBindState();
  @State clockAniOpt: ScreenLockSpaceAniData = spaceAniHelper.getSpaceAniClockState();

  @State themeClockParam: IThemeParam | undefined = undefined;
  @State @Watch('specialModeChanged') specialModeViewData: SpecialModeViewData =
    SpecialModeManager.getInstance().getSpecialModeViewData();
  @Prop normalArgs?: SlVisualArgs;
  @Prop enableEffect: boolean = true;
  @Prop enableBright: boolean = true;
  @Prop enableSolid: boolean = false;

  /**
   * 上次计算的时钟透明度，用于打印日志控制
   */
  private lastClockOpacity = 0;

  // 缓存当前特殊模式状态
  private curMode: KeyGuardMode = SpecialModeManager.getInstance().getSpecialModeViewData().curMode;

  private readonly _themeChangeCallback: ScreenLockThemeChangeCallback = {
    onScreenLockThemeChange: (themeParam?: LockscreenThemeConfig) => {
      log.showInfo(`onScreenLockThemeChange clock:${themeParam?.clock?.layout}, ` +
        `x:${themeParam?.clock?.positionX}, y:${themeParam?.clock?.positionY} signature length =
        ${themeParam?.clock?.signatureText.length}, isClockVisible:${this.lockManifestParam.clockVisible}`);
      this.themeClockParam = themeParam?.clock;
      if (!this.clockViewVc) {
        log.showError('clock view vc is null.');
      }
      this.clockViewVc?.updateClockStyle(themeParam?.clock);
      ClockViewVc.updateComponentMeshConfig(this.clockStyle);
      let isClockVisible: boolean = this.lockManifestParam.clockVisible && this.themeClockParam !== null;
      this.slClockStaticCtrl.setIsClockVisible(isClockVisible);
      this.slClockBindCtrl.setIsClockVisible(isClockVisible);
      this.clockViewVc?.updatePageDesktopOneShotState(isClockVisible, this.clockStyle);
      let isChangeColor: boolean = this.clockStyle.clockStrokeColor !== CLOCK_DEFAULT_FOREGROUND_COLOR;;
      let brightness: number = 1;
      if (this.clockStyle.aestheticColorArgs) {
        brightness = this.clockStyle.aestheticColorArgs.brightness;
      }
      this.slLockIconBindCtrl.setChangeColor(isChangeColor);
      this.slClockStaticCtrl.setChangeColorState(isChangeColor);
      this.slClockStaticCtrl.setSlState(ClockStaticStateType.BRIGHTNESS, brightness);
      this.clockViewVc?.updateClockThemeStyle();
      // 主题样式切换
      ClockThemeHelper.getInstance().updateClockThemeStyle(this.clockStyle, this.slBindState?.getGridWidth());
    }
  }

  private specialModeManagerListener: SpecialModeChangeListener = {
    onSpecialModeChange: (curMode: KeyGuardMode): void => {
      this.curMode = curMode;
    }
  }

  private onSmallFoldOuterChange(): void {
    this.slClockBindCtrl.setIsSmallOuter(this.isSmallFoldOuterScreen);
  }

  private specialModeChanged(): void {
    this.doWhenExitSpecialMode();
    this.onClockMargin();
  }

  private async doWhenExitSpecialMode(): Promise<void> {
  }

  private onClockStyle() {
    log.showInfo(`onClockStyle ${this.clockStyle.clockFontFamily}`);
    this.clockViewVc?.setIsEditClockUp(this.isEditClockUp);
    this.clockViewVc?.updateClockMargin(true);
    this.updateIState();
  }

  private onClockMargin() {
    this.clockViewVc?.updateClockMargin();
    this.updateIState();
  }

  private onFormChanged(): void {
    // 异壁纸场景,卡片移除场景,若原本时钟在底部需回落
    if (MultiSceneThemeManager.isSupportMultiSceneTheme()) {
      this.clockViewVc?.updateClockMargin(true);
    }
  }

  private solidListener: SolidColorListener = {
    onColorChange: () => {
      let textColor: string | undefined = this.getClockTextColor();
      log.showInfo(`AreaType ${SlAreaType.CLOCK} changed and text color now is ${textColor}`);
      this.slClockBindCtrl.setTextColor(textColor);
    }
  }

  /**
   * 时钟颜色状态修改监听器
   */
  private clockBindStateListener: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_CLOCK_WG_BIND_STATE,
  };



  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    slDofHelper.init();
    this.clockViewVc = new ClockViewVc({
      slBindState: this.slBindState,
      slClockBindCtrl: this.slClockBindCtrl,
      slClockLocateState: this.slClockLocateState,
      slClockAnimCtrl: this.slClockAnimCtrl,
      slClockStaticCtrl: this.slClockStaticCtrl,
      clockStyle: this.clockStyle,
      mainColor: this.mainColor,
      specialModeViewData: this.specialModeViewData,
    }, this.parentVc);
    this.clockViewVc?.init();
    this.slClockStaticCtrl.setClockExpandOnAod(false);
    this.slClockBindCtrl.setClockExpandOnAodAnim(false);
    this.slClockBindCtrl.setClockViewOffset({ x: undefined, y: undefined });
    this.clockViewVc?.updateClockMargin();
    this.clockViewVc?.setScreenLockThemeChangeCallback(this._themeChangeCallback);
    this.parentVc?.updateClockTextBlurEnabled();
    if (DeviceHelper.isUltraScreenProduct()) {
      this.clockViewVc.refreshPreClockPosition();
    }
    this.slClockStaticCtrl.setIsNeedRefreshClockLayout(false);
    this.slClockStaticCtrl.setHasNtfRelatedAnimation(true);
    this.slClockStaticCtrl.setShowAodBattery(true);
    this.slClockBindCtrl.setEnableBright(this.enableBright);
    this.slClockBindCtrl.setIsSmallOuter(this.isSmallFoldOuterScreen);
    if (this.enableSolid) {
      SlVisualControl.getInstance().registerSolidListener(SlAreaType.CLOCK, this.solidListener);
    }
    this.updateIState();
    this.clockViewVc?.setBatteryLayout();
    SpecialModeManager.getInstance().registerObserver(this.specialModeManagerListener);
    slUiStateMgr.registerSlStateChangeListener(this.clockBindStateListener);
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    slUiStateMgr.unregisterSlStateChangeListener(this.clockBindStateListener);
    SpecialModeManager.getInstance().unRegisterObserver(this.specialModeManagerListener);
    slDofHelper.release();
    if (this.enableSolid) {
      SlVisualControl.getInstance().unregisterSolidListener(SlAreaType.CLOCK, this.solidListener);
    }
    this.clockViewVc?.setScreenLockThemeChangeCallback(null);
    this.clockViewVc?.release();
  }

  private updateIState(): void {
    this.parentVc?.updateClockTextBlurEnabled();
    this.slClockBindCtrl.setTextShadow(this.getClockEnableShadow());
    this.slClockBindCtrl.setPositionX(this.getClockPositionX());
    this.slClockBindCtrl.setPositionY(this.getClockPositionY());
    let newLayout = this.getClockLayout() ?? ClockLayout.DEFAULT_CLOCK_LAYOUT;
    this.slClockBindCtrl.setClockLayout(newLayout);
    this.slClockBindCtrl.setSignatureText(this.clockStyle?.clockSignatureText);
    this.slClockStaticCtrl.setDateVisible(this.clockStyle?.isClockDateVisible);
    this.slClockStaticCtrl.setLunarVisible(this.clockStyle?.isClockLunarVisible);
    this.slClockBindCtrl.setSignatureVisible(this.getClockSignatureVisible());
    this.slClockBindCtrl.setClockStrokeColor(this.clockStyle?.clockStrokeColor);
    this.slClockBindCtrl.setTextColor(this.getClockTextColor());
    this.slClockBindCtrl.setFontFamily(this.getClockFontFamily());
    this.slClockBindCtrl.setPosterShadow(this.clockStyle?.isPosterShadow ?? false);
    this.setClockDegreeWithAnim();
    this.slClockBindCtrl.setTextAlign(this.clockStyle?.alignment);
    this.clockViewVc?.initEditMainColor();
  }

  build() {
    if (this.isSlClockVisible()) { // 时钟组件
      Stack({ alignContent: Alignment.TopStart }) {
        if (!this.isSmallFoldOuterScreen) {
          ClockBorderView({
            mainColorType: this.mainColor.colorType,
            displayMode: this.displayMode,
            isLightWallpaper: this.slWallpaperState?.isLightWallpaper,
          })
            .translate(this.getClockBorderTran())
            .onAreaChange((oldArea, newArea) => {
              this.slClockBindCtrl.setClockBoardArea(newArea);
            })
        }
        ClockWidget({
          clockAdapter: this.clockViewVc?.getClockAdapter(),
          isPosterShadow: this.clockStyle?.isPosterShadow,
        })
          .translate(this.getClockTran())
          .scale(this.getClockScale())
      }
      .id(SlWidgetId.CLOCK)
      .accessibilityGroup(true, { accessibilityPreferred: true })
      .zIndex(this.layoutParam.gridParam.zIndex ?? SlWidgetZIndex.Z_INDEX_CLOCK)
      .alignRules({
        top: { anchor: SlWidgetId.LOCK_HEAD, align: VerticalAlign.Bottom },
        left: { anchor: SlWidgetId.ROOT_ID, align: HorizontalAlign.Start }
      })
      .margin({
        start: LengthMetrics.vp(this.slClockBindCtrl.getClockWidgetLeftMargin()),
        top: LengthMetrics.vp(this.getClockWidgetTopMargin())
      })
      .offset(this.getClockViewOffset())
      .opacity(this.getClockWidgetOpacity())
      .onAppear(() => {
        this.clockViewVc?.updateClockMargin(true);
      })
      .onAreaChange((oldValue: Area, newValue: Area) => {
        SlVisualControl.getInstance().updateComponentArea(SlAreaType.CLOCK, newValue);
      })
      .gesture(GestureGroup(GestureMode.Exclusive,
        LongPressGesture({ repeat: false, duration: 500 })
          .onAction((event?: GestureEvent) => {
            this.parentVc?.getViewModel()?.longPressClockWidget(event);
          }),
        TapGesture({ count: 1 })
          .onAction((event: GestureEvent) => {
            this.parentVc?.getViewModel()?.singleClickClockWidget(event);
          }))
      )
    }
  }

  public getClockViewOffset(): Position {
    if (!this.isClockExpandAod()) {
      return { x: 0, y: 0 };
    }
    const offset = this.slClockBindCtrl.getClockViewOffset();
    const leftMargin = this.slClockBindCtrl.getClockWidgetLeftMargin();
    const topMargin = this.slClockBindCtrl.getClockWidgetTopMargin();
    log.showDebug(`clock expandOnAod, offset(x:${offset?.x},y:${offset?.y}) left:${leftMargin},top:${topMargin}`);
    if (leftMargin === undefined || topMargin === undefined ||
      offset.x === undefined || offset.y === undefined) {
      return { x: 0, y: 0 };
    }
    return {
      x: (offset.x as number ?? leftMargin) - leftMargin,
      y: (offset.y as number ?? topMargin) - topMargin
    }
  }

  private isClockExpandAod(): boolean {
    if (!slClockOneShotToDesktopService.isSupportConsumerMirror()) {
      return false;
    }
    return this.slClockBindCtrl.getClockExpandOnAodAnim();
  }

  /**
   * 时钟是否可见
   *
   * @returns 时钟可见性
   */
  public isSlClockVisible(): boolean {
    if (this.slClockBindCtrl.getIsClockVisible() || this.specialModeViewData?.curMode !== KeyGuardMode.DEFAULT) {
      return true;
    }
    if (this.slBindState.getSlState(SlBindStateType.IMMERSIVE_SHOWING_STATE) as boolean &&
      !this.isSmallFoldOuterScreen) {
      return true;
    }
    return this.slBindState.getSlState(SlBindStateType.SL_GREET_SHOWING_STATE) as boolean;
  }

  private getClockBorderTran(): TranslateOptions {
    return {
      x: this.slClockBindCtrl.getClockBorderLeftMargin(),
      y: this.slClockBindCtrl.getClockBorderTopMargin(),
    };
  }

  private onDrag(): void {
    // 可能会出现频繁打印日志，维测日志，禁止合入商用
    if (this.specialModeViewData?.curMode !== KeyGuardMode.DEFAULT || this.clockAnimState?.isWidgetAnimating()) {
      log.showWarn(`onDragClock ${this.specialModeViewData?.curMode}, ${this.clockAnimState?.isWidgetAnimating()}`);
    }
  }

  private getTripleClockTran(): TranslateOptions | undefined {
    // 判断是否处于时钟编辑态，是则返回位移为0，取消时钟位移动画
    if (this.clockViewVc?.parentVc?.currentState !== undefined
      && MpStateTypeUtils.isEditState(this.clockViewVc?.parentVc?.currentState)) {
      return {
        x: 0,
        y: 0,
      }
    }
    return {
      x: this.slClockAnimCtrl.getTranX() ?? 0,
      y: this.slClockAnimCtrl.getTranY() ?? 0,
    };
  }

  private getClockTran(): TranslateOptions | undefined {
    if (this.specialModeViewData?.curMode !== KeyGuardMode.DEFAULT) {
      return { x: 0, y: 0 };
    }
    if (this.slClockAnimCtrl?.isSceneAnimating(this.getTripleAnimScene()) && DeviceHelper.isUltraScreenProduct()) {
      return this.getTripleClockTran();
    }
    if (this.clockAnimState?.isWidgetAnimating()) { // 动效优先
      return {
        y: this.clockAnimState?.getTranY() ?? 0
      };
    }
    return this.dragInfo;
  }

  private getTripleAnimScene(): string | undefined {
    if (DeviceHelper.isUltraScreenProduct()) {
      return UltraScreenExpandAnimationVc.getInstance().getCurAnimScene();
    }
    return undefined;
  }

  private getClockEnableShadow(): boolean {
    let isShadow: boolean = false;
    if (this.parentVc) {
      isShadow = this.parentVc.getAestheticColorArgs().isShadow;
    }
    return isShadow && !this.slBindState?.isDisableClockShadow();
  }

  private getClockSignatureVisible(): boolean {
    return this.isSmallFoldOuterScreen ? false : this.clockStyle?.isClockSignatureVisible;
  }

  private getClockWidgetTopMargin() {
    if ((KeyguardStatusService.isMode(KeyGuardMode.LOST_MODE)) && this.isSmallFoldOuterScreen) {
      return Constants.SMALL_SCREENLOCK_CLOCK_WIDGET_MARGIN_TOP;
    }
    return this.slClockBindCtrl.getClockWidgetTopMargin();
  }

  private getClockWidgetOpacity(): number {
    // 空间感
    if (ScreenLockSpaceAnimationViewModel.isSpaceUnlockAnimation(SlWidgetId.CLOCK)) {
      this.printClockZeroOpacity('space anim', this.clockAniOpt.getSpaceOpacity());
      return this.clockAniOpt.getSpaceOpacity();
    }


    // 时钟组件动效
    if (this.clockAnimState?.isWidgetAnimating()) {
      this.printClockZeroOpacity('clock effect', this.clockAnimState?.getAlpha() ?? 1);
      return this.clockAnimState?.getAlpha() ?? 1;
    }

    // 跟手滑动动效
    if (this.parentVc?.isSlideAnimating()) {
      this.printClockZeroOpacity('clock slide', this.slClockBindCtrl.getLayoutOpacity());
      return this.slClockBindCtrl.getLayoutOpacity();
    }

    // 一镜到底
    if (this.slClockAnimCtrl.isSceneAnimating() && !this.slClockBindCtrl.isInDesktopAndAodClockOneShot()) {
      this.printClockZeroOpacity('clock one shot', this.slClockAnimCtrl.getAlpha() ?? 1);
      return this.slClockAnimCtrl.getAlpha() ?? 1;
    }

    // 动效场景
    if (this.slClockAnimCtrl?.isSceneAnimating()) {
      this.printClockZeroOpacity('clock animating', this.slClockAnimCtrl.getAlpha() ?? 1);
      return this.slClockAnimCtrl?.getAlpha() ?? 1;
    }

    // 默认参数，包括时钟一镜到底
    this.printClockZeroOpacity('clock one mirror', this.slClockBindCtrl.getLayoutOpacity());
    return this.slClockBindCtrl.getLayoutOpacity();
  }

  private printClockZeroOpacity(logTag: string, newOpacity: number): void {
    if (this.lastClockOpacity === newOpacity) {
      return;
    }
    this.lastClockOpacity = newOpacity;
    if (newOpacity === 0) {
      log.showWarn(logTag + ' set clock opacity to 0');
    } else if (newOpacity === 1) {
      log.showWarn(logTag + ' set clock opacity to 1');
    }
  }

  private getClockPositionX() : number | undefined {
    if (this.specialModeViewData?.curMode !== KeyGuardMode.DEFAULT) {
      return ScreenLockThemeManager.getInstance().getDefaultClockParams().clock.positionX;
    }
    return this.clockStyle?.x;
  }

  private getClockPositionY() : number | undefined {
    if (this.specialModeViewData?.curMode !== KeyGuardMode.DEFAULT) {
      return ScreenLockThemeManager.getInstance().getDefaultClockParams().clock.positionY;
    }
    return this.clockStyle?.y;
  }

  private getClockLayout() : ClockLayout | undefined {
    if (KeyguardStatusService.isMode(KeyGuardMode.LOST_MODE) && this.isSmallFoldOuterScreen) {
      return ClockLayout.NORMAL_CLOCK_LAYOUT;
    }
    if (this.specialModeViewData?.curMode !== KeyGuardMode.DEFAULT) {
      return ScreenLockThemeManager.getInstance().getDefaultClockParams().clock.layout;
    }
    return this.clockStyle?.layout;
  }

  private getClockTextColor() : string | undefined {
    if (this.specialModeViewData?.curMode !== KeyGuardMode.DEFAULT) {
      return '#B3FFFFFF';
    }

    if (!this.enableBright) {
      const selectedIndex = slUiStateMgr.getSlState(SlMainStateType.SL_EDIT_BIND_STATE)?.getSlState(
        EditBindStateType.SELECTED_COLOR_INDEX) as number;
      if (selectedIndex !== 0) {
        return this.clockStyle?.clockStrokeColor;
      }
      if (this.normalArgs) {
        if (this.enableSolid) {
          return this.normalArgs?.getSolidColor() as string;
        }
        return this.normalArgs?.getBrightnessColor(this.slWallpaperState?.isLightWallpaper) as string;
      }
    }

    return this.clockStyle?.clockStrokeColor;
  }

  private getClockFontFamily() : string | undefined {
    if (this.specialModeViewData?.curMode !== KeyGuardMode.DEFAULT) {
      return 'HarmonyHeiTi';
    }
    return this.clockStyle?.clockFontFamily;
  }

  private getClockScale(): ScaleOptions {
    // 滑动空间感
    if (ScreenLockSpaceAnimationViewModel.isSpaceUnlockAnimation(SlWidgetId.CLOCK)) {
      let screenHeight: number = GlobalStatusCache.getInstance().
      getStatus(StatusCacheConst.SCREEN_HEIGHT_KEY, 0) as number;
      log.debug(`getClockScale space: ${this.clockAniOpt.getSpaceScale()}`);
      return {
        x: this.clockAniOpt.getSpaceScale(),
        y: this.clockAniOpt.getSpaceScale(),
        centerX: '50%',
        centerY: ScreenLockSpaceAnimationViewModel.getScaleCenterY(SlWidgetId.CLOCK, screenHeight)
      };
    }

    // 时钟组件动效
    if (this.clockAnimState?.isWidgetAnimating()) {
      log.debug(`getClockScale anim: ${this.clockAnimState?.getScaleX()}`);
      return {
        x: this.clockAnimState?.getScaleX(),
        y: this.clockAnimState?.getScaleY(),
      };
    }

    // 一镜到底动效
    if (this.slClockAnimCtrl?.isSceneAnimating()) {
      log.debug(`getClockScale onemirror: ${this.slClockAnimCtrl?.getStateValue(WBaseProperty.SCALE_X)}`);
      return {
        x: this.slClockAnimCtrl?.getStateValue(WBaseProperty.SCALE_X) as number,
        y: this.slClockAnimCtrl?.getStateValue(WBaseProperty.SCALE_Y) as number,
      }
    }

    // 默认参数
    log.debug(`getClockScale default: ${this.clockAnimState?.getScaleX()}`);
    return {
      x: this.slClockBindCtrl?.getLayoutScale(),
      y: this.slClockBindCtrl?.getLayoutScale()
    }
  }

  private setClockDegreeWithAnim(): void {
    if (this.slClockStaticCtrl.getIsClockMarginNeedAnim()) {
      animateTo({ duration: 0 }, () => {
        this.slClockBindCtrl.setClockDegree(this.clockStyle.clockDegreeNumber);
      });
    } else {
      this.slClockBindCtrl.setClockDegree(this.clockStyle.clockDegreeNumber);
    }
  }
}