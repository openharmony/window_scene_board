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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit } from '@ohos/hypium';
import { ImmersiveCardHandle } from '../../../../../../main/ets/viewmodel/viewevent/ImmersiveCardHandle';
import { immersiveVm } from '../../../../../../main/ets/viewmodel/ImmersiveVm';
import { ImmersiveCardVm } from '../../../../../../main/ets/viewmodel/ImmersiveCardVm';
import { ImmersiveAnimManager } from '../../../../../../main/ets/viewmodel/viewanim/ImmersiveAnimManager';
import { ImmersiveState, ImmersiveType, ImmersiveTypeScene } from '@ohos/systemuicommon';
import { immersiveKgMgr } from '@ohos/systemuicommon';

/**
 * 沉浸式锁屏测试用例
 */
export function ImmersiveCardHandleTest() {
  let mocker: MockKit;
  describe('ImmersiveCardHandleTest', (): void => {
    beforeAll((): void => {
      mocker = new MockKit();
    });
    beforeEach((): void => {

    });
    afterAll((): void => {
      mocker.clearAll();
    });
    afterEach((): void => {

    });

    it('test_execCardToCapsuleAnim', Level.LEVEL0, (): void => {
      let cardVm: ImmersiveCardVm = immersiveVm.getImmersiveCardVm();
      let manager: ImmersiveAnimManager = new ImmersiveAnimManager();
      let cardHandle: ImmersiveCardHandle = new ImmersiveCardHandle();
      cardHandle.execCardToCapsuleAnim();
      expect(cardHandle).not().assertNull();
    });

    it('test_execCardToListAnim', Level.LEVEL0, (): void => {
      let cardVm: ImmersiveCardVm = immersiveVm.getImmersiveCardVm();
      let manager: ImmersiveAnimManager = new ImmersiveAnimManager();
      let cardHandle: ImmersiveCardHandle = new ImmersiveCardHandle();
      cardHandle.execCardToListAnim();
      expect(cardHandle).not().assertNull();
    });

  });
}
