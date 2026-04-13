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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { ResourceManager } from '@ohos/frameworkwrapper';
import { CardItemInfo } from '@ohos/launchercommon';
import { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';

const TAG = 'FormCenterFormCommonUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);
const KEY_NAME = 'name';

export class FormCenterFormCommonUtil {
  public static async getResourceName(defaultName: string, id: string | number,
    tag: string, item: CardItemInfo): Promise<string> {
    const cacheKey: string = `${id}${item.bundleName}${item.moduleName}`;
    let name: string = ResourceManager.getInstance().getAppResourceCache(cacheKey, KEY_NAME) as string;
    if (!CheckEmptyUtils.checkStrIsEmpty(name)) {
      return name;
    }
    return defaultName;
  }

  public static getFormItemId(bundleName: string, index: number): string {
    if (!bundleName || !index) {
      log.showWarn(`get form item id invalid param, bundleName: ${bundleName}, index: ${index}`);
    }

    return `FormCenterFormItem_Stack_${bundleName}_${index}`;
  }
}