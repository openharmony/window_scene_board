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
import { describe, beforeAll, it, expect } from '@ohos/hypium';
import { NotificationEntry } from '../../../../main/ets/model/NotificationEntry';
import { NtfSingleItemVM, SingleItemCallback } from '../../../../main/ets/vm/NtfSingleItemVM';
import { wantAgent } from '@kit.AbilityKit';
import { NotificationType } from '@ohos/systemuicommon/Index';

export default function NtfSingleItemVMTest() {
  let ntfSingleItemVM: NtfSingleItemVM | undefined;
  describe('NtfSingleItemVMTest', (): void => {
    beforeAll((): void => {
      ntfSingleItemVM = new NtfSingleItemVM();
      ntfSingleItemVM.init(new ItemCallback());
    })

    it('onItemClick_lock', 0, () => {
      try {
        let helper = () => {
          ntfSingleItemVM?.onItemClick(false, 1, false);
          throw new Error('onItemClick_lock');
        }
        expect(helper()).assertThrowError('onItemClick_lock');
      } catch (e) {
      }
    })

    it('onItemClick_unlock', 0, () => {
      try {
        let helper = () => {
          ntfSingleItemVM?.onItemClick(false, 1, true);
          throw new Error('onItemClick_unlock');
        }
        expect(helper()).assertThrowError('onItemClick_unlock');
      } catch (e) {
      }
    })
  })
}

class ItemCallback implements SingleItemCallback {
  getNtfEntry(): NotificationEntry | null {
    return getNtfEntry();
  }

  getNtfType(): number {
    return NotificationType.TYPE_PHONE_KEYGUARD
  }

  getIsInGroup?(): boolean {
    return true;
  }
}

function getNtfEntry(): NotificationEntry {
  let groupNotificationEntry: NotificationEntry = new NotificationEntry();
  groupNotificationEntry.isGroup = true;
  groupNotificationEntry.hashCode = '111';
  let notificationEntry: NotificationEntry = new NotificationEntry();
  notificationEntry.isGroup = true;
  notificationEntry.groupEntry = groupNotificationEntry;
  let wantAgentInfo: wantAgent.WantAgentInfo = {
    wants: [
      {
        bundleName: 'com.example.test',
        abilityName: 'EntryAbility',
      }
    ],
    actionType: wantAgent.OperationType.START_ABILITY,
    requestCode: 0,
    wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
  }
  notificationEntry.wantAgent = wantAgentInfo
  notificationEntry.hashCode = '222';
  notificationEntry.wantAgentInfo = {
    operationType: 1,
    bundleName: 'com.example.test'
  }
  let childrenNtf = [notificationEntry];
  groupNotificationEntry.childrenEntry = childrenNtf;
  return notificationEntry;
}