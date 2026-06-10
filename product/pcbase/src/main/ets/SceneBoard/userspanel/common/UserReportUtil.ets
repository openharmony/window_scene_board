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

import hiSysEvent from '@ohos.hiSysEvent';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { HiSysEventUtil } from '@ohos/frameworkwrapper';
import { ReportParams } from '@ohos/frameworkwrapper';
import accountModel from '../../screenlock/refactor/AccountsModel';

const TAG = 'UserReportUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const DOMAIN: string = 'SCENE_BOARD_UE'; // UE行为打点
const EVENT_SWITCH_USER: string = 'SWITCH_USER';
const EVENT_LOGOUT_USER: string = 'LOGOUT_USER';

/**
 * 用户事件结果
 * 0 - 操作成功；1 - 操作失败
 */
export type UserEventResultType = 0 | 1;

export enum SwitchUserType {
  SCREEN_LOCK = 'HoverScreenLock', // 锁屏 hover 用户头像
  CTRL_ALT_DEL_PANEL = 'CtrlAltDelPanel', // CtrlAltDel 快捷面板
  HOS_KEY = 'HosKey' // OpenHarmony键
}

export enum LogoutUserType {
  CTRL_ALT_DEL_PANEL = 'CtrlAltDelPanel', // CtrlAltDel 快捷面板
  HOS_KEY = 'HosKey' // OpenHarmony键
}

interface UserEventParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  RESULT?: UserEventResultType;
}

export interface SwitchUserEventParams extends UserEventParams {
  CURRENT_LOCAL_ID?: number;
  TARGET_LOCAL_ID?: number;
  TYPE: SwitchUserType;
}

export interface LogoutUserEventParams extends UserEventParams {
  LOCAL_ID?: number;
  TYPE: LogoutUserType;
}

export class UserReportUtil {
  /**
   * 多用户切换事件打点
   *
   * @param tarId 目标用户 id
   * @param type 切换类型
   * @param result 切换结果
   */
  static reportSwitchUserEvent(tarId: number | undefined, type: SwitchUserType, result: UserEventResultType = 0): void {
    try {
      const currId: number = accountModel.getCurrentUserId();
      const params: SwitchUserEventParams = {
        PNAMEID: ReportParams.PACKAGE_NAME,
        PVERSIONID: ReportParams.PROCESS_NAME,
        CURRENT_LOCAL_ID: currId,
        TARGET_LOCAL_ID: tarId,
        TYPE: type,
        RESULT: result
      };
      log.showInfo(`reportSwitchUserEvent currId ${currId} tarId ${tarId} type ${type} result ${result}`);
      HiSysEventUtil.report(DOMAIN, EVENT_SWITCH_USER, hiSysEvent.EventType.BEHAVIOR, params);
    } catch (err) {
      log.showInfo(`reportSwitchUserEvent failed. Error ${err?.code} ${err?.message}`);
    }
  }

  /**
   * 多用户注销事件打点
   *
   * @param id 用户 id
   * @param type 切换类型
   * @param result 切换结果
   */
  static reportLogoutUserEvent(type: LogoutUserType, result: UserEventResultType = 0): void {
    try {
      const id: number = accountModel.getCurrentUserId();
      const params: LogoutUserEventParams = {
        PNAMEID: ReportParams.PACKAGE_NAME,
        PVERSIONID: ReportParams.PROCESS_NAME,
        LOCAL_ID: id,
        TYPE: type,
        RESULT: result
      };
      log.showInfo(`reportLogoutUserEvent id ${id} type ${type} result ${result}`);
      HiSysEventUtil.report(DOMAIN, EVENT_LOGOUT_USER, hiSysEvent.EventType.BEHAVIOR, params);
    } catch (err) {
      log.showInfo(`reportLogoutUserEvent failed. Error ${err?.code} ${err?.message}`);
    }
  }
}