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

import lazy image from '@ohos.multimedia.image';
import lazy WallpaperMar from '@ohos.wallpaper';
import { ThemeLoadPublisher } from '../datdamanager/ThemeLoadPublisher';
import { Constants } from '../utils/Constants';
import { Log } from '../utils/Log';
import { WallpaperModifier } from './WallpaperModifier';


const TAG: string = 'DefaultWallpaperDataSource';

/**
 * Component definition of default wallpaper, it will be loaded to the wallpaper component when
 * given wallpaper type is DEFAULT.
 *
 * @since 2024-02-27
 */
@Component
export struct DefaultWallpaperDataSource {
  private bsodTag: string = Constants.PREFIX_BSOD + TAG;

  @State private imagePixelMap?: image.PixelMap = undefined;

  @State public modifier: WallpaperModifier | null = null;

  /**
   * On loading default wallpaper component, load wallpaper resource from WallpaperMar.getImage interface.
   */
  public async aboutToAppear(): Promise<void> {
    Log.info(TAG, 'Attempt to load default wallpaper.');
    try {
      this.imagePixelMap = await WallpaperMar.getImage(WallpaperMar.WallpaperType.WALLPAPER_SYSTEM);
      Log.info(TAG, `getImage pixelMap width: ${this.imagePixelMap.getImageInfoSync().size.width}` +
        ` height:${this.imagePixelMap.getImageInfoSync().size.height}`);
      ThemeLoadPublisher.getInstance().reportThemeLoad();
    } catch (err) {
      Log.error(TAG, `Error on loading default wallpaper, wallpaper may not work properly. ${err.code} - ${err
        .message}`);
    }
  }

  /**
   * Release PixelMap instance and resource on destroying this component.
   */
  public aboutToDisappear(): void {
    Log.warn(this.bsodTag, `in default wallpaper aboutToDisappear() release pixelMap.`);
    this.imagePixelMap?.release();
  }

  public onPageHide(): void {
    Log.warn(this.bsodTag, `in default wallpaper onPageHide() release source.`);
  }

  public build(): void {
    Image(this.imagePixelMap)
      .draggable(false)
      .width('100%')
      .height('100%')
      .objectFit(ImageFit.Cover)
      .hoverEffect(HoverEffect.None)
      .interpolation(ImageInterpolation.Low)
      .attributeModifier(this.modifier)
  }
}