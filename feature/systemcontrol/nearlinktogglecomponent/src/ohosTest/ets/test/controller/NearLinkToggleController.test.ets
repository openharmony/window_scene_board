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
import NearLinkManager from '../../../../main/ets/com/ohos/controller/NearLinkManager';
import NearLinkToggleController from '../../../../main/ets/com/ohos/controller/NearLinkToggleController';

export function NearLinkToggleControllerTest() {
  let mocker: MockKit;
  describe('NearLinkToggleControllerTest', (): void => {
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

    it('NearLinkToggleControllerClickTest', 0, (): void => {
      expect(new NearLinkToggleController().handleOneClick()).assertTrue();
    })

    it('NearLinkToggleControllerLongClickTest', 0, (): void => {
      expect(new NearLinkToggleController().isAvailable()).assertTrue();
    })

    it('PowerSavingToggleControllerIsLoadLottieTest', 0, (): void => {
      expect(new NearLinkToggleController().isLoadLottie()).assertTrue();
    })

    it('PowerSavingToggleControllerIsDarkReverseTest', 0, (): void => {
      new NearLinkToggleController().onStart();
      expect(new NearLinkToggleController().isDarkReverse()).assertTrue();
    })

    it('nearLinkManagerTest', 0, async (): Promise<void> => {
      const nearLinkManager = await NearLinkManager.getInstance();
      nearLinkManager.subscribeNearLinkState(()=>{});
      nearLinkManager.unSubscribeNearLinkState();
      nearLinkManager.changeNearLinkStateConcurrent(true);
      let nearLinkState = nearLinkManager.getNearLinkState();
      expect(nearLinkState !== undefined).assertTrue();
    })
  })
}