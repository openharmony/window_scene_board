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
import { GridLayoutItemInfo } from '@ohos/bigfolder';
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
} from '@ohos/hypium';
import { DeviceState } from '@ohos/launchercommon';
import { SwiperPageVM } from '../../../../../main/ets/default/common/viewmodel/SwiperPageVM';


export default function SwiperPageVMTest() {
  describe('SwiperPageVMTest', () => {
    beforeAll(() => {
    });
    beforeEach(() => {
    });
    afterEach(() => {
    });
    afterAll(() => {
    });
    it('doSelect', 0, () => {
      let swiperPageVM: SwiperPageVM = SwiperPageVM.getInstance();
      const item = new GridLayoutItemInfo();
      item.page = 0;
      item.row = 0;
      item.column = 0;
      swiperPageVM.setPageItems(0, [item]);

      swiperPageVM.doSelect(0, 0, 0, 0, 'portrait_expanded', 0);

      expect(item.isSelect).assertTrue();
    })

    it('paddingSideUpdate', 0, () => {
      let swiperPageVM: SwiperPageVM = SwiperPageVM.getInstance();
      let padding: number[] = swiperPageVM.getPaddingSide(0, DeviceState.DEFAULT_STATE);
      expect(padding[0]).assertEqual(0);
    })
  })
}