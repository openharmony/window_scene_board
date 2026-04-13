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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { AppStatus, CommonConstants, GridLayoutItemInfo } from '../../../TsIndex';
import { AbstractBatchUninstaller } from './AbstractBatchUninstaller';
import { batchUninstallChain, ForwardType } from './BatchUninstallChain';

const TAG = 'LongPressBatchUninstaller';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class LongPressBatchUninstaller extends AbstractBatchUninstaller {
  /**
   *
   * @param batchItem
   * @param args
   */
  doHandleData(batchItem: GridLayoutItemInfo[], args?: ForwardType): void {
    log.showInfo(`batchUninstall>>> doHandleData>>> args:${args}`);
    switch (args) {
      case ForwardType.LONG_PRESS:
        batchUninstallChain.existsUninstallable = this.existsUninstallable(batchItem);
        if (!batchUninstallChain.existsUninstallable) {
          log.showInfo(`no Uninstallable item exists`);
          return;
        }
        batchUninstallChain.canAllDirectlyRemove = this.isAllCanDirectlyRemove(batchItem);
        // 继续处理长按汇聚事件，展示删除按钮
        GlobalContext.getContext()?.eventHub?.emit(
          CommonConstants.LONG_PRESS_TO_SHOW_OR_HIDE_DELETE_ICON,
          true,
          batchUninstallChain.canAllDirectlyRemove
        );
        break;
      case ForwardType.LONG_PRESS_END:
        // 拖拽速度快时，会先调用LONG_PRESS_END，然后再DRAG_DROP，这里加isDrag判断，避免清空拖拽对象
        let isDrag: boolean = AppStorage.get<boolean>('isDrag') as boolean;
        if (isDrag) {
          break;
        }
        GlobalContext.getContext()?.eventHub?.emit(
          CommonConstants.LONG_PRESS_TO_SHOW_OR_HIDE_DELETE_ICON,
          false,
          batchUninstallChain.canAllDirectlyRemove
        );
        this.endChain(args);
        break;
      default:
        this.runNext(args);
    }
  }

  /**
   * 判断是否存在可删卸的项目
   * @returns 是否存在
   */
  private existsUninstallable(batchItem: GridLayoutItemInfo[]): boolean {
    if (batchItem.length === 0) {
      log.showError(`dragItemList is empty`);
      return false;
    }
    for (let item of batchItem) {
      if (this.isUninstallable(item)) {
        return true;
      }
    }
    return false;
  }

  /**
   * 判断是否全部为快捷方式/下载中应用之类可以直接删除的应用
   * @param batchItem 待删项
   * @returns 结果
   */
  private isAllCanDirectlyRemove(batchItem: GridLayoutItemInfo[]): boolean {
    for (let item of batchItem) {
      if (!this.isUninstallable(item)) {
        continue;
      }
      if (item.typeId === CommonConstants.TYPE_APP && item.appStatus !== AppStatus.INSTALLED) {
        continue;
      }
      if (item.typeId === CommonConstants.TYPE_CARD || item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        continue;
      }
      return false;
    }
    return true;
  }
}