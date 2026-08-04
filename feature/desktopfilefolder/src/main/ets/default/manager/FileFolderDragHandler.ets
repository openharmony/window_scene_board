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
import { LogDomain, Logger } from '@ohos/basicutils';
import { CommonConstants, FileType, GridLayoutItemInfo } from '@ohos/launchercommon';
import fileFolderManagerFactory from './FileFolderManagerFactory';
import FileFolderManager from './FileFolderManager';
import { FileFolderConstants } from '../common/FileFolderConstants'
import deviceInfo from '@ohos.deviceInfo';
import { DragDataType } from '@ohos/componentdrag';

const TAG = 'FileFolderDragHandler';
const log = Logger.getLogHelper(LogDomain.HOME);

export class FileFolderDragHandler {
  private static instance: FileFolderDragHandler;
  private fileFolderManager: FileFolderManager = fileFolderManagerFactory.getFileFolderManager();

  private constructor() {
  }

  public static getInstance(): FileFolderDragHandler {
    if (!FileFolderDragHandler.instance) {
      FileFolderDragHandler.instance = new FileFolderDragHandler();
    }
    return FileFolderDragHandler.instance;
  }

  /**
   * 文件（夹）是否支持覆盖落入
   * 文件夹或文件夹的快捷方式需支持覆盖落入
   * @param fileFolderInfo
   * @returns
   */
  public isSupportCover(dragItemInfo: GridLayoutItemInfo, coverItem: GridLayoutItemInfo): boolean {
    if (!this.isDragItemSupportCover(dragItemInfo)) {
      log.showInfo(TAG, `isSupportCover, dragItemInfo not support, typeID:${dragItemInfo.typeId}`);
      return false;
    }
    if (!this.isCoverItemSupportCover(coverItem)) {
      log.showInfo(TAG, `isSupportCover, coverItem not support, typeID:${coverItem.typeId}, ino:${coverItem.ino}`);
      return false;
    }
    return true;
  }

  /**
   * 拖拽元素是否支持落入文件夹，目前只有文件（夹）支持落入其它元素
   * @param dragItemInfo
   * @returns
   */
  private isDragItemSupportCover(dragItemInfo: GridLayoutItemInfo): boolean {
    return dragItemInfo.typeId === CommonConstants.TYPE_FILE_FOLDER;
  }

  /**
   * 被覆盖元素是否支持落入，目前文件夹或快捷方式文件夹支持被覆盖
   * @param coverItem
   * @returns
   */
  public isCoverItemSupportCover(coverItem: GridLayoutItemInfo): boolean {
    // 覆盖元素必须为文件或文件夹
    if (coverItem.typeId !== CommonConstants.TYPE_FILE_FOLDER) {
      return false;
    }
    // 文件夹支持落入覆盖
    if (coverItem.fileType === FileType.TYPE_FOLDER) {
      return true;
    }
    // 非快捷方式的普通文件不支持覆盖落入
    if (!this.fileFolderManager.isShortcutFile(coverItem)) {
      return false;
    }
    return this.fileFolderManager.getShortcutTargetFileType(coverItem) === FileType.TYPE_FOLDER;
  }

  /**
   * 拖拽过程中是否alt或ctrl按压
   * @param event
   * @returns
   */
  private isAltOrCtrlKeyDown(event: DragEvent): boolean {
    return this.isAltKeyDown(event) || this.isCtrlKeyDown(event);
  }

  private isAltKeyDown(event: DragEvent): boolean {
    let isAltKeyDown: boolean = false;
    if (event && event.getModifierKeyState) {
      isAltKeyDown = event.getModifierKeyState(['alt']);
    }
    log.showInfo(TAG, `isAltKeyDown: ${isAltKeyDown}`);
    return isAltKeyDown;
  }

