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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { BitUtil } from '../../../main/ets/utils/BitUtil';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NtfControlFlags } from '../../../main/ets/model/NtfControlFlags';
export default function NtfControlFlagsTest() {
  describe('parse_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_true_when_bit_is_set_in_flags', 0, () => {
      let flags: number = 0b10; // 10 in binary is 1010
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT1;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertTrue();
    });

    it('should_return_false_when_bit_is_not_set_in_flags', 0, () => {
      let flags: number = 0b10; // 10 in binary is 1010
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT2;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertFalse();
    });

    it('should_return_true_when_flags_is_zero_and_idx_is_also_zero', 0, () => {
      let flags: number = 0;
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT0;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertTrue();
    });

    it('should_return_false_when_flags_is_zero_and_idx_is_not_zero', 0, () => {
      let flags: number = 0;
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT2;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertFalse();
    });

    it('should_return_true_when_flags_is_max_value_and_idx_is_valid', 0, () => {
      let flags: number = 0b1111111111111111; // 65535 in binary is 1111111111111111
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT15;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertTrue();
    });

    it('should_return_false_when_flags_is_max_value_and_idx_is_invalid', 0, () => {
      let flags: number = 0b1111111111111111; // 65535 in binary is 1111111111111111
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT16;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertFalse();
    });

    it('should_return_true_when_extra_screen_is_on', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(1);
      let result: boolean = ntfcontrolconfig.isExtraScreenOn();
      expect(result).assertTrue();
    });

    it('should_return_false_when_extra_screen_is_off', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(0);
      let result: boolean = ntfcontrolconfig.isExtraScreenOn();
      expect(result).assertFalse();
    });

    it('should_return_true_when_extra_screen_is_on_despite_other_flags_are_set', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(0b1111);
      let result: boolean = ntfcontrolconfig.isExtraScreenOn();
      expect(result).assertTrue();
    });

    it('should_return_false_when_extra_screen_is_off_despite_other_flags_are_set', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(0b1100);
      let result: boolean = ntfcontrolconfig.isExtraScreenOn();
      expect(result).assertFalse();
    });

    it('should_return_false_when_CUSTOM_VIBRATION_is_not_set', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(0);
      let result = ntfcontrolconfig.isCustomVibration();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_CUSTOM_VIBRATION_is_set', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(BitUtil.setBit(0, NtfControlFlagIdxEnum.CUSTOM_VIBRATION));
      let result = ntfcontrolconfig.isCustomVibration();
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_bit_is_set_in_flags', 0, () => {
      let flags: number = 0b10; // 10 in binary is 1010
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT1;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertTrue();
    });

    it('should_return_false_when_bit_is_not_set_in_flags', 0, () => {
      let flags: number = 0b10; // 10 in binary is 1010
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT2;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertFalse();
    });

    it('should_return_true_when_flags_is_zero_and_idx_is_also_zero', 0, () => {
      let flags: number = 0;
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT0;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertTrue();
    });

    it('should_return_false_when_flags_is_zero_and_idx_is_not_zero', 0, () => {
      let flags: number = 0;
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT2;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertFalse();
    });

    it('should_return_true_when_flags_is_max_value_and_idx_is_valid', 0, () => {
      let flags: number = 0b1111111111111111; // 65535 in binary is 1111111111111111
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT15;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertTrue();
    });

    it('should_return_false_when_flags_is_max_value_and_idx_is_invalid', 0, () => {
      let flags: number = 0b1111111111111111; // 65535 in binary is 1111111111111111
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT16;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertFalse();
    });

    it('should_return_true_when_extra_screen_is_on', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(1);
      let result: boolean = ntfcontrolconfig.isExtraScreenOn();
      expect(result).assertTrue();
    });

    it('should_return_false_when_extra_screen_is_off', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(0);
      let result: boolean = ntfcontrolconfig.isExtraScreenOn();
      expect(result).assertFalse();
    });

    it('should_return_true_when_extra_screen_is_on_despite_other_flags_are_set', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(0b1111);
      let result: boolean = ntfcontrolconfig.isExtraScreenOn();
      expect(result).assertTrue();
    });

    it('should_return_false_when_extra_screen_is_off_despite_other_flags_are_set', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(0b1100);
      let result: boolean = ntfcontrolconfig.isExtraScreenOn();
      expect(result).assertFalse();
    });

    it('should_return_false_when_CUSTOM_VIBRATION_is_not_set', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(0);
      let result = ntfcontrolconfig.isCustomVibration();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_CUSTOM_VIBRATION_is_set', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(BitUtil.setBit(0, NtfControlFlagIdxEnum.CUSTOM_VIBRATION));
      let result = ntfcontrolconfig.isCustomVibration();
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_bit_is_set_in_flags', 0, () => {
      let flags: number = 0b10; // 10 in binary is 1010
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT1;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertTrue();
    });

    it('should_return_false_when_bit_is_not_set_in_flags', 0, () => {
      let flags: number = 0b10; // 10 in binary is 1010
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT2;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertFalse();
    });

    it('should_return_true_when_flags_is_zero_and_idx_is_also_zero', 0, () => {
      let flags: number = 0;
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT0;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertTrue();
    });

    it('should_return_false_when_flags_is_zero_and_idx_is_not_zero', 0, () => {
      let flags: number = 0;
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT2;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertFalse();
    });

    it('should_return_true_when_flags_is_max_value_and_idx_is_valid', 0, () => {
      let flags: number = 0b1111111111111111; // 65535 in binary is 1111111111111111
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT15;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertTrue();
    });

    it('should_return_false_when_flags_is_max_value_and_idx_is_invalid', 0, () => {
      let flags: number = 0b1111111111111111; // 65535 in binary is 1111111111111111
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT16;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertFalse();
    });

    it('should_return_true_when_extra_screen_is_on', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(1);
      let result: boolean = ntfcontrolconfig.isExtraScreenOn();
      expect(result).assertTrue();
    });

    it('should_return_false_when_extra_screen_is_off', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(0);
      let result: boolean = ntfcontrolconfig.isExtraScreenOn();
      expect(result).assertFalse();
    });

    it('should_return_true_when_extra_screen_is_on_despite_other_flags_are_set', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(0b1111);
      let result: boolean = ntfcontrolconfig.isExtraScreenOn();
      expect(result).assertTrue();
    });

    it('should_return_false_when_extra_screen_is_off_despite_other_flags_are_set', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(0b1100);
      let result: boolean = ntfcontrolconfig.isExtraScreenOn();
      expect(result).assertFalse();
    });

    it('should_return_false_when_CUSTOM_VIBRATION_is_not_set', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(0);
      let result = ntfcontrolconfig.isCustomVibration();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_CUSTOM_VIBRATION_is_set', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(BitUtil.setBit(0, NtfControlFlagIdxEnum.CUSTOM_VIBRATION));
      let result = ntfcontrolconfig.isCustomVibration();
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_bit_is_set_in_flags', 0, () => {
      let flags: number = 0b10; // 10 in binary is 1010
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT1;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertTrue();
    });

    it('should_return_false_when_bit_is_not_set_in_flags', 0, () => {
      let flags: number = 0b10; // 10 in binary is 1010
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT2;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertFalse();
    });

    it('should_return_true_when_flags_is_zero_and_idx_is_also_zero', 0, () => {
      let flags: number = 0;
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT0;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertTrue();
    });

    it('should_return_false_when_flags_is_zero_and_idx_is_not_zero', 0, () => {
      let flags: number = 0;
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT2;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertFalse();
    });

    it('should_return_true_when_flags_is_max_value_and_idx_is_valid', 0, () => {
      let flags: number = 0b1111111111111111; // 65535 in binary is 1111111111111111
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT15;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertTrue();
    });

    it('should_return_false_when_flags_is_max_value_and_idx_is_invalid', 0, () => {
      let flags: number = 0b1111111111111111; // 65535 in binary is 1111111111111111
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT16;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertFalse();
    });

    it('should_return_true_when_extra_screen_is_on', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(1);
      let result: boolean = ntfcontrolconfig.isExtraScreenOn();
      expect(result).assertTrue();
    });

    it('should_return_false_when_extra_screen_is_off', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(0);
      let result: boolean = ntfcontrolconfig.isExtraScreenOn();
      expect(result).assertFalse();
    });

    it('should_return_true_when_extra_screen_is_on_despite_other_flags_are_set', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(0b1111);
      let result: boolean = ntfcontrolconfig.isExtraScreenOn();
      expect(result).assertTrue();
    });

    it('should_return_false_when_extra_screen_is_off_despite_other_flags_are_set', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(0b1100);
      let result: boolean = ntfcontrolconfig.isExtraScreenOn();
      expect(result).assertFalse();
    });

    it('should_return_false_when_CUSTOM_VIBRATION_is_not_set', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(0);
      let result = ntfcontrolconfig.isCustomVibration();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_CUSTOM_VIBRATION_is_set', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(BitUtil.setBit(0, NtfControlFlagIdxEnum.CUSTOM_VIBRATION));
      let result = ntfcontrolconfig.isCustomVibration();
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_bit_is_set_in_flags', 0, () => {
      let flags: number = 0b10; // 10 in binary is 1010
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT1;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertTrue();
    });

    it('should_return_false_when_bit_is_not_set_in_flags', 0, () => {
      let flags: number = 0b10; // 10 in binary is 1010
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT2;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertFalse();
    });

    it('should_return_true_when_flags_is_zero_and_idx_is_also_zero', 0, () => {
      let flags: number = 0;
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT0;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertTrue();
    });

    it('should_return_false_when_flags_is_zero_and_idx_is_not_zero', 0, () => {
      let flags: number = 0;
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT2;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertFalse();
    });

    it('should_return_true_when_flags_is_max_value_and_idx_is_valid', 0, () => {
      let flags: number = 0b1111111111111111; // 65535 in binary is 1111111111111111
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT15;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertTrue();
    });

    it('should_return_false_when_flags_is_max_value_and_idx_is_invalid', 0, () => {
      let flags: number = 0b1111111111111111; // 65535 in binary is 1111111111111111
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT16;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertFalse();
    });

    it('should_return_true_when_extra_screen_is_on', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(1);
      let result: boolean = ntfcontrolconfig.isExtraScreenOn();
      expect(result).assertTrue();
    });

    it('should_return_false_when_extra_screen_is_off', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(0);
      let result: boolean = ntfcontrolconfig.isExtraScreenOn();
      expect(result).assertFalse();
    });

    it('should_return_true_when_extra_screen_is_on_despite_other_flags_are_set', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(0b1111);
      let result: boolean = ntfcontrolconfig.isExtraScreenOn();
      expect(result).assertTrue();
    });

    it('should_return_false_when_extra_screen_is_off_despite_other_flags_are_set', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(0b1100);
      let result: boolean = ntfcontrolconfig.isExtraScreenOn();
      expect(result).assertFalse();
    });

    it('should_return_false_when_CUSTOM_VIBRATION_is_not_set', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(0);
      let result = ntfcontrolconfig.isCustomVibration();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_CUSTOM_VIBRATION_is_set', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(BitUtil.setBit(0, NtfControlFlagIdxEnum.CUSTOM_VIBRATION));
      let result = ntfcontrolconfig.isCustomVibration();
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_bit_is_set_in_flags', 0, () => {
      let flags: number = 0b10; // 10 in binary is 1010
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT1;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertTrue();
    });

    it('should_return_false_when_bit_is_not_set_in_flags', 0, () => {
      let flags: number = 0b10; // 10 in binary is 1010
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT2;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertFalse();
    });

    it('should_return_true_when_flags_is_zero_and_idx_is_also_zero', 0, () => {
      let flags: number = 0;
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT0;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertTrue();
    });

    it('should_return_false_when_flags_is_zero_and_idx_is_not_zero', 0, () => {
      let flags: number = 0;
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT2;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertFalse();
    });

    it('should_return_true_when_flags_is_max_value_and_idx_is_valid', 0, () => {
      let flags: number = 0b1111111111111111; // 65535 in binary is 1111111111111111
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT15;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertTrue();
    });

    it('should_return_false_when_flags_is_max_value_and_idx_is_invalid', 0, () => {
      let flags: number = 0b1111111111111111; // 65535 in binary is 1111111111111111
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT16;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertFalse();
    });

    it('should_return_true_when_extra_screen_is_on', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(1);
      let result: boolean = ntfcontrolconfig.isExtraScreenOn();
      expect(result).assertTrue();
    });

    it('should_return_false_when_extra_screen_is_off', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(0);
      let result: boolean = ntfcontrolconfig.isExtraScreenOn();
      expect(result).assertFalse();
    });

    it('should_return_true_when_extra_screen_is_on_despite_other_flags_are_set', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(0b1111);
      let result: boolean = ntfcontrolconfig.isExtraScreenOn();
      expect(result).assertTrue();
    });

    it('should_return_false_when_extra_screen_is_off_despite_other_flags_are_set', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(0b1100);
      let result: boolean = ntfcontrolconfig.isExtraScreenOn();
      expect(result).assertFalse();
    });

    it('should_return_false_when_CUSTOM_VIBRATION_is_not_set', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(0);
      let result = ntfcontrolconfig.isCustomVibration();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_CUSTOM_VIBRATION_is_set', 0, () => {
      let ntfcontrolconfig: NtfControlConfig = new NtfControlConfig(BitUtil.setBit(0, NtfControlFlagIdxEnum.CUSTOM_VIBRATION));
      let result = ntfcontrolconfig.isCustomVibration();
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_bit_is_set_in_flags', 0, () => {
      let flags: number = 0b10; // 10 in binary is 1010
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT1;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertTrue();
    });

    it('should_return_false_when_bit_is_not_set_in_flags', 0, () => {
      let flags: number = 0b10; // 10 in binary is 1010
      let idx: NtfControlFlagIdxEnum = NtfControlFlagIdxEnum.BIT2;
      const result = NtfControlFlags.parse(flags, idx);
      expect(result).assertFalse();
    });
  });
}
