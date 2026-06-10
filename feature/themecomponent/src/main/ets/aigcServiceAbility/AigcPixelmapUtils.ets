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

import fs from '@ohos.file.fs';
import { image } from '@kit.ImageKit';
import { AigcConstant, AIGCMetaData } from './AigcConstant';
import { AigcFileUtils } from './AigcFileUtils';
import { util } from '@kit.ArkTS';
import { Log } from './IdlService/Log';

// import AigcSdk from 'libaigceffect.so';

const TAG = '[AigcService]AigcPixelmapUtils';

const CHANNEL_NUMBER: number = 4;
const DEFAULT_IMAGE_WIDTH_HEIGHT: number = 1600;
const DEFAULT_IMAGE_BUFFER_SIZE: number = DEFAULT_IMAGE_WIDTH_HEIGHT * DEFAULT_IMAGE_WIDTH_HEIGHT * CHANNEL_NUMBER;
const MAX_SCALE_RATE: number = 3;

export class AigcPixelmapUtils {
  /**
   * 加载像素图
   * @param {string} path - 图片路径
   * @return {image.PixelMap | undefined} 返回图片的像素或者未定义
   */
  public static loadPixelMap(path: string): image.PixelMap | undefined {
    const imageSource: image.ImageSource = image.createImageSource(path);
    if (!imageSource) {
      return undefined;
    }
    const pixelMap: image.PixelMap =
      imageSource.createPixelMapSync({ desiredPixelFormat: image.PixelMapFormat.RGBA_8888, editable: true });
    imageSource.release();
    if (pixelMap === undefined) {
      Log.error(TAG, 'create pixelmap failed');
      return undefined;
    }
    return pixelMap;
  }

  /**
   * 将图片保存到磁盘
   * @param {string} fullPath - 图片保存的完整路径
   * @param {image.PixelMap} pixelMap - 图片的像素
   * @return {Promise<boolean>} 返回一个Promise，如果图片保存成功，则返回true，否则返回false
   */
  public static async saveImage2Disk(fullPath: string, pixelMap: image.PixelMap): Promise<boolean> {
    let file: Nullable<fs.File>;
    try {
      const imagePacker = image.createImagePacker();
      const imageBuffer = await imagePacker.packing(pixelMap, {
        format: 'image/jpeg',
        quality: 100,
      });
      imagePacker.release();

      const mode = fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE;
      file = await fs.open(fullPath, mode);

      await fs.truncate(file.fd);
      await fs.write(file.fd, imageBuffer);

      Log.info(TAG, `Save image success`);
      return true;
    } catch (error) {
      Log.error(TAG, `Save image failed: code is ${error?.code}, msg is ${error?.message}`);
      return false;
    } finally {
      if (file !== undefined) {
        try {
          await fs.close(file);
        } catch (e) {
          Log.error(TAG, 'Failed to close file');
        }
      }
    }
  }

  /**
   * 复制一份pixelMap
   * @param oriImage pixelMap源文件
   * @return 返回一个新的PixelMap对象，如果出现错误则返回undefined
   */
  public static async clonePixelMap(oriImage: image.PixelMap): Promise<image.PixelMap | undefined> {
    if (!oriImage) {
      Log.error(TAG, 'Invalid input for clonePixelMap: oriImage cannot be undefined or null');
      return undefined;
    }
    try {
      let imageInfo: image.ImageInfo = await oriImage.getImageInfo();
      let pixelBytesNumber: number = oriImage.getPixelBytesNumber();
      if (pixelBytesNumber <= 0 || pixelBytesNumber > DEFAULT_IMAGE_BUFFER_SIZE) {
        Log.error(TAG, `Invalid input for clonePixelMap: pixel bytes is ${pixelBytesNumber}`);
        return;
      }
      const readBuffer: ArrayBuffer = new ArrayBuffer(pixelBytesNumber);
      await oriImage.readPixelsToBuffer(readBuffer);
      let opts: image.InitializationOptions = {
        editable: true,
        srcPixelFormat: image.PixelMapFormat.RGBA_8888,
        pixelFormat: image.PixelMapFormat.RGBA_8888,
        size: {
          height: imageInfo.size.height,
          width: imageInfo.size.width
        }
      };
      let clonePixmap: image.PixelMap = await image.createPixelMap(readBuffer, opts);
      return clonePixmap;
    } catch (error) {
      Log.error(TAG, `Clone pixelmap failed: code is ${error?.code}, msg is ${error?.message}`);
      return undefined;
    }
  }

  /**
   * @param map
   * @param name 图片名称会被截断，取index: 0 ~ 30的子字符串
   */
  public static addName(map: Nullable<image.PixelMap>, name: string): void {
    if (!map) {
      return;
    }
    try {
      map.setMemoryNameSync(name.substring(0, Math.min(31, name.length)));
    } catch (e) {
      Log.warn(TAG, `set memoryNameSync to ${name} failed`);
    }
  }

  // 比例缩放图片并按原尺寸中心裁切输入图
  public static scaleAndCenterCropImage(inputPixmap: image.PixelMap, scaleRate: number): boolean {
    if (scaleRate <= 1 || scaleRate > MAX_SCALE_RATE) {
      return false;
    }
    try {
      const imageInfo: image.ImageInfo = inputPixmap.getImageInfoSync();
      const srcWidth: number = imageInfo.size.width;
      const srcHeight: number = imageInfo.size.height;
      inputPixmap.scaleSync(scaleRate, scaleRate);
      inputPixmap.cropSync({
        size: { width: srcWidth, height: srcHeight },
        x: srcWidth * (scaleRate - 1) / 2,
        y: srcHeight * (scaleRate - 1) / 2
      });
      return true;
    } catch (e) {
      Log.error(TAG, `scaleAndCenterCropImage fail, code: ${e?.code} msg: ${e?.message}`);
      return false;
    }
  }

