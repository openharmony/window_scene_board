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
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { CommonConstants } from '../../constants/CommonConstants';
import { AbstractGridLayoutCorrector } from './AbstractGridLayoutCorrector';

const TAG = 'NoImageItemCorrector';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const BUNDLE_NAME = 'com.ohos.findservice';

export class NoImageItemCorrector extends AbstractGridLayoutCorrector {
  handleData(girdLayoutInfo: GridLayoutItemInfo[], isOuter?: boolean): void {
    let findIndex = girdLayoutInfo.findIndex(item => this.judgeEqualItem(item));
    if (findIndex !== -1) {
      this.deleteRdbGridLayoutItemInfo(girdLayoutInfo[findIndex], isOuter);
      let deleteObj = girdLayoutInfo.splice(findIndex, 1);
      log.showError(`find ${BUNDLE_NAME} in desktop, delete item:${JSON.stringify(deleteObj)}`);
      return;
    }
    // 从桌面文件夹中查找
    let folderItems: GridLayoutItemInfo[] = girdLayoutInfo.filter(layout => layout.typeId === CommonConstants.TYPE_FOLDER);
    findIndex = this.dealInFolder(folderItems, isOuter);
    if (findIndex !== -1) {
      log.showError(`find ${BUNDLE_NAME} in folder`);
      return;
    }
    log.showInfo('can not find com.ohos.findservice in anywhere');
  }

  private dealInFolder(folders: GridLayoutItemInfo[], isOuter?:boolean): number {
    if (!folders || folders.length === 0) {
      return -1;
    }
    let findIndex = -1;
    for (let i = 0; i < folders.length; i++) {
      findIndex = this.findFolderItem(folders[i], isOuter);
      if (findIndex !== -1) {
        break;
      }
    }
    return findIndex;
  }

  private findFolderItem(itemInfo: GridLayoutItemInfo, isOuter?:boolean): number {
    if (!itemInfo || !itemInfo.layoutInfo || !itemInfo.layoutInfo[0]) {
      return -1;
    }
    let folderInfos = itemInfo.layoutInfo[0];
    let findIndex = folderInfos.findIndex(item => this.judgeEqualItem(item));
    log.showError(`find in folder ${itemInfo.folderId}`);
    if (findIndex !== -1) {
      this.deleteRdbGridLayoutItemInfo(folderInfos[findIndex], isOuter);
      let deleteObj = folderInfos.splice(findIndex, 1);
      log.showError(`find in folder ${itemInfo.folderId} findIndex:${findIndex} delete:${JSON.stringify(deleteObj)}`);
    }
    return findIndex;
  }

  private judgeEqualItem(item: GridLayoutItemInfo): boolean {
    return item.bundleName === BUNDLE_NAME;
  }
}