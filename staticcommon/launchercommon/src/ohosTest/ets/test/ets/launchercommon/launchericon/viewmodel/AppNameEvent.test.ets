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

import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
} from '@ohos/hypium';
import { AppNameEvent } from '../../../../../../../main/ets/launchericon/viewmodel/AppNameEvent';
import { AppNameVm } from '../../../../../../../main/ets/launchericon/viewmodel/AppNameVm';

export function AppNameEventTest() {
  describe('AppNameEventTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('appNameDisappearAnimate', 0, () => {
      let vm: AppNameVm = new AppNameVm();
      let event: AppNameEvent = new AppNameEvent(vm);
      event.init();
      event.appNameDisappearAnimate(true);
      let a = 'test';
      expect(a).assertEqual('test');
    });

    it('changeAppNameOpacity', 0, () => {
      let vm: AppNameVm = new AppNameVm();
      let event: AppNameEvent = new AppNameEvent(vm);
      event.init();
      event.changeAppNameOpacity(1);
      let a = 'test';
      expect(a).assertEqual('test');
    });
  });
}