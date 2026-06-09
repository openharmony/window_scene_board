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
// import statusBar from '@hms.pcService.statusBar';
import {
  LogDomain,
  LogHelper,
  SingletonHelper
} from '@ohos/basicutils';

const TAG = 'StatusBarServiceManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export enum StatusBarConnectEvent {
  UNKNOWN = -1,
  ADD_TO_STATUS_BAR = 1,
  REMOVE_FROM_STATUS_BAR = 2,
  UPDATE_RIGHT_MENU = 3,
  UPDATE_QUICK_OPERATION_HEIGHT = 4,
  UPDATE_STATUSBAR_ICON = 5,
  UPDATE_RIGHT_MENU_CLICK_HANDLER = 6,
  ON_ICON_CLICK = 7
}

export interface StatusBarServiceInfo {
  type: StatusBarConnectEvent;
  tokenId: number;
  bundleName: string;
  pid: number;
  data: StatusBarData;
  appIndex: number;
}

export interface StatusBarData {
  //   statusBarItem?: ESObject;
  //   statusBarMenu?: ESObject;
  //   statusBarIcon?: ESObject;
  statusBarItem?: ESObject;
  statusBarMenu?: ESObject;
  statusBarIcon?: ESObject;
  operationHeight?: number;
  instanceKey?: string;
}

type StatusBarServiceListener = (data: StatusBarServiceInfo, callback?: Function) => void;

// 当前pc和pad的状态栏服务公共管理类，管理服务消息的处理及消息的下发
export class StatusBarServiceEventManager {
  private statusBarListenerSet: Set<StatusBarServiceListener> = new Set();

  public static getInstance(): StatusBarServiceEventManager {
    return SingletonHelper.getInstance(StatusBarServiceEventManager, TAG);
  }

  public registerStatusBarServiceEvent(listener: StatusBarServiceListener): boolean {
    this.statusBarListenerSet.add(listener);
    log.showInfo(`registerStatusBarEvent succeed`);
    return true;
  }

  public unRegisterStatusBarEvent(listener: StatusBarServiceListener): boolean {
    this.statusBarListenerSet.delete(listener);
    return true;
  }

  public postEvent(data: StatusBarServiceInfo, callback?: Function): boolean {
    this.statusBarListenerSet.forEach((listener) => {
      listener(data, callback);
    });
    log.showInfo(`postEvent succeed`);
    return true;
  }
}