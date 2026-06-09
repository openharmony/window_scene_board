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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import { DynamicRegion }  from '@ohos/screenlockwidget/src/main/ets/clock/common/DynamicRegion';

export default function DynamicRegionTest() {

  describe('DynamicRegionTest', (): void => {
    let rect: Rectangle;
    let region: DynamicRegion | undefined;
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_bindRegion_should_return', 0, (): void => {
      let scene: string = 'res';
      dynamicRegion: DynamicRegion.wrapper().bindRegion(scene,rect);
      expect(scene).not().assertNull();
    })
    it('test_getRegion_should_return', 0, (): void => {
      let scene: string = 'res';
      dynamicRegion: DynamicRegion.wrapper().getRegion(scene);
      expect(scene).not().assertNull();
    })
    it('test_initFromRegion_should_return', 0, (): void => {
      let scale: number = 1.0;
      dynamicRegion: DynamicRegion.wrapper().initFromRegion(region,scale);
      expect(scale).not().assertNull();
    })
  })
}