/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { SCBSceneSessionManager } from '../../scene/session/SCBSceneSessionManager';
import { SCBSceneInfo } from '../session/SCBSceneInfo';
import SessionManagerService from '@ohos.sessionManagerService';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBSceneMissionManager } from './SCBSceneMissionManager';
import type { SCBScenePersistent } from '../session/SCBScenePersistent';
import { DomainName, LogDomain, LogHelper } from '@ohos/basicutils';
import { AccountMgr } from '@ohos/frameworkwrapper';
import { TraceUtil } from '@ohos/basicutils';
import { BusinessError } from '@ohos.base';
import hiSysEvent from '@ohos.hiSysEvent';
import CommonEventManager from '@ohos.commonEventManager';
import { WinLog, WinLogDomain } from '../../utils/WinLog';

const MAX_RECOVER_CHECK_COUNT = 5;
const RECOVER_CHECK_SPAN_MILLI = 1000;
const COMMON_EVENT_SCB_RECOVER_ENABLE_INPUT = 'com.ohos.sceneboard.event.RECOVER_ENABLE_INPUT';
const COMMON_EVENT_SCB_RECOVER_INITIAL = 'com.ohos.sceneboard.event.RECOVER_INITIAL';
const COMMON_EVENT_SCB_RECOVER_LOGIN = 'com.ohos.sceneboard.event.login';

export class RecoverReportEventUtil {
  private static readonly WINDOW_MANAGER: string = 'WINDOWMANAGER';
  private static readonly PNAMEID: string = 'SCB';
  private static readonly PVERSIONID: string = '1.0';
  private static readonly WINDOW_INDEPENDENT_RECOVER: string = 'WINDOW_INDEPENDENT_RECOVER';

  private static reportEvent(eventName: string, msg: Object): void {
    hiSysEvent.write({
      domain: RecoverReportEventUtil.WINDOW_MANAGER,
      name: eventName,
      eventType: hiSysEvent.EventType.STATISTIC,
      params: msg
    }).then(() => {
      WinLog.showDebug(WinLogDomain.WMS_RECOVER, 'success');
    }).catch((err: BusinessError) => {
      WinLog.showError(WinLogDomain.WMS_RECOVER, 'report false ' + err.message);
    });
  }
 
  static reportRecoverFinishEvent(duration: number): void {
    let eventName: string = RecoverReportEventUtil.WINDOW_INDEPENDENT_RECOVER;
    WinLog.showInfo(WinLogDomain.WMS_RECOVER, `duration is ${duration}`);
    let params: Record<string, string> = {
      PNAMEID: RecoverReportEventUtil.PNAMEID,
      PVERSIONID: RecoverReportEventUtil.PVERSIONID,
      DURATION: duration.toString()
    };
    RecoverReportEventUtil.reportEvent(eventName, params);
  }
}

export enum SCBRecoverState {
  STATE_NORMAL = 0,
  STATE_INITIAL,
  STATE_FINAL
}

/**
 * SceneBoard recover after abnormal restart
 */
export default class SCBRecoverManager {
  private checkCount = 0;

  private enterRecoverTime: number = 0;

  private scenePersistent: SCBScenePersistent = SCBSceneSessionManager.getInstance().getScenePersistent();

  private sessionsNeedRecover = new Map<number, SCBSceneInfo>();

  private abnormalRecovery: boolean = false;

  private onRecoverFinishedCallback: Function;

  private recoverState: SCBRecoverState = SCBRecoverState.STATE_NORMAL;

  /**
   * Obtains a single instance of SCBRecoverManager.
   *
   * @returns { SCBRecoverManager } Returns a singleton instance of SCBRecoverManager
   */
  public static getInstance(): SCBRecoverManager {
    if (!globalThis.SCBRecoverManager) {
      globalThis.SCBRecoverManager = new SCBRecoverManager();
    }
    return globalThis.SCBRecoverManager;
  }

  /**
   * Sets the callback function after the restoration is complete.
   *
   * @param { Function } callback - Callback function after the restoration is complete
   */
  public setOnRecoverFinishedCallback(callback: Function): void {
    this.onRecoverFinishedCallback = callback;
  }

  /**
   * Begin recovering. Wait for app client to reconnect.
   */
  public async beginRecovering(): Promise<void> {
    TraceUtil.startTrace(DomainName.SCB, 'SCBRecoverManager');
    this.enterRecoverTime = Date.now();
    WinLog.showInfo(WinLogDomain.WMS_RECOVER, 'Ready to recover session due to SCB restart');
    this.abnormalRecovery = true;
    this.recoverState = SCBRecoverState.STATE_INITIAL;
    this.publishRecoverEvent(this.recoverState.toString(), COMMON_EVENT_SCB_RECOVER_INITIAL);
    let userId = await AccountMgr.getCurrentAccountId();
    let historySessionList = await this.scenePersistent.readPersistentJsonArray();
    let bundleNames: Array<string> = [];
    for (const data of historySessionList) {
      if (data.isAlive) {
        bundleNames.push(data.bundleName);
        let sceneInfo = new SCBSceneInfo(data.bundleName, data.moduleName, data.abilityName, data.appIndex, data.persistentId);
        WinLog.showInfo(WinLogDomain.WMS_RECOVER, `Add ability=${data.abilityName}, persistentId=${data.persistentId} to SessionNeedRecover list`);
        this.sessionsNeedRecover.set(data.persistentId, sceneInfo);
      } else {
        WinLog.showInfo(WinLogDomain.WMS_RECOVER, `Ability=${data.abilityName}, persistentId=${data.persistentId} is not alive. No need to recover.`);
      }
    }
    await SCBSceneSessionManager.getInstance().getBatchAbilityInfos(userId, bundleNames);
    if (this.sessionsNeedRecover.size > 0) {
      sceneSessionManager.notifySessionRecoverStatus(true, Array.from(this.sessionsNeedRecover.keys()));
    }
    SessionManagerService.notifySceneBoardAvailable();
    if (this.sessionsNeedRecover.size > 0) {
      this.periodicCheck();
    } else {
      WinLog.showInfo(WinLogDomain.WMS_RECOVER, 'No sessions need to be recovered');
      this.handleRecoverFinished();
    }
    RecoverReportEventUtil.reportRecoverFinishEvent(Date.now() - this.enterRecoverTime);
    TraceUtil.endTrace(DomainName.SCB, 'SCBRecoverManager');
  }

