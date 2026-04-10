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
import common from '@ohos.app.ability.common';
import type { BusinessError } from '@ohos.base';
import fileuri from '@ohos.file.fileuri';
import fs from '@ohos.file.fs';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { StartType } from '@ohos/basicutils';
import { CloseAppManager } from '@ohos/launchercommon/src/main/ets/manager/CloseAppManager';

const TAG: string = 'PcFileAccess';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
type DesktopFileQueryCallback = (result: ESObject[]) => void;

export default class PcFileAccess {

  /**
   * desktop root path
   */
  public static desktopPath: string = '';

  private static context: common.Context;

  /**
   * mainScreen displayId
   */
  private static displayId: number = 0;

  public static setDisplayId(displayId: number): void {
    log.showInfo('setDisplayId: ' + displayId);
    PcFileAccess.displayId = displayId;
  }

  /**
   * copy file
   * @param uris uris uris to be copy
   * @returns
   */
  public static async copyFile(uris: string[]): Promise<void> {
    log.showInfo('copyFile: ' + uris?.length);
    // await FileOperation.copyFile(uris, PcFileAccess.desktopPath);
  }

  /**
   * cut file
   * @param uris uris uris uris to be copy
   * @returns
   */
  public static async cutFile(uris: string[]): Promise<void> {
    log.showInfo('cutFile: ' + uris?.length);
    // return await FileOperation.cutFile(uris, PcFileAccess.desktopPath);
  }

  /**
   * 清空剪切板内容
   */
  public static clearPasteboard(): void {
    log.showInfo('clearPasteBoard');
    /*PasteBoardUtil.clearPasteData().catch((err?: BusinessError) => {
        log.showInfo(`clearPasteBoard, errCode:${err?.code}, errMessage:${err?.message}`);
      })*/
  }

  /**
   * paste file
   * @param uris uris uris uris to be paste
   * @returns
   */
  public static async pasteFile(dest: string, isShortCut?: boolean): Promise<void> {
    log.showInfo(`pasteFile, isShortCut: ${isShortCut}`);
    // return await FileOperation.paste(dest, PcFileAccess.displayId, isShortCut);
  }

  /**
   * rename file
   * @param uris uris uris uris to be rename
   * @returns uri of renamed file
   */
  public static async rename(uri: string, fileName: string, isShowSuffix?: boolean): Promise<string> {
    log.showInfo(`rename desktop file or folder, isShowSuffix:${isShowSuffix}`);
    // return await FileOperationUtil.renameWithDialog(uri, fileName, UnityStartMode.DESKTOP_FILE_START, isShowSuffix);
    return '';
  }

  public static async renameNoCheckNoHistory(srcUri: string, fileName: string): Promise<string> {
    // let fileInfo: ESObject = FileInfo.fromFileUriDesktop(srcUri);
    /*const result = await FileOperation.rename(fileInfo, fileName, false);
    if (result instanceof Error || !result) {
      log.error('renameNoCheckNoHistory error:', result);
      return '';
    }*/
    // return fileInfo.uri;
    return '';
  }

  /**
   * listen folder change
   * @param uris uris uris uris to be listen
   * @returns
   */
  public static listenFolder(uri: string, callBack: (result: ESObject[]) => void,
    context?: common.Context | undefined) {
    // FileOperation.listenFolder(uri, callBack, false, context);
  }

  /**
   * stop listen folder
   * @param uri uri to be stop
   * @returns
   */
  public static stopListenFolder(uri: string): void {
    // FilesQueryTaskUtil.stopListen(uri);
  }

  /**
   * 获取菜单显示列表
   * @param info 右键菜单文件
   * @param menuGroup 右键菜单组
   * @returns
   */
  public static getShowMenuItem(info: ESObject, menuGroup: ESObject[][]): number {
    // return RightMenuViewUtils.getRightMenuItems(info, menuGroup);
    return 0;
  }

  /**
   * 右键菜单点击事件
   * @param index
   * @param rightMenuInfo
   */
  public static menuClick(index: number, rightMenuInfo: ESObject): void {
    // RightMenuViewUtils.onClickEvent(index, rightMenuInfo, PcFileAccess.displayId);
  }

