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

import appManager from '@ohos.app.ability.appManager';
// import statusBar from '@hms.pcService.statusBar';
import { SCBSceneInfo } from './SCBSceneInfo';
import { SCBSceneSession } from './SCBSceneSession';
import { SCBSceneSessionManager } from './SCBSceneSessionManager';
import { SCBSceneContainerSession } from './SCBSceneContainerSession';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { EvtBus, EventManager } from '@ohos/frameworkwrapper';
import { sEventManager } from '@ohos/frameworkwrapper';
import { ProcessStateChangeEvent } from '@ohos/frameworkwrapper';
import { DropDownPanelManagerWrapper } from '@ohos/frameworkwrapper';
import { SCBExpandGuideParam } from './SCBExpandGuideParam';

const TAG = 'SCBTogManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const EXIT_NOTIFY_WAITE: number = 150;

export enum NotifyState {
  SHOW_IN = 1,
  SHOW_OUT = 2,
  HIDE_OUT = 3
}

export enum StartFrom {
  ICON = 1,
  RECENT = 2,
  TRANSITION = 3,
  OTHER = 4
}

export const PC_APP_WHITE_LIST: string[] = [
];

export const PC_IN_PHONE_LIST: string[] = SCBExpandGuideParam.getPcInPhoneList();

export class NotifyPCModeCallback {
  public onStateChange?: Function | null = null;
  public onTipsChange?: Function | null = null;
}

export class SCBTogManager {
  private static instance: SCBTogManager;
  private recoderSceneInfo?: SCBSceneInfo;
  private recoderStartFrom?: StartFrom;
  private notifyPCModeCallbacks: NotifyPCModeCallback[] = [];
  private pids: number[] = [];
  private bundleNames: string[] = [];
  private processInformation: Array<appManager.ProcessInformation> = [];
  private eventMgr: EventManager = EvtBus.createEventManager();
  private isShowingTips: boolean = false;

  private constructor() {
  }

  /**
   * 获取instance单例
   * @returns instance
   */
  public static getInstance(): SCBTogManager {
    if (!SCBTogManager.instance) {
      SCBTogManager.instance = new SCBTogManager();
    }
    return SCBTogManager.instance;
  }

  /**
   * 注册显隐弹窗回调
   * @param callback
   */
  public registerNotifyPCModeCallback(callback: NotifyPCModeCallback | null): void {
    if (!callback) {
      return;
    }
    let index = this.notifyPCModeCallbacks.indexOf(callback);
    if (index === -1) {
      log.showInfo('registerNotifyPCModeCallback successful');
      this.notifyPCModeCallbacks.push(callback);
    } else {
      log.showWarn('registerNotifyPCModeCallback fail, callback has already exist');
    }
  }

  /**
   * 去注册显隐弹窗回调
   * @param callback
   */
  public unregisterNotifyPCModeCallback(callback: NotifyPCModeCallback | null): void {
    if (!callback) {
      return;
    }
    let index = this.notifyPCModeCallbacks.indexOf(callback);
    if (index === -1) {
      log.showDebug('unregisterNotifyPCModeCallback successful');
      this.notifyPCModeCallbacks.splice(index, 1);
    } else {
      log.showWarn('unregisterNotifyPCModeCallback fail, callback has already exist');
    }
  }

  private getUniqueBundleNames(): string[] {
    let uniqueBundleNames: string[] = [];
    for (const bundleName of this.bundleNames) {
      if (!uniqueBundleNames.includes(bundleName)) {
        uniqueBundleNames.push(bundleName);
      }
    }
    return uniqueBundleNames;
  }

  private updateRunningPids(pid: number): void {
    let index = this.pids.indexOf(pid);
    if (index !== -1) {
      log.showInfo(`onProcessDied pid:${pid} died`);
      this.pids.splice(index, 1);
      this.bundleNames.splice(index, 1);
      if (this.pids.length === 0) {
        this.notifyStateChange(NotifyState.HIDE_OUT);
      } else {
        this.notifyTipsChange(this.getUniqueBundleNames());
      }
    }
  }

  private async getAllProcess(): Promise<void> {
    try {
      this.processInformation = await appManager.getRunningProcessInformation();
    } catch (paramError) {
      log.showError('getAllProcess error', paramError);
    }
  }

  private async getRunningPids(): Promise<void> {
    this.pids = [];
    this.bundleNames = [];
    await this.getAllProcess();
    for (const item of this.processInformation) {
      for (const bundleName of item.bundleNames) {
        if (PC_APP_WHITE_LIST.includes(bundleName) && !this.pids.includes(item.pid)) {
          log.showInfo(`tryToExitPCMode isPCAPP push processid:${item.pid}, bundleName:${bundleName}`);
          this.pids.push(item.pid);
          this.bundleNames.push(bundleName);
        }
      }
    }
  }

