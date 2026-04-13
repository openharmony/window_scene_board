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

import { describe, it, expect } from '@ohos/hypium'
import { IBaseState } from '../../../../../../../main/ets/immersivekgcommon/base/interface/IBaseState';
import { BaseStateManager } from '../../../../../../../main/ets/immersivekgcommon/base/manager/BaseStateManager';
import { StateType, BaseObj } from '../../../../../../../main/ets/immersivekgcommon/base/constants/BaseType';
import {
  IBaseStateChangeListener
} from '../../../../../../../main/ets/immersivekgcommon/base/interface/IBaseStateChangeListener';

export default function BaseStateManagerTest() {
  describe('BaseStateManagerTest', () => {
    it('BaseStateManagerTest_addState_001', 0, () => {
      let baseStateU = AppStorage.get<IBaseState>('BaseStateU') as IBaseState;
      let baseStateM: BaseStateManager = new BaseStateManager('testMgrName');
      let result = baseStateM.addState(baseStateU);
      expect(result).assertFalse();
      let baseState: IBaseState = {
        getStateType: (): StateType => {
          return StateType.BIND;
        },
        getStateId: (): string => {
          return 'testId';
        },
        setStateValue: (property: string, value?: BaseObj | undefined): IBaseState => {
          throw new Error('Function not implemented.');
        },
        getStateValue: (property: string, scene?: BaseObj | undefined): BaseObj | undefined => {
          throw new Error('Function not implemented.');
        }
      }
      result = baseStateM.addState(baseState);
      expect(result).assertTrue();
      result = baseStateM.addState(baseState);
      expect(result).assertFalse();
      // delete
      result = baseStateM.deleteState(baseStateU);
      expect(result).assertFalse();
      result = baseStateM.deleteStateById(StateType.BIND, '');
      expect(result).assertFalse();
      result = baseStateM.deleteState(baseState);
      expect(result).assertTrue();
    })
    it("BaseStateManagerTest_registerStateListener_001", 0, () => {
      let listenerU = AppStorage.get<IBaseStateChangeListener>('listener') as IBaseStateChangeListener;
      let baseStateM: BaseStateManager = new BaseStateManager('testMgrName');
      baseStateM.registerStateListener(listenerU);
      let listener: IBaseStateChangeListener = {
        onStateChange: (stateType: StateType, stateId: string, property?: string | undefined): void => {
          throw new Error('Function not implemented.');
        }
      };
      baseStateM.registerStateListener(listener);
      listener.stateType = StateType.BIND;
      baseStateM.registerStateListener(listener);
      listener.stateId = 'testId';
      baseStateM.registerStateListener(listener);
      baseStateM.registerStateListener(listener);
      baseStateM.unregisterStateListener(listener);
      expect(baseStateM != null).assertTrue();
    })
  })
}