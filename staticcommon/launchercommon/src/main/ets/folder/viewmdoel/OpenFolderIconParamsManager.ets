/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024. All rights reserved.
 */
import { AppIconData } from '../../launchericon/viewmodel/AppIconData';


/**
 * 文件夹展开态图标参数管理类
 * 用于管理文件夹展开态图标内绑定的iconData, 在关闭场景进行统一处理
 *
 */
export class OpenFolderIconParamsManager {
  // 按压的iconData数组,需要在关闭的时候遍历一次并统一关闭
  private mPressIconItems: AppIconData[] = [];

  public static getInstance(): OpenFolderIconParamsManager {
    if (globalThis.OpenFolderIconParamsManagerInstance == null) {
      globalThis.OpenFolderIconParamsManagerInstance = new OpenFolderIconParamsManager();
    }
    return globalThis.OpenFolderIconParamsManagerInstance;
  }

  /**
   * 记录当前做了按压动效的icon
   *
   * @param iconData 图标数据类
   */
  public pushPressIconData(iconData: AppIconData) {
    this.mPressIconItems.push(iconData);
  }

  /**
   * 从记录中删除按压动效已复位的icon
   *
   * @param iconData 图标数据类
   */
  public deletePressIconData(iconData: AppIconData) {
    let findIndex = this.mPressIconItems.findIndex((item: AppIconData) => {
      return item === iconData;
    })
    if (findIndex !== -1) {
      this.mPressIconItems.splice(findIndex, 1);
    }
  }

  /**
   * 将记录中的所有图标icon的按压状态复位
   *
   */
  public clearPressEffect(): void {
    this.mPressIconItems.forEach((iconData: AppIconData) => {
      iconData.touchMaskVisible = false;
    })
    this.mPressIconItems.splice(0, this.mPressIconItems.length);
  }
}