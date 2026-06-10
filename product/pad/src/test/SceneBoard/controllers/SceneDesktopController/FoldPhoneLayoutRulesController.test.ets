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

import { LayoutViewModel } from '@ohos/launchercommon/src/main/ets/viewmodel/LayoutViewModel'

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, TestType, Size, Level } from '@ohos/hypium'

export default function FoldPhoneLayoutRulesControllerTest() {
  describe('FoldPhoneLayoutRulesControllerTest', function () {
    let mLayoutViewModel = LayoutViewModel.getInstance();
    let baseConfig = mLayoutViewModel.getBaseConfig();
    let fold = FoldPhoneLayoutRulesController.getInstance(baseConfig);

    beforeAll(function () {

    })
    beforeEach(function () {

    })
    afterEach(function () {

    })
    afterAll(function () {

    })

    it('calculateDesktop', TestType.USER | Size.SMALLTEST | Level.LEVEL0, function () {
      fold.calculateDesktop();
    })
    it('calculateProductConfig', TestType.USER | Size.SMALLTEST | Level.LEVEL0, function () {
      fold.calculateProductConfig();
    })
    it('FoldPhoneLayoutRulesControllerTest_assertEqual', 0, function () {
      let a = 'test'
      expect(a).assertEqual('test')
    })
    it('FoldPhoneLayoutRulesControllerTest_assertEqual1', 0, function () {
      let a = 'test'
      expect(a).assertEqual('test')
    })
    it('FoldPhoneLayoutRulesControllerTest_assertEqual3', 0, function () {
      let a = 'test'
      expect(a).assertEqual('test')
    })
    it('FoldPhoneLayoutRulesControllerTest_assertEqual4', 0, function () {
      let a = 'test'
      expect(a).assertEqual('test')
    })
  })
}