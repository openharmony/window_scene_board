/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

import { CommonConstants, SettingsModel, RdbStoreManager, FormLayoutCacheManager } from '@ohos/launchercommon';
import { LogHelper, LogDomain, CheckEmptyUtils } from '@ohos/basicutils';
import type { GridLayoutItemInfo } from '@ohos/launchercommon';
import type { DefaultDesktopLayoutInfo } from '@ohos/launchercommon';

const TAG: string = 'FormStackModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

/**
 * FormStack information data model
 */
export class FormStackModel {
  private mFormStackInfoList: GridLayoutItemInfo[] = [];

  constructor() {
  }

  /**
   * Get formstack list
   *
   * @return formstack list
   */
  getFormStackList(isOuter?: boolean): GridLayoutItemInfo[] {
    log.showDebug('get the formStackList');
    this.mFormStackInfoList =
      FormLayoutCacheManager.getInstance().selectGridLayoutItemsByType(CommonConstants.TYPE_FORM_STACK, isOuter);
    return this.mFormStackInfoList;
  }

  /**
   * delete formstack
   */
  deleteFormStackById(formStackId: string): void {
    if (CheckEmptyUtils.checkStrIsEmpty(formStackId)) {
      log.showError('formStackId is null, delete form from formstack failed');
      return;
    }
    RdbStoreManager.getInstance().deleteItemByInfoId(formStackId);
  }
}
