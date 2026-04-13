/**
 * Copyright (c) 2023-2023 Huawei Device Co., Ltd.
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

import { CheckEmptyUtils, LogDomain, LogHelper, ObjUtil } from '@ohos/basicutils';
import { GridLayoutItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';

const TAG = 'FileInfoUpdateManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

class FileInfoUpdateManager {
  private static instance: FileInfoUpdateManager;
  private mFileItemListeners: Map<string, FileInfoUpdateListener> = new Map();
  public iconChangeCallback: Callback<string[]>[] = [];

  static getInstance(): FileInfoUpdateManager {
    if (!FileInfoUpdateManager.instance) {
      log.showInfo('get instance init');
      FileInfoUpdateManager.instance = new FileInfoUpdateManager();
    }
    return FileInfoUpdateManager.instance;
  }

  /**
   * 注册文件监听
   * @param key
   * @param listener
   */
  public registerListener(key: string, listener: FileInfoUpdateListener): void {
    log.showInfo('registerListener');
    if (ObjUtil.isInvalid(listener)) {
      log.showInfo('listener param error');
    }
    if (this.mFileItemListeners.has(key)) {
      log.showWarn(`registerListener mFileItemListeners conflict. key = ${key}`);
      if (this.mFileItemListeners.get(key) !== listener) {
        this.mFileItemListeners.get(key)?.unRegisterFileFolderEvent();
      }
    }
    listener?.registerFileFolderEvent();
    this.mFileItemListeners.set(key, listener);
  }

  /**
   * 取消注册监听
   * @param key
   */
  public unRegisterListener(key: string, listener?: FileInfoUpdateListener): void {
    if (!this.mFileItemListeners.has(key)) {
      log.showWarn(`unRegisterListener mFileItemListeners not exist. key = ${key}`);
      return;
    }
    if (listener && (this.mFileItemListeners.get(key) !== listener)) {
      log.showWarn('unRegisterListener, not same listener');
      return;
    }
    this.mFileItemListeners.get(key)?.unRegisterFileFolderEvent();
    this.mFileItemListeners.delete(key);
  }

  /**
   * 通知当前列表的文件刷新
   * @param updatedFileItems
   */
  public dispatchFileInfoUpdate(updatedFileItems: GridLayoutItemInfo[]): void {
    if (updatedFileItems === undefined || updatedFileItems === null) {
      log.showWarn('dispatchFileInfoUpdate no items');
      return;
    }
    updatedFileItems.forEach(element => {
      log.showDebug(`dispatchFileInfoUpdate this key already register: ${this.mFileItemListeners.has(element.ino)}`);
      this.mFileItemListeners.get(element.ino ?? '')?.onFileInfoUpdated(element);
    });
    log.showInfo(`dispatchFileInfoUpdate itemLength:${updatedFileItems.length}`);
  }

  public registerIconChangeListener(callback: Callback<string[]>): void {
    if (this.iconChangeCallback.indexOf(callback) === -1) {
      this.iconChangeCallback.push(callback);
    }
  }

  public unregisterIconChangeListener(callback: Callback<string[]>): void {
    const index = this.iconChangeCallback.indexOf(callback);
    if (index !== -1) {
      this.iconChangeCallback.splice(index, 1);
    }
  }

  /**
   * 通知文件类型为xxx的图标更新
   * @param updatedFileItems
   */
  public dispatchFileIconUpdateByUtdType(utdType: string[]): void {
    if (CheckEmptyUtils.isEmptyArr(utdType)) {
      log.showWarn('dispatchFileIconUpdate no items');
      return;
    }
    log.showInfo(`dispatchFileIconUpdate, utdType:${utdType}, item length:${this.iconChangeCallback.length}`);
    this.iconChangeCallback.forEach(callback => callback(utdType));
  }

  /**
   * 通知当前文件已完成压缩,取消置灰不可操作状态
   * @param ino
   */
  public refreshCompressStatus(ino: string): void {
    if (ino) {
      log.showDebug(`refreshCompressStatus ino: ${ino}, this key already register: ${this.mFileItemListeners.has(ino)}`);
      this.mFileItemListeners.get(ino)?.refreshComPressStatus();
    }
  }
}

export interface FileInfoUpdateListener {
  onFileInfoUpdated(item?: GridLayoutItemInfo): void;
  refreshComPressStatus(): void;
  registerFileFolderEvent(): void;
  unRegisterFileFolderEvent(): void;
}

const fileInfoUpdateManager = FileInfoUpdateManager.getInstance();
export default fileInfoUpdateManager;