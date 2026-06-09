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
import { image } from '@kit.ImageKit';
import { Context } from '@kit.AbilityKit';
import { HdsIconUtil } from '../../../main/ets/utils/HdsIconUtil';
import { process, taskpool } from '@kit.ArkTS';
import { DrawableDescriptor } from '@kit.ArkUI';
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { HdsIconTaskUtil } from '../../../main/ets/utils/HdsIconTaskUtil';

export default function HdsIconTaskUtilTest() {
  describe('getHdsIcon_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });
    it('should_execute_task_when_process_tid_equals_pid', 0, async () => {
      let context: Context = new Context();
      let bundleName: string = "com.example.app";
      let icon: DrawableDescriptor = new DrawableDescriptor();
      let mocker: MockKit = new MockKit();

      let mockTask: Function = mocker.mockFunc(taskpool, taskpool.execute);
      when(mockTask)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any)
        .afterReturn(Promise.resolve(new image.PixelMap()));

      let result = await HdsIconTaskUtil.getHdsIcon(context, bundleName, icon);
      expect(result).assertInstanceOf(image.PixelMap);

      mocker.ignoreMock(taskpool, taskpool.execute);
    });

    it('should_not_execute_task_when_process_tid_not_equals_pid', 0, async () => {
      let context: Context = new Context();
      let bundleName: string = "com.example.app";
      let icon: DrawableDescriptor = new DrawableDescriptor();
      let mocker: MockKit = new MockKit();

      let mockTask: Function = mocker.mockFunc(taskpool, taskpool.execute);
      when(mockTask)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any)
        .afterReturn(Promise.resolve(new image.PixelMap()));

      let originalTid = process.tid;
      process.tid = 0;
      let result = await HdsIconTaskUtil.getHdsIcon(context, bundleName, icon);
      expect(result).assertInstanceOf(image.PixelMap);
      process.tid = originalTid;

      mocker.ignoreMock(taskpool, taskpool.execute);
    });

    it('should_execute_taskpool_when_process_tid_equals_pid', 0, async () => {
      let context: Context = new Context();
      let iconInfos: Array<HdsIconUtil.IconInfo> = [new HdsIconUtil.IconInfo()];
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(process, process.tid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(process.pid);
      let result = await HdsIconTaskUtil.getHdsIconBatch(context, iconInfos);
      expect(result).assertInstanceOf(Array);
      mocker.ignoreMock(process, process.tid);
    });

    it('should_execute_doGetHdsIconBatch_when_process_tid_not_equals_pid', 0, async () => {
      let context: Context = new Context();
      let iconInfos: Array<HdsIconUtil.IconInfo> = [new HdsIconUtil.IconInfo()];
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(process, process.tid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(process.tid + 1);
      let result = await HdsIconTaskUtil.getHdsIconBatch(context, iconInfos);
      expect(result).assertInstanceOf(Array);
      mocker.ignoreMock(process, process.tid);
    });

    it('should_return_empty_array_when_iconInfos_is_empty', 0, async () => {
      let context: Context = new Context();
      let iconInfos: Array<HdsIconUtil.IconInfo> = [];
      let result = await HdsIconTaskUtil.getHdsIconBatch(context, iconInfos);
      expect(result).assertDeepEquals([]);
    });

    it('should_return_array_with_length_greater_than_0_when_iconInfos_is_not_empty', 0, async () => {
      let context: Context = new Context();
      let iconInfos: Array<HdsIconUtil.IconInfo> = [new HdsIconUtil.IconInfo(), new HdsIconUtil.IconInfo()];
      let result = await HdsIconTaskUtil.getHdsIconBatch(context, iconInfos);
      expect(result.length).assertLarger(0);
    });

    it('should_return_array_with_correct_length_when_iconInfos_has_different_sizes', 0, async () => {
      let context: Context = new Context();
      let iconInfos: Array<HdsIconUtil.IconInfo> =
        [new HdsIconUtil.IconInfo(), new HdsIconUtil.IconInfo(), new HdsIconUtil.IconInfo()];
      let result = await HdsIconTaskUtil.getHdsIconBatch(context, iconInfos);
      expect(result.length).assertEqual(iconInfos.length);
    });

    it('should_return_array_with_correct_length_when_iconInfos_has_same_sizes', 0, async () => {
      let context: Context = new Context();
      let iconInfos: Array<HdsIconUtil.IconInfo> =
        [new HdsIconUtil.IconInfo(), new HdsIconUtil.IconInfo(), new HdsIconUtil.IconInfo(),
          new HdsIconUtil.IconInfo()];
      let result = await HdsIconTaskUtil.getHdsIconBatch(context, iconInfos);
      expect(result.length).assertEqual(iconInfos.length);
    });

    it('should_return_array_with_correct_length_when_iconInfos_has_large_sizes', 0, async () => {
      let context: Context = new Context();
      let iconInfos: Array<HdsIconUtil.IconInfo> = new Array(1000).fill(new HdsIconUtil.IconInfo());
      let result = await HdsIconTaskUtil.getHdsIconBatch(context, iconInfos);
      expect(result.length).assertEqual(iconInfos.length);
    });

    it('should_return_array_with_correct_length_when_iconInfos_has_same_sizes_as_taskpool_batch_size', 0, async () => {
      let context: Context = new Context();
      let iconInfos: Array<HdsIconUtil.IconInfo> = new Array(taskpool.getBatchSize()).fill(new HdsIconUtil.IconInfo());
      let result = await HdsIconTaskUtil.getHdsIconBatch(context, iconInfos);
      expect(result.length).assertEqual(iconInfos.length);
    });

    it('should_return_array_with_correct_length_when_iconInfos_has_greater_sizes_than_taskpool_batch_size', 0,
      async () => {
        let context: Context = new Context();
        let iconInfos: Array<HdsIconUtil.IconInfo> =
          new Array(taskpool.getBatchSize() + 100).fill(new HdsIconUtil.IconInfo());
        let result = await HdsIconTaskUtil.getHdsIconBatch(context, iconInfos);
        expect(result.length).assertEqual(iconInfos.length);
      });

    it('should_return_array_with_correct_length_when_iconInfos_has_sizes_that_are_multiple_of_taskpool_batch_size', 0,
      async () => {
        let context: Context = new Context();
        let iconInfos: Array<HdsIconUtil.IconInfo> =
          new Array(taskpool.getBatchSize() * 5).fill(new HdsIconUtil.IconInfo());
        let result = await HdsIconTaskUtil.getHdsIconBatch(context, iconInfos);
        expect(result.length).assertEqual(iconInfos.length);
      });

    it('should_return_array_with_correct_length_when_iconInfos_has_sizes_that_are_multiple_of_taskpool_batch_size_plus_remaining_items',
      0, async () => {
        let context: Context = new Context();
        let iconInfos: Array<HdsIconUtil.IconInfo> =
          new Array(taskpool.getBatchSize() * 5 + 100).fill(new HdsIconUtil.IconInfo());
        let result = await HdsIconTaskUtil.getHdsIconBatch(context, iconInfos);
        expect(result.length).assertEqual(iconInfos.length);
      });

    it('should_return_array_with_correct_length_when_iconInfos_has_sizes_that_are_multiple_of_taskpool_batch_size_plus_remaining_items_and_batch_size_is_changed',
      0, async () => {
        let context: Context = new Context();
        let iconInfos: Array<HdsIconUtil.IconInfo> =
          new Array(taskpool.getBatchSize() * 5 + 100).fill(new HdsIconUtil.IconInfo());
        taskpool.setBatchSize(200);
        let result = await HdsIconTaskUtil.getHdsIconBatch(context, iconInfos);
        expect(result.length).assertEqual(iconInfos.length);
        taskpool.setBatchSize(50);
      });

    it('should_return_array_with_correct_length_when_iconInfos_has_sizes_that_are_multiple_of_taskpool_batch_size_plus_remaining_items_and_batch_size_is_changed_back',
      0, async () => {
        let context: Context = new Context();
        let iconInfos: Array<HdsIconUtil.IconInfo> =
          new Array(taskpool.getBatchSize() * 5 + 100).fill(new HdsIconUtil.IconInfo());
        taskpool.setBatchSize(200);
        let result = await HdsIconTaskUtil.getHdsIconBatch(context, iconInfos);
        expect(result.length).assertEqual(iconInfos.length);
        taskpool.setBatchSize(50);
      });

    it('should_return_pixelMap_when_getHdsIcon_returns_pixelMap', 0, async () => {
      let context: Context = new Context();
      let bundleName: string = "testBundle";
      let icon: DrawableDescriptor = new DrawableDescriptor();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(HdsIconUtil, HdsIconUtil.getHdsIcon);
      let pixelMap: image.PixelMap = new image.PixelMap();
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn(pixelMap);
      const result = await doGetHdsIcon(context, bundleName, icon);
      expect(result).assertInstanceOf(image.PixelMap);
      mocker.ignoreMock(HdsIconUtil, HdsIconUtil.getHdsIcon);
    });

    it('should_return_undefined_when_getHdsIcon_returns_undefined', 0, async () => {
      let context: Context = new Context();
      let bundleName: string = "testBundle";
      let icon: DrawableDescriptor = new DrawableDescriptor();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(HdsIconUtil, HdsIconUtil.getHdsIcon);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturn(undefined);
      const result = await doGetHdsIcon(context, bundleName, icon);
      expect(result).assertUndefined();
      mocker.ignoreMock(HdsIconUtil, HdsIconUtil.getHdsIcon);
    });

    it('should_return_pixelMap_when_getHdsIcon_throws_error', 0, async () => {
      let context: Context = new Context();
      let bundleName: string = "testBundle";
      let icon: DrawableDescriptor = new DrawableDescriptor();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(HdsIconUtil, HdsIconUtil.getHdsIcon);
      let pixelMap: image.PixelMap = new image.PixelMap();
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterThrow("Error");
      try {
        const result = await doGetHdsIcon(context, bundleName, icon);
      } catch (e) {
        expect(e.message).assertEqual("Error");
      }
      mocker.ignoreMock(HdsIconUtil, HdsIconUtil.getHdsIcon);
    });

    it('should_return_empty_array_when_iconInfos_is_empty', 0, async () => {
      let context: Context = new Context();
      let iconInfos: Array<IconInfo> = [];

      const result = await doGetHdsIconBatch(context, iconInfos);
      expect(result.length).assertEqual(0);
    });

    it('should_handle_error_when_getHdsIcon_throws_error', 0, async () => {
      let context: Context = new Context();
      let iconInfos: Array<IconInfo> = [
        {
          bundleName: 'com.example.app',
          icon: 'icon1'
        }
      ];
      let mocker: MockKit = new MockKit();
      let mockHdsIconUtil: HdsIconUtil = HdsIconUtil.INSTANCE;
      let mockGetHdsIcon: Function = mocker.mockFunc(mockHdsIconUtil, mockHdsIconUtil.getHdsIcon);
      when(mockGetHdsIcon)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterThrow('Error');
      try {
        await doGetHdsIconBatch(context, iconInfos);
        assertFail('Expected an error to be thrown');
      } catch (e) {
        expect(e.message).assertEqual('Error');
      }
      mocker.ignoreMock(mockHdsIconUtil, mockHdsIconUtil.getHdsIcon);
    });
  });
}