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

import type Base from '@ohos.base';
import formHost from '@ohos.app.form.formHost';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'ScreenLockFormManagerUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export default class ScreenLockFormManagerUtil {

  /**
   * 删除卡片
   *
   * @param formId 卡片id
   */
  public static deleteFormById(formId: string): void {
    log.showInfo(`deleteFormById, formId: ${formId}`);
    try {
      formHost.deleteForm(formId, (error: Base.BusinessError) => {
        if (error) {
          log.showError(`error, code: ${error.code}, message: ${error.message}`);
        } else {
          log.showInfo('formHost deleteForm success');
        }
      });
    } catch (error) {
      log.showError(`catch error, code: ${(error as Base.BusinessError).code}, message: ${(error as Base.BusinessError).message}`);
    }
  }
}