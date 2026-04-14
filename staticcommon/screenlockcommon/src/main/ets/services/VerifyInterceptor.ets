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

import osAccount from '@ohos.account.osAccount';
import { LogDomain, LogHelper, Trace } from '@ohos/basicutils';
import { AcquireResultCode } from '../base/ScreenLockVerifyVm';
import { AuthType } from '../utils/AccountHelper';
import { FingerAuthReportHelper } from '../utils/FingerAuthReportHelper';
import { DfxFaultEventTag, HiKGReportBase } from '../record/report/PerformanceMonitorUtil';
import { SlUnlockReportHelper } from '../record/report/SlUnlockReportHelper';
import {
  AcquireExtraInfo,
  IAMResultCode,
  PasswordAcquireCode,
  ResultHandler,
  VerifyInterceptor
} from './ScreenLockVerifyService';

const TAG = 'VerifyInterceptor';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 通用密码验证拦截器
 */
export class CommonPwdInterceptor extends VerifyInterceptor {
  constructor() {
    super(AuthType.PIN);
  }

  public endTrace(): void {
    Trace.end(Trace.CORE_METHOD_PSD_AUTH);
  }

  public onAcquireInfo(handler: ResultHandler, module: number, acquire: number, extraInfo: AcquireExtraInfo): boolean {
    log.showWarn(`onAcquire: ${acquire} PSD, ${JSON.stringify(extraInfo)}`);
    if (acquire === PasswordAcquireCode.PASSWORD_ACQUIRE_RESULT && extraInfo.authResult === AcquireResultCode.SUCCESS) {
      handler.setHasHandleAcquireInfo();
      handler.setMarkAcquireSuccess();
      handler.setHasHandleResult();
      SlUnlockReportHelper.getInstance().recordAuthEndTime(AuthType.PIN);
      FingerAuthReportHelper.getInstance().unlockReport(AuthType.PIN, true);
      Trace.end(Trace.CORE_METHOD_PSD_AUTH);
      handler.onPreVerifySuccess?.();
      handler.broadcastResult(osAccount.ResultCode.SUCCESS);
    }
    return true;
  }

  public onVerifyResult(handler: ResultHandler, result: number, extraInfo?: osAccount.AuthResult | undefined): boolean {
    this.handlePwdAuthResult(result);
    return false;
  }

  private handlePwdAuthResult(result: number): void {
    if (result !== IAMResultCode.SUCCESS) {
      // PIN 解锁失败打点
      SlUnlockReportHelper.getInstance().unlockReport(AuthType.PIN, false);
      if (result !== IAMResultCode.CANCEL && result !== IAMResultCode.FAIL) {
        // PIN 解锁故障打点
        HiKGReportBase.reportFault(DfxFaultEventTag.PASSWORD_UNLOCK_FAILED, Object({ ERROR_CODE: result }));
      }
    }
  }
}