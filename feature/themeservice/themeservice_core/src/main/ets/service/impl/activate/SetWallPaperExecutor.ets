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

import { BusinessError, systemDateTime } from '@kit.BasicServicesKit';
import {
  OriginType,
  ThemeInfo,
  ThemeOptions,
  TS_WALLPAPER_TYPE_HOME,
  TS_WALLPAPER_TYPE_LOCK,
  TWallpaperType,
  WallPaper,
  WallPaperInfo
} from '@ohos/themeservice_inner_api';
import { FileUtil, JsonUtils, NullableType, ObjectUtils, StringUtils, TsLog } from '@ohos/themeservicebase/Index';
import { ThemeEditInfo, ThemeExtendInfo } from '../../../cache/ThemeInfoStoreCache';
import { TSPathUtils } from '../../../util/TSPathUtils';
import { PathValidateUtil } from '../../../validate/PathValidateUtil';
import { ContentDescription, MovingPhotoCfg } from '../../model/ContentDescription';
import { WallPaperManifest } from '../../model/Manifest';
import { themeInfoService } from '../ThemeInfoServiceImpl';
import { ThemePackageInstaller } from './installer/ThemePackgeInstaller';
import { RemoteCode } from '@ohos/themeservicebase/src/main/ets/remote/RemoteCode';
import { ThemePackUtils } from '../../../util/ThemePackUtils';
import { ActivatedThemeUtil } from '../../../util/ActivatedThemeUtil';

const TAG: string = `SetWallPaperExecutor`;
const SUPPORT_WALLPAPER_INFO_NUM: number = 2;

/**
 * 折叠屏限定资源符
 */
export const UNFOLDED_WALLPAPER_CATEGORY: string = 'unfolded';

export class SetWallPaperExecutor {
  private readonly themeInfo: ThemeInfo;

  private readonly themeEditInfo: ThemeEditInfo = new Map();

  private readonly option: ThemeOptions = new ThemeOptions();

  /**
   * 本次操作时间戳
   */
  private readonly applyTime: string;

  constructor(themeInfo: ThemeInfo) {
    this.themeInfo = themeInfo;
    this.applyTime = systemDateTime.getTime().toString();
  }

  async setWallPaper(wallPaperInfos: WallPaperInfo[]): Promise<boolean> {
    TsLog.info(TAG, `setWallPaper applyTime = ${this.applyTime}`);
    if (!await this.validateWallPaper(wallPaperInfos)) {
      TsLog.error(TAG, `validate wallpaper failed`)
      const error: BusinessError<string> = { name: `error`, message: `validate wallpaper failed`, code: RemoteCode.ERR_ILLEGAL_WALLPAPER };
      return Promise.reject(error);
    }
    const homeWallPaper: NullableType<WallPaperInfo> = this.getWallPaper(TS_WALLPAPER_TYPE_HOME, wallPaperInfos);
    const lockWallPaper: NullableType<WallPaperInfo> = this.getWallPaper(TS_WALLPAPER_TYPE_LOCK, wallPaperInfos);
    if (homeWallPaper) {
      let result: number = await this.applyToCustom(homeWallPaper);
      if (result !== RemoteCode.SUCCESS ) {
        TsLog.warning(TAG, 'set wallpaper home fail');
        const error: BusinessError<string> = { name: `error`, message: `set wallpaper home fail`, code: result };
        return Promise.reject(error);
      }
    }
    if (lockWallPaper) {
      let result: number = await this.applyToCustom(lockWallPaper);
      if (result !== RemoteCode.SUCCESS ) {
        TsLog.warning(TAG, 'set wallpaper lock fail');
        const error: BusinessError<string> = { name: `error`, message: `set wallpaper lock fail`, code: result };
        return Promise.reject(error);
      }
    }

    // 图片、manifest保存成功，进行使能
    const ret: number = await new ThemePackageInstaller(this.themeInfo).activateThemeOpt(this.option);
    TsLog.info(TAG, `setWallPaper ret ${ret}`);
    if (ret === RemoteCode.SUCCESS) {
      await themeInfoService.get().applyTheme(this.themeInfo, this.themeEditInfo);
      return true;
    }
    TsLog.error(TAG, `set wallpaper failed`);
    const error: BusinessError<string> = { name: `error`, message: `set wallpaper failed`, code: ret };
    return Promise.reject(error);
  }

