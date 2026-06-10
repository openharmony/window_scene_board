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
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, MockKit, expect } from '@ohos/hypium';
import { DpinToggleController } from '../../../../main/ets/com/ohos/controller/DpinToggleController';

const sDpinToggleController: DpinToggleController = DpinToggleController.getInstance();

export function DpinToggleControllerTest() {
  let mocker: MockKit;

  describe('DpinToggleControllerTest', (): void => {
    beforeEach((): void => {

    })
    beforeAll(() => {
      mocker = new MockKit();
    })
    afterEach((): void => {

    })
    afterAll((): void => {
      mocker.clearAll();
    })

    it('DpinToggleControllerIsLoadLottieTest', 0, (): void => {
      expect(sDpinToggleController.isLoadLottie()).assertTrue();
    })

    it('DpinToggleControllerIsDarkReverseTest', 0, (): void => {
      expect(sDpinToggleController.isDarkReverse()).assertTrue();
    })

    it('DpinToggleControllerIsAvailableTest', 0, (): void => {
      expect(sDpinToggleController.isAvailable()).assertTrue();
    })

    it('DpinToggleControllerClickTest', 0, (): void => {
      expect(sDpinToggleController.handleOneClick()).assertTrue();
    })

    it('DpinToggleControllerLongClickTest', 0, (): void => {
      expect(sDpinToggleController.handleLongClick()).assertTrue();
    })

    it('DpinToggleControllerLabelClickTest', 0, (): void => {
      expect(sDpinToggleController.handleLabelClick()).assertTrue();
    })
  })
}