  /**
   * 添加水印到图片中
   * @param imagePixelMap - 需要添加水印的图片像素图
   * @param xOffset - 水印距离底部的距离(vp)
   * @param yOffset - 水印距离右侧的距离(vp)
   * @returns Promise<image.PixelMap> - 处理后的图片像素图
   */
  public static async addWaterMark(imagePixelMap: image.PixelMap, xOffset: number,
    yOffset: number): Promise<image.PixelMap> {
    const imageInfo: Size = (await imagePixelMap.getImageInfo()).size;
    const imageHeight: number = imageInfo.height;
    const imageWidth: number = imageInfo.width;
    let offscreenContext: OffscreenCanvasRenderingContext2D =
      new OffscreenCanvasRenderingContext2D(imageWidth, imageHeight);
    offscreenContext.drawImage(imagePixelMap, 0, 0, px2vp(imageWidth), px2vp(imageHeight));
    imagePixelMap.release();
    offscreenContext.font = AigcConstant.WATER_MARK_FONT;
    offscreenContext.textAlign = 'center';
    // const waterMark: string = getContext().resourceManager.getStringSync($r('app.string.aigc_generation_prompt'));
    const waterMark: string = getContext().resourceManager.getStringSync($r('app.string.icon_edit_not_support_small_step'));
    offscreenContext.fillStyle = AigcConstant.WATER_MARK_FILL_STYLE;
    offscreenContext.fillText(waterMark, px2vp(imageWidth)- xOffset, px2vp(imageHeight) - yOffset);
    return offscreenContext.getPixelMap(0, 0, px2vp(imageWidth), px2vp(imageHeight));
  }

  /**
   * 添加AI隐式标识到图片中
   * @param file - 需要添加的图片路径
   * @returns Promise<void>
   */
  public static async addAIGCExif(file: string): Promise<void> {
    let fd: number = -1;
    let imageSource: image.ImageSource | undefined = undefined;
    try {
      fd = fs.openSync(file, fs.OpenMode.READ_WRITE).fd;
      imageSource = image.createImageSource(fd);
      let aigcMetadata: AIGCMetaData = new AIGCMetaData();
      let imageID: string = AigcConstant.PRODUCE_ID_HEAD + Date.now() + util.generateRandomUUID();
      let aigcMetadataContent: Record<string, string> = {
        'Label': '1',
        'ContentProducer': AigcConstant.CONTENT_PRODUCER,
        'ProduceID': imageID,
        'ReservedCode1': '',
        'ContentPropagator': AigcConstant.CONTENT_PRODUCER,
        'PropagateID': imageID,
        'ReservedCode2': ''
      }
      aigcMetadata.AIGC = aigcMetadataContent;
      await imageSource.modifyImageProperty(image.PropertyKey.USER_COMMENT, JSON.stringify(aigcMetadata));
    } catch (err) {
      Log.error(TAG, `addAIGCExif fail, code: ${err?.code} msg: ${err?.message}`);
    } finally {
      imageSource?.release();
      if (fd !== -1) {
        try {
          fs.closeSync(fd);
        } catch (err) {
          Log.error(TAG, `addAIGCExif close fd fail, code: ${err?.code} msg: ${err?.message}`);
        }
      }
    }
  }

  /**
   * 将生成的视频资源第一帧做压暗并保存
   * @param themeRscPath - 主题资源文件夹路径
   * @param timeStamp - 生成时的时间戳，用于筛选生成结果文件夹
   * @returns Promise<boolean> 是否全部压暗并保存成功
   */
  public static async dimForVideo(themeRscPath: string, timeStamp: string): Promise<boolean> {
    const rscDirList: string[] = AigcFileUtils.listDirSync(themeRscPath);
    if (rscDirList.length === 0) {
      Log.error(TAG, `Dim first frame failed. the resource directory is empty.`);
      return false;
    }

    let isDimFinish: boolean = true;
    for (const rscPath of rscDirList) {
      let dirName = rscPath.substring(rscPath.lastIndexOf('/') + 1);
      if (!dirName.startsWith(timeStamp)) {
        isDimFinish = false;
        continue;
      }
      const src: image.PixelMap | undefined =  AigcPixelmapUtils.loadPixelMap(`${rscPath}/first_frame.jpg`);
      if (src === undefined) {
        Log.error(TAG, `Dim first frame failed. load src pixelmap failed.`);
        isDimFinish = false;
        continue;
      }
      // let dimResult: boolean = AigcPixelmapUtils.scaleAndCenterCropImage(src, 1.1) &&
      // AigcSdk.dimImage(src, src, AigcConstant.AOD_DIM_FACTOR) &&
      //   await AigcPixelmapUtils.saveImage2Disk(`${rscPath}/aod.jpg`, src);
      src.release();
      // isDimFinish = isDimFinish && dimResult;
    }
    Log.info(TAG, `dim for video theme res: ${isDimFinish}, timeStamp: ${timeStamp}`);
    return isDimFinish;
  }
}