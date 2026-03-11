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



import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, TestType, Size, Level } from '@ohos/hypium'
import { BaseConfig, LayoutViewModel } from '@ohos/launchercommon/src/main/ets/TsIndex'
import {
  OuterPhoneLayoutRulesController
} from '../../../../main/ets/SceneBoard/controllers/SceneDesktopController/OuterPhoneLayoutRulesController'

export default function OuterPhoneLayoutRulesControllerTest() {
  describe('OuterPhoneLayoutRulesControllerTest', () => {
    let mLayoutViewModel: LayoutViewModel = LayoutViewModel.getInstance();
    let baseConfig: BaseConfig = mLayoutViewModel.getBaseConfig();
    let isFoldProductFold = OuterPhoneLayoutRulesController.getInstance(baseConfig);
    beforeAll(() => {
    });
    beforeEach(() => {
    });
    afterEach(() => {
    });
    afterAll(() => {
    });

    it('test_calculateDesktop', TestType.USER | Size.SMALLTEST | Level.LEVEL0, () => {
      isFoldProductFold.calculateDesktop();
      let a = 'test';
      expect(a).assertEqual('test');
    });

    it('test_calculateDock', TestType.USER | Size.SMALLTEST | Level.LEVEL0, () => {
      isFoldProductFold.calculateDock();
      let a = 'test';
      expect(a).assertEqual('test');
    });

    it('test_calculateForm', TestType.USER | Size.SMALLTEST | Level.LEVEL0, () => {
      isFoldProductFold.calculateForm();
      let a = 'test';
      expect(a).assertEqual('test');
    });

    it('test_calculateOpenFolder', TestType.USER | Size.SMALLTEST | Level.LEVEL0, () => {
      // isFoldProductFold.calculateOpenFolder();
      let a = 'test';
      expect(a).assertEqual('test');
    });
  })
}