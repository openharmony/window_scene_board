/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
import { LogDomain, Logger } from '@ohos/basicutils';
import { NumberConstants } from '@ohos/commonconstants';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { CommonConstants } from '../../constants/CommonConstants';
import DataConvert from '../DataConvert';
import { BaseTransformItem } from './BaseTransformItem';

const TAG = 'FolderTransformItem';
const log: Logger = Logger.getLogHelper(LogDomain.BACKUP);
const USER_RENAME_FOLDER_NAME = 2;
const OLD_DEFAULT_FOLDER_NAME = 'folder_title';
const BACKUP_FOLDER_SPLIT = '++++';

export class FolderTransformItem extends BaseTransformItem {
  public isSupportInohos(): boolean {
    return true;
  }

  public async transformBackupInfoToGridInfo(): Promise<GridLayoutItemInfo[]> {
    let folderName = this.backupInfo.title;
    if (folderName && this.backupInfo.isNewInstalled !== USER_RENAME_FOLDER_NAME) {
      if (folderName.lastIndexOf(OLD_DEFAULT_FOLDER_NAME) > CommonConstants.INVALID_VALUE) {
        let defaultFolderName: string = '${new_folder_name}';
        folderName = `${defaultFolderName}${folderName.split('=')[1]}`;
      }
      if (folderName.lastIndexOf(BACKUP_FOLDER_SPLIT) > CommonConstants.INVALID_VALUE) {
        folderName = folderName.substring(folderName.lastIndexOf(BACKUP_FOLDER_SPLIT) + BACKUP_FOLDER_SPLIT.length);
      }
    }
    let item: GridLayoutItemInfo = this.buildGridInfoByBackupInfo(this.backupInfo);
    item.folderName = folderName;
    item.folderId = String(DataConvert.incCurrentTime());
    item.typeId = CommonConstants.TYPE_FOLDER;
    item.area = [this.backupInfo.spanX, this.backupInfo.spanY];
    item.area[0] = item.area[0] === NumberConstants.CONSTANT_NUMBER_THREE ?
      NumberConstants.CONSTANT_NUMBER_FOUR : item.area[0];
    item.area[1] = item.area[1] === NumberConstants.CONSTANT_NUMBER_THREE ?
      NumberConstants.CONSTANT_NUMBER_TWO : item.area[1];
    log.showInfo(TAG, `double folder is ${item.folderName}, folderId is ${item.folderId}, screen: ${item.page}, ` +
      `container: ${item.container}, point : [${item.row}, ${item.column}]`);
    return [item];
  }
}