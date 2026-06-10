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

import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  TestType,
  Level,
  expect,
  describe
} from '@ohos/hypium'
import {
  OverflowThresholdConfig
} from '../../../../../../../main/ets/default/common/components/liveform/common/OverflowThresholdConfig';

function arraysEqual(arr1: number[], arr2: number[]): boolean {
  if (arr1.length !== arr2.length) {
    return false;
  }
  for (let i = 0; i < arr1.length; i++) {
    if (arr1[i] !== arr2[i]) {
      return false;
    }
  }
  return true;
}

export function OverflowDeviceManagerTest() {
  describe('OverflowDeviceManagerTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('test_getInstance', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance = OverflowThresholdConfig.getInstance();
      expect(instance).not().assertNull();
    })

    it('test_getOverflowMaxDuration', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowThresholdConfig = OverflowThresholdConfig.getInstance();
      let result = instance.getOverflowMaxDuration();
      expect(result).assertEqual(3500);

    })

    it('test_getOverflowScaleRatio_dimensionNotExist_returnUndefined', TestType.FUNCTION | Level.LEVEL0, () => {
      let dimension: number = 108;
      let instance: OverflowThresholdConfig = OverflowThresholdConfig.getInstance();
      let getNumber: number[] | undefined = instance.getOverflowScaleRatio(dimension);
      expect(getNumber).assertEqual(undefined);
    })

    it('test_getOverflowScaleRatio_dimensionExist_returnCorrectRatio', TestType.FUNCTION | Level.LEVEL0, () => {
      let dimension: number = 3;
      let targetNumber: number[] | undefined = [1.25, 1.5];
      let instance: OverflowThresholdConfig = OverflowThresholdConfig.getInstance();
      let getNumber: number[] | undefined = instance.getOverflowScaleRatio(dimension);
      if ( getNumber !== undefined) {
       let result: boolean =  arraysEqual(getNumber,targetNumber);
        expect(result).assertTrue();
      }
    })
  })
}
