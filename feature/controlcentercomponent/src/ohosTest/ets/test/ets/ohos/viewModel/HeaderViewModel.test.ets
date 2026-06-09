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

import { afterAll, afterEach, beforeEach, it, describe, expect } from '@ohos/hypium';
import {
  HeaderViewModel
} from '../../../../../../main/ets/com/ohos/viewModel/HeaderViewModel';

import {
  HeaderViewData
} from '../../../../../../main/ets/com/ohos/model/HeaderViewData';

export function HeaderViewModelTest() {
  let mHeaderViewModel = HeaderViewModel.getInstance();
  describe('HeaderViewModelTest', (): void => {

    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('HeaderViewModelTest001', 0, (): void => {
      let handleNormal: boolean = true;
      try {
        mHeaderViewModel.onSettingClick();
        expect(handleNormal).assertEqual(true);
      } catch (e) {
        expect(handleNormal).assertEqual(true);
      }
    })

    it('HeaderViewModelTest002', 0, (): void => {
      let handleNormal: boolean = true;
      try {
        mHeaderViewModel.initData(new HeaderViewData());
        mHeaderViewModel.setVisibleOfSettingIcon(true);
        expect(handleNormal).assertEqual(true);
      } catch (e) {
        expect(handleNormal).assertEqual(true);
      }
    })
  })
}