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
import { batchUninstallChain, ForwardType } from './BatchUninstallChain';
import { EventConstants, GlobalContext, localEventManager } from '@ohos/frameworkwrapper';
import {
  AppStatus,
  CommonConstants,
  ContactCacheManager,
  EditModeConstants,
  GridLayoutItemInfo,
  GridLayoutUtil,
  layoutLockUtil,
  NotHarmonyUtil,
} from '../../../TsIndex';
import { launcherStatusUtil } from '@ohos/windowscene';
import { FolderLayoutCacheManager } from '../../../cache/layout/FolderLayoutCacheManager';

const TAG = 'AbstractBatchUninstaller';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export abstract class AbstractBatchUninstaller {
  protected next?: AbstractBatchUninstaller;

  public setNext(next: AbstractBatchUninstaller): AbstractBatchUninstaller {
    this.next = next;
    return this.next;
  }

  handleData(args?: ForwardType) {
    log.showInfo(`batchUninstall>>> handleData args = ${args}, batchItem.length = ${batchUninstallChain.batchItem?.length}`);
    // 如果没有需要卸载的就直接结束
    if (!batchUninstallChain.batchItem || batchUninstallChain.batchItem.length == 0) {
      this.endChain(args);
      return;
    }
    this.doHandleData(batchUninstallChain.batchItem, args);
  }

  abstract doHandleData(batchItem: GridLayoutItemInfo[], args?: ForwardType): void;

  protected endChain(args?: ForwardType) {
    log.showInfo(`batchUninstall>>> endChain>>> ${args}`);
    batchUninstallChain.endChain();
  }

  protected runNext(args?: ForwardType) {
    if (this.next) {
      this.next.handleData(args);
    } else {
      this.endChain(args);
    }
  }

  protected batchRecover(items: GridLayoutItemInfo[]) {
    log.showInfo(`batchUninstall>>> batchRecover`);
    if (items == null) {
      log.showInfo(`batchUninstall>>> batchRecover items is null`);
      return;
    }
    let folderItems: GridLayoutItemInfo[] = [];
    const changeList: string[] = [];
    items.forEach((item: GridLayoutItemInfo) => {
      const isInFolder: boolean = item.container != null && item.container !== CommonConstants.CONTAINER_DESKTOP;
      if (batchUninstallChain.multiSelected && isInFolder) {
        folderItems.push(item);
      } else if (!batchUninstallChain.multiSelected && isInFolder) {
        changeList.push(item.bundleName);
      }
      GlobalContext.getContext()?.eventHub?.emit(EditModeConstants.EVENT_EDIT_MODE_DROP_TO_DELETE + item.keyName,
        false);
    });
    if (folderItems.length > 0) {
      GlobalContext.getContext()?.eventHub?.emit(EditModeConstants.EVENT_EDIT_MODE_FOLDER_ITEM_RECOVER, folderItems);
    }
    if (changeList.length > 0) {
      localEventManager.sendLocalEvent(EventConstants.EVENT_REFRESH_SMALL_FOLDER_IMAGE, changeList);
    }
  }

  /**
   * 抽屉模式-判断元素是否可移除
   * @param item 元素
   * @returns 是否可移除
   */
  protected isRemovable(item: GridLayoutItemInfo): boolean {
    // 非app/快捷方式/卡片 不可移除
    let typeArr: number[] = [CommonConstants.TYPE_APP, CommonConstants.TYPE_CARD, CommonConstants.TYPE_SHORTCUT_ICON];
    if (item.typeId == null || typeArr.indexOf(item.typeId) < 0) {
      log.showInfo(`isRemovable>>> ${item.bundleName} not removable type`);
      return false;
    }
    // 取消即将发布应用文件夹特性开关关闭时，未OpenHarmony化的应用不可移除
    let appTypes: number[] = [];
    return true;
  }

  /**
   * 判断元素是否可卸载
   * @param item 元素
   * @returns 是否可卸载
   */
  public isUninstallable(item: GridLayoutItemInfo): boolean {
    // 非app/快捷方式/卡片 不可删
    let typeArr: number[] = [CommonConstants.TYPE_APP, CommonConstants.TYPE_CARD, CommonConstants.TYPE_SHORTCUT_ICON];
    if (item.typeId == null || typeArr.indexOf(item.typeId) < 0) {
      log.showInfo(`isUninstallable>>> ${item.bundleName} not uninstallable type`);
      return false;
    }
    // 外屏均可删
    if (launcherStatusUtil.getShowOutLauncherStatus() && this.isNotInLockedPage(item)) {
      log.showInfo(`isUninstallable>>> ${item.bundleName} showing out launcher`);
      return true;
    }
    // 不可卸载不可删
    if (item.isUninstallAble === false) {
      log.showInfo(`isUninstallable>>> ${item.bundleName} not UninstallAble`);
      return false;
    }
    // 正在安装不可删
    if (item.appStatus === AppStatus.INSTALLING) {
      log.showInfo(`isUninstallable>>> ${item.bundleName} app INSTALLING`);
      return false;
    }
    // 所在页加锁不可删
    if (!this.isNotInLockedPage(item)) {
      log.showInfo(`isUninstallable>>> ${item.bundleName} InLockedPage`);
      return false;
    }
    // id为空的卡片不可删
    let isCardButEmpty: boolean = item.typeId === CommonConstants.TYPE_CARD &&
    CheckEmptyUtils.checkStrIsEmpty(item.cardId);
    if (isCardButEmpty) {
      log.showInfo(`isUninstallable>>> ${item.bundleName} isCardButEmpty`);
      return false;
    }
    // 联系人不可删
    if (ContactCacheManager.getInstance().isContactShortcut(item)) {
      log.showInfo(`isUninstallable>>> ${item.bundleName} isContactShortcut`);
      return false;
    }
    return true;
  }

  private isNotInLockedPage(dragItem: GridLayoutItemInfo): boolean {
    if (!layoutLockUtil.isLocked()) {
      return true;
    }
    let curPage: number | undefined = dragItem.page;
    // 能走进这个判断里面的在编辑模式下只有文件夹内的应用，其他container不为DESKTOP的
    // 有dock栏和卡片堆叠内的卡片，dock栏在编辑模式下隐藏，卡片堆叠在编辑模式下无法展开
    if (dragItem.container != null && dragItem.container !== CommonConstants.CONTAINER_DESKTOP) {
      curPage = FolderLayoutCacheManager.getInstance().selectFolderByKeyName(dragItem.keyName ?? '')?.page;
    }
    log.showInfo(`isNotInLockedPage params, curPage:${curPage}, container:${dragItem.container}`);
    if (curPage == undefined) {
      return true;
    }
    return !layoutLockUtil.isLockedPage(curPage, 'show deleteIcon by drag', true);
  }
}