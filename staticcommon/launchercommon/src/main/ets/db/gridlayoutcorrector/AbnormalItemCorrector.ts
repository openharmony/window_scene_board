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
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { CommonConstants } from '../../constants/CommonConstants';
import { AbstractGridLayoutCorrector } from './AbstractGridLayoutCorrector';

const TAG = 'AbnormalItemCorrector';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 异常数据处理类，当前会被识别为异常数据的为：
 * 1.bundleName为空的图标
 * 2.桌面上重复的图标或单个文件夹中重复的图标
 * 3.桌面和文件夹或文件夹和文件夹中重复去重（暂无方案,待添加）
 */
export class AbnormalItemCorrector extends AbstractGridLayoutCorrector {
  handleData(girdLayoutInfo: GridLayoutItemInfo[], isOuter?: boolean): void {
    for (let i = 0; i < girdLayoutInfo.length; i++) {
      let itemInfo: GridLayoutItemInfo = girdLayoutInfo[i];

      // 文件夹内元素去重
      if (itemInfo.typeId === CommonConstants.TYPE_FOLDER && itemInfo.layoutInfo && itemInfo.layoutInfo[0]) {
        this.handleFolderItem(itemInfo);
      }

      // 桌面图标去重
      if (this.isCheckRepeatInDesktop(itemInfo)) {
        if (girdLayoutInfo.findIndex(item => {
          return this.judgeEqualItem(item, itemInfo);
        }) !== i || !itemInfo.bundleName) {
          log.showError(`gridLayoutCorrector delete:${JSON.stringify(itemInfo)}`);
          girdLayoutInfo.splice(i, 1);
          this.deleteRdbGridLayoutItemInfo(itemInfo, isOuter);
          i--;
        }
      }
    }
  }

  private isCheckRepeatInDesktop(itemInfo: GridLayoutItemInfo): boolean {
    // 桌面图标，以及联系人快捷方式检查去重
    return itemInfo.typeId === CommonConstants.TYPE_APP ||
      (itemInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON && itemInfo.bundleName === CommonConstants.CONTACTS_BUNDLE_NAME);
  }

  private handleFolderItem(itemInfo: GridLayoutItemInfo, isOuter?:boolean): void {
    if (!itemInfo.layoutInfo) {
      return;
    }
    let folderInfo = itemInfo.layoutInfo[0];
    for (let j: number = 0; j < folderInfo.length; j++) {
      let folderItem = folderInfo[j];
      if (folderInfo.findIndex(item => {
        return this.judgeEqualItem(item, folderItem);
      }) !== j || !folderItem.bundleName) {
        log.showError(`gridLayoutCorrector folder ${itemInfo.folderId} delete:${JSON.stringify(folderItem)}`);
        folderInfo.splice(j, 1);
        this.deleteRdbGridLayoutItemInfo(folderItem, isOuter);
        j--;
      }
    }
  }

  private judgeEqualItem(item: GridLayoutItemInfo, targetItem: GridLayoutItemInfo): boolean {
    return item.typeId === targetItem.typeId &&
      item.container === targetItem.container &&
      item.keyName === targetItem.keyName;
  }
}