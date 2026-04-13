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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { AppItemInfo, FormModel } from '@ohos/launchercommon';
import { FormCenterViewModel } from '../../FormCenterViewModel';
import { FormCenterStackViewEvent } from './FormCenterStackViewEvent';

const TAG = 'NegativeScreenStackViewEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class NegativeScreenStackViewEvent extends FormCenterStackViewEvent {
  constructor(openHighIndexView: boolean, appList: AppItemInfo[]) {
    log.showInfo('NegativeScreenStackViewEvent constructor');
    super(openHighIndexView, appList);
    if (FormModel.getInstance().isSupportFormCenterSplit()) {
      return;
    }
    this.filterNegativeScreenCards();
  }

  public filterNegativeScreenCards(): boolean {
    log.showInfo('filterNegativeScreenCards');
    // 负一屏拉起卡片中心需过滤黑名单卡片和应用
    let bundleBlackList: string[] = FormCenterViewModel.getInstance().getNegativeScreenBundleBlackList();
    if (!bundleBlackList || bundleBlackList.length === 0) {
      log.showWarn('filterNegativeScreenCards bundleBlackList is empty');
      return false;
    }
    bundleBlackList.forEach(item => {
      let appListIndex: number = this.appList.findIndex(app => app.bundleName === item);
      if (appListIndex !== -1) {
        this.appList.splice(appListIndex, 1);
      }
      log.showInfo(`filterNegativeScreenCards blackBundle: ${item}  appListIndex: ${appListIndex}`);
    })
    log.showInfo('filterNegativeScreenCards end');
    return true;
  }
}
