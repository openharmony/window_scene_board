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
import lazy { FileUtil } from './FileUtil';
import { Log } from './Log';

@Concurrent
export async function getPixelMap(path: string, croppedDecodingOptions?: image.DecodingOptions | undefined):
  Promise<image.PixelMap | null> {
  const imageSource: image.ImageSource = image.createImageSource(path);
  if (!imageSource) {
    Log.warn('PixelMapTransformation', `create ImageSource failed`);
    return null;
  }

  const pixelMap: image.PixelMap = await imageSource.createPixelMap(croppedDecodingOptions);
  imageSource.release();
  return pixelMap;
}

@Concurrent
export async function transformationAstc(pixelMap: image.PixelMap,
  targetDirectory: string, targetPath: string, compress: number = 4): Promise<boolean> {
  const TAG: string = 'transformationAstc';
  let imagePacker: image.ImagePacker | null = image.createImagePacker();
  if (imagePacker === null) {
    Log.warn(TAG, 'imagePacker is null');
    return false;
  }

  let packOptions: image.PackingOption;
  try {
    let imageInfo: image.ImageInfo = pixelMap.getImageInfoSync();
    if (imageInfo.pixelFormat === image.PixelMapFormat.RGBA_1010102) {
      // BT2020色域图片格式转astc参数, BT2020色域接口仅支持压缩系数为4，所以BT2020色域图片不设置压缩系数
      // api要求，image/hdr_astc_4x4格式，quality可选参数为85
      packOptions = {
        format: 'image/hdr_astc_4x4',
        quality: 85,
      };
    } else {
      // 一般图片转换为astc格式图片参数，compress：压缩系数，20：目标图像的质量（取值范围0-100）
      packOptions = {
        format: `image/astc/${compress}*${compress}`,
        quality: 20,
      };
    }
    Log.info(TAG, `packing format is ${packOptions.format}`);
  } catch (e) {
    Log.error(TAG, `getImageInfoFailed: code = ${e.code}, message = ${e.message}`);
    return false;
  }

  let targetFile: fs.File | undefined = undefined;
  const mode: number = fs.OpenMode.WRITE_ONLY | fs.OpenMode.CREATE | fs.OpenMode.TRUNC;
  let imageBuffer: ArrayBuffer | undefined = undefined;
  let bytesWritten: number = 0;

  try {
    imageBuffer = await imagePacker.packing(pixelMap, packOptions);
    if (!fs.accessSync(targetDirectory)) {
      fs.mkdirSync(targetDirectory, true);
      Log.info(TAG, 'targetDirectory is deleted and re-created before flushing');
    }
    targetFile = await fs.open(targetPath, mode);
    Log.info(TAG, 'write path');
    bytesWritten = await fs.write(targetFile.fd, imageBuffer);
  } catch (e) {
    Log.error(TAG, `failed pack the image: ${e.message}`);
    return false;
  } finally {
    await imagePacker.release();
    FileUtil.safeFsCloseSync(targetFile);
  }

  return bytesWritten > 0;
}