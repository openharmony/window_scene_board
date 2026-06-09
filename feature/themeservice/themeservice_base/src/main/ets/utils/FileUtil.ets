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

import { fileUri, hash } from '@kit.CoreFileKit';
import fs from '@ohos.file.fs';
import { TsLog } from '../log/TsLog';
import { StringUtils } from './StringUtils';

const TAG: string = 'FileUtil';

const FILE_SEPARATOR: string = '/';
const FILE_SUFFIX: string = '.';
/**
 * 单次加载文件支持最大的文件size大小
 */
const MAX_FILE_CONTENT_SIZE: number = 10 * 1024 * 1024;

/**
 * 文件操作工具类
 * 提供文件的类型判断、存在性校验、创建目录、拷贝、重命名、及删除操作
 */
export class FileUtil {
  public static normalizePath(path: string): string {
    try {
      const uriPath: string = fileUri.getUriFromPath(path);
      const normalizePath: string = new fileUri.FileUri(uriPath).normalize().path;
      return normalizePath;
    } catch (error) {
      TsLog.error(TAG, `normalizePath error`, error);
    }
    return path;
  }

  static async copyDirAsync(srcPath: string, destPath: string): Promise<boolean> {
    if (!FileUtil.isFileExists(srcPath)) {
      return false;
    }
    try {
      if (!FileUtil.createDirRecur(destPath)) {
        return false;
      }
      await fs.copyDir(srcPath, destPath, 1);
    } catch (e) {
      TsLog.error(TAG, `copy dir sync error:` + e);
      return false;
    }
    return true;
  }

  /**
   * 清理目录操作
   * @param dir 目标清理目录
   * @param excludeFiles 不需要删除的文件列表
   * @returns 是否清理成功
   */
  static async trimDirAsync(dir: string, excludeFiles?: string[]): Promise<boolean> {
    if (!FileUtil.isDir(dir) || !FileUtil.isFileExists(dir)) {
      return false;
    }
    try {
      const fileList: string[] = await fs.listFile(dir);
      for (let file of fileList) {
        let currentFile = `${dir}/${file}`;
        if (excludeFiles?.includes(file)) {
          continue;
        }
        if (FileUtil.isDir(currentFile)) {
          await fs.rmdir(currentFile);
        } else {
          await fs.unlink(currentFile);
        }
      }
    } catch (error) {
      TsLog.warning(TAG, `trimDirAsync fail`);
    }
    return true;
  }

  private static createDirSync(path: string): boolean {
    if (FileUtil.isFileExists(path)) {
      return FileUtil.isDir(path);
    }
    let parentPath: string = FileUtil.getParentPath(path);
    if (StringUtils.isEmpty(path) || path === parentPath) {
      TsLog.warning(TAG, 'createDirSync path is empty or path == parentPath');
      return false;
    }
    if (!FileUtil.isFileExists(parentPath)) {
      try {
        FileUtil.createDirSync(parentPath);
        fs.mkdirSync(path);
        return true;
      } catch (e) {
        TsLog.warning(TAG, 'createDirSync error ' + e);
        return false;
      }
    } else {
      try {
        fs.mkdirSync(path);
        return true;
      } catch (e) {
        TsLog.error(TAG, 'createDirSync error ', e);
        return false;
      }
    }
  }

  static isDir(path: string): boolean {
    try {
      if (!FileUtil.isFileExists(path)) {
        return false;
      }
      return fs.statSync(path).isDirectory();
    } catch (error) {
      TsLog.warning(TAG, `isDir error: ${error.message}`);
      return false;
    }
  }

  static isFileExists(path: string | undefined): boolean {
    if (StringUtils.isEmpty(path)) {
      return false;
    }
    let exist: boolean = false;
    try {
      exist = fs.accessSync(path);
    } catch (error) {
      TsLog.warning(TAG, `isFileExists error: ${error.message}`);
    }
    return exist;
  }

  static getFileName(path: string | undefined): string {
    if (!path || StringUtils.isEmpty(path)) {
      return '';
    }
    const index: number = path.lastIndexOf(FILE_SEPARATOR);
    if (index >= 0) {
      return path.substring(index + 1);
    }
    return path;
  }

