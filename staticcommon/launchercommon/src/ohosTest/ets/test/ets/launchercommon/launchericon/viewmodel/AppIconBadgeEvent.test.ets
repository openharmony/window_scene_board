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
import { AppItemInfo } from '../../../../../../../main/ets/bean/AppItemInfo';
import {
  AppIconBadgeEvent
} from '../../../../../../../main/ets/launchericon/viewmodel/AppIconBadgeEvent';
import { AppIconBadgeVm } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconBadgeVm';
import { AppStatus } from '../../../../../../../main/ets/TsIndex';

export function AppIconBadgeEventTest() {
  describe('AppIconBadgeEventTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('init_app_status', 0, () => {
      let vm: AppIconBadgeVm = new AppIconBadgeVm();
      vm.badgeNumber = 1;
      let event: AppIconBadgeEvent = new AppIconBadgeEvent(vm);
      let itemInfo: AppItemInfo = new AppItemInfo();
      itemInfo.appStatus = AppStatus.INSTALLED;
      itemInfo.appIndex = undefined;
      event.init(itemInfo);
      expect(vm.modifier.onInit).not().assertNull();
      event.destroy();
    });

    it('onActive_false', 0, () => {
      let vm: AppIconBadgeVm = new AppIconBadgeVm();
      let event: AppIconBadgeEvent = new AppIconBadgeEvent(vm);
      let itemInfo: AppItemInfo = new AppItemInfo();
      event.init(itemInfo);
      vm.badgeNumber = 0;
      event.onActive(true);
      expect(vm.visible).assertEqual(true);

      vm.badgeNumber = 10;
      event.onActive(true);
      expect(vm.visible).assertEqual(false);

      event.onActive(false);
      expect(vm.visible).assertEqual(true);
    });

    it('onIconScale', 0, () => {
      let vm: AppIconBadgeVm = new AppIconBadgeVm();
      let event: AppIconBadgeEvent = new AppIconBadgeEvent(vm);
      let itemInfo: AppItemInfo = new AppItemInfo();

      event.init(itemInfo);
      event.onIconScale(1, 70);

      vm.visible = true;
      vm.badgeNumber = 10;
      event.onIconScale(1, 70);

      event.onIconScale(0.9, 70);
      let a = 'test';
      expect(a).assertEqual('test');
    });

    it('localEventTest', 0, () => {
      let vm: AppIconBadgeVm = new AppIconBadgeVm();
      let event: AppIconBadgeEvent = new AppIconBadgeEvent(vm);
      let itemInfo: AppItemInfo = new AppItemInfo();
      itemInfo.appStatus = AppStatus.INSTALLED;

      event.init(itemInfo);
      localEventManager.sendLocalEventSticky(`badgeUpdate${itemInfo.bundleName}0`, 1);
      expect(vm.badgeNumber).assertEqual(1);
      event.destroy();
    });

    it('localEventTest', 1, () => {
      let vm: AppIconBadgeVm = new AppIconBadgeVm();
      vm.isUpdateSuperposeBadge = false;
      let event: AppIconBadgeEvent = new AppIconBadgeEvent(vm);
      let itemInfo: AppItemInfo = new AppItemInfo();
      itemInfo.appStatus = AppStatus.INSTALLED;

      event.init(itemInfo);
      localEventManager.sendLocalEventSticky(`badgeUpdate${itemInfo.bundleName}0`, 1);
      expect(vm.badgeNumber).assertEqual(0);
      event.destroy();
    })
  });
}