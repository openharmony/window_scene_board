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
import { image } from '@kit.ImageKit';
import { effectKit } from '@kit.ArkGraphics2D';
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const TAG = 'ScreenLock-StyleManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

class StyleManager {
  private reverseColorsMap: Map<string, ReverseColor> = new Map();
  private slWallpaperDegree: effectKit.PictureLightColorDegree = 0;
  private isDarkWallPaper: boolean = false;

  public async getIconShadow(sourceIcon: Resource, blur: number, callback: Callback<PixelMap>): Promise<void> {
    try {
      log.showDebug(`getIconShadow`);
      const buffer: Uint8Array = await getContext().resourceManager.getMediaContent(sourceIcon);
      const imageSource: image.ImageSource = image.createImageSource(buffer.buffer as ArrayBuffer);
      if (!imageSource) {
        log.showWarn(`getIconShadow imageSource is null`);
        return;
      }
      const sourcePixelMap = await imageSource.createPixelMap();
      if (!sourcePixelMap) {
        log.showWarn(`getIconShadow sourcePixelMap is null`);
        return;
      }
      effectKit.createEffect(sourcePixelMap)
        .blur(blur)
        .getPixelMap()
        .createAlphaPixelmap()
        .then((alphaPixelMap: PixelMap) => {
          callback(alphaPixelMap);
          log.showDebug(`getIconShadow createEffect success`);
        })
      imageSource.release();
    } catch (error) {
      log.showError(`getIconShadow createPixelMap error`);
    }
  }

  public updateWallpaperMode(wallpaperDegree: number): void {
    if (wallpaperDegree < 1 || wallpaperDegree > 6) {
      log.showInfo(`wallpaperDegree:${wallpaperDegree}, is invalid`);
      return;
    }
    this.isDarkWallPaper = (wallpaperDegree !== 1) && (wallpaperDegree !== 2);
    this.slWallpaperDegree = wallpaperDegree;
    log.showInfo(`isDarkWallPaper:${this.isDarkWallPaper}, ${this.slWallpaperDegree}`);
    this.doReverseColors();
  }

  getWallpaperDegree(): effectKit.PictureLightColorDegree {
    return this.slWallpaperDegree;
  }

  public reverseColor(styleId: string, style?: ReverseColor): void {
    if (!!style) {
      style.updateColor(this.isDarkWallPaper, this.slWallpaperDegree);
      return;
    }
    this.reverseColorsMap.get(styleId)?.updateColor(this.isDarkWallPaper, this.slWallpaperDegree);
  }

  public async doReverseColors(): Promise<void> {
    log.showInfo(`doReverseColor:len:${this.reverseColorsMap.size}`);
    this.reverseColorsMap.forEach(component => {
      component.updateColor(this.isDarkWallPaper, this.slWallpaperDegree);
    })
  }

  public registerReverseColor(key: string, component: ReverseColor): void {
    this.reverseColorsMap.set(key, component);
    this.reverseColor(key);
  }

  public unRegisterReverseColor(key: string): void {
    this.reverseColorsMap.delete(key);
  }

}

export interface ReverseColor {
  updateColor(isBrightWallpaper: boolean, wallpaperDegree?: number): void;
}

let styleManager = SingletonHelper.getInstance(StyleManager, TAG);

export default styleManager as StyleManager;