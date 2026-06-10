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

import { List } from '@kit.ArkTS';
import {
  ContextUtil,
  FileUtil,
  NullableType,
  PreferenceStoreCache,
  Singleton,
  StringUtils,
  TsLog,
  VERSION_EMPTY
} from '@ohos/themeservicebase/Index';
import { Constants, TServiceApi } from '@ohos/themeservice_inner_api/Index';
import { LemSubScreenInfo } from './LemSubScreenInfo';
import configPolicy from '@ohos.configPolicy';

const TAG: string = 'LemTsSubScreenCache';

/**
 * 主题包description.json名称
 */
const DESCRIPTION: string = 'description.json';

/**
 * 默认版本号
 */
const VERSION_DEFAULT: number = 0;

/**
 * 版本号1
 */
const FIRST_VERSION: number = 1;

export class LemTsSubScreenCache extends PreferenceStoreCache<List<LemSubScreenInfo>> {
  private static readonly INSTANCE: Singleton<LemTsSubScreenCache> =
    new Singleton<LemTsSubScreenCache>(() => new LemTsSubScreenCache());
  private readonly ONE_VERSION_MAP: Map<string, string> = new Map([
    ['000001', '2179312457'],
    ['000015', '2179312417'],
    ['000016', '2179312437'],
  ]);

  private constructor() {
    super(TServiceApi.preference(ContextUtil.getTsApplicationContext(), 'ts_lemSubScreens'),
      (oldVersion, newVersion, oldData) => {
        TsLog.info(TAG, `oldVersion:${oldVersion} -> newVersion:${newVersion}`);
        if (oldVersion === VERSION_EMPTY) {
          return this.initDefaultSubTheme();
        } else if (oldVersion === VERSION_DEFAULT) {
          return this.oneVersionMigrate(oldData);
        }
        return undefined;
      }, FIRST_VERSION);
  }

  private oneVersionMigrate(oldData: NullableType<List<LemSubScreenInfo>>): List<LemSubScreenInfo> {
    let userSubScreenThemeList: List<LemSubScreenInfo> = new List();
    oldData?.forEach((info) => {
      let themeId: string | undefined = this.ONE_VERSION_MAP.get(info.themeId);
      let newInfo: LemSubScreenInfo;
      let path: string = info.type === 'preset' ? info.path.replace('themes', 'themes/theme') : info.path;
      if (themeId) {
        TsLog.info(TAG, `themeId:${info.themeId}`);
        newInfo = new LemSubScreenInfo(themeId, path);
      } else {
        newInfo = new LemSubScreenInfo(info.themeId, path);
      }
      newInfo.battery = info.battery;
      newInfo.vibration = info.vibration;
      newInfo.sound = info.sound;
      newInfo.order = info.order;
      userSubScreenThemeList.add(newInfo);
    });
    return userSubScreenThemeList;
  }

  private async initDefaultSubTheme(): Promise<Nullable<List<LemSubScreenInfo>>> {
    let themeDir: string = '';
    try {
      themeDir = await configPolicy.getOneCfgFile('resource/themes/theme');
    } catch (error) {
      TsLog.error(TAG, `initDefaultSubTheme error.`);
      return undefined;
    }
    let defaultPath: string = themeDir + Constants.FILE_SEPARATOR + Constants.DEFAULT_THEME_NAME +
    Constants.FILE_SEPARATOR + Constants.SUB_SCREEN_PREFIX;
    if (!FileUtil.isFileExists(defaultPath)) {
      TsLog.error(TAG, `initDefaultSubTheme not exist.`);
      return undefined;
    }
    let content: string = FileUtil.getStringByFile(defaultPath + Constants.FILE_SEPARATOR + DESCRIPTION);
    if (StringUtils.isEmpty(content)) {
      TsLog.error(TAG, 'Error, no default sub screen theme.');
      return undefined;
    }
    try {
      let json: object = JSON.parse(content);
      let themeId: string = json[Constants.ID_PREFIX];
      let defaultSubTheme: LemSubScreenInfo = new LemSubScreenInfo(themeId, defaultPath);
      let userSubScreenThemeList: List<LemSubScreenInfo> = new List<LemSubScreenInfo>();
      userSubScreenThemeList.add(defaultSubTheme);
      return userSubScreenThemeList;
    } catch (error) {
      TsLog.error(TAG, `initDefaultSubTheme error: ${error?.message}`);
      return undefined;
    }
  }

  /**
   * 获取单例对象
   *
   * @returns 对象
   */
  public static getInstance(): LemTsSubScreenCache {
    return LemTsSubScreenCache.INSTANCE.get();
  }
}