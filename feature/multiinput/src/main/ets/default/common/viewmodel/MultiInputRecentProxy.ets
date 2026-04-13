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
import { SCBSceneContainerSession, SCBSceneContainerSessionArray, SCBSceneSessionManager} from '@ohos/windowscene';
import {LogDomain, LogHelper} from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';

const TAG = 'MultiInputRecentProxy';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const INVALID_NUM = -1;

export interface MultiInputRecentInterface {
  isCrossScreenFocusable: (() => boolean),
  getCurrentScreenId: (() => number),
  setCurrentSelectedIndex: ((index: number) => void),
  getCurrentSelectedIndex: (() => number),
  crossFocusToNextScreenRecentByAltTab: (() => void),
  getCurrentSelectedItem: (() => SCBSceneContainerSession | null),
  getContainerSessionListByScreenId: ((screenId: number) => SCBSceneContainerSessionArray),
  enterRecent: (() => void),
  enterAppCenter: (() => void),
  getShowInCurRecentContainerSessionList: () => SCBSceneContainerSessionArray
}


export class MultiInputRecentProxy {
  private static instance: MultiInputRecentProxy | null = null;
  private multiInputRecent: MultiInputRecentInterface | null = null;
  private recentSessionManager: RecentSessionManager | null = null;

  /**
   * Obtains the RecentFocusManager data model object.
   *
   * @return RecentFocusManager
   */
  static getInstance(): MultiInputRecentProxy {
    if (MultiInputRecentProxy.instance === null) {
      MultiInputRecentProxy.instance = new MultiInputRecentProxy();
    }
    return MultiInputRecentProxy.instance;
  }

  public registerMultiInputRecent(multiInputRecent: MultiInputRecentInterface): void {
    if (!this.multiInputRecent) {
      this.multiInputRecent = multiInputRecent;
      return;
    }
    log.showWarn(`registerRecent2MultiInput repeat`);
  }

  public initRecentSessionManager(recentSessionManager: RecentSessionManager): void {
    this.recentSessionManager = recentSessionManager;
  }

  public destroy(): void {
    this.recentSessionManager = null;
  }

  public isCrossScreenFocusable(): boolean {
    if (this.multiInputRecent === null) {
      return false;
    }
    return this.multiInputRecent.isCrossScreenFocusable();
  }

  public getShowInCurRecentContainerSessionList(): SCBSceneContainerSessionArray {
    if (DeviceHelper.isPC() && this.multiInputRecent) {
      return this.multiInputRecent.getShowInCurRecentContainerSessionList();
    }
    return SCBSceneSessionManager.getInstance().getContainerSessionList();
  }

  public getCurrentScreenId(): number {
    if (this.multiInputRecent === null) {
      return INVALID_NUM;
    }
    return this.multiInputRecent.getCurrentScreenId();
  }

  public setCurrentSelectedIndex(index: number): void {
    if (this.multiInputRecent === null) {
      return;
    }
    this.multiInputRecent.setCurrentSelectedIndex(index);
  }

  public getCurrentSelectedIndex(): number {
    if (this.multiInputRecent === null) {
      return INVALID_NUM;
    }
    return this.multiInputRecent.getCurrentSelectedIndex();
  }

  public crossFocusToNextScreenRecentByAltTab(): void {
    if (this.multiInputRecent === null) {
      return;
    }
    this.multiInputRecent.crossFocusToNextScreenRecentByAltTab();
  }

  public getCurrentSelectedItem(): SCBSceneContainerSession | null {
    if (this.multiInputRecent === null) {
      return null;
    }
    return this.multiInputRecent.getCurrentSelectedItem();
  }

  public getRecentContainerSessionList(screenId: number): SCBSceneContainerSessionArray {
    if (this.multiInputRecent === null) {
      return new SCBSceneContainerSessionArray();
    }
    return this.multiInputRecent.getContainerSessionListByScreenId(screenId);
  }

  public getCurrContainerSessionList(): SCBSceneContainerSessionArray {
    if (this.multiInputRecent === null) {
      return new SCBSceneContainerSessionArray();
    }
    return this.multiInputRecent.getContainerSessionListByScreenId(this.multiInputRecent.getCurrentScreenId());
  }

  public enterRecent(): void {
    if (this.multiInputRecent === null) {
      return;
    }
    this.multiInputRecent.enterRecent();
  }

  public enterAppCenter(): void {
    if (this.multiInputRecent === null) {
      return;
    }
    this.multiInputRecent.enterAppCenter();
  }
}

export abstract class RecentSessionManager {
  public abstract getShowInRecentSessionList(): SCBSceneContainerSessionArray;
}