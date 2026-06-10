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

import fileIo from '@ohos.file.fs';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { image } from '@kit.ImageKit';

const TAG: string = 'WallpaperApply-PixelMapUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 图像翻转类型
 */
export enum ImageFlipType {
  NONE = 0,
  HORIZONTAL = 1,
  VERTICAL = 2,
};

/**
 * 位图工具类
 *
 * @since 2025-05-26
 */
export class PixelMapUtil {
  /**
   * 将pixelMap图片保存到沙箱目录
   * @param pixelMap
   * @param path
   * @returns
   */
  public static async writePixelMapToPath(pixelMap: image.PixelMap | null, path: string): Promise<void> {
    if (!pixelMap) {
      log.showError('writePixelMapToPath pixelMap is null!');
      return;
    }
    let imagePacker: image.ImagePacker | undefined = undefined;
    let buffer: ArrayBuffer | undefined = undefined;
    try {
      imagePacker = image.createImagePacker()
      buffer = await imagePacker?.packing(pixelMap, {
        format: 'image/jpeg', quality: 95
      });
    } catch (err) {
      log.showError(`packing pixelMap failed: ${err?.message}`);
      return;
    } finally {
      imagePacker?.release();
    }
    let file: fileIo.File | undefined = undefined;
    try {
      file = await fileIo.open(path, fileIo.OpenMode.CREATE | fileIo.OpenMode.WRITE_ONLY);
      let writeLen = await fileIo.write(file.fd, buffer);
      log.showInfo(`write Len: ${writeLen}`);
    } catch (err) {
      log.showError(`writePixelMapToPath failed: ${err?.message}`);
    } finally {
      try {
        if (file) {
          await fileIo.close(file);
        }
      } catch (err) {
        log.showError(`writePixelMapToPath file close: ${err?.message}`);
      }
    }
  }

  /**
   * 获取图片旋转角度
   * @param imageSource
   * @returns number
   */
  public static async getImageRotateAngle(imageSource: image.ImageSource): Promise<number> {
    try {
      log.showInfo('getImageRotateAngle start');
      const orientation: string = await imageSource.getImageProperty(image.PropertyKey.ORIENTATION);
      log.showInfo(`orientation ${orientation}`);
      return PixelMapUtil.convertRotateAngle(orientation);
    } catch (err) {
      log.showError(`getImageRotateAngle err: ${err?.message}`);
      return 0;
    }
  }

  /**
   * 获取图片方向
   * @param imageSource
   * @returns string
   */
  public static async getImageOrientation(imageSource: image.ImageSource): Promise<string> {
    try {
      log.showInfo('getImageOrientation start');
      const orientation: string = await imageSource.getImageProperty(image.PropertyKey.ORIENTATION);
      log.showInfo(`orientation ${orientation}`);
      return orientation;
    } catch (err) {
      log.showError(`getImageOrientation err,code: ${err?.code} msg: ${err?.message}`);
      return '';
    }
  }

  /**
   * 获取旋转角度
   * @param orientation
   * @returns number
   */
  public static convertRotateAngle(orientation: string): number {
    let angle: number = 0;
    switch (orientation) {
      case 'Bottom-right':
        angle = 180;
        break;
      case 'Left-top':
      case 'Left-bottom':
        angle = 270;
        break;
      case 'Right-top':
      case 'Right-bottom':
        angle = 90;
        break;
      default:
        break;
    }
    return angle;
  }

  /**
   * 获取翻转类型
   * @param orientation
   * @returns ImageFlipType
   */
  public static convertFlipType(orientation: string): ImageFlipType {
    let flipType: ImageFlipType = ImageFlipType.NONE; // 不发生翻转
    switch (orientation) {
      case 'Top-right': // 镜像水平翻转
      case 'Left-top': //镜像水平翻转再顺时针旋转270°
      case 'Right-bottom': // 镜像水平翻转再顺时针旋转90°
        flipType = ImageFlipType.HORIZONTAL;
        break;
      case 'Bottom-left': // 镜像垂直翻转
        flipType = ImageFlipType.VERTICAL;
        break;
      default:
        break;
    }
    return flipType;
  }
}