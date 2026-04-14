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

import { afterAll, afterEach, beforeEach, it, describe, expect } from '@ohos/hypium';
import {
  PageMode,
  sPrivacySubLayoutController
} from '../../../../../../main/ets/com/ohos/controller/PrivacySubPageLayoutController';

export function PrivacySubLayoutControllerTest() {

  describe('PrivacySubLayoutControllerTest', (): void => {

    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('HideWindowTest', 0, (): void => {
      sPrivacySubLayoutController.hideWindow();
      expect(sPrivacySubLayoutController.getPageMode() === PageMode.NONE).assertTrue();
    })

    it('ShowWindowTest', 0, (): void => {
      sPrivacySubLayoutController.showWindow();
      expect(sPrivacySubLayoutController.getPageMode() === PageMode.DETAIL).assertTrue();
    })

    it('BackPressTest001', 0, (): void => {
      sPrivacySubLayoutController.onBackPress();
      expect(sPrivacySubLayoutController.getPageMode() === PageMode.NONE).assertTrue();
    })

    it('BackPressTest002', 0, (): void => {
      (sPrivacySubLayoutController as object)['pageMode'] = PageMode.NONE;
      sPrivacySubLayoutController.onBackPress();
      expect(sPrivacySubLayoutController.getPageMode() === PageMode.NONE).assertTrue();
    })


    it('onRemoteReady', 0, () => {
      (sPrivacySubLayoutController as object)['pageMode'] = PageMode.NONE;
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      sPrivacySubLayoutController.onRemoteReady(null);
      expect(sPrivacySubLayoutController !== null).assertTrue();
    })

    it('onRemoteReadyPC', 0, () => {
      (sPrivacySubLayoutController as object)['pageMode'] = PageMode.NONE;
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      sPrivacySubLayoutController.onRemoteReadyPC(null, 0);
      expect(sPrivacySubLayoutController !== null).assertTrue();
    })

    it('ScreenOffTest', 0, (): void => {
      sPrivacySubLayoutController.onScreenOff();
      expect(sPrivacySubLayoutController.getPageMode() === PageMode.NONE).assertTrue();
    })
  })
}