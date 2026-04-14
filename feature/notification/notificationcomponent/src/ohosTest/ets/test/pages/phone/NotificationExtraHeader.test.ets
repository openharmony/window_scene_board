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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { NotificationAnimationParas } from '../../../../main/ets/common/NotificationAnimationParas';
import { NotificationUtils } from '../../../../main/ets/common/NotificationUtils';
import { NotificationEntry } from '../../../../main/ets/model/NotificationEntry';
import I18n from '@ohos.i18n';
import { LengthMetrics } from '@ohos.arkui.node';
import { NtfAnimationConsts } from '../../../../main/ets/common/NtfAnimationConsts';
import { NotificationConstants } from '../../../../main/ets/common/NotificationConstants';
import { ntfViewConfigManager } from '../../../../main/ets/vm/config/NtfViewConfigManager';
import { NtfListContentConfig } from '../../../../main/ets/vm/config/NtfViewConfig';
import { NtfColorModeVM } from '../../../../main/ets/vm/NtfColorModeVM';
import { ExtraNtfCollapsedAnimation } from '../../../../main/ets/animation/ExtraNtfCollapsedAnimation';
import { ExtraNtfCollapseEvent } from '../../../../main/ets/common/event/NotificationEvent';
import { NotificationGroupExpandAnimation } from '../../../../main/ets/animation/NotificationGroupExpandAnimation';
import { AccessibilityUtil } from '@ohos/systemuicommon';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import {  } from '../../../../main/ets/pages/phone/NotificationExtraHeader';
export default function Test() {
  describe('beforeChangeCollapseStatus_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_0_when_isExtraNtfsCollapsed_is_true', 0, () => {
      let mocker: MockKit = new MockKit();
      let extraNtfList: NotificationEntry[] = [
        new NotificationEntry(),
        new NotificationEntry()
      ];
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let extraNtfCollapsedAnimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let underTest = new NotificationUtils();
      underTest.extraNtfList = extraNtfList;
      underTest.ntfViewConfigManager = ntfListContentConfig;
      underTest.ntfColorModeVM = ntfColorModeVM;
      underTest.extraNtfCollapsedAnimation = extraNtfCollapsedAnimation;
      underTest.isExtraNtfsCollapsed = true;
      const result = underTest.beforeChangeCollapseStatus();
      expect(result).assertEqual(0);
    });

    it('should_return_delay_250_when_extraNtfList_has_expanded_items', 0, () => {
      let mocker: MockKit = new MockKit();
      let extraNtfList: NotificationEntry[] = [
        new NotificationEntry(),
        new NotificationEntry()
      ];
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let extraNtfCollapsedAnimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let underTest = new NotificationUtils();
      underTest.extraNtfList = extraNtfList;
      underTest.ntfViewConfigManager = ntfListContentConfig;
      underTest.ntfColorModeVM = ntfColorModeVM;
      underTest.extraNtfCollapsedAnimation = extraNtfCollapsedAnimation;
      underTest.isExtraNtfsCollapsed = false;
      let mockResetItemExpandState: Function =
        mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.resetItemExpandState);
      when(mockResetItemExpandState)(ArgumentMatchers.any).afterReturnNothing();
      const result = underTest.beforeChangeCollapseStatus();
      expect(result).assertEqual(250);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.resetItemExpandState);
    });

    it('should_return_delay_NotificationGroupExpandAnimation_duration_when_extraNtfList_has_expanded_items_and_some_are_groups',
      0, () => {
        let mocker: MockKit = new MockKit();
        let extraNtfList: NotificationEntry[] = [
          new NotificationEntry(),
          new NotificationEntry()
        ];
        let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
        let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
        let extraNtfCollapsedAnimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
        let underTest = new NotificationUtils();
        underTest.extraNtfList = extraNtfList;
        underTest.ntfViewConfigManager = ntfListContentConfig;
        underTest.ntfColorModeVM = ntfColorModeVM;
        underTest.extraNtfCollapsedAnimation = extraNtfCollapsedAnimation;
        underTest.isExtraNtfsCollapsed = false;
        let mockResetItemExpandState: Function =
          mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.resetItemExpandState);
        when(mockResetItemExpandState)(ArgumentMatchers.any).afterReturnNothing();
        const result = underTest.beforeChangeCollapseStatus();
        expect(result).assertEqual(NotificationGroupExpandAnimation.duration);
        mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.resetItemExpandState);
      });

    it('should_return_0_when_extraNtfList_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let extraNtfCollapsedAnimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let underTest = new NotificationUtils();
      underTest.extraNtfList = null;
      underTest.ntfViewConfigManager = ntfListContentConfig;
      underTest.ntfColorModeVM = ntfColorModeVM;
      underTest.extraNtfCollapsedAnimation = extraNtfCollapsedAnimation;
      underTest.isExtraNtfsCollapsed = false;
      const result = underTest.beforeChangeCollapseStatus();
      expect(result).assertEqual(0);
    });

    it('should_return_0_when_extraNtfList_is_empty', 0, () => {
      let mocker: MockKit = new MockKit();
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let extraNtfCollapsedAnimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let underTest = new NotificationUtils();
      underTest.extraNtfList = [];
      underTest.ntfViewConfigManager = ntfListContentConfig;
      underTest.ntfColorModeVM = ntfColorModeVM;
      underTest.extraNtfCollapsedAnimation = extraNtfCollapsedAnimation;
      underTest.isExtraNtfsCollapsed = false;
      const result = underTest.beforeChangeCollapseStatus();
      expect(result).assertEqual(0);
    });

    it('should_return_0_when_extraNtfList_length_is_less_than_3', 0, () => {
      let mocker: MockKit = new MockKit();
      let extraNtfList: NotificationEntry[] = [
        new NotificationEntry()
      ];
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let extraNtfCollapsedAnimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let underTest = new NotificationUtils();
      underTest.extraNtfList = extraNtfList;
      underTest.ntfViewConfigManager = ntfListContentConfig;
      underTest.ntfColorModeVM = ntfColorModeVM;
      underTest.extraNtfCollapsedAnimation = extraNtfCollapsedAnimation;
      underTest.isExtraNtfsCollapsed = false;
      const result = underTest.beforeChangeCollapseStatus();
      expect(result).assertEqual(0);
    });

    it('should_return_250_when_extraNtfList_length_is_3', 0, () => {
      let mocker: MockKit = new MockKit();
      let extraNtfList: NotificationEntry[] = [
        new NotificationEntry(),
        new NotificationEntry(),
        new NotificationEntry()
      ];
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let extraNtfCollapsedAnimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let underTest = new NotificationUtils();
      underTest.extraNtfList = extraNtfList;
      underTest.ntfViewConfigManager = ntfListContentConfig;
      underTest.ntfColorModeVM = ntfColorModeVM;
      underTest.extraNtfCollapsedAnimation = extraNtfCollapsedAnimation;
      underTest.isExtraNtfsCollapsed = false;
      let mockResetItemExpandState: Function =
        mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.resetItemExpandState);
      when(mockResetItemExpandState)(ArgumentMatchers.any).afterReturnNothing();
      const result = underTest.beforeChangeCollapseStatus();
      expect(result).assertEqual(250);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.resetItemExpandState);
    });

    it('should_return_0_when_isExtraNtfsCollapsed_is_true', 0, () => {
      let mocker: MockKit = new MockKit();
      let extraNtfList: NotificationEntry[] = [
        new NotificationEntry(),
        new NotificationEntry()
      ];
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let extraNtfCollapsedAnimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let underTest = new NotificationUtils();
      underTest.extraNtfList = extraNtfList;
      underTest.ntfViewConfigManager = ntfListContentConfig;
      underTest.ntfColorModeVM = ntfColorModeVM;
      underTest.extraNtfCollapsedAnimation = extraNtfCollapsedAnimation;
      underTest.isExtraNtfsCollapsed = true;
      const result = underTest.beforeChangeCollapseStatus();
      expect(result).assertEqual(0);
    });

    it('should_return_delay_250_when_extraNtfList_has_expanded_items', 0, () => {
      let mocker: MockKit = new MockKit();
      let extraNtfList: NotificationEntry[] = [
        new NotificationEntry(),
        new NotificationEntry()
      ];
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let extraNtfCollapsedAnimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let underTest = new NotificationUtils();
      underTest.extraNtfList = extraNtfList;
      underTest.ntfViewConfigManager = ntfListContentConfig;
      underTest.ntfColorModeVM = ntfColorModeVM;
      underTest.extraNtfCollapsedAnimation = extraNtfCollapsedAnimation;
      underTest.isExtraNtfsCollapsed = false;
      let mockResetItemExpandState: Function = mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.resetItemExpandState);
      when(mockResetItemExpandState)(ArgumentMatchers.any).afterReturnNothing();
      const result = underTest.beforeChangeCollapseStatus();
      expect(result).assertEqual(250);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.resetItemExpandState);
    });

    it('should_return_delay_NotificationGroupExpandAnimation_duration_when_extraNtfList_has_expanded_items_and_some_are_groups', 0, () => {
      let mocker: MockKit = new MockKit();
      let extraNtfList: NotificationEntry[] = [
        new NotificationEntry(),
        new NotificationEntry()
      ];
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let extraNtfCollapsedAnimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let underTest = new NotificationUtils();
      underTest.extraNtfList = extraNtfList;
      underTest.ntfViewConfigManager = ntfListContentConfig;
      underTest.ntfColorModeVM = ntfColorModeVM;
      underTest.extraNtfCollapsedAnimation = extraNtfCollapsedAnimation;
      underTest.isExtraNtfsCollapsed = false;
      let mockResetItemExpandState: Function = mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.resetItemExpandState);
      when(mockResetItemExpandState)(ArgumentMatchers.any).afterReturnNothing();
      const result = underTest.beforeChangeCollapseStatus();
      expect(result).assertEqual(NotificationGroupExpandAnimation.duration);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.resetItemExpandState);
    });

    it('should_return_0_when_extraNtfList_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let extraNtfCollapsedAnimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let underTest = new NotificationUtils();
      underTest.extraNtfList = null;
      underTest.ntfViewConfigManager = ntfListContentConfig;
      underTest.ntfColorModeVM = ntfColorModeVM;
      underTest.extraNtfCollapsedAnimation = extraNtfCollapsedAnimation;
      underTest.isExtraNtfsCollapsed = false;
      const result = underTest.beforeChangeCollapseStatus();
      expect(result).assertEqual(0);
    });

    it('should_return_0_when_extraNtfList_is_empty', 0, () => {
      let mocker: MockKit = new MockKit();
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let extraNtfCollapsedAnimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let underTest = new NotificationUtils();
      underTest.extraNtfList = [];
      underTest.ntfViewConfigManager = ntfListContentConfig;
      underTest.ntfColorModeVM = ntfColorModeVM;
      underTest.extraNtfCollapsedAnimation = extraNtfCollapsedAnimation;
      underTest.isExtraNtfsCollapsed = false;
      const result = underTest.beforeChangeCollapseStatus();
      expect(result).assertEqual(0);
    });

    it('should_return_0_when_extraNtfList_length_is_less_than_3', 0, () => {
      let mocker: MockKit = new MockKit();
      let extraNtfList: NotificationEntry[] = [
        new NotificationEntry()
      ];
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let extraNtfCollapsedAnimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let underTest = new NotificationUtils();
      underTest.extraNtfList = extraNtfList;
      underTest.ntfViewConfigManager = ntfListContentConfig;
      underTest.ntfColorModeVM = ntfColorModeVM;
      underTest.extraNtfCollapsedAnimation = extraNtfCollapsedAnimation;
      underTest.isExtraNtfsCollapsed = false;
      const result = underTest.beforeChangeCollapseStatus();
      expect(result).assertEqual(0);
    });

    it('should_return_250_when_extraNtfList_length_is_3', 0, () => {
      let mocker: MockKit = new MockKit();
      let extraNtfList: NotificationEntry[] = [
        new NotificationEntry(),
        new NotificationEntry(),
        new NotificationEntry()
      ];
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let extraNtfCollapsedAnimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let underTest = new NotificationUtils();
      underTest.extraNtfList = extraNtfList;
      underTest.ntfViewConfigManager = ntfListContentConfig;
      underTest.ntfColorModeVM = ntfColorModeVM;
      underTest.extraNtfCollapsedAnimation = extraNtfCollapsedAnimation;
      underTest.isExtraNtfsCollapsed = false;
      let mockResetItemExpandState: Function = mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.resetItemExpandState);
      when(mockResetItemExpandState)(ArgumentMatchers.any).afterReturnNothing();
      const result = underTest.beforeChangeCollapseStatus();
      expect(result).assertEqual(250);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.resetItemExpandState);
    });
    it('should_return_0_when_isExtraNtfsCollapsed_is_true', 0, () => {
      let mocker: MockKit = new MockKit();
      let extraNtfList: NotificationEntry[] = [
        new NotificationEntry(),
        new NotificationEntry()
      ];
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let extraNtfCollapsedAnimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let underTest = new NotificationUtils();
      underTest.extraNtfList = extraNtfList;
      underTest.ntfViewConfigManager = ntfListContentConfig;
      underTest.ntfColorModeVM = ntfColorModeVM;
      underTest.extraNtfCollapsedAnimation = extraNtfCollapsedAnimation;
      underTest.isExtraNtfsCollapsed = true;
      const result = underTest.beforeChangeCollapseStatus();
      expect(result).assertEqual(0);
    });

    it('should_return_delay_250_when_extraNtfList_has_expanded_items', 0, () => {
      let mocker: MockKit = new MockKit();
      let extraNtfList: NotificationEntry[] = [
        new NotificationEntry(),
        new NotificationEntry()
      ];
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let extraNtfCollapsedAnimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let underTest = new NotificationUtils();
      underTest.extraNtfList = extraNtfList;
      underTest.ntfViewConfigManager = ntfListContentConfig;
      underTest.ntfColorModeVM = ntfColorModeVM;
      underTest.extraNtfCollapsedAnimation = extraNtfCollapsedAnimation;
      underTest.isExtraNtfsCollapsed = false;
      let mockResetItemExpandState: Function = mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.resetItemExpandState);
      when(mockResetItemExpandState)(ArgumentMatchers.any).afterReturnNothing();
      const result = underTest.beforeChangeCollapseStatus();
      expect(result).assertEqual(250);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.resetItemExpandState);
    });

    it('should_return_delay_NotificationGroupExpandAnimation_duration_when_extraNtfList_has_expanded_items_and_some_are_groups', 0, () => {
      let mocker: MockKit = new MockKit();
      let extraNtfList: NotificationEntry[] = [
        new NotificationEntry(),
        new NotificationEntry()
      ];
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let extraNtfCollapsedAnimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let underTest = new NotificationUtils();
      underTest.extraNtfList = extraNtfList;
      underTest.ntfViewConfigManager = ntfListContentConfig;
      underTest.ntfColorModeVM = ntfColorModeVM;
      underTest.extraNtfCollapsedAnimation = extraNtfCollapsedAnimation;
      underTest.isExtraNtfsCollapsed = false;
      let mockResetItemExpandState: Function = mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.resetItemExpandState);
      when(mockResetItemExpandState)(ArgumentMatchers.any).afterReturnNothing();
      const result = underTest.beforeChangeCollapseStatus();
      expect(result).assertEqual(NotificationGroupExpandAnimation.duration);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.resetItemExpandState);
    });

    it('should_return_0_when_extraNtfList_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let extraNtfCollapsedAnimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let underTest = new NotificationUtils();
      underTest.extraNtfList = null;
      underTest.ntfViewConfigManager = ntfListContentConfig;
      underTest.ntfColorModeVM = ntfColorModeVM;
      underTest.extraNtfCollapsedAnimation = extraNtfCollapsedAnimation;
      underTest.isExtraNtfsCollapsed = false;
      const result = underTest.beforeChangeCollapseStatus();
      expect(result).assertEqual(0);
    });

    it('should_return_0_when_extraNtfList_is_empty', 0, () => {
      let mocker: MockKit = new MockKit();
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let extraNtfCollapsedAnimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let underTest = new NotificationUtils();
      const result = underTest.beforeChangeCollapseStatus();
      expect(result).assertEqual(0);
    });

    it('should_return_0_when_extraNtfList_length_is_less_than_3', 0, () => {
      let mocker: MockKit = new MockKit();
      let extraNtfList: NotificationEntry[] = [
        new NotificationEntry()
      ];
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let extraNtfCollapsedAnimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let underTest = new NotificationUtils();
      underTest.extraNtfList = extraNtfList;
      underTest.ntfViewConfigManager = ntfListContentConfig;
      underTest.ntfColorModeVM = ntfColorModeVM;
      underTest.extraNtfCollapsedAnimation = extraNtfCollapsedAnimation;
      underTest.isExtraNtfsCollapsed = false;
      const result = underTest.beforeChangeCollapseStatus();
      expect(result).assertEqual(0);
    });

    it('should_return_250_when_extraNtfList_length_is_3', 0, () => {
      let mocker: MockKit = new MockKit();
      let extraNtfList: NotificationEntry[] = [
        new NotificationEntry(),
        new NotificationEntry(),
        new NotificationEntry()
      ];
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let extraNtfCollapsedAnimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let underTest = new NotificationUtils();
      underTest.extraNtfList = extraNtfList;
      underTest.ntfViewConfigManager = ntfListContentConfig;
      underTest.ntfColorModeVM = ntfColorModeVM;
      underTest.extraNtfCollapsedAnimation = extraNtfCollapsedAnimation;
      underTest.isExtraNtfsCollapsed = false;
      let mockResetItemExpandState: Function = mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.resetItemExpandState);
      when(mockResetItemExpandState)(ArgumentMatchers.any).afterReturnNothing();
      const result = underTest.beforeChangeCollapseStatus();
      expect(result).assertEqual(250);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.resetItemExpandState);
    });

    it('should_return_0_when_extraNtfList_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let extraNtfCollapsedAnimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let underTest = new NotificationUtils();
      underTest.extraNtfList = null;
      underTest.ntfViewConfigManager = ntfListContentConfig;
      underTest.ntfColorModeVM = ntfColorModeVM;
      underTest.extraNtfCollapsedAnimation = extraNtfCollapsedAnimation;
      underTest.isExtraNtfsCollapsed = false;
      const result = underTest.beforeChangeCollapseStatus();
      expect(result).assertEqual(0);
    });

    it('should_return_0_when_extraNtfList_is_empty', 0, () => {
      let underTest = new NotificationUtils();
      const result = underTest.beforeChangeCollapseStatus();
      expect(result).assertEqual(0);
    });

    it('should_return_0_when_extraNtfList_length_is_less_than_3', 0, () => {
      let mocker: MockKit = new MockKit();
      let extraNtfList: NotificationEntry[] = [
        new NotificationEntry()
      ];
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let extraNtfCollapsedAnimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let underTest = new NotificationUtils();
      underTest.extraNtfList = extraNtfList;
      underTest.ntfViewConfigManager = ntfListContentConfig;
      underTest.ntfColorModeVM = ntfColorModeVM;
      underTest.extraNtfCollapsedAnimation = extraNtfCollapsedAnimation;
      underTest.isExtraNtfsCollapsed = false;
      const result = underTest.beforeChangeCollapseStatus();
      expect(result).assertEqual(0);
    });

    it('should_return_250_when_extraNtfList_length_is_3', 0, () => {
      let mocker: MockKit = new MockKit();
      let extraNtfList: NotificationEntry[] = [
        new NotificationEntry(),
        new NotificationEntry(),
        new NotificationEntry()
      ];
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let extraNtfCollapsedAnimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
      let underTest = new NotificationUtils();
      underTest.extraNtfList = extraNtfList;
      underTest.ntfViewConfigManager = ntfListContentConfig;
      underTest.ntfColorModeVM = ntfColorModeVM;
      underTest.extraNtfCollapsedAnimation = extraNtfCollapsedAnimation;
      underTest.isExtraNtfsCollapsed = false;
      let mockResetItemExpandState: Function = mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.resetItemExpandState);
      when(mockResetItemExpandState)(ArgumentMatchers.any).afterReturnNothing();
      const result = underTest.beforeChangeCollapseStatus();
      expect(result).assertEqual(250);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.resetItemExpandState);
    });
  })
}

