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
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SCBRecentRotateLock } from './SCBRecentRotateLock';

const TAG = 'SCBRecentPanelViewModel';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

export class SCBRecentPanelViewModel {
  private screenID: number;
  private rsID: number = 0;
  private recentRotateLock: SCBRecentRotateLock;
  private exitRecentViewCallback?: Callback<boolean>;

  constructor(screenID: number) {
    this.screenID = screenID;
    this.recentRotateLock = new SCBRecentRotateLock(this.screenID);
  }

  public updateRsID(rsID: number): void {
    if (rsID === this.rsID) {
      return;
    }
    log.showInfo(`updateRsID:${this.rsID}, ${rsID}, ${this.screenID}`);
    this.rsID = rsID;
    this.exitRecentView(true, 'screen change');
  }

  public destroy(): void {
    this.recentRotateLock.disableRotateLock('panel destroy');
  }

  public exitRecentView(needAni: boolean, reason?: string): void {
    log.showInfo(`exit recent view, reason:${reason}, ${needAni}, ${this.screenID}`);
    if (!this.exitRecentViewCallback) {
      log.showWarn('exitRecentViewCallback is undefined');
      return;
    }
    this.exitRecentViewCallback(needAni);
  }

  public registerExitRecentViewCallback(callback: Callback<boolean>): void {
    this.exitRecentViewCallback = callback;
  }

  public unregisterExitRecentViewCallback(): void {
    this.exitRecentViewCallback = undefined;
  }
}

export class SCBRecentPanelManager {
  private static instance: SCBRecentPanelManager;
  private recentPanelMap: Map<number, SCBRecentPanelViewModel> = new Map();

  private constructor() {
  }

  public static getInstance(): SCBRecentPanelManager {
    if (!SCBRecentPanelManager.instance) {
      SCBRecentPanelManager.instance = new SCBRecentPanelManager();
    }
    return SCBRecentPanelManager.instance;
  }

  public getRecentPanelViewModel(screenID: number): SCBRecentPanelViewModel {
    let recentPanel = this.recentPanelMap.get(screenID);
    if (!recentPanel) {
      recentPanel = new SCBRecentPanelViewModel(screenID);
      this.recentPanelMap.set(screenID, recentPanel);
    }
    return recentPanel;
  }

  public removeRecentPanelViewModel(screenID: number): void {
    this.recentPanelMap.delete(screenID);
  }
}