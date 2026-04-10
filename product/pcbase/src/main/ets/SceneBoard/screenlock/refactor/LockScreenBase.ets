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

import ScreenLockMar from '@ohos.screenLock';
import { PowerUtils } from '@ohos/screenlockcommon';
import ScreenLockMediator from './ScreenLockMediator';
import ScreenLockService from './ScreenLockService';
import inputDevice from '@ohos.multimodalInput.inputDevice';
import type Callback from '@ohos.base';
import {
  LogDomain,
  LogHelper,
  DomainName,
  TraceUtil,
  AnimateToScheduleUtils,
  CommonUtils
} from '@ohos/basicutils';
import { DynamicWallPaperState } from '@ohos/themeservice';
import { themeWallpaperAniMgr } from '@ohos/themeservice';
import { HiDfxEventUtil } from '@ohos/frameworkwrapper';
import { SCBScreenSessionManager, sSCBOobeManager, SCBWindowRotateController } from '@ohos/windowscene';
import { DeviceHelper, sEventManager, EventConstants, obtainLocalEvent, ScreenLockEvent } from '@ohos/frameworkwrapper';
import systemParameter from '@ohos.systemparameter';
import { ScreenLockStatus, screenLockStateManager, ScreenLockState } from '@ohos/screenlockcommon';
import { strongAuthManager } from '@ohos/screenlockcommon';
import ScreenlockEventMonitor from './ScreenlockEventMonitor';
import Constants from '@ohos/screenlockcomponent/src/main/ets/common/Constants';
import accountModel from './AccountsModel';
import { VoteDevice } from './VoteDevice';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import { SlMainStateType, OneMirrorStaticStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { EnterpriseSpaceUtil } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { ScreenOnOffMediator } from '@ohos/screenlockcommon';

const TAG = 'ScreenLock-ServiceExtAbility';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);


const VOTE_TIMEOUT_INIT: number = 10000;

const VOTE_TIMEOUT_READY: number = 200;

const STATE_CHANGE_REASON_AOD_SLIDING: number = 40;

const STATE_CHANGE_REASON_PRE_BRIGHT_FAIL : number = 29;

const STATE_CHANGE_REASON_PROXIMITY: number = 32;

/**
 * basic keyguard service
 *
 * @since 2022-04-28
 */
export default class LockScreenBase {
  private static voteDevice: VoteDevice = new VoteDevice();

  private static isReadyToShow: boolean = false;

  private static isLockScreen: boolean = false;

  public static initVoteDevice(voteDevice: VoteDevice): void {
    LockScreenBase.voteDevice = voteDevice;
  }

