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

import commonEventManager from '@ohos.commonEventManager';
import { AnimateToScheduleUtils, DomainName, LogDomain, LogHelper, Trace, TraceUtil } from '@ohos/basicutils';
import {
  HiDfxEventUtil,
  HiSysEventUtil,
  ViewManagerPolicy,
  sSettingsUtil,
  ViewType,
  ApsUtils,
} from '@ohos/frameworkwrapper';
import {
  SCBSceneSessionManager,
  SCBTransitionManager,
  sSCBOobeManager,
  sSCBOtaManager
} from '@ohos/windowscene';
import CommonConstants from '../constants/CommonConstants';
import { immersiveKgMgr } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { AbstractObserverManager } from '../base/AbstractObserverManager';
import { OneMirrorStaticStateType, SlMainStateType, SlStaticStateType } from '../constants/SlStateType';
import DrawDoneManager from '../manager/DrawDoneManager';
import {
  LockState,
  LockStateInfo,
  PageState,
  ScreenLockStateChangeListener,
  ScreenLockStateManager
} from '../manager/ScreenLockStateManager';
import { slUiStateMgr } from '../manager/ScreenLockUiStateManager';
import { VerifyDataManager } from '../manager/VerifyDataManager';
import { AccountHelper, AuthType } from '../utils/AccountHelper';
import { DoubleCenterHelper } from '../utils/DoubleCenterHelper';
import { FingerAuthReportHelper } from '../utils/FingerAuthReportHelper';
import { LockEventType, SlServerHelper, AuthState, LockOperateResult } from '../utils/SlServerHelper';
import { SlUnlockReportHelper } from '../record/report/SlUnlockReportHelper';
import { SystemParamUtils } from '../utils/SystemParamUtils';
import { ScreenLockVerifyService } from './ScreenLockVerifyService';
import { UserSwitchService } from './UserSwitchService';
import { DfxFaultEventTag, HiKGReportBase } from '../record/report/PerformanceMonitorUtil';
import slClockOneShotToDesktopService from '../base/SlClockOneShotToDesktopService';
import { TraceTag } from '../record/trace/TraceTag';
import { SLAutoTestService } from './autoTest/SLAutoTestService';
// import apsManager from '@hms.graphic.apsManager';

const TAG = 'ScreenLockUnlockService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const SET_TIMEOUT_DELAY: number = 1100;
const SCREEN_LOCK_BOOT: string = 'ScreenLock_VoteDevice_Boot_Completed';

/**
 * 事件名称
 */
enum EventName {
  LOCK_SCREEN = 'common.event.LOCK_SCREEN',
  UNLOCK_SCREEN = 'common.event.UNLOCK_SCREEN',
  SCREEN_LOCK_BOOT_COMPLETED = 'common.event.SCREENLOCK_BOOT_COMPLETED',
}

/**
 * 上锁解锁事件回调
 */
export interface LockUnlockCallback {
  /**
   * 成功时回调
   */
  success?: Function;

  /**
   * 认证成功并收到result时回调（代表此时文件解密成功）
   */
  authResultSuccess?: Function;

  /**
   * 取消时回调
   */
  cancel?: Function;

  /**
   * 失败时回调
   */
  fail?: Function;
}

/**
 * 处理结果
 */
export enum HandleResult {
  /**
   * 成功
   */
  SUCCESS,

  /**
   * 认证成功并收到result时回调（代表此时文件解密成功）
   */
  AUTH_RESULT_SUCCESS,

  /**
   * 失败
   */
  FAIL,

  /**
   * 取消
   */
  CANCEL,

  /**
   * 等待解锁中
   */
  WAITING,
}

/**
 * 请求上锁，解锁事件处理者
 */
export interface LockUnlockRequestHandler {
  /**
   * 解锁请求
   *
   * @param callback 请求解锁回调
   */
  onRequestUnlock: (callback?: (result: HandleResult) => void) => void;

  /**
   * 请求上锁
   */
  onRequestLock: () => void;
}

