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
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect } from '@ohos/hypium';
import { notificationManager } from '@kit.NotificationKit';
import {
  getViewDataSlotType,
  getModelSlotType,
  getLabelBySlotType,
  getIdxInModelFlags,
  SlotType,
  RemindType,
} from '../../../../../main/ets/common/NotificationMgmtCommon';

export function NotificationMgmtCommonTest() {
  describe('NotificationMgmtCommonTest', (): void => {
    beforeAll(() => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('NotificationMgmtCommon_getViewDataSlotTypeTest01', 0, (): void => {
      const slot: notificationManager.NotificationSlot = {
        notificationType: notificationManager.SlotType.SOCIAL_COMMUNICATION,
      }
      const slotType: SlotType = getViewDataSlotType(slot) as SlotType;
      expect(slotType).assertEqual(SlotType.SOCIAL_COMMUNICATION);
    })

    it('NotificationMgmtCommon_getModelSlotTypeTest01', 0, (): void => {
      const slotType: SlotType = SlotType.SOCIAL_COMMUNICATION;
      const modelSlotType: notificationManager.SlotType = getModelSlotType(slotType) as notificationManager.SlotType;
      expect(modelSlotType).assertEqual(notificationManager.SlotType.SOCIAL_COMMUNICATION);
    })

    it('NotificationMgmtCommon_getLabelBySlotTypeTest01', 0, (): void => {
      const slotType: SlotType = SlotType.SOCIAL_COMMUNICATION;
      const labelBySlotType: ResourceStr = getLabelBySlotType(slotType) as ResourceStr;
      expect(labelBySlotType).not().assertEqual('');
    })

    it('NotificationMgmtCommon_getIdxInModelFlagsTest01', 0, (): void => {
      const remindType: RemindType = RemindType.SOUND;
      const labelBySlotType: number = getIdxInModelFlags(remindType) as number;
      expect(labelBySlotType).assertEqual(0);
    })
  })
}
