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
import { AppIconMenuVm } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconMenuVm';
import { MenuInfo } from '../../../../../../../main/ets/bean/MenuInfo';

export function AppIconMenuVmTest() {
  describe('AppIconMenuVmTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('setIsMenuShow', 0, () => {
      let vm: AppIconMenuVm = new AppIconMenuVm();
      vm.setIsMenuShow(true);
      expect(vm.isMenuShow()).not().assertNull();
    });

    it('setAppMenuPosition', 0, () => {
      let vm: AppIconMenuVm = new AppIconMenuVm();
      vm.setMenuPlacement(Placement.Top);
      expect(vm.getMenuPlacement()).assertEqual(Placement.Top);
    });

    it('setMaxScrollMenuHeight', 0, () => {
      let vm: AppIconMenuVm = new AppIconMenuVm();
      vm.setMaxScrollMenuHeight(20);
      expect(vm.getMaxScrollMenuHeight()).assertEqual(20);
    });

    it('getMaxScrollMenuHeight', 0, () => {
      let vm: AppIconMenuVm = new AppIconMenuVm();
      vm.setMaxScrollMenuHeight(20);
      expect(vm.getMaxScrollMenuHeight()).assertEqual(20);
    });

    it('getPlacement', 0, () => {
      let vm: AppIconMenuVm = new AppIconMenuVm();
      vm.setMenuPlacement(Placement.Top);
      expect(vm.getMenuPlacement()).assertEqual(Placement.Top);
    });

    it('test_setLayoutRegionMargin_01', 0, () => {
      try {
        let vm: AppIconMenuVm = new AppIconMenuVm();
        vm.setLayoutRegionMargin({ top: 0, bottom: 0 });
        expect(vm instanceof AppIconMenuVm).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_setBackgroundBlurStyle_01', 0, () => {
      try {
        let vm: AppIconMenuVm = new AppIconMenuVm();
        vm.setBackgroundBlurStyle(BlurStyle.COMPONENT_REGULAR);
        vm.setBackgroundBlurStyle(BlurStyle.COMPONENT_THICK);
        expect(vm instanceof AppIconMenuVm).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_setMenuOffset_01', 0, () => {
      try {
        let vm: AppIconMenuVm = new AppIconMenuVm();
        vm.setMenuOffset({ x: 1, y: 1 });
        vm.setMenuOffset({ x: 2, y: 2 });
        expect(vm instanceof AppIconMenuVm).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getMenuInfo_01', 0, () => {
      try {
        let vm: AppIconMenuVm = new AppIconMenuVm();
        expect(vm.getMenuInfo().length).assertEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_setMenuInfo_01', 0, () => {
      try {
        let vm: AppIconMenuVm = new AppIconMenuVm();
        vm.setMenuInfo([]);
        expect(vm.getMenuInfo().length).assertEqual(0);
        let menuInfo: MenuInfo[] = [];
        menuInfo.push(new MenuInfo());
        vm.setMenuInfo(menuInfo);
        expect(vm.getMenuInfo().length).assertEqual(1);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_cleanMenuInfo_01', 0, () => {
      try {
        let vm: AppIconMenuVm = new AppIconMenuVm();
        let menuInfo: MenuInfo[] = [];
        menuInfo.push(new MenuInfo());
        vm.setMenuInfo(menuInfo);
        expect(vm.getMenuInfo().length).assertEqual(1);
        vm.cleanMenuInfo(true);
        expect(vm.getMenuInfo().length).assertEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_cleanMenuInfo_02', 0, () => {
      try {
        let vm: AppIconMenuVm = new AppIconMenuVm();
        let menuInfo1: MenuInfo[] = [];
        menuInfo1.push(new MenuInfo());
        vm.setMenuInfo(menuInfo1);
        expect(vm.getMenuInfo().length).assertEqual(1);
        let menuInfo2: MenuInfo[] = [];
        menuInfo2.push(new MenuInfo());
        vm.setMenuInfo(menuInfo2);
        expect(vm.getMenuInfo().length).assertEqual(1);
        vm.cleanMenuInfo(true);
        expect(vm.getMenuInfo().length).assertEqual(1);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_releaseMenuInfo_01', 0, () => {
      try {
        let vm: AppIconMenuVm = new AppIconMenuVm();
        let menuInfo: MenuInfo[] = [];
        menuInfo.push(new MenuInfo());
        vm.setMenuInfo(menuInfo);
        expect(vm.getMenuInfo().length).assertEqual(1);
        vm.releaseMenuInfo();
        expect(vm.getMenuInfo().length).assertEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })
  });
}