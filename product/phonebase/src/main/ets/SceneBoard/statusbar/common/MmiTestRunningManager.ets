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
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { SystemParameterHelper } from '@ohos/systemuicommon/src/main/ets/utils/SystemParameterHelper';

const TAG = 'MmiTestRunningManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
/**
 * mmi test running flag manager
 */
export class MmiTestRunningManager {
  private isRunning: boolean = false;

  private getMmiTestRunningFlag(): boolean {
    let isRunningFlag: boolean = false;
    try {
      isRunningFlag = SystemParameterHelper.getCompareResult('persist.mmitest.isrunning', 'false', 'true');
    } catch (error) {
      log.showError(`get mmi test running flag fail. code: ${error?.code}, msg: ${error?.message}`);
    }
    return isRunningFlag;
  }

  public checkIsMmiTestRunningForbidden(event?: TouchEvent, scene?: string): boolean {
    if (!event || event.type === TouchType.Down) {
      this.isRunning = this.getMmiTestRunningFlag();
    }

    if (this.isRunning) {
      log.showInfo(`now mmi test is running, disable the drop-down top bar when ${scene}!`);
      return true;
    }
    return false;
  }
}
