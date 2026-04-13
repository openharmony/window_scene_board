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

import fs from '@ohos.file.fs';
import { Logger } from '../base/Logger';

const TAG: string = `FileUtil`;

/**
 * 单次加载文件支持最大的文件size大小
 */
const MAX_FILE_CONTENT_SIZE: number = 10 * 1024 * 1024;

// instrument ignore next
export class FileUtil {
  public static isFileExists(path: string): boolean {
    if (FileUtil.isEmpty(path)) {
      return false;
    }
    let exist = false;
    try {
      exist = fs.accessSync(path);
    } catch (e) {
      Logger.error(TAG, `isFileExists error: ${e}`);
    }
    return exist;
  }

  public static async readFileContent(filePath: string, maxFileSize: number = MAX_FILE_CONTENT_SIZE): Promise<string> {
    if (!FileUtil.isFileExists(filePath)) {
      return '';
    }
    try {
      const stat: fs.Stat = await fs.stat(filePath);
      if (stat.size > maxFileSize) {
        Logger.warning(TAG, `read target file too big`);
        return '';
      }
      let result: string = await fs.readText(filePath);
      return result;
    } catch (err) {
      Logger.error(TAG, 'get file content fail');
    }
    return '';
  }

  /**
   * 判断字符串是否为空
   *
   * @param str 待判断字符串
   * @returns true：字符串为空
   */
  private static isEmpty(str: string | String | undefined): boolean {
    if (str === undefined || str === null) {
      return true;
    }
    if (typeof str === 'string' || str instanceof String) {
      return !str.trim();
    }
    return false;
  }
}