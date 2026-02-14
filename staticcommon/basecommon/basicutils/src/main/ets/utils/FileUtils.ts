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

/**
 * An util that provides io functionality between file and JSON object.
 */
import Fileio from '@ohos.fileio';
import util from '@ohos.util';
import fileIo from '@ohos.file.fs';
import fileuri from '@ohos.file.fileuri';
import { LogDomain, LogHelper } from './LogHelper';
import fs from '@ohos.file.fs';

const TAG = 'FileUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

const READ_DATA_SIZE = 4096;
const FILE_SEPARATOR: string = '/';

export default class FileUtils {

  /**
   * Read Json file from disk by file path.
   *
   * @param {string} filePath - filePath as the absolute path to the target file.
   * @return {any} - read object from file
   * @deprecated since 2025.07.26
   * @useinstead FileUtils.readJsonFromFile
   */
  static readJsonFile(filePath: string): any {
    log.showDebug('readJsonFile start execution ${filePath}');
    let readStreamSync = null;
    let file: fs.File | undefined = undefined;
    try {
      file = fs.openSync(filePath, fs.OpenMode.READ_ONLY);
      readStreamSync = fs.fdopenStreamSync(file.fd, 'r');
      const content = this.getContent(readStreamSync);
      return JSON.parse(content);
    } catch (e) {
      log.showError(`readJsonFile error: ${e.toString()}`);
      return null;
    } finally {
      readStreamSync?.closeSync();
    }
  }

  static readJsonFromFile<T>(filePath: string): T | null {
    log.showDebug('readJsonFromFile');
    if (!filePath || filePath === '') {
      return null;
    }
    let readStreamSync: fileIo.Stream | null = null;
    let file: fs.File | undefined = undefined;
    try {
      file = fs.openSync(filePath, fs.OpenMode.READ_ONLY);
      readStreamSync = fs.fdopenStreamSync(file.fd, 'r');
      const content = FileUtils.getContent(readStreamSync);
      return JSON.parse(content);
    } catch (err) {
      log.showError(`readJsonFile error: ${err.toString()}`);
      return null;
    } finally {
      readStreamSync?.closeSync();
    }
  }

  /**
   * Read String from disk by bundleName.
   *
   * @param {string} filePath - filePath as the absolute path to the target file.
   * @return {string} - read string from file
   * @deprecated since 2024.05.17
   * @useinstead FileUtils.readTextSync
   */
  static readStringFromFile(filePath: string): string {
    log.showDebug('readStringFromFile start execution');
    let readStreamSync: Fileio.Stream | null = null;
    try {
      readStreamSync = Fileio.createStreamSync(filePath, 'r');
      const content = FileUtils.getContent(readStreamSync);
      return content;
    } catch (e) {
      log.showError(`readStringFromFile error: ${e.toString()}`);
      return '';
    } finally {
      if (readStreamSync) {
        readStreamSync?.closeSync();
      }
    }
  }

  /**
   * Write string to a file.
   *
   * @param {string} str - target string will be written to file.
   * @param {string} filePath - filePath as the absolute path to the target file.
   */
  static writeStringToFile(str: string, filePath: string): void {
    log.showDebug('writeStringToFile start execution');
    let writeStreamSync: Fileio.Stream | null = null;
    try {
      writeStreamSync = Fileio.createStreamSync(filePath, 'w+');
      let number = writeStreamSync.writeSync(str);
      log.showDebug('writeStringToFile number:%{public}d ', number);
    } catch (e) {
      log.showError(`writeStringToFile error: ${e.toString()}`);
    } finally {
      writeStreamSync?.closeSync();
      log.showDebug('writeStringToFile close sync');
    }
  }

  /**
   * Read JSON object from a file.
   *
   * @param {object} readStreamSync - stream of target file
   * @return {object} - object read from file stream
   */
  static getContent(readStreamSync: Fileio.Stream | fileIo.Stream): string {
    log.showDebug('getContent start');
    const bufArray: ArrayBuffer[] = [];
    let totalLength = 0;
    let buf = new ArrayBuffer(READ_DATA_SIZE);
    let len = readStreamSync.readSync(buf);
    while (len !== 0) {
      log.showDebug(`getContent FileIO reading ${len}`);
      totalLength += len;
      if (len < READ_DATA_SIZE) {
        buf = buf.slice(0, len);
        bufArray.push(buf);
        break;
      }
      bufArray.push(buf);
      buf = new ArrayBuffer(READ_DATA_SIZE);
      len = readStreamSync.readSync(buf);
    }
    log.showDebug(`getContent read finished: ${totalLength}`);
    const contentBuf = new Uint8Array(totalLength);
    let offset = 0;
    for (const bufArr of bufArray) {
      log.showDebug(`getContent collecting: ${offset}`);
      const uInt8Arr = new Uint8Array(bufArr);
      contentBuf.set(uInt8Arr, offset);
      offset += uInt8Arr.byteLength;
    }
    let textDecoder = new util.TextDecoder('utf-8', {ignoreBOM: true});
    const content = textDecoder.decode(contentBuf, {stream: false});
    return content;
  }

