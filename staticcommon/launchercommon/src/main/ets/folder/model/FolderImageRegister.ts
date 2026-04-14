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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { FolderData } from '../../TsIndex';

const TAG = 'FolderImageRegister';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 小文件夹图片相关回调注册器
 */
export class FolderImageRegister {
  /** 回调集合 */
  private callBackList: FolderImageCallback[] = [];

  private static _instance: FolderImageRegister;

  private constructor() {
  }

  /** 单例 */
  static getInstance(): FolderImageRegister {
    if (FolderImageRegister._instance == null) {
      log.showInfo('create folderImageRegister');
      FolderImageRegister._instance = new FolderImageRegister();
    }
    return FolderImageRegister._instance;
  }

  /**
   * 注册回调
   *
   * @param folderCallBack 文件夹回调封装对象
   */
  public registerCallBack(folderCallBack: FolderImageCallback): void {
    if (folderCallBack.folderId == null) {
      log.showInfo('register folder image callback for all folder');
    }
    this.callBackList.push(folderCallBack);
  }

  /**
   * 根据id反注册函数对应的回调
   *
   * @param moduleName 注册事件时的文件夹回调封装对象
   */
  public unregisterCallBack(cb: FolderImageCallback): void {
    let index = this.callBackList.findIndex((item) => {
      return item === cb;
    });
    if (index > -1) {
      this.callBackList.splice(index, 1);
    }
  }

  /**
   * 通知刷新截图
   */
  public notifyImageRefresh(): void {
    let callbacks: FolderImageCallback[] = this.callBackList.slice();
    callbacks.forEach((item) => {
      let openedFolderId: string = FolderData.getInstance().getOpenFolderId();
      log.showInfo(`notifyImageRefresh folderId:${item.folderId} openedFolderId:${openedFolderId}`);
      if (item.folderId === openedFolderId) {
        try {
          item.refreshImageCallback?.();
        } catch (err) {
          log.showError(`notifyImageRefresh err folderId:${item.folderId} ${err?.toString?.()}`);
        }
      }
    });
  }

  /**
   * 通知特定小文件夹刷新截图
   */
  public notifyImageRefreshByFolderId(folderId: string): void {
    let callbacks: FolderImageCallback[] = this.callBackList.slice();
    callbacks.forEach((item) => {
      log.showInfo(`notifyImageRefresh folderId:${item.folderId} `);
      if (item.folderId === folderId) {
        try {
          log.showInfo(`notifyImageRefresh folderId:${item.folderId} `);
          item.refreshImageCallback?.();
        } catch (err) {
          log.showError(`notifyImageRefresh err folderId:${item.folderId} ${err?.toString?.()}`);
        }
      }
    });
  }
}

/**
 * 小文件夹图片处理回调
 */
export interface FolderImageCallback {
  /* 文件夹Id */
  folderId?: string;

  /* 刷新截图回调 */
  refreshImageCallback?: () => void;
}
