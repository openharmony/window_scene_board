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

import { CommonUtils, LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { SCBConstants } from '@ohos/commonconstants';
import configPolicy from '@ohos.configPolicy';
import fs from '@ohos.file.fs';
import { image } from '@kit.ImageKit';

type PixelMap = image.PixelMap;

const TAG: string = 'TransparentBorderIconCropper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const DEFAULT_ICON_EDGE = 4;
const VALID_TRANSPARENCY = 40;
const TRANSPARENT_BORDER_ICON_APP_CFG = 'etc/transparent_border_icon_app_list.json';

export class TransparentBorderIconCropper {
  private transparentBorderIconAppSet: Set<string> = new Set<string>();

  /**
   * 加载透明边框图标的应用列表
   */
  public loadTransparentBorderIconAppCfg(): void {
    try {
      let filePath: string = configPolicy.getOneCfgFileSync(TRANSPARENT_BORDER_ICON_APP_CFG);
      let configStr: string = fs.readTextSync(filePath);
      if (configStr) {
        let jsonArray: string[] = JSON.parse(configStr);
        jsonArray.forEach(bundleName => this.transparentBorderIconAppSet.add(bundleName));
      } else {
        log.showWarn(`loadTransparentBorderIconAppCfg configStr is null`);
      }
    } catch (e) {
      log.showError(`loadTransparentBorderIconAppCfg error e:${e?.message}`);
    }
  }

  /**
   * 图标外圈是否有透明边框。在名单内的应用因图标不规范，需要裁剪外圈透明像素
   * @param bundleName 图标所属应用包名
   * @returns true图标外圈有透明像素
   */
  public isTransparentBorderIcon(bundleName: string): boolean {
    if (CommonUtils.isEmpty(bundleName)) {
      return false;
    }
    let bundleNameWithoutTemplate = bundleName;
    if (bundleName.endsWith(SCBConstants.BUNDLENAME_APPEND_TEMPLATE)) {
      bundleNameWithoutTemplate = bundleName.replace(SCBConstants.BUNDLENAME_APPEND_TEMPLATE, '');
    }
    return this.transparentBorderIconAppSet.has(bundleNameWithoutTemplate);
  }

  /**
   * 按非透明边界裁剪图标，去除图标外圈的透明像素
   * @param pixelMap 图标
   * @param appName 图标所属应用包名
   */
  public async cropByValidRegion(pixelMap: PixelMap, appName: string): Promise<void> {
    if (!pixelMap) {
      return;
    }
    try {
      let validInfoRegion = await this.getIconInfoRegion(pixelMap, appName);
      if (validInfoRegion) {
        pixelMap.cropSync(validInfoRegion);
      }
    } catch (e) {
      log.showError(`cropByValidRegion error e:${e?.message}`);
    }
  }

  /**
   * 获取图片非透明区域的边界信息
   * @param image 图标位图
   * @param bundleName 应用包名
   * @returns 图标非透明区域边界信息
   */
  private async getIconInfoRegion(image: PixelMap, bundleName: string):
    Promise<image.Region | undefined> {
    if (!image) {
      return undefined;
    }
    let size = image.getImageInfoSync().size;
    let width = size.width;
    let height = size.height;
    // 通过位图的大小创建像素点数组
    const buffer = new ArrayBuffer(image.getPixelBytesNumber());
    await image.readPixelsToBuffer(buffer);
    let pixels = new Uint32Array(buffer);
    let left = this.getValidLeft(pixels, width, height);
    let top = this.getValidTop(pixels, width, height);
    let right = this.getValidRight(pixels, width, height);
    let bottom = this.getValidBottom(pixels, width, height);
    log.showInfo(`border[${left}, ${top}, ${width - right}, ${height - bottom}], ${bundleName}`);

    if (left >= right || top >= bottom) {
      return undefined; // 完全透明
    }

    let border = Math.min(left, width - right, top, height - bottom) + DEFAULT_ICON_EDGE;
    let region: image.Region = {
      size: {
        width: width - border * 2,
        height: height - border * 2
      },
      x: border,
      y: border
    };
    return region;
  }

  private getValidTop(pixels: Uint32Array, width: number, height: number): number {
    let midWidth = width % 2 === 0 ? (width / 2 - 1) : (width / 2);
    for (let i = 0; i < height; i++) {
      let y = i * width;
      for (let j = midWidth; j >= 0; j--) {
        if (this.checkTransparency(pixels[y + j]) ||
        this.checkTransparency(pixels[y + (width - 1 - j)])) {
          return i;
        }
      }
    }
    return height;
  }

  private getValidBottom(pixels: Uint32Array, width: number, height: number): number {
    let midWidth = width % 2 === 0 ? (width / 2 - 1) : (width / 2);
    for (let i = height - 1; i >= 0; i--) {
      let y = i * width;
      for (let j = midWidth; j >= 0; j--) {
        if (this.checkTransparency(pixels[y + j]) ||
        this.checkTransparency(pixels[y + (width - 1 - j)])) {
          return i;
        }
      }
    }
    return 0;
  }

  private getValidLeft(pixels: Uint32Array, width: number, height: number): number {
    let midHeight = height % 2 === 0 ? (height / 2 - 1) : (height / 2);
    for (let i = 0; i < width; i++) {
      for (let j = midHeight; j >= 0; j--) {
        if (this.checkTransparency(pixels[j * width + i]) ||
        this.checkTransparency(pixels[(height - 1 - j) * width + i])) {
          return i;
        }
      }
    }
    return width;
  }

  private getValidRight(pixels: Uint32Array, width: number, height: number): number {
    let midHeight = height % 2 === 0 ? (height / 2 - 1) : (height / 2);
    for (let i = width - 1; i >= 0; i--) {
      for (let j = midHeight; j >= 0; j--) {
        if (this.checkTransparency(pixels[j * width + i]) ||
        this.checkTransparency(pixels[(height - 1 - j) * width + i])) {
          return i;
        }
      }
    }
    return 0;
  }

  private checkTransparency(argb: number): boolean {
    return (argb >>> 24) >= VALID_TRANSPARENCY;
  }
}

export let iconBorderCropper: TransparentBorderIconCropper =
  SingletonHelper.getInstance(TransparentBorderIconCropper, TAG);