  private getWallPaper(wallpaperType: TWallpaperType, wallPaperInfos: WallPaperInfo[]): NullableType<WallPaperInfo> {
    return wallPaperInfos.find((wallpaperInfo: WallPaperInfo) => {
      return wallpaperType === wallpaperInfo.wallPaperType;
    });
  }

  private async applyToCustom(wallpaperInfo: WallPaperInfo): Promise<number> {
    if (wallpaperInfo.wallPaperType === TS_WALLPAPER_TYPE_HOME) {
      this.option.home = ThemeOptions.ENABLE;
    } else if (wallpaperInfo.wallPaperType === TS_WALLPAPER_TYPE_LOCK) {
      this.option.lock = ThemeOptions.ENABLE;
    } else {
      return RemoteCode.ERR_WALLPAPER_TYPE;
    }
    const normalWallpapers: WallPaper[] = [];
    const unfoldedWallpapers: WallPaper[] = [];
    wallpaperInfo.wallPapers.forEach((wallpaper: WallPaper) => {
      if (wallpaper.category.includes(UNFOLDED_WALLPAPER_CATEGORY)) { // category包含unfolded
        unfoldedWallpapers.push(wallpaper);
      } else { // base
        normalWallpapers.push(wallpaper);
      }
    });
    const wallpaperType: TWallpaperType = wallpaperInfo.wallPaperType;
    const type: string = wallpaperInfo.type ?? 'image';
    const incrementalCategoryArrays: string[] = [];
    const commonRet: boolean =
      await this.setNormalWallpaper(wallpaperType, normalWallpapers, type, incrementalCategoryArrays);
    const xScreenRet: boolean =
      await this.setUnfoldedWallpaper(wallpaperType, unfoldedWallpapers, type, incrementalCategoryArrays);
    const customDir: string = `${TSPathUtils.getThemeCustomPackagePath(this.themeInfo)}/${wallpaperType}`;
    if (incrementalCategoryArrays.length > 0) {
      await this.setManifestType4Qualifiers(wallpaperType, customDir, incrementalCategoryArrays);
    }
    if (type !== 'movingPhoto') {
      await this.cleanWallpaper(wallpaperType);
    }
    return (commonRet || xScreenRet) ? RemoteCode.SUCCESS : RemoteCode.ERR_SET_WALLPAPER;
  }

  // normal指base目录
  private async setNormalWallpaper(wallpaperType: TWallpaperType, wallpaperArrays: WallPaper[],
    type: string = 'image', incrementalCategoryArrays: string[]): Promise<boolean> {
    if (wallpaperArrays.length === 0) {
      return false;
    }
    const customDir: string = `${TSPathUtils.getThemeCustomPackagePath(this.themeInfo)}/${wallpaperType}`;
    if (type === 'movingPhoto') {
      await this.cleanNormalWallpaperResources(customDir);
    }
    await this.cleanNormalJsonFiles(customDir);
    const manifest: WallPaperManifest = new WallPaperManifest();
    const contentDescription: ContentDescription = {
      id: '',
      origin: 'preset'
    };
    const movingPhotoCfg: MovingPhotoCfg = new MovingPhotoCfg();
    for (const wallpaper of wallpaperArrays) { // WallPaperInfos中的所有base
      if (wallpaper.property === 'main') {
        incrementalCategoryArrays.push(wallpaper.category);
      }
      const suffix: string = FileUtil.getFileSuffix(wallpaper.src);
      const isWallpaperExist: boolean = FileUtil.isFileExists(wallpaper.src);
      TsLog.info(TAG, `suffix:${suffix}, isWallpaperExist: ${isWallpaperExist}`)
      let targetFileName: string = ``;
      if (StringUtils.isEmpty(wallpaper.contentType) || wallpaper.contentType === 'originForOther') {
        targetFileName = `${wallpaperType}_wallpaper_${this.applyTime}.${suffix}`;
      } else {
        targetFileName = FileUtil.getFileName(wallpaper.src);
      }
      if (isWallpaperExist) {
        const targetDir: string = `${customDir}/${wallpaper.category}/resources`;
        FileUtil.createDirRecur(targetDir);
        const copyRet: boolean = await FileUtil.copyFileAsync(wallpaper.src, `${targetDir}/${targetFileName}`);
        if (!copyRet) {
          TsLog.warning(TAG, `copy fail src：${FileUtil.getFileName(wallpaper.src)},category:${wallpaper.category}`);
          return false;
        }
      }
      // 设置壁纸描述信息
      if (StringUtils.isEmpty(wallpaper.contentType) || wallpaper.contentType === 'default' ||
        wallpaper.property === 'main') {
        manifest.applyFrom = wallpaper.applyFrom ?? manifest.applyFrom;
        manifest.image.src = targetFileName;
        contentDescription.id = wallpaper.id ?? contentDescription.id;
        contentDescription.origin = wallpaper.origin ?? contentDescription.origin;
        contentDescription.applyFrom = wallpaper.applyFrom ?? contentDescription.applyFrom;
        TsLog.info(TAG, `wallpaper id:${contentDescription.id} exist:${isWallpaperExist}`);
        this.themeEditInfo.set(wallpaperType,
          new ThemeExtendInfo(contentDescription.origin, contentDescription.id, wallpaper.src));
      }

      if (wallpaper.type === 'movingPhoto' || type === 'movingPhoto') {
        movingPhotoCfg.enable = true;
        movingPhotoCfg.applyTime = this.applyTime;
        if (wallpaper.contentType === 'video') {
          movingPhotoCfg.src = targetFileName;
        }
        contentDescription.movingPhoto = movingPhotoCfg;
      }
    }
    const manifestFile: string = `${customDir}/manifest.json`;
    const descriptionFile: string = `${customDir}/description.json`;
    TsLog.info(TAG, `---${manifestFile}---${descriptionFile}`)
    FileUtil.writeFileSync(descriptionFile, JsonUtils.stringify(contentDescription));
    FileUtil.writeFileSync(manifestFile, JsonUtils.stringify(manifest));
    return true;
  }

