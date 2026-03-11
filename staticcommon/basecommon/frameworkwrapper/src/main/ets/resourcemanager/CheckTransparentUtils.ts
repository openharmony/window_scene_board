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
import image from '@ohos.multimedia.image';
import { LogDomain, Logger } from '@ohos/basicutils';

const TAG: string = 'CheckTransparentUtils';
const LOG: Logger = Logger.getLogHelper(LogDomain.SCB);

// alpha透明阈值：超过阈值(255*25%)，则判定为非透明；未超过阈值，则判定为透明
const ALPHA_TRANSPARENT_THRESHOLD: number = 60;
// 不透明像素点比例阈值：超过阈值，则判定图标为非透明；不超过阈值，则判定图标为透明
const POINTS_RATE_TRANSPARENT_THRESHOLD: number = 0.2;

export class CheckTransparentUtils {
  /**
   * 检测图片是否透明
   *
   * @param pixelMap 需要检测的pixelMap
   * @param tag 维测TAG
   * @returns
   */
  public static isTransparentImage(pixelMap: image.PixelMap, tag: string): boolean {
    LOG.showInfo(TAG, `${tag}, transparent check start`);
    if (!pixelMap) {
      LOG.showWarn(TAG, `${tag}, printImageSize pixMap error`);
      return false;
    }
    let imageInfo = pixelMap.getImageInfoSync();
    let isAlpha = CheckTransparentUtils.isSupportAlphaImage(imageInfo);
    if (!isAlpha) {
      LOG.showWarn(TAG, `${tag}, not support alpha`);
      return false;
    }

    const width = imageInfo.size.width;
    const height = imageInfo.size.height;
    const rule: PointCheckRule = CheckTransparentUtils.getPointCheckRule(imageInfo.size.width, imageInfo.size.height);
    const isTransparent: boolean = CheckTransparentUtils.checkTransparent(pixelMap, width, height, rule);
    if (isTransparent) {
      LOG.showWarn(TAG,
        `${tag}, isTransparent: ${isTransparent}, point:(${rule.pointX}, ${rule.pointY}), size: ${width}*${height}`);
    }
    LOG.showInfo(TAG, `${tag}, transparent check end, isTransparent: ${isTransparent}`);
    return isTransparent;
  }

  private static checkTransparent(pixelMap: image.PixelMap, imageWidth: number, imageHeight: number,
    rule: PointCheckRule): boolean {
    const notTransparentPointThreshold: number = rule.pointCheckCount * POINTS_RATE_TRANSPARENT_THRESHOLD;
    let notTransparentPointCount: number = 0;
    // 检测横线
    for (let x: number = 0; x < imageWidth; ) {
      if (!CheckTransparentUtils.isTransparentPoint(pixelMap, x, rule.pointY)) {
        notTransparentPointCount++;
        if (notTransparentPointCount >= notTransparentPointThreshold) {
          return false;
        }
      }
      x += rule.xGap;
    }
    // 检测竖线
    for (let y: number = 0; y < imageHeight; ) {
      if (!CheckTransparentUtils.isTransparentPoint(pixelMap, rule.pointX, y)) {
        notTransparentPointCount++;
        if (notTransparentPointCount >= notTransparentPointThreshold) {
          return false;
        }
      }
      y += rule.yGap;
    }
    return true;
  }

  private static getPointCheckRule(imageWidth: number, imageHeight: number): PointCheckRule {
    const rule: PointCheckRule = new PointCheckRule();
    rule.xGap = CheckTransparentUtils.getCheckPointStep(imageWidth);
    rule.yGap = CheckTransparentUtils.getCheckPointStep(imageHeight);
    rule.pointX = CheckTransparentUtils.getCheckPointLocation(imageWidth);
    rule.pointY = CheckTransparentUtils.getCheckPointLocation(imageHeight);
    rule.pointCheckCount = Math.floor(imageWidth / rule.xGap) + Math.floor(imageHeight / rule.yGap);
    return rule;
  }

  private static getCheckPointStep(length: number): number {
    // >=1024：一条线每5个点检测一次，>=512：一条线每3个点检测一次，< 512：一条线每2个点检测一次
    const gap = Math.floor(length / 256);
    return gap <= 0 ? 2 : gap + 1;
  }

  private static getCheckPointLocation(length: number): number {
    // 随机取中间部分的点作为基准点，取对应横线和竖线检测
    return Math.floor(Math.random() * length / 2 + length / 4);
  }

  private static isTransparentPoint(pixelMap: image.PixelMap, pointX: number, pointY: number): boolean {
    const pointArea: image.PositionArea = {
      pixels: new ArrayBuffer(4), // 像素buffer大小为4的倍数,对应四通道,取值为:height * width * 4, 单个像素即为4
      offset: 0,
      stride: 4,
      region: { size: { height: 1, width: 1 }, x: pointX, y: pointY }
    };
    pixelMap.readPixelsSync(pointArea);
    const pointPixel = new Uint8Array(pointArea.pixels);
    // BGRA四通道(当前图片编码格式), 第4通道alpha为不透明度
    return pointPixel[3] <= ALPHA_TRANSPARENT_THRESHOLD;
  }

  private static isSupportAlphaImage(imageInfo: image.ImageInfo): boolean {
    let pixelFormat = imageInfo.pixelFormat;
    return pixelFormat === image.PixelMapFormat.RGBA_8888 ||
      pixelFormat === image.PixelMapFormat.BGRA_8888 ||
      pixelFormat === image.PixelMapFormat.RGBA_F16;
  }
}

class PointCheckRule {
  public pointX: number = 0;
  public pointY: number = 0;
  public xGap: number = 0;
  public yGap: number = 0;
  public pointCheckCount: number = 0;
}