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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit } from '@ohos/hypium';
import { sEventManager, Events } from '../../../../../../main/ets/utils/EventManager';
import { EventBus, Callback } from '../../../../../../main/ets/utils/EventBus';
import { Event, obtainLocalEvent, obtainStartAbility, obtainStartServiceExt } from '../../../../../../main/ets/utils/EventUtil';

const mCallback: Callback = (args: Object): void=> {};

export function EventManagerTest() {
  describe('EventManagerTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('EventManager_publishLocalEvent', 0, (): void => {
      let eventLocal1: Event = obtainLocalEvent('eventName', true);
      let eventLocal2: Event = obtainLocalEvent('', true);
      expect(sEventManager.publish(eventLocal1)).assertTrue();
      expect(sEventManager.publish(eventLocal2)).assertFalse();
    })

    it('EventManager_publishAbilityEvent', 0, (): void => {
      let eventAbility1: Event = obtainStartAbility('bundleName', 'abilityName');
      let eventAbility2: Event = {
        target: 'ability',
        data: {
          bundleName: '',
          abilityName: ''
        }
      };
      expect(sEventManager.publish(eventAbility1)).assertTrue();
      expect(sEventManager.publish(eventAbility2)).assertFalse();
    })

    it('EventManager_publishServiceExtEvent', 0, (): void => {
      let eventServiceExt1: Event = obtainStartServiceExt('bundleName', 'abilityName');
      let eventServiceExt2: Event = {
        target: 'serviceExt',
        data: {
          bundleName: '',
          abilityName: ''
        }
      };
      expect(sEventManager.publish(eventServiceExt1)).assertTrue();
      expect(sEventManager.publish(eventServiceExt2)).assertFalse();
    })

    it('EventManager_publishRemoteAndCommonEvent', 0, (): void => {
      let eventRemote: Event = {
        target: 'remote',
        data: {
          bundleName: '',
          abilityName: ''
        }
      };
      let eventCommon: Event = {
        target: 'commonEvent',
        data: {
          bundleName: '',
          abilityName: ''
        }
      };
      expect(sEventManager.publish(eventRemote)).assertFalse();
      expect(sEventManager.publish(eventCommon)).assertFalse();
    })

    it('EventManager_subscribe', 0, (): void => {
      sEventManager.subscribe('mtest', mCallback);
      sEventManager.subscribe(['mtest1', 'mtest2'], mCallback);
      expect(true).assertTrue();
    })

    it('EventManager_off', 0, (): void => {
      sEventManager.off('mtest', mCallback);
      sEventManager.off(['mtest1', 'mtest2'], mCallback);
      sEventManager.off('', mCallback);
      expect(true).assertTrue();
    })

    it('EventManager_subscribeOnce', 0, (): void => {
      sEventManager.subscribeOnce('mtest', mCallback);
      expect(true).assertTrue();
    })
  })
}