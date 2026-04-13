/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
 *
 * 文件夹状态对应操作类基类，定义基本的文件夹操作，在子类状态类中根据需要覆写对应的文件夹业务流程入口函数
 */

import { LogDomain, LogHelper, } from '@ohos/basicutils';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';

const TAG = 'BaseFolderState';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class BaseFolderState {
  constructor() {
  }

  /**
   * 点击打开文件夹
   *
   */
  public clickOpenSmallFolder(event: ClickEvent, folderId: string): void {
    log.showDebug(`baseState clickOpenSmallFolder`);
  }

  /**
   * 点击关闭小文件夹
   *
   */
  public clickCloseSmallFolder(folderId: string): void {
    log.showDebug(`baseState clickCloseSmallFolder`);
  }

  /**
   * 点击打开大文件夹
   *
   */
  public clickCloseBigFolder(folderId: string): void {
    log.showDebug(`baseState clickCloseBigFolder`);
  }

  /**
   * 拖入应用到文件夹中
   *
   */
  public dragEnterFolderApp(folderId: string, item: GridLayoutItemInfo): void {
    log.showDebug(`baseState dragEnterFolderApp`);
  }

  /**
   * 拖出文件夹中应用
   *
   */
  public dragLeaveFolderApp(folderId: string, item: GridLayoutItemInfo): void {
    log.showDebug(`baseState dragLeaveFolderApp`);
  }

  /**
   * 文件夹重命名
   *
   */
  public reNameFolder(folderId: string, name: string): void {
    log.showDebug(`baseState renameFolder`);
  }

  /**
   * 小文件夹转大文件夹
   *
   */
  public convertToBigFolder(folderId: string, name: string): void {
    log.showDebug(`baseState convertToBigFolder`);
  }

  /**
   * 大文件夹转小文件夹
   *
   */
  public convertToSmallFolder(folderId: string, name: string): void {
    log.showDebug(`baseState convertToSmallFolder`);
  }

}

