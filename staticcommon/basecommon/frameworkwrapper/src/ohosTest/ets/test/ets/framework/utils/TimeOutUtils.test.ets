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
import { TimeOutUtils } from '../../../../../../main/ets/utils/TimeOutUtils';

const DEFAULT_TASK_ID: number = -1;
const TIME_OUT_SLEEP: number = 20;
const TIME_DELAY: number = 10;

function sleep(delay: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, delay));
};

export function TimeOutUtilsTest() {
  describe('TimeOutUtilsTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('test_setTimeout_01', DEFAULT, async (): Promise<void> => {
      let isCallBack: boolean = false;
      let callBack = () => {
        isCallBack = true;
      };
      const utils: TimeOutUtils = new TimeOutUtils(TIME_DELAY, callBack);
      utils.setTimeout();
      await sleep(TIME_OUT_SLEEP);
      expect(isCallBack).assertTrue();
    })

    it('test_setTimeout_02', DEFAULT, async (): Promise<void> => {
      let isCallBack: boolean = false;
      let callBack = () => {
        isCallBack = true;
      };
      const utils: TimeOutUtils = new TimeOutUtils(TIME_DELAY, callBack);
      utils.setTimeout(1);
      await sleep(TIME_OUT_SLEEP);
      expect(isCallBack).assertTrue();
    })

    it('test_clearTimeout_01', DEFAULT, (): void => {
      let callBack = () => {
      };
      const utils: TimeOutUtils = new TimeOutUtils(TIME_DELAY, callBack);
      utils.clearTimeout();
      expect((utils as object)['taskId']).assertEqual(DEFAULT_TASK_ID);
    })

    it('test_clearTimeout_02', DEFAULT, async (): Promise<void> => {
      let callBack = () => {
      };
      const utils: TimeOutUtils = new TimeOutUtils(1, callBack);
      utils.setTimeout(1);
      await sleep(TIME_OUT_SLEEP);
      utils.clearTimeout();
      expect((utils as object)['taskId']).assertEqual(DEFAULT_TASK_ID);
    })

    it('test_clearTimeout_03', DEFAULT, async (): Promise<void> => {
      let callBack = () => {
      };
      const utils: TimeOutUtils = new TimeOutUtils(1, callBack);
      (utils as object)['taskId'] = Number.MAX_VALUE;
      utils.clearTimeout();
      expect((utils as object)['taskId']).assertEqual(DEFAULT_TASK_ID);
    })
  })
}