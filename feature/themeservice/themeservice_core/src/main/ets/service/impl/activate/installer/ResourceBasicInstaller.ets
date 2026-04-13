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

import { TARGET_AOD, TARGET_FONT, TARGET_ICONS, ThemeInfo } from '@ohos/themeservice_inner_api';
import { FileUtil, JsonUtils, TsLog } from '@ohos/themeservicebase';
import { AbsResourceInstaller } from './AbsResourceInstaller';
import { AbsExtensionResInstaller } from './extension/AbsExtensionResInstaller';

const TAG: string = 'ResourceBasicInstaller';

export class ResourceBasicInstaller extends AbsResourceInstaller {
  constructor(resourceType: string, themeInfo: ThemeInfo) {
    super(resourceType, themeInfo);
  }

  async install(): Promise<boolean> {
    let hasCustom: boolean = false;
    if (this.getThemeTypeCustomPath()) {
      hasCustom = true;
    }
    let ret: boolean = await this.prepareCommonResource();
    if (!ret) {
      TsLog.warning(TAG, `install fail:${this.getThemeType()}`);
      return false;
    }
    // 自定义资源的id信息直接写在自定义目录，完整应用一个主题包
    await this.addDescriptionToResource(hasCustom);
    TsLog.info(TAG, `install:` + this.getThemeType());
    return true;
  }

  private async addDescriptionToResource(hasCustom: boolean): Promise<void> {
    if (hasCustom) {
      return;
    }
    // 非自定义资源，需要写入对应子资源的描述信息
    const themeInfo: ThemeInfo = this.getThemeInfo();
    if (!themeInfo.originThemePack?.srcPath) {
      return;
    }
    const descriptionPath: string = `${themeInfo.originThemePack.srcPath}/description.json`;
    const copyDestPath: string = `${this.getThemeTypePackagedPath()}/description.json`;
    await FileUtil.copyFileAsync(descriptionPath, copyDestPath);
    try {
      if (!themeInfo.originThemePack) {
        return;
      }
      const description: object = JSON.parse(themeInfo.originThemePack.description);
      const themeId: string = description['id'];
      const origin: string = description['origin'];
      await this.writeFontConfig(themeId, origin);
      await this.writeIconConfig(themeId);
      await this.writeAodConfig(themeId);
    } catch (error) {
      TsLog.error(TAG, 'parse description id fail', error);
    }
  }

  private async writeFontConfig(id: string, origin: string): Promise<void> {
    if (this.getThemeType() !== TARGET_FONT) {
      return;
    }
    try {
      const activateTheme: ThemeInfo = this.getThemeInfo();
      const fontsRootPath: string = `${activateTheme.originThemePack?.srcPath}/${TARGET_FONT}`;
      const manifestSrcPath: string = `${fontsRootPath}/manifest.json`;
      const fontManifestContent: string = await FileUtil.readFileContent(manifestSrcPath);
      const manifest: object = JSON.parse(fontManifestContent);
      manifest['id'] = id.toString();
      manifest['origin'] = origin;
      const fontName: string = manifest['src'];
      const fontNameExt: Nullable<string[]> = manifest['srcExt'] ?? undefined;
      // 按照主题包规范,识别字体真实路径(当前路径和系统字体路径,/system/fonts/)
      const systemFontsRootPath: string = '/system/fonts';
      const fontsPath: string = `${fontsRootPath}/${fontName}`;
      TsLog.info(TAG, `writeFontConfig fontNameExt length:${fontNameExt?.length}`);
      if (FileUtil.isFileExists(fontsRootPath)) {
        manifest['ttfFileSrc'] = fontsPath;
        let fontSrcExt: Nullable<string[]> = fontNameExt ? [] : undefined;
        fontNameExt?.forEach((fontName: string) => {
          if (fontName?.endsWith('.ttf')) {
            fontSrcExt?.push(`${fontsRootPath}/${fontName}`);
          } else {
            TsLog.warning(TAG, `writeFontConfig invalid file name ${fontName}`);
          }
        });
        manifest['ttfFileSrcExt'] = fontSrcExt;
        TsLog.info(TAG, `writeFontConfig length:${fontSrcExt?.length}`)
      } else {
        manifest['ttfFileSrc'] = `${systemFontsRootPath}/${fontName}`;
      }
      // 处理undefined场景，之前定的规则是multiWeight只能为true或者false
      if (!manifest['multiWeight']) {
        manifest['multiWeight'] = false;
      }
      const manifestDestPath: string = `${this.getThemeTypePackagedPath()}/manifest.json`;
      FileUtil.writeFileSync(manifestDestPath, JsonUtils.stringify(manifest));
    } catch (error) {
      TsLog.error(TAG, 'write font config error', error);
    }
  }

  private async writeIconConfig(id: string): Promise<void> {
    if (this.getThemeType() !== TARGET_ICONS) {
      return;
    }
    const manifestPath: string = `${this.getThemeTypePackagedPath()}/manifest.json`;
    let emitArg: Record<string, string> = {
      'id': id,
    }
    FileUtil.writeFileSync(manifestPath, JsonUtils.stringify(emitArg));
  }

  private async writeAodConfig(id: string): Promise<void> {
    if (this.getThemeType() !== TARGET_AOD) {
      return;
    }
    try {
      const manifestSrcPath: string = `${this.getThemeInfo().originThemePack?.srcPath}/${TARGET_AOD}/manifest.json`;
      const aodManifestContent: string = await FileUtil.readFileContent(manifestSrcPath);
      const manifest: object = JSON.parse(aodManifestContent);
      manifest['id'] = id.toString();
      const manifestDestPath: string = `${this.getThemeTypePackagedPath()}/manifest.json`;
      FileUtil.writeFileSync(manifestDestPath, JsonUtils.stringify(manifest));
    } catch (error) {
      TsLog.error(TAG, 'write font config error', error);
    }
  }

  public addExtendResource() {
    // 没有增量主题包资源，也没有自定义资源没有必要copy
    let themeTypeResourceBaseDir: string = `${this.getThemeTypePackagedPath()}${'/base'}`;
    FileUtil.createDirRecur(themeTypeResourceBaseDir);
    FileUtil.createEmptyFile(`${themeTypeResourceBaseDir}${'/'}${'.placeholder'}`);
  }

  /**
   * 是否含有拓展资源，即其他风格资源
   * @returns true表示存在拓展资源
   */
  protected hasExtensionRes() {
    let path: string | undefined = this.getThemeInfo().originThemePack?.srcPath;
    if (!FileUtil.isFileExists(path)) {
      return false;
    }
    path = `${path}/${this.getThemeType()}_extension`;
    if (!FileUtil.isFileExists(path)) {
      return false;
    }
    return true;
  }

  public async installExtension(style: string): Promise<boolean> {
    TsLog.info(TAG, `${this.getThemeType()} not overwrite`);
    return false;
  }
}

