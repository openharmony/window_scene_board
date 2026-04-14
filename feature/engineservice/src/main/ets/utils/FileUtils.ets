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
import lazy fs from '@ohos.file.fs';
import { Log } from './Log';
import lazy { TextUtil } from './TextUtil';

const TAG: string = 'FileUtils';
/**
 * 单次加载文件支持最大的文件size大小 (100M)
 */
const MAX_FILE_CONTENT_SIZE: number = 100 * 1024 * 1024;

export class FileUtils {
  /**
   * 同步mkdir
   * @param path 路径
   * @param recursion whether to recursively make directory.
   * @returns true/false
   */
  public static mkdirSync(path: string, recursion: boolean = true): boolean {
    try {
      if (fs.accessSync(path)) {
        return true;
      }
      fs.mkdirSync(path, recursion);
      return true;
    } catch (err) {
      Log.error(TAG, `mkdirSync catch exception.`, err)
    }
    return false;
  }

  /**
   * 写入文件
   * @param destFileDir 路径
   * @param fileName 文件名称
   * @param content 写入内容
   * @returns true/false
   */
  public static writeFileSync(destFileDir: string, fileName: string, content: string): boolean {
    let file: fs.File | undefined = undefined;
    try {
      if (!FileUtils.isExists(destFileDir)) {
        fs.mkdirSync(destFileDir, true);
      }
      file = fs.openSync(destFileDir + `/${fileName}`, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      fs.writeSync(file.fd, content);
      return true;
    } catch (err) {
      Log.error(TAG, `writeFileSync catch exception. ${err?.code}: ${err?.message}`);
      return false;
    } finally {
      FileUtils.safeFsCloseSync(file);
    }
  }

  /**
   * 文件流安全关闭公共方法
   *
   * @param file 文件类或文件的fd编号
   */
  public static safeFsCloseSync(file: undefined | number | fs.File): void {
    if (typeof (file) === 'undefined') {
      return;
    }
    try {
      fs.closeSync(file);
    } catch (e) {
      Log.error(TAG, `file stream close failed, code is ${e.code}, message is ${e.message}`);
    }
  }

  /**
   * 读取文件Text内容
   * @param path 文件路径
   * @param maxFileSize 最大读取文件大小（默认100M）
   * @returns 文件内容string
   */
  public static readTextSync(path: string, maxFileSize: number = MAX_FILE_CONTENT_SIZE): Nullable<string> {
    if (!FileUtils.isExists(path)) {
      return undefined;
    }
    try {
      const stat: fs.Stat = fs.statSync(path);
      if (stat.size > maxFileSize) {
        Log.error(TAG, `read target file too big`);
        return undefined;
      }
      let result: string = fs.readTextSync(path);
      return result;
    } catch (err) {
      Log.error(TAG, 'readTextSync catch exception.', err);
    }
    return undefined;
  }

  /**
   * 文件是否存在
   * @param path 路径
   * @returns true:存在，false:不存在
   */
  public static isExists(path: string): boolean {
    let exist = false;
    if (TextUtil.isEmpty(path)) {
      return exist;
    }
    try {
      exist = fs.accessSync(path);
    } catch (err) {
      Log.error('isExists catch exception.', err);
    }
    return exist;
  }

  public static async copyFile(src: string, dst: string): Promise<boolean> {
    if (!FileUtils.isExists(src)) {
      return false;
    }
    try {
      await fs.copyFile(src, dst);
      return true;
    } catch (err) {
      Log.error(TAG, `copyFileSync catch exception.`, err)
    }
    return false;
  }

  /**
   * 删除文件或者文件夹
   *
   * @param path 文件或者文件夹路径
   * @returns true：删除成功
   */
  public static async deleteAsync(path: string): Promise<boolean> {
    try {
      if (!FileUtils.isExists(path)) {
        return false;
      }
      if (fs.statSync(path).isDirectory()) {
        await fs.rmdir(path);
      } else {
        await fs.unlink(path);
      }
      return true;
    } catch (err) {
      Log.error(TAG, `deleteAsync catch exception.`, err);
    }
    return false;
  }

  public static async checkFileSize(path: string, maxFileSize: number): Promise<boolean> {
    if (!FileUtils.isExists(path)) {
      return false;
    }
    try {
      let stat: fs.Stat = await fs.stat(path);
      let fileSize = stat?.size ?? 0;
      if (fileSize >= maxFileSize) {
        Log.info(TAG, `file exceeds size limit.`)
        return false;
      }
    } catch (err) {
      Log.error(TAG, `checkFileSize catch exception.`, err);
    }
    return true;
  }

  /**
   * 判断路径是否是目录
   * @param path 文件路径
   * @returns 路径存在且是目录返回true，否则返回false
   */
  public static isDir(path: string): boolean {
    if (!FileUtils.isExists(path)) {
      return false;
    }
    try {
      if (fs.statSync(path).isDirectory()) {
        return true;
      }
    } catch (e) {
      Log.warn(TAG, `isDir error: code is ${e.code}, message is ${e.message}`);
    }
    return false;
  }

  /**
   * 获取文件大小，如果是目录，则递归遍历下面所有文件统计总大小
   * @param path 文件路径
   * @returns
   */
  public static getFileSize(path: string): number {
    if (!FileUtils.isExists(path)) {
      Log.warn(TAG, `getFileSize path is not exists.`);
      return 0;
    }
    try {
      let size: number = 0;
      if (!FileUtils.isDir(path)) {
        size = fs.statSync(path).size;
      } else {
        const filelist: string[] = FileUtils.listFiles(path, true);
        for (const file of filelist) {
          size += fs.statSync(file).size
        }
      }
      return size;
    } catch (e) {
      Log.error(TAG, `getFileSize error: code is ${e.code}, message is ${e.message}`);
      return 0;
    }
  }

  /**
   * 遍历目录下的所有文件
   *
   * @param filePath 文件路径
   * @param isRecursion 是否递归遍历文件，默认为false
   * @returns 文件名称列表
   */
  public static listFiles(filePath: string, isRecursion: boolean = false): string[] {
    if (!FileUtils.isExists(filePath)) {
      return [];
    }
    if (!FileUtils.isDir(filePath)) {
      return [];
    }
    try {
      let result: string[] = fs.listFileSync(filePath, { recursion: isRecursion, listNum: 0 });
      return result.map(fileName => `${filePath}/${fileName}`);
    } catch (e) {
      Log.warn(TAG, `list file failed: code is ${e.code}, message is ${e.message}`);
    }
    return [];
  }
}