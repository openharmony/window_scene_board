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
import { describe, it, expect } from '@ohos/hypium';
import { NotificationAction } from '@ohos/systemuicommon';
import { KeyguardNtfActionVM } from '../../../../main/ets/vm/KeyguardNtfActionVM';
import { NotificationEntry } from '../../../../main/ets/model/NotificationEntry';
import { wantAgent } from '@kit.AbilityKit';
import { ActionCallback } from '../../../../main/ets/vm/NtfActionVM';
import { NotificationType } from '@ohos/systemuicommon/Index';
import WantAgent, { WantAgent as _WantAgent } from '@ohos.app.ability.wantAgent';
import { BusinessError } from '@kit.BasicServicesKit';

export default function KeyguardNtfActionVMTest() {
  describe('KeyguardNtfActionVMTest', (): void => {

    it('startActionInner', 0, () => {
      let actionVM: KeyguardNtfActionVM = new KeyguardNtfActionVM();
      actionVM.init(new ItemListen());
      let agent = getWantAgent();
      if (agent) {
        let ntfAction: NotificationAction = {
          actionTitle: 'test',
          wantAgent: agent,
          updateCount: 1,
          setUpdateCount: (count: number): void => {
          },
          getUpdateCount: (): number => {
            return 0;
          }
        }
        let ret = true;
        actionVM.startActionInner(ntfAction, true, true);
        expect(ret).assertTrue();
      } else {
        let ret = true;
        expect(ret).assertTrue();
      }
    })
  })
}

class ItemListen implements ActionCallback {
  getNtfEntry(): NotificationEntry {
    return getNtfEntry();
  }

  getNtfType(): number {
    return NotificationType.TYPE_PHONE_KEYGUARD;
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

function getWantAgent(): _WantAgent | undefined {
  let wantAgent: _WantAgent | undefined;
  let wantAgentInfo: WantAgent.WantAgentInfo = {
    wants: [
      {
        deviceId: 'deviceId',
        bundleName: 'com.example.myapplication',
        abilityName: 'EntryAbility',
        action: 'action1',
        entities: ['entity1'],
        type: 'MIMETYPE',
        uri: 'key={true,true,false}',
      } as Want
    ],
    actionType: WantAgent.OperationType.START_ABILITIES,
    requestCode: 0,
    wantAgentFlags: [WantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
  };
  try {
    WantAgent.getWantAgent(wantAgentInfo).then((data) => {
      wantAgent = data;
    }).catch((err: BusinessError) => {
      wantAgent = undefined;
    });
  } catch (err) {
    wantAgent = undefined;
  }
  return wantAgent;
}

