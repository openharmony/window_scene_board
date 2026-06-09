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
  describe('clearNtf_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_undefined_when_incomingNtf_is_null', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let result = notificationdatavm.clearNtf(null);
      expect(result).assertEqual(undefined);
    });

    it('should_return_undefined_when_existNtf_is_null', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let incomingNtf: NotificationBase =
        new NormalNotification('1', '1', NotificationCategory.NOTIFICATION_TYPE_SERVICE, '1');
      let result = notificationdatavm.clearNtf(incomingNtf);
      expect(result).assertEqual(undefined);
    });

    it('should_return_undefined_when_existNtf_is_not_NormalNotificationGroup', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let incomingNtf: NotificationBase =
        new NormalNotification('1', '1', NotificationCategory.NOTIFICATION_TYPE_SERVICE, '1');
      let existNtf: NotificationBase =
        new NormalNotification('2', '2', NotificationCategory.NOTIFICATION_TYPE_SERVICE, '2');
      notificationdatavm['ntfGroupMap'].set(incomingNtf.groupKey, existNtf);
      let result = notificationdatavm.clearNtf(incomingNtf);
      expect(result).assertEqual(undefined);
    });

    it('should_return_undefined_when_existNtf_is_NormalNotificationGroup_and_newGroup_is_null', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let incomingNtf: NotificationBase =
        new NormalNotification('1', '1', NotificationCategory.NOTIFICATION_TYPE_SERVICE, '1');
      let existNtf: NotificationBase =
        new NormalNotificationGroup('2', '2', NotificationCategory.NOTIFICATION_TYPE_SERVICE, '2');
      notificationdatavm['ntfGroupMap'].set(incomingNtf.groupKey, existNtf);
      let result = notificationdatavm.clearNtf(incomingNtf);
      expect(result).assertEqual(undefined);
    });

    it('should_return_undefined_when_existNtf_is_NormalNotificationGroup_and_newGroup_has_one_child', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let incomingNtf: NotificationBase =
        new NormalNotification('1', '1', NotificationCategory.NOTIFICATION_TYPE_SERVICE, '1');
      let existNtf: NotificationBase =
        new NormalNotificationGroup('2', '2', NotificationCategory.NOTIFICATION_TYPE_SERVICE, '2');
      let newGroup: NotificationBaseGroup =
        new NormalNotificationGroup('2', '2', NotificationCategory.NOTIFICATION_TYPE_SERVICE, '2');
      newGroup.children = [new NormalNotification('3', '3', NotificationCategory.NOTIFICATION_TYPE_SERVICE, '3')];
      notificationdatavm['ntfGroupMap'].set(incomingNtf.groupKey, existNtf);
      let result = notificationdatavm.clearNtf(incomingNtf);
      expect(result).assertEqual(undefined);
    });

    it('should_return_undefined_when_existNtf_is_NormalNotificationGroup_and_newGroup_has_multiple_children', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let incomingNtf: NotificationBase =
        new NormalNotification('1', '1', NotificationCategory.NOTIFICATION_TYPE_SERVICE, '1');
      let existNtf: NotificationBase =
        new NormalNotificationGroup('2', '2', NotificationCategory.NOTIFICATION_TYPE_SERVICE, '2');
      let newGroup: NotificationBaseGroup =
        new NormalNotificationGroup('2', '2', NotificationCategory.NOTIFICATION_TYPE_SERVICE, '2');
      newGroup.children = [new NormalNotification('3', '3', NotificationCategory.NOTIFICATION_TYPE_SERVICE, '3'),
        new NormalNotification('4', '4', NotificationCategory.NOTIFICATION_TYPE_SERVICE, '4')];
      notificationdatavm['ntfGroupMap'].set(incomingNtf.groupKey, existNtf);
      let result = notificationdatavm.clearNtf(incomingNtf);
      expect(result).assertEqual(undefined);
    });

    it('should_return_undefined_when_existNtf_is_NormalNotificationGroup_and_newGroup_has_children_and_isResetGroup_is_true',
      0, () => {
        let notificationdatavm: NotificationDataVm = new NotificationDataVm();
        let incomingNtf: NotificationBase =
          new NormalNotification('1', '1', NotificationCategory.NOTIFICATION_TYPE_SERVICE, '1');
        let existNtf: NotificationBase =
          new NormalNotificationGroup('2', '2', NotificationCategory.NOTIFICATION_TYPE_SERVICE, '2');
        let newGroup: NotificationBaseGroup =
          new NormalNotificationGroup('2', '2', NotificationCategory.NOTIFICATION_TYPE_SERVICE, '2');
        newGroup.children = [new NormalNotification('3', '3', NotificationCategory.NOTIFICATION_TYPE_SERVICE, '3')];
        notificationdatavm['ntfGroupMap'].set(incomingNtf.groupKey, existNtf);
        let result = notificationdatavm.clearNtf(incomingNtf);
        expect(result).assertEqual(undefined);
      });

    it('should_return_undefined_when_existNtf_is_NormalNotification_and_hashCode_matches', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let incomingNtf: NotificationBase =
        new NormalNotification('1', '1', NotificationCategory.NOTIFICATION_TYPE_SERVICE, '1');
      let existNtf: NotificationBase =
        new NormalNotification('1', '1', NotificationCategory.NOTIFICATION_TYPE_SERVICE, '1');
      notificationdatavm['ntfGroupMap'].set(incomingNtf.groupKey, existNtf);
      let result = notificationdatavm.clearNtf(incomingNtf);
      expect(result).assertEqual(undefined);
    });

    it('should_return_undefined_when_existNtf_is_NormalNotificationGroup_and_hashCode_does_not_match', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let incomingNtf: NotificationBase =
        new NormalNotification('1', '1', NotificationCategory.NOTIFICATION_TYPE_SERVICE, '1');
      let existNtf: NotificationBase =
        new NormalNotificationGroup('2', '2', NotificationCategory.NOTIFICATION_TYPE_SERVICE, '2');
      notificationdatavm['ntfGroupMap'].set(incomingNtf.groupKey, existNtf);
      let result = notificationdatavm.clearNtf(incomingNtf);
      expect(result).assertEqual(undefined);
    });

    it('should_return_undefined_when_existNtf_is_NormalNotificationGroup_and_hashCode_does_not_match_and_newGroup_has_children',
      0, () => {
        let notificationdatavm: NotificationDataVm = new NotificationDataVm();
        let incomingNtf: NotificationBase =
          new NormalNotification('1', '1', NotificationCategory.NOTIFICATION_TYPE_SERVICE, '1');
        let existNtf: NotificationBase =
          new NormalNotificationGroup('2', '2', NotificationCategory.NOTIFICATION_TYPE_SERVICE, '2');
        let newGroup: NotificationBaseGroup =
          new NormalNotificationGroup('2', '2', NotificationCategory.NOTIFICATION_TYPE_SERVICE, '2');
        newGroup.children = [new NormalNotification('3', '3', NotificationCategory.NOTIFICATION_TYPE_SERVICE, '3')];
        notificationdatavm['ntfGroupMap'].set(incomingNtf.groupKey, existNtf);
        let result = notificationdatavm.clearNtf(incomingNtf);
        expect(result).assertEqual(undefined);
      });

    it('should_return_undefined_when_existNtf_is_NormalNotificationGroup_and_hashCode_does_not_match_and_newGroup_has_children_and_isResetGroup_is_true',
      0, () => {
        let notificationdatavm: NotificationDataVm = new NotificationDataVm();
        let incomingNtf: NotificationBase =
          new NormalNotification('1', '1', NotificationCategory.NOTIFICATION_TYPE_SERVICE, '1');
        let existNtf: NotificationBase =
          new NormalNotificationGroup('2', '2', NotificationCategory.NOTIFICATION_TYPE_SERVICE, '2');
        let newGroup: NotificationBaseGroup =
          new NormalNotificationGroup('2', '2', NotificationCategory.NOTIFICATION_TYPE_SERVICE, '2');
        newGroup.children = [new NormalNotification('3', '3', NotificationCategory.NOTIFICATION_TYPE_SERVICE, '3')];
        notificationdatavm['ntfGroupMap'].set(incomingNtf.groupKey, existNtf);
      });

    it('should_start_record_data_refresh_successfully', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      notificationdatavm.startRecordDataRefresh();
      expect(notificationdatavm.dataRefreshRecord.isRecordEnable).assertEqual(true);
      expect(notificationdatavm.dataRefreshRecord.isDataRefresh).assertEqual(false);
      expect(notificationdatavm.dataRefreshRecord.dataRefreshType).assertEqual(NotificationRefreshType.DATA_INIT);
      expect(notificationdatavm.dataRefreshRecord.changeDataArray).assertInstanceOf(NotificationArray);
    });

    it('should_record_refresh_type_as_DATA_INIT_when_refreshType_is_DATA_INIT', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      notificationdatavm.recordRefreshType(NotificationRefreshType.DATA_INIT);
      expect(notificationdatavm.dataRefreshRecord.dataRefreshType).assertEqual(NotificationRefreshType.DATA_INIT);
    });

    it('should_record_refresh_type_as_DATA_ADD_when_refreshType_is_DATA_ADD_and_changeDataArray_is_not_empty', 0,
      () => {
        let notificationdatavm: NotificationDataVm = new NotificationDataVm();
        let changeDataArray: NotificationArray = new NotificationArray();
        changeDataArray.add(new NormalNotification('1'));
        notificationdatavm.dataRefreshRecord.changeDataArray = changeDataArray;
        notificationdatavm.recordRefreshType(NotificationRefreshType.DATA_ADD);
        expect(notificationdatavm.dataRefreshRecord.dataRefreshType).assertEqual(NotificationRefreshType.DATA_ADD);
      });

    it('should_record_refresh_type_as_DATA_UPDATE_when_refreshType_is_DATA_ADD_and_changeDataArray_is_empty', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      notificationdatavm.recordRefreshType(NotificationRefreshType.DATA_ADD);
      expect(notificationdatavm.dataRefreshRecord.dataRefreshType).assertEqual(NotificationRefreshType.DATA_UPDATE);
    });

    it('should_record_refresh_type_as_DATA_DELETE_when_refreshType_is_DATA_DELETE_and_changeDataArray_is_not_empty', 0,
      () => {
        let notificationdatavm: NotificationDataVm = new NotificationDataVm();
        let changeDataArray: NotificationArray = new NotificationArray();
        changeDataArray.add(new NormalNotification('1'));
        notificationdatavm.dataRefreshRecord.changeDataArray = changeDataArray;
        notificationdatavm.recordRefreshType(NotificationRefreshType.DATA_DELETE);
        expect(notificationdatavm.dataRefreshRecord.dataRefreshType).assertEqual(NotificationRefreshType.DATA_DELETE);
      });

    it('should_record_refresh_type_as_DATA_UPDATE_when_refreshType_is_DATA_DELETE_and_changeDataArray_is_empty', 0,
      () => {
        let notificationdatavm: NotificationDataVm = new NotificationDataVm();
        notificationdatavm.recordRefreshType(NotificationRefreshType.DATA_DELETE);
        expect(notificationdatavm.dataRefreshRecord.dataRefreshType).assertEqual(NotificationRefreshType.DATA_UPDATE);
      });

    it('should_record_refresh_type_as_DATA_UPDATE_when_refreshType_is_DATA_UPDATE_and_changeDataArray_is_empty', 0,
      () => {
        let notificationdatavm: NotificationDataVm = new NotificationDataVm();
        notificationdatavm.recordRefreshType(NotificationRefreshType.DATA_UPDATE);
        expect(notificationdatavm.dataRefreshRecord.dataRefreshType).assertEqual(NotificationRefreshType.DATA_UPDATE);
      });

    it('should_record_refresh_type_as_DATA_ADD_when_refreshType_is_DATA_UPDATE_and_changeDataArray_is_not_empty', 0,
      () => {
        let notificationdatavm: NotificationDataVm = new NotificationDataVm();
        let changeDataArray: NotificationArray = new NotificationArray();
        changeDataArray.add(new NormalNotification('1'));
        notificationdatavm.dataRefreshRecord.changeDataArray = changeDataArray;
        notificationdatavm.recordRefreshType(NotificationRefreshType.DATA_UPDATE);
        expect(notificationdatavm.dataRefreshRecord.dataRefreshType).assertEqual(NotificationRefreshType.DATA_ADD);
      });

    it('should_return_false_when_existNtf_is_null', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let result = notificationdatavm.delMapData(null);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_existNtf_is_not_normal_group', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let existNtf: NotificationBase = new NotificationBase();
      existNtf.notificationType = NotificationCategory.NOTIFICATION_TYPE_ALERT;
      let result = notificationdatavm.delMapData(existNtf);
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_existNtf_is_normal_group_and_delete_successfully', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let existNtf: NotificationBase = new NormalNotificationGroup();
      existNtf.notificationType = NotificationCategory.NOTIFICATION_TYPE_ALERT_GROUP;
      existNtf.children = new NotificationArray();
      existNtf.children?.push(new NormalNotification());
      let mocker: MockKit = new MockKit();

      let result = notificationdatavm.delMapData(existNtf);
      expect(result).assertEqual(true);

    });

    it('should_return_true_when_existNtf_is_normal_group_and_delete_fails', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let existNtf: NotificationBase = new NormalNotificationGroup();
      existNtf.notificationType = NotificationCategory.NOTIFICATION_TYPE_ALERT_GROUP;
      existNtf.children = new NotificationArray();
      existNtf.children?.push(new NormalNotification());
      let mocker: MockKit = new MockKit();

      let result = notificationdatavm.delMapData(existNtf);
      expect(result).assertEqual(true);
    });

  });
}