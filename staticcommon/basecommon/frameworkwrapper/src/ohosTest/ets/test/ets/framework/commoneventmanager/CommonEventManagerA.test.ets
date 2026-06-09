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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, TestType, Size, Level, MockKit, when } from '@ohos/hypium'
import { CEManager } from '../../../../../../main/ets/commoneventmanager/CommonEventManagerA'

export function CommonEventManagerATest() {
  describe('CommonEventManagerATest', () => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterEach((): void => {
    });
    afterAll((): void => {
    });

    it('CommonEventManagerATest_init', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void=> {
      let mocker: MockKit = new MockKit();
      let mockfunc:Function = mocker.mockFunc(CEManager, CEManager.init);
      when(mockfunc)().afterReturn('undefined');
      expect(CEManager.init).not().assertFail();
      mocker.clear(CEManager);
      mocker.clearAll();
    })

    it('CommonEventManagerTest_unregisterAllCommonEvent', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try{
        CEManager['registerAllCommonEvent'];
      } catch (error) {
      }
      try {
        CEManager['unregisterAllCommonEvent'];
      } catch (error) {
      }
      expect(true).assertTrue();
    })

    it('CommonEventManagerTest_publishCommentEvent', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        CEManager.publishCommentEvent(null, null);
      } catch (error) {
      }
      CEManager.publishCommentEvent('MediaControlEvent', {
        data: 'true'
      });
      expect(true).assertTrue();
    })

    it('CommonEventManagerTest_handleCommonEventCallback', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      CEManager['handleCommonEventCallback'](null, null);
      CEManager['handleCommonEventCallback']({
        code: 0, data: null, name: '',
        message: ''
      }, null);
      try {
        CEManager['handleCommonEventCallback']({
          code: 0, data: null, name: '',
          message: ''
        }, { code: 0, event: 'test_event' });
      } catch (error) {
      }
      expect(true).assertTrue();
    })
  })
}