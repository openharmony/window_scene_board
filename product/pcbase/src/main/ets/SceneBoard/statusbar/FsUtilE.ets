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
import type { BusinessError } from '@ohos.base';
import fs from '@ohos.file.fs';
import fileuri from '@ohos.file.fileuri';
import type uri from '@ohos.uri';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'FsUtil';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);


export class FsUtil {
  private static readonly FILENOTEXIST: number = 13900002;

  public static async stat(file: string | number): Promise<fs.Stat | BusinessError> {
    try {
      return await fs.stat(file);
    } catch (error) {
      log.error(TAG, 'fs stat error = ' + JSON.stringify(error));
      return error;
    }
  }

  public static statSync(file: string | number): fs.Stat | BusinessError {
    try {
      return fs.statSync(file);
    } catch (error) {
      log.error(TAG, 'fs statSync error = ' + JSON.stringify(error));
      return error;
    }
  }

  public static async access(path: string): Promise<boolean | BusinessError> {
    try {
      return await fs.access(path);
    } catch (error) {
      log.error(TAG, 'fs access error = ' + JSON.stringify(error));
      return error;
    }
  }

  public static accessSync(path: string): boolean | BusinessError {
    try {
      return fs.accessSync(path);
    } catch (error) {
      log.error(TAG, 'fs accessSync error = ' + JSON.stringify(error));
      return error;
    }
  }

  public static async close(file: number | fs.File): Promise<void | BusinessError> {
    try {
      return await fs.close(file);
    } catch (error) {
      log.error(TAG, 'fs close error = ' + JSON.stringify(error));
      return error;
    }
  }

  public static closeSync(file: number | fs.File): void | BusinessError {
    try {
      return fs.closeSync(file);
    } catch (error) {
      log.error(TAG, 'fs closeSync error = ' + JSON.stringify(error));
      return error;
    }
  }

  public static async mkdir(path: string, recursion: boolean = false): Promise<void | BusinessError> {
    try {
      return await fs.mkdir(path, recursion);
    } catch (error) {
      log.error(TAG, 'fs mkdir error = ' + JSON.stringify(error));
      return error;
    }
  }

  public static mkdirSync(path: string, recursion: boolean = false): void | BusinessError {
    try {
      return fs.mkdirSync(path, recursion);
    } catch (error) {
      log.error(TAG, 'fs mkdirSync error = ' + JSON.stringify(error));
      return error;
    }
  }

  public static async rmdir(path: string): Promise<void | BusinessError> {
    try {
      return await fs.rmdir(path);
    } catch (error) {
      log.error(TAG, 'fs rmdir error = ' + JSON.stringify(error));
      return error;
    }
  }

  public static rmdirSync(path: string): void | BusinessError {
    try {
      return fs.rmdirSync(path);
    } catch (error) {
      log.error(TAG, 'fs rmdirSync error = ' + JSON.stringify(error));
      return error;
    }
  }

  public static async moveFile(src: string, dest: string, mode?: number): Promise<void | BusinessError> {
    try {
      return await fs.moveFile(src, dest, mode);
    } catch (error) {
      log.error(TAG, 'fs moveFile error = ' + JSON.stringify(error));
      return error;
    }
  }

  public static async moveDir(src: string, dest: string, mode?: number): Promise<void | BusinessError> {
    try {
      return await fs.moveDir(src, dest, mode);
    } catch (error) {
      log.error(TAG, 'fs moveDir error = ' + JSON.stringify(error));
      return error;
    }
  }

  public static moveFileSync(src: string, dest: string, mode?: number): void | BusinessError {
    try {
      return fs.moveFileSync(src, dest, mode);
    } catch (error) {
      log.error(TAG, 'fs moveFileSync error = ' + JSON.stringify(error));
      return error;
    }
  }

  public static moveDirSync(src: string, dest: string, mode?: number): void | BusinessError {
    try {
      return fs.moveDirSync(src, dest, mode);
    } catch (error) {
      log.error(TAG, 'fs moveDirSync error = ' + JSON.stringify(error));
      return error;
    }
  }

