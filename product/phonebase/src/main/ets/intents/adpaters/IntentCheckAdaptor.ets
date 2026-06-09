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

import insightIntent from '@ohos.app.ability.insightIntent';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { IntentCodeConstants } from '../IntentCodeConstant';

const TAG: string = 'IntentCheckAdaptor';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

const checkItemFunRecord: Record<string, Function> = {
  'PIP_SWITCH': () => {},
  'MULTI_DOCK_SWITCH': () => {},
}

/**
 * Intention Framework Operation Setting Validation Setting Item Transfer Class
 *
 * @since 2024-05-23
 */
export class IntentCheckAdaptor {
  public static async checkSettingItem(itemName: string, appBundleName: string): Promise<insightIntent.ExecuteResult> {
    log.showInfo(`checkSettingItem intent itemName is ${itemName}`);
    let func = checkItemFunRecord[itemName];
    if (func === null || func == undefined) {
      let rsp: insightIntent.ExecuteResult = {
        code: IntentCodeConstants.DEFAULT_CODE_FAILED,
        result: {
          'itemName': itemName,
          'isSupport': false,
          'appBundleName': appBundleName,
        }
      }
      return rsp;
    }
    let isValid: boolean = func();
    let rsp: insightIntent.ExecuteResult = {
      code: IntentCodeConstants.DEFAULT_CODE_SUCCESS,
      result: {
        'itemName': itemName,
        'isSupport': isValid,
        'appBundleName': appBundleName,
      }
    }
    return rsp;
  }

  /**
   * 检查页面是否可以跳转
   * @param intentParam 意图参数
   * @returns
   */
  public static checkSettingPage(intentParam: Record<string, Object>): insightIntent.ExecuteResult {
    log.showInfo('checkSettingPage');
    const entryKey: string = intentParam.entryKey?.toString();
    const uriParams: string = intentParam.uriParams?.toString();
    const appBundleName: string = intentParam.appBundleName?.toString();
    let rsp: insightIntent.ExecuteResult = {
      code: IntentCodeConstants.DEFAULT_CODE_SUCCESS,
      result: {
        'entryKey': entryKey,
        'uriParams': uriParams,
        'appBundleName': appBundleName,
      }
    }
    return rsp;
  }
}