/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
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