/**
 * 解锁上锁监听
 */
export interface LockUnlockListener {
  /**
   * 锁屏窗口显示前回调
   */
  onPreLockPageShow?: () => void;

  /**
   * 解锁前回调
   */
  onPreUnlock?: () => void;

  /**
   * 解锁后回调
   */
  onPostUnlock?: () => void;

  /**
   * 请求解锁状态变化
   *
   * @param isInRequestUnlock 是否在请求解锁中
   */
  onRequestUnlockStateChange?: (isInRequestUnlock: boolean) => void;
}

/**
 * 0层控件延时隐藏辅助类
 */
class DelayHideViewHelper {
  private _delayHideViewTimeout: number = 0;

  public get isInDelayHideView(): boolean {
    return this._delayHideViewTimeout !== 0;
  }

  /**
   * 用于部分场景下，需要延时隐藏锁屏0层控件
   */
  public delayHideView(): void {
    log.showInfo('delayHideView start.');
    this._delayHideViewTimeout = setTimeout(() => {
      this._delayHideViewTimeout = 0;
      let pageState: PageState = ScreenLockStateManager.getInstance().lockStateInfo.pageState;
      // 保护增强，属于危险接口对外部暴露，防止锁屏没有退锁的时候执行跳过导致状态不匹配
      if (pageState === PageState.HIDE) {
        ViewManagerPolicy.hideView(ViewType.KEYGUARD);
        log.showInfo('delayHideView done.');
      } else {
        log.showInfo(`page state: ${pageState}, skip hide.`);
      }
    }, 1000); // 最大延时1s
  }

  /**
   * 存在延时隐藏请求时，立即执行隐藏
   */
  public hideView(): void {
    log.showInfo('hideView start.');
    if (this._delayHideViewTimeout !== 0) {
      clearTimeout(this._delayHideViewTimeout);
      this._delayHideViewTimeout = 0;
      ViewManagerPolicy.hideView(ViewType.KEYGUARD);
      log.showInfo('hideView done.');
    }
  }

  /**
   * 清除延时隐藏
   */
  public clearDelayHideView(): void {
    if (this._delayHideViewTimeout !== 0) {
      log.showInfo('clearDelayHideView');
      clearTimeout(this._delayHideViewTimeout);
      this._delayHideViewTimeout = 0;
    }
  }
}

/**
 * 屏幕锁定和解锁服务
 */
export class ScreenLockUnlockService extends AbstractObserverManager<LockUnlockListener> {
  private static sInstance: ScreenLockUnlockService;
  private drawDoneManager: DrawDoneManager = new DrawDoneManager(SCREEN_LOCK_BOOT);

  public static getInstance(): ScreenLockUnlockService {
    if (ScreenLockUnlockService.sInstance == null) {
      ScreenLockUnlockService.sInstance = new ScreenLockUnlockService();
    }
    return ScreenLockUnlockService.sInstance;
  }

  private _pageState: PageState = ScreenLockStateManager.getInstance().lockStateInfo.pageState;
  private _lockState: LockState = ScreenLockStateManager.getInstance().lockStateInfo.lockState;

  private readonly _lockStateChangeListener: ScreenLockStateChangeListener = {
    onLockStateChange: (lockStateInfo: LockStateInfo): void => {
      if (this._pageState === lockStateInfo.pageState) {
        log.showInfo(`onLockStateChange cur: ${this._lockState}, next: ${lockStateInfo.lockState}`);
        if (this._lockState === LockState.UNLOCKED && lockStateInfo.lockState === LockState.LOCKED) {
          ScreenLockStateManager.getInstance().updateLockAuthState(LockState.LOCKED);
        }
        this._lockState = lockStateInfo.lockState;
        return;
      }
      this._lockState = lockStateInfo.lockState;
      this._pageState = lockStateInfo.pageState;
      switch (this._pageState) {
        case PageState.SHOW:
          this.doScreenLockInner();
          break;
        case PageState.HIDE:
          this.doScreenUnlockInner();
          break;
        default:
          break;
      }
    }
  };