  public static async rename(oldPath: string, newPath: string): Promise<void | BusinessError> {
    try {
      return await fs.rename(oldPath, newPath);
    } catch (error) {
      log.error(TAG, 'fs rename error = ' + JSON.stringify(error));
      return error;
    }
  }

  public static renameSync(oldPath: string, newPath: string): void | BusinessError {
    try {
      return fs.renameSync(oldPath, newPath);
    } catch (error) {
      log.info(TAG, 'fs renameSync error = ' + JSON.stringify(error));
      return error;
    }
  }

  public static async unlink(path: string): Promise<void | BusinessError> {
    try {
      return await fs.unlink(path);
    } catch (error) {
      log.error(TAG, 'fs unlink error = ' + JSON.stringify(error));
      return error;
    }
  }

  public static unlinkSync(path: string): void | BusinessError {
    try {
      return fs.unlinkSync(path);
    } catch (error) {
      log.error(TAG, 'fs unlinkSync error = ' + JSON.stringify(error));
      return error;
    }
  }

  public static async fsync(fd: number): Promise<void | BusinessError> {
    try {
      return await fs.fsync(fd);
    } catch (error) {
      log.error(TAG, 'fs fsync error = ' + JSON.stringify(error));
      return error;
    }
  }

  /**
   * 强制删除文件
   * @param uri 删除文件的uri
   */
  public static forceDelete(uri: string): number | BusinessError {
    try {
      let fileUri: fileuri.FileUri = new fileuri.FileUri(uri);
      let filePath: string = fileUri.path;
      if (fs.statSync(filePath).isDirectory()) {
        fs.rmdirSync(filePath);
      } else {
        fs.unlinkSync(filePath);
      }
      return 0;
    } catch (error) {
      log.error(TAG, 'force delete file error: ' + JSON.stringify(error));
      return error;
    }
  }

  /**
   * 文件夹判空
   * @param path 文件夹的uri
   */
  public static isFolderEmpty(path: string): boolean | BusinessError {
    try {
      let fileList = fs.listFileSync(path, { listNum: 1 });
      return fileList.length === 0;
    } catch (error) {
      log.error(TAG, 'isFolderEmpty error: ' + JSON.stringify(error));
      return error;
    }
  }

  /**
   * 判断文件是否为文件夹（目前暂不支持应用沙箱目录）
   * @param path 文件
   * @returns
   */
  public static isFolder(path: string): boolean | BusinessError {
    try {
      let stat = fs.statSync(path);
      return stat?.isDirectory();
    } catch (error) {
      log.error(TAG, 'isFolder error:', error);
      return error;
    }
  }

  /**
   * 判断文件是否存在
   * @param uri 文件uri
   * @returns 判断结果
   */
  public static isFileExist(uri: string): boolean {
    let fileFd: fs.File | undefined = undefined;
    let isExist: boolean = false;
    try {
      log.info(TAG, 'open start');
      fileFd = fs.openSync(uri, fs.OpenMode.READ_ONLY);
      isExist = true;
    } catch (error) {
      log.error(TAG, 'openSync fail: ' + JSON.stringify(error));
      if (error.code === FsUtil.FILENOTEXIST) {
        log.error(TAG, 'file is not exist');
      }
    } finally {
      if (fileFd) {
        fs.closeSync(fileFd);
      }
    }
    return isExist;
  }

  /**
   * 判断目录下是否存在同名文件
   * @param destUri：目录uri
   * @param fileName：待判断的文件名
   * @returns 判断结果
   */
  public static isExistDupName(destUri: string, fileName: string): boolean {
    let isExistDupName: boolean = false;
    try {
      let destFileInfo: uri.URI = new fileuri.FileUri(destUri);
      let newFilePath: string = destFileInfo.path + '/' + fileName;
      isExistDupName = fs.accessSync(newFilePath);
    } catch (err) {
      log.warn(TAG, 'isExistDupName err: ' + JSON.stringify(err));
    }
    return isExistDupName;
  }

