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

import { KeyCode } from '@ohos.multimodalInput.keyCode';
import { AnimationType, themeWallpaperAniMgr } from '@ohos/themeservice';
import { PerformanceReporter, CurrentMemScene } from '@ohos/frameworkcommon';
import { LogDomain, LogHelper, } from '@ohos/basicutils';
import {
  DeviceHelper,
  EvtBus,
  HiSysEventUtil,
  StatusBarContentEvent,
  ViewCallback,
  ViewManagerPolicy,
  ViewType
} from '@ohos/frameworkwrapper';
import { FocusChangeReason, OccludeKeygaurdScene, SCBKeyboardManager, SCBSceneSessionManager, } from '@ohos/windowscene';
import {
  BaseViewVm,
  ClockOneShortConsts,
  DoubleCenterHelper,
  KeyGuardMode,
  KeyguardStatusService,
  LockEventType,
  OccludedStateManager,
  OccludedStateManagerListener,
  PowerUtils,
  ScreenLockUnlockService,
  LockUnlockListener,
  ScreenLockVerifyService,
  ScreenLockToDesktopConsts,
  ScreenLockStateManager,
  slClockOneShotToDesktopService,
  SlServerHelper,
  SlStorageKey,
  StrongAuthStateManager,
  VerifyDataManager,
  WallpaperZIndexUtils,
  CcmConfigHelper,
  GlobalStatusCache,
  StatusCacheConst,
  HiKGReportBase,
  SLUETag,
  PVERSIONID,
  PNAMEID,
} from '@ohos/screenlockcommon';
import {
  FsmCallback,
  FrequentFoldManager,
  ImmInvertColorMgr,
  ImmRunningLockMgr
} from '@ohos/screenlockcommon/Index';
import { DrawDoneManager } from '@ohos/screenlockcommon';
import { AuthType } from '@ohos/screenlockcommon/src/main/ets/utils/AccountHelper';
import {
  CoreEvent,
  CoreEventType,
  CoreStateType,
  CoreStateTypeUtils
} from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockCoreFsm';
import { EventAdapterManager } from '@ohos/screenlockcomponent/src/main/ets/adapter/EventAdapterManapger';
import { GestureNaviUtil } from '@ohos/screenlockcomponent/src/main/ets/utils/GestureNaviUtil';
import ScreenLockAVPlayerManager from '@ohos/screenlockcomponent/src/main/ets/tone/ScreenLockAVPlayerManager';
import { ScreenLockFsmProxy } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockFsmProxy';
import { StatusBarType } from '@ohos/systemuicommon';
import { PageDesktopOneShotManager } from '@ohos/launchercommon/src/main/ets/viewmodel/PageDesktopOneShotManager';
import { CommonConstants as LockCommonConstants } from '@ohos/screenlockcommon';
import {
  SCREEN_LOCK_WALL_PAPER_Z_INDEX,
  SCREEN_LOCK_Z_INDEX
} from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockCoreFsm';
import { OneMirrorService } from '@ohos/screenlockcomponent/src/main/ets/onemirror/service/OneMirrorService';
import { slStateHelper } from '../model/helper/SlStateHelper';
import { ExtDeviceUnLockEvent } from '../utils/ExtDeviceUnLockEvent';
import { SceneBoardStateManager, CoreEventType as SCBCoreEventType } from '@ohos/frameworkwrapper/Index';
import { SCBDefaultZIndex } from '../../scenemanager/SCBScreen';
import lazy { SingleDisplayPocketClockManager } from '../custSingleDisplayDevice/SingleDisplayPocketClockManager'

const TAG = 'SCBScreenLockVm';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 锁屏跟组件ID
 */
export const COMPONENT_ID_SCREEN_LOCK_ROOT = 'ScreenLockRootComponent';

/**
 * 锁屏根组件视图模型
 */
export class SCBScreenLockVm extends BaseViewVm {
  private readonly _fsmProxy: ScreenLockFsmProxy;
  private _windowOccludedState: number = 0;