  private _firstLockScreen: boolean = true;
  private _requestUnlockCount: number = 0;
  private _lockUnlockRequestHandler?: LockUnlockRequestHandler;
  private _setTimeOutId: number = -1;
  private readonly _delayHideViewHelper: DelayHideViewHelper = new DelayHideViewHelper();
  private _unlockUserSwitch: boolean = false; // 隐私空间切换直接解锁
  private _hasReceiveResult: boolean = false; // onResult标记位

  private constructor() {
    super();
  }

  public get isInRequestUnlock(): boolean {
    return this._requestUnlockCount > 0;
  }

  public set lockUnlockRequestHandler(lockUnlockRequestHandler: LockUnlockRequestHandler | undefined) {
    this._lockUnlockRequestHandler = lockUnlockRequestHandler;
  }

  public get unlockUserSwitch(): boolean {
    return this._unlockUserSwitch;
}

  public set unlockUserSwitch(isUnlockByUserSwitch: boolean) {
    if (this._unlockUserSwitch !== isUnlockByUserSwitch) {
      log.showInfo(`set unlockUserSwitch: ${isUnlockByUserSwitch}`);
    } else {
      log.showDebug(`set unlockUserSwitch: ${isUnlockByUserSwitch}`);
    }
    this._unlockUserSwitch = isUnlockByUserSwitch;
  }

  public get hasReceiveResult(): boolean {
    return this._hasReceiveResult;
  }

  public set hasReceiveResult(hasReceiveResult: boolean) {
    if (this._hasReceiveResult !== hasReceiveResult) {
      log.showInfo(`set hasReceiveResult: ${hasReceiveResult}`);
    } else {
      log.showDebug(`set hasReceiveResult: ${hasReceiveResult}`);
    }
    this._hasReceiveResult = hasReceiveResult;
  }

