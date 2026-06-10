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
// import appLock from '@hms.security.appLock';
import { BusinessError } from '@ohos.base';
import { ForwardType } from './BatchUninstallChain';
import { CommonConstants, GridLayoutItemInfo } from '../../../TsIndex';
import { GlobalContext } from '@ohos/frameworkwrapper';

const TAG = 'LockedBatchUninstaller';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class LockedBatchUninstaller extends AbstractBatchUninstaller {
  doHandleData(batchItem: GridLayoutItemInfo[], args?: ForwardType): void {
    log.showInfo(`batchUninstall>>> doHandleData>>> args:${args}`);
    let existsLocked = this.existsLockedItems(batchItem);
    if (args !== ForwardType.CONFIRM_REMOVE || !existsLocked) {
      this.runNext(args);
      return;
    }
    // appLock.startAppLockAuth()
    //   .then(() => {
    //     log.showInfo('startAppLockAuth succeed');
    //     // 直接卸载
    //     let length: number = batchItem.length;
    //     let lockedItems: GridLayoutItemInfo[] = [];
    //     for (let i = 0; i < length; i++) {
    //       let item: GridLayoutItemInfo | undefined = batchItem.shift();
    //       if (!item) {
    //         continue;
    //       }
    //       if (!item.isAppLocked) {
    //         batchItem.push(item);
    //         continue;
    //       }
    //       lockedItems.push(item);
    //     }
    //     GlobalContext.getContext()?.eventHub?.emit(CommonConstants.EDIT_MODE_ITEM_REMOVE_EVENT, lockedItems);
    //   })
    //   .catch((error: BusinessError) => {
    //     log.error(`startAppLockAuth error, errcode: ${error.code}, msg: ${error.message}`);
    //   })
    //   .finally(() => {
    //     this.runNext(args)
    //   });
  }

  private existsLockedItems(batchItem: GridLayoutItemInfo[]): boolean {
    for (let item of batchItem) {
      if (item.isAppLocked) {
        return true;
      }
    }
    return false;
  }
}