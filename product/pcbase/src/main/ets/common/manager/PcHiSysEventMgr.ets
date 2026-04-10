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


import { LogHelper, LogDomain } from '@ohos/basicutils';
import { ReportParams, HiSysEventUtil, WindowStatisticsParams } from '@ohos/frameworkwrapper';
import hiSysEvent from '@ohos.hiSysEvent';

/**
 * PC业务 大数据用户行为相关打点工具类
 */

const TAG = 'PcHiSysEventMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export enum TIP_RESULT {
  USER_PIN_TIP_PUBLISH_TIMEOUT = 0,
  USER_PIN_TIP_PUBLISH_SUCCESS = 1,
}

export enum COMPLEXITY_STATUS {
  USER_PIN_PASSWORD_NO_LIMIT = 0,
  USER_PIN_HAVE_COMPLEXITY_PASSWORD = 1,
}

export enum COMPLEXITY_AUTH_RESULT {
  NEW_USER_PIN_COMPLEXITY_AUTH_SUCCESS = 0,
  NEW_USER_PIN_COMPLEXITY_AUTH_FAIL = 1,
}

export enum RECOVERY_KEY_RESET_PWD_RESULT {
  USER_PIN_RECOVERY_KEY_RESET_PASSWORD_SUCCESS = 0,
  USER_PIN_RECOVERY_KEY_RESET_PASSWORD_FAIL = 1,
}

interface TipReportParams {
  PNAMEID: string;
  PVERSIONID: string;
  TIP_RESULT: TIP_RESULT;
}

interface ComplexityStatusReportParams {
  PNAMEID: string;
  PVERSIONID: string;
  COMPLEXITY_STATUS: COMPLEXITY_STATUS;
}

interface ComplexityAuthReportParams {
  PNAMEID: string;
  PVERSIONID: string;
  COMPLEXITY_AUTH_RESULT: COMPLEXITY_AUTH_RESULT;
}

interface RecoverKeyResetPasswordReportParams {
  PNAMEID: string;
  PVERSIONID: string;
  RECOVERY_KEY_RESET_PWD_RESULT: RECOVERY_KEY_RESET_PWD_RESULT;
}

export class PcHiSysEventMgr {

  // 锁屏密码有效期
  public static USER_PIN_TIMEOUT_TIP: string = 'USER_PIN_TIMEOUT_TIP';
  public static USER_PIN_COMPLEXITY_STATUS: string = 'USER_PIN_COMPLEXITY_STATUS';
  public static USER_PIN_COMPLEXITY_AUTH_RESULT: string = 'USER_PIN_COMPLEXITY_AUTH_RESULT';
  public static USER_PIN_RECOVERY_KEY_RESET_PASSWORD: string = 'USER_PIN_RECOVERY_RESET_PWD';
  public static SCREENLOCK_UE: string = 'SCREENLOCK_UE';

  // 窗口总数數量统计
  private static readonly WINDOW_STATISTICS = 'WINDOW_STATISTICS';

  /**
   * 上报是否弹出到期时间提醒
   *
   * @param params 上报是否弹出到期时间提醒
   */
  public static userPinTimeTip(tipResult: TIP_RESULT): void {
    let params : TipReportParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      TIP_RESULT: tipResult,
    };
    log.showInfo('authUser UserAuthManager, USER_PIN_TIMEOUT_TIP');
    HiSysEventUtil.reportEvent(PcHiSysEventMgr.USER_PIN_TIMEOUT_TIP, params, hiSysEvent.EventType.BEHAVIOR,
      PcHiSysEventMgr.SCREENLOCK_UE);
  }

  /**
   * 上报是否设置有密码复杂度
   *
   * @param params 上报是否设置有密码复杂度
   */
  public static userPinComplexityStatus(complexityStatus: COMPLEXITY_STATUS): void {
    let params : ComplexityStatusReportParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      COMPLEXITY_STATUS: complexityStatus,
    };
    log.showInfo('authUser UserAuthManager, USER_PIN_COMPLEXITY_STATUS');
    HiSysEventUtil.reportEvent(PcHiSysEventMgr.USER_PIN_COMPLEXITY_STATUS, params, hiSysEvent.EventType.BEHAVIOR,
      PcHiSysEventMgr.SCREENLOCK_UE);
  }

  /**
   * 上报校验新密码是否通过复杂度校验
   *
   * @param params 上报校验新密码是否通过复杂度校验
   */
  public static userPinComplexityAuthResult(complexityAuthResult: COMPLEXITY_AUTH_RESULT): void {
    let params : ComplexityAuthReportParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      COMPLEXITY_AUTH_RESULT: complexityAuthResult,
    };
    log.showInfo('authUser UserAuthManager, USER_PIN_COMPLEXITY_AUTH_RESULT');
    HiSysEventUtil.reportEvent(PcHiSysEventMgr.USER_PIN_COMPLEXITY_AUTH_RESULT, params, hiSysEvent.EventType.BEHAVIOR,
      PcHiSysEventMgr.SCREENLOCK_UE);
  }

  /**
   * 上报使用恢复密钥重设密码结果
   *
   * @param params 上报是否成功使用恢复密钥重设密码
   */
  public static userPinRecoverKeyResetPassword(resetPasswordResut: RECOVERY_KEY_RESET_PWD_RESULT): void {
    let params : RecoverKeyResetPasswordReportParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      RECOVERY_KEY_RESET_PWD_RESULT: resetPasswordResut,
    };
    log.showInfo('user recoverKey reset password, RECOVERY_KEY_RESET_PWD_RESULT');
    HiSysEventUtil.reportEvent(PcHiSysEventMgr.USER_PIN_RECOVERY_KEY_RESET_PASSWORD,
      params, hiSysEvent.EventType.BEHAVIOR, PcHiSysEventMgr.SCREENLOCK_UE);
  }

  public static reportWindowStatisticsData(cnt: number): void {
    const params: WindowStatisticsParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      WINDOW_CNT: cnt
    };
    HiSysEventUtil.reportEvent(PcHiSysEventMgr.WINDOW_STATISTICS, params, hiSysEvent.EventType.STATISTIC);
  }

}