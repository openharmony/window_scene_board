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

import { NotificationBase } from '@ohos/systemuicommon/newTsIndex';
import { INotificationMoreVm, NotificationBaseVm } from '@ohos/systemuicommon/newIndex';
import { MoreNotificationCollapsedAnimation } from '../../../main/ets/animation/MoreNotificationCollapsedAnimation';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { RTLUtil } from '@ohos/componenthelper/src/main/ets/TsIndex';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NotificationMoreVm } from '../../../main/ets/viewmodel/NotificationMoreVm';
export default function NotificationMoreVmTest() {
  describe('briefContent_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_return_app_names_joined_with_顿号_when_app_count_is_less_than_threshold', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      let mocker: MockKit = new MockKit();

      let mockNtf1: NotificationBase = {
        appLabel: 'App1'
      };
      let mockNtf2: NotificationBase = {
        appLabel: 'App2'
      };
      let mockNtf3: NotificationBase = {
        appLabel: 'App3'
      };
      notificationmorevm.moreNtfAppList = [mockNtf1, mockNtf2, mockNtf3];

      const result = notificationmorevm.briefContent;
      expect(result).assertEqual('App1、App2、App3');
    });

    it('should_return_app_names_joined_with_顿号_when_app_count_is_equal_to_threshold', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      let mocker: MockKit = new MockKit();

      let mockNtf1: NotificationBase = {
        appLabel: 'App1'
      };
      let mockNtf2: NotificationBase = {
        appLabel: 'App2'
      };
      let mockNtf3: NotificationBase = {
        appLabel: 'App3'
      };
      let mockNtf4: NotificationBase = {
        appLabel: 'App4'
      };
      notificationmorevm.moreNtfAppList = [mockNtf1, mockNtf2, mockNtf3, mockNtf4];

      const result = notificationmorevm.briefContent;
      expect(result).assertEqual('App1、App2、App3、App4');
    });

    it('should_return_app_names_joined_with_顿号_when_app_count_is_greater_than_threshold', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      let mocker: MockKit = new MockKit();

      let mockNtf1: NotificationBase = {
        appLabel: 'App1'
      };
      let mockNtf2: NotificationBase = {
        appLabel: 'App2'
      };
      let mockNtf3: NotificationBase = {
        appLabel: 'App3'
      };
      let mockNtf4: NotificationBase = {
        appLabel: 'App4'
      };
      let mockNtf5: NotificationBase = {
        appLabel: 'App5'
      };
      notificationmorevm.moreNtfAppList = [mockNtf1, mockNtf2, mockNtf3, mockNtf4, mockNtf5];

      const result = notificationmorevm.briefContent;
      expect(result).assertEqual('App1、App2、App3、App4');
    });

    it('should_return_empty_string_when_moreNtfAppList_is_empty', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      notificationmorevm.moreNtfAppList = [];
      const result = notificationmorevm.briefContent;
      expect(result).assertEqual('');
    });

    it('should_return_app_names_joined_with_顿号_when_app_labels_are_undefined', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      let mocker: MockKit = new MockKit();

      let mockNtf1: NotificationBase = {
        appLabel: undefined
      };
      let mockNtf2: NotificationBase = {
        appLabel: 'App2'
      };
      let mockNtf3: NotificationBase = {
        appLabel: 'App3'
      };
      notificationmorevm.moreNtfAppList = [mockNtf1, mockNtf2, mockNtf3];

      const result = notificationmorevm.briefContent;
      expect(result).assertEqual('App2、App3');
    });

    it('should_return_app_names_joined_with_顿号_when_app_count_is_less_than_threshold', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      let mocker: MockKit = new MockKit();

      let mockNtf1: NotificationBase = {
        appLabel: 'App1'
      };
      let mockNtf2: NotificationBase = {
        appLabel: 'App2'
      };
      let mockNtf3: NotificationBase = {
        appLabel: 'App3'
      };
      notificationmorevm.moreNtfAppList = [mockNtf1, mockNtf2, mockNtf3];

      const result = notificationmorevm.briefContent;
      expect(result).assertEqual('App1、App2、App3');
    });

    it('should_return_app_names_joined_with_顿号_when_app_count_is_equal_to_threshold', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      let mocker: MockKit = new MockKit();

      let mockNtf1: NotificationBase = {
        appLabel: 'App1'
      };
      let mockNtf2: NotificationBase = {
        appLabel: 'App2'
      };
      let mockNtf3: NotificationBase = {
        appLabel: 'App3'
      };
      let mockNtf4: NotificationBase = {
        appLabel: 'App4'
      };
      notificationmorevm.moreNtfAppList = [mockNtf1, mockNtf2, mockNtf3, mockNtf4];

      const result = notificationmorevm.briefContent;
      expect(result).assertEqual('App1、App2、App3、App4');
    });

    it('should_return_app_names_joined_with_顿号_when_app_count_is_greater_than_threshold', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      let mocker: MockKit = new MockKit();

      let mockNtf1: NotificationBase = {
        appLabel: 'App1'
      };
      let mockNtf2: NotificationBase = {
        appLabel: 'App2'
      };
      let mockNtf3: NotificationBase = {
        appLabel: 'App3'
      };
      let mockNtf4: NotificationBase = {
        appLabel: 'App4'
      };
      let mockNtf5: NotificationBase = {
        appLabel: 'App5'
      };
      notificationmorevm.moreNtfAppList = [mockNtf1, mockNtf2, mockNtf3, mockNtf4, mockNtf5];

      const result = notificationmorevm.briefContent;
      expect(result).assertEqual('App1、App2、App3、App4');
    });

    it('should_return_empty_string_when_moreNtfAppList_is_empty', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      notificationmorevm.moreNtfAppList = [];
      const result = notificationmorevm.briefContent;
      expect(result).assertEqual('');
    });

    it('should_return_app_names_joined_with_顿号_when_app_labels_are_undefined', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      let mocker: MockKit = new MockKit();

      let mockNtf1: NotificationBase = {
        appLabel: undefined
      };
      let mockNtf2: NotificationBase = {
        appLabel: 'App2'
      };
      let mockNtf3: NotificationBase = {
        appLabel: 'App3'
      };
      notificationmorevm.moreNtfAppList = [mockNtf1, mockNtf2, mockNtf3];

      const result = notificationmorevm.briefContent;
      expect(result).assertEqual('App2、App3');
    });

    it('should_return_app_names_joined_with_顿号_when_app_count_is_less_than_threshold', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      let mocker: MockKit = new MockKit();

      let mockNtf1: NotificationBase = {
        appLabel: 'App1'
      };
      let mockNtf2: NotificationBase = {
        appLabel: 'App2'
      };
      let mockNtf3: NotificationBase = {
        appLabel: 'App3'
      };
      notificationmorevm.moreNtfAppList = [mockNtf1, mockNtf2, mockNtf3];

      const result = notificationmorevm.briefContent;
      expect(result).assertEqual('App1、App2、App3');
    });

    it('should_return_app_names_joined_with_顿号_when_app_count_is_equal_to_threshold', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      let mocker: MockKit = new MockKit();

      let mockNtf1: NotificationBase = {
        appLabel: 'App1'
      };
      let mockNtf2: NotificationBase = {
        appLabel: 'App2'
      };
      let mockNtf3: NotificationBase = {
        appLabel: 'App3'
      };
      let mockNtf4: NotificationBase = {
        appLabel: 'App4'
      };
      notificationmorevm.moreNtfAppList = [mockNtf1, mockNtf2, mockNtf3, mockNtf4];

      const result = notificationmorevm.briefContent;
      expect(result).assertEqual('App1、App2、App3、App4');
    });

    it('should_return_app_names_joined_with_顿号_when_app_count_is_greater_than_threshold', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      let mocker: MockKit = new MockKit();

      let mockNtf1: NotificationBase = {
        appLabel: 'App1'
      };
      let mockNtf2: NotificationBase = {
        appLabel: 'App2'
      };
      let mockNtf3: NotificationBase = {
        appLabel: 'App3'
      };
      let mockNtf4: NotificationBase = {
        appLabel: 'App4'
      };
      let mockNtf5: NotificationBase = {
        appLabel: 'App5'
      };
      notificationmorevm.moreNtfAppList = [mockNtf1, mockNtf2, mockNtf3, mockNtf4, mockNtf5];

      const result = notificationmorevm.briefContent;
      expect(result).assertEqual('App1、App2、App3、App4');
    });

    it('should_return_empty_string_when_moreNtfAppList_is_empty', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      notificationmorevm.moreNtfAppList = [];
      const result = notificationmorevm.briefContent;
      expect(result).assertEqual('');
    });

    it('should_return_app_names_joined_with_顿号_when_app_labels_are_undefined', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      let mocker: MockKit = new MockKit();

      let mockNtf1: NotificationBase = {
        appLabel: undefined
      };
      let mockNtf2: NotificationBase = {
        appLabel: 'App2'
      };
      let mockNtf3: NotificationBase = {
        appLabel: 'App3'
      };
      notificationmorevm.moreNtfAppList = [mockNtf1, mockNtf2, mockNtf3];

      const result = notificationmorevm.briefContent;
      expect(result).assertEqual('App2、App3');
    });

    it('should_return_0vp_when_listVm_is_null', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      let mocker: MockKit = new MockKit();

      const result = notificationmorevm.getIconWidth();
      expect(result).assertEqual('0vp');
    });

    it('should_return_APP_ICON_SIZE_when_listVm_length_is_1', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      let mocker: MockKit = new MockKit();

      const result = notificationmorevm.getIconWidth();
      expect(result).assertEqual('14vp');
    });

    it('should_return_correct_width_when_listVm_length_is_2', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      let mocker: MockKit = new MockKit();

      const result = notificationmorevm.getIconWidth();
      expect(result).assertEqual('27vp');
    });

    it('should_return_correct_width_when_listVm_length_is_3', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      let mocker: MockKit = new MockKit();

      const result = notificationmorevm.getIconWidth();
      expect(result).assertEqual('40vp');
    });

    it('should_return_correct_width_when_listVm_length_is_greater_than_3', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      let mocker: MockKit = new MockKit();

      const result = notificationmorevm.getIconWidth();
      expect(result).assertEqual('40vp');
    });

    it('should_return_0vp_when_listVm_is_null', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      let mocker: MockKit = new MockKit();

      const result = notificationmorevm.getIconWidth();
      expect(result).assertEqual('0vp');
    });

    it('should_return_APP_ICON_SIZE_when_listVm_length_is_1', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      let mocker: MockKit = new MockKit();

      const result = notificationmorevm.getIconWidth();
      expect(result).assertEqual('14vp');
    });

    it('should_return_correct_width_when_listVm_length_is_2', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      let mocker: MockKit = new MockKit();

      const result = notificationmorevm.getIconWidth();
      expect(result).assertEqual('27vp');
    });

    it('should_return_correct_width_when_listVm_length_is_3', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      let mocker: MockKit = new MockKit();

      const result = notificationmorevm.getIconWidth();
      expect(result).assertEqual('40vp');
    });

    it('should_return_correct_width_when_listVm_length_is_greater_than_3', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      let mocker: MockKit = new MockKit();

      const result = notificationmorevm.getIconWidth();
      expect(result).assertEqual('40vp');
    });
    it('should_return_0vp_when_listVm_is_null', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      let mocker: MockKit = new MockKit();

      const result = notificationmorevm.getIconWidth();
      expect(result).assertEqual('0vp');
    });

    it('should_return_APP_ICON_SIZE_when_listVm_length_is_1', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      let mocker: MockKit = new MockKit();

      const result = notificationmorevm.getIconWidth();
      expect(result).assertEqual('14vp');
    });

    it('should_return_correct_width_when_listVm_length_is_2', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      let mocker: MockKit = new MockKit();

      const result = notificationmorevm.getIconWidth();
      expect(result).assertEqual('27vp');
    });

    it('should_return_correct_width_when_listVm_length_is_3', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      let mocker: MockKit = new MockKit();

      const result = notificationmorevm.getIconWidth();
      expect(result).assertEqual('40vp');
    });

    it('should_return_correct_width_when_listVm_length_is_greater_than_3', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      let mocker: MockKit = new MockKit();

      const result = notificationmorevm.getIconWidth();
      expect(result).assertEqual('40vp');
    });

    it('should_return_length_minus_index_when_listVm_length_is_greater_than_0', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationmorevm, notificationmorevm.listVm);
      when(mockfunc)(ArgumentMatchers.any).afterReturn({ moreNtfList: [1, 2, 3] });

      const result = notificationmorevm.getZIndex(1);
      expect(result).assertEqual(2);

      mocker.ignoreMock(notificationmorevm, notificationmorevm.listVm);
    });

    it('should_return_0_when_listVm_length_is_0', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationmorevm, notificationmorevm.listVm);
      when(mockfunc)(ArgumentMatchers.any).afterReturn({ moreNtfList: [] });

      const result = notificationmorevm.getZIndex(1);
      expect(result).assertEqual(0);

      mocker.ignoreMock(notificationmorevm, notificationmorevm.listVm);
    });

    it('should_return_0_when_listVm_length_is_less_than_0', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationmorevm, notificationmorevm.listVm);
      when(mockfunc)(ArgumentMatchers.any).afterReturn({ moreNtfList: -1 });

      const result = notificationmorevm.getZIndex(1);
      expect(result).assertEqual(0);

      mocker.ignoreMock(notificationmorevm, notificationmorevm.listVm);
    });
    it('should_return_length_minus_index_when_listVm_length_is_greater_than_0', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationmorevm, notificationmorevm.listVm);
      when(mockfunc)(ArgumentMatchers.any).afterReturn({ moreNtfList: [1, 2, 3] });

      const result = notificationmorevm.getZIndex(1);
      expect(result).assertEqual(2);

      mocker.ignoreMock(notificationmorevm, notificationmorevm.listVm);
    });

    it('should_return_0_when_listVm_length_is_0', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationmorevm, notificationmorevm.listVm);
      when(mockfunc)(ArgumentMatchers.any).afterReturn({ moreNtfList: [] });

      const result = notificationmorevm.getZIndex(1);
      expect(result).assertEqual(0);

      mocker.ignoreMock(notificationmorevm, notificationmorevm.listVm);
    });
    it('should_return_0_when_listVm_length_is_0', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationmorevm, notificationmorevm.listVm);
      when(mockfunc)(ArgumentMatchers.any).afterReturn({ moreNtfList: [] });

      const result = notificationmorevm.getZIndex(1);
      expect(result).assertEqual(0);

      mocker.ignoreMock(notificationmorevm, notificationmorevm.listVm);
    });

    it('should_return_0_when_listVm_length_is_less_than_0', 0, () => {
      let notificationmorevm: NotificationMoreVm = new NotificationMoreVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationmorevm, notificationmorevm.listVm);
      when(mockfunc)(ArgumentMatchers.any).afterReturn({ moreNtfList: -1 });

      const result = notificationmorevm.getZIndex(1);
      expect(result).assertEqual(0);

      mocker.ignoreMock(notificationmorevm, notificationmorevm.listVm);
    });
  });