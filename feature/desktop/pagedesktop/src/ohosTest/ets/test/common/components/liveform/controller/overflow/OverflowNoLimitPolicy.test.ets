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

import formInfo from '@ohos.app.form.formInfo';
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
} from '@ohos/hypium';
import {
  OverflowNoLimitPolicy
} from '../../../../../../../../../src/main/ets/default/common/components/liveform/controller/overflow/OverflowNoLimitPolicy';

export function OverflowNoLimitPolicyTest() {
  let overflowInfoTrue: formInfo.OverflowInfo = {
    area: {
      left: -30,
      top: -30,
      width: 200,
      height: 200
    },
    duration: 3500
  };

  let overflowInfoTrue1: formInfo.OverflowInfo = {
    area: {
      left: -30,
      top: -30,
      width: 200,
      height: 200
    },
    duration: 8000
  };

  let overflowInfoTrue2: formInfo.OverflowInfo = {
    area: {
      left: -30,
      top: -30,
      width: 2000,
      height: 2000
    },
    duration: 8000
  };

  let overflowInfoTrue3: formInfo.OverflowInfo = {
    area: {
      left: -40,
      top: -40,
      width: 200,
      height: 200
    },
    duration: 3000
  };

  let overflowInfoTrue4: formInfo.OverflowInfo = {
    area: {
      left: -80,
      top: -80,
      width: 2000,
      height: 2000
    },
    duration: 8000
  };

  let overflowInfoFalse: formInfo.OverflowInfo = {
    area: {
      left: 30,
      top: 30,
      width: 200,
      height: 200
    },
    duration: 3500
  };

  let overflowInfoFalse1: formInfo.OverflowInfo = {
    area: {
      left: -30,
      top: -30,
      width: 200,
      height: 200
    },
    duration: -10
  };

  let overflowInfoFalse2: formInfo.OverflowInfo = {
    area: {
      left: 30,
      top: 30,
      width: 200,
      height: 200
    },
    duration: -10
  };

  let overflowInfoFalse3: formInfo.OverflowInfo = {
    area: {
      left: -30,
      top: -30,
      width: 100,
      height: 200
    },
    duration: 3000
  };

  let overflowInfoFalse4: formInfo.OverflowInfo = {
    area: {
      left: -30,
      top: -30,
      width: 200,
      height: 100
    },
    duration: 3000
  };

  let overflowInfoFalse5: formInfo.OverflowInfo = {
    area: {
      left: -30,
      top: -30,
      width: 100,
      height: 100
    },
    duration: 3000
  };

  // CARD_DIMENSION_2x2 = 2
  let cardDimension: number = 2;
  let formItemWidth: number = 158;
  let formItemHeight: number = 158;
  let cardDimensionFalse: number = 108;

  describe('OverflowNoLimitPolicyTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('test_OverflowNoLimitPolicyTest_canOverflow', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowNoLimitPolicy = new OverflowNoLimitPolicy();
      let result: boolean = instance.canOverflow(overflowInfoFalse, cardDimension, formItemWidth, formItemHeight);
      expect(result).assertFalse();
    })

    it('test_OverflowNoLimitPolicyTest_canOverflow_01', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowNoLimitPolicy = new OverflowNoLimitPolicy();
      let result: boolean = instance.canOverflow(overflowInfoFalse1, cardDimension, formItemWidth, formItemHeight);
      expect(result).assertFalse();
    })

    it('test_OverflowNoLimitPolicyTest_canOverflow_02', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowNoLimitPolicy = new OverflowNoLimitPolicy();
      let result: boolean = instance.canOverflow(overflowInfoFalse2, cardDimension, formItemWidth, formItemHeight);
      expect(result).assertFalse();
    })

    it('test_OverflowNoLimitPolicyTest_canOverflow_03', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowNoLimitPolicy = new OverflowNoLimitPolicy();
      let result: boolean = instance.canOverflow(overflowInfoFalse3, cardDimension, formItemWidth, formItemHeight);
      expect(result).assertFalse();
    })

    it('test_OverflowNoLimitPolicyTest_canOverflow_04', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowNoLimitPolicy = new OverflowNoLimitPolicy();
      let result: boolean = instance.canOverflow(overflowInfoFalse4, cardDimension, formItemWidth, formItemHeight);
      expect(result).assertFalse();
    })

    it('test_OverflowNoLimitPolicyTest_canOverflow_05', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowNoLimitPolicy = new OverflowNoLimitPolicy();
      let result: boolean = instance.canOverflow(overflowInfoFalse5, cardDimension, formItemWidth, formItemHeight);
      expect(result).assertFalse();
    })

    it('test_OverflowNoLimitPolicyTest_canOverflow_06', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowNoLimitPolicy = new OverflowNoLimitPolicy();
      let result: boolean = instance.canOverflow(overflowInfoTrue, cardDimension, formItemWidth, formItemHeight);
      expect(result).assertTrue();
    })

    it('test_OverflowNoLimitPolicyTest_canOverflow_07', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowNoLimitPolicy = new OverflowNoLimitPolicy();
      let result: boolean = instance.canOverflow(overflowInfoTrue1, cardDimension, formItemWidth, formItemHeight);
      expect(result).assertTrue();
    })

    it('test_OverflowNoLimitPolicyTest_canOverflow_08', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowNoLimitPolicy = new OverflowNoLimitPolicy();
      let result: boolean = instance.canOverflow(overflowInfoTrue2, cardDimension, formItemWidth, formItemHeight);
      expect(result).assertTrue();
    })

    it('test_OverflowNoLimitPolicyTest_canOverflow_09', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowNoLimitPolicy = new OverflowNoLimitPolicy();
      let result: boolean = instance.canOverflow(overflowInfoTrue3, cardDimension, formItemWidth, formItemHeight);
      expect(result).assertTrue();
    })

    it('test_OverflowNoLimitPolicyTest_canOverflow_10', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowNoLimitPolicy = new OverflowNoLimitPolicy();
      let result: boolean = instance.canOverflow(overflowInfoTrue4, cardDimension, formItemWidth, formItemHeight);
      expect(result).assertTrue();
    })

    it('test_OverflowNoLimitPolicyTest_canOverflow_11', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowNoLimitPolicy = new OverflowNoLimitPolicy();
      let result: boolean = instance.canOverflow(overflowInfoTrue, cardDimensionFalse, formItemWidth, formItemHeight);
      expect(result).assertTrue();
    })
  })
}
