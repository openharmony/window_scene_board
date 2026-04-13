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
import { image } from '@kit.ImageKit';
import { FileUtil, TsLog } from '@ohos/themeservicebase';
import PixelMapUtil, { ImageFileType } from '../../../util/PixelMapUtil';
import { WallpaperInfo } from '../activate/WallpaperCaller';
const TAG: string = 'WallpaperBlurHandler';
export class WallpaperBlurHandler {
  public static async handleWallpaper(wallpaperInfo: WallpaperInfo, wallpaperTypeStr: string,
    rootPath: string): Promise<Nullable<WallpaperInfo>> {
    const imagePath = wallpaperInfo.source;
    if (imagePath == undefined) {
      return wallpaperInfo;
    }
    if (wallpaperTypeStr == undefined) {
      return wallpaperInfo;
    }
    const fileName = imagePath.substring(imagePath.indexOf(wallpaperTypeStr));
    const blurPath = `${rootPath}/${fileName}`;
    if (FileUtil.isFileExists(blurPath)) {
      await FileUtil.deleteAsync(blurPath);
    }
    let pixelMap: Nullable<image.PixelMap>;
    let blurPixelMap: Nullable<image.PixelMap>;
    try {
      pixelMap = await PixelMapUtil.creatDefaultPixelMap(imagePath);
      if (!pixelMap) {
        TsLog.error(TAG, `handleWallpaper pixelMap is undefine`);
        return wallpaperInfo;
      }
      const radius: number = 100;
      blurPixelMap = await PixelMapUtil.getBlurPixelMap(pixelMap, radius);
      if (!blurPixelMap) {
        TsLog.error(TAG, `handleWallpaper blurPixelMap is undefine`);
        return wallpaperInfo;
      }
      await PixelMapUtil.writePixelMapToPath(blurPixelMap, blurPath, {
        fileType: ImageFileType.JPEG,
        isAtomically: true // 原子化写入
      });
    } catch (err) {
      TsLog.error(TAG, `wallpaper blur writePixelMapToPath failed: `, err);
    } finally {
      await PixelMapUtil.releasePixelMap(pixelMap);
      await PixelMapUtil.releasePixelMap(blurPixelMap);
    }
    wallpaperInfo.source = blurPath;
    return wallpaperInfo;
  }
}