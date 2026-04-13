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
import lazy buffer from '@ohos.buffer';
import lazy { BusinessError } from '@ohos.base';
import lazy { ThemeConstant } from './ThemeConstant';
import { Log } from './Log';
import { FileUtils } from './FileUtils';
import { Constants } from './Constants';
import { GlobalContext } from './GlobalContext';

const TAG: string = 'EngineService-FileUtil';
const MAX_BUFFER: number = 1280000;
const FILE_SEPARATOR: string = '/';
const PATH_SEP: string = '/';
const URI_PREFIX: string = 'file:';
const URI_PREFIX_LEN: number = 5;

/**
 * 文件工具类
 *
 * @since 2024-08-29
 */
export class FileUtil {

  /**
   * 更新沙箱目录是否成功
   *
   * @param sandBoxPath 沙箱文件路径
   * @returns true：成功，false：失败
   */
  public static updateSandBox(sandBoxPath?: string): boolean {
    if (sandBoxPath && FileUtils.isExists(sandBoxPath)) {
      GlobalContext.getContext().setObject(Constants.SANDBOX, sandBoxPath);
    } else if (FileUtils.isExists(Constants.FLAG_PATH_A)) {
      GlobalContext.getContext().setObject(Constants.SANDBOX, Constants.SANDBOX_PATH_A);
    } else if (FileUtils.isExists(Constants.FLAG_PATH_B)) {
      GlobalContext.getContext().setObject(Constants.SANDBOX, Constants.SANDBOX_PATH_B);
    } else {
      Log.error(TAG, 'current device has neither directory A nor directory B');
      return false;
    }
    return true;
  }

