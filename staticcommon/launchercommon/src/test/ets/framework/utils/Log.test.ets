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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect } from '@ohos/hypium';
import { Log } from '../../../../../../main/ets/framework/utils/Log';

export function LogTest() {
  describe('LogTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('LogTest_showDebug', 0, (): void => {
      expect(Log.showDebug('test', 'test log')).not().assertFail();
      expect(Log.debug('test')).not().assertFail();
      expect(Log.showDebug('test', 'test log', 'test debug log')).not().assertFail();
      expect(Log.debug('test', 'test debug log')).not().assertFail();
    })
    it('LogTest_showInfo', 0, (): void => {
      expect(Log.showInfo('test', 'test log')).not().assertFail();
      expect(Log.info('test')).not().assertFail();
      expect(Log.showInfo('test', 'test log', 'test info log')).not().assertFail();
      expect(Log.info('test', 'test info log')).not().assertFail();
    })
    it('LogTest_showWarn', 0, (): void => {
      expect(Log.showWarn('test', 'test log')).not().assertFail();
      expect(Log.warn('test')).not().assertFail();
      expect(Log.showWarn('test', 'test log', 'test warn log')).not().assertFail();
      expect(Log.warn('test', 'test warn log')).not().assertFail();
    })
    it('LogTest_showError', 0, (): void => {
      expect(Log.showError('test', 'test log')).not().assertFail();
      expect(Log.error('test')).not().assertFail();
      expect(Log.showError('test', 'test log', 'test error log')).not().assertFail();
      expect(Log.error('test', 'test error log')).not().assertFail();
    })
    it('LogTest_showFatal', 0, (): void => {
      expect(Log.showFatal('test', 'test log')).not().assertFail();
      expect(Log.showFatal('test', 'test log', 'test error log')).not().assertFail();
    })
  })
}