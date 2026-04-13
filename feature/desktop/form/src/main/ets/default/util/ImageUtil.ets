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

import image from '@ohos.multimedia.image';
import { BusinessError } from '@ohos.base';
import { componentSnapshot } from '@kit.ArkUI';
import { CheckEmptyUtils, LogDomain, Logger, PixelMapUtil } from '@ohos/basicutils';

const TAG: string = 'ImageUtil';
const log: Logger = Logger.getLogHelper(LogDomain.FORM);

export class ImageUtil {
  public static snapImage(componentId: string, onRecvPixelMap: (pixmap: image.PixelMap) => void,
    onError?: (error: BusinessError) => void): void {
    if (CheckEmptyUtils.checkStrIsEmpty(componentId)) {
      log.showError(TAG, 'snap image failed, componentId is invalid!');
      return;
    }

    log.showInfo(TAG, `start to snap image, componentId: ${componentId}.`);
    try {
      componentSnapshot.get(componentId)?.then((pixmap: image.PixelMap) => {
        log.showInfo(TAG, `snap image of componentId: ${componentId} successed.`);
        PixelMapUtil.addName(pixmap, `snapImage_${componentId}`);
        onRecvPixelMap?.(pixmap);
      }).catch((error: BusinessError) => {
        onError?.(error);
        log.showError(TAG, `snap image of componentId: ${componentId} failed, error: ${error?.code}!`);
      });
    } catch (error) {
      onError?.(error as BusinessError);
      log.showError(TAG, `snap image of componentId: ${componentId} failed, error: ${error?.code}!`);
    }
  }
}