  /**
   * 返回当前生效主题包所在路径是A还是B
   *
   * @returns 返回AB目录标识，异常时返回空
   */
  public static getThemePathId(): string {
    if (FileUtils.isExists(Constants.FLAG_PATH_A)) {
      return 'A';
    } else if (FileUtils.isExists(Constants.FLAG_PATH_B)) {
      return 'B';
    } else {
      Log.error(TAG, 'current device has neither directory A nor directory B');
    }
    return '';
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
   * 递归拷贝目录，包含目录结构和目录中文件
   *
   * @param srcPath 原始目录地址
   * @param destPath 目标目录地址
   * @returns 是否拷贝成功
   */
  public static async copyDirectoryRecursively(srcPath: string, destPath: string): Promise<boolean> {
    try {
      const destExists: boolean = FileUtils.isExists(destPath);
      if (!destExists) {
        // 如果目标目录不存在，则递归创建目标目录。
        await FileUtil.createDirectoryRecursively(destPath);
      }
      if (!srcPath.endsWith(PATH_SEP)) {
        srcPath += PATH_SEP;
      }
      if (!destPath.endsWith(PATH_SEP)) {
        destPath += PATH_SEP;
      }
      // copyDir 传入的源目录和目标目录都需要存在，且以 / 结尾。
      await fs.copyDir(srcPath, destPath, 0);
      return true;
    } catch (e) {
      Log.error(TAG, `copyDirectoryRecursively error, code is ${e.code}, message is ${e.message}`);
      return false;
    }
  }

  /**
   * 递归创建目录
   *
   * @param path 目录路径
   * @returns 返回是否创建成功
   */
  public static async createDirectoryRecursively(path: string): Promise<boolean> {
    if (path === PATH_SEP) {
      Log.error(TAG, 'createDirectoryRecursively looked back upon the root!');
      return false;
    }
    const parentPath: string = FileUtil.getParentDirectory(path);
    if (parentPath === path) {
      Log.error(TAG, 'createDirectoryRecursively looked back upon the root!');
      return false;
    }
    const parentExists: boolean = FileUtils.isExists(parentPath);
    if (!parentExists) {
      const parentCreated: boolean = await FileUtil.createDirectoryRecursively(parentPath);
      if (!parentCreated) {
        return parentCreated;
      }
    }
    return FileUtil.buildDirectoryByFullpath(path);
  }

  /**
   * 创建目录
   *
   * @param fullPath 目录路径
   * @returns 是否目录创建成功
   */
  public static buildDirectoryByFullpath(fullPath: string): boolean {
    try {
      if (fs.accessSync(fullPath)) {
        return true;
      }
      fs.mkdirSync(fullPath, true);
      return true;
    } catch (e) {
      Log.error(TAG, `sth wrong when buildDirectoryByFullpath, code is ${e.code}, message is ${e.message}`);
    }
    return false;
  }

  /**
   * 移除路径中最后的片段（获取上级路径）
   *
   * @param path 原路径
   * @returns 新路径
   */
  public static getParentDirectory(path: string): string {
    const sPath: string = FileUtil.standardizePath(path);
    let pathComps: string[] = sPath.split(PATH_SEP);
    pathComps = pathComps.filter((comp) => comp.length > 0);
    pathComps.pop();
    return FileUtil.standardizePath(PATH_SEP + pathComps.join(PATH_SEP));
  }

  /**
   * 标准化路径，将路径起始'file:'去除以及冗余路径分隔符
   *
   * @param path
   * @returns 标准化后路径
   */
  private static standardizePath(path: string): string {
    if (path.startsWith(URI_PREFIX)) {
      path = path.slice(URI_PREFIX_LEN);
    }
    if (!path.startsWith(PATH_SEP)) {
      return path;
    }
    let pathComps: string[] = path.split(PATH_SEP);
    pathComps = pathComps.filter((comp) => comp.length > 0);
    return PATH_SEP + pathComps.join(PATH_SEP);
  }

  /**
   * 获取资源文件的全路径
   *
   * @param fileName 文件名
   * @param scriptType 脚本类型
   * @returns 资源文件的绝对路径
   */
  public static getAbsolutePath(fileName: string, scriptType: string): string {
    if (!fileName) {
      return '';
    }

    // 通过UIAbilityContext获取沙箱地址filesDir
    let sandBox: string = GlobalContext.getContext().getObject(Constants.SANDBOX) as string;
    if (!sandBox) {
      return '';
    }
    return `${sandBox}/${scriptType}${Constants.SANDBOX_RESOURCES_PATH}${fileName}`;
  }

  public static isQualifierFileExists(qualifier: string): boolean {
    let sandbox: string = GlobalContext.getContext().getObject(Constants.SANDBOX) as string;
    if (FileUtils.isExists(sandbox + `/${Constants.AOD.toLowerCase()}/` + qualifier)) {
      return true;
    }
    if (FileUtils.isExists(sandbox + `/${Constants.HOME.toLowerCase()}/` + qualifier)) {
      return true;
    }
    if (FileUtils.isExists(sandbox + `/${Constants.LOCK.toLowerCase()}/` + qualifier)) {
      return true;
    }
    return false;
  }

  /**
   * 递归删除目录，包含目录结构和目录中文件
   *
   * @param srcPath 原始目录地址
   * @returns 是否删除成功
   */
  public static async removeDirectoryRecursively(srcPath: string): Promise<boolean> {
    const srcExists: boolean = FileUtils.isExists(srcPath);
    if (!srcExists) {
      Log.info(TAG, 'removeDirectoryRecursively failed. src file not exists');
      return true;
    }
    const parentPath: string = srcPath + (srcPath.endsWith('/') ? '' : '/');
    try {
      const files: string[] = await fs.listFile(srcPath);
      for (let fileName of files) {
        const filePath: string = parentPath + fileName;
        const fileStat: fs.Stat = fs.lstatSync(filePath);
        if (fileStat.isFile()) {
          await fs.unlink(filePath);
        } else {
          await FileUtil.removeDirectoryRecursively(filePath);
        }
      }
      await fs.rmdir(srcPath);
      return true;
    } catch (e) {
      Log.error(TAG, `removeDirectoryRecursively failed. code is ${e?.code}, message is ${e?.message}`);
      return false;
    }
  }

  /**
   * 重命名文件/文件夹
   *
   * @param oldPath 旧名称
   * @param newPath 新名称
   * @returns 是否重命名成功
   */
  public static async renameFile(oldPath: string, newPath: string): Promise<boolean> {
    if (!FileUtils.isExists(oldPath)) {
      Log.info(TAG, 'renameFile failed. src file not exists');
      return false;
    }
    try {
      await fs.rename(oldPath, newPath);
      return true;
    } catch (e) {
      Log.error(TAG, `renameFile failed. code is ${e?.code}, message is ${e?.message}`);
    }
    return false;
  }

  /**
   * 读取manifest.json文件
   *
   * @param json文件路径
   * @returns manifest.json文件中的permissions
   */
  public static async readManifestJson(filePath: string): Promise<string> {
    let jsonContent: boolean | string = await FileUtil.getJsonContent(filePath);
    if (typeof jsonContent === 'boolean') {
      return '';
    }
    try {
      let json: object = JSON.parse(jsonContent as string);
      let manifest: string = '';
      for (let key of Object.keys(json)) {
        if (key === ThemeConstant.PERMISSIONS) {
          manifest = json[key];
          break;
        }
      }
      Log.info(TAG, `read manifest json success, manifest = ${manifest}`);
      return manifest;
    } catch (jsonError) {
      Log.error(TAG, `JSON parse error! ${jsonError?.code} ${jsonError?.message}`);
      return '';
    }
  }

  /**
   * 解析 json 文件内容
   *
   * @param json 文件路径
   * @returns 文件内容，当解析失败时候返回 false，成功时返回文件内容
   */
  private static async getJsonContent(filePath: string): Promise<boolean | string> {
    if (!filePath) {
      Log.error(TAG, `Json filePath is null!`);
      return false;
    }
    try {
      let content: string = await FileUtil.getStringByFile(filePath);
      if (!content) {
        Log.error(TAG, `readJson error, not respond data!`);
        return false;
      }
      return content;
    } catch (jsonError) {
      Log.error(TAG, `getJsonContent error! ${jsonError?.code} ${jsonError?.message}`);
      return false;
    }
  }

  /**
   * 读取指定路径下的json文件
   *
   * @param json文件路径
   * @returns json文件内容
   */
  private static async getStringByFile(filePath: string): Promise<string> {
    if (!filePath) {
      Log.error(TAG, `getFileContent failed. filePath is null.`);
      return '';
    }
    return new Promise((resolve, reject) => {
      let file: fs.File | undefined;
      try {
        file = fs.openSync(filePath, fs.OpenMode.READ_ONLY);
        if (typeof file === 'undefined') {
          return;
        }
        let size: number = fs.statSync(file.fd).size;
        let arrBuf: ArrayBuffer = new ArrayBuffer(size <= MAX_BUFFER ? size : MAX_BUFFER);
        fs.read(file.fd, arrBuf).then((readLen: number) => {
          let buf: buffer.Buffer = buffer.from(arrBuf, 0, readLen);
          let content: string = buf.toString();
          Log.debug(TAG, `getFileContent ${content}`);
          resolve(content);
        }).catch((err: BusinessError) => {
          Log.error(TAG, `getFileContent failed. ${err?.code} ${err?.message}`);
          reject(err);
        }).finally(() => {
          FileUtil.safeFsCloseSync(file);
        });
      } catch (jsonError) {
        Log.error(TAG, `JSON parse error:${jsonError?.code} ${jsonError?.message}`);
        FileUtil.safeFsCloseSync(file);
        reject();
      }
    });
  }

  /**
   * 获取主题包名
   *
   * @param 主题包路径
   * @returns 主题包名
   */
  public static getFileName(path: string): string {
    if (!path) {
      return '';
    }
    const index: number = path.lastIndexOf(FILE_SEPARATOR);
    if (index >= 0) {
      return path.substring(index + 1);
    }
    return path;
  }

  /**
   * 文件是否存在
   * @param path 路径
   * @returns true:存在，false:不存在
   */
  public static isFileExists(path: string): boolean {
    let exist = false;
    if (!path) {
      return exist;
    }
    try {
      exist = fs.accessSync(path);
    } catch (e) {
      Log.error('isFileExists error: %o', e);
    }
    return exist;
  }
}
