/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { HashMap } from '@kit.ArkTS';
import { image } from '@kit.ImageKit';
import { DrawableDescriptor } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';

const TAG = 'FileIconUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class FileIconUtils {
  
  private static fileIconMap: HashMap<number, image.PixelMap> = new HashMap<number, image.PixelMap>();

  /**
   * 从资源Id获取pixMap, 先从缓存map取，去不到再从资源拿
   * @param resId, 资源Id
   * @param context
   * @returns 
   */
  public static getPixMapFromResourceId(resId: number, context: common.Context): image.PixelMap | undefined {
    if (!resId || !context) {
      log.showError('getPixMapFromResourceId, input resId undefined');
      return undefined;
    }
    let iconPixedMap: image.PixelMap | undefined = FileIconUtils.fileIconMap.get(resId);
    if (iconPixedMap) {
      return iconPixedMap;
    }
    try {
      let imageDescriptor: DrawableDescriptor = context.resourceManager?.getDrawableDescriptor(resId);
      let value: image.PixelMap = imageDescriptor?.getPixelMap();
      if (value) {
        log.showInfo(`getPixMapFromResourceId find and save Item: ${resId}`);
        FileIconUtils.fileIconMap.set(resId, value);
      }
      return value;
    } catch (err) {
      log.showError(`getPixMapFromResourceId error, code: ${err?.code}, message: ${err?.message}`);
      return undefined;
    }
  }
}