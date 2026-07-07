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
import IAodProxy from '../model/IAodProxy';

const TAG = 'OneMirrorAodProxy';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AOD, TAG);
const DISPLAY_SCREEN_ON: number = 0;

export class OneMirrorAodProxy {
  private static instance: OneMirrorAodProxy;
  private isSupportOneMirror: boolean = false; // 缓存数据，灭屏需要刷新
  private isLemProductAndSubDisplay: boolean = false; // 缓存数据，灭屏需要刷新
  private isMirrorFinish: boolean = false;
  private aodProxy?: IAodProxy;
  private onPreStartAod?: (isSupportAnim: boolean) => void;
  private onPreStopAod?: () => void;

  private constructor() {
  }

  public static getInstance(): OneMirrorAodProxy {
    if (!OneMirrorAodProxy.instance) {
      OneMirrorAodProxy.instance = new OneMirrorAodProxy();
    }
    return OneMirrorAodProxy.instance;
  }

  /**
   * 初始化aodproxy
   * @param aodProxy
   */
  public doInit(aodProxy: IAodProxy): void {
    this.aodProxy = aodProxy;
  }

  /**
   * screenoffView上树注册灭屏回调，如果一镜到底已经结束，直接执行startaod
   * @param isSupportOneMirror
   * @param isLemProductAndSubDisplay
   * @param callback
   * @returns
   */
  public registerScreenOffFunc(callback: (isSupportAnim: boolean) => void, preStopCallback: () => void): void {
    this.onPreStartAod = callback;
    this.onPreStopAod = preStopCallback;
    if (this.isMirrorFinish) {
      log.showInfo(`registerScreenOffFunc start aod, ${this.isSupportOneMirror}, ${this.isLemProductAndSubDisplay}`);
      this.onPreStartAod?.(this.isSupportOneMirror);
      this.aodProxy?.start(this.isSupportOneMirror || this.isLemProductAndSubDisplay);
    }
  }

  /**
   * screenoffView下树解注册
   * @param preStopCallback
   */
  public unRegisterScreenOffFunc(): void {
    this.onPreStartAod = undefined;
  }

  /**
   * 一镜到底结束执行回调进入AOD
   * @param isSupportOneMirror
   * @param isLemProductAndSubDisplay
   * @param callback
   * @returns
   */
  public startAodEnter(isSupportOneMirror: boolean, isLemProductAndSubDisplay: boolean): void {
    this.isSupportOneMirror = isSupportOneMirror;
    this.isLemProductAndSubDisplay = isLemProductAndSubDisplay;
    if (!this.onPreStartAod) {
      log.showInfo('One mirror finish, wait for screenoff view appear');
      this.isMirrorFinish = true;
    } else {
      log.showInfo(`Bgein start aod, ${this.isSupportOneMirror}, ${this.isLemProductAndSubDisplay}`);
      this.onPreStartAod?.(this.isSupportOneMirror);
      this.aodProxy?.start(this.isSupportOneMirror || this.isLemProductAndSubDisplay);
    }
  }

  /**
   * 亮屏退出AOD
   * @param preStopCallback
   * @param postStopCallback
   */
  public stopAodEnter(): void {
    log.showInfo('handleScreenOnResult stop aod.');
    this.isMirrorFinish = false;
    this.onPreStopAod?.();
    this.aodProxy?.stop(DISPLAY_SCREEN_ON);
  }
}