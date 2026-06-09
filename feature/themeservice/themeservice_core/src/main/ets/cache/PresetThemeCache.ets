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
import {
  ORIGIN_PRESET,
  PRESET_RES_FONT,
  PRESET_RES_ICON,
  PRESET_RES_THEME,
  TServiceApi
} from '@ohos/themeservice_inner_api/Index';
import {
  ContextUtil,
  FileUtil,
  JsonUtils,
  MemoryCache,
  NullableType,
  PreferenceStoreCache,
  Singleton,
  TsLog
} from '@ohos/themeservicebase/Index';
import { ThemeCategory, ThemeDir } from '../preset/ThemePackParser';
import { TSPathUtils } from '../util/TSPathUtils';
import { FontInfo } from '../service/model/FontInfo';

const TAG: string = 'PresetThemeCache';

export class PresetThemeIdCache extends PreferenceStoreCache<string[]> {
  private static readonly INSTANCE: Singleton<PresetThemeIdCache> =
    new Singleton<PresetThemeIdCache>(() => new PresetThemeIdCache());

  private constructor() {
    super(TServiceApi.preference(ContextUtil.getTsApplicationContext(), 'preset_themes'));
  }

  /**
   * 获取单例对象
   *
   * @returns 对象
   */
  public static getInstance(): PresetThemeIdCache {
    return PresetThemeIdCache.INSTANCE.get();
  }
}

export class PresetThemeExt {
  public id: string;
  public iconPath: NullableType<string>;
  public fontPath: NullableType<string>;

  constructor(id: string, iconPath: NullableType<string>, fontPath: NullableType<string>) {
    this.id = id;
    this.iconPath = iconPath;
    this.fontPath = fontPath;
  }
}

export class PresetThemeExtCache extends MemoryCache<PresetThemeExt[]> {
  private static readonly INSTANCE: Singleton<PresetThemeExtCache> =
    new Singleton<PresetThemeExtCache>(() => new PresetThemeExtCache());
  private defaultFont: NullableType<FontInfo>;

  private presetFonts: FontInfo[] = [];

  public static getInstance(): PresetThemeExtCache {
    return PresetThemeExtCache.INSTANCE.get();
  }

  private constructor() {
    super(`PresetThemeCache`, () => this.init());
  }

  /**
   * 获取主题关联的图标资源路径
   *
   * @param themeId 主题id
   * @returns 预制关联图标资源路径
   */
  public async getIconPath(themeId: string): Promise<NullableType<string>> {
    let cacheDataList: PresetThemeExt[] = await this.get() ?? [];
    for (let index = 0; index < cacheDataList.length; index++) {
      const element: PresetThemeExt = cacheDataList[index];
      if (element.id === themeId) {
        return element.iconPath;
      }
    }
    return undefined;
  }

  /**
   * 获取主题关联的字体资源路径
   *
   * @param themeId 主题资源id
   * @returns 预制字体资源路径
   */
  public async getFontsPath(themeId: string): Promise<NullableType<string>> {
    let cacheDataList: PresetThemeExt[] = await this.get() ?? [];
    for (let index = 0; index < cacheDataList.length; index++) {
      const element: PresetThemeExt = cacheDataList[index];
      if (element.id === themeId) {
        return element.fontPath;
      }
    }
    return undefined;
  }

  /**
   * 获取预置字体列表信息
   *
   * @returns 预置字体列表
   */
  public async getPresetFonts(): Promise<FontInfo[]> {
    await this.get();
    return this.presetFonts;
  }

  /**
   * 获取默认字体信息
   *
   * @returns 默认字体信息
   */
  public async getDefaultFont(): Promise<NullableType<FontInfo>> {
    await this.get();
    return this.defaultFont;
  }

  private async readPresetIcons(presetDirList: Array<string>): Promise<HashMap<string, string>> {
    const iconInfoMap: HashMap<string, string> = new HashMap();
    for (const presetDir of presetDirList) {
      const presetIconsDir: string = `${presetDir}/${PRESET_RES_ICON}`;
      if (!FileUtil.isFileExists(presetIconsDir)) {
        continue;
      }
      const presetIcons: string[] = await FileUtil.listFiles(presetIconsDir);
      for (let iconPath of presetIcons) {
        try {
          const iconManifest: string = await FileUtil.readFileContent(`${iconPath}/manifest.json`);
          const iconId: string = JSON.parse(iconManifest)['id'];
          iconInfoMap.set(iconId, iconPath);
        } catch (error) {
          TsLog.info(TAG, `read icon preset fail`);
        }
      }
    }
    return iconInfoMap;
  }

