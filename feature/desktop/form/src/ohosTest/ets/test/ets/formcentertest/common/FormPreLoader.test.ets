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

import { afterAll, afterEach, beforeAll, beforeEach,
  it, describe, expect, Level, TestType,
  MockKit, when
} from '@ohos/hypium';
import { CommonConstants } from '@ohos/launchercommon';
import { layoutConfigManager } from '@ohos/launchercommon';
import { formPreLoader } from '../../../../../../../src/main/ets/default/common/FormPreLoader';
import FeatureConstants from '../../../../../../main/ets/default/common/constants/FeatureConstants';

export function FormPreLoaderTest() {
  describe('FormPreLoaderTest', ()=> {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('releaseConfigAndData', TestType.FUNCTION | Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let mockRemoveConfigFromManager: Function = mocker.mockFunc(layoutConfigManager,
        layoutConfigManager.removeConfigFromManager);
      let called: boolean = false;
      when(mockRemoveConfigFromManager)().afterAction(() => { called = true; });

      formPreLoader.releaseConfigAndData();
      expect(called).assertEqual(true);
    });
  })
}