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

import { HashMap } from '@kit.ArkTS';
import { fileIo } from '@kit.CoreFileKit';
import {
  ORIGIN_ONLINE,
  OriginType,
  TARGET_AOD,
  TARGET_FONT,
  TARGET_HOME,
  TARGET_ICONS,
  TARGET_LOCK,
  TargetType,
  ThemeInfo,
  ThemeOptions,
  TARGET_LONG_TAKE,
  From
} from '@ohos/themeservice_inner_api/Index';
import { FileUtil, JsonUtils, NullableType, StringUtils, TsLog } from '@ohos/themeservicebase/Index';
import { ThemeEditInfo, ThemeExtendInfo } from '../../../cache/ThemeInfoStoreCache';
import { TSPathUtils } from '../../../util/TSPathUtils';
import { FontInfo } from '../../model/FontInfo';
import { UNFOLDED_WALLPAPER_CATEGORY } from './SetWallPaperExecutor';
import { PathValidateUtil } from '../../../validate/PathValidateUtil';
import { ThemePackUtils } from '../../../util/ThemePackUtils';

const TAG: string = `ThemeMixedExecutor`;

export const excludedThemeList: TargetType[] = [TARGET_FONT, TARGET_ICONS];

export class ThemeMixedExecutor {
  private readonly defaultTheme: ThemeInfo;
  private readonly activateTheme: NullableType<ThemeInfo>;
  private supportMixed: Array<TargetType> =
    ['home', 'lock', 'icons', 'fonts', 'skin', 'fa', 'aod', 'sub_screen', 'long_take'];
  private enableOptionsMap: HashMap<string, (option: Nullable<ThemeOptions>) => boolean> = new HashMap();
  private mixed: boolean = false;

  constructor(defaultTheme: ThemeInfo, activateTheme: NullableType<ThemeInfo>) {
    this.defaultTheme = defaultTheme;
    this.activateTheme = activateTheme;
    this.enableOptionsMap.set('home', (option: ThemeOptions) => {
      return option?.home === ThemeOptions.ENABLE;
    });
    this.enableOptionsMap.set('lock', (option: ThemeOptions) => {
      return option?.lock === ThemeOptions.ENABLE;
    });
    this.enableOptionsMap.set('icons', (option: ThemeOptions) => {
      return option?.icons === ThemeOptions.ENABLE;
    });
    this.enableOptionsMap.set('fonts', (option: ThemeOptions) => {
      return option?.fonts === ThemeOptions.ENABLE;
    });
    this.enableOptionsMap.set('skin', (option: ThemeOptions) => {
      return option?.skin === ThemeOptions.ENABLE;
    });
    this.enableOptionsMap.set('aod', (option: ThemeOptions) => {
      return option?.aod === ThemeOptions.ENABLE;
    });
    this.enableOptionsMap.set('long_take', (option: ThemeOptions) => {
      return option?.long_take === ThemeOptions.ENABLE;
    });
    this.enableOptionsMap.set('sub_screen', (option: ThemeOptions) => {
      return option?.sub_screen === ThemeOptions.ENABLE;
    });
  }

  async activateThemeMixed(path: string, option?: ThemeOptions, apply: boolean = true,
    from : From = 'default'): Promise<ThemeEditInfo> {
    // 混搭主要用于画廊主题编辑保存:1.应用全量主题包，不需要混搭,2:仅应用主题到SA不需要产生画廊数据,3：目标主题包非规范化格式
    if (!option || !apply || !this.activateTheme) {
      TsLog.info(TAG, `activate all：${!option},apply:${apply},theme invalid:${!this.activateTheme}`);
      return new Map();
    }
    TsLog.info(TAG, `activateThemeMixed ${this.defaultTheme.editorId}:` + JsonUtils.stringify(option));
    let themeEditInfo: ThemeEditInfo = new Map();
    try {
      for (let index = 0; index < this.supportMixed.length; index++) {
        const subTheme: TargetType = this.supportMixed[index];
        let enableOpt: Nullable<(themeOption: Nullable<ThemeOptions>) => boolean> = this.enableOptionsMap.get(subTheme);
        if (!enableOpt || !enableOpt(option)) {
          continue;
        }
        let description: Nullable<string> = JsonUtils.parse(this.activateTheme.originThemePack?.description ?? '');
        if (!description) {
          TsLog.warning(TAG, `description is null`);
          continue;
        }
        if (!excludedThemeList.includes(subTheme)) {
          themeEditInfo.set(subTheme, new ThemeExtendInfo(description['origin'], this.activateTheme.id, path));
        }
        await this.saveThemeToCustom(path, subTheme, from);
        // 外屏sub_screen比较特殊，如果混搭外屏，仅拷贝外屏增量资源，不对mixed赋值
        if (subTheme !== 'sub_screen') {
          this.mixed = true;
        }
      }
    } catch (err) {
      TsLog.error(TAG, `activate theme mixd error`, err)
    }
    return themeEditInfo;
  }

