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
import { GlobalContext } from '@ohos/frameworkwrapper';
import settings from '@ohos.settings';

const TAG = 'FloatingNavigationInfoMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);
const FLOAT_NAVIGATION_INFO = 'float_navigation_info';

export enum FloatingNavigationShowType {
  NOT_SHOW = -1,
  THREE_KEYS = 0,
  FLOATING = 1
}

export class FloatingNavigationInfo {
  showType?: number;
  region?: number[];
}

/**
 * 悬浮导航相关信息被观察者
 */
export class FloatingNavigationInfoMgr {
  private static mInstance: FloatingNavigationInfoMgr;
  private floatingNavigationInfo = new FloatingNavigationInfo();
  private infoObserverMap: Map<String, Function> = new Map();

  public static getInstance(): FloatingNavigationInfoMgr {
    if (!FloatingNavigationInfoMgr.mInstance) {
      FloatingNavigationInfoMgr.mInstance = new FloatingNavigationInfoMgr();
    }
    return FloatingNavigationInfoMgr.mInstance;
  }

  private constructor() {
  }

  /**
   * 初始化FloatingNavigationInfoMgr
   */
  public init(): void {
    this.registerNavigationInfoSettingData();
  }

  private registerNavigationInfoSettingData(): void {
    try {
      settings.registerKeyObserver(GlobalContext.getContext(), FLOAT_NAVIGATION_INFO, settings.domainName.USER_PROPERTY,
        () => {
          let value = settings.getValueSync(GlobalContext.getContext(), FLOAT_NAVIGATION_INFO, '',
            settings.domainName.USER_PROPERTY);
          log.showInfo(`receive float_navigation_info change:${value}`);
          try {
            this.floatingNavigationInfo = JSON.parse(value) as FloatingNavigationInfo;
          } catch (e) {
            log.showError(`parse float_navigation_info error`);
          }
          this.infoObserverMap.forEach((callback: Function) => {
            callback?.(this.floatingNavigationInfo);
          });
        });
    } catch (err) {
      log.showError(TAG, `registerKeyObserver error: ${err?.code}, ${err?.message}`);
    }
  }

  /**
   * 获取悬浮导航相关信息
   *
   * @returns 悬浮导航相关信息
   */
  public getFloatingNavigationInfo(): FloatingNavigationInfo {
    return this.floatingNavigationInfo;
  }

  /**
   * 注册悬浮导航信息观察者
   *
   * @param caller 注册的场景caller
   * @param callBack 回调
   */
  public registerNavigationInfoObserver(sceneType: string, callBack: Function): void {
    log.showInfo(`registerWindowInfoObserver sceneType=${sceneType}.`);
    this.infoObserverMap.set(sceneType, callBack);
  }

  /**
   * 注销悬浮导航信息观察者
   *
   * @param caller 注册的场景caller
   */
  public unRegisterNavigationInfoObserver(sceneType: string): void {
    if (!this.infoObserverMap.has(sceneType)) {
      log.showInfo(`unRegister sceneType=${sceneType} error, no such sceneType`);
      return;
    }
    this.infoObserverMap.delete(sceneType);
    log.showInfo(`unRegister sceneType=${sceneType} success`);
  }
}

// 单例
export let floatingNavigationInfoMgr: FloatingNavigationInfoMgr = FloatingNavigationInfoMgr.getInstance();