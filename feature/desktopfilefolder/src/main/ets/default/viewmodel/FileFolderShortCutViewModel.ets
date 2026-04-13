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
import { CheckEmptyUtils, LogDomain, Logger } from '@ohos/basicutils';
import { DesktopItemPosition } from '../common/bean/DesktopItemPosition';
import FileFolderManagerFactory from '../manager/FileFolderManagerFactory';
import FileFolderManager from '../manager/FileFolderManager';
import { GridLayoutItemInfo } from '@ohos/launchercommon';

const TAG = 'FileFolderShortCutViewModel';
const log = Logger.getLogHelper(LogDomain.HOME);

export class FileFolderShortCutViewModel {
  private fileFolderManager: FileFolderManager = FileFolderManagerFactory.getFileFolderManager();
  private static instance: FileFolderShortCutViewModel;

  public static getInstance(): FileFolderShortCutViewModel {
    if (!FileFolderShortCutViewModel.instance) {
      FileFolderShortCutViewModel.instance = new FileFolderShortCutViewModel();
    }
    return FileFolderShortCutViewModel.instance;
  }

  public preStoreDesktopPosition(shortcutItemInfo: GridLayoutItemInfo): boolean {
    if (!shortcutItemInfo || !shortcutItemInfo?.uri || CheckEmptyUtils.isEmpty(shortcutItemInfo?.column) ||
      CheckEmptyUtils.isEmpty(shortcutItemInfo?.row) || CheckEmptyUtils.isEmpty(shortcutItemInfo?.page)) {
      log.showError(TAG, 'preStoreDesktopPosition invalid param');
      return false;
    }
    this.fileFolderManager.setDesktopPositionByUris([shortcutItemInfo.uri], shortcutItemInfo.column ?? 0,
      shortcutItemInfo.row ?? 0, shortcutItemInfo.page ?? 0);
    return true;
  }

}
