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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import CartesianCoordinates from '../../../../../../main/ets/utils/CartesianCoordinates';

/**
 * 平面直角坐标系 DT测试套
 */
export function CartesianCoordinatesTest() {
  describe('CartesianCoordinatesTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('CartesianCoordinatesTest_getDistance', Level.LEVEL0, (): void => {
      let a: CartesianCoordinates.Point = { x: 1, y: 2};
      let b: CartesianCoordinates.Point = { x: 5, y: 5};
      /* 勾三股四弦五 */
      expect(CartesianCoordinates.Linear.getDistance(a, b)).assertEqual(5);
      expect(CartesianCoordinates.Linear.getDistance(b, a)).assertEqual(5);
    })

    it('CartesianCoordinatesTest_getPointOnExtensionLine_001', Level.LEVEL0, (): void => {
      let a: CartesianCoordinates.Point = { x: 0, y: 0};
      let b: CartesianCoordinates.Point = { x: 3, y: 4};
      let res = CartesianCoordinates.Linear.getPointOnExtensionLine(a, b, 2.5);

      expect(res.x).assertEqual(4.5);
      expect(res.y).assertEqual(6);
    })

    it('CartesianCoordinatesTest_getPointOnExtensionLine_002', Level.LEVEL0, (): void => {
      let a: CartesianCoordinates.Point = { x: 0, y: 0};
      let b: CartesianCoordinates.Point = { x: 3, y: 4};
      let res = CartesianCoordinates.Linear.getPointOnExtensionLine(b, a, 5);

      expect(res.x).assertEqual(-3);
      expect(res.y).assertEqual(-4);
    })

    it('CartesianCoordinatesTest_getPointOnExtensionLine_003', Level.LEVEL0, (): void => {
      let a: CartesianCoordinates.Point = { x: 0, y: 0};
      let b: CartesianCoordinates.Point = { x: -3, y: 4};
      let res = CartesianCoordinates.Linear.getPointOnExtensionLine(a, b, 2.5);

      expect(res.x).assertEqual(-4.5);
      expect(res.y).assertEqual(6);
    })

    it('CartesianCoordinatesTest_getPointOnExtensionLine_004', Level.LEVEL0, (): void => {
      let a: CartesianCoordinates.Point = { x: 2, y: 1};
      let b: CartesianCoordinates.Point = { x: 5, y: 5};
      let res = CartesianCoordinates.Linear.getPointOnExtensionLine(a, b, 2.5);

      expect(res.x).assertEqual(6.5);
      expect(res.y).assertEqual(7);
    })

    it('CartesianCoordinatesTest_getPointOnExtensionLine_005', Level.LEVEL0, (): void => {
      let a: CartesianCoordinates.Point = { x: 1, y: 1};
      let b: CartesianCoordinates.Point = { x: 1, y: 2};
      let res = CartesianCoordinates.Linear.getPointOnExtensionLine(a, b, 2);

      expect(res.x).assertEqual(1);
      expect(res.y).assertEqual(4);
    })

    it('CartesianCoordinatesTest_getPointOnExtensionLine_006', Level.LEVEL0, (): void => {
      let a: CartesianCoordinates.Point = { x: 1, y: 1};
      let b: CartesianCoordinates.Point = { x: 2, y: 1};
      let res = CartesianCoordinates.Linear.getPointOnExtensionLine(a, b, 2);

      expect(res.x).assertEqual(4);
      expect(res.y).assertEqual(1);
    })
  })
}