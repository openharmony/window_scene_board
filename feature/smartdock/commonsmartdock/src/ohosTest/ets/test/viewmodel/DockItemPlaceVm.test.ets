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
import { DragItemPlaceVm } from '../../../../main/ets/default/viewmodel/DragItemPlaceVm';

/**
 * DockItemPlaceVm测试
 *
 * @since 2025-04-22
 */
export default function DockItemPlaceVmTest() {
  describe('DockItemPlaceVmTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterEach((): void => {
    });

    afterAll((): void => {
    });

    it('test_refreshVisibility', 0, (): void => {
      let vm = new DragItemPlaceVm();
      vm.opacity = 1;

      vm.refreshVisibility(true);

      vm.refreshVisibility(false);
      expect(vm.opacity).assertEqual(0);
    });

    it('test_onDockHolderIndexChange', 0, (): void => {
      let vm = new DragItemPlaceVm();
      vm.onDockHolderIndexChange(20, -10, false, false);
      expect(vm.opacity).assertEqual(0);
      expect(vm.translateX).assertEqual(0);

      vm = new DragItemPlaceVm();
      vm.onDockHolderIndexChange(20, 10, false, true);
      expect(vm.opacity).assertEqual(0);
      expect(vm.translateX).assertEqual(0);

      vm = new DragItemPlaceVm();
      vm.onDockHolderIndexChange(10, 10, true, true);
      expect(vm.opacity).assertEqual(1);
      expect(vm.translateX).assertEqual(0);

      vm = new DragItemPlaceVm();
      vm.onDockHolderIndexChange(20, 10, true, true);
      expect(vm.opacity).assertEqual(1);
      expect(vm.translateX).assertEqual(10);

      vm = new DragItemPlaceVm();
      vm.opacity = 1;
      vm.onDockHolderIndexChange(20, 10, false, false);
      expect(vm.opacity).assertEqual(0);
    });
  });
}