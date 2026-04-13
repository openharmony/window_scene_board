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

import { ArgumentMatchers, describe, expect, it, MockKit, when } from '@ohos/hypium';
import { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from '@ohos/themeservicekit/src/main/ets/base/Logger';

export default function LoggerTest() {
  describe('LoggerTest', () => {

    it('should_log_error_with_message_and_stack_when_error_is_defined_and_debug_is_true', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockIsDebug: Function = mocker.mockFunc(Logger, Logger.isDebug);
      when(mockIsDebug)(ArgumentMatchers.any).afterReturn(true);
      let error = new Error('testError');
      expect(error.message).assertEqual('testError');
      error.stack = 'testStack';
      Logger.debug('testTag', 'testMessage');
      Logger.info('testTag', 'testMessage');
      Logger.warning('testTag', 'testMessage');
      Logger.error('testTag', 'testMessage', error);
      mocker.ignoreMock(Logger, Logger.isDebug);
      done();
    });

    it('should_log_error_with_message_only_when_error_is_defined_and_debug_is_false', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockIsDebug: Function = mocker.mockFunc(Logger, Logger.isDebug);
      when(mockIsDebug)(ArgumentMatchers.any).afterReturn(false);
      let error = new Error('testError');
      expect(error.message).assertEqual('testError');
      Logger.error('testTag', 'testMessage', error);
      mocker.ignoreMock(Logger, Logger.isDebug);
      done();
    });

    it('should_log_error_with_message_and_code_when_error_is_defined_with_code_and_debug_is_true', 0,
      async (done: Function) => {
        let mocker: MockKit = new MockKit();
        let mockIsDebug: Function = mocker.mockFunc(Logger, Logger.isDebug);
        when(mockIsDebug)(ArgumentMatchers.any).afterReturn(true);
        let error: Error = {
          code: 404, message: 'testError'
        } as BusinessError;
        expect(error.message).assertEqual('testError');
        Logger.error('testTag', 'testMessage', error);
        mocker.ignoreMock(Logger, Logger.isDebug);
        done();
      });

    it('should_log_error_with_message_and_code_when_error_is_defined_with_code_and_debug_is_false', 0,
      async (done: Function) => {
        let mocker: MockKit = new MockKit();
        let mockIsDebug: Function = mocker.mockFunc(Logger, Logger.isDebug);
        when(mockIsDebug)(ArgumentMatchers.any).afterReturn(false);
        let error: Error = {
          code: 404, message: 'testError'
        } as BusinessError;
        expect(error.message).assertEqual('testError');
        Logger.error('testTag', 'testMessage', error);
        mocker.ignoreMock(Logger, Logger.isDebug);
        done();
      });
  });
}