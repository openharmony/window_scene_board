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
import { LogDomain, Logger, CheckEmptyUtils } from '@ohos/basicutils';
import { MenuInfo, StyleConstants, EventConstants } from '@ohos/launchercommon';
import measure from '@ohos.measure';
import { MenuConstants } from '../common/FileFolderConstants';

const TAG = 'FileFolderMenuViewModel';
const log = Logger.getLogHelper(LogDomain.HOME);

export class FileFolderMenuViewModel {
  private static instance: FileFolderMenuViewModel;
  public static getInstance(): FileFolderMenuViewModel {
    if (!FileFolderMenuViewModel.instance) {
      FileFolderMenuViewModel.instance = new FileFolderMenuViewModel();
    }
    return FileFolderMenuViewModel.instance;
  }

  /**
   * 判断是否是分隔线
   * @param item
   * @returns
   */
  public isSeparatorItem(item: MenuInfo): boolean {
    return item?.menuKeyString?.startsWith('-') ?? false;
  }

  /**
   * 获取此菜单项的宽度
   * @param menuItem
   * @returns
   */
  public getMenuWidth(menuItem: MenuInfo): number {
    let textWidth: number = Math.ceil(px2vp(measure.measureText({
      textContent: menuItem.menuText,
      fontSize: MenuConstants.DEFAULT_FONT_SIZE,
      fontWeight: FontWeight.Medium,
    })));
    log.showDebug(TAG, `getMenuWidth ${textWidth}`);
    return textWidth + MenuConstants.DEFAULT_MENU_ITEM_SIDE_PADDING * 2 + StyleConstants.DEFAULT_33;
  }

  /**
   * 获取菜单项最大宽度
   * @param menuInfos
   * @returns
   */
  public getMaxMenuWidth(menuInfos: MenuInfo[]): number {
    let maxMenuWidth = MenuConstants.MENU_ITEM_MIN_WIDTH;
    if (CheckEmptyUtils.isEmptyArr(menuInfos)) {
      log.showWarn(TAG, 'getMaxMenuWidth menuInfos is empty');
      return maxMenuWidth;
    }
    menuInfos.forEach(menuItem => {
      let currItemWidth = this.getMenuWidth(menuItem);
      maxMenuWidth = Math.max(currItemWidth, maxMenuWidth);
    });
    log.showInfo(TAG, `getMaxMenuWidth ${maxMenuWidth} ${menuInfos.length}`);
    return maxMenuWidth;
  }

  /**
   * 判断当前key是否有子菜单
   * @param menuLevelIndexConfig 菜单级别配置
   * @param currKey  当前key
   * @returns
   */
  public isHasSubMenu(menuLevelIndexConfig: Map<string, string[]>, currKey: string): boolean {
    if (CheckEmptyUtils.isEmpty(menuLevelIndexConfig)) {
      log.showWarn(TAG, 'isHashSubMenu menuLevelIndexConfig is invalid');
      return false;
    }
    if (!currKey) {
      log.showWarn(TAG, 'isHashSubMenu currKey is invalid');
      return false;
    }
    const firstMenuKeyIndexes = Array.from<string>(MenuConstants.MENU_LEVEL_INDEX_CONFIG.keys());
    let res: boolean = firstMenuKeyIndexes.includes(currKey);
    log.showInfo(TAG, `isHashSubMenu ${currKey} ${res}`);
    return res;
  }
}

