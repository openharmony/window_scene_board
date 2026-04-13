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

import { List } from '@kit.ArkTS';
import {
  ContextUtil,
  FileUtil,
  JsonUtils,
  NullableType,
  PreferenceStoreCache,
  Singleton,
  StringUtils,
  TsLog,
  VERSION_EMPTY
} from '@ohos/themeservicebase/Index';
import { Constants, TServiceApi } from '@ohos/themeservice_inner_api/Index';
import { SubScreenInfo, TYPE_COMBINED } from './SubScreenInfo';
import configPolicy from '@ohos.configPolicy';
import { systemDateTime } from '@kit.BasicServicesKit';
import { SubThemeColorRuleUtil } from './SubThemeColorRuleUtil';
import { SubThemeUtil } from './SubThemeUtil';
import { SUM_THEME_PATH } from './SubThemeHelper';

const TAG: string = 'TsSubScreenCache';

/**
 * 主题包description.json名称
 */
const DESCRIPTION: string = 'description.json';

/**
 * 主题包的相对路径
 */
const THEME_PKG_DIR: string = 'resource/themes/theme';

/**
 * 版本号1
 */
const FIRST_VERSION: number = 1;

export class TsSubScreenCache extends PreferenceStoreCache<List<SubScreenInfo>> {
  private isFirstInit: boolean = false;

  private static readonly INSTANCE: Singleton<TsSubScreenCache> =
    new Singleton<TsSubScreenCache>(() => new TsSubScreenCache());

  private constructor() {
    super(TServiceApi.preference(ContextUtil.getTsApplicationContext(), 'ts_smallSubScreens'),
      (oldVersion, newVersion, oldData) => {
        TsLog.info(TAG, `oldVersion:${oldVersion} -> newVersion:${newVersion}`);
        if (oldVersion === VERSION_EMPTY) {
          this.isFirstInit = true;
          return this.initDefaultSubTheme();
        }
        return undefined;
      }, FIRST_VERSION);
  }

  /**
   * 设置是否处于首次初始化状态
   *
   * @param isFirstInit 是否首次初始化
   */
  public setIsFirstInit(isFirstInit: boolean): void {
    if (this.isFirstInit !== isFirstInit) {
      this.isFirstInit = isFirstInit;
    }
  }

  /**
   * 获得是否处于首次初始化状态
   *
   * @return isFirstInit 是否首次初始化
   */
  public getIsFirstInit(): boolean {
    return this.isFirstInit;
  }

  private async getDefaultDirWithColorRule(dir: string): Promise<string> {
    let colorJsonObject: Nullable<object> = await SubThemeColorRuleUtil.getThemeColorJsonObject();
    let defaultDir: string = dir;
    if (colorJsonObject && String(Object.values(colorJsonObject)[0]) === dir) {
      defaultDir = this.updateDefaultDirWithColorRule(colorJsonObject, dir);
    }
    return defaultDir;
  }

  private updateDefaultDirWithColorRule(colorRule: object, dir: string): string {
    let backColor: string = SubThemeColorRuleUtil.getDeviceBackColor();
    TsLog.info(TAG, `backColor = ${backColor}`);
    let value: object = colorRule[`${backColor}`];
    if (!value) {
      TsLog.info(TAG, `updateDefaultDirWithColorRule, not match color rule`);
      return dir;
    }
    return String(value);
  }

  /**
   * 初始化默认应用主题
   */
  public async initDefaultSubTheme(): Promise<Nullable<List<SubScreenInfo>>> {
    let themeDir: string = '';
    try {
      themeDir = await configPolicy.getOneCfgFile(THEME_PKG_DIR);
    } catch (error) {
      TsLog.error(TAG, `initDefaultSubTheme error.`);
      return undefined;
    }
    let defaultPath: string = themeDir + Constants.FILE_SEPARATOR + Constants.DEFAULT_THEME_NAME;
    defaultPath = await this.getDefaultDirWithColorRule(defaultPath) + Constants.FILE_SEPARATOR +
      Constants.SUB_SCREEN_PREFIX;
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
      let json: object | undefined = JsonUtils.parse(content);
      let userSubScreenThemeList: List<SubScreenInfo> = new List<SubScreenInfo>();
      if (json) {
        let subTheme: SubScreenInfo = await this.parseDefaultTheme(json, defaultPath);
        userSubScreenThemeList.add(subTheme);
      }
      return userSubScreenThemeList;
    } catch (error) {
      TsLog.error(TAG, `initDefaultSubTheme error: ${error?.message}`);
      return undefined;
    }
  }

  private async parseDefaultTheme(json : object, defaultPath : string) : Promise<SubScreenInfo> {
    let themeId: string = json[Constants.ID_PREFIX];
    const subThemeEditorId: string = '0000000000000';
    const targetDir: string = `${SUM_THEME_PATH}${subThemeEditorId}`;
    // theme is not existing in outScreen path, no need to remove target dir
    const copyRet: boolean = await FileUtil.copyDirAsync(`${defaultPath}`, `${targetDir}`);
    if (!copyRet) {
      TsLog.warning(TAG, `copy fail src: ${defaultPath}`);
    }
    let defaultSubTheme: SubScreenInfo =
      new SubScreenInfo(themeId, subThemeEditorId, defaultPath, targetDir + '/sub_screen');
    defaultSubTheme.type = TYPE_COMBINED;
    defaultSubTheme.isEnabled = true;
    defaultSubTheme.isSuite = true;
    SubThemeUtil.checkThemePackage(subThemeEditorId, targetDir + '/sub_screen');
    return defaultSubTheme;
  }

  /**
   * 获取单例对象
   *
   * @returns 对象
   */
  public static getInstance(): TsSubScreenCache {
    return TsSubScreenCache.INSTANCE.get();
  }
}