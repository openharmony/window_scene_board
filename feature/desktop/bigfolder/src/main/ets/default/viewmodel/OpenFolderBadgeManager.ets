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

import { ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext, EventConstants } from '@ohos/frameworkwrapper'
import {
  FolderModel,
  GridLayoutItemInfo,
  FolderManager,
  FolderCommonUtil
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { BadgeAnimationType } from '@ohos/launchercommon/Index';
import { AppIconBadgeVm } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconBadgeVm';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { OpenCloseAnimationUtil } from './openclose/OpenCloseAnimationUtil';
import { editModeManager } from '@ohos/launchercommon/src/main/ets/editmode/model/EditModeManager';
import { PC_IN_PHONE_LIST } from '@ohos/windowscene';

const TAG = 'OpenFolderBadgeManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 文件夹展开态角标与分身下角标管理类
 */
export class OpenFolderBadgeManager {
  private iconBadgeVm: AppIconBadgeVm = new AppIconBadgeVm();
  private item: GridLayoutItemInfo = new GridLayoutItemInfo();
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  private mFolderMgr: FolderManager = FolderManager.getInstance();

  constructor(badgeVm: AppIconBadgeVm,  item: GridLayoutItemInfo) {
    this.iconBadgeVm = badgeVm;
    this.item = item;
  }

  /**
   * 执行打开文件夹角标动效
   */
  private openFolderBadgeAnimate(): void {
    this.desktopContext?.eventHub.emit(EventConstants.EVENT_FOLDER_CLOSING, false);
    let isVisible: boolean = this.isBadgeVisible();
    log.showInfo('%{public}s Badge visible form %{public}s to %{public}s by open folder, badgeNumber:%{public}d',
      this.item.bundleName, this.iconBadgeVm.visible, isVisible, this.iconBadgeVm.badgeNumber);
    this.iconBadgeVm.visible = isVisible;
    this.iconBadgeVm.animate = BadgeAnimationType.OPEN_FOLDER_BUBBLE_SHOW;
  }

  /**
   * 执行堆叠下角标动效
   */
  public showFolderCloneBadgeAnimation(): void {
  }

  private isBadgeVisible(): boolean {
    const folder: GridLayoutItemInfo = this.mFolderMgr.getOpenedFolder();
    // 4x2的折叠态打开过程中补位的动效元素的角标需要隐藏避免打开动效过程中出现残影，其他类型文件夹的角标正常显示
    let is4x2Folder: boolean = ArrayUtils.equalsArr(folder.area, [4, 2]);
    let pageNum: number = FolderModel.getInstance().getOpenFolderMaxPerPage();
    let aniNum: number = OpenCloseAnimationUtil.getOpenFolderAppAnimateCount();
    const indexInList: number = this.mFolderMgr.getIndexInFolder(this.item, folder) +
      pageNum * this.mFolderMgr.getPageIndexInFolder(this.item, folder);
    return !is4x2Folder || (indexInList < pageNum || indexInList >= aniNum);
  }

  /**
   * 执行角标关闭动效
   */
  public closeFolderBadgeAnimate(): void {
    if (FolderCommonUtil.isLayout1X1(this.mFolderMgr.getClosingFolder()?.area)) {
      this.desktopContext?.eventHub.emit(EventConstants.EVENT_FOLDER_CLOSING, true);
    }
    this.iconBadgeVm.animate = BadgeAnimationType.CLOSE_FOLDER_BUBBLE_HIDE;
  }

  /**
   * 执行文件夹数字角标动效
   */
  public showFolderBadgeAnimation(): void {
    if (this.iconBadgeVm.badgeNumber <= 0) {
      return;
    }
    if (this.mFolderMgr.isFolderOpen() && !editModeManager.getEditModeState().isInEditMode()) {
      this.openFolderBadgeAnimate();
    } else {
      this.closeFolderBadgeAnimate();
    }
  }

  /**
   * 补位动效元素的角标在打开动效完成后将角标显示出来，关闭动效开始时将角标隐藏
   */
  public badgeChangeOnOpenClose(): void {
    if (this.iconBadgeVm.badgeNumber <= 0) {
      return;
    }
    if (this.mFolderMgr.isFolderOpen() && !editModeManager.getEditModeState().isInEditMode()) {
      log.showInfo('%{public}s Badge visible form %{public}s to true by folder opened',
        this.item.bundleName, this.iconBadgeVm.visible);
      this.iconBadgeVm.visible = true;
      this.iconBadgeVm.animate = BadgeAnimationType.TOUCH_UP;
    } else {
      this.iconBadgeVm.animate = BadgeAnimationType.CLOSE_FOLDER_BUBBLE_HIDE;
    }
  }
}