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
export interface IContractedFolderOpenCloseViewModel {
  /**
   * 打开文件夹
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   * @param isRename 是否重命名
   * @param flags 打开类型
   */
  open(msg: string, folderId: string, isRename: boolean, flags: number): void;

  /**
   * 关闭文件夹
   *
   * @param msg 用于DFX的日志打印
   * @param flags 标志关闭的模式
   */
  close(msg: string, flags: number): void;

  /**
   * 设置文件夹关闭后的回调
   *
   * @param callback
   */
  setClosedCallBack(callback: () => void): void;

  /**
   * 根据folderId给每个文件夹注册动效生命周期回调
   *
   * @param folderId 文件夹id
   */
  registerFolderActionEventByFolderId(folderId: string): void;

  /**
   * 根据folderId给每个文件夹取消注册动效生命周期回调
   *
   * @param folderId 文件夹id
   */
  unregisterFolderActionEventByFolderId(folderId: string): void;
}