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
} from '@ohos/hypium';
import EditModeIconAbilityPhone from '@ohos/phonebase/src/main/ets/desktopedit/ability/EditModeIconAbilityPhone';
import { UIExtensionContentSession } from '@kit.AbilityKit';

export function EditModeIconAbilityPhoneTest() {
  describe('EditModeIconAbilityPhoneTest', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })
    it('test_onDestroy_01', 0, () => {
      const editModeIconAbilityPhone = new EditModeIconAbilityPhone();
      (editModeIconAbilityPhone as object)['timeId'] = -1
      let res = editModeIconAbilityPhone.onDestroy()
      expect(res !== null).assertTrue()
    })

    it('test_onDestroy_02', 0, () => {
      const editModeIconAbilityPhone = new EditModeIconAbilityPhone();
      (editModeIconAbilityPhone as object)['timeId'] = 0
      let res = editModeIconAbilityPhone.onDestroy()
      expect(res !== null).assertTrue()
    })

    it('test_dealDesktopPreviewParam_01', 0, () => {
      const editModeIconAbilityPhone = new EditModeIconAbilityPhone();
      let wantData: Want = {
        parameters:{
          'desktopParam':'desktopParam'
        }
      };
      let res:object = (editModeIconAbilityPhone as object)['dealDesktopPreviewParam'](wantData)
      expect(res !== null).assertTrue()
    })

    it('test_dealDesktopPreviewParam_02', 0, () => {
      const editModeIconAbilityPhone = new EditModeIconAbilityPhone();
      let wantData: Want = {};
      let res:object = (editModeIconAbilityPhone as object)['dealDesktopPreviewParam'](wantData)
      expect(res !== null).assertTrue()
    })

    it('test_dealDesktopPreviewParam_03', 0, () => {
      const editModeIconAbilityPhone = new EditModeIconAbilityPhone();
      let wantData: Want = {
        parameters:{
          'nav':'icon'
        }
      };
      let res:object = (editModeIconAbilityPhone as object)['dealDesktopPreviewParam'](wantData)
      expect(res !== null).assertTrue()
    })

    it('test_setupDarkModeEnvironment_01', 0, () => {
      const editModeIconAbilityPhone = new EditModeIconAbilityPhone();
      let res:object = (editModeIconAbilityPhone as object)['setupDarkModeEnvironment']()
      expect(res !== null).assertTrue()
    })
  })
}