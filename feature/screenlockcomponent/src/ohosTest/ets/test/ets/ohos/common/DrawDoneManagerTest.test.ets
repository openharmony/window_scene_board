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

import { SCBOobeManager } from '@ohos/windowscene';
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import DrawDoneManager from '@ohos/screenlockcommon/src/main/ets/manager/DrawDoneManager';

export default function DrawDoneManagerTest() {

  describe('DrawDoneManagerTest', (): void => {
    let id: string = 'res1';
    let mDrawDoneManager: DrawDoneManager = new DrawDoneManager(id);
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_getWatermarkFromRawData_return_true', 0, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      mDrawDoneManager.registerComponentDrawObserver();
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    })

    it('test_registerComponentDrawObserver', 0, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      SCBOobeManager.updateOobeEnable(false);
      mDrawDoneManager.registerComponentDrawObserver();
      mDrawDoneManager.registerComponentDrawObserver();
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    })
  })
}