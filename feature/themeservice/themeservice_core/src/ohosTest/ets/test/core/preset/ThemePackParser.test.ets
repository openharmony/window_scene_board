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

import fs from '@ohos.file.fs';
import image from '@ohos.multimedia.image';
import systemDateTime from '@ohos.systemDateTime';
import { describe, expect, it } from '@ohos/hypium';
import { TsLog } from '@ohos/themeservicebase/Index';
import { PRESET_RES_THEME } from '@ohos/themeservice_inner_api/Index';
import { TSPathUtils } from '../../../../../main/ets/util/TSPathUtils';

const TAG: string = 'ThemePackParserTest';

export default function ThemePackParserTest() {
  describe('ThemePackParserTest', async () => {

    it('test_decode_preset_images_time', 0, async () => {
      expect(await checkDecodeTimeAchieved()).assertTrue();
    })
  })
}

async function checkDecodeTimeAchieved(): Promise<boolean> {
  let underBaseTime: boolean = true;
  let presetThemePaths: string[] = [];
  const presetThemeDirList: Array<string> = await TSPathUtils.getTsPresetRootPath(PRESET_RES_THEME);
  for (const presetThemeRootPath of presetThemeDirList) {
    try {
      let presetThemes: string[] = fs.listFileSync(presetThemeRootPath);
      presetThemes.forEach((item: string) => {
        let path: string = '';
        if (item.indexOf('default') >= 0) {
          path = `${presetThemeRootPath}/${item}/lock/base/resources/unlock_wallpaper_0.jpg`;
        }
        if (fs.accessSync(path)) {
          presetThemePaths.push(path);
        }
      })
    } catch (err) {
      TsLog.error(TAG, `Get preset theme package failed.`, err);
    }
  }
  const decodingOptions: image.DecodingOptions = {
    editable: false,
    desiredPixelFormat: image.PixelMapFormat.RGBA_8888,
  }
  presetThemePaths.forEach(async (item: string) => {
    let pixelMap: Nullable<image.PixelMap>;
    try {
      let decodeTime: number = systemDateTime.getTime(false);
      const imageSource: image.ImageSource = image.createImageSource(item);
      pixelMap = imageSource.createPixelMapSync(decodingOptions);
      if (pixelMap.getPixelBytesNumber() <= 0) {
        underBaseTime = false;
      } else {
        decodeTime = systemDateTime.getTime(false) - decodeTime;
      }
      if (decodeTime > 300) {
        underBaseTime = false;
        TsLog.error(TAG, `The image decoding time exceeds the threshold: ${item}`);
      }
    } catch (err) {
      TsLog.error(TAG, `Decode image to PixelMap failed.`, err);
    } finally {
      pixelMap?.release();
    }
  })
  return underBaseTime;
}