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
import { ActivateEventData, EventId, ORIGIN_ONLINE, ThemeInfo, ThemePackInfo } from '@ohos/themeservice_inner_api';
import { BusinessError } from '@ohos.base';
import { display } from '@kit.ArkUI';
import { deviceInfo } from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';
import { EventEmitter, FileUtil, JsonUtils, NullableType, Singleton, StringUtils, TsLog } from '@ohos/themeservicebase';
import PixelMapUtil, { ImageFileType } from '../../../util/PixelMapUtil';
import { ThemeOptimizeCache } from '../../../cache/ThemeOptimizeCache';
import { ThemeOptimizeInfo } from '../../../cache/ThemeOptimizeInfo';
import { TSPathUtils } from '../../../util/TSPathUtils';
import { ThemeResourceOptimizeService } from '../../api/ThemeResourceOptimizeService';
import { themeInfoService } from '../ThemeInfoServiceImpl';
import ThumbnailProcessor from './ThumbnailProcessor';
import { PathValidateUtil } from '../../../validate/PathValidateUtil';
import { getCustomThemePack, getThemePackParser } from '../../../preset/ThemePackParser';

const TAG: string = 'ThemeResourceOptimizeServiceImpl';
const FILE_SEPARATOR: string = '/';
const FILE_SUFFIX_ASTC: string = '.astc';
const IMAGE_SUFFIX_JPG: string = 'jpg';
const IMAGE_SUFFIX_PNG: string = 'png';
const LOCK_PATH: string = 'lock';
const RESOURCES_PATH: string = 'resources';
const PREVIEW_PATH: string = 'preview';
const QUALIFIER_STRINGS: string[] = ['base', 'unfolded', 'land', 'unfolded-land', 'unfolded2', 'unfolded2-land'];
const OPT_FILE_DIR: string = `opt`;
const CONFIG_VERSION: number = 500100000;
const INVALID_CONFIG_VERSION: number = -1;
const BLUR_RADIUS: number = 100;

// 优化后的缩略图目标宽度: 430vp
const DESIRED_WIDTH: number = 430;
const OPTIMIZE_WIDTH: number = 350;


export class ThemeResourceOptimizeServiceImpl implements ThemeResourceOptimizeService {

  /**
   * 监听事件
   * @param themeInfo 待优化的主题包
   */
  public async subscribeOptEvent(): Promise<void> {
    TsLog.info(TAG, `start subscribe optEvent enter`);
    // 监听TS主题使能事件
    EventEmitter.on(EventId.EVENT_ACTIVATE_THEME, (data: ActivateEventData) => this.optimizeCurrentTheme(data));
    EventEmitter.on(EventId.EVENT_GET_THEME_LIST,
      (themes: NullableType<ThemeInfo[]>) => this.optimizeThemeList(themes));
  }

  private async optimizeThemeList(themeList: NullableType<ThemeInfo[]>): Promise<void> {
    TsLog.debug(TAG, `optimizeThemeList start`);
    if (!themeList) {
      TsLog.error(TAG, `themeList is undefined`);
      return;
    }
    for (let theme of themeList) {
      await this.optimizeThemeImage(theme);
    }
  }

  private async optimizeCurrentTheme(data: ActivateEventData): Promise<void> {
    TsLog.debug(TAG, `optimizeCurrentTheme start`);
    if (!data.path) {
      TsLog.error(TAG, `path is undefined`);
      return;
    }
    let originThemePack: NullableType<ThemePackInfo> = await getThemePackParser().parse(data.path);
    let customThemePack: NullableType<ThemePackInfo> = await getCustomThemePack(data.editorId);
    let themeInfo = new ThemeInfo(data.id, data.editorId);
    themeInfo.originThemePack = originThemePack;
    themeInfo.customThemePack = customThemePack;
    await this.optimizeThemeImage(themeInfo);
  }

  /**
   * 优化主题包中图片资源
   * @param themeInfo 待优化的主题包
   */
  public async optimizeThemeImage(themeInfo: ThemeInfo): Promise<void> {
    // 优化原始主题包资源：lock、preview目录下的图片资源
    await this.optimizeOriginThemeImage(themeInfo);
    // 优化增量主题包资源：lock目录下的图片资源
    await this.optimizeCustomThemeImage(themeInfo);
  }

