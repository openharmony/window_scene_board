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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { sSettingsUtil } from '@ohos/frameworkwrapper';
import { AbstractObserverManager } from '../base/AbstractObserverManager';
import { DataShareHelper, DataType } from '../utils/DataShareHelper';

const TAG = 'RemoteLockStateManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const REMOTE_LOCK_STATUS_KEY: string = 'settings.edm.lock_device_enable';
const REMOTE_LOCK_TIPS_KEY: string = 'settings.edm.lock_device_info';
const LOCK_STATUS_DEFAULT_VALUE: string = 'false';
const LOCK_STATUS_LOCKED_VALUE: string = 'true';
const LOCK_TIPS_DEFAULT_VALUE: string = 'The device has been locked by the administrator.';

/**
 * 锁定状态变化监听器
 */
export interface RemoteLockStateChangeListener {
  /**
   * 变更函数
   *
   * @param fingerprintData 指纹数据
   */
  onRemoteLockStateChange?: (isLocked: boolean, lockedTips: string) => void;
}

/**
 * 锁定状态管理器
 */
export class RemoteLockStateManager extends AbstractObserverManager<RemoteLockStateChangeListener> {
  private static sInstance: RemoteLockStateManager;

  public static getInstance(): RemoteLockStateManager {
    if (RemoteLockStateManager.sInstance == null) {
      RemoteLockStateManager.sInstance = new RemoteLockStateManager();
    }
    return RemoteLockStateManager.sInstance;
  }

  private _isRemoteLocked: boolean;
  private _remoteLockTips: string;
  private _dataShareHelper: DataShareHelper;

  private constructor() {
    super();
    this._isRemoteLocked = this.getRemoteLockStatus();
    this._remoteLockTips = this.getRemoteLockTips();
    this._dataShareHelper = new DataShareHelper(DataType.NORMAL, REMOTE_LOCK_STATUS_KEY,
      () => this.handleRemoteLockStatus());
  }

  public get isRemoteLocked(): boolean {
    return this._isRemoteLocked;
  }

  public get remoteLockedTips(): string {
    return this._remoteLockTips;
  }

  protected doInit(): void {
    log.showInfo('doInit');
    this._dataShareHelper.registerDataShareListener();
  }

  protected doRelease(): void {
    log.showInfo('doRelease');
    this._dataShareHelper.unRegisterDataShareListener();
  }

  private handleRemoteLockStatus(): void {
    try {
      log.showInfo('receive dataChange notify');
      let newLocked: boolean = this.getRemoteLockStatus();
      let newTips: string = this.getRemoteLockTips();
      if (this._isRemoteLocked !== newLocked || this._remoteLockTips !== newTips) {
        log.showInfo(`data changed: [${this._isRemoteLocked}, ${this._remoteLockTips}] -> [${newLocked}, ${newTips}]`);
        this._isRemoteLocked = newLocked;
        this._remoteLockTips = newTips;
        this.broadcastDataChange(listener => listener.onRemoteLockStateChange?.(newLocked, newTips));
      }
    } catch (error) {
      log.showError('handleRemoteLockStatus error.');
    }
  }

  private getRemoteLockStatus(): boolean {
    return sSettingsUtil.getValue(REMOTE_LOCK_STATUS_KEY, LOCK_STATUS_DEFAULT_VALUE) === LOCK_STATUS_LOCKED_VALUE;
  }

  private getRemoteLockTips(): string {
    return sSettingsUtil.getValue(REMOTE_LOCK_TIPS_KEY, LOCK_TIPS_DEFAULT_VALUE);
  }
}