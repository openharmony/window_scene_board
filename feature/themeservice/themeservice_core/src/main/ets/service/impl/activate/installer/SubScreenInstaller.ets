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
import { Constants, TARGET_SKIN, TARGET_SUB_SCREEN, ThemeInfo } from '@ohos/themeservice_inner_api';
import { FileUtil, TsLog } from '@ohos/themeservicebase';
import { TSPathUtils } from '../../../../util/TSPathUtils';
import { ActivatedThemeUtil } from '../../../../util/ActivatedThemeUtil';
import { ResourceBasicInstaller } from './ResourceBasicInstaller';
import { SubSkinExtensionResInstaller } from './extension/SubSkinExtensionResInstaller';

const TAG: string = 'SubScreenInstaller';

export class SubScreenInstaller extends ResourceBasicInstaller {
  constructor(themeInfo: ThemeInfo) {
    super(Constants.SUB_SCREEN_PREFIX, themeInfo);
  }

  async install(): Promise<boolean> {
    if (await super.install()) {
      await this.deleteSkinExtension();
      return true;
    }
    let resourceThemeSrc: string = `${ActivatedThemeUtil.getActivatedThemePath()}${'system/'}${this.getThemeType()}`;
    if (FileUtil.isFileExists(resourceThemeSrc)) {
      TsLog.info(TAG, 'install getActivatedThemePath');
      return FileUtil.copyDirAsync(resourceThemeSrc, TSPathUtils.getTsPackagedPath());
    }
    TsLog.error(TAG, 'No activated sub screen theme');
    return false;
  }

  /**
   * 原始主题包sub_screen中的skin_extension不需要应用到ab目录
   */
  private async deleteSkinExtension(): Promise<void> {
    let skinExtensionPath: string = `${TSPathUtils.getTsPackagedPath()}/sub_screen/skin_extension`;
    if (FileUtil.isFileExists(skinExtensionPath)) {
      TsLog.info(TAG, 'delete skin_extension');
      await FileUtil.rmdirAsync(skinExtensionPath);
    }
  }

  public async installExtension(style: string): Promise<boolean> {
    if (!this.hasSkinExtensionRes()) {
      TsLog.info(TAG, `${this.getThemeType()} not has extension`);
      return false;
    }
    let extensionInstaller: SubSkinExtensionResInstaller = new SubSkinExtensionResInstaller('skin', this.getThemeInfo());
    return extensionInstaller.install(style);
  }

  private hasSkinExtensionRes() {
    let path: string | undefined = this.getThemeInfo().originThemePack?.srcPath;
    if (!FileUtil.isFileExists(path)) {
      return false;
    }
    return FileUtil.isFileExists(`${path}/${TARGET_SUB_SCREEN}/${TARGET_SKIN}_extension`);
  }
}