  private publishRecoverEvent(state: string, eventName: string): void {
    WinLog.showInfo(WinLogDomain.WMS_RECOVER, `Event: ${eventName}, RecoverState: ${state}`);
    try {
      CommonEventManager.publish(eventName, (err) => {
        if (err && err.code !== 0) {
          WinLog.showError(WinLogDomain.WMS_RECOVER, 'publish error: ' + JSON.stringify(err));
        }
      });
    } catch (err) {
      WinLog.showError(WinLogDomain.WMS_RECOVER, 'publish failed, catch error' + JSON.stringify(err));
    }
  }

  /**
   * Begin logout recovering. Wait for app client to reconnect.
   */
  public beginLogoutRecovering(): void {
    WinLog.showInfo(WinLogDomain.WMS_RECOVER, 'Ready to recover due to SCB logout and login');
    SessionManagerService.notifySceneBoardAvailable();
    this.publishRecoverEvent(this.recoverState.toString(), COMMON_EVENT_SCB_RECOVER_LOGIN);
  }

  /**
   * Is abnormal recovery
   *
   * @returns { Boolean }
   */
  public isAbnormalRecovery(): boolean {
    return this.abnormalRecovery;
  }

  /**
   * Add one recovered client session
   *
   * @param sceneInfo
   */
  public addRecoveredSession(persistentId: number, sceneInfo: sceneSessionManager.SceneRecoverInfo): void {
    this.scenePersistent.addToLocalPersistentMap(persistentId, sceneInfo);
    WinLog.showInfo(WinLogDomain.WMS_RECOVER, `Recover session with persistentId=${persistentId}, bundleName=${sceneInfo.bundleName}`);
  }

  private async periodicCheck(): Promise<void> {
    this.checkCount += 1;
    WinLog.showInfo(WinLogDomain.WMS_RECOVER, `Run recover periodic check, current check count=${this.checkCount}`);
    try {
      let unRecoveredSessions = this.getUnRecoveredSessions();
      WinLog.showInfo(WinLogDomain.WMS_RECOVER, `Current number of unrecovered sessions=${unRecoveredSessions.length}`);
      if (unRecoveredSessions.length === 0) {
        WinLog.showInfo(WinLogDomain.WMS_RECOVER, 'All sessions are reconnected. Set inputEventEnabled to true');
        this.handleRecoverFinished();
        return;
      }
      if (this.checkCount <= MAX_RECOVER_CHECK_COUNT) {
        setTimeout(() => this.periodicCheck(), RECOVER_CHECK_SPAN_MILLI);
      } else {
        WinLog.showInfo(WinLogDomain.WMS_RECOVER, `Session reconnection timeout reached. Remaining number of sessions=${unRecoveredSessions.length}. Start to kill all expired sessions`);
        SCBSceneSessionManager.getInstance().handleExtendScreenSessionRecover();
        this.handleRecoverFinished();
      }
    } catch (err) {
      WinLog.showError(WinLogDomain.WMS_RECOVER, `Error occurred in recover periodic check, message : ${err.message}, code : ${err.code}`);
      this.handleRecoverFinished();
    }
  }

  private handleRecoverFinished(): void {
    this.scenePersistent.setRecoverFinished();
    if (this.onRecoverFinishedCallback) {
      this.onRecoverFinishedCallback();
    }
    const recoverSessionIdList = this.scenePersistent.getAllPersistentIds();
    sceneSessionManager.notifySessionRecoverStatus(false, recoverSessionIdList);
    SCBSceneMissionManager.getInstance().notifySessionRecoverFinished(recoverSessionIdList);
    this.recoverState = SCBRecoverState.STATE_FINAL;
    this.publishRecoverEvent(this.recoverState.toString(), COMMON_EVENT_SCB_RECOVER_ENABLE_INPUT);
  }

  private getUnRecoveredSessions(): Array<SCBSceneInfo> {
    let unRecovered: Array<SCBSceneInfo> = [];
    for (const persistentId of this.sessionsNeedRecover.keys()) {
      if (!this.scenePersistent.hasPersistentIdElem(persistentId)) {
        unRecovered.push(this.sessionsNeedRecover.get(persistentId));
      }
    }
    return unRecovered;
  }
}