  private async cleanNormalWallpaperResources(customDir: string): Promise<void> {
    const subFiles: string[] = await FileUtil.listFiles(customDir);
    // 应用movingPhoto壁纸之前需要清理之前设置的壁纸资源,image图片走增量删除的逻辑
    const commonWallpaperDirs: string[] = subFiles.filter((file: string) => {
      const name: string = FileUtil.getFileName(file);
      return FileUtil.isDir(file) && !name.includes(UNFOLDED_WALLPAPER_CATEGORY);
    });
    for (const commonWallpaperDir of commonWallpaperDirs) {
      const resourceDir: string = `${commonWallpaperDir}/resources`;
      await FileUtil.rmdirAsync(resourceDir);
    }
  }

  private async cleanNormalJsonFiles(customDir: string): Promise<void> {
    const manifestFile: string = `${customDir}/manifest.json`;
    const descriptionFile: string = `${customDir}/description.json`;
    await FileUtil.deleteAsync(manifestFile);
    await FileUtil.deleteAsync(descriptionFile);
  }

  /**
   * 异壁纸资源单独设置，异壁纸限定符目录需要单独存储manifest资源描述信息
   * @param wallpaperArrays 异壁纸资源
   * @returns
   */
  private async setUnfoldedWallpaper(wallpaperType: TWallpaperType, wallpaperArrays: WallPaper[],
    type: string = 'image', incrementalCategoryArrays: string[]): Promise<boolean> {
    if (wallpaperArrays.length === 0) {
      return false;
    }
    const customDir: string = `${TSPathUtils.getThemeCustomPackagePath(this.themeInfo)}/${wallpaperType}`;
    const manifest: WallPaperManifest = new WallPaperManifest();
    let id: string = '';
    let origin: OriginType = 'preset';
    const description: ContentDescription = {
      id: id,
      origin: origin
    };
    const movingPhoto: MovingPhotoCfg = new MovingPhotoCfg();
    await this.cleanUnfoldedWallpaper(customDir, wallpaperArrays);
    for (const wallpaper of wallpaperArrays) {
      const suffix: string = FileUtil.getFileSuffix(wallpaper.src);
      const isWallpaperExist: boolean = FileUtil.isFileExists(wallpaper.src);
      let targetFileName: string = '';
      if (StringUtils.isEmpty(wallpaper.contentType) || wallpaper.contentType === 'originInBase') { // 由TS进行文件命名
        targetFileName = `${wallpaperType}_wallpaper_${this.applyTime}.${suffix}`; // 和normal是同一个applyTime
      } else { // 设置contentType，保留原文件名
        targetFileName = FileUtil.getFileName(wallpaper.src);
      }
      TsLog.info(TAG, `setUnfoldedWallpaper contentType:${wallpaper.contentType}`)
      if (isWallpaperExist) {
        let targetDir: string = '';
        if (wallpaper.contentType === 'image') {
          targetDir = `${customDir}/base/resources`;
        } else {
          targetDir = `${customDir}/${wallpaper.category}/resources`;
        }
        FileUtil.createDirRecur(targetDir);
        const copyRet: boolean = await FileUtil.copyFileAsync(wallpaper.src, `${targetDir}/${targetFileName}`);
        if (!copyRet) {
          TsLog.warning(TAG, `copy fail src：${FileUtil.getFileName(wallpaper.src)},category:${wallpaper.category}`);
          return false;
        }
      }
      const descriptionFile: string = `${customDir}/${wallpaper.category}/description.json`;
      if (StringUtils.isEmpty(wallpaper.contentType) || wallpaper.contentType === 'default' ||
        wallpaper.property === 'main') {
        // 设置壁纸描述信息
        manifest.applyFrom = wallpaper.applyFrom ?? manifest.applyFrom;
        manifest.image.src = targetFileName;
        id = wallpaper.id ?? id;
        origin = wallpaper.origin ?? origin;
        description.id = id;
        description.origin = origin;
        description.applyFrom = manifest.applyFrom;
        TsLog.info(TAG, `wallpaper id:${id} exist:${isWallpaperExist}`)
        const manifestFile: string = `${customDir}/${wallpaper.category}/manifest.json`;
        await FileUtil.deleteAsync(manifestFile);
        FileUtil.writeFileSync(manifestFile, JsonUtils.stringify(manifest));
        await FileUtil.deleteAsync(descriptionFile);
        FileUtil.writeFileSync(descriptionFile, JsonUtils.stringify(description));
      }
      if (wallpaper.property === 'main') {
        incrementalCategoryArrays.push(wallpaper.category);
      }

      if (wallpaper.contentType === 'originInBase') { // originInBase，需要刷新manifest内容
        manifest.applyFrom = wallpaper.applyFrom ?? manifest.applyFrom;
        manifest.image.src = targetFileName; // 文件名和base下的图片相符

        TsLog.info(TAG, `originInBase wallpaper id:${id} exist:${isWallpaperExist}`)
        const manifestFile: string = `${customDir}/${wallpaper.category}/manifest.json`;
        await FileUtil.deleteAsync(manifestFile);
        FileUtil.writeFileSync(manifestFile, JsonUtils.stringify(manifest));
      }

      if (wallpaper.type === 'movingPhoto' || type === 'movingPhoto') {
        if (wallpaper.contentType === 'video') {
          movingPhoto.enable = true;
          movingPhoto.applyTime = this.applyTime;
          movingPhoto.src = targetFileName;
          description.movingPhoto = movingPhoto;
          await FileUtil.deleteAsync(descriptionFile);
          FileUtil.writeFileSync(descriptionFile, JsonUtils.stringify(description));
        }
      }
    }
    return true;
  }

