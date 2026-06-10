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

import { BusinessError } from '@kit.BasicServicesKit';
import wifiManager from '@ohos.wifiManager';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { WifiConstants } from '../constants/WifiConstants';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, 'GlassWifiManager');

export class GlassWifiManager {
  public static instance?: GlassWifiManager;
  private updateWifiIconColorCallback?: ((color: ResourceColor) => void);
  private updateWifiIconBgColorCallback?: ((color: ResourceColor) => void);
  private updateWifiNameCallback?: ((name: ResourceStr) => void);

  private constructor() {
  }

  /*
   * 注册更新wifi图标颜色回调
   * */
  public registerUpdateWifiIconColorCallback(callback: (color: ResourceColor) => void): void {
    this.updateWifiIconColorCallback = callback;
  }

  /*
   * 注册更新wifi图标背景颜色回调
   * */
  public registerUpdateWifiIconBgColorCallback(callback: (color: ResourceColor) => void): void {
    this.updateWifiIconBgColorCallback = callback;
  }

  /*
   * 注册更新wifi名称回调
   * */
  public registerUpdateWifiNameCallback(name: (name: ResourceStr) => void): void {
    this.updateWifiNameCallback = name;
  }

  /*
   * 获取wifi管理类单实例
   *
   * @return GlassWifiManager
   * */
  public static getInstance(): GlassWifiManager {
    if (!GlassWifiManager.instance) {
      GlassWifiManager.instance = new GlassWifiManager();
    }
    return GlassWifiManager.instance;
  }

  /*
   * 销毁wifi管理类单实例
   * */
  public static destroyInstance(): void {
    log.showInfo(`destroyInstance`)
    if (GlassWifiManager.instance) {
      GlassWifiManager.instance.updateWifiIconColorCallback = undefined;
      GlassWifiManager.instance.updateWifiIconBgColorCallback = undefined;
      GlassWifiManager.instance.updateWifiNameCallback = undefined;
      GlassWifiManager.instance = undefined;
    }
  }

  private enableWifi(): void {
    try {
      wifiManager.enableWifi();
    } catch (err) {
      this.logError(err);
    }
  }

  private disableWifi(): void {
    try {
      wifiManager.disableWifi();
    } catch (err) {
      this.logError(err);
    }
  }

  /*
   * 更新wifi状态
   * */
  public updateStatus(): void {
    if (wifiManager.isWifiActive()) {
      this.updateWifiLinkedInfo();
      this.updateWifiStatus();
    } else {
      this.resetWifiStatus();
    }
  }

  /**
   * 监听 WiFi 状态变化的方法
   * 当 WiFi 状态发生变化时，会触发回调函数，并根据当前的 WiFi 状态进行相应的处理
   */
  public onWifiStateChangeListener(): void {
    wifiManager.on('wifiStateChange', () => {
      if (wifiManager.isWifiActive()) {
        log.info('wifiStateChange WiFi is now active.');
        this.updateWifiStatus();
        this.checkAndResolveConnection();
      } else {
        log.error('wifiStateChange WiFi is now inactive.');
        this.resetWifiStatus();
      }
    });
  }

  /**
   * 监听 WiFi 连接变化的方法
   * 当 WiFi 连接发生变化时，会触发回调函数，并根据当前的 WiFi 状态进行相应的处理
   */
  public onWifiConnectionChangeListener(): void {
    wifiManager.on('wifiConnectionChange', (result: number) => {
      if (wifiManager.isWifiActive()) {
        log.info(`wifiConnectionChange WiFi is now active.result is ${result}`);
        this.updateWifiStatus();
        this.checkAndResolveConnection();
        if (result === 0) {
          this.setWifiName($r('app.string.control_center_wlan'));
        } else {
          this.updateWifiLinkedInfo();
        }
      } else {
        log.error(`WiFi is now inactive.result is ${result}`);
        this.resetWifiStatus();
      }
    });
  }

  private logError(err: BusinessError) {
    log.error('errCode: ' + err.code + ', errMessage: ' +
    err.message);
  }

  private updateWifiStatus() {
    log.showInfo(`updateWifiStatus,now wifi is open`);
    this.setWifiColor(WifiConstants.CAPSULE_OPEN_COLOR);
    this.setWifiFillColor(WifiConstants.CAPSULE_ICON_OPEN_COLOR);
  }

  private resetWifiStatus() {
    log.showInfo(`resetWifiStatus,now wifi is close`);
    this.setWifiName($r('app.string.control_center_wlan'));
    this.setWifiColor(WifiConstants.CAPSULE_CLOSE_COLOR);
    this.setWifiFillColor(WifiConstants.CAPSULE_ICON_CLOSE_COLOR);
  }

  private async updateWifiLinkedInfo() {
    try {
      const data = await wifiManager.getLinkedInfo();
      this.setWifiName(data.ssid)
    } catch (error) {
      log.error('get wifi linked info: ' + error.code);
    }
  }

  public wifiSwitch(): void {
    try {
      let isWifiActive = wifiManager.isWifiActive();
      if (isWifiActive) {
        this.disableWifi();
        this.resetWifiStatus();
      } else {
        this.updateWifiStatus();
        this.enableWifi();
      }
    } catch (error) {
      log.error('Wifi Switching failed');
    }
  }

  /**
   * 检查并解决连接问题的方法
   * 当 WiFi 连接状态发生变化时，会触发回调函数，并根据当前的连接状态进行相应的处理
   * 如果wifi 未连接，设置一个延时检查状态
   */
  private async checkAndResolveConnection() {
    const isConnected = wifiManager.isConnected();
    if (isConnected) {
      log.info('WiFi is connected.');
      await this.updateWifiLinkedInfo();
    } else {
      setTimeout(this.checkAndResolveConnection, 200);
    }
  }

  private setWifiColor(value: ResourceColor): void {
    if (this.updateWifiIconBgColorCallback) {
      this.updateWifiIconBgColorCallback(value)
    }
  }

  private setWifiFillColor(value: ResourceColor): void {
    if (this.updateWifiIconColorCallback) {
      this.updateWifiIconColorCallback(value)
    }
  }

  private setWifiName(value: ResourceStr): void {
    if (value === '') {
      log.showInfo(`setWifiName cancel ,value is empty`);
      return;
    }
    if (this.updateWifiNameCallback) {
      this.updateWifiNameCallback(value)
    }
  }
}