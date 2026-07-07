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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper, localEventManager } from '@ohos/frameworkwrapper';
import { KeyCodeConstants } from '@ohos/commonconstants';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import {
  CommonConstants,
  EventConstants,
  GridLayoutItemInfo,
  GridLayoutUtil,
  LaunchLayoutCacheManager,
  PadLaunchLayoutCacheManager,
  SettingsModel,
  PageDesktopModel
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { PageDesktopGridStyleConfig } from '@ohos/launchercommon/src/main/ets/layoutconfig/PageDesktopGridStyleConfig';
import { PageDesktopViewModel } from '../common/viewmodel/PageDesktopViewModel';
import { HashMap } from '@kit.ArkTS';

const TAG = 'FocusManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 用于桌面走焦逻辑的utils
 */
export default class FocusManager {
  private isSuperFold = false;

  private mGridConfig = SettingsModel.getInstance().getGridConfig();

  private mPageDesktopModel = PageDesktopModel.getInstance();

  private mLauncherLayoutCacheManager = DeviceHelper.isPad() ? PadLaunchLayoutCacheManager.getInstance() :
  LaunchLayoutCacheManager.getInstance();

  private static mFocusManager: FocusManager;

  private constructor() {
  }

  /**
   * 获取单例对象
   * @returns FocusManager
   */
  public static getInstance(): FocusManager {
    if (!FocusManager.mFocusManager) {
      FocusManager.mFocusManager = new FocusManager();
    }
    return FocusManager.mFocusManager;
  }

  /**
   * 根据按下方向执行对应选中态走焦
   * @param row 元素所在行
   * @param column 元素所在列
   * @param page 元素所在页
   * @param event 按键事件
   */
  public setDirectionsFocus(fromItem: GridLayoutItemInfo, event: KeyEvent): void {
    fromItem = this.mLauncherLayoutCacheManager.selectGridLayoutItemById(fromItem.infoId) ?? fromItem;
    log.showInfo(`setDirectionsFocus fromItem[${GridLayoutUtil.generateUniqueKey(fromItem)}]\
    (${fromItem.page}, ${fromItem.column}, ${fromItem.row})`);
    let directionMap: HashMap<number, () => GridLayoutItemInfo | undefined> = new HashMap();
    directionMap.set(KeyCodeConstants.KEYCODE_DPAD_UP, () => this.findUpItem(fromItem));
    directionMap.set(KeyCodeConstants.KEYCODE_DPAD_DOWN, () => this.findBottomItem(fromItem));
    directionMap.set(KeyCodeConstants.KEYCODE_DPAD_LEFT, () => this.findLeftItem(fromItem));
    directionMap.set(KeyCodeConstants.KEYCODE_DPAD_RIGHT, () => this.findRightItem(fromItem));
    const toItem: GridLayoutItemInfo | undefined = directionMap.get(event?.keyCode)?.();
    if (toItem) {
      log.showInfo(`setDirectionsFocus toItem[${GridLayoutUtil.generateUniqueKey(toItem)}]\
      (${toItem.page},${toItem.column},${toItem.row})`);
      this.onKeyDownSelectItem(toItem);
    }
  }

  public findUpItem(fromItem: GridLayoutItemInfo): GridLayoutItemInfo | undefined {
    const pageDesktopGridStyleConfig: PageDesktopGridStyleConfig =
      this.mPageDesktopModel.getPageDesktopStyleConfig();
    if (fromItem.row === undefined || fromItem.column === undefined || fromItem.area === undefined ||
      fromItem.page === undefined) {
      return undefined;
    }
    for (let i = fromItem.row - 1; i >= 0; i--) {
      for (let j = fromItem.column; j < fromItem.column + fromItem.area[0]; j++) {
        const item: GridLayoutItemInfo | undefined = this.getItemByPos(i, j, fromItem.page);
        if (!this.isInvalidItem(item, fromItem)) {
          return item;
        }
      }
    }
    //当前页顶层元素,只有在第二页并且是竖屏的时候才能继续往上走焦 page - 1
    const isPortrait: boolean = AppStorage.get<boolean>('isPortrait') as boolean;
    const needFindInOtherPage = this.isSuperFold && fromItem.page === 1 && isPortrait;
    if (!needFindInOtherPage) {
      return undefined;
    }
    for (let i = pageDesktopGridStyleConfig.mRows - 1; i >= 0; i--) {
      for (let j = fromItem.column; j < fromItem.column + fromItem.area[0]; j++) {
        const item: GridLayoutItemInfo | undefined = this.getItemByPos(i, j, fromItem.page - 1);
        if (!this.isInvalidItem(item, fromItem)) {
          return item;
        }
      }
    }
    return undefined;
  }

  public findBottomItem(fromItem: GridLayoutItemInfo): GridLayoutItemInfo | undefined {
    const pageDesktopGridStyleConfig: PageDesktopGridStyleConfig =
      PageDesktopModel.getInstance().getPageDesktopStyleConfig();
    if (fromItem.row === undefined || fromItem.column === undefined || fromItem.area === undefined ||
      fromItem.page === undefined) {
      return undefined;
    }
    for (let i = fromItem.row + 1; i < pageDesktopGridStyleConfig.mRows; i++) {
      for (let j = fromItem.column; j < fromItem.column + fromItem.area[0]; j++) {
        const item: GridLayoutItemInfo | undefined = this.getItemByPos(i, j, fromItem.page);
        if (!this.isInvalidItem(item, fromItem)) {
          return item;
        }
      }
    }
    //当前页最底层元素,只有在第一页并且是竖屏的时候才能继续向下走焦 page + 1
    const isPortrait: boolean = AppStorage.get<boolean>('isPortrait') as boolean;
    const needFindInOtherPage = this.isSuperFold && fromItem.page === 0 && isPortrait;
    if (!needFindInOtherPage) {
      return undefined;
    }
    for (let i = 0; i < pageDesktopGridStyleConfig.mRows; i++) {
      for (let j = fromItem.column; j < fromItem.column + fromItem.area[0]; j++) {
        const item: GridLayoutItemInfo | undefined = this.getItemByPos(i, j, fromItem.page + 1);
        if (!this.isInvalidItem(item, fromItem)) {
          return item;
        }
      }
    }
    return undefined;
  }

  public findLeftItem(fromItem: GridLayoutItemInfo): GridLayoutItemInfo | undefined {
    const pageDesktopGridStyleConfig: PageDesktopGridStyleConfig =
      this.mPageDesktopModel.getPageDesktopStyleConfig();
    if (fromItem.row === undefined || fromItem.column === undefined || fromItem.area === undefined ||
      fromItem.page === undefined) {
      return undefined;
    }
    for (let i = fromItem.column - 1; i >= 0; i--) {
      for (let j = fromItem.row; j < fromItem.row + fromItem.area[1]; j++) {
        const item: GridLayoutItemInfo | undefined = this.getItemByPos(j, i, fromItem.page);
        if (!this.isInvalidItem(item, fromItem)) {
          return item;
        }
      }
    }
    //当前页最左边元素,只有在第二页并且是横屏的时候才能继续向左走焦 page - 1
    const isPortrait: boolean = AppStorage.get<boolean>('isPortrait') as boolean;
    const needFindInOtherPage = this.isSuperFold && fromItem.page === 1 && !isPortrait;
    if (!needFindInOtherPage) {
      return undefined;
    }
    for (let i = pageDesktopGridStyleConfig.mColumns - 1; i >= 0; i--) {
      for (let j = fromItem.row; j < fromItem.row + fromItem.area[1]; j++) {
        const item: GridLayoutItemInfo | undefined = this.getItemByPos(j, i, fromItem.page - 1);
        if (!this.isInvalidItem(item, fromItem)) {
          return item;
        }
      }
    }
    return undefined;
  }

  public findRightItem(fromItem: GridLayoutItemInfo): GridLayoutItemInfo | undefined {
    const pageDesktopGridStyleConfig: PageDesktopGridStyleConfig =
      this.mPageDesktopModel.getPageDesktopStyleConfig();
    if (fromItem.row === undefined || fromItem.column === undefined || fromItem.area === undefined ||
      fromItem.page === undefined) {
      return undefined;
    }
    for (let i = fromItem.column + 1; i < this.mGridConfig.column; i++) {
      for (let j = fromItem.row; j < fromItem.row + fromItem.area[1]; j++) {
        const item: GridLayoutItemInfo | undefined = this.getItemByPos(j, i, fromItem.page);
        if (!this.isInvalidItem(item, fromItem)) {
          return item;
        }
      }
    }
    //当前页最右边元素,只有在第一页并且是横屏的时候才能继续向右走焦 page + 1
    const isPortrait: boolean = AppStorage.get<boolean>('isPortrait') as boolean;
    const needFindInOtherPage = this.isSuperFold && fromItem.page === 0 && !isPortrait;
    if (!needFindInOtherPage) {
      return undefined;
    }
    for (let i = 0; i < pageDesktopGridStyleConfig.mColumns; i++) {
      for (let j = fromItem.row; j < fromItem.row + fromItem.area[1]; j++) {
        const item: GridLayoutItemInfo | undefined = this.getItemByPos(j, i, fromItem.page + 1);
        if (!this.isInvalidItem(item, fromItem)) {
          return item;
        }
      }
    }
    return undefined;
  }

  private getItemByPos(row: number, column: number, page: number): GridLayoutItemInfo | undefined {
    log.showInfo(`getItemByPos row: ${row}, column: ${column}, page: ${page}`);
    const layoutInfo = this.mLauncherLayoutCacheManager.selectGridLayoutItemsByPage(page);
    const itemInfo = layoutInfo.find(item => {
      if (item.row === undefined || item.column === undefined || item.area === undefined) {
        return false;
      }
      return (column >= item.column && column < item.column + item.area[0]) &&
        (row >= item.row && row < item.row + item.area[1]) && item.page === page;
    });
    return itemInfo;
  }

  private isInvalidItem(item: GridLayoutItemInfo | undefined, fromItem: GridLayoutItemInfo): boolean {
    // 无效元素，包括以下原因：1、空元素；2、卡片；3、与走焦起始元素相同
    return !item || item.typeId === CommonConstants.TYPE_CARD ||
    GridLayoutUtil.checkGridItemEqual(item, fromItem);
  }

  private onKeyDownSelectItem(item: GridLayoutItemInfo | undefined): void {
    if (!item) {
      return;
    }
    const mPageDesktopViewModel = PageDesktopViewModel.getInstance();
    mPageDesktopViewModel.onSelectItemChange([mPageDesktopViewModel.getItemKeyByType(item)], true);
    AppStorage.setOrCreate('lastFocusItem', item);
    AppStorage.setOrCreate('shiftStartItem', item);
  }
}