  private async cleanWallpaper(wallpaperType: TWallpaperType): Promise<void> {
    const customDir: string = `${TSPathUtils.getThemeCustomPackagePath(this.themeInfo)}/${wallpaperType}`;
    const normalManifestFile: string = `${customDir}/manifest.json`;
    const srcArrays: string[] = [];
    await this.readManifest(normalManifestFile, srcArrays);
    const unfoldedCategory: string[] = ['unfolded', 'unfolded2', 'unfolded-land', 'unfolded2-land'];
    for(const category of unfoldedCategory) {
      const unfoldedManifestFile: string = `${customDir}/${category}/manifest.json`;
      if (!FileUtil.isFileExists(unfoldedManifestFile)) {
        continue;
      }
      await this.readManifest(unfoldedManifestFile, srcArrays);
    }
    const wallpaperPrefix: string[] = [];
    for (const src of srcArrays) {
      const prefix: string = FileUtil.getFilePrefix(src);
      wallpaperPrefix.push(prefix);
    }
    const resourcesDir: string = `${customDir}/base/resources`;
    const resourcesFiles: string[] = await FileUtil.listFiles(resourcesDir);
    const resourcesFileNames: string[] = [];
    for (const resourcesFile of resourcesFiles) {
      const name: string = FileUtil.getFileName(resourcesFile);
      resourcesFileNames.push(name);
    }
    const filteredFileNames: string[] = resourcesFileNames.filter(fileName => {
      return !wallpaperPrefix.some(prefix => fileName.includes(prefix));
    });
    for(const fileName of filteredFileNames) {
      const resourceJpg: string = `${customDir}/base/resources/${fileName}`;
      const formatPath: string = PathValidateUtil.formatPath(resourceJpg);
      await FileUtil.deleteAsync(formatPath);
    }
  }

