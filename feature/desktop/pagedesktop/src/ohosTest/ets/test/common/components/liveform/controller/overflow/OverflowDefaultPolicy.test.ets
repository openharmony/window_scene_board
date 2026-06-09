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
  OverflowDefaultPolicy
} from '../../../../../../../../../src/main/ets/default/common/components/liveform/controller/overflow/OverflowDefaultPolicy';

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
    left: -19.75,
    top: -19.75,
    width: 177.75,
    height: 177.75
  },
  duration: 3500
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
    width: 200,
    height: 200
  },
  duration: 8000
};

let overflowInfoFalse4: formInfo.OverflowInfo = {
  area: {
    left: -30,
    top: -30,
    width: 100,
    height: 200
  },
  duration: 3500
};

let overflowInfoFalse5: formInfo.OverflowInfo = {
  area: {
    left: -30,
    top: -30,
    width: 200,
    height: 100
  },
  duration: 3500
};

let overflowInfoFalse6: formInfo.OverflowInfo = {
  area: {
    left: -80,
    top: -80,
    width: 200,
    height: 200
  },
  duration: 3500
};

let overflowInfoFalse7: formInfo.OverflowInfo = {
  area: {
    left: -80,
    top: 30,
    width: 200,
    height: 200
  },
  duration: 3500
};

let overflowInfoFalse8: formInfo.OverflowInfo = {
  area: {
    left: 30,
    top: -80,
    width: 200,
    height: 200
  },
  duration: 3500
};

let overflowInfoFalse9: formInfo.OverflowInfo = {
  area: {
    left: -30,
    top: 30,
    width: 200,
    height: 200
  },
  duration: 3500
};

let overflowInfoFalse10: formInfo.OverflowInfo = {
  area: {
    left: 30,
    top: -30,
    width: 200,
    height: 200
  },
  duration: 3500
};

let overflowInfoFalse11: formInfo.OverflowInfo = {
  area: {
    left: -80,
    top: -30,
    width: 200,
    height: 200
  },
  duration: 3500
};

let overflowInfoFalse12: formInfo.OverflowInfo = {
  area: {
    left: -30,
    top: -80,
    width: 200,
    height: 200
  },
  duration: 3500
};

let overflowInfoFalse13: formInfo.OverflowInfo = {
  area: {
    left: -30,
    top: -30,
    width: 160,
    height: 200
  },
  duration: 3500
};

let overflowInfoFalse14: formInfo.OverflowInfo = {
  area: {
    left: -30,
    top: -30,
    width: 260,
    height: 200
  },
  duration: 3500
};

let overflowInfoFalse15: formInfo.OverflowInfo = {
  area: {
    left: -30,
    top: -30,
    width: 200,
    height: 160
  },
  duration: 3500
};

let overflowInfoFalse16: formInfo.OverflowInfo = {
  area: {
    left: -30,
    top: -30,
    width: 200,
    height: 260
  },
  duration: 3500
};


// CARD_DIMENSION_2x2 = 2
let cardDimension: number = 2;
let formItemWidth: number = 158;
let formItemHeight: number = 158;
let cardDimensionFalse: number = 108;
let cardDimension1: number = 4;

