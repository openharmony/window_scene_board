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
import { ThemeInfo } from '@ohos/themeservice_inner_api/Index';
import { TARGET_SKIN } from '@ohos/themeservice_inner_api/src/main/ets/constant/TSTypes';
import { FileUtil, JsonUtils, NullableType, TsLog } from '@ohos/themeservicebase/Index';
import { TSPathUtils } from '../../../../util/TSPathUtils';
import { SkinExtensionResInstaller } from './extension/SkinExtensionResInstaller';
import { ResourceBasicInstaller } from './ResourceBasicInstaller';

const TAG: string = `SkinInstaller`;

// 音频管家包名
const audioBundleName = 'com.ohos.audioaccessorymanager';

export class SkinInstaller extends ResourceBasicInstaller {
  constructor(themeInfo: ThemeInfo) {
    super(TARGET_SKIN, themeInfo);
  }

  async install(): Promise<boolean> {
    const ret = await super.install();
    if (ret) {
      await this.writeAudioDescription();
    }
    return ret;
  }

  protected overlayMode(): boolean {
    if (this.hasCustomSkin()) {
      return false;
    }
    return true;
  }

  private hasCustomSkin(): boolean {
    let customSkinPath: NullableType<string> = this.getThemeTypeCustomPath();
    if (!customSkinPath) {
      return false;
    }
    return FileUtil.isFileExists(`${customSkinPath}`);
  }

  protected keepCustom(): boolean {
    return false;
  }

  private async writeAudioDescription() {
    const tsSkinPath = `${TSPathUtils.getTsPackagedPath()}/${TARGET_SKIN}`;
    if (!FileUtil.isFileExists(`${tsSkinPath}/${audioBundleName}`)) {
      return;
    }
    const descriptionPath = `${tsSkinPath}/${audioBundleName}/description.json`;
    try {
      let descriptionContent = '';
      if (!FileUtil.isFileExists(descriptionPath)) {
        descriptionContent = await FileUtil.readFileContent(`${tsSkinPath}/description.json`);
      } else {
        descriptionContent = await FileUtil.readFileContent(descriptionPath);
      }
      const description: object = JSON.parse(descriptionContent);
      description['applyTime'] = Date.now();
      FileUtil.writeFileSync(descriptionPath, JsonUtils.stringify(description));
    } catch (err) {
      TsLog.warning(TAG, `writeAudioDescription err: ${err}`);
    }
  }

  public async installExtension(style: string): Promise<boolean> {
    if (!this.hasExtensionRes()) {
      TsLog.info(TAG, `${this.getThemeType()} not has extension`);
      return false;
    }
    let extensionInstaller: SkinExtensionResInstaller = new SkinExtensionResInstaller(TARGET_SKIN, this.getThemeInfo());
    return extensionInstaller.install(style);
  }
}

