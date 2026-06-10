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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when } from '@ohos/hypium'
import { InnerSimCard, LockType, SimCardStateManager } from '../../../../../main/ets/manager/SimCardStateManager'
import { sim } from '@kit.TelephonyKit'
import { SimCardUtils } from '../../../../../main/ets/utils/SimCardUtils'

/**
 * SIM卡状态管理器
 */
export default function SimCardStateManagerTest() {
  describe('SimCardStateManagerTest', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('SimCardStateManager_isPukLocked', Level.LEVEL0, () => {
      let isPukLocked: boolean = SimCardStateManager.getInstance().isPukLocked();
      expect(isPukLocked).assertFalse();
    })

    it('SimCardStateManager_isPinLocked', Level.LEVEL1, () => {
      let isPinLocked: boolean = SimCardStateManager.getInstance().isPinLocked();
      expect(isPinLocked).assertFalse();
    })

    it('SimCardStateManager_isSimLocked', Level.LEVEL2, () => {
      let isSimLocked: boolean = SimCardStateManager.getInstance().isSimLocked();
      expect(isSimLocked).assertFalse();
    })

    it('SimCardStateManager_getInstance', 0, () => {
      let result: SimCardStateManager = SimCardStateManager.getInstance();
      expect(result).not().assertNull();
    })

    it('SimCardStateManager_updateSimCardState1', 0, () => {
      let simCard: InnerSimCard = new InnerSimCard(0);
      simCard.timerId = 1;
      (SimCardStateManager.getInstance() as object)['updateSimCardState'](simCard, sim.SimState.SIM_STATE_UNKNOWN,
        false);
      expect(SimCardStateManager.getInstance()).not().assertNull();
    })

    it('SimCardStateManager_updateSimCardState2', 0, () => {
      let simCard: InnerSimCard = new InnerSimCard(0);
      simCard.timerId = 1;
      (SimCardStateManager.getInstance() as object)['updateSimCardState'](simCard, sim.SimState.SIM_STATE_NOT_PRESENT,
        false);
      expect(SimCardStateManager.getInstance()).not().assertNull();
    })

    it('SimCardStateManager_sendBroadCast1', 0, () => {
      let simCard: InnerSimCard = new InnerSimCard(0);
      simCard.timerId = 1;
      simCard.isPositionChange = true;
      (SimCardStateManager.getInstance() as object)['_simState'] = sim.SimState.SIM_STATE_LOCKED;
      (SimCardStateManager.getInstance() as object)['_lockType'] = LockType.PIN_LOCK;
      (SimCardStateManager.getInstance() as object)['sendBroadCast'](simCard, true, 0);
      expect(SimCardStateManager.getInstance()).not().assertNull();
    })

    it('SimCardStateManager_sendBroadCast2', 0, () => {
      let simCard: InnerSimCard = new InnerSimCard(0);
      simCard.timerId = 1;
      simCard.isPositionChange = true;
      (SimCardStateManager.getInstance() as object)['_simState'] = sim.SimState.SIM_STATE_LOCKED;
      (SimCardStateManager.getInstance() as object)['_lockType'] = LockType.PIN_LOCK;
      (SimCardStateManager.getInstance() as object)['sendBroadCast'](simCard, false, 0);
      expect(SimCardStateManager.getInstance()).not().assertNull();
    })

    it('SimCardStateManager_sendBroadCast3', 0, () => {
      let simCard: InnerSimCard = new InnerSimCard(0);
      simCard.timerId = 1;
      simCard.isPositionChange = false;
      (SimCardStateManager.getInstance() as object)['sendBroadCast'](simCard, false, 0);
      expect(SimCardStateManager.getInstance()).not().assertNull();
    })

    it('SimCardStateManager_syncSimAccountInfo', 0, () => {
      let simCard: InnerSimCard = new InnerSimCard(10);
      simCard.timerId = 1;
      simCard.isPositionChange = false;
      (SimCardStateManager.getInstance() as object)['syncSimAccountInfo'](simCard);
      expect(SimCardStateManager.getInstance()).not().assertNull();
    })

    it('SimCardStateManager_syncSimCardLockInfo1', 0, async (done: Function) => {
      let simCard: InnerSimCard = new InnerSimCard(10);
      simCard.timerId = 1;
      simCard.simState = sim.SimState.SIM_STATE_READY;
      simCard.isPositionChange = false;
      (SimCardStateManager.getInstance() as object)['syncSimCardLockInfo'](simCard);
      expect(SimCardStateManager.getInstance()).not().assertNull();
      done();
    })

    it('SimCardStateManager_syncSimCardLockInfo2', 0, async (done: Function) => {
      let simCard: InnerSimCard = new InnerSimCard(10);
      simCard.timerId = 1;
      simCard.simState = sim.SimState.SIM_STATE_LOCKED;
      simCard.isPositionChange = false;
      (SimCardStateManager.getInstance() as object)['syncSimCardLockInfo'](simCard);
      expect(SimCardStateManager.getInstance()).not().assertNull();
      done();
    })

    it('SimCardStateManager_getRemainTimes1', 0, () => {
      (SimCardStateManager.getInstance() as object)['getRemainTimes'](10, LockType.PIN_LOCK, sim.LockType.PIN_LOCK);
      expect(SimCardStateManager.getInstance()).not().assertNull();
    })

    it('SimCardStateManager_getRemainTimes2', 0, () => {
      (SimCardStateManager.getInstance() as object)['getRemainTimes'](10, LockType.PUK_LOCK, sim.LockType.PIN_LOCK);
      expect(SimCardStateManager.getInstance()).not().assertNull();
    })

    it('SimCardStateManager_updateQueue1', 0, () => {
      (SimCardStateManager.getInstance() as object)['updateQueue'](10, true, false);
      expect(SimCardStateManager.getInstance()).not().assertNull();
    })

    it('SimCardStateManager_updateQueue2', 0, () => {
      (SimCardStateManager.getInstance() as object)['updateQueue'](10, false, true);
      expect(SimCardStateManager.getInstance()).not().assertNull();
    })

    it('SimCardStateManager_removeQueue', 0, () => {
      let simCard: InnerSimCard = new InnerSimCard(10);
      simCard.timerId = 1;
      simCard.simState = sim.SimState.SIM_STATE_LOCKED;
      simCard.isPositionChange = true;
      (SimCardStateManager.getInstance() as object)['removeQueue'](simCard);
      expect(SimCardStateManager.getInstance()).not().assertNull();
    })

    it('SimCardStateManager_isCurPinSavingSupported', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(SimCardUtils, SimCardUtils.getPinSavingSupported);
      when(mockFunc)().afterReturn(true);
      (SimCardStateManager.getInstance() as object)['isCurPinSavingSupported'](10);
      expect(SimCardStateManager.getInstance()).not().assertNull();
      mocker.clear(SimCardUtils);
      mocker.clearAll();
      done();
    })

    it('SimCardStateManager_updateCardState1', 0, async (done: Function) => {
      SimCardStateManager.getInstance().updateCardState(-10, sim.SimState.SIM_STATE_READY);
      expect(SimCardStateManager.getInstance()).not().assertNull();
      done();
    })

    it('SimCardStateManager_updateCardState2', 0, async (done: Function) => {
      SimCardStateManager.getInstance().updateCardState(10, sim.SimState.SIM_STATE_READY);
      expect(SimCardStateManager.getInstance()).not().assertNull();
      done();
    })

    it('SimCardStateManager_updateQueue1', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(SimCardStateManager.getInstance(), SimCardStateManager.getInstance().isSimLocked);
      when(mockFunc)().afterReturn(true);
      SimCardStateManager.getInstance().isSimLocked();
      expect(SimCardStateManager.getInstance()).not().assertNull();
    })

    it('SimCardStateManager_updateQueue2', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(SimCardStateManager.getInstance(), SimCardStateManager.getInstance().isSimLocked);
      when(mockFunc)().afterReturn(false);
      SimCardStateManager.getInstance().isSimLocked();
      expect(SimCardStateManager.getInstance()).not().assertNull();
    })

    it('SimCardStateManager_getActiveSimNumber', 0, () => {
      let result = SimCardStateManager.getInstance().getActiveSimNumber();
      expect(result).not().assertNull();
    })

    it('SimCardStateManager_setSkipAuth', 0, () => {
      SimCardStateManager.getInstance().setSkipAuth(false);
      SimCardStateManager.getInstance().setSkipAuth(true);
      let result = SimCardStateManager.getInstance().getCurSimCard();
      expect(result).not().assertNull();
    })

    it('SimCardStateManager_isAlreadySkipAuth', 0, () => {
      let result = SimCardStateManager.getInstance().isAlreadySkipAuth();
      expect(result).not().assertNull();
    })

    it('SimCardStateManager_getAvailableTimes', 0, () => {
      let result = SimCardStateManager.getInstance().getAvailableTimes();
      expect(result).not().assertNull();
    })
  })
}