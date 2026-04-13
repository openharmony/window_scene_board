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

import {
  CheckEmptyUtils,
  SingletonHelper,
  FileUtils,
  LogDomain,
  LogHelper
} from '@ohos/basicutils';
import configPolicy from '@ohos.configPolicy';
import { EditModeConstants, ManifestData } from '../common/constants/EditModeConstants';
import IconEditPageConstants from '../common/constants/IconEditPageConstants';

const TAG: string = 'ThemeActiveManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 预置主题相对路径
 */
const THEME_RESOURCE_SRC = 'resource/themes/icon';

/**
 * 主题包Icon路径名称
 */
const ICON_NAME = 'Icon';

/**
 * 主题包Icon路径名称
 */
const MANIFEST_FILE_NAME = 'manifest.json';

/**
 * 主题包Icon路径名称
 */
const ICON_PATH = 'icon';

/**
 * 使能主题
 */
export class ThemeActiveManager {
  /**
   * 获取当前的iconID
   *
   * @returns 当前的iconID
   */
  public getCurrentIconId(iconPaths: string[]): string {
    let activatedThemePath: string = this.getActivatedThemePath();
    if (CheckEmptyUtils.isEmpty(activatedThemePath)) {
      log.showError('can not find activated theme');
      return this.getIconPath(iconPaths);
    }
    const isPathA: boolean = activatedThemePath === EditModeConstants.ACTIVATED_PATH_A;
    log.showInfo('get activated theme success, isPathA: %{public}s', isPathA);
    let configPath = activatedThemePath + EditModeConstants.ACTIVATED_CONFIG;
    if (!FileUtils.isExist(configPath)) {
      log.showError('can not find config');
      return this.getIconPath(iconPaths);
    }

    let description: ManifestData = this.parseManifest(configPath);
    let activeIconId: string = description.id;
    if (CheckEmptyUtils.isEmpty(activeIconId)) {
      log.showError('can not find active iconId');
      return this.getIconPath(iconPaths);
    }
    for (let i = 0; i < iconPaths.length; i++) {
      let iconDir = iconPaths[i] + EditModeConstants.FILE_SEPARATOR + MANIFEST_FILE_NAME;
      let iconPathDescription: ManifestData = this.parseManifest(iconDir);
      if (iconPathDescription.id === activeIconId) {
        return iconPaths[i];
      }
    }
    return this.getIconPath(iconPaths);
  }

  private getIconPath(iconPaths: string[]): string {
    return iconPaths.length !== 0 ? iconPaths[0] : IconEditPageConstants.PREVIEW_PATH_DEFAULT;
  }

  private parseManifest(configPath: string): ManifestData {
    let description: ManifestData = {
      id: '',
      preview: ''
    };
    let descriptionContent: string = FileUtils.readTextSync(configPath);
    try {
      const manifest: object = JSON.parse(descriptionContent);
      description.id = manifest['id'] ?? '';
      description.preview = manifest['preview'] ?? '';
      log.showInfo('parse manifest file success, id: %{public}s', description.id);
    } catch (e) {
      log.showError('Parse manifest file failed error:' + e);
    }
    return description;
  }

  private getActivatedThemePath(): string {
    if (FileUtils.isExist(EditModeConstants.ACTIVATED_PATH_A + EditModeConstants.ACTIVATED_FLAG)) {
      return EditModeConstants.ACTIVATED_PATH_A;
    } else if (FileUtils.isExist(EditModeConstants.ACTIVATED_PATH_B + EditModeConstants.ACTIVATED_FLAG)) {
      return EditModeConstants.ACTIVATED_PATH_B;
    } else {
      return '';
    }
  }

  /**
   * 读取所有的iconPath
   *
   * @returns iconPath路径
   */
  public readAllIconResourceSync(): string[] {
    let themeDir = configPolicy.getOneCfgFileSync(THEME_RESOURCE_SRC);
    return this.readIconResource(themeDir);
  }

  /**
   * 读取所有的iconPath
   *
   * @returns iconPath路径
   */
  public async readAllIconResource(): Promise<string[]> {
    let themeDir = await configPolicy.getOneCfgFile(THEME_RESOURCE_SRC);
    return this.readIconResource(themeDir);
  }

  private readIconResource(rootPath: string): string[] {
    let iconPath: string[] = [];
    let fileNames = FileUtils.getFileList(rootPath);
    for (let fileName of fileNames) {
      if (fileName.startsWith(ICON_NAME)) {
        iconPath.push(rootPath + EditModeConstants.FILE_SEPARATOR + fileName);
      }
    }
    log.showInfo('readAllIconResource iconPath');
    return iconPath;
  }
}

// 单例
export const THEME_ACTIVE_MANAGER = SingletonHelper.getInstance(ThemeActiveManager, TAG);