  private readonly _coreFsmStatChangeCallback: FsmCallback<CoreStateType, CoreEvent> = {
    onFsmStateChange: (oldState: CoreStateType, newState: CoreStateType, event?: CoreEvent): void => {
      log.showInfo(`onFsmStateChange: ${CoreStateType[oldState]} --> ${CoreStateType[newState]}`);
      // 状态机状态变更处理
      this.onCoreFsmStateChange(oldState, newState);

      // 锁屏内逻辑变化更新窗口Z序
      let isChangeToLock: boolean = CoreStateTypeUtils.isInUnlockPage(oldState) &&
        !CoreStateTypeUtils.isInUnlockPage(newState);
      let isChangeToUnlock: boolean = !CoreStateTypeUtils.isInUnlockPage(oldState) &&
        CoreStateTypeUtils.isInUnlockPage(newState);
      let screenOn: boolean = CoreStateTypeUtils.isScreenOffState(oldState) &&
        CoreStateTypeUtils.isInScreenOn(newState);
      if (!isChangeToLock && !isChangeToUnlock && !screenOn) {
        this.updateWindowZIndex(true);
      }
      const isBackFromBouncerPage: boolean =
        CoreStateTypeUtils.isInBouncePage(oldState) && CoreStateTypeUtils.isInMainPage(newState);
      if (OccludedStateManager.getInstance().isWindowOccluded && (isBackFromBouncerPage || isChangeToUnlock)) {
        // 调层级回到从密码页面返回到三方应用等页面或者退出锁屏，锁屏需要requestUnfocus将焦点给对应的窗口（在拉起的时候也主动获焦到锁屏了）
        SCBSceneSessionManager.getInstance()
          .requestUnfocus(this.persistentId, FocusChangeReason.BACKGROUND);
        log.showInfo('back to main or unlock from bouncer requestUnfocus if screenlock occluded');
      }

      // 触发子状态机运转
      this._fsmProxy.matchCoreFsmChange(oldState, newState, event);
      log.showInfo('onFsmStateChange finish');
    }
  };

  private readonly _viewCallback: ViewCallback = { // 锁屏面板各事件回调
    onShow: () => {
      log.showInfo('onShow');
      this._slDrawDoneManager.registerComponentDrawObserver(() => {
        log.showInfo('drawDone');
        SlServerHelper.getInstance().sendScreenLockEvent(LockEventType.SCREEN_DRAW_DONE);
      });
      PerformanceReporter.getInstance().reportEnterMemScene(CurrentMemScene.SCENE_SCREEN_LOCK); // 内存记录
    },
    onHide: () => {
      log.showInfo('onHide');
      SCBKeyboardManager.getInstance().setKeyboardPosYOffset(0);
      if (DeviceHelper.isPadOr2in1PcType()) {
        themeWallpaperAniMgr.sendAnimationInfo2Wallpaper({
          animationType: AnimationType.WALLPAPER_LOCKSCREEN_TO_DESKTOP_PAD
        });
      }
      PerformanceReporter.getInstance().reportExitMemScene(CurrentMemScene.SCENE_SCREEN_LOCK);
    },
    onGainFocus: () => {
      GlobalStatusCache.getInstance().setStatus(StatusCacheConst.IS_SCREEN_LOCK_FOCUS, true);
      log.showInfo('onGainFocus');
    },
    onLoseFocus: () => {
      GlobalStatusCache.getInstance().setStatus(StatusCacheConst.IS_SCREEN_LOCK_FOCUS, false);
      log.showInfo('onLoseFocus');
    }
  };

  private readonly _occludedChange: OccludedStateManagerListener = {
    onOccludedStateChange: (isOccluded: boolean): void => {
      if (isOccluded) {
        this._windowOccludedState |= OccludedStateManager.getInstance().windowOccludedState;
      }
      this.updatePageState();
      if (!isOccluded) {
        this._windowOccludedState = 0;
      }
      this.updateWindowZIndex(false);
    }
  };

  private readonly _eventAdapterManager: EventAdapterManager;
  private readonly _slDrawDoneManager: DrawDoneManager = new DrawDoneManager(COMPONENT_ID_SCREEN_LOCK_ROOT);
  private _isUserSlScreenOffTime?: boolean; // 是否使用熄屏时长，初次强制刷新

  private externalDeviceUnlock = (event: ExtDeviceUnLockEvent): void => {
    log.showInfo('externalDeviceUnlock.');
    this.handleSpaceMenuKeyEvent();
  };

