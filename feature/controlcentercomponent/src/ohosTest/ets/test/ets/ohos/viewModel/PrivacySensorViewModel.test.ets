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

import { afterAll, afterEach, beforeEach, it, describe, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { PrivacySensorViewData } from '../../../../../../main/ets/com/ohos/model/PrivacySensorViewData';
import { PrivacySensorViewModel } from '../../../../../../main/ets/com/ohos/viewModel/PrivacySensorViewModel';
import { ConfigurationEvent } from '@ohos/frameworkwrapper';
import { bundleManager } from '@kit.AbilityKit';
import { AccessibilityUtil } from '@ohos/screenlockcommon/src/main/ets/utils/AccessibilityUtil';


export function PrivacySensorViewModelTest() {

  describe('PrivacySensorViewModelTest', (): void => {

    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('PrivacySensorViewModelInitData', 0, (): void => {
      let viewData = new PrivacySensorViewData();
      let viewMode = PrivacySensorViewModel.getInstance(viewData);
      viewMode.initData();
      expect(viewData.isApplicationInterview !== undefined).assertTrue();
    })

    it('PrivacySensorLanguageChangeTest', 0, (): void => {
      let viewData = new PrivacySensorViewData();
      let viewMode = PrivacySensorViewModel.getInstance(viewData);
      viewMode.languageChangeListener(new ConfigurationEvent());
      expect(viewData.isRTL != undefined).assertTrue();
    })

    it('PrivacySensorViewModelResetData', 0, (): void => {
      let viewData = new PrivacySensorViewData();
      let viewMode = PrivacySensorViewModel.getInstance(viewData);
      viewMode.resetData();
      expect(viewData.isApplicationInterview).assertFalse();
    })

    it("PrivacySensorViewModelTest_getPrivacySensorText_2", 0, async (done: Function) => {
      let viewData = new PrivacySensorViewData();
      let viewMode = PrivacySensorViewModel.getInstance(viewData);
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(AccessibilityUtil, AccessibilityUtil.isAccessibilityMode);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      viewMode.getPrivacySensorText('App');
      expect(viewMode.getPrivacySensorText('')).assertEqual('');
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      viewMode.getPrivacySensorText('App');
      expect(viewMode.getPrivacySensorText('')).assertEqual('');
      mocker.clear(AccessibilityUtil);
      done();
    })
  })
}