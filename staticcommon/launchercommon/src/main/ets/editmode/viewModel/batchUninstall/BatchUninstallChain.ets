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
import { AbstractBatchUninstaller } from './AbstractBatchUninstaller';
import { LongPressBatchUninstaller } from './LongPressBatchUninstaller';
import { DialogBatchUninstaller, RemoveDialogConfig } from './DialogBatchUninstaller';
import { RemoveBatchUninstaller } from './RemoveBatchUninstaller';
import { RecoverBatchUninstaller } from './RecoverBatchUninstaller';
import { editModeManager, GridLayoutItemInfo, CommonConstants, GridLayoutUtil } from '../../../TsIndex';
import { lockLayoutManager } from '../../../manager/LockLayoutManager';
import EditModeConstants from '../../../utils/EditModeConstants';
import { AppLockManager, AppLockStatusEnum } from '../../../manager/AppLockManager';
import { LockedBatchUninstaller } from './LockedBatchUninstaller';
import { NotHarmonyUtil } from '../../../utils/NotHarmonyUtil';

const TAG = 'BatchUninstallChain';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export enum UninstallMode {
  NORMAL,
  DRAWER
}

export enum ForwardType {
  INIT,
  LONG_PRESS,
  LONG_PRESS_END,
  LONG_PRESS_CANCEL,
  DRAG_START,
  DRAG_DROP,
  DRAG_END,
  JUMP_TO_UNINSTALL,
  CONFIRM_REMOVE,
  CANCEL_REMOVE,
  CONFIRM_LOCK,
  CANCEL_LOCK
}

export class BatchUninstallChain {
  private static _instance: BatchUninstallChain | null = null;

  public static getInstance(): BatchUninstallChain {
    if (!BatchUninstallChain._instance) {
      BatchUninstallChain._instance = new BatchUninstallChain();
    }
    return BatchUninstallChain._instance;
  }

  private getCurrentMode(): number {
    return UninstallMode.NORMAL;
  }

  public currentMode: number = this.getCurrentMode();
  public currentType: ForwardType = ForwardType.INIT;
  private uninstallerMap: Map<number, AbstractBatchUninstaller> = new Map();
  public batchItem?: GridLayoutItemInfo[];
  public multiSelected: boolean = false;
  public existsRemovable: boolean = false;
  public existsUninstallable: boolean = false;
  public canAllDirectlyRemove: boolean = false;
  public dialogConfig?: RemoveDialogConfig;

  public constructor() {
    /**
     * 长按展示删除按钮-->组装提示框-->执行删除或取消-->加锁应用删除-->删除失败恢复
     */
    let normalUninstaller = new LongPressBatchUninstaller();
    normalUninstaller
      .setNext(new DialogBatchUninstaller())
      .setNext(new RemoveBatchUninstaller())
      .setNext(new LockedBatchUninstaller())
      .setNext(new RecoverBatchUninstaller());
    this.uninstallerMap.set(UninstallMode.NORMAL, normalUninstaller);
  }

  public forward(args: ForwardType, batchItem?: GridLayoutItemInfo[]): void {
    if (lockLayoutManager.isLockLayout()) {
      return;
    }
    log.showInfo(`batchUninstall>>> forward args = ${args}`);
    if (this.currentType >= args) {
      log.showError(`error : batchUninstall>>> forward args = ${args}, currentType: ${this.currentType}`);
      return;
    }
    this.currentType = args;
    if (batchItem) {
      // 超过上限不处理结束
      if (batchItem.length > EditModeConstants.MULTI_SELECT_LIMIT) {
        this.endChain();
        return;
      }
      batchItem.forEach(item => this.isLockedApp(item));
      this.batchItem = batchItem;
      this.multiSelected = batchItem.length > 1;
    }
    this.uninstallerMap.get(this.currentMode)?.handleData(args);
  }

  public endChain() {
    log.showInfo(`batchUninstallChain.endChain, currentType>>>${this.currentType}`);
    this.currentMode = this.getCurrentMode();
    this.currentType = ForwardType.INIT;
    this.batchItem = undefined;
    this.multiSelected = false;
    this.existsRemovable = false;
    this.existsUninstallable = false;
    this.canAllDirectlyRemove = false;
    this.dialogConfig = undefined;
  }

  /**
   * 是否加锁属性赋值
   * @param item 判断对象
   * @returns 是否加锁
   */
  private isLockedApp(item?: GridLayoutItemInfo): boolean {
    if (!item || item.typeId !== CommonConstants.TYPE_APP) {
      return false;
    }
    let appLockStatus: AppLockStatusEnum = AppLockManager.getInstance().getAppLockStatus(
      item.bundleName,
      item.appIndex
    );
    item.isAppLocked = appLockStatus === AppLockStatusEnum.LOCK;
    return item.isAppLocked;
  }

  /**
   * 判断图标是否隐藏
   * @param appItem 图标
   * @returns 是否隐藏
   */
  public ifHideAppIcon(appItem: GridLayoutItemInfo): boolean {
    return editModeManager.getIsShowingUninstallDialog() && this.isItemInBatch(appItem);
  }

  /**
   * 判断图标是否可卸载
   *
   * @param appItem 图标
   * @returns 是否可卸载
   */
  public isUninstallable(appItem: GridLayoutItemInfo): boolean {
    return this.uninstallerMap.get(UninstallMode.NORMAL)?.isUninstallable(appItem) ?? false;
  }

  /**
   * 判断图标是否在多选元素中
   *
   * @param appItem 图标
   * @returns 是否在
   */
  public isItemInBatch(appItem: GridLayoutItemInfo): boolean {
    if (appItem == null) {
      return false;
    }
    let appKey = GridLayoutUtil.generateUniqueKey(appItem);
    if (this.batchItem) {
      for (let item of this.batchItem) {
        let uniKey = GridLayoutUtil.generateUniqueKey(item);
        if (appKey === uniKey) {
          return true;
        }
      }
    }
    return false;
  }
}

export const batchUninstallChain: BatchUninstallChain = BatchUninstallChain.getInstance();