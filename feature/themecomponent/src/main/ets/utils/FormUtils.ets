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

import { formHost } from '@kit.FormKit';
import type Base from '@ohos.base';
import { Log } from '../aigcServiceAbility/IdlService/Log';

const splitKey = ',';
const TAG: string = 'FormUtils';

/**
 * FormUtils
 */
export class FormUtils {
  public static checkStrIsEmpty(str: string): boolean {
    return str === undefined || str === null || (typeof str === 'string' && str.trim().length === 0);
  }

  /**
   * 删除卡片batch
   *
   * @param formId 卡片id
   */
  public static async deleteFormByIdBatch(tempFormCardIdList: string = ''): Promise<void> {
    Log.info(TAG, `deleteFormByIdBatch start `);
    if (!tempFormCardIdList) {
      return;
    }
    try {
      let itemArr = tempFormCardIdList.split(splitKey);
      if (itemArr.length === 0) {
        return;
      }
      for (let cardId of itemArr) {
        FormUtils.deleteFormById(cardId);
      }
    } catch (error) {
      Log.error(TAG, `deleteFormByIdBatch catch error, code: ${error}`);
    }
  }

  /**
   * 删除卡片
   *
   * @param formId 卡片id
   */
  public static async deleteFormById(formId: string): Promise<void> {
    Log.info(TAG, `deleteFormById, formId: ${formId}`);
    if (FormUtils.checkStrIsEmpty(formId)) {
      Log.error(TAG, `deleteFormById error, formId: ${formId}`);
      return;
    }
    try {
      formHost.deleteForm(formId, (error: Base.BusinessError) => {
        if (error) {
          Log.info(TAG, `deleteFormById error, code: ${error.code}, message: ${error.message}`);
        } else {
          Log.info(TAG, 'formHost deleteForm success');
        }
      });
    } catch (error) {
      Log.error(TAG, `deleteFormById catch error, code: ${error}`);
    }
  }

  /**
   * 注册卡片
   *
   * @param formId 卡片id
   */
  public static castFormById(formId: string): void {
    Log.info(TAG, `castFormById, formId: ${formId}`);
    if (FormUtils.checkStrIsEmpty(formId)) {
      Log.info(TAG, `castFormById error, formId: ${formId}`);
      return;
    }
    try {
      formHost.castToNormalForm(formId, (error: Base.BusinessError) => {
        if (error) {
          Log.error(TAG, `castFormById error, code: ${error.code}, message: ${error.message}`);
        } else {
          Log.info(TAG, 'castFormById success');
        }
      });
    } catch (error) {
      Log.error(TAG, `castFormById error, code: ${error.code}, message: ${error.message}`);
    }
  }
}