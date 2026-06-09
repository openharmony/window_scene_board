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
  describe,
  expect,
  it,
} from '@ohos/hypium';
import { AppInstallEventData } from '../../../../../../main/ets/appinstall/AppInstallEventData';

export default function AppInstallEventDataTest() {
  describe('AppInstallEventDataTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_eventNam', 0, async () => {
      const instance: AppInstallEventData = new AppInstallEventData();
      let eventName = 'eventName';
      instance.eventName = eventName;
      expect(instance.eventName).assertEqual(eventName);
    });

    it('test_eventNam', 0, async () => {
      const instance: AppInstallEventData = new AppInstallEventData();
      let bundleName = 'bundleName';
      instance.bundleName = bundleName;
      expect(instance.bundleName).assertEqual(bundleName);
    })

    it('test_eventNam', 0, async () => {
      const instance: AppInstallEventData = new AppInstallEventData();
      let appIndex = 0;
      instance.appIndex = appIndex;
      expect(instance.appIndex).assertEqual(appIndex);
    })
  })
}