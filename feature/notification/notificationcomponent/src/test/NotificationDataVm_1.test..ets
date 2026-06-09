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
import { ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import {
  NotificationBaseVm,
  INotificationDataVm,
  NotificationRefreshType,
  NotificationRefreshRecord
} from '@ohos/systemuicommon/newIndex';
import {
  InnerEventUtil,
  NormalNotification,
  NormalNotificationGroup,
  NotificationArray,
  NotificationBase,
  NotificationCategory,
  NotificationEvent
} from '@ohos/systemuicommon/newTsIndex';
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
import { NotificationDataVm } from '../../../main/ets/viewmodel/NotificationDataVm';

export default function NotificationDataVmTest() {
  describe('init_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_log_info_and_register_event_listener', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      notificationdatavm.init();
    });

    it('should_log_info_and_off_event_when_destroy_is_called', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();

      notificationdatavm.destroy();

    });

    it('should_clear_ntfGroupMap_and_ntfHashMap_when_destroy_is_called', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();

      notificationdatavm.destroy();

      expect(notificationdatavm.ntfGroupMap.size).assertEqual(0);
      expect(notificationdatavm.ntfHashMap.size).assertEqual(0);
    });

    it('should_call_callback_for_each_item_in_ntfGroupMap', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();

      let callback: (value: NotificationBase, key: string, map: Map<string, NotificationBase>) => void =
        (value: NotificationBase, key: string, map: Map<string, NotificationBase>) => {
          expect(value).assertInstanceOf(NotificationBase);
          expect(key).assertInstanceOf(String);
          expect(map).assertInstanceOf(Map);
        };

      notificationdatavm.groupForEach(callback);
    });


    it('should_return_undefined_when_groupKey_is_not_found', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let result = notificationdatavm.getNtfByGroupKey('non_existing_key');
      expect(result).assertUndefined();
    });

    it('should_return_notification_when_groupKey_is_found', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mockNtfGroup: NotificationBase = new NormalNotification('1', 'group1', NotificationCategory.INFO, 'content1');
      notificationdatavm.ntfGroupMap.set('group1', mockNtfGroup);
      let result = notificationdatavm.getNtfByGroupKey('group1');
      expect(result).assertInstanceOf(NotificationBase);
      expect(result?.getContent()).assertEqual('content1');
    });

    it('should_return_undefined_when_ntfHashMap_does_not_contain_key', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let hashcode: string = 'non_existent_hashcode';
      let result = notificationdatavm.getNtfByHashCode(hashcode);
      expect(result).assertUndefined();
    });

    it('should_return_notification_when_ntfHashMap_contains_key', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let hashcode: string = 'existing_hashcode';
      let mockNtf: NotificationBase = new NormalNotification('existing_title', 'existing_content',
        NotificationCategory.NOTIFICATION_CATEGORY_DEFAULT);
      notificationdatavm.ntfHashMap.set(hashcode, mockNtf);
      let result = notificationdatavm.getNtfByHashCode(hashcode);
      expect(result).assertInstanceOf(NotificationBase);
      expect(result?.title).assertEqual('existing_title');
      expect(result?.content).assertEqual('existing_content');
      expect(result?.category).assertEqual(NotificationCategory.NOTIFICATION_CATEGORY_DEFAULT);
    });

    it('should_return_undefined_when_ntfGroupMap_is_empty', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let ntf: NotificationBase = new NormalNotification('1');
      ntf.groupKey = 'testGroup';
      let result = notificationdatavm.getGroupNtf(ntf);
      expect(result).assertUndefined();
    });

    it('should_return_undefined_when_existNtf_is_not_normal_group', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let ntf: NotificationBase = new NormalNotification('1');
      ntf.groupKey = 'testGroup';
      let existNtf: NotificationBase = new NormalNotification('2');
      existNtf.groupKey = 'testGroup';
      existNtf.isNormalGroup = () => false;
      notificationdatavm.ntfGroupMap.set('testGroup', existNtf);
      let result = notificationdatavm.getGroupNtf(ntf);
      expect(result).assertUndefined();
    });

    it('should_return_existNtf_when_existNtf_is_normal_group', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let ntf: NotificationBase = new NormalNotification('1');
      ntf.groupKey = 'testGroup';
      let existNtf: NotificationBase = new NormalNotification('2');
      existNtf.groupKey = 'testGroup';
      existNtf.isNormalGroup = () => true;
      notificationdatavm.ntfGroupMap.set('testGroup', existNtf);
      let result = notificationdatavm.getGroupNtf(ntf);
      expect(result).assertDeepEquals(existNtf);
    });

    it('should_release_group_when_group_is_not_null', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();

      let group: NormalNotificationGroup = new NormalNotificationGroup();
      group.groupKey = 'testGroup';
      let children: Array<NotificationBase> = new Array<NotificationBase>();
      let child1: NormalNotification = new NormalNotification();
      child1.title = 'testChild1';
      let child2: NormalNotification = new NormalNotification();
      child2.title = 'testChild2';
      children.push(child1);
      children.push(child2);
      group.children = children;

      notificationdatavm.releaseGroup(group);

    });

    it('should_not_release_group_when_group_is_null', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();

      let group: NormalNotificationGroup = null;

      notificationdatavm.releaseGroup(group);
    });

    it('should_return_immediately_when_notificationList_is_empty_and_eventType_is_not_INIT', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_ADD, []);
      notificationdatavm.handleNotificationEvent(event);
      expect(notificationdatavm.dataRefreshRecord.isDataRefresh).assertFalse();
    });

    it('should_handle_init_event_correctly', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_INIT, [
        new NormalNotification('1', 'title', 'content', NotificationCategory.NOTIFICATION_TYPE_DEFAULT, 1)
      ]);
      notificationdatavm.handleNotificationEvent(event);
      expect(notificationdatavm.dataRefreshRecord.isDataRefresh).assertTrue();
      expect(notificationdatavm.dataRefreshRecord.dataRefreshType).assertEqual(NotificationRefreshType.DATA_INIT);
    });

    it('should_handle_add_event_correctly', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_ADD, [
        new NormalNotification('1', 'title', 'content', NotificationCategory.NOTIFICATION_TYPE_DEFAULT, 1)
      ]);
      notificationdatavm.handleNotificationEvent(event);
      expect(notificationdatavm.dataRefreshRecord.isDataRefresh).assertTrue();
      expect(notificationdatavm.dataRefreshRecord.dataRefreshType).assertEqual(NotificationRefreshType.DATA_ADD);
    });

    it('should_handle_update_event_correctly', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_UPDATE, [
        new NormalNotification('1', 'title', 'content', NotificationCategory.NOTIFICATION_TYPE_DEFAULT, 1)
      ]);
      notificationdatavm.handleNotificationEvent(event);
      expect(notificationdatavm.dataRefreshRecord.isDataRefresh).assertTrue();
      expect(notificationdatavm.dataRefreshRecord.dataRefreshType).assertEqual(NotificationRefreshType.DATA_UPDATE);
    });

    it('should_handle_remove_event_correctly', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_REMOVE, [
        new NormalNotification('1', 'title', 'content', NotificationCategory.NOTIFICATION_TYPE_DEFAULT, 1)
      ]);
      notificationdatavm.handleNotificationEvent(event);
      expect(notificationdatavm.dataRefreshRecord.isDataRefresh).assertTrue();
      expect(notificationdatavm.dataRefreshRecord.dataRefreshType).assertEqual(NotificationRefreshType.DATA_DELETE);
    });

    it('should_handle_mixed_event_correctly', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_MIXED, [
        new NormalNotification('1', 'title', 'content', NotificationCategory.NOTIFICATION_TYPE_DEFAULT, 1),
        new NormalNotification('2', 'title', 'content', NotificationCategory.NOTIFICATION_TYPE_DEFAULT, 1)
      ]);
      notificationdatavm.handleNotificationEvent(event);
      expect(notificationdatavm.dataRefreshRecord.isDataRefresh).assertTrue();
      expect(notificationdatavm.dataRefreshRecord.dataRefreshType).assertEqual(NotificationRefreshType.DATA_MIXED);
    });

    it('should_clear_ntfGroupMap_and_ntfHashMap_when_incomingNtfList_is_not_empty', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let incomingNtfList: NotificationBase[] = [
        new NormalNotification('1', 'alert', NotificationCategory.INFO, 'id1'),
        new NormalNotification('2', 'alert', NotificationCategory.INFO, 'id2')
      ];
      notificationdatavm.handleInitEvent(incomingNtfList);
      expect(notificationdatavm.ntfGroupMap.size).assertEqual(2);
      expect(notificationdatavm.ntfHashMap.size).assertEqual(2);
    });

    it('should_clear_ntfGroupMap_and_ntfHashMap_when_incomingNtfList_is_empty', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let incomingNtfList: NotificationBase[] = [];
      notificationdatavm.handleInitEvent(incomingNtfList);
      expect(notificationdatavm.ntfGroupMap.size).assertEqual(0);
      expect(notificationdatavm.ntfHashMap.size).assertEqual(0);
    });

    it('should_handle_add_update_event_correctly_when_incomingNtfList_is_null', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let incomingNtfList: NotificationBase[] | undefined = undefined;
      notificationdatavm.handleAddUpdateEvent(incomingNtfList);
      // 没有具体断言，但期望函数不抛出异常
    });

    it('should_handle_add_update_event_correctly_when_incomingNtfList_is_empty', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let incomingNtfList: NotificationBase[] = [];
      notificationdatavm.handleAddUpdateEvent(incomingNtfList);
      // 没有具体断言，但期望函数不抛出异常
    });

    it('should_handle_add_update_event_correctly_when_incomingNtfList_has_elements', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let incomingNtfList: NotificationBase[] = [
        new NormalNotification('1', 'group1', 'content1', NotificationCategory.NOTIFICATION_CATEGORY_SOCIAL),
        new NormalNotification('2', 'group2', 'content2', NotificationCategory.NOTIFICATION_CATEGORY_SOCIAL)
      ];
      notificationdatavm.handleAddUpdateEvent(incomingNtfList);
      // 没有具体断言，但期望函数不抛出异常
    });

    it('should_handle_add_update_event_correctly_when_saveNtf_returns_new_data', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let incomingNtfList: NotificationBase[] = [
        new NormalNotification('1', 'group1', 'content1', NotificationCategory.NOTIFICATION_CATEGORY_SOCIAL)
      ];
      let mocker: MockKit = new MockKit();

      notificationdatavm.handleAddUpdateEvent(incomingNtfList);
    });

    it('should_handle_add_update_event_correctly_when_saveNtf_returns_existing_data', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let incomingNtfList: NotificationBase[] = [
        new NormalNotification('1', 'group1', 'content1', NotificationCategory.NOTIFICATION_CATEGORY_SOCIAL)
      ];
      let mocker: MockKit = new MockKit();

      notificationdatavm.handleAddUpdateEvent(incomingNtfList);
    });

    it('should_handle_add_update_event_correctly_when_saveNtf_returns_null', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let incomingNtfList: NotificationBase[] = [
        new NormalNotification('1', 'group1', 'content1', NotificationCategory.NOTIFICATION_CATEGORY_SOCIAL)
      ];
      let mocker: MockKit = new MockKit();

      notificationdatavm.handleAddUpdateEvent(incomingNtfList);
    });


    it('should_do_nothing_when_incomingNtf_is_null', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let incomingNtf: NotificationBase = null;
      notificationdatavm.deleteWrongGroup(incomingNtf);
    });

    it('should_do_nothing_when_existNtf_is_null', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let incomingNtf: NotificationBase = new NormalNotification();
      notificationdatavm.deleteWrongGroup(incomingNtf);
    });

    it('should_delete_old_data_when_existNtf_is_not_normal_and_incomingNtf_has_different_group_or_category', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let incomingNtf: NotificationBase = new NormalNotification();
      incomingNtf.groupKey = 'group1';
      incomingNtf.category = NotificationCategory.EMERGENCY;
      let existNtf: NotificationBase = new NormalNotification();
      existNtf.groupKey = 'group2';
      existNtf.category = NotificationCategory.WARNING;
      notificationdatavm.deleteWrongGroup(incomingNtf);
    });

    it('should_do_nothing_when_existNtf_is_normal_and_incomingNtf_has_same_group', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let incomingNtf: NotificationBase = new NormalNotification();
      incomingNtf.groupKey = 'group1';
      let existNtf: NotificationBase = new NormalNotification();
      existNtf.groupKey = 'group1';
      notificationdatavm.deleteWrongGroup(incomingNtf);
    });

    it('should_delete_old_data_and_handle_group_disfragmentation', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let incomingNtf: NotificationBase = new NormalNotification();
      incomingNtf.groupKey = 'group1';
      let existNtf: NotificationBase = new NormalNotification();
      existNtf.groupKey = 'group1';
      let newGroup: NotificationBase = new NormalNotificationGroup();
      notificationdatavm.deleteWrongGroup(incomingNtf);
    });


    it('should_return_undefined_when_incomingNtf_is_null', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      const result = notificationdatavm.saveNtf(null);
      expect(result).assertEqual(undefined);
    });

    it('should_add_new_ntf_when_existNtf_is_null', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.addHashMapData);
      let mockfunc2: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.addMapData);
      let mockfunc3: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.recordDataRefresh);
      let mockfunc4: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.vmInjector);

      let incomingNtf: NotificationBase = new NormalNotification('1', '1', NotificationCategory.NOTIFICATION_TYPE_DEFAULT);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(incomingNtf);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(incomingNtf);
      when(mockfunc3)(ArgumentMatchers.any).afterReturnNothing();
      when(mockfunc4)(ArgumentMatchers.any).afterReturnNothing();

      const result = notificationdatavm.saveNtf(incomingNtf);
      expect(result).assertInstanceOf(NotificationBase);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.addHashMapData);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.addMapData);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.recordDataRefresh);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.vmInjector);
    });

    it('should_add_ntf_to_group_when_existNtf_is_normal_group', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.addHashMapData);
      let mockfunc2: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.addMapData);
      let mockfunc3: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.recordDataRefresh);
      let mockfunc4: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.vmInjector);

      let existNtf: NotificationBase = new NormalNotification('1', '1', NotificationCategory.NOTIFICATION_TYPE_DEFAULT);
      let incomingNtf: NotificationBase = new NormalNotification('2', '2', NotificationCategory.NOTIFICATION_TYPE_DEFAULT);
      notificationdatavm.ntfGroupMap.set(existNtf.groupKey, existNtf);

      when(mockfunc)(ArgumentMatchers.any).afterReturn(incomingNtf);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(incomingNtf);
      when(mockfunc3)(ArgumentMatchers.any).afterReturnNothing();
      when(mockfunc4)(ArgumentMatchers.any).afterReturnNothing();

      const result = notificationdatavm.saveNtf(incomingNtf);
      expect(result).assertInstanceOf(NotificationBase);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.addHashMapData);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.addMapData);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.recordDataRefresh);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.vmInjector);
    });

    it('should_update_single_ntf_when_existNtf_is_same_hashCode', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.addHashMapData);
      let mockfunc2: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.addMapData);
      let mockfunc3: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.recordDataRefresh);
      let mockfunc4: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.vmInjector);

      let existNtf: NotificationBase = new NormalNotification('1', '1', NotificationCategory.NOTIFICATION_TYPE_DEFAULT);
      let incomingNtf: NotificationBase = new NormalNotification('1', '2', NotificationCategory.NOTIFICATION_TYPE_DEFAULT);
      notificationdatavm.ntfGroupMap.set(existNtf.groupKey, existNtf);
      notificationdatavm.ntfHashMap.set(existNtf.hashCode, existNtf);

      when(mockfunc)(ArgumentMatchers.any).afterReturn(incomingNtf);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(incomingNtf);
      when(mockfunc3)(ArgumentMatchers.any).afterReturnNothing();
      when(mockfunc4)(ArgumentMatchers.any).afterReturnNothing();

      const result = notificationdatavm.saveNtf(incomingNtf);
      expect(result).assertInstanceOf(NotificationBase);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.addHashMapData);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.addMapData);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.recordDataRefresh);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.vmInjector);
    });

    it('should_merge_ntfs_when_existNtf_and_incomingNtf_are_both_normal', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.addHashMapData);
      let mockfunc2: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.addMapData);
      let mockfunc3: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.recordDataRefresh);
      let mockfunc4: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.vmInjector);

      let existNtf: NotificationBase = new NormalNotification('1', '1', NotificationCategory.NOTIFICATION_TYPE_DEFAULT);
      let incomingNtf: NotificationBase = new NormalNotification('2', '2', NotificationCategory.NOTIFICATION_TYPE_DEFAULT);
      notificationdatavm.ntfGroupMap.set(existNtf.groupKey, existNtf);
      notificationdatavm.ntfHashMap.set(existNtf.hashCode, existNtf);

      when(mockfunc)(ArgumentMatchers.any).afterReturn(incomingNtf);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(incomingNtf);
      when(mockfunc3)(ArgumentMatchers.any).afterReturnNothing();
      when(mockfunc4)(ArgumentMatchers.any).afterReturnNothing();

      const result = notificationdatavm.saveNtf(incomingNtf);
      expect(result).assertInstanceOf(NotificationBase);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.addHashMapData);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.addMapData);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.recordDataRefresh);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.vmInjector);
    });

    it('should_handle_notification_event_when_saveNtf_is_called', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.onNotificationEvent);

      let incomingNtf: NotificationBase = new NormalNotification('1', '1', NotificationCategory.NOTIFICATION_TYPE_DEFAULT);

      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      notificationdatavm.saveNtf(incomingNtf);

      mocker.ignoreMock(notificationdatavm, notificationdatavm.onNotificationEvent);
    });

  });
}