  static async getFileSize(path: string): Promise<number> {
    if (!FileUtil.isFileExists(path)) {
      TsLog.warning(TAG, `getFileSize path is emtry`);
      return 0;
    }
    try {
      let size: number = 0;
      if (!FileUtil.isDir(path)) {
        size = (await fs.statSync(path)).size;
      } else {
        const filelist: string[] = await FileUtil.listFiles(path, true);
        for (const file of filelist) {
          size += fs.statSync(file).size
        }
      }
      return size;
    } catch (error) {
      TsLog.error(TAG, `getFileSize error: ${error.message}`);
      return 0;
    }
  }

  /**
   * 遍历目录下的所有文件
   *
   * @param filePath 文件路径
   * @param isRecursion 是否递归遍历文件，默认为false
   * @returns 文件列表
   */
  static async listFiles(filePath: string, isRecursion: boolean = false): Promise<string[]> {
    if (!FileUtil.isDir(filePath)) {
      return [filePath];
    }
    if (!filePath.endsWith(FILE_SEPARATOR)) {
      filePath = filePath + FILE_SEPARATOR;
    }
    let fileNames: string[] = [];
    try {
      fileNames = await fs.listFile(filePath, { recursion: isRecursion });
    } catch (err) {
      TsLog.warning(TAG, `list file fail`);
    }
    const result: string[] = [];
    for (let fileName of fileNames) {
      result.push(`${filePath}${fileName}`);
    }
    return result;
  }

  /**
   * 遍历目录下的所有文件
   *
   * @param filePath 文件路径
   * @param isRecursion 是否递归遍历文件，默认为false
   * @returns 文件名称列表
   */
  static async listFileNames(filePath: string, isRecursion: boolean = false): Promise<string[]> {
    if (!FileUtil.isDir(filePath)) {
      return [];
    }
    try {
      return await fs.listFile(filePath, { recursion: isRecursion });
    } catch (err) {
      TsLog.warning(TAG, 'list file fail');
    }
    return [];
  }

  static getStringByFile(filePath: string, maxFileSize: number = MAX_FILE_CONTENT_SIZE): string {
    if (!FileUtil.isFileExists(filePath)) {
      return '';
    }
    try {
      const stat: fs.Stat = fs.statSync(filePath);
      if (stat.size > maxFileSize) {
        TsLog.warning(TAG, `read target file too big:${FileUtil.getFileName(filePath)}`);
        return '';
      }
      return fs.readTextSync(filePath);
    } catch (e) {
      TsLog.error(TAG, 'get file content fail');
      return '';
    }
  }

  static async readFileContent(filePath: string, maxFileSize: number = MAX_FILE_CONTENT_SIZE): Promise<string> {
    if (!FileUtil.isFileExists(filePath)) {
      return '';
    }
    try {
      const stat: fs.Stat = await fs.stat(filePath);
      if (stat.size > maxFileSize) {
        TsLog.warning(TAG, `read target file too big:${FileUtil.getFileName(filePath)}`);
        return '';
      }
      let result: string = await fs.readText(filePath);
      return result;
    } catch (err) {
      TsLog.error(TAG, 'get file content fail');
    }
    return '';
  }

  static createDirRecur(path: string): boolean {
    if (FileUtil.isFileExists(path)) {
      return true;
    }
    try {
      fs.mkdirSync(path, true);
    } catch (error) {
      TsLog.warning(TAG, 'createDirRecur fail');
      return false;
    }
    return true;
  }

  static getParentPath(path: string): string {
    if (!path) {
      return StringUtils.EMPTY;
    }
    let index: number = path.lastIndexOf(FILE_SEPARATOR);
    if (index >= 0) {
      return path.substring(0, index);
    }
    return path;
  }

