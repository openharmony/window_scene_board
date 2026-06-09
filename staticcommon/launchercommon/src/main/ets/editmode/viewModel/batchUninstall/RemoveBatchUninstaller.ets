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
import { ForwardType } from './BatchUninstallChain';
import { CommonConstants, GridLayoutItemInfo } from '../../../TsIndex';
import { GlobalContext } from '@ohos/frameworkwrapper';

const TAG = 'RemoveBatchUninstaller';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class RemoveBatchUninstaller extends AbstractBatchUninstaller {
  doHandleData(batchItem: GridLayoutItemInfo[], args?: ForwardType): void {
    log.showInfo(`batchUninstall>>> doHandleData>>> args:${args}`);
    switch (args) {
      case ForwardType.CANCEL_REMOVE:
        // 取消
        this.doCancelRemove(batchItem);
        this.endChain(args);
        break;
      case ForwardType.CONFIRM_REMOVE:
        // 确认
        let length: number = batchItem.length;
        let toRecoverItems: GridLayoutItemInfo[] = [];
        let toRemoveItems: GridLayoutItemInfo[] = [];
        for (let i = 0; i < length; i++) {
          let item: GridLayoutItemInfo | undefined = batchItem.shift();
          if (!item) {
            continue;
          }
          if (!this.isUninstallable(item)) {
            toRecoverItems.push(item);
            continue;
          }
          if (item.isAppLocked) {
            batchItem.push(item);
            continue;
          }
          toRemoveItems.push(item);
        }
        // GlobalContext.getContext()?.eventHub?.emit(CommonConstants.EDIT_MODE_ITEM_REMOVE_EVENT, toRemoveItems);
        GlobalContext.getContext()?.eventHub?.emit(CommonConstants.EDIT_MODE_ITEM_UNINSTALL_EVENT, toRemoveItems);
        this.batchRecover(toRecoverItems);
        this.runNext(args);
        break;
      default:
        this.runNext(args);
    }
  }

  private doCancelRemove(batchItem: GridLayoutItemInfo[]) {
    this.batchRecover(batchItem);
    batchItem.forEach((item) => {
      if (item.typeId === CommonConstants.TYPE_APP) {
        GlobalContext.getContext()?.eventHub?.emit(`cancelUninstall${item.keyName}`, true);
      } else if (item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        GlobalContext.getContext()?.eventHub?.emit(`cancelUninstall${item.shortcutId}`, true);
      } else if (item.typeId === CommonConstants.TYPE_CARD) {
        GlobalContext.getContext()?.eventHub?.emit(`cancelUninstall${item.cardId}`, true);
      }
    });
  }
}