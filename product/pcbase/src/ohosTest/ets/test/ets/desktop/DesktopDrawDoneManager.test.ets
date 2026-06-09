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
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium'
import DesktopDrawDoneManager from '../../../../../../../pcbase/src/main/ets/desktop/DesktopDrawDoneManager';

export default function DesktopDrawDoneManagerTest() {
  describe('DesktopDrawDoneManagerTest', () => {
    let mocker: MockKit;
    let desktopDrawDoneManager: DesktopDrawDoneManager;
    beforeAll(() => {
    })
    beforeEach(() => {
      desktopDrawDoneManager = new DesktopDrawDoneManager('componentId');
      mocker = new MockKit();
    })
    afterEach(() => {
    })
    afterAll(() => {
      mocker.clearAll();
    })
    it('registerComponentDrawObserverTest', 0, () => {
      desktopDrawDoneManager.registerComponentDrawObserver()
      expect(desktopDrawDoneManager instanceof DesktopDrawDoneManager).assertTrue();
    })
  })
}