export function OverflowDefaultPolicyTest() {
  describe('OverflowDefaultPolicyTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('test_OverflowDefaultPolicyTest_canOverflow', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowDefaultPolicy = new OverflowDefaultPolicy();
      let result: boolean = instance.canOverflow(overflowInfoFalse, cardDimension, formItemWidth, formItemHeight);
      expect(result).assertFalse();
    })

    it('test_OverflowDefaultPolicyTest_canOverflow_01', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowDefaultPolicy = new OverflowDefaultPolicy();
      let result: boolean = instance.canOverflow(overflowInfoFalse1, cardDimension, formItemWidth, formItemHeight);
      expect(result).assertFalse();
    })

    it('test_OverflowDefaultPolicyTest_canOverflow_02', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowDefaultPolicy = new OverflowDefaultPolicy();
      let result: boolean = instance.canOverflow(overflowInfoFalse2, cardDimension, formItemWidth, formItemHeight);
      expect(result).assertFalse();
    })

    it('test_OverflowDefaultPolicyTest_canOverflow_03', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowDefaultPolicy = new OverflowDefaultPolicy();
      let result: boolean = instance.canOverflow(overflowInfoFalse3, cardDimension, formItemWidth, formItemHeight);
      expect(result).assertFalse();
    })

    it('test_OverflowDefaultPolicyTest_canOverflow_04', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowDefaultPolicy = new OverflowDefaultPolicy();
      let result: boolean = instance.canOverflow(overflowInfoTrue, cardDimensionFalse, formItemWidth, formItemHeight);
      expect(result).assertFalse();
    })

    it('test_OverflowDefaultPolicyTest_canOverflow_05', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowDefaultPolicy = new OverflowDefaultPolicy();
      let result: boolean = instance.canOverflow(overflowInfoFalse4, cardDimension, formItemWidth, formItemHeight);
      expect(result).assertFalse();
    })

    it('test_OverflowDefaultPolicyTest_canOverflow_06', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowDefaultPolicy = new OverflowDefaultPolicy();
      let result: boolean = instance.canOverflow(overflowInfoFalse5, cardDimension, formItemWidth, formItemHeight);
      expect(result).assertFalse();
    })

    it('test_OverflowDefaultPolicyTest_canOverflow_07', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowDefaultPolicy = new OverflowDefaultPolicy();
      let result: boolean = instance.canOverflow(overflowInfoTrue, cardDimension1, formItemWidth, formItemHeight);
      expect(result).assertFalse();
    })

    it('test_OverflowDefaultPolicyTest_canOverflow_08', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowDefaultPolicy = new OverflowDefaultPolicy();
      let result: boolean = instance.canOverflow(overflowInfoTrue1, cardDimension1, formItemWidth, formItemHeight);
      expect(result).assertTrue();
    })

    it('test_OverflowDefaultPolicyTest_canOverflow_09', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowDefaultPolicy = new OverflowDefaultPolicy();
      let result: boolean = instance.canOverflow(overflowInfoFalse6, cardDimension, formItemWidth, formItemHeight);
      expect(result).assertFalse();
    })

    it('test_OverflowDefaultPolicyTest_canOverflow_10', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowDefaultPolicy = new OverflowDefaultPolicy();
      let result: boolean = instance.canOverflow(overflowInfoFalse7, cardDimension, formItemWidth, formItemHeight);
      expect(result).assertFalse();
    })

    it('test_OverflowDefaultPolicyTest_canOverflow_11', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowDefaultPolicy = new OverflowDefaultPolicy();
      let result: boolean = instance.canOverflow(overflowInfoFalse8, cardDimension, formItemWidth, formItemHeight);
      expect(result).assertFalse();
    })

    it('test_OverflowDefaultPolicyTest_canOverflow_12', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowDefaultPolicy = new OverflowDefaultPolicy();
      let result: boolean = instance.canOverflow(overflowInfoFalse9, cardDimension, formItemWidth, formItemHeight);
      expect(result).assertFalse();
    })

    it('test_OverflowDefaultPolicyTest_canOverflow_13', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowDefaultPolicy = new OverflowDefaultPolicy();
      let result: boolean = instance.canOverflow(overflowInfoFalse10, cardDimension, formItemWidth, formItemHeight);
      expect(result).assertFalse();
    })

    it('test_OverflowDefaultPolicyTest_canOverflow_14', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowDefaultPolicy = new OverflowDefaultPolicy();
      let result: boolean = instance.canOverflow(overflowInfoFalse11, cardDimension, formItemWidth, formItemHeight);
      expect(result).assertFalse();
    })

    it('test_OverflowDefaultPolicyTest_canOverflow_15', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowDefaultPolicy = new OverflowDefaultPolicy();
      let result: boolean = instance.canOverflow(overflowInfoFalse12, cardDimension, formItemWidth, formItemHeight);
      expect(result).assertFalse();
    })

    it('test_OverflowDefaultPolicyTest_canOverflow_16', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowDefaultPolicy = new OverflowDefaultPolicy();
      let result: boolean = instance.canOverflow(overflowInfoFalse13, cardDimension, formItemWidth, formItemHeight);
      expect(result).assertFalse();
    })

    it('test_OverflowDefaultPolicyTest_canOverflow_17', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowDefaultPolicy = new OverflowDefaultPolicy();
      let result: boolean = instance.canOverflow(overflowInfoFalse14, cardDimension, formItemWidth, formItemHeight);
      expect(result).assertFalse();
    })

    it('test_OverflowDefaultPolicyTest_canOverflow_18', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowDefaultPolicy = new OverflowDefaultPolicy();
      let result: boolean = instance.canOverflow(overflowInfoFalse15, cardDimension, formItemWidth, formItemHeight);
      expect(result).assertFalse();
    })

    it('test_OverflowDefaultPolicyTest_canOverflow_19', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowDefaultPolicy = new OverflowDefaultPolicy();
      let result: boolean = instance.canOverflow(overflowInfoFalse16, cardDimension, formItemWidth, formItemHeight);
      expect(result).assertFalse();
    })

    it('test_OverflowDefaultPolicyTest_canOverflow_20', TestType.FUNCTION | Level.LEVEL0, () => {
      let instance: OverflowDefaultPolicy = new OverflowDefaultPolicy();
      let result: boolean = instance.canOverflow(overflowInfoTrue, cardDimension, formItemWidth, formItemHeight);
      expect(result).assertTrue();
    })
  })
}
