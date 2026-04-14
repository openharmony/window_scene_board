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
import { MusicServiceController } from '../../../../main/ets/com/ohos/controller/MusicServiceToggleController';

export function MusicServiceToggleControllerTest() {
  let mocker: MockKit;
  describe('MusicServiceToggleControllerTest', (): void => {
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

    it('MusicServiceToggleControllerTest', 0, (): void => {
      expect(MusicServiceController.getInstance().handleOneClick()).assertTrue();
    })

    it('MusicServiceToggleControllerLongClickTest', 0, (): void => {
      expect(MusicServiceController.getInstance().handleLongClick()).assertTrue();
    })

    it('MusicServiceToggleControllerIsLoadLottieTest', 0, (): void => {
      expect(MusicServiceController.getInstance().isLoadLottie()).assertTrue();
    })

    it('MusicServiceToggleControllerIsDarkReverseTest', 0, (): void => {
      let controllerInstance = MusicServiceController.getInstance();
      controllerInstance.onStart();
      expect(controllerInstance.isDarkReverse()).assertTrue();
    })
  })
}