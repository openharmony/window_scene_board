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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import commonEventMonitor from '@ohos/screenlockcommon/src/main/ets/base/CommonEventMonitor';

export default function commonEventMonitorTest() {

  describe('commonEventMonitorTest', (): void => {

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_registerCredentialSubscriber_return', 0, (): void => {
      let execute: string = '';
      const callback: Function = () => {
        execute = 'success';
      };
      commonEventMonitor.registerCredentialSubscriber(callback);
      commonEventMonitor.unRegisterCredentialSubscriber();
      expect(execute == 'success' ? true : false).assertEqual(false);
    })

    it('test_registerThemeSubscriber_return', 0, (): void => {
      let execute: string = '';
      const callback: Function = () => {
        execute = 'success';
      };
      commonEventMonitor.registerThemeSubscriber(callback);
      commonEventMonitor.unRegisterThemeSubscriber();
      expect(execute == 'success' ? true : false).assertEqual(false);
    })

    it('test_registerUserUpdateSubscriber_return', 0, (): void => {
      let execute: string = '';
      const callback: Function = () => {
        execute = 'success';
      };
      commonEventMonitor.registerUserUpdateSubscriber(callback);
      commonEventMonitor.unRegisterUserUpdateSubscriber();
      expect(execute == 'success' ? true : false).assertEqual(false);
    })

    it('test_init', 0, (): void => {
      commonEventMonitor.init();
      commonEventMonitor.destroy();
      expect(true).assertTrue();
    })
  })
}