  private async optimizeOriginThemeImage(themeInfo: ThemeInfo): Promise<void> {
    if (!themeInfo) {
      TsLog.error(TAG, `themeInfo is undefined`);
      return;
    }
    const originThemePack: NullableType<ThemePackInfo> = themeInfo.originThemePack;
    if (!originThemePack) {
      TsLog.error(TAG, `originThemePack is undefined`);
      return;
    }
    const originImageOptPath: string = `${TSPathUtils.getTsPresetOptimizePath()}/${themeInfo.id}`;
    const pathEnable: boolean = await PathValidateUtil.validatePath(originImageOptPath);
    if (!pathEnable) {
      TsLog.error(TAG, `originImageOptPath validate path failed`);
      return;
    }
    await this.optimizeLockImage(themeInfo.id, originThemePack, originImageOptPath, true);
    // 只有在线主题缓存preview目录下的资源
    if (originThemePack?.origin === ORIGIN_ONLINE) {
      TsLog.info(TAG, `origin theme pack type: ${originThemePack?.origin}`)
      await this.optimizePreviewImage(themeInfo.id, originThemePack, originImageOptPath, true);
    }
  }

  private async optimizeCustomThemeImage(themeInfo: ThemeInfo): Promise<void> {
    if (!themeInfo) {
      TsLog.error(TAG, `themeInfo is undefined`);
      return;
    }
    const customThemePack: NullableType<ThemePackInfo> = themeInfo?.customThemePack;
    if (!customThemePack) {
      TsLog.error(TAG, `customThemePack is undefined`);
      return;
    }
    if (!FileUtil.isFileExists(customThemePack.srcPath)) {
      return;
    }
    await this.optimizeLockImage(themeInfo.id, customThemePack, customThemePack.srcPath,
      false);
  }

  // 根据LOCK_DIR，优化lock目录下对应的图片资源
  private async optimizeLockImage(themeId: string, themePack: ThemePackInfo, optRootPath: string,
    updateCache: boolean = false): Promise<void> {
    if (!themePack) {
      TsLog.error(TAG, `optimizeLockImage themePack is undefined`);
      return;
    }
    const lockManifest: Nullable<ManifestLite> = JsonUtils.parse(themePack.lockManifest);
    const originImageName: Nullable<string> = lockManifest?.image.src;
    if (!originImageName) {
      TsLog.info(TAG, `originImageName is empty `);
      return;
    }
    for (const type of QUALIFIER_STRINGS) {
      const lockOptPath: string = `${LOCK_PATH}/${type}/${RESOURCES_PATH}`;
      let originImagePath: string = `${themePack.srcPath}/${lockOptPath}/${originImageName}`;
      const configPath: string = `${themePack.srcPath}/${LOCK_PATH}/${type}/wallpaper_config.json`;
      const pathEnable: boolean = await PathValidateUtil.validatePath(originImagePath);
      if (!pathEnable) {
        TsLog.error(TAG, `originImagePath validate path failed`);
        return;
      }
      if (!FileUtil.isFileExists(originImagePath)) {
        originImagePath = FileUtil.isFileExists(configPath) ?
          `${themePack.srcPath}/${LOCK_PATH}/base/${RESOURCES_PATH}/${originImageName}` : '';
      }
      if (!FileUtil.isFileExists(originImagePath)) {
        continue;
      }
      const optPath: string = `${optRootPath}/opt/${lockOptPath}`;
      const optPathEnable: boolean = await PathValidateUtil.validatePath(optPath);
      if (!optPathEnable) {
        TsLog.error(TAG, `optPath validate path failed`);
        return;
      }
      const result: Nullable<string> = await this.optimizeImage(originImagePath, optPath);
      if (!(result && updateCache)) {
        TsLog.debug(TAG, `result: ${result}, updateCache: ${updateCache} no need optimize cache`);
        continue;
      }
      const optimizeInfo: ThemeOptimizeInfo = new ThemeOptimizeInfo(themeId, themePack?.origin ?? 'preset', lockOptPath,
        FileUtil.getFileName(originImagePath), result);
      await this.addThemeOptimizeCache(optimizeInfo);
    }
  }

