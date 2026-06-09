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
import { afterAll, afterEach, beforeEach, it, describe, expect } from '@ohos/hypium';
import {
  MultiWindowToggleController
} from '../../../../../../main/ets/com/ohos/controller/MultiWindowToggleController';

export function MultiWindowToggleControllerTest() {

  describe('MultiWindowToggleControllerTest', (): void => {

    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('MultiWindowToggleControllerTest_001', 0, (): void => {
      let multiWindowToggleController = MultiWindowToggleController.getInstance();
      multiWindowToggleController.init();
      expect(multiWindowToggleController.getViewData()).not().assertNull();
      expect(multiWindowToggleController.isAvailable()).assertFalse();
      multiWindowToggleController.getViewData().isOn = true;
      let ret = multiWindowToggleController.handleOneClick();
      multiWindowToggleController.getViewData().isOn = false;
      let ret2 = multiWindowToggleController.handleOneClick();
      expect(multiWindowToggleController.isAvailable()).assertFalse();
      multiWindowToggleController.unInit();
    })
  })
}
