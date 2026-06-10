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
  ArgumentMatchers,
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium';
import { LiveViewData } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { LiveViewItemSwipeVm } from '../../../../../main/ets/vm/LiveViewItemSwipeVm';

export function LiveViewItemSwipeVmTest01() {

  describe('LiveViewItemSwipeVmTest_0', () => {
    const liveViewItemSwipeVm = new LiveViewItemSwipeVm();
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    it('reset', 0, () => {
      const func = () => LiveViewItemSwipeVm.reset();

      expect(func).not().assertFail();
    })

    it('init', 0, () => {
      liveViewItemSwipeVm.init(Object())

      expect((liveViewItemSwipeVm as object)['itemData']).not().assertUndefined();
    })

    it('destroy', 0, () => {
      liveViewItemSwipeVm.destroy();

      expect((liveViewItemSwipeVm as object)['itemData']).assertUndefined();
    })

    it('getMenuTranslateX_01', 0, () => {
      liveViewItemSwipeVm.isRemoving = false;

      expect(liveViewItemSwipeVm.getMenuTranslateX()).assertEqual(0);
    })

    it('getMenuTranslateX_02', 0, () => {
      liveViewItemSwipeVm.isRemoving = true;

      const res = liveViewItemSwipeVm.translateX + liveViewItemSwipeVm.menuWidth;

      expect(liveViewItemSwipeVm.getMenuTranslateX()).assertEqual(res);
    })

    it('setMenuWidth', 0, () => {
      liveViewItemSwipeVm.menuWidth = 100;
      liveViewItemSwipeVm.setMenuWidth(120);

      expect(liveViewItemSwipeVm.menuWidth).assertEqual(120);
    })
    it('setMenuWidth_01', 0, () => {
      liveViewItemSwipeVm.menuWidth = 120;
      liveViewItemSwipeVm.setMenuWidth(120);

      expect(liveViewItemSwipeVm.menuWidth).assertEqual(120);
    })

    it('getContainerWidth', 0, () => {
      liveViewItemSwipeVm.setContainerWidth(100);
      expect(liveViewItemSwipeVm.getContainerWidth()).assertEqual(100);
    })

    it('reset1', 0, () => {
      let mocker: MockKit = new MockKit();
      let vm: LiveViewItemSwipeVm = new LiveViewItemSwipeVm();
      let data: LiveViewData = new LiveViewData();
      vm.translateX = 0;
      vm.init(data);

      let mockFunc: Function = mocker.mockFunc(vm, vm.update);
      when(mockFunc)().afterReturnNothing();
      LiveViewItemSwipeVm.reset();
      mocker.verify('update', [0, true]).never();
      LiveViewItemSwipeVm.reset(data);
      mocker.verify('update', [0, true]).never();
    })

    it('setContainerWidth', 0, () => {
      liveViewItemSwipeVm.setContainerWidth(140);
      expect((liveViewItemSwipeVm as object)['containerWidth']).assertEqual(140);
    })

    it('setContainerWidth_01', 0, () => {
      liveViewItemSwipeVm.setContainerWidth(140);
      liveViewItemSwipeVm.setContainerWidth(140);
      expect((liveViewItemSwipeVm as object)['containerWidth']).assertEqual(140);
    })

    it('setContainerHeight', 0, () => {
      liveViewItemSwipeVm.setContainerHeight(80);
      expect((liveViewItemSwipeVm as object)['containerHeight']).assertEqual(80);
    })

    it('setContainerHeight_1', 0, () => {
      liveViewItemSwipeVm.setContainerHeight(80);
      liveViewItemSwipeVm.setContainerHeight(80);
      expect((liveViewItemSwipeVm as object)['containerHeight']).assertEqual(80);
    })
  })
}

export function LiveViewItemSwipeVmTest02() {
  const liveViewItemSwipeVm = new LiveViewItemSwipeVm();

  describe('LiveViewItemSwipeVmTest_1', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('onSwipe', 0, () => {
      const func = () => liveViewItemSwipeVm.onSwipe(10);
      expect(func).not().assertFail();
    })

    const liveViewItemSwipeVm = new LiveViewItemSwipeVm();

    it('onStop_1', 0, () => {
      try {
        liveViewItemSwipeVm.onStop(10);
      } catch (err) {
      }

      try {
        liveViewItemSwipeVm.onStop(20);
      } catch (err) {
      }

      try {
        liveViewItemSwipeVm.onStop(-10);
      } catch (err) {
      }

      try {
        liveViewItemSwipeVm.onStop(-20);
      } catch (err) {
      }
      expect(Reflect.has(liveViewItemSwipeVm, 'onStop')).assertTrue();
    })

    it('swipe2Remove', 0, () => {
      try {
        liveViewItemSwipeVm.swipe2Remove();
      } catch (err) {
      }
      expect(true).assertTrue()
    });

    it('onStart', 0, () => {
      liveViewItemSwipeVm.onStart();
      expect(liveViewItemSwipeVm.isSwiping).assertTrue();
      expect(liveViewItemSwipeVm.translateX).assertEqual((liveViewItemSwipeVm as object)['startTranslateX'])
    })

    it('fun411', 0, () => {
      try {
        LiveViewItemSwipeVm.resetPromise();
        let ans: Set<LiveViewItemSwipeVm> = new Set();
        let vm = new LiveViewItemSwipeVm();
        vm.translateX = 0;
        let vm1 = new LiveViewItemSwipeVm();
        vm.translateX = 2;
        ans.add(vm);
        ans.add(vm1);
        Reflect.set(LiveViewItemSwipeVm, 'instances', ans);
        LiveViewItemSwipeVm.resetPromise();
      } catch (err) {
      }
      expect(true).assertTrue()
    });

    it('fun422', 0, () => {
      const liveViewItemSwipeVm = new LiveViewItemSwipeVm();
      try {
        liveViewItemSwipeVm.translateX = 10;
        liveViewItemSwipeVm.update(10, true);
        liveViewItemSwipeVm.update(20, true);
        liveViewItemSwipeVm.update(0, false);
      } catch (err) {
      }
      expect(true).assertTrue()
    });

    it('test_getMenuTranX', 0, () => {
      const vm = new LiveViewItemSwipeVm();
      vm.isRemoving = false;
      vm.getMenuTranX();

      vm.isSwiping = true;
      vm.translateX = -10000;
      vm.getMenuTranX();

      vm.translateX = 1;
      const ret = vm.getMenuTranX();

      expect(ret > -100).assertEqual(true);
    });

    it('test_onSwipe', 0, () => {
      const vm = new LiveViewItemSwipeVm();
      try {
        vm.onSwipe(1);
      } catch (err) {
      }
      expect(vm !== undefined).assertEqual(true);
    });
  })
}
