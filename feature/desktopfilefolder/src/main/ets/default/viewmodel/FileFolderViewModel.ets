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
import { LogDomain, Logger, RectInfo } from '@ohos/basicutils';
import { FileType, GridLayoutItemInfo, CommonConstants, BaseViewModel } from '@ohos/launchercommon';
import FileFolderManagerFactory from '../manager/FileFolderManagerFactory';
import FileFolderManager from '../manager/FileFolderManager';
import { FileFolderDragHandler } from '../manager/FileFolderDragHandler';
import { MenuInfo, } from '@ohos/launchercommon';
import { FileFolderInfo } from '../model/FileFolderInfo';
import { ItemUtils } from '@ohos/componenthelper';

const TAG = 'FileFolderViewModel';
const log = Logger.getLogHelper(LogDomain.HOME);

export class FileFolderViewModel {
  private fileFolderInfo: GridLayoutItemInfo;
  private fileFolderManager: FileFolderManager = FileFolderManagerFactory.getFileFolderManager();

  constructor(fileFolderLayoutInfo: GridLayoutItemInfo) {
    this.fileFolderInfo = fileFolderLayoutInfo;
  }

  public isShortcut(): boolean {
    return this.fileFolderManager.isShortcutFile(this.fileFolderInfo);
  }

  /**
   * 是否支持文件落入当前文件或文件夹
   * @returns
   */
  public isSupportDropFile(): boolean {
    return FileFolderDragHandler.getInstance().isCoverItemSupportCover(this.fileFolderInfo);
  }

  /**
   * 获取文件（夹）的目标路径，文件、文件夹为当前uri，快捷方式为映射的源文件（夹）uri
   * @returns
   */
  public getTargetUri(): string | undefined {
    if (!this.isShortcut()) {
      return this.fileFolderInfo.uri;
    }
    return this.fileFolderManager.getShortCutTargetUri(this.fileFolderInfo.uri);
  }

  /**
   * 获取快捷方式映射的文件类型
   * @returns
   */
  public getShortcutType(): FileType | undefined {
    return this.fileFolderManager.getShortcutTargetFileType(this.fileFolderInfo);
  }

  /**
   * 判断快捷方式映射的对象是否为文件夹
   * @returns
   */
  public isFolderShortcut(): boolean {
    return this.isShortcut() && this.getShortcutType() === FileType.TYPE_FOLDER;
  }

  /**
   * 获取缓存的略缩图路径
   * @param withMtime
   * @returns
   */
  public getThumbnailPath(): string {
    return this.getThumbnailPathInner(this.getTargetUri() ?? '', '');
  }

  /**
   * 获取缓存的略缩图路径
   * @param withMtime
   * @returns
   */
  public getThumbnailPathWithMtime(): string {
    let fileFolderInfo: FileFolderInfo | undefined = undefined;
    // 快捷方式使用映射的文件（夹）图标
    if (this.isShortcut()) {
      fileFolderInfo = this.fileFolderManager.getTargetInfoByShortcutUri(this.fileFolderInfo.uri);
    } else {
      fileFolderInfo = this.fileFolderManager.getFileInfoByUri(this.fileFolderInfo.uri);
    }
    const mtimeMs = fileFolderInfo?.mtimeMs ? fileFolderInfo.mtimeMs.toString() : '';
    log.showInfo(TAG, `getThumbnailPath, mtimeMs:${mtimeMs}, ino:${this.fileFolderInfo.ino}`);
    return this.getThumbnailPathInner(fileFolderInfo?.uri ?? '', mtimeMs);
  }

  /**
   * 根据文件（夹）路径，解析获取不同来源的略缩图路径
   * @param fileFolderUri
   * @param mtime
   * @returns
   */
  private getThumbnailPathInner(fileFolderUri: string, mtime: string): string {
    let suffix = '?filemanager?';
    if (fileFolderUri.startsWith('file://media')) { //媒体库
      suffix = '?oper=astc';
    }
    return `${fileFolderUri}${suffix}${mtime}`;
  }

  /**
   * 获取文件文件夹的菜单项
   * @returns
   */
  public getMenuInfoList(selectItems: string[] | undefined): MenuInfo[] {
    if (selectItems === undefined) {
      log.showWarn(TAG, 'invalid selectItems');
      return [] as MenuInfo[];
    }
    return this.fileFolderManager.getRightMenuInfo(
      this.fileFolderInfo.uri,
      selectItems,
      this.fileFolderInfo.page ?? 0
    );
  }

  public getTextAreaMaxHeight(containerBelong: GridLayoutItemInfo | undefined): number {
    const nameTop: number = ItemUtils.getRectById(this.getFileFolderNameId()).top;
    if (containerBelong && containerBelong.typeId === CommonConstants.TYPE_REGION_FOLDER) {
      const regionFolderRect: RectInfo = ItemUtils.getRectById(containerBelong.componentId);
      const availableHeight = regionFolderRect.top + (regionFolderRect.height ?? 0) - nameTop;
      log.showInfo(TAG, `getTextAreaMaxHeight in RegionFolder, availableHeight: ${availableHeight} ${JSON.stringify(regionFolderRect)}`);
      return availableHeight;
    }
    const availableHeight = this.fileFolderManager.getTextAreaAvailableHeight(nameTop);
    log.showInfo(TAG, `getTextAreaMaxHeight ${this.fileFolderInfo.ino} ${nameTop} ${availableHeight}`);
    return availableHeight;
  }

  public isCrossOverBelongContainerBottom(containerBelong: GridLayoutItemInfo | undefined,
    containerViewModel?: BaseViewModel): boolean {
    if (!containerBelong) {
      log.showInfo(TAG, `isCrossBelongContainerBottom invalid containerBelong`);
      return false;
    }
    if (containerViewModel && containerBelong.typeId === CommonConstants.TYPE_REGION_FOLDER) {
      const fileFolderGridItemId = containerViewModel.getContainerGridItemId(this.fileFolderInfo);
      const gridItemTop: number = ItemUtils.getRectById(fileFolderGridItemId).top;
      const gridItemBottom: number = ItemUtils.getRectById(fileFolderGridItemId).bottom;
      const containerBottom: number = ItemUtils.getRectById(containerBelong.componentId).bottom;
      log.showInfo(TAG, `isCrossBelongContainerBottom in RegionFolder, \r\n
        gridItemTop: ${gridItemTop}, gridItemBottom: ${gridItemBottom}, containerBottom: ${containerBottom}`);
      return gridItemTop < containerBottom && containerBottom < gridItemBottom ? true : false;
    }
    return false;
  }

  public scrollToShowFullyInBelongContainer(containerBelong: GridLayoutItemInfo | undefined,
    containerViewModel?: BaseViewModel): void {
    if (!containerBelong) {
      log.showInfo(TAG, `scrollToShowFullyInBelongContainer invalid containerBelong`);
      return;
    }
    if (containerViewModel && containerBelong.typeId === CommonConstants.TYPE_REGION_FOLDER) {
      log.showInfo(TAG, `scrollDownToShowGridItemFully TYPE_REGION_FOLDER`);
      containerViewModel.scrollDownToShowGridItemFully(this.fileFolderInfo);
    }
  }

  public getFileFolderNameId(): string {
    return `FileFolderComponent_FileName_${this.fileFolderInfo.ino}`;
  }
}