  /**
   * 进入系统，此时需要确保页面已经Ready。
   */
  public enterSystem(): void {
    log.showInfo('enterSystem begin.');
    TraceUtil.startTrace(DomainName.SCB, TraceUtil.CORE_LOCK_SCREEN_VOTE_BOOT);
    if (sSCBOobeManager.isEnable()) {
      this.voteBootEvent();
      this.publishScreenLockBoot(false);
    } else {
        this.voteBootEvent();
        this.publishScreenLockBoot(true);
    }
    TraceUtil.endTrace(DomainName.SCB, TraceUtil.CORE_LOCK_SCREEN_VOTE_BOOT);
    AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_START);
    log.showInfo('enterSystem end.');
  }

  /**
   * 请求锁屏
   */
  public requestLock(): void {
    log.showInfo('requestLock.');
    this._lockUnlockRequestHandler?.onRequestLock?.();
  }

  /**
   * 请求解锁
   *
   * @param callback 解锁后事件回调
   * @returns 是否等待中
   */
  public requestUnlock(callback?: LockUnlockCallback): boolean {
    if (!this._lockUnlockRequestHandler) {
      log.showWarn('requestUnlock handler not exist.');
      callback?.fail?.();
      return false;
    }
    log.showInfo('requestUnlock.');
    let isWaiting: boolean = false;
    this._lockUnlockRequestHandler.onRequestUnlock((result: HandleResult): void => {
      if (isWaiting && result !== HandleResult.WAITING) {
        this.updateRequestUnlockCount(false);
      }
      switch (result) {
        case HandleResult.SUCCESS:
          callback?.success?.();
          break;
        case HandleResult.AUTH_RESULT_SUCCESS:
          callback?.authResultSuccess?.();
          break;
        case HandleResult.FAIL:
          callback?.fail?.();
          break;
        case HandleResult.CANCEL:
          callback?.cancel?.();
          break;
        case HandleResult.WAITING:
          isWaiting = true;
          this.updateRequestUnlockCount(true);
        default:
          break;
      }
    });
    return isWaiting;
  }

  /**
   * 用于部分场景下，需要延时隐藏锁屏0层控件
   */
  public delayHideRootView(): void {
    this._delayHideViewHelper.delayHideView();
  }

  /**
   * 存在延时隐藏请求时，立即执行隐藏
   */
  public hideRootView(): void {
    this._delayHideViewHelper.hideView();
  }

  public logFinishCallbackTimeout(delay: number = SET_TIMEOUT_DELAY): void {
    if (this._setTimeOutId !== -1) {
      this.rollbackCallbackTimeout();
    }
    this._setTimeOutId = setTimeout(() => {
      log.showError('exitKeyguard onFinish is not received');
      HiKGReportBase.reportFault(DfxFaultEventTag.FINISH_CALLBACK_TIMEOUT);
      this._setTimeOutId = -1;
    }, delay);
  }

  public rollbackCallbackTimeout(): void {
    clearTimeout(this._setTimeOutId);
     this._setTimeOutId = -1;
  }

  /**
   * 通知WMS锁屏状态
   */
  public notifyEarlyUnlockTransition() : void {
    SCBSceneSessionManager.getInstance().notifyWMSIsLockReceived(false);
  }

  protected doInit(): void {
    log.showInfo('doInit');
    ScreenLockStateManager.getInstance().init();
    ScreenLockStateManager.getInstance().registerObserver(this._lockStateChangeListener);
  }

  protected doRelease(): void {
    log.showInfo('doRelease');
    ScreenLockStateManager.getInstance().release();
    ScreenLockStateManager.getInstance().unRegisterObserver(this._lockStateChangeListener);
  }

  private updateRequestUnlockCount(isAdd: boolean): void {
    log.showInfo(`requestUnlockCount change. cur: ${this._requestUnlockCount}, isAdd: ${isAdd}`);
    let oldState: boolean = this.isInRequestUnlock;
    this._requestUnlockCount = Math.max(this._requestUnlockCount + (isAdd ? 1 : -1), 0);
    let newState: boolean = this.isInRequestUnlock;
    if (oldState !== newState) {
      this.broadcastDataChange(observer => observer.onRequestUnlockStateChange?.(newState));
    }
  }

  private doScreenLockInner(): void {
    if (SlServerHelper.getInstance().isScreenLockDisabled()) {
      log.showWarn('doScreenLock encounter lock disabled.');
      return;
    }
    this.broadcastDataChange(listener => listener?.onPreLockPageShow?.());
    SLAutoTestService.getInstance().connectService();
    // 锁屏时需要保障桌面图标退场动效，故SL_LOCK_STATE变量变化放在notifyLockTransition之后
    if (!slUiStateMgr.getSlState(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE)?.getSlState(
      OneMirrorStaticStateType.IS_NEED_SHOW_IMMERSIVE) || !immersiveKgMgr.getDefaultImmersiveSwitch()) {
      slUiStateMgr.getSlState(SlMainStateType.SL_STATIC_STATE)?.setSlState(SlStaticStateType.SL_LOCK_STATE, true);
    } else {
      log.showInfo('need to show immersive card, do not play the desktop exit effect.');
    }

    log.showWarn('doScreenLock');
    Trace.start(Trace.CORE_METHOD_LOCK_HIDE);
    this._delayHideViewHelper.clearDelayHideView();
    ViewManagerPolicy.showView(ViewType.KEYGUARD);
    HiSysEventUtil.reportShowKeyguard();
    this.checkPrivateDataMoving();
    ScreenLockStateManager.getInstance().updateLockAuthState(LockState.LOCKED);
    this.unlockUserSwitch = false;
    if (!(this._firstLockScreen &&
      SlServerHelper.getInstance().getScreenLockAuthState() === AuthState.PRE_AUTHED_BY_CREDENTIAL)) {
      // 存储取消监听后下掉
      SlServerHelper.getInstance().sendScreenLockEvent(LockEventType.LOCK_SCREEN_RESULT);
    }

    Trace.start(TraceTag.NOTIFY_LOCK);
    SCBTransitionManager.getInstance().notifyLockTransition();
    Trace.end(TraceTag.NOTIFY_LOCK);

    // 锁屏时通知双中心退出
    DoubleCenterHelper.getInstance().exitDoubleCenter();

    this.publishEvent(EventName.LOCK_SCREEN);

    // 广播锁屏事件
    ScreenLockStateManager.getInstance().publishScreenLockEvent();

    // 锁屏时，刷新验证数据，避免信息不同步
    VerifyDataManager.getInstance().updateVerifyData();
    VerifyDataManager.getInstance().updateOtherUserProperty();

    // startOobeForOta after first lockScreen
    if (this._firstLockScreen) {
      log.showInfo('first lockScreen startOobeForOta');
      sSCBOtaManager.startOobeForOta();
      this._firstLockScreen = false;
    }
    Trace.end(Trace.CORE_METHOD_LOCK_HIDE);

    slUiStateMgr.getSlState(SlMainStateType.SL_STATIC_STATE)?.setSlState(SlStaticStateType.SL_HOST_STATE, true);
  }

  /**
   * 隐私空间上锁时，如果此时是处于数据迁移阶段，则需要加密主用户数据
   */
  private checkPrivateDataMoving(): void {
    AccountHelper.getInstance().isPrivacySpaceUser((isPrivacySpaceUser: boolean) => {
      if (!isPrivacySpaceUser) {
        log.showInfo('checkPrivateDataMoving, but current space is not privacy!.');
        return;
      }
      if (!UserSwitchService.getInstance().isCurrentUserActive) {
        log.showInfo('checkPrivateDataMoving, but current user is not active!.');
        sSettingsUtil.setSecureValue(CommonConstants.PRIVATE_SPACE_MOVING_DATA,
          CommonConstants.PRIVATE_SPACE_MOVING_DATA_STOP);
        return;
      }

      let isPrivateSpaceMoving: string = sSettingsUtil.getValueBySECURE(CommonConstants.PRIVATE_SPACE_MOVING_DATA,
        CommonConstants.PRIVATE_SPACE_MOVING_DATA_STOP);
      if (isPrivateSpaceMoving === CommonConstants.PRIVATE_SPACE_MOVING_DATA_START) {
        log.showError('checkPrivateDataMoving, privacy space data moving & locking, deactivate main user.');
        AccountHelper.getInstance().fileEncryption(CommonConstants.DEFAULT_USER_ID);
        sSettingsUtil.setSecureValue(CommonConstants.PRIVATE_SPACE_MOVING_DATA,
          CommonConstants.PRIVATE_SPACE_MOVING_DATA_STOP);
      }
    });
  }

  /**
   * 屏幕解锁
   */
  private doScreenUnlockInner(): void {
    log.showWarn('doScreenUnlock');
    Trace.start(Trace.CORE_METHOD_UNLOCK_HIDE);
    // ApsUtils.setApsScene(apsManager.SceneAnimation.UNLOCK_TO_ENTER_DESKTOP,
    //   CommonConstants.APS_UNLOCK_TO_ENTER_DESKTOP_OPEN);
    this.notifyEarlyUnlockTransition();
    this.broadcastDataChange(listener => listener?.onPreUnlock?.());
    if (!this._delayHideViewHelper.isInDelayHideView) {
      log.showInfo('hideView doScreenUnlockInner');
      ViewManagerPolicy.hideView(ViewType.KEYGUARD);
    }
    HiSysEventUtil.reportHideKeyguard();
    UserSwitchService.getInstance().isUserSwitching = false;
    if (!slClockOneShotToDesktopService.isClockOneShotAnimAvailable()) {
      SCBTransitionManager.getInstance().notifyUnlockSpaceAniFinished();
    }
    if (VerifyDataManager.getInstance().hasNoPwd) {
      SlUnlockReportHelper.getInstance().unlockReport();
    } else {
      SlUnlockReportHelper.getInstance().unlockReport(ScreenLockVerifyService.getInstance().lastSuccessAuthType);
    }
    SlServerHelper.getInstance()
      .sendScreenLockEvent(LockEventType.UNLOCK_SCREEN_RESULT, LockOperateResult.EarlySuccess);
    Trace.start(TraceTag.NOTIFY_UNLOCK);
    SCBTransitionManager.getInstance().notifyUnlockStartScene();
    Trace.end(TraceTag.NOTIFY_UNLOCK);
    //桌面动效绘制完成再上报指纹打点
    if (VerifyDataManager.getInstance().hasNoPwd) {
      FingerAuthReportHelper.getInstance().unlockReport();
      ScreenLockStateManager.getInstance().updateDeviceLockState(AuthType.PIN);
    } else {
      FingerAuthReportHelper.getInstance().unlockReport(ScreenLockVerifyService.getInstance().lastSuccessAuthType);
    }

    // 无密码、隐私空间切换、收到onResult，直接发送解锁广播
    if (this._hasReceiveResult || VerifyDataManager.getInstance().hasNoPwd || this._unlockUserSwitch) {
      log.showInfo('send unlock screenlockEvent when hide keyguard');
      SlServerHelper.getInstance().sendScreenLockEvent(LockEventType.UNLOCK_SCREEN_RESULT);
    }

    this.publishEvent(EventName.UNLOCK_SCREEN);

    if (VerifyDataManager.getInstance().hasNoPwd) {
      HiDfxEventUtil.reportNoPwdUnlock();
    }

    this.broadcastDataChange(listener => listener?.onPostUnlock?.());
    Trace.end(Trace.CORE_METHOD_UNLOCK_HIDE);
    slUiStateMgr.getSlState(SlMainStateType.SL_STATIC_STATE)?.setSlState(SlStaticStateType.SL_LOCK_STATE, false)
      .setSlState(SlStaticStateType.SL_HOST_STATE, false);
    SLAutoTestService.getInstance().disconnectService();
  }

  private publishEvent(eventName: EventName): void {
    log.showDebug(`publishByUser event name: ${eventName}`);
    let publishData: commonEventManager.CommonEventPublishData = {
      parameters: {
        userId: AccountHelper.getInstance().currentLocalId
      }
    };
    try {
      commonEventManager.publish(eventName, publishData, (err) => {
        if (err) {
          log.showError(`publishEvent ${eventName} error. code: ${err.code}`);
          return;
        }
        log.showInfo(`publishEvent ${eventName} success.`);
      });
    } catch (error) {
      log.showError(`publishEvent ${eventName} failed.`);
    }
  }

  private voteBootEvent(): void {
    log.showInfo('voteBootEvent for lockscreen begin');
    // 设置此属性后，才能跳过开机界面，进入桌面状态，影响开机性能基线。
    if (!SystemParamUtils.setSystemParam('bootevent.lockscreen.ready', 'true')) {
      log.showError('set voteBootEvent failed.');
    }
    log.showInfo('voteBootEvent for lockscreen end');
  }

  /**
   * 开机场景发送公共事件，区分有无oobe场景
   */
  public publishScreenLockBoot(isScreenLockShow: boolean): void {
    // 锁屏重启并且锁屏显示 注册监听
    if (isScreenLockShow) {
      this.drawDoneManager.registerComponentDrawObserver(this.notifyScreenLockDrawDone);
    }
    // 锁屏不显示直接发送
    this.publishEvent(EventName.SCREEN_LOCK_BOOT_COMPLETED);
    log.showInfo(`publishScreenLockBoot isScreenLockShow:${isScreenLockShow}`);
  }

  private notifyScreenLockDrawDone = (): void => {
    SlServerHelper.getInstance().sendScreenLockEvent(LockEventType.SCREEN_DRAW_DONE);
    log.showInfo('notifyDrawDone');
  };
}
