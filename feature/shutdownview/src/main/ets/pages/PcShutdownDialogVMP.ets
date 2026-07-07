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

import { appManager } from '@kit.AbilityKit';
import statusBar from '@ohos.pcService.statusBar';
import { viewMgrPolicy, ViewType, settingsDataManager, DeviceHelper } from '@ohos/frameworkwrapper';
import {
  SCBSceneSessionManager,
  SCBSceneSession,
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray
} from '@ohos/windowscene';
import { SingletonHelper, LogDomain, LogHelper, CheckEmptyUtils, CapabilityUtil } from '@ohos/basicutils';
import { ModeChangeUtils } from '@ohos/frameworkwrapper/src/main/ets/utils/ModeChangeUtils';
import { rpcShutdownPolicy } from '../policy/RpcShutdownPolicy';

const TAG = 'PcShutdownDialogVMP';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const DELAY_500 = 500;
const VIRTUAL_MACHINE_KEY = 'hwf.shutdown.allowed';
const BUNDLE_NAME_BROWSER = 'com.ohos.browser';

export const BUNDLE_NAME_SETTINGS = 'com.ohos.settings';
export const BUNDLE_NAME_vpn_1 = 'com.openharmony.vpn';
export const BUNDLE_NAME_vpn_2 = 'com.openharmony.his.vpn';

class PcShutdownDialogVMP {
  private hasDealWithAppBundleNameList: string[] = [];  // 已经预关闭过的应用
  private lastAllAppBundleNameList: string[] = [];  // 500ms前的全量运行应用
  private showPcShutdownViewCb: Function = () => {
    this.showPcShutdownView();
  }

  public init(): void {
    if (ModeChangeUtils.isSupportWindowPcModeSwitch()) {
      ModeChangeUtils.registerShutDownViewCallback(this.showPcShutdownViewCb, TAG);
    }
  }

  public destroy(): void {
    if (ModeChangeUtils.isSupportWindowPcModeSwitch()) {
      ModeChangeUtils.unRegisterShutDownViewCallback(TAG);
    }
  }

  // 预关闭
  private closeNewApp(pidList: number[], bundleName: string): void {
    log.showInfo('closeNewApp begin');
    try {
      CapabilityUtil.isStatusBarAvailable() && statusBar.exitProcesses(pidList);
      log.showInfo(`closeNewApp bundle name: ${bundleName}`);
    } catch (e) {
      log.showError(`closeNewApp exitTrayProcess error, code: ${e?.code}, message: ${e?.message}`);
    }
  }

  // linux应用预关闭
  private closeOldApp(sessionId: number, bundleName: string, currentSession: SCBSceneSession | null): void {
    log.showInfo('closeOldApp begin');
    // 调用关闭接口
    try {
      if (sessionId === -1) {
        log.showInfo('sessionId not reasonable');
        return;
      }
      const currentSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      currentSessionManager.asyncPrepareTerminate(sessionId, (err, isPrepareTerminate) => {
        if (isPrepareTerminate) {
          log.showInfo(`old app will not terminate. bundle name: ${bundleName}`);
        } else {
          let currentScreenId: number = currentSession?.sceneInfo?.screenId || currentSessionManager.mainScreenId;
          let currentPersistentId: number = currentSession?.sceneInfo?.persistentId || 0;
          log.showInfo(`current screenId = ${currentScreenId}`);
          log.showInfo(`close old app. bundle name: ${bundleName}`);
          SCBSceneSessionManager.getInstance().close(currentScreenId, currentPersistentId);
        }
      });
    } catch (e) {
      log.showError(`closeOldApp error, code: ${e?.code}, message: ${e?.message}`);
    }
  }

  private async closeNotPrepareTerminateApp(currentSession: SCBSceneSession | null, sessionId: number,
    bundleName: string): Promise<void> {
    log.showInfo('closeNotPrepareTerminateApp begin');
    try {
      if (rpcShutdownPolicy.getRpcView() && bundleName === BUNDLE_NAME_SETTINGS) {
        log.showInfo('rpc not close settings');
        return;
      }
      let pidList: number[] = [];
      const processInfoList: appManager.ProcessInformation[] =
        await appManager.getRunningProcessInfoByBundleName(bundleName);
      if (processInfoList.length === 0) {
        log.showInfo('processInfoList length is 0');
        return;
      }
      processInfoList.forEach(item => {
        if (item.bundleNames[0] === bundleName && CheckEmptyUtils.isEmpty(item.appCloneIndex) &&
          pidList.indexOf(item.pid) === -1) {
          pidList.push(item.pid);
        }
      });
      if (pidList.length !== 0) {
        log.showInfo(`exit ${bundleName} app pid list size : ${pidList.length}`);
        this.closeNewApp(pidList, bundleName);
        return;
      } else {
        this.closeOldApp(sessionId, bundleName, currentSession);
        return;
      }
    } catch (e) {
      log.showError(`closeNotPrepareTerminateApp error, code: ${e?.code}, message: ${e?.message}`);
      return;
    }
  }

  private dealWithLastAllAppList(bundleName: string, type: string): boolean {
    if (type === 'closeNotPrepareTerminateApps') {
      if (this.lastAllAppBundleNameList.indexOf(bundleName) === -1) {
        this.lastAllAppBundleNameList.push(bundleName);
      }
      return false;
    } else if (type === 'closeNewOpenApps') {
      if (this.lastAllAppBundleNameList.indexOf(bundleName) !== -1) {
        return true;
      }
      log.showInfo(`dealWithLastAllAppList closeNewOpenApps bundleName: ${bundleName}`);
      return false;
    }
    return false;
  }