  public static getVoteDevice(): VoteDevice {
    return LockScreenBase.voteDevice;
  }
  /**
   * create service
   *
   */
  static onCreate(): void {
    LockScreenBase.voteDevice.scheduleVoteTimeout(VOTE_TIMEOUT_INIT);
    ScreenlockEventMonitor.monitorEvent();
    TraceUtil.startTrace(DomainName.SCB, TraceUtil.CORE_LOCK_SCREEN_VOTE_BOOT);
    LockScreenBase.voteBoot();
    TraceUtil.endTrace(DomainName.SCB, TraceUtil.CORE_LOCK_SCREEN_VOTE_BOOT);
    AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_START);
  }

  /**
   * 由于灭屏后，AOD显示期间，Sceneboard窗口不可旋转。
   * 如果用户在灭屏以后旋转了设备，
   * 在收到亮屏事件以后需要恢复窗口到当前设备状态
   */
  private static rotateFoldFullScreen(): void {
    try {
      if (DeviceHelper.isPC()) {
        return;
      }
      if (DeviceHelper.isFoldExpandedButNotSmallFoldProduct()) {
        const session = SCBScreenSessionManager.getInstance().getMainScreenSession();
        if (!CommonUtils.isInvalid(session) &&
          SCBWindowRotateController.getInstance().isDesktopRotatable()) {
          log.showInfo('rotateFoldFullScreen.');
          session.rotationChangeEntry(session.sensorScreenProperty.rotation, 'aod exit');
        }
      }
    } catch (e) {
      log.showError('rotateFoldFullScreen fail');
    }
  }

  private static voteBoot(): void {
    if (EnterpriseSpaceUtil.hwItOsCheck()) {
      log.showInfo('hwItOsCheck result:true');
      LockScreenBase.votePCBoot();
      return;
    }
    LockScreenBase.voteDevice.cancelVoteTimeout();
    if (sSCBOobeManager.isEnable()) {
      LockScreenBase.voteDevice.voteBootEvent();
      LockScreenBase.voteDevice.publishScreenLockBoot(false);
    } else {
      LockScreenBase.voteDevice.scheduleForReadyTimeout();
      ScreenLockMediator.doScreenLockWithLocalCallback(() => {
        screenLockStateManager.onEnterHost(false);
        LockScreenBase.isLockScreen = true;
        LockScreenBase.checkVoteBoot();
      });
    }
    accountModel.updateCurrentUserId(async () => {
      await ScreenLockService.checkHasPasswordProperty();
      ScreenLockService.setLockStatus(ScreenLockStatus.LOCKING, ScreenLockEvent.LOCK_STATUS_SECURE);
      strongAuthManager.triggerAuthByReboot();
    });
  }

  private static votePCBoot(): void {
    LockScreenBase.voteDevice.cancelVoteTimeout();
    accountModel.updateCurrentUserId(async () => {
      await ScreenLockService.checkHasPasswordProperty();
      if (sSCBOobeManager.isEnable()) {
        LockScreenBase.voteDevice.voteBootEvent();
        LockScreenBase.voteDevice.publishScreenLockBoot(false);
      } else {
        LockScreenBase.voteDevice.scheduleForReadyTimeout();
        ScreenLockMediator.doScreenLockWithLocalCallback(() => {
          screenLockStateManager.onEnterHost(false);
          LockScreenBase.voteDevice.voteForReady();
          LockScreenBase.voteDevice.publishScreenLockBoot(true);
        });
      }
      ScreenLockService.setLockStatus(ScreenLockStatus.LOCKING, ScreenLockEvent.LOCK_STATUS_SECURE);
      strongAuthManager.triggerAuthByReboot();
    });
  }

  public static onBeginWakeup(changeReason?: number): void {
    log.showInfo(`onBeginWakeup changeReason=${changeReason}`);
    if (changeReason === STATE_CHANGE_REASON_PROXIMITY) {
      ScreenLockService.notifyDrawDone();
      log.showInfo('send proximity send on msg to themeWallpaper');
      themeWallpaperAniMgr.reqPlayWallpaperAnimation({
        curState: DynamicWallPaperState.PROXIMITY_SCREEN_OFF,
        tarState: DynamicWallPaperState.PROXIMITY_SCREEN_ON,
        isOffScreenSupportAod: false,
        onFinish: () => { },
        isPlayingAnimation: false
      });
    }
    sEventManager.publish(obtainLocalEvent(Constants.SCREEN_LOCK_BEGIN_WAKEUP, null));
    slUiStateMgr.getSlState(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE)?.setSlState(
      OneMirrorStaticStateType.SLEEP_REASON, changeReason);
    AppStorage.setOrCreate('isWakeupStart', true);
    // 亮屏时重置BeginSleepStart为false
    AppStorage.setOrCreate('isBeginSleepStart', false);
    ScreenLockService.isScreenOffFromBouncer = false;
    ScreenLockMediator.setScreenOn(true);
    ScreenOnOffMediator.ableToSendScreenOffNotifyEvent = false;
    LockScreenBase.rotateFoldFullScreen();
    LockScreenBase.handleAodSliding(changeReason);
  }

  private static handleAodSliding(changeReason?: number): void {
    if (changeReason !== STATE_CHANGE_REASON_AOD_SLIDING) {
      return;
    }
    ScreenLockService.onAodSlideUnlock();
  }

  public static onEndSleep(): void {
    sEventManager.publish(obtainLocalEvent(Constants.SCREEN_LOCK_END_SLEEP, null));
    ScreenLockMediator.setScreenOnEnd(false);
    ScreenLockMediator.setScreenOn(false);
    AppStorage.setOrCreate('isWakeupStart', false);
    AppStorage.setOrCreate('isScreenOnStart', false);
    AppStorage.setOrCreate('isBeginSleepStart', false);
    HiDfxEventUtil.reportScreenOffEvent();
  }

  public static onBeginSleep(changeReason?: number): void {
    if (ScreenLockService.getIsOffScreenUnlocking() && changeReason === STATE_CHANGE_REASON_PRE_BRIGHT_FAIL) {
      // 黑屏指纹解锁成功之后，不再触发预亮屏失败灭屏上锁
      log.showInfo('pre bright fail, no need lock screen.');
      return;
    }
    AppStorage.setOrCreate('isBeginSleepStart', true);
    AppStorage.setOrCreate('isShortcutKeyPanelShow', false);
    if (changeReason === STATE_CHANGE_REASON_PROXIMITY) {
      log.showInfo('The screen is powered off without locking the screen when the proximity sensor is off.');
      ScreenLockService.faceAuthSuccessByDirectUnlock = false;
      SCBScreenSessionManager.getInstance().notifyScreenLockEvent(PowerUtils.NOTIFY_OFF_SCREEN_CLOSE_LCD);
      log.showInfo('send proximity send off msg to themeWallpaper');
      themeWallpaperAniMgr.reqPlayWallpaperAnimation({
        curState: DynamicWallPaperState.PROXIMITY_SCREEN_ON,
        tarState: DynamicWallPaperState.PROXIMITY_SCREEN_OFF,
        isOffScreenSupportAod: false,
        onFinish: () => { },
        isPlayingAnimation: false
      });
      return;
    }
    slUiStateMgr.getSlState(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE)?.setSlState(
      OneMirrorStaticStateType.SLEEP_REASON, changeReason);
    ScreenLockService.isScreenOffFromBouncer = AppStorage.get('isPwdVisible') ?? false;
    ScreenOnOffMediator.ableToSendScreenOffNotifyEvent = true;
    ScreenLockMediator.backPage();
    sEventManager.publish(obtainLocalEvent(EventConstants.SCREEN_LOCK_BEGIN_SLEEP, null));
    ScreenLockService.resetFaceRecognitionState();
    ScreenLockMediator.doScreenLockWithLocalCallback(() => {
      screenLockStateManager.onEnterHost(false);
    });
  }

  public static VoteReadyToShow(delay?: number): void {
    if (LockScreenBase.isReadyToShow) {
      return;
    }
    LockScreenBase.isReadyToShow = true;
    if (delay) {
      setTimeout(() => {
        LockScreenBase.checkVoteBoot();
      }, delay);
    } else {
      LockScreenBase.checkVoteBoot();
    }
  }

  private static checkVoteBoot(): void {
    if (!LockScreenBase.isReadyToShow || !LockScreenBase.isLockScreen) {
      log.showInfo(`Cannot vote boot, isReadyToShow ${LockScreenBase.isReadyToShow},\
        isLockScreen ${LockScreenBase.isLockScreen}`);
      return;
    }
    LockScreenBase.voteDevice?.voteForReady();
    LockScreenBase.voteDevice?.publishScreenLockBoot(true);
  }
}