  private readonly _lockUnlockListener: LockUnlockListener = {
    onRequestUnlockStateChange: (isInRequestUnlock: boolean) => {
      if (isInRequestUnlock) {
        this.updateWindowZIndex(true);
      }
    }
  };

  constructor(persistentId: number) {
    super(persistentId);
    this._fsmProxy = ScreenLockFsmProxy.getInstance(persistentId);
    this._eventAdapterManager = new EventAdapterManager(this._fsmProxy);
  }

  /**
   * 初始化
   */
  protected doInit(): void {
    log.showInfo('doInit start.');
    super.doInit();
    let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
    if (systemSceneSession) {
      systemSceneSession.setSkipSelfWhenShowOnVirtualScreen(true);
    }
    // 注册页面回调监听
    ViewManagerPolicy.registerViewCallback(ViewType.KEYGUARD, this._viewCallback);

    // 初始化状态机
    this._fsmProxy.coreFsm.init();

    // 监听核心状态机事件
    this._fsmProxy.coreFsm.registerObserver(this._coreFsmStatChangeCallback);

    // 初始化强认证管理器
    StrongAuthStateManager.getInstance().triggerAuthByReboot();

    // 事件适配器初始化
    this._eventAdapterManager.init();

    // 通知双中心退出，否则就会造成页面无法操作，需要熄屏才能恢复。
    DoubleCenterHelper.getInstance().exitDoubleCenter();

    // 注册其他窗口事件监听
    OccludedStateManager.getInstance().init();
    OccludedStateManager.getInstance().registerObserver(this._occludedChange);

    // 投票进入系统
    ScreenLockUnlockService.getInstance().enterSystem();

    // 开启播放锁屏声监听
    ScreenLockAVPlayerManager.onScreenLockPageTypeListener();

    // CCM配置读取初始化
    CcmConfigHelper.getInstance().init();

    EvtBus.post(StatusBarContentEvent,
      StatusBarContentEvent.create(StatusBarType.TYPE_MAIN_PHONE_KEYGUARD, '#FFFFFF'));
    EvtBus.on(ExtDeviceUnLockEvent, this.externalDeviceUnlock);
    ScreenLockUnlockService.getInstance().registerObserver(this._lockUnlockListener);

    log.showInfo('doInit end.');
  }

  protected onModeChanged(mode: KeyGuardMode): void {
    this.updatePageState();
  }

  /**
   * 释放
   */
  protected doRelease(): void {
    log.showInfo('release');
    super.doRelease();

    // 取消监听核心状态机事件
    this._fsmProxy.coreFsm.unRegisterObserver(this._coreFsmStatChangeCallback);

    // 删除状态机代理实例
    ScreenLockFsmProxy.releaseInstance(this.persistentId);

    // 事件适配器释放
    this._eventAdapterManager.release();

    // 注销其他窗口事件监听
    OccludedStateManager.getInstance().unRegisterObserver(this._occludedChange);

    // 注销页面回调监听
    ViewManagerPolicy.unRegisterViewCallback(ViewType.KEYGUARD, this._viewCallback);

    // 关闭播放锁屏声监听
    ScreenLockAVPlayerManager.onScreenLockPageTypeListenerOff();
    EvtBus.off(ExtDeviceUnLockEvent, this.externalDeviceUnlock);

    // CCM配置数据释放
    CcmConfigHelper.getInstance().releaseData();
    let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
    if (systemSceneSession) {
      systemSceneSession.setSkipSelfWhenShowOnVirtualScreen(false);
    }
    ScreenLockUnlockService.getInstance().unRegisterObserver(this._lockUnlockListener);
  }

  private onCoreFsmStateChange(oldState: CoreStateType, newState: CoreStateType): void {
    // 更新导航相关
    this.updateGestureNavEnableState(oldState, newState);
    // 触发页面状态更新
    if (oldState !== newState) {
      this.updatePageState();
      this.onUnlockPageStateChange(oldState, newState);
      this.reportCoreStateChange(oldState, newState);
    }
  }