  static createEmptyFile(path: string): void {
    try {
      let file: fs.File = fs.openSync(path, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      let fd: number = file.fd;
      try {
        fs.truncateSync(fd);
      } catch (err) {
        TsLog.warning(TAG, `createEmptyFile truncateSync fail`);
      } finally {
        FileUtil.closeSync(file);
      }
    } catch (err) {
      TsLog.warning(TAG, `createEmptyFile openSync fail`);
    }
  }

  /**
   * 删除目录
   * @param path 目录
   * @returns true/false
   */
  static async rmdirAsync(path: string): Promise<boolean> {
    try {
      if (!FileUtil.isFileExists(path)) {
        return false;
      }
      await fs.rmdir(path);
      return true;
    } catch (err) {
      TsLog.error(TAG, `rmdirSync catch exception.`, err);
    }
    return false;
  }

  /**
   * 删除文件或者文件夹
   * @param path
   * @returns
   */
  static async deleteAsync(path: string): Promise<boolean> {
    try {
      if (!FileUtil.isFileExists(path)) {
        return false;
      }
      if (fs.statSync(path).isDirectory()) {
        await fs.rmdir(path);
      } else {
        await fs.unlink(path);
      }
      return true;
    } catch (err) {
      TsLog.error(TAG, `deleteAsync catch exception.`, err);
    }
    return false;
  }

  static async renameAsync(oldPath: string, newPath: string): Promise<boolean> {
    try {
      if (StringUtils.isEmpty(oldPath) || StringUtils.isEmpty(newPath)) {
        return false;
      }
      await fs.rename(oldPath, newPath);
      return true;
    } catch (err) {
      TsLog.error(TAG, `renameSync catch exception.`, err);
    }
    return false;
  }

  static async copyFileAsync(src: string, dest: string, createDir: boolean = true, mode?: number): Promise<boolean> {
    try {
      if (!FileUtil.isFileExists(src)) {
        return false;
      }
      if (createDir) {
        FileUtil.createParentDir(dest);
      }
      await fs.copyFile(src, dest, mode);
      return true;
    } catch (err) {
      TsLog.error(TAG, `copyFileSync catch exception.`, err);
    }
    return false;
  }

  static copyFileSync(src: string, dest: string, createDir: boolean = true, mode?: number): boolean {
    try {
      if (!FileUtil.isFileExists(src)) {
        return false;
      }
      if (createDir) {
        FileUtil.createParentDir(dest);
      }
      fs.copyFileSync(src, dest, mode);
      return true;
    } catch (err) {
      TsLog.error(TAG, `copyFileSync catch exception.`, err);
    }
    return false;
  }

  private static createParentDir(dest: string): void {
    if (!dest) {
      return;
    }
    let parentPath: string = FileUtil.getParentPath(dest);
    if (!FileUtil.isFileExists(parentPath)) {
      FileUtil.createDirSync(parentPath);
    }
  }

  static writeFileSync(filePath: string, content: ArrayBuffer | string | undefined,
    createDir: boolean = true): boolean {
    if (content === undefined) {
      return false;
    }
    if (createDir) {
      FileUtil.createParentDir(filePath);
    }
    let file: fs.File | undefined;
    try {
      file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      fs.truncateSync(file.fd);
      fs.writeSync(file.fd, content); // 写入一段内容至文件
      return true;
    } catch (err) {
      TsLog.error(TAG, `writeFile catch exception.`, err);
    } finally {
      FileUtil.closeSync(file);
    }
    return false;
  }

  private static closeSync(file: fs.File | undefined): void {
    try {
      if (file) {
        fs.closeSync(file);
      }
    } catch (err) {
      TsLog.error(TAG, `closeSync catch exception.`, err);
    }
  }

  static getFileSuffix(filePath: string): string {
    const index: number = filePath.lastIndexOf(FILE_SUFFIX);
    if (index >= 0) {
      return filePath.substring(index + 1);
    }
    return filePath;
  }

  static getFilePrefix(fileName: string): string {
    const index: number = fileName.indexOf(FILE_SUFFIX);
    if (index >= 0) {
      return fileName.slice(0, index);
    }
    return fileName;
  }

  /**
   * 向路径中追加后缀名
   * @param path 原路径
   * @param pathExt 后缀名
   * @returns 新路径
   */
  static appendPathExtension(path: string, pathExt: string): string {
    if (!(path && pathExt)) {
      return path;
    }
    let appendExt: string | undefined = pathExt?.split(FILE_SUFFIX).pop();
    const newPath: string = `${path}${FILE_SUFFIX}${appendExt}`;
    return newPath;
  }

  /**
   * 计算文件哈希值
   *
   * @param path 待计算哈希值文件的应用沙箱路径
   * @param algorithm 哈希计算采用的算法
   * @returns 返回文件的哈希值，表示为十六进制数字串，所有字母均大写
   */
  static async calculateFileHash(path: string, algorithm?: string): Promise<string> {
    if (!FileUtil.isFileExists(path)) {
      TsLog.error(TAG, 'calculate file path is null.');
      return StringUtils.EMPTY;
    }
    return hash.hash(path, algorithm ? algorithm : 'sha256')
  }
}