  private isCtrlKeyDown(event: DragEvent): boolean {
    let isCtrlKeyDown: boolean = false;
    if (event && event.getModifierKeyState) {
      isCtrlKeyDown = event.getModifierKeyState(['ctrl']);
    }
    log.showInfo(TAG, `isCtrlKeyDown: ${isCtrlKeyDown}`);
    return isCtrlKeyDown;
  }

  private getExtraInfo(extraParams?: string): string {
    let extraInfo: string = '';
    if (extraParams) {
      let tempExtraInfo: string = '';
      try {
        tempExtraInfo = JSON.parse(extraParams).extraInfo;
      } catch (error) {
        log.showError(TAG, `get extra error ${error?.code}, ${error?.message}`);
      }
      if (tempExtraInfo !== undefined) {
        extraInfo = tempExtraInfo;
      }
    }
    return extraInfo;
  }

  /**
   * 是否拖拽创建文件(拖拽复制,拖拽创建快捷方式等)
   * @param event
   * @param extraParams
   * @returns
   */
  public isDragToCreateFile(event: DragEvent, extraParams?: string): boolean {
    const extraInfo = this.getExtraInfo(extraParams);
    const isDragFromSideBar = this.fileFolderManager.isDragFromSideBar(extraInfo);
    const isAltOrCtrlKeyDown = this.isAltOrCtrlKeyDown(event);
    log.showInfo(TAG, `isDragToCreateFile ${isAltOrCtrlKeyDown}, ${isDragFromSideBar}`);
    return isAltOrCtrlKeyDown || isDragFromSideBar;
  }

  /**
   * 是否拖拽显示落位框
   * @param extraInfo
   * @returns
   */
  public isNeedWhiteBox(extraInfo?: string): boolean {
    return this.isDragFromFileManager(extraInfo) || this.isDragFromHiSearch(extraInfo) ||
      this.isDragFromAnotherPc(extraInfo);
  }

  /**
   * 判断是否来自文管的拖拽
   * @param extraInfo
   * @returns
   */
  public isDragFromFileManager(extraInfo?: string): boolean {
    if (!extraInfo) {
      log.showError(TAG, 'isDragFromFileManager invalid extraInfo');
      return false;
    }
    return extraInfo.includes(FileFolderConstants.FROM_FILE_VIEW) ||
      extraInfo.includes(FileFolderConstants.FROM_USER_SIDEBAR) ||
      extraInfo.includes(FileFolderConstants.PHONE_FILE) ||
      this.fileFolderManager.isDragFromSideBar(extraInfo) ;
  }

  /**
   * 判断是否来另一台PC桌面的拖拽
   * @param extraInfo
   * @returns
   */
  public isDragFromAnotherPc(extraInfo?: string): boolean {
    if (!extraInfo) {
      log.showError(TAG, 'isDragFromAnotherPc invalid extraInfo');
      return false;
    }
    let extraInfoMap: Map<string, object> = new Map();
    try {
      extraInfoMap = JSON.parse(extraInfo) as Map<string, object>;
    } catch (error) {
      log.showError(TAG, `Failed to parse extraInfo message ${error?.message}, code ${error?.code}`);
    }
    log.showInfo(TAG, `drag data type ${extraInfoMap[FileFolderConstants.DRAG_DATA_TYPE]}`);
    if (extraInfoMap[FileFolderConstants.DRAG_DATA_TYPE] === DragDataType.PC_FILE  &&
      extraInfoMap[FileFolderConstants.DRAG_FROM_DEVICE_SN] !== deviceInfo.serial) {
      log.showInfo(TAG, 'is Drag From Another Pc');
      return true;
    }
    return false;
  }

  /**
   * 判断是否来自全搜的拖拽
   * @param extraInfo
   * @returns
   */
  public isDragFromHiSearch(extraInfo?: string): boolean {
    if (!extraInfo) {
      log.showError(TAG, 'isDragFromHiSearch invalid extraInfo');
      return false;
    }
    return extraInfo.includes(FileFolderConstants.HI_SEARCH);
  }

}