  private onUnlockPageStateChange(oldState: CoreStateType, newState: CoreStateType): void {
    if (CoreStateTypeUtils.isInUnlockPage(oldState) && !CoreStateTypeUtils.isInUnlockPage(newState)) {
      log.showInfo('into screenlock');
      SceneBoardStateManager.getInstance().consumeEvent(SCBCoreEventType.ENTER_SCREEN_LOCK);
      return;
    }
    if (!CoreStateTypeUtils.isInUnlockPage(oldState) && CoreStateTypeUtils.isInUnlockPage(newState)) {
      log.showInfo('exit screenlock');
      this.onScreenOffUnlock(oldState, newState);
      SceneBoardStateManager.getInstance().consumeEvent(SCBCoreEventType.ENTER_DESKTOP);
      return;
    }
  }

  private onScreenOffUnlock(oldState: CoreStateType, newState: CoreStateType): void {
    if (!CoreStateTypeUtils.isScreenOffUnlockState(oldState) && CoreStateTypeUtils.isScreenOffUnlockState(newState)) {
      // 不支持时钟一镜到底动画时，在熄屏非锁屏态提前将锁屏隐藏，避免黑屏指纹解锁时闪锁屏
      if (OneMirrorService.getInstance().isClockOneShotAnimAvailableOnScreenOffFp()) {
        log.showInfo('pre hide desktop clock card');
        PageDesktopOneShotManager.getInstance().setIsHideClockAnimation(true);
        PageDesktopOneShotManager.getInstance().notifiyFormHideCard();
      } else { // 支持时钟一镜到底动画时，在熄屏非锁屏态提前将锁屏隐藏，避免黑屏指纹解锁时闪锁屏
        log.showInfo('pre hide main page view');
        HiKGReportBase.reportUe(SLUETag.HIDESCREENLOCK, Object({
          PNAMEID: PNAMEID,
          PVERSIONID: PVERSIONID,
        }));
        // 锁屏解锁后，立即隐藏锁屏
        animateToImmediately(
          { duration: 0 },
          () => {
          slStateHelper.getSlBindState().setSlVisibility(Visibility.Hidden);
        })
      }
    }
  }

  private reportCoreStateChange(oldState: CoreStateType, newState: CoreStateType): void {
    if (!CoreStateTypeUtils.isInUnlockPage(oldState) && CoreStateTypeUtils.isInUnlockPage(newState)) {
      HiSysEventUtil.reportExitKeyguard();
    }
  }

  private updateGestureNavEnableState(oldState: CoreStateType, newState: CoreStateType): void {
    if (CoreStateTypeUtils.isInUnlockPage(oldState) && !CoreStateTypeUtils.isInUnlockPage(newState)) {
      // 锁屏状态下默认为去使能back，使能home，场景定制在各子状态机里进行覆盖
      GestureNaviUtil.setGestureNavigationEnableState(false, true);
    } else if (!CoreStateTypeUtils.isInUnlockPage(oldState) && CoreStateTypeUtils.isInUnlockPage(newState)) {
      // 退出锁屏时，还原手势导航默认状态
      GestureNaviUtil.setGestureNavigationEnableState(true, true, false);
    }
  }

  private updatePageState(): void {
    let stateType: CoreStateType = this._fsmProxy.coreFsm.currentStateType;
    let isOccluded: boolean = OccludedStateManager.getInstance().isOccluded;
    log.showInfo(`updatePageState ${CoreStateType[stateType]}, isOccluded: ${isOccluded}`);

    // 更新验证状态
    this.updateVerifierState(stateType, isOccluded);

    // 更新熄屏时长
    this.updateScreenOffTime(stateType);

    // 更新隐私模式
    this.updatePrivacyMode(stateType);

    // 更新主页面状态
    this.updateMainPageState(stateType, isOccluded);
  }

