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

import { GlobalContext, ResourceManager } from '@ohos/frameworkwrapper';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import GridLayoutItemInfo from '../../../bean/GridLayoutItemInfo';
import { editModeManager, DesktopUtils } from '../../../TsIndex';
import { FolderCommonUtil } from './FolderCommonUtil';
import { FolderManager } from './model/FolderManager';
import { lockLayoutManager } from '../../../manager/LockLayoutManager';
import GridLayoutUtil from '../../../utils/GridLayoutUtil';

/**
 * 文件夹无障碍工具类
 */
export class FolderAccessibilityUtil {
  /**
   * 获取文件夹展开态图标播报文本
   *
   * @param item 文件夹展开态图标元素
   * @param isAccessibility 是否支持无障碍
   * @returns 播报文本
   */
  public static getOpenFolderItemAccessibilityText(item: GridLayoutItemInfo, isAccessibilityMode: boolean): string {
    if (isAccessibilityMode && GridLayoutUtil.isAddIcon(item)) {
      return '';
    }
    // 锁定布局时，图标无可用操作，仅播报图标名称
    return DesktopUtils.getAccessibilityDescription(isAccessibilityMode,
      editModeManager.isInEditMode() && lockLayoutManager.isLockLayout(), item);
  }

  /**
   * 获取小文件夹的播报文本
   *
   * @param folderId 文件夹id
   * @param isAccessibility 是否支持无障碍
   * @param badgeNum 角标数量
   * @returns 小文件夹播报文本
   */
  public static getFolderReaderText(folderId: string, isSmall: boolean, badgeNum: number): string {
    let desktopContext: ServiceExtensionContext = GlobalContext.getContext();
    let folderItem: GridLayoutItemInfo = FolderManager.getInstance().getFolder(folderId).getGridInfo();
    const realFolderNameReaderText: string = FolderCommonUtil.getRealFolderName(folderItem.folderName || '');
    const folderTypeReaderText: string = isSmall ? ResourceManager.getInstance().getStringByName('small_folder') :
      ResourceManager.getInstance().getStringByName('big_folder');
    const folderAppsReaderText: string = FolderAccessibilityUtil.getFolderAppsReaderText(desktopContext, folderItem);
    const folderNotificationReaderText: string = isSmall ?
      FolderAccessibilityUtil.getSmallFolderNotificationsReaderText(desktopContext, badgeNum) : '';
    return `${realFolderNameReaderText}, ${folderTypeReaderText}, ${folderAppsReaderText}, ${folderNotificationReaderText}`;
  }

  private static getFolderAppsReaderText(desktopContext: ServiceExtensionContext,
    folderItem: GridLayoutItemInfo): string {
    let appCount: number = folderItem.layoutInfo?.reduce(
      (acc: number, arr: GridLayoutItemInfo[]) => acc + arr.length, 0) || 0;
    return desktopContext?.resourceManager
      .getPluralStringValueSync($r('app.plural.number_of_apps').id, appCount) || '';
  }

  private static getSmallFolderNotificationsReaderText(desktopContext: ServiceExtensionContext,
    badgeNum: number): string {
    if (!editModeManager.getEditModeState().isInEditMode()) {
      if (badgeNum > 0) {
        return desktopContext?.resourceManager
          .getPluralStringValueSync($r('app.plural.number_of_notifications').id, badgeNum) || '';
      }
    }
    return '';
  }

  /**
   * 获取文件夹描述
   *
   * @returns 文件夹描述
   */
  public static getFolderDescription(): string {
    return ResourceManager.getInstance().getStringByName('tap_with_menu_reader_text');
  }
}