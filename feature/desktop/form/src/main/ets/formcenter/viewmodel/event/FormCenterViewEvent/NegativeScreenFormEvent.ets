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

import { FormCenterViewParam, } from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { AppItemInfo, FormModel } from '@ohos/launchercommon';
import { FormCenterViewEvent } from './FormCenterViewEvent';
import { FormCenterViewModel } from '../../FormCenterViewModel';
import { FormCenterEventInterface } from '../../../interfaces/FormCenterEventInterface';

const TAG = 'NegativeScreenFormEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class NegativeScreenFormEvent extends FormCenterViewEvent implements FormCenterEventInterface {

  protected async firstShowView(param: FormCenterViewParam): Promise<void> {
    log.showInfo('firstShowView');
    await super.firstShowView(param);
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
    let appList: AppItemInfo[] = this.mAppInfoListViewData.getAllData();
    bundleBlackList.forEach(item => {
      let mRecommendedIndex = this.mRecommendedCardList.findIndex(card => card.bundleName === item);
      let appListIndex = appList.findIndex(app => app.bundleName === item);
      if (mRecommendedIndex !== -1) {
        this.mRecommendedCardList.splice(mRecommendedIndex, 1);
      }
      if (appListIndex !== -1) {
        this.mAppInfoListViewData.deleteItemByIndex(appListIndex);
      }
      log.showInfo(`filterNegativeScreenCards blackBundle: ${item} mRecommendedIndex: ${mRecommendedIndex} appListIndex: ${appListIndex}`);
    })
    log.showInfo(`filterNegativeScreenCards appList: ${appList.length} this.mAppInfoListViewData ${this.mAppInfoListViewData.totalCount()}`)
    return true;
  }
}