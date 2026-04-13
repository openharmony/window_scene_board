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

import {
  BaseVM,
  ViewCallback
} from './BaseVM';
import { DateUtils } from '../common/DateUtils';
import I18n from '@ohos.i18n';
import { taskpool } from '@kit.ArkTS';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const TAG = 'TimeVM';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 时间文本数据处理
 *
 * @since 2022-12-23
 */
export class TimeVM extends BaseVM {
  /**
   * 时间是否显示AM/PM
   */
  private isShowAmPm: boolean = true;
  /**
   * 时间是否异步获取
   */
  private isAsyncGetTime: boolean = false;

  /**
   * 初始化（复写）
   *
   * @param isShowAmPm 是否显示AM/PM
   * @param slot 唯一标示
   * @param callback 回调器
   */
  initOv(isShowAmPm: boolean, slot: string, callback: ViewCallback, isAsyncGetTime?: boolean): void {
    this.isShowAmPm = isShowAmPm;
    this.isAsyncGetTime = isAsyncGetTime ?? false;
    this.init(slot, callback);
  }

  public getCurrentTime(): string {
    let result = DateUtils.formatLocalTime(new Date());
    log.showInfo(`getCurrentTime, formatLocalTime result: ${result}`);
    if (this.isShowAmPm) {
      return result;
    }
    result = DateUtils.getTimeWithoutAmPm(result);
    return result;
  }

  /**
   * 更新时间文本
   *
   * @return 时间文本
   */
  protected async updateTime(): Promise<string> {
    if (this.isAsyncGetTime) {
      return new Promise((resolve) => {
        this.asyncGetCurrentTime(resolve);
      });
    }
    return this.getCurrentTime();
  }

  private asyncGetCurrentTime(resolve: (value: string | PromiseLike<string>) => void) {
    try {
      taskpool.execute(asyncGetTime, this.isShowAmPm)
        .then((result: Object) => {
          resolve(result as string);
        }).catch((error: object) => {
        log.showError('getTime error', error);
        resolve('');
      });
    } catch (error) {
      log.showError('getTime error', error);
      resolve('');
    }
  }
}
@Concurrent
export async function asyncGetTime(isShowAmPm: boolean): Promise<string> {
  let result = DateUtils.formatLocalTime(new Date());
  if (isShowAmPm) {
    return result;
  }
  result = DateUtils.getTimeWithoutAmPm(result);
  return result;
}
