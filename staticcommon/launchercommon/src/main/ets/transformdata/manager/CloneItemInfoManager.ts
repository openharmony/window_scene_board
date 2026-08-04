/**
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import { CheckEmptyUtils, CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import preferences from '@ohos.data.preferences';
import type { CloneItemInfo } from '../../constants/CommonConstants';
import type ctx from '@ohos.app.ability.common';
import { CommonConstants } from '../../constants/CommonConstants';
import { DeliverUtil, AppReserveType, LegacyInfo } from '../../TsIndex';
import { RestoreLauncherDataListInfo } from '../RestoreLauncherDataListInfo';
import { ObjectCopyUtil } from '@ohos/componenthelper';

const TAG = 'CloneItemInfoManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.BACKUP, TAG);

class CloneItemInfoManager {
  private static sInstance: CloneItemInfoManager;

  private cloneItemInfoList : CloneItemInfo[] = [];

  private readonly filesDir: string = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext)?.filesDir;

  constructor() {
  }

  /**
   * select the clone app list from preference
   *
   * @returns the list of clone app
   */
  public async queryRestoreLauncherData(): Promise<CloneItemInfo[]> {
    log.showInfo('query Restore launcher Data');
    let resLauDaListInfo = new RestoreLauncherDataListInfo();
    try {
      let context = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext);
      // 清除缓存强制从本地文件读取，防止因进程未取消读到上一次克隆的缓存数据
      preferences.removePreferencesFromCacheSync(context, CommonConstants.RESTORE_LAUNCHER_DATA);
      const preference: preferences.Preferences =
        preferences.getPreferencesSync(context, { name: CommonConstants.RESTORE_LAUNCHER_DATA });
      resLauDaListInfo.pkgList = preference.getSync('RestorePkgData', []) as string[];
      resLauDaListInfo.bundleList = preference.getSync('RestoreBundleData', []) as string[];
      resLauDaListInfo.iconUriList = preference.getSync('RestoreIconUriData', []) as string[];
      resLauDaListInfo.titleList = preference.getSync('RestoreIconTitleData', []) as string[];
      resLauDaListInfo.callerName = preference.getSync('RestoreCallerName', null) as string;
      resLauDaListInfo.isWaitForHarmonyList = preference.getSync('RestoreIsWaitForHarmonyListData', []) as boolean[];
      resLauDaListInfo.waitForSystemKeyList = preference.getSync('RestoreWaitForSystemKeyListData', []) as string[];
      resLauDaListInfo.legacyInfoList = preference.getSync('RestoreLegacyInfoData', []) as LegacyInfo[];
      resLauDaListInfo.appTypeList = preference.getSync('RestoreAppTypeData', []) as number[];
      resLauDaListInfo.enterpriseLinkList = preference.getSync('RestoreEnterpriseLinkData', []) as string[];
      resLauDaListInfo.appIndexList = preference.getSync('RestoreAppIndexData', []) as number[];
    } catch (err) {
      log.showError(`get iconUriList from SP occur error: ${err}`);
    }
    return this.getCloneItemInfoList(resLauDaListInfo);
  }

  private getCloneItemInfoList(resLauDaListInfo: RestoreLauncherDataListInfo): CloneItemInfo[] {
    this.cloneItemInfoList = [];
    if (resLauDaListInfo.pkgList.length !== resLauDaListInfo.bundleList.length ||
      resLauDaListInfo.pkgList.length !== resLauDaListInfo.iconUriList.length) {
      log.showInfo('the size of pkgList, bundleList and iconUriList is not matched');
      return this.cloneItemInfoList;
    }
    for (let i = 0; i < resLauDaListInfo.pkgList.length; i++) {
      // 取出的映射若bundleName为空则删除，防止系统迁移形成无bundleName的元素占位
      if (CheckEmptyUtils.checkStrIsEmpty(resLauDaListInfo.bundleList[i])) {
        log.showWarn(`the bundleName is Empty ${resLauDaListInfo.bundleList[i]},${resLauDaListInfo.pkgList[i]}`);
        continue;
      }
      let info: CloneItemInfo = {
        bundleName: resLauDaListInfo.bundleList[i],
        packageName: resLauDaListInfo.pkgList[i],
        iconUri: resLauDaListInfo.iconUriList[i],
        title: resLauDaListInfo.titleList[i],
        callerName: resLauDaListInfo.callerName,
        isUsed: false,
        appIndex: resLauDaListInfo.appIndexList[i]
      } as CloneItemInfo;
      this.updateEnterpriseAndWaitForHarmonyItem(resLauDaListInfo, info, i);
      this.cloneItemInfoList.push(info);
    }
    log.showWarn(`select the clone app with size: ${this.cloneItemInfoList.length}`);
    return this.cloneItemInfoList;
  }

  private updateEnterpriseAndWaitForHarmonyItem(resLauDaListInfo: RestoreLauncherDataListInfo, info: CloneItemInfo,
    index: number): void {
    if (resLauDaListInfo.legacyInfoList && resLauDaListInfo.legacyInfoList.length > 0 && resLauDaListInfo.isWaitForHarmonyList[index]) {
      log.showInfo(`has wait for harmony app, legacyInfoList length is ${resLauDaListInfo.legacyInfoList.length}`);
      let addInfo: CloneItemInfo = {
        intent: DeliverUtil.getCloneGridLayoutItemIntent(resLauDaListInfo.legacyInfoList[index], resLauDaListInfo.waitForSystemKeyList[index],
          resLauDaListInfo.enterpriseLinkList[index], resLauDaListInfo.appTypeList[index]),
        appType: resLauDaListInfo.appTypeList[index],
        enterpriseLink: resLauDaListInfo.enterpriseLinkList[index]
      } as CloneItemInfo;
      ObjectCopyUtil.simpleClone(addInfo, info);
      return;
    }
    if (resLauDaListInfo.appTypeList && resLauDaListInfo.appTypeList.length > 0 &&
      (resLauDaListInfo.appTypeList[index] === AppReserveType.ENTERPRISE ||
        resLauDaListInfo.appTypeList[index] === AppReserveType.TASTE_FRESH)) {
      let extendInfo: IIntentInfo = {
        'targetModuleUrl': resLauDaListInfo.enterpriseLinkList[index],
        'appType': resLauDaListInfo.appTypeList[index],
        'maskState': 1
      };
      let addInfo: CloneItemInfo = {
        intent: JSON.stringify(extendInfo),
        appType: resLauDaListInfo.appTypeList[index],
        enterpriseLink: resLauDaListInfo.enterpriseLinkList[index]
      } as CloneItemInfo;
      ObjectCopyUtil.simpleClone(addInfo, info);
    }
  }

  public getCloneItemInfoByPackageName(source: string, use: boolean = false, sourceAppIndex: number = 0):
    CloneItemInfo | undefined {
    let findIndex: number = -1;
    let cloneItemInfo: CloneItemInfo | undefined = this.cloneItemInfoList.find((item, idx) => {
      return item.packageName === source && (item?.appIndex ?? 0) === sourceAppIndex && (findIndex = idx) !== -1;
    });
    if (findIndex !== -1 && use) {
      this.cloneItemInfoList[findIndex].isUsed = true;
    }
    log.showInfo(`getCloneItemInfoByPackageName, packageName is ${source}, sourceAppIndex is ${sourceAppIndex}, findIndex:${findIndex}`);
    return cloneItemInfo;
  }

  /**
   * 根据包名获取克隆占位信息
   *
   * @param bundleName 应用包名
   * @param sourceAppIndex 应用index
   * @returns CloneItemInfo 克隆占位信息
   */
  public getCloneItemInfoByBundleName(bundleName: string,
    sourceAppIndex: number = CommonConstants.MAIN_APP_INDEX): CloneItemInfo | undefined {
    return this.cloneItemInfoList.find(item => item.bundleName === bundleName &&
      (item.appIndex ?? CommonConstants.MAIN_APP_INDEX) === sourceAppIndex);
  }

  /**
   * 根据包名判断是否需要克隆
   *
   * @returns the packageName of clone app
   */
  public isNeedCloneJudgeByPackageName(source: string): boolean {
    let index = this.cloneItemInfoList.findIndex((item) => {
      return item.packageName === source;
    });
    return index !== CommonConstants.INVALID_VALUE;
  }

  public static getInstance(): CloneItemInfoManager {
    if (!CloneItemInfoManager.sInstance) {
      CloneItemInfoManager.sInstance = new CloneItemInfoManager();
    }
    return CloneItemInfoManager.sInstance;
  }
}

export {CloneItemInfoManager};

export interface IIntentInfo {
  targetModuleUrl: string;
  appType: number;
  maskState: number;
}