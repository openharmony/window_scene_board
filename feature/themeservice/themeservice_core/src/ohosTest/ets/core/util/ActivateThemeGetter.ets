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
import { FileUtil, TsLog } from '@ohos/themeservicebase/Index';


const TAG: string = 'ActivateThemeUtil';

/**
 * A/B目录正在使用主题工具类
 */
export class ActivateThemeGetter {
  private static readonly ACTIVATED_PATH_A: string = '/data/themes/a/';
  private static readonly ACTIVATED_PATH_B: string = '/data/themes/b/';
  private static readonly ACTIVATED_FLAG: string = 'app/flag';

  public static getActivatedThemePath(): Nullable<string> {
    if (FileUtil.isFileExists(ActivateThemeGetter.ACTIVATED_PATH_A + ActivateThemeGetter.ACTIVATED_FLAG)) {
      return ActivateThemeGetter.ACTIVATED_PATH_A;
    } else if (FileUtil.isFileExists(ActivateThemeGetter.ACTIVATED_PATH_B + ActivateThemeGetter.ACTIVATED_FLAG)) {
      return ActivateThemeGetter.ACTIVATED_PATH_B;
    } else {
      return undefined;
    }
  }

  public static async getActivatedThemeCfg(cfgPath: string): Promise<Nullable<string>> {
    const activatedThemePath: Nullable<string> = ActivateThemeGetter.getActivatedThemePath();
    if (!activatedThemePath) {
      return undefined;
    }
    let cfgFile: string = `${activatedThemePath}${cfgPath}`;
    return FileUtil.readFileContent(cfgFile);
  }

  public static async getCurrentFontId(): Promise<Nullable<string>> {
    try {
      let cfgFileContent: Nullable<string> = await ActivateThemeGetter.getActivatedThemeCfg(`app/fonts/manifest.json`);
      TsLog.debug(TAG, `getCurrentFontId:${cfgFileContent}`);
      if (cfgFileContent) {
        let cfg: object = JSON.parse(cfgFileContent);
        let id: string = cfg?.[`id`];
        return id;
      }
    } catch (err) {
      TsLog.error(TAG, `getCurrentFontId catch exception.`, err);
    }
    return;
  }

  public static async getCurrentThemeId(): Promise<Nullable<string>> {
    try {
      let descriptionContent: Nullable<string> = await ActivateThemeGetter.getActivatedThemeCfg(`system/description.json`);
      if (descriptionContent) {
        let description: object = JSON.parse(descriptionContent);
        let id: string = description?.[`id`];
        return id;
      }
    } catch (err) {
      TsLog.error(TAG, `getCurrentThemeId catch exception.`, err);
    }
    return undefined;
  }
}