  private updateVerifierState(stateType: CoreStateType, isOccluded: boolean): void {
    if (stateType === CoreStateType.SCREEN_OFF_SIM_CHECK_STATE) {
      log.showInfo('screen off sim check close face open fp');
      ScreenLockVerifyService.getInstance().setPageOpenState(AuthType.FACE, false);
      ScreenLockVerifyService.getInstance().setPageOpenState(AuthType.FINGERPRINT, true);
    } else if (CoreStateTypeUtils.isInScreenOff(stateType)) {
      log.showInfo('other screen off open face fp');
      ScreenLockVerifyService.getInstance().setPageOpenState(AuthType.FACE, true, true, 'other screen off page');
      ScreenLockVerifyService.getInstance().setPageOpenState(AuthType.FINGERPRINT, true);
    } else if (CoreStateTypeUtils.isInFakeAodMainPage(stateType) ||
      stateType === CoreStateType.MAIN_PAGE_UNLOCK_STATE) {
      log.showInfo('fake aod or main page unlock close face open fp');
      ScreenLockVerifyService.getInstance().setPageOpenState(AuthType.FACE, false);
      ScreenLockVerifyService.getInstance().setPageOpenState(AuthType.FINGERPRINT, true);
    } else if (CoreStateTypeUtils.isSimLockState(stateType) || CoreStateTypeUtils.isUnlockStateScreenOn(stateType)) {
      log.showInfo('sim check or unlock close face fp');
      ScreenLockVerifyService.getInstance().setPageOpenState(AuthType.FACE, false);
      ScreenLockVerifyService.getInstance().setPageOpenState(AuthType.FINGERPRINT, false);
    } else if (CoreStateTypeUtils.isInNormalBounce(stateType) &&
      !OccludedStateManager.getInstance().isOccludeOnBouncer &&
      this._windowOccludedState !== OccludeKeygaurdScene.SYSTEM_DIALOG_UNOCCLUDE) {
      log.showInfo('pwd check and occlude on bouncer open face fp');
      ScreenLockVerifyService.getInstance().setPageOpenState(AuthType.FACE, true, true,
        'pwd check and occlude on bouncer');
      ScreenLockVerifyService.getInstance().setPageOpenState(AuthType.FINGERPRINT, true);
    } else {
      log.showInfo(`others, ${CoreStateType[stateType]}, isOccluded: ${isOccluded}, occludedState: ${this._windowOccludedState}`);
      if (!isOccluded && this._windowOccludedState === OccludeKeygaurdScene.SYSTEM_DIALOG_UNOCCLUDE) {
        log.showDebug('Occluded only from SYSTEM_DIALOG_UNOCCLUDE without start face auth');
        ScreenLockVerifyService.getInstance().setPageOpenState(AuthType.FACE, !isOccluded, false);
      } else if (isOccluded || !FrequentFoldManager.getInstance().isFrequentFoldChange) {
        ScreenLockVerifyService.getInstance().setPageOpenState(AuthType.FACE, !isOccluded);
      }
      if (VerifyDataManager.getInstance().getVerifyInfo(AuthType.FINGERPRINT).hasUnderFingerprint) {
        ScreenLockVerifyService.getInstance().setPageOpenState(AuthType.FINGERPRINT, !isOccluded);
      } else {
        ScreenLockVerifyService.getInstance().setPageOpenState(AuthType.FINGERPRINT, true);
      }
    }
  }

  private updateScreenOffTime(stateType: CoreStateType): void {
    // 解锁态，编辑态 恢复成设置中的熄屏时长，其他采用默认锁屏熄屏时长
    let isSlOffTime: boolean = !(CoreStateTypeUtils.isInUnlockPage(stateType) ||
      CoreStateTypeUtils.isInEditMainPage(stateType));
    if (this._isUserSlScreenOffTime !== isSlOffTime) {
      this._isUserSlScreenOffTime = isSlOffTime;
      PowerUtils.setScreenOffTime(isSlOffTime);
    }
  }

  private updatePrivacyMode(stateType: CoreStateType): void {
    // 密码页禁止截图
    let screenLockId = ViewManagerPolicy.getViewController(ViewType.KEYGUARD)?.getId();
    if (screenLockId) {
      let needSetPrivacy: boolean = CoreStateTypeUtils.isInBouncePage(stateType);
      SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(screenLockId)?.setPrivacyMode(needSetPrivacy);
    }
  }

