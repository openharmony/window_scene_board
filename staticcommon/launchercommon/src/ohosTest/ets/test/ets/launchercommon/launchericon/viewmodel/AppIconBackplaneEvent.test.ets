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
import type abilityCommon from '@ohos.app.ability.common';
import { GlobalContext } from '@ohos/frameworkwrapper';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
} from '@ohos/hypium';
import { AppIconBackplaneEvent } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconBackplaneEvent';
import { AppIconBackplaneVm } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconBackplaneVm';
import { CommonConstants } from '../../../../../../../main/ets/constants/CommonConstants';

export function AppIconBackplaneEventTest() {
  describe('AppIconBackplaneEventTest', () => {
    beforeAll(() => {
      GlobalContext.setContext(globalThis.getContext() as abilityCommon.ServiceExtensionContext);
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('coveredAppTest', 0, () => {
      let vm: AppIconBackplaneVm = new AppIconBackplaneVm();
      let event: AppIconBackplaneEvent = new AppIconBackplaneEvent(vm);
      let isOpen: boolean = false;
      let keyName: string = 'anyKeyName';
      let func = (value: boolean): void => {
        isOpen = value;
      };

      event.init(keyName, func);

      AppStorage.set<number>('dragItemType', 100);
      GlobalContext.getContext()?.eventHub.emit(`coveredApp${keyName}`, true);
      expect(isOpen).assertFalse();

      AppStorage.set<number>('dragItemType', CommonConstants.DRAG_FROM_DESKTOP);
      GlobalContext.getContext()?.eventHub.emit(`coveredApp${keyName}`, true);
      expect(isOpen).assertTrue();
      expect(vm.visible).assertTrue();

      GlobalContext.getContext()?.eventHub.emit(`coveredApp${keyName}`, false);
      expect(isOpen).assertFalse();

      event.destroy();
    });
  });
}