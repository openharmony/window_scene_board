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

/**
 * 调用异常打点
 */
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import {
  FreqLimitMaintenance,
  LimitMaintenanceExt
} from '@ohos/systemuiutils/src/main/ets/maintenance/FreqLimitMaintenance';
import { MaintenanceRecordType } from '@ohos/systemuiutils/src/main/ets/maintenance/MaintenanceModel';
import { ICommonExceptionReporter } from './ICommonExceptionMaintenance';

const TAG = 'MainExceptionReporter';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

interface CommonExceptionMaintenanceExt extends LimitMaintenanceExt {
  desc?: string;
  stack?: string;
}

export class MainExceptionReporter implements ICommonExceptionReporter {
  public reportInfo(desc: string, errorCode: number, stack?: string, tag?: string): void {
    new ExceptionReporter().reportInfo(errorCode, desc, stack, tag);
  }
}

export class ExceptionReporter extends FreqLimitMaintenance<CommonExceptionMaintenanceExt> {
  private static readonly DEFAULT_TAG = 'common_exception';

  // 通用错误码一天最多上报500条日志
  private static readonly LOG_LIMIT = 500;

  // 特殊错误码一天最多上报5条日志
  private static readonly SPECIAL_LOG_LIMIT = 5;

  // 上报异常日志默认错误码
  private static readonly DEFAULT_EXCEPTION_CODE = -1;

  private static readonly MAX_STACK_LEN = 2048;

  constructor() {
    super(MaintenanceRecordType.INTERFACE_EXCEPTION);
  }

  protected getDimensionAndThreshold() : [number[], number] {
    if (this.ext.errorCodes?.every(code => code !== ExceptionReporter.DEFAULT_EXCEPTION_CODE)) {
      return [this.ext.errorCodes, ExceptionReporter.SPECIAL_LOG_LIMIT];
    }
    // 统一限频
    return [[ExceptionReporter.DEFAULT_EXCEPTION_CODE], ExceptionReporter.LOG_LIMIT];
  }

  public reportInfo(errorCode: number, desc?: string, stack?: string, tag?: string): void {
    try {
      this.ext.bundleName = tag ?? ExceptionReporter.DEFAULT_TAG; // 频控使用
      this.ext.desc = desc;
      this.ext.stack = stack?.slice(0, ExceptionReporter.MAX_STACK_LEN);
      this.addErrorCode(errorCode ?? ExceptionReporter.DEFAULT_EXCEPTION_CODE);
      this.report();
    } catch (e) {
      log.error('report info failed, ' + e);
    }
  }
}