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
 */
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';

import { CommonConstants } from '../../constants/CommonConstants';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import GridLayoutUtil from '../../utils/GridLayoutUtil';
import { FolderItemStateData } from './FolderItemStateData';
import { FolderState } from '../common/FolderConstans';
import { BaseFolderState, } from '../state/BaseFolderState';
import { FolderItemAppData } from './FolderItemAppData';

const TAG = 'FolderDataModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * Item info of folders.
 */
export default class FolderDataModel {
  public folderId: string | undefined;
  public folderItemStateData: FolderItemStateData;
  public folderItemAppData: FolderItemAppData;
  private folderPageLoadState: boolean[] = [];

  constructor(item: GridLayoutItemInfo) {
    if (CheckEmptyUtils.isEmpty(item) || item.typeId !== CommonConstants.TYPE_FOLDER) {
      throw new Error('constructor error, item is not folder');
    }
    this.folderId = item.folderId;
    this.folderItemStateData = new FolderItemStateData(item);
    this.folderItemAppData = new FolderItemAppData(item);
    this.initPageLoadState(item);
  }

  /**
   * 获取文件夹布局信息
   *
   * @return GridLayoutItemInfo
   */
  public getFolderItem(): GridLayoutItemInfo {
    return this.folderItemAppData.getFolderItemAppData();
  }

  /**
   * 设置文件夹布局信息
   *
   */
  public setFolderItem(item: GridLayoutItemInfo): void {
    this.folderItemAppData.setFolderItemAppData(item);
    this.initPageLoadState(item);
  }

  /**
   * 获取文件夹当前状态
   * @return FolderState 获取文件夹当前状态
   */
  public getState(): FolderState {
    return this.folderItemStateData.getFolderState();
  }

  /**
   * 获取当前文件夹对应操作类
   * @return BaseFolderState 获取文件夹当前状态
   */
  public getStateContext(): BaseFolderState {
    return this.folderItemStateData.getFolderStateContext();
  }

  /**
   * 设置文件夹状态
   */
  public setFolderState(nextState: FolderState): void {
    this.folderItemStateData.setFolderState(nextState);
  }

  /**
   * 获取文件夹状态类
   * @return FolderItemStateData 设置文件夹状态
   */
  public getFolderItemStateData(): FolderItemStateData {
    return this.folderItemStateData;
  }

  /**
   * 判断是否是小文件夹
   * @return boolean 是否是小文件夹
   */
  public isSmallFolder(): boolean {
    return GridLayoutUtil.isSmallFolder(this.folderItemAppData.getFolderItemAppData());
  }

  /**
   * 是否需要预加载
   * @param index 预加载页索引
   * @returns 是否需要预加载
   */
  public needPreLoadPage(index: number): boolean {
    if (index < 0) {
      return false;
    }
    if (this.folderPageLoadState.length === 0 || index > this.folderPageLoadState.length - 1) {
      return false;
    }
    return !this.folderPageLoadState[index];
  }

  /**
   * 设置某页已加载
   * @param index 已加载页索引
   */
  public setPageLoaded(index: number): void {
    if (index < 0) {
      return;
    }
    if (this.folderPageLoadState.length === 0 || index > this.folderPageLoadState.length - 1) {
      return;
    }
    this.folderPageLoadState[index] = true;
  }

  private initPageLoadState(item: GridLayoutItemInfo): void {
    this.folderPageLoadState = [];
    if (item && item.layoutInfo) {
      for (let i = 0; i < item.layoutInfo.length; i++) {
        this.folderPageLoadState.push(false);
      }
    }
  }
}
