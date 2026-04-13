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

import { GridLayoutItemInfo } from '../../../../../TsIndex';

/**
 * 折叠态文件夹View组件的控制接口，由Feature层里的ViewModel实现
 */
export interface IContractedFolderUninstallViewModel {
  /**
   * 卸载应用
   *
   * @param msg DFX的日志打印
   * @param folderId 文件夹id
   * @param itemInfo 文件夹item
   * @param needToUninstall 应用是否上锁，上锁需要用户选择确认后删除
   */
  uninstallItem(msg: string, folderId: string, itemInfo: GridLayoutItemInfo, needToUninstall: boolean): void;

  /**
   * 卸载加锁应用
   *
   * @param msg DFX的日志打印
   * @param folderId 文件夹id
   * @param itemInfo 文件夹item
   */
  uninstallLockedItem(msg: string, folderId: string, itemInfo: GridLayoutItemInfo): void;

  /**
   * 通知触发解散动效
   *
   * @param msg 用于DFX日志
   * @param folderId 文件夹id
   * @param flags 动画标识
   */
  notifyDisbandFolder(msg: string, folderId: string, flags: number): void;
}