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

import { GlobalContext, HiSysEventUtil } from '@ohos/frameworkwrapper';
import { CheckEmptyUtils, LogDomain, LogHelper, } from '@ohos/basicutils';
import { RectInfo } from '@ohos/basicutils';
import { ItemUtils } from '@ohos/componenthelper';
import { CommonConstants } from '../../constants/CommonConstants';
import { MenuInfo } from '../../bean/MenuInfo';
import { AppItemInfo } from '../../bean/AppItemInfo';
import { AppBubbleEventData } from '../../bean/AppBubbleEventData';
import { AppStatus, DownloadStatusInfo } from '../../constants/CommonConstants';
import { AppGalleryDownloadManager } from '../../manager/AppGalleryDownloadManager';
import GridLayoutUtil from '../../utils/GridLayoutUtil';
import { MenuCommonUtil } from '../../utils/MenuCommonUtil';
import { AppIconMenuVm } from './AppIconMenuVm';
import { editModeManager, ScreenSplitUtil, StyleConstants, desktopItemDraggableManager, GridLayoutItemInfo } from '../../TsIndex';
import { NavBarHideAndShowManager } from '../../manager/NavBarHideAndShowManager';

const TAG = 'AppIconMenuEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.ICON, TAG);

export class AppIconMenuEvent {
  private iconMenuVm: AppIconMenuVm;
  private itemInfo: AppItemInfo = new AppItemInfo();
  private setIconVisible?: (isVisible: boolean, isLongPressShow: boolean) => void;
  private onMenuDisappear?: (isLongPressShow: boolean) => void;
  private onMenuAppear?: (isLongPressShow: boolean) => void;

  constructor(vm: AppIconMenuVm) {
    this.iconMenuVm = vm;
  }

  private getItemAppStatus(): AppStatus {
    let downloadStatusInfo: DownloadStatusInfo | undefined =
      AppGalleryDownloadManager.getInstance().getDownDownloadTaskInfo(this.itemInfo.bundleName);

    if (downloadStatusInfo && !this.itemInfo.appIndex) {
      return downloadStatusInfo.status;
    }
    return this.itemInfo.appStatus as AppStatus;
  }

  public setMenuInfo(getMenuInfo?: () => MenuInfo[], getNotInstalledMenuMap?: () => Map<AppStatus, MenuInfo[]>): void {
    if (!GridLayoutUtil.isAppInstalled(this.itemInfo)) {
      this.iconMenuVm.setMenuInfo(getNotInstalledMenuMap?.()?.get(this.getItemAppStatus()) ?? []);
    } else {
      this.iconMenuVm.setMenuInfo(getMenuInfo?.() ?? []);
    }
  }

  public init(itemInfo: AppItemInfo,
    setIconVisible?: (isVisible: boolean, isLongPressShow: boolean) => void,
    onMenuDisappear?: (isLongPressShow: boolean) => void, onMenuAppear?: (isLongPressShow: boolean) => void): void {
    this.itemInfo = itemInfo;
    this.setIconVisible = setIconVisible;
    this.onMenuDisappear = onMenuDisappear;
    this.onMenuAppear = onMenuAppear;
  }

  public destroy(): void {
    this.iconMenuVm.releaseMenuInfo();
  }

  public onAppear(isLongPressShow: boolean): void {
    log.showWarn('MenuBuilder onAppear');
    if (isLongPressShow) {
      HiSysEventUtil.reportGoIntoAppShortcutMenu(this.itemInfo.bundleName, this.itemInfo.appName, 'LAUNCHER');
    }
    NavBarHideAndShowManager.getInstance().executeCallbackByType(TAG, false);
    this.setIconVisible?.(false, isLongPressShow);
    let mAppBubbleEventData: AppBubbleEventData = {
      bundleName: this.itemInfo.bundleName,
      keyName: this.itemInfo.keyName as string,
      iconIsPickUp: true
    };
    GlobalContext.getContext()?.eventHub.emit(`appIconPickUp`, mAppBubbleEventData);

    this.onMenuAppear?.(isLongPressShow);
  }

  public onDisAppear(isLongPressShow: boolean): void {
    log.showWarn('MenuBuilder onDisAppear');
    this.iconMenuVm.isHiddenEffect = false;
    AppStorage.setOrCreate<string>('notifyEnterFormManagerAnimate', String(this.itemInfo.appIconId));
    AppStorage.setOrCreate<boolean>('contextMenuState', false);
    NavBarHideAndShowManager.getInstance().executeCallbackByType(TAG, true);
    GlobalContext.getContext()?.eventHub.emit(CommonConstants.EVENTHUB_APP_MENU_DISAPPEAR);
    this.setIconVisible?.(true, isLongPressShow);
    let mAppBubbleEventData: AppBubbleEventData = {
      bundleName: this.itemInfo.bundleName,
      keyName: this.itemInfo.keyName as string,
      iconIsPickUp: false
    };
    GlobalContext.getContext()?.eventHub.emit(`appIconPickUp`, mAppBubbleEventData);
    this.onMenuDisappear?.(isLongPressShow);
    // 菜单消失时释放menuInfo对象, 避免占据常驻内存
    this.iconMenuVm.cleanMenuInfo(true);
  }

  public setAppMenuPosition(touchX: number, iconId: string): void {
    if (CheckEmptyUtils.checkStrIsEmpty(iconId)) {
      log.showError('invalid iconId, can not set position');
      return;
    }
    let iconRect: RectInfo = ItemUtils.getRectById(iconId);
    let menuPlacement = MenuCommonUtil.getMenuPlacementByTouchX(touchX, iconRect);
    this.iconMenuVm.setMenuPlacement(menuPlacement);
    let maxMenuHeight = MenuCommonUtil.getMaxMenuHeight(menuPlacement, iconRect);
    let maxScrollMenuHeight = MenuCommonUtil.getMaxDynamicMenuHeight(maxMenuHeight,
      new Set(this.iconMenuVm.getMenuInfo().filter(item => item.menuType === CommonConstants.MENU_TYPE_FIXED)).size);
    this.iconMenuVm.setMaxScrollMenuHeight(maxScrollMenuHeight);
    log.showInfo(`menuPlacement: ${menuPlacement}, maxMenuHeight: ${maxMenuHeight}, maxScrollMenuHeight: ${maxScrollMenuHeight}`);
  }

  public setOuterAppMenuPosition(itemInfo: AppItemInfo): void {
    let hasDynamicItem: boolean = this.iconMenuVm.getMenuInfo().some(item => item.menuType !== 0)
    let menuPlacement = MenuCommonUtil.getOuterMenuPlacement(itemInfo, hasDynamicItem);
    this.iconMenuVm.setMenuPlacement(menuPlacement);
  }

  /**
   * 长按显示菜单
   */
  public onLongPressShowMenu(): void {
    if (!editModeManager.isInEditMode() && !AppStorage.get<boolean>('isDrag') && !ScreenSplitUtil.isScreenSplit(TAG) &&
      this.iconMenuVm.getMenuInfo()?.length) {
      this.iconMenuVm.setIsMenuShow(true);
    }
  }

  /**
   * 图标的菜单预览在出现时，按压蒙黑需要做渐隐动效
   */
  public previewMaskAnim(): void {
    this.iconMenuVm.previewMaskOpacity = 1;
    animateTo({
      duration: StyleConstants.APP_ICON_MASK_DISAPPEAR_DURATION,
      curve: Curve.Linear,
    }, () => {
      this.iconMenuVm.previewMaskOpacity = 0;
    });
  }
}