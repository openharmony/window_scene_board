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
import { ObjectCopyUtil } from '../../../../../../main/ets/utils/ObjectCopyUtil';

export function ObjectCopyUtilTest() {
  describe('ObjectCopyUtilTest', (): void => {
    let num: number[] = [1, 2, 3];
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('test_deepClone_number_array', Level.LEVEL0, (): void => {
      let numNew = ObjectCopyUtil.deepClone(num);
      let res = isArrayEqual(num, numNew);
      expect(res).assertTrue();
    })

    it('test_simpleClone_number_array', Level.LEVEL0, (): void => {
      let numNew = ObjectCopyUtil.simpleClone(num);
      let res = isArrayEqual(num, numNew);
      expect(res).assertTrue();
    })

    it('test_deepClone_Object', Level.LEVEL0, (): void => {
      let point: Point = new Point(5, [6, 7, 8]);
      let obj: ObjectTest = new ObjectTest('test', 11, point);
      let objNew = ObjectCopyUtil.deepClone(obj);
      let res = isObjectTestEqual(obj, objNew);
      expect(res).assertTrue();
    })

    it('test_simpleClone_Object', Level.LEVEL0, (): void => {
      let point: Point = new Point(5, [6, 7, 8]);
      let obj: ObjectTest = new ObjectTest('test', 11, point);
      let objNew = ObjectCopyUtil.simpleClone(obj);
      let res = isObjectTestEqual(obj, objNew);
      expect(res).assertTrue();
    })
  })
}

function isArrayEqual(arr1: number[], arr2: number[]) {
  return JSON.stringify(arr1) === JSON.stringify(arr2);
}

function isObjectTestEqual(obj: ObjectTest, objNew: ObjectTest) {
  return obj.name === objNew.name && obj.id === objNew.id && obj.point.x === objNew.point.x && isArrayEqual(obj.point.y, objNew.point.y);
}

class ObjectTest {
  name: string;
  id: number;
  point: Point;

  constructor(name: string, id: number, point: Point) {
    this.name = name;
    this.id = id;
    this.point = point
  }
}

class Point {
  x: number;
  y: number[];

  constructor(x: number, y: number[]) {
    this.x = x;
    this.y = y;
  }
}