  public static getInoByUri(uri: string): string {
    try {
      let fileUri: fileuri.FileUri = new fileuri.FileUri(uri);
      let stat = fs.statSync(fileUri.path);
      return stat.ino.toString();
    } catch (error) {
      log.error(TAG, `get ino failed, error message : ${error?.message}, error code : ${error?.code}`);
      return '';
    }
  }

  /**
   * 文件拷贝同步接口，适合十几兆的小文件拷贝
   * @param srcPath 源文件
   * @param destinationPath 目标文件
   * @param mode 拷贝模式
   * @returns true：拷贝成功，目标文件已经存在
   */
  public static copyFileSyncByPath(srcPath: string, destinationPath: string, mode?: number): boolean {
    try {
      fs.copyFileSync(srcPath, destinationPath, mode);
      return FsUtil.isExistSyncByPath(destinationPath);
    } catch (error) {
      log.error(TAG, 'copyFileSyncByPath err: ' + JSON.stringify(error));
      return false;
    }
  }

  /**
   * 判断文件是否存在
   *
   * @param path 文件全目录
   * @returns true：文件存在
   */
  public static isExistSyncByPath(path: string): boolean {
    try {
      return fs.accessSync(path);
    } catch (error) {
      log.error(TAG, 'isExistSyncByPath error = ' + JSON.stringify(error));
      return false;
    }
  }

  /**
   * 重命名异步接口
   * @param oldPath 即将要重命名的文件全路径
   * @param newPath 重命名之后的文件全路径
   * @returns true：命名成功
   */
  public static renameSyncByPath(oldPath: string, newPath: string): boolean {
    try {
      fs.renameSync(oldPath, newPath);
      return FsUtil.isExistSyncByPath(newPath);
    } catch (error) {
      log.info(TAG, 'fs renameSync error = ' + JSON.stringify(error));
      return false;
    }
  }

  /**
   * 同步获取文件大小
   * @param path 文件全路径
   * @returns 文件夹大小
   */
  public static getFileSizeSyncByPath(path: string): number {
    let size = 0;
    try {
      let stat = fs.statSync(path);
      size = stat.size;
    } catch (error) {
      log.error(TAG, 'getFileInfoByFs fail, error:' + JSON.stringify(error));
    }
    return size;
  }

  /**
   * 同步获取文件大小
   * @param path 文件全路径
   * @returns 文件夹大小
   */
  public static getFileSizeSyncByPath1(path: string): number {
    let size = 0;
    try {
      let stat = fs.statSync(path);
      size = stat.size;
    } catch (error) {
      log.error(TAG, 'getFileInfoByFs fail, error:' + JSON.stringify(error));
    }
    return size;
  }

  /**
   * 同步获取文件大小
   * @param path 文件全路径
   * @returns 文件夹大小
   */
  public static getFileSizeSyncByPath3(path: string): number {
    let size = 0;
    try {
      let stat = fs.statSync(path);
      size = stat.size;
    } catch (error) {
      log.error(TAG, 'getFileInfoByFs fail, error:' + JSON.stringify(error));
    }
    return size;
  }
}

export enum FormatListItem {
  Z7 = '7z',
  AMR = 'amr',
  APE = 'ape',
  FLAC = 'flac',
  M4A = 'm4a',
  MP3 = 'music',
  WAV = 'wav',
  APP = 'app',
  CALENDER = 'calender',
  CHM = 'chm',
  RAR = 'rar',
  CONTACTS = 'contacts',
  DOC = 'doc',
  DOCX = 'docx',
  TXT = 'txt',
  HTM = 'htm',
  HTML = 'html',
  PDF = 'pdf',
  PPT = 'ppt',
  PPTX = 'pptx',
  XLS = 'xls',
  XLSX = 'xlsx',
  ZIP = 'zip',
  IMAGE = 'image',
  MP4 = 'video',
  LOG = 'log',
  XML = 'xml',
  WMA = 'wma',
  DLP = 'dlp',
  CAJ = 'caj',
  EDDX = 'eddx',
  KDH = 'kdh',
  NH = 'nh',
  TEB = 'teb',
  UNKNOWN = 'unknown',
  EMPTY_FOLDER = 'empty_folder',
  FOLDER = 'folder',
  EMPTY_DESKTOP = 'empty_desktop',
  DESKTOP = 'desktop',
  EMPTY_PICTURE = 'empty_pictures',
  PICTURE = 'pictures',
  EMPTY_DOCUMENTS = 'empty_documents',
  DOCUMENTS = 'documents',
  EMPTY_DOWNLOAD = 'empty_download',
  DOWNLOAD = 'download',
  EMPTY_APPDATA = 'empty_appdata',
  APPDATA = 'appdata',
  DEFAULT_IMAGE = 'default_image',
  DEFAULT_VIDEO = 'default_video',
  DEFAULT_PDF = 'default_pdf',
}

