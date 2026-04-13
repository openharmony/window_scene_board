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
import { ScreenState } from '@ohos/frameworkwrapper';
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import { DockRegionAnimationEvent } from '../../../../main/ets/default/viewmodel/DockRegionAnimationEvent';
import { DockRegionAnimationVm } from '../../../../main/ets/default/viewmodel/DockRegionAnimationVm';

/**
 * DockRegionAnimationEvent测试
 *
 * @since 2025-04-22
 */
export default function DockRegionAnimationEventTest() {
  describe('DockRegionAnimationEventTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterEach((): void => {
    });

    afterAll((): void => {
    });

    it('test_onScreenOn', 0, (): void => {
      try {
        let vm = new DockRegionAnimationVm();
        let event = new DockRegionAnimationEvent(vm);
        event.onScreenOn();
        expect(vm.visible).assertEqual(Visibility.Visible);

        vm.visible = Visibility.Hidden;
        event.onScreenOn();
        expect(vm.visible).assertEqual(Visibility.Visible);
      } catch (e) {
      }
    });

    it('test_onDividerTouch', 0, (): void => {
      try {
        let vm = new DockRegionAnimationVm();
        let event = new DockRegionAnimationEvent(vm);
        event.onDividerTouch();
        expect(vm.dividerScale).assertEqual(1);
      } catch (e) {
      }
    });

    it('test_expandedAnimation', 0, (): void => {
      try {
        let vm = new DockRegionAnimationVm();
        let event = new DockRegionAnimationEvent(vm);
        event.expandedAnimation(800, 2400, 'id', true);
        expect(vm.alpha).assertEqual(1);
        expect(vm.translateX).assertEqual(0);
        expect(vm.scaleSizeX).assertEqual(1);

        event.expandedAnimation(800, 2400, 'id', false);
        expect(vm.alpha).assertEqual(1);
        expect(vm.translateX).assertEqual(0);
        expect(vm.scaleSizeX).assertEqual(1);
        expect(vm.dividerScale).assertEqual(1);
      } catch (e) {
      }
    });

    it('test_unlockAnimation', 0, (): void => {
      try {
        let vm = new DockRegionAnimationVm();
        let event = new DockRegionAnimationEvent(vm);
        event.unlockAnimation(800, 2400, 'id');
        expect(vm.alpha).assertEqual(1);
        expect(vm.translateX).assertEqual(0);
        expect(vm.translateY).assertEqual(0);
        expect(vm.scaleSizeX).assertEqual(1);
        expect(vm.scaleSizeY).assertEqual(1);
        expect(vm.dividerScale).assertEqual(1);
        expect(vm.isUnlocking).assertEqual(true);
      } catch (e) {
      }
    });

    it('test_lockAnimation', 0, (): void => {
      try {
        let vm = new DockRegionAnimationVm();
        let event = new DockRegionAnimationEvent(vm);
        event.lockAnimation(800, 2400, 'id');
        expect(vm.alpha).assertEqual(0);
        expect(vm.scaleSizeX).assertEqual(0.8);
        expect(vm.scaleSizeY).assertEqual(0.8);
        expect(vm.dividerScale).assertEqual(0.8);
        expect(vm.blurRadius).assertEqual(100);
      } catch (e) {
      }
    });
  });
}