  private async readManifest(manifestFile: string, srcArrays: string[]) {
    try {
      const manifestContent: string = await FileUtil.readFileContent(manifestFile);
      const manifest: object = JSON.parse(manifestContent);
      const image: string = manifest['image'];
      if (!StringUtils.isEmpty(image)) {
        const src: string = image['src'];
        srcArrays.push(src);
      }
    } catch (error) {
      TsLog.error(TAG, `read mainifest fail.`, error);
    }
  }

  private async setManifestType4Qualifiers(wallpaperType: TWallpaperType, customDir: string,
    incrementalCategoryArrays: string[], type: 'image' = 'image'): Promise<void> {
    const activatedPath: string = ActivatedThemeUtil.getActivatedThemePath();
    const qualifiers: string[] = ['base', 'unfolded', 'unfolded-land', 'unfolded2', 'unfolded2-land'];
    const categorySets = new Set(incrementalCategoryArrays);
    const filteredQualifiers: string[] = qualifiers.filter(qualifier => !categorySets.has(qualifier));
    let customFile: string;
    for (const qualifier of filteredQualifiers) {
      let manifestFile: string;
      if (qualifier === 'base') {
        manifestFile = `${activatedPath}/system/${wallpaperType}/manifest.json`;
        customFile = `${customDir}`;
      } else {
        manifestFile = `${activatedPath}/system/${wallpaperType}/${qualifier}/manifest.json`;
        customFile = `${customDir}/${qualifier}`;
      }
      if (FileUtil.isFileExists(manifestFile)) {
        let content: string = await FileUtil.readFileContent(manifestFile);
        content = ThemePackUtils.modifyJson(content, 'type', type, (value) => value === 'longTake');
        FileUtil.createDirRecur(customFile);
        FileUtil.writeFileSync(`${customFile}/manifest.json`, content);
      }
    }
  }

  private async cleanUnfoldedWallpaper(customDir: string, wallpaperArrays: WallPaper[]): Promise<void> {
    for (const wallpaper of wallpaperArrays) {
      const targetDir: string = `${customDir}/${wallpaper.category}/resources`;
      await FileUtil.rmdirAsync(targetDir);
    }
  }

  private async validateWallPaper(wallPaperInfos: WallPaperInfo[]): Promise<boolean> {
    if (ObjectUtils.isNull(wallPaperInfos) || wallPaperInfos.length > SUPPORT_WALLPAPER_INFO_NUM ||
      wallPaperInfos.length === 0) {
      TsLog.warning(TAG, `validate wallpaper param fail:${wallPaperInfos?.length}`);
      return false;
    }
    for (let wallpaperInfo of wallPaperInfos) {
      if (wallpaperInfo && wallpaperInfo.wallPapers?.length === 0) {
        TsLog.warning(TAG, `validate wallpaper fail:${wallpaperInfo.wallPaperType} for wallpaper empty`);
        return false;
      }
      for (let index: number = 0; index < wallpaperInfo.wallPapers.length; index++) {
        const wallpaper: WallPaper = wallpaperInfo.wallPapers[index];
        if (!await this.isWallPaperValid(wallpaperInfo.wallPaperType, wallpaper)) {
          TsLog.warning(TAG, `validate wallpaper fail:${FileUtil.getFileName(wallpaper.src)},${wallpaper.category}`);
          return false;
        }
      }
    }
    return true;
  }

  private async isWallPaperValid(wallpaperType: TWallpaperType, wallpaper: WallPaper): Promise<boolean> {
    if (!wallpaper) {
      return false;
    }
    const customDir: string = `${TSPathUtils.getThemeCustomPackagePath(this.themeInfo)}/${wallpaperType}`;
    const targetDir: string = `${customDir}/${wallpaper.category}/resources`;
    if (!await PathValidateUtil.validatePath(targetDir)) {
      TsLog.warning(TAG, `wallpaper validate path fail type:${wallpaperType},category:${wallpaper.category}`);
      return false;
    }
    return true;
  }
}
