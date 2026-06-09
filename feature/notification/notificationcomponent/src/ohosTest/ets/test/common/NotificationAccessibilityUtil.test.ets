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
import { LogHelper } from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';
import { AccessibilityManager } from '@ohos/frameworkwrapper';
import { afterEach, ArgumentMatchers, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium';
import { ResUtils } from '@ohos/windowscene';
import { NotificationAccessibilityUtil } from '../../../../main/ets/common/NotificationAccessibilityUtil';

export default function NotificationAccessibilityUtilTest() {
  describe('getSwipeDescription_testSuite', () => {

    it('should_return_empty_string_when_isAccessibilityMode_is_false', 0, () => {
      let isAccessibilityMode: boolean = false;
      let isSwiped: boolean = true;
      const result = NotificationAccessibilityUtil.getSwipeDescription(isAccessibilityMode, isSwiped);
      expect(result).assertEqual('');
    });
    it('should_return_empty_string_when_isAccessibilityMode_is_false', 0, () => {
      let isAccessibilityMode: boolean = false;
      let isSwiped: boolean = false;
      const result = NotificationAccessibilityUtil.getSwipeDescription(isAccessibilityMode, isSwiped);
      expect(result).assertEqual('');
    });
    it('should_return_collapse_tips_when_isSwiped_is_true', 0, () => {
      let isAccessibilityMode: boolean = true;
      let isSwiped: boolean = true;
      const result = NotificationAccessibilityUtil.getSwipeDescription(isAccessibilityMode, isSwiped);
      expect(result).assertEqual(ResUtils.getInnerString($r('app.string.cc_accessibility_str_ntf_collapse_tips')));
    });
    it('should_return_click_and_focused_action_tips_when_isSwiped_is_false', 0, () => {
      let isAccessibilityMode: boolean = true;
      let isSwiped: boolean = false;
      const result = NotificationAccessibilityUtil.getSwipeDescription(isAccessibilityMode, isSwiped);
      let expectedResult = [ResUtils.getInnerString($r('app.string.cc_accessibility_str_click')),
        ResUtils.getInnerString($r('app.string.cc_accessibility_str_ntf_focused_action_tips'))].join(' ');
      expect(result).assertEqual(expectedResult);
    });
  });

  describe('sendNtfSwipeAccessibility_testSuite', () => {

    it('should_return_when_isAccessibilityMode_is_false', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFuncIsAccessibilityMode: Function =
        mocker.mockFunc(NotificationAccessibilityUtil, NotificationAccessibilityUtil.isAccessibilityMode);
      when(mockFuncIsAccessibilityMode)([]).afterReturn(false);
      LogHelper.showInfo = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(LogHelper.showInfo)([ArgumentMatchers.anyString]).afterReturnNothing();
      NotificationAccessibilityUtil.sendNtfSwipeAccessibility(10);
      mocker.verify('sendAccessibility', []).once();
      mocker.ignoreMock(NotificationAccessibilityUtil, NotificationAccessibilityUtil.isAccessibilityMode);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_send_accessibility_when_isToExpand_is_true', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFuncIsAccessibilityMode: Function =
        mocker.mockFunc(NotificationAccessibilityUtil, NotificationAccessibilityUtil.isAccessibilityMode);
      when(mockFuncIsAccessibilityMode)([]).afterReturn(true);
      let mockFuncIsRTL: Function = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockFuncIsRTL)([]).afterReturn(true);
      let mockFuncSendAccessibility: Function =
        mocker.mockFunc(NotificationAccessibilityUtil, NotificationAccessibilityUtil.sendAccessibility);
      when(mockFuncSendAccessibility)([ArgumentMatchers.anyString]).afterReturnNothing();
      NotificationAccessibilityUtil.sendNtfSwipeAccessibility(10);
      mocker.verify('sendAccessibility', []).once();
      mocker.ignoreMock(NotificationAccessibilityUtil, NotificationAccessibilityUtil.isAccessibilityMode);
      mocker.ignoreMock(RTLUtil, RTLUtil.isRTL);
      mocker.ignoreMock(NotificationAccessibilityUtil, NotificationAccessibilityUtil.sendAccessibility);
    });

    it('should_send_accessibility_when_isToExpand_is_false', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFuncIsAccessibilityMode: Function =
        mocker.mockFunc(NotificationAccessibilityUtil, NotificationAccessibilityUtil.isAccessibilityMode);
      when(mockFuncIsAccessibilityMode)([]).afterReturn(true);
      let mockFuncIsRTL: Function = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockFuncIsRTL)([]).afterReturn(false);
      let mockFuncSendAccessibility: Function =
        mocker.mockFunc(NotificationAccessibilityUtil, NotificationAccessibilityUtil.sendAccessibility);
      when(mockFuncSendAccessibility)([ArgumentMatchers.anyString]).afterReturnNothing();
      NotificationAccessibilityUtil.sendNtfSwipeAccessibility(10);
      mocker.verify('sendAccessibility', []).once();
      mocker.ignoreMock(NotificationAccessibilityUtil, NotificationAccessibilityUtil.isAccessibilityMode);
      mocker.ignoreMock(RTLUtil, RTLUtil.isRTL);
      mocker.ignoreMock(NotificationAccessibilityUtil, NotificationAccessibilityUtil.sendAccessibility);
    });
  });

  describe('sendNtfRemoveAccessibility_testSuite', () => {

    it('should_return_immediately_when_isAccessibilityMode_is_false', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(NotificationAccessibilityUtil, NotificationAccessibilityUtil.isAccessibilityMode);
      when(mockfunc)().afterReturn(false);
      NotificationAccessibilityUtil.sendNtfRemoveAccessibility(true);
      mocker.verify('isAccessibilityMode', []).once();
      mocker.ignoreMock(NotificationAccessibilityUtil, NotificationAccessibilityUtil.isAccessibilityMode);
    });

    it('should_send_accessibility_when_isRemoveEntry_is_true', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(NotificationAccessibilityUtil, NotificationAccessibilityUtil.isAccessibilityMode);
      when(mockfunc)().afterReturn(true);

      let mockfunc2: Function =
        mocker.mockFunc(NotificationAccessibilityUtil, NotificationAccessibilityUtil.sendAccessibility);
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturn(null);
      NotificationAccessibilityUtil.sendNtfRemoveAccessibility(true);
      mocker.verify('sendAccessibility', []).once();
      mocker.ignoreMock(NotificationAccessibilityUtil, NotificationAccessibilityUtil.isAccessibilityMode);
      mocker.ignoreMock(NotificationAccessibilityUtil, NotificationAccessibilityUtil.sendAccessibility);
    });

    it('should_not_send_accessibility_when_isRemoveEntry_is_false', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(NotificationAccessibilityUtil, NotificationAccessibilityUtil.isAccessibilityMode);
      when(mockfunc)().afterReturn(true);
      let mockfunc2: Function =
        mocker.mockFunc(NotificationAccessibilityUtil, NotificationAccessibilityUtil.sendAccessibility);
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturn(null);
      NotificationAccessibilityUtil.sendNtfRemoveAccessibility(false);
      mocker.verify('sendAccessibility', []).once();
      mocker.ignoreMock(NotificationAccessibilityUtil, NotificationAccessibilityUtil.isAccessibilityMode);
      mocker.ignoreMock(NotificationAccessibilityUtil, NotificationAccessibilityUtil.sendAccessibility);
    });
  });
}