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

import { FormModel, AppModel, AtomicServiceAppModel } from '@ohos/launchercommon';
import type { CardItemInfo, AppItemInfo } from '@ohos/launchercommon';
import { LogHelper, LogDomain, CheckEmptyUtils } from '@ohos/basicutils';
import { ResourceManager } from '@ohos/frameworkwrapper';
import { PinyinSort } from '@ohos/frameworkpinyin';
import HashSet from '@ohos.util.HashSet';

const TAG = 'ServiceFormManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

/**
 * form service
 */
export default class ServiceFormManager {
  private readonly mFormModel: FormModel;
  private readonly mAppModel: AppModel;
  private readonly mPinyinSort: PinyinSort;
  private static instance: ServiceFormManager;

  private constructor() {
    this.mFormModel = FormModel.getInstance();
    this.mAppModel = AppModel.getInstance();
    this.mPinyinSort = new PinyinSort();
  }

  /**
   * getInstance
   *
   * @return Instance
   */
  static getInstance(): ServiceFormManager {
    if (!ServiceFormManager.instance) {
      ServiceFormManager.instance = new ServiceFormManager();
    }
    return ServiceFormManager.instance;
  }

  private sortServiceFormAppList(serviceFormAppList: AppItemInfo[]): void {
    if (serviceFormAppList.length === 0) {
      return;
    }
    serviceFormAppList.sort((item1, item2) => {
      return this.mPinyinSort.sortByParameter(item1.applicationName, item2.applicationName);
    });
  }

  /**
   * 获取带有FA属性的APP信息
   *
   * @return 带有FA属性的APP信息
   */
  async getServiceFormAppList(): Promise<AppItemInfo[]> {
    let allAppList: AppItemInfo[] = [];
    // 桌面app
    let desktopServiceFormAppList: AppItemInfo[] = await this.getDesktopServiceFormAppList();
    !CheckEmptyUtils.isEmptyArr(desktopServiceFormAppList) && allAppList.push(...desktopServiceFormAppList);
    // app排序
    this.sortServiceFormAppList(allAppList);
    return allAppList;
  }

  private async getDesktopServiceFormAppList(): Promise<AppItemInfo[]> {
    let serviceFormAppNames: HashSet<string> = new HashSet();
    let allAppItemFormInfoMap: Map<string, CardItemInfo[]> = this.mFormModel.getAllAppItemFormInfoMap();
    let appListInfo: AppItemInfo[] = this.mAppModel.getAppList();
    let serviceFormAppList: AppItemInfo[] = [];
    for (let i: number = 0; i < appListInfo.length; i++) {
      let bundleName: string = appListInfo[i].bundleName;
      if (serviceFormAppNames.has(bundleName) || !allAppItemFormInfoMap.has(bundleName)) {
        continue;
      }
      const formAppInfoList = allAppItemFormInfoMap.get(bundleName);
      if (CheckEmptyUtils.isEmptyArr(formAppInfoList)) {
        continue;
      }
      appListInfo[i].applicationName = await ResourceManager.getInstance()
        .getAppNameSync(appListInfo[i].appLabelId, bundleName, appListInfo[i].moduleName, '');
      serviceFormAppList.push(appListInfo[i]);
      serviceFormAppNames.add(bundleName);
    }
    return serviceFormAppList;
  }
}