  /**
   * 注册 统一图标 变化监听
   * @param callback
   */
  public static registerIconChangeListener(callback: Callback<string[]>): void {
    try {
      // ThumbnailUtil.registerIconChange(callback);
    } catch (e) {
      log.showWarn(`registerIconChangeListener fail, errCode:${e?.code}, errMsg:${e?.message}`);
    }
  }

  /**
   * 通过后缀名获取utdType
   * @param suffix
   * @returns
   */
  public static getUtdTypeBySuffix(suffix: string): string {
    try {
      // return ThumbnailUtil.getUtdTypeIdBySuffix(suffix);
    } catch (err) {
      log.showWarn(`getUtdTypeBySuffix fail, suffix:${suffix}, errCode:${err?.code}, errMsg:${err?.message}`);
    }
    return '';
  }
  /**
   * set context for next file operation
   * @param context context
   */
  public static setContext(context: common.Context): void {
    PcFileAccess.context = context;
    // return CommonUtil.init(context, 'DesktopFile');
  }

  /**
   * get desktop path
   * @returns desktop path
   */
  public static async getDesktop(): Promise<string> {
    log.showInfo('getDesktop');
    if (PcFileAccess.desktopPath === '') {
      // PcFileAccess.desktopPath = await FilesQueryTaskUtil.getDesktop();
    }
    return PcFileAccess.desktopPath;
  }

  /**
   * get all file object on desktop
   * @param uri desktop path
   * @param callback query callback
   * @returns
   */
  public static async listFilesOfFolder(uri: string, callback: DesktopFileQueryCallback): Promise<void> {
    log.showInfo('listFilesOfFolder');
    // let currentAddressData: AddressData = new AddressData(uri);
    // FilesQueryTaskUtil.listFilesOfFolder(currentAddressData, callback);
  }

  /**
   * openFile only
   * @param uri uri
   */
  public static async openFile(uri: string): Promise<void> {
    /*let fileInfo: FileInfo = FileInfo.fromFileUriDesktop(uri);
    CloseAppManager.getInstance().setStartAppType(StartType.FILE_FOLDER);
    log.showInfo(`pcFileAccess openFile, ino:${fileInfo.ino}`);*/
    /*FileOperation.openFileOrFolder(fileInfo, true).catch((err?: BusinessError) => {
      log.showWarn(`openFileOrFolder error, errCode:${err?.code}, errMessage:${err?.message}`);
    });*/
  }

  /**
   * mkDir
   * @param uri uri
   */
  public static async mkDir(uri: string, isRegisterHistory: boolean = true): Promise<string | BusinessError<void>> {
    log.showInfo('pcFileAccess mkDir');
    // return await FileOperation.buildNewFolder(uri, isRegisterHistory);
    return '';
  }

  /**
   * delete file or folder
   * @param uris uris to be delete
   * @param isForceDelete whether the files need to be delete in force
   * @returns delete result
   */
  public static delete(uris: string[], isForceDelete: boolean = false,
    isRegisterHistory: boolean = true): number | BusinessError {
    log.showInfo('delete: ' + uris?.length);
    if (!uris || uris.length === 0) {
      return 0;
    }
    if (isForceDelete) {
      // FileOperationUtil.forceDeleteWithDialog(uris, true);
    } else {
      // FileOperation.deleteFile(uris, false, undefined, isRegisterHistory);
    }
    return 0;
  }

  /**
   * 文件是否存在
   * @param uri 路径
   * @returns
   */
  public static isFileExists(uri: string): boolean {
    if (!uri || uri === '') {
      log.showInfo('params undefined');
      return false;
    }
    try {
      let fileUri: fileuri.FileUri = new fileuri.FileUri(uri);
      let stat: fs.Stat = fs.statSync(fileUri.path);
      if (stat) {
        return true;
      }
    } catch (err) {
      log.showInfo(`isFileExists fail: ${err?.code} ${err?.message}`);
      return false;
    }
    return false;
  }

