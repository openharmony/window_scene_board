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

import { curves, promptAction } from '@kit.ArkUI';
import { AnimateToScheduleUtils, DomainName, LogDomain, LogHelper, Trace, TraceUtil } from '@ohos/basicutils';
import { ObjectCopyUtil, RTLUtil } from '@ohos/componenthelper';
import { WallpaperStratege } from '@ohos/screenlockcommon/src/main/ets/bean/KeyGuardStatusEnum';
import { SlWidgetId } from '@ohos/screenlockcommon/src/main/ets/constants/SlWidgetConst';
import { AccessibilityLevel } from '@ohos/systemuicommon/src/main/ets/accessibility/AccessibilityData';
import { ThemeServiceHelper } from '@ohos/wallpapercomponent/src/main/ets/themeassistant/ThemeServiceHelper';
import { ScbState } from '@ohos/wallpapercomponent/src/main/ets/themeassistant/ThemeConstant';
import {
  ApsUtils,
  DeviceHelper,
  EventConstants,
  EventManager,
  EvtBus,
  obtainLocalEvent,
  sEventManager,
  ViewCallback,
  viewMgrPolicy,
  ViewType,
  WallpaperData,
} from '@ohos/frameworkwrapper';
import { ResUtils, SCBSceneSessionManager } from '@ohos/windowscene';
import {
  CoreStateType,
  CoreStateTypeUtils
} from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockCoreFsm';
import { FinishCallback } from '@ohos/screenlockcomponent/src/main/ets/onemirror/service/OneMirrorService';
import { MirrorScene } from '@ohos/screenlockcomponent/src/main/ets/onemirror/service/OneMirrorService';
import { OneMirrorListener } from '@ohos/screenlockcomponent/src/main/ets/onemirror/service/OneMirrorService';
import { OneMirrorService } from '@ohos/screenlockcomponent/src/main/ets/onemirror/service/OneMirrorService';
import { MpStateTypeUtils, MpStateType } from '@ohos/screenlockcommon/src/main/ets/fsm/MainPageFsm';
import { SlObserverProxy } from '@ohos/screenlockcomponent/src/main/ets/observer/SlObserverProxy';
import { VerifyResultInfo } from '@ohos/screenlockcomponent/src/main/ets/tips/service/VerifyTipsService';
import {
  AccessibilityUtil,
  CacheValue,
  GlobalStatusCache,
  NotificationStateManager,
  PerformanceMonitorUtil,
  screenLockInnerStateManager,
  ScreenLockToDesktopConsts,
  slClockOneShotToDesktopService,
  slWallpaperMgr,
  SLWallpaperState,
  SLWallpaperType,
  SLWallpaperVisibleScene,
  CameraStateManager,
  VerifyDataManager,
  CommonConstants,
  FingerprintAcquireCode,
  SlStorageKey,
  KeyguardStatusService,
  StatusCacheConst,
  SlFeatureType,
  CcmOption,
  KeyGuardMode,
  ClockAniAvailableFromDesktopStateWrapper,
} from '@ohos/screenlockcommon';
import {
  StateTransferAction,
  TimerScene,
  TimerUtil,
  SettingDbUtils,
  DisplayStateManager,
  DisplayStateListener,
  HiKGReportBase,
  SLUETag,
  PNAMEID,
  PVERSIONID,
  TraceTag,
} from '@ohos/screenlockcommon/Index';
import { SlStateBaseMgr } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { AuthType } from '@ohos/screenlockcommon/src/main/ets/utils/AccountHelper';
import {
  AestheticColorArgs,
  ClockLayout,
  IThemeParam,
  LockscreenThemeConfig,
} from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';
import {
  immersiveFgCtrl,
  ImmersiveFingerListener
} from '@ohos/immersivekeyguard/src/main/ets/model/service/ImmersiveFingerControll';
import Constants from '@ohos/screenlockcomponent/src/main/ets/common/Constants';
import ThemeHelperUtil, { LockManifest } from '@ohos/screenlockwidget/src/main/ets/common/theme/ThemeHelperUtil';
import {
  AnyClock,
} from '@ohos/screenlockwidget/src/main/ets/editsheet/models/AnyClock';
import {
  clockLayoutHelper,
  DEFAULT_CLOCK_LAYOUT_WIDTH_AMOUNT,
  N4_CLOCK_LAYOUT_WIDTH_AMOUNT
} from '@ohos/screenlockwidget/src/main/ets/clock/common/ClockLayoutHelper';
import { slStateHelper } from '../model/helper/SlStateHelper';
import { slStateHelper as WidgetStateHelper} from '@ohos/screenlockwidget/src/main/ets/common/utils/SlStateHelper';
import { SlLockIconBindState } from '@ohos/screenlockcomponent/src/main/ets/password/viewmodel/SlLockIconBindState';
import ScreenLockFormViewModel, {
  ShowFormPanelScene
} from '@ohos/screenlockwidget/src/main/ets/form/vm/ScreenLockFormViewModel';
import lazy OuterScreenLockFormViewModel from '@ohos/screenlockwidget/src/main/ets/form/vm/OuterScreenLockFormViewModel';
import { SlBindState } from '../model/data/SlBindState';
import { SlAnimScene } from '@ohos/screenlockcomponent/src/main/ets/common/anim/SlAnimConstants';
import SlideScreenLockVm, {
  SlideTouchType
} from '@ohos/screenlockcomponent/src/main/ets/password/viewmodel/SlideScreenLockVm';
import { LockscreenEditWeekParams, HiKGReportTimeout, TIMEOUT_PARAMS } from '@ohos/screenlockcommon/src/main/ets/record/report/PerformanceMonitorUtil';
import { immersiveVm } from '@ohos/immersivekeyguard/src/main/ets/viewmodel/ImmersiveVm';
import TemporaryPromptViewModel, { HidePromptCode } from '@ohos/screenlockcomponent/src/main/ets/fingerprint/TemporaryPromptViewModel';
import { ScreenLockVc } from '@ohos/screenlockcomponent/src/main/ets/common/ScreenLockVc';
import {
  OneMirrorAnimationPara,
  OneMirrorLayoutPara,
  OneMirrorLayoutType,
  OneMirrorSceneParaData,
  OneMirrorAnimateCallback,
  ImmersiveOneMirror
} from '@ohos/screenlockcomponent/src/main/ets/onemirror/utils/OneMirrorParaUtil';
import { OneMirrorStrategyContext } from '@ohos/screenlockcomponent/src/main/ets/onemirror/strategy/OneMirrorStrategyContext';
import { SpecialModeViewData } from '@ohos/screenlockcomponent/src/main/ets/common/SpecialModeManager';
import { VerifyTipsUtils } from '@ohos/screenlockcomponent/src/main/ets/tips/utils/VerifyTipsUtils';
import {
  SpecialModeManager,
  SpecialModeChangeListener
} from '@ohos/screenlockcomponent/src/main/ets/common/SpecialModeManager';
import ScreenLockFormPanelMeshConfig from '@ohos/screenlockwidget/src/main/ets/form/ScreenLockFormPanelMeshConfig';
import { osAccount, systemParameterEnhance } from '@kit.BasicServicesKit';
import { SlClockBindState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockBindState';
import { SlClockLocateState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockLocateState';
import { SlListWidgetBindState } from '@ohos/immersivekeyguard/src/main/ets/model/data/SlListWidgetBindState';
import { SlFingerprintBindState } from '@ohos/screenlockcomponent/src/main/ets/screenlockstate/model/data/SlFingerprintBindState';
import { SlClockStaticState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockStaticState';
import ScreenLockSpaceAnimationViewModel
  from '@ohos/screenlockcomponent/src/main/ets/password/viewmodel/ScreenLockSpaceAnimationViewModel';
import { ScreenLockSpaceBlurData } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockSpaceAniOptions';
import MirrorAniConfig from '@ohos/screenlockcomponent/src/main/ets/onemirror/model/MirrorAnimationConf';
import { MainPageVm } from '../viewmodel/MainPageVm';
import MultiSceneThemeManager, { DataType } from '@ohos/screenlockwidget/src/main/ets/common/theme/MultiSceneThemeManager';
import { clockLayoutParam } from '@ohos/screenlockwidget/src/main/ets/clock/common/ClockLayoutParam';
import { clockWidgetConfigManager } from '@ohos/screenlockwidget/src/main/ets/clock/common/ClockWidgetConfigManager';
import PasswordConstants from '@ohos/screenlockcomponent/src/main/ets/password/common/PasswordConstants';
import {
  immersiveKgMgr,
  IState,
  OnStateChangeListener,
  StateType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { OneMirrorSceneData } from '@ohos/screenlockcomponent/src/main/ets/onemirror/utils/OneMirrorParaUtil';
import OneMirrorAnimCtlFactory  from '@ohos/screenlockcomponent/src/main/ets/onemirror/viewmodel/OneMirrorAnimCtlFactory';
import { screenLockBlurButtonVM } from '@ohos/notificationcomponent/src/main/ets/vm/ScreenLockBlurButtonVM';
import { ClockViewVc } from '../component/subviewcontrol/ClockViewVc';
import { CCMParamUtil } from '@ohos/screenlockwidget/src/main/ets/clock/common/CCMParamUtil';
import {
  ScreenLockWallpaperChangeEvent
} from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/event/ImmersiveEvent';
import { screenLockGreetModel } from '@ohos/screenlockcomponent/src/main/ets/greet/model/ScreenLockGreetModel';
import { SlBindStateType,
  SlMainStateType,
  SlStaticStateType,
  SlSubStateType} from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { SlGreetModeReportScene } from '@ohos/screenlockcomponent/src/main/ets/greet/constant/Constants';
import { UltraScreenStatus } from '@ohos/screenlockcommon/src/main/ets/utils/DisplayUtils';
import { ScreenBp } from '@ohos/screenlockcommon';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import { ISlStateChangeListener } from '@ohos/screenlockcommon/src/main/ets/interface/ISlStateChangeListener';
import { ScreenLockFsmProxy, EventCallback } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockFsmProxy';
import { MpEventType } from '@ohos/screenlockcommon/src/main/ets/fsm/MainPageFsm';
import { ICommand } from '@ohos/screenlockwidget/src/main/ets/common/command/Command';
import { FormOutputEventType, IEvent } from '@ohos/screenlockwidget/src/main/ets/common/command/Event';
import { BatteryLayout } from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';
import { BaseConfig } from '@ohos/screenlockwidget/src/main/ets/common/adapter/FeatureConfig';
import { ClockAdapterFactory } from '@ohos/screenlockwidget/src/main/ets/clock/adapter/ClockAdapter';
import { UseScene } from '@ohos/screenlockwidget/src/main/ets/common/adapter/Constans';
import { ClockAdapter } from '@ohos/screenlockwidget/src/main/ets/clock/adapter/ClockAdapter';
import { ConfigType } from '@ohos/screenlockwidget/src/main/ets/common/adapter/Constans';
import { SlVisualVc } from '../visualManager/SlVisualVc';
import lazy { ScreenLockFoldExpandAnimUtil } from '@ohos/screenlockcommon/src/main/ets/utils/ScreenLockFoldExpandAnimUtil';
import { QuickToolUtil } from '@ohos/screenlockcomponent/src/main/ets/quicktools/common/StatusCacheUtil';
import {
  QuickToolConstants,
  QuickToolsState
} from '@ohos/screenlockcomponent/src/main/ets/quicktools/common/QuickToolConstants';
import { MirrorsScene } from '@ohos/screenlockcomponent/src/main/ets/onemirror/constants/MirrorToEndConst';
import OneMirrorAnimController
  from '@ohos/screenlockcomponent/src/main/ets/onemirror/viewmodel/OneMirrorAnimController';
import { PosterFontParams } from '@ohos/screenlockcommon/src/main/ets/record/report/PerformanceMonitorUtil';
import lazy { v2Helper } from '@ohos/immersivekeyguard';
import { TextEmojiHelper } from '@ohos/systemuicommon/src/main/ets/utils/TextEmojiHelper';
import parameter from '@ohos.systemParameterEnhance';
import { PageDesktopOneShotManager } from '@ohos/launchercommon/Index';

const TAG = 'MainPageViewControl';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const I_CURVE: ICurve = curves.cubicBezierCurve(0.40, 0, 0.40, 1);
const FOREGROUND_BLUR_PROGRESS = 0.2;
const BLUR_ANIMATION_DURATION_MAX: number = 100;
const ANIMATION_DURATION_THRESHOLD: number = 8;

const IS_PAD: boolean = DeviceHelper.isPadOr2in1PcType();
const IS_SMALL_FOLD: boolean = DeviceHelper.isSmallFoldProduct();
const IS_FOLD_BUT_NOT_SMALL_FOLD: boolean = DeviceHelper.isFoldButNotSmallFoldProduct();
const IS_ULTRA_SCREEN = DeviceHelper.isUltraScreenProduct();
const IS_LARGE_FOLD: boolean = DeviceHelper.isLargeInFoldProduct();

const SHOW_EDITOR: string = 'showEditor';
const HIDE_EDITOR: string = 'hideEditor';
const SHOW_PSD: string = 'CUSTOM_ANIMATOR_showPSD';
const EDIT_STATE_MAIN_PAGE_SCALE: number = 0.76;
const EDIT_PAGE_TRANSLATE: number = 24;
const TOAST_DELAY = 3000;
const CLOCK_LAYOUT: number = 1;
const POSTER_LAYOUT: number = 2;

class MainPageViewParam {
  public slVisibility?: Visibility; // 主页属性
  public wallpapreTranslate?: number;
  public zoomRatio?: number;
  public slideRatio?: number;
  public slOpacity?: number;
  public wallpaperScale?: number;
  public slWallpaperScale?: number;
  public blurRadius?: number;
  public lockIconOpacity?: number; // 锁头
  public clockOpacity?: number; // 时钟
  public listVisibility?: Visibility; // 列表
}

const NORMAL_SHOW: MainPageViewParam = {
  slVisibility: Visibility.Visible,
  wallpapreTranslate: 0,
  zoomRatio: Constants.DEFAULT_ZOOM_RATIO,
  slideRatio: Constants.DEFAULT_SLIDE_RATIO,
  slOpacity: Constants.DEFAULT_HOME_VIEW_OPACITY,
  wallpaperScale: undefined,
  slWallpaperScale: Constants.DEFAULT_WALLPAPER_SCALE,
  blurRadius: Constants.DEFAULT_BLUR_RADIUS,
  lockIconOpacity: Constants.DEFAULT_HOME_VIEW_OPACITY,
  clockOpacity: Constants.DEFAULT_HOME_VIEW_OPACITY,
  listVisibility: Visibility.Visible
};

const SCREEN_OFF_SHOW: MainPageViewParam = {
  slVisibility: Visibility.Visible,
  wallpapreTranslate: 0,
  zoomRatio: Constants.DEFAULT_ZOOM_RATIO,
  slideRatio: Constants.DEFAULT_SLIDE_RATIO,
  slOpacity: Constants.DEFAULT_HOME_VIEW_OPACITY,
  wallpaperScale: undefined,
  slWallpaperScale: Constants.DEFAULT_WALLPAPER_SCALE,
  blurRadius: Constants.DEFAULT_BLUR_RADIUS,
  lockIconOpacity: Constants.MAX_VIEW_OPACITY,
  clockOpacity: Constants.DEFAULT_HOME_VIEW_OPACITY,
  listVisibility: Visibility.Visible
};

const EDIT_NORMAL_SHOW: MainPageViewParam = {
  slVisibility: Visibility.Visible,
  wallpapreTranslate: -EDIT_PAGE_TRANSLATE,
  zoomRatio: Constants.DEFAULT_ZOOM_RATIO,
  slideRatio: Constants.DEFAULT_SLIDE_RATIO,
  slOpacity: Constants.DEFAULT_HOME_VIEW_OPACITY,
  wallpaperScale: EDIT_STATE_MAIN_PAGE_SCALE,
  slWallpaperScale: Constants.DEFAULT_WALLPAPER_SCALE,
  blurRadius: Constants.DEFAULT_BLUR_RADIUS,
  lockIconOpacity: Constants.MAX_VIEW_OPACITY,
  clockOpacity: Constants.DEFAULT_HOME_VIEW_OPACITY,
  listVisibility: Visibility.Hidden
}

const OUTER_EDIT_NORMAL_SHOW: MainPageViewParam = {
  slVisibility: Visibility.Visible,
  zoomRatio: Constants.DEFAULT_ZOOM_RATIO,
  slideRatio: Constants.DEFAULT_SLIDE_RATIO,
  slOpacity: Constants.DEFAULT_HOME_VIEW_OPACITY,
  wallpaperScale: Constants.DEFAULT_ZOOM_RATIO,
  slWallpaperScale: Constants.DEFAULT_WALLPAPER_SCALE,
  blurRadius: Constants.DEFAULT_BLUR_RADIUS,
  lockIconOpacity: Constants.MAX_VIEW_OPACITY,
  clockOpacity: Constants.DEFAULT_HOME_VIEW_OPACITY,
  listVisibility: Visibility.Hidden,
}

const FULL_EDIT_NORMAL_SHOW: MainPageViewParam = {
  slVisibility: Visibility.Visible,
  wallpapreTranslate: 0,
  zoomRatio: Constants.DEFAULT_ZOOM_RATIO,
  slideRatio: Constants.DEFAULT_SLIDE_RATIO,
  slOpacity: Constants.DEFAULT_HOME_VIEW_OPACITY,
  wallpaperScale: undefined,
  slWallpaperScale: Constants.DEFAULT_WALLPAPER_SCALE,
  blurRadius: Constants.DEFAULT_BLUR_RADIUS,
  lockIconOpacity: Constants.MAX_VIEW_OPACITY,
  clockOpacity: Constants.DEFAULT_HOME_VIEW_OPACITY,
  listVisibility: Visibility.Hidden
}

const BOUNCER_SHOW: MainPageViewParam = {
  slVisibility: undefined,
  wallpapreTranslate: 0,
  zoomRatio: Constants.MAX_ZOOM_RATIO,
  slideRatio: Constants.MAX_SLIDE_RATIO,
  slOpacity: Constants.MAX_VIEW_OPACITY,
  wallpaperScale: Constants.MIN_SCENE_SCALE,
  slWallpaperScale: Constants.MIN_WALLPAPER_SCALE,
  lockIconOpacity: Constants.MAX_VIEW_OPACITY,
  clockOpacity: Constants.MAX_VIEW_OPACITY,
  listVisibility: Visibility.Hidden
}

const UNLOCK_SHOW: MainPageViewParam = {
  slVisibility: undefined,
  wallpapreTranslate: 0,
  zoomRatio: Constants.MAX_ZOOM_RATIO,
  slideRatio: Constants.MAX_SLIDE_RATIO,
  slOpacity: Constants.MAX_VIEW_OPACITY,
  wallpaperScale: Constants.MIN_SCENE_SCALE,
  slWallpaperScale: Constants.MIN_WALLPAPER_SCALE,
  blurRadius: Constants.DEFAULT_BLUR_RADIUS,
  lockIconOpacity: Constants.MAX_VIEW_OPACITY,
  clockOpacity: Constants.MAX_VIEW_OPACITY,
  listVisibility: Visibility.Hidden
}

/**
 * View Control里用于操作渲染界面的对象
 */
export interface MainPageOperateParams {
  persistentId: number;
  slBindState: SlBindState;
  slLockIconBindCtrl: SlLockIconBindState;
  slClockBindCtrl: SlClockBindState;
  slClockLocateState: SlClockLocateState
  slClockStaticCtrl: SlClockStaticState;
  slListWidgetBindState: SlListWidgetBindState;
  slFingerprintBindState: SlFingerprintBindState;
  notificationConf: MirrorAniConfig;
  lowPositionConf: MirrorAniConfig;
  fingerPrintConf: MirrorAniConfig;
  clockStyle: AnyClock;
  wallpaperData: WallpaperData;
  slWallpaperState: SLWallpaperState;
  lockManifestParam: LockManifest;
  themeClockParam?: IThemeParam;
  spaceAniBlurOpt: ScreenLockSpaceBlurData;
}

/**
 * main page view control
 *
 * @since 2024-08-31
 */
export class MainPageVc extends ScreenLockVc<MpStateType> {
  private _persistentId: number = 0;
  private _mainPageVm?: MainPageVm;
  private _formViewModel?: ScreenLockFormViewModel;
  private _outerFormViewModel?: OuterScreenLockFormViewModel;
  private _slideScreenLockViewModel?: SlideScreenLockVm;
  private _temporaryPromptViewModel?: TemporaryPromptViewModel;
  private _spaceAnimationViewModel?: ScreenLockSpaceAnimationViewModel;
  private _uiContext?: UIContext | null;
  private _slVisualVc: SlVisualVc = new SlVisualVc();
  private _specialModeViewData: SpecialModeViewData = SpecialModeManager.getInstance().getSpecialModeViewData();
  private clockAdapter: ClockAdapter = ClockAdapterFactory.wrapper(UseScene.MAIN_PAGE);
  private clockConfig: BaseConfig = new BaseConfig();
  // 当前是否关闭时钟阴影
  private disableClockShadow: boolean = false;

  get slVisualVc(): SlVisualVc {
    return this._slVisualVc;
  }

  private isEnterEditMode(): boolean {
    return MpStateTypeUtils.isEditState(this.currentState);
  }

  private isAccessibilityMode(): boolean {
    return AccessibilityUtil.isAccessibilityMode();
  }

  public getAccessibilityText(): string {
    return this.isEnterEditMode() ? ResUtils.getInnerString(Constants.SCREEN_LOCK_EDIT_ACCESSIBLE) : '';
  }

  public getAccessibilityLevel(): string {
    if (this.slBindState.getIsToolsUsing()) {
      return AccessibilityLevel.NO_HIDE_DESCENDANTS;
    }
    return this.isEnterEditMode() ? AccessibilityLevel.YES : AccessibilityLevel.NO;
  }

  public getRootAccessibilityLevel(): string {
    return this.slBindState.getFocusDisabled() ? AccessibilityLevel.NO_HIDE_DESCENDANTS : AccessibilityLevel.YES;
  }

  private _keyguardViewCallback: ViewCallback = {
    onShow: (): void => {
      log.showWarn('show screen lock view.');
      // 进锁屏加载字体
      HiKGReportBase.reportUe(SLUETag.INTOKEYGUARD, Object({
        PNAMEID: PNAMEID,
        PVERSIONID: PVERSIONID,
      }));
      this.slBindState.setSlShowing(true);
      this.onPageShow();
    },
    onHide: (): void => {
      log.showWarn('hide screen lock view.');
      HiKGReportBase.reportUe(SLUETag.EXITKEYGUARD, Object({
        PNAMEID: PNAMEID,
        PVERSIONID: PVERSIONID,
      }));
      // 锁屏隐藏时通知桌面恢复显示
      sEventManager.publish(obtainLocalEvent(ScreenLockToDesktopConsts.DESKTOP_CLOCK_ANIMATION_START, null));
      // 保底处理，正常调用
      slClockOneShotToDesktopService.notifyNoPwdUnlockHasExitKeyguard();
      this.slBindState.setSlShowing(false);
      /*ApsUtils.setApsScene(apsManager.SceneAnimation.UNLOCK_TO_ENTER_DESKTOP,
        CommonConstants.APS_UNLOCK_TO_ENTER_DESKTOP_CLOSE);*/
    }
  };

  private _fsmEventCallback: EventCallback<CoreStateType> = {
    onEventFinish: (oldState: CoreStateType, newState: CoreStateType): void => {
      if (CoreStateTypeUtils.isInEditMainPage(oldState) && !CoreStateTypeUtils.isInEditMainPage(newState)) {
        log.showInfo('finish exist edit');
        if (this._formViewModel) {
          ScreenLockFormPanelMeshConfig.setPanelHeight(this._formViewModel.getFormPanelHeight());
        }
        ClockViewVc.updateComponentMeshConfig(this.clockStyle);
        // 通知沉浸态状态显示刷新
        if (immersiveKgMgr.getImmersiveDisplayState().isImmersive()) {
          this.slBindState.setIsImmersiveShowing(true);
        }
      }
    }
  };

  /**
   * 沉浸状态切换监听
   */
  private onStateChange: OnStateChangeListener = {
    /**
     * 沉浸状态回调
     */
    onStateChange: (state: IState): void => {
      if (state.getStateType() === StateType.TYPE_IMMERSIVE_KEYGUARD_TYPE) {
        if (immersiveKgMgr.getImmersiveDisplayState().isImmersive()) {
          this.slBindState.setIsImmersiveShowing(true);
        } else {
          this.slBindState.setIsImmersiveShowing(false);
        }
        log.showInfo(`handle immersive state change: ${this.slBindState.getIsImmersiveShowing()}`);
      }
    }
  };

  private checkSetOneShotClockOpacity(): void {
    if (OneMirrorService.getInstance().isConfigSupportToEnd() &&
      slClockOneShotToDesktopService.isClockOneShotAnimAvailable()) {
      this.setClockOpacity(Constants.DEFAULT_HOME_VIEW_OPACITY);
      log.info('clock show');
    } else {
      // 隐藏锁屏内容，防止闪
      this.setClockOpacity(Constants.MAX_VIEW_OPACITY);
      this.slBindState.setOpacity(Constants.MAX_VIEW_OPACITY);
      log.info('screenlock hide');
    }
  }

  private onPageShow() {
    this.checkSetOneShotClockOpacity();

    if (CoreStateTypeUtils.isInMainPage(this.slObserverProxy.getCoreFsmState(this._persistentId))) {
      this.slBindState.setSlVisibility(Visibility.Visible);
    }

    // reset for oneshot
    this.slClockBindCtrl.setRemoveBrightness(false);
    this.disableClockShadow = false;
    this.setDisableClockShadowWidthAnim();
    this.slClockBindCtrl.setClearTextBlurEffect(false);
    this.updateClockTextBlurEnabled();
    this.slBindState.setNeedUseEffect(false);
    this._spaceAnimationViewModel?.setUnlockAnimation(1, 1);
    this.spaceAniBlurOpt.setBlurRatio(0);
  }

  // 入参opacity取值范围：0~150；对应于setLayoutOpacity的1~0;
  private setClockOpacity(viewOpacity: number): void {
    this.slClockBindCtrl.setLayoutOpacity(1 - viewOpacity / 150);
  }

  /**
   * 重新唤醒
   */
  private readonly _wakeUpStateTransferAction: StateTransferAction<MpStateType> = {
    isStateTransferMatched: (oldState: MpStateType, newState: MpStateType): boolean => {
      return !MpStateTypeUtils.isScreenOffState(newState);
    },
    targetAction: () => {
      log.showInfo('wakeUpStateTransferAction');
    }
  };

  /**
   * 锁屏首页进入锁屏编辑预览态
   */
  private readonly stateChangeToEditShow: StateTransferAction<MpStateType> = {
    isStateTransferMatched: (oldState: MpStateType, newState: MpStateType): boolean => {
      return (MpStateTypeUtils.isBouncerState(oldState) || MpStateTypeUtils.isNormalShowState(oldState)) &&
      MpStateTypeUtils.isEditPreviewState(newState);
    },
    prepareAction: () => {
      this.updateBgWallpaperState(true);
      slWallpaperMgr.enterSlWallpaperScene(SLWallpaperType.TYPE_EDIT_STYLE, SLWallpaperVisibleScene.SCENE_SCREEN_EDIT);
      PerformanceMonitorUtil.setPinchGestureMoStart();
      Trace.start(SHOW_EDITOR);
      slClockOneShotToDesktopService.notifyRecoverClockAfterOneShotAnim();
      this.slBindState.setIsImmersiveShowing(false);
      this._formViewModel?.viewModelInit(this._formViewModel?.formConfigs, this.clockStyle.layout,
        ShowFormPanelScene.LOCK_SCREEN_EDIT, this.clockStyle.y);
      let lockIconAnimCtrl = slStateHelper.getSlLockIconStaticState().getSlLockIconAnimCtrl();
      if (lockIconAnimCtrl.isSceneAnimating()) {
        // 亮屏过程有一镜到底动效拖尾，需要清除动效场景。
        let scenes: string = lockIconAnimCtrl?.getSceneValues();
        log.showInfo(`now clear all anim scenes, ${scenes}`)
        scenes?.split(',').forEach((scene) => {
          lockIconAnimCtrl?.setAnimScene({ isAnimating: false, animScene: scene, isForceRemove: true });
        })
      }
      this.slClockLocateState.setMoveDistance(0);
      this.slBindState.setSlVisibility(Visibility.Visible);
      this.slBindState?.setSlState(SlBindStateType.SL_GREET_SHOWING_STATE, false);
      screenLockGreetModel.unLoadGreetViewWithoutAni(SlGreetModeReportScene.TO_EDIT);
    },
    animationParam: {
      curve: curves.interpolatingSpring(0, Constants.PSD_MASS, 228, 26),
      onFinish: () => {
        Trace.end(SHOW_EDITOR);
        PerformanceMonitorUtil.setPinchGestureMoEnd();
        this.updateBgWallpaperState(false);
      }
    },
    targetAction: () => {
      log.showInfo('stateChangeToEditShow');
      this.setMainPageParam(EDIT_NORMAL_SHOW);
    }
  };
  /**
   * 编辑全屏进入锁屏编辑预览态
   */
  private readonly stateChangeEditFulToEditShow: StateTransferAction<MpStateType> = {
    isStateTransferMatched: (oldState: MpStateType, newState: MpStateType): boolean => {
      return (MpStateTypeUtils.isEditFullState(oldState) && MpStateTypeUtils.isEditPreviewState(newState));
    },
    animationParam: {
      curve: curves.interpolatingSpring(0, Constants.PSD_MASS, 228, 26),
      onFinish: () => {
        Trace.end(SHOW_EDITOR);
        PerformanceMonitorUtil.setPinchGestureMoEnd();
      }
    },
    targetAction: () => {
      log.showInfo('stateChangeEditFulToEditShow');
      this.setMainPageParam(EDIT_NORMAL_SHOW);
    }
  };
  /**
   * 进入锁屏全屏编辑态
   */
  private readonly stateChangeToEditFull: StateTransferAction<MpStateType> = {
    isStateTransferMatched: (oldState: MpStateType, newState: MpStateType): boolean => {
      return (!MpStateTypeUtils.isEditFullState(oldState) && MpStateTypeUtils.isEditFullState(newState));
    },
    animationParam: {
      curve: curves.interpolatingSpring(0, Constants.PSD_MASS, Constants.PSD_STIFFNESS, Constants.PSD_DAMPING),
    },
    targetAction: () => {
      log.showInfo('enterFullEditStateTransferAction');
      this.setMainPageParam(FULL_EDIT_NORMAL_SHOW);
      this.resetWallpaperScale();
    }
  };

  private resetWallpaperScale(): void {
    // 动态壁纸时为默认值1；锁屏时为1.1
    let scale = Constants.DEFAULT_WALLPAPER_SCALE;
    if (!this.slBindState.getIsStaticTheme()) {
      scale = Constants.DEFAULT_SCALE;
    }

    this.wallpaperData.wallpaperScale = scale;
  }

  private updateBgWallpaperState(isAnimationPlaying: boolean) {
    log.showInfo(`isAnimationPlaying: ${isAnimationPlaying}`);
    if (this.isEnterEditMode() || isAnimationPlaying) {
      log.showInfo('show edit background wallpaper')
      this.wallpaperData.showBackWallpaper = true;
      TimerUtil.clearTimerByScene(TimerScene.EDIT_BACKGROUND_WALLPAPER);
    } else {
      TimerUtil.setTimer(TimerScene.EDIT_BACKGROUND_WALLPAPER, () => {
        log.showInfo(`hide edit wallpaper`);
        this.wallpaperData.showBackWallpaper = false;
      }, 1000);
    }
  }

  private exitEditState(): void {
    log.showInfo('exitEditState');
    this.setMainPageParam(NORMAL_SHOW);
    this.resetWallpaperScale();
  }

  private readonly stateChangeToBouncer: StateTransferAction<MpStateType> = {
    isStateTransferMatched: (oldState: MpStateType, newState: MpStateType): boolean => {
      return (!MpStateTypeUtils.isBouncerState(oldState) && MpStateTypeUtils.isBouncerState(newState));
    },
    prepareAction: () => {
      // V2场景隔离
      if (SlStateBaseMgr.isV2Enable()) {
        v2Helper.getV2Hook()?.requestHideSettingDialog();
      } else if (screenLockBlurButtonVM.getShouldBlur()) {
        screenLockBlurButtonVM.unblur(true);
      }
      this.slBindState.setBgBlurFreeze({ isFreeze: true, scene: SlAnimScene.SCENE_SLID_TO_PWD });
      Trace.start(TraceTag.SHOW_PSD, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
      PerformanceMonitorUtil.setScreenIntoPINStart();
      AppStorage.setOrCreate('blurRadius', Constants.MAX_WALLPAPER_BLUR);
    },
    finishAction: () => {
      if (CoreStateTypeUtils.isInBouncePage(this.slObserverProxy.getCoreFsmState(this._persistentId))) {
      this.slBindState.setSlVisibility(Visibility.Hidden);
    }
      PerformanceMonitorUtil.setScreenIntoPINEnd();
      this.slBindState.setBgBlurFreeze({ isFreeze: false, scene: SlAnimScene.SCENE_SLID_TO_PWD });
      AppStorage.setOrCreate('isSpaceOrMenuKeyEvent', false);
      log.showInfo('enterBouncer finish');
    },
    targetAction: () => {
      log.showInfo('enterBouncerStateTransferAction');
      this._spaceAnimationViewModel?.setSlideAnimation(0, 1);
      this.setMainPageParam(BOUNCER_SHOW);
    }
  };
  private readonly _immersiveFingerStateListener: ImmersiveFingerListener = {
    onNtfDataUpdate: (isShowFinger: boolean) => {
      log.showInfo(`immersive update fingerprint enable status: ${isShowFinger}`);
      this.slFingerprintBindState.setNtfDisableFingerPrint(!isShowFinger);
    }
  };
  private _oneMirrorConfMap: Map<OneMirrorLayoutType, MirrorAniConfig> = new Map();
  private _immersiveOneMirror?: ImmersiveOneMirror;
  private animCtrlFactory: OneMirrorAnimCtlFactory;
  private fromScene: MirrorScene = MirrorScene.SCREEN_OFF;
  private toScene: MirrorScene = MirrorScene.SCREEN_OFF;
  private readonly _oneMirrorListener: OneMirrorListener = {
    onMirrorScene: (fromScene: MirrorScene, toScene: MirrorScene, hasAnim: boolean,
      finishCallback?: FinishCallback): boolean => {
      this.fromScene = fromScene;
      this.toScene = toScene;
      return this.doOneMirrorScene(hasAnim, finishCallback);
    }
  }
  private slBindState: SlBindState;
  private slLockIconBindCtrl: SlLockIconBindState;
  private slClockBindCtrl: SlClockBindState;
  private slClockLocateState: SlClockLocateState;
  private slClockStaticCtrl: SlClockStaticState;
  private slListWidgetBindState: SlListWidgetBindState;
  private slFingerprintBindState: SlFingerprintBindState;
  private notificationConf: MirrorAniConfig;
  private lowPositionConf: MirrorAniConfig;
  private fingerPrintConf: MirrorAniConfig;
  private immersiveConf: MirrorAniConfig = new MirrorAniConfig();
  private clockStyle: AnyClock;
  private wallpaperData: WallpaperData;
  private slWallpaperState: SLWallpaperState;
  private spaceAniBlurOpt: ScreenLockSpaceBlurData;
  private lockManifestParam: LockManifest;
  private themeClockParam: IThemeParam | undefined;
  private eventMgr: EventManager = EvtBus.createEventManager();

  private updateToolsViewMarginForUltraScreen: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_STATIC_STATE,
    onSlStateChange: (mainType: SlMainStateType, subType?: SlSubStateType): void => {
      if (subType === SlStaticStateType.SCREEN_BP) {
        slStateHelper.getSlBindState().setBottomViewMargin(this.getBottomToolsGadget());
      }
    }
  }

  // 监听特殊模式
  private readonly _specialModeListener: SpecialModeChangeListener = {
    onSpecialModeChange: (curMode: KeyGuardMode): void => {
      this.updateClockTextBlurEnabled();
      this.updateMixedPassWordSettingState(curMode);
      QuickToolUtil.getInstance().setToolsState(QuickToolsState.CLOSE);
      this.slBindState.setIsToolsUsing(false);
    }
  };

    constructor(params: MainPageOperateParams) {
    super();
    this._persistentId = params.persistentId;
    this.lockManifestParam = params.lockManifestParam;
    this.slBindState = params.slBindState;
    this.slLockIconBindCtrl = params.slLockIconBindCtrl;
    this.slClockBindCtrl = params.slClockBindCtrl;
    this.slClockLocateState = params.slClockLocateState;
    this.slClockStaticCtrl = params.slClockStaticCtrl;
    this.slListWidgetBindState = params.slListWidgetBindState;
    this.slFingerprintBindState = params.slFingerprintBindState;
    this.notificationConf = params.notificationConf;
    this.lowPositionConf = params.lowPositionConf;
    this.fingerPrintConf = params.fingerPrintConf;
    this.clockStyle = params.clockStyle;
    this.wallpaperData = params.wallpaperData;
    this.slWallpaperState = params.slWallpaperState;
    this.spaceAniBlurOpt = params.spaceAniBlurOpt;
    this.themeClockParam = params.themeClockParam;
    this.animCtrlFactory = new OneMirrorAnimCtlFactory();
  }

  public setUIContext(uiContext: UIContext | null):void {
    this._uiContext = uiContext;
  }

  /**
   * 处理状态栏左边滑动事件
   */
  public onscreenLockMoveEvent(screenMoveEvent: TouchEvent): void {
    // 覆盖模式拦截状态栏滑动事件转发
    if (MpStateTypeUtils.isNormalShowState(this.slObserverProxy.getMpFsmState(this._persistentId)) &&
      !KeyguardStatusService.isOccluded()) {
      this._slideScreenLockViewModel?.handleTouchEvent(screenMoveEvent, SlideTouchType.TOUCH_UNLOCK);
      return;
    }
  }

  protected doInit(): void {
    log.showInfo('doInit');
    this._mainPageVm = new MainPageVm(this._persistentId);
    this.clockConfig.setConfig(ConfigType.OPEN_ART_SIGN, true);
    this.clockAdapter.setConfig(this.clockConfig);
    this.clockAdapter.init();
    this.registerStateTransferActionList();
    this._mainPageVm.init();
    if (IS_LARGE_FOLD) {
      ScreenLockFoldExpandAnimUtil.getInstance().registerClockAnimation();
    }
    MultiSceneThemeManager.init();
    MultiSceneThemeManager.setupUiThemeInfo(DataType.CLOCK_STYLE, this.clockStyle);
    this.slObserverProxy.getMpFsmState(this._persistentId, (oldState: MpStateType, newState: MpStateType): void => {
      log.showInfo(`fsm state: [${MpStateType[oldState]} -> ${MpStateType[newState]}]`);
      if (!this.triggerStateTransferAction(oldState, newState)) {
        this.doMpStateLayout(newState);
      }
      if (MpStateTypeUtils.isEditState(oldState) && MpStateTypeUtils.isUnlockState(newState)) {
        slWallpaperMgr.exitSlWallpaperScene(SLWallpaperType.TYPE_EDIT_STYLE, SLWallpaperVisibleScene.SCENE_SCREEN_EDIT);
        this.setMainPageParam(UNLOCK_SHOW);
      }
      this.handleFsmStateChangeInAccessibilityMode(oldState, newState);
      if (oldState === MpStateType.BOUNCER_STATE && newState === MpStateType.NORMAL_LOCK_STATE) {
        AccessibilityUtil.requestFocusAccessibility(SlWidgetId.LOCK_HEAD);
      }
    });

    this.initOneMirror();

    this.initSlideScreenLockViewModel();

    DisplayStateManager.getInstance().registerObserver(this.displayFoldStatusChangeListener, true, true);
    immersiveFgCtrl.registerImmersiveFingerListener(this._immersiveFingerStateListener);

    this.initFormAdapter();

    slClockOneShotToDesktopService.setSetTextColorOfDesktopClockForEffect((textColor: string) => {
      this.slClockBindCtrl.setTextColorOfDesktopClock(textColor);
    });

    slClockOneShotToDesktopService.setNoPwdUnlockExitKeyguard((authType?: osAccount.AuthType) => {
      log.info('slClockOneShotToDesktop NoPwdUnlockExitKeyguard');
      this.resetForClockOneshot(authType);
    });

    slClockOneShotToDesktopService.setExitScreenLock(() => {
      this._mainPageVm?.exitScreenLock();
    });

    slClockOneShotToDesktopService.setScreenUnlockAnim(() => {
      this.doClockOneShotAnimForUnlock();
    });

    slClockOneShotToDesktopService.setIsSupportMirrorToEnd((): boolean => {
      return false;
    });

    slClockOneShotToDesktopService.setIsSupportConsumerMirror((): boolean => {
      return OneMirrorService.getInstance().isSupportConsumerMirror();
    });

    this.initObserverVerifyTips();
    viewMgrPolicy.registerViewCallback(ViewType.KEYGUARD, this._keyguardViewCallback);

    this.slObserverProxy.observerScreenOnOff({
      onBeginSleep: () => {
        if (this.isAccessibilityMode()) {
          this.slBindState.setFocusDisabled(true);
        }
        sEventManager.publish(obtainLocalEvent(EventConstants.SCREEN_LOCK_BEGIN_SLEEP, null));
      },
      onEndDisplayOff: () => {
        if (this.isAccessibilityMode()) {
          this.slBindState.setFocusDisabled(false);
        }
      },
      onEndSleep: () => {
        if (this._temporaryPromptViewModel) {
          this._temporaryPromptViewModel.isShowTemporaryPrompt = false;
        }
      },
      onEndDisplayOn: () => {
        if (this.isAccessibilityMode()) {
          this.slBindState.setFocusDisabled(false);
        }
      },
      onBeginDisplayOn: () => {
        let isFaceSupportUnlock = VerifyDataManager.getInstance().getVerifyInfo(AuthType.FACE).isSupportUnlock;
        if (isFaceSupportUnlock && CameraStateManager.getInstance().isCameraMuted) {
          this._temporaryPromptViewModel?.showTemporaryPrompt(ResUtils.getInnerString($r('app.string.camera_muted')),
            TOAST_DELAY);
        }
      }
    });
    this.eventMgr.on(ScreenLockWallpaperChangeEvent,
      (event?: ScreenLockWallpaperChangeEvent) => { this.handleScreenLockWallpaperChangeEvent() });
    this.handleScreenLockWallpaperChangeEvent();
    slStateHelper.getSlBindState().setBottomViewMargin(this.getBottomToolsGadget())
    if (IS_ULTRA_SCREEN) {
      slUiStateMgr.registerSlStateChangeListener(this.updateToolsViewMarginForUltraScreen);
    }
    SpecialModeManager.getInstance().registerObserver(this._specialModeListener);
    immersiveKgMgr.registerStateChangeListener(StateType.TYPE_IMMERSIVE_KEYGUARD_TYPE, this.onStateChange);
    this.initHandlerForQuickTools();
    this.reportEditReportWeek();
    super.doInit();
  }

  private initHandlerForQuickTools(): void {
    GlobalStatusCache.getInstance().subscribe(QuickToolConstants.CACHE_KEY_TOOLS_STATE,
      (toolsState?: CacheValue) => {
        if (toolsState === QuickToolsState.OPEN) {
          KeyguardStatusService.openMode(KeyGuardMode.QUICK_TOOLS);
        } else {
          KeyguardStatusService.closeMode(KeyGuardMode.QUICK_TOOLS);
        }
      });
    GlobalStatusCache.getInstance().subscribe(QuickToolConstants.CACHE_KEY_IS_TOOLS_USING, (isToolsUsing?: CacheValue) => {
      if (typeof isToolsUsing !== 'boolean') {
        return;
      }
      this.slBindState.setIsToolsUsing(isToolsUsing);
      log.showInfo(`isToolsUsing changes ${isToolsUsing}`);
      if (isToolsUsing) {
        this.slBindState?.setBgBlurFreeze({
          isFreeze: true,
          scene: SlAnimScene.SCENE_TOOLS_USING
        });
      } else {
        this.slBindState?.setBgBlurFreeze({
          isFreeze: false,
          scene: SlAnimScene.SCENE_TOOLS_USING
        });
      }
    });
  }

  private handleFsmStateChangeInAccessibilityMode(oldState: MpStateType, newState: MpStateType): void {
    if (!this.isAccessibilityMode()) {
      return;
    }
    if (MpStateTypeUtils.isScreenOffState(oldState) && MpStateTypeUtils.isNormalShowState(newState)) {
      this.slBindState.setFocusDisabled(false);
    }
    if (MpStateTypeUtils.isUnlockState(oldState)) {
      this.slBindState.setFocusDisabled(true);
    }
  }

  private handleScreenLockWallpaperChangeEvent(): void {
    slStateHelper.getSlBindState().setisLightWallpaper(this.getClockNeedToDarken());
  }

  private doMpStateLayout(newState: MpStateType): void {
    // 密码页、编辑页面首页、编辑全屏页面都有动效在transfer中处理
    if (MpStateTypeUtils.isNormalShowState(newState)) {
      this.setMainPageParam(NORMAL_SHOW);
    }
  }

  private initOneMirror() {
    this._oneMirrorConfMap.set(OneMirrorLayoutType.NotificationConf, this.notificationConf);
    this._oneMirrorConfMap.set(OneMirrorLayoutType.LowPostionConf, this.lowPositionConf);
    this._oneMirrorConfMap.set(OneMirrorLayoutType.FingerPrintConf, this.fingerPrintConf);
    OneMirrorService.getInstance().registerObserver(this._oneMirrorListener);
  }

  private updateBatterySwitch(toScene: MirrorScene): void {
    if (toScene === MirrorScene.SCREEN_LOCK || toScene === MirrorScene.UNLOCK) {
      // 亮屏无需更新电量，灭屏状态电量不会更新
      return;
    }
  }

  private doOneMirrorScene(hasAnim: boolean, finishCallback?: FinishCallback): boolean {
    log.info('doOneMirrorScene from:' + MirrorScene[this.fromScene] + ' --> ' + MirrorScene[this.toScene] + ', hasAnim:' +
      hasAnim);
    // 解锁动效
    this.checkDoUnlockAnimation();
    this.checkDoLockAnimation();

    let oneMirrorAnimateCallback = new OneMirrorAnimateCallback(finishCallback);
    let coreState = this.slObserverProxy.getCoreFsmState(this._persistentId);
    // 亮屏到密码界面场景需要隔离
    if (this.needSkipOneMirror(coreState)) {
      log.info(`no one mirror, oldState:${MpStateType[this.currentState]} newState:${CoreStateType[coreState]}`);
      // 刷新数据，不执行动效
      this.doOneMirrorConf(false, oneMirrorAnimateCallback);
      return false;
    }
    this.updateBatterySwitch(this.toScene);
    // MirrorController reset处理
    let resetStage = OneMirrorSceneData.getResetMirrorsScene(this.fromScene, this.toScene);
    const controller: OneMirrorAnimController = this.animCtrlFactory.getMirrorController();
    if (resetStage && hasAnim) {
      controller.startOneMirrorAnim(resetStage, true);
    }

    // 一镜到底conf配置
    let ret = this.doOneMirrorConf(hasAnim, oneMirrorAnimateCallback);

    // MirrorController anim处理
    let animStage = OneMirrorSceneData.getAnimMirrorsScene(this.fromScene, this.toScene);
    if (animStage && !hasAnim) {
      log.showInfo('has no anim, refresh ui');
      controller.startOneMirrorWithoutAnim(animStage);
      return ret;
    }
    if (animStage) {
      controller.startOneMirrorAnim(animStage, false, oneMirrorAnimateCallback);
    }

    return ret;
  }

  /**
   * 是否跳过一镜到底动效
   *
   * @param coreState
   * @returns true, 跳过一镜到底动效
   */
  private needSkipOneMirror(coreState: CoreStateType): boolean {
    const needSlAnimStrategy: boolean = OneMirrorStrategyContext.getInstance().getStrategy()
      .needScreenLockAnim(this.toScene);
    log.showDebug(`needSlAnimStrategy:${needSlAnimStrategy}`);
    if (!needSlAnimStrategy) {
      // 一镜到底策略不需要播放锁屏动效
      return true;
    }
    return this.toScene !== MirrorScene.SCREEN_LOCK &&
      (CoreStateTypeUtils.isInBouncePage(coreState) || MpStateTypeUtils.isBouncerState(this.currentState));
  }

  private checkDoUnlockAnimation(): void {
    if (this.toScene !== MirrorScene.UNLOCK) {
      return;
    }
    log.info('checkDoUnlockAnimation start');
    if (slClockOneShotToDesktopService.doUnlockAnimationForClockOneshot()) {
      screenLockGreetModel.unLoadGreetViewWithoutAni(SlGreetModeReportScene.UNLOCK_FOR_CLOCK_ONE_SHOT);
      return;
    }
    this.animCtrlFactory.getMirrorController().startOneMirrorAnim(MirrorsScene.SCREEN_LOCK_TO_UNLOCK, true);
    this.doUnlockAnimationCommon();
    log.info('checkDoUnlockAnimation end');
  }

  // 解锁动效结束，隐藏锁屏
  private onFinishExitLockWithAnim(): void {
    slClockOneShotToDesktopService.finishRequestDirectUnlock();
    log.info('onFinishExitLockWithAnim');
  }

  private doOneMirrorConf(hasAnim: boolean, oneMirrorAnimateCallback: OneMirrorAnimateCallback): boolean {
    let oneMirrorScenePara = OneMirrorSceneParaData.getOneMirrorScene(this.fromScene, this.toScene);
    if (!oneMirrorScenePara) {
      log.warn('no mirror ' + MirrorScene[this.fromScene] + '-->' + MirrorScene[this.toScene]);
      return false;
    }

    let fromLayoutPara = oneMirrorScenePara.fromLayout;
    if (fromLayoutPara) {
      fromLayoutPara.forEach(item => {
        this.setOneMirrorLayoutParam(item);
      });
    }

    let toAnimPara = oneMirrorScenePara.toLayoutAnimPara;
    log.info('doOneMirrorScene toAnimPara:' + toAnimPara);
    if (toAnimPara) {
      toAnimPara.forEach(animation => {
        if (animation.needAnimation && hasAnim) {
          this.doOneMirrorAnimation(animation, oneMirrorAnimateCallback);
          log.info('doOneMirrorScene toScene animation');
        } else {
          this.setOneMirrorLayoutParam(animation.layoutPara);
          log.info('doOneMirrorScene toScene no animation');
        }
      });
    }

    // immersive conf设置
    this._immersiveOneMirror?.doImmersiveOneMirror(this.fromScene, this.toScene, hasAnim, oneMirrorAnimateCallback);

    return oneMirrorAnimateCallback.isWaiting;
  }

  private setOneMirrorLayoutParam(layoutPara?: OneMirrorLayoutPara, reason: string = 'static'): boolean {
    if (!layoutPara || layoutPara.type === undefined) {
      log.warn('setOneMirrorLayoutParam null para');
      return false;
    }

    let conf = this._oneMirrorConfMap.get(layoutPara.type);
    if (!conf) {
      log.warn('no mirror conf:' + layoutPara.type);
      return false;
    }

    conf.setScale(layoutPara.scale ?? 1);
    conf.setAlpha(layoutPara.alpha ?? 1);
    conf.setBlur(layoutPara.blur ?? 0);
    log.info('setOneMirrorLayoutParam type:' + OneMirrorLayoutType[layoutPara.type] + ', scale:' + layoutPara.scale +
      ', alpha:' + layoutPara.alpha + ', blur:' + layoutPara.blur + ', reason:' + reason);
    return true;
  }

  private doOneMirrorAnimation(animationPara: OneMirrorAnimationPara,
    oneMirrorAnimateCallback: OneMirrorAnimateCallback): boolean {
    if (!animationPara) {
      log.warn('doOneMirrorAnimation null para');
      return false;
    }

    animateTo({
      duration: 400,
      delay: animationPara.delay,
      finishCallbackType: FinishCallbackType.LOGICALLY,
      onFinish: () => {
        oneMirrorAnimateCallback?.finish();
      },
      curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1)
    }, () => {
      oneMirrorAnimateCallback?.animateStart();
      this.setOneMirrorLayoutParam(animationPara.layoutPara, 'animation');
    });

    return true;
  }

  private initSlideScreenLockViewModel(): void {
    this._slideScreenLockViewModel = new SlideScreenLockVm(this._persistentId);
    this._mainPageVm?.setSlideScreenLockViewModel(this._slideScreenLockViewModel);
    this._slideScreenLockViewModel.viewModelInit(
      () => {
        this.resetAnimation();
      },
      (scale: number, offset: number, blur: number, opacity: number, wallpaperScale: number,
        slidingDistance?: number, isOnOneShotAnim?: boolean, spaceAniProgress?: number) => {
        this.slideAnimation(scale, offset, blur, opacity, wallpaperScale, slidingDistance, isOnOneShotAnim,
          spaceAniProgress);
      },
      (keyboardPosition?: number) => {
        this.slideToPwdInput(keyboardPosition);
      });
  }

  private readonly slObserverProxy: SlObserverProxy = new SlObserverProxy();

  private initObserverVerifyTips(): void {
    this.slObserverProxy.observerVerifyTips({
      onVerifyingTips: (authType: AuthType, acquire: number): void => {
        log.showInfo(`onVerifyingTips authType ${authType}, acquire:${acquire}`);
        switch (authType) {
          case AuthType.FINGERPRINT:
            if (acquire === FingerprintAcquireCode.FINGERPRINT_TIP_TOO_FAST) {
              this._temporaryPromptViewModel?.showTemporaryPrompt(
                ResUtils.getInnerString($r('app.string.fp_hold_finger')));
            }
            if (acquire === FingerprintAcquireCode.FINGERPRINT_ANTITOUCH_NOTIFICATION_CAMERA) {
              this._temporaryPromptViewModel?.showTemporaryPrompt(
                ResUtils.getInnerString($r('app.string.fingerprint_antitouch_notification_camera')), TOAST_DELAY, true,
                HidePromptCode.FINGERPRINT_ANTI_TOUCH_CAMERA);
            }
            break;
          default:
            break;
        }
      },
      onVerifyResultTips: (authType: AuthType, verifyResultInfo: VerifyResultInfo): void => {
        log.showInfo(`onVerifyResultTips authType ${authType}, verifyResultInfo:${verifyResultInfo.toString()}`);
        switch (authType) {
          case AuthType.FINGERPRINT:
            VerifyTipsUtils.getFingerprintPromptFromVerifyResult(verifyResultInfo).then(
              (propStr: string) => {
                this._temporaryPromptViewModel?.showTemporaryPrompt(propStr, verifyResultInfo.freezingTime, false);
                this._temporaryPromptViewModel?.countdown(
                  verifyResultInfo.remainTimes,
                  verifyResultInfo.freezingTime,
                  verifyResultInfo.isPwdFreezing,
                  true,
                  (remainTimes: number, freezingTime: number, isPsdFreezing: boolean): Promise<string> => {
                    return VerifyTipsUtils.getFingerprintPrompt(remainTimes, freezingTime, isPsdFreezing);
                  });
                if (verifyResultInfo.remainTimes <= 0 && verifyResultInfo.freezingTime > 0 &&
                  !this.lockManifestParam.quickToolsVisible && this._mainPageVm?.isNormalLockState()) {
                  VerifyTipsUtils.getDisableEnterPsdPrompt(propStr, (promptText: string) => {
                    this.showfpDisableEnterPsd(promptText);
                  });
                }
              });
            break;
          default:
            break;
        }
      }
    });
  }

  private showfpDisableEnterPsd(message: string): void {
    try {
      let topMargin: number = Constants.SCREENLOCK_LOCK_ICON_MARGIN_TOP;
      if (DeviceHelper.isPhone()) {
        topMargin =
        Constants.SCREENLOCK_LOCK_ICON_MARGIN_TOP;
      } else {
        topMargin = Constants.SCREENLOCK_LOCK_ICON_MARGIN_TOP_PAD;
      }
      this._uiContext?.getPromptAction()?.showToast({
        message: message,
        duration: Constants.SCREENLOCK_LOCK_DISABLE_TOAST_SHOW,
        showMode: promptAction.ToastShowMode.SYSTEM_TOP_MOST,
        bottom: Constants.SCREENLOCK_LOCK_DISABLE_TOAST_BOTTOM_MARGIN
      });
    } catch (error) {
      log.showError(`showfpDisableEnterPsd error, code: ${error.code}`);
    }
  }

  private resetAnimation(): void {
    log.showDebug('resetAnimation start');
    animateTo({
      curve: curves.interpolatingSpring(0, Constants.PSD_MASS,
        Constants.PSD_STIFFNESS, Constants.PSD_DAMPING),
      onFinish: () => {
        this.slBindState.setNeedUseEffect(false);
      }
    }, () => {
      this.setMainPageParam(NORMAL_SHOW);
      this.spaceAniBlurOpt.setBlurRatio(0);
    })
  }

  private blurCurves: curves.ICurve = curves.cubicBezierCurve(0.4, 0.0, 0.55, 1.0);
  private slideAniCount: number = 0;

  private slideAnimation(scale: number, offset: number, blur: number, opacity: number, wallpaperScale: number,
    slidingDistance?: number, isOnOneShotAnim?: boolean, spaceAniProgress?: number): void {
    if (this.slideAniCount > 0) {
      this._slideScreenLockViewModel?.setSlidState(true);
    }
    this.slideAniCount++;
    animateTo({
      curve: curves.interpolatingSpring(0, Constants.PSD_MASS, Constants.PSD_STIFFNESS, Constants.PSD_DAMPING),
      onFinish: () => {
        this.slideAniCount--;
        if (this.slideAniCount <= 0) {
          this._slideScreenLockViewModel?.setSlidState(false);
        }
      }
    }, () => {
      if (isOnOneShotAnim) {
        slClockOneShotToDesktopService.notifyUpdateClockWidgetParamsOnMove(slidingDistance ? slidingDistance : 0);
        this.setClockOpacity(0);
      } else {
        this.setClockOpacity(opacity);
      }
      if (spaceAniProgress) {
        this._spaceAnimationViewModel?.setSlideAnimation(1 - spaceAniProgress, spaceAniProgress);
        if (!slClockOneShotToDesktopService.isClockOneShotAnimAvailable() && !DeviceHelper.isFold() &&
          spaceAniProgress > FOREGROUND_BLUR_PROGRESS) {
          this.spaceAniBlurOpt.setBlurRatio(spaceAniProgress * 2 > 1 ? 1 : Math.max(spaceAniProgress * 2, 0.5));
          this.slBindState.setNeedUseEffect(true);
        } else {
          this.spaceAniBlurOpt.setBlurRatio(0);
        }
      }
      if (this.slBindState.getIsStaticTheme()) {
        this.wallpaperData.wallpaperScale = wallpaperScale;
      }
      this.slWallpaperState.wallpaperScale = wallpaperScale;
      this.slBindState.setOpacity(opacity);
      this.slBindState.setZoomRatio(scale);
      this.slBindState.setSlideScale(scale);
      AppStorage.setOrCreate('blurRadius', this.blurCurves.interpolate(blur * 0.01));
    });
  }

  /**
   * 是否处于跟手滑动动效中
   *
   * @returns 是否处于跟手滑动动效中
   */
  public isSlideAnimating(): boolean {
    if (this._slideScreenLockViewModel) {
      return this._slideScreenLockViewModel.isSlideAnimating();
    }
    return false;
  }

  private slideToPwdInput(keyboardPosition: number = Constants.NO_TOUCH_OR_SCREEN_MIDDLE,
    isClockLongPress: boolean = false): void {
    log.showInfo('slideToPwdAnimation start');
    AppStorage.setOrCreate(SlStorageKey.KEYBOARD_POSITION, keyboardPosition);
    this._mainPageVm?.enterBouncerView();
  }

  private doBlurAnimation(): void {
    log.showInfo('doBlurAnimation');
    if (slClockOneShotToDesktopService.isClockOneShotAnimAvailable() || !CCMParamUtil.isForegroundEffectSupport()) {
      return;
    }
    let duration = (1 - this.spaceAniBlurOpt.getBlurRatio()) * BLUR_ANIMATION_DURATION_MAX;
    if (duration < ANIMATION_DURATION_THRESHOLD) { // 时长小于一帧的动画无需下发
      this.spaceAniBlurOpt.setBlurRatio(0);
      return;
    }
    this.disableClockShadow = true;
    animateToImmediately({
      duration: duration,
      onFinish: () => {
        log.showInfo('doBlurAnimation finish');
        this.spaceAniBlurOpt.setBlurRatio(0);
        this.slClockBindCtrl.setRemoveBrightness(false);
        this.disableClockShadow = false;
        this.setDisableClockShadowWidthAnim();
        this.slBindState.setNeedUseEffect(false);
      }
    }, () => {
      this.spaceAniBlurOpt.setBlurRatio(1);
      this.slClockBindCtrl.setRemoveBrightness(true);
      this.slBindState.setDisableClockShadow(this.disableClockShadow);
      this.slBindState.setNeedUseEffect(true);
    })
  }

  private checkDoLockAnimation(): void {
    if (!(this.fromScene === MirrorScene.UNLOCK && this.toScene === MirrorScene.SCREEN_LOCK)) {
      return;
    }
    log.showInfo('checkDoLockAnimation start');
    this.handleBeforeLockAnim();
    animateTo({
      curve: I_CURVE,
      delay: 0,
      duration: 400,
      onFinish: () => {
        log.showInfo('checkDoLockAnimation end');
      }
    }, () => {
      this.callbackForLockAnim();
    });
  }

  private handleBeforeLockAnim(): void {
    this.slBindState.setZoomRatio(Constants.DEFAULT_SLIDE_RATIO);
    this.slBindState.setSlideScale(Constants.MAX_ZOOM_RATIO);
    this.wallpaperData.wallpaperScale = Constants.MIN_SCENE_SCALE;
    this.slBindState.setOpacity(Constants.MAX_VIEW_OPACITY);
    this.setClockOpacity(Constants.MAX_VIEW_OPACITY);
  }

  private callbackForLockAnim(): void {
    this.slBindState.setSlideScale(Constants.DEFAULT_ZOOM_RATIO);
    this.slBindState.setOpacity(Constants.DEFAULT_HOME_VIEW_OPACITY);
    this.setClockOpacity(Constants.DEFAULT_HOME_VIEW_OPACITY);
    this._spaceAnimationViewModel?.setUnlockAnimation(1, 1);
  }

  // 非时钟一镜到底动效
  private doUnlockAnimationCommon(authType?: osAccount.AuthType): void {
    const isSkipAnim = !this._spaceAnimationViewModel?.isUnlockToHome();
    log.showInfo('doUnlockAnimationCommon start: ' +isSkipAnim);
    if (isSkipAnim) {
      this.slBindState.setZoomRatio(Constants.DEFAULT_ZOOM_RATIO + Constants.DIFF_RATIO);
      this.slBindState.setOpacity(Constants.MAX_VIEW_OPACITY - 1);
      this.setClockOpacity(Constants.MAX_VIEW_OPACITY - 1);
    }
    this.handleBeforeUnlockAnim(false, authType);
    // 锁屏元素一镜到底动效；与时钟一镜到底区别：1）无需设置时钟opacity；2）锁屏动效结束不触发finish，等待时钟动效完成再触发
    animateTo({
      curve: I_CURVE,
      delay: 0,
      duration: Constants.UNLOCK_ANIMATION_DURATION,
      onFinish: () => {
        this.onFinishForUnlockAnim(false, authType, false);
      }
    }, () => {
      this.callbackForUnlockAnim(false);
    });
    this.doBlurAnimation();

    AppStorage.setOrCreate('isSpaceOrMenuKeyEvent', false);
    log.showInfo('doUnlockAnimationCommon end');
  }

  private handleBeforeUnlockAnim(isOneShot: boolean, authType?: osAccount.AuthType): void {
    AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.UNLOCK_START);
    PerformanceMonitorUtil.setFrameRateMoStart(authType, false);
    this._spaceAnimationViewModel?.doItemNoPwdUnlockAnimation(false, !authType);
    let animationScale = 1;
    if (!isOneShot) {
      animationScale = Math.max(Number.parseInt(parameter.getSync('persist.sys.graphic.animationscale', '1')), 1);
    }
    // 设置-系统-过渡动画缩放，1表示正常速度，2代表放慢2倍
    HiKGReportTimeout.getInstance().logTimeout(
      isOneShot ? TIMEOUT_PARAMS.UNLOCK_ONE_SHOT_ANI.NAME : TIMEOUT_PARAMS.UNLOCK_FROM_MAIN_ANI.NAME,
      isOneShot ? TIMEOUT_PARAMS.UNLOCK_ONE_SHOT_ANI.TIME_OUT : TIMEOUT_PARAMS.UNLOCK_FROM_MAIN_ANI.TIME_OUT * animationScale);
    TraceUtil.startAnimTrace(DomainName.KG, TraceUtil.UNLOCK_TO_HOME_ANI, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
    Trace.start(Trace.CORE_METHOD_EXIT_KEYGUARD);

    this.slBindState.setBgBlurFreeze(
      { isFreeze: true, scene: SlAnimScene.SCENE_NOT_PWD_UNLOCK });
  }

  private onFinishForUnlockAnim(isOneShot: boolean, authType?: osAccount.AuthType, isSkipAnim: boolean = false): void {
    this.onFinishForUnlockAnimReport(isOneShot, authType);
    if (!isSkipAnim) {
      this.slBindState.setZoomRatio(Constants.DEFAULT_ZOOM_RATIO);
    }
    this.slBindState.setSlideScale(Constants.DEFAULT_SLIDE_RATIO);
    this.wallpaperData.wallpaperScale = Constants.MIN_SCENE_SCALE;
    screenLockGreetModel.unLoadGreetViewWithoutAni(SlGreetModeReportScene.UNLOCK_COMMON);
    this.onFinishExitLockWithAnim();
  }

  private onFinishForUnlockAnimReport(isOneShot: boolean, authType: osAccount.AuthType | undefined) {
    PerformanceMonitorUtil.setFrameRateMoEnd(authType, false);
    HiKGReportTimeout.getInstance().rollbackTimeout(
      isOneShot ? TIMEOUT_PARAMS.UNLOCK_ONE_SHOT_ANI.NAME : TIMEOUT_PARAMS.UNLOCK_FROM_MAIN_ANI.NAME);
    Trace.end(Trace.CORE_METHOD_EXIT_KEYGUARD);
    // reset
    this.slBindState?.setBgBlurFreeze({ isFreeze: false, scene: SlAnimScene.SCENE_NOT_PWD_UNLOCK });
  }

  // 锁屏到桌面解锁，一镜到底时不设置时钟opacity
  private callbackForUnlockAnim(isOnOneShot?: boolean) {
    this.slBindState.setZoomRatio(Constants.MAX_ZOOM_RATIO + Constants.DIFF_RATIO);
    this.wallpaperData.wallpaperScale = Constants.MIN_SCENE_SCALE + Constants.DIFF_RATIO;
    // 方便后续打断动画，此时动效目标值改为 150 - 1
    this.slBindState.setOpacity(Constants.MAX_VIEW_OPACITY - 1);
    if (!isOnOneShot) {
      this.slBindState.setSlideScale(Constants.MAX_SCALE_WHEN_PWD_CHECKED);
      this.setClockOpacity(Constants.MAX_VIEW_OPACITY - 1);
    } else {
      this.slBindState.setSlideScale(Constants.DEFAULT_SLIDE_RATIO);
      slWallpaperMgr.exitSlWallpaperScene(SLWallpaperType.TYPE_IMMERSIVE_STYLE,
        SLWallpaperVisibleScene.SCENE_IMMERSIVE_CARD);
    }
  }

  private doClockOneShotAnimForUnlock(authType?: osAccount.AuthType): void {
    log.showInfo('doClockOneShotAnimForUnlock start');
    slClockOneShotToDesktopService.updateKeyguardExitingState(true);
    slClockOneShotToDesktopService.updateAuthType(authType);
    this.handleBeforeUnlockAnim(true, authType);
    // 锁屏元素一镜到底动效；与普通解锁动效区别：1）无需设置时钟opacity；2）锁屏动效结束不触发finish，等待时钟动效完成再触发
    animateTo({
      curve: I_CURVE,
      delay: 0,
      duration: Constants.UNLOCK_ANIMATION_DURATION,
    }, () => {
      this.callbackForUnlockAnim(true);
    });
    this.disableClockShadow = true;
    animateTo({
      duration: Constants.REMOVE_BRIGHTNESS_ANIMATION_DURATION,
      onFinish: () => {
        this.slClockBindCtrl.setClearTextBlurEffect(true);
        this.updateClockTextBlurEnabled();
      }
    }, () => {
      this.slBindState.setDisableClockShadow(this.disableClockShadow);
      this.slClockBindCtrl.setRemoveBrightness(true);
    })

    AppStorage.setOrCreate('isSpaceOrMenuKeyEvent', false);
    log.showInfo('doClockOneShotAnimForUnlock end');
  }

  private setDisableClockShadowWidthAnim(): void {
      animateTo({ duration: 0 }, () => {
        this.slBindState.setDisableClockShadow(this.disableClockShadow);
      });
  }

  private resetForClockOneshot(authType?: osAccount.AuthType): void {
    if (this.currentState !== MpStateType.UNLOCK_STATE) {
      this.onFinishForUnlockAnimReport(true, authType);
      log.showInfo('resetForClockOneshot, but is not unlock state');
      return;
    }
    slClockOneShotToDesktopService.updateKeyguardExitingState(false);
    this.onFinishForUnlockAnim(true, authType);
    this.slBindState.setOpacity(Constants.MAX_VIEW_OPACITY);

    // reset for oneshot
    this.slClockBindCtrl.setRemoveBrightness(false);
    this.disableClockShadow = false;
    this.setDisableClockShadowWidthAnim();
  }

  private registerStateTransferActionList(): void {
    // to 锁屏显示
    this.registerStateTransferAction(this.stateChangeBouncerToMpShow);
    this.registerStateTransferAction(this.stateChangeEditNormalToMpShow);
    this.registerStateTransferAction(this.stateChangeEditFullToMpShow);
    this.registerStateTransferAction(this.stateChangeEditExtendToMpShow);
    this.registerStateTransferAction(this.stateChangeToScreenOff);
    this.registerStateTransferAction(this._wakeUpStateTransferAction);
    // 编辑首页进入
    this.registerStateTransferAction(this.stateChangeToEditShow);
    // 编辑全屏返回编辑首页
    this.registerStateTransferAction(this.stateChangeEditFulToEditShow);
    // 编辑全屏进入
    this.registerStateTransferAction(this.stateChangeToEditFull);
    // 密码页进入
    this.registerStateTransferAction(this.stateChangeToBouncer);
    ScreenLockFsmProxy.getInstance(this._persistentId).registerCoreEventCallback(this._fsmEventCallback);
  }

  private displayFoldStatusChangeListener: DisplayStateListener = {
    onFoldStateChange: (isFoldExpand: boolean): void => {
      clockLayoutHelper.setScreenSessionRotatable(DisplayStateManager.getInstance().getScreenSessionRotatable());
      OneMirrorStrategyContext.getInstance().getStrategy().onFold(!isFoldExpand,
        ThemeServiceHelper.getInstance().getScbState() === ScbState.UNKNOWN, false);
    }
  }

  protected doRelease(): void {
    super.doRelease();
    log.showInfo('doRelease');
    immersiveKgMgr.unregisterStateChangeListener(StateType.TYPE_IMMERSIVE_KEYGUARD_TYPE, this.onStateChange);
    OneMirrorService.getInstance().unRegisterObserver(this._oneMirrorListener);
    this._oneMirrorConfMap.clear();
    viewMgrPolicy.unRegisterViewCallback(ViewType.KEYGUARD, this._keyguardViewCallback);
    slClockOneShotToDesktopService.setSetTextColorOfDesktopClockForEffect(undefined);
    DisplayStateManager.getInstance().unRegisterObserver(this.displayFoldStatusChangeListener);
    immersiveFgCtrl.unregisterImmersiveFingerListener(this._immersiveFingerStateListener);
    this._slideScreenLockViewModel?.viewModelDestroy();
    MultiSceneThemeManager.destroy();
    this._mainPageVm?.release();
    this.unRegisterStateTransferActionList();
    this.eventMgr.offAll()
    this.destroyFormAdapter();
    if (IS_ULTRA_SCREEN) {
      slUiStateMgr.unregisterSlStateChangeListener(this.updateToolsViewMarginForUltraScreen);
    }
    if (IS_LARGE_FOLD) {
      ScreenLockFoldExpandAnimUtil.getInstance().unRegisterClockAnimation();
    }
    SpecialModeManager.getInstance().unRegisterObserver(this._specialModeListener);
    this.clockAdapter.release();
    GlobalStatusCache.getInstance().unsubscribeByType(QuickToolConstants.CACHE_KEY_TOOLS_STATE);
    GlobalStatusCache.getInstance().unsubscribeByType(QuickToolConstants.CACHE_KEY_IS_TOOLS_USING);
  }

  private initFormAdapter(): void {
    this._formViewModel?.formAdapter?.init();
  }

  private destroyFormAdapter(): void {
    this._formViewModel?.formAdapter?.release();
  }

  private unRegisterStateTransferActionList(): void {
    this.unRegisterStateTransferAction(this.stateChangeBouncerToMpShow);
    this.unRegisterStateTransferAction(this.stateChangeEditNormalToMpShow);
    this.unRegisterStateTransferAction(this.stateChangeEditFullToMpShow);
    this.unRegisterStateTransferAction(this.stateChangeEditExtendToMpShow);
    this.unRegisterStateTransferAction(this.stateChangeToScreenOff);

    this.unRegisterStateTransferAction(this._wakeUpStateTransferAction);
    this.unRegisterStateTransferAction(this.stateChangeToEditShow);
    this.unRegisterStateTransferAction(this.stateChangeEditFulToEditShow);
    this.unRegisterStateTransferAction(this.stateChangeToEditFull);
    this.unRegisterStateTransferAction(this.stateChangeToBouncer);
    ScreenLockFsmProxy.getInstance(this._persistentId).unregisterCoreEventCallback(this._fsmEventCallback);
  }

  /**
   * 获取布局的viewModel处理事件交互
   *
   * @returns 基础页面view model
   */
  public getViewModel(): MainPageVm | undefined {
    return this._mainPageVm;
  }

  /**
   * 获取界面文字提示view model
   *
   * @returns 文字提示view model
   */
  public getPromptViewModel(): TemporaryPromptViewModel | undefined {
    return this._temporaryPromptViewModel;
  }

  /**
   * 设置文字提示ViewModel
   *
   * @param temporaryPromptViewModel 文字提示ViewModel
   */
  public setTemporaryPromptViewModel(temporaryPromptViewModel: TemporaryPromptViewModel) {
    this._temporaryPromptViewModel = temporaryPromptViewModel;
  }

  /**
   * 设置空间感动效vm
   *
   * @param spaceAnimationViewModel 空间感动画ViewModel
   */
  public setSpaceAnimationViewModel(spaceAnimationViewModel: ScreenLockSpaceAnimationViewModel) {
    this._spaceAnimationViewModel = spaceAnimationViewModel;
  }

  /**
   * 设置卡片ViewModel
   *
   * @param formViewModel 卡片ViewModel
   */
  public setFormViewModel(formViewModel: ScreenLockFormViewModel) {
    this._formViewModel = formViewModel;
    this._mainPageVm?.setFormViewModel(formViewModel);
    MultiSceneThemeManager.setFormViewModel(formViewModel);
    this.registerFromMainPageEvent();
  }

  private registerFromMainPageEvent(): void {
    this._formViewModel?.formAdapter?.getInvoker().registerObserver(this.formMainPageEventListener);
  }

  private formMainPageEventListener: ICommand = {
    execute: (event: IEvent): void => {
      if (event.getEventType() === FormOutputEventType.ENTER_EDIT_CARD_EVENT) {
        ScreenLockFsmProxy.getInstance(this._persistentId)
          .submitMainPageEvent(MpEventType.ENTER_EDIT_CARD);
      } else {
        log.showWarn(`formMainPageEventListener fail, type:${event.getEventType()}, scene:${event.getScene()}`);
      }
    }
  }

/**
   * 设置外屏卡片ViewModel
   *
   * @param outerFormViewModel 外屏卡片ViewModel
   */
  public setOuterFormViewModel(outerFormViewModel: OuterScreenLockFormViewModel) {
    this._outerFormViewModel = outerFormViewModel;
  }

  /**
   * 更新锁屏主题参数
   *
   * @param lockManifestParam 主题参数
   * @param themeClockParam 时钟参数
   */
  public updateScreenLockThemeParam(lockManifestParam: LockManifest, themeClockParam?: IThemeParam): void {
    this.lockManifestParam = lockManifestParam;
    this.themeClockParam = themeClockParam;
  }

  public getScreenLockPanelPositionX(dealRtl: boolean = true): number {
    let positionX: number = this.clockStyle.x;
    if (this.clockStyle.layout === ClockLayout.DIMENSION_4_4) {
      positionX = this.clockStyle.x + 1;
    }
    let deviceWidthGrid: number = clockLayoutHelper.getLayoutAmount(this.isPortrait(), this.isFoldExpanded()).x;
    let clockWidthAmount: number = clockLayoutHelper.isN4Layout(this.clockStyle.layout) ?
      N4_CLOCK_LAYOUT_WIDTH_AMOUNT : DEFAULT_CLOCK_LAYOUT_WIDTH_AMOUNT;
    if (dealRtl && RTLUtil.isRTL()) {
      return this.correctPos(deviceWidthGrid - clockWidthAmount - positionX, deviceWidthGrid, clockWidthAmount);
    }
    return this.correctPos(positionX, deviceWidthGrid, clockWidthAmount);
  }

  /**
   * 修正时钟坐标，避免偏出屏幕外
   *
   * @param pos 原始位置
   * @param domain 可用区域长度范围
   * @param length 组件占据长度范围
   * @returns  修正后的坐标
   */
  private correctPos(pos: number, domain: number, length: number): number {
    if (domain < 0 || length < 0 || domain < length) {
      log.showError(`correctPos err pos:${pos},widthGridAmount:${domain}, clockWidthAmount:${length}`);
      return Math.max(0, pos);
    }
    if (pos < 0) {
      return 0;
    }
    if(pos + length > domain) {
      return Math.max(domain - length, 0);
    }
    return pos;
  }

  public getScreenLockPanelPositionY(gridWidth?: number): number {
    let finalMoveDistance = this.slClockLocateState.getMoveDistance();
    let positionY: number = this.clockStyle.y;
    positionY -= finalMoveDistance;
    // 区分数字时钟与艺术签名时钟
    if (this.clockStyle.layout < 200) {
      positionY = this.fixedMultiScenePositionY(positionY);
    }
    log.showInfo(`positionY: ${positionY}, LayoutGridWidth ${clockLayoutHelper.getLayoutGridWidth(this.isPortrait())}`
      + `finalMoveDistance = ${finalMoveDistance}`);
    // 间距保护，防止顶部偏移溢出
    let deviceHeightGrid: number = clockLayoutHelper.getLayoutAmount(this.isPortrait(), this.isFoldExpanded()).y ?? 0;
    let gridHeightAmount: number = clockLayoutParam.gridParam.gridHeightAmount;
    positionY = this.correctPos(positionY, deviceHeightGrid, gridHeightAmount);
    return gridWidth? positionY * gridWidth : positionY * clockLayoutHelper.getLayoutGridWidth(this.isPortrait());
  }

  public getAestheticColorArgs(): AestheticColorArgs {
    let args = this.clockStyle.aestheticColorArgs ?? new AestheticColorArgs();
    return args;
  }

  private fixedMultiScenePositionY(positionY: number): number {
    // 异壁纸场景,有卡片时需确保两屏卡片都有足够的显示区域
    if (MultiSceneThemeManager.isSupportMultiSceneTheme()) {
      let clockHeight: number = clockLayoutParam.gridParam.gridHeightAmount;
      let grid = clockWidgetConfigManager.getExpandClockGridType(this.clockStyle.layout);
      clockHeight = grid?.gridHeightAmount ?? clockHeight;
      let formPanelHeight = this._formViewModel ? this._formViewModel.getCurrentPanelHeight() : 0;
      positionY = Math.min(clockLayoutHelper.getLayoutGridAmount(this.isPortrait()).y -
        formPanelHeight - clockHeight, positionY);
    }
    return positionY;
  }

  /**
   * 获取底部工具栏左右边距
   *
   * @returns 左右边距资源对象
   */
  public getBottomToolsGadget(): number {
    if (IS_ULTRA_SCREEN) {
      return this.getBottomToolsGadgetForUltraScreen();
    }
    if (IS_PAD) {
      return Constants.SCREEN_LOCK_GADGET_MARGIN_PAD;
    } else if (this.isFoldExpanded() && !IS_SMALL_FOLD) {
      return Constants.SCREEN_LOCK_GADGET_MARGIN_EXPAND;
    }
    return Constants.SCREEN_LOCK_GADGET_MARGIN;
  }

  /**
   * 获取超大屏产品底部工具栏左右边距
   *
   * @returns 左右边距资源对象
   */
  private getBottomToolsGadgetForUltraScreen(): number {
    let screenBp = slStateHelper.getSlStaticState()?.getSlState(SlStaticStateType.SCREEN_BP) as ScreenBp;
    if (UltraScreenStatus.G_STATUS === this.getUltraScreenStatus(screenBp)) {
      return Constants.SCREEN_LOCK_GADGET_MARGIN_PAD;
    } else if (UltraScreenStatus.M_STATUS === this.getUltraScreenStatus(screenBp)) {
      return Constants.SCREEN_LOCK_GADGET_MARGIN_EXPAND;
    }
    return Constants.SCREEN_LOCK_GADGET_MARGIN;
  }

  /**
   * 检查当前时钟是否需要压暗
   *
   * @returns
   */
  public getClockNeedToDarken(): boolean {
    let brightness = this.slClockStaticCtrl.getBrightness();
    if (this.slBindState.getImmersiveWallPaperUsing() || brightness < 0) {
      return this.slWallpaperState.isLightWallpaper ?? false;
    }
    return brightness < CommonConstants.BRIGHT_NESS_DEFAULT;
  }

  public onOrientationChange(orientation: number): void {
    super.onOrientationChange(orientation);
    this._mainPageVm?.initScreenLockMeshConfig(this.isPortrait());
  }

  public onScreenSizeChange(width: number, height: number): void {
    super.onScreenSizeChange(width, height);
    let gridWidth = clockLayoutHelper.getLayoutGridWidth(this.isPortrait());
    this.slBindState.setGridWidth(gridWidth);
    if (IS_FOLD_BUT_NOT_SMALL_FOLD) {
      this._mainPageVm?.initScreenLockMeshConfig(this.isPortrait());
    }
    // 窗口大小切换时，隐藏弹框
    if (SlStateBaseMgr.isV2Enable()) {
      v2Helper.getV2Hook()?.requestHideSettingDialog();
    } else {
      screenLockBlurButtonVM.unblur(false, true);
    }
  }

  public onFoldStateChange(isFoldExpand: boolean): void {
    if (isFoldExpand) {
      this._temporaryPromptViewModel?.hideTemporaryPrompt(HidePromptCode.FINGERPRINT_ANTI_TOUCH_CAMERA);
    }
    if (IS_ULTRA_SCREEN) {
      return;
    }
    this.slBindState.setBottomViewMargin(this.getBottomToolsGadget());
  }

  protected onScreenLockThemeChange(themeParam?: LockscreenThemeConfig, isDisplayChange?: boolean): void {
    super.onScreenLockThemeChange(themeParam);
    this.lockManifestParam = ThemeHelperUtil.getLockManifest();
    log.showInfo(`lockManifestParam, clockVisible: ${this.lockManifestParam.clockVisible},
      quickToolsVisible: ${this.lockManifestParam.quickToolsVisible},
      formVisible: ${this.lockManifestParam.formVisible},
      wallpaperTouchable: ${this.lockManifestParam.wallpaperTouchable},
      wallpaperTouchableStrategy: ${this.lockManifestParam.wallpaperTouchableStrategy},
      desktopWallpaper type is  ${this.lockManifestParam.type},
      clock layout is  ${themeParam?.clock?.layout}`);
    this.slBindState.setIsStaticTheme(ThemeHelperUtil.isStaticTheme());
    log.showInfo(`registerThemeActiveEvent isStaticTheme is ${this.slBindState.getIsStaticTheme()}`);
    if (themeParam && themeParam.clock) {
      this.clockStyle.layout = themeParam.clock.layout;
      this.clockStyle.x = themeParam.clock.positionX;
      this.clockStyle.y = themeParam.clock.positionY;
    }
    NotificationStateManager.notificationState.isBottomAlign = !this.lockManifestParam.clockVisible;
    NotificationStateManager.notificationState.isClockVisible = this.lockManifestParam.clockVisible;
    if (this.lockManifestParam.wallpaperTouchableStrategy === -1) {
      this._mainPageVm?.updateWallpaperTouchable(this.lockManifestParam.wallpaperTouchable);
    } else {
      this._mainPageVm?.updateWallpaperTouchable(this.lockManifestParam.wallpaperTouchableStrategy !=
        WallpaperStratege.DISABLE_TOUCHABLE);
    }
    this._mainPageVm?.updateInterWallpaperUnlockable(this.lockManifestParam.wallpaperTouchableStrategy);
    this.updateFormConfig(themeParam, isDisplayChange);
    this.updateOuterFormConfig(themeParam);
    slClockOneShotToDesktopService.setJudgeClockAniAvailableFromDesktop((stateWrapper:
      ClockAniAvailableFromDesktopStateWrapper) => {
      let pageDesktopClock: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
      stateWrapper.isAvailable = pageDesktopClock.isSatisfiedOneShotAnimation();
      stateWrapper.desktopRectInfo = pageDesktopClock.getClockPosition();
    });
  }

  private updateFormConfig(themeParam?: LockscreenThemeConfig, isDisplayChange?: boolean): void {
    if (!themeParam || !this._formViewModel) {
      return;
    }
    this._formViewModel.themeParam = ObjectCopyUtil.deepClone(themeParam);
    log.showInfo(`updateFormConfig form: ${JSON.stringify(themeParam.form)}`);
    if (this.isEnterEditMode()) {
      if (isDisplayChange === false) {
        this._formViewModel.viewModelInit(themeParam.form.list, themeParam.clock?.layout,
          ShowFormPanelScene.LOCK_SCREEN_EDIT, themeParam.form.positionY);
      }
    } else {
      this._formViewModel.viewModelInitOnScreenLock(themeParam.form.list,
        themeParam.clock?.layout, themeParam.form.positionY);
    }
    ScreenLockFormPanelMeshConfig.setPanelHeight(this._formViewModel.getFormPanelHeight());
  }

  private updateOuterFormConfig(themeParam?: LockscreenThemeConfig): void {
    if (!themeParam || !this._outerFormViewModel) {
      return;
    }
    this._outerFormViewModel?.viewModelInitOnScreenLock(themeParam.form.list);
  }

  private reportEditReportWeek(): void {
    screenLockInnerStateManager.startReportAlarmWithFunc(() => {
      let reportWeekParams: LockscreenEditWeekParams = {
        layout: this.clockStyle.layout.toString(),
        clockFontFamily: this.clockStyle.clockFontFamily,
        clockStrokeColor: this.clockStyle.clockStrokeColor,
        showDate: Number(this.clockStyle.isClockDateVisible).toString(),
        showLunarCalendar: Number(this.clockStyle.isClockLunarVisible).toString(),
        showSignature: Number(this.clockStyle.isClockSignatureVisible).toString(),
        signatureLength: this.clockStyle.clockSignatureText.length.toString(),
        signatureHasEmoji: TextEmojiHelper.isEmoji(this.clockStyle.clockSignatureText) ? '1':'0',
        editFormNum: GlobalStatusCache.getInstance().getStatus('editFormNum', '').toString(),
        editDimensionNum: GlobalStatusCache.getInstance().getStatus('editDimensionNum', '').toString(),
        editThemeId: GlobalStatusCache.getInstance().getStatus('editThemeId', '').toString(),
        editThemeName: GlobalStatusCache.getInstance().getStatus('editThemeName', '').toString()
      };
      let isSupportedPoster: boolean = false;
      PerformanceMonitorUtil.reportLockscreenEditStateNowWeek(reportWeekParams, CLOCK_LAYOUT, undefined, false,
          isSupportedPoster);
    });
  }

  // 密码页到主页锁屏态/主页解锁态
  private readonly stateChangeBouncerToMpShow: StateTransferAction<MpStateType> = {
    isStateTransferMatched: (oldState: MpStateType, newState: MpStateType): boolean => {
      return (MpStateTypeUtils.isBouncerState(oldState) && MpStateTypeUtils.isNormalShowState(newState));
    },
    prepareAction: () => {
      this._spaceAnimationViewModel?.doItemNoPwdUnlockAnimation(true, true);
      this.slBindState.setSlVisibility(Visibility.Visible);
    },
    animationParam: {
      curve: curves.interpolatingSpring(0, 1, 228, 30),
      delay: PasswordConstants.PSD_BACK_DELAY + 50, // 比密码页动效稍晚一点，避免看到密码页残影
      onFinish: () => {
        AppStorage.setOrCreate<boolean>(StatusCacheConst.IS_PLAY_PWD_BACK_ANIMATION, false);
      }
    },
    targetAction: () => {
      log.showInfo('stateChangeBouncerToMpShow');
      this.setMainPageParam(NORMAL_SHOW);
      this.resetWallpaperScale();
      this.spaceAniBlurOpt.setBlurRatio(0);
    }
  };
  // 编辑首页 -> 锁屏显示
  private readonly stateChangeEditNormalToMpShow: StateTransferAction<MpStateType> = {
    isStateTransferMatched: (oldState: MpStateType, newState: MpStateType): boolean => {
      return (MpStateTypeUtils.isEditPreviewState(oldState) && MpStateTypeUtils.isNormalShowState(newState));
    },
    prepareAction: () => {
      this.updateBgWallpaperState(true);
      slWallpaperMgr.exitSlWallpaperScene(SLWallpaperType.TYPE_EDIT_STYLE, SLWallpaperVisibleScene.SCENE_SCREEN_EDIT);
      PerformanceMonitorUtil.setOutScreenLockEditorMoStart();
      Trace.start(HIDE_EDITOR);
    },
    animationParam: {
      curve: curves.interpolatingSpring(0, Constants.PSD_MASS, 228, 30),
      onFinish: () => {
        Trace.end(HIDE_EDITOR);
        PerformanceMonitorUtil.setOutScreenLockEditorMoEnd();
        this.updateBgWallpaperState(false);
      }
    },
    targetAction: () => {
      log.showInfo('stateChangeEditNormalToMpShow');
      this.setMainPageParam(NORMAL_SHOW);
      this.resetWallpaperScale();
      // 退出编辑页面时刷新栅格范围
      // V2场景隔离
      if (SlStateBaseMgr.isV2Enable()) {
        v2Helper.getV2Hook()?.requestUpdateMeshRange();
      } else {
        immersiveVm.getImmersiveMeshManager().requestUpdateMeshRange();
      }
    }
  };
  // 编辑全屏-> 锁屏显示
  private readonly stateChangeEditFullToMpShow: StateTransferAction<MpStateType> = {
    isStateTransferMatched: (oldState: MpStateType, newState: MpStateType): boolean => {
      return (MpStateTypeUtils.isEditFullState(oldState) && MpStateTypeUtils.isNormalShowState(newState));
    },
    targetAction: () => {
      slWallpaperMgr.exitSlWallpaperScene(SLWallpaperType.TYPE_EDIT_STYLE, SLWallpaperVisibleScene.SCENE_SCREEN_EDIT);
      this.setMainPageParam(NORMAL_SHOW);
      this.resetWallpaperScale();
      this.updateBgWallpaperState(false);
    }
  };

  // 编辑扩展-> 锁屏显示
  private readonly stateChangeEditExtendToMpShow: StateTransferAction<MpStateType> = {
    isStateTransferMatched: (oldState: MpStateType, newState: MpStateType): boolean => {
      return (MpStateTypeUtils.isEditExtendState(oldState) && MpStateTypeUtils.isNormalShowState(newState));
    },
    targetAction: () => {
      slWallpaperMgr.exitSlWallpaperScene(SLWallpaperType.TYPE_EDIT_STYLE, SLWallpaperVisibleScene.SCENE_SCREEN_EDIT);
      this.updateBgWallpaperState(false);
    }
  };
  // ScreenOff态
  private readonly stateChangeToScreenOff: StateTransferAction<MpStateType> = {
    isStateTransferMatched: (oldState: MpStateType, newState: MpStateType): boolean => {
      return (!MpStateTypeUtils.isScreenOffState(oldState) && MpStateTypeUtils.isScreenOffState(newState));
    },
    targetAction: () => {
      log.showInfo('stateChangeToScreenOff');
      this.setMainPageParam(SCREEN_OFF_SHOW);
      if (!OneMirrorService.getInstance().isConfigSupportToEnd()) {
        // 隐藏锁屏内容，防止闪
        this.setClockOpacity(Constants.MAX_VIEW_OPACITY);
        this.slBindState.setOpacity(Constants.MAX_VIEW_OPACITY);
      }
      this.updateBgWallpaperState(false);
    }
  };

  private setMainPageParam(param: MainPageViewParam): void {
    if (param.slVisibility != undefined) {
      this.slBindState.setSlVisibility(param.slVisibility);
    }
    if (param.wallpapreTranslate != undefined) {
      this.slBindState.setWallpaperTranslate(param.wallpapreTranslate);
      AppStorage.setOrCreate('editorTranslate', -param.wallpapreTranslate);
    }
    if (param.zoomRatio != undefined) {
      this.slBindState.setZoomRatio(param.zoomRatio);
    }
    if (param.slideRatio != undefined) {
      this.slBindState.setSlideScale(param.slideRatio);
    }
    if (param.slOpacity != undefined) {
      this.slBindState.setOpacity(param.slOpacity);
    }

    if (param.wallpaperScale != undefined) {
      this.wallpaperData.wallpaperScale = param.wallpaperScale;
    }

    if (param.slWallpaperScale != undefined) {
      this.slWallpaperState.wallpaperScale = param.slWallpaperScale;
    }
    if (param.blurRadius != undefined) {
      AppStorage.setOrCreate('blurRadius', param.blurRadius);
    }
    if (param.lockIconOpacity != undefined) {
      this.slLockIconBindCtrl.setLayoutOpacity(1 - param.lockIconOpacity / 150);
    }
    if (param.clockOpacity != undefined) {
      this.slClockBindCtrl.setLayoutOpacity(1 - param.clockOpacity / 150);
    }
    if (param.listVisibility != undefined) {
      this.slListWidgetBindState.setVisibility(param.listVisibility);
    }
  }

  private updateMixedPassWordSettingState(curMode: KeyGuardMode = SpecialModeManager.getInstance()
    .getSpecialModeViewData()
    .curMode): void {
    let isSpecialMode = KeyGuardMode.DEFAULT !== curMode;
    SettingDbUtils.setNormalValToDbWithCatch('SettingsDB.Screenlock.Wallpaper.IsLightWallpaper',
      isSpecialMode ? 'false' : this.slWallpaperState.isLightWallpaper + '');
  }

  public updateClockTextBlurEnabled(): void {
    let textBlurEffect: boolean = false;
    if (!this._slVisualVc.getEnable(SlFeatureType.CLOCK_MAIN, CcmOption.EFFECT)) {
      this.slClockBindCtrl.setTextBlurEffect(textBlurEffect);
      return;
    }
    textBlurEffect = this.clockStyle.isClockTextBlurEffectEnabled &&
      !this.slClockBindCtrl.getClearTextBlurEffect() && this._specialModeViewData.curMode === KeyGuardMode.DEFAULT;
    this.slClockBindCtrl.setTextBlurEffect(textBlurEffect);
  }
}