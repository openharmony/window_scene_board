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

import type { IExecutor } from '@ohos/launchercommon';
import { LogHelper, LogDomain } from '@ohos/basicutils';
import type { IService } from '@ohos/componenthelper';
import { viewMgrPolicy, ViewType, HiSysEventUtil } from '@ohos/frameworkwrapper';
import SystemPanelModel from '../../SceneBoard/systempanel/model/SystemPanelModel';
import accountModel from '../../SceneBoard/screenlock/refactor/AccountsModel';
import { emitter } from '@kit.BasicServicesKit';
import rpc from '@ohos.rpc';
import Constants from '../../SceneBoard/screenlock/common/Constants';
import { PcSmartDockEventMgr } from '@ohos/pcsmartdock/src/main/ets/default/manager/PcSmartDockEventMgr';
import { LogoutUserType, SwitchUserType, UserReportUtil } from '../../SceneBoard/userspanel/common/UserReportUtil';

const TAG: string = 'HosKeyService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * 响应消息
 */
class Response {
  public static readonly success = 'OK';

  public static readonly fail = 'fail';

  public static readonly invalidMethodError = 'invalid method';

  public static readonly unknownMethodError = 'unknown method';

  public static readonly invalidExtra = 'invalid extra';
}

/**
 * 请求方法，与系统键约定
 */
enum RequestMethod {
  /**
   * 锁屏
   */
  SCREEN_LOCK = 'screenlock',
  /**
   * 关机
   */
  SHUT_DOWN = 'shutdown',
  /**
   * 睡眠
   */
  SLEEP = 'sleep',
  /**
   * 重启
   */
  REBOOT = 'reboot',
  /**
   * 跳转应用中心
   */
  TO_APP_CENTER = 'toAppCenter',
  /**
   * 锁屏
   */
  USER_SWITCH = 'userswitch',
  /**
   * 企业空间切换用户
   */
  SPACE_SWITCH = 'spaceSwitch',
  /**
   * 注销
   */
  DEACTIVE = 'deactive',
  /**
   * 显示dock栏
   */
  SHOW_DOCK = 'showDock',
  /**
   * dock栏变化
   */
  CHANGE_DOCK = 'changeDock',
  /**
   * 删除个人空间
   */
  SPACE_REMOVE = 'spaceRemove',
}

interface UserInfo {
  userid: number
}

class ScreenLockExecutor implements IExecutor {
  async execute(extra?: object | undefined, remoteObject?: rpc.IRemoteObject | null | undefined): Promise<string> {
    SystemPanelModel.lockScreenByHosKey();
    return Response.success;
  }
}

class ShutDownExecutor implements IExecutor {
  async execute(extra?: object | undefined, remoteObject?: rpc.IRemoteObject | null | undefined): Promise<string> {
    SystemPanelModel.shutdownByHosKey();
    return Response.success;
  }
}

class SleepExecutor implements IExecutor {
  async execute(extra?: object | undefined, remoteObject?: rpc.IRemoteObject | null | undefined): Promise<string> {
    SystemPanelModel.sleepByHosKey();
    return Response.success;
  }
}

class RebootExecutor implements IExecutor {
  async execute(extra?: object | undefined, remoteObject?: rpc.IRemoteObject | null | undefined): Promise<string> {
    SystemPanelModel.rebootByHosKey();
    return Response.success;
  }
}

class ToAppCenterExecutor implements IExecutor {
  async execute(extra?: object | undefined, remoteObject?: rpc.IRemoteObject | null | undefined): Promise<string> {
    HiSysEventUtil.reportPullAppCenter(HiSysEventUtil.APPCENTER_TYPE_HOSKEY);
    viewMgrPolicy.showView(ViewType.APP_CENTER);
    return Response.success;
  }
}

class UserSwitchExecutor implements IExecutor {
  async execute(extra?: object | undefined, remoteObject?: rpc.IRemoteObject | null | undefined): Promise<string> {
    let userInfo = extra as UserInfo;
    const tarUserId = userInfo?.userid;
    if (!userInfo) {
      log.showWarn('invalid UserInfo');
      UserReportUtil.reportSwitchUserEvent(tarUserId, SwitchUserType.HOS_KEY, 1);
      return 'invalid UserInfo';
    }
    await accountModel.onUserSwitch(tarUserId);
    UserReportUtil.reportSwitchUserEvent(tarUserId, SwitchUserType.HOS_KEY);
    return Response.success;
  }
}

