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

import fileIo from '@ohos.file.fs';
import fs from '@ohos.file.fs';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { IDofParam } from '../wallpaper/ScreenLockWallpaperManager';

const TAG = 'FileUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 文件操作工具类
 */
export class FileUtil {
  public static updateDofWallpaperConfig(dofCalcInfo: IDofParam): void {
    try {
      let fileContent = FileUtil.getDofConfigStringByObj(dofCalcInfo);
      if (!fileContent) {
        return;
      }
      FileUtil.createJsonFile(dofCalcInfo.configPath, fileContent);
      log.showWarn(`success write file, file length is ${fileContent?.length}`);
    } catch (e) {
      log.showError(`Failed to write wallpaper config, err code=${e?.code}`);
    }
  }

  public static getDofConfigStringByObj(dofCalcInfo: IDofParam): string {
    if (!dofCalcInfo) {
      log.showError('src dof info is null.');
      return '';
    }

    try {
      let wallpaperConfig: Record<string, Object> = JSON.parse(dofCalcInfo.configContent);
      wallpaperConfig.isDofDone = dofCalcInfo.isDofDone;
      wallpaperConfig.isDofShow = dofCalcInfo.isDof;
      return JSON.stringify(wallpaperConfig);
    } catch (e) {
      log.showError(`falied to get string, code=${e?.code}`);
      return '';
    }
  }

  public static getDofInfoByFile(path: string): IDofParam | undefined {
    let isDof = false;
    let isDofDone = false;
    let content = '';
    try {
      if (!fs.accessSync(path)) {
        log.showWarn('dof config file not exists');
        return undefined;
      }
      const text = fs.readTextSync(path);
      if (!text) {
        log.showWarn('dof config file is empty');
        return undefined;
      }

      const wallpaperConfig: Record<string, Object> = JSON.parse(text);
      isDof = wallpaperConfig?.isDofShow as boolean;
      isDofDone = wallpaperConfig?.isDofDone as boolean;
      content = text;
    } catch (e) {
      log.showError(`parse dof wallpaper error, code=${e?.code}`);
      return undefined;
    }
    return {
      type: null, isDof: isDof, isDofDone: isDofDone, configContent: content, pic: undefined, configPath: path
    };
  }

  /**
   * 将JSON object写入文件
   * @param jsonFilePath 文件路径
   * @param obj JSON对象
   */
  public static createJsonFile(jsonFilePath: string, jsonString: string | undefined): void {
    try {
      let file = fs.openSync(jsonFilePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      let fd = file.fd;
      try {
        fs.truncateSync(fd);
        // 写入一段内容至文件
        let writeLen = fs.writeSync(fd, jsonString);
        log.showInfo(`createJsonFile succeed ${writeLen}`);
      } catch (err) {
        log.showError(`createJsonFile error ${err?.code}`);
      } finally {
        try {
          fs.closeSync(fd);
        } catch (err) {
          log.showError(`createJsonFile error ${err?.code}`);
        }
      }
    } catch (err) {
      log.showError(`createJsonFile error ${err?.code}`);
    }
  }

  /**
   * 路径下的文件列表
   *
   * @param filePath 路径
   * @returns 文件列表
   */
  public static getDirentByPath(filePath: string): string[] {
    try {
      let fileList = fs.listFileSync(filePath);
      let res = [...fileList];
      return res;
    } catch (err) {
      log.showError(`getDirentByPath error ${err?.code}`);
      return [];
    }
  }

  /**
   * 关闭文件
   *
   * @param file 文件句柄
   * @returns true标识成功关闭
   */
  public static closeFile(file: number | fileIo.File): boolean {
    if (!file) {
      log.showInfo(TAG, 'close file error, file is null.');
      return false;
    }
    try {
      fileIo.closeSync(file);
      return true;
    } catch (e) {
      log.showError(TAG, 'closeFile error');
      return false;
    }
  }
}
