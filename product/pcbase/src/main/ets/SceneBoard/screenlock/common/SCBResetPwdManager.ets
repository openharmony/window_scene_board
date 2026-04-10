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

import { SystemParameterUtil } from '@ohos/launchercommon/src/main/ets/utils/SystemParameterUtil';
import { LogDomain, Logger } from '@ohos/basicutils'
import { Callback } from '@kit.BasicServicesKit';

const TAG = 'SCBResetPwdManager';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

const RESET_PASSWORD_MOD = 'persist.pc_security.reset_password_mod';
const DEFAULT_RESET_PASSWORD_MOD_VALUE = '0';

/**
 * 重设密码管理类
 */
export class SCBResetPwdManager {
  private static instance: SCBResetPwdManager;
  private _resetPwdMod: string = DEFAULT_RESET_PASSWORD_MOD_VALUE;
  private _resetPwdPage: boolean = false;
  private _resetPwdEntry: boolean = false;
  private _resetPwdEntryChangeCallbacks: Set<Callback<boolean>> = new Set();

  public static getInstance(): SCBResetPwdManager {
    if (!SCBResetPwdManager.instance) {
      SCBResetPwdManager.instance = new SCBResetPwdManager;
    }
    return SCBResetPwdManager.instance;
  }

  public init(): void {
    this._resetPwdMod = SystemParameterUtil.getSync(RESET_PASSWORD_MOD, DEFAULT_RESET_PASSWORD_MOD_VALUE);
    this._resetPwdPage = this._resetPwdMod !== DEFAULT_RESET_PASSWORD_MOD_VALUE;
    this._resetPwdEntryChangeCallbacks.clear();
  }


  /**
   * 是否进入重设密码阶段
   *
   * @return {boolean} true-在重设密码阶段，false-不在重设密码阶段
   */
  public get resetPwdMod(): string {
    return this._resetPwdMod;
  }

  /**
   * 是否进入重设密码阶段
   *
   * @return {boolean} true-在重设密码阶段，false-不在重设密码阶段
   */
  public get resetPwdPageShow(): boolean {
    return this._resetPwdPage;
  }

  /**
   * 提供给外部更新ResetPwdPage阶段的能力
   *
   * @param resetPwdPageShow 是否在重设密码阶段
   */
  public setResetPwdPage(resetPwdPageShow: boolean): void {
    this._resetPwdPage = resetPwdPageShow;
  }

  /**
   * 是否显示密码重设入口
   *
   * @return {boolean} true-重设密码入口显示，false-重设密码入口不显示
   */
  public get resetPwdEntry(): boolean {
    return this._resetPwdEntry;
  }

  /**
   * 提供给外部更新ResetPwdEntry显示状态的能力
   *
   * @param resetPwdEntryShow 是否显示重设密码按钮
   */
  public setResetPwdEntry(resetPwdEntryShow: boolean, reason: string = ''): void {
    if (this._resetPwdEntry === resetPwdEntryShow) {
      return;
    }
    log.info(TAG, `resetPwdEntryShow is changed. reason: ${reason}`);
    this._resetPwdEntry = resetPwdEntryShow;
    this.notifyResetPwdEntryChange(this._resetPwdEntry);
  }

  public registerResetPwdEntryChange(callback: Callback<boolean>): void {
    this._resetPwdEntryChangeCallbacks.add(callback);
  }

  public unregisterResetPwdEntryChange(callback: Callback<boolean>): void {
    this._resetPwdEntryChangeCallbacks.delete(callback);
  }

  private notifyResetPwdEntryChange(resetPwdEntry: boolean): void {
    for (let callback of this._resetPwdEntryChangeCallbacks) {
      callback(resetPwdEntry);
    }
  }
}