  // 根据PREVIEW_DIR，优化preview目录下对应的图片资源，不会递归获取当前目录下子目录的文件
  private async optimizePreviewImage(themeId: string, themePack: ThemePackInfo, optRootPath: string,
    updateCache: boolean = false): Promise<void> {
    if (!themePack) {
      TsLog.error(TAG, `previewImage themePack is undefined`);
      return;
    }

    for (const type of QUALIFIER_STRINGS) {
      const previewOpt: string = `${PREVIEW_PATH}/${type}`;
      const previewDir: string = `${themePack.srcPath}/${previewOpt}`;
      const paths: string[] = await FileUtil.listFiles(previewDir);
      for (const originPath of paths) {
        if (!FileUtil.isFileExists(originPath)) {
          TsLog.error(TAG, `file: ${FileUtil.getFileName(originPath)} not exists`);
          return;
        }
        const optPath: string = StringUtils.join(FILE_SEPARATOR, [optRootPath, OPT_FILE_DIR, previewOpt]);
        TsLog.info(TAG, `optimizePreviewImage, themeId: ${themeId}, type: ${type}`);
        const result: Nullable<string> = await this.optimizeImage(originPath, optPath);
        if (!(result && updateCache)) {
          TsLog.debug(TAG, `result: ${result}, updateCache: ${updateCache} no need optimize cache`);
          continue;
        }
        const optimizeInfo: ThemeOptimizeInfo = new ThemeOptimizeInfo(themeId, themePack?.origin ?? 'preset',
          previewOpt, FileUtil.getFileName(originPath), result);
        await this.addThemeOptimizeCache(optimizeInfo);
      }
    }
  }

  /**
   * 根据目标宽度缩小原图，保存缩略图至缓存路径
   *
   * @param originPath 原图路径
   * @param optPath 优化后的图片保存目录(根目录，不含文件名)
   * @returns Promise<void>
   */
  private async optimizeImage(originPath: string, optPath: string): Promise<Nullable<string>> {
    const suffix: string = FileUtil.getFileSuffix(originPath);
    let result: Nullable<string>;
    if (suffix !== IMAGE_SUFFIX_PNG && suffix !== IMAGE_SUFFIX_JPG) {
      TsLog.warning(TAG, `file: ${FileUtil.getFileName(originPath)} format ${suffix} not support`);
      return result;
    }
    result = await this.optimizeResult(originPath, optPath, 'medium', this.getOptimizeImageSize(DESIRED_WIDTH));
    await this.optimizeResult(originPath, optPath, 'medium_blur',
      this.getOptimizeImageSize(OPTIMIZE_WIDTH), BLUR_RADIUS);
    if (deviceInfo.deviceType === 'tablet') {
      try {
        // 大画廊的缩略图目标宽度：屏幕宽度*0.6 (只平板)
        const MAX_DESIRED_WIDTH: number = Math.round(display.getDefaultDisplaySync().width * 0.6);
        await this.optimizeResult(originPath, optPath, 'max',
          Math.max(MAX_DESIRED_WIDTH, this.getOptimizeImageSize(DESIRED_WIDTH)));
      } catch (err) {
        TsLog.error(TAG, `optimizeImage max desired width catch exception.`, err);
      }
    }
    return result;
  }


  private async optimizeResult(originPath: string, optPath: string, optimizeName: string, width: number,
    radius: number = 0): Promise<Nullable<string>> {
    let result: Nullable<string>;
    const originImageName: string = FileUtil.getFileName(originPath).split('.')[0];
    const cacheImageName: string = `${originImageName}_${optimizeName}${FILE_SUFFIX_ASTC}`;
    const cachePath: string = StringUtils.join(FILE_SEPARATOR, [optPath, cacheImageName]);
    if (FileUtil.isFileExists(cachePath)) {
      return result;
    }
    result = await ThumbnailProcessor.getInstance().saveThumbnailInTaskPool(width, originPath, cachePath, radius);
    TsLog.info(TAG, `start save Thumbnail cacheImageName: ${cacheImageName}, result:${result}`);
    return result;
  }

  private async addThemeOptimizeCache(optimizeInfo: ThemeOptimizeInfo): Promise<void> {
    if (!optimizeInfo) {
      TsLog.error(TAG, `optimizeIfo is undefined`);
      return;
    }
    const caches: NullableType<ThemeOptimizeInfo[]> = await ThemeOptimizeCache.getInstance().get() ?? [];
    caches?.push(optimizeInfo);
    await ThemeOptimizeCache.getInstance().update(caches);
  }

  private getOptimizeImageSize(width: number): number {
    return Math.round(vp2px(width));
  }
}

export class ManifestLite {
  public type: string = `image`;

  public image: Image = new Image();

  public applyFrom?: string;
}

export class Image {
  public src?: string;
}

export const themeResourceOptService: Singleton<ThemeResourceOptimizeService> =
  new Singleton<ThemeResourceOptimizeService>(() => new ThemeResourceOptimizeServiceImpl());