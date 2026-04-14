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
import lazy { FileUtil } from './FileUtil';
import { Log } from './Log';
import { JsonUtil } from './JsonUtil';

const TAG: string = 'JsonFileUtil';
const MAX_BUFFER: number = 1280000;
const DOES_NOT_EXIST_VALUE: number = -1;

/**
 * JsonFile util
 *
 * @since 2023-11-17
 */
export class JsonFileUtil {
  /**
   * get Json content in a specified path.
   *
   * @param filePath the Json file path
   * @return Json content
   */
  public static async getStringByFile(filePath: string): Promise<string> {
    if (!filePath) {
      Log.error(TAG, 'getFileContent failed. filePath is null.');
      return '';
    }
    try {
      return JsonFileUtil.readJson(filePath);
    } catch (e) {
      Log.error(TAG, `getFileContent failed: code is ${e.code}, message is ${e.message}`);
      return '';
    }
  }

  /**
   * get type in manifest path.
   *
   * @param path the manifest path
   * @return type content
   */
  public static getManifestType(path: string): string {
    try {
      if (!fs.accessSync(path)) {
        Log.warn(TAG, 'hasScriptType manifest has not access!');
        return '';
      }
      let content: object | undefined = JsonUtil.jsonParse(fs.readTextSync(path));
      if (!content) {
        Log.error(TAG, 'getManifestType content is null');
        return '';
      }
      return content['type'];
    } catch (err) {
      Log.error(TAG, `getManifestType error: ${err?.code}}`);
    }
    return '';
  }

  /**
   * 读取Json文件
   *
   * @param filePath 文件路径
   * @returns 文件内容
   * @throws 文件路径读取异常
   * @throws 文件读取失败
   */
  public static readJson(filePath: string): Promise<string> {
    if (!filePath) {
      return new Promise((resolve) => resolve(''));
    }
    return new Promise((resolve, reject) => {
      let file: fs.File | undefined;
      try {
        let separator: number = filePath.lastIndexOf('/');
        if (separator === DOES_NOT_EXIST_VALUE) {
          separator = filePath.lastIndexOf('\\');
        }
        let intendedDir: string = filePath.substring(0, separator);
        let fileName: string = filePath.substring(separator + 1);
        if (!JsonFileUtil.isFileDirPathIsValid(intendedDir, fileName)) {
          // 说明文件路径校验出非法字符，此时抛出异常，终止
          reject(new Error('Invalid file path.'));
          return;
        }
        file = fs.openSync(filePath, fs.OpenMode.READ_ONLY);
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
   * 校验文件路径,目录和文件名分开传入
   *
   * @param intendedDir 文件所在日录,传入参数需解码后的字符串,非url、base64等编码后内容
   * @param fileName 文件名,传入参数需解码后的字符串,非url、base64等编码后内容
   * @returns 校验是否合法,true:合法,false:非法
   */
  private static isFileDirPathIsValid(intendedDir: string, fileName: string): boolean {
    if ((intendedDir && !JsonFileUtil.checkPath(intendedDir)) || (fileName && !JsonFileUtil.checkPath(fileName))) {
      Log.warn(TAG, `Invalid file directory or file name.`);
      return false;
    }
    return true;
  }

  /**
   * 检查字符串中是否包含危险字符
   *
   * @param path 待校验字符串
   * @returns 校验结果,false:存在危险字符,true:不存在危险字符
   */
  private static checkPath(path: string): boolean {
    if (path.includes('..') || path.includes('./') || path.includes('.\\.\\') || path.includes('%00')) {
      return false;
    }
    return true;
  }
}