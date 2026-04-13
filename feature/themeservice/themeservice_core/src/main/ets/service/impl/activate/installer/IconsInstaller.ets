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
import { FileUtil, JsonUtils, NullableType, TsLog } from '@ohos/themeservicebase/Index';

import { ThemeInfo } from '@ohos/themeservice_inner_api/Index';
import { ORIGIN_PRESET, TARGET_ICONS } from '@ohos/themeservice_inner_api/src/main/ets/constant/TSTypes';
import { PresetThemeExtCache } from '../../../../cache/PresetThemeCache';
import { TSPathUtils } from '../../../../util/TSPathUtils';
import { ResourceBasicInstaller } from './ResourceBasicInstaller';

const TAG: string = `IconsInstaller`;

export class IconsInstaller extends ResourceBasicInstaller {
  constructor(themeInfo: ThemeInfo) {
    super(TARGET_ICONS, themeInfo);
  }

  async install(): Promise<boolean> {
    let copyRet: boolean = await super.install();
    if (copyRet) {
      return true;
    }
    return this.installPresetIcons();
  }

  protected overlayMode(): boolean {
    // 图标资源如果有自定义资源，使用自定义资源，不使用增量覆盖模式
    if (super.getThemeTypeCustomPath()) {
      return false;
    }
    return true;
  }

  protected keepCustom(): boolean {
    return false;
  }

  private async installPresetIcons(): Promise<boolean> {
    const currentThemeId: string = this.getThemeInfo().id;
    const presetIconPath: NullableType<string> = await PresetThemeExtCache.getInstance().getIconPath(currentThemeId);
    if (!presetIconPath || !FileUtil.isFileExists(presetIconPath)) {
      TsLog.error(TAG, `prepare preset icon fail,presetIconPath`);
      return false;
    }
    TsLog.info(TAG, `prepare preset icon related resource`);
    if (!await FileUtil.copyDirAsync(`${presetIconPath}/${TARGET_ICONS}`, TSPathUtils.getTsPackagedPath())) {
      TsLog.warning(TAG, `install preset icon related resource fail current theme id:${currentThemeId}`);
      return false;
    }
    const iconPackagePath: string = `${TSPathUtils.getTsPackagedPath()}/${TARGET_ICONS}`;
    try {
      const manifestContent: string = await FileUtil.readFileContent(`${presetIconPath}/manifest.json`);
      const manifest: object = JSON.parse(manifestContent);
      const descriptionFile: string = `${iconPackagePath}/description.json`;
      let emitArg: Record<string, string> = {
        'id': manifest['id'],
        'origin': ORIGIN_PRESET
      }
      FileUtil.writeFileSync(descriptionFile, JsonUtils.stringify(emitArg));
    } catch (err) {
      TsLog.warning(TAG, 'read icon manifest fail', err);
    }
    return await FileUtil.copyFileAsync(`${presetIconPath}/manifest.json`, `${iconPackagePath}/manifest.json`);
  }
}

