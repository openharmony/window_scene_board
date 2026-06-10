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
} from '@ohos/hypium';
import { WantParams } from '@ohos/desktopedit/src/main/ets/default/common/constants/EditModeConstants';
import { DesktopEditPageViewModel } from '@ohos/phonebase/src/main/ets/desktopedit/viewmodel/DesktopEditPageViewModel';

export function DesktopEditPageViewModelTest() {
  describe('DesktopEditPageViewModelTest', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('test_dealParms', 0, () => {
      const desktopEditPageViewModel = new DesktopEditPageViewModel();
      const pageInfos = new NavPathStack();
      const params = new WantParams();
      params.nav = 'wallpaperPicker';
      LocalStorage.getShared()?.set<WantParams>('params', params);
      expect(desktopEditPageViewModel.dealParms(pageInfos) === undefined).assertTrue();
      LocalStorage.getShared()?.delete('params');
    })
  })
}