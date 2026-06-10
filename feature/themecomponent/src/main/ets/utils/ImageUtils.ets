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
import { display } from '@kit.ArkUI';
import { Log } from '../aigcServiceAbility/IdlService/Log';

export class ImageUtils {
  public static async convertUriToPixelMap(uri: string): Promise<image.PixelMap> {
    try {
      const file = await fs.open(uri, fs.OpenMode.READ_ONLY);
      const imageSource = image.createImageSource(file.fd);
      const decodingOptions: image.DecodingOptions = {
        desiredSize: { width: display.getDefaultDisplaySync().width, height: display.getDefaultDisplaySync().height },
        desiredPixelFormat: image.PixelMapFormat.RGBA_8888
      };
      const pixelMap: image.PixelMap = await imageSource.createPixelMap(decodingOptions);
      fs.close(file);
      return pixelMap
    } catch (error) {
      Log.error('error: ', error);
      return error
    }
  }
}