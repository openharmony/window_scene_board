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

import rpc from '@ohos.rpc';
import systemParameter from '@ohos.systemparameter';
import type { IExecutor } from '@ohos/launchercommon';
import { LogHelper, LogDomain } from '@ohos/basicutils';
import type { IService } from '@ohos/componenthelper';
import { viewMgrPolicy, ViewType, HiSysEventUtil } from '@ohos/frameworkwrapper';
import { rpcShutdownPolicy } from '@ohos/shutdownview/src/main/ets/policy/RpcShutdownPolicy';
import { pcShutdownDialogVMP } from '@ohos/shutdownview/src/main/ets/pages/PcShutdownDialogVMP';

const TAG: string = 'RpcShutdownService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
enum MenuType {
  INVAILD_MENU = 0,
  INFO_MENU = 1,
  SETTINGS_MENU = 2,
  SLEEP_MENU = 3,
  LOCK_MENU = 4,
  SHUTDOWN_MENU = 5,
  REBOOT_MENU = 6,
  CLOSE_DIALOG_MENU = 7,
}

/**
 * 响应消息
 */
class Response {
  static readonly SUCCESS = 'OK';

  static readonly FAIL = 'fail';

  static readonly INVALID_METHOD_ERROR = 'invalid method';

  static readonly UNKNOWN_METHOD_ERROR = 'unknown method';

  static readonly INVALID_EXTRA = 'invalid extra';
}

/**
 * 请求方法
 */
enum RequestMethod {
  /**
   * 关机
   */
  SHUT_DOWN = 'shutdown',
  /**
   * 重启
   */
  REBOOT = 'reboot',
  /**
   * 关闭弹窗
   */
  CLOSE_DIALOG = 'close dialog'
}

class ShutDownExecutor implements IExecutor {
  async execute(extra?: object, remoteObject?: rpc.IRemoteObject): Promise<string> {
    log.showInfo(`shutdown execute.`);
    try {
      systemParameter.setSync('persist.dfx.userclicktime', new Date().getTime().toString());
      HiSysEventUtil.hiSysWriteStorage(MenuType.SHUTDOWN_MENU, HiSysEventUtil.MOUSE_EVENT, () => {
        rpcShutdownPolicy.setRpcView(true);
        rpcShutdownPolicy.setRpcClientObj(remoteObject);
        pcShutdownDialogVMP.showPcShutdownView();
      });
      return Response.SUCCESS;
    } catch (err) {
      log.showError(`ShutDownExecutor error.${err?.message}`);
      return Response.FAIL;
    }
  }
}


class RebootExecutor implements IExecutor {
  async execute(extra?: object, remoteObject?: rpc.IRemoteObject): Promise<string> {
    log.showInfo(`reboot execute.`);
    try {
      systemParameter.setSync('persist.dfx.userclicktime', new Date().getTime().toString());
      HiSysEventUtil.hiSysWriteStorage(MenuType.REBOOT_MENU, HiSysEventUtil.MOUSE_EVENT, () => {
        rpcShutdownPolicy.setRpcView(true);
        rpcShutdownPolicy.setRpcClientObj(remoteObject);
        pcShutdownDialogVMP.showPcShutdownView();
      });
      return Response.SUCCESS;
    } catch (err) {
      log.showError(`RebootExecutor error.${err?.message}`);
      return Response.FAIL;
    }
  }
}

class CloseDialogExecutor implements IExecutor {
  async execute(extra?: object, remoteObject?: rpc.IRemoteObject | null): Promise<string> {
    log.showInfo(`close dialog execute.`);
    try {
      systemParameter.setSync('persist.dfx.userclicktime', new Date().getTime().toString());
      HiSysEventUtil.hiSysWriteStorage(MenuType.CLOSE_DIALOG_MENU, HiSysEventUtil.MOUSE_EVENT, () => {
        rpcShutdownPolicy.setRpcView(false);
        rpcShutdownPolicy.setRpcClientObj();
        viewMgrPolicy.hideView(ViewType.SHUTDOWN_VIEW);
      });
      return Response.SUCCESS;
    } catch (err) {
      log.showError(`CloseDialogExecutor error.${err?.message}`);
      return Response.FAIL;
    }
  }
}

/**
 * 通用关机弹窗业务服务
 *
 */
export class RpcShutdownService implements IService {
  private static readonly executorMap: Map<string, () => IExecutor> = new Map<string, () => IExecutor>([
    [RequestMethod.SHUT_DOWN, (): IExecutor => new ShutDownExecutor()],
    [RequestMethod.REBOOT, (): IExecutor => new RebootExecutor()],
    [RequestMethod.CLOSE_DIALOG, (): IExecutor => new CloseDialogExecutor()],
  ]);

  async onCall(json: string, clientObj: rpc.IRemoteObject): Promise<string> {
    let msg: CallMessage | undefined;
    try {
      msg = JSON.parse(json) as CallMessage;
    } catch (err) {
      log.error(`onCall parse message failed, `, err);
    }
    if (!msg || !msg.method) {
      log.showWarn(`onCall invalid method`);
      return Response.INVALID_METHOD_ERROR;
    }

    const method: string = msg.method;
    log.showInfo(`onCall method = ${method}`);
    const executor = RpcShutdownService.executorMap.get(method);
    if (!executor) {
      log.showWarn(`onCall unknown method = ${method}`);
      return Response.UNKNOWN_METHOD_ERROR;
    }
    return executor().execute(msg.extra, clientObj);
  }

  isSupportSegments(): boolean {
    return true;
  }
}

/**
 * 请求消息
 *
 */
interface CallMessage {
  /**
   * 方法名
   */
  method: string;

  /**
   * 附加参数
   */
  extra: object;
}