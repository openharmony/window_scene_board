/**
 * Copyright (c) 2023-Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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
 *
 *
 */

import { CheckEmptyUtils, LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import FolderDataModel from '../data/FolderDataModel';
import { BaseFolderState } from '../state/BaseFolderState';

import { FolderDataModelManager } from './FolderDataModelManager';

const TAG = 'FolderServiceManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class FolderServiceManager {

  private mFolderDataModelManager = FolderDataModelManager.getInstance();

  protected constructor() {
  }

  static getInstance(): FolderServiceManager {
    if (globalThis.folderServiceManager == null) {
      log.showInfo('getInstance FolderServiceManager');
      globalThis.folderServiceManager = new FolderServiceManager();
    }
    return globalThis.folderServiceManager;
  }

  /**
   * 点击打开文件夹处理函数
   * @param folderId folderId
   */
  public clickOpenFolder(folderId: string): void {
    this.mFolderDataModelManager.setOpenFolderId(folderId);
  }

  /**
   * 点击关闭文件夹
   * @param folderId folderId
   */
  public clickCloseFolder(folderId: string): void {
    let folderStateContext: BaseFolderState | undefined =
      this.mFolderDataModelManager.getFolderStateContextById(folderId);
    let folderDataModel: FolderDataModel | undefined = this.mFolderDataModelManager.getFolderDataModelById(folderId);
    if (!folderStateContext || !folderDataModel) {
      return;
    }
    if (folderDataModel.isSmallFolder()) {
      folderStateContext.clickCloseSmallFolder(folderId);
    } else {
      folderStateContext.clickCloseBigFolder(folderId);
    }
  }
}
