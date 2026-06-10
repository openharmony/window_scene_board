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
import { LogHelper, LogDomain } from '@ohos/basicutils';
import { Singleton } from '../../../main/ets/utils/Singleton';
import { BannerPanelType } from '../../../main/ets/banner/common/info/BannerState';
import { EventEmitter } from '../../../main/ets/utils/EventEmitter';
import { EvtBus, WindowEvent } from '@ohos/frameworkwrapper';
import { WindowConstants } from '@ohos/commonconstants';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { BannerVm } from '../../../main/ets/vm/BannerVm';
export default function BannerVmTest() {
  describe('setBannerType_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_log_info_when_bannerType_is_changed', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(undefined);

      bannervm.setBannerType(BannerPanelType.TYPE_INFO, BannerPanelType.TYPE_NONE);

      expect(mockfunc).assertCalledWith("Set banner type, old: TYPE_NONE, new: TYPE_INFO");
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_secondaryType_is_changed', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(undefined);

      bannervm.setBannerType(BannerPanelType.TYPE_NONE, BannerPanelType.TYPE_INFO);

      expect(mockfunc).assertCalledWith("Set secondaryType type, old: TYPE_NONE, new: TYPE_INFO");
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_log_info_when_bannerType_and_secondaryType_are_same', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(undefined);

      bannervm.setBannerType(BannerPanelType.TYPE_NONE, BannerPanelType.TYPE_NONE);

      expect(mockfunc).assertNotCalled();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_emit_event_when_bannerType_is_changed', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let eventEmitter: EventEmitter<WindowEvent> = new EventEmitter();
      let mockEmit: Function = mocker.mockFunc(eventEmitter, eventEmitter.emit);
      when(mockEmit)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(undefined);

      bannervm.setBannerType(BannerPanelType.TYPE_INFO, BannerPanelType.TYPE_NONE);

      expect(mockEmit).assertCalledWith(WindowConstants.BANNER_TYPE_CHANGE_EVENT, undefined);
      mocker.ignoreMock(eventEmitter, eventEmitter.emit);
    });

    it('should_not_emit_event_when_bannerType_and_secondaryType_are_same', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let eventEmitter: EventEmitter<WindowEvent> = new EventEmitter();
      let mockEmit: Function = mocker.mockFunc(eventEmitter, eventEmitter.emit);
      when(mockEmit)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(undefined);

      bannervm.setBannerType(BannerPanelType.TYPE_NONE, BannerPanelType.TYPE_NONE);

      expect(mockEmit).assertNotCalled();
      mocker.ignoreMock(eventEmitter, eventEmitter.emit);
    });

    it('should_return_true_when_bannerType_is_TYPE_NONE', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      bannervm.bannerType = BannerPanelType.TYPE_NONE;
      expect(bannervm.isNone()).assertTrue();
    });

    it('should_return_false_when_bannerType_is_not_TYPE_NONE', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      bannervm.bannerType = BannerPanelType.TYPE_INFO;
      expect(bannervm.isNone()).assertFalse();
    });

    it('should_return_true_when_bannerType_is_TYPE_HEADS_UP', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      bannervm.bannerType = BannerPanelType.TYPE_HEADS_UP;
      const result = bannervm.isHeadsUp();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_bannerType_is_not_TYPE_HEADS_UP', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      bannervm.bannerType = BannerPanelType.TYPE_NONE;
      const result = bannervm.isHeadsUp();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_bannerType_is_TYPE_LIVE_LIST', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      bannervm.bannerType = BannerPanelType.TYPE_LIVE_LIST;
      expect(bannervm.isLivePanel()).assertTrue();
    });

    it('should_return_true_when_secondaryType_is_TYPE_CAPSULE_LIST', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      bannervm.secondaryType = BannerPanelType.TYPE_CAPSULE_LIST;
      expect(bannervm.isLivePanel()).assertTrue();
    });

    it('should_return_false_when_both_bannerType_and_secondaryType_are_not_live_panel_types', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      bannervm.bannerType = BannerPanelType.TYPE_NONE;
      bannervm.secondaryType = BannerPanelType.TYPE_NONE;
      expect(bannervm.isLivePanel()).assertFalse();
    });

    it('should_return_true_when_bannerType_is_TYPE_LIVE_LIST', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      bannervm.bannerType = BannerPanelType.TYPE_LIVE_LIST;
      const result = bannervm.isHideCapsule();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_bannerType_is_not_TYPE_LIVE_LIST', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      bannervm.bannerType = BannerPanelType.TYPE_NONE;
      const result = bannervm.isHideCapsule();
      expect(result).assertEqual(false);
    });

    it('should_log_info_when_bannerType_is_changed', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(undefined);

      bannervm.setBannerType(BannerPanelType.TYPE_INFO, BannerPanelType.TYPE_NONE);

      expect(mockfunc).assertCalledWith("Set banner type, old: TYPE_NONE, new: TYPE_INFO");
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_secondaryType_is_changed', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(undefined);

      bannervm.setBannerType(BannerPanelType.TYPE_NONE, BannerPanelType.TYPE_INFO);

      expect(mockfunc).assertCalledWith("Set secondaryType type, old: TYPE_NONE, new: TYPE_INFO");
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_log_info_when_bannerType_and_secondaryType_are_same', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(undefined);

      bannervm.setBannerType(BannerPanelType.TYPE_NONE, BannerPanelType.TYPE_NONE);

      expect(mockfunc).assertNotCalled();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_emit_event_when_bannerType_is_changed', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let eventEmitter: EventEmitter<WindowEvent> = new EventEmitter();
      let mockEmit: Function = mocker.mockFunc(eventEmitter, eventEmitter.emit);
      when(mockEmit)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(undefined);

      bannervm.setBannerType(BannerPanelType.TYPE_INFO, BannerPanelType.TYPE_NONE);

      expect(mockEmit).assertCalledWith(WindowConstants.BANNER_TYPE_CHANGE_EVENT, undefined);
      mocker.ignoreMock(eventEmitter, eventEmitter.emit);
    });

    it('should_not_emit_event_when_bannerType_and_secondaryType_are_same', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let eventEmitter: EventEmitter<WindowEvent> = new EventEmitter();
      let mockEmit: Function = mocker.mockFunc(eventEmitter, eventEmitter.emit);
      when(mockEmit)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(undefined);

      bannervm.setBannerType(BannerPanelType.TYPE_NONE, BannerPanelType.TYPE_NONE);

      expect(mockEmit).assertNotCalled();
      mocker.ignoreMock(eventEmitter, eventEmitter.emit);
    });

    it('should_return_true_when_bannerType_is_TYPE_NONE', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      bannervm.bannerType = BannerPanelType.TYPE_NONE;
      expect(bannervm.isNone()).assertTrue();
    });

    it('should_return_false_when_bannerType_is_not_TYPE_NONE', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      bannervm.bannerType = BannerPanelType.TYPE_INFO;
      expect(bannervm.isNone()).assertFalse();
    });

    it('should_return_true_when_bannerType_is_TYPE_HEADS_UP', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      bannervm.bannerType = BannerPanelType.TYPE_HEADS_UP;
      const result = bannervm.isHeadsUp();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_bannerType_is_not_TYPE_HEADS_UP', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      bannervm.bannerType = BannerPanelType.TYPE_NONE;
      const result = bannervm.isHeadsUp();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_bannerType_is_TYPE_LIVE_LIST', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      bannervm.bannerType = BannerPanelType.TYPE_LIVE_LIST;
      expect(bannervm.isLivePanel()).assertTrue();
    });

    it('should_return_true_when_secondaryType_is_TYPE_CAPSULE_LIST', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      bannervm.secondaryType = BannerPanelType.TYPE_CAPSULE_LIST;
      expect(bannervm.isLivePanel()).assertTrue();
    });

    it('should_return_false_when_both_bannerType_and_secondaryType_are_not_live_panel_types', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      bannervm.bannerType = BannerPanelType.TYPE_NONE;
      bannervm.secondaryType = BannerPanelType.TYPE_NONE;
      expect(bannervm.isLivePanel()).assertFalse();
    });

    it('should_return_true_when_bannerType_is_TYPE_LIVE_LIST', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      bannervm.bannerType = BannerPanelType.TYPE_LIVE_LIST;
      const result = bannervm.isHideCapsule();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_bannerType_is_not_TYPE_LIVE_LIST', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      bannervm.bannerType = BannerPanelType.TYPE_NONE;
      const result = bannervm.isHideCapsule();
      expect(result).assertEqual(false);
    });

    it('should_log_info_when_bannerType_is_changed', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(undefined);

      bannervm.setBannerType(BannerPanelType.TYPE_INFO, BannerPanelType.TYPE_NONE);

      expect(mockfunc).assertCalledWith("Set banner type, old: TYPE_NONE, new: TYPE_INFO");
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_secondaryType_is_changed', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(undefined);

      bannervm.setBannerType(BannerPanelType.TYPE_NONE, BannerPanelType.TYPE_INFO);

      expect(mockfunc).assertCalledWith("Set secondaryType type, old: TYPE_NONE, new: TYPE_INFO");
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_log_info_when_bannerType_and_secondaryType_are_same', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(undefined);

      bannervm.setBannerType(BannerPanelType.TYPE_NONE, BannerPanelType.TYPE_NONE);

      expect(mockfunc).assertNotCalled();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_emit_event_when_bannerType_is_changed', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let eventEmitter: EventEmitter<WindowEvent> = new EventEmitter();
      let mockEmit: Function = mocker.mockFunc(eventEmitter, eventEmitter.emit);
      when(mockEmit)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(undefined);

      bannervm.setBannerType(BannerPanelType.TYPE_INFO, BannerPanelType.TYPE_NONE);

      expect(mockEmit).assertCalledWith(WindowConstants.BANNER_TYPE_CHANGE_EVENT, undefined);
      mocker.ignoreMock(eventEmitter, eventEmitter.emit);
    });

    it('should_not_emit_event_when_bannerType_and_secondaryType_are_same', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let eventEmitter: EventEmitter<WindowEvent> = new EventEmitter();
      let mockEmit: Function = mocker.mockFunc(eventEmitter, eventEmitter.emit);
      when(mockEmit)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(undefined);

      bannervm.setBannerType(BannerPanelType.TYPE_NONE, BannerPanelType.TYPE_NONE);

      expect(mockEmit).assertNotCalled();
      mocker.ignoreMock(eventEmitter, eventEmitter.emit);
    });

    it('should_return_true_when_bannerType_is_TYPE_NONE', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      bannervm.bannerType = BannerPanelType.TYPE_NONE;
      expect(bannervm.isNone()).assertTrue();
    });

    it('should_return_false_when_bannerType_is_not_TYPE_NONE', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      bannervm.bannerType = BannerPanelType.TYPE_INFO;
      expect(bannervm.isNone()).assertFalse();
    });

    it('should_return_true_when_bannerType_is_TYPE_HEADS_UP', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      bannervm.bannerType = BannerPanelType.TYPE_HEADS_UP;
      const result = bannervm.isHeadsUp();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_bannerType_is_not_TYPE_HEADS_UP', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      bannervm.bannerType = BannerPanelType.TYPE_NONE;
      const result = bannervm.isHeadsUp();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_bannerType_is_TYPE_LIVE_LIST', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      bannervm.bannerType = BannerPanelType.TYPE_LIVE_LIST;
      expect(bannervm.isLivePanel()).assertTrue();
    });

    it('should_return_true_when_secondaryType_is_TYPE_CAPSULE_LIST', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      bannervm.secondaryType = BannerPanelType.TYPE_CAPSULE_LIST;
      expect(bannervm.isLivePanel()).assertTrue();
    });

    it('should_return_false_when_both_bannerType_and_secondaryType_are_not_live_panel_types', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      bannervm.bannerType = BannerPanelType.TYPE_NONE;
      bannervm.secondaryType = BannerPanelType.TYPE_NONE;
      expect(bannervm.isLivePanel()).assertFalse();
    });

    it('should_return_true_when_bannerType_is_TYPE_LIVE_LIST', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      bannervm.bannerType = BannerPanelType.TYPE_LIVE_LIST;
      const result = bannervm.isHideCapsule();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_bannerType_is_not_TYPE_LIVE_LIST', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      bannervm.bannerType = BannerPanelType.TYPE_NONE;
      const result = bannervm.isHideCapsule();
      expect(result).assertEqual(false);
    });

    it('should_log_info_when_bannerType_is_changed', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(undefined);

      bannervm.setBannerType(BannerPanelType.TYPE_INFO, BannerPanelType.TYPE_NONE);

      expect(mockfunc).assertCalledWith("Set banner type, old: TYPE_NONE, new: TYPE_INFO");
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_secondaryType_is_changed', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(undefined);

      bannervm.setBannerType(BannerPanelType.TYPE_NONE, BannerPanelType.TYPE_INFO);

      expect(mockfunc).assertCalledWith("Set secondaryType type, old: TYPE_NONE, new: TYPE_INFO");
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_log_info_when_bannerType_and_secondaryType_are_same', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(undefined);

      bannervm.setBannerType(BannerPanelType.TYPE_NONE, BannerPanelType.TYPE_NONE);

      expect(mockfunc).assertNotCalled();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_emit_event_when_bannerType_is_changed', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let eventEmitter: EventEmitter<WindowEvent> = new EventEmitter();
      let mockEmit: Function = mocker.mockFunc(eventEmitter, eventEmitter.emit);
      when(mockEmit)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(undefined);

      bannervm.setBannerType(BannerPanelType.TYPE_INFO, BannerPanelType.TYPE_NONE);

      expect(mockEmit).assertCalledWith(WindowConstants.BANNER_TYPE_CHANGE_EVENT, undefined);
      mocker.ignoreMock(eventEmitter, eventEmitter.emit);
    });

    it('should_not_emit_event_when_bannerType_and_secondaryType_are_same', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let eventEmitter: EventEmitter<WindowEvent> = new EventEmitter();
      let mockEmit: Function = mocker.mockFunc(eventEmitter, eventEmitter.emit);
      when(mockEmit)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(undefined);

      bannervm.setBannerType(BannerPanelType.TYPE_NONE, BannerPanelType.TYPE_NONE);

      expect(mockEmit).assertNotCalled();
      mocker.ignoreMock(eventEmitter, eventEmitter.emit);
    });

    it('should_return_true_when_bannerType_is_TYPE_NONE', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      bannervm.bannerType = BannerPanelType.TYPE_NONE;
      expect(bannervm.isNone()).assertTrue();
    });

    it('should_return_false_when_bannerType_is_not_TYPE_NONE', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      bannervm.bannerType = BannerPanelType.TYPE_INFO;
      expect(bannervm.isNone()).assertFalse();
    });

    it('should_return_true_when_bannerType_is_TYPE_HEADS_UP', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      bannervm.bannerType = BannerPanelType.TYPE_HEADS_UP;
      const result = bannervm.isHeadsUp();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_bannerType_is_not_TYPE_HEADS_UP', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      bannervm.bannerType = BannerPanelType.TYPE_NONE;
      const result = bannervm.isHeadsUp();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_bannerType_is_TYPE_LIVE_LIST', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      bannervm.bannerType = BannerPanelType.TYPE_LIVE_LIST;
      expect(bannervm.isLivePanel()).assertTrue();
    });

    it('should_return_true_when_secondaryType_is_TYPE_CAPSULE_LIST', 0, () => {
      let bannervm: BannerVm = BannerVm.INSTANCE;
      bannervm.secondaryType = BannerPanelType.TYPE_CAPSULE_LIST;
      expect(bannervm.isLivePanel()).assertTrue();
    });
  });
