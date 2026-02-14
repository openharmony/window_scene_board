/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
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

/**
 * 对象拷贝工具类
 */
export class ObjectCopyUtil {
  /**
   * 对象深拷贝
   *
   * @param tSource
   * @returns
   */
  public static deepClone<T>(tSource: T, tTarget?: Record<string, any> | T): T {
    if (Array.isArray(tSource)) {
      tTarget = tTarget || [];
    } else {
      tTarget = tTarget || {};
    }
    for (const key in tSource) {
      if (Object.prototype.hasOwnProperty.call(tSource, key)) {
        if (typeof tSource[key] === 'object' && typeof tSource[key] !== null) {
          tTarget[key] = Array.isArray(tSource[key]) ? [] : {};
          this.deepClone(tSource[key], tTarget[key]);
        } else {
          tTarget[key] = tSource[key];
        }
      }
    }
    return tTarget as T;
  }

  /**
   * 对象浅拷贝
   *
   * @param tSource
   * @returns
   */
  public static simpleClone<T>(tSource: T, tTarget?: Record<string, any> | T): T {
    if (Array.isArray(tSource)) {
      tTarget = tTarget || [];
    } else {
      tTarget = tTarget || {};
    }
    for (const key in tSource) {
      if (Object.prototype.hasOwnProperty.call(tSource, key)) {
        tTarget[key] = tSource[key];
      }
    }
    return tTarget as T;
  }

  /**
   * PixelMap对象深拷贝
   * API16以后推荐直接使用 image.PixelMap.clone()接口
   *
   * @param pixelMap
   * @throws 参数不合法抛出异常
   * @returns
   */
  public static deepCopyPixelMap(pixelMap: image.PixelMap): image.PixelMap {
    let imageInfo: image.ImageInfo = pixelMap.getImageInfoSync();
    let buffer: ArrayBuffer = new ArrayBuffer(pixelMap.getPixelBytesNumber());
    pixelMap.readPixelsToBufferSync(buffer);
    let options: image.InitializationOptions = {
      srcPixelFormat: imageInfo.pixelFormat,
      pixelFormat: imageInfo.pixelFormat,
      size: imageInfo.size,
      alphaType: imageInfo.alphaType,
    };

    let newPixelMap = image.createPixelMapSync(options);
    newPixelMap.writeBufferToPixelsSync(buffer);
    return newPixelMap;
  }
}