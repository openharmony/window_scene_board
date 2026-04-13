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
import { MeetingToggleController } from '../../../../main/ets/com/ohos/controller/MeetingToggleController';

const sMeetingToggleController: MeetingToggleController = MeetingToggleController.getInstance();

export function MeetingToggleControllerTest() {
  let mocker: MockKit;

  describe('MeetingToggleControllerTest', (): void => {
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

    it('MeetingToggleControllerIsLoadLottieTest', 0, (): void => {
      expect(sMeetingToggleController.isLoadLottie()).assertTrue();
    })

    it('MeetingToggleControllerIsDarkReverseTest', 0, (): void => {
      expect(sMeetingToggleController.isDarkReverse()).assertTrue();
    })

    it('MeetingToggleControllerIsAvailableTest', 0, (): void => {
      expect(sMeetingToggleController.isAvailable()).assertTrue();
    })

    it('MeetingToggleControllerClickTest', 0, (): void => {
      expect(sMeetingToggleController.handleOneClick()).assertTrue();
    })

    it('MeetingToggleControllerLongClickTest', 0, (): void => {
      expect(sMeetingToggleController.handleLongClick()).assertTrue();
    })

    it('MeetingToggleControllerLabelClickTest', 0, (): void => {
      expect(sMeetingToggleController.handleLabelClick()).assertTrue();
    })
  })
}