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
import { LiveViewEntryEvent,
  LiveViewCapsuleEntryEvent,
  LiveViewFormEntryEvent,
  LiveViewPluginEvent,
  LiveTimeoutEvent,
} from '../../../../../main/ets/event/LiveViewEvent';

export function LiveViewEventTest() {
  describe('LiveViewEventTest', (): void => {
    it('test_initLiveViewEntryEvent', 0, (): void => {
      let testInstance: LiveViewEntryEvent = new LiveViewEntryEvent();
      expect(testInstance instanceof LiveViewEntryEvent).assertTrue();
    });
    it('test_initLiveViewCapsuleEntryEvent', 0, (): void => {
      let testInstance: LiveViewCapsuleEntryEvent = new LiveViewCapsuleEntryEvent();
      expect(testInstance instanceof LiveViewCapsuleEntryEvent).assertTrue();
    });

    it('test_initLiveViewFormEntryEvent', 0, (): void => {
      let testInstance: LiveViewFormEntryEvent = new LiveViewFormEntryEvent();
      expect(testInstance instanceof LiveViewFormEntryEvent).assertTrue();
    });
    it('test_initLiveViewPluginEvent', 0, (): void => {
      let testInstance: LiveViewPluginEvent = new LiveViewPluginEvent();
      expect(testInstance instanceof LiveViewPluginEvent).assertTrue();
    });

    it('test_initLiveTimeoutEvent', 0, (): void => {
      let testInstance: LiveTimeoutEvent = new LiveTimeoutEvent();
      expect(testInstance instanceof LiveTimeoutEvent).assertTrue();
    });
  });
}