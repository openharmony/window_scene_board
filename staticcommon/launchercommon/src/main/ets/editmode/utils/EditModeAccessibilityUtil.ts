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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { AccessibilityManager, GlobalContext } from '@ohos/frameworkwrapper';
import { SwiperLoadData } from '@ohos/swiperdata';
import type ctx from '@ohos.app.ability.common';
import {
  DesktopUtils,
  editModeManager,
  LaunchLayoutCacheManager,
  lockLayoutManager,
  PageInfoManager
} from '../../TsIndex';
import { desktopUtil } from '@ohos/componenthelper';
import { launcherStatusUtil } from '@ohos/windowscene';
import { BusinessType } from '../../constants/CommonConstants';
import { AppListInfo } from '../../folder/FolderModel';

const TAG: string = 'EditModeAccessibilityUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 编辑模式无障碍适配功能类
 */
export class EditModeAccessibilityUtil {

  /**
   * 获取编辑模式当前屏屏幕朗读播报字串
   * @param index： 页面index
   *
   * @returns 播报字串
   */
  public static getAccessibilityText(index: number): string {
    let appListInfo: AppListInfo | undefined = AppStorage.get('appListInfo');
    const pages = appListInfo?.appGridInfo;
    const displayCnt:number = PageInfoManager.getInstance().getDisplayCount();
    const totalPages = Math.ceil(pages?.length ?? 0 / displayCnt);
    const currentPage = Math.floor(index / displayCnt) + 1;
    let currentPageText: string = '';
    const accessibilityManager = AccessibilityManager.getInstance();
    const isAccessibilityMode: boolean = accessibilityManager.getIsAccessibilityMode();
    if (isAccessibilityMode) {
      if (GlobalContext.getInstance().hasObject('desktopContext')) {
        const serviceExtensionContext =
          GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext;
        currentPageText = serviceExtensionContext
          .resourceManager
          .getStringSync($r('app.string.desktop_current_page').id, String(currentPage), String(totalPages));
      }
    }
    log.showInfo(`textAnnouncedForCurrentPage ${currentPageText}`);
    return currentPageText;
  }

  /**
   * 获取编辑模式背景板聚焦屏幕朗读播报字串
   *
   * @returns 播报字串
   */
  public static getBackPlaneAccessibilityText(index: number): string {
    let appListInfo: AppListInfo | undefined = AppStorage.get('appListInfo');
    const pages = appListInfo?.appGridInfo;
    const displayCnt:number = PageInfoManager.getInstance().getDisplayCount();
    const totalPages = Math.ceil(pages?.length ?? 0 / displayCnt);
    const currentPage = Math.floor(index / displayCnt) + 1;
    let exitEditModeText: string = '';
    if (GlobalContext.getInstance().hasObject('desktopContext') && editModeManager.isInEditMode()) {
      const serviceExtensionContext =
        GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext;
      exitEditModeText = serviceExtensionContext
        .resourceManager
        .getStringSync($r('app.string.desktop_current_page').id, String(currentPage), String(totalPages));
      if (!lockLayoutManager.isLockLayout()) {
        exitEditModeText += '，' + serviceExtensionContext
          .resourceManager.getStringSync($r('app.string.talkback_double_click_press_drag').id);
      }
    }
    log.showInfo(`getBackPlaneAccessibilityText ${exitEditModeText}`);
    return exitEditModeText;
  }

  /**
   * 获取编辑模式加号页添加按钮聚焦屏幕朗读播报字串
   *
   * @returns 播报字串
   */
  public static getAddButtonAccessibilityText(): string {
    let addButtonText: string = '';
    if (GlobalContext.getInstance().hasObject('desktopContext')) {
      const serviceExtensionContext =
        GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext;
      addButtonText =
        serviceExtensionContext
        .resourceManager
        .getStringSync($r('app.string.talkback_add_screen').id) + '，' +
        serviceExtensionContext
        .resourceManager
        .getStringSync($r('app.string.double_tap_to_execute').id);
    }
    log.showInfo(`textAnnouncedForAddButton ${addButtonText}`);
    return addButtonText;
  }

