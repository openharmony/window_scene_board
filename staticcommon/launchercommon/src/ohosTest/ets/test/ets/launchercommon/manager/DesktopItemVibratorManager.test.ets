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

import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import vibrator from '@ohos.vibrator';
import { DesktopItemVibratorManager } from '../../../../../../main/ets/manager/DesktopItemVibratorManager';
import { CommonConstants } from '../../../../../../main/ets/constants/CommonConstants';
import { vibratorMgr } from '../../../../../../main/ets/manager/VibratorManager';

/**
 * 桌面元素长按振动管理类的测试套
 */
export default function DesktopItemVibratorManagerTest() {
  describe('DesktopItemVibratorManagerTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('test_effectId', 0, () => {
      let effectId: string = '123';
      let defaultEffectId: string = CommonConstants.VIBRATION_EFFECT_MEDIUM;
      let tag: string = 'test';
      DesktopItemVibratorManager.getInstance().setEffectId(effectId, tag);
      expect(DesktopItemVibratorManager.getInstance().getEffectId()).assertEqual(effectId);
      DesktopItemVibratorManager.getInstance().resetEffectId();
      expect(DesktopItemVibratorManager.getInstance().getEffectId()).assertEqual(defaultEffectId);
    })

    it('test_longPressVibrator', 0, () => {
      let effectId1: string = '123';
      let effectId2: string = '456';
      let tag: string = 'test';
      let defaultUsageType: vibrator.Usage = CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS;
      let mocker: MockKit = new MockKit();
      mocker.mockFunc(vibratorMgr, vibratorMgr.startVibration);
      DesktopItemVibratorManager.getInstance().setEffectId(effectId1, tag);
      DesktopItemVibratorManager.getInstance().longPressVibrator(tag);
      mocker.verify('startVibration', [effectId1, defaultUsageType, tag]).once();
      DesktopItemVibratorManager.getInstance().longPressVibrator(tag, effectId2);
      mocker.verify('startVibration', [effectId2, defaultUsageType, tag]).once();
      mocker.clear(vibratorMgr);
      mocker.clearAll();
    })
  })
}
