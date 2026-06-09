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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, DEFAULT } from '@ohos/hypium';
import { EventBus, createEventBus } from '../../../../../../main/ets/utils/EventBus';

export function EventBusUtilsTest() {
  describe('EventBusUtilsTest', (): void => {

    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('test_createEventBus_01', DEFAULT, (): void => {
      let eventBus: EventBus<string> = createEventBus<string>();
      expect(eventBus).not().assertUndefined();
    })

    it('test_createEventBus_02', DEFAULT, (): void => {
      let isCalled = false;
      let callBack = () => {
        isCalled = true;
      };
      let eventBus: EventBus<string> = createEventBus<string>();
      eventBus.on('callFun', callBack);
      eventBus.emit('callFun', '');
      expect(isCalled).assertTrue();
      eventBus.off('callFun', callBack);
    })

    it('test_createEventBus_03', DEFAULT, (): void => {
      let isCalled = false;
      let callBack = () => {
        isCalled = true;
      };
      let eventBus: EventBus<string> = createEventBus<string>();
      eventBus.on(['callFun1', 'callFun2'], callBack);
      eventBus.emit('callFun1', '');
      eventBus.emit('callFun2', '');
      expect(isCalled).assertTrue();
      eventBus.off(['callFun1', 'callFun2'], callBack);
    })

    it('test_createEventBus_04', DEFAULT, (): void => {
      let isCallCounter = 0;
      let callBack = () => {
        isCallCounter++;
      };
      let eventBus: EventBus<string> = createEventBus<string>();
      eventBus.once('callFun', callBack);
      eventBus.emit('callFun', '');
      eventBus.emit('callFun', '');
      expect(isCallCounter).assertEqual(1);
    })

    it('test_createEventBus_05', DEFAULT, (): void => {
      let eventBus: EventBus<string> = createEventBus<string>();
      eventBus.emit('', '');
      eventBus.off('', () => {
      });
      expect(eventBus).not().assertUndefined();
    })
  })
}