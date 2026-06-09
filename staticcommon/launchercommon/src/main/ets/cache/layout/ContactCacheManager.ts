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
import { DeviceHelper, IconResourceManager, ResourceManager } from '@ohos/frameworkwrapper';
import { AppItemInfo } from '../../bean/AppItemInfo';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { CommonConstants} from '../../constants/CommonConstants';
import { RdbStoreManager } from '../../db/RdbStoreManager';
import {
  AppModel,
  DockItemInfo,
  FolderModel,
  ShortcutInfo,
  ShortcutViewModel
} from '../../TsIndex';
import { LaunchLayoutCacheManager } from './LaunchLayoutCacheManager';
import { LayoutViewModel } from '../../viewmodel/LayoutViewModel';
import { ObjectCopyUtil } from '@ohos/componenthelper';

const TAG = 'ContactCacheManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const CONTACT_BUNDLE_NAME = 'com.ohos.contacts';
const CONTACT_ABILITY_NAME = 'com.ohos.contacts.MainAbility';
const CONTACT_MODULE_NAME = 'entry';
const CONTACT_SHORTCUT_ID = 'shortcut_id_01';
const DEFAULT_CONTACT_SHORTCUT_NAME = '联系人';

/**
 * 联系人图标
 */
export class ContactCacheManager {
  private static instance: ContactCacheManager;

  static getInstance(): ContactCacheManager {
    if (!ContactCacheManager.instance) {
      ContactCacheManager.instance = new ContactCacheManager();
    }
    return ContactCacheManager.instance;
  }

  /**
   * 初始化缓存时检测是否需要补充一个快捷方式图标
   *
   * @param dockItemList
   */
  public checkToAddContactShortcut(dockItemList?: DockItemInfo[]): void {
    let isSupportVoice: boolean = DeviceHelper.isSupportVoiceCapability();
    let contactShortcuts: ShortcutInfo[] | undefined = AppModel.getInstance().getShortcutInfo(CONTACT_BUNDLE_NAME);
    if (CheckEmptyUtils.isEmptyArr(contactShortcuts) || !isSupportVoice) {
      log.showInfo('the contact shortcut is not support for isSupportVoice: %{public}s', isSupportVoice);
      return;
    }
    let hasContactShortcut: boolean = false;
    let contactShortcutItem: GridLayoutItemInfo = new GridLayoutItemInfo();
    let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
    let layoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList(TAG, false);
    // 检测是否在桌面
    for (const item of layoutList) {
      if (!hasContactShortcut && (this.isContactShortcut(item) || this.isContactShortInFolder(item))) {
        contactShortcutItem = this.findContactShortcut(item);
        hasContactShortcut = true;
        break;
      }
    }
    // 检测是否在dock区
    hasContactShortcut = (hasContactShortcut || this.isContactShortcutInDock(dockItemList ?? [], contactShortcutItem));
    log.showInfo(`checkToAddContactShortcut hasContactShortcut:${hasContactShortcut}`);
    if (!hasContactShortcut) {
      layoutList.push(this.buildContactShortcut());
      layoutCacheManager.updateGridLayoutItems(layoutList, TAG, false);
    } else {
      this.correctContactShortcut(contactShortcutItem);
    }
  }

  private findContactShortcut(layoutItem: GridLayoutItemInfo | DockItemInfo): GridLayoutItemInfo {
    let shortcutItem: GridLayoutItemInfo = new GridLayoutItemInfo();
    if (layoutItem.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      log.showInfo('findContactShortcut not in desktop');
      shortcutItem = ObjectCopyUtil.simpleClone(layoutItem as GridLayoutItemInfo);
      return shortcutItem;
    }
    if (layoutItem.typeId === CommonConstants.TYPE_FOLDER) {
      let itemsInFolder: GridLayoutItemInfo[] | undefined = layoutItem.layoutInfo?.flat();
      if (!itemsInFolder) {
        shortcutItem = ObjectCopyUtil.simpleClone(layoutItem as GridLayoutItemInfo);
        return shortcutItem;
      }
      for (const item of itemsInFolder) {
        if (this.isContactShortcut(item)) {
          log.showInfo('findContactShortcut in folder');
          shortcutItem = ObjectCopyUtil.simpleClone(item);
          return shortcutItem;
        }
      }
    }
    shortcutItem = ObjectCopyUtil.simpleClone(layoutItem as GridLayoutItemInfo);
    return shortcutItem;
  }

