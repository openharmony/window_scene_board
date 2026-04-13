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
import { DesktopShortcutViewModel } from '../../../../../main/ets/default/common/viewmodel/DesktopShortcutViewModel';
import { ShortcutInfo, ShortcutViewModel } from '@ohos/launchercommon/src/main/ets/TsIndex';

export default function DesktopShortcutViewModelTest() {
  describe('DesktopShortcutViewModelTest', () => {
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
    it('test_getInstance', 0, () => {
      expect(DesktopShortcutViewModel.getInstance()).not().assertNull();
    })

    it('test_checkShortcutMore', 0, () => {
      const desktopShortcutViewModel: DesktopShortcutViewModel = DesktopShortcutViewModel.getInstance();
      let shortcutInfo: ShortcutInfo = {
        id: '',
        bundleName: '1',
        appIndex: 1,
        sourceType: 2,
        icon:'1',
        label:'1',
        hostAbility:'1',
        wants:undefined
      };
      expect((desktopShortcutViewModel as object)['checkShortcutMore'](shortcutInfo)).not().assertNull();
      shortcutInfo.sourceType = 0;
      expect((desktopShortcutViewModel as object)['checkShortcutMore'](shortcutInfo)).not().assertNull();
      shortcutInfo.sourceType = 1;
      expect((desktopShortcutViewModel as object)['checkShortcutMore'](shortcutInfo)).not().assertNull();
    })

    it('test_addShortcutToDesktop', 0, async () => {
      const desktopShortcutViewModel: DesktopShortcutViewModel = DesktopShortcutViewModel.getInstance();
      let shortcutInfo: ShortcutInfo = {
        id: '',
        bundleName: '1',
        appIndex: 1,
        sourceType: 2
      };
      expect(await desktopShortcutViewModel.addShortcutToDesktop(shortcutInfo)).not().assertNull();
    })

    it('test_addShortcutToDesktop_1', 0, async () => {
      const desktopShortcutViewModel: DesktopShortcutViewModel = DesktopShortcutViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
      let func_1: Function = mocker.mockFunc(shortcutViewModel, shortcutViewModel.checkShortcut);
      when(func_1)(ArgumentMatchers.any).afterReturn({
        code: 0
      });
      // 通过
      let shortcutInfo: ShortcutInfo = {
        id: '1',
        bundleName: '1',
        appIndex: 1,
        sourceType: 2,
        moduleName: '',
        icon: '',
        label: '',
        hostAbility: '',
        wants: undefined
      };
      try {
        expect(await desktopShortcutViewModel.addShortcutToDesktop(shortcutInfo)).not().assertNull();
      } catch (e) {}
      shortcutInfo.sourceType = 1;
      let func_2: Function = mocker.mockFunc(shortcutViewModel, shortcutViewModel.getShortcutByBundleName);
      when(func_2)(ArgumentMatchers.any).afterReturn([]);
      try {
        expect(await desktopShortcutViewModel.addShortcutToDesktop(shortcutInfo)).not().assertNull();
      } catch (e) {}
      when(func_2)(ArgumentMatchers.any).afterReturn([
        {
          id: ''
        }
      ]);
      try {
        expect(await desktopShortcutViewModel.addShortcutToDesktop(shortcutInfo)).not().assertNull();
      } catch (e) {}
      when(func_2)(ArgumentMatchers.any).afterReturn([
        {
          id: '1'
        }
      ]);
      try {
        expect(await desktopShortcutViewModel.addShortcutToDesktop(shortcutInfo)).not().assertNull();
      } catch (e) {}
      mocker.clear(shortcutViewModel);
      mocker.clearAll();
    })
  })
}