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
import { SlotType } from '../../../../../main/ets/common/NotificationMgmtCommon';
import {
  NotificationMgmtViewData,
  ObservedArray,
  SlotViewData,
  SoltCfg,
  State,
  VisualReminderViewData,
} from '../../../../../main/ets/vm/NotificationMgmtViewData';

export function NotificationMgmtViewDataTest01() {
  const nNotificationMgmtViewData: NotificationMgmtViewData = new NotificationMgmtViewData();
  describe('NotificationMgmtViewDataTest01', (): void => {
    it('NotificationMgmtViewData_initNotificationMgmtViewDataTest01', 0, (): void => {
      const notificationMgmtViewData: NotificationMgmtViewData = new NotificationMgmtViewData();
      expect(notificationMgmtViewData instanceof NotificationMgmtViewData).assertTrue();
    })

    it('NotificationMgmtViewData_isNativeAppTest01', 0, (): void => {
      const res: boolean = nNotificationMgmtViewData.isNativeApp();
      expect(res).assertInstanceOf('Boolean');
    })

    it('NotificationMgmtViewData_isOnTest01', 0, (): void => {
      const isOn: boolean = nNotificationMgmtViewData.isOn();
      expect(isOn).assertInstanceOf('Boolean');
    })

    it('NotificationMgmtViewData_getAllowStateTest01', 0, (): void => {
      const state: State = nNotificationMgmtViewData.getAllowState();
      expect(state instanceof State).assertTrue();
    })

    it('NotificationMgmtViewData_getPinTopStateTest01', 0, (): void => {
      const state: State = nNotificationMgmtViewData.getPinTopState();
      expect(state instanceof State).assertTrue();
    })

    it('NotificationMgmtViewData_getScreenLockReminderViewDataTest01', 0, (): void => {
      const reminder: VisualReminderViewData = nNotificationMgmtViewData.getScreenLockReminderViewData();
      expect(reminder instanceof VisualReminderViewData).assertTrue();
    })

    it('NotificationMgmtViewData_getBannerReminderViewDataTest01', 0, (): void => {
      const reminder: VisualReminderViewData = nNotificationMgmtViewData.getBannerReminderViewData();
      expect(reminder instanceof VisualReminderViewData).assertTrue();
    })

    it('NotificationMgmtViewData_getCornerReminderViewDataTest01', 0, (): void => {
      const reminder: VisualReminderViewData = nNotificationMgmtViewData.getCornerReminderViewData();
      expect(reminder instanceof VisualReminderViewData).assertTrue();
    })
  })
}

export function NotificationMgmtViewDataTest02() {
  const nNotificationMgmtViewData: NotificationMgmtViewData = new NotificationMgmtViewData();
  describe('NotificationMgmtViewDataTest02', (): void => {
    it('NotificationMgmtViewData_getSoundReminderStateTest01', 0, (): void => {
      const state: State = nNotificationMgmtViewData.getSoundReminderState();
      expect(state instanceof State).assertTrue();
    })

    it('NotificationMgmtViewData_getVibrationReinderStateTest01', 0, (): void => {
      const state: State = nNotificationMgmtViewData.getVibrationReinderState();
      expect(state instanceof State).assertTrue();
    })

    it('NotificationMgmtViewData_getSlotsViewDataTest01', 0, (): void => {
      const state: ObservedArray<SlotViewData> = nNotificationMgmtViewData.getSlotsViewData();
      expect(state instanceof ObservedArray).assertTrue();
    })

    it('NotificationMgmtViewData_isHideBackButtonTest01', 0, (): void => {
      const isHide: boolean = nNotificationMgmtViewData.isHideBackButton();
      expect(isHide).assertInstanceOf('Boolean');
    })

    it('NotificationMgmtViewData_updateHideBackButtonTest01', 0, (): void => {
      nNotificationMgmtViewData.updateHideBackButton(false);
      expect((nNotificationMgmtViewData as object)['hideBackButton']).assertFalse();
    })

    it('NotificationMgmtViewData_updateAllowStateTest01', 0, (): void => {
      nNotificationMgmtViewData.updateAllowState(true);
      expect((nNotificationMgmtViewData as object)['on']).assertTrue();
    })

    it('NotificationMgmtViewData_updatePinTopStateTest01', 0, (): void => {
      nNotificationMgmtViewData.updatePinTopState(true);
      expect((nNotificationMgmtViewData as object)['pinTop']['value']).assertTrue();
    })

    it('NotificationMgmtViewData_updateReminderTypesTest01', 0, (): void => {
      nNotificationMgmtViewData.updateReminderTypes(0);
      expect((nNotificationMgmtViewData as object)['connerReminder']['state']).assertTrue();
    })

    it('NotificationMgmtViewData_updateLockScreenReminderStateTest01', 0, (): void => {
      nNotificationMgmtViewData.updateLockScreenReminderState(true);
      expect((nNotificationMgmtViewData as object)['screenLockReminder']['state']).assertTrue();
    })
  })
}

