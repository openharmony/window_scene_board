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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, Level, TestType,
  MockKit,
  when
} from '@ohos/hypium';
import { CommonConstants } from '@ohos/launchercommon';
import { FormDetailLayoutConfig } from '../../../../../../main/ets/default/common/FormDetailLayoutConfig';
import FeatureConstants from '../../../../../../main/ets/default/common/constants/FeatureConstants';

export function FormDetailLayoutConfigTest() {
  describe('FormDetailLayoutConfigTest', ()=> {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('initConfig', TestType.FUNCTION | Level.LEVEL0, () => {
      const config: FormDetailLayoutConfig = FormDetailLayoutConfig.getInstance();

      let called: boolean = false;
      const mocker: MockKit = new MockKit();
      let mockInitConfig: Function = mocker.mockFunc(config, config.initConfig);
      when(mockInitConfig)().afterAction(() => { called = true; });
      FormDetailLayoutConfig.getInstance();
      expect(called).assertEqual(false);
      mocker.clear(config);
      mocker.clearAll();
    });

    it('FormDetailLayoutConfigTest_getConfigLevel', TestType.FUNCTION | Level.LEVEL0, () => {
      expect(FormDetailLayoutConfig.getInstance().getConfigLevel())
        .assertEqual(CommonConstants.LAYOUT_CONFIG_LEVEL_FEATURE);
    });

    it('FormDetailLayoutConfigTest_getFeatureName', TestType.FUNCTION | Level.LEVEL0, () => {
      expect(FormDetailLayoutConfig.getInstance().getFeatureName())
        .assertEqual(FeatureConstants.FEATURE_NAME);
    });
  })
}