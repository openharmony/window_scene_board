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

import { afterAll, afterEach, beforeAll, beforeEach, describe, Level, it, expect } from '@ohos/hypium'
import { WidgetStaticState } from '../../../../../main/ets/bean/SlWidgetState';
import { ListWgBindStateType, SlMainStateType } from '../../../../../main/ets/constants/SlStateType';
import { ISlStateChangeListener } from '../../../../../main/ets/interface/ISlStateChangeListener';
import { slUiStateMgr } from '../../../../../main/ets/manager/ScreenLockUiStateManager';

// 锁屏状态管理集散中心测试用例
export function ScreenLockUiStateManagerTest() {
  describe('ScreenLockUiStateManagerTest', () => {
    beforeAll(() => {
    });
    beforeEach(() => {
    });
    afterAll(() => {
    });
    afterEach(() => {
    });

    it("ScreenLockUiStateManager_setSlState_getSlState", Level.LEVEL1, () => {
      let listener: ISlStateChangeListener = {
        slMainStateType: SlMainStateType.SL_LIST_WG_BIND_STATE,
        onSlStateChange: (mainType, subType) => {}
      };
      slUiStateMgr.registerSlStateChangeListener(listener);
      let slState: WidgetStaticState<ListWgBindStateType> = new WidgetStaticState(SlMainStateType.SL_LIST_WG_BIND_STATE);
      slUiStateMgr.setSlState(SlMainStateType.SL_LIST_WG_BIND_STATE, slState);
      let st: WidgetStaticState<ListWgBindStateType> = new WidgetStaticState(SlMainStateType.SL_LIST_WG_BIND_STATE);
      slUiStateMgr.setSlState(SlMainStateType.SL_LIST_WG_BIND_STATE, st);
      expect(slUiStateMgr.getSlState(SlMainStateType.SL_LIST_WG_BIND_STATE)).not().assertNull();
    });

    it("ScreenLockUiStateManager_registerSlStateChangeListener", Level.LEVEL1, () => {
      let listener: ISlStateChangeListener = {
        slMainStateType: SlMainStateType.SL_STATIC_STATE,
        onSlStateChange: (mainType, subType) => {}
      };
      let quick = slUiStateMgr.registerSlStateChangeListener(listener);
      let listeners = Reflect.get(slUiStateMgr, 'slStateListeners') as Map<SlMainStateType, Set<ISlStateChangeListener>>;
      expect(listeners?.get(SlMainStateType.SL_STATIC_STATE)?.has(listener)).assertTrue();
      quick?.();
      let li: ISlStateChangeListener = {
        onSlStateChange: (mainType, subType) => {}
      };
      slUiStateMgr.registerSlStateChangeListener(li)?.();
      expect(listeners?.get(SlMainStateType.SL_STATIC_STATE)?.has(listener)).assertFalse();
    });

    it("ScreenLockUiStateManager_unregisterSlStateChangeListener", Level.LEVEL1, () => {
      let listener: ISlStateChangeListener = {
        slMainStateType: SlMainStateType.SL_STATIC_STATE,
        onSlStateChange: (mainType, subType) => {}
      };
      slUiStateMgr.registerSlStateChangeListener(listener);
      slUiStateMgr.unregisterSlStateChangeListener(listener);
      let li: ISlStateChangeListener = {
        onSlStateChange: (mainType, subType) => {}
      };
      slUiStateMgr.unregisterSlStateChangeListener(li);
      let listeners = Reflect.get(slUiStateMgr, 'slStateListeners') as Map<SlMainStateType, Set<ISlStateChangeListener>>;
      expect(listeners?.get(SlMainStateType.SL_STATIC_STATE)?.has(listener)).assertFalse();
    });

    it("test_registerSlStateChangeListener", Level.LEVEL1, () => {
      slUiStateMgr.registerSlStateChangeListener({} as ISlStateChangeListener);
      expect(true).assertTrue();
    });
  })
}