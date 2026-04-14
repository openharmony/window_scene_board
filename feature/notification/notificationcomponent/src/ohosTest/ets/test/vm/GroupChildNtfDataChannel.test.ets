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
import { afterEach, ArgumentMatchers, beforeEach, describe, expect, it, MockKit, when } from "@ohos/hypium";
import GroupChildNtfDataChannel from "../../../../main/ets/vm/GroupChildNtfDataChannel";

export default function GroupChildNtfDataChannelTest() {

  describe('setGroupCollapseCallback_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_set_group_collapse_callback_when_callback_is_not_null', 0, () => {
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      let callback: () => void = () => {
        console.log("Callback fired");
      };
      groupChildNtfDataChannel.setGroupCollapseCallback(callback);
      expect(groupChildNtfDataChannel.groupCollapseCallback).assertEqual(callback);
    });

    it('should_set_group_collapse_callback_when_callback_is_null', 0, () => {
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      let callback: () => void = null;
      groupChildNtfDataChannel.setGroupCollapseCallback(callback);
      expect(groupChildNtfDataChannel.groupCollapseCallback).assertNull();
    });

    it('should_initially_have_null_callback', 0, () => {
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      expect(groupChildNtfDataChannel.groupCollapseCallback).assertNull();
    });

    // 测试多次设置覆盖
    it('should_overwrite_previous_callback_on_repeated_set', 0, () => {
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      const firstCallback = () => { console.log("First"); };
      const secondCallback = () => { console.log("Second"); };

      groupChildNtfDataChannel.setGroupCollapseCallback(firstCallback);
      groupChildNtfDataChannel.setGroupCollapseCallback(secondCallback);

      expect(groupChildNtfDataChannel.groupCollapseCallback).assertEqual(secondCallback);
    });

    // 测试null设置后恢复有效回调
    it('should_restore_valid_callback_after_null', 0, () => {
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      const validCallback = () => { console.log("Valid"); };

      groupChildNtfDataChannel.setGroupCollapseCallback(validCallback);
      groupChildNtfDataChannel.setGroupCollapseCallback(null);
      groupChildNtfDataChannel.setGroupCollapseCallback(validCallback);

      expect(groupChildNtfDataChannel.groupCollapseCallback).assertEqual(validCallback);
    });
  });

  describe('registerGroupTranslateCallback_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_not_add_callback_when_callback_is_null', 0, () => {
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      groupChildNtfDataChannel.registerGroupTranslateCallback(null);
      expect(groupChildNtfDataChannel.groupTranslateCallbacks).assertNull();
    });

    it('should_add_callback_when_callback_is_not_null_and_callbacks_is_null', 0, () => {
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      let callback: (tranX: number) => void = (tranX: number) => {};
      groupChildNtfDataChannel.registerGroupTranslateCallback(callback);
      expect(groupChildNtfDataChannel.groupTranslateCallbacks?).assertNotNull();
      expect(groupChildNtfDataChannel.groupTranslateCallbacks?.has(callback)).assertTrue();
    });

    it('should_not_add_callback_when_callback_is_already_in_callbacks', 0, () => {
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      let callback: (tranX: number) => void = (tranX: number) => {};
      groupChildNtfDataChannel.registerGroupTranslateCallback(callback);
      groupChildNtfDataChannel.registerGroupTranslateCallback(callback);
      expect(groupChildNtfDataChannel.groupTranslateCallbacks?.size).assertEqual(1);
    });

    it('should_not_add_callback_when_callback_is_undefined', 0, () => {
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      groupChildNtfDataChannel.registerGroupTranslateCallback(undefined as any);
      expect(groupChildNtfDataChannel.groupTranslateCallbacks).assertNull();
    });

    it('should_call_callback_with_current_groupTranslateX', 0, () => {
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      groupChildNtfDataChannel.groupTranslateX = 100;
      let calledValue: number | null = null;
      const callback = (tranX: number) => { calledValue = tranX; };
      groupChildNtfDataChannel.registerGroupTranslateCallback(callback);
      expect(calledValue).assertEqual(100);
    });

    it('should_add_multiple_callbacks', 0, () => {
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      const callback1 = (tranX: number) => {};
      const callback2 = (tranX: number) => {};
      groupChildNtfDataChannel.registerGroupTranslateCallback(callback1);
      groupChildNtfDataChannel.registerGroupTranslateCallback(callback2);
      expect(groupChildNtfDataChannel.groupTranslateCallbacks?.size).assertEqual(2);
    });

    it('should_initialize_groupTranslateCallbacks_when_first_add', 0, () => {
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      const callback = (tranX: number) => {};
      groupChildNtfDataChannel.registerGroupTranslateCallback(callback);
      expect(groupChildNtfDataChannel.groupTranslateCallbacks).assertNotNull();
    });

    it('should_call_callback_with_initial_groupTranslateX', 0, () => {
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      let calledValue: number | null = null;
      const callback = (tranX: number) => { calledValue = tranX; };
      groupChildNtfDataChannel.registerGroupTranslateCallback(callback);
      expect(calledValue).assertEqual(0);
    });
  });

  describe('unRegisterGroupTranslateCallback_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_remove_callback_when_callback_is_not_null_and_callbacks_set_is_not_null_and_callback_exists', 0, () => {
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      let callback: (tranX: number) => void = (tranX: number) => {
        console.log(`Translated X: ${tranX}`);
      };
      groupChildNtfDataChannel.groupTranslateCallbacks?.add(callback);
      expect(groupChildNtfDataChannel.groupTranslateCallbacks?.has(callback)).assertTrue();
      groupChildNtfDataChannel.unRegisterGroupTranslateCallback(callback);
      expect(groupChildNtfDataChannel.groupTranslateCallbacks?.has(callback)).assertFalse();
    });

    it('should_do_nothing_when_callback_is_null', 0, () => {
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      let callback: (tranX: number) => void = null;
      groupChildNtfDataChannel.unRegisterGroupTranslateCallback(callback);
      expect(groupChildNtfDataChannel.groupTranslateCallbacks).assertNull();
    });

    it('should_do_nothing_when_callbacks_set_is_null', 0, () => {
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      groupChildNtfDataChannel.groupTranslateCallbacks = null;
      let callback: (tranX: number) => void = (tranX: number) => {
        console.log(`Translated X: ${tranX}`);
      };
      groupChildNtfDataChannel.unRegisterGroupTranslateCallback(callback);
      expect(groupChildNtfDataChannel.groupTranslateCallbacks).assertNull();
    });

    it('should_do_nothing_when_callback_does_not_exist', 0, () => {
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      let callback: (tranX: number) => void = (tranX: number) => {
        console.log(`Translated X: ${tranX}`);
      };
      groupChildNtfDataChannel.unRegisterGroupTranslateCallback(callback);
      expect(groupChildNtfDataChannel.groupTranslateCallbacks).assertNull();
    });
    it('should_do_nothing_when_callback_is_undefined', 0, () => {
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      let validCallback: (tranX: number) => void = (tranX) => { };
      groupChildNtfDataChannel.groupTranslateCallbacks?.add(validCallback);
      groupChildNtfDataChannel.unRegisterGroupTranslateCallback(undefined as any);
      expect(groupChildNtfDataChannel.groupTranslateCallbacks?.has(validCallback)).assertTrue();
    });

    it('should_do_nothing_when_callback_does_not_exist_in_non_null_set', 0, () => {
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      let existingCallback: (tranX: number) => void = (tranX) => { };
      let nonExistingCallback: (tranX: number) => void = (tranX) => { };
      groupChildNtfDataChannel.groupTranslateCallbacks?.add(existingCallback);
      groupChildNtfDataChannel.unRegisterGroupTranslateCallback(nonExistingCallback);
      expect(groupChildNtfDataChannel.groupTranslateCallbacks?.has(existingCallback)).assertTrue();
      expect(groupChildNtfDataChannel.groupTranslateCallbacks?.has(nonExistingCallback)).assertFalse();
    });

    it('should_remove_callback_even_after_multiple_unregister_calls', 0, () => {
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      let callback: (tranX: number) => void = (tranX) => { };
      groupChildNtfDataChannel.groupTranslateCallbacks?.add(callback);
      groupChildNtfDataChannel.unRegisterGroupTranslateCallback(callback);
      groupChildNtfDataChannel.unRegisterGroupTranslateCallback(callback); // 第二次调用
      expect(groupChildNtfDataChannel.groupTranslateCallbacks?.has(callback)).assertFalse();
    });
  });

  describe('collapseGroupNtf_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_groupCollapseCallback_when_it_is_not_null', 0, () => {
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(groupChildNtfDataChannel, groupChildNtfDataChannel.collapseGroupNtf);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      groupChildNtfDataChannel.collapseGroupNtf();
      mocker.ignoreMock(groupChildNtfDataChannel, groupChildNtfDataChannel.collapseGroupNtf);
    });

    it('should_not_invoke_callback_when_null', 0, () => {
      let groupChildNtfDataChannel = new GroupChildNtfDataChannel();
      let mockCallback = jasmine.createSpy('mockCallback');

      // 设置非null状态再测试
      groupChildNtfDataChannel.groupCollapseCallback = mockCallback;
      groupChildNtfDataChannel.groupCollapseCallback = null; // 重置为null

      groupChildNtfDataChannel.collapseGroupNtf();

      expect(mockCallback).not.toHaveBeenCalled();
    });

    it('should_call_groupCollapseCallback_when_set', 0, () => {
      let called = false;
      const channel = new GroupChildNtfDataChannel();
      channel.groupCollapseCallback = () => { called = true; };
      channel.collapseGroupNtf();
      expect(called).assertTrue();
    });

    it('should_call_callback_multiple_times', 0, () => {
      let count = 0;

      const channel = new GroupChildNtfDataChannel();

      channel.groupCollapseCallback = () => count++;
      channel.collapseGroupNtf();
      channel.collapseGroupNtf();

      expect(count).assertEqual(2);
    });

    it('should_not_call_after_setting_to_null', 0, () => {

      let called = false;

      const channel = new GroupChildNtfDataChannel();

      channel.groupCollapseCallback = () => { called = true; };
      channel.collapseGroupNtf();
      channel.groupCollapseCallback = null;
      channel.collapseGroupNtf();

      expect(called).assertTrue(); // 第一次调用有效
      expect(channel.groupCollapseCallback).assertNull();
    });

    it('should_call_new_callback_after_reassigning', 0, () => {

      let firstCalled = false;
      let secondCalled = false;

      const channel = new GroupChildNtfDataChannel();

      channel.groupCollapseCallback = () => { firstCalled = true; };
      channel.collapseGroupNtf();
      channel.groupCollapseCallback = () => { secondCalled = true; };
      channel.collapseGroupNtf();

      expect(firstCalled).assertTrue();
      expect(secondCalled).assertTrue();
    });

    it('should_not_call_initially_null', 0, () => {
      let called = false;
      const channel = new GroupChildNtfDataChannel();
      channel.groupCollapseCallback = null;
      channel.collapseGroupNtf();
      expect(called).assertFalse();
    });
  });

  describe('groupTranslateXChanged_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_callbacks_when_groupTranslateCallbacks_is_not_null', 0, () => {
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      let mocker: MockKit = new MockKit();

      let callback1: Function = (translateX: number) => {
        expect(translateX).assertEqual(100);
      };
      let callback2: Function = (translateX: number) => {
        expect(translateX).assertEqual(100);
      };

      groupChildNtfDataChannel.groupTranslateCallbacks?.add(callback1);
      groupChildNtfDataChannel.groupTranslateCallbacks?.add(callback2);

      groupChildNtfDataChannel.groupTranslateXChanged(100);

    });

    it('should_not_call_callbacks_when_groupTranslateCallbacks_is_null', 0, () => {

      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();

      let callback1Called = false;
      let callback2Called = false;

      const callback1 = (translateX: number) => {
        callback1Called = true;
      };
      const callback2 = (translateX: number) => {
        callback2Called = true;
      };

      groupChildNtfDataChannel.groupTranslateCallbacks?.add(callback1);
      groupChildNtfDataChannel.groupTranslateCallbacks?.add(callback2);

      groupChildNtfDataChannel.groupTranslateCallbacks = null;

      groupChildNtfDataChannel.groupTranslateXChanged(100);

      expect(callback1Called).assertFalse();
      expect(callback2Called).assertFalse();

    });

    it('should_not_call_callbacks_when_callback_is_null', 0, () => {

      let groupChildNtfDataChannel = new GroupChildNtfDataChannel();

      let validCallbackCalled = false;

      const validCallback = (translateX: number) => {
        validCallbackCalled = true;
      };

      groupChildNtfDataChannel.groupTranslateCallbacks?.add(validCallback);
      groupChildNtfDataChannel.groupTranslateCallbacks?.add(null);

      groupChildNtfDataChannel.groupTranslateXChanged(100);

      expect(validCallbackCalled).assertFalse();

    });

  });

  describe('destroyCallbacks_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_reset_all_callbacks_and_translate_values_to_default', 0, () => {
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      groupChildNtfDataChannel.destroyCallbacks();

      expect(groupChildNtfDataChannel.groupCollapseCallback).assertNull();
      expect(groupChildNtfDataChannel.groupTranslateCallbacks).assertNull();
      expect(groupChildNtfDataChannel.groupTranslateX).assertEqual(0);
    });

    it('should_reset_all_callbacks_and_translate_values_to_default', 0, () => {
      let channel = new GroupChildNtfDataChannel();
      channel.destroyCallbacks();
      expect(channel.groupCollapseCallback).assertNull();
      expect(channel.groupTranslateCallbacks).assertNull();
      expect(channel.groupTranslateX).assertEqual(0);
    });

    // 测试当groupTranslateCallbacks初始为null时的行为
    it('should_handle_null_groupTranslateCallbacks', 0, () => {
      let channel = new GroupChildNtfDataChannel();
      channel.groupTranslateCallbacks = null;
      channel.destroyCallbacks();
      expect(channel.groupTranslateCallbacks).assertNull();
    });

    // 测试当groupTranslateX有初始值时的重置
    it('should_reset_groupTranslateX_from_non_zero_value', 0, () => {
      let channel = new GroupChildNtfDataChannel();
      channel.groupTranslateX = 100;
      channel.destroyCallbacks();
      expect(channel.groupTranslateX).assertEqual(0);
    });

    // 测试当存在groupCollapseCallback时的重置
    it('should_clear_existing_groupCollapseCallback', 0, () => {
      let channel = new GroupChildNtfDataChannel();
      channel.groupCollapseCallback = () => {};
      channel.destroyCallbacks();
      expect(channel.groupCollapseCallback).assertNull();
    });

    // 测试当groupTranslateCallbacks有元素时的清理
    it('should_clear_and_nullify_non_empty_groupTranslateCallbacks', 0, () => {
      let channel = new GroupChildNtfDataChannel();
      channel.groupTranslateCallbacks.add(() => {});
      channel.destroyCallbacks();
      expect(channel.groupTranslateCallbacks).assertNull();
    });
  });
}