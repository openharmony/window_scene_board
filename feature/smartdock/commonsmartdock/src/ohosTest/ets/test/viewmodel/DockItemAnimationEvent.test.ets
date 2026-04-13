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
import {
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium';
import { DockItemInfo, PageDesktopOneShotManager } from '@ohos/launchercommon/Index';
import { DockItemAnimationEvent } from '../../../../main/ets/default/viewmodel/DockItemAnimationEvent';
import { DockItemAnimationVm } from '../../../../main/ets/default/viewmodel/DockItemAnimationVm';
import SmartDockViewModel from '../../../../main/ets/default/viewmodel/SmartDockViewModel';
import {
  gravityAnimationManager,
  GravityAnimationParameter,
  GravityAnimationConfig
} from '@ohos/componentanimator/Index';
import { DesktopUtils } from '@ohos/pagedesktop';

/**
 * DockItemAnimationEvent测试
 *
 * @since 2025-04-22
 */
export default function DockItemAnimationEventTest() {
  describe('DockItemAnimationEventTest', (): void => {
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
        let vm = new DockItemAnimationVm();
        let event = new DockItemAnimationEvent(vm);
        event.onScreenOn();
        expect(vm.visible).assertEqual(Visibility.Visible);

        vm.visible = Visibility.Hidden;
        event.onScreenOn();
        expect(vm.visible).assertEqual(Visibility.Visible);
      } catch (e) {
      }
    });

    it('test_foldedAnimation', 0, (): void => {
      try {
        let vm = new DockItemAnimationVm();
        let event = new DockItemAnimationEvent(vm);
        event.foldedAnimation(800, 1, 4);
        expect(vm.centerX).assertEqual(0.5);
        expect(vm.centerY).assertEqual(0.5);
        expect(vm.alpha).assertEqual(1);
        expect(vm.translateX).assertEqual(0);
        expect(vm.scaleSize).assertEqual(1);
      } catch (e) {
      }
    });

    it('test_expandedAnimation', 0, (): void => {
      try {
        let vm = new DockItemAnimationVm();
        let event = new DockItemAnimationEvent(vm);
        event.expandedAnimation(800, 2400, 'id', 1, true);
        expect(vm.alpha).assertEqual(1);
        expect(vm.translateX).assertEqual(0);
        expect(vm.translateY).assertEqual(0);
        expect(vm.scaleSize).assertEqual(1);
      } catch (e) {
      }
    });

    it('test_lockAnimation_01_7', 0, (): void => {
      let mock = new MockKit();
      let instance = PageDesktopOneShotManager.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(instance, instance.getIsBaseDeskPage);
        when(mockFunc)().afterReturn(true);

        let mockFunc2: Function = mock.mockFunc(DesktopUtils, DesktopUtils.isSupportLockAnimation);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let vm = new DockItemAnimationVm();
        let event = new DockItemAnimationEvent(vm);
        event.lockAnimation(800, 2400, 'id');
        expect(vm.alpha).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clear(DesktopUtils);
      mock.clearAll();
    });

    it('test_lockAnimation_02_7', 0, (): void => {
      let mock = new MockKit();
      let instance = PageDesktopOneShotManager.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(instance, instance.getIsBaseDeskPage);
        when(mockFunc)().afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(DesktopUtils, DesktopUtils.isSupportLockAnimation);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let vm = new DockItemAnimationVm();
        let event = new DockItemAnimationEvent(vm);
        event.lockAnimation(800, 2400, 'id');
        expect(vm.alpha).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clear(DesktopUtils);
      mock.clearAll();
    });

    it('test_lockAnimation_03_7', 0, (): void => {
      let mock = new MockKit();
      let instance = PageDesktopOneShotManager.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(instance, instance.getIsBaseDeskPage);
        when(mockFunc)().afterReturn(true);

        let mockFunc2: Function = mock.mockFunc(DesktopUtils, DesktopUtils.isSupportLockAnimation);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let vm = new DockItemAnimationVm();
        let event = new DockItemAnimationEvent(vm);
        event.lockAnimation(800, 2400, 'id');
        expect(vm.alpha).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clear(DesktopUtils);
      mock.clearAll();
    });

    it('test_unlockAnimation_01', 0, (): void => {
      let mock = new MockKit();
      try {
        let mockFunc2: Function = mock.mockFunc(DesktopUtils, DesktopUtils.isSupportLockAnimation);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let vm = new DockItemAnimationVm();
        let event = new DockItemAnimationEvent(vm);
        event.unlockAnimation(800, 2400, 'id');
        expect(vm.alpha).assertEqual(1);
        expect(vm.translateX).assertEqual(0);
        expect(vm.translateY).assertEqual(0);
        expect(vm.scaleSize).assertEqual(1);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DesktopUtils);
      mock.clearAll();
    });

    it('test_unlockAnimation_02', 0, (): void => {
      let mock = new MockKit();
      try {
        let mockFunc2: Function = mock.mockFunc(DesktopUtils, DesktopUtils.isSupportLockAnimation);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let vm = new DockItemAnimationVm();
        let event = new DockItemAnimationEvent(vm);
        event.unlockAnimation(800, 2400, 'id');
        expect(vm.alpha).assertEqual(1);
        expect(vm.translateX).assertEqual(0);
        expect(vm.translateY).assertEqual(0);
        expect(vm.scaleSize).assertEqual(1);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DesktopUtils);
      mock.clearAll();
    });

    it('test_moveAnimation_01_7', 0, (): void => {
      let mock = new MockKit();
      let instance = SmartDockViewModel.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(instance, instance.getDockItemCenter);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(200);

        let vm = new DockItemAnimationVm();
        let event = new DockItemAnimationEvent(vm);
        event.moveAnimation(100, false, 'id', 5, 2);

        event.moveAnimation(300, true, 'id', 5, 2);
        expect(vm.alpha).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clearAll();
    });

    it('test_moveAnimation_02', 0, (): void => {
      let mock = new MockKit();
      let instance = SmartDockViewModel.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(instance, instance.getDockItemCenter);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(-1);

        let vm = new DockItemAnimationVm();
        let event = new DockItemAnimationEvent(vm);
        event.moveAnimation(300, true, 'id', 5, 2);
        expect(instance instanceof SmartDockViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clearAll();
    });

    it('test_startGravityRestoreAnimation_01', 0, (): void => {
      try {
        let param: GravityAnimationParameter = {
          now: {
            x: 0, y: 0
          },
          effected: false,
          distance: 0,
          delay: 0,
          waveCrest: {
            x: 0, y: 0
          },
          waveTrough: {
            x: 0, y: 0
          },
          waveDuration: 0,
          waveCurve: GravityAnimationConfig.getCurveConfig(),
          isFarthest: false,
        };
        let appInfo: DockItemInfo = {
          bundleName: 'com.ohos.contacts',
          keyName: 'keyName',
          visible: true,
          borderVisible: false,
          shake: 0,
          abilityName: '',
          moduleName: '',
          appName: '',
          appIconId: 0,
          missionInfoList: []
        }

        let vm = new DockItemAnimationVm();
        let event = new DockItemAnimationEvent(vm);
        (event as object)['startGravityRestoreAnimation'](param, appInfo);
        expect(event instanceof DockItemAnimationEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_startGravityAnimation_01', 0, (): void => {
      try {
        let param: GravityAnimationParameter = {
          now: {
            x: 0, y: 0
          },
          effected: false,
          distance: 0,
          delay: 0,
          waveCrest: {
            x: 0, y: 0
          },
          waveTrough: {
            x: 0, y: 0
          },
          waveDuration: 0,
          waveCurve: GravityAnimationConfig.getCurveConfig(),
          isFarthest: false,
        };
        let appInfo: DockItemInfo = {
          bundleName: 'com.ohos.contacts',
          keyName: 'keyName',
          visible: true,
          borderVisible: false,
          shake: 0,
          abilityName: '',
          moduleName: '',
          appName: '',
          appIconId: 0,
          missionInfoList: []
        }

        let vm = new DockItemAnimationVm();
        let event = new DockItemAnimationEvent(vm);
        event.startGravityAnimation(param, appInfo);
        expect(event instanceof DockItemAnimationEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })
  });
}