  private isContactShortcutInDock(dockItemList: DockItemInfo[], contactShortcutItem: GridLayoutItemInfo): boolean {
    if (CheckEmptyUtils.isEmptyArr(dockItemList)) {
      return false;
    }
    for (const dockItem of dockItemList) {
      if (this.isContactShortcut(dockItem) || this.isContactShortInFolder(dockItem)) {
        contactShortcutItem = this.findContactShortcut(dockItem);
        return true;
      }
    }
    return false;
  }

  private async correctContactShortcut(contactShortcutItem: GridLayoutItemInfo): Promise<void> {
    // 修复数据库缺失数据
    if (CheckEmptyUtils.checkStrIsEmpty(contactShortcutItem.infoName)) {
      contactShortcutItem.infoName = DEFAULT_CONTACT_SHORTCUT_NAME;
      contactShortcutItem.intent = JSON.stringify({ sourceType: 1 });
      contactShortcutItem.bundleName = CONTACT_BUNDLE_NAME;
      contactShortcutItem.shortcutId = CONTACT_SHORTCUT_ID;
      let correctMissProperty: boolean = await RdbStoreManager.getInstance().correctShortcutItemInfo(contactShortcutItem);
      log.showInfo(`correctMissProperty whether successful: ${correctMissProperty}`);
    }
    // 如果BMS数据库中没有则重新添加至BMS数据库
    let shortcutInfoList: ShortcutInfo[] = await ShortcutViewModel.getInstance().getAllDesktopShortcutFromBMS();
    let shortcutInfo: ShortcutInfo | undefined = shortcutInfoList.find(item => item.id === CONTACT_SHORTCUT_ID &&
      item.bundleName === CONTACT_BUNDLE_NAME);
    if (!shortcutInfo) {
      let shortcuts: ShortcutInfo[] = ShortcutViewModel.getInstance().getShortcutByBundleName(contactShortcutItem.bundleName);
      if (!CheckEmptyUtils.isEmptyArr(shortcuts)) {
        let correctAddToBms: number = await ShortcutViewModel.getInstance().addShortcutToBMS(shortcuts[0]);
        log.showInfo(`correctAddToBms whether successful: ${correctAddToBms}`);
      }
    } else {
      log.showError(`correctContactShortcut getAllDesktopShortcutFromBMS exist contact`);
    }
  }

  /**
   * 是否还是联系人快捷方式
   *
   * @param item 元素
   * @returns true是联系人快捷方式
   */
  public isContactShortcut(item: GridLayoutItemInfo | DockItemInfo): boolean {
    if (CheckEmptyUtils.isEmpty(item)) {
      return false;
    }
    return item.typeId === CommonConstants.TYPE_SHORTCUT_ICON && item.bundleName === CONTACT_BUNDLE_NAME;
  }

  private isContactShortInFolder(folderItem: GridLayoutItemInfo | DockItemInfo): boolean {
    if (CheckEmptyUtils.isEmpty(folderItem) || (folderItem.typeId !== CommonConstants.TYPE_FOLDER)) {
      return false;
    }
    let itemsInFolder: GridLayoutItemInfo[] | undefined = folderItem.layoutInfo?.flat();
    if (!itemsInFolder || CheckEmptyUtils.isEmptyArr(itemsInFolder)) {
      return false;
    }
    for (const item of itemsInFolder) {
      if (this.isContactShortcut(item)) {
        return true;
      }
    }
    return false;
  }

