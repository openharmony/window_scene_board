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

/**
 * 折叠态文件夹View组件的控制接口，由Feature层里的ViewModel实现
 */
export interface IContractedFolderDownloadViewModel {
  /**
   * 更新文件夹下载的应用列表
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   */
  updateDownloadList(msg: string, folderId: string): void;

  /**
   * 设置下载进度更新回调
   *
   * @param msg DFX日志打印
   * @param folderId 文件夹id
   * @param callback 回调
   */
  initDownloadState(msg: string, folderId: string, callback: (curSize: number, totalSize: number,
    isNewProgress?: boolean, isReset?: boolean) => void): void;

  /**
   * 反注册下载回调
   *
   * @param folderId 文件夹id
   */
  unregisterEvents(folderId: string, callback?: (curSize: number, totalSize: number,
    isNewProgress?: boolean, isReset?: boolean) => void): void;
}