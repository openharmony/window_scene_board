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

import { Logger } from '../../base/Logger';
import { ThemePathConstant } from '../../event/TsConstant';
import { FileUtil } from '../../util/FileUtil';
import { TSCurrentThemeApi } from '../api/TSCurrentThemeApi';
import { IconsInfo } from '../model/IconsInfo';

const TAG: string = 'TSCurrentThemeApiImpl';

/**
 * 沙箱路径 A 目录
 */
const THEME_A_PATH: string = '/data/themes/a';

/**
 * 沙箱路径 B 目录
 */
const THEME_B_PATH: string = '/data/themes/b';

/**
 * 充电动效脚本文件路径
 */
const CHARGING_SCRIPT_PATH: string = '/skin/com.ohos.charging/base/script.json';
const CHARGING_SUBSCREEN_SCRIPT_PATH: string = '/system/sub_screen/skin/com.ohos.charging/base/script.json';

/**
 * 同一进程内通用Api实现，调用方为大桌面主进程
 */
class TSCurrentThemeApiImpl implements TSCurrentThemeApi {
  async hasChargingResource(): Promise<boolean[]> {
    // 判断充电动效脚本文件是否存在
    let newChargingPath: string = `${this.getActiveThemePath()}${CHARGING_SCRIPT_PATH}`;
    let oldChargingPath: string = `${this.getActiveThemePath()}/app${CHARGING_SCRIPT_PATH}`;
    let isExist: boolean = FileUtil.isFileExists(newChargingPath) || FileUtil.isFileExists(oldChargingPath);
    let newChargingSubPath: string = `${this.getActiveThemePath()}${CHARGING_SUBSCREEN_SCRIPT_PATH}`;
    let isSubExist: boolean = FileUtil.isFileExists(newChargingSubPath);
    Logger.info(TAG, `hasChargingResource = ${isExist},hasSubChargingResource = ${isSubExist}`);
    return [isExist, isSubExist];
  }

  async getIconsInfo(): Promise<IconsInfo> {
    const curIconsPath: string = `${this.getActiveThemePath()}/app/icons`;
    const descriptionPath: string = `${curIconsPath}/description.json`;
    const manifestPath: string = `${curIconsPath}/manifest.json`;
    let iconsInfo: IconsInfo = { id: '', origin: '' };
    try {
      if (FileUtil.isFileExists(descriptionPath)) {
        const descriptionContent: string = await FileUtil.readFileContent(descriptionPath);
        const description: object = JSON.parse(descriptionContent);
        iconsInfo.id = description['id'] ?? '';
        iconsInfo.origin = description['origin'] ?? '';
      }
    } catch (err) {
      Logger.error(TAG, `read icons description error`);
    }

    try {
      if ((iconsInfo.id === '' || iconsInfo.origin === '') && FileUtil.isFileExists(manifestPath)) {
        const manifestContent: string = await FileUtil.readFileContent(manifestPath);
        const manifest: object = JSON.parse(manifestContent);
        iconsInfo.id = iconsInfo.id !== '' ? iconsInfo.id : manifest['id'] ?? '';
        iconsInfo.origin = iconsInfo.origin !== '' ? iconsInfo.origin : manifest['origin'] ?? '';
      }
    } catch (err) {
      Logger.error(TAG, `read icons manifest error`);
    }

    Logger.info(TAG, `icons info id:${iconsInfo.id}, origin:${iconsInfo.origin}`);
    return iconsInfo;
  }

  /**
   * 获取当前激活的主题路径
   *
   * @return 返回当前激活的主题路径
   */
  private getActiveThemePath(): string {
    if (FileUtil.isFileExists(ThemePathConstant.THEME_A_FLAG)) {
      return THEME_A_PATH;
    } else if (FileUtil.isFileExists(ThemePathConstant.THEME_B_FLAG)) {
      return THEME_B_PATH;
    } else {
      Logger.warning(TAG, `theme resource was not found in neither A nor B directory.`);
      return '';
    }
  }
}

/**
 * 创建Api实例对象
 */
export function createCurrentThemeApi(): TSCurrentThemeApi {
  return new TSCurrentThemeApiImpl();
}