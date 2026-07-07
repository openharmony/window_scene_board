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
import type ctx from '@ohos.app.ability.common';
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect } from '@ohos/hypium';
import { LockScreenNtfStyle } from '../../../../../main/ets/common/NotificationMgmtCommon';
import { NotificationMgmtModel } from '../../../../../main/ets/model/NotificationMgmtModel';
import { notificationManager } from '@kit.NotificationKit';

export function NotificationMgmtModelTest01() {
  const nNotificationMgmtModel: NotificationMgmtModel = new NotificationMgmtModel('test', 1);
  describe('NotificationMgmtModelTest01', (): void => {
    beforeAll(() => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('NotificationMgmtModel_initNotificationMgmtModelTest01', 0, (): void => {
      const notificationMgmtModel: NotificationMgmtModel = new NotificationMgmtModel('test', 1);
      expect(notificationMgmtModel instanceof NotificationMgmtModel).assertTrue();
    })

    it('NotificationMgmtModel_getLockScreenStyleTest01', 0, (): void => {
      const style: LockScreenNtfStyle | undefined = NotificationMgmtModel.getLockScreenStyle();
      expect(typeof style === 'number' || style === undefined).assertTrue();
    })

    it('NotificationMgmtModel_getAllowStateTest01', 0, async (): Promise<void> => {
      const state: boolean = await nNotificationMgmtModel.getAllowState();
      expect(state).assertInstanceOf('Boolean');
    })

    it('NotificationMgmtModel_setAllowStateTest01', 0, async (): Promise<void> => {
      const state: void = await nNotificationMgmtModel.setAllowState(true);
      expect(state === undefined).assertTrue();
    })

    it('NotificationMgmtModel_getPinTopStateTest01', 0, async (): Promise<void> => {
      const state: boolean = await nNotificationMgmtModel.getPinTopState();
      expect(state).assertInstanceOf('Boolean');
    })

    it('NotificationMgmtModel_setPinTopStateTest01', 0, async (): Promise<void> => {
      const state: void = await nNotificationMgmtModel.setPinTopState(true);
      expect(state === undefined).assertTrue();
    })
  })
}

export function NotificationMgmtModelTest02() {
  const nNotificationMgmtModel: NotificationMgmtModel = new NotificationMgmtModel('test', 1);
  describe('NotificationMgmtModelTest02', (): void => {
    beforeAll(() => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })
    it('NotificationMgmtModel_batchDisablePinTopTest01', 0, async (): Promise<void> => {
      const state: boolean = await nNotificationMgmtModel.batchDisablePinTop(new Set());
      expect(state).assertInstanceOf('Boolean');
    })

    it('NotificationMgmtModel_getSlotFlagsTest01', 0, async (): Promise<void> => {
      const flag: number = await nNotificationMgmtModel.getSlotFlags();
      expect(flag).assertInstanceOf('Number');
    })

    it('NotificationMgmtModel_setSlotFlagsTest01', 0, async (): Promise<void> => {
      const state: void = await nNotificationMgmtModel.setSlotFlags(1);
      expect(state === undefined).assertTrue();
    })

    it('NotificationMgmtModel_getSlotsTest01', 0, async (): Promise<void> => {
      const slots: notificationManager.NotificationSlot[] = await nNotificationMgmtModel.getSlots();
      expect(slots).assertInstanceOf('Array');
    })

    it('NotificationMgmtModel_setSlotTest01', 0, async (): Promise<void> => {
      const state: void = await nNotificationMgmtModel.setSlot(notificationManager.SlotType.SOCIAL_COMMUNICATION, true);
      expect(state === undefined).assertTrue();
    })

    it('NotificationMgmtModel_isDeliverTest01', 0, async (): Promise<void> => {
      const state: boolean = await nNotificationMgmtModel.isDeliver();
      expect(state).assertInstanceOf('Boolean');
    })
  })
}
