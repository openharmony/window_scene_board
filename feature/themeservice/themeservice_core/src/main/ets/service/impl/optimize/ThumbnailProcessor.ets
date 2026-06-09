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

import image from '@ohos.multimedia.image';
import taskPool from '@ohos.taskpool';
import { FileUtil, Singleton, TsLog } from '@ohos/themeservicebase/Index';
import { ActivatedThemeUtil } from '../../../util/ActivatedThemeUtil';
import PixelMapUtil, { ImageFileType } from '../../../util/PixelMapUtil';
import TaskPoolManager from '../../../util/TaskPoolManager';
import { hash } from '@kit.CoreFileKit';

const TAG: string = 'ThumbnailProcessor';

/**
 * 缩略图获取选项
 */
export interface IThumbnailFetchOptions {
  customKey: string,
  maximumWidth: number,
  imagePath: string, // 路径必填，用于读取修改时间，以确定缩略图存储键名
}

/**
 * 缩略图压缩异步过程（从现有的 PixelMap），进行一次图像纹理编码。
 * 注：不能使用 TS，需要使用 ArkTS。
 * 将传入的 PixelMap 写入为 .atx (astc) 格式的缩略图纹理。
 * @param pixelMap 现有的 PixelMap
 * @param cachePath 缓存路径
 * @param radius 模糊半径
 * @returns
 */
@Concurrent
async function saveThumbnailByImagePath(width: number, imagePath: string, cachePath: string,
  radius: number = 0): Promise<Nullable<string>> {
  const logTag: string = 'ThumbnailProcessor';
  if (FileUtil.isFileExists(cachePath)) {
    TsLog.debug(logTag, `file: ${FileUtil.getFileName(cachePath)} is exist`);
    return;
  }
  if (taskPool.Task.isCanceled()) {
    TsLog.error(logTag, 'task is canceled');
    return;
  }
  // 获取原图解码缩小后的pixelMap
  let pixelMap: Nullable<image.PixelMap>;
  try {
    pixelMap = await PixelMapUtil.creatScalePixelMap(imagePath, {maximumWidth: width});
    if (radius > 0) {
      pixelMap = await PixelMapUtil.getBlurPixelMap(pixelMap, radius);
    }
  } catch (err) {
    TsLog.error(logTag, `save thumbnail creatScalePixelMap failed: `, err);
  }
  if (!pixelMap) {
    TsLog.error(logTag, `saveThumbnailByImagePath pixelMap is undefine `);
    return;
  }

  // pixelMap转astc图片缓存至目标路径
  try {
    await PixelMapUtil.writePixelMapToPath(pixelMap, cachePath, {
      fileType: ImageFileType.ASTC,
      isAtomically: true, // 原子化写入
    });
  } catch (err) {
    TsLog.error(logTag, `save thumbnail writePixelMapToPath failed: `, err);
  } finally {
    await PixelMapUtil.releasePixelMap(pixelMap);
  }
  // 获取原图的hash值
  let newHash: string = '';
  try {
    newHash = await hash.hash(imagePath, 'sha256');
  } catch (err) {
    TsLog.error(logTag, 'task is canceled');
  }
  return newHash;
}

/**
 * 纹理缓存管理类
 */
export default class ThumbnailProcessor {
  private static readonly INSTANCE: Singleton<ThumbnailProcessor> =
    new Singleton<ThumbnailProcessor>(() => new ThumbnailProcessor());

  public static getInstance(): ThumbnailProcessor {
    return ThumbnailProcessor.INSTANCE.get();
  }

  /**
   * 在taskPool子线程中创建pixelMap保存astc缩略图缓存
   *
   * @param width 目标宽度
   * @param imagePath 原始资源路径
   * @param cachePath 目标缓存路径
   * @param radius 模糊半径
   * @returns Promise<boolean> 缓存优化结果
   */
  async saveThumbnailInTaskPool(width: number, imagePath: string, cachePath: string,
    radius: number = 0): Promise<Nullable<string>> {
    TsLog.debug(TAG, `start saveThumbnailInTaskPool`);
    const task: taskPool.Task = new taskPool.Task(saveThumbnailByImagePath, width, imagePath, cachePath, radius);
    let result: Nullable<string>;
    try {
      result = (await TaskPoolManager.getInstance().processTask(task)) as string; // 无需 await
    } catch (e) {
      TsLog.error(TAG, 'save thumbnail taskpool.execute failed:', e);
    }
    return result;
  }
}
