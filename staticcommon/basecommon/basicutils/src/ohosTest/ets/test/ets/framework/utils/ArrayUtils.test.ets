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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect } from '@ohos/hypium';
import { ArrayUtils } from '../../../../../../main/ets/utils/ArrayUtils';
import ArrayList from '@ohos.util.ArrayList';

export function ArrayUtilTest() {
  describe('ArrayUtilTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('ArrayUtilTest_isEmpty', 0, (): void => {
      let arr1:Array<string> = new Array();
      let arr2:Array<string> = new Array('arrTest');
      let mSet:Set<string|undefined> = new Set();
      expect(ArrayUtils.isEmpty(arr1)).assertTrue();
      expect(ArrayUtils.isEmpty(arr2)).assertFalse();
      expect(ArrayUtils.isEmpty(mSet)).assertTrue();
    })

    it('ArrayUtilTest_isEmpty_arraylist', 0, (): void => {
      let list: ArrayList<string> = new ArrayList();
      expect(ArrayUtils.isEmpty(list)).assertEqual(list.isEmpty());
    })

    it('ArrayUtilTest_isEmpty_arrIsUndefined', 0, (): void => {
      expect(ArrayUtils.isEmpty()).assertTrue();
    })

    it('ArrayUtilTest_checkDeleteIfEmpty', 0, (): void => {
      let mMap: Map<string, undefined> = new Map([['test', undefined]]);
      ArrayUtils.checkDeleteIfEmpty(mMap, 'test');
      expect(mMap.has('test')).assertFalse();
      ArrayUtils.checkDeleteIfEmpty(mMap, 'test');
      ArrayUtils.checkDeleteIfEmpty(null, 'test');
    })

    it('ArrayUtilTest_checkDeleteIfEmpty_else', 0, (): void => {
      let demoMap: Map<string, string> = new Map();
      let mMap: Map<string, Map<string, string>> = new Map();
      demoMap.set('key', 'this a value');
      mMap.set('data', demoMap);
      ArrayUtils.checkDeleteIfEmpty(mMap, 'data');
      expect(mMap.has('data')).assertTrue();
    })

    it('ArrayUtilTest_getSize_array', 0, (): void => {
      let arr1:Array<string> = new Array();
      let arr2:Array<string> = new Array('arrTest');
      expect(ArrayUtils.getSize(null)).assertEqual(0);
      expect(ArrayUtils.getSize(arr1)).assertEqual(0);
      expect(ArrayUtils.getSize(arr2)).assertEqual(1);
    })

    it('ArrayUtilTest_getSize_map', 0, (): void => {
      let mMap:Map<string, undefined> = new Map([['test',undefined]]);
      expect(ArrayUtils.getSize(mMap)).assertEqual(1);
    })

    it('ArrayUtilTest_clearArr', 0, (): void => {
        let arr:Array<string> = new Array('arrTest');
        ArrayUtils.clearArr(arr);
        expect(arr.length).assertEqual(0);
    })

    it('ArrayUtilTest_clearArr_arr_is_empty', 0, (): void => {
      let arr:Array<string> = new Array();
      ArrayUtils.clearArr(arr);
      expect(arr.length).assertEqual(0);
    })

    it('ArrayUtilTest_moveArr', 0, (): void => {
      let arr: Array<string> = new Array('arrTest','arrTestAgain');
      expect(ArrayUtils.moveArr(arr, 0, 1)).assertTrue();
      ArrayUtils.moveArr(null,0,1);
    })

    it('ArrayUtilTest_moveArr_index_invalid', 0, (): void => {
      let arr:Array<string> = new Array('arrTest','arrTestAgain');
      expect(ArrayUtils.moveArr(arr, 1, 2)).assertFalse();
    })

    it('ArrayUtilTest_addArr', 0, (): void => {
      let arr:Array<string> = new Array();
      ArrayUtils.addArr(arr,0,'arrTest');
      expect(arr.length).assertEqual(1);
      ArrayUtils.addArr(null,0,'arrTest');
      ArrayUtils.updateArr(null,'arrTest');
    })

    it('ArrayUtilTest_addArr_add_in_arr', 0, (): void => {
      let arr:Array<string> = new Array('test');
      ArrayUtils.addArr(arr,0,'arrTest');
      expect(arr.length).assertEqual(2);
    })

    it('ArrayUtilTest_equalsArr_defferent_length', 0, (): void => {
      expect(ArrayUtils.equalsArr(['arrTest'],['arrTest', 'arrTestAgain'])).assertFalse();
    })

    it('ArrayUtilTest_findArr', 0, (): void => {
      let arr: Array<string> = new Array('findArr');
      expect(ArrayUtils.findArr(arr, 0)).assertEqual('findArr');
    })

    it('ArrayUtilTest_findArr_arr_is_empty_or_index_invalid', 0, (): void => {
      let arr: Array<undefined> = new Array();
      let arr2: Array<string> = new Array('test');
      expect(ArrayUtils.findArr(arr, 1)).assertNull();
      expect(ArrayUtils.findArr(arr2, 2)).assertNull();
    })

    it('ArrayUtilTest_deleteArr', 0, (): void => {
      let elementToDel: string = 'dt';
      let arr: Array<string> = new Array('test', elementToDel);
      expect(ArrayUtils.deleteArr(null, 0)).assertEqual(-1);
      expect(ArrayUtils.deleteArr(arr, elementToDel)).assertLargerOrEqual(0);
    })

    it('ArrayUtilTest_deleteArrByIndex', 0, (): void => {
      let arr: Array<string> = new Array('test');
      expect(ArrayUtils.deleteArrByIndex(arr, 1)).assertNull();
      expect(ArrayUtils.deleteArrByIndex(arr, 0)).assertEqual('test');
      expect(ArrayUtils.deleteArrByIndex(null,0)).assertNull();
    })

    it('ArrayUtilTest_updateByIndex', 0, (): void => {
      let arr: Array<string> = new Array('test1');
      ArrayUtils.updateByIndex(arr, 0, 'test2');
      expect(arr[0]).assertEqual('test2');
    })

    it('ArrayUtilTest_delete1', 0, (): void => {
      let elementToDel: string = 'dt';
      let arr: Array<string> = new Array('test', elementToDel);
      expect(ArrayUtils.delete(arr, elementToDel)).assertEqual(elementToDel);
    })

    it('ArrayUtilTest_delete2', 0, (): void => {
      let elementToDel: string = 'dt';
      let arr: Set<string> = new Set();
      arr.add(elementToDel);
      expect(ArrayUtils.delete(arr, elementToDel)).not().assertNull();
    })

    it('ArrayUtilTest_updateArr', 0, (): void => {
      let arr: Array<string> = new Array();
      arr.push('element1');
      arr.push('element2');
      arr.push('element3');
      let ret: number = ArrayUtils.updateArr(arr, 'element1');
      expect(ret).assertEqual(0);
    })

    it('ArrayUtilTest_update', 0, (): void => {
      let arr: Set<string> = new Set();
      arr.add('element1');
      arr.add('element2');
      arr.add('element3');
      let ret: string | null = ArrayUtils.update(arr, 'element1');
      expect(ret).assertEqual('element1');
    })

    it('ArrayUtilTest_updateAll', 0, (): void => {
      let arr: Array<string> = new Array();
      arr.push('array1');
      arr.push('array2');
      arr.push('array3');
      let element: Array<string> = new Array();
      element.push('element1');
      element.push('element2');
      element.push('element3');
      let count: number = arr.length + element.length;
      ArrayUtils.updateAll(arr, element);
      expect(arr.length).assertEqual(count);
    })

    it('ArrayUtilTest_equalsArr_else', 0, (): void => {
      let arr: Array<string> = new Array();
      arr.push('array1');
      arr.push('array2');
      arr.push('array3');
      let element: Array<string> = new Array();
      element.push('element1');
      element.push('element2');
      element.push('element3');
      let count: number = arr.length + element.length;
      let same: boolean = ArrayUtils.equalsArr(arr, element);
      expect(same).assertFalse();
    })
  })
}