  /**
   * Check if the file exists.
   *
   * @param {string} filePath - filePath as the absolute path to the target file.
   * @return {boolean} - boolean true(Exist)
   */
  static isExist(filePath: string): boolean {
    try {
      Fileio.accessSync(filePath);
      log.showDebug('accessSync success.');
    } catch (e) {
      log.showDebug(`isExist error: ${e.toString()}`);
      return false;
    }
    return true;
  }

  /**
   * 把文件转换成文本
   *
   * @param path 文本路径
   * @returns 文本里面的字符串
   */
  static readTextSync(path: string): string {
    let ret = '';
    try {
      ret = fileIo.readTextSync(path);
    } catch (e) {
      log.showError(`readTextSync error: ${e.toString()}`);
    }
    return ret;
  }

  /**
   * 获取制定路径下文件的uri
   *
   * @param path 文件路径
   * @returns 文件路径对应的uri
   */
  static getUriFromPath(path: string): string {
    let ret = '';
    try {
      ret = fileuri.getUriFromPath(path);
    } catch (e) {
      log.showError(`getUriFromPath error: ${e.toString()}`);
    }
    return ret;
  }

  /**
   * Delete Files.
   *
   * @param {string} filePath - filePath as the absolute path to the target file.
   */
  static deleteConfigFile(filePath: string): void {
    try {
      Fileio.unlinkSync(filePath);
    } catch (e) {
      log.showError(`deleteFile error: ${e.toString()}`);
    }
  }


  static copyFile(srcPath: string, dstPath: string): boolean {
    try {
      fileIo.copyFileSync(srcPath, dstPath);
      log.showDebug('copyFile success');
      return true;
    } catch (e) {
      log.showError(`copyFile error: ${e.toString()}`);
      return false;
    }
  }

  static moveFile(srcPath: string, dstPath: string): boolean {
    try {
      fileIo.moveFileSync(srcPath, dstPath);
      log.showDebug('moveFile success');
      return true;
    } catch (e) {
      log.showError(`moveFile error: ${e.toString()}`);
      return false;
    }
  }

  static getFileList(path: string): string[] {
    try {
      return fileIo.listFileSync(path);
    } catch (e) {
      log.showError(`getFileList error: ${e.toString()}`);
      return [];
    }
  }

  static openFile(path: string, mode:number = fileIo.OpenMode.READ_ONLY): fileIo.File | null {
    try {
      return fileIo.openSync(path, mode);
    } catch (e) {
      log.showError(`openFile error: ${e.toString()}`);
      return null;
    }
  }

  static getFileStream(path: string): fileIo.Stream | null {
    let readStreamSync: fileIo.Stream | null = null;
    try {
      readStreamSync = fileIo.createStreamSync(path, 'r+');
      return readStreamSync;
    } catch (e) {
      log.showError(`getFileStream error: ${e.toString()}`);
      return null;
    } finally {
      readStreamSync?.closeSync();
    }
  }

  static writeBufferToFile(file: fileIo.File, buffer: ArrayBuffer): number {
    try {
      return fileIo.writeSync(file.fd, buffer);
    } catch (e) {
      log.showError(TAG, 'writeBufferToFile error');
      return 0;
    }
  }

  static closeFile(file: fileIo.File): boolean {
    try {
      fileIo.closeSync(file.fd);
      return true;
    } catch (e) {
      log.showError(TAG, 'closeFile error');
      return false;
    }
  }

  static createFolder(path: string): boolean {
    if (FileUtils.isExist(path)) {
      return true;
    }
    try {
      fileIo.mkdirSync(path);
      return true;
    } catch (e) {
      log.showError(TAG, 'createFolder error');
      return false;
    }
  }

  static isExistFs(path: string): boolean {
    try {
      let res = fs.accessSync(path);
      if (res) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log.showError(TAG, `accessSync failed, ${e?.code}, msg: ${e?.message}`);
    }
    return false;
  }

  static isDir(path: string): boolean {
    try {
      if (!FileUtils.isExistFs(path)) {
        return false;
      }
      return fs.statSync(path).isDirectory();
    } catch (error) {
      log.showWarn(TAG, `isDir error: ${error.message}`);
      return false;
    }
  }

  static async listFiles(filePath: string, isRecursion: boolean = false): Promise<string[]> {
    if (!FileUtils.isDir(filePath)) {
      return [filePath];
    }
    if (!filePath.endsWith(FILE_SEPARATOR)) {
      filePath = filePath + FILE_SEPARATOR;
    }
    let fileNames: string[] = [];
    try {
      fileNames = await fs.listFile(filePath, { recursion: isRecursion });
    } catch (err) {
      log.showWarn(TAG, `list file fail`);
    }
    const result: string[] = [];
    for (let fileName of fileNames) {
      result.push(`${filePath}${fileName}`);
    }
    return result;
  }

  static async getFileSize(path: string): Promise<number> {
    if (!FileUtils.isExistFs(path)) {
      log.showWarn(TAG, `getFileSize path is emtry`);
      return 0;
    }
    try {
      let size: number = 0;
      if (!FileUtils.isDir(path)) {
        size = fs.statSync(path).size;
      } else {
        const filelist: string[] = await FileUtils.listFiles(path, true);
        for (const file of filelist) {
          size += fs.statSync(file).size
        }
      }
      return size;
    } catch (error) {
      log.showError(TAG, `getFileSize error: ${error.message}`);
      return 0;
    }
  }
}