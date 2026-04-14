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
import { NormalNotification } from '../../../main/ets/model/NormalNotification';
import { NotificationBase } from '../../../main/ets/model/NotificationBase';
import { NotificationRole } from '../../../main/ets/model/NotificationContent';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NormalNotificationGroup } from '../../../main/ets/model/NormalNotificationGroup';
export default function NormalNotificationGroupTest() {
  describe('isEmpty_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_true_when_children_length_is_zero', 0, () => {
      let normalnotification: NormalNotification = new NormalNotification(1, NotificationRole.CONTENT_INFO, "title", "text", "bundleName", 1, 1, 1, 1, 1, 1, 1, 1, 1, true, true, true, true, "category", 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(normalnotification);
      normalnotificationgroup.children = [];
      const result = normalnotificationgroup.isEmpty();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_children_length_is_not_zero', 0, () => {
      let normalnotification: NormalNotification = new NormalNotification(1, NotificationRole.CONTENT_INFO, "title", "text", "bundleName", 1, 1, 1, 1, 1, 1, 1, 1, 1, true, true, true, true, "category", 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(normalnotification);
      normalnotificationgroup.children = [normalnotification];
      const result = normalnotificationgroup.isEmpty();
      expect(result).assertEqual(false);
    });

    it('should_return_undefined_when_no_child_matches_hashCode', 0, () => {
      let ntf1: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1,
        NotificationRole.CONSUMER, 'creatorBundleName', 1, 1, true, true, true, true, 'category', 1);
      let ntf2: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1,
        NotificationRole.CONSUMER, 'creatorBundleName', 1, 1, true, true, true, true, 'category', 2);
      let otherOtherList: NormalNotification[] = [ntf2];
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf1, ...otherOtherList);
      let result = normalnotificationgroup.getChild('3');
      expect(result).assertUndefined();
    });

    it('should_return_child_when_one_child_matches_hashCode', 0, () => {
      let ntf1: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1,
        NotificationRole.CONSUMER, 'creatorBundleName', 1, 1, true, true, true, true, 'category', 1);
      let ntf2: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1,
        NotificationRole.CONSUMER, 'creatorBundleName', 1, 1, true, true, true, true, 'category', 2);
      let otherOtherList: NormalNotification[] = [ntf2];
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf1, ...otherOtherList);
      let result = normalnotificationgroup.getChild('1');
      expect(result).assertDeepEquals(ntf1);
    });

    it('should_return_undefined_when_children_length_is_zero', 0, () => {
      let ntf: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let otherNtf: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf, otherNtf);
      normalnotificationgroup.removeChild('1');
      expect(normalnotificationgroup.removeChild('1')).assertUndefined();
    });

    it('should_return_new_group_when_removeChild_is_successful', 0, () => {
      let ntf: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let otherNtf: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf, otherNtf);
      normalnotificationgroup.removeChild('2');
      expect(normalnotificationgroup.removeChild('1')).assertInstanceOf(NormalNotificationGroup);
    });

    it('should_return_undefined_when_all_children_are_removed', 0, () => {
      let ntf: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let otherNtf: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf, otherNtf);
      normalnotificationgroup.removeChild('1');
      normalnotificationgroup.removeChild('2');
      expect(normalnotificationgroup.removeChild('1')).assertUndefined();
    });

    it('should_return_true_when_children_length_is_zero', 0, () => {
      let normalnotification: NormalNotification = new NormalNotification(1, NotificationRole.CONTENT_INFO, "title", "text", "bundleName", 1, 1, 1, 1, 1, 1, 1, 1, 1, true, true, true, true, "category", 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(normalnotification);
      normalnotificationgroup.children = [];
      const result = normalnotificationgroup.isEmpty();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_children_length_is_not_zero', 0, () => {
      let normalnotification: NormalNotification = new NormalNotification(1, NotificationRole.CONTENT_INFO, "title", "text", "bundleName", 1, 1, 1, 1, 1, 1, 1, 1, 1, true, true, true, true, "category", 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(normalnotification);
      normalnotificationgroup.children = [normalnotification];
      const result = normalnotificationgroup.isEmpty();
      expect(result).assertEqual(false);
    });

    it('should_return_undefined_when_no_child_matches_hashCode', 0, () => {
      let ntf1: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1,
        NotificationRole.CONSUMER, 'creatorBundleName', 1, 1, true, true, true, true, 'category', 1);
      let ntf2: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1,
        NotificationRole.CONSUMER, 'creatorBundleName', 1, 1, true, true, true, true, 'category', 2);
      let otherOtherList: NormalNotification[] = [ntf2];
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf1, ...otherOtherList);
      let result = normalnotificationgroup.getChild('3');
      expect(result).assertUndefined();
    });

    it('should_return_child_when_one_child_matches_hashCode', 0, () => {
      let ntf1: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1,
        NotificationRole.CONSUMER, 'creatorBundleName', 1, 1, true, true, true, true, 'category', 1);
      let ntf2: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1,
        NotificationRole.CONSUMER, 'creatorBundleName', 1, 1, true, true, true, true, 'category', 2);
      let otherOtherList: NormalNotification[] = [ntf2];
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf1, ...otherOtherList);
      let result = normalnotificationgroup.getChild('1');
      expect(result).assertDeepEquals(ntf1);
    });

    it('should_return_undefined_when_children_length_is_zero', 0, () => {
      let ntf: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let otherNtf: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf, otherNtf);
      normalnotificationgroup.removeChild('1');
      expect(normalnotificationgroup.removeChild('1')).assertUndefined();
    });

    it('should_return_new_group_when_removeChild_is_successful', 0, () => {
      let ntf: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let otherNtf: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf, otherNtf);
      normalnotificationgroup.removeChild('2');
      expect(normalnotificationgroup.removeChild('1')).assertInstanceOf(NormalNotificationGroup);
    });

    it('should_return_undefined_when_all_children_are_removed', 0, () => {
      let ntf: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let otherNtf: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf, otherNtf);
      normalnotificationgroup.removeChild('1');
      normalnotificationgroup.removeChild('2');
      expect(normalnotificationgroup.removeChild('1')).assertUndefined();
    });

    it('should_return_true_when_children_length_is_zero', 0, () => {
      let normalnotification: NormalNotification = new NormalNotification(1, NotificationRole.CONTENT_INFO, "title", "text", "bundleName", 1, 1, 1, 1, 1, 1, 1, 1, 1, true, true, true, true, "category", 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(normalnotification);
      normalnotificationgroup.children = [];
      const result = normalnotificationgroup.isEmpty();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_children_length_is_not_zero', 0, () => {
      let normalnotification: NormalNotification = new NormalNotification(1, NotificationRole.CONTENT_INFO, "title", "text", "bundleName", 1, 1, 1, 1, 1, 1, 1, 1, 1, true, true, true, true, "category", 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(normalnotification);
      normalnotificationgroup.children = [normalnotification];
      const result = normalnotificationgroup.isEmpty();
      expect(result).assertEqual(false);
    });

    it('should_return_undefined_when_no_child_matches_hashCode', 0, () => {
      let ntf1: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1,
        NotificationRole.CONSUMER, 'creatorBundleName', 1, 1, true, true, true, true, 'category', 1);
      let ntf2: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1,
        NotificationRole.CONSUMER, 'creatorBundleName', 1, 1, true, true, true, true, 'category', 2);
      let otherOtherList: NormalNotification[] = [ntf2];
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf1, ...otherOtherList);
      let result = normalnotificationgroup.getChild('3');
      expect(result).assertUndefined();
    });

    it('should_return_child_when_one_child_matches_hashCode', 0, () => {
      let ntf1: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1,
        NotificationRole.CONSUMER, 'creatorBundleName', 1, 1, true, true, true, true, 'category', 1);
      let ntf2: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1,
        NotificationRole.CONSUMER, 'creatorBundleName', 1, 1, true, true, true, true, 'category', 2);
      let otherOtherList: NormalNotification[] = [ntf2];
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf1, ...otherOtherList);
      let result = normalnotificationgroup.getChild('1');
      expect(result).assertDeepEquals(ntf1);
    });

    it('should_return_undefined_when_children_length_is_zero', 0, () => {
      let ntf: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let otherNtf: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf, otherNtf);
      normalnotificationgroup.removeChild('1');
      expect(normalnotificationgroup.removeChild('1')).assertUndefined();
    });

    it('should_return_new_group_when_removeChild_is_successful', 0, () => {
      let ntf: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let otherNtf: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf, otherNtf);
      normalnotificationgroup.removeChild('2');
      expect(normalnotificationgroup.removeChild('1')).assertInstanceOf(NormalNotificationGroup);
    });

    it('should_return_undefined_when_all_children_are_removed', 0, () => {
      let ntf: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let otherNtf: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf, otherNtf);
      normalnotificationgroup.removeChild('1');
      normalnotificationgroup.removeChild('2');
      expect(normalnotificationgroup.removeChild('1')).assertUndefined();
    });

    it('should_return_true_when_children_length_is_zero', 0, () => {
      let normalnotification: NormalNotification = new NormalNotification(1, NotificationRole.CONTENT_INFO, "title", "text", "bundleName", 1, 1, 1, 1, 1, 1, 1, 1, 1, true, true, true, true, "category", 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(normalnotification);
      normalnotificationgroup.children = [];
      const result = normalnotificationgroup.isEmpty();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_children_length_is_not_zero', 0, () => {
      let normalnotification: NormalNotification = new NormalNotification(1, NotificationRole.CONTENT_INFO, "title", "text", "bundleName", 1, 1, 1, 1, 1, 1, 1, 1, 1, true, true, true, true, "category", 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(normalnotification);
      normalnotificationgroup.children = [normalnotification];
      const result = normalnotificationgroup.isEmpty();
      expect(result).assertEqual(false);
    });

    it('should_return_undefined_when_no_child_matches_hashCode', 0, () => {
      let ntf1: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1,
        NotificationRole.CONSUMER, 'creatorBundleName', 1, 1, true, true, true, true, 'category', 1);
      let ntf2: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1,
        NotificationRole.CONSUMER, 'creatorBundleName', 1, 1, true, true, true, true, 'category', 2);
      let otherOtherList: NormalNotification[] = [ntf2];
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf1, ...otherOtherList);
      let result = normalnotificationgroup.getChild('3');
      expect(result).assertUndefined();
    });

    it('should_return_child_when_one_child_matches_hashCode', 0, () => {
      let ntf1: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1,
        NotificationRole.CONSUMER, 'creatorBundleName', 1, 1, true, true, true, true, 'category', 1);
      let ntf2: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1,
        NotificationRole.CONSUMER, 'creatorBundleName', 1, 1, true, true, true, true, 'category', 2);
      let otherOtherList: NormalNotification[] = [ntf2];
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf1, ...otherOtherList);
      let result = normalnotificationgroup.getChild('1');
      expect(result).assertDeepEquals(ntf1);
    });

    it('should_return_undefined_when_children_length_is_zero', 0, () => {
      let ntf: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let otherNtf: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf, otherNtf);
      normalnotificationgroup.removeChild('1');
      expect(normalnotificationgroup.removeChild('1')).assertUndefined();
    });

    it('should_return_new_group_when_removeChild_is_successful', 0, () => {
      let ntf: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let otherNtf: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf, otherNtf);
      normalnotificationgroup.removeChild('2');
      expect(normalnotificationgroup.removeChild('1')).assertInstanceOf(NormalNotificationGroup);
    });

    it('should_return_undefined_when_all_children_are_removed', 0, () => {
      let ntf: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let otherNtf: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf, otherNtf);
      normalnotificationgroup.removeChild('1');
      normalnotificationgroup.removeChild('2');
      expect(normalnotificationgroup.removeChild('1')).assertUndefined();
    });

    it('should_return_true_when_children_length_is_zero', 0, () => {
      let normalnotification: NormalNotification = new NormalNotification(1, NotificationRole.CONTENT_INFO, "title", "text", "bundleName", 1, 1, 1, 1, 1, 1, 1, 1, 1, true, true, true, true, "category", 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(normalnotification);
      normalnotificationgroup.children = [];
      const result = normalnotificationgroup.isEmpty();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_children_length_is_not_zero', 0, () => {
      let normalnotification: NormalNotification = new NormalNotification(1, NotificationRole.CONTENT_INFO, "title", "text", "bundleName", 1, 1, 1, 1, 1, 1, 1, 1, 1, true, true, true, true, "category", 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(normalnotification);
      normalnotificationgroup.children = [normalnotification];
      const result = normalnotificationgroup.isEmpty();
      expect(result).assertEqual(false);
    });

    it('should_return_undefined_when_no_child_matches_hashCode', 0, () => {
      let ntf1: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1,
        NotificationRole.CONSUMER, 'creatorBundleName', 1, 1, true, true, true, true, 'category', 1);
      let ntf2: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1,
        NotificationRole.CONSUMER, 'creatorBundleName', 1, 1, true, true, true, true, 'category', 2);
      let otherOtherList: NormalNotification[] = [ntf2];
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf1, ...otherOtherList);
      let result = normalnotificationgroup.getChild('3');
      expect(result).assertUndefined();
    });

    it('should_return_child_when_one_child_matches_hashCode', 0, () => {
      let ntf1: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1,
        NotificationRole.CONSUMER, 'creatorBundleName', 1, 1, true, true, true, true, 'category', 1);
      let ntf2: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1,
        NotificationRole.CONSUMER, 'creatorBundleName', 1, 1, true, true, true, true, 'category', 2);
      let otherOtherList: NormalNotification[] = [ntf2];
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf1, ...otherOtherList);
      let result = normalnotificationgroup.getChild('1');
      expect(result).assertDeepEquals(ntf1);
    });

    it('should_return_undefined_when_children_length_is_zero', 0, () => {
      let ntf: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let otherNtf: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf, otherNtf);
      normalnotificationgroup.removeChild('1');
      expect(normalnotificationgroup.removeChild('1')).assertUndefined();
    });

    it('should_return_new_group_when_removeChild_is_successful', 0, () => {
      let ntf: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let otherNtf: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf, otherNtf);
      normalnotificationgroup.removeChild('2');
      expect(normalnotificationgroup.removeChild('1')).assertInstanceOf(NormalNotificationGroup);
    });

    it('should_return_undefined_when_all_children_are_removed', 0, () => {
      let ntf: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let otherNtf: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf, otherNtf);
      normalnotificationgroup.removeChild('1');
      normalnotificationgroup.removeChild('2');
      expect(normalnotificationgroup.removeChild('1')).assertUndefined();
    });

    it('should_return_true_when_children_length_is_zero', 0, () => {
      let normalnotification: NormalNotification = new NormalNotification(1, NotificationRole.CONTENT_INFO, "title", "text", "bundleName", 1, 1, 1, 1, 1, 1, 1, 1, 1, true, true, true, true, "category", 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(normalnotification);
      normalnotificationgroup.children = [];
      const result = normalnotificationgroup.isEmpty();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_children_length_is_not_zero', 0, () => {
      let normalnotification: NormalNotification = new NormalNotification(1, NotificationRole.CONTENT_INFO, "title", "text", "bundleName", 1, 1, 1, 1, 1, 1, 1, 1, 1, true, true, true, true, "category", 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(normalnotification);
      normalnotificationgroup.children = [normalnotification];
      const result = normalnotificationgroup.isEmpty();
      expect(result).assertEqual(false);
    });

    it('should_return_undefined_when_no_child_matches_hashCode', 0, () => {
      let ntf1: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1,
        NotificationRole.CONSUMER, 'creatorBundleName', 1, 1, true, true, true, true, 'category', 1);
      let ntf2: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1,
        NotificationRole.CONSUMER, 'creatorBundleName', 1, 1, true, true, true, true, 'category', 2);
      let otherOtherList: NormalNotification[] = [ntf2];
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf1, ...otherOtherList);
      let result = normalnotificationgroup.getChild('3');
      expect(result).assertUndefined();
    });

    it('should_return_child_when_one_child_matches_hashCode', 0, () => {
      let ntf1: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1,
        NotificationRole.CONSUMER, 'creatorBundleName', 1, 1, true, true, true, true, 'category', 1);
      let ntf2: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1,
        NotificationRole.CONSUMER, 'creatorBundleName', 1, 1, true, true, true, true, 'category', 2);
      let otherOtherList: NormalNotification[] = [ntf2];
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf1, ...otherOtherList);
      let result = normalnotificationgroup.getChild('1');
      expect(result).assertDeepEquals(ntf1);
    });

    it('should_return_undefined_when_children_length_is_zero', 0, () => {
      let ntf: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let otherNtf: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf, otherNtf);
      normalnotificationgroup.removeChild('1');
      expect(normalnotificationgroup.removeChild('1')).assertUndefined();
    });

    it('should_return_new_group_when_removeChild_is_successful', 0, () => {
      let ntf: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let otherNtf: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf, otherNtf);
      normalnotificationgroup.removeChild('2');
      expect(normalnotificationgroup.removeChild('1')).assertInstanceOf(NormalNotificationGroup);
    });

    it('should_return_undefined_when_all_children_are_removed', 0, () => {
      let ntf: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let otherNtf: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf, otherNtf);
      normalnotificationgroup.removeChild('1');
      normalnotificationgroup.removeChild('2');
      expect(normalnotificationgroup.removeChild('1')).assertUndefined();
    });

    it('should_return_true_when_children_length_is_zero', 0, () => {
      let normalnotification: NormalNotification = new NormalNotification(1, NotificationRole.CONTENT_INFO, "title", "text", "bundleName", 1, 1, 1, 1, 1, 1, 1, 1, 1, true, true, true, true, "category", 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(normalnotification);
      normalnotificationgroup.children = [];
      const result = normalnotificationgroup.isEmpty();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_children_length_is_not_zero', 0, () => {
      let normalnotification: NormalNotification = new NormalNotification(1, NotificationRole.CONTENT_INFO, "title", "text", "bundleName", 1, 1, 1, 1, 1, 1, 1, 1, 1, true, true, true, true, "category", 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(normalnotification);
      normalnotificationgroup.children = [normalnotification];
      const result = normalnotificationgroup.isEmpty();
      expect(result).assertEqual(false);
    });

    it('should_return_undefined_when_no_child_matches_hashCode', 0, () => {
      let ntf1: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1,
        NotificationRole.CONSUMER, 'creatorBundleName', 1, 1, true, true, true, true, 'category', 1);
      let ntf2: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1,
        NotificationRole.CONSUMER, 'creatorBundleName', 1, 1, true, true, true, true, 'category', 2);
      let otherOtherList: NormalNotification[] = [ntf2];
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf1, ...otherOtherList);
      let result = normalnotificationgroup.getChild('3');
      expect(result).assertUndefined();
    });

    it('should_return_child_when_one_child_matches_hashCode', 0, () => {
      let ntf1: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1,
        NotificationRole.CONSUMER, 'creatorBundleName', 1, 1, true, true, true, true, 'category', 1);
      let ntf2: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1,
        NotificationRole.CONSUMER, 'creatorBundleName', 1, 1, true, true, true, true, 'category', 2);
      let otherOtherList: NormalNotification[] = [ntf2];
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf1, ...otherOtherList);
      let result = normalnotificationgroup.getChild('1');
      expect(result).assertDeepEquals(ntf1);
    });

    it('should_return_undefined_when_children_length_is_zero', 0, () => {
      let ntf: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let otherNtf: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf, otherNtf);
      normalnotificationgroup.removeChild('1');
      expect(normalnotificationgroup.removeChild('1')).assertUndefined();
    });

    it('should_return_new_group_when_removeChild_is_successful', 0, () => {
      let ntf: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let otherNtf: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf, otherNtf);
      normalnotificationgroup.removeChild('2');
      expect(normalnotificationgroup.removeChild('1')).assertInstanceOf(NormalNotificationGroup);
    });

    it('should_return_undefined_when_all_children_are_removed', 0, () => {
      let ntf: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let otherNtf: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1, true, true, true, true, true, true, true, true, 'category', 1, NotificationRole.SOCIAL_COMMUNICATION, 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf, otherNtf);
      normalnotificationgroup.removeChild('1');
      normalnotificationgroup.removeChild('2');
      expect(normalnotificationgroup.removeChild('1')).assertUndefined();
    });

    it('should_return_true_when_children_length_is_zero', 0, () => {
      let normalnotification: NormalNotification = new NormalNotification(1, NotificationRole.CONTENT_INFO, "title", "text", "bundleName", 1, 1, 1, 1, 1, 1, 1, 1, 1, true, true, true, true, "category", 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(normalnotification);
      normalnotificationgroup.children = [];
      const result = normalnotificationgroup.isEmpty();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_children_length_is_not_zero', 0, () => {
      let normalnotification: NormalNotification = new NormalNotification(1, NotificationRole.CONTENT_INFO, "title", "text", "bundleName", 1, 1, 1, 1, 1, 1, 1, 1, 1, true, true, true, true, "category", 1);
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(normalnotification);
      normalnotificationgroup.children = [normalnotification];
      const result = normalnotificationgroup.isEmpty();
      expect(result).assertEqual(false);
    });

    it('should_return_undefined_when_no_child_matches_hashCode', 0, () => {
      let ntf1: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1,
        NotificationRole.CONSUMER, 'creatorBundleName', 1, 1, true, true, true, true, 'category', 1);
      let ntf2: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1,
        NotificationRole.CONSUMER, 'creatorBundleName', 1, 1, true, true, true, true, 'category', 2);
      let otherOtherList: NormalNotification[] = [ntf2];
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf1, ...otherOtherList);
      let result = normalnotificationgroup.getChild('3');
      expect(result).assertUndefined();
    });

    it('should_return_child_when_one_child_matches_hashCode', 0, () => {
      let ntf1: NormalNotification = new NormalNotification('1', 'appLabel', 'appIcon', 1, 1,
        NotificationRole.CONSUMER, 'creatorBundleName', 1, 1, true, true, true, true, 'category', 1);
      let ntf2: NormalNotification = new NormalNotification('2', 'appLabel', 'appIcon', 1, 1,
        NotificationRole.CONSUMER, 'creatorBundleName', 1, 1, true, true, true, true, 'category', 2);
      let otherOtherList: NormalNotification[] = [ntf2];
      let normalnotificationgroup: NormalNotificationGroup = new NormalNotificationGroup(ntf1, ...otherOtherList);
      let result = normalnotificationgroup.getChild('1');
      expect(result).assertDeepEquals(ntf1);
    });

  });
