/**
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved. 2024-2025. All rights reserved.
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

import { SCBScreenSessionManager, SCBScreenSession } from '@ohos/windowscene';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper, localEventManager } from '@ohos/frameworkwrapper';
import { BusinessType } from '../constants/CommonConstants';
import { EventConstants } from '../constants/EventConstants';
import type { FolderLayoutStruct } from './FolderLayoutInfo';
import { FolderLayoutConfig } from './FolderLayoutConfig';
import { layoutConfigManager } from '../layoutconfig/LayoutConfigManager';
import type { AppItemInfo } from '../bean/AppItemInfo';
import type GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import { FolderLayoutCacheManager } from '../cache/layout/FolderLayoutCacheManager';
import { GridLayoutUtil, ReceiveEventInfo } from '../TsIndex';

const TAG = 'FolderModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * Folder information data model
 */
export class FolderModel {
  private readonly mFolderLayoutConfig: FolderLayoutConfig;
  private isResizeAnimationPlaying: boolean = false;

  private constructor() {
    this.mFolderLayoutConfig = layoutConfigManager.getFunctionConfig(FolderLayoutConfig.FOLDER_GRID_LAYOUT_INFO);
  }

  updateFolderSize(folderItem: GridLayoutItemInfo, isOuter?: boolean): void {
    FolderLayoutCacheManager.getInstance().updateFolderSizeByFolderItem(folderItem, BusinessType.BUSINESS_FOLDER, true,
      isOuter);
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
  }

  /**
   * Get folder model object
   *
   * @return Single instance of folder data model
   */
  public static getInstance(): FolderModel {
    if (globalThis.FolderModelInstance == null) {
      globalThis.FolderModelInstance = new FolderModel();
    }
    return globalThis.FolderModelInstance;
  }

  public getSmallFolderLayout(): FolderLayoutStruct {
    return this.mFolderLayoutConfig.getFolderLayoutInfo().smallFolderLayoutTable;
  }

  public getBigFolderLayout(): FolderLayoutStruct {
    return this.mFolderLayoutConfig.getFolderLayoutInfo().bigFolderLayoutTable;
  }

  public getFolderOpenLayout(): FolderLayoutStruct {
    if (this.isDevicePadOrBigFold()) {
      return (this.mFolderLayoutConfig.getFolderLayoutInfo().folderOpenLayoutInfoInPadOrExpand ??
        this.mFolderLayoutConfig.getDefaultLayoutInfo().folderOpenLayoutInfoInPadOrExpand) as FolderLayoutStruct;
    }
    return this.mFolderLayoutConfig.getFolderLayoutInfo().folderOpenLayoutTable ??
      this.mFolderLayoutConfig.getDefaultLayoutInfo().folderOpenLayoutTable;
  }

  public getOpenFolderMaxPerPage(): number {
    return (this.getFolderOpenLayout()?.column ?? 0) * (this.getFolderOpenLayout()?.row ?? 0);
  }

  public getFolderLayoutInOpen(): string {
    return this.getFolderOpenLayout()?.layout ?? '';
  }

  public getFolderAddAppLayout(): FolderLayoutStruct {
    if (this.isDevicePadOrBigFold()) {
      let folderOpenLayout: FolderLayoutStruct | undefined =
        this.mFolderLayoutConfig.getFolderLayoutInfo().folderAddLayoutInPadOrExpand;
      if (folderOpenLayout) {
        return folderOpenLayout;
      } else {
        log.showWarn('getFolderAddAppLayout is pad or expand but layout is null.');
      }
    }
    return this.mFolderLayoutConfig.getFolderLayoutInfo().folderAddAppLayoutTable;
  }

  /**
   * Get folder list
   *
   * @return folder list
   */
  public getFolderList(installedAppInfoList: AppItemInfo[], isOuter: boolean): GridLayoutItemInfo[] {
    log.showDebug('getFolderList');
    return FolderLayoutCacheManager.getInstance().selectAllFoldersWithAppCheck(installedAppInfoList, isOuter);
  }


  /**
   * 设置拖拽改变大小动效状态
   * @param isGo 是否在动效过程中
   */
  public setResizeAnimationState(isPlaying: boolean): void {
    this.isResizeAnimationPlaying = isPlaying;
  }

  /**
   * 获取拖拽改变大小动效状态
   * @returns 是否在动效过程中
   */
  public getResizeAnimationState(): boolean {
    return this.isResizeAnimationPlaying;
  }

  /**
   * register folder update event.
   *
   * @param listener
   */
  registerFolderUpdateEvent(listener: ReceiveEventInfo): void {
    localEventManager.registerEventListener(listener, [
      EventConstants.EVENT_BADGE_UPDATE,
      EventConstants.EVENT_FOLDER_PACKAGE_REMOVED,
      EventConstants.EVENT_FOLDER_PACKAGE_REMOVED_BATCH,
      EventConstants.EVENT_FOLDER_ITEM_UPDATE
    ]);
  }

  /**
   * 判断产品是否为pad或大折叠，如果是需要返回4x4布局，不是则返回3x4布局，
   * UltraScreen需要使用单独的接口,避免返回值错误
   * SCBScreenSession.isSingleDisplayPocketFoldDevice()为判断是否小折叠新产品
   */
  private isDevicePadOrBigFold(): boolean {
    if (DeviceHelper.isUltraScreenProduct()) {
      return DeviceHelper.isGState() || DeviceHelper.isMState();
    }
    if (DeviceHelper.isPad()) {
      return true;
    }
    if (SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus()) {
      return true;
    }
    return GridLayoutUtil.isTrifoldExpanded();
  }
}

export enum FolderLayoutInOpen {
  FOLDER_OPEN_LAYOUT_4x4 = '4X4',
  FOLDER_OPEN_LAYOUT_3X4 = '4X3'
};

export class AppListInfo {
  appGridInfo: GridLayoutItemInfo[][] = [];
}