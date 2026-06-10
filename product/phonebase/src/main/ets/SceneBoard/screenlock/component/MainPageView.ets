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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper, EventManager, EvtBus, WallpaperData, WallpaperManager } from '@ohos/frameworkwrapper';
import { SCBScreenProperty } from '@ohos/windowscene';
import { InteractiveType } from '@ohos/themeservice';
import { StyleConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import {
  IThemeParam,
  LockscreenThemeConfig
} from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';
import { AnyClock } from '@ohos/screenlockwidget/src/main/ets/editsheet/models/AnyClock';
import { MainColor } from '@ohos/screenlockwidget/src/main/ets/editsheet/models/MainColor';
import ScreenLockFormViewModel from '@ohos/screenlockwidget/src/main/ets/form/vm/ScreenLockFormViewModel';
import lazy OuterScreenLockFormViewModel
  from '@ohos/screenlockwidget/src/main/ets/form/vm/OuterScreenLockFormViewModel';
import ThemeHelperUtil, { LockManifest } from '@ohos/screenlockwidget/src/main/ets/common/theme/ThemeHelperUtil';
import { MainPageVc } from '../controller/MainPageVc';
import lazy { ScreenLockEditView } from './ScreenLockEditView';
import { PinchGestureActionType } from '@ohos/desktopedit/src/main/ets/default/viewmodel/EditModeViewEvent';
import LockIcon from '@ohos/screenlockcomponent/src/main/ets/password/view/LockIcon';
import Constants from '@ohos/screenlockcomponent/src/main/ets/common/Constants';
import { clockLayoutHelper } from '@ohos/screenlockwidget/src/main/ets/clock/common/ClockLayoutHelper';
import { SlWidgetId, SlWidgetZIndex } from '@ohos/screenlockcommon/src/main/ets/constants/SlWidgetConst';
import { SCBScreenLockModel } from '../common/SCBScreenLockModel';
import {
  CommonEventMonitor,
  KeyGuardMode,
  KeyguardStatusService,
  slWallpaperMgr,
  SLWallpaperState,
  VerifyDataManager
} from '@ohos/screenlockcommon';
import { DisplayModeChangeListener, NONE_EDIT_MODE } from '@ohos/screenlockcommon/Index';
import { FormInterruptEvent } from '@ohos/screenlockwidget/src/main/ets/formAni/FormEvent';
import { ClockView } from './subview/ClockView';
import { FormPanelView } from './subview/FormPanelView';
import lazy { OuterScreenLockFormView } from './subview/OuterScreenLockFormView';
import { SlBindState } from '../model/data/SlBindState';
import { SlLockIconBindState } from '@ohos/screenlockcomponent/src/main/ets/password/viewmodel/SlLockIconBindState';
import { ScreenLockThemeChangeCallback } from '@ohos/screenlockcomponent/src/main/ets/common/ScreenLockVc';
import TemporaryPromptViewModel from '@ohos/screenlockcomponent/src/main/ets/fingerprint/TemporaryPromptViewModel';
import { AuthType } from '@ohos/screenlockcommon/src/main/ets/utils/AccountHelper';
import { MainPageDragVc } from './subviewcontrol/MainPageDragVc';
import {
  SpecialModeManager,
  SpecialModeViewData
} from '@ohos/screenlockcomponent/src/main/ets/common/SpecialModeManager';
import { slStateHelper } from '../model/helper/SlStateHelper';
import { SlCapWidgetBindState } from '@ohos/immersivekeyguard/src/main/ets/model/data/SlCapWidgetBindState';
import { SlClockBindState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockBindState';
import { SlClockLocateState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockLocateState';
import { SlListWidgetBindState } from '@ohos/immersivekeyguard/src/main/ets/model/data/SlListWidgetBindState';
import {
  SlFingerprintBindState
} from '@ohos/screenlockcomponent/src/main/ets/screenlockstate/model/data/SlFingerprintBindState';
import { SlClockStaticState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockStaticState';
import { ScreenLockSpaceBlurData } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockSpaceAniOptions';
import ScreenLockSpaceAnimationViewModel
  from '@ohos/screenlockcomponent/src/main/ets/password/viewmodel/ScreenLockSpaceAnimationViewModel';
import FormPlaceHolderInfo from '@ohos/screenlockwidget/src/main/ets/form/drag/FormPlaceHolderInfo';
import MirrorAniConfig from '@ohos/screenlockcomponent/src/main/ets/onemirror/model/MirrorAnimationConf';
import FormProxy from '@ohos/screenlockwidget/src/main/ets/form/remote/FormProxy';
import { LengthMetrics } from '@kit.ArkUI';
import { ScreenLockFormAni } from '@ohos/screenlockwidget/src/main/ets/formAni/ScreenLockFormAni';
import { ScreenLockAniScene } from '@ohos/screenlockwidget/src/main/ets/formAni/ScreenLockFormAniMgr';
import {
  StartAbilityOverlayAnimateData
} from '@ohos/systemuicommon/src/main/ets/liveview/common/StartAbilityOverlayAnimateData';
import {
  StartAbilityOverlayAnimate
} from '@ohos/systemuicommon/src/main/ets/liveview/common/StartAbilityOverlayAnimate';
import { CCMParamUtil } from '@ohos/screenlockwidget/src/main/ets/clock/common/CCMParamUtil';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { ClockStaticData } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/ClockStaticData';
import { SlVisualControl, SlAreaType, SlFeatureType, SlPositionType, CcmOption } from '@ohos/screenlockcommon';
import { RTLUtil, SCBVisualEffectMgr } from '@ohos/componenthelper';
import { VisualEffectConstants, } from '@ohos/commonconstants';
import { ImmersiveKeyguardVc } from './subviewcontrol/ImmersiveKeyguardVc';
import { ImmersiveKeyguardView } from './subview/ImmersiveKeyguardView';
import { ClockAdapterFactory } from '@ohos/screenlockwidget/src/main/ets/clock/adapter/ClockAdapter';
import { UseScene } from '@ohos/screenlockwidget/src/main/ets/common/adapter/Constans';
import { ScreenLockSpaceAniData } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockSpaceAniOptions';
import { spaceAniHelper } from '@ohos/screenlockcommon/src/main/ets/manager/SpaceAniHelper';
import { SlObserverProxy } from '@ohos/screenlockcomponent/src/main/ets/observer/SlObserverProxy';
import { MpStateTypeUtils, MpStateType } from '@ohos/screenlockcommon/src/main/ets/fsm/MainPageFsm';

const TAG = 'MainPageView'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const COMPONENT_ID_SCREEN_LOCK_HOME = TAG + '_Screen_Lock_Home';
const LOCK_ICON_HEIGHT: number = DeviceHelper.isPhone() ? Constants.SCREENLOCK_LOCK_ICON_HEIGHT :
Constants.SCREENLOCK_LOCK_ICON_HEIGHT_PAD;
const ICON_START_EXIT_BLUR_DISABLE: boolean =
  SCBVisualEffectMgr.isFeatureParamTrue(VisualEffectConstants.ICON_START_EXIT_BLUR_DISABLE);
const MAX_RTL_HEIGHT: number = 3;

@Component
export struct MainPageView {
  private persistentId: number = 0;

  @Link screenProp: SCBScreenProperty;
  @Link lockManifestParam: LockManifest;
  @Provide mainColor: MainColor = new MainColor({});
  @Provide isEdited: boolean = false;
  @Provide holderInfo: FormPlaceHolderInfo = {
    positionX: 0,
    positionY: 0,
    dimensionX: 0,
  }
  @Provide formProxy: FormProxy | undefined = undefined;
  @Provide @Watch('onFormEditChange') isEditClockUp: boolean = false;
  @Consume isFoldExpand: boolean;
  @Consume isSmallFoldOuterScreen: boolean = false;
  @State slBindState: SlBindState = slStateHelper.getSlBindState();
  @State rootAnimState: WidgetAnimState = slStateHelper.getSlStaticState().getSlMainAnimCtrl();
  @State slLockIconBindCtrl: SlLockIconBindState = slStateHelper.getSlLockIconBindState();
  @State slClockBindCtrl: SlClockBindState = slStateHelper.getSlClockBindState();
  @State slClockLocateState: SlClockLocateState = slStateHelper.getSlClockLocateState();
  @State slClockStaticCtrl: SlClockStaticState = slStateHelper.getSlClockStaticState();
  @State clockStyle: AnyClock = new AnyClock();
  @State slCapWidgetBindState: SlCapWidgetBindState = slStateHelper.getSlCapBindState();
  @State slListWidgetBindState: SlListWidgetBindState = slStateHelper.getSlListBindState();
  @State slFingerprintBindState: SlFingerprintBindState = slStateHelper.getSlFingerprintBindState();
  @State cardAnimState?: WidgetAnimState = slStateHelper.getSlCardStaticState().getSlRootCardAnimCtrl();
  @State toggleAnimState?: WidgetAnimState = slStateHelper.getSlCardStaticState().getSlToggleCardAnimCtrl();
  @State listAnimState?: WidgetAnimState = slStateHelper.getSlListStaticState().getSlRootListAnimCtrl();
  @State wallpaperData: WallpaperData = WallpaperManager.getInstance().wallpaperData;
  @State slWallpaperState: SLWallpaperState = slWallpaperMgr.getSlWallpaperState();
  @State notificationConf: MirrorAniConfig = new MirrorAniConfig();
  @State lowPositionConf: MirrorAniConfig = new MirrorAniConfig();
  @State fingerPrintConf: MirrorAniConfig = new MirrorAniConfig();
  @State themeClockParam: IThemeParam | undefined = undefined;
  @State formViewModel: ScreenLockFormViewModel | undefined = undefined;
  @State outerFormViewModel: OuterScreenLockFormViewModel | undefined = undefined;
  @State isShowFormBindSheet: boolean = false;
  @State displayMode: number = NONE_EDIT_MODE;
  @State currentState: MpStateType = MpStateType.INIT_STATE;
  @State startInfo: TranslateOptions = { x: 0, y: 0 };
  @State dragInfo: TranslateOptions = { x: 0, y: 0 };
  @State spaceAniBlurOpt: ScreenLockSpaceBlurData = spaceAniHelper.getSpaceAniBlurState();
  @State spaceAniCameraOpt: ScreenLockSpaceAniData = spaceAniHelper.getSpaceAniCameraState();
  @State spaceAniImmersiveOpt: ScreenLockSpaceAniData = spaceAniHelper.getSpaceAniImmersiveCapState();
  @State specialModeViewData: SpecialModeViewData = SpecialModeManager.getInstance().getSpecialModeViewData();
  @State temporaryPromptViewModel: TemporaryPromptViewModel =
    new TemporaryPromptViewModel(VerifyDataManager.getInstance().getVerifyInfo(AuthType.FINGERPRINT).isSupportUnlock);
  @State spaceAniViewModel: ScreenLockSpaceAnimationViewModel = new ScreenLockSpaceAnimationViewModel();
  @StorageProp('screenLockMoveEvent') @Watch('onscreenLockMoveEvent') screenMoveEvent: TouchEvent | null = null;
  @State startAbilityAnimateData: StartAbilityOverlayAnimateData = new StartAbilityOverlayAnimateData();


  @State slClockAnimCtrl: WidgetAnimState = slStateHelper.getSlClockAnimCtrl();

  // 记录当前签名显示，用于添加维测日志
  private isArtSignShow: boolean = false;

  private mainPageViewControl?: MainPageVc;
  private mainPageDragVc?: MainPageDragVc;
  private immersiveKeyguardVc: ImmersiveKeyguardVc = new ImmersiveKeyguardVc();
  private screenLockModel: SCBScreenLockModel = new SCBScreenLockModel();
  private eventMgr: EventManager = EvtBus.createEventManager();
  private slObserverProxy: SlObserverProxy = new SlObserverProxy();
  private initMpFsmState(): void {
    this.currentState = this.slObserverProxy.getMpFsmState(this.persistentId, (oldState: MpStateType, newState: MpStateType): void => {
      if (oldState === newState) {
        return;
      }
      this.currentState = newState;
      // 拖拽卡片时灭屏需要收起bindSheet
      if (!this.slBindState.getIsFormDragNotDrop() || this.currentState === MpStateType.NORMAL_FAKE_AOD_STATE ||
        this.currentState === MpStateType.SCREEN_OFF_STATE) {
        this.isShowFormBindSheet = newState === MpStateType.EDIT_CARD_STATE
          || newState === MpStateType.EDIT_CARD_DETAIL_STATE;
        slStateHelper.getClockEditorBindState().setIsShowFormBindSheet(this.isShowFormBindSheet);
      }
      this.mainPageDragVc?.updateDragState(this.isShowFormBindSheet);
      if (!this.isShowFormBindSheet) {
        this.isEditClockUp = false;
        this.slBindState.setEditClockUpScale(1.0);
      }
      if (MpStateTypeUtils.isUnlockState(newState)) {
        // 退出锁屏时，恢复时钟组件为展开布局
        ClockStaticData.updateClockWidgetExpand(true);
        this.slBindState.setIsImmersiveShowing(false);
      }
    });
  }
  private readonly _displayModeListener: DisplayModeChangeListener = {
    onDisplayModeChange: (newMode: number) => {
      this.displayMode = newMode;
      log.showInfo(`onDisplayModeChange, displayMode = ${this.displayMode}`);
    }
  }
  private readonly _themeChangeCallback: ScreenLockThemeChangeCallback = {
    onScreenLockThemeChange: (themeParam?: LockscreenThemeConfig) => {
      this.lockManifestParam = ThemeHelperUtil.getLockManifest();
      this.themeClockParam = themeParam?.clock;
      this.mainPageViewControl?.updateScreenLockThemeParam(this.lockManifestParam, this.themeClockParam);
    }
  }

  private onFormEditChange() {
    this.mainPageDragVc?.updateClockEditTop(this.isEditClockUp);
  }

  /**
   * 此处为状态栏下滑事件处理，用于下滑状态栏时调整密码页
   */
  private onscreenLockMoveEvent(): void {
    if (this.screenMoveEvent) {
      this.mainPageViewControl?.onscreenLockMoveEvent(this.screenMoveEvent);
    }
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear, start');
    StartAbilityOverlayAnimate.getInstance().initData(this.startAbilityAnimateData);
    this.mainPageViewControl = new MainPageVc({
      persistentId: this.persistentId,
      lockManifestParam: this.lockManifestParam,
      themeClockParam: this.themeClockParam,
      slBindState: this.slBindState,
      slLockIconBindCtrl: this.slLockIconBindCtrl,
      slClockBindCtrl: this.slClockBindCtrl,
      slClockLocateState: this.slClockLocateState,
      slClockStaticCtrl: this.slClockStaticCtrl,
      slListWidgetBindState: this.slListWidgetBindState,
      slFingerprintBindState: this.slFingerprintBindState,
      notificationConf: this.notificationConf,
      lowPositionConf: this.lowPositionConf,
      fingerPrintConf: this.fingerPrintConf,
      clockStyle: this.clockStyle,
      wallpaperData: this.wallpaperData,
      slWallpaperState: this.slWallpaperState,
      spaceAniBlurOpt: this.spaceAniBlurOpt,
    });
    this.mainPageViewControl.slVisualVc.init();
    this.mainPageViewControl.setUIContext(this.getUIContext());
    this.formViewModel = new ScreenLockFormViewModel();
    CommonEventMonitor.registerScreenLockSubscriber(this.formViewModel.handleSubscriberCallback);
    this.mainPageViewControl.setFormViewModel(this.formViewModel);
    this.mainPageViewControl.setTemporaryPromptViewModel(this.temporaryPromptViewModel);
    this.spaceAniViewModel.viewModelInit(this.screenProp);
    this.mainPageViewControl.setSpaceAnimationViewModel(this.spaceAniViewModel);
    this.mainPageViewControl.init();
    this.mainPageViewControl.setScreenLockThemeChangeCallback(this._themeChangeCallback);
    this.initOuterScreenLockForm();
    this.mainPageDragVc = new MainPageDragVc({
      persistentId: this.persistentId,
      mainPageVc: this.mainPageViewControl,
      slBindState: this.slBindState,
      slClockBindCtrl: this.slClockBindCtrl,
      slClockLocateState: this.slClockLocateState,
      clockStyle: this.clockStyle,
      startInfo: this.startInfo,
      dragInfo: this.dragInfo,
      holderInfo: this.holderInfo,
      formViewModel: this.formViewModel,
    });
    this.mainPageDragVc.init();
    this.formProxy = this.mainPageDragVc.getFormProxy();
    this.screenLockModel.initViewModel(this._displayModeListener);
    this.eventMgr.on(FormInterruptEvent, this.handleInterrupt);
    this.slBindState.setEditClockUpScale(1.0);
    this.initMpFsmState();
    log.showWarn(`aboutToAppear, end, clockStyle: ${this.clockStyle?.toString()}`);
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    this.mainPageViewControl?.setScreenLockThemeChangeCallback(null);
    this.mainPageViewControl?.release();
    this.mainPageViewControl?.setUIContext(null);
    this.screenLockModel.destroyViewModel();
    this.eventMgr.offAll();
    this.mainPageViewControl?.slVisualVc.destroy();
    this.slObserverProxy.release();
    CommonEventMonitor.unRegisterScreenLockSubscriber();
  }

  private initOuterScreenLockForm(): void {
      return;
  }

  // 处理打断添加事件
  private handleInterrupt = (event: FormInterruptEvent): void => {
    log.showInfo(`handle interrupt ${event.isHomeInterrupting}`);
    if (event.isHomeInterrupting) {
      this.mainPageDragVc?.cancelAddingFormAni();
    }
    this.formProxy?.closeFormCenter();
    this.mainPageViewControl?.getViewModel()?.setAddFormState(false);
  }

  private getLockIconMarginTop(): number {
    if (DeviceHelper.isPhone()) {
      return this.isSmallFoldOuterScreen ? Constants.SCREENLOCK_LOCK_ICON_MARGIN_TOP_SMALL_FOLD :
      Constants.SCREENLOCK_LOCK_ICON_MARGIN_TOP
    } else {
      return Constants.SCREENLOCK_LOCK_ICON_MARGIN_TOP_PAD
    }
  }

  private getLockIconHeight(): number {
    if ((KeyguardStatusService.isMode(KeyGuardMode.LOST_MODE)) && this.isSmallFoldOuterScreen) {
      return Constants.SMALL_SCREENLOCK_LOCK_ICON_HEIGHT;
    }
    if (this.isSmallFoldOuterScreen) {
      return Constants.SINGLE_POCKET_SCREENLOCK_LOCK_ICON_HEIGHT;
    }
    return RTLUtil.isRTL() ? LOCK_ICON_HEIGHT + MAX_RTL_HEIGHT : LOCK_ICON_HEIGHT;
  }

  @Builder
  buildLockIcon() {
    // 锁头、提示语
    LockIcon({
      persistentId: this.persistentId,
      temporaryPromptViewModel: this.temporaryPromptViewModel,
      isLightWallpaper: this.slBindState.getisLightWallpaper(),
      clockStrokeColor: this.clockStyle.clockStrokeColor,
      globalOpacity: 1 - this.slBindState.getOpacity() / 150,
      startAbilityAnimateData: this.startAbilityAnimateData,
      normalBrightArgs: this.mainPageViewControl?.slVisualVc.getBrightArgs(SlFeatureType.LOCK_ICON,
        SlPositionType.LOCK_ICON),
      enableEffect: this.clockStyle.isClockTextBlurEffectEnabled &&
        this.specialModeViewData.curMode === KeyGuardMode.DEFAULT &&
      this.mainPageViewControl?.slVisualVc.getEnable(SlFeatureType.LOCK_ICON, CcmOption.EFFECT),
      enableBright: this.mainPageViewControl?.slVisualVc.getEnable(SlFeatureType.LOCK_ICON, CcmOption.BRIGHT),
      enableSolid: this.mainPageViewControl?.slVisualVc.getEnable(SlFeatureType.LOCK_ICON, CcmOption.SOLID),
    })
      .height(this.getLockIconHeight())
      .visibility(this.lockManifestParam.quickToolsVisible ? Visibility.Visible : Visibility.Hidden)
      .margin({
        top: LengthMetrics.vp(this.getLockIconMarginTop()),
        start: LengthMetrics.vp(clockLayoutHelper.getHorizontalLockIconMargin()),
        end: LengthMetrics.vp(clockLayoutHelper.getHorizontalLockIconMargin())
      })
      .id(SlWidgetId.LOCK_HEAD)
      .zIndex(SlWidgetZIndex.Z_INDEX_LOCK_HEAD)
      .alignRules({
        top: { anchor: SlWidgetId.ROOT_ID, align: VerticalAlign.Top },
        middle: { anchor: SlWidgetId.ROOT_ID, align: HorizontalAlign.Center }
      })
      .hitTestBehavior(HitTestMode.None)
      .onAreaChange((old, newArea) => {
        SlVisualControl.getInstance().updateComponentArea(SlAreaType.LOCK_ICON, newArea);
      })
  }

  @Builder
  buildClockWidget() {
    ClockView({
      parentVc: this.mainPageViewControl,
      displayMode: this.displayMode,
      lockManifestParam: this.lockManifestParam,
      dragInfo: this.dragInfo,
      slBindState: this.slBindState,
      clockStyle: this.clockStyle,
      slClockBindCtrl: this.slClockBindCtrl,
      formViewModel: this.formViewModel,
      normalArgs: this.mainPageViewControl?.slVisualVc.getBrightArgs(SlFeatureType.CLOCK_MAIN,
        SlPositionType.SL_CLOCK_WIDGET),
      enableEffect: this.mainPageViewControl?.slVisualVc.getEnable(SlFeatureType.CLOCK_MAIN, CcmOption.EFFECT),
      enableBright: this.mainPageViewControl?.slVisualVc.getEnable(SlFeatureType.CLOCK_MAIN, CcmOption.BRIGHT),
      enableSolid: this.mainPageViewControl?.slVisualVc.getEnable(SlFeatureType.CLOCK_MAIN, CcmOption.SOLID),
    })
  }



  @Builder
  buildFormPanelView() {
    if (this.specialModeViewData.curMode === KeyGuardMode.DEFAULT && !this.isSmallFoldOuterScreen) {
      FormPanelView({
        persistentId: this.persistentId,
        parentVc: this.mainPageViewControl,
        displayMode: this.displayMode,
        formViewModel: this.formViewModel,
        screenProp: this.screenProp,
        lockManifestParam: this.lockManifestParam,
        clockStyle: this.clockStyle,
        isShowFormBindSheet: this.isShowFormBindSheet,
        dragInfo: this.dragInfo,
        bgEffect: this.getEffect()
      })
    }
  }

  @Builder
  buildImmersiveKeyguard() {
    ImmersiveKeyguardView({
      keyGuardMode: this.specialModeViewData.curMode,
      slBindState: this.slBindState,
      isNtfFingerprintConflict: this.slCapWidgetBindState.getNtfFingerprintConflict(),
      slClockBindCtrl: this.slClockBindCtrl,
      isDeviceWithOuter: false,
      isSmallFoldOuterScreen: this.isSmallFoldOuterScreen,
      slListWidgetBindState: this.slListWidgetBindState,
      spaceAniViewModel: this.spaceAniViewModel,
      listAnimState: this.listAnimState,
      isFoldExpand: this.isFoldExpand,
      cardAnimState: this.cardAnimState,
      toggleAnimState: this.toggleAnimState,
      spaceAniOpt: this.spaceAniImmersiveOpt,
      notificationConf: this.notificationConf,
      slFingerprintBindState: this.slFingerprintBindState,
      vc: this.immersiveKeyguardVc,
      currentState: this.currentState
    })
  }

  @Builder
  buildContentBlur() {
    if (this.getScreenLockHomeBlur() > 0) { // 相机图标跟手滑动时模糊遮挡
      Column()
        .hitTestBehavior(HitTestMode.None)
        .width(StyleConstants.PERCENTAGE_100)
        .height(StyleConstants.PERCENTAGE_100)
        .backdropBlur(this.getScreenLockHomeBlur(), undefined, { disableSystemAdaptation: true })
        .id('contentBlur')
    }
  }

  private getScreenLockHomeBlur(): number {
    if (CCMParamUtil.isForegroundEffectSupport() && this.spaceAniBlurOpt.getBlurRatio() > 0) {
      return this.spaceAniBlurOpt.getBlurRatio() * Constants.MAX_FOREGROUND_BLUR_RADIUS;
    }
    if (ICON_START_EXIT_BLUR_DISABLE) {
      return 0;
    }
    return this.slBindState.getHomeContentBlur();
  }

  @Builder
  buildOuterScreenLockFormView() {
    if (this.specialModeViewData.curMode === KeyGuardMode.DEFAULT && this.isSmallFoldOuterScreen) {
      OuterScreenLockFormView({
        outerFormViewModel: this.outerFormViewModel,
        displayMode: this.displayMode,
        clockStyle: this.clockStyle,
      })
    }
  }

  /**
   * 获取当前模式是否显示底部提示语
   *
   * @returns true:显示 false:不显示
   */
  private isShowRemindView(): boolean {
    return this.specialModeViewData.curMode === KeyGuardMode.LOST_MODE ||
      this.specialModeViewData.curMode === KeyGuardMode.POWER_EMERGENCY;
  }

  private getScreenLockEleOpacity(): number {
    let viewOpacity: number = this.slBindState.getOpacity();
    return 1 - viewOpacity / 150;
  }

  private getBottomToolsEleOpacity(): number {
    if (ScreenLockSpaceAnimationViewModel.isSpaceUnlockAnimation()) {
      return this.spaceAniCameraOpt.getSpaceOpacity();
    }
    return this.lowPositionConf.getAlpha() * this.getScreenLockEleOpacity();
  }

  @Styles
  mainContentStyles() {
    .draggable(false)
    .scale(this.getRootScale())
    .borderRadius(this.isSmallFoldOuterScreen ? $r('app.float.wallpaper_outline_radius_small_fold') :
    $r('app.float.wallpaper_outline_radius'))
    .width(StyleConstants.PERCENTAGE_100)
    .height(StyleConstants.PERCENTAGE_100)
    .onTouch(event => {
      this.mainPageDragVc?.handleClockDrag(event);
      this.mainPageViewControl?.getViewModel()?.handleTouchScreenLock(event);
      this.mainPageViewControl?.getViewModel()?.setPanelDownGlobalPosition(event);
    })
    .onClick((event: ClickEvent) => {
      this.mainPageViewControl?.getViewModel()?.singleClickScreenLock(event);
    })
    .priorityGesture(PinchGesture() // 感知捏合手势
      .onActionStart((ev: GestureEvent) => {
        this.mainPageViewControl?.getViewModel()?.handlePinchGestureEvent(ev, PinchGestureActionType.ACTION_START)
      })
      .onActionUpdate((ev: GestureEvent) => {
        this.mainPageViewControl?.getViewModel()?.handlePinchGestureEvent(ev, PinchGestureActionType.ACTION_UPDATE);
      })
      .onActionEnd((ev: GestureEvent) => {
        this.mainPageViewControl?.getViewModel()?.handlePinchGestureEvent(ev, PinchGestureActionType.ACTION_END);
      }))
    .parallelGesture(GestureGroup(GestureMode.Exclusive,
      PanGesture({ direction: PanDirection.All })
        .onActionStart((ev: GestureEvent) => {
          this.mainPageViewControl?.getViewModel()?.handleInteractiveEvent(ev, InteractiveType.MOVE)
        })
        .onActionEnd((ev: GestureEvent) => {
          this.mainPageViewControl?.getViewModel()?.scrollWheelUnlock(ev);
        }),
      TapGesture({ count: 2 }) // 双击
        .onAction((ev: GestureEvent) => {
          this.mainPageViewControl?.getViewModel()?.doubleClickScreenLock(ev);
          this.mainPageViewControl?.getViewModel()?.handleInteractiveEvent(ev, InteractiveType.DOUBLE_CLICK);
        }),
      TapGesture({ count: 1 }) // 单击
        .onAction((event: GestureEvent) => {
          this.mainPageViewControl?.getViewModel()?.handleInteractiveEvent(event, InteractiveType.CLICK);
        }),
      LongPressGesture({ repeat: false })
        .onAction((ev: GestureEvent) => {
          this.mainPageViewControl?.getViewModel()?.handleInteractiveEvent(ev, InteractiveType.LONG_PRESS);
        })
        .onActionEnd((ev: GestureEvent) => {
          this.mainPageViewControl?.getViewModel()?.touchGesture2Psd(ev);
        })
    ))
    .translate(this.getWallpaperTranslate())
    .hitTestBehavior(this.getScreenLockTouchBehavior())
    .accessibilityLevel(this.mainPageViewControl?.getAccessibilityLevel())
    .accessibilityText(this.mainPageViewControl?.getAccessibilityText())
    .onDragStart((event) => {
      this.mainPageDragVc?.handleFormDragStart(event);
    })
    .onDragMove((event) => {
      this.mainPageDragVc?.handleFormDragMove(event);
    })
    .onDrop((event) => {
      this.mainPageDragVc?.handleFormDragEnd(event);
    })
  }

  private getRootScale(): ScaleOptions {
    if (this.isEditClockUp && this.slBindState.getEditClockUpScale() < 1) {
      return {
        x: this.slBindState.getEditClockUpScale(),
        y: this.slBindState.getEditClockUpScale(),
        centerX: '50%',
        centerY: 0
      }
    }
    if (this.rootAnimState.isSceneAnimating()) {
      return { x: this.rootAnimState?.getScaleX(), y: this.rootAnimState?.getScaleY() };
    }

    const rootScale = this.slBindState.getRootScale();
    let wallpaperScale: number = this.wallpaperData.wallpaperScale > 1 ? 1 : this.wallpaperData.wallpaperScale;
    let slideScale = this.slBindState.getSlideScale();
    return {
      x: slideScale * rootScale *
      this.slBindState.getScaleByCameraTool() * wallpaperScale,
      y: slideScale * rootScale *
      this.slBindState.getScaleByCameraTool() * wallpaperScale
    };

  }

  private getWallpaperTranslate(): TranslateOptions {
    return { y: this.slBindState.getWallpaperTranslate() };
  }

  private getScreenLockTouchBehavior(): HitTestMode {
    if (this.slBindState?.getIsFakeAodState()) {
      return HitTestMode.Block;
    } else {
      return HitTestMode.Default;
    }
  }

  @Builder
  buildSCBScreenLock() {
    Stack() {
      EffectComponent() { // 模糊合并区域
        ScreenLockFormAni({
          scene: ScreenLockAniScene.INNER
        })
          .zIndex(SlWidgetZIndex.Z_INDEX_DROP_ANIMATION)
        RelativeContainer() {
          this.buildLockIcon()
          this.buildOuterScreenLockFormView()
          this.buildClockWidget()
          this.buildFormPanelView()
          this.buildImmersiveKeyguard()
        }
        .mainContentStyles()

        this.buildContentBlur()
      }
      .width(StyleConstants.PERCENTAGE_100)
      .height(StyleConstants.PERCENTAGE_100)
      .backgroundEffect(this.getEffect(), { disableSystemAdaptation: true })
      .freeze(this.getScreenLockBlurFreeze())
    }
    .width(StyleConstants.PERCENTAGE_100)
    .height(StyleConstants.PERCENTAGE_100)
    .id(COMPONENT_ID_SCREEN_LOCK_HOME)
    .foregroundBlurStyle(this.getScreenLockBlurStyle(),
      { colorMode: ThemeColorMode.LIGHT, adaptiveColor: AdaptiveColor.DEFAULT, scale: 0.1 },
      { disableSystemAdaptation: true })
  }

  private getEffect(): BackgroundEffectOptions | undefined {
    if (this.mainPageViewControl?.slVisualVc.getMainViewEffectDisabled()) {
      return undefined;
    }

    if (!this.mainPageViewControl?.slVisualVc.getEnable(SlFeatureType.CLOCK_MAIN, CcmOption.BRIGHT)) {
      return {
        policy: 1,
        radius: 25,
        color: this.getFontColor()
      }
    }
    return {
      policy: 1,
      radius: 25
    }
  }

  // 中档视效场景，由于时钟保留模糊，直接在时钟组件内赋色无法生效；赋色需要将颜色添加在模糊参数中
  private getFontColor(): ResourceColor | undefined {
    let clockVm = ClockAdapterFactory.wrapper(UseScene.MAIN_PAGE).getClockWidgetModel();
    return clockVm.getFontColor({
      slClockAnimCtrl: this.slClockAnimCtrl,
      slClockBindCtrl: this.slClockBindCtrl,
      slClockStaticCtrl: this.slClockStaticCtrl,
      textBlurEffect: this.getClockTextBlurEnabled(),
      staticState: clockVm.getClockStaticState()
    });
  }

  private getClockTextBlurEnabled(): boolean {
    if (!this.mainPageViewControl?.slVisualVc.getEnable(SlFeatureType.CLOCK_MAIN, CcmOption.SOLID) &&
      !this.mainPageViewControl?.slVisualVc.getEnable(SlFeatureType.CLOCK_MAIN, CcmOption.BRIGHT)) {
      return false;
    }

    return this.clockStyle.isClockTextBlurEffectEnabled &&
      !this.slClockBindCtrl.getClearTextBlurEffect() && this.specialModeViewData.curMode === KeyGuardMode.DEFAULT
  }

  private getScreenLockBlurStyle(): BlurStyle | undefined {
    if (this.rootAnimState?.isSceneAnimating()) {
      return this.rootAnimState.getBlur();
    } else {
      return BlurStyle.NONE;
    }
  }

  private getScreenLockBlurFreeze(): boolean {
    if (this.specialModeViewData?.curMode !== KeyGuardMode.DEFAULT) {
      return true;
    }
    return this.slBindState.isBgBlurSceneFreeze();
  }

  private isSpecialMode(): boolean {
    return this.specialModeViewData.curMode !== KeyGuardMode.DEFAULT;
  }

  build() {
    if (this.slBindState.isPanelShowing()) {
      Stack({ alignContent: Alignment.Bottom }) {

        this.buildSCBScreenLock()
        if (this.wallpaperData.showBackWallpaper) {
          ScreenLockEditView({
            clockStyle: this.clockStyle,
            formViewModel: this.formViewModel,
            persistentId: this.persistentId,
            mainPageViewControl: this.mainPageViewControl
          })
        }
      }
      .visibility(this.slBindState.getSlVisibility())
      .width('100%')
      .height('100%')
    }
  }
}
