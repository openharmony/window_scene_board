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

import { FolderManager, GridLayoutItemInfo, GridLayoutUtil } from '@ohos/launchercommon';

/**
 * 打开退出动效工具类
 */
export class OpenCloseAnimationUtil {
  /**
   * 获取展开态文件夹需要做动效的图标数量
   *
   * @returns 文件夹内图标数量 < 展开态每页最大显示数量 ? 返回文件夹内图标数量 : 展开态每页最大显示数量（4*2 最大18）
   */
  public static getOpenFolderAppAnimateCount(): number {
    let openFolder: GridLayoutItemInfo = FolderManager.getInstance().getOpenedFolder();
    let itemNums: number = openFolder.layoutInfo?.flat().length ?? 0;
    if (itemNums > 0) {
      let appNumberWhenFolderOpen = GridLayoutUtil.getCountPerPageFolderOpen();
      if (itemNums > appNumberWhenFolderOpen) {
        const maxNum = GridLayoutUtil.getCountPerPageInFolder(openFolder.area);
        return Math.max(Math.min(itemNums, maxNum), appNumberWhenFolderOpen);
      } else {
        return itemNums;
      }
    }
    return 12;
  }
}