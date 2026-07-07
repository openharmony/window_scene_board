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
  SingletonHelper
} from '@ohos/basicutils';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import {
  AppStatus,
  CommonConstants,
  DeliverUtil,
  FolderData,
  GridLayoutItemInfo,
  RdbStoreManager,
  NotHarmonyUtil,
  LauncherLayoutCacheUtil,
  ShortcutViewModel,
  AppModel,
  FolderConfigManager,
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { folderAnimateCallBack } from '@ohos/launchercommon/src/main/ets/folder/viewmdoel/FolderAnimateCallBack';
import { BigFolderViewModel } from './BigFolderViewModel';
import OpenFolderDragHandler from '../common/OpenFolderDragHandler';
import { FolderManager } from '@ohos/launchercommon/src/main/ets/folder/next/common/model/FolderManager';
import { UninstallViewModel } from './uninstall/UninstallViewModel';

const TAG = 'OpenFolderUninstallManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 文件夹展开态移除和卸载相关逻辑, 后续将BigFolderViewModel中卸载相关逻辑迁移到这个类中来,
 * 同时需要归一化移除和卸载流程, 去除相关全局变量
 */
class OpenFolderUninstallManager {
  /**
   * 移除未安装应用或快捷方式
   *
   * @param deleteItem 待移除应用
   */
  public removeFolderItem(deleteItem: GridLayoutItemInfo): void {
    // 历史缺陷待优化 通过全局变量广播触发补位动效
    if (FolderConfigManager.getInstance().isSupportNewFolder()) {
      let openFolderId: string = FolderManager.getInstance().getOpenFolderId();
      UninstallViewModel.getInstance().uninstallItem('remove shortcut in folder', openFolderId, deleteItem, true);
      return;
    }
    AppStorage.setOrCreate('unInstallItemInfo', deleteItem);
    let openFolderData: GridLayoutItemInfo = FolderData.getInstance().getOpenedFolder();
    let folderAppList: GridLayoutItemInfo[] = BigFolderViewModel.getInstance().getAppListInFolder(openFolderData);
    log.showInfo('removeFolderItem deleteItem keyName = %{public}s ,appIndex = %{public}s , folderAppList.length = %{public}d',
      deleteItem.keyName, deleteItem.appIndex, folderAppList.length);
    // 定制文件夹文件夹内2个应用当移除一个时, 不能走卸载流程
    //过滤被移除的APP
    let filterAppList: GridLayoutItemInfo[] = folderAppList.filter(appItem =>!LauncherLayoutCacheUtil
      .isSameAppByBundleName(deleteItem, appItem.bundleName, appItem.appIndex));
    if (DeliverUtil.checkFolderIsReleased(openFolderData.folderId, folderAppList.length - 1) &&
    NotHarmonyUtil.isNotHarmonyFolderShouldReleased(openFolderData.folderId, folderAppList.length - 1, filterAppList)) {
      this.removeFolderItemAndDissolveFolder(deleteItem);
      return;
    }
    BigFolderViewModel.getInstance().waitFolderMoveAniamtion(() => {
      let findIndex: number = folderAppList.findIndex(item => item?.keyName === deleteItem.keyName);
      if (findIndex >= 0) {
        folderAppList.splice(findIndex, 1);
      }
      BigFolderViewModel.getInstance().updateFolderAppList(folderAppList, openFolderData);
      OpenFolderDragHandler.getInstance().resetTranslateZero('by removeFolderItem');
      this.refreshAfterAnimationEnd(deleteItem, openFolderData);
      log.showInfo(`removeFolderItem remove from db, bundleName: ${deleteItem.bundleName}`);
      RdbStoreManager.getInstance().deleteInfoByBundle(deleteItem.bundleName, deleteItem.typeId, deleteItem.appIndex,
        undefined, deleteItem.shortcutId);
      if (deleteItem.shortcutId) {
        log.showInfo(`removeShortcutItem ${JSON.stringify(deleteItem)}`);
        ShortcutViewModel.getInstance().deleteShortcutFromBMS({ bundleName: deleteItem.bundleName,
          appIndex: deleteItem.appIndex,
          id: deleteItem.shortcutId });
      }
      //未安装应用移除时，需要同步删除桌面占位快捷方式
      if (deleteItem.typeId === CommonConstants.TYPE_APP) {
        AppModel.getInstance().appItemRemove(deleteItem.bundleName, deleteItem.appIndex);
      }
    })
  }

  private removeFolderItemAndDissolveFolder(deleteItem: GridLayoutItemInfo): void {
    AppStorage.setOrCreate('unInstallItemInfo', deleteItem);
    // 补位动效阶段更新缓存并拉起解散动效
    let openFolderData: GridLayoutItemInfo = FolderData.getInstance().getOpenedFolder();
    BigFolderViewModel.getInstance().waitFolderMoveAniamtion(() => {
      // 深拷贝openFolderData用于updateFolderLayoutAfterLeave使用
      const originOpenFolderDataForLayoutUpdate = new GridLayoutItemInfo();
      ObjectCopyUtil.deepClone(openFolderData, originOpenFolderDataForLayoutUpdate);
      let folderAppList: GridLayoutItemInfo[] = BigFolderViewModel.getInstance().getAppListInFolder(openFolderData);
      BigFolderViewModel.getInstance().updateFolderLayoutAfterLeave([deleteItem], originOpenFolderDataForLayoutUpdate);
      BigFolderViewModel.getInstance()
        .removeFolderAfterUninstallIfNeeded(openFolderData, folderAppList, deleteItem.keyName ?? '');
      OpenFolderDragHandler.getInstance().resetTranslateZero('by removeFolderItemAndDissolveFolder');
    })
    // 解散动效完成以后刷新布局
    folderAnimateCallBack.waitFolderDissolveAnimation(() => {
      this.refreshAfterAnimationEnd(deleteItem, openFolderData);
    })
  }

  private refreshAfterAnimationEnd(deleteItem: GridLayoutItemInfo, openFolderData: GridLayoutItemInfo) {
    if (deleteItem.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      // 后续需要简化removeShortCut流程,去除传递的openFolderData
      BigFolderViewModel.getInstance().removeShortCut(openFolderData, deleteItem);
    } else if (deleteItem.appStatus !== AppStatus.INSTALLED) {
      this.deleteNotInstallItem(deleteItem);
    }
    AppStorage.setOrCreate('unInstallItemInfo', new GridLayoutItemInfo());
  }

  private deleteNotInstallItem(deleteItem: GridLayoutItemInfo): void {
    let isHarmony: boolean = deleteItem.appStatus !== AppStatus.WAIT_FOR_HARMONY;
    let appIndex: number = deleteItem.appIndex ?? 0;
    let bundleName: string = deleteItem.bundleName;
    // 未鸿蒙化应用需要传映射表的包名
    if (!isHarmony) {
      bundleName = CommonUtils.jsonStrToMap(deleteItem.intent).get('requestBundleName') as string ?? bundleName;
    }
  }
}

export let openFolderUninstallManager: OpenFolderUninstallManager =
  SingletonHelper.getInstance(OpenFolderUninstallManager, TAG);