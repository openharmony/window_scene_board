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

import { image } from '@kit.ImageKit';
import { effectKit } from '@kit.ArkGraphics2D';
import { AigcPixelmapUtils } from './AigcPixelmapUtils';
import { Log } from './IdlService/Log';

const STATUS_HEIGHT: number = 135;
const BIG_FOLD_STATUS_HEIGHT_RATIO: number = 0.12;
const MAX_DARK_WIDTH: number = 1600;
const BASE_DARKEN_RATIO: number = 0.75;
const GRADIENT_DARKEN_RATIO: number = 0.25;
const CHANNEL_1: number = 1;
const CHANNEL_2: number = 2;
const CHANNEL_NUMBER: number = 4;
const TAG: string = '[AigcService]AigcWallpaperColorManager';

export class AigcWallpaperColorManager {
  /**
   * 获取图片的亮度等级
   * @param pixelMap 图片像素
   * @return 返回图片的亮度等级，如果失败则返回null
   */
  public static async getLightDegree(pixelMap: image.PixelMap): Promise<effectKit.PictureLightColorDegree | null> {
    Log.info(TAG, 'getLightDegree begin');
    if (!pixelMap) {
      Log.error(TAG, 'Invalid input for getLightDegree: pixelMap cannot be undefined or null');
      return null;
    }
    let imagePixelMap: image.PixelMap | undefined = undefined;
    let colorPicker: effectKit.ColorPicker | undefined = undefined;
    try {
      const imageInfo: image.ImageInfo = await pixelMap.getImageInfo();
      imagePixelMap = await AigcPixelmapUtils.clonePixelMap(pixelMap);
      if (imagePixelMap === undefined) {
        Log.error(TAG, 'Clone pixelmap failed, so cannot get status bar area image light degree');
        return null;
      }
      let region: image.Region = {
        x: 0,
        y: 0,
        size: { height: STATUS_HEIGHT, width: imageInfo.size.width }
      };
      await imagePixelMap.crop(region);
      colorPicker = await effectKit.createColorPicker(imagePixelMap);
      const degree: effectKit.PictureLightColorDegree = colorPicker.discriminatePitureLightDegree();
      return degree;
    } catch (err) {
      Log.error(TAG, `Get status bar area image light degree failed: code is ${err?.code}, msg is ${err?.message}`);
      return null;
    } finally {
      if (colorPicker !== undefined) {
        // MemoryUtils.removeNapiWrap(colorPicker, false);
      }
      imagePixelMap?.release();
      Log.info(TAG, 'getLightDegree finish');
    }
  }

  /**
   * 对状态栏区域进行压暗处理
   * @param pixelMap 图像像素
   * @return Promise<void> 返回一个Promise，当操作完成时resolve
   */
  public static async darkStatusArea(pixelMap: image.PixelMap): Promise<void> {
    Log.info(TAG, 'darkStatusArea begin');
    if (!pixelMap) {
      Log.error(TAG, 'Invalid input for darkStatusArea: pixelMap cannot be undefined or null');
      return;
    }
    try {
      const statusHeight: number = STATUS_HEIGHT;
      let imageInfo: image.ImageInfo = await pixelMap.getImageInfo();
      if (imageInfo.size.width > MAX_DARK_WIDTH) {
        Log.error(TAG, 'Invalid input for darkStatusArea: input pixelmap width exceeds limit');
        return;
      }
      let byteNumbers: number = pixelMap.getBytesNumberPerRow();
      if (byteNumbers <= 0 || byteNumbers > MAX_DARK_WIDTH * CHANNEL_NUMBER) {
        Log.error(TAG, `Invalid input for darkStatusArea: pixel bytes number is ${byteNumbers}`);
        return;
      }
      let pixels: Uint8Array = new Uint8Array(byteNumbers * statusHeight);
      let area : image.PositionArea = {
        pixels: pixels.buffer,
        offset: 0,
        stride: byteNumbers,
        region: { size: { height: statusHeight, width: imageInfo.size.width }, x: 0, y: 0 }
      }
      await pixelMap.readPixels(area);

      for (let i = 0; i < statusHeight; i++) {
        for (let j = 0; j < imageInfo.size.width; j++) {
          let index: number = (i * imageInfo.size.width + j) * CHANNEL_NUMBER;
          pixels[index] *= (BASE_DARKEN_RATIO + GRADIENT_DARKEN_RATIO * i / statusHeight); // B
          pixels[index + CHANNEL_1] *= (BASE_DARKEN_RATIO + GRADIENT_DARKEN_RATIO * i / statusHeight); // G
          pixels[index + CHANNEL_2] *= (BASE_DARKEN_RATIO + GRADIENT_DARKEN_RATIO * i / statusHeight); // R
        }
      }
      await pixelMap.writePixels(area);
      Log.info(TAG, 'darkStatusArea finish');
    } catch (err) {
      Log.error(TAG, `Darken status area failed: code is ${err?.code}, msg is ${err?.message}`);
    }
  }

  /**
   * 大折叠压暗状态栏
   *
   * @param pixelMap 直接操作原图，对原图状态栏区域压暗
   */
  public static async darkBigFoldStatusArea(pixelMap: image.PixelMap): Promise<void> {
    Log.info(TAG, 'darkBigFoldStatusArea begin');
    if (!pixelMap) {
      Log.error(TAG, 'Invalid input for darkBigFoldStatusArea: pixelMap cannot be undefined or null');
      return;
    }
    try {
      let imageInfo: image.ImageInfo = await pixelMap.getImageInfo();
      if (imageInfo.size.width > MAX_DARK_WIDTH) {
        Log.error(TAG, 'Invalid input for darkBigFoldStatusArea: input pixelmap width exceeds limit');
        return;
      }
      let byteNumbers: number = pixelMap.getBytesNumberPerRow();
      if (byteNumbers <= 0 || byteNumbers > MAX_DARK_WIDTH * CHANNEL_NUMBER) {
        Log.error(TAG, `Invalid input for darkBigFoldStatusArea: pixel bytes number is ${byteNumbers}`);
        return;
      }
      const statusHeight: number = Math.ceil(imageInfo.size.height * BIG_FOLD_STATUS_HEIGHT_RATIO);
      let pixels: Uint8Array = new Uint8Array(byteNumbers * statusHeight);
      let area : image.PositionArea = {
        pixels: pixels.buffer,
        offset: 0,
        stride: byteNumbers,
        region: { size: { height: statusHeight, width: imageInfo.size.width }, x: 0, y: 0 }
      }
      await pixelMap.readPixels(area);

      for (let i = 0; i < statusHeight; i++) {
        for (let j = 0; j < imageInfo.size.width; j++) {
          let index: number = (i * imageInfo.size.width + j) * CHANNEL_NUMBER;
          pixels[index] *= (BASE_DARKEN_RATIO + GRADIENT_DARKEN_RATIO * i / statusHeight); // B
          pixels[index + CHANNEL_1] *= (BASE_DARKEN_RATIO + GRADIENT_DARKEN_RATIO * i / statusHeight); // G
          pixels[index + CHANNEL_2] *= (BASE_DARKEN_RATIO + GRADIENT_DARKEN_RATIO * i / statusHeight); // R
        }
      }
      await pixelMap.writePixels(area);
      Log.info(TAG, 'darkBigFoldStatusArea finish');
    } catch (err) {
      Log.error(TAG, `darkBigFoldStatusArea failed: code is ${err?.code}, msg is ${err?.message}`);
    }
  }
}