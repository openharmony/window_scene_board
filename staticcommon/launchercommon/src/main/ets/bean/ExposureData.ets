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

import { LogDomain, Logger } from '@ohos/basicutils';
import type { CardItemInfo } from './CardItemInfo';

const MAX_COUNT: number = 100;
const TAG: string = 'ExposureManager';
const log: Logger = Logger.getLogHelper(LogDomain.SCB);

/**
 * ExposureData
 */
export class ExposureData {
  private folderExposureDataList: FolderExposureData[] = [];
  private desktopExposureDataList: DesktopExposureData[] = [];
  private stackExposureDataList: StackExposureData[] = [];
  constructor() {
  }

  /**
   * 获取文件夹曝光数据
   * @returns
   */
  public getFolderExposureDataList(): FolderExposureData[] {
    return this.folderExposureDataList;
  }

  /**
   * 插入文件夹曝光数据
   * @param newFolderData
   * @returns
   */
  public insertFolderExposureDataList(newFolderData: FolderExposureData): void {
    if (this.folderExposureDataList.length >= MAX_COUNT) {
      const dropItem: FolderExposureData = this.folderExposureDataList.shift()!;
      log.showWarn(TAG, `folderExposureDataList up to max, drop item id: ${dropItem.id}`);
    }
    this.folderExposureDataList.push(newFolderData);
    log.showWarn(TAG, `folderExposureDataList lengh: ${this.folderExposureDataList.length}`);
  }

  /**
   * 获取桌面曝光数据
   * @returns
   */
  public getDesktopExposureDataList(): DesktopExposureData[] {
    return this.desktopExposureDataList;
  }

  /**
   * 插入桌面曝光数据
   * @param newDesktopData
   * @returns
   */
  public insertDesktopExposureDataList(newDesktopData: DesktopExposureData): void {
    this.desktopExposureDataList.push(newDesktopData);
  }

  /**
   * 获取堆叠曝光数据
   * @returns
   */
  public getStackExposureDataList(): StackExposureData[] {
    return this.stackExposureDataList;
  }

  /**
   * 插入堆叠曝光数据
   * @param newStackData
   * @returns
   */
  public insertStackExposureDataList(newStackData: StackExposureData): void {
    if (this.stackExposureDataList.length >= MAX_COUNT) {
      const dropItem: StackExposureData = this.stackExposureDataList.shift()!;
      log.showWarn(TAG, `stackExposureDataList up to max, drop item id: ${dropItem.id}`);
    }
    this.stackExposureDataList.push(newStackData);
    log.showWarn(TAG, `stackExposureDataList lengh: ${this.stackExposureDataList.length}`);
  }

  /**
   * 重置曝光数据
   * @returns
   */
  public resetData(): void {
    this.desktopExposureDataList = [];
    this.folderExposureDataList = [];
    this.stackExposureDataList = [];
  }
}

interface Coordinate { column?: number, row?: number }

interface BaseExposureData {
  id?: string;
  exposureTime: number;
  exposureCount: number;
  desktopPageIndex: number;
  coordinate?: Coordinate,
}

interface BaseFolderData {
  folderId: string,
  folderName: string,
  coordinate?: Coordinate,
  isBigFolder: boolean
}

export interface FolderApp { bundleName: string, coordinate: Coordinate }

export interface DesktopExposureData extends BaseExposureData {
  desktopAppInfoList: DesktopAppInfo[],
  desktopFolderInfoList: DesktopFolderInfo[],
  desktopCardInfoList: DesktopCardInfo[],
  desktopStackInfoList: DesktopStackInfo[],
}

export interface FolderExposureData extends BaseExposureData, BaseFolderData {
  pageIndex: number,
  folderAppList: FolderApp[],
}

export interface StackExposureData extends BaseExposureData {
  cardList: string[],
}

export interface DesktopAppInfo {
  bundleName: string,
  coordinate: Coordinate,
  station: String,
}

export interface DesktopFolderInfo extends BaseFolderData {
  bigFolderDisplayAppList: string[],
  station: string,
}

export interface DesktopCardInfo {
  cardName: string,
  coordinate: Coordinate,
}

export interface DesktopStackInfo {
  coordinate: Coordinate,
  cardList: string[],
}

export interface FormStackInfo {
  formStackId: string | undefined;
  page: number;
  layoutInfo: CardItemInfo[][];
  column: number;
  row: number;
}