class SpaceSwitchExecutor implements IExecutor {
  async execute(extra?: object | undefined, remoteObject?: rpc.IRemoteObject | null | undefined): Promise<string> {
    log.showInfo(`SpaceSwitchExecutor extra ${JSON.stringify(extra)}`);
    emitter.emit(Constants.SPACE_SWITCH, { data: extra });
    return Response.success;
  }
}

class DeactiveExecutor implements IExecutor {
  async execute(extra?: object | undefined, remoteObject?: rpc.IRemoteObject | null | undefined): Promise<string> {
    let userInfo = extra as UserInfo;
    if (!userInfo) {
      log.showError('invalid UserInfo');
      UserReportUtil.reportLogoutUserEvent(LogoutUserType.HOS_KEY, 1);
      return Response.invalidExtra;
    }
    await SystemPanelModel.logout();
    UserReportUtil.reportLogoutUserEvent(LogoutUserType.HOS_KEY);
    return Response.success;
  }
}
/**
 * 启动系统键，dock栏显示
 * */
class ShowDockExecuter implements IExecutor {
  async execute(extra?: object | undefined, remoteObject?: rpc.IRemoteObject | null | undefined): Promise<string> {
    log.showInfo('ShowDockExecuter HosKey ShowDock');
    PcSmartDockEventMgr.getInstance().levelTwoMenuShowDock(true);
    return Response.success;
  }
}

/**
 * 系统键DOCK栏显示变化
 * */
class ChangeDockExecuter implements IExecutor {
  async execute(extra?: object | undefined, remoteObject?: rpc.IRemoteObject | null | undefined): Promise<string> {
    log.showInfo('ChangeDockExecuter HosKey ChangeDock');
    PcSmartDockEventMgr.getInstance().levelTwoMenuShowDock(false);
    return Response.success;
  }
}

class SpaceRemoveExecutor implements IExecutor {
  async execute(extra?: object | undefined, remoteObject?: rpc.IRemoteObject | null | undefined): Promise<string> {
    log.showInfo(`SpaceRemoveExecutor extra ${JSON.stringify(extra)}`);
    emitter.emit(Constants.SPACE_REMOVE, { data: extra });
    return Response.success;
  }
}

/**
 * 系统键业务服务
 *
 */
export class HosKeyService implements IService {
  private static readonly executorMap: Map<string, () => IExecutor> = new Map<string, () => IExecutor>([
    [RequestMethod.SCREEN_LOCK, (): IExecutor => new ScreenLockExecutor()],
    [RequestMethod.SHUT_DOWN, (): IExecutor => new ShutDownExecutor()],
    [RequestMethod.SLEEP, (): IExecutor => new SleepExecutor()],
    [RequestMethod.REBOOT, (): IExecutor => new RebootExecutor()],
    [RequestMethod.TO_APP_CENTER, (): IExecutor => new ToAppCenterExecutor()],
    [RequestMethod.USER_SWITCH, (): IExecutor => new UserSwitchExecutor()],
    [RequestMethod.SPACE_SWITCH, (): IExecutor => new SpaceSwitchExecutor()],
    [RequestMethod.DEACTIVE, (): IExecutor => new DeactiveExecutor()],
    [RequestMethod.SHOW_DOCK, (): IExecutor => new ShowDockExecuter()],
    [RequestMethod.CHANGE_DOCK, (): IExecutor => new ChangeDockExecuter()],
    [RequestMethod.SPACE_REMOVE, (): IExecutor => new SpaceRemoveExecutor()],
  ]);

  async onCall(json: string): Promise<string> {
    let msg: CallMessage | null = null;
    try {
      msg = JSON.parse(json) as CallMessage;
    } catch (err) {
      log.error('onCall parse message failed, ', err);
    }
    if (!msg || !msg.method) {
      log.showWarn('onCall invalid method');
      return Response.invalidMethodError;
    }

    log.showInfo(`HosKeyService.executorMap:${JSON.stringify(HosKeyService.executorMap)}`);
    const method: string = msg.method;
    log.showInfo(`onCall method = ${method}`);
    const executor = HosKeyService.executorMap.get(method);
    if (!executor) {
      log.showWarn(`onCall unknown method = ${method}`);
      return Response.unknownMethodError;
    }
    return executor().execute(msg.extra);
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