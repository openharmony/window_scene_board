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
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { BitUtil } from '../../../main/ets/utils/BitUtil';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NtfRemindFlags } from '../../../main/ets/model/NtfRemindFlags';
export default function NtfRemindFlagsTest() {
  describe('parse_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_true_when_bit_is_set_in_flags', 0, () => {
      let flags: number = 5; // 0101 in binary
      let idx: NtfRemindFlagIdxEnum = NtfRemindFlagIdxEnum.REMIND_FLAG_0;
      const result = NtfRemindFlags.parse(flags, idx);
      expect(result).assertTrue();
    });

    it('should_return_false_when_bit_is_not_set_in_flags', 0, () => {
      let flags: number = 4; // 0100 in binary
      let idx: NtfRemindFlagIdxEnum = NtfRemindFlagIdxEnum.REMIND_FLAG_1;
      const result = NtfRemindFlags.parse(flags, idx);
      expect(result).assertFalse();
    });

    it('should_return_true_when_flags_is_zero', 0, () => {
      let flags: number = 0;
      let idx: NtfRemindFlagIdxEnum = NtfRemindFlagIdxEnum.REMIND_FLAG_0;
      const result = NtfRemindFlags.parse(flags, idx);
      expect(result).assertFalse();
    });

    it('should_return_false_when_flags_is_zero', 0, () => {
      let flags: number = 0;
      let idx: NtfRemindFlagIdxEnum = NtfRemindFlagIdxEnum.REMIND_FLAG_1;
      const result = NtfRemindFlags.parse(flags, idx);
      expect(result).assertFalse();
    });

    it('should_return_true_when_sound_is_enabled', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(1);
      let result = ntfreminderconfig.isSoundEnable();
      expect(result).assertTrue();
    });

    it('should_return_false_when_sound_is_disabled', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(0);
      let result = ntfreminderconfig.isSoundEnable();
      expect(result).assertFalse();
    });

    it('should_return_true_when_sound_is_enabled_despite_other_flags_are_set', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(3);
      let result = ntfreminderconfig.isSoundEnable();
      expect(result).assertTrue();
    });

    it('should_return_false_when_sound_is_disabled_despite_other_flags_are_set', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(2);
      let result = ntfreminderconfig.isSoundEnable();
      expect(result).assertFalse();
    });

    it('should_return_true_when_banner_is_enabled', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(1);
      let result = ntfreminderconfig.isBannerEnable();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_banner_is_disabled', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(0);
      let result = ntfreminderconfig.isBannerEnable();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_banner_is_enabled_despite_other_flags_are_set', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(BitUtil.setBit(0, 2));
      let result = ntfreminderconfig.isBannerEnable();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_banner_is_disabled_despite_other_flags_are_set', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(BitUtil.setBit(0, 3));
      let result = ntfreminderconfig.isBannerEnable();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_banner_is_enabled_despite_flags_are_completely_set', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(BitUtil.setBit(BitUtil.setBit(0, 2), 3));
      let result = ntfreminderconfig.isBannerEnable();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_banner_is_disabled_despite_flags_are_completely_set', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(BitUtil.setBit(BitUtil.setBit(0, 2), 3));
      let result = ntfreminderconfig.isBannerEnable();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_ON_SCREEN_flag_is_set', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(1);
      let result = ntfreminderconfig.isOnScreenEnable();
      expect(result).assertTrue();
    });

    it('should_return_false_when_ON_SCREEN_flag_is_not_set', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(0);
      let result = ntfreminderconfig.isOnScreenEnable();
      expect(result).assertFalse();
    });

    it('should_return_true_when_ON_SCREEN_flag_is_set_in_middle_position', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(4);
      let result = ntfreminderconfig.isOnScreenEnable();
      expect(result).assertTrue();
    });

    it('should_return_false_when_ON_SCREEN_flag_is_not_set_in_middle_position', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(0);
      let result = ntfreminderconfig.isOnScreenEnable();
      expect(result).assertFalse();
    });

    it('should_return_true_when_ON_SCREEN_flag_is_set_in_last_position', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(8);
      let result = ntfreminderconfig.isOnScreenEnable();
      expect(result).assertTrue();
    });

    it('should_return_false_when_ON_SCREEN_flag_is_not_set_in_last_position', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(0);
      let result = ntfreminderconfig.isOnScreenEnable();
      expect(result).assertFalse();
    });

    it('should_return_false_when_flags_are_all_zero', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(0);
      let result = ntfreminderconfig.isOnScreenEnable();
      expect(result).assertFalse();
    });

    it('should_return_true_when_flags_are_all_one', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(15);
      let result = ntfreminderconfig.isOnScreenEnable();
      expect(result).assertTrue();
    });

    it('should_return_false_when_flags_are_all_zero_except_ON_SCREEN', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(0);
      BitUtil.setBit(ntfreminderconfig.flags, NtfRemindFlagIdxEnum.ON_SCREEN);
      let result = ntfreminderconfig.isOnScreenEnable();
      expect(result).assertFalse();
    });

    it('should_return_true_when_flags_are_all_one_except_ON_SCREEN', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(15);
      BitUtil.clearBit(ntfreminderconfig.flags, NtfRemindFlagIdxEnum.ON_SCREEN);
      let result = ntfreminderconfig.isOnScreenEnable();
      expect(result).assertTrue();
    });

    it('should_return_false_when_flags_are_all_one_with_ON_SCREEN_in_last_position', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(15);
      BitUtil.setBit(ntfreminderconfig.flags, NtfRemindFlagIdxEnum.ON_SCREEN);
      BitUtil.clearBit(ntfreminderconfig.flags, NtfRemindFlagIdxEnum.ON_SCREEN);
      let result = ntfreminderconfig.isOnScreenEnable();
      expect(result).assertFalse();
    });

    it('should_return_true_when_flags_are_all_one_with_ON_SCREEN_in_last_position', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(15);
      BitUtil.clearBit(ntfreminderconfig.flags, NtfRemindFlagIdxEnum.ON_SCREEN);
      BitUtil.setBit(ntfreminderconfig.flags, NtfRemindFlagIdxEnum.ON_SCREEN);
      let result = ntfreminderconfig.isOnScreenEnable();
      expect(result).assertTrue();
    });
    it('should_return_true_when_bit_is_set_in_flags', 0, () => {
      let flags: number = 5; // 0101 in binary
      let idx: NtfRemindFlagIdxEnum = NtfRemindFlagIdxEnum.REMIND_FLAG_0;
      const result = NtfRemindFlags.parse(flags, idx);
      expect(result).assertTrue();
    });

    it('should_return_false_when_bit_is_not_set_in_flags', 0, () => {
      let flags: number = 4; // 0100 in binary
      let idx: NtfRemindFlagIdxEnum = NtfRemindFlagIdxEnum.REMIND_FLAG_1;
      const result = NtfRemindFlags.parse(flags, idx);
      expect(result).assertFalse();
    });

    it('should_return_true_when_flags_is_zero', 0, () => {
      let flags: number = 0;
      let idx: NtfRemindFlagIdxEnum = NtfRemindFlagIdxEnum.REMIND_FLAG_0;
      const result = NtfRemindFlags.parse(flags, idx);
      expect(result).assertFalse();
    });

    it('should_return_false_when_flags_is_zero', 0, () => {
      let flags: number = 0;
      let idx: NtfRemindFlagIdxEnum = NtfRemindFlagIdxEnum.REMIND_FLAG_1;
      const result = NtfRemindFlags.parse(flags, idx);
      expect(result).assertFalse();
    });

    it('should_return_true_when_sound_is_enabled', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(1);
      let result = ntfreminderconfig.isSoundEnable();
      expect(result).assertTrue();
    });

    it('should_return_false_when_sound_is_disabled', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(0);
      let result = ntfreminderconfig.isSoundEnable();
      expect(result).assertFalse();
    });

    it('should_return_true_when_sound_is_enabled_despite_other_flags_are_set', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(3);
      let result = ntfreminderconfig.isSoundEnable();
      expect(result).assertTrue();
    });

    it('should_return_false_when_sound_is_disabled_despite_other_flags_are_set', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(2);
      let result = ntfreminderconfig.isSoundEnable();
      expect(result).assertFalse();
    });

    it('should_return_true_when_banner_is_enabled', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(1);
      let result = ntfreminderconfig.isBannerEnable();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_banner_is_disabled', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(0);
      let result = ntfreminderconfig.isBannerEnable();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_banner_is_enabled_despite_other_flags_are_set', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(BitUtil.setBit(0, 2));
      let result = ntfreminderconfig.isBannerEnable();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_banner_is_disabled_despite_other_flags_are_set', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(BitUtil.setBit(0, 3));
      let result = ntfreminderconfig.isBannerEnable();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_banner_is_enabled_despite_flags_are_completely_set', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(BitUtil.setBit(BitUtil.setBit(0, 2), 3));
      let result = ntfreminderconfig.isBannerEnable();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_banner_is_disabled_despite_flags_are_completely_set', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(BitUtil.setBit(BitUtil.setBit(0, 2), 3));
      let result = ntfreminderconfig.isBannerEnable();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_ON_SCREEN_flag_is_set', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(1);
      let result = ntfreminderconfig.isOnScreenEnable();
      expect(result).assertTrue();
    });

    it('should_return_false_when_ON_SCREEN_flag_is_not_set', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(0);
      let result = ntfreminderconfig.isOnScreenEnable();
      expect(result).assertFalse();
    });

    it('should_return_true_when_ON_SCREEN_flag_is_set_in_middle_position', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(4);
      let result = ntfreminderconfig.isOnScreenEnable();
      expect(result).assertTrue();
    });

    it('should_return_false_when_ON_SCREEN_flag_is_not_set_in_middle_position', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(0);
      let result = ntfreminderconfig.isOnScreenEnable();
      expect(result).assertFalse();
    });

    it('should_return_true_when_ON_SCREEN_flag_is_set_in_last_position', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(8);
      let result = ntfreminderconfig.isOnScreenEnable();
      expect(result).assertTrue();
    });

    it('should_return_false_when_ON_SCREEN_flag_is_not_set_in_last_position', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(0);
      let result = ntfreminderconfig.isOnScreenEnable();
      expect(result).assertFalse();
    });

    it('should_return_false_when_flags_are_all_zero', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(0);
      let result = ntfreminderconfig.isOnScreenEnable();
      expect(result).assertFalse();
    });

    it('should_return_true_when_flags_are_all_one', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(15);
      let result = ntfreminderconfig.isOnScreenEnable();
      expect(result).assertTrue();
    });

    it('should_return_false_when_flags_are_all_zero_except_ON_SCREEN', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(0);
      BitUtil.setBit(ntfreminderconfig.flags, NtfRemindFlagIdxEnum.ON_SCREEN);
      let result = ntfreminderconfig.isOnScreenEnable();
      expect(result).assertFalse();
    });

    it('should_return_true_when_flags_are_all_one_except_ON_SCREEN', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(15);
      BitUtil.clearBit(ntfreminderconfig.flags, NtfRemindFlagIdxEnum.ON_SCREEN);
      let result = ntfreminderconfig.isOnScreenEnable();
      expect(result).assertTrue();
    });

    it('should_return_false_when_flags_are_all_one_with_ON_SCREEN_in_last_position', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(15);
      BitUtil.setBit(ntfreminderconfig.flags, NtfRemindFlagIdxEnum.ON_SCREEN);
      BitUtil.clearBit(ntfreminderconfig.flags, NtfRemindFlagIdxEnum.ON_SCREEN);
      let result = ntfreminderconfig.isOnScreenEnable();
      expect(result).assertFalse();
    });

    it('should_return_true_when_flags_are_all_one_with_ON_SCREEN_in_last_position', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(15);
      BitUtil.clearBit(ntfreminderconfig.flags, NtfRemindFlagIdxEnum.ON_SCREEN);
      BitUtil.setBit(ntfreminderconfig.flags, NtfRemindFlagIdxEnum.ON_SCREEN);
      let result = ntfreminderconfig.isOnScreenEnable();
      expect(result).assertTrue();
    });
    it('should_return_true_when_bit_is_set_in_flags', 0, () => {
      let flags: number = 5; // 0101 in binary
      let idx: NtfRemindFlagIdxEnum = NtfRemindFlagIdxEnum.REMIND_FLAG_0;
      const result = NtfRemindFlags.parse(flags, idx);
      expect(result).assertTrue();
    });

    it('should_return_false_when_bit_is_not_set_in_flags', 0, () => {
      let flags: number = 4; // 0100 in binary
      let idx: NtfRemindFlagIdxEnum = NtfRemindFlagIdxEnum.REMIND_FLAG_1;
      const result = NtfRemindFlags.parse(flags, idx);
      expect(result).assertFalse();
    });

    it('should_return_true_when_flags_is_zero', 0, () => {
      let flags: number = 0;
      let idx: NtfRemindFlagIdxEnum = NtfRemindFlagIdxEnum.REMIND_FLAG_0;
      const result = NtfRemindFlags.parse(flags, idx);
      expect(result).assertFalse();
    });

    it('should_return_false_when_flags_is_zero', 0, () => {
      let flags: number = 0;
      let idx: NtfRemindFlagIdxEnum = NtfRemindFlagIdxEnum.REMIND_FLAG_1;
      const result = NtfRemindFlags.parse(flags, idx);
      expect(result).assertFalse();
    });

    it('should_return_true_when_sound_is_enabled', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(1);
      let result = ntfreminderconfig.isSoundEnable();
      expect(result).assertTrue();
    });

    it('should_return_false_when_sound_is_disabled', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(0);
      let result = ntfreminderconfig.isSoundEnable();
      expect(result).assertFalse();
    });

    it('should_return_true_when_sound_is_enabled_despite_other_flags_are_set', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(3);
      let result = ntfreminderconfig.isSoundEnable();
      expect(result).assertTrue();
    });

    it('should_return_false_when_sound_is_disabled_despite_other_flags_are_set', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(2);
      let result = ntfreminderconfig.isSoundEnable();
      expect(result).assertFalse();
    });

    it('should_return_true_when_banner_is_enabled', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(1);
      let result = ntfreminderconfig.isBannerEnable();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_banner_is_disabled', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(0);
      let result = ntfreminderconfig.isBannerEnable();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_banner_is_enabled_despite_other_flags_are_set', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(BitUtil.setBit(0, 2));
      let result = ntfreminderconfig.isBannerEnable();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_banner_is_disabled_despite_other_flags_are_set', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(BitUtil.setBit(0, 3));
      let result = ntfreminderconfig.isBannerEnable();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_banner_is_enabled_despite_flags_are_completely_set', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(BitUtil.setBit(BitUtil.setBit(0, 2), 3));
      let result = ntfreminderconfig.isBannerEnable();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_banner_is_disabled_despite_flags_are_completely_set', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(BitUtil.setBit(BitUtil.setBit(0, 2), 3));
      let result = ntfreminderconfig.isBannerEnable();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_ON_SCREEN_flag_is_set', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(1);
      let result = ntfreminderconfig.isOnScreenEnable();
      expect(result).assertTrue();
    });

    it('should_return_false_when_ON_SCREEN_flag_is_not_set', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(0);
      let result = ntfreminderconfig.isOnScreenEnable();
      expect(result).assertFalse();
    });

    it('should_return_true_when_ON_SCREEN_flag_is_set_in_middle_position', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(4);
      let result = ntfreminderconfig.isOnScreenEnable();
      expect(result).assertTrue();
    });

    it('should_return_false_when_ON_SCREEN_flag_is_not_set_in_middle_position', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(0);
      let result = ntfreminderconfig.isOnScreenEnable();
      expect(result).assertFalse();
    });

    it('should_return_true_when_ON_SCREEN_flag_is_set_in_last_position', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(8);
      let result = ntfreminderconfig.isOnScreenEnable();
      expect(result).assertTrue();
    });

    it('should_return_false_when_ON_SCREEN_flag_is_not_set_in_last_position', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(0);
      let result = ntfreminderconfig.isOnScreenEnable();
      expect(result).assertFalse();
    });

    it('should_return_false_when_flags_are_all_zero', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(0);
      let result = ntfreminderconfig.isOnScreenEnable();
      expect(result).assertFalse();
    });

    it('should_return_true_when_flags_are_all_one', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(15);
      let result = ntfreminderconfig.isOnScreenEnable();
      expect(result).assertTrue();
    });

    it('should_return_false_when_flags_are_all_zero_except_ON_SCREEN', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(0);
      BitUtil.setBit(ntfreminderconfig.flags, NtfRemindFlagIdxEnum.ON_SCREEN);
      let result = ntfreminderconfig.isOnScreenEnable();
      expect(result).assertFalse();
    });

    it('should_return_true_when_flags_are_all_one_except_ON_SCREEN', 0, () => {
      let ntfreminderconfig: NtfReminderConfig = new NtfReminderConfig(15);
      BitUtil.clearBit(ntfreminderconfig.flags, NtfRemindFlagIdxEnum.ON_SCREEN);
      let result = ntfreminderconfig.isOnScreenEnable();
      expect(result).assertTrue();
    });

  });
