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

import ProcessData from 'application/ProcessData';
import AppStateData from 'application/AppStateData';
import appManager from '@ohos.app.ability.appManager';
import {
  SingletonHelper,
  CommonUtils,
  LogDomain,
  LogHelper
} from '@ohos/basicutils';
import {
  EvtBus,
  CapsuleVisibleEvent,
  PluginSlot,
  AppStateChangeEvent,
} from '@ohos/frameworkwrapper';
import type { PluginParseInfo } from '@ohos/frameworkwrapper';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = 'Plugin-AppManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const APP_CLOSE = 'close';
/**
 * 最大重试次数
 */
const MAX_RETRY_COUNT = 3;

/**
 * 1秒重试一次
 */
const RETRY_TIME = 1000;

class AppManager {
  private observerId: number;
  private isStart: boolean = false;
  /**
   * 重试次数
   */
  private retryCount: number = 0;
  private pluginParseInfos: Array<PluginParseInfo> = [];
  private openAppNameList: string[] = [];
  private applicationStateObserver = {
    onForegroundApplicationChanged(): void {
    },
    onAbilityStateChanged(): void {
    },
    // 进程创建
    onProcessCreated: (processData: ProcessData): void => {
      log.showDebug(`onProcessCreated:${processData.bundleName}`);
      this.postCapsuleVisibleEvent(processData.bundleName, true, processData.pid);
    },
    // 进程销毁
    onProcessDied: (processData: ProcessData): void => {
      log.showDebug(`onProcessDied:${processData.bundleName} ${processData.pid}`);
      this.postCapsuleVisibleEvent(processData.bundleName, false, processData.pid);
    },
    onProcessStateChanged(): void {
    },
    // 应用启动
    onAppStarted: (appStateData: AppStateData): void => {
      if (!this.openAppNameList.includes(appStateData.bundleName)) {
        this.openAppNameList.push(appStateData.bundleName);
        log.showInfo(`onAppStarted:${appStateData.bundleName}`);
      }
    },
    // 应用关闭
    onAppStopped: (appStateData: AppStateData): void => {
      const index = this.openAppNameList.indexOf(appStateData.bundleName);
      if (index !== -1) {
        this.openAppNameList.splice(index, 1);
        log.showDebug(`onAppStopped:${appStateData.bundleName}`);
        this.postAppStateChangeEvent(appStateData.bundleName, APP_CLOSE);
      }
    }
  };

  async init(): Promise<void> {
    if (this.retryCount >= MAX_RETRY_COUNT || this.isStart) {
      log.showWarn('onApplicationState retry over max count.');
      return;
    }
    try {
      if (CommonUtils.isNumber(this.observerId)) {
        await appManager.off('applicationState', this.observerId);
      }
      const observerId = appManager.on('applicationState', this.applicationStateObserver);
      this.observerId = observerId;
      this.isStart = true;
    } catch (err) {
      log.showError('onApplicationState err: ' + (err as BusinessError)?.message);
      setTimeout(() => {
        this.retryCount++;
        this.init();
      }, RETRY_TIME);
    }
  }

  private async postCapsuleVisibleEvent(bundleName: string, visible: boolean, requestPid: number): Promise<void> {
    for (let index = 0; index < this.pluginParseInfos.length; index++) {
      let info = this.pluginParseInfos[index];
      if (info.bundleName !== bundleName) {
        continue;
      }
      EvtBus.post(CapsuleVisibleEvent, {
        pluginSlot: info.pluginSlot + info.instanceKey,
        visible: visible,
        requestPid: requestPid,
      });
      break;
    }
  }

  private async postAppStateChangeEvent(bundleName: string, state: string): Promise<void> {
    EvtBus.post(AppStateChangeEvent, {
      appName: bundleName,
      state: state,
    });
  }

  async registerApplicationStateObserver(pluginParseInfos: Array<PluginParseInfo>): Promise<void> {
    log.showInfo('registerApplicationStateObserver start');
    try {
      // 去重
      this.pluginParseInfos = [...new Set([...this.pluginParseInfos, ...pluginParseInfos])];
      log.showInfo('registerApplicationStateObserver bundleNameList success');
    } catch (paramError) {
      log.showError('registerApplicationStateObserver error', paramError);
    }
  }

  async unregisterApplicationStateObserver(pluginParseInfos: Array<PluginParseInfo>): Promise<void> {
    try {
      const pluginSlots = pluginParseInfos.map((info) => {
        if (!info) {
          log.showError('unregisterApplicationStateObserver info invalid');
          return '';
        }
        return info.pluginSlot + info.instanceKey;
      });
      this.pluginParseInfos = this.pluginParseInfos.filter((parseInfo: PluginParseInfo) => {
        return !pluginSlots.includes(parseInfo.pluginSlot + parseInfo.instanceKey);
      });
      log.showInfo(`unregisterApplicationStateObserver bundleNameList: ${pluginSlots.length}`);
    } catch (paramError) {
      log.showError('unregisterApplicationStateObserver error', paramError);
    }
  }

  async isProcessing(pluginParseInfo: PluginParseInfo): Promise<boolean> {
    let processInformation = await appManager.getRunningProcessInformation();
    const index = processInformation.findIndex((info) => {
      return info?.bundleNames.includes(pluginParseInfo?.bundleName);
    });
    return index !== -1;
  }
}

export let appMgr = SingletonHelper.getInstance(AppManager, TAG);