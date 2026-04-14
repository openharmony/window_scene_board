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
import { AbstractObserverManager, ObserverAble } from '../base/AbstractObserverManager';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import Queue from '@ohos.util.Queue';
import display from '@ohos.display';

const TAG = 'FrequentFoldManager';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const FOLD_LIMIT: number = 4;

const FOLD_LIMIT_INTERVAL: number = 10 * 1000;


/**
 * 频繁折叠开合状态变化监听
 */
export interface FrequentFoldChangeListener extends ObserverAble {
  /**
   * 频繁开合状态变化
   *
   * @param isFrequentFold 用户是否正在频繁折叠开合
   */
  onFrequentFoldChange(isFrequentFold: boolean): void;
}

/**
 * 频繁折叠管理，小折叠特有
 */
export class FrequentFoldManager extends AbstractObserverManager<FrequentFoldChangeListener> {
  private static sInstance: FrequentFoldManager;
  /**
   * 用户是否正在频繁开合(10s内折叠开合4次以上)
   */
  private _isFrequentFold: boolean = false;

  private _isFoldStatus: display.FoldStatus = display.FoldStatus.FOLD_STATUS_UNKNOWN;

  private _lastFoldTime: number = 0;

  private _intervalList: Queue<number> = new Queue();

  private _resetTimeoutId: number = 0;

  private foldStatusChangeCallback: Callback<display.FoldStatus> = (newFoldStatus: display.FoldStatus): void => {
    if (this._isFoldStatus === newFoldStatus) {
      return;
    }
    this._isFoldStatus = newFoldStatus;
    if (newFoldStatus !== display.FoldStatus.FOLD_STATUS_FOLDED &&
      newFoldStatus !== display.FoldStatus.FOLD_STATUS_EXPANDED) {
      return;
    }
    this.updateFrequentFoldScene();
  };

  public static getInstance(): FrequentFoldManager {
    if (FrequentFoldManager.sInstance == null) {
      FrequentFoldManager.sInstance = new FrequentFoldManager();
    }
    return FrequentFoldManager.sInstance;
  }

  public get isFrequentFoldChange(): boolean {
    return this._isFrequentFold;
  }

  public set isFrequentFoldChange(isFrequentFold: boolean) {
    if (this._isFrequentFold !== isFrequentFold) {
      log.showWarn(`set isFrequentFoldChange, _isFrequentFold: ${this._isFrequentFold}, isFrequentFold: ${isFrequentFold}`);
      this._isFrequentFold = isFrequentFold;
      this.broadcastDataChange((observer) => observer.onFrequentFoldChange(isFrequentFold));
    }
  }

  /**
   * 折叠开合时触发，更新此时是否处于频繁开合状态
   */
  private updateFrequentFoldScene(): void {
      return;
  }

  private calculateFrequentFoldScene(): boolean {
    if (this._lastFoldTime === 0) {
      this._lastFoldTime = Date.now();
      return false;
    }
    let currentTime = Date.now();
    let interval = currentTime - this._lastFoldTime;
    this._lastFoldTime = currentTime;
    // 新的间隔时间入队, 如果队列已满则队首出队
    if (this._intervalList.length >= FOLD_LIMIT) {
      this._intervalList.pop();
    }
    this._intervalList.add(interval);
    if (this._intervalList.length < FOLD_LIMIT) {
      return false;
    }
    // 获取最近4次开合的间隔总和, 如果小于10s, 认为处于频繁开合状态
    let duration: number = 0;
    this._intervalList.forEach((time) => {
      duration += time;
    });
    log.showInfo(`calculateFrequentFoldScene, length: ${this._intervalList.length}, duration: ${duration}`);
    return duration < FOLD_LIMIT_INTERVAL;
  }

  /**
   * 初始化
   */
  public doInit(): void {
    try {
      display.on('foldStatusChange', this.foldStatusChangeCallback);
    } catch (e) {
      log.showError(`doInit code: ${e?.code}, msg: ${e?.message}`);
    }
  }

  public doRelease(): void {
    try {
      display.off('foldStatusChange', this.foldStatusChangeCallback);
    } catch (e) {
      log.showError(`doRelease code: ${e?.code}, msg: ${e?.message}`);
    }
  }

  public registerObserver(observer: FrequentFoldChangeListener, isCallbackImmediately?: boolean,
    highPriory?: boolean): void {
    super.registerObserver(observer, isCallbackImmediately, highPriory);
    if (isCallbackImmediately) {
      this.broadcastDataChange((observer) => observer.onFrequentFoldChange(this._isFrequentFold));
    }
  }

  protected broadcastDataChange(callback: (observer: FrequentFoldChangeListener) => void): void {
    super.broadcastDataChange(callback);
  }
}