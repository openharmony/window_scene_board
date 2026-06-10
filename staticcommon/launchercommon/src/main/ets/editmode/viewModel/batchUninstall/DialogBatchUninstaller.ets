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
import { GlobalContext, IconResourceManager } from '@ohos/frameworkwrapper';
import { ResidentLayoutCacheMgr } from '../../../dock/cache/ResidentLayoutCacheMgr';
import {
  AppStatus,
  CommonConstants,
  GridLayoutItemInfo,
  LaunchLayoutCacheManager,
  ShortcutViewModel,
  DockItemInfo,
  GridLayoutUtil,
  AppModel
} from '../../../TsIndex';
import { UninstallDialogUtil } from '../../../utils/UninstallDialogUtil';
import { AbstractBatchUninstaller } from './AbstractBatchUninstaller';
import { batchUninstallChain, ForwardType } from './BatchUninstallChain';
import { AppItemInfo } from '../../../bean/AppItemInfo';

const TAG = 'DialogBatchUninstaller';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class IconImage {
  // 图标
  public icon: string | PixelMap | undefined;
  // 图标背板
  public iconBG: string | PixelMap | undefined;
}

export class RemoveDialogConfig {
  public icons: IconImage[] = [];
  public title?: Resource | string;
  public content?: Resource | string;
  public cancelBtn?: Resource;
  public jumpBtn?: Resource;
  public confirmBtn?: Resource;
  public appIndex?: number;
}

export class BatchItemInfo {
  public removableAppCount: number = 0;
  public uninstallableAppCount: number = 0;
  public twinsAppCount: number = 0;
  public cardShortcutCount: number = 0;
  public normalDownloadingAppCount: number = 0;
  public cloningUpgradingAppCount: number = 0;
  public anyMainHaveTwins: boolean = false;
}

export class DialogBatchUninstaller extends AbstractBatchUninstaller {
  doHandleData(batchItem: GridLayoutItemInfo[], args?: ForwardType): void {
    log.showInfo(`batchUninstall>>> doHandleData>>> args:${args}`);
    switch (args) {
      case ForwardType.DRAG_START:
        log.showInfo(`ForwardType.DRAG_START`);
        break;
      case ForwardType.DRAG_DROP:
        // 组装提示框内容, 拉起对话框
        batchUninstallChain.dialogConfig = this.buildDialog(batchItem);
        break;
      case ForwardType.DRAG_END:
        log.showInfo(`ForwardType.DRAG_END`);
        this.endChain(args);
        break;
      default:
        this.runNext(args);
    }
  }

