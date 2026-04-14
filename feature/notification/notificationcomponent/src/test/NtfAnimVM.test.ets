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
import { curves } from '@kit.ArkUI';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { NtfAnimationConsts } from '../../../main/ets/common/NtfAnimationConsts';
import { NotificationEntry } from '../../../main/ets/model/NotificationEntry';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NtfAnimVM } from '../../../main/ets/vm/NtfAnimVM';
export default function NtfAnimVMTest() {
  describe('isDeletingItem_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_false_when_ntfEntry_is_null', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      let result = ntfanimvm.isDeletingItem(null);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_deletingItem_and_ntfEntry_are_null', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      ntfanimvm.deletingItem = null;
      let result = ntfanimvm.isDeletingItem(null);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_deletingItem_and_ntfEntry_are_not_null_but_getGroupTypeKey_returns_different_values', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      let deletingItem: NotificationEntry = new NotificationEntry();
      deletingItem.getGroupTypeKey = () => 'type1';
      ntfanimvm.deletingItem = deletingItem;
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.getGroupTypeKey = () => 'type2';
      let result = ntfanimvm.isDeletingItem(ntfEntry);
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_deletingItem_and_ntfEntry_are_not_null_and_getGroupTypeKey_returns_same_values', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      let deletingItem: NotificationEntry = new NotificationEntry();
      deletingItem.getGroupTypeKey = () => 'type1';
      ntfanimvm.deletingItem = deletingItem;
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.getGroupTypeKey = () => 'type1';
      let result = ntfanimvm.isDeletingItem(ntfEntry);
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_ntfEntry_is_null', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      let result = ntfanimvm.isDeletingItem(null);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_deletingItem_and_ntfEntry_are_null', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      ntfanimvm.deletingItem = null;
      let result = ntfanimvm.isDeletingItem(null);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_deletingItem_and_ntfEntry_are_not_null_but_getGroupTypeKey_returns_different_values', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      let deletingItem: NotificationEntry = new NotificationEntry();
      deletingItem.getGroupTypeKey = () => 'type1';
      ntfanimvm.deletingItem = deletingItem;
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.getGroupTypeKey = () => 'type2';
      let result = ntfanimvm.isDeletingItem(ntfEntry);
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_deletingItem_and_ntfEntry_are_not_null_and_getGroupTypeKey_returns_same_values', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      let deletingItem: NotificationEntry = new NotificationEntry();
      deletingItem.getGroupTypeKey = () => 'type1';
      ntfanimvm.deletingItem = deletingItem;
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.getGroupTypeKey = () => 'type1';
      let result = ntfanimvm.isDeletingItem(ntfEntry);
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_ntfEntry_is_null', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      let result = ntfanimvm.isDeletingItem(null);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_deletingItem_and_ntfEntry_are_null', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      ntfanimvm.deletingItem = null;
      let result = ntfanimvm.isDeletingItem(null);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_deletingItem_and_ntfEntry_are_not_null_but_getGroupTypeKey_returns_different_values', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      let deletingItem: NotificationEntry = new NotificationEntry();
      deletingItem.getGroupTypeKey = () => 'type1';
      ntfanimvm.deletingItem = deletingItem;
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.getGroupTypeKey = () => 'type2';
      let result = ntfanimvm.isDeletingItem(ntfEntry);
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_deletingItem_and_ntfEntry_are_not_null_and_getGroupTypeKey_returns_same_values', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      let deletingItem: NotificationEntry = new NotificationEntry();
      deletingItem.getGroupTypeKey = () => 'type1';
      ntfanimvm.deletingItem = deletingItem;
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.getGroupTypeKey = () => 'type1';
      let result = ntfanimvm.isDeletingItem(ntfEntry);
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_ntfEntry_is_null', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      let result = ntfanimvm.isDeletingItem(null);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_deletingItem_and_ntfEntry_are_null', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      ntfanimvm.deletingItem = null;
      let result = ntfanimvm.isDeletingItem(null);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_deletingItem_and_ntfEntry_are_not_null_but_getGroupTypeKey_returns_different_values', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      let deletingItem: NotificationEntry = new NotificationEntry();
      deletingItem.getGroupTypeKey = () => 'type1';
      ntfanimvm.deletingItem = deletingItem;
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.getGroupTypeKey = () => 'type2';
      let result = ntfanimvm.isDeletingItem(ntfEntry);
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_deletingItem_and_ntfEntry_are_not_null_and_getGroupTypeKey_returns_same_values', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      let deletingItem: NotificationEntry = new NotificationEntry();
      deletingItem.getGroupTypeKey = () => 'type1';
      ntfanimvm.deletingItem = deletingItem;
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.getGroupTypeKey = () => 'type1';
      let result = ntfanimvm.isDeletingItem(ntfEntry);
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_ntfEntry_is_null', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      let result = ntfanimvm.isDeletingItem(null);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_deletingItem_and_ntfEntry_are_null', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      ntfanimvm.deletingItem = null;
      let result = ntfanimvm.isDeletingItem(null);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_deletingItem_and_ntfEntry_are_not_null_but_getGroupTypeKey_returns_different_values', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      let deletingItem: NotificationEntry = new NotificationEntry();
      deletingItem.getGroupTypeKey = () => 'type1';
      ntfanimvm.deletingItem = deletingItem;
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.getGroupTypeKey = () => 'type2';
      let result = ntfanimvm.isDeletingItem(ntfEntry);
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_deletingItem_and_ntfEntry_are_not_null_and_getGroupTypeKey_returns_same_values', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      let deletingItem: NotificationEntry = new NotificationEntry();
      deletingItem.getGroupTypeKey = () => 'type1';
      ntfanimvm.deletingItem = deletingItem;
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.getGroupTypeKey = () => 'type1';
      let result = ntfanimvm.isDeletingItem(ntfEntry);
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_ntfEntry_is_null', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      let result = ntfanimvm.isDeletingItem(null);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_deletingItem_and_ntfEntry_are_null', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      ntfanimvm.deletingItem = null;
      let result = ntfanimvm.isDeletingItem(null);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_deletingItem_and_ntfEntry_are_not_null_but_getGroupTypeKey_returns_different_values', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      let deletingItem: NotificationEntry = new NotificationEntry();
      deletingItem.getGroupTypeKey = () => 'type1';
      ntfanimvm.deletingItem = deletingItem;
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.getGroupTypeKey = () => 'type2';
      let result = ntfanimvm.isDeletingItem(ntfEntry);
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_deletingItem_and_ntfEntry_are_not_null_and_getGroupTypeKey_returns_same_values', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      let deletingItem: NotificationEntry = new NotificationEntry();
      deletingItem.getGroupTypeKey = () => 'type1';
      ntfanimvm.deletingItem = deletingItem;
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.getGroupTypeKey = () => 'type1';
      let result = ntfanimvm.isDeletingItem(ntfEntry);
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_ntfEntry_is_null', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      let result = ntfanimvm.isDeletingItem(null);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_deletingItem_and_ntfEntry_are_null', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      ntfanimvm.deletingItem = null;
      let result = ntfanimvm.isDeletingItem(null);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_deletingItem_and_ntfEntry_are_not_null_but_getGroupTypeKey_returns_different_values', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      let deletingItem: NotificationEntry = new NotificationEntry();
      deletingItem.getGroupTypeKey = () => 'type1';
      ntfanimvm.deletingItem = deletingItem;
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.getGroupTypeKey = () => 'type2';
      let result = ntfanimvm.isDeletingItem(ntfEntry);
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_deletingItem_and_ntfEntry_are_not_null_and_getGroupTypeKey_returns_same_values', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      let deletingItem: NotificationEntry = new NotificationEntry();
      deletingItem.getGroupTypeKey = () => 'type1';
      ntfanimvm.deletingItem = deletingItem;
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.getGroupTypeKey = () => 'type1';
      let result = ntfanimvm.isDeletingItem(ntfEntry);
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_ntfEntry_is_null', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      let result = ntfanimvm.isDeletingItem(null);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_deletingItem_and_ntfEntry_are_null', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      ntfanimvm.deletingItem = null;
      let result = ntfanimvm.isDeletingItem(null);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_deletingItem_and_ntfEntry_are_not_null_but_getGroupTypeKey_returns_different_values', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      let deletingItem: NotificationEntry = new NotificationEntry();
      deletingItem.getGroupTypeKey = () => 'type1';
      ntfanimvm.deletingItem = deletingItem;
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.getGroupTypeKey = () => 'type2';
      let result = ntfanimvm.isDeletingItem(ntfEntry);
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_deletingItem_and_ntfEntry_are_not_null_and_getGroupTypeKey_returns_same_values', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      let deletingItem: NotificationEntry = new NotificationEntry();
      deletingItem.getGroupTypeKey = () => 'type1';
      ntfanimvm.deletingItem = deletingItem;
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.getGroupTypeKey = () => 'type1';
      let result = ntfanimvm.isDeletingItem(ntfEntry);
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_ntfEntry_is_null', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      let result = ntfanimvm.isDeletingItem(null);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_deletingItem_and_ntfEntry_are_null', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      ntfanimvm.deletingItem = null;
      let result = ntfanimvm.isDeletingItem(null);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_deletingItem_and_ntfEntry_are_not_null_but_getGroupTypeKey_returns_different_values', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      let deletingItem: NotificationEntry = new NotificationEntry();
      deletingItem.getGroupTypeKey = () => 'type1';
      ntfanimvm.deletingItem = deletingItem;
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.getGroupTypeKey = () => 'type2';
      let result = ntfanimvm.isDeletingItem(ntfEntry);
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_deletingItem_and_ntfEntry_are_not_null_and_getGroupTypeKey_returns_same_values', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      let deletingItem: NotificationEntry = new NotificationEntry();
      deletingItem.getGroupTypeKey = () => 'type1';
      ntfanimvm.deletingItem = deletingItem;
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.getGroupTypeKey = () => 'type1';
      let result = ntfanimvm.isDeletingItem(ntfEntry);
      expect(result).assertEqual(true);
    });

  });
  describe('getNtfAppearTransition_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_correct_transition_when_deletingItem_is_undefined', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      ntfanimvm.deletingItem = undefined;
      let result: TransitionEffect = ntfanimvm.getNtfAppearTransition();
      expect(result).assertInstanceOf(TransitionEffect);
      expect(result.duration).assertEqual(167);
      expect(result.delay).assertEqual(83);
      expect(result.curve).assertInstanceOf(curves.Curve);
    });

    it('should_return_correct_transition_when_deletingItem_is_not_undefined', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      let deletingItem: NotificationEntry = new NotificationEntry();
      ntfanimvm.deletingItem = deletingItem;
      let result: TransitionEffect = ntfanimvm.getNtfAppearTransition();
      expect(result).assertInstanceOf(TransitionEffect);
      expect(result.duration).assertEqual(167);
      expect(result.delay).assertEqual(83);
      expect(result.curve).assertInstanceOf(curves.Curve);
    });

    it('should_return_correct_transition_when_deletingItem_is_undefined', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      ntfanimvm.deletingItem = undefined;
      let result: TransitionEffect = ntfanimvm.getNtfAppearTransition();
      expect(result).assertInstanceOf(TransitionEffect);
      expect(result.duration).assertEqual(167);
      expect(result.delay).assertEqual(83);
      expect(result.curve).assertInstanceOf(curves.Curve);
    });

    it('should_return_correct_transition_when_deletingItem_is_not_undefined', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      let deletingItem: NotificationEntry = new NotificationEntry();
      ntfanimvm.deletingItem = deletingItem;
      let result: TransitionEffect = ntfanimvm.getNtfAppearTransition();
      expect(result).assertInstanceOf(TransitionEffect);
      expect(result.duration).assertEqual(167);
      expect(result.delay).assertEqual(83);
      expect(result.curve).assertInstanceOf(curves.Curve);
    });

    it('should_return_correct_transition_when_deletingItem_is_undefined', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      ntfanimvm.deletingItem = undefined;
      let result: TransitionEffect = ntfanimvm.getNtfAppearTransition();
      expect(result).assertInstanceOf(TransitionEffect);
      expect(result.duration).assertEqual(167);
      expect(result.delay).assertEqual(83);
      expect(result.curve).assertInstanceOf(curves.Curve);
    });

    it('should_return_correct_transition_when_deletingItem_is_not_undefined', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      let deletingItem: NotificationEntry = new NotificationEntry();
      ntfanimvm.deletingItem = deletingItem;
      let result: TransitionEffect = ntfanimvm.getNtfAppearTransition();
      expect(result).assertInstanceOf(TransitionEffect);
      expect(result.duration).assertEqual(167);
      expect(result.delay).assertEqual(83);
      expect(result.curve).assertInstanceOf(curves.Curve);
    });

    it('should_return_correct_transition_when_deletingItem_is_undefined', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      ntfanimvm.deletingItem = undefined;
      let result: TransitionEffect = ntfanimvm.getNtfAppearTransition();
      expect(result).assertInstanceOf(TransitionEffect);
      expect(result.duration).assertEqual(167);
      expect(result.delay).assertEqual(83);
      expect(result.curve).assertInstanceOf(curves.Curve);
    });

    it('should_return_correct_transition_when_deletingItem_is_not_undefined', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      let deletingItem: NotificationEntry = new NotificationEntry();
      ntfanimvm.deletingItem = deletingItem;
      let result: TransitionEffect = ntfanimvm.getNtfAppearTransition();
      expect(result).assertInstanceOf(TransitionEffect);
      expect(result.duration).assertEqual(167);
      expect(result.delay).assertEqual(83);
      expect(result.curve).assertInstanceOf(curves.Curve);
    });

  });
  describe('getNtfDisappearTransition_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_correct_transition_when_deletingItem_is_null', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      ntfanimvm.deletingItem = null;
      let result: TransitionEffect = ntfanimvm.getNtfDisappearTransition();
      expect(result).assertInstanceOf(TransitionEffect);
      expect(result.getDuration()).assertEqual(100);
      expect(result.getCurve()).assertInstanceOf(curves.Curve);
    });

    it('should_return_correct_transition_when_deletingItem_is_not_null', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      let deletingItem: NotificationEntry = new NotificationEntry();
      ntfanimvm.deletingItem = deletingItem;
      let result: TransitionEffect = ntfanimvm.getNtfDisappearTransition();
      expect(result).assertInstanceOf(TransitionEffect);
      expect(result.getDuration()).assertEqual(100);
      expect(result.getCurve()).assertInstanceOf(curves.Curve);
    });

    it('should_return_correct_transition_when_deletingItem_is_null', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      ntfanimvm.deletingItem = null;
      let result: TransitionEffect = ntfanimvm.getNtfDisappearTransition();
      expect(result).assertInstanceOf(TransitionEffect);
      expect(result.getDuration()).assertEqual(100);
      expect(result.getCurve()).assertInstanceOf(curves.Curve);
    });

    it('should_return_correct_transition_when_deletingItem_is_not_null', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      let deletingItem: NotificationEntry = new NotificationEntry();
      ntfanimvm.deletingItem = deletingItem;
      let result: TransitionEffect = ntfanimvm.getNtfDisappearTransition();
      expect(result).assertInstanceOf(TransitionEffect);
      expect(result.getDuration()).assertEqual(100);
      expect(result.getCurve()).assertInstanceOf(curves.Curve);
    });

    it('should_return_correct_transition_when_deletingItem_is_null', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      ntfanimvm.deletingItem = null;
      let result: TransitionEffect = ntfanimvm.getNtfDisappearTransition();
      expect(result).assertInstanceOf(TransitionEffect);
      expect(result.getDuration()).assertEqual(100);
      expect(result.getCurve()).assertInstanceOf(curves.Curve);
    });

    it('should_return_correct_transition_when_deletingItem_is_not_null', 0, () => {
      let ntfanimvm: NtfAnimVM = new NtfAnimVM();
      let deletingItem: NotificationEntry = new NotificationEntry();
      ntfanimvm.deletingItem = deletingItem;
      let result: TransitionEffect = ntfanimvm.getNtfDisappearTransition();
      expect(result).assertInstanceOf(TransitionEffect);
      expect(result.getDuration()).assertEqual(100);
      expect(result.getCurve()).assertInstanceOf(curves.Curve);
    });
  });
}