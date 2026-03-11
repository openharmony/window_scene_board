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

import {
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  DEFAULT,
  describe,
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium';
import {
  localEventManager,
  DockInfoEventListener,
  DockInfo
} from '../../../../../../main/ets/manager/LocalEventManager';
import { PowerStatus } from '@ohos/commonconstants';

const EVENT_IN_APP_EXIT: string = 'launcher.event.IN_APP_EXIT';

export function LocalEventManagerTest() {
  describe('LocalEventManagerTest', () => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('test_registerEventListener_null_args', DEFAULT, (): void => {
      localEventManager.registerEventListener(null, []);
      let listener: DockInfoEventListener = {
        onReceiveEvent: (event: string, params: DockInfo): void => {
          throw new Error('Function not implemented.');
        }
      };
      localEventManager.registerEventListener(listener, []);
      expect(localEventManager).not().assertUndefined();
    })

    it('test_registerEventListener', DEFAULT, (): void => {
      let listener: DockInfoEventListener = {
        onReceiveEvent: (event: string, params: DockInfo): void => {

        }
      };
      (localEventManager as object)['mEventListenerMap'] = {};
      localEventManager.registerEventListener(listener, [EVENT_IN_APP_EXIT, 'test_dt_event']);
      expect((localEventManager as object)['mEventListenerMap']).not().assertUndefined();
    })

    it('test_unregisterEventListener', DEFAULT, (): void => {
      let listener: DockInfoEventListener = {
        onReceiveEvent: (event: string, params: DockInfo): void => {

        }
      };
      (localEventManager as object)['mEventListenerMap'] = {};
      localEventManager.registerEventListener(listener, [EVENT_IN_APP_EXIT, 'test_dt_event']);
      localEventManager.unregisterEventListener(listener);
      expect((localEventManager as object)['mEventListenerMap']).not().assertUndefined();
    })

    it('test_unregisterEventListener_invalid_if', DEFAULT, (): void => {
      let listener: DockInfoEventListener = {
        onReceiveEvent: (event: string, params: DockInfo): void => {

        }
      };
      (localEventManager as object)['mEventListenerMap'] = {};
      localEventManager.unregisterEventListener(listener);
      expect((localEventManager as object)['mEventListenerMap']).not().assertUndefined();
    })

    it('test_sendLocalEvent_first_if', DEFAULT, (): void => {
      (localEventManager as object)['mEventListenerMap'] = {};
      AppStorage.set('powerStatus', PowerStatus.SHUTDOWN);
      localEventManager.sendLocalEvent('any event');

      AppStorage.set('powerStatus', PowerStatus.REBOOT);
      localEventManager.sendLocalEvent('any event');
      expect((localEventManager as object)['mEventListenerMap']).not().assertUndefined();
      AppStorage.delete('powerStatus');
    })

    it('test_sendLocalEvent_if_undefined', DEFAULT, (): void => {
      (localEventManager as object)['mEventListenerMap'] = {};
      AppStorage.delete('powerStatus');
      localEventManager.sendLocalEvent('dt test any event');
      expect((localEventManager as object)['mEventListenerMap']).not().assertUndefined();
    })

    it('test_sendLocalEvent_valid_event', DEFAULT, (): void => {
      let isCalled: boolean = false;
      let listener: DockInfoEventListener = {
        onReceiveEvent: (event: string, params: DockInfo): void => {
          isCalled = true;
        }
      };
      (localEventManager as object)['mEventListenerMap'] = {};
      localEventManager.registerEventListener(listener, [EVENT_IN_APP_EXIT, 'test_dt_event']);
      AppStorage.delete('powerStatus');

      localEventManager.sendLocalEvent('test_dt_event');
      expect((localEventManager as object)['mEventListenerMap']).not().assertUndefined();
      expect(isCalled).assertTrue();
    })

    it('test_sendLocalEventAsync', DEFAULT, async (done: Function) => {
      await localEventManager.sendLocalEventAsync('dt test any event');
      done();
    })

    it('test_sendLocalEventSticky_if', DEFAULT, async (done: Function) => {
      (localEventManager as object)['mEventListenerMap'] = {};
      AppStorage.set('powerStatus', PowerStatus.SHUTDOWN);
      await localEventManager.sendLocalEventSticky('dt test any event', '');

      AppStorage.set('powerStatus', PowerStatus.REBOOT);
      await localEventManager.sendLocalEventSticky('dt test any event', '');
      expect((localEventManager as object)['mEventListenerMap']).not().assertUndefined();
      AppStorage.delete('powerStatus');
      done();
    })

    it('test_sendLocalEventSticky', DEFAULT, async (done: Function) => {
      (localEventManager as object)['mEventListenerMap'] = {};
      AppStorage.delete('powerStatus');
      await localEventManager.sendLocalEventSticky('dt test any event', '');
      expect((localEventManager as object)['mEventListenerMap']).not().assertUndefined();
      done();
    })
  })
}
