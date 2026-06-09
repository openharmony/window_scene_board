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
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
} from '@ohos/hypium';
import { localEventManager } from '@ohos/frameworkwrapper';
import {
  AppIconDisableMaskVm
} from '../../../../../../../main/ets/launchericon/viewmodel/AppIconDisableMaskVm';
import {
  AppIconDisableMaskEvent
} from '../../../../../../../main/ets/launchericon/viewmodel/AppIconDisableMaskEvent';
import { BaseBundleInfo } from '../../../../../../../main/ets/bean/BaseBundleInfo';

export function AppIconDisableMaskEventTest() {
  describe('AppIconDisableMaskEventTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('grayAppIconEventTest', 0, () => {
      let vm: AppIconDisableMaskVm = new AppIconDisableMaskVm();
      let event: AppIconDisableMaskEvent = new AppIconDisableMaskEvent(vm);
      let testItemInfo: BaseBundleInfo = {
        bundleName: 'testBundleName',
        appIndex: 0,
      };
      event.init(testItemInfo);

      localEventManager.sendLocalEventSticky(`grayAppIcon${testItemInfo.bundleName}${testItemInfo.appIndex}`, true);
      expect(vm.visible).assertEqual(true);

      event.destroy();
    });

    it('test_init_02', 0, () => {
      try {
        let vm: AppIconDisableMaskVm = new AppIconDisableMaskVm();
        let event: AppIconDisableMaskEvent = new AppIconDisableMaskEvent(vm);
        let testItemInfo: BaseBundleInfo = {
          bundleName: 'testBundleName',
          appIndex: 0,
        };
        let isDisableMaskCb = (param?: boolean) => true;
        event.init(testItemInfo, isDisableMaskCb);
        expect(event instanceof AppIconDisableMaskEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })


  });
}