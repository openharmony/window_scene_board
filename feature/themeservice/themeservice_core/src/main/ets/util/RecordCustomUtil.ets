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
import { ORIGIN_PRESET, ThemeInfo } from '@ohos/themeservice_inner_api';
import { FileUtil, JsonUtils, TsLog } from '@ohos/themeservicebase';
import { TSPathUtils } from './TSPathUtils';

const TAG: string = `RecordCustomUtil`;

const srcConfig: string = `/data/themes/s/themeService/ThemeSrcConfig.json`;

const customConfig: string = `/data/themes/s/themeService/ThemeCustomConfig.json`;

// 可以强制升级的资源
const FORCE_UPDATE_RES: string[] = [`aod`, `long_take`, `lock`, `home`];

interface SrcFile {
  src: string;
}

interface CustomFiles {
  aod?: string[],
  long_take?: string[],
  lock?: string[],
  home?: string[]
}

export class RecordCustomUtil {
  /**
   * 记录当前使能的主题增量信息，范围[aod,longTake,lock,home]
   *
   * @param needRecord 是否需要记录
   * @param themeInfo 主题信息
   * @returns
   */
  public static async recordCustomFilesName(needRecord: boolean, themeInfo: ThemeInfo): Promise<void> {
    if (!needRecord) {
      TsLog.info(TAG, `no need record`);
      return;
    }
    await FileUtil.deleteAsync(srcConfig);
    await FileUtil.deleteAsync(customConfig);
    if (themeInfo.originThemePack?.origin !== ORIGIN_PRESET) {
      TsLog.info(TAG, `origin is not preset`);
      return;
    }

    let srcRecorder: SrcFile = { src: `${themeInfo.originThemePack?.srcPath}` };
    FileUtil.writeFileSync(srcConfig, `${JsonUtils.stringify(srcRecorder)}`);

    const customPath: string = `${TSPathUtils.getThemeCustomPackagePath(themeInfo)}`;
    const fileNames: string[] = await FileUtil.listFileNames(customPath);
    if (fileNames.length === 0) {
      TsLog.info(TAG, `custom resource files is empty`);
      return;
    }
    let customRecorders: CustomFiles = {};
    for (let fileName of fileNames) {
      if (!FORCE_UPDATE_RES.includes(fileName)) {
        continue;
      }
      let customFilePath: string = `${customPath}/${fileName}`;
      const customFileNames: string[] = await FileUtil.listFileNames(customFilePath, true);
      if (customFileNames.length === 0) {
        continue;
      }
      RecordCustomUtil.matchKey(fileName, customRecorders, customFileNames);
    }
    FileUtil.writeFileSync(customConfig, `${JsonUtils.stringify(customRecorders)}`);
  }

  private static matchKey(key: string, customFiles: CustomFiles, fileNames: string[]) {
    switch (key) {
      case `aod`:
        customFiles.aod = fileNames;
        break;
      case `long_take`:
        customFiles.long_take = fileNames;
        break;
      case `lock`:
        customFiles.lock = fileNames;
        break;
      case `home`:
        customFiles.home = fileNames;
        break;
      default:
        break;
    }
  }
}