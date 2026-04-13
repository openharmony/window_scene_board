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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when, ArgumentMatchers } from '@ohos/hypium'
import { SimCardUtils } from '../../../../../main/ets/utils/SimCardUtils'
import { ArrayList } from '@kit.ArkTS'
import { SimCardVerifyService, PinVerifyState, PukVerifyState, SimCardVerifyCallback } from '../../../../../main/ets/services/SimCardVerifyService'
import { SimCardStateManager } from '../../../../../main/ets/TsIndex'


export default function SimCardVerifyServiceTest() {
  describe('SimCardVerifyServiceTest', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })
    let simCardCallBack: SimCardVerifyCallback = {
      onPinVerifyCallback: (state: PinVerifyState): void => { },
      onPukVerifyCallback: (state: PukVerifyState, psd?: string | undefined): void => { }
    };

    it('SimCardVerifyServiceTest_unlockSimCard_001', Level.LEVEL0, () => {
      let simCard = SimCardVerifyService.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(SimCardStateManager.getInstance(), SimCardStateManager.getInstance().isPinLocked);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let result = simCard.unlockSimCard(true, '1', simCardCallBack);
      expect(result == null).assertTrue();

      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      const mockFunc1: Function = mocker.mockFunc(SimCardStateManager.getInstance(), SimCardStateManager.getInstance().isPukLocked);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      result = simCard.unlockSimCard(true, '1', simCardCallBack);
      expect(result == null).assertTrue();

      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      result = simCard.unlockSimCard(true, '1', simCardCallBack);
      expect(result == null).assertTrue();

      mocker.clear(SimCardStateManager.getInstance());
      mocker.clearAll();
    })

    it('SimCardVerifyServiceTest_isSupport_002', Level.LEVEL0, () => {
      let simCard = SimCardVerifyService.getInstance();
      let result = simCard['isSupport']();
      expect(result).assertTrue();
    })

    it('SimCardVerifyServiceTest_doInit_003', Level.LEVEL0, () => {
      let simCard = SimCardVerifyService.getInstance();
      let result = simCard['doInit']();
      expect(result == null).assertTrue();
    })

    it('SimCardVerifyServiceTest_doRelease_004', Level.LEVEL0, () => {
      let simCard = SimCardVerifyService.getInstance();
      let result = simCard['doRelease']();
      expect(result == null).assertTrue();
    })

    it('SimCardVerifyServiceTest_verifyPin_005', Level.LEVEL0, () => {
      let simCard = SimCardVerifyService.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(SimCardUtils, SimCardUtils.isValidPin);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let result = simCard['verifyPin'](true, 1, 'test1234', simCardCallBack);
      expect(result == null).assertTrue();

      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      result = simCard['verifyPin'](true, 1, 'test1234', simCardCallBack);
      expect(result == null).assertTrue();

      mocker.clear(SimCardUtils);
      mocker.clearAll();
    })

    it('SimCardVerifyServiceTest_verifyPuk_006', Level.LEVEL0, () => {
      let simCard = SimCardVerifyService.getInstance();
      let result = simCard['verifyPuk'](true, 1, 'test1234', simCardCallBack);
      expect(result == null).assertTrue();

      let array: ArrayList<string> = new ArrayList();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(SimCardUtils, SimCardUtils.isValidPukCode);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      result = simCard['verifyPuk'](true, 1, 'test1234', simCardCallBack, array);
      expect(result == null).assertTrue();

      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      result = simCard['verifyPuk'](true, 1, 'test1234', simCardCallBack, array);
      expect(result == null).assertTrue();

      array.add('test1');
      const mockFunc0: Function = mocker.mockFunc(SimCardUtils, SimCardUtils.isValidPin);
      when(mockFunc0)(ArgumentMatchers.any).afterReturn(false);
      result = simCard['verifyPuk'](true, 1, 'test1234', simCardCallBack, array);
      expect(result == null).assertTrue();

      array.add('test2');
      const mockFunc1: Function = mocker.mockFunc(SimCardUtils, SimCardUtils.isMatchedPin);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      result = simCard['verifyPuk'](true, 1, 'test1234', simCardCallBack, array);
      expect(result == null).assertTrue();

      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      result = simCard['verifyPuk'](true, 1, 'test1234', simCardCallBack, array);
      expect(result == null).assertTrue();

      array.add('test3');
      result = simCard['verifyPuk'](true, 1, 'test1234', simCardCallBack, array);
      expect(result == null).assertTrue();

      mocker.clear(SimCardUtils);
      mocker.clearAll();
    })

    it('SimCardVerifyServiceTest_unlockPukInner_007', Level.LEVEL0, () => {
      let simCard = SimCardVerifyService.getInstance();
      let array: ArrayList<string> = new ArrayList();
      let result = simCard['unlockPukInner'](true, 1, 'test1234', simCardCallBack, array);
      expect(result == null).assertTrue();
    })

  })
}