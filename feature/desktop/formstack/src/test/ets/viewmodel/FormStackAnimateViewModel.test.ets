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
import { CardItemInfo } from '@ohos/launchercommon';

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect } from '@ohos/hypium';
import { FormStackAnimateViewModel } from '../../../main/ets/viewmodel/FormStackAnimateViewModel';

export function FormStackAnimateViewModelTest() {
  describe('FormStackAnimateViewModelTest', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterAll(() => {
    })

    afterEach(() => {
    })

    it('initAnimateInfo', 0, () => {
      let viewModel: FormStackAnimateViewModel = new FormStackAnimateViewModel();
      viewModel.initAnimateInfo(null, 0, 0);
      expect(viewModel.mItemInfoList.length).assertEqual(0);
      expect(viewModel.mMaskList.length).assertEqual(0);
    })

    it('resetData', 0, () => {
      let arr: CardItemInfo[] = new Array<CardItemInfo>();
      let card: CardItemInfo = new CardItemInfo();
      arr.push(card);
      arr.push(card);
      let viewModel: FormStackAnimateViewModel = new FormStackAnimateViewModel();
      viewModel.initAnimateInfo(arr, 0, 0);
      expect(viewModel.mItemInfoList.length).assertEqual(2);
      expect(viewModel.mMaskList.length).assertEqual(2);
      viewModel.resetData();
      expect(viewModel.mItemInfoList.length).assertEqual(0);
      expect(viewModel.mMaskList.length).assertEqual(0);
    })

    it('updateFormListByClose', 0, () => {
      const arr: CardItemInfo[] = new Array<CardItemInfo>();
      let card: CardItemInfo = new CardItemInfo();
      arr.push(card);
      arr.push(card);
      arr[0].cardId = '12345678';
      arr[1].cardId = '87654321';
      let viewModel: FormStackAnimateViewModel = new FormStackAnimateViewModel();
      viewModel.initAnimateInfo(arr, 0, 0);
      expect(viewModel.mItemInfoList.length).assertEqual(2);
      viewModel.mItemInfoList[0].zIndex = 1;
      viewModel.mItemInfoList[1].zIndex = 0;
      viewModel.updateFormListByClose(arr);
      expect(viewModel.mItemInfoList[0].zIndex).assertEqual(0);
      expect(viewModel.mItemInfoList[1].zIndex).assertEqual(2);
      arr.splice(0, arr.length);
    })
  })
}