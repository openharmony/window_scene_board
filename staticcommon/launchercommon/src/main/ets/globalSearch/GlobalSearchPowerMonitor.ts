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

import { inputMonitor } from '@kit.InputKit';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import { KeyEvent, Action } from '@ohos.multimodalInput.keyEvent';
import { viewMgrPolicy, ViewType, ViewCallback } from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBTransitionManager, SCBUnlockTransitionController } from '@ohos/windowscene';

const TAG = 'GlobalSearchPowerMonitor';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SEARCH, TAG);

export class GlobalSearchPowerMonitor {

  private static instance: GlobalSearchPowerMonitor;
  private isBlockOpen: boolean = false;
  private static readonly CLEAR_GLOBAL_SEARCH_POWER_MONITOR_TIME: number = 400;
  private exitBlockOpenTimerId: number;
  private unrelatedScenarios: () => boolean = (): boolean => {
    return false;
  };
  private lockTransitionController: SCBUnlockTransitionController = {
    name: TAG,
    onLock: (): void => {},
    onUnlock: (): void => {
      log.showInfo(`onUnlock setBlockOpen false`);
      this.setBlockOpen(false);
    }
  };
  private monitorFocusCallback: ViewCallback = {
    onGainFocus: () => {
      log.showInfo('desktop or negative screen gain focus');
      this.setBlockOpen(false);
    }
  };

  /**
   * 设置不需要监听电源up事件的场景
   * 通过unrelatedScenarios函数判断场景
   * @param unrelatedScenarios 提供一个函数返回值为boolean
   */
  public setUnrelatedScenarios(unrelatedScenarios: () => boolean): void {
    this.unrelatedScenarios = unrelatedScenarios;
  }

  public releaseUnrelatedScenarios(): void {
    this.unrelatedScenarios = (): boolean => false;
  }

  /**
   * 设置全搜拦截是否开启
   */
  public setBlockOpen(isBlockOpen: boolean): void {
    this.isBlockOpen = isBlockOpen;
    log.showInfo(`isBlockOpen: ${isBlockOpen}`);
  }

  /**
   * 获取全搜拦截是否开启
   */
  public getBlockOpen(): boolean {
    return this.isBlockOpen;
  }

  public static getInstance(): GlobalSearchPowerMonitor {
    if (!GlobalSearchPowerMonitor.instance) {
      GlobalSearchPowerMonitor.instance = new GlobalSearchPowerMonitor();
    }
    return GlobalSearchPowerMonitor.instance;
  }

  /**
   * 注册全搜电源监听
   */
  public registerGlobalSearchPowerMonitor(): void {
    const keys: Array<KeyCode> = [KeyCode.KEYCODE_POWER];
    try {
      inputMonitor.on('keyPressed', keys, this.globalSearchPowerMonitorCallback);
      viewMgrPolicy.registerViewCallback(ViewType.DESKTOP, this.monitorFocusCallback);
      viewMgrPolicy.registerViewCallback(ViewType.NEGATIVE_SCREEN, this.monitorFocusCallback);
      SCBTransitionManager.getInstance().registerUnlockTransitionController(this.lockTransitionController, false);
    } catch (err) {
      log.showError(`register error: ${err}`);
    }
  }

  private globalSearchPowerMonitorCallback = (keyEvent: KeyEvent): void => {
    if (keyEvent.action === Action.UP && !this.unrelatedScenarios()) {
      clearTimeout(this.exitBlockOpenTimerId);
      this.setBlockOpen(true);
      this.exitBlockOpenTimerId = setTimeout(() => {
        log.showInfo(`setTimeout setBlockOpen false`);
        this.setBlockOpen(false);
      }, GlobalSearchPowerMonitor.CLEAR_GLOBAL_SEARCH_POWER_MONITOR_TIME);
    }
  };

  /**
   * 注销全搜电源监听
   */
  public unregisterGlobalSearchPowerMonitor(): void {
    this.setBlockOpen(false);
    try {
      inputMonitor.off('keyPressed', this.globalSearchPowerMonitorCallback);
      viewMgrPolicy.unRegisterViewCallback(ViewType.DESKTOP, this.monitorFocusCallback);
      viewMgrPolicy.unRegisterViewCallback(ViewType.NEGATIVE_SCREEN, this.monitorFocusCallback);
      SCBTransitionManager.getInstance().unRegisterUnlockTransitionController(this.lockTransitionController, false);
    } catch (err) {
      log.showError(`unregister error: ${err}`);
    }
  }
}