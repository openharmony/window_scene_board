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
// import statusBar from '@hms.pcService.statusBar';
import {
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import { ExtendMap } from '@ohos/basicutils/src/main/ets/utils/ExtendMap';
import { StatusBarConnectEvent, StatusBarServiceInfo } from './StatusBarServiceEventManager';

const TAG = 'TrayManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export interface BundleInfo {
  bundleName: string;

  // hdc临时方案，托盘相关消息缓存区
  pids: Set<number>;
  backPids: Set<number>;
  //  data?: statusBar.StatusBarItem;
  data?: ESObject;
}

// 当前仅对底层提供的托盘能力进行一层封装，方便后续统一整改
export class TrayManager {
  // hdc临时方案，先将托盘及相关数据保存，保证先启动wps再进pc模式可以获取到托盘及相关数据
  private itemInfos: ExtendMap<BundleInfo> = new ExtendMap<BundleInfo>();
  private static mInstance: TrayManager | undefined = undefined;
  private trayManagerListener: Set<(tokenId: number, pid: number,
    instanceKey: string, isDetached: boolean) => void> = new Set();

  // 创建托盘管理器
  public static getOrCreateTrayManager(): TrayManager {
    if (TrayManager.mInstance === undefined) {
      TrayManager.mInstance = new TrayManager();
      // statusBar.createTrayManager((slot: number, pid: number, instanceIndex: string, isDetached: boolean) => {
      //   TrayManager.mInstance?.trayManagerListener.forEach((listener) => {
      //     listener(slot, pid, instanceIndex, isDetached);
      //   });
      //   TrayManager.mInstance?.itemInfos.getData(slot, instanceIndex)?.backPids.add(pid);
      //   log.showInfo(`add MultiMap backPids:${slot},${pid} ${instanceIndex} ${isDetached}`);
      // });
    }
    return TrayManager.mInstance;
  }

  // 销毁托盘管理器
  public static deleteTrayManager(): boolean {
    log.showDebug('deleteTrayManager...');
    if (TrayManager.mInstance !== undefined) {
      if (TrayManager.mInstance.itemInfos.getSize() > 0) {
        TrayManager.mInstance.itemInfos.forEach((value: BundleInfo, tokenId: number, instanceKey: string) => {
          // statusBar.deleteTrayForApp(tokenId, instanceKey);
        });
      }
      // statusBar.deleteTrayManager();
      TrayManager.mInstance = undefined;
    }
    return true;
  }

  public registerTrayManagerListener(listener: (tokenId: number, pid: number,
    instanceKey: string, isDetached: boolean) => void): void {
    this.trayManagerListener.add(listener);
  }

  public unRegisterTrayManagerListener(listener: (tokenId: number, pid: number,
    instanceKey: string, isDetached: boolean) => void): void {
    this.trayManagerListener.delete(listener);
  }

  public createTrayForApp(slot: number, bundleName: string, pids: number[], instanceIndex?: string): void {
    log.showDebug('createTrayForApp instanceIndex: ' + instanceIndex +
      ' bundleName ' + bundleName + ' pids ' + pids.toString());
    if (this.itemInfos.hasData(slot, instanceIndex ?? '')) {
      let tokenIdInfo = this.itemInfos.getData(slot, instanceIndex ?? '');
      if (tokenIdInfo === undefined) {
        log.showError(`slot info not found ${slot} ${instanceIndex}`);
        return;
      }
      pids.forEach((pid: number) => {
        tokenIdInfo?.pids.add(pid);
      });
    } else {
      // statusBar.createTrayForApp(slot, instanceIndex ?? '');
      let bundleInfo: BundleInfo = {
        bundleName: bundleName,
        pids: new Set(pids),
        backPids: new Set(),
      };
      this.itemInfos.setData(slot, instanceIndex ?? '', bundleInfo);
    }
  }

  // hdc临时方案，在接收到托盘相关接口消息时，直接进行更新托盘数据更新，保证进入pad上进入pc模式后dock栏可以获取
  public updateAppTrayInfo(tokenId: number, info: StatusBarServiceInfo): void {
    let tokenIdInfo = this.itemInfos.getData(tokenId, info.data.instanceKey);
    if (!tokenIdInfo) {
      log.showError(`updateAppTrayInfo1 instanceKey: ${info.data.instanceKey}`);
      return;
    }
    log.showError(`updateAppTrayInfo2 instanceKey: ${info.data.instanceKey}`);
    switch (info.type) {
      case StatusBarConnectEvent.ADD_TO_STATUS_BAR:
        if (info.data.statusBarItem && !tokenIdInfo.data) {
          tokenIdInfo.data = info.data.statusBarItem;
        }
        break;
      case StatusBarConnectEvent.UPDATE_RIGHT_MENU:
        if (info.data?.statusBarMenu && tokenIdInfo.data) {
          tokenIdInfo.data.statusBarGroupMenu = info.data.statusBarMenu;
        }
        break;
      case StatusBarConnectEvent.UPDATE_QUICK_OPERATION_HEIGHT:
        if (info.data?.operationHeight && tokenIdInfo.data) {
          tokenIdInfo.data.quickOperation.height = info.data?.operationHeight;
        }
        break;
      case StatusBarConnectEvent.UPDATE_STATUSBAR_ICON:
        if (info.data?.statusBarIcon && tokenIdInfo.data) {
          tokenIdInfo.data.icons = info.data?.statusBarIcon;
        }
        break;
      default:
        break;
    }
  }

  public deleteTrayForApp(tokenId: number, instanceKey?: string): void {
    log.showDebug('deleteTrayForApp instanceKey: ' + instanceKey);
    if (this.itemInfos.hasData(tokenId, instanceKey ?? '')) {
      this.itemInfos.deleteData(tokenId, instanceKey ?? '');
      // statusBar.deleteTrayForApp(tokenId, instanceKey ?? '');
    }
  }

  public tokenIdProcessExit(tokenId: number, pid: number, instanceKey?: string): void {
    log.showDebug('tokenIdProcessExit instanceKey: ' + instanceKey + ' pid ' + pid);
    if (this.itemInfos.hasData(tokenId, instanceKey ?? '')) {
      this.itemInfos.getData(tokenId, instanceKey ?? '')?.pids.delete(pid);
    }
  }

  public forEach(callbackfn: (value: BundleInfo, key: number, instanceKey: string) => void): void {
    this.itemInfos.forEach(callbackfn);
  }

  public static exitTrayProcess(pids: number[]): void {
    // statusBar.exitProcesses(pids);
  }
}