  private dealWithContainerSessions(containerSessionList: SCBSceneContainerSessionArray, type: string): void {
    log.showInfo('dealWithContainerSessions begin');
    if (!containerSessionList) {
      log.showInfo('dealWithContainerSessions containerSessionList is null!');
      return;
    }
    for (const containerSession of containerSessionList) {
      const primarySession = containerSession.primarySession;
      if (!this.isCurrentSessionRight(primarySession)) {
        continue;
      }
      const primarySessionId: number = primarySession?.session?.persistentId || -1;
      const primaryBundleName: string = primarySession?.sceneInfo?.bundleName || '';
      if (this.dealWithLastAllAppList(primaryBundleName, type)) {
        continue;
      }
      if (this.hasDealWithAppBundleNameList.indexOf(primaryBundleName) !== -1) {
        continue;
      }
      this.hasDealWithAppBundleNameList.push(primaryBundleName);
      this.closeNotPrepareTerminateApp(primarySession, primarySessionId, primaryBundleName);
    }

    // 二分屏
    for (const containerSession of containerSessionList) {
      if (containerSession.secondarySession) {
        const secondarySession = containerSession.secondarySession;
        if (!this.isCurrentSessionRight(secondarySession)) {
          continue;
        }
        const secondarySessionId: number = secondarySession?.session?.persistentId || -1;
        const secondaryBundleName: string = secondarySession?.sceneInfo?.bundleName || '';
        if (this.dealWithLastAllAppList(secondaryBundleName, type)) {
          continue;
        }
        if (this.hasDealWithAppBundleNameList.indexOf(secondaryBundleName) !== -1) {
          continue;
        }
        this.hasDealWithAppBundleNameList.push(secondaryBundleName);
        this.closeNotPrepareTerminateApp(secondarySession, secondarySessionId, secondaryBundleName);
      }
    }
  }

  private closeNotPrepareTerminateApps(): void {
    log.showInfo('closeNotPrepareTerminateApps begin');
    try {
      let containerSessionList =
        (DeviceHelper.is2In1DevicePadType() || DeviceHelper.is2In1DevicePcType()) ?
        SCBSceneSessionManager.getInstance().getContainerSessionList() :
        SCBSceneSessionManager.getInstance().getAllContainerSessionList();
      this.dealWithContainerSessions(containerSessionList, 'closeNotPrepareTerminateApps');
      // 悬浮窗
      if (DeviceHelper.is2In1DevicePadType() || DeviceHelper.is2In1DevicePcType()) {
        log.showInfo('closeNotPrepareTerminateApps deal with floatingSessions');
        let floatingSessionList = SCBSceneSessionManager.getInstance().getFloatingSessionList();
        this.dealWithContainerSessions(floatingSessionList, 'closeNotPrepareTerminateApps');
      }
    } catch (e) {
      log.showError(`closeNotPrepareTerminateApps error, code: ${e?.code}, message: ${e?.message}`);
    }
  }

  // 预关闭500ms延时内新打开的应用
  private closeNewOpenApps(): void {
    log.showInfo('closeNewOpenApps begin');
    try {
      let containerSessionList =
        (DeviceHelper.is2In1DevicePadType() || DeviceHelper.is2In1DevicePcType()) ?
        SCBSceneSessionManager.getInstance().getContainerSessionList() :
        SCBSceneSessionManager.getInstance().getAllContainerSessionList();
      this.dealWithContainerSessions(containerSessionList, 'closeNewOpenApps');
      // 悬浮窗
      if (DeviceHelper.is2In1DevicePadType() || DeviceHelper.is2In1DevicePcType()) {
        log.showInfo('closeNewOpenApps deal with floatingSessions');
        let floatingSessionList = SCBSceneSessionManager.getInstance().getFloatingSessionList();
        this.dealWithContainerSessions(floatingSessionList, 'closeNewOpenApps');
      }
    } catch (e) {
      log.showError(`closeNewOpenApps error, code: ${e?.code}, message: ${e?.message}`);
    }
  }

  public isCurrentSessionRight(currentSession: SCBSceneSession | null): boolean {
    if (currentSession === null) {
      log.showInfo('currentSession is null!');
      return false;
    }
    if (currentSession.sceneInfo?.bundleName === BUNDLE_NAME_vpn_1 ||
      currentSession.sceneInfo?.bundleName === BUNDLE_NAME_vpn_2) {
      log.showInfo('currentSession is vpn');
      return false;
    }
    return true;
  }

  private async delay(delayTime: number): Promise<void> {
    log.showInfo(`delay ${delayTime}ms`);
    return new Promise((resolve) => setTimeout(resolve, delayTime));
  }

  public async showPcShutdownView(): Promise<void> {
    log.showInfo('showPcShutdownView begin');
    this.hasDealWithAppBundleNameList = [];
    this.lastAllAppBundleNameList = [];
    try {
      let virtualMachineVal: string = settingsDataManager.getValue(null, VIRTUAL_MACHINE_KEY, 'true');
      log.showInfo(`virtualMachineVal: ${virtualMachineVal}`);
      if (virtualMachineVal !== 'false') {
        this.closeNotPrepareTerminateApps();
        if (this.lastAllAppBundleNameList.length !== 0) {
          await this.delay(DELAY_500);
        }
        this.closeNewOpenApps();
      } else {
        await this.delay(DELAY_500);
      }
      viewMgrPolicy.showView(ViewType.SHUTDOWN_VIEW);
    } catch (e) {
      log.showError(`showPcShutdownView err, code: ${e?.code}, message: ${e?.message}`);
    }
  }
}

// 单例
export const pcShutdownDialogVMP = SingletonHelper.getInstance(PcShutdownDialogVMP, TAG);