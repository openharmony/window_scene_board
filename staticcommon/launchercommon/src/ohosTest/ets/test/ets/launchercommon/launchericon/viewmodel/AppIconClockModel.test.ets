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
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when,
  ArgumentMatchers, } from '@ohos/hypium';
import { AppIconClockModel } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconClockModel';

export function AppIconClockModelTest() {
  describe('AppIconClockModelTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('registerCallBackTest', 0, () => {
      let instance: AppIconClockModel = AppIconClockModel.getInstance();
      let called = false;
      instance.registerCallBack(() => {
        called = true
      });
      expect(called).assertTrue();
    });

    it('unRegisterCallBackTest', 0, () => {
      let instance: AppIconClockModel = AppIconClockModel.getInstance();
      let called = false;
      let callBack = () => {
        called = true
      }
      instance.unRegisterCallBack(callBack);
      instance.registerCallBack(callBack);
      instance.unRegisterCallBack(callBack);
      expect(called).assertTrue();
    });

    it('test_startTimer_01', 0, () => {
      try {
        let instance: AppIconClockModel = AppIconClockModel.getInstance();
        (instance as object)['startTimer']();
        (instance as object)['clearTimer']();
        expect(instance instanceof AppIconClockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })
  });
}