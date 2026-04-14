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
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { EventManager, EvtBus } from '@ohos/frameworkwrapper';
import { UnifiedGroupRemindEvent, UnifiedGroupUpdateEvent } from '../../../main/ets/common/event/NotificationEvent';
import { AggregateContent, NotificationEntry, UnifiedSceneType } from '../../../main/ets/model/NotificationEntry';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NotificationUnifiedRemindLimitManager } from '../../../main/ets/model/NotificationUnifiedRemindLimitManager';
export default function NotificationUnifiedRemindLimitManagerTest() {
  describe('onUnifiedGroupRemindEvent_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_handle_null_event', 0, () => {
      let notificationunifiedremindlimitmanager: NotificationUnifiedRemindLimitManager = new NotificationUnifiedRemindLimitManager();
      notificationunifiedremindlimitmanager.onUnifiedGroupRemindEvent(null);
      expect(notificationunifiedremindlimitmanager.dictMap).assertNull();
      expect(notificationunifiedremindlimitmanager.ntfAllListMap).assertNull();
      expect(notificationunifiedremindlimitmanager.ntfRemindMap).assertNull();
      expect(notificationunifiedremindlimitmanager.unifiedRemindMap).assertNull();
    });

    it('should_handle_empty_ntfRemindMap', 0, () => {
      let notificationunifiedremindlimitmanager: NotificationUnifiedRemindLimitManager = new NotificationUnifiedRemindLimitManager();
      let event: UnifiedGroupRemindEvent = new UnifiedGroupRemindEvent();
      event.unified = {
        dictMap: new Map(),
        ntfAllListMap: new Map()
      };
      notificationunifiedremindlimitmanager.onUnifiedGroupRemindEvent(event);
      expect(notificationunifiedremindlimitmanager.dictMap).assertDeepEquals(event.unified.dictMap);
      expect(notificationunifiedremindlimitmanager.ntfAllListMap).assertDeepEquals(event.unified.ntfAllListMap);
      expect(notificationunifiedremindlimitmanager.ntfRemindMap).assertDeepEquals(new Map());
      expect(notificationunifiedremindlimitmanager.unifiedRemindMap).assertDeepEquals(new Map());
    });

    it('should_handle_ntfRemindMap_with_deleted_ntfs', 0, () => {
      let notificationunifiedremindlimitmanager: NotificationUnifiedRemindLimitManager = new NotificationUnifiedRemindLimitManager();
      let event: UnifiedGroupRemindEvent = new UnifiedGroupRemindEvent();
      event.unified = {
        dictMap: new Map([
          [1, new AggregateContent()]
        ]),
        ntfAllListMap: new Map([
          [1, new Set([new NotificationEntry()]]
        ])
      };
      notificationunifiedremindlimitmanager.ntfRemindMap = new Map([
        [2, new Set([1])]
      ]);
      notificationunifiedremindlimitmanager.onUnifiedGroupRemindEvent(event);
      expect(notificationunifiedremindlimitmanager.dictMap).assertDeepEquals(event.unified.dictMap);
      expect(notificationunifiedremindlimitmanager.ntfAllListMap).assertDeepEquals(event.unified.ntfAllListMap);
      expect(notificationunifiedremindlimitmanager.ntfRemindMap).assertDeepEquals(new Map());
      expect(notificationunifiedremindlimitmanager.unifiedRemindMap).assertDeepEquals(new Map());
    });

    it('should_handle_ntfRemindMap_with_valid_ntfs', 0, () => {
      let notificationunifiedremindlimitmanager: NotificationUnifiedRemindLimitManager = new NotificationUnifiedRemindLimitManager();
      let event: UnifiedGroupRemindEvent = new UnifiedGroupRemindEvent();
      event.unified = {
        dictMap: new Map([
          [1, new AggregateContent()]
        ]),
        ntfAllListMap: new Map([
          [1, new Set([new NotificationEntry()])]
        ])
      };
      notificationunifiedremindlimitmanager.ntfRemindMap = new Map([
        [1, new Set([1])]
      ]);
      notificationunifiedremindlimitmanager.onUnifiedGroupRemindEvent(event);
      expect(notificationunifiedremindlimitmanager.dictMap).assertDeepEquals(event.unified.dictMap);
      expect(notificationunifiedremindlimitmanager.ntfAllListMap).assertDeepEquals(event.unified.ntfAllListMap);
      expect(notificationunifiedremindlimitmanager.ntfRemindMap).assertDeepEquals(new Map([
        [1, new Set([1])]
      ]));
      expect(notificationunifiedremindlimitmanager.unifiedRemindMap).assertDeepEquals(new Map([
        [1, new Set([1])]
      ]));
    });

    it('should_handle_ntfAllListMap_with_aggregate_groups', 0, () => {
      let notificationunifiedremindlimitmanager: NotificationUnifiedRemindLimitManager = new NotificationUnifiedRemindLimitManager();
      let event: UnifiedGroupRemindEvent = new UnifiedGroupRemindEvent();
      event.unified = {
        dictMap: new Map([
          [1, new AggregateContent()]
        ]),
        ntfAllListMap: new Map([
          [1, new Set([new NotificationEntry()])]
        ])
      };
      notificationunifiedremindlimitmanager.ntfAllListMap = new Map([
        [1, new Set([new NotificationEntry()])]
      ]);
      notificationunifiedremindlimitmanager.onUnifiedGroupRemindEvent(event);
      expect(notificationunifiedremindlimitmanager.dictMap).assertDeepEquals(event.unified.dictMap);
      expect(notificationunifiedremindlimitmanager.ntfAllListMap).assertDeepEquals(event.unified.ntfAllListMap);
      expect(notificationunifiedremindlimitmanager.ntfRemindMap).assertDeepEquals(new Map());
      expect(notificationunifiedremindlimitmanager.unifiedRemindMap).assertDeepEquals(new Map([
        [1, new Set([1])]
      ]));
    });

    it('should_handle_ntfAllListMap_with_non_aggregate_groups', 0, () => {
      let notificationunifiedremindlimitmanager: NotificationUnifiedRemindLimitManager = new NotificationUnifiedRemindLimitManager();
      let event: UnifiedGroupRemindEvent = new UnifiedGroupRemindEvent();
      event.unified = {
        dictMap: new Map([
          [1, new AggregateContent()]
        ]),
        ntfAllListMap: new Map([
          [1, new Set([new NotificationEntry()])]
        ])
      };
      notificationunifiedremindlimitmanager.ntfAllListMap = new Map([
        [1, new Set([new NotificationEntry()])]
      ]);
      notificationunifiedremindlimitmanager.onUnifiedGroupRemindEvent(event);
      expect(notificationunifiedremindlimitmanager.dictMap).assertDeepEquals(event.unified.dictMap);
      expect(notificationunifiedremindlimitmanager.ntfAllListMap).assertDeepEquals(event.unified.ntfAllListMap);
      expect(notificationunifiedremindlimitmanager.ntfRemindMap).assertDeepEquals(new Map());
      expect(notificationunifiedremindlimitmanager.unifiedRemindMap).assertDeepEquals(new Map([
        [1, new Set([1])]
      ]));
    });
    it('should_return_true_when_entry_aggregateContent_is_null', 0, () => {
      let notificationunifiedremindlimitmanager: NotificationUnifiedRemindLimitManager = new NotificationUnifiedRemindLimitManager();
      let entry: NotificationEntry = new NotificationEntry();
      entry.aggregateContent = null;
      entry.hashCode = 123;
      let result = notificationunifiedremindlimitmanager.checkMember(entry);
      expect(result).assertEqual(false);
    });
    it('should_return_true_when_entry_aggregateContent_memberList_is_null', 0, () => {
      let notificationunifiedremindlimitmanager: NotificationUnifiedRemindLimitManager = new NotificationUnifiedRemindLimitManager();
      let entry: NotificationEntry = new NotificationEntry();
      entry.aggregateContent = new AggregateContent();
      entry.aggregateContent.memberList = null;
      entry.hashCode = 123;
      let result = notificationunifiedremindlimitmanager.checkMember(entry);
      expect(result).assertEqual(false);
    });
    it('should_return_true_when_entry_aggregateContent_memberList_length_is_less_than_2', 0, () => {
      let notificationunifiedremindlimitmanager: NotificationUnifiedRemindLimitManager = new NotificationUnifiedRemindLimitManager();
      let entry: NotificationEntry = new NotificationEntry();
      entry.aggregateContent = new AggregateContent();
      entry.aggregateContent.memberList = [123];
      entry.hashCode = 123;
      let result = notificationunifiedremindlimitmanager.checkMember(entry);
      expect(result).assertEqual(false);
    });
    it('should_return_true_when_entry_aggregateContent_memberList_length_is_greater_than_2', 0, () => {
      let notificationunifiedremindlimitmanager: NotificationUnifiedRemindLimitManager = new NotificationUnifiedRemindLimitManager();
      let entry: NotificationEntry = new NotificationEntry();
      entry.aggregateContent = new AggregateContent();
      entry.aggregateContent.memberList = [123, 456];
      entry.hashCode = 123;
      let result = notificationunifiedremindlimitmanager.checkMember(entry);
      expect(result).assertEqual(true);
    });
    it('should_return_true_when_entry_aggregateContent_memberList_contains_hashCode', 0, () => {
      let notificationunifiedremindlimitmanager: NotificationUnifiedRemindLimitManager = new NotificationUnifiedRemindLimitManager();
      let entry: NotificationEntry = new NotificationEntry();
      entry.aggregateContent = new AggregateContent();
      entry.aggregateContent.memberList = [123, 456, 123];
      entry.hashCode = 123;
      let result = notificationunifiedremindlimitmanager.checkMember(entry);
      expect(result).assertEqual(true);
    });
    it('should_return_true_when_entry_aggregateContent_memberList_contains_dictMap_hashcode', 0, () => {
      let notificationunifiedremindlimitmanager: NotificationUnifiedRemindLimitManager = new NotificationUnifiedRemindLimitManager();
      let entry: NotificationEntry = new NotificationEntry();
      entry.aggregateContent = new AggregateContent();
      entry.aggregateContent.memberList = [123, 456];
      entry.hashCode = 123;
      notificationunifiedremindlimitmanager.dictMap.set(456, true);
      let result = notificationunifiedremindlimitmanager.checkMember(entry);
      expect(result).assertEqual(true);
    });
    it('should_return_false_when_entry_aggregateContent_memberList_does_not_contain_hashCode_or_dictMap_hashcode', 0, () => {
      let notificationunifiedremindlimitmanager: NotificationUnifiedRemindLimitManager = new NotificationUnifiedRemindLimitManager();
      let entry: NotificationEntry = new NotificationEntry();
      entry.aggregateContent = new AggregateContent();
      entry.aggregateContent.memberList = [123, 456];
      entry.hashCode = 123;
      let result = notificationunifiedremindlimitmanager.checkMember(entry);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_originGroup_is_null', 0, () => {
      let notificationunifiedremindlimitmanager: NotificationUnifiedRemindLimitManager = new NotificationUnifiedRemindLimitManager();
      let entry: NotificationEntry = new NotificationEntry();
      entry.hashCode = 1;
      entry.aggregateContent = new AggregateContent();
      entry.aggregateContent.key = 'key1';
      let type: RemindType = RemindType.REMIND_TYPE_1;
      let result = notificationunifiedremindlimitmanager.isOriginLimit(entry, type);
      expect(result).assertEqual(false);
    });
    it('should_return_false_when_originGroup_isInAggregate_is_false', 0, () => {
      let notificationunifiedremindlimitmanager: NotificationUnifiedRemindLimitManager = new NotificationUnifiedRemindLimitManager();
      let entry: NotificationEntry = new NotificationEntry();
      entry.hashCode = 1;
      entry.aggregateContent = new AggregateContent();
      entry.aggregateContent.key = 'key1';
      let type: RemindType = RemindType.REMIND_TYPE_1;
      let result = notificationunifiedremindlimitmanager.isOriginLimit(entry, type);
      expect(result).assertEqual(false);
    });
    it('should_return_false_when_originGroup_aggregateContent_key_is_not_equal_to_entry_aggregateContent_key', 0, () => {
      let notificationunifiedremindlimitmanager: NotificationUnifiedRemindLimitManager = new NotificationUnifiedRemindLimitManager();
      let entry: NotificationEntry = new NotificationEntry();
      entry.hashCode = 1;
      entry.aggregateContent = new AggregateContent();
      entry.aggregateContent.key = 'key1';
      let type: RemindType = RemindType.REMIND_TYPE_1;
      let result = notificationunifiedremindlimitmanager.isOriginLimit(entry, type);
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_originGroup_aggregateContent_key_is_equal_to_entry_aggregateContent_key_and_type_is_in_unifiedRemindMap', 0, () => {
      let notificationunifiedremindlimitmanager: NotificationUnifiedRemindLimitManager = new NotificationUnifiedRemindLimitManager();
      let entry: NotificationEntry = new NotificationEntry();
      entry.hashCode = 1;
      entry.aggregateContent = new AggregateContent();
      entry.aggregateContent.key = 'key1';
      let type: RemindType = RemindType.REMIND_TYPE_1;
      let result = notificationunifiedremindlimitmanager.isOriginLimit(entry, type);
      expect(result).assertEqual(true);
    });
    it('should_return_false_when_originGroup_aggregateContent_key_is_equal_to_entry_aggregateContent_key_but_type_is_not_in_unifiedRemindMap', 0, () => {
      let notificationunifiedremindlimitmanager: NotificationUnifiedRemindLimitManager = new NotificationUnifiedRemindLimitManager();
      let entry: NotificationEntry = new NotificationEntry();
      entry.hashCode = 1;
      entry.aggregateContent = new AggregateContent();
      entry.aggregateContent.key = 'key1';
      let type: RemindType = RemindType.REMIND_TYPE_1;
      let result = notificationunifiedremindlimitmanager.isOriginLimit(entry, type);
      expect(result).assertEqual(false);
    });
    it('should_return_false_when_entry_aggregateContent_is_null_and_type_is_delete', 0, () => {
      let notificationunifiedremindlimitmanager: NotificationUnifiedRemindLimitManager = new NotificationUnifiedRemindLimitManager();
      let entry: NotificationEntry = new NotificationEntry();
      let type: RemindType = new RemindType();
      type.type = "delete";
      let result = notificationunifiedremindlimitmanager.isAddRemindLimit(entry, type);
      expect(result).assertEqual(false);
    });
    it('should_return_false_when_entry_aggregateContent_is_not_null_and_type_is_delete_and_originLimits_has_type', 0, () => {
      let notificationunifiedremindlimitmanager: NotificationUnifiedRemindLimitManager = new NotificationUnifiedRemindLimitManager();
      let entry: NotificationEntry = new NotificationEntry();
      entry.aggregateContent = { memberList: [1], key: "testKey" };
      let type: RemindType = new RemindType();
      type.type = "delete";
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationunifiedremindlimitmanager, notificationunifiedremindlimitmanager.checkMember);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      let originLimits = new Set<string>();
      originLimits.add("delete");
      notificationunifiedremindlimitmanager.unifiedRemindMap.set("testKey", originLimits);
      let result = notificationunifiedremindlimitmanager.isAddRemindLimit(entry, type);
      expect(result).assertEqual(false);
      mocker.ignoreMock(notificationunifiedremindlimitmanager, notificationunifiedremindlimitmanager.checkMember);
    });
    it('should_return_true_when_entry_aggregateContent_is_not_null_and_type_is_delete_and_originLimits_does_not_has_type', 0, () => {
      let notificationunifiedremindlimitmanager: NotificationUnifiedRemindLimitManager = new NotificationUnifiedRemindLimitManager();
      let entry: NotificationEntry = new NotificationEntry();
      entry.aggregateContent = { memberList: [1], key: "testKey" };
      let type: RemindType = new RemindType();
      type.type = "delete";
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationunifiedremindlimitmanager, notificationunifiedremindlimitmanager.checkMember);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      let originLimits = new Set<string>();
      originLimits.add("otherType");
      notificationunifiedremindlimitmanager.unifiedRemindMap.set("testKey", originLimits);
      let result = notificationunifiedremindlimitmanager.isAddRemindLimit(entry, type);
      expect(result).assertEqual(true);
      mocker.ignoreMock(notificationunifiedremindlimitmanager, notificationunifiedremindlimitmanager.checkMember);
    });
    it('should_return_true_when_entry_aggregateContent_is_null_and_type_is_other', 0, () => {
      let notificationunifiedremindlimitmanager: NotificationUnifiedRemindLimitManager = new NotificationUnifiedRemindLimitManager();
      let entry: NotificationEntry = new NotificationEntry();
      let type: RemindType = new RemindType();
      type.type = "other";
      let result = notificationunifiedremindlimitmanager.isAddRemindLimit(entry, type);
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_entry_aggregateContent_is_not_null_and_type_is_other_and_originLimits_has_type', 0, () => {
      let notificationunifiedremindlimitmanager: NotificationUnifiedRemindLimitManager = new NotificationUnifiedRemindLimitManager();
      let entry: NotificationEntry = new NotificationEntry();
      entry.aggregateContent = { memberList: [1], key: "testKey" };
      let type: RemindType = new RemindType();
      type.type = "other";
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationunifiedremindlimitmanager, notificationunifiedremindlimitmanager.checkMember);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      let originLimits = new Set<string>();
      originLimits.add("other");
      notificationunifiedremindlimitmanager.unifiedRemindMap.set("testKey", originLimits);
      let result = notificationunifiedremindlimitmanager.isAddRemindLimit(entry, type);
      expect(result).assertEqual(true);
      mocker.ignoreMock(notificationunifiedremindlimitmanager, notificationunifiedremindlimitmanager.checkMember);
    });
    it('should_return_false_when_entry_aggregateContent_is_not_null_and_type_is_other_and_originLimits_does_not_has_type', 0, () => {
      let notificationunifiedremindlimitmanager: NotificationUnifiedRemindLimitManager = new NotificationUnifiedRemindLimitManager();
      let entry: NotificationEntry = new NotificationEntry();
      entry.aggregateContent = { memberList: [1], key: "testKey" };
      let type: RemindType = new RemindType();
      type.type = "other";
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationunifiedremindlimitmanager, notificationunifiedremindlimitmanager.checkMember);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      let originLimits = new Set<string>();
      originLimits.add("delete");
      notificationunifiedremindlimitmanager.unifiedRemindMap.set("testKey", originLimits);
      let result = notificationunifiedremindlimitmanager.isAddRemindLimit(entry, type);
      expect(result).assertEqual(false);
      mocker.ignoreMock(notificationunifiedremindlimitmanager, notificationunifiedremindlimitmanager.checkMember);
    });
    it('should_return_true_when_entry_aggregateContent_is_not_null_and_type_is_delete_and_originLimits_is_null', 0, () => {
      let notificationunifiedremindlimitmanager: NotificationUnifiedRemindLimitManager = new NotificationUnifiedRemindLimitManager();
      let entry: NotificationEntry = new NotificationEntry();
      entry.aggregateContent = { memberList: [1], key: "testKey" };
      let type: RemindType = new RemindType();
      type.type = "delete";
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationunifiedremindlimitmanager, notificationunifiedremindlimitmanager.checkMember);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      notificationunifiedremindlimitmanager.unifiedRemindMap.set("testKey", null);
      let result = notificationunifiedremindlimitmanager.isAddRemindLimit(entry, type);
      expect(result).assertEqual(true);
      mocker.ignoreMock(notificationunifiedremindlimitmanager, notificationunifiedremindlimitmanager.checkMember);
    });
    it('should_return_false_when_entry_aggregateContent_is_not_null_and_type_is_other_and_originLimits_is_null', 0, () => {
      let notificationunifiedremindlimitmanager: NotificationUnifiedRemindLimitManager = new NotificationUnifiedRemindLimitManager();
      let entry: NotificationEntry = new NotificationEntry();
      entry.aggregateContent = { memberList: [1], key: "testKey" };
      let type: RemindType = new RemindType();
      type.type = "other";
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationunifiedremindlimitmanager, notificationunifiedremindlimitmanager.checkMember);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      notificationunifiedremindlimitmanager.unifiedRemindMap.set("testKey", null);
      let result = notificationunifiedremindlimitmanager.isAddRemindLimit(entry, type);
      expect(result).assertEqual(false);
      mocker.ignoreMock(notificationunifiedremindlimitmanager, notificationunifiedremindlimitmanager.checkMember);
    });
    it('should_log_info_when_title_or_content_is_different', 0, () => {
      let notificationunifiedremindlimitmanager: NotificationUnifiedRemindLimitManager = new NotificationUnifiedRemindLimitManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let originContent: AggregateContent = new AggregateContent();
      originContent.title = 'title';
      originContent.content = 'content';
      originContent.key = 'key';

      let newContent: AggregateContent = new AggregateContent();
      newContent.title = 'title2';
      newContent.content = 'content2';
      newContent.key = 'key';

      notificationunifiedremindlimitmanager.refreshLimit(originContent, newContent);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
    it('should_clear_remind_when_title_or_content_is_different', 0, () => {
      let notificationunifiedremindlimitmanager: NotificationUnifiedRemindLimitManager = new NotificationUnifiedRemindLimitManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let originContent: AggregateContent = new AggregateContent();
      originContent.title = 'title';
      originContent.content = 'content';
      originContent.key = 'key';

      let newContent: AggregateContent = new AggregateContent();
      newContent.title = 'title2';
      newContent.content = 'content2';
      newContent.key = 'key';

      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.hashCode = 'hashCode';
      notificationEntry.unifiedSceneType = UnifiedSceneType.FLIGHT_Unified_Scene;
      notificationunifiedremindlimitmanager.ntfAllListMap.set('key', [notificationEntry]);
      notificationunifiedremindlimitmanager.refreshLimit(originContent, newContent);

      expect(notificationunifiedremindlimitmanager.ntfRemindMap.get('hashCode')).assertInstanceOf(Set);
      expect(notificationunifiedremindlimitmanager.unifiedRemindMap.get('key')).assertInstanceOf(Map);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
    it('should_not_clear_remind_when_title_and_content_are_same', 0, () => {
      let notificationunifiedremindlimitmanager: NotificationUnifiedRemindLimitManager = new NotificationUnifiedRemindLimitManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let originContent: AggregateContent = new AggregateContent();
      originContent.title = 'title';
      originContent.content = 'content';
      originContent.key = 'key';

      let newContent: AggregateContent = new AggregateContent();
      newContent.title = 'title';
      newContent.content = 'content';
      newContent.key = 'key';

      notificationunifiedremindlimitmanager.refreshLimit(originContent, newContent);

      expect(notificationunifiedremindlimitmanager.ntfRemindMap.get('hashCode')).assertInstanceOf(Set);
      expect(notificationunifiedremindlimitmanager.unifiedRemindMap.get('key')).assertInstanceOf(Map);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
    it('should_not_clear_remind_when_title_and_content_are_same_1', 0, () => {
      let notificationunifiedremindlimitmanager: NotificationUnifiedRemindLimitManager = new NotificationUnifiedRemindLimitManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let originContent: AggregateContent = new AggregateContent();
      originContent.title = 'title';
      originContent.content = 'content';
      originContent.key = 'key';

      let newContent: AggregateContent = new AggregateContent();
      newContent.title = 'title';
      newContent.content = 'content';
      newContent.key = 'key';

      notificationunifiedremindlimitmanager.refreshLimit(originContent, newContent);

      expect(notificationunifiedremindlimitmanager.ntfRemindMap.get('hashCode')).assertInstanceOf(Set);
      expect(notificationunifiedremindlimitmanager.unifiedRemindMap.get('key')).assertInstanceOf(Map);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
  });