  public isMixed(): boolean {
    return this.mixed;
  }

  private async saveThemeToCustom(themePath: string, themeType: string, from: From = 'default'): Promise<boolean> {
    const themeTypePath: string = `${themePath}/${themeType}`;
    if (!FileUtil.isFileExists(themeTypePath)) {
      return false;
    }
    const customPath: string = TSPathUtils.getThemeCustomPackagePath(this.defaultTheme);
    const calculateLockPath: string =
      `${customPath}/${TARGET_LOCK}/base/resources/unlock_wallpaper_0.jpg`
    if (themeType === 'lock' && FileUtil.isFileExists(calculateLockPath)) {
      const calculateLockBefore = await FileUtil.calculateFileHash(calculateLockPath);
      const calculateLockAfter =
        await FileUtil.calculateFileHash(`${themeTypePath}/base/resources/unlock_wallpaper_0.jpg`);
      if (calculateLockBefore !== calculateLockAfter) {
        await this.deleteThemeImage(`${TSPathUtils.getThemeCustomPackagePath(this.defaultTheme)}/opt/${TARGET_LOCK}/base/resources`)
      }
    }
    await this.cleanInvalid(`${customPath}/${themeType}`, themePath, themeType);
    let ret: boolean = await FileUtil.copyDirAsync(themeTypePath, customPath);
    TsLog.info(TAG, `save theme ${themeType} ret:${ret}`);
    await this.writeFontConfig(themePath, themeType);
    this.writeIconsConfig(themePath, themeType);
    await this.writeAodConfig(themePath, themeType);
    // 自定义资源，需要写入对应子资源的描述信息
    const description :string = await FileUtil.readFileContent(`${themePath}/description.json`);
    const newDescription :string = ThemePackUtils.modifyDescription(description, 'applyFrom', from);
    ret = FileUtil.writeFileSync(`${customPath}/${themeType}/description.json`, newDescription);
    return ret;
  }

  private async cleanInvalid(themeTypeCustomPath: string, themePath: string, themeType: string): Promise<void> {
    if (!await this.cleanCustom(themeTypeCustomPath, themePath, themeType)) {
      await FileUtil.rmdirAsync(themeTypeCustomPath);
    }
  }

  /**
   * 清理桌面和锁屏目录资源,需要特殊处理
   * @param themeTypeCustomPath 当前主题增量修改资源
   * @param themePath 目标应用的主题资源文件
   * @param themeType 主题资源类型
   * @returns
   */
  private async cleanCustom(themeTypeCustomPath: string, themePath: string, themeType: string): Promise<boolean> {
    if (TARGET_HOME !== themeType && TARGET_LOCK !== themeType && TARGET_LONG_TAKE !== themeType) {
      return false;
    }
    // 锁屏目录的时钟配置文件不能清除config.json
    // 基于异壁纸方案,调用端如果仅应用内屏资源，不应清理外屏资源
    const themeTypeDir: string = `${themePath}/${themeType}`;
    const baseDir: string = `${themeTypeDir}/base`;
    if (FileUtil.isFileExists(baseDir)) {
      const subFiles: string[] = await FileUtil.listFiles(themeTypeCustomPath);
      // 应用正常壁纸之前需要清理之前设置的壁纸资源
      const commonWallpaperDirs: string[] = subFiles.filter((file: string) => {
        const name: string = FileUtil.getFileName(file);
        return FileUtil.isDir(file) && !name.includes(UNFOLDED_WALLPAPER_CATEGORY);
      });
      for (const commonWallpaperDir of commonWallpaperDirs) {
        await FileUtil.trimDirAsync(commonWallpaperDir, ['config.json']);
        if ((await FileUtil.listFiles(commonWallpaperDir)).length === 0) {
          await FileUtil.rmdirAsync(commonWallpaperDir);
        }
      }
    }
    const subFiles: string[] = await FileUtil.listFiles(themeTypeDir);
    for (const subFile of subFiles) {
      const subDir: string = FileUtil.getFileName(subFile);
      if (!FileUtil.isDir(subFile) || !subDir.includes(UNFOLDED_WALLPAPER_CATEGORY)) {
        continue;
      }
      const customSubDir: string = `${themeTypeCustomPath}/${subDir}`
      if (!await PathValidateUtil.validatePath(customSubDir)) {
        continue;
      }
      await FileUtil.trimDirAsync(customSubDir, ['config.json']);
      if ((await FileUtil.listFiles(customSubDir)).length === 0) {
        await FileUtil.rmdirAsync(customSubDir);
      }
    }
    return true;
  }

