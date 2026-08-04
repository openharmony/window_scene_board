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

import {
  CommonUtils,
  LogDomain,
  LogHelper,
  CheckEmptyUtils,
} from '@ohos/basicutils';
import {
  GlobalContext,
  localEventManager,
} from '@ohos/frameworkwrapper';
import type ctx from '@ohos.app.ability.common';


import {
  AppGalleryDownloadManager,
  AppInstallUtils,
  AppStatus,
  CommonConstants,
  DockItemInfo,
  EventConstants,
  GridLayoutItemInfo,
  IExecutor,
  LaunchLayoutCacheManager,
  LegacyInfo,
  ResidentLayoutCacheMgr,
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { CloneCloudServiceResponse } from '@ohos/launchercommon/src/main/ets/constants/DesktopServiceConstant';
import SmartDockConstants from '@ohos/smartdock/src/main/ets/default/common/constants/SmartDockConstants';
import SmartDockModel from '@ohos/smartdock/src/main/ets/default/model/SmartDockModel';
import preferences from '@ohos.data.preferences';
import {
  RestoreLauncherDataListInfo
} from '@ohos/launchercommon/src/main/ets/transformdata/RestoreLauncherDataListInfo';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = 'CancelRestoreLauncherData';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 取消克隆,需要删除占位图标
 *
 */
export class CancelRestoreLauncherData implements IExecutor {

  async execute(extra?: object): Promise<string> {
    if (extra === null || extra === undefined) {
      log.showError('the extra is null');
      return CloneCloudServiceResponse.FAIL;
    }
    let msg = extra as ExtraInfo;
    let backUpExtraDatas: ExtraDataInfo[] = msg?.list as ExtraDataInfo[];
    log.showInfo(`CancelRestoreLauncherData start msg.list.length = ${backUpExtraDatas?.length}`);
    let restoreBundleList: string[] = [];
    for (let i = 0; i < backUpExtraDatas.length; i++) {
      let curItem = backUpExtraDatas[i];
      restoreBundleList.push(CommonUtils.isEmpty(curItem?.bundleName) ? '' : curItem.bundleName);
      log.showInfo(`CancelRestoreLauncherData item:  ${curItem?.bundleName}`);
    }

    let cancelBundles: string[] = [];
    for (let i = 0; i < restoreBundleList.length; i++) {
      let selectItem: GridLayoutItemInfo[] = LaunchLayoutCacheManager.getInstance()
        .selectGridLayoutItemsByBundleName(restoreBundleList[i]);
      // 如果未在当前桌面图标中找到，则在桌面文件夹中再遍历一次
      if (selectItem.length === 0) {
        this.getItemFromFolder(restoreBundleList[i], selectItem);
      }
      for (let j = 0; j < selectItem.length; ++j) {
        log.showInfo(`CancelRestoreLauncherData bundleName: ${selectItem[j]?.bundleName} ,appStatus: ${selectItem[j]?.appStatus}`);
        if (selectItem[j].appStatus !== AppStatus.INSTALLED) {
          localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_DELETE_DEFAULT_CARD,
            selectItem[j]?.bundleName);
          localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_DELETE, {
            bundleName: selectItem[j]?.bundleName,
            keyName: selectItem[j]?.keyName,
            appIndex: selectItem[j]?.appIndex,
          });
          cancelBundles.push(selectItem[j]?.bundleName);
        }
      }
    }
    if (cancelBundles.length > 0) {
      AppInstallUtils.getInstance().cancelRestoreLauncherData(cancelBundles);
    }
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
    for (let i = 0; i < restoreBundleList.length; i++) {
      if (this.isNeedToDelete(restoreBundleList[i])) {
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_DELETE_DEFAULT_CARD, restoreBundleList[i]);
        SmartDockModel.getInstance().deleteDockItem({
          bundleName: restoreBundleList[i],
          keyName: undefined,
          isDeleteAppToUninstallFolder: true
        }, SmartDockConstants.RESIDENT_DOCK_TYPE);
        AppInstallUtils.getInstance().cancelTask(restoreBundleList[i]);
      }
    }
    await this.deleteCancelAppInPreferences(restoreBundleList);
    return CloneCloudServiceResponse.SUCCESS;
  }

  private async deleteCancelAppInPreferences(restoreBundleList: string[]): Promise<void> {
    let context = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext);
    try {
      await preferences.getPreferences(context, 'RestoreLauncherData')
        .then((preference) => {
          this.deleteCancelAppInPre(preference, restoreBundleList);
        }).catch((err: BusinessError) => {
          log.showError(`deleteCancelAppInPreferences error ${err?.code}, ${err?.message}`);
        });
    } catch (error) {
      log.showError(`delete or cancel app in preference fail ${error?.code}, ${error?.message}`);
    }
  }

  private deleteCancelAppInPre(preference: preferences.Preferences, restoreBundleList: string[]): void {
    let pkgList: string[] = preference.getSync('RestorePkgData', []) as string[];
    let bundleList: string[] = preference.getSync('RestoreBundleData', []) as string[];
    let iconUriList: string[] = preference.getSync('RestoreIconUriData', []) as string[];
    let titleList: string[] = preference.getSync('RestoreIconTitleData', []) as string[];
    let legacyInfoList: LegacyInfo[] = preference.getSync('RestoreLegacyInfoData', []) as LegacyInfo[];
    let appTypeList: number[] = preference.getSync('RestoreAppTypeData', []) as number[];
    let enterpriseLinkList: string[] = preference.getSync('RestoreEnterpriseLinkData', []) as string[];
    let isWaitForHarmonyList: boolean[] = preference.getSync('RestoreIsWaitForHarmonyListData', []) as boolean[];
    let waitForSystemKeyList: string[] = preference.getSync('RestoreWaitForSystemKeyListData', []) as string[];
    let appIndexList: number[] = preference.getSync('RestoreAppIndexData', []) as number[];
    let resLauDaListInfo = new RestoreLauncherDataListInfo();
    for (let i = 0; i < pkgList.length; i++) {
      let index = restoreBundleList.indexOf(pkgList[i]);
      if (index === CommonConstants.INVALID_VALUE) {
        resLauDaListInfo.pkgList.push(pkgList[i]);
        resLauDaListInfo.bundleList.push(bundleList[i]);
        resLauDaListInfo.iconUriList.push(iconUriList[i]);
        resLauDaListInfo.titleList.push(titleList[i]);
        resLauDaListInfo.legacyInfoList.push(legacyInfoList[i]);
        resLauDaListInfo.appTypeList.push(appTypeList[i]);
        resLauDaListInfo.enterpriseLinkList.push(enterpriseLinkList[i]);
        resLauDaListInfo.isWaitForHarmonyList.push(isWaitForHarmonyList[i]);
        resLauDaListInfo.waitForSystemKeyList.push(waitForSystemKeyList[i]);
        resLauDaListInfo.appIndexList.push(appIndexList[i]);
      }
    }
    preference.putSync('RestorePkgData', resLauDaListInfo.pkgList);
    preference.putSync('RestoreBundleData', resLauDaListInfo.bundleList);
    preference.putSync('RestoreIconUriData', resLauDaListInfo.iconUriList);
    preference.putSync('RestoreIconTitleData', resLauDaListInfo.titleList);
    preference.putSync('RestoreLegacyInfoData', resLauDaListInfo.legacyInfoList);
    preference.putSync('RestoreAppTypeData', resLauDaListInfo.appTypeList);
    preference.putSync('RestoreEnterpriseLinkData', resLauDaListInfo.enterpriseLinkList);
    preference.putSync('RestoreIsWaitForHarmonyListData', resLauDaListInfo.isWaitForHarmonyList);
    preference.putSync('RestoreWaitForSystemKeyListData', resLauDaListInfo.waitForSystemKeyList);
    preference.putSync('RestoreAppIndexData', resLauDaListInfo.appIndexList);
    preference.flush();
  }

  private isNeedToDelete(bundleName: string): boolean {
    let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    if (CheckEmptyUtils.isEmptyArr(residentList)) {
      log.showInfo('isBundleNameAppExistInDock residentList is empty');
      return false;
    }
    let findIndex = residentList.findIndex(item => {
      if (item.itemType === CommonConstants.TYPE_APP) {
        return item.bundleName === bundleName && item.appStatus !== AppStatus.INSTALLED;
      } else if (item.itemType === CommonConstants.TYPE_FOLDER) {
        return item.layoutInfo?.flat().findIndex(item => item.bundleName === bundleName &&
          item.appStatus !== AppStatus.INSTALLED) !== CommonConstants.INVALID_VALUE;
      } else {
        return false;
      }
    });
    return findIndex !== CommonConstants.INVALID_VALUE;
  }

  private getItemFromFolder(bundleName: string, itemList: GridLayoutItemInfo[]): void {
    let folderItems: GridLayoutItemInfo[] = LaunchLayoutCacheManager.getInstance()
      .selectGridLayoutItemsByType(CommonConstants.TYPE_FOLDER);
    for (let i = 0; i < folderItems.length; i++) {
      folderItems[i]?.layoutInfo?.flat().forEach(item => {
        if (item.bundleName === bundleName) {
          itemList.push(item);
        }
      });
    }
  }
}

class ExtraInfo {
  public list: ExtraDataInfo[] = [];
  public ownerInfo: OwnerInfo = new OwnerInfo();
}

/**
 * 备份数据格式
 */
export class ExtraDataInfo {
  public callerName: string = '';

  public callerType: number = 0;

  public bundleName: string = '';

  public packageName: string = '';

  public title: string = '';

  public iconUri: string = '';
}

/**
 * 备份数据格式
 */
export class OwnerInfo {
  public bundleName: string = '';

  public moduleName: string = '';

  public abilityName: string = '';
}