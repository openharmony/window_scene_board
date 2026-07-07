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

import { LogDomain, Logger } from '@ohos/basicutils';
import { settings, systemParameterEnhance } from '@kit.BasicServicesKit';
import { Constants } from '@ohos/commonconstants';

import { GlobalContext } from '../../utils/GlobalContext';

const TAG = 'LightOutdoorConfig';
const log = Logger.getLogHelper(LogDomain.HOME);

/**
 * 云端模式工具类
 */
export class LightOutdoorConfig {
  private static instance: LightOutdoorConfig;
  private outdoorModeStatus: number = -1;
  private hotSwitchToLightOutdoorMode: boolean = false;
  private hotSwitchToOtherMode: boolean = false;
  private lightOutdoorModeChangeListenerMap: Map<string, LightOutdoorModeChangeListener> = new Map();

  private constructor() {
    this.readSystemParam();
  }

  public static getInstance(): LightOutdoorConfig {
    if (!LightOutdoorConfig.instance) {
      LightOutdoorConfig.instance = new LightOutdoorConfig();
    }
    return LightOutdoorConfig.instance;
  }

  /**
   * 注册云端模式2状态切换的监听器
   * @param key
   * @param listener
   */
  public registerLightOutdoorModeChangeListener(key: string, listener: LightOutdoorModeChangeListener): void {
    this.lightOutdoorModeChangeListenerMap.set(key, listener);
  }

  /**
   * 解注册云端模式2状态切换的监听器
   *
   * @param key 监听key
   */
  public unRegisterLightOutdoorModeChangeListener(key: string): void {
    this.lightOutdoorModeChangeListenerMap.delete(key);
  }

  /**
   * 进入云端2
   */
  public enterOutdoorMode(): void {
    log.showInfo(TAG, 'enterOutdoorMode');
    this.outdoorModeStatus = 1;
    this.hotSwitchToLightOutdoorMode = true;
    this.callback(1);
  }

  /**
   * 是否热切到云端2
   *
   * @returns true 是; false 否
   */
  public isHotSwitchToLightOutdoorMode(): boolean {
    return this.hotSwitchToLightOutdoorMode;
  }

  /**
   * 是否热切到其他模式
   *
   * @returns  true 是; false 否
   */
  public isHotSwitchToOtherMode(): boolean {
    return this.hotSwitchToOtherMode;
  }

  /**
   * 重置是否热切到云端2状态
   */
  public resetHotSwitchToLightOutdoorStatus(): void {
    this.hotSwitchToLightOutdoorMode = false;
  }

  /**
   * 重置是否热切到其他模式状态
   */
  public resetHotSwitchToOtherModeStatus(): void {
    this.hotSwitchToOtherMode = false;
  }

  /**
   * 退出云端2
   */
  public existOutdoorMode(): void {
    log.showInfo(TAG, 'existOutdoorMode');
    this.outdoorModeStatus = 0;
    this.hotSwitchToOtherMode = true;
    this.callback(0);
  }

  private callback(mode: number): void {
    Array.from(this.lightOutdoorModeChangeListenerMap.values()).forEach(callbackFun => callbackFun?.(mode));
  }

  /**
   * 更新云端2 状态
   *
   * @param status 0：非云端2;1：云端2
   */
  public updateOutdoorStatus(status: number): void {
    this.outdoorModeStatus = status;
  }

  /**
   * 判断当前是否处理云端2模式
   *
   * @returns true 是; false 否
   */
  public isOnLightOutdoorMode(): boolean {
    if (this.outdoorModeStatus === -1) {
      try {
        let outdoorModeStr = settings.getValueSync(GlobalContext.getContext(),
          Constants.LIGHT_OUTDOOR_MODE_KEY, '0');
        this.outdoorModeStatus = Number(outdoorModeStr);
        log.showInfo(TAG, `read lightoutdoor status from setting: ${this.outdoorModeStatus}`);
      } catch (err) {
        log.showError(TAG, `read lightoutdoor status err code ${err.code}, err msg ${err.msg}`);
      }
    }
    return this.outdoorModeStatus === 1;
  }

  /**
   * 读取系统配置, 如果是云端1， 会清除云端2的标识
   */
  private readSystemParam(): void {
    try {
      let productValue: string = systemParameterEnhance.getSync('ohos.boot.minisys.mode', '');
      log.showInfo(TAG, `productValue: ${productValue}`);
      if (productValue === 'cloud') {
        settings.setValueSync(GlobalContext.getContext(), Constants.LIGHT_OUTDOOR_MODE_KEY, '0');
        log.showInfo(TAG, `current is cloud1, reset cloud2 flag`);
      }
    } catch (e) {
      log.showError(TAG, `query product type error, code: ${e.code}, message: ${e.message}`);
    }
  }
}

export type LightOutdoorModeChangeListener = (action: number) => void;