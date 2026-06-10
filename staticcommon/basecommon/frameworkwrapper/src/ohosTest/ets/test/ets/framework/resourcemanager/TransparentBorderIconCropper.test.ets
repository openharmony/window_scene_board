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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium'
import { image } from '@kit.ImageKit';
import { iconBorderCropper } from '../../../../../../main/ets/resourcemanager/TransparentBorderIconCropper';

export function TransparentBorderIconCropperTest() {

  describe('TransparentBorderIconCropperTest', () => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('TransparentBorderIconCropperTest_test_loadTransparentBorderIconAppCfg', 0, () => {
      iconBorderCropper.loadTransparentBorderIconAppCfg();
      let result = iconBorderCropper.isTransparentBorderIcon('');
      expect(result).assertFalse();
    })

    it('TransparentBorderIconCropperTest_test_isTransparentBorderIcon_01', 0, () => {
      let result = iconBorderCropper.isTransparentBorderIcon('123');
      expect(result).assertFalse();
    })

    it('TransparentBorderIconCropperTest_test_isTransparentBorderIcon_02', 0, () => {
      let result = iconBorderCropper.isTransparentBorderIcon('com.vanke.activity');
      expect(result).assertTrue();
    })

    it('TransparentBorderIconCropperTest_test_cropByValidRegion_01', 0, async (done: Function) => {
      let iconImage = await resourceManagerCreateImage();
      let result = iconBorderCropper.cropByValidRegion(iconImage, '');
      expect(result === undefined).assertFalse();
      done();
    })
  });
}

async function resourceManagerCreateImage(): Promise<image.PixelMap> {
  let width: number = 10;
  let height: number = 10;
  const color = new ArrayBuffer(width * height * 4);
  let opts: image.InitializationOptions = { editable: true, pixelFormat: 3, size: { height: width, width: height } };
  return image.createPixelMap(color, opts);
}