  private buildContactShortcut(): GridLayoutItemInfo {
    let contactShortcut: GridLayoutItemInfo = new GridLayoutItemInfo();
    contactShortcut.shortcutId = CONTACT_SHORTCUT_ID;
    contactShortcut.bundleName = CONTACT_BUNDLE_NAME;
    contactShortcut.moduleName = CONTACT_MODULE_NAME;
    contactShortcut.abilityName = CONTACT_ABILITY_NAME;
    contactShortcut.intent = JSON.stringify({ sourceType: 1 });
    contactShortcut.container = CommonConstants.CONTAINER_DESKTOP;
    contactShortcut.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
    contactShortcut.area = [1, 1];
    contactShortcut.page = 1;
    contactShortcut.row = -1;
    contactShortcut.column = -1;
    let shortcuts: ShortcutInfo[] = ShortcutViewModel.getInstance().getShortcutByBundleName(contactShortcut.bundleName);
    if (!CheckEmptyUtils.isEmptyArr(shortcuts)) {
      contactShortcut.shortcutId = shortcuts[0].id;
      contactShortcut.moduleName = shortcuts[0].moduleName;
      contactShortcut.appIconId = shortcuts[0].iconId ?? 0;
      contactShortcut.appLabelId = shortcuts[0].labelId;
    }
    contactShortcut.keyName = AppItemInfo.getKeyName(contactShortcut);
    IconResourceManager.getInstance().getAppNameWithCallback(contactShortcut.appLabelId, contactShortcut.bundleName,
      contactShortcut.moduleName, DEFAULT_CONTACT_SHORTCUT_NAME, (name: string) => {
        contactShortcut.infoName = name;
        contactShortcut.appName = name;
      });
    if (!CheckEmptyUtils.isEmptyArr(shortcuts) && !CheckEmptyUtils.isEmpty(shortcuts[0])) {
      ShortcutViewModel.getInstance().addShortcutToBMS(shortcuts[0]);
    }
    log.showInfo(`buildContactShortcut contactShortcut shortcutId:${contactShortcut.shortcutId},appIconId:${contactShortcut.appIconId},appLabelId:${contactShortcut.appLabelId},keyName:${contactShortcut.keyName}`);
    return contactShortcut;
  }

  /**
   * 添加到预置文件夹中
   *
   * @param folderItem 预置的应用文件夹
   */
  public addPresetContactToFolder(folderItem: GridLayoutItemInfo): void {
    if (!folderItem.layoutInfo) {
      return;
    }
    let isSupportVoice: boolean = DeviceHelper.isSupportVoiceCapability();
    let contactShortcuts: ShortcutInfo[] | undefined = AppModel.getInstance().getShortcutInfo(CONTACT_BUNDLE_NAME);
    if (CheckEmptyUtils.isEmptyArr(contactShortcuts) || !isSupportVoice) {
      log.showInfo('the contact shortcut is not support for isSupportVoice: %{public}s', isSupportVoice);
      return;
    }
    let presetContact = this.buildContactShortcut();
    const lastPageItems: GridLayoutItemInfo[] = folderItem.layoutInfo[folderItem.layoutInfo.length - 1];
    if (!CheckEmptyUtils.isEmpty(lastPageItems[lastPageItems.length - 1]) &&
      lastPageItems[lastPageItems.length - 1].typeId === CommonConstants.TYPE_ADD) {
      lastPageItems[lastPageItems.length - 1] = presetContact;
    } else {
      const openFolderConfig = FolderModel.getInstance().getFolderOpenLayout();
      if (openFolderConfig && lastPageItems.length === openFolderConfig.column * openFolderConfig.row) {
        folderItem.layoutInfo.push([presetContact]);
      } else {
        lastPageItems.push(presetContact);
      }
      let folderLayout: GridLayoutItemInfo[] = folderItem.layoutInfo.flat();
      this.updateFolderAppLocation(folderLayout);
    }
  }

  /**
   * 更新文件夹应用位置
   *
   * @param layoutList 文件夹中应用列表
   */
  private updateFolderAppLocation(layoutList: GridLayoutItemInfo[]): void {
    let folderOpenColumn: number | undefined = FolderModel.getInstance().getFolderOpenLayout()?.column;
    let folderOpenRow: number | undefined = FolderModel.getInstance().getFolderOpenLayout()?.row;
    if (!folderOpenColumn || !folderOpenRow) {
      return;
    }
    for (let i = 0; i < layoutList.length; i++) {
      layoutList[i].column = i % folderOpenColumn;
      layoutList[i].row = Math.floor(i / folderOpenColumn % folderOpenRow);
      layoutList[i].page = Math.floor(i / (folderOpenColumn * folderOpenRow));
    }
  }
}