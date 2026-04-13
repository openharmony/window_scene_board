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
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, MockKit, expect } from '@ohos/hypium';
import AntiPeepingToggleController from '../../../../main/ets/com/ohos/controller/AntiPeepingToggleController';

export function AntiPeepingToggleControllerTest() {
  let mocker: MockKit;
  let sAntiPeepingToggleController: AntiPeepingToggleController;

  describe('AntiPeepingToggleControllerTest', (): void => {
    beforeEach((): void => {

    })
    beforeAll(() => {
      mocker = new MockKit();
      sAntiPeepingToggleController = new AntiPeepingToggleController();
    })
    afterEach((): void => {

    })
    afterAll((): void => {
      mocker.clearAll();
    })

    it('AntiPeepingToggleControllerClickTest', 0, (): void => {
      expect(sAntiPeepingToggleController.handleOneClick()).assertTrue();
    })
  })
}