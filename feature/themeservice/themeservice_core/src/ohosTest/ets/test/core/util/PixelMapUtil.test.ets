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
import { beforeAll, describe, expect, it } from '@ohos/hypium';
import { FileUtil, TsLog } from '@ohos/themeservicebase/Index';
import PixelMapUtil, { ImageFileType, IPixelMapReadingOptions } from '../../../../../main/ets/util/PixelMapUtil';
import { TSPathUtils } from '../../../../../main/ets/util/TSPathUtils';
import { image } from '@kit.ImageKit';

const TAG: string = 'PixelMapUtil.test';

const IMAGE_SUFFIX_JPG: string = 'jpg';
const IMAGE_SUFFIX_PNG: string = 'png';
const FILE_SUFFIX_ASTC: string = '.astc';

export default function PixelMapUtilTest() {
  describe('PixelMapUtilTest', () => {
    let wallpaperPresetList: string[] = [];
    let validWallpaper: string = '';
    let invalidWallpaper: string = '';
    beforeAll(async () => {
      const presetPathList: Array<string> = await TSPathUtils.getTsPresetRootPath('wallpaper');
      for (const defThemePath of presetPathList) {
        wallpaperPresetList = await FileUtil.listFiles(defThemePath, true);
        TsLog.info(TAG, `wallpaperPresetList.length: ${wallpaperPresetList.length}`);
        validWallpaper = getValidWallpaper(wallpaperPresetList);
        invalidWallpaper = getInvalidWallpaper(wallpaperPresetList);
      }
    });

    // 验证可以将png/jpg格式的图片处理成pixelMap
    it('creatScalePixelMap_test_001', 0, async () => {
      const desiredWidth: number = 512;
      const option: IPixelMapReadingOptions = {maximumWidth: desiredWidth};
      TsLog.info(TAG, `wallpaperPresetList.length: ${wallpaperPresetList.length}, wallpaper: ${validWallpaper}`);
      const pixelMap: Nullable<image.PixelMap> = await PixelMapUtil.creatScalePixelMap(validWallpaper, option);
      expect(pixelMap).not().assertUndefined();
      const width: Nullable<number> = pixelMap?.getImageInfoSync().size.width;
      TsLog.info(TAG, `creatScalePixelMap_test_001 width: ${width}`);
      expect(width).assertEqual(desiredWidth);
      await pixelMap?.release();
    });

    // 验证非png/jpg格式图片不会处理，返回undefined，不会出现异常
    it('creatScalePixelMap_test_002', 0, async () => {
      const desiredWidth: number = 512;
      const option: IPixelMapReadingOptions = {maximumWidth: desiredWidth};
      TsLog.info(TAG, `wallpaperPresetList.length: ${wallpaperPresetList.length}, wallpaper: ${invalidWallpaper}`);
      const pixelMap: Nullable<image.PixelMap> = await PixelMapUtil.creatScalePixelMap(invalidWallpaper, option);
      expect(pixelMap).assertUndefined();
    });

    it('writePixelMapToPath_test_001', 0, async () => {
      const desiredWidth: number = 512;
      const option: IPixelMapReadingOptions = {maximumWidth: desiredWidth};
      TsLog.info(TAG, `wallpaperPresetList.length: ${wallpaperPresetList.length}, wallpaper: ${validWallpaper}`);
      const pixelMap: Nullable<image.PixelMap> = await PixelMapUtil.creatScalePixelMap(validWallpaper, option);
      expect(pixelMap).not().assertUndefined();
      const originImageName: string = FileUtil.getFileName(validWallpaper).split('.')[0];
      // 优化后的缓存文件保存路径
      const optRootPath: string = `${TSPathUtils.getTsPresetOptimizePath()}/test`;
      const cachePath: string = `${optRootPath}/${originImageName}${FILE_SUFFIX_ASTC}`;
      const result: boolean = await PixelMapUtil.writePixelMapToPath(pixelMap, cachePath, {
        fileType: ImageFileType.ASTC,
        isAtomically: true, // 原子化写入
      });
      TsLog.info(TAG, `writePixelMapToPath_test_001 result: ${result}`);
      expect(result).assertTrue();
      await pixelMap?.release();
      FileUtil.rmdirAsync(optRootPath);
    });

    it("getBlurPixelMap_test_001", 0, async () => {
      let blurPixelMap: Nullable<image.PixelMap> = await PixelMapUtil.getBlurPixelMap(undefined, 0);
      expect(blurPixelMap).assertUndefined();
    })

    it("getBlurPixelMap_test_002", 0, async () => {
      const desiredWidth: number = 512;
      const option: IPixelMapReadingOptions = {maximumWidth: desiredWidth};
      TsLog.info(TAG, `wallpaperPresetList.length: ${wallpaperPresetList.length}, wallpaper: ${validWallpaper}`);
      const pixelMap: Nullable<image.PixelMap> = await PixelMapUtil.creatScalePixelMap(validWallpaper, option);
      let blurPixelMap: Nullable<image.PixelMap> = await PixelMapUtil.getBlurPixelMap(pixelMap, 0);
      expect(blurPixelMap).not().assertUndefined();
      await pixelMap?.release();
    })

    it("getImageSourceByPath_test_001", 0, async () => {
      let imageSource: Nullable<image.ImageSource> = await PixelMapUtil.getImageSourceByPath('invalid_path');
      expect(imageSource).assertUndefined();
      await PixelMapUtil.release(imageSource);
      expect(imageSource).assertUndefined();
    })

    it("creatDefaultPixelMap_test_001", 0, async () => {
      let pixelMap: image.PixelMap | undefined = await PixelMapUtil.creatDefaultPixelMap(validWallpaper);
      expect(pixelMap).not().assertUndefined();
      await pixelMap?.release();
    })
  })
}

function getValidWallpaper(wallpaperPresetList: string[]): string {
  let validWallpaper: string = '';
  for (const wallpaper of wallpaperPresetList) {
    const suffix: string = FileUtil.getFileSuffix(wallpaper);
    if (suffix === IMAGE_SUFFIX_PNG || suffix === IMAGE_SUFFIX_JPG) {
      validWallpaper = wallpaper;
      break;
    }
  }
  return validWallpaper;
}

function getInvalidWallpaper(wallpaperPresetList: string[]): string {
  let invalidWallpaper: string = '';
  for (const wallpaper of wallpaperPresetList) {
    const suffix: string = FileUtil.getFileSuffix(wallpaper);
    if (suffix !== IMAGE_SUFFIX_PNG && suffix !== IMAGE_SUFFIX_JPG) {
      invalidWallpaper = wallpaper;
      break;
    }
  }
  return invalidWallpaper;
}