/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
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
import { JSON } from '@kit.ArkTS';
import { common } from '@kit.AbilityKit';
import { LogDomain, Logger } from '@ohos/basicutils';
import { BusinessError } from '@kit.BasicServicesKit';

const JSON_FILE_NAME = 'ScreenLockForm_data.json';
const TAG: string = 'ScreenLockFormSaveUtils';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

export class ScreenLockFormSaveUtils {
  /**
   * 初始化 JSON 文件
   */
  public static async initJsonFile(context: common.UIAbilityContext): Promise<string> {
    try {
      // 1. 检查文件是否存在
      const sandboxDir = context.filesDir;
      const targetPath = `${sandboxDir}/${JSON_FILE_NAME}`;
      const fileExists = await ScreenLockFormSaveUtils.checkFileExists(targetPath);

      if (!fileExists) {
        // 2. 文件不存在，创建并初始化
        await ScreenLockFormSaveUtils.createJsonFile(targetPath, []);
      } else {
        // 3. 文件存在，读取数据
        return await ScreenLockFormSaveUtils.readJsonFile(targetPath);
      }
      return targetPath;
    } catch (error) {
      const err = error as BusinessError;
      log.showError(TAG, `Initialization failed error:${err?.code} ${err?.message}`);
      return 'fail';
    }
  }

  /**
   * 检查文件是否存在
   */
  public static async checkFileExists(filePath: string): Promise<boolean> {
    try {
      await fs.access(filePath);
      return true;
    } catch (error) {
      const err = error as BusinessError;
      log.showError(TAG, `filePath:${filePath} File does not exist error:${err?.code} ${err?.message}`);
      return false;
    }
  }

  /**
   * 创建 JSON 文件
   */
  public static async createJsonFile(jsonPath: string, initialData: string[]): Promise<void> {
    try {
      const jsonString = JSON.stringify(initialData, null, 2);
      const file = fs.openSync(jsonPath, fs.OpenMode.CREATE | fs.OpenMode.WRITE_ONLY);
      fs.writeSync(file.fd, jsonString);
      fs.closeSync(file);
    } catch (error) {
      const err = error as BusinessError;
      log.showError(TAG, `jsonPath:${jsonPath} Creation failed error:${err?.code} ${err?.message}`);
    }
  }

  /**
   * 读取 JSON 文件
   */
  public static async readJsonFile(jsonPath: string): Promise<string> {
    try {
      const file = fs.openSync(jsonPath, fs.OpenMode.READ_ONLY);
      const stat = await fs.stat(jsonPath);
      const buffer = new ArrayBuffer(stat.size);
      fs.readSync(file.fd, buffer);

      const uint8Array = new Uint8Array(buffer);
      let jsonString = '';
      for (let i = 0; i < uint8Array.length; i++) {
        jsonString += String.fromCharCode(uint8Array[i]);
      }
      fs.closeSync(file);
      return jsonString;
    } catch (error) {
      const err = error as BusinessError;
      log.showError(TAG, `jsonPath:${jsonPath} Read failed error:${err?.code} ${err?.message}`);
      return 'fail';
    }
  }

  /**
   * 写入 JSON 文件
   */
  public static async writeJsonFile(jsonPath: string, data: string): Promise<void> {
    try {
      const file = fs.openSync(jsonPath, fs.OpenMode.CREATE | fs.OpenMode.TRUNC | fs.OpenMode.WRITE_ONLY);
      fs.writeSync(file.fd, data);
      fs.closeSync(file);
    } catch (error) {
      const err = error as BusinessError;
      log.showError(TAG, `jsonPath:${jsonPath} Write failed error:${err?.code} ${err?.message}`);
    }
  }

}