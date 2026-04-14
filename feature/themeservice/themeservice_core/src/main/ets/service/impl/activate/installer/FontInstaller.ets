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

import { ORIGIN_PRESET, TARGET_FONT, ThemeInfo } from '@ohos/themeservice_inner_api';
import { FileUtil, JsonUtils, NullableType, TsLog } from '@ohos/themeservicebase';
import { PresetThemeExtCache } from '../../../../cache/PresetThemeCache';
import { TSPathUtils } from '../../../../util/TSPathUtils';
import { FontInfo } from '../../../model/FontInfo';
import { ResourceBasicInstaller } from './ResourceBasicInstaller';
import { ActivatedThemeUtil } from '../../../../util/ActivatedThemeUtil';

const TAG: string = `FontInstaller`;

export class FontInstaller extends ResourceBasicInstaller {
  constructor(themeInfo: ThemeInfo) {
    super(TARGET_FONT, themeInfo);
  }

  protected overlayMode(): boolean {
    return !this.hasCustomFont();
  }

  protected keepCustom(): boolean {
    return false;
  }

  private hasCustomFont(): boolean {
    let customFontPath: NullableType<string> = this.getThemeTypeCustomPath();
    if (!customFontPath) {
      return false;
    }
    return FileUtil.isFileExists(`${customFontPath}/manifest.json`);
  }

  async install(): Promise<boolean> {
    let installRet: boolean = await super.install();
    if (installRet) {
      return true;
    }
    installRet = await this.installPresetFonts();
    if (!installRet) {
      const activatedFonts: string = `${ActivatedThemeUtil.getActivatedThemePath()}${'app/'}${this.getThemeType()}`;
      if (FileUtil.isFileExists(`${activatedFonts}/manifest.json`)) {
        installRet = await FileUtil.copyDirAsync(activatedFonts, TSPathUtils.getTsPackagedPath());
        TsLog.info(TAG, `extends activated fonts:${installRet}`);
      }
    }
    return installRet;
  }

  private async installPresetFonts(): Promise<boolean> {
    const currentThemeId: string = this.getThemeInfo().id;
    const presetFontPath: NullableType<string> = await PresetThemeExtCache.getInstance().getFontsPath(currentThemeId);
    if (!presetFontPath || !FileUtil.isFileExists(presetFontPath)) {
      return false;
    }
    const fontManifest: string = await FileUtil.readFileContent(`${presetFontPath}/manifest.json`);
    try {
      TsLog.info(TAG, `prepare preset fonts related resource`);
      const fontManifestObj: object = JSON.parse(fontManifest);
      const fontId: string = fontManifestObj['id'];
      const fontName: string = fontManifestObj['src'];
      const fontNameExt: Nullable<string[]> = fontManifestObj['srcExt'];
      const multiWeight: boolean = fontManifestObj['multiWeight'];
      const fontPackagePath: string = `${TSPathUtils.getTsPackagedPath()}/${TARGET_FONT}`;
      TsLog.info(TAG, `installPresetFonts fontNameExt length: ${fontNameExt?.length}`);
      FileUtil.createDirRecur(fontPackagePath);
      let fontPath: string = TSPathUtils.getFontPath(presetFontPath, fontName);
      const fontTargetPath: string = `${fontPackagePath}/${FileUtil.getFileName(fontPath)}`;
      await FileUtil.copyFileAsync(fontPath, fontTargetPath);
      const fontInfo: FontInfo = {
        id: fontId,
        origin: ORIGIN_PRESET,
        src: FileUtil.getFileName(fontName),
        srcExt: TSPathUtils.getFontNameExt(fontName, fontNameExt),
        ttfFileSrc: fontPath,
        ttfFileSrcExt: TSPathUtils.getFontPathExt(presetFontPath, fontName, fontNameExt),
        multiWeight: multiWeight
      }
      const manifestFile: string = `${fontPackagePath}/manifest.json`;
      const descriptionFile: string = `${fontPackagePath}/description.json`;
      FileUtil.writeFileSync(manifestFile, JsonUtils.stringify(fontInfo));
      let emitArg: Record<string, string> = {
        'id': fontId,
        'origin': ORIGIN_PRESET
      }
      FileUtil.writeFileSync(descriptionFile, JsonUtils.stringify(emitArg));
      return true;
    } catch (error) {
      TsLog.warning(TAG, `parse font manifest error`);
    }
    return false;
  }
}