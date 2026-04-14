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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { ParamHelper } from '../../../../../../main/ets/buildernode/BaseNodeParams'
import { BaseNodeParams } from '../../../../../../main/ets/TsIndex'

export default function BaseNodeParamsTest() {
  describe('BaseNodeParamsTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('assertEqual', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let a = 'test'
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test')
    })

    it('text_BaseNodeParams_setUpdatePropertyValue', 0, (): void => {
      let baseNodeParams: BaseNodeParams = new BaseNodeParams();
      baseNodeParams.setUpdatePropertyValue('996');
      expect(baseNodeParams).not().assertNull();
    });

    it('text_BaseNodeParams_getUpdatePropertyValue', 0, (): void => {
      let baseNodeParams: BaseNodeParams = new BaseNodeParams();
      baseNodeParams.getUpdatePropertyValue('996');
      expect(baseNodeParams).not().assertNull();
    });

    it('text_BaseNodeParams_getNeedUpdateParamsMap', 0, (): void => {
      let baseNodeParams: BaseNodeParams = new BaseNodeParams();
      baseNodeParams.getNeedUpdateParamsMap();
      expect(baseNodeParams).not().assertNull();
    });

    it('text_BaseNodeParams_getUpdateParamsList', 0, (): void => {
      let baseNodeParams: BaseNodeParams = new BaseNodeParams();
      let result: string[] = baseNodeParams.getUpdateParamsList();
      expect(result.length).assertEqual(0);
    });

    it('text_BaseNodeParams_setParamsValue', 0, (): void => {
      let paramHelper: ParamHelper = new ParamHelper();
      ParamHelper.setParamsValue('996', '007');
      expect(paramHelper).not().assertNull();
      ParamHelper.setParamsValue('996', true);
      expect(paramHelper).not().assertNull();
      ParamHelper.setParamsValue('996', 7);
      expect(paramHelper).not().assertNull();
      ParamHelper.setParamsValue('996', new Object());
      expect(paramHelper).not().assertNull();
    });

    it('text_BaseNodeParams_getParamsValue', 0, (): void => {
      let paramHelper: ParamHelper = new ParamHelper();
      ParamHelper.getParamsValue('996');
      expect(paramHelper).not().assertNull();
    });

    it('text_BaseNodeParams_getParamsValue', 0, (): void => {
      let paramHelper: ParamHelper = new ParamHelper();
      ParamHelper.getParamsMap();
      expect(paramHelper).not().assertNull();
    });
  })
}