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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import { DockRegionLayoutPropertyVm } from '../../../../main/ets/default/viewmodel/DockRegionLayoutPropertyVm';
import { SmartDockObserver } from '../../../../main/ets/default/viewmodel/smartDockObserver';

export default function SmartDockObserverTest() {
  describe('SmartDockObserverTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterEach((): void => {
    });

    afterAll((): void => {
    });

    it('test_getInstance', 0, (): void => {
      let smartdockobserver: SmartDockObserver = SmartDockObserver.getInstance();
      expect(smartdockobserver.getLayoutPropertyVm().scale).assertEqual(1);
    });

    it('atc_should_return_dockRegionLayoutPropertyVm_when_getLayoutPropertyVm_is_called', 0, () => {
      let smartdockobserver: SmartDockObserver = SmartDockObserver.getInstance();
      let result: DockRegionLayoutPropertyVm = smartdockobserver.getLayoutPropertyVm();
      expect(result.scale).assertEqual(1);
    });
  });
}