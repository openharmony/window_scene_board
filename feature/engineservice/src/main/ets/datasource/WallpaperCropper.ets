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

import lazy image from '@ohos.multimedia.image';
import { DeviceUtil } from '../utils/DeviceUtil';
import { GlobalContext } from '../utils/GlobalContext';
import { Log } from '../utils/Log';


const TAG: string = 'WallpaperCropper';
const CROP_COEFFICIENT: number = 0.5;
const DEFAULT_SCALE: number = 1;

/**
 * Provide methods for static wallpaper to crop to meet basic memory requirement
 *
 * @since 2024-02-27
 */
export class WallpaperCropper {
  private horizontalScaleAfterCrop: number = DEFAULT_SCALE;
  private verticalScaleAfterCrop: number = DEFAULT_SCALE;

  /**
   * Get the cropped horizontal scale of the image
   *
   * @returns Horizontal scale after crop
   */
  public getHorizontalScale(): number {
    if (this.horizontalScaleAfterCrop <= 0) {
      return DEFAULT_SCALE;
    }
    return this.horizontalScaleAfterCrop;
  }

  /**
   * Get the cropped vertical scale of the image
   *
   * @returns Vertical scale after crop
   */
  public getVerticalScale(): number {
    if (this.verticalScaleAfterCrop <= 0) {
      return DEFAULT_SCALE;
    }
    return this.verticalScaleAfterCrop;
  }

  private canBeCropped(imageInfo: image.ImageInfo, screenWidth: number, screenHeight: number): boolean {
    if (screenWidth === 0 || screenHeight === 0) {
      Log.warn(TAG, 'Unable to decide crop area without a valid display info.');
      return false;
    }

    if (imageInfo.size.height === 0 || imageInfo.size.width === 0) {
      Log.warn(TAG, 'Unable to crop with invalid image size info.');
      return false;
    }

    // No crop is needed for foldables and pad
    if (DeviceUtil.isFold() || DeviceUtil.isPad()) {
      Log.warn(TAG, 'No crop is needed for foldables and pad.');
      return false;
    }

    return true;
  }

  private updateScale(horizontalScale: number, verticalScale: number): void {
    this.horizontalScaleAfterCrop = horizontalScale;
    this.verticalScaleAfterCrop = verticalScale;
  }

  /**
   * Given image and display size, calculate the actual visible region of this image on current display
   * and crop the image to meet the memory consumption standard.
   *
   * @param imageInfo Basic info of the given image with size info included
   * @returns Decoding option that would allow the image to be cropped to the actual visible region
   */
  public async getCropDecodingOption(imageInfo: image.ImageInfo):
    Promise<image.DecodingOptions | undefined> {
    let screenWidth: number = this.getScreenWidth();
    let screenHeight: number = this.getScreenHeight();

    if (!this.canBeCropped(imageInfo, screenWidth, screenHeight)) {
      Log.warn(TAG, 'Skipping crop for not able to crop');
      return undefined;
    }

    let isNeedSwitchSide: boolean = this.isPhoneInLandscape();
    let actualDisplayWidth: number = isNeedSwitchSide ? screenHeight : screenWidth;
    let actualDisplayHeight: number = isNeedSwitchSide ? screenWidth : screenHeight;

    let imageHeight: number = imageInfo.size.height;
    let imageWidth: number = imageInfo.size.width;
    Log.info(TAG, `Getting image size ${imageWidth}x${imageHeight},
      display size ${actualDisplayWidth}x${actualDisplayHeight}`);

    // Dividend check has been done in canBeCropped()
    let displayRatio: number = actualDisplayHeight / actualDisplayWidth;
    let imageRatio: number = imageHeight / imageWidth;

    let isImageWider: boolean = imageRatio < displayRatio;

    // Alter the image's w/h ratio to the display's ratio
    let alteredHeight: number = isImageWider ? imageHeight : displayRatio * imageWidth;
    let alteredWidth: number = isImageWider ? 1 / displayRatio * imageHeight : imageWidth;

    // Reset image region with the new ratio
    let horizontalRegionStart: number = imageWidth > alteredWidth ?
      (imageWidth - alteredWidth) * CROP_COEFFICIENT : 0;
    let verticalRegionStart: number = imageHeight > alteredHeight ?
      (imageHeight - alteredHeight) * CROP_COEFFICIENT : 0;

    Log.info(TAG, `Wallpaper crop option size ${alteredWidth}x${alteredHeight},
      region start [${horizontalRegionStart}, ${verticalRegionStart}]`);

    let decodingOptions: image.DecodingOptions = {
      desiredRegion: {
        size: { height: alteredHeight, width: alteredWidth },
        x: horizontalRegionStart,
        y: verticalRegionStart,
      },
    };

    this.updateScale(actualDisplayHeight / alteredHeight, actualDisplayWidth / alteredWidth);
    return decodingOptions;
  }

  /**
   * 判断是否是横屏状态的直板机，在桌面重启时从display获取的参数有异常，故优先读取桌面传入的参数，读取失败才从display读取
   *
   * @returns true为横屏
   */
  private isPhoneInLandscape(): boolean {
    let screenOrientation: Object | undefined = GlobalContext.getContext().getObject('screenOrientation');
    return typeof screenOrientation === 'number' ? DeviceUtil.isPhoneInLandscape(screenOrientation as number) :
      DeviceUtil.isPhoneInLandscape();
  }

  private getScreenWidth(): number {
    let screenWidth: Object | undefined = GlobalContext.getContext().getObject('screenWidth');
    return typeof screenWidth === 'number' ? screenWidth as number : DeviceUtil.getScreenWidth();
  }

  private getScreenHeight(): number {
    let screenHeight: Object | undefined = GlobalContext.getContext().getObject('screenHeight');
    return typeof screenHeight === 'number' ? screenHeight as number : DeviceUtil.getScreenHeight();
  }
}