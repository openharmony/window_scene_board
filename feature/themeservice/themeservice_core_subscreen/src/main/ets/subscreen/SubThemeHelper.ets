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

import fs from '@ohos.file.fs';
import List from '@ohos.util.List';
import { FileUtil, JsonUtils, NullableType, TsLog } from '@ohos/themeservicebase';
import { SubScreenInfo } from './SubScreenInfo';
import { ArkTSUtils } from '@kit.ArkTS';

export const COVER_DIR: string = '';
const BASE_DIR: string = '/data/storage/el2/base';
export const THEME_ROOT_DIR: string = '/data/themes/s/subthemes';
export const SUM_THEME_PATH: string = '/data/themes/s/subthemes/t_pkg_sub_screen/';
const FILE_SEPARATOR: string = '/';
const DESCRIPTION: string = 'description.json';
const LOCK_PREFIX: string = 'lock';
const INTERVAL_NUMBER: number = 10;

const TAG: string = 'SubThemeHelper';

export class SubThemeHelper {
  private static lock_: ArkTSUtils.locks.AsyncLock = new ArkTSUtils.locks.AsyncLock();

  /**
   * 迁移主题包
   */
  public static async moveThemePkg(cachedSubThemeInfoList: NullableType<List<SubScreenInfo>>): Promise<void> {
    // 仅hap改造上线后，用户首次升级场景进行主题包迁移
    if (FileUtil.isFileExists(BASE_DIR) && !FileUtil.isFileExists(COVER_DIR)) {
      TsLog.info(TAG, 'no need excute moveThemePkg');
      return;
    }
    TsLog.info(TAG, 'try get lock');
    await SubThemeHelper.lock_.lockAsync(async () => {
      TsLog.info(TAG, 'get lock');
      await SubThemeHelper.copyAndDelCover(cachedSubThemeInfoList);
      TsLog.info(TAG, 'release lock');
    })
  }

  private static async copyAndDelCover(cachedSubThemeInfoList: NullableType<List<SubScreenInfo>>): Promise<void> {
    TsLog.info(TAG, 'copyAndDelCover start...');
    if (FileUtil.isFileExists(COVER_DIR)) {
      try {
        TsLog.info(TAG, 'copy old theme data start...');
        const copyRet: boolean = await FileUtil.copyDirAsync(`${COVER_DIR}`, `${THEME_ROOT_DIR}`);
        // 针对movingPhoto做特殊处理 重新复制video
        cachedSubThemeInfoList?.forEach((item: SubScreenInfo) => {
          SubThemeHelper.copyMovingPhotoVideo(item.customPath);
        });
        if (!copyRet) {
          TsLog.error(TAG, `copy fail src fail`);
        } else {
          const rmRet = await FileUtil.rmdirAsync(COVER_DIR);
          TsLog.info(TAG, `rm coverDir ret: ${rmRet}`);
        }
        TsLog.info(TAG, 'copy old theme data end...');
      } catch (error) {
        TsLog.error(TAG, `copy themes fail: ${error?.message}`);
      }
    }
  }

  private static copyMovingPhotoVideo(path: string) {
    try {
      if (!FileUtil.isFileExists(path + FILE_SEPARATOR + LOCK_PREFIX + FILE_SEPARATOR + DESCRIPTION)) {
        return;
      }
      let content: string = FileUtil.getStringByFile(path + FILE_SEPARATOR + LOCK_PREFIX +
        FILE_SEPARATOR + DESCRIPTION);
      let json: object | undefined = JsonUtils.parse(content);
      let videoName: string = '';
      if (json) {
        videoName = json['movingPhoto']['src'];
      }
      TsLog.info(TAG, `videoName:${videoName}`);
      const videoPath: string = path + FILE_SEPARATOR + LOCK_PREFIX + FILE_SEPARATOR + 'origin/resources/' + videoName;
      const coverDir: string = COVER_DIR;
      if (FileUtil.isFileExists(videoPath)) {
        SubThemeHelper.copyFile(videoPath, videoPath.replace(coverDir, SUM_THEME_PATH));
      }
    } catch (error) {
      TsLog.error(TAG, `copyMovingPhotoVideo error: ${error?.message}`);
    }
  }


  private static copyFile(srcPath: string, destPath: string) {
    try {
      let file: fs.File = fs.openSync(srcPath);
      let fd: number = file.fd;
      let stat = fs.statSync(fd);
      let buf = new ArrayBuffer(stat.size);
      fs.readSync(fd, buf);
      fs.close(file);

      let isExist = fs.accessSync(destPath);
      let outFile: fs.File | null = null;
      if (isExist) {
        fs.unlinkSync(destPath);
        outFile = fs.openSync(destPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      } else {
        outFile = fs.openSync(destPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      }
      fs.writeSync(outFile.fd, buf);
      fs.close(outFile);
    } catch (err) {
      TsLog.info(TAG, 'write error');
    }
  }
}