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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, DEFAULT } from '@ohos/hypium';
import StyleConfiguration from '../../../../../../../main/ets/com/ohos/common/StyleConfiguration';
import { StartsBarCameraComponentStyle } from '../../../../../../../main/ets/com/ohos/common/StyleConfiguration';

export function CameraIndicatorStyleTest() {
  describe('CameraIndicatorStyleTest', (): void => {
    beforeAll(() => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('CameraIndicatorStyle_getStartsBarCameraComponentStyleTest01', DEFAULT, (): void => {
      const style: StartsBarCameraComponentStyle = StyleConfiguration.getStartsBarCameraComponentStyle();
      expect(style instanceof StartsBarCameraComponentStyle).assertTrue();
    })

    it('CameraIndicatorStyle_initStartsBarCameraComponentStyleTest01', DEFAULT, (): void => {
      const style: StartsBarCameraComponentStyle = new StartsBarCameraComponentStyle();
      expect(style instanceof StartsBarCameraComponentStyle).assertTrue();
    })
  })
}