export function NotificationMgmtViewDataTest03() {
  const nNotificationMgmtViewData: NotificationMgmtViewData = new NotificationMgmtViewData();
  describe('NotificationMgmtViewDataTest03', (): void => {
    it('NotificationMgmtViewData_updateBannerReminderStateTest01', 0, (): void => {
      nNotificationMgmtViewData.updateBannerReminderState(true);
      expect((nNotificationMgmtViewData as object)['bannerReminder']['state']).assertTrue();
    })

    it('NotificationMgmtViewData_updateSoundReminderStateTest01', 0, (): void => {
      nNotificationMgmtViewData.updateSoundReminderState(true);
      expect((nNotificationMgmtViewData as object)['soundReminder']['value']).assertTrue();
    })

    it('NotificationMgmtViewData_updateVibrationReminderStateTest01', 0, (): void => {
      nNotificationMgmtViewData.updateVibrationReminderState(true);
      expect((nNotificationMgmtViewData as object)['vibrationReinder']['value']).assertTrue();
    })

    it('NotificationMgmtViewData_reloadSlotsTest01', 0, (): void => {
      nNotificationMgmtViewData.reloadSlots([]);
      expect((nNotificationMgmtViewData as object)['viewSlots'].length).assertEqual(0);
    })

    it('NotificationMgmtViewData_setFromMainPageTest01', 0, (): void => {
      nNotificationMgmtViewData.setFromMainPage();
      expect((nNotificationMgmtViewData as object)['fromMainPage']).assertTrue();
    })

    it('NotificationMgmtViewData_isFromMainPageTest01', 0, (): void => {
      const isFromMainPage: boolean = nNotificationMgmtViewData.isFromMainPage();
      expect(isFromMainPage).assertInstanceOf('Boolean');
    })

    it('NotificationMgmtViewData_setFromAppAndMetaTest01', 0, (): void => {
      nNotificationMgmtViewData.setFromAppAndMeta();
      expect((nNotificationMgmtViewData as object)['fromAppAndMeta']).assertTrue();
    })

    it('NotificationMgmtViewData_isFromAppAndMetaTest01', 0, (): void => {
      const isFromAppAndMeta: boolean = nNotificationMgmtViewData.isFromAppAndMeta();
      expect(isFromAppAndMeta).assertInstanceOf('Boolean');
    })
  })
}

export function VisualReminderViewDataTest() {
  const vVisualReminderViewData: VisualReminderViewData = new VisualReminderViewData();
  describe('VisualReminderViewDataTest', (): void => {
    beforeAll(() => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('VisualReminderViewData_initVisualReminderViewDataTest01', 0, (): void => {
      const visualReminderViewData: VisualReminderViewData = new VisualReminderViewData();
      expect(visualReminderViewData instanceof VisualReminderViewData).assertTrue();
    })

    it('VisualReminderViewData_isOnTest01', 0, (): void => {
      const isOn: boolean = vVisualReminderViewData.isOn();
      expect(isOn).assertInstanceOf('Boolean');
    })

    it('VisualReminderViewData_setStateTest01', 0, (): void => {
      vVisualReminderViewData.setState(true);
      expect((vVisualReminderViewData as object)['state']).assertTrue();
    })

    it('VisualReminderViewData_getImgTest01', 0, (): void => {
      const img: Resource = vVisualReminderViewData.getImg();
      expect(img).not().assertUndefined();
    })

    it('VisualReminderViewData_setImgTest01', 0, (): void => {
      vVisualReminderViewData.setImg(Object());
      expect((vVisualReminderViewData as object)['img']).not().assertUndefined();
    })
  })
}

export function SoltCfgTest() {
  const sSlotViewData: SlotViewData = new SlotViewData(SlotType.SOCIAL_COMMUNICATION, 'test', true);
  const sSoltCfg: SoltCfg = new SoltCfg(SlotType.SOCIAL_COMMUNICATION, sSlotViewData);
  describe('SoltCfgTest', (): void => {
    beforeAll(() => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('SoltCfg_initSoltCfgTest01', 0, (): void => {
      const slotViewData: SlotViewData = new SlotViewData(SlotType.SOCIAL_COMMUNICATION, 'test', true);
      const soltCfg: SoltCfg = new SoltCfg(SlotType.SOCIAL_COMMUNICATION, slotViewData);
      expect(soltCfg instanceof SoltCfg).assertTrue();
    })

    it('SoltCfg_getTypeTest01', 0, (): void => {
      const type: SlotType = sSoltCfg.getType();
      expect(type).assertEqual(SlotType.SOCIAL_COMMUNICATION);
    })

    it('SoltCfg_getSlotTest01', 0, (): void => {
      const slot: SlotViewData = sSoltCfg.getSlot();
      expect(slot instanceof SlotViewData).assertTrue();
    })
  })
}

export function SlotViewDataTest() {
  const sSlotViewData: SlotViewData = new SlotViewData(SlotType.SOCIAL_COMMUNICATION, 'test', true);
  describe('SlotViewDataTest', (): void => {
    beforeAll(() => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('SlotViewData_initSlotViewDataTest01', 0, (): void => {
      const slotViewData: SlotViewData = new SlotViewData(SlotType.SOCIAL_COMMUNICATION, 'test', true);
      expect(slotViewData instanceof SlotViewData).assertTrue();
    })

    it('SlotViewData_getTypeTest01', 0, (): void => {
      const type: SlotType = sSlotViewData.getType();
      expect(type).assertEqual(SlotType.SOCIAL_COMMUNICATION);
    })

    it('SlotViewData_getSecLabelTest01', 0, (): void => {
      const label: ResourceStr = sSlotViewData.getSecLabel();
      expect(label).assertEqual('test');
    })

    it('SlotViewData_isOnTest01', 0, (): void => {
      const isOn: boolean = sSlotViewData.isOn();
      expect(isOn).assertTrue();
    })
  })
}

export function NotificationStateTest() {
  const sState: State = new State(true);
  describe('NotificationStateTest', (): void => {
    beforeAll(() => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('NotificationState_initStateTest01', 0, (): void => {
      const state: State = new State(true);
      expect(state instanceof State).assertTrue();
    })

    it('NotificationState_isOnTest01', 0, (): void => {
      const isOn: boolean = sState.isOn();
      expect(isOn).assertTrue();
    })

    it('NotificationState_setStateTest01', 0, (): void => {
      sState.setState(false);
      expect((sState as object)['value']).assertFalse();
    })
  })
}
