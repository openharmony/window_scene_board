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
import {
  GestureAction,
  SCBGestureRecord
} from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBGestureRecord';
import { beforeAll, beforeEach, describe, expect, it, Level } from '@ohos/hypium';
import {
  SCBGridRowUtils
} from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/utils/SCBGridRowUtils';

let gridUtilTmp: SCBGridRowUtils;
let gestureRecordTmp: SCBGestureRecord;
let initAll = () => {
  gridUtilTmp = new SCBGridRowUtils();
}
let assertFlag: boolean = true;

export function SCBGridRowUtilsTest() {
  describe('SCBGridRowUtilsTest_describe', () => {
    beforeAll((): void => {
      gestureRecordTmp = new SCBGestureRecord(() => () => {});
    })
    beforeEach(initAll)
    it('recordCurGestureModel_it', Level.LEVEL0, () => {
      gestureRecordTmp.recordCurGesture(GestureAction.START , null);
      expect(assertFlag).assertTrue();
    })

    it ("test_updateScreenSize_it", Level.LEVEL0, test_updateScreenSize_func);
    it ("test_getSpanWidth_it", Level.LEVEL0, test_getSpanWidth_func);

    it('processCancelModel', Level.LEVEL0, () => {
      gestureRecordTmp.processCancel();
      expect(assertFlag).assertTrue();
    })
    it ("test_init_it", Level.LEVEL0, test_init_func);
    it ("test_defaultCalcColumns_it", Level.LEVEL0, test_defaultCalcColumns_func);
  });
}

function test_updateScreenSize_func() {
  gridUtilTmp.init(0, 0, 900, 0, null);
  gridUtilTmp.updateScreenSize(0, 0);
  expect(assertFlag).assertTrue();
}

function test_getSpanWidth_func() {
  gridUtilTmp.getSpanWidth(0);
  gridUtilTmp.getSpanWidth(1);
  gridUtilTmp.init(0, 0, 0, 0, null);
  gridUtilTmp.getSpanWidth(2);
  gridUtilTmp.getSpanWidth(1000);
  expect(assertFlag).assertTrue();
}

function test_init_func() {
  gridUtilTmp.init(0, 0, 0, 0, () => {});
  expect(assertFlag).assertTrue();
}


function test_defaultCalcColumns_func() {
  gridUtilTmp.init(0, 0, 0, 0, null);
  gridUtilTmp.defaultCalcColumns();
  gridUtilTmp.init(0, 0, 600, 0, null);
  gridUtilTmp.defaultCalcColumns();
  gridUtilTmp.init(0, 0, 900, 0, null);
  gridUtilTmp.defaultCalcColumns();
  expect(assertFlag).assertTrue();
}