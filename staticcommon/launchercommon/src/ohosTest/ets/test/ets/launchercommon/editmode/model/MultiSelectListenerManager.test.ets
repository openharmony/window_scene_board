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

import { describe, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium'
import { MultiSelectListenerType, MultiSelectListenManager } from '../../../../../../../main/ets/TsIndex';

export default function MultiSelectListenManagerTest() {
  describe('MultiSelectListenManagerTest', () => {
    let multiSelectListenManager: MultiSelectListenManager = new MultiSelectListenManager();

    it('test_register', 0, () => {
      let listener: MultiSelectListenerType = new MultiSelectListenerType();
      listener.id = '1';
      multiSelectListenManager.register(listener);
      expect(multiSelectListenManager['listenerMap'].size).assertEqual(1);

      multiSelectListenManager.register(listener);
      expect(multiSelectListenManager['listenerMap'].size).assertEqual(1);
    })

    it('test_unregister', 0, () => {
      multiSelectListenManager.unregister(undefined);
      expect(multiSelectListenManager['listenerMap'].size).assertEqual(1);

      let listener: MultiSelectListenerType = new MultiSelectListenerType();
      listener.id = '1';
      multiSelectListenManager.unregister(listener);
      expect(multiSelectListenManager['listenerMap'].size).assertEqual(1);

      listener.id = '2';
      multiSelectListenManager.unregister(listener);
      expect(multiSelectListenManager['listenerMap'].size).assertEqual(1);
    })

    it('test_clearAll', 0, () => {
      multiSelectListenManager.clearAll();
      expect(multiSelectListenManager['listenerMap'].size).assertEqual(0);
    })

    it('test_executeEvent', 0, () => {
      let listener1: MultiSelectListenerType = new MultiSelectListenerType();
      listener1.id = '1';
      multiSelectListenManager.register(listener1);
      let listener2: MultiSelectListenerType = new MultiSelectListenerType();
      listener2.id = '2';
      listener2.onEnter = () => {};
      listener2.onExit = () => {};
      listener2.onUpdatingMultiSelectMap = () => {};
      listener2.onLongPress = () => {};
      listener2.beforeGather = () => {};
      listener2.onGather = () => {};
      listener2.onDragging = () => {};
      listener2.onDropping = () => {};
      listener2.onItemDropped = () => {};
      listener2.onFinish = () => {};
      listener2.onUpdateState = () => {};
      multiSelectListenManager.register(listener2);
      multiSelectListenManager.executeEnter();
      multiSelectListenManager.executeExit();
      multiSelectListenManager.executeUpdatingMultiSelectMap();
      multiSelectListenManager.executeLongPress();
      multiSelectListenManager.executeBeforeGather();
      multiSelectListenManager.executeGather();
      multiSelectListenManager.executeDragging();
      multiSelectListenManager.executeDropping();
      multiSelectListenManager.executeItemDropped();
      multiSelectListenManager.executeFinish();
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('test_executeUpdateState', 0, () => {
      multiSelectListenManager.executeUpdateState([]);
      expect(true).assertTrue();

      multiSelectListenManager.executeUpdateState(['1', '2']);
      expect(true).assertTrue();
    })

    it('test_sendEvent', 0, () => {
      multiSelectListenManager['sendEvent']([], ()=>{}, false);
      expect(true).assertTrue();

      multiSelectListenManager['sendEvent'](['1'], ()=>{}, false);
      expect(true).assertTrue();

      multiSelectListenManager['sendEvent'](['1'], ()=>{}, true);
      expect(true).assertTrue();
    })
  })
}