  public static doRevoke(): void {
    log.showInfo('doRevoke');
    try {
      // FileOperationUtil.undo();
    } catch (err) {
      log.showError(`doRevoke failed: ${err?.code} ${err?.message}`);
    }
  }

  public static doReverseRevoke(): void {
    log.showInfo('doReverseRevoke');
    try {
      // FileOperationUtil.redo();
    } catch (err) {
      log.showError(`doReverseRevoke failed: ${err?.code} ${err?.message}`);
    }
  }

  public static async moveFile(srcUri: string, destUri: string): Promise<string> {
    return '';
    /*if (CommonUtils.isEmpty(srcUri) || CommonUtils.isEmpty(destUri)) {
      log.error('moveFile fail, invalid args');
      return '';
    }
    const srcInfo = FileInfo.fromFileUriDesktop(srcUri);
    const destInfo = FileInfo.fromFileUriDesktop(destUri);
    let destPath = destInfo.relativePath + '/' + srcInfo.fileName;
    let res: void | BusinessError = undefined;
    if (srcInfo.isFolder) {
      res = await FsUtil.moveDir(srcInfo.relativePath, destInfo.relativePath, 1); // mode是1：移动时存在重名文件夹时进行合并
    } else {
      res = await FsUtil.moveFile(srcInfo.relativePath, destPath);
    }
    if (res instanceof Error) {
      log.error('moveFile fail, error:', res);
      return '';
    }
    let result = FileUtil.getUriFromPath(destPath);
    return result;*/
  }

  public static notifyFolderRefresh(folderUris: string[]): void {
    if (CommonUtils.containerIsEmpty(folderUris)) {
      log.showError('notifyFolderRefresh fail, folderUris is empty');
      return;
    }
    // FileOperation.notifyFolderRefresh(folderUris);
  }

  /**
   * 解析菜单项图标资源
   * @param menuInfo
   * @returns
   */
  public static parseMenuIcon(menuInfo: ESObject): Resource | PixelMap | undefined {
    try {
      // return RightMenuViewUtils.parseNewFileMenuIcon(menuInfo, GlobalHolder.getInstance().getCommonContext());
    } catch (e) {
      log.showWarn(`parseFileIcon error, errCode:${e?.code} errMsg:${e?.message}, bundleName:${menuInfo.bundleName}, moduleHapName:${menuInfo.moduleName}`);
    }
    return undefined;
  }

  /**
   * 获取支持新建的菜单项信息
   * @returns
   */
  public static getNewFileSupportList(): ESObject[] {
    let supportMenuInfos: ESObject[] = [];
    try {
      // supportMenuInfos = RightMenuExpandManager.getInstance().getNewFileSupportList();
    } catch (e) {
      log.showWarn(`getNewFileSupportList, errCode:${e?.code}, errMsg:${e?.message}`);
    }
    log.showInfo(`getNewFileSupportList, menu length:${supportMenuInfos.length}`);
    return supportMenuInfos;
  }
}

export enum FileObservedChangeEvent {
  // 文件内容被修改
  IN_MODIFY = 0x2,
  // 文件元数据被修改
  IN_ATTRIB = 0x4,
  // 文件在打开时进行了写操作，然后被关闭
  IN_CLOSE_WRITE = 0x8,
  // 监听目录中文件被移动走
  IN_MOVED_FROM = 0x40,
  // 自定义重命名事件
  IN_RENAME = 0x60,
  // 监听目录中文件被移动过来
  IN_MOVED_TO = 0x80,
  // 监听目录中文件或子目录被创建
  IN_CREATE = 0x100,
  // 监听目录中文件或子目录被删除
  IN_DELETE = 0x200
}

export enum FileEventStatus {
  ABORT = -1,
  START = 0,
  COMPLETED = 1,
  RUNNING = 2,
  CANCEL = 3
}

export enum FileEventAction {
  CUT = 'cut',
  COPY = 'copy',
  UNKNOWN = 'unknown',
  /**
   * 压缩
   */
  COMPRESS = 'compress',
  /**
   * 解压缩
   */
  DECOMPRESS = 'decompress',
}