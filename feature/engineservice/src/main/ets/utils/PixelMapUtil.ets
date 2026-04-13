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
import lazy fs from '@ohos.file.fs';
import { getPixelMap } from './PixelMapTransformationUtil';
import { transformationAstc } from './PixelMapTransformationUtil';
import { Log } from './Log';

const TAG: string = 'PixelMapUtil';

/**
 * 转换图片为astc格式并落盘
 *
 * @param originPath 转换前图片路径
 * @param targetPath 转换后落盘图片路径
 * @returns true: 转换成功 false: 转换失败
 */
@Concurrent
export async function pixelMapTransformation(originPath: string, targetDirectory: string, targetPath: string,
  croppedDecodingOptions: image.DecodingOptions | undefined): Promise<image.PixelMap | null> {
  const TAG: string = 'PixelUtil';
  const TEMP_PATH: string = 'Temp.';
  if (originPath === '' || targetPath === '') {
    Log.warn(TAG, 'originPath or targetPath is null');
    return null;
  }

  let pixelMap: image.PixelMap | null = await getPixelMap(originPath, croppedDecodingOptions);
  if (!pixelMap) {
    Log.warn(TAG, 'pixelMap is undefined');
    return null;
  }

  // 将astc文件名重命名，astc落盘完成后在重命名回原来名字。防止快速旋转或者折展时astc没有落盘完成，astc路径可以读到，导致显示不正确问题
  let paths: string[] = targetPath.split('.');
  let path: string = paths.length > 1 ? `${paths[0]}${TEMP_PATH}${paths[1]}` : targetPath;
  let isTransformationSucc: boolean = await transformationAstc(pixelMap, targetDirectory, path);
  try {
    if (path !== targetPath) {
      fs.renameSync(path, targetPath);
    }
  } catch (e) {
    Log.error(TAG, `failed renameSync: ${e.message}`);
  }
  pixelMap.release();
  if (!isTransformationSucc) {
    Log.warn(TAG, 'transform picture to astc fail');
    return null;
  }

  const pixelMapAstc: image.PixelMap | null = await getPixelMap(targetPath);
  return pixelMapAstc;
}

/**
 * 图形PixelMap使用工具
 *
 * @since 2024-03-08
 */
export class PixelMapUtil {
  /**
   * 根据宽高值创建对应的PixelMap实例
   *
   * @param height pixelMap的高度
   * @param width pixelMap的宽度
   * @returns 对应大小的空PixelMap实例
   */
  public static async createPixelMapAsync(height: number, width: number): Promise<PixelMap> {
    // 需要创建的像素buffer大小，取值为：height * width *4
    const color: ArrayBuffer = new ArrayBuffer(4 * height * width);
    let opts: image.InitializationOptions = {
      editable: true,
      pixelFormat: image.PixelMapFormat.RGBA_8888,
      size: { height: height, width: width }
    };
    const pixel: PixelMap = await image.createPixelMap(color, opts);
    return pixel;
  }

  /**
   * 根据文件路径创建pixelMap
   *
   * @param url 文件路径
   * @returns pixelMap对象
   */
  public static async getPixelMap(url: string): Promise<image.PixelMap | null> {
    let imageSource: image.ImageSource | null = null;
    let pixelMap: image.PixelMap | null = null;
    try {
      imageSource = image.createImageSource(url);
      if (!imageSource) {
        Log.error(TAG, `create imageSource failed`);
        return null;
      }
      pixelMap = await imageSource.createPixelMap();
    } catch (error) {
      Log.error(TAG, `create pixelMap failed, code: ${error?.code}`);
    } finally {
      imageSource?.release();
    }
    return pixelMap;
  }

  public static async getPixelMapList(url: string): Promise<GifPixelMap | null> {
    let imageSource: image.ImageSource | null = null;
    let pixelMapList: image.PixelMap[] | undefined = undefined;
    let delayTimeList: number[] | undefined = undefined;
    try {
      imageSource = image.createImageSource(url);
      if (!imageSource) {
        Log.error(TAG, `create imageSource failed`);
        return null;
      }
      pixelMapList = await imageSource.createPixelMapList();
      delayTimeList = await imageSource.getDelayTimeList();
    } catch (error) {
      Log.error(TAG, `create pixelMap failed, code: ${error?.code}`);
    } finally {
      imageSource?.release();
    }
    return {
      pixelMapList: pixelMapList,
      delayTimeList: delayTimeList,
    };
  }
}

export interface GifPixelMap {
  pixelMapList: image.PixelMap[] | undefined;
  delayTimeList: number[] | undefined;
}