  private updateWindowZIndex(isFsmChanged: boolean): void {
    let newState = this._fsmProxy.coreFsm.currentStateType;
    let isInSpecialZIndex: boolean = false;
    if (CoreStateTypeUtils.isInMainPage(newState)) {
      log.showInfo('wallpaperZIndex to screenLock, main page.');
      ViewManagerPolicy.setZIndex(ViewType.KEYGUARD, SCREEN_LOCK_Z_INDEX);
      this.handleEnterHostWallpaper();
    } else if (CoreStateTypeUtils.isInBouncePage(newState)) {
      if (OccludedStateManager.getInstance().isOccluded && isFsmChanged &&
      ScreenLockUnlockService.getInstance().isInRequestUnlock) {
        // 由状态机触发的层级变化，需要更新层级
        log.showInfo('wallpaperZIndex to special.');
        ViewManagerPolicy.setZIndex(ViewType.KEYGUARD, SCBDefaultZIndex.SCREEN_LOCK_SPECIAL_BOUNCER);
        WallpaperZIndexUtils.setWallpaperZIndex(SCBDefaultZIndex.SCREEN_LOCK_SPECIAL_BOUNCER - 1, 0);
        isInSpecialZIndex = true;
      } else {
        log.showInfo('wallpaperZIndex to screenLock, bouncer page.');
        ViewManagerPolicy.setZIndex(ViewType.KEYGUARD, SCREEN_LOCK_Z_INDEX);
        WallpaperZIndexUtils.setWallpaperZIndex(SCREEN_LOCK_WALL_PAPER_Z_INDEX, 0);
      }
    }
    AppStorage.setOrCreate(SlStorageKey.IS_IN_SPECIAL_Z_INDEX, isInSpecialZIndex);
  }

  private updateMainPageState(stateType: CoreStateType, isOccluded: boolean): void {
    // 刷新主页面显示状态
    const isMainPage = CoreStateTypeUtils.isInNormalMainPage(stateType);
    ImmInvertColorMgr.getInstance().setSlMainPageState(isMainPage);
    ImmInvertColorMgr.getInstance().setSlOccluded(isOccluded);
    ImmRunningLockMgr.getInstance().setSlMainPageState(isMainPage);
    // 排除下拉面板覆盖影响
    ImmRunningLockMgr.getInstance().setSlOccluded(OccludedStateManager.getInstance().isWindowOccluded);
  }

  public handleKeyEvent(event?: KeyEvent): void {
    switch (event?.keyCode) {
      case KeyCode.KEYCODE_SPACE:
      case KeyCode.KEYCODE_MENU:
        AppStorage.setOrCreate('isSpaceOrMenuKeyEvent', true);
        this.handleSpaceMenuKeyEvent();
        break;
    }
  }

  private handleSpaceMenuKeyEvent(): void {
    let isLocked: boolean = ScreenLockStateManager.getInstance().isLocked;
    let currentStateType: CoreStateType = this._fsmProxy.coreFsm.currentStateType;
    log.info(`handleSpaceMenuKeyEvent, isLocked=${isLocked} currentStateType=${currentStateType}`);
    // 在锁屏主页，无密码或者解锁成功，走时钟一镜到底动效，否则请求解锁
    if (!isLocked && CoreStateTypeUtils.isInFakeAodMainPage(currentStateType)) {
      slClockOneShotToDesktopService
        .requestDirectUnlock(ClockOneShortConsts.AOD_TO_DESKTOP_CLOCK_ANIMATION);
    } else if (!isLocked && CoreStateTypeUtils.isInNormalMainPage(currentStateType)) {
      slClockOneShotToDesktopService
        .requestDirectUnlock(ScreenLockToDesktopConsts.KEYPRESS_TO_DESKTOP_CLOCK_ANIMATION);
    } else {
      this._fsmProxy.submitCoreEvent(CoreEventType.REQUEST_UNLOCK);
    }
  }

  private handleEnterHostWallpaper(): void {
    let delay = 0;
    let isBaseDeskPage: boolean = PageDesktopOneShotManager.getInstance().getIsBaseDeskPage();
    if (isBaseDeskPage) {
      delay = LockCommonConstants.DESKTOP_TO_AOD_HOME_PAGE_DELAY;
      log.showInfo(`handleEnterHostWallpaper: on BaseDeskPage,delay:${delay}}`);
    }
    WallpaperZIndexUtils.setWallpaperZIndex(SCREEN_LOCK_WALL_PAPER_Z_INDEX, delay, 'main page');
  }
}