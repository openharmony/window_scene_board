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
import {
  notificationSettingManager
} from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/NotificationSettingManager';
import { AppLstComponentViewModel } from '@ohos/managementcomponent/src/main/ets/com/ohos/vm/appLstComponentViewModel';
import { describe, beforeEach, afterEach, it, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NtfLiveViewViewData } from '../../../../../main/ets/vm/NtfLiveViewViewData';

export default function NtfLiveViewViewDataTest() {
  describe('init_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_call_refresh_subscribeSlotChangeEvent_01', 0, async () => {
      let ntfliveviewviewdata: NtfLiveViewViewData = new NtfLiveViewViewData();
      let mocker: MockKit = new MockKit();

      let mockLiveviewlistInit: Function = mocker.mockFunc(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      when(mockLiveviewlistInit)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockSubscribeChangeEvent: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
      when(mockSubscribeChangeEvent)(ArgumentMatchers.any).afterReturnNothing();

      ntfliveviewviewdata.init();

      mocker.verify('liveviewlistInit', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
    });

    it('should_call_refresh_subscribeSlotChangeEvent_02', 0, async () => {
      let ntfliveviewviewdata: NtfLiveViewViewData = new NtfLiveViewViewData();
      let mocker: MockKit = new MockKit();

      let mockLiveviewlistInit: Function = mocker.mockFunc(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      when(mockLiveviewlistInit)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockSubscribeChangeEvent: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
      when(mockSubscribeChangeEvent)(ArgumentMatchers.any).afterReturnNothing();

      ntfliveviewviewdata.init();
      mocker.verify('liveviewlistInit', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
    });

    it('should_call_refresh_subscribeSlotChangeEvent_03', 0, async () => {
      let ntfliveviewviewdata: NtfLiveViewViewData = new NtfLiveViewViewData();
      let mocker: MockKit = new MockKit();

      let mockLiveviewlistInit: Function = mocker.mockFunc(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      when(mockLiveviewlistInit)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockSubscribeChangeEvent: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
      when(mockSubscribeChangeEvent)(ArgumentMatchers.any).afterReturnNothing();

      ntfliveviewviewdata.init();
      mocker.verify('liveviewlistInit', [ArgumentMatchers.any]).once();

      mocker.ignoreMock(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
    });

    it('should_call_refresh_subscribeSlotChangeEvent_04', 0, async () => {
      let ntfliveviewviewdata: NtfLiveViewViewData = new NtfLiveViewViewData();
      let mocker: MockKit = new MockKit();

      let mockLiveviewlistInit: Function = mocker.mockFunc(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      when(mockLiveviewlistInit)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockSubscribeChangeEvent: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
      when(mockSubscribeChangeEvent)(ArgumentMatchers.any).afterReturnNothing();

      ntfliveviewviewdata.init();
      mocker.verify('liveviewlistInit', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
    });

    it('should_call_refresh_subscribeSlotChangeEvent_05', 0, async () => {
      let ntfliveviewviewdata: NtfLiveViewViewData = new NtfLiveViewViewData();
      let mocker: MockKit = new MockKit();

      let mockLiveviewlistInit: Function = mocker.mockFunc(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      when(mockLiveviewlistInit)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockSubscribeChangeEvent: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
      when(mockSubscribeChangeEvent)(ArgumentMatchers.any).afterReturnNothing();

      ntfliveviewviewdata.init();
      mocker.verify('liveviewlistInit', [ArgumentMatchers.any]).once();

      mocker.ignoreMock(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
    });

    it('should_call_refresh_subscribeSlotChangeEvent_06', 0, async () => {
      let ntfliveviewviewdata: NtfLiveViewViewData = new NtfLiveViewViewData();
      let mocker: MockKit = new MockKit();

      let mockLiveviewlistInit: Function = mocker.mockFunc(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      when(mockLiveviewlistInit)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockSubscribeChangeEvent: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
      when(mockSubscribeChangeEvent)(ArgumentMatchers.any).afterReturnNothing();

      ntfliveviewviewdata.init();
      mocker.verify('liveviewlistInit', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
    });

    it('should_call_refresh_subscribeSlotChangeEvent_07', 0, async () => {
      let ntfliveviewviewdata: NtfLiveViewViewData = new NtfLiveViewViewData();
      let mocker: MockKit = new MockKit();

      let mockLiveviewlistInit: Function = mocker.mockFunc(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      when(mockLiveviewlistInit)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockSubscribeChangeEvent: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
      when(mockSubscribeChangeEvent)(ArgumentMatchers.any).afterReturnNothing();

      ntfliveviewviewdata.init();
      mocker.verify('liveviewlistInit', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
    });

    it('should_call_refresh_subscribeSlotChangeEvent_08', 0, async () => {
      let ntfliveviewviewdata: NtfLiveViewViewData = new NtfLiveViewViewData();
      let mocker: MockKit = new MockKit();

      let mockLiveviewlistInit: Function = mocker.mockFunc(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      when(mockLiveviewlistInit)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockSubscribeChangeEvent: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
      when(mockSubscribeChangeEvent)(ArgumentMatchers.any).afterReturnNothing();

      ntfliveviewviewdata.init();
      mocker.verify('liveviewlistInit', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
    });

    it('should_call_refresh_subscribeSlotChangeEvent_09', 0, async () => {
      let ntfliveviewviewdata: NtfLiveViewViewData = new NtfLiveViewViewData();
      let mocker: MockKit = new MockKit();

      let mockLiveviewlistInit: Function = mocker.mockFunc(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      when(mockLiveviewlistInit)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockSubscribeChangeEvent: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
      when(mockSubscribeChangeEvent)(ArgumentMatchers.any).afterReturnNothing();

      ntfliveviewviewdata.init();
      mocker.verify('liveviewlistInit', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
    });

    it('should_call_refresh_subscribeSlotChangeEvent_10', 0, async () => {
      let ntfliveviewviewdata: NtfLiveViewViewData = new NtfLiveViewViewData();
      let mocker: MockKit = new MockKit();

      let mockLiveviewlistInit: Function = mocker.mockFunc(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      when(mockLiveviewlistInit)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockSubscribeChangeEvent: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
      when(mockSubscribeChangeEvent)(ArgumentMatchers.any).afterReturnNothing();

      ntfliveviewviewdata.init();
      mocker.verify('liveviewlistInit', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
    });

    it('should_call_refresh_subscribeSlotChangeEvent_11', 0, async () => {
      let ntfliveviewviewdata: NtfLiveViewViewData = new NtfLiveViewViewData();
      let mocker: MockKit = new MockKit();

      let mockLiveviewlistInit: Function = mocker.mockFunc(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      when(mockLiveviewlistInit)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockSubscribeChangeEvent: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
      when(mockSubscribeChangeEvent)(ArgumentMatchers.any).afterReturnNothing();

      ntfliveviewviewdata.init();
      mocker.verify('liveviewlistInit', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
    });

    it('should_call_refresh_subscribeSlotChangeEvent_12', 0, async () => {
      let ntfliveviewviewdata: NtfLiveViewViewData = new NtfLiveViewViewData();
      let mocker: MockKit = new MockKit();

      let mockLiveviewlistInit: Function = mocker.mockFunc(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      when(mockLiveviewlistInit)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockSubscribeChangeEvent: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
      when(mockSubscribeChangeEvent)(ArgumentMatchers.any).afterReturnNothing();

      ntfliveviewviewdata.init();
      mocker.verify('liveviewlistInit', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
    });

    it('should_call_refresh_subscribeSlotChangeEvent_13', 0, async () => {
      let ntfliveviewviewdata: NtfLiveViewViewData = new NtfLiveViewViewData();
      let mocker: MockKit = new MockKit();

      let mockLiveviewlistInit: Function = mocker.mockFunc(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      when(mockLiveviewlistInit)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockSubscribeChangeEvent: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
      when(mockSubscribeChangeEvent)(ArgumentMatchers.any).afterReturnNothing();

      ntfliveviewviewdata.init();
      mocker.verify('liveviewlistInit', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
    });

    it('should_call_refresh_subscribeSlotChangeEvent_14', 0, async () => {
      let ntfliveviewviewdata: NtfLiveViewViewData = new NtfLiveViewViewData();
      let mocker: MockKit = new MockKit();

      let mockLiveviewlistInit: Function = mocker.mockFunc(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      when(mockLiveviewlistInit)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockSubscribeChangeEvent: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
      when(mockSubscribeChangeEvent)(ArgumentMatchers.any).afterReturnNothing();

      ntfliveviewviewdata.init();
      mocker.verify('liveviewlistInit', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
    });

    it('should_call_refresh_subscribeSlotChangeEvent_15', 0, async () => {
      let ntfliveviewviewdata: NtfLiveViewViewData = new NtfLiveViewViewData();
      let mocker: MockKit = new MockKit();

      let mockLiveviewlistInit: Function = mocker.mockFunc(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      when(mockLiveviewlistInit)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockSubscribeChangeEvent: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
      when(mockSubscribeChangeEvent)(ArgumentMatchers.any).afterReturnNothing();

      ntfliveviewviewdata.init();
      mocker.verify('liveviewlistInit', [ArgumentMatchers.any]).once();

      mocker.ignoreMock(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
    });

    it('should_call_refresh_subscribeSlotChangeEvent_16', 0, async () => {
      let ntfliveviewviewdata: NtfLiveViewViewData = new NtfLiveViewViewData();
      let mocker: MockKit = new MockKit();

      let mockLiveviewlistInit: Function = mocker.mockFunc(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      when(mockLiveviewlistInit)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockSubscribeChangeEvent: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
      when(mockSubscribeChangeEvent)(ArgumentMatchers.any).afterReturnNothing();

      ntfliveviewviewdata.init();
      mocker.verify('liveviewlistInit', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
    });

    it('should_call_refresh_subscribeSlotChangeEvent_17', 0, async () => {
      let ntfliveviewviewdata: NtfLiveViewViewData = new NtfLiveViewViewData();
      let mocker: MockKit = new MockKit();

      let mockLiveviewlistInit: Function = mocker.mockFunc(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      when(mockLiveviewlistInit)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockSubscribeChangeEvent: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
      when(mockSubscribeChangeEvent)(ArgumentMatchers.any).afterReturnNothing();

      ntfliveviewviewdata.init();
      mocker.verify('liveviewlistInit', [ArgumentMatchers.any]).once();

      mocker.ignoreMock(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
    });

    it('should_call_refresh_subscribeSlotChangeEvent_18', 0, async () => {
      let ntfliveviewviewdata: NtfLiveViewViewData = new NtfLiveViewViewData();
      let mocker: MockKit = new MockKit();

      let mockLiveviewlistInit: Function = mocker.mockFunc(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      when(mockLiveviewlistInit)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockSubscribeChangeEvent: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
      when(mockSubscribeChangeEvent)(ArgumentMatchers.any).afterReturnNothing();

      ntfliveviewviewdata.init();
      mocker.verify('liveviewlistInit', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
    });

    it('should_call_refresh_subscribeSlotChangeEvent_19', 0, async () => {
      let ntfliveviewviewdata: NtfLiveViewViewData = new NtfLiveViewViewData();
      let mocker: MockKit = new MockKit();

      let mockLiveviewlistInit: Function = mocker.mockFunc(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      when(mockLiveviewlistInit)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockSubscribeChangeEvent: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
      when(mockSubscribeChangeEvent)(ArgumentMatchers.any).afterReturnNothing();

      ntfliveviewviewdata.init();
      mocker.verify('liveviewlistInit', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
    });

    it('should_call_refresh_subscribeSlotChangeEvent_20', 0, async () => {
      let ntfliveviewviewdata: NtfLiveViewViewData = new NtfLiveViewViewData();
      let mocker: MockKit = new MockKit();

      let mockLiveviewlistInit: Function = mocker.mockFunc(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      when(mockLiveviewlistInit)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockSubscribeChangeEvent: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
      when(mockSubscribeChangeEvent)(ArgumentMatchers.any).afterReturnNothing();

      ntfliveviewviewdata.init();
      mocker.verify('liveviewlistInit', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
    });

    it('should_call_refresh_subscribeSlotChangeEvent_21', 0, async () => {
      let ntfliveviewviewdata: NtfLiveViewViewData = new NtfLiveViewViewData();
      let mocker: MockKit = new MockKit();

      let mockLiveviewlistInit: Function = mocker.mockFunc(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      when(mockLiveviewlistInit)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockSubscribeChangeEvent: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
      when(mockSubscribeChangeEvent)(ArgumentMatchers.any).afterReturnNothing();

      ntfliveviewviewdata.init();
      mocker.verify('liveviewlistInit', [ArgumentMatchers.any]).once();

      mocker.ignoreMock(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
    });

    it('should_call_refresh_subscribeSlotChangeEvent_22', 0, async () => {
      let ntfliveviewviewdata: NtfLiveViewViewData = new NtfLiveViewViewData();
      let mocker: MockKit = new MockKit();

      let mockLiveviewlistInit: Function = mocker.mockFunc(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      when(mockLiveviewlistInit)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockSubscribeChangeEvent: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
      when(mockSubscribeChangeEvent)(ArgumentMatchers.any).afterReturnNothing();

      ntfliveviewviewdata.init();
      mocker.verify('liveviewlistInit', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
    });

    it('should_call_refresh_subscribeSlotChangeEvent_23', 0, async () => {
      let ntfliveviewviewdata: NtfLiveViewViewData = new NtfLiveViewViewData();
      let mocker: MockKit = new MockKit();

      let mockLiveviewlistInit: Function = mocker.mockFunc(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      when(mockLiveviewlistInit)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockSubscribeChangeEvent: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
      when(mockSubscribeChangeEvent)(ArgumentMatchers.any).afterReturnNothing();

      ntfliveviewviewdata.init();
      mocker.verify('liveviewlistInit', [ArgumentMatchers.any]).once();

      mocker.ignoreMock(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
    });

    it('should_call_refresh_subscribeSlotChangeEvent_24', 0, async () => {
      let ntfliveviewviewdata: NtfLiveViewViewData = new NtfLiveViewViewData();
      let mocker: MockKit = new MockKit();

      let mockLiveviewlistInit: Function = mocker.mockFunc(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      when(mockLiveviewlistInit)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockSubscribeChangeEvent: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
      when(mockSubscribeChangeEvent)(ArgumentMatchers.any).afterReturnNothing();

      ntfliveviewviewdata.init();
      mocker.verify('liveviewlistInit', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
    });

    it('should_call_refresh_subscribeSlotChangeEvent_25', 0, async () => {
      let ntfliveviewviewdata: NtfLiveViewViewData = new NtfLiveViewViewData();
      let mocker: MockKit = new MockKit();

      let mockLiveviewlistInit: Function = mocker.mockFunc(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      when(mockLiveviewlistInit)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockSubscribeChangeEvent: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
      when(mockSubscribeChangeEvent)(ArgumentMatchers.any).afterReturnNothing();

      ntfliveviewviewdata.init();
      mocker.verify('liveviewlistInit', [ArgumentMatchers.any]).once();

      mocker.ignoreMock(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
    });

    it('should_call_refresh_subscribeSlotChangeEvent_26', 0, async () => {
      let ntfliveviewviewdata: NtfLiveViewViewData = new NtfLiveViewViewData();
      let mocker: MockKit = new MockKit();

      let mockLiveviewlistInit: Function = mocker.mockFunc(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      when(mockLiveviewlistInit)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockSubscribeChangeEvent: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
      when(mockSubscribeChangeEvent)(ArgumentMatchers.any).afterReturnNothing();

      ntfliveviewviewdata.init();
      mocker.verify('liveviewlistInit', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
    });

    it('should_call_refresh_subscribeSlotChangeEvent_27', 0, async () => {
      let ntfliveviewviewdata: NtfLiveViewViewData = new NtfLiveViewViewData();
      let mocker: MockKit = new MockKit();

      let mockLiveviewlistInit: Function = mocker.mockFunc(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      when(mockLiveviewlistInit)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockSubscribeChangeEvent: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
      when(mockSubscribeChangeEvent)(ArgumentMatchers.any).afterReturnNothing();

      ntfliveviewviewdata.init();
      mocker.verify('liveviewlistInit', [ArgumentMatchers.any]).once();

      mocker.ignoreMock(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
    });

    it('should_call_refresh_subscribeSlotChangeEvent_28', 0, async () => {
      let ntfliveviewviewdata: NtfLiveViewViewData = new NtfLiveViewViewData();
      let mocker: MockKit = new MockKit();

      let mockLiveviewlistInit: Function = mocker.mockFunc(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      when(mockLiveviewlistInit)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockSubscribeChangeEvent: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
      when(mockSubscribeChangeEvent)(ArgumentMatchers.any).afterReturnNothing();

      ntfliveviewviewdata.init();
      mocker.verify('liveviewlistInit', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
    });

    it('should_call_refresh_subscribeSlotChangeEvent_29', 0, async () => {
      let ntfliveviewviewdata: NtfLiveViewViewData = new NtfLiveViewViewData();
      let mocker: MockKit = new MockKit();

      let mockLiveviewlistInit: Function = mocker.mockFunc(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      when(mockLiveviewlistInit)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockSubscribeChangeEvent: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
      when(mockSubscribeChangeEvent)(ArgumentMatchers.any).afterReturnNothing();

      ntfliveviewviewdata.init();
      mocker.verify('liveviewlistInit', [ArgumentMatchers.any]).once();

      mocker.ignoreMock(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
    });

    it('should_call_refresh_subscribeSlotChangeEvent_30', 0, async () => {
      let ntfliveviewviewdata: NtfLiveViewViewData = new NtfLiveViewViewData();
      let mocker: MockKit = new MockKit();

      let mockLiveviewlistInit: Function = mocker.mockFunc(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      when(mockLiveviewlistInit)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockSubscribeChangeEvent: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
      when(mockSubscribeChangeEvent)(ArgumentMatchers.any).afterReturnNothing();

      ntfliveviewviewdata.init();
      mocker.verify('liveviewlistInit', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(AppLstComponentViewModel.prototype, AppLstComponentViewModel.prototype.liveviewlistInit);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.subscribeChangeEvent);
    });
  });
}