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

import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { CommonConstants } from '../../constants/CommonConstants';
import { AbstractGridLayoutCorrector } from './AbstractGridLayoutCorrector';

/**
 * 针对wifi only平板清理beta升级过程中的多余联系人脏数据
 * 1.bundleName: com.ohos.contacts / com.ohos.contacts.MainAbility
 * 2.shortcut_id: shortcut_id_01
 * 3.module_name: entry
 */
export class CleanContactsDirtyIconCorrector extends AbstractGridLayoutCorrector {
  handleData(girdLayoutInfo: GridLayoutItemInfo[], isOuter?: boolean): void {
    for (let i = 0; i < girdLayoutInfo.length; i++) {
      let itemInfo: GridLayoutItemInfo = girdLayoutInfo[i];

      // 文件夹内电话脏数据
      if (itemInfo.typeId === CommonConstants.TYPE_FOLDER && itemInfo.layoutInfo && itemInfo.layoutInfo[0]) {
        this.handleFolderItem(itemInfo);
      }

      // 桌面图标删除脏数据
      if (itemInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON && (itemInfo.bundleName === 'com.ohos.contacts')) {
        girdLayoutInfo.splice(i, 1);
        this.deleteRdbGridLayoutItemInfo(itemInfo, isOuter);
        i--;
      }
    }
  }

  private handleFolderItem(itemInfo: GridLayoutItemInfo, isOuter?:boolean): void {
    if (!itemInfo.layoutInfo) {
      return;
    }
    let folderInfo = itemInfo.layoutInfo[0];
    for (let j: number = 0; j < folderInfo.length; j++) {
      let tmpItem = folderInfo[j];
      if (CommonConstants.TYPE_SHORTCUT_ICON === tmpItem.typeId && (tmpItem.bundleName === 'com.ohos.contacts')) {
        this.deleteRdbGridLayoutItemInfo(tmpItem, isOuter);
        folderInfo.splice(j, 1);
        j--;
      }
    }
  }
}