/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import curves from '@ohos.curves';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import { AnimateToScheduleUtils, DomainName, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';
import { GlobalContext, HiSysEventUtil, viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import {
  SCBSceneSession,
  SCBSceneContainerSession,
  SCBSystemSceneSession,
  SCBSceneSessionManager,
  FocusChangeReason,
  SCBScreenProperty,
  SCBRecentSessionState,
  SCBRecentSessionHelper
} from '@ohos/windowscene';
import { recentStateManager, SCBRecentStateEvents, SCBRecentStateCallbackArgsType } from './SCBRecentState';
import { SCBRecentCardViewModel } from './SCBRecentCardViewModel';
import { SCBRecentTitleViewModel } from './SCBRecentTitleViewModel';
import { SCBRecentCover } from './SCBRecentCover';
import { PcSCBSceneContainerSessionArray } from '@ohos/pcmode';
import { RecentAndAppCenterSwitchManager } from '../../common/manager/RecentAndAppCenterSwitchManager';

const TAG = 'SCBRecentEnter';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);
const INVALID_PERSISTENT_ID: number = 0;

export class SCBRecentEnter {
  private groupAnimationRef: number = 0;
  private screenProperty: SCBScreenProperty;
  private needRecoverSessionFocus: boolean = false;
  private needRecoverFocusedSessionId: number = SCBSceneSessionManager.getInstance().getFocusedSessionId();

  constructor(screenProperty: SCBScreenProperty) {
    this.screenProperty = screenProperty;
    this.needRecoverFocusedSessionId =
      SCBSceneSessionManager.getInstance().getFocusedSessionId(this.screenProperty.screenId);
    this.registerRecentEnterStartEventCallback();
    this.registerRecentEnterAllAnimateStartEventCallback();
    this.registerRecentEnterAllAnimateStartedEventCallback();
    this.registerRecentEnterEndEventCallback();
  }

  public changeNeedRecoverSessionFocus(isNeedRecoverSessionFocus: boolean): void {
    this.needRecoverSessionFocus = isNeedRecoverSessionFocus;
  }

  public getNeedRecoverSessionFocus(): boolean {
    return this.needRecoverSessionFocus;
  }

  public getNeedRecoverFocusedSessionId(): number {
    return this.needRecoverFocusedSessionId;
  }

  public getNeedRecoverFocusSession(
    containerSessionList: PcSCBSceneContainerSessionArray): SCBSceneContainerSession | null {
    if (this.getNeedRecoverSessionFocus()) {
      this.changeNeedRecoverSessionFocus(false);
      const needRecoverFocusedSessionId: number = this.getNeedRecoverFocusedSessionId();
      const focusedSession: SCBSceneContainerSession | null =
        containerSessionList.findByPersistentId(needRecoverFocusedSessionId);
      if (focusedSession?.isActive) {
        return focusedSession;
      }
    }
    return null;
  }

  public switchInFocus(sysSceneSession: SCBSystemSceneSession): void {
    if (!sysSceneSession) {
      return;
    }
    sysSceneSession.setFocusable(true);
    SCBSceneSessionManager.getInstance()
      .requestFocus(sysSceneSession.session.persistentId, false, FocusChangeReason.RECENT);

    this.recordFocusSceneSession();
  }

  private recordFocusSceneSession(): void {
    let focusedSession: SCBSceneSession | null =
      SCBSceneSessionManager.getInstance().getFocusedSceneSession(this.screenProperty.screenId);
    if (!focusedSession) {
      return;
    }
    this.needRecoverFocusedSessionId = focusedSession.session.persistentId;
    this.needRecoverSessionFocus = this.needRecoverFocusedSessionId !== INVALID_PERSISTENT_ID;
    log.showDebug(`needRecoverSessionFocus: ${this.needRecoverSessionFocus}, ` +
      `needRecoverFocusedSessionId: ${this.needRecoverFocusedSessionId}.`);
  }

  public switchOutFocus(sysSceneSession: SCBSystemSceneSession,
    containerSessionList: PcSCBSceneContainerSessionArray): void {
    if (!sysSceneSession) {
      return;
    }
    sysSceneSession.setFocusable(false);
    this.recoverFocusSceneSession(this.getNeedRecoverFocusSession(containerSessionList));
  }

  private recoverFocusSceneSession(topActiveSession: SCBSceneContainerSession | null): void {
    // 点击窗口最小时，同时进入任务中心，然后退出任务中心场景，此场景退出任务中心时提最后一个active sceneSession
    if (!topActiveSession || !topActiveSession.primarySession) {
      log.showInfo(`no top active sceneSession`);
      return;
    }
    let needRecoverFocusSceneSession = topActiveSession.primarySession;
    if (topActiveSession.isSplit && topActiveSession.secondarySession) {
      needRecoverFocusSceneSession = topActiveSession.secondarySession;
    }
    log.showInfo(`recoverFocusSceneSession： ${needRecoverFocusSceneSession?.getName()}`);
    SCBSceneSessionManager.getInstance().requestFocus(needRecoverFocusSceneSession?.session?.persistentId,
      undefined, FocusChangeReason.RECENT);
  }

  // 1，从Home进入recent: start IntoRecent:Gesture:Land. from home
  private recordStartEnterRecentLogs(): void {
    log.showInfo('start %{public}s from home. screenId: %{public}d', TraceUtil.CORE_METHOD_ENTER_RECENT,
      this.screenProperty.screenId);
    TraceUtil.startTrace(DomainName.RECENT, TraceUtil.CORE_METHOD_ENTER_RECENT);
  }

  private registerRecentEnterStartEventCallback(): void {
    let instance = recentStateManager.getRecentStateInstance(this.screenProperty.screenId);
    let event = SCBRecentStateEvents.EVENT_ENTER_RECENT_START;
    instance.registerRecentCallback(event,
      {
        name: TAG + event,
        func: (...args: SCBRecentStateCallbackArgsType[]) => {
          AnimateToScheduleUtils.attachBigCoreCPU(AnimateToScheduleUtils.ACTION_ATTACH_START);
          this.recordStartEnterRecentLogs();
          SCBSceneSessionManager.getInstance().notifyEnterRecentForFloat();
          return true;
        }
      });
  }

  private registerRecentEnterAllAnimateStartEventCallback(): void {
    let instance = recentStateManager.getRecentStateInstance(this.screenProperty.screenId);
    let event = SCBRecentStateEvents.EVENT_ENTER_RECENT_ALL_ANIMATE_START;
    instance.registerRecentCallback(event,
      {
        name: TAG + event,
        func: (...args: SCBRecentStateCallbackArgsType[]) => {
          return true;
        }
      });
  }

  private registerRecentEnterAllAnimateStartedEventCallback(): void {
    let instance = recentStateManager.getRecentStateInstance(this.screenProperty.screenId);
    let event = SCBRecentStateEvents.EVENT_ENTER_RECENT_ALL_ANIMATE_STARTED;
    instance.registerRecentCallback(event,
      {
        name: TAG + event,
        func: (...args: SCBRecentStateCallbackArgsType[]) => {
          return true;
        }
      });
  }

  private registerRecentEnterEndEventCallback(): void {
    let instance = recentStateManager.getRecentStateInstance(this.screenProperty.screenId);
    let event = SCBRecentStateEvents.EVENT_ENTER_RECENT_END;
    instance.registerRecentCallback(event,
      {
        name: TAG + event,
        func: (...args: SCBRecentStateCallbackArgsType[]) => {
          return true;
        }
      });
  }

  public fgWindow2RecentVisibleAnimate(delayTime: number): void {
    this.fgWindow2RecentVisibleAnimatePrepare();
    animateToImmediately({
      curve: curves.interpolatingSpring(0, 1, 400, 32),
      delay: delayTime,
      onFinish: () => {
        this.fgWindow2RecentVisibleAnimateFinish();
      }
    }, () => {
      this.fgWindow2RecentVisibleAnimateEvent();
    });
    this.fgWindow2RecentVisibleAnimateEvent();
  }

  private fgWindow2RecentVisibleAnimatePrepare(): void {
  }

  private fgWindow2RecentVisibleAnimateEvent(): void {
  }

  private fgWindow2RecentVisibleAnimateFinish(): void {
  }

  public fgWindow2RecentInvisibleAnimate(): void {
    this.fgWindow2RecentInvisibleAnimatePrepare();
    this.fgWindow2RecentInvisibleAnimateEvent();
    this.fgWindow2RecentInvisibleAnimateFinish();
  }

  private fgWindow2RecentInvisibleAnimatePrepare(): void {
  }

  private fgWindow2RecentInvisibleAnimateEvent(): void {
  }

  private fgWindow2RecentInvisibleAnimateFinish(): void {
  }

  public bgWindow2RecentVisibleAnimate(sceneContainerSessionList: SCBSceneContainerSession[], delayTime: number): void {
    if (sceneContainerSessionList.length === 0) {
      return;
    }
    this.bgWindow2RecentVisibleAnimatePrepare();
    animateToImmediately({
      curve: curves.interpolatingSpring(0, 1, 400, 32),
      delay: delayTime,
      onFinish: () => {
        this.bgWindow2RecentVisibleAnimateFinish(sceneContainerSessionList);
      }
    }, () => {
      this.bgWindow2RecentVisibleAnimateEvent(sceneContainerSessionList);
    });
    animateToImmediately({
      duration: 400,
      curve: Curve.Sharp,
      delay: delayTime
    }, () => {
      this.bgWindow2RecentVisibleTitleAnimateEvent(sceneContainerSessionList);
    });
  }

  private bgWindow2RecentVisibleTitleAnimateEvent(sceneContainerSessionList: SCBSceneContainerSession[]): void {
    sceneContainerSessionList.forEach((sceneContainerSession) => {
      sceneContainerSession.needRenderAlpha.setNeedRenderAlpha(1.0);
      sceneContainerSession.needRenderTitleViewAlpha.setTitleViewAlpha(1.0);
    });
  }

  private bgWindow2RecentVisibleAnimatePrepare(): void {
  }

  private bgWindow2RecentVisibleAnimateEvent(sceneContainerSessionList: SCBSceneContainerSession[]): void {
    sceneContainerSessionList.forEach((sceneContainerSession) => {
      if (!sceneContainerSession.primarySession) {
        return;
      }
    });
  }

  private bgWindow2RecentVisibleAnimateFinish(sceneContainerSessionList: SCBSceneContainerSession[]): void {
    sceneContainerSessionList.forEach((sceneContainerSession) => {
      SCBRecentSessionHelper.setState(sceneContainerSession, SCBRecentSessionState.ENTER_RECENT_ANIMATE_FINISH);
    });
    this.recordWindowToRecentFinish();
  }

  private recordWindowToRecentFinish(): void {
    performanceMonitor.end(HiSysEventUtil.PC_GESTURE_TO_RECENT);
    performanceMonitor.end(HiSysEventUtil.PC_INTO_RECENT);
    performanceMonitor.end(HiSysEventUtil.PC_SHORTCUT_TO_RECENT);
    performanceMonitor.end(HiSysEventUtil.PC_ALT_TAB_TO_RECENT);
    log.showInfo('PC_INO_RECENT FINISH');
  }


  public bgWindow2RecentInvisibleAnimate(): void {
    this.bgWindow2RecentInvisibleAnimatePrepare();
    this.bgWindow2RecentInvisibleAnimateEvent();
    this.bgWindow2RecentInvisibleAnimateFinish();
  }

  private bgWindow2RecentInvisibleAnimatePrepare(): void {
  }

  private bgWindow2RecentInvisibleAnimateEvent(): void {
  }

  private bgWindow2RecentInvisibleAnimateFinish(): void {
  }

  public groupAnimationRefInit(): void {
    this.groupAnimationRef = 0;
    log.showInfo('group animation ref init');
  }

  public groupAnimationRefZero(): boolean {
    return (this.groupAnimationRef === 0);
  }

  public groupAnimationRefAdd(): void {
    this.groupAnimationRef++;
    log.showInfo(`group animation ref add: ${this.groupAnimationRef}`);
  }

  public groupAnimationRefDec(): void {
    this.groupAnimationRef--;
    log.showInfo(`group animation ref decrease: ${this.groupAnimationRef}`);
  }
}
