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
import {
  NotificationBase,
  InnerEventUtil,
  NotificationEvent,
  NotificationArray,
  NotificationCategory,
} from '@ohos/systemuicommon/newTsIndex';
import { AnimationBase, INotificationListVm, DeviceInfoVm, DropdownVm, } from '@ohos/systemuicommon/newIndex';
import { LiveDropdownVmInjector } from '@ohos/systemuicommon/src/main/ets/live/variant/dropdown/LiveDropdownVmInjector';
import { NotificationSwipeVm } from '../../../main/ets/viewmodel/NotificationSwipeVm';
import { NotificationConfig } from '../../../main/ets/common/NotificationConfig';
import { NotificationNormalVm } from '../../../main/ets/viewmodel/NotificationNormalVm';
import { NotificationDataVm } from '../../../main/ets/viewmodel/NotificationDataVm';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { ItemUtils } from '@ohos/componenthelper/src/main/ets/TsIndex';
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
import { NotificationListVm } from '../../../main/ets/viewmodel/NotificationListVm';

export default function NotificationListVmTest() {
  describe('padding_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_return_padding_when_device_is_not_pad', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      when(DeviceHelper.isPad())(ArgumentMatchers.any).afterReturn(false);
      const result = notificationlistvm.padding;
      expect(result).assertDeepEquals({
        left: $r('app.float.ntf_list_item_padding_start_end'),
        right: $r('app.float.ntf_list_item_padding_start_end'),
        bottom: $r('app.float.ntf_list_item_padding_bottom'),
        top: 0,
      });
    });

    it('should_return_padding_when_device_is_pad_and_landscape', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      when(DeviceHelper.isPad())(ArgumentMatchers.any).afterReturn(true);
      when(DeviceInfoVm.instance.isLandscape)(ArgumentMatchers.any).afterReturn(true);
      const result = notificationlistvm.padding;
      expect(result).assertDeepEquals({
        bottom: $r('app.float.ntf_list_land_item_padding_bottom'),
      });
    });

    it('should_return_padding_when_device_is_pad_and_portrait', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      when(DeviceHelper.isPad())(ArgumentMatchers.any).afterReturn(true);
      when(DeviceInfoVm.instance.isLandscape)(ArgumentMatchers.any).afterReturn(false);
      const result = notificationlistvm.padding;
      expect(result).assertDeepEquals({
        bottom: $r('app.float.ntf_list_item_padding_bottom'),
      });
    });

    it('should_call_getLiveDataVm_init_and_super_init', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();

      let mockLiveDataVm: INotificationListVm = {
        init: () => {
        }
      };
      when(mocker.mockFunc(LiveDropdownVmInjector.instance,
        LiveDropdownVmInjector.instance.getLiveDataVm))(ArgumentMatchers.any).afterReturn(mockLiveDataVm);
      notificationlistvm.init();
    });

    it('should_return_first_item_when_isCollapsed_is_true_and_moreNtfList_has_items', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let moreVm: LiveDropdownVmInjector = new LiveDropdownVmInjector();
      let mocker: MockKit = new MockKit();

      let mockMoreVm: Function =
        mocker.mockFunc(notificationlistvm.vmInjector, notificationlistvm.vmInjector.getMoreVm);
      when(mockMoreVm)().afterReturn(moreVm);

      let mockNotificationMoreHeaderVm: Function =
        mocker.mockFunc(notificationlistvm.vmInjector, notificationlistvm.vmInjector.getNotificationMoreHeaderVm);
      let isCollapsed = true;
      when(mockNotificationMoreHeaderVm)().afterReturn({
        isCollapsed: isCollapsed
      });

      let mockMoreNtfList: Function = mocker.mockFunc(notificationlistvm, notificationlistvm.moreNtfList);
      let moreNtfList: NotificationArray = new NotificationArray();
      moreNtfList.push(new NotificationBase());
      when(mockMoreNtfList)().afterReturn(moreNtfList);

      expect(notificationlistvm.displayedMoreNtfList.length).assertEqual(1);

      mocker.ignoreMock(notificationlistvm.vmInjector, notificationlistvm.vmInjector.getMoreVm);
      mocker.ignoreMock(notificationlistvm.vmInjector, notificationlistvm.vmInjector.getNotificationMoreHeaderVm);
      mocker.ignoreMock(notificationlistvm, notificationlistvm.moreNtfList);
    });

    it('should_return_moreNtfList_when_isCollapsed_is_false_or_moreNtfList_is_empty', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let moreVm: LiveDropdownVmInjector = new LiveDropdownVmInjector();
      let mocker: MockKit = new MockKit();

      let mockMoreVm: Function =
        mocker.mockFunc(notificationlistvm.vmInjector, notificationlistvm.vmInjector.getMoreVm);
      when(mockMoreVm)().afterReturn(moreVm);

      let mockNotificationMoreHeaderVm: Function =
        mocker.mockFunc(notificationlistvm.vmInjector, notificationlistvm.vmInjector.getNotificationMoreHeaderVm);
      let isCollapsed = false;
      when(mockNotificationMoreHeaderVm)().afterReturn({
        isCollapsed: isCollapsed
      });

      let mockMoreNtfList: Function = mocker.mockFunc(notificationlistvm, notificationlistvm.moreNtfList);
      let moreNtfList: NotificationArray = new NotificationArray();
      when(mockMoreNtfList)().afterReturn(moreNtfList);

      expect(notificationlistvm.displayedMoreNtfList.length).assertEqual(0);

      mocker.ignoreMock(notificationlistvm.vmInjector, notificationlistvm.vmInjector.getMoreVm);
      mocker.ignoreMock(notificationlistvm.vmInjector, notificationlistvm.vmInjector.getNotificationMoreHeaderVm);
      mocker.ignoreMock(notificationlistvm, notificationlistvm.moreNtfList);
    });

    it('should_return_index_when_ntf_in_mainNtfList', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();

      let ntf: NotificationBase = new NotificationBase();
      ntf.hashCode = 12345;

      notificationlistvm.mainNtfList = [ntf];
      const result = notificationlistvm.getListItemIndex(ntf);
      expect(result).assertEqual(0);
    });

    it('should_return_index_when_ntf_in_moreNtfList', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();

      let ntf: NotificationBase = new NotificationBase();
      ntf.hashCode = 12345;

      notificationlistvm.moreNtfList = [ntf];
      const result = notificationlistvm.getListItemIndex(ntf);
      expect(result).assertEqual(notificationlistvm.mainNtfList.length + 1);
    });

    it('should_return_minus_one_when_ntf_not_in_either_list', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();

      let ntf: NotificationBase = new NotificationBase();
      ntf.hashCode = 12345;

      const result = notificationlistvm.getListItemIndex(ntf);
      expect(result).assertEqual(-1);
    });

    it('should_set_clipShape_correctly_when_size_is_valid', 0, () => {
      const notificationlistvm: NotificationListVm = new NotificationListVm();
      const size: SizeOptions = {
        width: '100', height: '100'
      };
      notificationlistvm.onListSizeChange(size);
      expect(notificationlistvm.clipShape).assertInstanceOf(Path);
    });

    it('should_set_clipShape_correctly_when_size_is_invalid', 0, () => {
      const notificationlistvm: NotificationListVm = new NotificationListVm();
      const size: SizeOptions = {
        width: '0', height: '0'
      };
      notificationlistvm.onListSizeChange(size);
      expect(notificationlistvm.clipShape).assertInstanceOf(Path);
    });

    it('should_not_execute_animation_when_event_type_is_remove', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_REMOVE);
      let mocker: MockKit = new MockKit();

      notificationlistvm.handleNotificationEvent(event);

      expect(notificationlistvm.updateNtf).not.toHaveBeenCalled();
    });

    it('should_execute_animation_when_event_type_is_not_remove', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_SWIPE);
      let mocker: MockKit = new MockKit();

      notificationlistvm.handleNotificationEvent(event);

      expect(notificationlistvm.updateNtf).toHaveBeenCalled();
    });

    it('should_update_ntf_list_when_event_type_is_swipe_or_drag', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_SWIPE);
      let mocker: MockKit = new MockKit();

      notificationlistvm.handleNotificationEvent(event);

      expect(notificationlistvm.mainNtfList.length).not.assertEqual(0);
    });

    it('should_separate_mainNtfList_and_moreNtfList_correctly', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();
      let mockDeviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let mockDropdownVm: DropdownVm = DropdownVm.instance;
      let mockLiveDropdownVmInjector: LiveDropdownVmInjector = LiveDropdownVmInjector.instance;
      let mockNotificationSwipeVm: NotificationSwipeVm = new NotificationSwipeVm();
      let mockNotificationNormalVm: NotificationNormalVm = new NotificationNormalVm();
      let mockNotificationDataVm: NotificationDataVm = new NotificationDataVm();

      notificationlistvm.mainNtfList.push(
        new NotificationBase({
          id: 1,
          content: 'content1',
          category: NotificationCategory.OTHER,
        }),
        new NotificationBase({
          id: 2,
          content: 'content2',
          category: NotificationCategory.OTHER,
        }),
        new NotificationBase({
          id: 3,
          content: 'content3',
          category: NotificationCategory.SOCIAL,
        }),
        new NotificationBase({
          id: 4,
          content: 'content4',
          category: NotificationCategory.SOCIAL,
        }),
      );

      notificationlistvm.moreNtfList.push(
        new NotificationBase({
          id: 5,
          content: 'content5',
          category: NotificationCategory.OTHER,
        }),
        new NotificationBase({
          id: 6,
          content: 'content6',
          category: NotificationCategory.SOCIAL,
        }),
      );

      notificationlistvm.groupForEach((ntf) => {
        if (notificationlistvm.isNeedFilter(ntf)) {
          return;
        }
        if (ntf.category === NotificationCategory.OTHER) {
          notificationlistvm.moreNtfList.push(ntf);
        } else {
          notificationlistvm.mainNtfList.push(ntf);
        }
      });

      expect(notificationlistvm.mainNtfList.length).assertEqual(2);
      expect(notificationlistvm.moreNtfList.length).assertEqual(3);
    });

    it('should_return_correct_index_when_moreNtfList_is_not_empty_and_isCollapsed_is_true', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();
      let moreNtfList: NotificationArray = new NotificationArray();
      let mainNtfList: NotificationArray = new NotificationArray();
      let mockfunc1: Function = mocker.mockFunc(notificationlistvm, notificationlistvm.moreNtfList);
      let mockfunc2: Function = mocker.mockFunc(notificationlistvm, notificationlistvm.vmInjector);

      when(mockfunc1)(ArgumentMatchers.any).afterReturn(moreNtfList);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn({
        isCollapsed: true
      });

      const result = notificationlistvm.getMaxIndex();
      expect(result).assertEqual(mainNtfList.length + 1);

      mocker.ignoreMock(notificationlistvm, notificationlistvm.moreNtfList);
      mocker.ignoreMock(notificationlistvm, notificationlistvm.vmInjector);
    });

    it('should_return_correct_index_when_moreNtfList_is_not_empty_and_isCollapsed_is_false', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();
      let moreNtfList: NotificationArray = new NotificationArray();
      let mainNtfList: NotificationArray = new NotificationArray();
      let mockfunc1: Function = mocker.mockFunc(notificationlistvm, notificationlistvm.moreNtfList);
      let mockfunc2: Function = mocker.mockFunc(notificationlistvm, notificationlistvm.vmInjector);

      when(mockfunc1)(ArgumentMatchers.any).afterReturn(moreNtfList);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn({
        isCollapsed: false
      });

      const result = notificationlistvm.getMaxIndex();
      expect(result).assertEqual(mainNtfList.length + moreNtfList.length);

      mocker.ignoreMock(notificationlistvm, notificationlistvm.moreNtfList);
      mocker.ignoreMock(notificationlistvm, notificationlistvm.vmInjector);
    });

    it('should_return_correct_index_when_moreNtfList_is_empty', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();
      let moreNtfList: NotificationArray = new NotificationArray();
      let mainNtfList: NotificationArray = new NotificationArray();
      let mockfunc1: Function = mocker.mockFunc(notificationlistvm, notificationlistvm.moreNtfList);
      let mockfunc2: Function = mocker.mockFunc(notificationlistvm, notificationlistvm.vmInjector);

      when(mockfunc1)(ArgumentMatchers.any).afterReturn(moreNtfList);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn({
        isCollapsed: false
      });

      const result = notificationlistvm.getMaxIndex();
      expect(result).assertEqual(mainNtfList.length - 1);

      mocker.ignoreMock(notificationlistvm, notificationlistvm.moreNtfList);
      mocker.ignoreMock(notificationlistvm, notificationlistvm.vmInjector);
    });

    it('should_execute_all_steps_when_isPanelVisible_is_false', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      notificationlistvm.isPanelVisible = false;
      let mocker: MockKit = new MockKit();

      let mockUpdateGroup: Function = mocker.mockFunc(notificationlistvm, notificationlistvm.updateGroup);
      when(mockUpdateGroup)(ArgumentMatchers.any).afterReturnNothing();

      let mockSort: Function = mocker.mockFunc(notificationlistvm, notificationlistvm.sort);
      when(mockSort)().afterReturnNothing();

      let mockNotificationSwipeVmReset: Function = mocker.mockFunc(NotificationSwipeVm, NotificationSwipeVm.reset);
      when(mockNotificationSwipeVmReset)().afterReturnNothing();

      let mockNotificationNormalVmHideActionButtons: Function =
        mocker.mockFunc(NotificationNormalVm, NotificationNormalVm.hideActionButtons);
      when(mockNotificationNormalVmHideActionButtons)(ArgumentMatchers.any).afterReturnNothing();

      notificationlistvm.onPanelVisibleChange();

      mocker.ignoreMock(notificationlistvm, notificationlistvm.updateGroup);
      mocker.ignoreMock(notificationlistvm, notificationlistvm.sort);
      mocker.ignoreMock(NotificationSwipeVm, NotificationSwipeVm.reset);
      mocker.ignoreMock(NotificationNormalVm, NotificationNormalVm.hideActionButtons);
    });

    it('should_add_icon_hashes_to_list_when_ntf_is_normal_group', 0, () => {
      const notificationListVm: NotificationListVm = new NotificationListVm();
      const ntfList: NotificationArray = new NotificationArray();
      const allNtfList: string[] = [];
      const ntf: NotificationBase = new NotificationBase();
      ntf.isNormalGroup = () => true;
      const childNtf: NotificationBase = new NotificationBase();
      ntf.children = new NotificationArray();
      ntf.children.push(childNtf);
      ntfList.push(ntf);

      notificationListVm.addStatusBarIconHashList(ntfList, allNtfList);

      expect(allNtfList.length).assertEqual(1);
      expect(allNtfList[0]).assertEqual(childNtf.hashCode);
    });

    it('should_add_icon_hashes_to_list_when_ntf_is_not_normal_group', 0, () => {
      const notificationListVm: NotificationListVm = new NotificationListVm();
      const ntfList: NotificationArray = new NotificationArray();
      const allNtfList: string[] = [];
      const ntf: NotificationBase = new NotificationBase();
      ntf.isNormalGroup = () => false;
      ntfList.push(ntf);

      notificationListVm.addStatusBarIconHashList(ntfList, allNtfList);

      expect(allNtfList.length).assertEqual(1);
      expect(allNtfList[0]).assertEqual(ntf.hashCode);
    });

    it('should_not_add_icon_hash_when_creator_bundle_name_is_null', 0, () => {
      const notificationListVm: NotificationListVm = new NotificationListVm();
      const ntfList: NotificationArray = new NotificationArray();
      const allNtfList: string[] = [];
      const ntf: NotificationBase = new NotificationBase();
      ntf.creatorBundleName = null;
      ntf.creatorUid = 'uid';
      ntf.isLiveView = () => false;
      ntf.isShowStatusBarIcon = true;
      ntfList.push(ntf);

      notificationListVm.addStatusBarIconHashList(ntfList, allNtfList);

      expect(allNtfList.length).assertEqual(0);
    });

    it('should_not_add_icon_hash_when_hash_already_added', 0, () => {
      const notificationListVm: NotificationListVm = new NotificationListVm();
      const ntfList: NotificationArray = new NotificationArray();
      const allNtfList: string[] = [];
      const ntf: NotificationBase = new NotificationBase();
      ntf.creatorBundleName = 'bundleName';
      ntf.creatorUid = 'uid';
      ntf.isLiveView = () => false;
      ntf.isShowStatusBarIcon = true;
      ntfList.push(ntf);
      allNtfList.push(ntf.hashCode);

      notificationListVm.addStatusBarIconHashList(ntfList, allNtfList);

      expect(allNtfList.length).assertEqual(1);
      expect(allNtfList[0]).assertEqual(ntf.hashCode);
    });

    it('should_not_add_icon_hash_when_is_live_view_is_true', 0, () => {
      const notificationListVm: NotificationListVm = new NotificationListVm();
      const ntfList: NotificationArray = new NotificationArray();
      const allNtfList: string[] = [];
      const ntf: NotificationBase = new NotificationBase();
      ntf.creatorBundleName = 'bundleName';
      ntf.creatorUid = 'uid';
      ntf.isLiveView = () => true;
      ntf.isShowStatusBarIcon = true;
      ntfList.push(ntf);

      notificationListVm.addStatusBarIconHashList(ntfList, allNtfList);

      expect(allNtfList.length).assertEqual(0);
    });

    it('should_not_add_icon_hash_when_is_show_status_bar_icon_is_false', 0, () => {
      const notificationListVm: NotificationListVm = new NotificationListVm();
      const ntfList: NotificationArray = new NotificationArray();
      const allNtfList: string[] = [];
      const ntf: NotificationBase = new NotificationBase();
      ntf.creatorBundleName = 'bundleName';
      ntf.creatorUid = 'uid';
      ntf.isLiveView = () => false;
      ntf.isShowStatusBarIcon = false;
      ntfList.push(ntf);

      notificationListVm.addStatusBarIconHashList(ntfList, allNtfList);

      expect(allNtfList.length).assertEqual(0);
    });

    it('should_return_immediately_when_ntf_is_not_normal_group', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let ntf: NotificationBase = new NotificationBase();
      ntf.category = NotificationCategory.NOTIFICATION_VARIANT_GROUP;
      notificationlistvm.updateGroup(ntf);
    });

    it('should_collapse_group_when_ntf_has_more_than_one_child', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let ntf: NotificationBase = new NotificationBase();
      ntf.category = NotificationCategory.NOTIFICATION_VARIANT_NORMAL_GROUP;
      ntf.children = [new NotificationBase(), new NotificationBase()];
      notificationlistvm.updateGroup(ntf);
    });

    it('should_release_group_when_ntf_has_only_one_child', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let ntf: NotificationBase = new NotificationBase();
      ntf.category = NotificationCategory.NOTIFICATION_VARIANT_NORMAL_GROUP;
      ntf.children = [new NotificationBase()];
      notificationlistvm.updateGroup(ntf);
    });

  });
}