  /**
   * 获取编辑模式空白页删除按钮聚焦屏幕朗读播报字串
   *
   * @returns 播报字串
   */
  public static getDeleteButtonAccessibilityText(): string {
    let deleteButtonText: string = '';
    if (GlobalContext.getInstance().hasObject('desktopContext')) {
      const serviceExtensionContext =
        GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext;
      deleteButtonText =
        serviceExtensionContext
          .resourceManager
          .getStringSync($r('app.string.talkback_delete_screen').id) + '，' +
        serviceExtensionContext
          .resourceManager
          .getStringSync($r('app.string.double_tap_to_execute').id);
    }
    log.showInfo(`textAnnouncedForDeleteButton ${deleteButtonText}`);
    return deleteButtonText;
  }

  /**
   * 获取编辑模式加号页聚焦屏幕朗读播报字串
   *
   * @returns 播报字串
   */
  public static getAddPageAccessibilityText(): string {
    let addPageText: string = '';
    if (GlobalContext.getInstance().hasObject('desktopContext')) {
      const serviceExtensionContext =
        GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext;
      addPageText = serviceExtensionContext
        .resourceManager
        .getStringSync($r('app.string.talkback_add_screen_page').id);
    }
    log.showInfo(`textAnnouncedForAddPageText ${addPageText}`);
    return addPageText;
  }

