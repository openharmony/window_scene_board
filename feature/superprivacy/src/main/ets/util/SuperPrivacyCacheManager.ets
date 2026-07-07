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
// import superPrivacyManager from '@ohos.security.superPrivacyManager';
import { SingletonHelper, LogDomain, Logger } from '@ohos/basicutils';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = 'SuperPrivacyCacheManager';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);

// 缓存超级隐私状态值，旨在避免超级隐私订阅时候十来ms开销
class SuperPrivacyCacheManager {
  private callbackArray: Array<Callback<number>> = [];
  private superPrivacyCallback: Callback<number> = (mode: ESObject) => {
    this.currentSuperPrivacyMode = mode;
    this.callbackArray.forEach((item: Callback<number>) => {
      item?.(mode);
    });
  }
  private bInit: boolean = false;
  private currentSuperPrivacyMode: ESObject | undefined = undefined;

  constructor() {
  }

  private init() {
    // superPrivacyManager.on('superPrivacyModeChange', this.superPrivacyCallback);
    this.bInit = true;
  }

  private unInit(): void {
    // superPrivacyManager.off('superPrivacyModeChange', this.superPrivacyCallback);
    this.bInit = false;
    this.currentSuperPrivacyMode = undefined;
  }

  // 接口定义以及异常码同SuperPrivacyManager的function on(type: 'superPrivacyModeChange', callback: Callback<number>): void;
  public on(type: 'superPrivacyModeChange', callback: Callback<number>): void {
    log.debug(TAG, `listen superPrivacyModeChange`);
    if (!this.bInit) {
      this.init();
      this.callbackArray.push(callback);
    } else if (this.currentSuperPrivacyMode !== undefined) {
      this.callbackArray.push(callback);
      callback?.(this.currentSuperPrivacyMode);
    }
  }

  // 接口定义以及异常码同SuperPrivacyManager的function off(type: 'superPrivacyModeChange', callback?: Callback<number>): void;
  public off(type: 'superPrivacyModeChange', callback: Callback<number>): void {
    log.debug(TAG, `unlisten superPrivacyModeChange`);
    let index = this.callbackArray.indexOf(callback);
    if (index === -1) {
      return;
    } else {
      this.callbackArray.splice(index, 1);
    }
    if (this.callbackArray.length === 0 && this.bInit) {
      this.unInit();
    }
  }

  // 接口定义以及异常码同SuperPrivacyManager的function setSuperPrivacyMode(mode: SuperPrivacyMode, source: Source): Promise<void>;
  public setSuperPrivacyMode(mode: ESObject,
    source: ESObject): Promise<void> {
    // return superPrivacyManager.setSuperPrivacyMode(mode, source);
    return new Promise(()=>{});
  }

  // 接口定义以及异常码同SuperPrivacyManager的function getSuperPrivacyMode() : Promise<SuperPrivacyMode>;
  public getSuperPrivacyMode(): Promise<ESObject> {
    log.debug(TAG, `getSuperPrivacyMode`);
    if (this.currentSuperPrivacyMode === undefined || !this.bInit) {
      /*return superPrivacyManager.getSuperPrivacyMode().then((mode: ESObject) => {
        this.currentSuperPrivacyMode = mode;
        return Promise.resolve(mode);
      });*/
      return new Promise(()=>{});
    } else {
      return Promise.resolve(this.currentSuperPrivacyMode);
    }
  }
}

let superPrivacyCacheManager = SingletonHelper.getInstance(SuperPrivacyCacheManager, TAG);

export { superPrivacyCacheManager };