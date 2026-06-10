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
import { NtfAnimationConsts } from '../../../main/ets/common/NtfAnimationConsts';
import { NotificationEntry } from '../../../main/ets/model/NotificationEntry';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { ExtraNtfCollapsedAnimation } from '../../../main/ets/animation/ExtraNtfCollapsedAnimation';
export default function ExtraNtfCollapsedAnimationTest() {
  describe('getExtraNtfAnimationArray_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_empty_array_when_extraNtfs_is_null', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result).assertDeepEquals([]);
    });

    it('should_return_empty_array_when_extraNtfs_is_empty', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      extrantfcollapsedanimation.extraNtfs = [];
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result).assertDeepEquals([]);
    });

    it('should_return_transition_effect_array_when_extraNtfs_is_not_null_and_not_empty', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let mocker: MockKit = new MockKit();

      let mockExtraNtfComponentTransition_1: Function =
        mocker.mockFunc(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
      when(mockExtraNtfComponentTransition_1)(ArgumentMatchers.anyNumber).afterReturn(new TransitionEffect());

      let mockExtraNtfComponentTransition_2: Function =
        mocker.mockFunc(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
      when(mockExtraNtfComponentTransition_2)(ArgumentMatchers.anyNumber).afterReturn(new TransitionEffect());

      extrantfcollapsedanimation.extraNtfs = [new NotificationEntry(), new NotificationEntry()];
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result.length).assertEqual(2);

      mocker.ignoreMock(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
    });

    it('should_return_empty_array_when_extraNtfs_is_null', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result).assertDeepEquals([]);
    });

    it('should_return_empty_array_when_extraNtfs_is_empty', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      extrantfcollapsedanimation.extraNtfs = [];
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result).assertDeepEquals([]);
    });

    it('should_return_transition_effect_array_when_extraNtfs_is_not_null_and_not_empty', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let mocker: MockKit = new MockKit();

      let mockExtraNtfComponentTransition_1: Function =
        mocker.mockFunc(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
      when(mockExtraNtfComponentTransition_1)(ArgumentMatchers.anyNumber).afterReturn(new TransitionEffect());

      let mockExtraNtfComponentTransition_2: Function =
        mocker.mockFunc(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
      when(mockExtraNtfComponentTransition_2)(ArgumentMatchers.anyNumber).afterReturn(new TransitionEffect());

      extrantfcollapsedanimation.extraNtfs = [new NotificationEntry(), new NotificationEntry()];
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result.length).assertEqual(2);

      mocker.ignoreMock(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
    });

    it('should_return_empty_array_when_extraNtfs_is_null', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result).assertDeepEquals([]);
    });

    it('should_return_empty_array_when_extraNtfs_is_empty', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      extrantfcollapsedanimation.extraNtfs = [];
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result).assertDeepEquals([]);
    });

    it('should_return_transition_effect_array_when_extraNtfs_is_not_null_and_not_empty', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let mocker: MockKit = new MockKit();

      let mockExtraNtfComponentTransition_1: Function =
        mocker.mockFunc(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
      when(mockExtraNtfComponentTransition_1)(ArgumentMatchers.anyNumber).afterReturn(new TransitionEffect());

      let mockExtraNtfComponentTransition_2: Function =
        mocker.mockFunc(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
      when(mockExtraNtfComponentTransition_2)(ArgumentMatchers.anyNumber).afterReturn(new TransitionEffect());

      extrantfcollapsedanimation.extraNtfs = [new NotificationEntry(), new NotificationEntry()];
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result.length).assertEqual(2);

      mocker.ignoreMock(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
    });

    it('should_return_empty_array_when_extraNtfs_is_null', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result).assertDeepEquals([]);
    });

    it('should_return_empty_array_when_extraNtfs_is_empty', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      extrantfcollapsedanimation.extraNtfs = [];
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result).assertDeepEquals([]);
    });

    it('should_return_transition_effect_array_when_extraNtfs_is_not_null_and_not_empty', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let mocker: MockKit = new MockKit();

      let mockExtraNtfComponentTransition_1: Function =
        mocker.mockFunc(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
      when(mockExtraNtfComponentTransition_1)(ArgumentMatchers.anyNumber).afterReturn(new TransitionEffect());

      let mockExtraNtfComponentTransition_2: Function =
        mocker.mockFunc(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
      when(mockExtraNtfComponentTransition_2)(ArgumentMatchers.anyNumber).afterReturn(new TransitionEffect());

      extrantfcollapsedanimation.extraNtfs = [new NotificationEntry(), new NotificationEntry()];
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result.length).assertEqual(2);

      mocker.ignoreMock(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
    });

    it('should_return_empty_array_when_extraNtfs_is_null', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result).assertDeepEquals([]);
    });

    it('should_return_empty_array_when_extraNtfs_is_empty', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      extrantfcollapsedanimation.extraNtfs = [];
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result).assertDeepEquals([]);
    });

    it('should_return_transition_effect_array_when_extraNtfs_is_not_null_and_not_empty', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let mocker: MockKit = new MockKit();

      let mockExtraNtfComponentTransition_1: Function =
        mocker.mockFunc(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
      when(mockExtraNtfComponentTransition_1)(ArgumentMatchers.anyNumber).afterReturn(new TransitionEffect());

      let mockExtraNtfComponentTransition_2: Function =
        mocker.mockFunc(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
      when(mockExtraNtfComponentTransition_2)(ArgumentMatchers.anyNumber).afterReturn(new TransitionEffect());

      extrantfcollapsedanimation.extraNtfs = [new NotificationEntry(), new NotificationEntry()];
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result.length).assertEqual(2);

      mocker.ignoreMock(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
    });

    it('should_return_empty_array_when_extraNtfs_is_null', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result).assertDeepEquals([]);
    });

    it('should_return_empty_array_when_extraNtfs_is_empty', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      extrantfcollapsedanimation.extraNtfs = [];
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result).assertDeepEquals([]);
    });

    it('should_return_transition_effect_array_when_extraNtfs_is_not_null_and_not_empty', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let mocker: MockKit = new MockKit();

      let mockExtraNtfComponentTransition_1: Function =
        mocker.mockFunc(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
      when(mockExtraNtfComponentTransition_1)(ArgumentMatchers.anyNumber).afterReturn(new TransitionEffect());

      let mockExtraNtfComponentTransition_2: Function =
        mocker.mockFunc(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
      when(mockExtraNtfComponentTransition_2)(ArgumentMatchers.anyNumber).afterReturn(new TransitionEffect());

      extrantfcollapsedanimation.extraNtfs = [new NotificationEntry(), new NotificationEntry()];
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result.length).assertEqual(2);

      mocker.ignoreMock(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
    });

    it('should_return_empty_array_when_extraNtfs_is_null', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result).assertDeepEquals([]);
    });

    it('should_return_empty_array_when_extraNtfs_is_empty', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      extrantfcollapsedanimation.extraNtfs = [];
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result).assertDeepEquals([]);
    });

    it('should_return_transition_effect_array_when_extraNtfs_is_not_null_and_not_empty', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let mocker: MockKit = new MockKit();

      let mockExtraNtfComponentTransition_1: Function =
        mocker.mockFunc(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
      when(mockExtraNtfComponentTransition_1)(ArgumentMatchers.anyNumber).afterReturn(new TransitionEffect());

      let mockExtraNtfComponentTransition_2: Function =
        mocker.mockFunc(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
      when(mockExtraNtfComponentTransition_2)(ArgumentMatchers.anyNumber).afterReturn(new TransitionEffect());

      extrantfcollapsedanimation.extraNtfs = [new NotificationEntry(), new NotificationEntry()];
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result.length).assertEqual(2);

      mocker.ignoreMock(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
    });

    it('should_return_empty_array_when_extraNtfs_is_null', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result).assertDeepEquals([]);
    });

    it('should_return_empty_array_when_extraNtfs_is_empty', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      extrantfcollapsedanimation.extraNtfs = [];
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result).assertDeepEquals([]);
    });

    it('should_return_transition_effect_array_when_extraNtfs_is_not_null_and_not_empty', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let mocker: MockKit = new MockKit();

      let mockExtraNtfComponentTransition_1: Function =
        mocker.mockFunc(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
      when(mockExtraNtfComponentTransition_1)(ArgumentMatchers.anyNumber).afterReturn(new TransitionEffect());

      let mockExtraNtfComponentTransition_2: Function =
        mocker.mockFunc(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
      when(mockExtraNtfComponentTransition_2)(ArgumentMatchers.anyNumber).afterReturn(new TransitionEffect());

      extrantfcollapsedanimation.extraNtfs = [new NotificationEntry(), new NotificationEntry()];
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result.length).assertEqual(2);

      mocker.ignoreMock(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
    });

    it('should_return_empty_array_when_extraNtfs_is_null', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result).assertDeepEquals([]);
    });

    it('should_return_empty_array_when_extraNtfs_is_empty', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      extrantfcollapsedanimation.extraNtfs = [];
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result).assertDeepEquals([]);
    });

    it('should_return_transition_effect_array_when_extraNtfs_is_not_null_and_not_empty', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let mocker: MockKit = new MockKit();

      let mockExtraNtfComponentTransition_1: Function =
        mocker.mockFunc(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
      when(mockExtraNtfComponentTransition_1)(ArgumentMatchers.anyNumber).afterReturn(new TransitionEffect());

      let mockExtraNtfComponentTransition_2: Function =
        mocker.mockFunc(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
      when(mockExtraNtfComponentTransition_2)(ArgumentMatchers.anyNumber).afterReturn(new TransitionEffect());

      extrantfcollapsedanimation.extraNtfs = [new NotificationEntry(), new NotificationEntry()];
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result.length).assertEqual(2);

      mocker.ignoreMock(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
    });

    it('should_return_empty_array_when_extraNtfs_is_null', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result).assertDeepEquals([]);
    });

    it('should_return_empty_array_when_extraNtfs_is_empty', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      extrantfcollapsedanimation.extraNtfs = [];
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result).assertDeepEquals([]);
    });

    it('should_return_transition_effect_array_when_extraNtfs_is_not_null_and_not_empty', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let mocker: MockKit = new MockKit();

      let mockExtraNtfComponentTransition_1: Function =
        mocker.mockFunc(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
      when(mockExtraNtfComponentTransition_1)(ArgumentMatchers.anyNumber).afterReturn(new TransitionEffect());

      let mockExtraNtfComponentTransition_2: Function =
        mocker.mockFunc(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
      when(mockExtraNtfComponentTransition_2)(ArgumentMatchers.anyNumber).afterReturn(new TransitionEffect());

      extrantfcollapsedanimation.extraNtfs = [new NotificationEntry(), new NotificationEntry()];
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result.length).assertEqual(2);

      mocker.ignoreMock(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
    });

    it('should_return_empty_array_when_extraNtfs_is_null', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result).assertDeepEquals([]);
    });

    it('should_return_empty_array_when_extraNtfs_is_empty', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      extrantfcollapsedanimation.extraNtfs = [];
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result).assertDeepEquals([]);
    });

    it('should_return_transition_effect_array_when_extraNtfs_is_not_null_and_not_empty', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let mocker: MockKit = new MockKit();

      let mockExtraNtfComponentTransition_1: Function =
        mocker.mockFunc(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
      when(mockExtraNtfComponentTransition_1)(ArgumentMatchers.anyNumber).afterReturn(new TransitionEffect());

      let mockExtraNtfComponentTransition_2: Function =
        mocker.mockFunc(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
      when(mockExtraNtfComponentTransition_2)(ArgumentMatchers.anyNumber).afterReturn(new TransitionEffect());

      extrantfcollapsedanimation.extraNtfs = [new NotificationEntry(), new NotificationEntry()];
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result.length).assertEqual(2);

      mocker.ignoreMock(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
    });

    it('should_return_empty_array_when_extraNtfs_is_null', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result).assertDeepEquals([]);
    });

    it('should_return_empty_array_when_extraNtfs_is_empty', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      extrantfcollapsedanimation.extraNtfs = [];
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result).assertDeepEquals([]);
    });

    it('should_return_transition_effect_array_when_extraNtfs_is_not_null_and_not_empty', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let mocker: MockKit = new MockKit();

      let mockExtraNtfComponentTransition_1: Function =
        mocker.mockFunc(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
      when(mockExtraNtfComponentTransition_1)(ArgumentMatchers.anyNumber).afterReturn(new TransitionEffect());

      let mockExtraNtfComponentTransition_2: Function =
        mocker.mockFunc(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
      when(mockExtraNtfComponentTransition_2)(ArgumentMatchers.anyNumber).afterReturn(new TransitionEffect());

      extrantfcollapsedanimation.extraNtfs = [new NotificationEntry(), new NotificationEntry()];
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result.length).assertEqual(2);

      mocker.ignoreMock(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
    });

    it('should_return_empty_array_when_extraNtfs_is_null', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result).assertDeepEquals([]);
    });

    it('should_return_empty_array_when_extraNtfs_is_empty', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      extrantfcollapsedanimation.extraNtfs = [];
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result).assertDeepEquals([]);
    });

    it('should_return_transition_effect_array_when_extraNtfs_is_not_null_and_not_empty', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let mocker: MockKit = new MockKit();

      let mockExtraNtfComponentTransition_1: Function =
        mocker.mockFunc(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
      when(mockExtraNtfComponentTransition_1)(ArgumentMatchers.anyNumber).afterReturn(new TransitionEffect());

      let mockExtraNtfComponentTransition_2: Function =
        mocker.mockFunc(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
      when(mockExtraNtfComponentTransition_2)(ArgumentMatchers.anyNumber).afterReturn(new TransitionEffect());

      extrantfcollapsedanimation.extraNtfs = [new NotificationEntry(), new NotificationEntry()];
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result.length).assertEqual(2);

      mocker.ignoreMock(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
    });

    it('should_return_empty_array_when_extraNtfs_is_null', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result).assertDeepEquals([]);
    });

    it('should_return_empty_array_when_extraNtfs_is_empty', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      extrantfcollapsedanimation.extraNtfs = [];
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result).assertDeepEquals([]);
    });

    it('should_return_transition_effect_array_when_extraNtfs_is_not_null_and_not_empty', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let mocker: MockKit = new MockKit();

      let mockExtraNtfComponentTransition_1: Function =
        mocker.mockFunc(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
      when(mockExtraNtfComponentTransition_1)(ArgumentMatchers.anyNumber).afterReturn(new TransitionEffect());

      let mockExtraNtfComponentTransition_2: Function =
        mocker.mockFunc(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
      when(mockExtraNtfComponentTransition_2)(ArgumentMatchers.anyNumber).afterReturn(new TransitionEffect());

      extrantfcollapsedanimation.extraNtfs = [new NotificationEntry(), new NotificationEntry()];
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result.length).assertEqual(2);

      mocker.ignoreMock(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
    });

    it('should_return_empty_array_when_extraNtfs_is_null', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result).assertDeepEquals([]);
    });

    it('should_return_empty_array_when_extraNtfs_is_empty', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      extrantfcollapsedanimation.extraNtfs = [];
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result).assertDeepEquals([]);
    });

    it('should_return_transition_effect_array_when_extraNtfs_is_not_null_and_not_empty', 0, () => {
      let extrantfcollapsedanimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let mocker: MockKit = new MockKit();

      let mockExtraNtfComponentTransition_1: Function =
        mocker.mockFunc(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
      when(mockExtraNtfComponentTransition_1)(ArgumentMatchers.anyNumber).afterReturn(new TransitionEffect());

      let mockExtraNtfComponentTransition_2: Function =
        mocker.mockFunc(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
      when(mockExtraNtfComponentTransition_2)(ArgumentMatchers.anyNumber).afterReturn(new TransitionEffect());

      extrantfcollapsedanimation.extraNtfs = [new NotificationEntry(), new NotificationEntry()];
      let result = extrantfcollapsedanimation.getExtraNtfAnimationArray();
      expect(result.length).assertEqual(2);

      mocker.ignoreMock(extrantfcollapsedanimation, extrantfcollapsedanimation.getExtraNtfComponentTransition);
    });
  });
}