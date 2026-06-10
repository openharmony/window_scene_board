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
import { describe, it, expect } from '@ohos/hypium';
import { NotificationConstants } from '../../../../main/ets/common/NotificationConstants';
import { LiveUseScene } from '@ohos/systemuicommon/src/main/ets/liveview/common/LiveConstants';
import { NotificationEntry } from '../../../../main/ets/model/NotificationEntry';

export default function NotificationConstantsTest() {
  describe('NotificationConstantsTest', (): void => {

    it('getNTFSingleItemCompId_01', 0, () => {
      let ret = NotificationConstants.getNTFSingleItemCompId(LiveUseScene.SCENE_SCREEN_LOCK_NOTIFICATION, '111');
      expect(ret).assertEqual('NTF_single_item_notification_center_111');
    })

    it('onItemClick_unlock_02', 0, () => {
      let ret = NotificationConstants.getNTFSingleItemCompId(LiveUseScene.SCENE_NTF_CENTER, '111');
      expect(ret).assertEqual('NTF_single_item_notification_center_111');
    })

    it('getGroupNTFItemCompId', 0, () => {
      let ret = NotificationConstants.getGroupNTFItemCompId('group');
      expect(ret).assertEqual('NotificationGroupDetail_group_111');
    })

    it('isGroupNTF_01', 0, () => {
      let ret = NotificationConstants.isGroupNTF(geNtfEntry());
      expect(ret).assertFalse();
    })

    it('isGroupNTF_02', 0, () => {
      let ret = NotificationConstants.isGroupNTF(getGroupNtfEntry());
      expect(ret).assertTrue();
    })
  })
}

function geNtfEntry(): NotificationEntry {
  let groupNotificationEntry: NotificationEntry = new NotificationEntry();
  groupNotificationEntry.isGroup = true;
  let notificationEntry: NotificationEntry = new NotificationEntry();
  notificationEntry.isGroup = true;
  notificationEntry.groupEntry = groupNotificationEntry;
  let childrenNtf = [notificationEntry];
  groupNotificationEntry.childrenEntry = childrenNtf;
  return notificationEntry;
}

function getGroupNtfEntry(): NotificationEntry {
  let groupNotificationEntry: NotificationEntry = new NotificationEntry();
  groupNotificationEntry.isGroup = true;
  let notificationEntry: NotificationEntry = new NotificationEntry();
  notificationEntry.isGroup = true;
  notificationEntry.groupEntry = groupNotificationEntry;
  let notificationEntryOne: NotificationEntry = new NotificationEntry();
  notificationEntryOne.isGroup = true;
  notificationEntryOne.groupEntry = groupNotificationEntry;
  let childrenNtf = [notificationEntry, notificationEntryOne];
  groupNotificationEntry.childrenEntry = childrenNtf;
  return notificationEntry;
}