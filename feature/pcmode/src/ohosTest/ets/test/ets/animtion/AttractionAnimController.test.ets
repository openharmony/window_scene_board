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
import {
  describe, beforeEach,
  afterEach,
  afterAll,
  it,
  expect, MockKit,
} from '@ohos/hypium';
import { GlobalContext } from '@ohos/frameworkwrapper';
import context from '@ohos.app.ability.common';
import {
  AttractionAnimController
} from '../../../../../main/ets/animation/AttractionAnimController';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = 'AttractionAnimControllerTest';

export default function AttractionAnimControllerTest() {
  let mocker: MockKit;
  describe('AttractionAnimControllerTest', () => {
    beforeEach(() => {
      mocker = new MockKit();
    });
    afterEach(() => {
    });

    afterAll((): void => {
      hilog.info(0x0000, TAG, 'afterAll all it pass');
    });

    it('getInstanceTest', 0, () => {
      try {
        let instance1 = AttractionAnimController.getInstance();
        let instance2 = AttractionAnimController.getInstance();
        expect(instance1).assertDeepEquals(instance2);
      } catch (e) {
        expect(false).assertFail();
        hilog.info(0x0000, TAG, 'getInstanceTest error' + e);
      }
    });

    it('isAttractionEnabledTest', 0, () => {
      try {
        AttractionAnimController.getInstance().isAttractionEnabled();
      } catch (e) {
        expect(false).assertFail();
        hilog.info(0x0000, TAG, 'isAttractionEnabled error' + e);
      }
    });

    it('unRegisterSettingDataObserverTest', 0, () => {
      try {
        let context = GlobalContext.getInstance().getObject('desktopContext') as context.ServiceExtensionContext;
        AttractionAnimController.getInstance().unRegisterSettingDataObserver();
      } catch (e) {
        expect(false).assertFail();
        hilog.info(0x0000, TAG, 'unRegisterSettingDataObserver error' + e);
      }
    });

    it('registerStateChangeCallbackTest', 0, () => {
      try {
        let callback: (isAttractionEffect: boolean) => void = () => {
        };
        let screenId = 0;
        AttractionAnimController.getInstance().registerStateChangeCallback(screenId, callback);
      } catch (e) {
        expect(false).assertFail();
        hilog.info(0x0000, TAG, 'registerStateChangeCallback error' + e);
      }
    });

    it('getAttractionEffectTest', 0, () => {
      try {
        let instance = AttractionAnimController.getInstance();
        let result1: string = (instance as object)['getAttractionEffect']();
        let result2: string = (instance as object)['getAttractionEffect']();
        expect(result1).assertDeepEquals(result2);
      } catch (e) {
        expect(false).assertFail();
        hilog.info(0x0000, TAG, 'getAttractionEffect error' + e);
      }
    });

    it('settingDataChangedTest', 0, () => {
      try {
        (AttractionAnimController as object)['settingDataChanged']();
      } catch (e) {
        expect(false).assertFail();
        hilog.info(0x0000, TAG, 'getAttractionEffect error' + e);
      }
    });
  });
}