  private async readPresetFonts(presetDirList: Array<string>): Promise<HashMap<string, string>> {
    const fontInfoMap: HashMap<string, string> = new HashMap();
    for (const presetDir of presetDirList) {
      const presetFontsDir: string = `${presetDir}/${PRESET_RES_FONT}`;
      if (!FileUtil.isFileExists(presetFontsDir)) {
        continue;
      }
      const presetFonts: string[] = await FileUtil.listFiles(presetFontsDir);
      for (let fontPath of presetFonts) {
        try {
          const fontManifestContent: string = await FileUtil.readFileContent(`${fontPath}/manifest.json`);
          const fontManifest: object = JSON.parse(fontManifestContent);
          const fontId: string = fontManifest['id'];
          const ttfSrc: string = fontManifest['src'];
          const ttfSrcExt: string[] = fontManifest['srcExt'];
          const multiWeight: boolean = fontManifest['multiWeight'];
          fontInfoMap.set(fontId, fontPath);
          TsLog.info(TAG, `readPresetFonts ttfSrcExt:${ttfSrcExt}`);
          const fontInfo: FontInfo = {
            id: fontId,
            origin: ORIGIN_PRESET,
            src: FileUtil.getFileName(ttfSrc),
            srcExt: TSPathUtils.getFontNameExt(ttfSrc, ttfSrcExt),
            ttfFileSrc: TSPathUtils.getFontPath(fontPath, ttfSrc),
            ttfFileSrcExt: TSPathUtils.getFontPathExt(fontPath, ttfSrc, ttfSrcExt),
            multiWeight: multiWeight
          }
          this.presetFonts.push(fontInfo);
          if (!fontPath.endsWith('font_01')) {
            continue;
          }
          this.defaultFont = fontInfo;
        } catch (error) {
          TsLog.error(TAG, `read fonts preset fail.`, error);
        }
      }
    }
    return fontInfoMap;
  }

  private async init(): Promise<PresetThemeExt[]> {
    const presetThemeExt: PresetThemeExt[] = [];
    const presetThemeDirList: string[] = await TSPathUtils.getTsPresetRootPath();
    const iconInfoMap: HashMap<string, string> = await this.readPresetIcons(presetThemeDirList);
    const fontInfoMap: HashMap<string, string> = await this.readPresetFonts(presetThemeDirList);
    for (const presetThemeDir of presetThemeDirList) {
      // 从manifest.json文件中获取主题清单，将主题清单解析为ThemeCategory数组
      const themeManifest: string =
        FileUtil.getStringByFile(`${presetThemeDir}/${PRESET_RES_THEME}/manifest.json`);
      const themeCategoryArray: NullableType<ThemeCategory[]> = JsonUtils.parse(themeManifest);
      themeCategoryArray?.forEach((themeCategory: ThemeCategory) => {
        const dir: ThemeDir[] = themeCategory.dir;
        for (let theme of dir) {
          if (this.contain(presetThemeExt, theme.theme_id)) {
            continue;
          }
          presetThemeExt.push(new PresetThemeExt(theme.theme_id, iconInfoMap.get(theme.icon_id),
            fontInfoMap.get(theme.font_id)));
        }
      });
      const hideThemeManifest: string =
        FileUtil.getStringByFile(`${presetThemeDir}/${PRESET_RES_THEME}/hidemanifest.json`);
      const hideThemeCategoryArray: NullableType<ThemeCategory[]> = JsonUtils.parse(hideThemeManifest);
      hideThemeCategoryArray?.forEach((themeCategory: ThemeCategory) => {
        const dir: ThemeDir[] = themeCategory.dir;
        for (let theme of dir) {
          if (this.contain(presetThemeExt, theme.theme_id)) {
            continue;
          }
          presetThemeExt.push(new PresetThemeExt(theme.theme_id, iconInfoMap.get(theme.icon_id),
            fontInfoMap.get(theme.font_id)));
        }
      });
    }
    return presetThemeExt;
  }

  private contain(presetThemeExt: PresetThemeExt[], targetThemeId: string): boolean {
    return Array.from(presetThemeExt).some((value: PresetThemeExt) => {
      return value?.id?.toString() === targetThemeId?.toString();
    });
  }
}

