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

import { DockItemInfo, GridLayoutItemInfo } from '../../../../../TsIndex';

/**
 * 折叠态文件夹View组件的控制接口，由Feature层里的ViewModel实现
 */
export interface IContractedFolderRenameViewModel {
  /**
   * 查询长按预览图的位置参数
   *
   * @param item
   * @param indexInSwiper
   * @returns
   */
  getShadowOption(folderId: string, indexInSwiper: number): ShadowOptions;

  /**
   * 更新文件夹名字
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   */
  updateFolderName(msg: string, folderId: string, folderName: string): void;

  /**
   * 点击重命名
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   */
  clickRename(msg: string, folderId: string): void;

  /**
   * 生成文件夹名字
   *
   * @param msg 用于DFX的日志打印
   */
  generateFolderName(msg: string, endLayoutInfo: GridLayoutItemInfo,
    dragItems: GridLayoutItemInfo[] | DockItemInfo[]): string;
}