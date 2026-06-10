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

import { it, describe, expect } from '@ohos/hypium';
import { BindBaseState } from '../../../../../../../main/ets/immersivekgcommon/base/bean/BindBaseState';
import {
  IBaseStateChangeListener
} from '../../../../../../../main/ets/immersivekgcommon/base/interface/IBaseStateChangeListener';
import { BaseState } from '../../../../../../../main/ets/immersivekgcommon/base/bean/BaseState';

export function BindBaseStateTest() {
  describe('BindBaseStateTest', (): void => {
    it('test_registerStateChangeListener', 0, (): void => {
      let listener: IBaseStateChangeListener = {
        onStateChange: () => {
        }
      };
      let testInstance: BindBaseState = BaseState.wrap(BindBaseState, 'BindBaseStateTest');
      testInstance.registerStateChangeListener?.(listener);
      expect(true).assertTrue();
    });
    it('test_unregisterStateChangeListener', 0, (): void => {
      let listener: IBaseStateChangeListener = {
        onStateChange: () => {
        }
      };
      let testInstance: BindBaseState = BaseState.wrap(BindBaseState, 'BindBaseStateTest');
      testInstance.unregisterStateChangeListener?.(listener);
      expect(true).assertTrue();
    });
    it('test_getStateType', 0, (): void => {
      let testInstance: BindBaseState = BaseState.wrap(BindBaseState, 'BindBaseStateTest');
      let res = testInstance.getStateType();
      expect(res != undefined).assertTrue();
    });
    it('test_setStateValue', 0, (): void => {
      let testInstance: BindBaseState = BaseState.wrap(BindBaseState, 'BindBaseStateTest');
      let res = testInstance.setStateValue('10');
      expect(res instanceof BindBaseState).assertTrue();
    });
    it('test_getStateValue', 0, (): void => {
      let testInstance: BindBaseState = BaseState.wrap(BindBaseState, 'BindBaseStateTest');
      testInstance.getStateValue('10');
      expect(true).assertTrue();
    });

  });
}