  private buildDialog(batchItem: GridLayoutItemInfo[]): RemoveDialogConfig {
    let info = this.analysis(batchItem);
    let dialog = new RemoveDialogConfig();
    // 卸载弹框上展示的首个应用是否为分身应用
    dialog.appIndex = this.getNthUninstallable(batchItem, 1).appIndex;
    this.setNthIcon(dialog, batchItem, 1);
    dialog.cancelBtn = $r('app.string.cancel');
    if (info.uninstallableAppCount == 1) { // 单个
      let firstUninstallable: GridLayoutItemInfo = this.getNthUninstallable(batchItem, 1);
      let appName: string = this.getAppName(firstUninstallable);
      if (UninstallDialogUtil.checkIsNeedTipsApp(firstUninstallable.bundleName)) {
        this.setTipsDialog(dialog, firstUninstallable);
      } else if (info.twinsAppCount == info.uninstallableAppCount) { // 单个分身应用
        dialog.title = $r('app.string.delete_title', appName);
        dialog.content = $r('app.string.delete_content');
        dialog.confirmBtn = $r('app.string.delete');
      } else if (info.cloningUpgradingAppCount == info.uninstallableAppCount) { // 单个克隆升级中应用
        dialog.title = $r('app.string.remove_title', appName);
        dialog.content = $r('app.string.remove_n_content');
        dialog.confirmBtn = $r('app.string.remove_button');
      } else if (info.anyMainHaveTwins) { // 带分身
        dialog.title = $r('app.string.uninstall_title', appName);
        dialog.content = $r('app.string.uninstall_n_twin_content');
        dialog.confirmBtn = $r('app.string.uninstall');
      } else { // 单个普通应用
        dialog.title = $r('app.string.uninstall_title', appName);
        dialog.content = $r('app.string.uninstall_content');
        dialog.confirmBtn = $r('app.string.uninstall');
      }
    } else { // 多个
      this.setNthIcon(dialog, batchItem, 2);
      if (info.twinsAppCount == info.uninstallableAppCount) { // 全是分身应用
        dialog.title =
          GlobalContext.getContext()?.resourceManager?.getPluralStringValueSync($r('app.plural.delete_n_title').id,
            info.uninstallableAppCount);
        dialog.content = $r('app.string.delete_content');
        dialog.confirmBtn = $r('app.string.delete');
      } else if (info.cloningUpgradingAppCount == info.uninstallableAppCount) { // 全是克隆升级中应用
        dialog.title =
          GlobalContext.getContext()?.resourceManager?.getPluralStringValueSync($r('app.plural.remove_n_title').id,
            info.uninstallableAppCount);
        dialog.content = $r('app.string.remove_n_content');
        dialog.confirmBtn = $r('app.string.remove_button');
      } else if (info.anyMainHaveTwins) { // 存在主应用带分身
        dialog.title =
          GlobalContext.getContext()?.resourceManager?.getPluralStringValueSync($r('app.plural.uninstall_n_title').id,
            info.uninstallableAppCount);
        dialog.content = $r('app.string.uninstall_n_twin_content');
        dialog.confirmBtn = $r('app.string.uninstall');
      } else {
        dialog.title =
          GlobalContext.getContext()?.resourceManager?.getPluralStringValueSync($r('app.plural.uninstall_n_title').id,
            info.uninstallableAppCount);
        dialog.content = $r('app.string.uninstall_content');
        dialog.confirmBtn = $r('app.string.uninstall');
      }
    }
    return dialog;
  }

  private getAppName(item: GridLayoutItemInfo): string {
    let appName = AppModel.getInstance().getAppInfoByBundleName(item.bundleName)?.appName;
    if (!appName) {
      return item.appName ?? '';
    }
    let appIndex: number = item.appIndex ?? 0;
    return `${appName}${appIndex > 0 ? appIndex : ''}`;
  }

  private analysis(batchItem: GridLayoutItemInfo[]): BatchItemInfo {
    let info = new BatchItemInfo();
    info.uninstallableAppCount = batchItem.length;
    let appListMap: Map<string, GridLayoutItemInfo[]> = this.getAppListMap();
    batchItem.forEach((item) => {
      // 不可卸载
      if (!this.isUninstallable(item)) {
        info.uninstallableAppCount--;
        return;
      }

      // 卡片/快捷方式
      let isCard = item.typeId === CommonConstants.TYPE_CARD;
      let isShortcut = item.typeId === CommonConstants.TYPE_SHORTCUT_ICON;
      if (isCard || isShortcut) {
        info.cardShortcutCount++;
        return;
      }

      // 判断主应用是否有分身
      if (item.appIndex === 0) {
        let appList: GridLayoutItemInfo[] = appListMap.get(item.bundleName) ?? [];
        for (let app of appList) {
          if (app.appIndex && app.appIndex > 0) {
            info.anyMainHaveTwins = true;
            break;
          }
        }
      }

      // 克隆/升级/下载中
      let isDownloading = item.appStatus !== AppStatus.INSTALLED;
      let isClone = item.callerName === CommonConstants.SOURCE_CLONE;
      let isUpgrading = item.callerName === CommonConstants.SOURCE_UPGRADE;
      if (isDownloading) {
        if (isClone || isUpgrading) {
          // 克隆/升级中
          batchUninstallChain.canAllDirectlyRemove = false;
          info.cloningUpgradingAppCount++;
        } else {
          // 普通下载中
          info.normalDownloadingAppCount++;
        }
      }

      // 判断是否分身应用
      if (item.appIndex && item.appIndex > 0) {
        info.twinsAppCount++;
      }
    });
    return info;
  }

