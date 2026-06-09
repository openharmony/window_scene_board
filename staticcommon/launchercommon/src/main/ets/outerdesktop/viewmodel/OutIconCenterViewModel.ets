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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { ResourceManager } from '@ohos/frameworkwrapper';
import {
  AppItemInfo,
  AppModel,
  GridLayoutItemInfo,
  LaunchLayoutCacheManager,
} from '../../TsIndex';
import { OuterAppManager } from '../../manager/OuterAppManager';
import { intl } from '@kit.LocalizationKit';
import { taskpool } from '@kit.ArkTS';

const TAG: string = 'OuterIconCenterViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 外屏应用管理Model
 */
export class OuterIconCenterViewModel {
  private static mInstance: OuterIconCenterViewModel;
  private appInfoAllList: AppItemInfo[] = [];
  // 所有应用,包括外屏已添加的应用
  private appInfoAllListByAdded: AppItemInfo[] = [];
  private topAppList: AppItemInfo[] = [];
  private experimentAppList: AppItemInfo[] = [];
  private nameMap: Map<string, string> = new Map();
  private readonly mOuterAppManager: OuterAppManager = OuterAppManager.getInstance();
  private collator: intl.Collator | undefined;
  private options: intl.CollatorOptions = {
    localeMatcher: 'lookup',
    usage: 'sort',
    numeric: true,
    caseFirst: 'lower',
    sensitivity: 'case',
    collation: 'phonebk',
  };

  /**
   * 获取 OuterIconCenterViewModel 实例
   *
   * @returns OuterIconCenterViewModel实例
   */
  public static getInstance(): OuterIconCenterViewModel {
    if (OuterIconCenterViewModel.mInstance == null) {
      OuterIconCenterViewModel.mInstance = new OuterIconCenterViewModel();
    }
    return OuterIconCenterViewModel.mInstance;
  }

  /**
   * 获取App列表
   *
   * @returns App列表
   */
  public getAppInfoList(): AppItemInfo[] {
    log.showInfo(`getAppInfoList appInfoAllList: ${this.appInfoAllList.length}`);
    return this.appInfoAllList;
  }

  /**
   * 获得新形态小折叠外屏所有应用,包括已添加至外屏桌面的应用
   *
   * @returns App列表
   */
  public getAllListByAdded(): AppItemInfo[] {
    log.showInfo(`getAllListByAdded: ${this.appInfoAllListByAdded.length}`);
    return this.appInfoAllListByAdded;
  }

  /**
   * 获得精品应用
   *
   * @returns 精品应用
   */
  public getTopQualityPkgList(): AppItemInfo[] {
    return this.topAppList;
  }

  /**
   * 获得实验应用,需要初始化再使用
   *
   * @returns 实验应用
   */
  public getPoorExperimentalPkgList(): AppItemInfo[] {
    return this.experimentAppList;
  }

  /**
   * 获取包名与小写转换后的应用名称map
   */
  public getLowerCaseAppNameMap(): Map<string, string> {
    return this.nameMap;
  }

  /**
   * 更新应用中心
   *
   * @returns
   */
  public async updateOuterIconCenterData(): Promise<void> {
    this.mOuterAppManager.updateNameList();
    log.showWarn('The refresh time is not reached.');
    let appList: AppItemInfo[] = AppModel.getInstance().getAppList();
    this.nameMap.clear();
    for (let i = 0; i < appList.length; i++) {
      appList[i].applicationName = await ResourceManager.getInstance()
        .getAppNameSync(appList[i].appLabelId, appList[i].bundleName, appList[i].moduleName, '');
    }
    taskpool.execute(asyncGetAppTagInfos, appList).then((item) => {
      let tmpItem = item as Map<string, string>;
      this.nameMap = tmpItem;
    });
    let outerList: GridLayoutItemInfo[] = LaunchLayoutCacheManager.getInstance().getOuterList();
    this.sortLocale(appList);
    let appListFilterOuter: AppItemInfo[] = appList.filter((item) => {
      return !outerList.some(itemSelect => itemSelect.bundleName === item.bundleName &&
        itemSelect.appIndex === item.appIndex &&
        itemSelect.typeId === 0);
    });
    this.topAppList = [];
    this.experimentAppList = [];
    let topAppNameList: string[] = this.mOuterAppManager.getTopPkgNameListByTag();
    let experimentAppNameList: string[] = this.mOuterAppManager.getExperimentalPkgNameListByTag();
    appList.forEach(item => {
      if (CheckEmptyUtils.isEmpty(item) || topAppNameList.includes(item.bundleName) ||
        experimentAppNameList.includes(item.bundleName)) {
        return;
      }
      if (this.mOuterAppManager.isTopApp(item.bundleName)) {
        topAppNameList.push(item.bundleName);
        return;
      }
      if (this.mOuterAppManager.isOpenVersion(true) &&
        !this.mOuterAppManager.isBlockApp(item.bundleName, undefined, true)) {
        experimentAppNameList.push(item.bundleName);
        return;
      }
    });
    appListFilterOuter.forEach(item => {
      if (topAppNameList.indexOf(item.bundleName) !== -1) {
        this.topAppList.push(item);
      } else if (experimentAppNameList.indexOf(item.bundleName) !== -1) {
        this.experimentAppList.push(item);
      }
    });
    this.appInfoAllList = this.topAppList.concat(this.experimentAppList);
    this.appInfoAllListByAdded = appList.filter(item => {
     return (topAppNameList.indexOf(item.bundleName) !== -1) ||
       (experimentAppNameList.indexOf(item.bundleName) !== -1);
    });
  }

  private sortLocale(appList: AppItemInfo[]): void {
    if (appList.length === 0) {
      return;
    }
    if (CheckEmptyUtils.isEmpty(this.collator)) {
      this.collator = new intl.Collator(new intl.Locale().toString(), this.options);
    }
    appList.sort((appInfoFirst, appInfoSecond) => {
      return this.collator?.compare(appInfoFirst.applicationName, appInfoSecond.applicationName) ?? 0;
    });
  }
}

async function asyncGetAppTagInfos(appItemInfos: AppItemInfo[]): Promise<Map<string, string>> {
  'use concurrent';
  let nameMap: Map<string, string> = new Map();
  appItemInfos.forEach(item => {
    if (item.applicationName) {
      nameMap.set(item.bundleName, item.applicationName.toLocaleLowerCase());
    }
  });
  return nameMap;
}
