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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { CallToState, WindowConstants } from '@ohos/commonconstants';
import {
  DeviceHelper,
  EvtBus,
  SystemParamUtils,
  ViewController,
  viewMgrPolicy,
  ViewType,
  WindowEvent
} from '@ohos/frameworkwrapper';
import { AnimationType, InteractiveType, themeWallpaperAniMgr } from '@ohos/themeservice';
import {
  SCBEventId,
  scbGestureManager,
  SCBSceneSessionManager,
  SCBScreenSessionManager,
  sSCBOobeManager,
  GestureType
} from '@ohos/windowscene';
import { ThemeFreezeReason  } from '@ohos/themeservice/src/main/ets/service/themeservice/ThemeWallpaperAnimationManager';
import { OccludeKeygaurdScene } from '@ohos/windowscene/src/main/ets/scene/session/SCBSceneSessionManager';
import {
  immersiveFgCtrl,
  ImmersiveFingerListener
} from '@ohos/immersivekeyguard/src/main/ets/model/service/ImmersiveFingerControll';
import Constants from '@ohos/screenlockcomponent/src/main/ets/common/Constants';
import { ResUtils } from '@ohos/windowscene';
import { immersiveVm } from '@ohos/immersivekeyguard/src/main/ets/viewmodel/ImmersiveVm';
import { screenLockBlurButtonVM } from '@ohos/notificationcomponent/src/main/ets/vm/ScreenLockBlurButtonVM';
import {
  AcquireExtraInfo,
  AcquireResultCode,
  BaseVerifyViewVm,
  CacheValue,
  ClockOneShortConsts,
  CommonConstants,
  FingerprintAcquireCode,
  GlobalStatusCache,
  KeyguardStatusService,
  MeshConfig,
  OccludedStateManager,
  OccludedStateManagerListener,
  PowerUtils,
  screenLockInnerStateManager,
  ScreenLockState,
  ScreenLockToDesktopConsts,
  ScreenLockTransitionState,
  ScreenLockVerifyService,
  ScreenOnOffListener,
  ScreenOnOffService,
  slClockOneShotToDesktopService,
  StrongAuthStateManager,
  VerifyDataManager,
  VerifyInfo,
  vibratorMgr,
  KeyGuardMode,
  KeyGuardCacheKey,
  FaceUnlockReason,
  PerformanceMonitorUtil,
} from '@ohos/screenlockcommon';
import {
  DisplayStateManager,
  eyeGazeSwingEvent,
  FsmCallback
} from '@ohos/screenlockcommon/Index';
import { SlStateBaseMgr, SlStateMgr } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { ClockEditorEntryMethod } from '@ohos/screenlockcommon/src/main/ets/record/report/PerformanceMonitorUtil';
import { WallpaperStratege } from '@ohos/screenlockcommon/src/main/ets/bean/KeyGuardStatusEnum';
import { FormInterruptEvent } from '@ohos/screenlockwidget/src/main/ets/formAni/FormEvent';
import { AccessibilityUtil } from '@ohos/screenlockcommon/src/main/ets/utils/AccessibilityUtil';
import { AuthType } from '@ohos/screenlockcommon/src/main/ets/utils/AccountHelper';
import { clockLayoutHelper } from '@ohos/screenlockwidget/src/main/ets/clock/common/ClockLayoutHelper';
import { ClockStaticData } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/ClockStaticData';
import { SlClockBindState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockBindState';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import ScreenLockThemeManager from '@ohos/screenlockwidget/src/main/ets/common/theme/ScreenLockThemeManager';
import { LockscreenThemeConfig } from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';
import ScreenLockFormViewModel from '@ohos/screenlockwidget/src/main/ets/form/vm/ScreenLockFormViewModel';
import SlideScreenLockVm, {
  PinchGestureActionType,
  SlideTouchType
} from '@ohos/screenlockcomponent/src/main/ets/password/viewmodel/SlideScreenLockVm';
import {
  QuickToolConstants,
  QuickToolsState
} from '@ohos/screenlockcomponent/src/main/ets/quicktools/common/QuickToolConstants';
import { CoreEventType } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockCoreFsm';
import { QuickToolUtil } from '@ohos/screenlockcomponent/src/main/ets/quicktools/common/StatusCacheUtil';
import MultiSceneThemeManager from '@ohos/screenlockwidget/src/main/ets/common/theme/MultiSceneThemeManager';
import { GestureNaviUtil } from '@ohos/screenlockcomponent/src/main/ets/utils/GestureNaviUtil';
import { AodSlideAdapter } from '@ohos/screenlockcomponent/src/main/ets/adapter/AodSlideAdapter';
import {
  CoreStateTypeUtils
} from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockCoreFsm';
import { MpEvent, MpStateTypeUtils, MpStateType, MpEventType } from '@ohos/screenlockcommon/src/main/ets/fsm/MainPageFsm';
import { ScreenLockFsmProxy } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockFsmProxy';
import { SoStateTypeUtils } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenOffFsm';
import { VerifyTipsService } from '@ohos/screenlockcomponent/src/main/ets/tips/service/VerifyTipsService';
import {
  EnableBackGestureEvent,
  immersiveKgMgr,
  scbStatusBarStatusManager
} from '@ohos/systemuicommon';
import { Qualifier } from '@ohos/themeservicekit/Index';
import lazy { v2Helper } from '@ohos/immersivekeyguard';
import { SCBDefaultZIndex } from '../../scenemanager/SCBScreen';
import {
  slStateHelper as screenLockStateHelper
} from '@ohos/screenlockcomponent/src/main/ets/screenlockstate/model/helper/SlStateHelper';
import { slStateHelper } from '../model/helper/SlStateHelper';
import {
  SpecialModeManager,
  SpecialModeChangeListener
} from '@ohos/screenlockcomponent/src/main/ets/common/SpecialModeManager';
import { VibratorManagerEffect } from '@ohos/screenlockcommon/src/main/ets/manager/VibratorManager';
import { SlMainStateType, WidgetStaticStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { WidgetArea } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';
import { SlBindState } from '../model/data/SlBindState';
import { ExtDeviceUnLockEvent } from '../utils/ExtDeviceUnLockEvent';
import { DownPosition } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';
import { scbStatusBarVM } from '../../statusbar/viewmodel/SCBStatusBarVM';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { text } from '@kit.ArkGraphics2D';
import { MainPageHeightManger } from './MainPageHeightManger';
import { UseScene } from '@ohos/screenlockwidget/src/main/ets/common/adapter/Constans';
import { ClockAdapterFactory } from '@ohos/screenlockwidget/src/main/ets/clock/adapter/ClockAdapter';
import { SlListWidgetBindState } from '@ohos/immersivekeyguard/src/main/ets/model/data/SlListWidgetBindState';
import ThemeHelperUtil from '@ohos/screenlockwidget/src/main/ets/common/theme/ThemeHelperUtil';

const TAG = 'MainPageVm';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const IS_PAD: boolean = DeviceHelper.isPadOr2in1PcType();
const NORMAL_GRID_AMOUNT_Y: number = 7;
const STATUS_BAR_BG_COLOR = '#4D000000';
const slideEventType: number[] = [0, 102, 1001];
const scrollWheelType: number = 9;
const slideEventTypeWhenTalkback: number[] = [0, 1, 1001];
const MAX_REMAIN_TIMES: number = 2;
const IS_NOTIFICATION_WAKEUP: string = 'isNotificationWakeUpForFace';
const APP_START_WHITE_LIST: string[] =
  ['com.ohos.clock.FullScreenAbility', 'com.ohos.callui.MainAbility', 'PickerAbility'];

/**
 * 主页视图模型
 */
export class MainPageVm extends BaseVerifyViewVm {
  private fsmProxy: ScreenLockFsmProxy;
  private slideScreenLockViewModel?: SlideScreenLockVm;
  private formViewModel?: ScreenLockFormViewModel;
  private screenLockThemeManager: ScreenLockThemeManager = ScreenLockThemeManager.getInstance();
  private isEnableBackGesture: boolean = false;
  private isFingerprintEnable: boolean = false;
  private extensionProxy: UIExtensionProxy | null = null;
  private isWallpaperTouchable: boolean = false;
  private interWallpaperUnlockable: boolean = false;
  private clockUiBindCtrl: SlClockBindState | undefined = slStateHelper.getSlClockBindState();
  private currentState: MpStateType = MpStateType.INIT_STATE;
  private readonly aodSlideAdapter: AodSlideAdapter;
  // 是否正在执行添加卡片动画
  private isAddingForm: boolean = false;
  // 是否正在拖拽卡片
  private isDraggingForm: boolean = false;
  // 触发手势回调返回结果
  private gestureSupportStatus: number = CommonConstants.GESTURE_DEFAULT;
  // 锁屏主页状态管理
  private slBindState: SlBindState = slStateHelper.getSlBindState();
  private slListBindState: SlListWidgetBindState = slStateHelper.getSlListBindState();
  private externerDeviceMove: boolean = false;

  /**
   * 主界面子组件高度管理器
   */
  private mainPageHeightMgr: MainPageHeightManger;

  private _fsmCallback: FsmCallback<MpStateType, MpEvent> = {
    onFsmStateChange: (oldState: MpStateType, newState: MpStateType): void => {
      this.currentState = newState;
      let isFakeAod = MpStateTypeUtils.isFakeAodState(newState);
      log.showInfo(`onFsmStateChange: ${MpStateType[oldState]} --> ${MpStateType[newState]}  fakeAod:${isFakeAod}`);
      this.slBindState?.setIsFakeAodState(isFakeAod);
      this.onMpFsmStateChange(oldState, newState);
      log.showInfo('onMpStateChange end');
    }
  };

  private _enableBackGestureCallback = (event: EnableBackGestureEvent) => {
    let enableBackGesture: boolean = event.isEnable;
    if (this.isEnableBackGesture !== enableBackGesture) {
      log.showInfo(`onBackGestureEnableStateChange: ${this.isEnableBackGesture} --> ${enableBackGesture}, ` +
        `callerName:${event.callerName}`);
      this.isEnableBackGesture = enableBackGesture;
      this.updateGestureNavigationEnableState();
    }
    this.updateEyeGazeSwing();
  };

  private readonly _occludedChange: OccludedStateManagerListener = {
    onOccludedStateChange: (): void => {
      this.updateGestureNavigationEnableState();
      this.updateEyeGazeSwing();
      this.sendFreezeMsgToTheme();
    }
  };

  private sendFreezeMsgToTheme(): void {
    let occludStateManager = OccludedStateManager.getInstance();
    if (this.isNeedSendMsgToTheme(occludStateManager.windowOccludedState)) {
      log.showInfo(`isFreezeAni = ${occludStateManager.isOccluded}`);
      if (occludStateManager.isOccluded) {
        themeWallpaperAniMgr.freezeThemeEngine(ThemeFreezeReason.SCREEN_LOCK_ON_BACKGROUND);
      } else {
        themeWallpaperAniMgr.unfreezeThemeEngine(ThemeFreezeReason.SCREEN_LOCK_ON_BACKGROUND);
      }
    }
  }

  private isNeedSendMsgToTheme(occludedState: number): boolean {
    return OccludeKeygaurdScene.SPECIAL === occludedState || OccludeKeygaurdScene.SYSTEM_TOP_PANEL === occludedState ||
      !OccludedStateManager.getInstance().isOccluded;
  }


  private isRegisterNavigationTouch: boolean = false;

  // 锁屏导航条事件回调
  private readonly _navigationTouchCallback: Function = (event: TouchEvent) => {
    // 锁屏主屏幕底部上滑才能解锁
    if ((KeyguardStatusService.isOccluded() && TouchType.Cancel !== event.type && TouchType.Up !== event.type) ||
      QuickToolUtil.getInstance().getToolsUsing()) {
      return;
    }
    this.closeNtfSettingBtn(event);
    this.setPanelDownGlobalPosition(event);
    // 假AOD状态底部上滑解锁
    this.slideScreenLockViewModel?.handleTouchEvent(event, MpStateTypeUtils.isFakeAodState(
      this.fsmProxy.mainPageFsm.currentStateType) ? SlideTouchType.TOUCH_AOD_UNLOCK : SlideTouchType.TOUCH_UNLOCK);
  };

  private powerStateChangeListener: ScreenOnOffListener = {
    onBeginWakeUp: () => {
      if (!SoStateTypeUtils.isPreBrightState(this.fsmProxy.screenOffFsm.currentStateType)) {
        this.openFaceOnScreenOn();
      }
    },
    onPreBeginSleep: () => {
      log.debug(`onPreBeginSleep state:${MpStateType[this.currentState]}`);
      // 开始灭屏前（状态机处理前），执行沉浸锁屏初始化
      this.checkInitImmersiveCard();
      if (this.currentState === MpStateType.UNLOCK_STATE) {
        this.clockUiBindCtrl?.setClockDesktopToAod(
          slClockOneShotToDesktopService.isClockDesktopToAodAnimAvailable(true));
      }
    },
    onEndSleep: () => {
      AppStorage.delete(IS_NOTIFICATION_WAKEUP);
    }
  };

  // 监听小工具是否在使用中
  private readonly _quickToolListener = (isToolsUsing?: CacheValue) => {
    log.showInfo(`isToolsUsing changes ${isToolsUsing}`);
    this.updateVerifyState();
    this.updateEyeGazeSwing();
  };

  // 监听沉浸态下胶囊导致的指纹能否显示
  private _isImmersiveDisableFinger: boolean = false;
  private readonly _immersiveFingerStateListener: ImmersiveFingerListener = {
    onNtfDataUpdate: (isShowFinger: boolean) => {
      log.showInfo(`immersive update fingerprint enable status: ${isShowFinger}`);
      this._isImmersiveDisableFinger = !isShowFinger;
      this.updateVerifyState();
    }
  };

  // 监听特殊模式
  private readonly _specialModeListener: SpecialModeChangeListener = {
    onSpecialModeChange: (curMode: KeyGuardMode): void => {
      if (curMode !== KeyGuardMode.DEFAULT &&
      MpStateTypeUtils.isEditState(this.fsmProxy.mainPageFsm.currentStateType)) {
        this.fsmProxy.submitCoreEvent(CoreEventType.BACK_TO_MAIN_PAGE);
      }
      this.updateEyeGazeSwing();
    }
  };

  constructor(persistentId: number) {
    super(persistentId);
    this.fsmProxy = ScreenLockFsmProxy.getInstance(persistentId);
    this.aodSlideAdapter = new AodSlideAdapter(this.fsmProxy);
    this.mainPageHeightMgr = new MainPageHeightManger(persistentId);
  }

  /**
   * 假AOD状态触发重新唤醒
   */
  public handleFakeAodRecover(): void {
    if (this.fsmProxy.mainPageFsm.currentStateType === MpStateType.UNLOCK_STATE) {
      log.showInfo('handleFakeAodChange, begin to UNLOCK_STATE.');
      PowerUtils.asyncWakeupDevice(PowerUtils.WAKEUP_DETAIL_FINGER_AUTH_SUCCESS);
      if (PowerUtils.isActive()) {
        log.showInfo('handleFakeAodChange, notifyScreenLockEvent MSG_NOTIFY_CANCEL_OFF_SCREEN.');
        SCBScreenSessionManager.getInstance().notifyScreenLockEvent(PowerUtils.MSG_NOTIFY_CANCEL_OFF_SCREEN);
      }
      log.showInfo('handleFakeAodChange, end to UNLOCK_STATE.');
    } else {
      log.showInfo('handleFakeAodChange, begin to BOUNCER_STATE.');
      PowerUtils.asyncWakeupDevice(PowerUtils.WAKEUP_DETAIL_AOD_SLIDE_UNLOCK);
      if (PowerUtils.isActive()) {
        log.showInfo('handleFakeAodChange, notifyScreenLockEvent MSG_NOTIFY_CANCEL_OFF_SCREEN.');
        SCBScreenSessionManager.getInstance().notifyScreenLockEvent(PowerUtils.MSG_NOTIFY_CANCEL_OFF_SCREEN);
      }
      log.showInfo('handleFakeAodChange, end to BOUNCER_STATE.');
    }
  }

  /**
   * 初始化
   */
  protected doInit(): void {
    log.info('doInit');
    super.doInit();
    this.fsmProxy.mainPageFsm.registerObserver(this._fsmCallback);
    this.screenLockThemeManager.registerThemeActiveEvent({
      onMultiThemeActivate: (themeParams: Map<Qualifier, LockscreenThemeConfig>) => {
        MultiSceneThemeManager.cacheThemeInfoByQualifier(themeParams);
      }
    });
    EvtBus.on(EnableBackGestureEvent, this._enableBackGestureCallback);
    VerifyDataManager.getInstance().registerObserver({
      onVerifyInfoChange: (authType: AuthType, verifyInfo: VerifyInfo) => {
        if (authType === AuthType.FINGERPRINT) {
          this.updateFingerprintEnableState(verifyInfo.isSupportUnlock);
          this.initScreenLockMeshConfig(DisplayStateManager.getInstance().isPortrait());
        }
      }
    });
    ScreenOnOffService.getInstance().registerObserver(this.powerStateChangeListener);
    OccludedStateManager.getInstance().registerObserver(this._occludedChange);
    SpecialModeManager.getInstance().registerObserver(this._specialModeListener);
    immersiveFgCtrl.registerImmersiveFingerListener(this._immersiveFingerStateListener);
    // 初始化指纹管理
    immersiveFgCtrl.init();
    this.mainPageHeightMgr.init();
  }

  /**
   * 设置锁屏卡片的view model
   *
   * @param formViewModel
   */
  public setFormViewModel(formViewModel: ScreenLockFormViewModel): void {
    this.formViewModel = formViewModel;
  }

  /**
   * 设置卡片添加状态
   *
   * @param isAddingForm
   */
  public setAddFormState(isAddingForm: boolean): void {
    this.isAddingForm = isAddingForm;
  }

  /**
   * 设置卡片拖拽状态
   *
   * @param isDragForm
   */
  public setDragFormState(isDraggingForm: boolean): void {
    this.isDraggingForm = isDraggingForm;
  }

  /**
   * 设置锁屏页面滑动交互的view model
   *
   * @param slideScreenLockViewModel
   */
  public setSlideScreenLockViewModel(slideScreenLockViewModel: SlideScreenLockVm): void {
    this.slideScreenLockViewModel = slideScreenLockViewModel;
  }

  private registerNavigationTouchCallback(): void {
    if (!this.isRegisterNavigationTouch) {
      scbGestureManager.registerTouchEvent(GestureType.NAVIGATION, 'SCBScreenLock', this._navigationTouchCallback);
      this.isRegisterNavigationTouch = true;
    }
  }

  private unregisterNavigationTouchCallback(): void {
    if (this.isRegisterNavigationTouch) {
      scbGestureManager.unRegisterTouchEvent(GestureType.NAVIGATION, 'SCBScreenLock');
      this.isRegisterNavigationTouch = false;
    }
  }

  private updateEyeGazeSwing(): void {
    let isNormalShow: boolean = MpStateTypeUtils.isNormalShowState(this.fsmProxy.mainPageFsm.currentStateType);
    let isOccluded: boolean = OccludedStateManager.getInstance().isOccluded;
    let isToolUsing: boolean = GlobalStatusCache.getInstance().
      getStatus(QuickToolConstants.CACHE_KEY_IS_TOOLS_USING, false) as boolean;
    let isSpecialMode = SpecialModeManager.getInstance().getSpecialModeViewData().curMode !== KeyGuardMode.DEFAULT;
    let isNeedSubscribe: boolean = isNormalShow && !isOccluded && !isToolUsing && !this.isEnableBackGesture &&
      !isSpecialMode;
    if (isNeedSubscribe) {
      eyeGazeSwingEvent.subscribe();
    } else {
      eyeGazeSwingEvent.unSubscribe();
    }
    let gestureEnable = isNormalShow && !isToolUsing && !OccludedStateManager.getInstance().isOccluded &&
      !isSpecialMode && ScreenLockThemeManager.getInstance().isGestureSupported;
    this.gestureSupportStatus = themeWallpaperAniMgr.reqEnableGesture(gestureEnable, (isClockCollapse: boolean) => {
      this.clockShiftByGesture(isClockCollapse);
    });
  }

  /**
   * 释放
   */
  protected doRelease(): void {
    log.info('doRelease');
    super.doRelease();
    this.fsmProxy.mainPageFsm.unRegisterObserver(this._fsmCallback);
    EvtBus.off(EnableBackGestureEvent, this._enableBackGestureCallback);
    ScreenOnOffService.getInstance().unRegisterObserver(this.powerStateChangeListener);
    OccludedStateManager.getInstance().unRegisterObserver(this._occludedChange);
    SpecialModeManager.getInstance().unRegisterObserver(this._specialModeListener);
    GlobalStatusCache.getInstance().unsubscribe(QuickToolConstants.CACHE_KEY_IS_TOOLS_USING, this._quickToolListener);
    immersiveFgCtrl.unregisterImmersiveFingerListener(this._immersiveFingerStateListener);
    immersiveFgCtrl.destroy();
    this.mainPageHeightMgr.destroy();
  }

  private onMpFsmStateChange(oldState: MpStateType, newState: MpStateType): void {
    if (MpStateTypeUtils.isScreenOffState(oldState) && !MpStateTypeUtils.isScreenOffState(newState)) {
      this.onEnterScreenOnState();
    }
    if (!MpStateTypeUtils.isNormalShowState(oldState) && MpStateTypeUtils.isNormalShowState(newState)) {
      this.onEnterScreenLockMainPage();
    }
    if (MpStateTypeUtils.isNormalShowState(newState) || MpStateTypeUtils.isFakeAodState(newState)) {
      this.registerNavigationTouchCallback();
    } else {
      this.unregisterNavigationTouchCallback();
    }
    if (!MpStateTypeUtils.isEditState(oldState) && MpStateTypeUtils.isEditPreviewState(newState)) {
      this.onEnterScreenLockEditPage();
    }
    if (MpStateTypeUtils.isEditFullState(newState)) {
      this.onEnterScreenLockFullEditPage(newState);
    }
    if ((MpStateTypeUtils.isEditFullState(oldState) || MpStateTypeUtils.isEditExtensionState(oldState)) &&
      MpStateTypeUtils.isEditPreviewState(newState)) {
      this.onBackToPreviewEditPage();
    }
    if (!MpStateTypeUtils.isEditExtensionState(oldState) && MpStateTypeUtils.isEditExtensionState(newState)) {
      this.onEnterScreenLockEditExtPage(newState);
    }
    if (!MpStateTypeUtils.isUnlockState(oldState) && MpStateTypeUtils.isUnlockState(newState)) {
      this.onExitScreenLockPage();
    }
    if (MpStateTypeUtils.isUnlockState(oldState) && !MpStateTypeUtils.isUnlockState(newState)) {
      this.onEnterScreenLockPage();
    }
    if (MpStateTypeUtils.isMainPageState(newState) && MpStateTypeUtils.isBouncerState(oldState)) {
      this.onBackFromBouncer();
    }
    if (!MpStateTypeUtils.isBouncerState(oldState) && MpStateTypeUtils.isBouncerState(newState)) {
      this.onEnterBouncer();
    }
    if (!MpStateTypeUtils.isEditState(newState) && MpStateTypeUtils.isEditState(oldState)) {
      this.onExitScreenLockEditPage();
    }
    if (!MpStateTypeUtils.isFakeAodState(oldState) && MpStateTypeUtils.isFakeAodState(newState)) {
      this.onEnterScreenOffState();
    }
    if (!MpStateTypeUtils.isEditClockPickerState(oldState) && MpStateTypeUtils.isEditClockPickerState(newState)) {
      this.onEnterEditClockPicker();
    }
    if (!MpStateTypeUtils.isEditAodPickerState(oldState) && MpStateTypeUtils.isEditAodPickerState(newState)) {
      this.onEnterEditClockPicker();
    }
    this.updateVerifyState(oldState);
    this.updateEyeGazeSwing();
  }

  /**
   * 息屏态过渡为亮屏态
   */
  private onEnterScreenOnState(): void {
    log.showInfo(`onEnterScreenOnState isNotificationWakeUpForFace: ${AppStorage.has(IS_NOTIFICATION_WAKEUP)}`);
    this.openFaceOnScreenOn();
  }


  private openFaceOnScreenOn(): void {
    if (AppStorage.has(IS_NOTIFICATION_WAKEUP)) {
      ScreenLockVerifyService.getInstance().setOperateOpenState(AuthType.FACE, true, false, FaceUnlockReason.SCREEN_ON);
    } else {
      ScreenLockVerifyService.getInstance().setOperateOpenState(AuthType.FACE, true, true, FaceUnlockReason.SCREEN_ON);
    }
  }

  /**
   * 亮屏态过渡为息屏态
   */
  private onEnterScreenOffState(): void {
    log.showInfo('onEnterScreenOffState');
    viewMgrPolicy.offGestureCallback(SCBEventId.HOME_GESTURE_EVENT, this.persistentId);
    screenLockInnerStateManager.onEnterHost();
    this.postHideHeadsUpWindowEvent();
    this.cancelGestureEnable();
  }

  /**
   * 锁屏艺术风 从时钟编辑拉起图库Picker
   */
  private onEnterEditClockPicker(): void {
    viewMgrPolicy.offGestureCallback(SCBEventId.BACK_GESTURE_EVENT, this.persistentId);
    viewMgrPolicy.onGestureCallback(SCBEventId.BACK_GESTURE_EVENT, this.persistentId,
      () => {
        // 主动对PhotoPicker发送back事件
        sceneSessionManager.processBackEvent();
      });
  }

  private postHideHeadsUpWindowEvent(): void {
    // 关闭横幅通知
    let event: WindowEvent = new WindowEvent();
    event.windowName = WindowConstants.WINDOW_NAME_BANNER;
    event.eventState = WindowEvent.EVENT_STATE_END;
    event.eventType = WindowEvent.EVENT_TYPE_HIDE;
    EvtBus.post(WindowEvent, event);
  }

  /**
   * 进入锁屏首页
   */
  private onEnterScreenLockMainPage(): void {
    log.showInfo('onEnterScreenLockMainPage');
    this.updateGestureNavigationEnableState();
    screenLockInnerStateManager.onEnterHost();
    viewMgrPolicy.offGestureCallback(SCBEventId.BACK_GESTURE_EVENT, this.persistentId);
    viewMgrPolicy.onGestureCallback(SCBEventId.BACK_GESTURE_EVENT, this.persistentId,
      () => {
        log.showInfo('onGestureCallback under main page');
        if (QuickToolUtil.getInstance().getToolsUsing()) {
          QuickToolUtil.getInstance().setToolsState(QuickToolsState.CLOSE);
          return;
        }
        // V2开关
        if (SlStateBaseMgr.isV2Enable()) {
          let stateMgr = SlStateMgr.MGR_COMMON;
          v2Helper.getV2Hook()?.onBackGestureEvent(stateMgr);
        } else {
          if (screenLockBlurButtonVM.getShouldBlur()) {
            screenLockBlurButtonVM.unblur(true);
            return;
          }
          immersiveVm.handleImmersiveBackEvent();
        }
      });
    viewMgrPolicy.offGestureCallback(SCBEventId.HOME_GESTURE_EVENT, this.persistentId);
    viewMgrPolicy.onGestureCallback(SCBEventId.HOME_GESTURE_EVENT, this.persistentId,
      () => {
        log.showInfo('onGesture home under main page');
        if (MpStateTypeUtils.isBouncerState(this.fsmProxy.mainPageFsm.currentStateType)) {
          PowerUtils.refreshActivity('onHomeGestureCallback');
        }
        if (QuickToolUtil.getInstance().getToolsUsing()) {
          QuickToolUtil.getInstance().setToolsState(QuickToolsState.CLOSE);
          return;
        }
        if (VerifyDataManager.getInstance().getVerifyInfo(AuthType.FACE).isDirectUnlockOnce) {
          log.showInfo('is in aod sliding state.');
          return;
        }
        this.fsmProxy.submitCoreEvent(CoreEventType.SLIDE_FROM_BOTTOM);
      });
  }

  private _startSceneCallback: Function =
    (bundleName: string, moduleName: string, abilityName: string, callState: number = CallToState.UNKNOWN) => {
      log.showInfo(`screenlock onAppStart, moduleName = ${moduleName} abilityName = ${abilityName},
          bundleName = ${bundleName}, CallToState = ${callState}, ${APP_START_WHITE_LIST.indexOf(abilityName)}`);
      if (APP_START_WHITE_LIST.indexOf(abilityName) !== -1 || CallToState.BACKGROUND === callState) {
        return;
      }
      this.fsmProxy.submitCoreEvent(CoreEventType.REQUEST_UNLOCK);
    };

  /**
   * 进入锁屏编辑
   */
  private onEnterScreenLockEditPage(): void {
    log.showInfo('onEnterScreenLockEditPage');
    this.updateGestureNavigationEnableState();
    scbStatusBarVM.setLockEditorState(true);
    scbStatusBarVM.hideStatusbarLockEditor(STATUS_BAR_BG_COLOR);
    screenLockInnerStateManager.onEnterThemeEditor();
    viewMgrPolicy.offGestureCallback(SCBEventId.BACK_GESTURE_EVENT, this.persistentId);
    viewMgrPolicy.onGestureCallback(SCBEventId.BACK_GESTURE_EVENT, this.persistentId,
      () => {
        log.showInfo('onGestureCallback under edit page');
        this.fsmProxy.submitCoreEvent(CoreEventType.BACK_TO_MAIN_PAGE);
      });
    viewMgrPolicy.offGestureCallback(SCBEventId.HOME_GESTURE_EVENT, this.persistentId);
    viewMgrPolicy.onGestureCallback(SCBEventId.HOME_GESTURE_EVENT, this.persistentId,
      () => {
        log.showInfo('onGesture home under edit page');
        if (this.isDraggingForm) {
          return;
        }
        if (this.isAddingForm) {
          this.interruptFormAdding(true);
        }
        this.fsmProxy.submitCoreEvent(CoreEventType.BACK_TO_MAIN_PAGE);
      });
    SCBSceneSessionManager.getInstance().registerStartSceneListener(this._startSceneCallback);
  }

  /**
   * 打断卡片添加动画处理
   *
   * @param isHomeGesture : 是否是home手势触发打断
   */
  private interruptFormAdding(isHomeGesture: boolean): void {
    log.showInfo(`interrupt add form, is home interrupt : ${isHomeGesture}`);
    EvtBus.post(FormInterruptEvent, {isHomeInterrupting:isHomeGesture});
  }

  /**
   * 退出锁屏编辑
   */
  private onExitScreenLockEditPage(): void {
    log.showInfo('onExitScreenLockEditPage');
    scbStatusBarVM.setLockEditorState(false);
    scbStatusBarStatusManager.showStatusBar();
    SCBSceneSessionManager.getInstance().unregisterStartSceneListener();
  }

  /**
   * 进入锁屏全屏编辑
   */
  private onEnterScreenLockFullEditPage(newState: MpStateType): void {
    log.showInfo(`onEnterScreenLockFullEditPage newState: ${newState}`);
    if (newState === MpStateType.EDIT_MAIN_PAGE_STATE_FULL) {
      screenLockInnerStateManager.onEnterFullEditor(ScreenLockState.THEME_EDITOR_FULL);
    } else if (newState === MpStateType.EDIT_CLOCK_STATE) {
      screenLockInnerStateManager.onEnterFullEditor(ScreenLockState.THEME_EDITOR_FULL_CLOCK);
    } else if (newState === MpStateType.EDIT_CARD_STATE) {
      screenLockInnerStateManager.onEnterFullEditor(ScreenLockState.THEME_EDITOR_FULL_FORM);
    } else if (newState === MpStateType.EDIT_CARD_DETAIL_STATE) {
      screenLockInnerStateManager.onEnterFullEditor(ScreenLockState.THEME_EDITOR_FORM_DETAIL);
    }
    viewMgrPolicy.offGestureCallback(SCBEventId.BACK_GESTURE_EVENT, this.persistentId);
    viewMgrPolicy.onGestureCallback(SCBEventId.BACK_GESTURE_EVENT, this.persistentId,
      () => {
        log.showInfo('onGestureCallback under edit page');
        if (this.isDraggingForm) {
          return;
        }
        if (this.isAddingForm) {
          this.interruptFormAdding(false);
        }
        this.fsmProxy.submitMainPageEvent(MpEventType.SLIDE_BACK);
      });
  }

  private onBackToPreviewEditPage(): void {
    log.showInfo('onBackToPreviewEditPage');
    screenLockInnerStateManager.onEnterThemeEditor();
    viewMgrPolicy.offGestureCallback(SCBEventId.BACK_GESTURE_EVENT, this.persistentId);
    viewMgrPolicy.onGestureCallback(SCBEventId.BACK_GESTURE_EVENT, this.persistentId,
      () => {
        log.showInfo('onGestureCallback under edit page');
        this.fsmProxy.submitCoreEvent(CoreEventType.BACK_TO_MAIN_PAGE);
      });
    viewMgrPolicy.offGestureCallback(SCBEventId.HOME_GESTURE_EVENT, this.persistentId);
    viewMgrPolicy.onGestureCallback(SCBEventId.HOME_GESTURE_EVENT, this.persistentId,
      () => {
        log.showInfo('onGesture home under edit page');
        this.fsmProxy.submitCoreEvent(CoreEventType.BACK_TO_MAIN_PAGE);
      });
  }

  /**
   * 设置拉起extension的调用代理
   *
   * @param extensionProxy 调用代理
   */
  public setExtensionProxy(extensionProxy: UIExtensionProxy | null): void {
    this.extensionProxy = extensionProxy;
  }

  /**
   * 通知主题退出主题画廊
   */
  public exitThemeGallery(): void {
    this.extensionProxy?.send({
      'animation': true
    });
  }

  /**
   * 进入锁屏编辑扩展编辑态
   */
  private onEnterScreenLockEditExtPage(stateType: MpStateType): void {
    log.showInfo('onEnterScreenLockEditExtPage');
    if (stateType === MpStateType.EDIT_WALLPAPER_STATE) {
      screenLockInnerStateManager.onEnterOtherAppBorderShow();
    } else if (stateType === MpStateType.EDIT_THEME_STATE || stateType === MpStateType.EDIT_CUSTOM_THEME_STATE ||
      stateType === MpStateType.EDIT_AOD_STYLE_STATE) {
      screenLockInnerStateManager.onEnterOtherAppBorderHide();
    }
    viewMgrPolicy.offGestureCallback(SCBEventId.BACK_GESTURE_EVENT, this.persistentId);
    viewMgrPolicy.onGestureCallback(SCBEventId.BACK_GESTURE_EVENT, this.persistentId,
      () => {
        log.showInfo('onGesture back under edit other app page');
        this.extensionProxy?.send({ 'backEvent': true });
      });
    viewMgrPolicy.offGestureCallback(SCBEventId.HOME_GESTURE_EVENT, this.persistentId);
    viewMgrPolicy.onGestureCallback(SCBEventId.HOME_GESTURE_EVENT, this.persistentId,
      () => {
        log.showInfo('onGesture home under edit other app page');
        this.extensionProxy?.send({ 'backEvent': true });
        this.fsmProxy.submitCoreEvent(CoreEventType.BACK_TO_MAIN_PAGE);
      });
  }

  /**
   * 进入锁屏解锁态
   */
  private onExitScreenLockPage(): void {
    log.showInfo('onExitScreenLockPage');
    viewMgrPolicy.offGestureCallback(SCBEventId.BACK_GESTURE_EVENT, this.persistentId);
    viewMgrPolicy.offGestureCallback(SCBEventId.HOME_GESTURE_EVENT, this.persistentId);
    text.FontCollection.getGlobalInstance().clearCaches();
  }

  /**
   * 进入密码态
   */
  private onEnterBouncer(): void {
    log.showInfo('onEnterBouncer');
    screenLockInnerStateManager.onEnterBouncer();
  }

  /**
   * 从密码页面返回
   */
  private onBackFromBouncer(): void {
    let controller: ViewController | undefined = viewMgrPolicy.getViewController(ViewType.WALLPAPER);
    log.showInfo(`onEnterHost, setWallpaperZindex to ${SCBDefaultZIndex.SCREEN_LOCK_WALL_PAPER}, controller: ${controller}`);
    controller?.setZIndex(SCBDefaultZIndex.SCREEN_LOCK_WALL_PAPER);
  }

  /**
   * 进入密码态
   */
  private onEnterScreenLockPage(): void {
    log.showInfo('onEnterScreenLockPage');
  }

  private updateGestureNavigationEnableState() {
    // 非主页场景，不处理
    if (!MpStateTypeUtils.isMainPageState(this.fsmProxy.mainPageFsm.currentStateType)) {
      return;
    }
    if (MpStateTypeUtils.isEditState(this.fsmProxy.mainPageFsm.currentStateType)) {
      // 刷新导航条使能情况，编辑状态下home手势和back手势均使能
      GestureNaviUtil.setGestureNavigationEnableState(true, true);
    } else {
      // 刷新导航条使能情况，通知显示的时候使能back
      GestureNaviUtil.setGestureNavigationEnableState(this.isEnableBackGesture, true);
    }
  }

  private clockShiftByGesture(isClockCollapse: boolean) {
    // V2开关
    if (SlStateBaseMgr.isV2Enable()) {
      v2Helper.getV2Hook()?.screenLockClockShift(isClockCollapse);
    } else {
      immersiveVm.getImmersiveMeshManager().screenLockClockShift(isClockCollapse);
    }
  }

  private cancelGestureEnable() {
    // V2开关
    if (SlStateBaseMgr.isV2Enable()) {
      v2Helper.getV2Hook()?.screenLockClockShift(false);
    } else {
      immersiveVm.getImmersiveMeshManager().screenLockClockShift(false);
    }
    if (this.gestureSupportStatus !== CommonConstants.GESTURE_DEFAULT) {
      themeWallpaperAniMgr.reqEnableGesture(false, () => {});
      this.gestureSupportStatus = CommonConstants.GESTURE_DEFAULT;
    }
  }

  private closeNtfSettingBtn(event: TouchEvent): void {
    switch (event.type as TouchType) {
      case TouchType.Down:
        if (SlStateBaseMgr.isV2Enable()) {
          v2Helper.getV2Hook()?.requestHideSettingDialog();
        } else {
          screenLockBlurButtonVM.unblur();
        }
        break;
      default:
        break;
    }
  }

  /**
   * 触发进入锁屏编辑
   */
  public enterScreenLockEdit(): void {
    log.showInfo('enterScreenLockEdit');
    this.fsmProxy.submitCoreEvent(CoreEventType.ENTER_EDIT);
  }

  /**
   * 触发退出锁屏
   */
  public exitScreenLock(): void {
    log.showInfo('exitScreenLock');
    this.fsmProxy.submitCoreEvent(CoreEventType.UNLOCK_DIRECT);
  }

  /**
   * 进入密码解锁页面
   */
  public enterBouncerView(): void {
    log.showInfo('enterBouncerView');
    this.fsmProxy.submitCoreEvent(CoreEventType.REQUEST_UNLOCK);
  }

  /**
   * 记录触摸的点位置
   */
  public setPanelDownGlobalPosition(event: TouchEvent): void {
    switch (event.type as TouchType) {
      case TouchType.Down:
      // 记录down点
        if (event?.touches?.length == 1) {
          let globalDown: DownPosition =
            { positionX: event?.touches[0]?.screenX, positionY: event?.touches[0]?.screenY };
          slStateHelper.getSlStaticState()?.setSlPanelDownGlobal(globalDown);
        }
        break;
      default:
        break;
    }
  }

  /**
   * 当前是否支持显示卡片
   *
   * @returns 是否支持显示卡片
   */
  public isSupportShowScreenLockForm(): boolean {
    if (this.formViewModel && this.formViewModel?.supportFormPositions) {
      return this.formViewModel?.supportFormPositions?.length > 0 &&
        this.formViewModel?.supportFormPositions[0].positionX === 0;
    }
    return false;
  }

  protected isNeedHandleVerifyResult(): boolean {
    return CoreStateTypeUtils.isInMainPage(this.fsmProxy.coreFsm.currentStateType);
  }

  /**
   * 初始化网格布局信息
   *
   * @param isPortrait 是否竖屏
   */
  public initScreenLockMeshConfig(isPortrait: boolean): void {
    const gridAmountY: number = clockLayoutHelper.getLayoutGridAmount(isPortrait).y;
    if (this.isFingerprintEnable || IS_PAD || DeviceHelper.isUltraScreenProduct()) {
      MeshConfig.maxScreenLockMesh = gridAmountY;
    } else {
      MeshConfig.maxScreenLockMesh = NORMAL_GRID_AMOUNT_Y;
    }
    MeshConfig.meshHeight = clockLayoutHelper.getLayoutGridWidth(isPortrait);
    slStateHelper.getSlStaticState()?.setMeshConfig(MeshConfig);
    log.showInfo(`initScreenlockMeshConfig fingerprintEnable: ${this.isFingerprintEnable},` +
      `gridAmountY: ${gridAmountY} meshHeight: ${MeshConfig.meshHeight}`);
  }

  /**
   * 更新指纹状态
   *
   * @param isEnable 指纹使能
   */
  public updateFingerprintEnableState(isEnable: boolean) {
    log.showInfo(`updateFingerprintEnableState ${isEnable}`);
    this.isFingerprintEnable = isEnable;
    immersiveKgMgr.updateFingerprintEnable(isEnable);
  }

  /**
   * 锁屏界面双击
   */
  public doubleClickScreenLock(ev?: GestureEvent): void {
    if (this.isDraggingForm || this.isAddingForm) {
      log.showInfo(`adding card`);
      return;
    }
    log.showInfo('doubleClickScreenLock');
    if (IS_PAD) {
      themeWallpaperAniMgr.sendAnimationInfo2Wallpaper({
        animationType: AnimationType.WALLPAPER_DOUBLE_CLICK_PAD
      });
    }
    if (MpStateTypeUtils.isFakeAodState(this.fsmProxy.mainPageFsm.currentStateType)) { // 假AOD双击亮屏
      this.fsmProxy.submitCoreEvent(CoreEventType.BACK_TO_MAIN_PAGE);
      return;
    }
    // 沉浸三态区域双击不响应人脸解锁
    if (ev) {
      let globalX = ev.fingerList[0]?.globalX;
      let globalY = ev.fingerList[0]?.globalY;
      let isMatchImmArea: boolean = false;
      // V2开关
      if (SlStateBaseMgr.isV2Enable()) {
        let stateMgr = SlStateMgr.MGR_COMMON;
        isMatchImmArea = v2Helper.getV2Hook()?.checkMatchExactArea({
          globalX: globalX, globalY: globalY, slStMgr: stateMgr });
      } else {
        isMatchImmArea = immersiveVm.checkMatchExactArea({ globalX: globalX, globalY: globalY });
      }
      if (isMatchImmArea) {
        log.showWarn('checkImmMatchExactArea onlyImmRange true');
        return;
      }
    }

    ScreenLockVerifyService.getInstance().setOperateOpenState(AuthType.FACE, true, true, FaceUnlockReason.DOUBLE_TAP);
    if (ScreenLockVerifyService.getInstance().isVerifying(AuthType.FACE)) {
      vibratorMgr.startVibration();
    }
  }

  /**
   * 锁屏界面单机空白区域
   */
  public singleClickScreenLock(event: ClickEvent): void {
    log.showInfo('singleClickScreenLock');
    if (!MpStateTypeUtils.isEditState(this.fsmProxy.mainPageFsm.currentStateType)) {
      this.click2Psw(event);
      return;
    }
    log.showInfo(`singleClickScreenLock: ${this.fsmProxy.mainPageFsm.currentStateType}`);
    if (this.isDraggingForm) {
      return;
    }
    if (this.isAddingForm) {
      this.interruptFormAdding(false);
    }
    this.fsmProxy.submitMainPageEvent(MpEventType.ENTER_EDIT_MAIN_PAGE_FULL);
  }

  private click2Psw(event: ClickEvent): void {
    if (!this.isValidDevice(event)) {
      return;
    }
    if (this.externerDeviceMove) {
      return;
    }
    let globalX = event.windowX;
    let globalY = event.windowY;
    this.handleExtDeviceUnlock(globalX, globalY, false);
  }

  private singleClick2Psw(event: GestureEvent) {
    this.touchGesture2Psd(event, false)
  }

  public touchGesture2Psd(event: GestureEvent, isLongPress: boolean = true): void {
    if (!this.isValidDevice(event)) {
      return;
    }
    if (this.externerDeviceMove) {
      return;
    }
    let globalX = event.fingerList[0].globalX;
    let globalY = event.fingerList[0].globalY;
    this.handleExtDeviceUnlock(globalX, globalY, isLongPress);
  }

  private isValidDevice(event: BaseEvent): boolean {
    if (event.sourceTool != SourceTool.MOUSE && event.sourceTool != SourceTool.TOUCHPAD) {
      return false;
    }
    return true;
  }

  private handleExtDeviceUnlock(globalX: number, globalY: number, isLongPress: boolean): void {
    if (this.isWallpaperTouchable) {
      return;
    }
    if ((this.isNormalLockState() || this.isNormalUnlockState()) &&
      this.positionInValidRange(globalX, globalY, isLongPress)) {
      EvtBus.post(ExtDeviceUnLockEvent, new ExtDeviceUnLockEvent());
    }
  }

  public scrollWheelUnlock(ev: GestureEvent) {
    if (ev.source === SourceType.Mouse && ev.sourceTool === scrollWheelType &&
      (this.isNormalLockState() || this.isNormalUnlockState())) {
      AppStorage.setOrCreate('isSpaceOrMenuKeyEvent', true);
      EvtBus.post(ExtDeviceUnLockEvent, new ExtDeviceUnLockEvent());
    }
  }

  private positionInValidRange(globalX: number, globalY: number, isLongPress: boolean): boolean {
    let array: SlMainStateType[] = [SlMainStateType.SL_QT_WG_STATIC_STATE, SlMainStateType.SL_CAMERA_WG_STATIC_STATE];
    if (isLongPress) {
      array = [SlMainStateType.SL_QT_WG_STATIC_STATE, SlMainStateType.SL_CAMERA_WG_STATIC_STATE,
        SlMainStateType.SL_CLOCK_WG_STATIC_STATE];
    }
    for (let index = 0; index < array.length; index++) {
      let area: WidgetArea = slUiStateMgr.getSlState(array[index])?.getSlState(
        WidgetStaticStateType.WIDGET_AREA) as WidgetArea;
      if (globalX > area.globalX! && (globalX < area.globalX! + area.width) && globalY > area.globalY! &&
        (globalY < area.globalY! + area.height)) {
        return false;
      }
    }
    let isMatchImmArea: boolean = false;
    // V2开关
    if (SlStateBaseMgr.isV2Enable()) {
      let stateMgr = SlStateMgr.MGR_COMMON;
      isMatchImmArea = v2Helper.getV2Hook()?.checkMatchExactArea({
        globalX: globalX, globalY: globalY, slStMgr: stateMgr });
    } else {
      isMatchImmArea = immersiveVm.checkMatchExactArea({ globalX: globalX, globalY: globalY });
    }
    if (isMatchImmArea) {
      return false;
    }
    return true;
  }

  public isNormalLockState() {
    return MpStateTypeUtils.isNormalLockState(this.fsmProxy.mainPageFsm.currentStateType)
  }

  public isNormalUnlockState() {
    return MpStateTypeUtils.isNormalUnlockState(this.fsmProxy.mainPageFsm.currentStateType)
  }

  /**
   * 锁屏界面滑动事件处理
   *
   * @param event 滑动事件
   */
  public handleTouchScreenLock(event: TouchEvent) {
    if (event.type == TouchType.Down) {
      this.externerDeviceMove = false;
    }
    if (event.type !== TouchType.Move) {
      log.showInfo(`event.type: ${event.type}`);
    } else {
      this.externerDeviceMove = true;
    }
    let isSpecialMode = SpecialModeManager.getInstance().getSpecialModeViewData().curMode !== KeyGuardMode.DEFAULT;
    if (this.isNeedUnlockByTheme() && !isSpecialMode) {
      this.onTouchEventTransferValue(event);
      if (this.interWallpaperUnlockable) {
        if (MpStateTypeUtils.isNormalShowState(this.fsmProxy.mainPageFsm.currentStateType)) {
          this.slideScreenLockViewModel?.handleTouchEvent(event, SlideTouchType.TOUCH_UNLOCK);
        }
      }
    } else {
      if (MpStateTypeUtils.isNormalShowState(this.fsmProxy.mainPageFsm.currentStateType)) {
        this.slideScreenLockViewModel?.handleTouchEvent(event, SlideTouchType.TOUCH_UNLOCK);
      }
    }
  }

  private isNeedUnlockByTheme() {
    return this.isWallpaperTouchable;
  }

  // 在onTouchEventTransferValue()中使用，标识是否有TouchDown事件
  private hasTouchDown: boolean = false;
  private onTouchEventTransferValue(event?: TouchEvent): void {
    if (!MpStateTypeUtils.isNormalShowState(this.fsmProxy.mainPageFsm.currentStateType)) {
      themeWallpaperAniMgr.sendMainPageStateChangeEvent2Wallpaper({
        mainPageStateType: this.fsmProxy.mainPageFsm.currentStateType
      });
      this.sendCancelToThemeWallpaper(event);
      return;
    }
    if (event?.type === TouchType.Cancel) {
      this.sendCancelToThemeWallpaper(event);
    }
    if (this.hasTouchDown === false && event?.type === TouchType.Move) {
      // Move事件的前提是有Down事件，如果缺失Down事件，则把第一次的Move事件模拟为Down事件
      this.hasTouchDown = true;
      event!.type = TouchType.Down;
    }
    let curSlideEventType = slideEventType;
    if (AccessibilityUtil.isAccessibilityMode()) {
      curSlideEventType = slideEventTypeWhenTalkback;
    }
    if (event?.type === TouchType.Down && curSlideEventType.includes(event?.changedTouches[0]?.id)) {
      this.hasTouchDown = true;
      themeWallpaperAniMgr.sendInteractiveEvent2Wallpaper({
        interactiveType: InteractiveType.TOUCH_DOWN,
        x: event.changedTouches[0].windowX,
        y: event.changedTouches[0].windowY,
      });
    }
    if (event?.type === TouchType.Up && curSlideEventType.includes(event?.changedTouches[0]?.id)) {
      themeWallpaperAniMgr.sendInteractiveEvent2Wallpaper({
        interactiveType: InteractiveType.TOUCH_UP,
        x: event.changedTouches[0].windowX,
        y: event.changedTouches[0].windowY,
      });
      this.hasTouchDown = false;
    }
    if (event?.type === TouchType.Cancel) {
      this.hasTouchDown = false;
    }
    if (event?.type !== TouchType.Move) {
      log.showInfo('onTouchEventTransferValue');
    }
  }

  private sendCancelToThemeWallpaper(event: TouchEvent | undefined) {
    themeWallpaperAniMgr.sendInteractiveEvent2Wallpaper({
      interactiveType: InteractiveType.CANCEL,
      x: 0,
      y: 0,
    });

  }

  /**
   * 长按时钟组件
   */
  public longPressClockWidget(event?: GestureEvent): void {
    if (this.isEnableEditor() && MpStateTypeUtils.isNormalShowState(this.fsmProxy.mainPageFsm.currentStateType)) {
      vibratorMgr.startVibrationPlus(VibratorManagerEffect.VIBRATION_EFFECT_LIGHT);
      PerformanceMonitorUtil.reportLockscreenEditorEnterMethod(ClockEditorEntryMethod.LONG_PRESS);
      this.enterScreenLockEdit();
    } else if (MpStateTypeUtils.isEditState(this.fsmProxy.mainPageFsm.currentStateType) &&
      !MpStateTypeUtils.isEditExtensionState(this.fsmProxy.mainPageFsm.currentStateType)) {
      vibratorMgr.startVibrationPlus(VibratorManagerEffect.VIBRATION_EFFECT_LIGHT);
      this.fsmProxy.submitMainPageEvent(MpEventType.ENTER_EDIT_MAIN_PAGE_FULL);
      screenLockInnerStateManager.onEnterFullEditor(ScreenLockState.THEME_EDITOR_CLOCK_DRAG);
      this.slBindState.setClockDragState(true);
    }
  }

  /**
   * 单击时钟组件
   */
  public singleClickClockWidget(event: GestureEvent): void {
    log.showInfo('singleClickClockWidget');
    if (MpStateTypeUtils.isEditState(this.fsmProxy.mainPageFsm.currentStateType)) {
      log.showInfo('ClockWidget onClick');
      if (MpStateTypeUtils.isEditClockState(this.fsmProxy.mainPageFsm.currentStateType)) {
        this.fsmProxy.submitMainPageEvent(MpEventType.ENTER_EDIT_MAIN_PAGE_FULL);
        this.sendExitClockEditMessage();
      } else {
        this.fsmProxy.submitMainPageEvent(MpEventType.ENTER_EDIT_CLOCK);
        this.sendEnterClockEditMessage();
      }
    }
    this.singleClick2Psw(event);
  }

  /**
   * 长按卡片组件
   */
  public longPressFormPanel(): void {
    if (this.isEnableEditor() && MpStateTypeUtils.isNormalShowState(this.fsmProxy.mainPageFsm.currentStateType)) {
      vibratorMgr.startVibrationPlus(VibratorManagerEffect.VIBRATION_EFFECT_LIGHT);
      PerformanceMonitorUtil.reportLockscreenEditorEnterMethod(ClockEditorEntryMethod.LONG_PRESS);
      this.enterScreenLockEdit();
    }
  }

  /**
   * 刷新壁纸是否可以支持交互
   */
  public updateWallpaperTouchable(isTouchable: boolean): void {
    log.showInfo(`updateWallpaperTouchable ${isTouchable}`);
    this.isWallpaperTouchable = isTouchable;
  }

  public updateInterWallpaperUnlockable(wallpaperTouchableStrategy: number): void {
    this.interWallpaperUnlockable = wallpaperTouchableStrategy == WallpaperStratege.ENABLE_TOUCHABLE_WITH_KEYGUARD;
    GlobalStatusCache.getInstance().setStatus(KeyGuardCacheKey.INTERWALLPAPER_UNLOCKABLE,
      this.interWallpaperUnlockable);
  }

  /**
   * 壁纸可交互场景处理事件下发
   */
  public handleInteractiveEvent(event: GestureEvent, type: InteractiveType) {
    if (!this.isWallpaperTouchable) {
      return;
    }
    if (this.isValidDevice(event)) {
      return;
    }
    if (!MpStateTypeUtils.isNormalShowState(this.fsmProxy.mainPageFsm.currentStateType)) {
      return;
    }
    log.showInfo(`handleInteractiveEvent GestureEvent type is ${type}`);
    if (event && event.fingerList.length !== 0 && event.fingerList[0]) {
      let globalX = event.fingerList[0].globalX;
      let globalY = event.fingerList[0].globalY;
      let isMatchImmZones: boolean = false;
      // V2开关
      if (SlStateBaseMgr.isV2Enable()) {

        let stateMgr = SlStateMgr.MGR_COMMON;
        isMatchImmZones = v2Helper.getV2Hook()?.checkMatchHotZones({
          globalX: globalX, globalY: globalY, slStMgr: stateMgr });
      } else {
        isMatchImmZones = immersiveVm.checkMatchHotZones({ globalX: globalX, globalY: globalY });
      }
      if (isMatchImmZones) {
        log.showWarn('handleInteractiveEvent checkImmTouchHotZones is true');
        return;
      }
      themeWallpaperAniMgr.sendInteractiveEvent2Wallpaper({
        interactiveType: type,
        x: event.fingerList[0].globalX,
        y: event.fingerList[0].globalY,
      });
    }
  }

  public handlePinchGestureEvent(event: GestureEvent, type: PinchGestureActionType): void {
    if (!this.isEnableEditor()) {
      log.showInfo('pinch editor is disable');
      return;
    }
    this.slideScreenLockViewModel?.pinchGestureEvent(event, type, () => {
      vibratorMgr.startVibrationPlus();
      PerformanceMonitorUtil.reportLockscreenEditorEnterMethod(ClockEditorEntryMethod.FINGER_PINCH);
      this.enterScreenLockEdit();
    });
  }

  /**
   * 无障碍模式下播报"进入时钟组件编辑模式"
   */
  private sendEnterClockEditMessage(): void {
    if (AccessibilityUtil.isAccessibilityMode()) {
      AccessibilityUtil.sendAccessibility(ResUtils.getInnerString(Constants.ENTER_CLOCK_EDIT_ACCESSIBLE));
    }
  }

  /**
   * 无障碍模式下播报"退出时钟组件编辑模式"
   */
  private sendExitClockEditMessage(): void {
    if (AccessibilityUtil.isAccessibilityMode()) {
      AccessibilityUtil.sendAccessibility(ResUtils.getInnerString(Constants.EXIT_CLOCK_EDIT_ACCESSIBLE));
    }
  }

  private isEnableEditor(): boolean {
    if (SystemParamUtils.isHddProduct()) {
      // 如果是2D产品,不处理捏合逻辑
      log.showInfo('disable editor in hdd product');
      return false;
    }

    if (KeyguardStatusService.isSpecialMode()) {
      // 特殊模式不支持进入锁屏编辑
      log.showInfo('disable editor in special mode');
      return false;
    }

    if (sSCBOobeManager.isOobeActivated()) {
      log.showInfo('disable editor in oobe');
      return false;
    }

    return MpStateTypeUtils.isNormalLockState(this.fsmProxy.mainPageFsm.currentStateType) ||
      MpStateTypeUtils.isNormalUnlockState(this.fsmProxy.mainPageFsm.currentStateType);
  }

  private updateVerifyState(oldState?: MpStateType): void {
    let curState: MpStateType = this.fsmProxy.mainPageFsm.currentStateType;
    if (!MpStateTypeUtils.isMainPageState(curState)) {
      // 非主页态不处理
      return;
    } else {
      // 有可能被错误清除!!! 所以进入主页时重新注册监听
      GlobalStatusCache.getInstance().subscribe(QuickToolConstants.CACHE_KEY_IS_TOOLS_USING, this._quickToolListener);
    }

    // 更新人脸验证状态
    if (QuickToolUtil.getInstance().getToolsUsing()) {
      // 小工具使用中，则关闭人脸验证
      ScreenLockVerifyService.getInstance().setOperateOpenState(AuthType.FACE, false);
    } else if (MpStateTypeUtils.isNormalLockState(curState)) {
      if (oldState !== undefined && MpStateTypeUtils.isScreenOffState(oldState)) {
        this.openFaceOnScreenOn();
      } else {
        ScreenLockVerifyService.getInstance().setOperateOpenState(AuthType.FACE, true, true, FaceUnlockReason.BACK_MAIN_PAGE);
      }
    } else {
      ScreenLockVerifyService.getInstance().setOperateOpenState(AuthType.FACE, false);
    }

    // 更新指纹验证状态
    if ((QuickToolUtil.getInstance().getToolsUsing() || this._isImmersiveDisableFinger) &&
      VerifyDataManager.getInstance().getVerifyInfo(AuthType.FINGERPRINT).hasUnderFingerprint) {
      // 小工具使用中或沉浸态导致的指纹不能显示，则关闭屏下指纹验证
      ScreenLockVerifyService.getInstance().setOperateOpenState(AuthType.FINGERPRINT, false);
    } else if (MpStateTypeUtils.isNormalLockState(curState) || MpStateTypeUtils.isFakeAodState(curState)) {
      ScreenLockVerifyService.getInstance().setOperateOpenState(AuthType.FINGERPRINT, true);
    } else if (MpStateTypeUtils.isNormalUnlockState(curState)) {
      // 常规解锁态下，支持外部指纹解锁
      ScreenLockVerifyService.getInstance().setOperateOpenState(AuthType.FINGERPRINT,
        VerifyDataManager.getInstance().getVerifyInfo(AuthType.FINGERPRINT).hasOuterFingerprint);
    } else {
      ScreenLockVerifyService.getInstance().setOperateOpenState(AuthType.FINGERPRINT, false);
    }
  }

  protected onFaceVerifySuccess(): void {
    super.onFaceVerifySuccess();
    log.showInfo('onFaceVerifySuccess');
    if (this.faceVerifyInfo.isDirectUnlock || this.faceVerifyInfo.isDirectUnlockOnce) {
      slClockOneShotToDesktopService
        .requestDirectUnlock(ScreenLockToDesktopConsts.FACE_TO_DESKTOP_CLOCK_ANIMATION);
    } else {
      this.fsmProxy.submitCoreEvent(CoreEventType.UNLOCK_SILENCE);
    }
  }

  protected onFaceVerifyFail(): void {
    super.onFaceVerifyFail();
    log.showInfo('onFaceVerifyFail.');
    if (VerifyDataManager.getInstance().getVerifyInfo(AuthType.FACE).isStateLocked) {
      log.showInfo('onFaceVerifyFail verify state locked.');
      if (KeyguardStatusService.isOccluded()) {
        // 覆盖模式下不跳转
        return;
      }
      // 人脸禁用时，若密码未禁用，则需要跳转至密码页
      if (!VerifyDataManager.getInstance().getVerifyInfo(AuthType.PIN).isStateLocked) {
        log.showInfo('onFaceVerifyFail verify state locked, will goto bouncer view.');
        this.fsmProxy.submitCoreEvent(CoreEventType.REQUEST_UNLOCK);
      }
    }
  }

  protected onOtherFingerprintAcquireSuccess(): void {
    let isNeedStrongAuth: boolean = StrongAuthStateManager.getInstance().isNeedStrongAuth();
    log.showInfo(`handleFingerprintAuthSuccess state:${MpStateType[this.currentState]} isNeedStrongAuth: ${isNeedStrongAuth}`);
    if (!isNeedStrongAuth) {
      if (MpStateTypeUtils.isFakeAodState(this.currentState)) {
        slClockOneShotToDesktopService
          .requestDirectUnlock(ClockOneShortConsts.AOD_TO_DESKTOP_CLOCK_ANIMATION);
      } else {
        slClockOneShotToDesktopService
          .requestDirectUnlock(ScreenLockToDesktopConsts.FINGERPRINT_TO_DESKTOP_CLOCK_ANIMATION);
      }
    } else {
      this.fsmProxy.submitCoreEvent(CoreEventType.REQUEST_UNLOCK);
    }
  }

  protected onFingerprintAcquireTriggerStrongAuth(): void {
    super.onFingerprintAcquireTriggerStrongAuth();
    log.showInfo('onFingerprintAcquireTriggerStrongAuth');
    this.fsmProxy.submitCoreEvent(CoreEventType.REQUEST_UNLOCK);
  }

  protected onOtherFingerprintAcquireInfo(module: number, acquire: number, extraInfo: AcquireExtraInfo): void {
    super.onOtherFingerprintAcquireInfo(module, acquire, extraInfo);
    log.showInfo(`onOtherFingerprintAcquireInfo acquire: ${acquire}`);
    switch (acquire) {
      case FingerprintAcquireCode.FINGERPRINT_TIP_TOO_FAST:
        log.showDebug('receive FINGERPRINT_TIP_TOO_FAST');
        VerifyTipsService.getInstance().publishVerifyingTips(AuthType.FINGERPRINT, acquire);
        break;
      case FingerprintAcquireCode.FINGERPRINT_ANTITOUCH_NOTIFICATION_CAMERA:
        log.showDebug('receive FINGERPRINT_TIP_TRIGGER_ANTITOUCH_NOTIFICATION');
        VerifyTipsService.getInstance().publishVerifyingTips(AuthType.FINGERPRINT, acquire);
        break;
      case FingerprintAcquireCode.FINGERPRINT_TIP_SINGLE_PRESS_RESULT:
        log.showDebug('receive FINGERPRINT_TIP_SINGLE_PRESS_RESULT');
        if (extraInfo && (extraInfo.authResult === AcquireResultCode.FAIL ||
          extraInfo.authResult === AcquireResultCode.LOCKED)) {
          let fpVerifyInfo: VerifyInfo = VerifyDataManager.getInstance().getVerifyInfo(AuthType.FINGERPRINT);
          if (fpVerifyInfo.remainTimes > 0 && fpVerifyInfo.remainTimes <= MAX_REMAIN_TIMES &&
            !KeyguardStatusService.isOccluded()) {
            this.enterBouncerView();
          }
          VerifyTipsService.getInstance().publishVerifyResultTips(AuthType.FINGERPRINT);
        }
      default:
        break;
    }
  }

  private checkInitImmersiveCard(): void {
    // 状态机未执行，从Unlock状态切换时，并且默认进沉浸态开关打开时，才进行设置
    if (this.currentState !== MpStateType.UNLOCK_STATE || !immersiveKgMgr.getDefaultImmersiveSwitch()) {
      log.showInfo('checkInitImmersiveCard ' + MpStateType[this.currentState]);
      return;
    }
    screenLockStateHelper.getOneMirrorStaticState()?.setIsDesktopToSL(true);
    if (!SlStateBaseMgr.isV2Enable() && screenLockStateHelper.getOneMirrorStaticState()?.getIsNeedToShowImmersive()) {
      // 提前置为非沉浸态， 避免默认进沉浸态时界面闪烁
      immersiveKgMgr.setDefaultImmersiveType();
      // 沉浸态设置时钟为非展开态
      ClockStaticData.updateClockWidgetExpand(false);
    }
    log.showInfo('checkInitImmersiveCard setDesktopToScreenLockFlag true');
  }

  /**
   * 通知熄屏风格编辑跳转全屏预览
   */
  public toAodPreview(): void {
    log.showInfo('toAodFullPreview');
    this.extensionProxy?.send({ 'toAodFullPreview': true });
  }
}