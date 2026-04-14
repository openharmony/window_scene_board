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

import { LogDomain, Logger } from '@ohos/basicutils';
import { image } from '@kit.ImageKit';
// import { ArtSignPhotoOrientation } from '../../clock/common/ArtSignConstants';

/**
 * 图片最大尺寸
 */
export const IMAGE_MAX_SIZE: number = 6400;
const TAG: string = 'ART_SIGN_ImageUtil';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

export class ImageUtil {

  /**
   * 获取图片方向
   * @param imageSource
   * @returns
   */
  private static async getOrientation(imageSource: image.ImageSource): Promise<string> {
    try {
      if (!imageSource) {
        return '';
      }
      return await imageSource.getImageProperty(image.PropertyKey.ORIENTATION);
    } catch (err) {
      log.showError(TAG, `Failed to getImageProperty. error message: ${err.code}`);
    }
    return '';
  }

  /**
   * pixel旋转
   * PS：整个方法扒自文件预览，获取方向为空则不旋转
   * 1：Top-left，图像未旋转。
   - 2：Top-right，镜像水平翻转。
   - 3：Bottom-right，图像旋转180°。
   - 4：Bottom-left，镜像垂直翻转。
   - 5：Left-top，镜像水平翻转再顺时针旋转270°。
   - 6：Right-top，顺时针旋转90°。
   - 7：Right-bottom，镜像水平翻转再顺时针旋转90°。
   - 8：Left-bottom，顺时针旋转270°。
   - 未定义值返回Unknown Value。
   */
  private static orientationPixelMap(orientation: string,
    pixelMap: image.PixelMap | undefined): image.PixelMap | undefined {
    if (!pixelMap) {
      return;
    }
    /*
    if (orientation === ArtSignPhotoOrientation.TOP_RIGHT) {
      pixelMap?.flipSync(true, false);
      log.showInfo(TAG, `orientationPixelMap Top-right`);
    } else if (orientation === ArtSignPhotoOrientation.BOTTOM_RIGHT) {
      pixelMap?.rotateSync(180);
      log.showInfo(TAG, `orientationPixelMap Bottom-right`);
    } else if (orientation === ArtSignPhotoOrientation.BOTTOM_LEFT) {
      pixelMap?.flipSync(false, true);
      log.showInfo(TAG, `orientationPixelMap Bottom-left`);
    } else if (orientation === ArtSignPhotoOrientation.LEFT_TOP) {
      pixelMap?.flipSync(true, false);
      pixelMap?.rotateSync(270);
      log.showInfo(TAG, `orientationPixelMap Left-top`);
    } else if (orientation === ArtSignPhotoOrientation.RIGHT_TOP) {
      pixelMap?.rotateSync(90);
      log.showInfo(TAG, `orientationPixelMap Right-top`);
    } else if (orientation === ArtSignPhotoOrientation.RIGHT_BOTTOM) {
      pixelMap?.flipSync(true, false);
      pixelMap?.rotateSync(90);
      log.showInfo(TAG, `orientationPixelMap Right-bottom`);
    } else if (orientation === ArtSignPhotoOrientation.LEFT_BOTTOM) {
      pixelMap?.rotateSync(270);
      log.showInfo(TAG, `orientationPixelMap Left-bottom`);
    }
    * */
    return pixelMap;
  }

  /**
   * 图片旋转
   * @param imageSource
   * @param pixelMap
   * @returns
   */
  public static async rotatePixelMap(imageSource: image.ImageSource,
    pixelMap: image.PixelMap | undefined): Promise<image.PixelMap | undefined> {
    const orientation: string = await ImageUtil.getOrientation(imageSource);
    log.showError(TAG, `orientation ${orientation}`)
    return ImageUtil.orientationPixelMap(orientation, pixelMap);
  }
}