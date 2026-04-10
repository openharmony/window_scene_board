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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { localEventManager } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';

const TAG = 'ScreenLockWifiEventManager';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * 锁屏 Wifi 图标点击事件回调函数的类型
 * @eventName 事件名
 * @params 事件传递的参数
 */
export type ScreenLockWifiIconClickCallback = (eventName: string, params: IScreenLockWifiIconClickParams) => void;

/**
 * 锁屏 Wifi 图标点击事件传递的参数接口
 */
export interface IScreenLockWifiIconClickParams {
  event: ClickEvent;
}

/**
 * 锁屏 Wifi 图标点击事件监听器接口
 */
export interface ScreenLockWifiListener {
  onReceiveEvent: ScreenLockWifiIconClickCallback;
}

/**
 * 锁屏 Wifi 事件管理器
 */
class ScreenLockWifiEventManager {
  // 图标点击事件名
  public readonly iconClickEventName: string = 'screen_lock_wifi_icon_clicked';

  /**
   * 发送图标点击事件
   *
   * @param event 点击事件数据
   */
  public postIconClick(event: ClickEvent): void {
    log.info('postIconClick');
    const params: IScreenLockWifiIconClickParams = {
      event: event,
    };
    try {
      localEventManager.sendLocalEvent(this.iconClickEventName, params);
    } catch (err) {
      log.error(`postIconClick failed ${err?.code} ${err?.message}`);
    }
  }

  /**
   * 注册图标点击事件
   *
   * @param listener 事件监听器
   */
  public registerIconClick(listener: ScreenLockWifiListener): void {
    log.info('registerIconClick');
    try {
      localEventManager.registerEventListener(listener, [this.iconClickEventName]);
    } catch (err) {
      log.error(`registerIconClick failed ${err?.code} ${err?.message}`);
    }
  }

  /**
   * 反注册图标点击事件
   *
   * @param listener 事件监听器
   */
  public unregisterIconClick(listener: ScreenLockWifiListener): void {
    log.info('unregisterIconClick');
    try {
      localEventManager.unregisterEventListener(listener);
    } catch (err) {
      log.error(`unregisterIconClick failed ${err?.code} ${err?.message}`);
    }
  }
}

// 单例
const screenLockWifiEventMgr = SingletonHelper.getInstance(ScreenLockWifiEventManager, 'ScreenLockWifiMgr');

export default screenLockWifiEventMgr;