export class FileIconUtil {
  // 图标类型到图标的映射
  private static readonly iconMap: Map<string, Resource> = new Map([
    [FormatListItem.Z7, $r('app.media.ic_normal_7z')],
    [FormatListItem.AMR, $r('app.media.ic_normal_amr')],
    [FormatListItem.APE, $r('app.media.ic_normal_ape')],
    [FormatListItem.FLAC, $r('app.media.ic_normal_flac')],
    [FormatListItem.M4A, $r('app.media.ic_normal_m4a')],
    [FormatListItem.MP3, $r('app.media.ic_normal_mp3')],
    [FormatListItem.WAV, $r('app.media.ic_normal_wav')],
    [FormatListItem.APP, $r('app.media.ic_normal_app')],
    [FormatListItem.CALENDER, $r('app.media.ic_normal_calendar')],
    [FormatListItem.CHM, $r('app.media.ic_normal_chm')],
    [FormatListItem.RAR, $r('app.media.ic_normal_rar')],
    [FormatListItem.CONTACTS, $r('app.media.ic_normal_contact')],
    [FormatListItem.DOC, $r('app.media.ic_normal_doc')],
    [FormatListItem.DOCX, $r('app.media.ic_normal_doc')],
    [FormatListItem.TXT, $r('app.media.ic_normal_txt')],
    [FormatListItem.HTM, $r('app.media.ic_normal_htm')],
    [FormatListItem.HTML, $r('app.media.ic_normal_html')],
    [FormatListItem.PDF, $r('app.media.ic_normal_pdf')],
    [FormatListItem.DEFAULT_PDF, $r('app.media.ic_normal_pdf')],
    [FormatListItem.PPT, $r('app.media.ic_normal_ppt')],
    [FormatListItem.PPTX, $r('app.media.ic_normal_ppt')],
    [FormatListItem.XLS, $r('app.media.ic_normal_xls')],
    [FormatListItem.XLSX, $r('app.media.ic_normal_xls')],
    [FormatListItem.ZIP, $r('app.media.ic_normal_zip')],
    [FormatListItem.MP4, $r('app.media.ic_normal_video')],
    [FormatListItem.DEFAULT_VIDEO, $r('app.media.ic_normal_video')],
    [FormatListItem.LOG, $r('app.media.ic_normal_log')],
    [FormatListItem.XML, $r('app.media.ic_normal_xml')],
    [FormatListItem.WMA, $r('app.media.ic_normal_wma')],
    [FormatListItem.CAJ, $r('app.media.ic_normal_caj')],
    [FormatListItem.EDDX, $r('app.media.ic_normal_eddx')],
    [FormatListItem.KDH, $r('app.media.ic_normal_kdh')],
    [FormatListItem.NH, $r('app.media.ic_normal_nh')],
    [FormatListItem.TEB, $r('app.media.ic_normal_teb')],
    [FormatListItem.IMAGE, $r('app.media.ic_normal_image')],
    [FormatListItem.DEFAULT_IMAGE, $r('app.media.ic_normal_image')],
    [FormatListItem.UNKNOWN, $r('app.media.ic_normal_unknown')],
    [FormatListItem.EMPTY_FOLDER, $r('app.media.ic_normal_folder_empty')],
    [FormatListItem.FOLDER, $r('app.media.ic_normal_folder')],
  ])
}