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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { UnionArray } from '../../../../../main/ets/utils/UnionArray';

export default function UnionArrayTest() {
  describe('UnionArrayTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    });
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    });
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    });
    it('UnionArrayInit', 0, () => {
      let unionArray: UnionArray<number> = new UnionArray<number>();
      expect(unionArray.length).assertEqual(0);
    });
    it('UnionArrayUnion', 0, () => {
      let arr1 = [0, 1, 2, 3];
      let arr2 = [4, 5, 6, 7];
      let unionArray: UnionArray<number> = new UnionArray<number>();
      expect(unionArray.length).assertEqual(0);
      expect(unionArray.union(arr1)).assertTrue();
      expect(unionArray.length).assertEqual(4);
      expect(unionArray.union(arr2)).assertTrue();
      expect(unionArray.length).assertEqual(8);
      expect(unionArray.union(arr1)).assertFalse();
    });
    it('UnionArrayUnUnion', 0, () => {
      let arr1 = [0, 1, 2, 3];
      let arr2 = [4, 5, 6, 7];
      let unionArray: UnionArray<number> = new UnionArray<number>();
      expect(unionArray.length).assertEqual(0);
      expect(unionArray.union(arr1)).assertTrue();
      expect(unionArray.union(arr2)).assertTrue();
      expect(unionArray.length).assertEqual(8);
      expect(unionArray.unUnion(arr1)).assertTrue();
      expect(unionArray.length).assertEqual(4);
      expect(unionArray.unUnion(arr2)).assertTrue();
      expect(unionArray.length).assertEqual(0);
      expect(unionArray.unUnion(arr2)).assertFalse();
    });
    it('UnionArrayGet', 0, () => {
      let arr1 = [0, 1, 2, 3];
      let arr2 = [4, 5, 6, 7];
      let unionArray: UnionArray<number> = new UnionArray<number>();
      unionArray.union(arr1);
      unionArray.union(arr2);
      expect(unionArray.length).assertEqual(8);
      expect(unionArray.get(-1)).assertEqual(undefined);
      expect(unionArray.get(0)).assertEqual(0);
      expect(unionArray.get(4)).assertEqual(4);
      expect(unionArray.get(7)).assertEqual(7);
      expect(unionArray.get(8)).assertEqual(undefined);
    });
    it('UnionArrayGet2', 0, () => {
      let arr1 = [0, 1, 2, 3];
      let arr2 = [4, 5, 6, 7];
      let unionArray: UnionArray<number> = new UnionArray<number>();
      unionArray.union(arr1);
      unionArray.union(arr2);
      expect(unionArray.length).assertEqual(8);
      expect(unionArray.get(0)).assertEqual(0);
      expect(unionArray.get(4)).assertEqual(4);
      expect(unionArray.get(7)).assertEqual(7);

      arr1[0] = 10;
      expect(unionArray.get(0)).assertEqual(10);
      arr2[0] = 20;
      expect(unionArray.get(4)).assertEqual(20);
    });
    it('UnionArrayFind', 0, () => {
      let arr1 = [0, 1, 2, 3];
      let arr2 = [4, 5, 6, 7];
      let unionArray: UnionArray<number> = new UnionArray<number>();
      unionArray.union(arr1);
      unionArray.union(arr2);
      expect(unionArray.length).assertEqual(8);
      expect(unionArray.find((item: number) => {
        return item === 0;
      })).assertEqual(0);
      expect(unionArray.find((item: number) => {
        return item === 4;
      })).assertEqual(4);
      expect(unionArray.find((item: number) => {
        return item === 8;
      })).assertEqual(undefined);
    });
    it('UnionArrayFindIndex', 0, () => {
      let arr1 = [0, 1, 2, 3];
      let arr2 = [4, 5, 6, 7];
      let unionArray: UnionArray<number> = new UnionArray<number>();
      unionArray.union(arr1);
      unionArray.union(arr2);
      expect(unionArray.length).assertEqual(8);
      expect(unionArray.findIndex((item: number) => {
        return item === 0;
      })).assertEqual(0);
      expect(unionArray.findIndex((item: number) => {
        return item === 4;
      })).assertEqual(4);
      expect(unionArray.findIndex((item: number) => {
        return item === 8;
      })).assertEqual(-1);
    });
    it('UnionArrayFindIndexInOwner', 0, () => {
      let arr1 = [0, 1, 2, 3];
      let arr2 = [4, 5, 6, 7];
      let unionArray: UnionArray<number> = new UnionArray<number>();
      unionArray.union(arr1);
      unionArray.union(arr2);
      expect(unionArray.length).assertEqual(8);
      expect(unionArray.findIndexInOwner((item: number) => {
        return item === 0;
      })).assertEqual(0);
      expect(unionArray.findIndexInOwner((item: number) => {
        return item === 4;
      })).assertEqual(0);
      expect(unionArray.findIndexInOwner((item: number) => {
        return item === 8;
      })).assertEqual(-1);
    });
    it('UnionArrayIndexOf', 0, () => {
      let arr1 = [0, 1, 2, 3];
      let arr2 = [4, 5, 6, 7];
      let unionArray: UnionArray<number> = new UnionArray<number>();
      unionArray.union(arr1);
      unionArray.union(arr2);
      expect(unionArray.length).assertEqual(8);
      expect(unionArray.indexOf(0)).assertEqual(0);
      expect(unionArray.indexOf(4)).assertEqual(4);
      expect(unionArray.indexOf(8)).assertEqual(-1);
    });
    it('UnionArrayIndexOfWithFromIndex', 0, () => {
      let arr1 = [0, 1, 2, 3];
      let arr2 = [4, 5, 6, 7];
      let unionArray: UnionArray<number> = new UnionArray<number>();
      unionArray.union(arr1);
      unionArray.union(arr2);
      expect(unionArray.length).assertEqual(8);
      expect(unionArray.indexOf(0, 0)).assertEqual(0);
      expect(unionArray.indexOf(0, 1)).assertEqual(-1);
      expect(unionArray.indexOf(4, 0)).assertEqual(4);
      expect(unionArray.indexOf(4, 5)).assertEqual(-1);
      expect(unionArray.indexOf(8, 0)).assertEqual(-1);
    });
    it('UnionArrayIndexOfOwner', 0, () => {
      let arr1 = [0, 1, 2, 3];
      let arr2 = [4, 5, 6, 7];
      let unionArray: UnionArray<number> = new UnionArray<number>();
      unionArray.union(arr1);
      unionArray.union(arr2);
      expect(unionArray.length).assertEqual(8);
      expect(unionArray.indexOfOwner(0)).assertEqual(0);
      expect(unionArray.indexOfOwner(4)).assertEqual(0);
      expect(unionArray.indexOfOwner(8)).assertEqual(-1);
    });
    it('UnionArrayIndexOfOwnerWithFromIndex', 0, () => {
      let arr1 = [0, 1, 2, 3];
      let arr2 = [4, 5, 6, 7];
      let unionArray: UnionArray<number> = new UnionArray<number>();
      unionArray.union(arr1);
      unionArray.union(arr2);
      expect(unionArray.length).assertEqual(8);
      expect(unionArray.indexOfOwner(0, 0)).assertEqual(0);
      expect(unionArray.indexOfOwner(0, 1)).assertEqual(-1);
      expect(unionArray.indexOfOwner(4, 0)).assertEqual(0);
      expect(unionArray.indexOfOwner(4, 1)).assertEqual(-1);
      expect(unionArray.indexOfOwner(8)).assertEqual(-1);
    });
    it('UnionArrayLastIndexOf', 0, () => {
      let arr1 = [0, 1, 2, 3];
      let arr2 = [0, 1, 2, 3];
      let unionArray: UnionArray<number> = new UnionArray<number>();
      unionArray.union(arr1);
      unionArray.union(arr2);
      expect(unionArray.length).assertEqual(8);
      expect(unionArray.lastIndexOf(0)).assertEqual(4);
      expect(unionArray.lastIndexOf(3)).assertEqual(7);
      expect(unionArray.lastIndexOf(8)).assertEqual(-1);
    });
    it('UnionArrayLastIndexOfWithFromIndex', 0, () => {
      let arr1 = [0, 1, 2, 3];
      let arr2 = [0, 1, 2, 3];
      let unionArray: UnionArray<number> = new UnionArray<number>();
      unionArray.union(arr1);
      unionArray.union(arr2);
      expect(unionArray.length).assertEqual(8);
      expect(unionArray.lastIndexOf(0, 8)).assertEqual(4);
      expect(unionArray.lastIndexOf(0, 7)).assertEqual(4);
      expect(unionArray.lastIndexOf(0, 4)).assertEqual(4);
      expect(unionArray.lastIndexOf(0, 3)).assertEqual(0);
      expect(unionArray.lastIndexOf(3, 7)).assertEqual(7);
      expect(unionArray.lastIndexOf(8, 7)).assertEqual(-1);
    });
    it('UnionArrayLastIndexOfOwner', 0, () => {
      let arr1 = [0, 1, 2, 3];
      let arr2 = [0, 1, 2, 3];
      let unionArray: UnionArray<number> = new UnionArray<number>();
      unionArray.union(arr1);
      unionArray.union(arr2);
      expect(unionArray.length).assertEqual(8);
      expect(unionArray.lastIndexOfOwner(0)).assertEqual(0);
      expect(unionArray.lastIndexOfOwner(3)).assertEqual(3);
      expect(unionArray.lastIndexOfOwner(4)).assertEqual(-1);
      expect(unionArray.lastIndexOfOwner(8)).assertEqual(-1);
    });
    it('UnionArrayLastIndexOfOwnerWithFromIndex', 0, () => {
      let arr1 = [4, 5, 6, 7];
      let arr2 = [0, 1, 2, 3];
      let unionArray: UnionArray<number> = new UnionArray<number>();
      unionArray.union(arr1);
      unionArray.union(arr2);
      expect(unionArray.length).assertEqual(8);
      expect(unionArray.lastIndexOfOwner(0, 8)).assertEqual(0);
      expect(unionArray.lastIndexOfOwner(0, 4)).assertEqual(0);
      expect(unionArray.lastIndexOfOwner(3, 8)).assertEqual(3);
      expect(unionArray.lastIndexOfOwner(3, 3)).assertEqual(3);
      expect(unionArray.lastIndexOfOwner(3, 2)).assertEqual(-1);
      expect(unionArray.lastIndexOfOwner(4, 7)).assertEqual(0);
      expect(unionArray.lastIndexOfOwner(4, 3)).assertEqual(0);
      expect(unionArray.lastIndexOfOwner(4, 0)).assertEqual(0);
      expect(unionArray.lastIndexOfOwner(8, 8)).assertEqual(-1);
    });
    it('UnionArrayForEach', 0, () => {
      let arr1 = [0, 1, 2, 3];
      let arr2 = [4, 5, 6, 7];
      let unionArray: UnionArray<number> = new UnionArray<number>();
      unionArray.union(arr1);
      unionArray.union(arr2);
      expect(unionArray.length).assertEqual(8);
      let i = 0;
      unionArray.forEach((item: number) => {
        expect(item).assertEqual(i);
        i++;
      });
    });
    it('UnionArraySplice', 0, () => {
      let arr1 = [0, 1, 2, 3];
      let arr2 = [4, 5, 6, 7];
      let unionArray: UnionArray<number> = new UnionArray<number>();
      unionArray.union(arr1);
      unionArray.union(arr2);
      expect(unionArray.length).assertEqual(8);
      unionArray.splice(0, 2);
      expect(unionArray.length).assertEqual(6);
      expect(unionArray.get(0)).assertEqual(2);
      expect(unionArray.splice(8, 2).length).assertEqual(0)
      expect(unionArray.splice(-1, 1).length).assertEqual(0)
    });
    it('UnionArrayRemove', 0, () => {
      let arr1 = [0, 1, 2, 3];
      let arr2 = [4, 5, 6, 7];
      let unionArray: UnionArray<number> = new UnionArray<number>();
      unionArray.union(arr1);
      unionArray.union(arr2);
      expect(unionArray.length).assertEqual(8);
      unionArray.remove(0);
      expect(unionArray.length).assertEqual(7);
      expect(unionArray.get(0)).assertEqual(1);
      unionArray.remove(4);
      expect(unionArray.length).assertEqual(6);
      expect(unionArray.get(3)).assertEqual(5);
      expect(unionArray.remove(99)).assertFalse()
    });
    it('UnionArrayRemoveAll', 0, () => {
      let arr1 = [0, 1, 2, 3];
      let arr2 = [0, 1, 2, 3];
      let unionArray: UnionArray<number> = new UnionArray<number>();
      unionArray.union(arr1);
      unionArray.union(arr2);
      expect(unionArray.length).assertEqual(8);
      unionArray.removeAll(0);
      expect(unionArray.length).assertEqual(6);
      expect(unionArray.get(0)).assertEqual(1);
      expect(unionArray.get(3)).assertEqual(1);
    });
    it('UnionArrayRemoveAll2', 0, () => {
      let arr1 = [0, 0, 0, 0];
      let arr2 = [0, 0, 0, 0];
      let unionArray: UnionArray<number> = new UnionArray<number>();
      unionArray.union(arr1);
      unionArray.union(arr2);
      expect(unionArray.length).assertEqual(8);
      unionArray.removeAll(0);
      expect(unionArray.length).assertEqual(0);
    });
    it('UnionArrayFilter', 0, () => {
      let arr1 = [0, 1, 2, 3];
      let arr2 = [4, 5, 6, 7];
      let unionArray: UnionArray<number> = new UnionArray<number>();
      unionArray.union(arr1);
      unionArray.union(arr2);
      expect(unionArray.length).assertEqual(8);
      let filterArr: number[] = unionArray.filter((item: number) => {
        return item === 0;
      });
      expect(filterArr.length).assertEqual(1);
    });
    it('UnionArrayFilter2', 0, () => {
      let arr1 = [0, 1, 2, 3];
      let arr2 = [0, 1, 2, 3];
      let unionArray: UnionArray<number> = new UnionArray<number>();
      unionArray.union(arr1);
      unionArray.union(arr2);
      expect(unionArray.length).assertEqual(8);
      let filterArr: number[] = unionArray.filter((item: number) => {
        return item === 0;
      });
      expect(filterArr.length).assertEqual(2);
    });
  });
}