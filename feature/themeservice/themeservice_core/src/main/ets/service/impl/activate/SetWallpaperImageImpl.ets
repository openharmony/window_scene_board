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
import wallpaper from '@ohos.wallpaper';
import { ActivateEventData, EventId } from '@ohos/themeservice_inner_api';
import { EventEmitter, FileUtil, JsonUtils, Singleton, StringUtils, TsLog } from '@ohos/themeservicebase';
import { TSPathUtils } from '../../../util/TSPathUtils';
import { SetWallPaperImage } from '../../api/SetWallpaperImage';
import { WallPaperManifest } from '../../model/Manifest';
import { WallpapersBlurProcessor } from '../optimize/WallpapersBlurProcessor';
import { FoldState, RotateState, WallpaperCaller, WallpaperInfo, WallpaperType } from './WallpaperCaller';

const TAG: string = `SetWallPaperImageImpl`;

export class SetWallPaperImageImpl implements SetWallPaperImage {
  private srcPath: string = '';

  private customPath: string = '';

  private wallpaperMap: Map<string, [FoldState, RotateState]> = new Map([
    ['base', [FoldState.NORMAL, RotateState.PORTRAIT]],
    ['land', [FoldState.NORMAL, RotateState.LANDSCAPE]],
    ['unfolded', [FoldState.UNFOLD_ONCE_STATE, RotateState.PORTRAIT]],
    ['unfolded2', [FoldState.UNFOLD_TWICE_STATE, RotateState.PORTRAIT]],
    ['unfolded-land', [FoldState.UNFOLD_ONCE_STATE, RotateState.LANDSCAPE]],
    ['unfolded2-land', [FoldState.UNFOLD_TWICE_STATE, RotateState.LANDSCAPE]],
  ]);

  /**
   * 监听事件
   * @param event
   */
  public async subscribeWallpaperEvent(): Promise<void> {
    TsLog.info(TAG, `start subscribe WallpaperEvent enter`);
    // 监听TS主题使能事件
    EventEmitter.on(EventId.EVENT_ACTIVATE_THEME,
      (event: ActivateEventData) => this.setThemeWallpaperImage(event));
    return;
  }

  public async initThemeWallpaperImage(path: string, editorId: string): Promise<void> {
    TsLog.info(TAG, 'initThemeWallpaperImage');
    this.srcPath = path;
    this.customPath = `${TSPathUtils.getTsCustomRootPath()}/${editorId}`;
    await this.setWallPaperImage('home');
    await this.setWallPaperImage('lock');
  }

  private async setThemeWallpaperImage(event: ActivateEventData): Promise<void> {
    TsLog.info(TAG, `setThemeWallpaperImage start`);
    if (!event || !event.path || StringUtils.isEmpty(event.path)) {
      TsLog.error(TAG, `event is undefined or empty`);
      return;
    }
    this.srcPath = event.path;
    this.customPath = `${TSPathUtils.getTsCustomRootPath()}/${event.editorId}`;
    if (event.home === true) {
      await this.setWallPaperImage('home');
    }
    if (event.lock === true && !event.lockConfig) {
      await this.setWallPaperImage('lock');
    }
  }

  private getWallPaperImage(path: string): string | undefined {
    if (FileUtil.isFileExists(`${path}/manifest.json`)) {
      const cusManiContent = FileUtil.getStringByFile(`${path}/manifest.json`);
      const cusManifest: WallPaperManifest | undefined = JsonUtils.parse(cusManiContent);
      return cusManifest?.image.src;
    }
    return undefined;
  }

  private getWallPaperImageByCategory(wallpaperTypeStr: string, category: string): string | undefined {
    let image: string | undefined = undefined;
    image = this.getWallPaperImage(`${this.customPath}/${wallpaperTypeStr}/${category}`);
    if (typeof image === 'string') {
      return image;
    }
    image = this.getWallPaperImage(`${this.srcPath}/${wallpaperTypeStr}/${category}`);
    if (typeof image === 'string') {
      return image;
    }
    image = this.getWallPaperImage(`${this.customPath}/${wallpaperTypeStr}`);
    if (typeof image === 'string') {
      return image;
    }
    image = this.getWallPaperImage(`${this.srcPath}/${wallpaperTypeStr}`);
    if (typeof image === 'string') {
      return image;
    }
    return image;
  }

  private async setWallPaperImage(wallpaperTypeStr: string): Promise<void> {
    TsLog.info(TAG, `setWallPaperImage start, type: ${wallpaperTypeStr}`);
    let wallpaperInfos: WallpaperInfo[] = [];
    this.wallpaperMap.forEach((value, category) => {
      const image: string | undefined = this.getWallPaperImageByCategory(wallpaperTypeStr, category);
      if (image) {
        const imageSrcPath: string = `${this.srcPath}/${wallpaperTypeStr}/${category}/resources/${image}`;
        const imageCusPath: string = `${this.customPath}/${wallpaperTypeStr}/${category}/resources/${image}`;
        const cusWallpaperConfig: string = `${this.customPath}/${wallpaperTypeStr}/${category}/wallpaper_config.json`;
        const baseImageSrcPath: string = `${this.customPath}/${wallpaperTypeStr}/base/resources/${image}`;
        if (FileUtil.isFileExists(imageCusPath)) {
          wallpaperInfos.push({ foldState: value[0], rotateState: value[1], source: imageCusPath });
        } else if (FileUtil.isFileExists(cusWallpaperConfig) && FileUtil.isFileExists(baseImageSrcPath)) {
          wallpaperInfos.push({ foldState: value[0], rotateState: value[1], source: baseImageSrcPath });
        } else if (FileUtil.isFileExists(imageSrcPath)) {
          wallpaperInfos.push({ foldState: value[0], rotateState: value[1], source: imageSrcPath });
        }
      }
    })
    if (wallpaperTypeStr === 'lock') {
      this.setWallPaperBlurImage(wallpaperInfos, wallpaperTypeStr, wallpaper.WallpaperType.WALLPAPER_LOCKSCREEN);
    } else if (wallpaperTypeStr === 'home') {
      this.setWallPaperBlurImage(wallpaperInfos, wallpaperTypeStr, wallpaper.WallpaperType.WALLPAPER_SYSTEM);
    }
  }

  private async setWallPaperBlurImage(wallpaperInfos: WallpaperInfo[], wallpaperTypeStr: string,
    type: WallpaperType): Promise<void> {
    const blurRootPath: string = TSPathUtils.getTsWallpaperBlurPath();
    WallpapersBlurProcessor.saveWallpapersBlurInTaskPool(wallpaperInfos, wallpaperTypeStr, blurRootPath)
      .then(async (wallpapers) => {
        await WallpaperCaller.setAllWallpapers(wallpapers ?? [], type);
        return wallpapers;
      })
      .then((wallpapers) => {
        if (wallpapers) {
          WallpapersBlurProcessor.releaseWallpaperBlurCache(wallpapers);
        }
      }).catch((err: Error) => {
      TsLog.error(TAG, 'setWallPaperImage failed: ', err);
    });
  }
}

export const setWallPaperImageService: Singleton<SetWallPaperImage> =
  new Singleton<SetWallPaperImage>(() => new SetWallPaperImageImpl());