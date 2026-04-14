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
import { configPolicy, systemParameterEnhance } from '@kit.BasicServicesKit';
import { FileUtil, TsLog } from '@ohos/themeservicebase';
import { JSON } from '@kit.ArkTS';

const TAG: string = 'ThemeColorRuleUtil';

const colorCfgPath: string = 'etc/themes/defaultThemePerDeviceColor.json';

interface ThemeConfig {
  type: string;
  rules?: Record<string, string>;
}

export class ThemeColorRuleUtil {
  /**
   * 获取背壳颜色与主题对应关系
   * @returns
   */
  public static async getThemeColorJsonObject(): Promise<Nullable<object>> {
    let dirList: string[] = [];
    let jsonPath: string = '';
    try {
      dirList = await configPolicy.getCfgFiles(colorCfgPath);
    } catch (error) {
      TsLog.warning(TAG, `config policy get error:${error.code},message:${error.msg}`);
      return;
    }
    for (let dir of dirList) {
      if (FileUtil.isFileExists(`${dir}`)) {
        // 使用优先级最高匹配的优先级
        jsonPath = dir;
      }
    }
    if (jsonPath === '') {
      TsLog.warning(TAG, `getThemeColorJsonObject, not find the json`);
      return;
    }
    let jsonContent: string;
    let themeConfig: ThemeConfig;
    try {
      jsonContent = await FileUtil.readFileContent(jsonPath);
      themeConfig = JSON.parse(jsonContent) as ThemeConfig;
    } catch (error) {
      TsLog.warning(TAG, `Error reading file : ${error.message}`);
      return;
    }
    if (themeConfig.type === 'sku') {
      TsLog.warning(TAG, `Theme type is 'sku', returning null`);
      return;
    }
    if (themeConfig.rules) {
      return themeConfig.rules;
    }
    return themeConfig;
  }

  /**
   * 获取设备背壳颜色
   * @returns 背壳颜色
   */
  public static getDeviceBackColor(): string {
    let backColor: string = '';
    try {
      backColor = systemParameterEnhance.getSync('ohos.boot.backcolor', '');
    } catch (err) {
      TsLog.error(TAG, ` getDeviceBackColor catch exception. code:${err.code}, message:${err.message}`);
      return backColor;
    }
    return backColor;
  }
}