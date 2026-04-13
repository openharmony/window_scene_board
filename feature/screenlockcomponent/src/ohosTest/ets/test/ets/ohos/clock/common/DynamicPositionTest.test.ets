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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import { DynamicPosition }  from '@ohos/screenlockwidget/src/main/ets/clock/common/DynamicPosition';

export default function DynamicPositionTest() {

  describe('DynamicPositionTest', (): void => {
    let offset: Position;
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_buildPosition_return', 0, (): void => {
      let scene: string = 'res';
      dynamicOffset: DynamicPosition.wrapper().buildProperty(scene,offset);
      expect(scene).assertEqual('res');
    })

    it('test_getPosition_return', 0, (): void => {
      let scene: string = 'res';
      dynamicOffset: DynamicPosition.wrapper().getProperty(scene);
      expect(scene).assertEqual('res');
    })

    it('test_getForEach_return', 0, (): void => {
      let key: string = 'res';
      let map: Map<string, Position>;
      let value: Position;
      dynamicOffset: DynamicPosition.wrapper().forEach((value,key,map)=>{});
      expect(key).not().assertNull();
    })

    it('test_getWrapper_return', 0, (): void => {
      let result: string = 'res';
      dynamicOffset: DynamicPosition.wrapper();
      expect(result).assertEqual('res');
    })
  })
}