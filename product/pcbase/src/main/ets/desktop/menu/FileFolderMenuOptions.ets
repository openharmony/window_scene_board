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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { MenuInfo, StyleConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { DesktopBaseMenuOptions } from './DesktopBaseMenuOptions';
import { fileFolderManagerFactory } from '@ohos/desktopfilefolder';
import measure from '@ohos.measure';

const DIVIDER_HEIGHT = px2vp(1);
const MENU_ITEM_HEIGHT = 40;
const FILE_FOLDER_MENU_ITEM_HEIGHT = 1;
const MENU_HEIGHT_ADD = 5;
const DEFAULT_FONT_SIZE: number = 16;
const DEFAULT_MENU_ITEM_SIDE_PADDING: number = 17;

const TAG = 'FileFolderMenuOptions';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 桌面元素之文件文件夹, FileFolderComponent -> FileFolderMenu
 */
export class FileFolderMenuOptions extends DesktopBaseMenuOptions {

  getMenuWidth(menuInfoList: MenuInfo[]): number {
    let fileFolderManager = fileFolderManagerFactory.getFileFolderManager();
    let menuWidth = fileFolderManager.getRightMenuMinWidth();
    menuInfoList?.forEach((menuItem) => {
      let currItemWidth = this.getMenuItemWidth(menuItem);
      if (currItemWidth > menuWidth) {
        menuWidth = currItemWidth;
      }
    })
    log.showInfo(`getMenuWidth ${menuWidth}`);
    return menuWidth;
  }

  getMenuHeight(menuInfoList: MenuInfo[]): number {
    if (!menuInfoList || menuInfoList.length === 0) {
      return 0;
    }
    let separatorList: MenuInfo[] = [];
    let menuItemList: MenuInfo[] = [];
    let separatorHeight = 0;
    let menuItemHeight = 0;
    let sumHeight = 0;
    for (let menuInfo of menuInfoList) {
      if (menuInfo?.menuKeyString?.startsWith('-')) {
        separatorList.push(menuInfo);
      } else {
        menuItemList.push(menuInfo);
      }
    }
    if (separatorList.length > 0 ) {
      separatorHeight = (DIVIDER_HEIGHT + StyleConstants.DEFAULT_4 * 2 +
        StyleConstants.DEFAULT_3 * 2) * separatorList.length;
    }
    if (menuItemList.length > 0) {
      menuItemHeight = (MENU_ITEM_HEIGHT + FILE_FOLDER_MENU_ITEM_HEIGHT * 2) * menuItemList.length;
    }
    sumHeight = separatorHeight + menuItemHeight;
    sumHeight += MENU_HEIGHT_ADD;
    log.showInfo('getFileFolderMenuHeight length: %{public}d, [%{public}d, %{public}d, %{public}d]',
      menuInfoList.length, separatorHeight, menuItemHeight, sumHeight);
    return sumHeight;
  }

  private getMenuItemWidth(menuItem: MenuInfo): number {
    let textWidth: number = Math.ceil(px2vp(measure.measureText({
      textContent: menuItem.menuText,
      fontSize: DEFAULT_FONT_SIZE,
      fontWeight: 'medium',
    })));
    log.showInfo(`more subMenuTextWidth ${textWidth}`);
    return textWidth + DEFAULT_MENU_ITEM_SIDE_PADDING * 2 + StyleConstants.DEFAULT_33;
  }

}