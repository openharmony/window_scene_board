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
  expect,
  it,
} from '@ohos/hypium';
import { EditModeUIExtensionViewModel } from '../../../../main/ets/uiExtension/viewmodel/EditModeUIExtensionViewModel';
import Want from '@ohos.app.ability.Want';
import IconEditPageConstants from '../../../../main/ets/default/common/constants/IconEditPageConstants';

export function EditModeUIExtensionViewModelTest() {
  describe('EditModeUIExtensionViewModelTest', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('test_onReceiveData_apply', 0, () => {
      let data: Record<string, object | string | number | boolean> = {
        'apply': true,
        'isShowNameChange': true
      };
      let editModeUIExtensionViewModel: EditModeUIExtensionViewModel = new EditModeUIExtensionViewModel();
      let res = editModeUIExtensionViewModel.onReceiveData(data);
      expect(res !== null).assertTrue()
    })

    it('test_onReceiveData_01', 0, () => {
      const editModeUIExtensionViewModel = new EditModeUIExtensionViewModel();
      let data: Record<string, object | string | number | boolean> = {};
      let res = editModeUIExtensionViewModel.onReceiveData(data)
      expect(res !== null).assertTrue()
    })

    it('test_onReceiveData_02', 0, () => {
      const editModeUIExtensionViewModel = new EditModeUIExtensionViewModel();
      let data: Record<string, object | string | number | boolean> = {
        'apply': true,
        'isShowNameChange': true
      };
      let wantData: Want = {
        abilityName: undefined
      };
      let res = editModeUIExtensionViewModel.onReceiveData(data, wantData)
      expect(res !== null).assertTrue()
    })

    it('test_onReceiveData_03', 0, () => {
      const editModeUIExtensionViewModel = new EditModeUIExtensionViewModel();
      let data: Record<string, object | string | number | boolean> = {
        'apply': true,
        'isShowNameChange': true
      };
      let wantData: Want = {
        abilityName: 'EditModeIconAbilityPhone'
      };
      let res = editModeUIExtensionViewModel.onReceiveData(data, wantData)
      expect(res !== null).assertTrue()
    })

    it('test_onReceiveData_04', 0, () => {
      const editModeUIExtensionViewModel = new EditModeUIExtensionViewModel();
      let data: Record<string, object | string | number | boolean> = {
        'apply': true,
        'isShowNameChange': true
      };
      let wantData: Want = {
        abilityName: ''
      };
      let res = editModeUIExtensionViewModel.onReceiveData(data, wantData)
      expect(res !== null).assertTrue()
    })

    it('test_onReceiveData_05', 0, () => {
      const editModeUIExtensionViewModel = new EditModeUIExtensionViewModel();
      let data: Record<string, object | string | number | boolean> = {
        'apply': true,
        'isShowNameChange': true,
        'back': true
      };
      let wantData: Want = {
        abilityName: ''
      };
      let res = editModeUIExtensionViewModel.onReceiveData(data, wantData)
      expect(res !== null).assertTrue()
    })

    it('test_onReceiveData_06', 0, () => {
      const editModeUIExtensionViewModel = new EditModeUIExtensionViewModel();
      let data: Record<string, object | string | number | boolean> = {
        'apply': true,
        'isShowNameChange': true,
        'back': false
      };
      let wantData: Want = {
        abilityName: ''
      };
      let res = editModeUIExtensionViewModel.onReceiveData(data, wantData)
      expect(res !== null).assertTrue()
    })

    it('test_onReceiveData_07', 0, () => {
      const editModeUIExtensionViewModel = new EditModeUIExtensionViewModel();
      let data: Record<string, object | string | number | boolean> = {
        'apply': true,
        'isShowNameChange': true,
        'back': true
      };
      let wantData: Want = {
        abilityName: ''
      };
      (editModeUIExtensionViewModel as object)['timerId'] = -1
      let res = editModeUIExtensionViewModel.onReceiveData(data, wantData)
      expect(res !== null).assertTrue()
    })

    it('test_onReceiveData_08', 0, () => {
      const editModeUIExtensionViewModel = new EditModeUIExtensionViewModel();
      let data: Record<string, object | string | number | boolean> = {
        'apply': true,
        'isShowNameChange': true,
        'back': true
      };
      let wantData: Want = {
        abilityName: ''
      };
      (editModeUIExtensionViewModel as object)['timerId'] = 0
      let res = editModeUIExtensionViewModel.onReceiveData(data, wantData)
      expect(res !== null).assertTrue()
    })

    it('test_onReceiveData_09', 0, () => {
      const editModeUIExtensionViewModel = new EditModeUIExtensionViewModel();
      let data: Record<string, object | string | number | boolean> = {
        'apply': true,
        'isShowNameChange': true,
        'back': true,
        'isUseCache': true
      };
      let wantData: Want = {
        abilityName: ''
      };

      let res = editModeUIExtensionViewModel.onReceiveData(data, wantData)
      expect(res !== null).assertTrue()
    })

    it('test_onReceiveData_10', 0, () => {
      const editModeUIExtensionViewModel = new EditModeUIExtensionViewModel();
      let data: Record<string, object | string | number | boolean> = {
        'apply': true,
        'isShowNameChange': true,
        'back': true,
        'isUseCache': ''
      };
      let wantData: Want = {
        abilityName: ''
      };
      let res = editModeUIExtensionViewModel.onReceiveData(data, wantData)
      expect(res !== null).assertTrue()
    })

    it('test_onReceiveData_11', 0, () => {
      const editModeUIExtensionViewModel = new EditModeUIExtensionViewModel();
      let data: Record<string, object | string | number | boolean> = {
        'apply': true,
        'isShowNameChange': false,
        'back': true,
        'isUseCache': ''
      };
      let wantData: Want = {
        abilityName: ''
      };
      let res = editModeUIExtensionViewModel.onReceiveData(data, wantData)
      expect(res !== null).assertTrue()
    })

    it('test_onReceiveData_12', 0, () => {
      const editModeUIExtensionViewModel = new EditModeUIExtensionViewModel();
      let data: Record<string, object | string | number | boolean> = {
        'apply': false,
        'isShowNameChange': false,
        'back': true,
        'isUseCache': ''
      };
      let wantData: Want = {
        abilityName: ''
      };
      let res = editModeUIExtensionViewModel.onReceiveData(data, wantData)
      expect(res !== null).assertTrue()
    })

    it('test_cancelDesktopCacheState_01', 0, () => {
      const editModeUIExtensionViewModel = new EditModeUIExtensionViewModel();
      let data: Record<string, object | string | number | boolean> = {
        'useCache': false,
      };
      let res: object = (editModeUIExtensionViewModel as object)['cancelDesktopCacheState'](data)
      expect(res !== null).assertTrue()
    })

    it('test_cancelDesktopCacheState_02', 0, () => {
      const editModeUIExtensionViewModel = new EditModeUIExtensionViewModel();
      let data: Record<string, object | string | number | boolean> = {
        'useCache': true,
      };
      let res: object = (editModeUIExtensionViewModel as object)['cancelDesktopCacheState'](data)
      expect(res !== null).assertTrue()
    })
  })
}