  /**
   * 删除应用主题的缩略图，触发画廊切换
   *
   * @returns Promise<void>
   */
  private async deleteThemeImage(cachePath: string): Promise<void> {
    if (!FileUtil.trimDirAsync(cachePath)) {
      TsLog.warning(TAG, `delete optimizeLockImage fail, editorIdId: ${this.defaultTheme.editorId}`);
      return;
    }
    TsLog.info(TAG, `delete optimizeLockImage, editorIdId: ${this.defaultTheme.editorId}`);
  }

  private writeIconsConfig(path: string, themeType: string): void {
    let iconDir: string = `${path}/${TARGET_ICONS}`;
    if (TARGET_ICONS != themeType || !FileUtil.isFileExists(iconDir) || !this.activateTheme) {
      return;
    }
    let emitArg: Record<string, string> = {
      'id': this.activateTheme.id,
    }
    FileUtil.writeFileSync(`${TSPathUtils.getThemeCustomPackagePath(this.defaultTheme)}/${TARGET_ICONS}/manifest.json`,
      JsonUtils.stringify(emitArg));
  }

  private async writeAodConfig(path: string, themeType: string): Promise<void> {
    let aodDir: string = `${path}/${TARGET_AOD}`;
    if (TARGET_AOD !== themeType || !FileUtil.isFileExists(aodDir) || !this.activateTheme) {
      return;
    }
    try {
      const aodManifestContent: string = await FileUtil.readFileContent(`${aodDir}/manifest.json`);
      const manifest: object = JSON.parse(aodManifestContent);
      manifest['id'] = this.activateTheme.id;
      FileUtil.writeFileSync(`${TSPathUtils.getThemeCustomPackagePath(this.defaultTheme)}/${TARGET_AOD}/manifest.json`,
        JsonUtils.stringify(manifest));
    } catch (error) {
      TsLog.warning(TAG, `writeAodConfig error`);
    }
  }

  private async writeFontConfig(path: string, themeType: string): Promise<void> {
    let fontDir: string = `${path}/${TARGET_FONT}`;
    if (themeType !== TARGET_FONT || !FileUtil.isFileExists(fontDir) || !this.activateTheme) {
      return;
    }
    const fontManifest: string = await FileUtil.readFileContent(`${fontDir}/manifest.json`);
    let fontName: string = '';
    let fontNameExt: Nullable<string[]>;
    try {
      const fontManifestObj: object = JSON.parse(fontManifest);
      fontName = fontManifestObj['src'];
      fontNameExt = fontManifestObj['srcExt'];
      TsLog.info(TAG, `writeFontConfig fontName:${fontName} fontNameExt:${fontNameExt}`);
    } catch (error) {
      TsLog.warning(TAG, 'writeFontConfig parse font manifest error');
    }
    if (StringUtils.isEmpty(fontName)) {
      TsLog.error(TAG, 'fontName is empty');
      return;
    }
    const fontSrc: string = `${fontDir}/${fontName}`;
    let fontSrcExt: Nullable<string[]> = fontNameExt ? [] : undefined;
    fontNameExt?.forEach((fileName: string) => {
      if (fileName?.endsWith('.ttf')) {
        fontSrcExt?.push(`${fontDir}/${fileName}`);
      } else {
        TsLog.warning(TAG, `writeFontConfig Invalid file name. fileName= ${fileName}`);
      }
    });
    let origin: OriginType = ORIGIN_ONLINE;
    try {
      let description: Nullable<string> = this.activateTheme.originThemePack?.description;
      if (description) {
        origin = JSON.parse(description)['origin'];
      }
    } catch (err) {
      TsLog.error(TAG, `writeFontConfig. code:${err.code}, message:${err.message}`)
    }
    // 在线字体默认都是不支持设置字重
    const fontInfo: FontInfo = {
      id: this.activateTheme.id,
      origin: origin,
      src: fontName,
      srcExt: fontNameExt,
      ttfFileSrc: fontSrc,
      ttfFileSrcExt: fontSrcExt,
      multiWeight: false,
    }
    TsLog.info(TAG, `writeFontConfig length:${fontSrcExt?.length}`)
    FileUtil.writeFileSync(`${TSPathUtils.getThemeCustomPackagePath(this.defaultTheme)}/${themeType}/manifest.json`,
      JsonUtils.stringify(fontInfo));
  }
}