  private getAppListMap(): Map<string, GridLayoutItemInfo[]> {
    let appListMap: Map<string, GridLayoutItemInfo[]> = new Map();
    const desktopItemList: GridLayoutItemInfo[] = LaunchLayoutCacheManager.getInstance().getGridLayoutItemList();
    const residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    let dockItemList: GridLayoutItemInfo[] = [];
    residentList.forEach(item => dockItemList.push(GridLayoutUtil.dockItemToGridLayout(item)));
    this.updateAppListMap(desktopItemList, appListMap);
    this.updateAppListMap(dockItemList, appListMap);
    return appListMap;
  }

  private updateAppListMap(itemList: GridLayoutItemInfo[], appListMap: Map<string, GridLayoutItemInfo[]>): void {
    itemList.forEach((item: GridLayoutItemInfo) => {
      const itemKey: string = item.bundleName;
      if (item.typeId === CommonConstants.TYPE_APP) {
        if (!appListMap.has(itemKey)) {
          appListMap.set(itemKey, []);
        }
        appListMap.get(itemKey)?.push(item);
      } else if (item.typeId === CommonConstants.TYPE_FOLDER) {
        this.updateAppListMap(item.layoutInfo?.flat() ?? [], appListMap);
      }
    });
  }

  /**
   * 获取第 n 个可卸载的项目
   * @param batchItem 待卸载列表
   * @param nth 第n个
   * @returns 第 n 个可卸载的项目
   */
  private getNthUninstallable(batchItem: GridLayoutItemInfo[], nth: number): GridLayoutItemInfo {
    for (let item of batchItem) {
      if (this.isUninstallable(item)) {
        nth--;
        if (nth === 0) {
          return item;
        }
      }
    }
    return batchItem[0];
  }

  private async setTipsDialog(dialog: RemoveDialogConfig, item: GridLayoutItemInfo): Promise<void> {
    let uninstallDialogTips = await UninstallDialogUtil.getResUninstallAppInfo(item.bundleName);
    dialog.title = uninstallDialogTips.title;
    dialog.content = uninstallDialogTips.content;
    dialog.confirmBtn = $r('app.string.uninstall');
    if (CheckEmptyUtils.isEmpty(dialog.title)) {
      dialog.title = $r('app.string.uninstall_title', item.appName);
    }
    if (CheckEmptyUtils.isEmpty(dialog.content)) {
      dialog.content = $r('app.string.uninstall_content');
    }
  }

  /**
   * 对话框图片赋值
   *
   * @param dialog 对话框属性
   * @param batchItem 当前所选应用
   * @param n 第n张图片
   */
  private setNthIcon(dialog: RemoveDialogConfig, batchItem: GridLayoutItemInfo[], n: number) {
    // 补填空位
    while (dialog.icons.length < n) {
      dialog.icons.push(new IconImage());
    }
    let iconImage: IconImage = dialog.icons[n - 1];
    let nth: GridLayoutItemInfo = this.getNthUninstallable(batchItem, n);
    if (nth.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      // 背景图赋值
      iconImage.iconBG = ShortcutViewModel.getInstance().getShortcutBackgroundImage(nth);
      // 快捷方式取图
      iconImage.icon = ShortcutViewModel.getInstance().getShortcutImageSync(nth as AppItemInfo);
    } else if (nth.typeId === CommonConstants.TYPE_APP && nth.appStatus === AppStatus.INSTALLED) {
      // 已安装应用图标
      const bundleName: string = nth.bundleName;
      const moduleName: string | undefined = nth.moduleName;
      const abilityName: string = nth.abilityName;
      iconImage.icon = IconResourceManager.getInstance()
        .getCachedCombIconSync(bundleName, moduleName, abilityName, undefined, 'CombIcon_UninstallAppComponent');
    } else {
      // 其他图标赋值
      iconImage.icon = nth.iconResource;
    }
  }
}