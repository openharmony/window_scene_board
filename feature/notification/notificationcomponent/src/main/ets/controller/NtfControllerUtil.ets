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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { pinTopLimitDC } from './PinTopLimitDialogController';

const TAG = 'NtfControllerUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class NtfControllerUtil {
  static isDialogShowing(ntfType: number): boolean {
    if (pinTopLimitDC.isShowing(ntfType)) {
      log.showInfo('PinTopLimitDialog is showing in TYPE_PHONE_DROPDOWN.');
      return true;
    }
    return false;
  }
}