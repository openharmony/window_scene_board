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
import {
  DeviceHelper,
  EvtBus,
  SCBDesktopCacheManager,
  SettingsUtil,
  sEventManager,
  sSettingsUtil,
  unsubscribe,
  ViewManagerPolicy,
  ViewType
} from '@ohos/frameworkwrapper';
import { AodElemPosition, DynamicWallPaperState, themeWallpaperAniMgr } from '@ohos/themeservice';
import {
  OccludeKeygaurdScene,
  OOBE_CHANGE_EVENT,
  SCBScreenSessionManager,
  SCBTransitionManager
} from '@ohos/windowscene';
import { NavBarHideAndShowManager } from '@ohos/launchercommon';
import {
  AbstractObserverManager,
  ClockOneShortConsts,
  DoubleCenterHelper,
  KeyguardStatusService,
  OccludedStateManager,
  OccludedStateManagerListener,
  PowerUtils,
  ScreenLockToDesktopConsts,
  SimCardStateManager,
  ScreenOnOffListener,
  ScreenOnOffService,
  slClockOneShotToDesktopService,
  SleepReason,
  WakeUpReason
} from '@ohos/screenlockcommon';
import {
  FsmCallback,
  ObjectPool,
  Recyclable
} from '@ohos/screenlockcommon/Index';
import DataShareManager from '@ohos/screenlockcommon/src/main/ets/base/DataShareManager';
import { ScreenLockThemeChangeEvent } from '@ohos/screenlockwidget/src/main/ets/common/theme/ScreenLockThemeManager';
import { CoreEvent, CoreStateType, CoreStateTypeUtils } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockCoreFsm';
import { ScreenLockFsmProxy } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockFsmProxy';
import ThemeHelperUtil from '@ohos/screenlockwidget/src/main/ets/common/theme/ThemeHelperUtil';
import IAodProxy from '../model/IAodProxy';
import { PerformanceMonitorUtil } from '@ohos/screenlockcommon';
import { OneMirrorAodProxy } from './OneMirrorAodProxy';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import { ClockStaticStateType, SlMainStateType, ClockDeskTop2AodAnimType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { immersiveKgMgr } from '@ohos/systemuicommon';
import { IOneMirrorStrategy } from '../model/IOneMirrorStrategy';
import { NoMirrorReasonParams } from '@ohos/screenlockcommon/src/main/ets/record/report/PerformanceMonitorUtil';
import { NoMirrorReason } from '../constants/MirrorToEndConst';
import { ClockAdapterFactory } from '@ohos/screenlockwidget/src/main/ets/clock/adapter/ClockAdapter';
import { UseScene } from '@ohos/screenlockwidget/src/main/ets/common/adapter/Constans';
import { ClockAdapter } from '@ohos/screenlockwidget/src/main/ets/clock/adapter/ClockAdapter';
import { ClockLayout } from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';
import { SlClockBindState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockBindState';
import { OneMirrorAodStateMonitor } from './OneMirrorAodStateMonitor';

const TAG = 'OneMirrorService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const FINISH_CALLBACK_POOL_SIZE = 100;
const FINISH_CALLBACK_WAIT_MILLIS = 3000;
const SL_FINISH_CALLBACK_WAIT_MILLIS = 1200;
const FINISH_CALLBACK_CLOCK_ANIM_WAIT_MILLIS = 1000;
const FINISH_CALLBACK_MANAGER_POOL_SIZE = 2;
const MAX_SCREEN_OFF_DELAY_TIME = 2000;
const LEM_MAX_SCREEN_OFF_DELAY_TIME = 3000;
const HDR_MAX_SCREEN_OFF_DELAY_TIME = 3500;
const HDR_STATUS_SETTINGS = 'settings.rs.luminance.hdr_status';
const AOD_ENABLE_STATE_CHANGE = 'aodEnableStateChange';
const AOD_HDR_STATUS_KEY = 'settings.rs.luminance.aod_hdr_status';

/**
 * 一镜到底场景
 */
export enum MirrorScene {
  /**
   * 黑屏
   */
  SCREEN_OFF = DynamicWallPaperState.DEFAULT,

  /**
   * 全屏AOD + 局部AOD
   */
  AOD = DynamicWallPaperState.AOD,

  /**
   * 锁屏
   */
  SCREEN_LOCK = DynamicWallPaperState.SCREENLOCK,

  /**
   * 非锁屏态
   */
  UNLOCK = DynamicWallPaperState.DESKTOP,
}

/**
 * 一镜到底场景工具类
 */
export class MirrorSceneUtils {
  private constructor() {
  }

  /**
   * 是否熄屏场景
   *
   * @param mirrorScene 一镜到底场景
   * @returns 是否熄屏场景
   */
  public static isScreenOffScene(mirrorScene: MirrorScene): boolean {
    return mirrorScene === MirrorScene.SCREEN_OFF || mirrorScene === MirrorScene.AOD;
  }

  /**
   * 是否屏幕完全熄灭场景
   *
   * @param mirrorScene 一镜到底场景
   * @returns 是否屏幕完全熄灭场景
   */
  public static isPowerOffScene(mirrorScene: MirrorScene): boolean {
    return mirrorScene === MirrorScene.SCREEN_OFF;
  }

  /**
   * 是否假AOD场景
   *
   * @param mirrorScene 一镜到底场景
   * @returns 是否假AOD场景
   */
  public static isFakeAodScene(mirrorScene: MirrorScene): boolean {
    return mirrorScene === MirrorScene.AOD;
  }

  /**
   * 是否锁屏场景
   *
   * @param mirrorScene 一镜到底场景
   * @returns 是否锁屏场景
   */
  public static isScreenLockScene(mirrorScene: MirrorScene): boolean {
    return mirrorScene === MirrorScene.SCREEN_LOCK;
  }

  /**
   * 是否解锁场景
   *
   * @param mirrorScene 一镜到底场景
   * @returns 是否解锁场景
   */
  public static isScreenUnLockScene(mirrorScene: MirrorScene): boolean {
    return mirrorScene === MirrorScene.UNLOCK;
  }
}


/**
 * 不同场景下一镜到底参数数据
 */
export class OneMirrorParaData<T> {
  public from?: MirrorScene;
  public to?: MirrorScene;
  public needAnimation: boolean = true;
  public fromLayoutPara?: T;
  public toLayoutPara?: T;
}

/**
 * 结束回调
 */
export interface FinishCallback {
  /**
   * 获取结束回调ID
   *
   * @returns 结束回调ID
   */
  getId(): number;

  /**
   * 执行结束回调
   *
   * @param 结束回调ID
   * @returns 是否成功结束
   */
  finish(id: number): boolean;
}

/**
 * 一镜到底实体
 */
export interface OneMirrorListener {
  /**
   * 场景切换通知
   *
   * @param fromScene 一镜到底开始场景
   * @param toScene 一镜到底目标场景
   * @param hasAnim 是否有一镜到底动效
   * @param finishCallback 结束回调
   * @returns 是否处理中（为true时，即表示需要调用finishCallback的finish后才算处理完）
   */
  onMirrorScene?: (fromScene: MirrorScene, toScene: MirrorScene, hasAnim: boolean,
    finishCallback?: FinishCallback) => boolean;

  /**
   * 启动Aod前调用
   *
   * @param isSupportAnim 是否支持一镜到底动效
   */
  onPreStartAod?: (isSupportAnim: boolean) => void;

  /**
   * 启动Aod后调用
   */
  onPostStartAod?: () => void;

  /**
   * 停止Aod前调用
   */
  onPreStopAod?: (reason: WakeUpReason) => void;

  /**
   * 停止Aod后调用
   */
  onPostStopAod?: (reason: WakeUpReason) => void;
}

/**
 * 内部实现
 */
class InnerFinishCallback implements FinishCallback, Recyclable {
  private static currentId: number = 0;

  private static generateId(): number {
    if (InnerFinishCallback.currentId >= Number.MAX_SAFE_INTEGER) {
      InnerFinishCallback.currentId = 0;
    }
    return ++InnerFinishCallback.currentId;
  }

  private readonly _objPool: ObjectPool<InnerFinishCallback>;
  private _id: number = InnerFinishCallback.generateId();
  private _timeout: number = 0;
  private _finishedCallback?: () => void;

  constructor(objPool: ObjectPool<InnerFinishCallback>) {
    this._objPool = objPool;
  }

  /**
   * 设置超时回调
   *
   * @param waitTime 等待时间
   * @param finishedCallback 结束回调
   */
  public setTimeoutCallback(waitTime: number, finishedCallback: () => void): void {
    this._finishedCallback = finishedCallback;
    this._timeout = setTimeout(() => {
      log.showWarn('timeout finished.');
      this._timeout = 0;
      this.doFinish();
    }, waitTime);
  }

  getId(): number {
    return this._id;
  }

  finish(id: number): boolean {
    if (id === this._id) {
      log.showInfo('normal finished.');
      this.cancelTimeout();
      this.doFinish();
      return true;
    }
    return false;
  }

  recycle(): void {
    this.cancelTimeout();
    this._finishedCallback = undefined;
    this._id = InnerFinishCallback.generateId();
  }

  private doFinish(): void {
    if (!this._objPool.isReleased(this)) {
      this._finishedCallback?.();
      this._objPool.release(this);
    }
  }

  private cancelTimeout(): void {
    if (this._timeout !== 0) {
      clearTimeout(this._timeout);
      this._timeout = 0;
    }
  }
}

/**
 * 结束回调管理器
 */
class FinishCallbackManager implements Recyclable {
  private readonly _finishCallbackPool: ObjectPool<InnerFinishCallback>;
  private readonly _finishedCallback: () => void = (): void => {
    this._finished++;
    log.showInfo(`total ${this._total}, finished: ${this._finished}`);
    if (this._finished >= this._total) {
      log.showInfo('all finished.');
      this._allFinishedCallback?.();
    }
  };
  private _total: number = 0;
  private _finished: number = 0;
  private _allFinishedCallback?: () => void;
  private _finishCallbacks: Set<InnerFinishCallback> = new Set();

  constructor(finishCallbackPool: ObjectPool<InnerFinishCallback>) {
    this._finishCallbackPool = finishCallbackPool;
  }

  public recycle(): void {
    this._finishCallbacks.forEach(finishCallback => this._finishCallbackPool.release(finishCallback));
    this._finishCallbacks.clear();
    this._total = 0;
    this._finished = 0;
    this._allFinishedCallback = undefined;
  }

  public get isWaiting(): boolean {
    return this._total > 0 && this._finished < this._total;
  }

  public set allFinishedCallback(allFinishedCallback: () => void) {
    this._allFinishedCallback = allFinishedCallback;
  }

  /**
   * 产生结束回调
   *
   * @param waitTime 结束等待时间
   * @returns 结束回调
   */
  public buildFinishCallback(): InnerFinishCallback | undefined {
    let finishCallback: InnerFinishCallback | undefined = this._finishCallbackPool.acquire();
    if (!finishCallback) {
      log.showError('acquire finishCallback failed.');
    }
    return finishCallback;
  }

  /**
   * 增加结束回调
   *
   * @param finishCallback 结束回调
   */
  public addFinishCallback(waitTime: number, finishCallback: InnerFinishCallback | undefined): void {
    if (finishCallback) {
      this._total++;
      this._finishCallbacks.add(finishCallback);
      finishCallback.setTimeoutCallback(waitTime, this._finishedCallback);
    }
  }

  /**
   * 回收结束回到
   *
   * @param finishCallback 结束回调
   */
  public releaseFinishCallback(finishCallback: InnerFinishCallback | undefined): void {
    if (finishCallback) {
      this._finishCallbacks.delete(finishCallback);
      this._finishCallbackPool.release(finishCallback);
    }
  }
}

interface InitParams {
  persistentId: number,
  aodProxy: IAodProxy,
  oneMirrorStrategy: IOneMirrorStrategy,
}

/**
 * 一镜到底服务，掌控对AOD模块的启停，可通过注册观察者进行时机监听
 */
export class OneMirrorService extends AbstractObserverManager<OneMirrorListener> {
  private static sInstance: OneMirrorService;

  public static getInstance(): OneMirrorService {
    if (!OneMirrorService.sInstance) {
      OneMirrorService.sInstance = new OneMirrorService();
    }
    return OneMirrorService.sInstance;
  }

  private _persistentId: number = 0;
  private _aodProxy?: IAodProxy;
  private _mirrorStrategy?: IOneMirrorStrategy;
  private _isSupportWallpaperOneMirror: boolean = true; // 壁纸是否支持一镜到底，默认支持
  private _isAodShow: boolean = true; // 亮屏时，AOD是否显示状态，用以区分从黑屏态还是AOD态亮屏
  private _isFingerprintShow: boolean = true; // 仅用于标记亮屏时，指纹是否显示
  private _isHdrShowing: boolean = false;
  private _fsmProxy?: ScreenLockFsmProxy; // 状态机代理
  private readonly _finishCallbackPool: ObjectPool<InnerFinishCallback> =
    new ObjectPool(FINISH_CALLBACK_POOL_SIZE, () => new InnerFinishCallback(this._finishCallbackPool));
  private readonly _finishCallbackManagerPool: ObjectPool<FinishCallbackManager> =
    new ObjectPool(FINISH_CALLBACK_MANAGER_POOL_SIZE, () => new FinishCallbackManager(this._finishCallbackPool));
  private _waitFinishCallbackManager?: FinishCallbackManager;
  private _isAodSupportOneMirror = true;
  private clockAnimUnSubScribe?: unsubscribe;
  private clockAnimCallback?: InnerFinishCallback;
  private hdrChangeCallback?: InnerFinishCallback;
  private isPartAodOneMirror: boolean = false;
  private isSupportOffMirror: boolean = true;
  private noMirrorReason: string  = '';
  private _isScreenOffWakeUp: boolean = false;
  // 艺术签名做隔离依赖，功能适配好后移除
  private slClockBindState?: SlClockBindState;
  private readonly _aodSettingChangeListener = (): void => {
    log.showInfo('Aod setting data change');
    this._aodProxy?.checkAod();
  };

  private readonly _oobeStateChangeListener = (enable: boolean): void => {
    if (!enable) {
      this._aodProxy?.checkAod();
    }
  };

  private readonly _hdrStateListener = (): void => {
    this._isHdrShowing = sSettingsUtil.getValue(HDR_STATUS_SETTINGS, '0') !== '0';
    if (this._isHdrShowing) {
      SCBScreenSessionManager.getInstance().setScreenOffDelayTime(HDR_MAX_SCREEN_OFF_DELAY_TIME);
    } else {
      if (DeviceHelper.isSmallFoldProduct() && DeviceHelper.isSubDisplayMode()) {
        SCBScreenSessionManager.getInstance().setScreenOffDelayTime(LEM_MAX_SCREEN_OFF_DELAY_TIME);
      } else {
        SCBScreenSessionManager.getInstance().setScreenOffDelayTime(MAX_SCREEN_OFF_DELAY_TIME);
      }
    }
    if (this.hdrChangeCallback && !this._isHdrShowing) {
      log.showInfo('hdr callback');
      const finishId: number = this.hdrChangeCallback.getId();
      this.hdrChangeCallback.finish(finishId);
    }
  };

  private readonly _screenOnOffListener: ScreenOnOffListener = {
    onBeginWakeUp: (reason: WakeUpReason): void => {
      this._isScreenOffWakeUp = false;
      this._isAodShow = false;
      this._isFingerprintShow = false;
      this.prepareHideScreenLockView();
      log.showInfo(`isAodShow ${this._isAodShow}, isFingerprintShow: ${this._isFingerprintShow}`);
      this.wakeUpSyncThemeEnginState(reason);
      this.handleScreenOnResult(reason);
      SettingsUtil.setValue(AOD_HDR_STATUS_KEY, '0');
    },
    onPreBeginSleep: (reason: SleepReason): void => {
      // 通知双中心退出
      DoubleCenterHelper.getInstance().exitDoubleCenter();
      this.sleepSyncThemeEnginState(reason);
      this._aodProxy?.updateTPState(true);
      this._aodProxy?.checkAod();
      if (!this.isSupportScreenOffToEnd()) {
        log.showInfo('no need to end anim NOTIFY_OFF_SCREEN_CLOSE_LCD');
        SCBScreenSessionManager.getInstance().notifyScreenLockEvent(PowerUtils.NOTIFY_OFF_SCREEN_CLOSE_LCD);
      }
      SettingsUtil.setValue(AOD_HDR_STATUS_KEY, '1');
    }
  };

  /**
   * 不显示AOD情况下，亮屏到锁屏需要提前隐藏锁屏元素
   */
  private prepareHideScreenLockView(): void {
    // 亮屏第一帧需要隐藏条件: 全屏AOD，自定义AOD不显示AOD情况下
    // 全部局部AOD亮屏前都需要隐藏
    const isAodThemeSupport: boolean = this.isSupportFullMirror();
    if (this._isAodShow && isAodThemeSupport ||
      (this._fsmProxy && CoreStateTypeUtils.isUnlockState(this._fsmProxy?.coreFsm.currentStateType))) {
      // AOD 显示或者已经解锁,不需要隐藏
      return;
    }
    // 黑屏到锁屏场景，需要在亮屏前隐藏锁屏
    this.broadcastDataChange(observer => {
      if (!observer?.onMirrorScene) {
        return;
      }
      log.showWarn('hideScreenLockView');
      observer.onMirrorScene(MirrorScene.AOD, MirrorScene.SCREEN_OFF, true);
      this._isScreenOffWakeUp = true;
    });
  }

  private readonly _screenLockThemeChangeListener = (): void => {
    this._isSupportWallpaperOneMirror = (ThemeHelperUtil.getLockManifest().type === 'longTake' ||
      ThemeHelperUtil.getLockManifest().type === 'image');
    log.showInfo(`isSupportWallpaperOneMirror: ${this._isSupportWallpaperOneMirror}`);
  };

  private readonly _coreFsmStatChangeListener: FsmCallback<CoreStateType, CoreEvent> = {
    onFsmStateChange: (oldState: CoreStateType, newState: CoreStateType): void => {
      log.showInfo(`onFsmStateChange: ${CoreStateType[oldState]} --> ${CoreStateType[newState]}`);
      this._aodProxy?.checkAod();
      this.triggerOneMirrorAction(oldState, newState);
      log.showInfo('onFsmStateChange end');
    }
  };

  private constructor() {
    super();
  }

  /**
   * AOD是否处于显示状态
   *
   * @returns AOD是否处于显示状态
   */
  public isAodShowing(): boolean {
    return this._isAodShow;
  }

  /**
   * 亮屏时，指纹是否显示
   *
   * @returns 是否显示
   */
  public isFingerprintShowing(): boolean {
    return this._isFingerprintShow;
  }

  protected doInit(initParams?: InitParams): void {
    this._aodProxy = initParams?.aodProxy;
    this._persistentId = initParams?.persistentId ?? 0;
    this._mirrorStrategy = initParams?.oneMirrorStrategy;
    this._fsmProxy = ScreenLockFsmProxy.getInstance(this._persistentId);
    this._aodProxy?.checkAod();
    if (this._aodProxy) {
      OneMirrorAodProxy.getInstance().doInit(this._aodProxy);
    }
    const clockAdapter: ClockAdapter = ClockAdapterFactory.wrapper(UseScene.MAIN_PAGE);
    this.slClockBindState = clockAdapter.getDataManager().getSlClockBindState();

    // 监听AOD状态变化
    sEventManager.subscribe(AOD_ENABLE_STATE_CHANGE, this._aodSettingChangeListener);

    // OOBE阶段AOD不可用，为避免状态错误，退出OOBE时需要重新刷新AOD状态
    sEventManager.subscribe(OOBE_CHANGE_EVENT, this._oobeStateChangeListener);

    // 监听主题变化
    EvtBus.on(ScreenLockThemeChangeEvent, this._screenLockThemeChangeListener);

    DataShareManager.getInstance().registerDataShareListener(HDR_STATUS_SETTINGS, this._hdrStateListener);

    // 监听亮灭屏事件
    ScreenOnOffService.getInstance().registerObserver(this._screenOnOffListener);

    // 监听核心状态机事件
    this._fsmProxy.coreFsm.registerObserver(this._coreFsmStatChangeListener, false, false);

    OneMirrorAodStateMonitor.getIns().doInit();
  }

  protected doRelease(): void {
    sEventManager.off(AOD_ENABLE_STATE_CHANGE, this._aodSettingChangeListener);

    sEventManager.off(OOBE_CHANGE_EVENT, this._oobeStateChangeListener);

    EvtBus.off(ScreenLockThemeChangeEvent, this._screenLockThemeChangeListener);

    DataShareManager.getInstance().unregisterDataShareListener(HDR_STATUS_SETTINGS);

    // 清除时钟动效订阅服务
    this.clearClockAnimUnSubScribe();

    this._finishCallbackPool.destroy();

    // 取消监听亮灭屏事件
    ScreenOnOffService.getInstance().unRegisterObserver(this._screenOnOffListener);

    // 取消监听核心状态机事件
    this._fsmProxy?.coreFsm.unRegisterObserver(this._coreFsmStatChangeListener);

    OneMirrorAodStateMonitor.getIns().doRelease();
  }

  /**
   * 由于主题管理没有监听电源事件，重新亮屏时，状态无法恢复，依赖锁屏模块发定制消息进行状态同步（有可能是主题管理监听不到电源早期事件）
   */
  private wakeUpSyncThemeEnginState(reason: WakeUpReason): void {
    log.showInfo('wakeUpSyncThemeEnginState');

    if (this._fsmProxy?.coreFsm.currentStateType &&
      !CoreStateTypeUtils.isScreenOnState(this._fsmProxy?.coreFsm.currentStateType) ||
      reason === WakeUpReason.PROXIMITY) {
      this.performWallpaperAnim(DynamicWallPaperState.DEFAULT, DynamicWallPaperState.SCREEN_ON, false);
    }

    if (reason === WakeUpReason.PROXIMITY || ScreenOnOffService.getInstance().sleepReason ===  SleepReason.PROXIMITY) {
      this.performWallpaperAnim(DynamicWallPaperState.PROXIMITY_SCREEN_OFF, DynamicWallPaperState.PROXIMITY_SCREEN_ON,
        false);
    }
  }

  private sleepSyncThemeEnginState(reason: SleepReason): void {
    log.showInfo('sleepSyncThemeEnginState');
    if (reason === SleepReason.PROXIMITY) {
      this.performWallpaperAnim(DynamicWallPaperState.PROXIMITY_SCREEN_ON, DynamicWallPaperState.PROXIMITY_SCREEN_OFF,
        false);
    }
  }

  private onScreenOffFpUnlockSuccess(oldState: CoreStateType, newState: CoreStateType): boolean {
    if (oldState === CoreStateType.SCREEN_OFF_MP_LOCK_STATE && newState === CoreStateType.SCREEN_OFF_UNLOCK_STATE) {
      let reason: string = '';
      if (this.isClockOneShotAnimAvailableOnScreenOffFp()) {
        // 全局AOD显示态，需要做时钟一镜到底动效
        log.showInfo('config aod to desktop clock animation.');
        reason = ClockOneShortConsts.AOD_TO_DESKTOP_CLOCK_ANIMATION;
      } else {
        log.showInfo('config screen off direct unlock animation.');
      }
      slClockOneShotToDesktopService.requestDirectUnlock(reason);
      return true;
    }
    return false;
  }

  public isClockOneShotAnimAvailableOnScreenOffFp(): boolean {
    const isAodSupport = this.isSupportConsumerMirror() || this.isSupportFullMirror();
    return isAodSupport &&
    slClockOneShotToDesktopService.isClockOneShotAnimAvailable();
  }

  private triggerOneMirrorAction(oldState: CoreStateType, newState: CoreStateType): void {
    if (this.onScreenOffFpUnlockSuccess(oldState, newState)) {
      return;
    }
    let oldMirrorScene: MirrorScene = this.getMirrorSceneFromCoreState(oldState);
    let newMirrorScene: MirrorScene = this.getMirrorSceneFromCoreState(newState);
    if (oldMirrorScene === newMirrorScene) {
      this.recoverSlElemState(newMirrorScene);
      return;
    }
    log.showInfo(`triggerOneMirrorAction ${MirrorScene[oldMirrorScene]} -> ${MirrorScene[newMirrorScene]}.`);
    if (MirrorSceneUtils.isScreenOffScene(oldMirrorScene) && MirrorSceneUtils.isScreenOffScene(newMirrorScene)) {
      // 自动修正场景，无须下发切换
      log.showInfo(`triggerOneMirrorAction not need performSceneChange.`);
      return;
    }

    this.isSupportOffMirror = this.isSupportScreenOffToEnd(true);
    this.performSceneChange(oldMirrorScene, newMirrorScene, this.isNeedOneMirrorAnim(oldState, newState));
  }

  private getMirrorSceneFromCoreState(stateType: CoreStateType): MirrorScene {
    if (CoreStateTypeUtils.isScreenOffState(stateType)) {
      return MirrorScene.SCREEN_OFF;
    } else if (CoreStateTypeUtils.isInUnlockPage(stateType)) {
      return MirrorScene.UNLOCK;
    } else if (CoreStateTypeUtils.isAodState(stateType)) {
      return MirrorScene.AOD;
    } else {
      return MirrorScene.SCREEN_LOCK;
    }
  }

  private isNeedOneMirrorAnim(oldState: CoreStateType, newState: CoreStateType): boolean {
    switch (this.getMirrorSceneFromCoreState(newState)) {
      case MirrorScene.AOD:
        const hasExtraScreenOffAnimStrategy: boolean = this._mirrorStrategy?.hasExtraScreenOffAnim() ?? false;
        if (CoreStateTypeUtils.isScreenOnState(oldState) && hasExtraScreenOffAnimStrategy) {
          // 小折叠场景熄屏，需要启动一镜到底
          return true;
        }
        if (!this.isSupportOffMirror) {
          return false;
        }
        if (OccludedStateManager.getInstance().isWindowOccluded) {
          this.updateNoMirrorReason(true, NoMirrorReason.WINDOW_OCCLUDED);
          return false;
        }
        if (this.isSlPageSupportOffMirror(oldState)) {
          // screen_lock -> aod
          return true;
        }
        if (CoreStateTypeUtils.isInUnlockPage(oldState)) {
          // unlock -> aod
          return true;
        }
        break;
      case MirrorScene.SCREEN_LOCK:
        if (!this.isSupportScreenOnToEnd() || OccludedStateManager.getInstance().isWindowOccluded ||
          this.isSlideFromAOD(oldState, newState)) {
          return false;
        }
        return true;
      case MirrorScene.UNLOCK:
        return true;
      default:
        break;
    }
    return false;
  }

  /**
   * 判断核心状态机迁移是否为AOD上划进入密码页
   *
   * @param oldState 旧状态
   * @param newState 新状态
   * @returns 是否为AOD上划进入密码页
   */
  private isSlideFromAOD(oldState: CoreStateType, newState: CoreStateType): boolean {
    return (oldState === CoreStateType.SCREEN_OFF_PWD_CHECK_STATE &&
      newState === CoreStateType.BOUNCER_TO_UNLOCK_STATE);
  }

  /**
   * 存在黑屏到亮屏时，亮屏第一帧隐藏了锁屏，需要恢复锁屏元素显示
   */
  private recoverSlElemState(toMirrorScene: MirrorScene): void {
    if (toMirrorScene !== MirrorScene.SCREEN_LOCK) {
      log.showDebug(' toScene is not screen lock');
      return;
    }
    if (!this._isScreenOffWakeUp) {
      log.showDebug('aod screen on, no need recover');
      return;
    }
    this.broadcastDataChange(observer => {
      if (!observer?.onMirrorScene) {
        log.showWarn('recoverSlElemState failed');
        return;
      }
      log.showWarn('recoverSlElemState');
      observer.onMirrorScene(MirrorScene.SCREEN_OFF, MirrorScene.SCREEN_LOCK, false);
      this._isScreenOffWakeUp = false;
    });
  }

  /**
   * 锁屏页面是否支持灭屏一镜到底
   * @param oldState 状态机状态
   * @returns boolean
   */
  private isSlPageSupportOffMirror(oldState: CoreStateType): boolean {
    if (CoreStateTypeUtils.isInMainPage(oldState)) {
      // 锁屏主页
      return true;
    }
    if (CoreStateTypeUtils.isInNormalBounce(oldState)) {
      // 锁屏密码页面
      return true;
    }
    return false;
  }

  /**
   * 执行一镜到底动效
   *
   * @param fromScene 开始场景
   * @param toScene 目标场景
   * @param hasAnim 是否有一镜到底动效
   */
  private performSceneChange(fromScene: MirrorScene, toScene: MirrorScene, hasAnim: boolean): void {
    // 每次动效开始前进行缓存
    this._isAodSupportOneMirror = this.isConfigSupportAod();
    let realFromScene = this.getRealScene(fromScene, true, this._isAodSupportOneMirror);
    let realToScene = this.getRealScene(toScene, false, this._isAodSupportOneMirror);
    let realHasAnim = hasAnim && realToScene !== MirrorScene.SCREEN_OFF;
    log.showInfo(`performSceneChange: [${MirrorScene[realFromScene]} -> ${MirrorScene[realToScene]} ${realHasAnim}]`);
    if (realFromScene === realToScene) {
      log.showWarn(`the same scene ${MirrorScene[realToScene]}, not need perform.`);
      this.recoverSlElemState(realToScene);
      return;
    }
    this.performSceneChangeInner(realFromScene, realToScene, realHasAnim);
    if (toScene === MirrorScene.AOD && !realHasAnim) {
      //不播一镜到底动效
      log.showWarn(`noMirrorReason: ${this.noMirrorReason}`);
      const param: NoMirrorReasonParams = {
        noMirrorReason: this.noMirrorReason
      }
      PerformanceMonitorUtil.reportNoMirrorReasonEvent(param)
    }
    this.noMirrorReason = '';
  }

  /**
   * 状态机上AOD属于过渡态，亮屏默认从SCREEN_OFF触发，熄屏默认先到AOD态
   *
   * @param mirrorScene 原始场景
   * @param isFromScene 是否开始场景
   * @returns 真实场景
   */
  private getRealScene(mirrorScene: MirrorScene, isFromScene: boolean, isConfigSupportAod: boolean): MirrorScene {
    switch (mirrorScene) {
      case MirrorScene.SCREEN_OFF:
        if (this._isAodShow && isFromScene && isConfigSupportAod) {
          log.showInfo(`full aod is show, change screen_off to aod.`);
          return MirrorScene.AOD;
        }
        break;
      case MirrorScene.AOD:
        if (!isConfigSupportAod) {
          log.showInfo(`not support aod, change aod to screen_off.`);
          return MirrorScene.SCREEN_OFF;
        }
        break;
      default:
        break;
    }
    return mirrorScene;
  }

  private performSceneChangeInner(fromScene: MirrorScene, toScene: MirrorScene, hasAnim: boolean): void {
    let finishCallbackManager: FinishCallbackManager | undefined = this._finishCallbackManagerPool.acquire();
    if (!finishCallbackManager) {
      log.showError(`acquire fcm failed: ${MirrorScene[fromScene]} -> ${MirrorScene[toScene]} hasAnim: ${hasAnim}`);
      return;
    }

    if (!hasAnim || toScene !== MirrorScene.AOD) {
      // 不播一镜到底场景，只是先下电，等锁屏绘制完成再进入AOD
      this.handleResult(fromScene, toScene, false, false);
    }

    // 执行导航条消失与出现
    this.handleNavBarUpdate(fromScene, toScene);
    // 执行时钟样式切换
    this.handleClockAnimSceneChange(fromScene, toScene, hasAnim, finishCallbackManager);
    // 执行壁纸场景切换
    if (this.isPartAodOneMirror && toScene === MirrorScene.AOD) {
      this._aodProxy?.getAodLayerInfo(false).then((aodPosition: AodElemPosition) => {
        themeWallpaperAniMgr.syncAodPosition(aodPosition);
        if (!finishCallbackManager) {
          log.showError(TAG, `acquire callback failed`);
          return;
        }
        this.handleWallpaperSceneChange(fromScene, toScene, hasAnim, finishCallbackManager);
      });
    } else {
      this.handleWallpaperSceneChange(fromScene, toScene, hasAnim, finishCallbackManager);
    }

    // 执行桌面场景切换
    this.handleScreenLockSceneChange(fromScene, toScene, hasAnim, finishCallbackManager);

    // 取消还没有执行完的回调
    if (this._waitFinishCallbackManager) {
      log.showInfo(`cancelhandleResult: ${MirrorScene[fromScene]} -> ${MirrorScene[toScene]} hasAnim: ${hasAnim}`);
      this._finishCallbackManagerPool.release(this._waitFinishCallbackManager);
      this._waitFinishCallbackManager = undefined;
    }

    if (finishCallbackManager.isWaiting && hasAnim && toScene === MirrorScene.AOD) {
      // 需要等待动效播放完成后，才能进入AOD
      log.showInfo('notifyScreenOffTransition');
      SCBTransitionManager.getInstance().notifyScreenOffTransition();
      finishCallbackManager.allFinishedCallback = (): void => {
        if (this._waitFinishCallbackManager === finishCallbackManager) {
          this.handleResult(fromScene, toScene, true, true);
          this._waitFinishCallbackManager = undefined;
        }
        if (finishCallbackManager) {
          this._finishCallbackManagerPool.release(finishCallbackManager);
        }
        this.clearClockAnimUnSubScribe();
        this.hdrChangeCallback = undefined;
      };
      this._waitFinishCallbackManager = finishCallbackManager;
    } else {
      // 直接执行结果
      this.handleResult(fromScene, toScene, false, true);
      this._finishCallbackManagerPool.release(finishCallbackManager);
      this.clearClockAnimUnSubScribe();
      this.hdrChangeCallback = undefined;
    }
  }

  private clearClockAnimUnSubScribe(): void {
    this.clockAnimUnSubScribe?.();
    this.clockAnimUnSubScribe = undefined;
    this.clockAnimCallback = undefined;
  }

  private handleClockAnimSceneChange(fromScene: number, toScene: number, isPlayAnim: boolean,
    finishCallbackManager: FinishCallbackManager): void {
    if (!(fromScene === MirrorScene.UNLOCK && toScene === MirrorScene.AOD) || !isPlayAnim) {
      log.showDebug('handleClockMoveSceneChange scene not satisfied');
      return;
    }
    const clockAnimType: ClockDeskTop2AodAnimType | undefined =
      slUiStateMgr.getSlState(SlMainStateType.SL_CLOCK_WG_STATIC_STATE)?.getSlState(
        ClockStaticStateType.DESKTOP_TO_AOD_ANIM_TYPE) as ClockDeskTop2AodAnimType;
    if (!clockAnimType || clockAnimType === ClockDeskTop2AodAnimType.NONE) {
      log.showInfo('not satisfied desktopToAod animation');
      return;
    }
    if (this.clockAnimCallback) {
      log.showInfo(`handleClockMoveSceneChange clockAnimCallback exist ${this.clockAnimCallback?.getId()}`);
      this.clockAnimCallback?.finish(this.clockAnimCallback?.getId());
      this.clearClockAnimUnSubScribe();
    }
    this.clockAnimCallback = finishCallbackManager.buildFinishCallback();
    finishCallbackManager.addFinishCallback(FINISH_CALLBACK_CLOCK_ANIM_WAIT_MILLIS, this.clockAnimCallback);
    log.showInfo(`handleClockMoveSceneChange clockAnimType:${clockAnimType}  finishId:${this.clockAnimCallback?.getId()}`);
    this.clockAnimUnSubScribe = sEventManager.subscribe(ScreenLockToDesktopConsts.DESKTOP_TO_AOD_ANIM_FINISHED, () => {
      log.showInfo(`handleClockMoveSceneChange subscribe:${this.clockAnimCallback?.getId()}`);
      this.clockAnimCallback?.finish(this.clockAnimCallback?.getId());
    });
  }

  private handleWallpaperSceneChange(fromScene: number, toScene: number, isPlayAnim: boolean,
    finishCallbackManager: FinishCallbackManager): void {
    let isImmersive = immersiveKgMgr.getImmersiveDisplayState().isImmersive();
    if (fromScene === MirrorScene.UNLOCK && toScene === MirrorScene.AOD) {
      // 桌面到AOD场景还是需要播放动效来过渡, 桌面时不处于沉浸态,需要作为非沉浸态
      isImmersive = false;
    }
    const needWppAnimStrategy: boolean = this._mirrorStrategy?.needWallpaperAnim() ?? true;
    log.showInfo(`oneMirrorStrategy:${this._mirrorStrategy?.getName()} needWppAnimStrategy:${needWppAnimStrategy}`);
    let isAnimByWallpaper = !isImmersive && isPlayAnim && needWppAnimStrategy;
    let finishCallback: InnerFinishCallback | undefined =
      isAnimByWallpaper ? finishCallbackManager.buildFinishCallback() : undefined;
    if (finishCallback) {
      finishCallbackManager.addFinishCallback(FINISH_CALLBACK_WAIT_MILLIS, finishCallback);
    }
    this.performWallpaperAnim(fromScene, toScene, isAnimByWallpaper, (): void => {
      if (finishCallback) {
        let finishId: number = finishCallback?.getId();
        finishCallback?.finish(finishId);
      }
      if (fromScene === MirrorScene.SCREEN_LOCK && toScene === MirrorScene.UNLOCK) {
        SCBDesktopCacheManager.getInstance().screenUnlockAnimationFinish();
      }
    });
  }

  private performWallpaperAnim(fromScene: number, toScene: number, isPlayAnim: boolean, callback?: Function): void {
    this.reportPerformanceIfNeed(toScene, true);
    log.showInfo(`wallpaper animation begin: ${this.generateWallpaperAnimLog(fromScene, toScene, isPlayAnim)}`);
    themeWallpaperAniMgr.reqPlayWallpaperAnimation({
      curState: fromScene,
      tarState: toScene,
      isOffScreenSupportAod: this._isAodSupportOneMirror, // 当前确认，此字段壁纸不会用到
      onFinish: () => {
        this.reportPerformanceIfNeed(toScene, false);
        log.showInfo(`wallpaper animation end: ${this.generateWallpaperAnimLog(fromScene, toScene, isPlayAnim)}`);
        callback?.();
      },
      isPlayingAnimation: isPlayAnim,
      isSafeMode: this.isSafeModeState(fromScene, toScene)
    });
    this.reportWallpaperChangeEvent(fromScene, toScene, isPlayAnim);
  }

  private isSafeModeState(fromScene: number, toScene: number): boolean {
    let isLock2Unlock = (fromScene === MirrorScene.SCREEN_LOCK && toScene === MirrorScene.UNLOCK);
    return isLock2Unlock;
  }

  private reportWallpaperChangeEvent(fromScene: number, toScene: number, isPlayAnim: boolean): void {
    if (toScene === MirrorScene.SCREEN_LOCK || toScene === MirrorScene.UNLOCK) {
      PerformanceMonitorUtil.reportWallpaperChangeEvent({
        curState: fromScene,
        tarState: toScene,
        isPlayingAnim: isPlayAnim
      });
    }
  }

  private generateWallpaperAnimLog(fromScene: number, toScene: number, isPlayAnim: boolean): string {
    return `${MirrorScene[fromScene]}(${fromScene}) -> ${MirrorScene[toScene]}(${toScene}) isPlayAnim: ${isPlayAnim}`;
  }

  private handleScreenLockSceneChange(fromScene: MirrorScene, toScene: MirrorScene, hasAnim: boolean,
    finishCallbackManager: FinishCallbackManager): void {
    this.broadcastDataChange(observer => {
      if (!observer?.onMirrorScene) {
        return;
      }
      this._isScreenOffWakeUp = false;
      if (!hasAnim) {
        observer.onMirrorScene(fromScene, toScene, hasAnim);
      } else {
        let finishCallback: InnerFinishCallback | undefined = finishCallbackManager.buildFinishCallback();
        if (observer.onMirrorScene(fromScene, toScene, hasAnim, finishCallback)) {
          finishCallbackManager.addFinishCallback(SL_FINISH_CALLBACK_WAIT_MILLIS, finishCallback);
        } else {
          finishCallbackManager.releaseFinishCallback(finishCallback);
        }
      }
    });
  }

  private handleHdrSceneChange(toScene: MirrorScene, hasAnim: boolean,
    finishCallbackManager: FinishCallbackManager): void {
    if (toScene !== MirrorScene.AOD || !hasAnim || !this._isHdrShowing) {
      return;
    }
    let finishCallback: InnerFinishCallback | undefined = finishCallbackManager.buildFinishCallback();
    if (finishCallback) {
      finishCallbackManager.addFinishCallback(FINISH_CALLBACK_WAIT_MILLIS, finishCallback);
    }
    this.hdrChangeCallback = finishCallback;
  }


  private handleNavBarUpdate(fromScene: MirrorScene, toScene: MirrorScene): void {
    if (this._aodProxy?.isPartAodPlayMirror()) {
      if (!MirrorSceneUtils.isScreenOffScene(fromScene) && MirrorSceneUtils.isScreenOffScene(toScene)) {
        // 灭屏导航条消失
        NavBarHideAndShowManager.getInstance().executeCallbackByType(TAG, false);
      } else {
        // 亮屏导航条出现
        NavBarHideAndShowManager.getInstance().executeCallbackByType(TAG, true);
      }
    }
  }

  private handleResult(fromScene: MirrorScene, toScene: MirrorScene, needToEndAnim: boolean,
    needStartAod: boolean): void {
    log.showInfo(`handleResult: ${MirrorScene[fromScene]} -> ${MirrorScene[toScene]} needToEndAnim: ${needToEndAnim}`);
    if (!MirrorSceneUtils.isScreenOffScene(fromScene) && MirrorSceneUtils.isScreenOffScene(toScene)) {
      this.handleScreenOffResult(needToEndAnim, needStartAod);
    } else {
      log.showInfo('no need handleResult.');
    }
  }

  private handleScreenOnResult(reason: WakeUpReason): void {
    OneMirrorAodProxy.getInstance().stopAodEnter();
    this.broadcastDataChange(callback => callback?.onPostStopAod?.(reason));
  }

  private handleScreenOffResult(needToEndAnim: boolean, needStartAod: boolean): void {
    if (KeyguardStatusService.isCoverMode()) {
      log.showInfo('cover is add on, not start aod');
      SCBScreenSessionManager.getInstance().notifyScreenLockEvent(PowerUtils.NOTIFY_OFF_SCREEN_CLOSE_LCD);
      return;
    }

    // 只有场景和配置同时满足时，才执行一镜到底动效
    let isSupportOneMirror: boolean = needToEndAnim && this.isSupportOffMirror;
    const forceIntoAodStrategy: boolean = this.getForceIntoAodStrategy();
    if (needStartAod && (this.isConfigSupportStartAod() || forceIntoAodStrategy)) {
      OneMirrorAodProxy.getInstance().startAodEnter(isSupportOneMirror, forceIntoAodStrategy);
    }

    if ((!isSupportOneMirror && !forceIntoAodStrategy) || this.isPartAodOneMirror) {
      // 不支持一镜到底时，关闭屏幕
      log.showInfo('handleScreenOffResult no need to end anim NOTIFY_OFF_SCREEN_CLOSE_LCD.');
      SCBScreenSessionManager.getInstance().notifyScreenLockEvent(PowerUtils.NOTIFY_OFF_SCREEN_CLOSE_LCD);
    }
  }

  /**
   * 配置是否支持开启AOD
   *
   * @returns 是否支持开启AOD
   */
  private isConfigSupportStartAod(): boolean {
    return !!this._aodProxy && (this._aodProxy.isAODEnable() || this._aodProxy.isFingerprintEnable());
  }

  /**
   * 配置是否支持一镜到底
   *
   * @returns 是否支持一镜到底
   */
  public isConfigSupportToEnd(): boolean {
    if (!this.isSupportScreenOffToEnd()) {
      return false;
    }
    return this.isWallpaperSupportToEnd() && this.isConfigSupportAod() && !this._aodProxy?.isAodDataInValid();
  }

  /**
   * 灭屏动画不支持场景
   * @returns boolean
   */
  public isSupportScreenOffToEnd(needRecordReason: boolean = false): boolean {
    if (!this.isWallpaperSupportToEnd()) {
      // 壁纸不支持一镜到底动画
      this.updateNoMirrorReason(needRecordReason, NoMirrorReason.WALLPAPER);
      return false;
    }

    if (this._aodProxy?.isAodDataInValid()) {
      // AOD 数据异常
      this.updateNoMirrorReason(needRecordReason, NoMirrorReason.AOD_INVALID);
      return false;
    }

    if (!this.isSupportSlStatusToEnd()) {
      this.updateNoMirrorReason(needRecordReason, NoMirrorReason.SL_SPECIAL_MODEL);
      return false;
    }

    if (!this.isConfigSupportAod()) {
      this.updateNoMirrorReason(needRecordReason, NoMirrorReason.AOD_STYLE);
      return false;
    }

    if (this._isHdrShowing) {
      log.showWarn('is hdr showing, disable screen to end');
      this.updateNoMirrorReason(needRecordReason, NoMirrorReason.HDR);
      return false;
    }

    return true;
  }

  private updateNoMirrorReason(needRecordReason: boolean, reason: NoMirrorReason): void {
    this.noMirrorReason = needRecordReason ? reason.valueOf() : '';
  }

  /**
   * 亮屏动画不支持场景
   * @returns boolean
   */
  public isSupportScreenOnToEnd(): boolean {
    if (!this.isSupportSlStatusToEnd()) {
      return false;
    }
    if (this.isOnlineMixAod()) {
      log.showWarn('aod not support disable screen to end');
      return false;
    }
    return true;
  }

  /**
   * 锁屏状态不支持一镜到底场景
   * @returns boolean
   */
  private isSupportSlStatusToEnd(): boolean {
    if (KeyguardStatusService.isCoverMode()) {
      log.showWarn('cover model, disable screen to end');
      return false;
    }

    if (KeyguardStatusService.isSpecialMode()) {
      log.showWarn('Special model, disable screen to end');
      return false;
    }

    if (SimCardStateManager.getInstance().isSimLocked()) {
      log.showWarn('sim locked, disable screen to end');
      return false;
    }
    return true;
  }

  /**
   * 壁纸是否支持一镜到底
   *
   * @returns 是否支持一镜到底
   */
  public isWallpaperSupportToEnd(): boolean {
    return this._isSupportWallpaperOneMirror && (DeviceHelper.isPhone() || DeviceHelper.isPadOr2in1PcType());
  }

  /**
   * 配置是否支持到假AOD态（假AOD态才支持一镜到底）
   *
   * @returns 是否支持假AOD态
   */
  private isConfigSupportAod(): boolean {
    this.isPartAodOneMirror = this.isSupportPartMirror();
    return this.isSupportFullMirror() || this.isPartAodOneMirror || this.getForceIntoAodStrategy();
  }

  private isSupportFullMirror(): boolean {
    return !!this._aodProxy && this._aodProxy.isAODEnable() && this._aodProxy.isFullAodPlayMirror();
  }

  private isSupportPartMirror(): boolean {
    if (this._aodProxy === undefined) {
      return false;
    }
    if (!this._aodProxy.isAODEnable()) {
      return false;
    }
    return this._aodProxy.isPartAodPlayMirror();
  }

  /**
   * 是否支持局部自定义一镜到底
   * @returns
   */
  public isSupportConsumerMirror(): boolean {
    if (this.slClockBindState === undefined || this._aodProxy === undefined) {
      return false;
    }

    return this._aodProxy.isPartMirrorAod();
  }

  private isOnlineMixAod(): boolean {
    return !!this._aodProxy && this._aodProxy.isOnlineMixAod();
  }

  /**
   * 获取灭屏后是否强制进AOD策略
   *
   * @returns true，灭屏后强制进AOD
   */
  private getForceIntoAodStrategy(): boolean {
    return this._mirrorStrategy?.forceIntoAod() ?? false;
  }

  public reportPerformanceIfNeed(target: DynamicWallPaperState, isStart: boolean): void {
    if (target === DynamicWallPaperState.AOD) {
      if (isStart) {
        PerformanceMonitorUtil.setScreenSleepMoStart();
      } else {
        PerformanceMonitorUtil.setScreenSleepMoEnd();
      }
    }
  }

  /**
   * 将壁纸状态设置为AOD
   */
  public setWallpaperStateToAod(): void {
    this.performWallpaperAnim(DynamicWallPaperState.DEFAULT, DynamicWallPaperState.AOD, false);
  }
}