  private onProcessStateChangeEvent = (event: ProcessStateChangeEvent): void => {
    log.showInfo(`onProcessStateChangeEvent pid: ${event.requestPid}, event:${JSON.stringify(event)}`);
    if (!event.visible) {
      this.updateRunningPids(event.requestPid as number);
    }
  };

  private async checkNeedExitNotify(): Promise<void> {
    await this.getRunningPids();
    log.showInfo(`checkNeedExitNotify pid length ${this.pids.length}, bundles length ${this.bundleNames.length}`);
    if (this.pids.length > 0) {
      this.eventMgr.on(ProcessStateChangeEvent, this.onProcessStateChangeEvent);
      this.notifyTipsChange(this.getUniqueBundleNames());
      this.notifyStateChange(NotifyState.SHOW_OUT);
      return;
    }
  }

  private async tryToExitPCMode(): Promise<void> {
    await this.getRunningPids();
    log.showInfo(`tryToExitPCMode pid length ${this.pids.length}`);
    if (this.pids.length > 0) {
      // statusBar.exitProcesses(this.pids);
      setTimeout(() => {
        this.checkNeedExitNotify();
      }, EXIT_NOTIFY_WAITE);
      return;
    }
  }

  private notifyStateChange(state: NotifyState): void {
    this.isShowingTips = state === NotifyState.SHOW_IN;
    this.notifyPCModeCallbacks.forEach((callback: NotifyPCModeCallback) => {
      if (callback.onStateChange) {
        callback.onStateChange(state);
      }
    });
  }

  private notifyTipsChange(bundleNames: string[]): void {
    this.notifyPCModeCallbacks.forEach((callback: NotifyPCModeCallback) => {
      if (callback.onTipsChange) {
        callback.onTipsChange(bundleNames);
      }
    });
  }

  /**
   * StartScene入口
   * @param sceneInfo
   * @Param startFrom (enum ICON, OTHER, RECENT, TRANSITION)
   * @returns boolean (白名单应用返回true，非白名单应用返回false，startFrom ICON和OTHER启动弹窗)
   */
  public onStartScene(sceneInfo: SCBSceneInfo, startFrom: StartFrom): boolean {
    return false;
  }

  public showTips(): void {
    this.notifyStateChange(NotifyState.SHOW_IN);
    DropDownPanelManagerWrapper.getInstance().hideWindowDirectly();
  }

  public hideTips(): void {
    if (this.isShowingTips) {
      this.notifyStateChange(NotifyState.HIDE_OUT);
    }
  }

  private setRecoderSceneInfo(sceneInfo: SCBSceneInfo, startFrom: StartFrom): void {
    if (sceneInfo) {
      log.showInfo(`setRecoderSceneInfo:${sceneInfo.bundleName}`);
      this.recoderSceneInfo = sceneInfo;
      this.recoderStartFrom = startFrom;
      return;
    }
  }

  /**
   * clearRecoderSceneInfo
   * 清空记录的SceneInfo和StartFrom
   */
  public clearRecoderSceneInfo(): void {
    this.recoderSceneInfo = undefined;
    this.recoderStartFrom = undefined;
  }

  /**
   * getRecoderSceneInfo
   * @returns SCBSceneInfo
   */
  public getRecoderSceneInfo(): SCBSceneInfo {
    return this.recoderSceneInfo as SCBSceneInfo;
  }

  /**
   * getRecoderStartFrom
   * @returns StartFrom
   */
  public getRecoderStartFrom(): StartFrom {
    return this.recoderStartFrom as StartFrom;
  }

  /**
   * offProcessStateListening when NotifyPCModePanel hide
   */
  public offProcessStateListening(): void {
    this.eventMgr.offAll();
  }
 
  /**
   * when a conatinerSession not in split mode contains whitelist app return true otherwise return false
   */
  public isPCFloat(containerSession: SCBSceneContainerSession): boolean {
    if (!containerSession) {
      return false;
    }
    if (containerSession.isSplit) {
      if (containerSession.primarySession && containerSession.secondarySession) {
        log.showInfo(`isPCFloat isSplit`);
        return false;
      }
      if ((containerSession.primarySession && this.checkWhiteList(containerSession.primarySession)) ||
        (containerSession?.secondarySession && this.checkWhiteList(containerSession?.secondarySession))) {
        log.showInfo(`isPCFloat pcApp in preSplit`);
        return true;
      }
    }
    if (containerSession.primarySession && this.checkWhiteList(containerSession.primarySession)) {
      log.showInfo(`isPCFloat pcApp`);
      return true;
    }
    return false;
  }
 
  private checkWhiteList(sceneSession: SCBSceneSession): boolean {
    if (PC_APP_WHITE_LIST.includes(sceneSession.sceneInfo.bundleName)) {
      log.showInfo(`checktrustlist ${sceneSession.sceneInfo.bundleName} in trustlist`);
      return true;
    }
    return false;
  }
}