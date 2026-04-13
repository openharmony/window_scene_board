/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { AbstractGridLayoutCorrector } from './AbstractGridLayoutCorrector';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { CommonConstants } from '../../constants/CommonConstants';
import {
  AppItemInfo,
  AppModel,
  DesktopUtils,
  launcherAbilityManager,
  RdbStoreManager,
  ShortcutInfo,
  ShortcutViewModel,
} from '../../TsIndex';

const TAG = 'ShortcutChangeCorrector';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const CONTACT_BUNDLE_NAME = 'com.ohos.contacts';

export class ShortcutChangeCorrector extends AbstractGridLayoutCorrector {
  handleData(girdLayoutInfo: GridLayoutItemInfo[], isOuter?: boolean): void {
    girdLayoutInfo.forEach(item => {
      // 正常文件夹
      if (this.isNormalFolder(item)) {
        item.layoutInfo?.forEach(folderPage => folderPage.forEach(itemInPage => {
          this.updateShortcut(itemInPage);
        }));
        return;
      }
      // 定制文件夹
      if (item.typeId === CommonConstants.TYPE_FOLDER) {
        return;
      }
      // 图标
      this.updateShortcut(item);
    });
  }

  /**
   * 与包管理快捷方式对比，更新快捷图标信息
   *
   * @param itemInfo 当前布局信息
   * @param updateItemInfo 需要更新的布局数组
   */
  private updateShortcut(itemInfo: GridLayoutItemInfo): void {
    if (!itemInfo || itemInfo.typeId !== CommonConstants.TYPE_SHORTCUT_ICON) {
      return;
    }
    log.showInfo(`updateShortcut itemInfo bundleName:${itemInfo.bundleName},shortcutId:${itemInfo.shortcutId},appLabelId:${itemInfo.appLabelId},appIconId:${itemInfo.appIconId},typeId:${itemInfo.typeId},keyName:${itemInfo.keyName}`);
    let shortcutInfoList: ShortcutInfo[] | undefined = AppModel.getInstance().getAllShortcutInfo(itemInfo.bundleName);
    if (!shortcutInfoList) {
      shortcutInfoList = launcherAbilityManager.getShortcutInfoByBundleNameSync(itemInfo.bundleName);
      AppModel.getInstance().setShortcutInfo(itemInfo.bundleName, shortcutInfoList);
    }

    let shortcut: ShortcutInfo | undefined = shortcutInfoList.find(shortcut => shortcut.id === itemInfo.shortcutId);
    if (shortcut) {
      this.updateShortcutInfoFromBMS(itemInfo, shortcut);
      // 更新本地数据库
      RdbStoreManager.getInstance().updateShortcutItemInfo(itemInfo);
      // 更新BMS数据库
      ShortcutViewModel.getInstance().updateShortcutToBMS(shortcut);
    }
    // 纠正异常联系人快捷方式数据
    if (itemInfo.bundleName === CONTACT_BUNDLE_NAME && CheckEmptyUtils.isEmpty(itemInfo.shortcutId)) {
      log.warn(`updateShortcut itemInfo:${DesktopUtils.desktopItemsToString(itemInfo)}`);
      let contactShortcut: ShortcutInfo | undefined =
        shortcutInfoList.find(shortcut => shortcut.bundleName === CONTACT_BUNDLE_NAME);
      if (contactShortcut && shortcut) {
        this.updateShortcutInfoFromBMS(itemInfo, contactShortcut);
        // 更新本地数据库
        RdbStoreManager.getInstance().updateContactShortcutItemInfo(itemInfo);
        // 更新BMS数据库
        ShortcutViewModel.getInstance().updateShortcutToBMS(shortcut);
        log.warn(`updateShortcut contactShortcut bundleName:${contactShortcut.bundleName},shortcutId:${contactShortcut.id},appLabelId:${contactShortcut.id},appIconId:${contactShortcut.iconId},keyName:${itemInfo.keyName}`);
      }
    }
  }

  private updateShortcutInfoFromBMS(itemInfo: GridLayoutItemInfo, shortcut: ShortcutInfo): void {
    itemInfo.appIconId = shortcut.iconId ?? 0;
    itemInfo.appLabelId = shortcut.labelId;
    itemInfo.shortcutId = shortcut.id;
    itemInfo.appName = '';
    itemInfo.badgeNumber = 0;
    itemInfo.keyName = AppItemInfo.getKeyName(itemInfo);
  }

  /**
   * 是否为非定制文件夹
   *
   * @param folderItem 文件夹
   * @returns true是非定制文件夹
   */
  private isNormalFolder(folderItem: GridLayoutItemInfo): boolean {
    return folderItem.typeId === CommonConstants.TYPE_FOLDER;
  }
}