  /**
   * 在无障碍模式主动播报添加页面成功
   */
  public static async textAnnouncedForAddPageSuccess(current: number, total: number): Promise<void> {
    log.showInfo(`textAnnouncedForAddPageSuccess current:${current}, total:${total}}`);
    const accessibilityManager = AccessibilityManager.getInstance();
    const isAccessibilityMode: boolean = accessibilityManager.getIsAccessibilityMode();
    if (isAccessibilityMode) {
      try {
        let addPageText: string = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext)
          .resourceManager.getStringSync($r('app.string.talkback_add_screen_success').id);
        log.showInfo(`textAnnouncedForCurrentPage ${addPageText}`);
        accessibilityManager.sendTextAnnouncedForAccessibility(addPageText, 'textAnnouncedForAddPageSuccess');
      } catch (err) {
        if (err) {
          log.showError(`textAnnouncedForAddPageSuccess failed, Code is ${err.code}, message is ${err.message}`);
        }
      }
    }
  }

  /**
   * 在无障碍模式主动播报删除页面成功
   */
  public static async textAnnouncedForDeletePageSuccess(current: number, total: number): Promise<void> {
    log.showInfo(`textAnnouncedForDeletePageSuccess current:${current}, total:${total}}`);
    const accessibilityManager = AccessibilityManager.getInstance();
    const isAccessibilityMode: boolean = accessibilityManager.getIsAccessibilityMode();
    if (isAccessibilityMode) {
      try {
        let deletePageText: string = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext)
          .resourceManager.getStringSync($r('app.string.talkback_delete_screen_success').id);
        log.showInfo(`textAnnouncedForCurrentPage ${deletePageText}`);
        accessibilityManager.sendTextAnnouncedForAccessibility(deletePageText, 'textAnnouncedForDeletePageSuccess');
      } catch (err) {
        if (err) {
          log.showError(`textAnnouncedForDeletePageSuccess failed, Code is ${err.code}, message is ${err.message}`);
        }
      }
    }
  }

  /**
   * 在无障碍模式主动播报页面拖起
   */
  public static async textAnnouncedForDragPage(): Promise<void> {
    log.showInfo(`textAnnouncedForDragPage`);
    const accessibilityManager = AccessibilityManager.getInstance();
    const isAccessibilityMode: boolean = accessibilityManager.getIsAccessibilityMode();
    if (isAccessibilityMode) {
      try {
        let dragPageText: string = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext)
          .resourceManager.getStringSync($r('app.string.cc_accessibility_str_edit_move_start').id);
        log.showInfo(`textAnnouncedForDragPage ${dragPageText}`);
        accessibilityManager.sendTextAnnouncedForAccessibility(dragPageText, 'textAnnouncedForDragPage');
      } catch (err) {
        if (err) {
          log.showError(`textAnnouncedForDragPage failed, Code is ${err.code}, message is ${err.message}`);
        }
      }
    }
  }

  /**
   * 在无障碍模式主动播报页面拖拽挤位
   */
  public static async textAnnouncedForDragSqueezePageToSwipe(oldPageIndex: number, currentPageIndex: number): Promise<void> {
    log.showInfo(`textAnnouncedForDragSqueezePageToSwipe`);
    const accessibilityManager = AccessibilityManager.getInstance();
    const isAccessibilityMode: boolean = accessibilityManager.getIsAccessibilityMode();
    if (isAccessibilityMode) {
      try {
        const displayCnt:number = PageInfoManager.getInstance().getDisplayCount();
        const realOldPageIndex: number = Math.floor(oldPageIndex / displayCnt);
        const realCurrentPageIndex: number = Math.floor(currentPageIndex / displayCnt);
        log.showInfo(`textAnnouncedForDragSqueezePageToSwipe realOldPageIndex: ${realOldPageIndex}, realCurrentPageIndex: ${realCurrentPageIndex}`);
        const squeezedPages = realCurrentPageIndex - realOldPageIndex;
        const dragPageToIndexText: string = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext)
          .resourceManager.getPluralStringValueSync($r('app.plural.talkback_drag_page_to_n').id, realCurrentPageIndex + 1);
        let pastSqueezedPages: string = '';
        if (squeezedPages > 0) {
          pastSqueezedPages = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext)
            .resourceManager.getPluralStringValueSync($r('app.plural.talkback_n_page_move_forward').id, squeezedPages);
        } else {
          pastSqueezedPages = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext)
            .resourceManager.getPluralStringValueSync($r('app.plural.talkback_n_page_move_back').id, Math.abs(squeezedPages));
        }
        log.showInfo(`textAnnouncedForDragSqueezePageToSwipe ${dragPageToIndexText + '，' + pastSqueezedPages}`);
        accessibilityManager.sendTextAnnouncedForAccessibility(dragPageToIndexText + '，' + pastSqueezedPages, 'textAnnouncedForDragSqueezePageToSwipe');
      } catch (err) {
        if (err) {
          log.showError(`textAnnouncedForDragSqueezePageToSwipe failed, Code is ${err.code}, message is ${err.message}`);
        }
      }
    }
  }

  /**
   * 在无障碍模式获取本页首个图标Id用于走焦
   */
  public static getCurrentPageFirstIconId(): string {
    const isOuter = launcherStatusUtil.getShowOutLauncherStatus();
    const currentPageIndex = AppStorage.get<number>(desktopUtil.getPageIndex());
    const appListInfo = LaunchLayoutCacheManager.getInstance()
      .getAllGridLayoutItemList(BusinessType.BUSINESS_BASIC_DESKTOP, isOuter);
    const currentShowedAppListInfo = appListInfo.filter(appItemInfo => appItemInfo.page === currentPageIndex);
    if (CheckEmptyUtils.isEmptyArr(currentShowedAppListInfo)) {
      return '';
    }
    const firstIcon = currentShowedAppListInfo.sort((a, b) => {
      if (a.row !== b.row) {
        return (a.row ?? 0) < (b.row ?? 0) ? -1 : 1;
      }
      return (a.column ?? 0) - (b.column ?? 0);
    })[0];
    return DesktopUtils.getGridItemId(currentPageIndex ?? -1, firstIcon, isOuter);
  }

  /**
   * 编号编辑模式下按钮，用于无障碍走焦
   */
  public static getEditModeDockIconId(index: number): string {
    return `editModeDockButton${index}`;
  }

  /**
   * 编号编辑模式下页面背景板，用于无障碍走焦
   */
  public static getEditModeBackPlaneId(key: number): string {
    return `single_page_background_${key}`;
  }
}