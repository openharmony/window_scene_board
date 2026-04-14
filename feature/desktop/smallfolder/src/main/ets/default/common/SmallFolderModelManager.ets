/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *     http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { SmallFolderShowModel } from '../viewmodel/SmallFolderShowModel';

const TAG = 'SmallFolderModelManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 注册、执行及销毁组件显示与隐藏回调函数的管理器
 */
export class SmallFolderModelManager {
  private smallFolderModelMap: Map<string, SmallFolderShowModel> = new Map();

  /**
   * 获取 SmallFolderModelManager 单例
   * @returns SmallFolderModelManager
   */
  public static getInstance(): SmallFolderModelManager {
    return SingletonHelper.getInstance(SmallFolderModelManager, TAG);
  }

  /**
   * 添加model
   * @param smallFolderId 小文件夹Id
   * @param smallFolderModel 小文件夹model
   */
  addSmallFolderShowModel(smallFolderId: string, smallFolderModel: SmallFolderShowModel): void {
    log.info(`pushSmallFolderModel smallFolderId:${smallFolderId}`);
    this.smallFolderModelMap.set(smallFolderId, smallFolderModel);
  }

  /**
   * 删除model
   * @param smallFolderId 小文件夹Id
   */
  removeSmallFolderShowModel(smallFolderId: string): void {
    if (this.smallFolderModelMap.has(smallFolderId)) {
      this.smallFolderModelMap.delete(smallFolderId);
    } else {
      log.info(`${smallFolderId} has not SmallFolderModelManager`);
    }
  }

  /**
   * 获取model
   * @param smallFolderId 小文件夹Id
   */
  getSmallFolderShowModel(smallFolderId: string): SmallFolderShowModel {
    if (!this.smallFolderModelMap.has(smallFolderId)) {
      log.info(`${smallFolderId} has not SmallFolderModel`);
    }
    return this.smallFolderModelMap.get(smallFolderId) ?? new SmallFolderShowModel;
  }
}