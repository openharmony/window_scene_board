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
import { ItemUtils } from '@ohos/componenthelper';
import { FormStackExpandItem } from '../../../../../main/ets/viewmodel/FormStackExpandItem';

import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  MockKit,
  when,
  expect,
  ArgumentMatchers,
} from '@ohos/hypium';
import { FormStackDebugCmd } from '../../../../../main/ets/common/FormStackDebugCmd';
import { FormStackExpandItemDropAnimate } from '../../../../../main/ets/viewmodel/FormStackExpandItemDropAnimate';
import { FormStackExpandViewData } from '../../../../../main/ets/viewmodel/FormStackExpandViewData';
import { FormStackTestUtil } from '../common/FormStackTestUtil';

export function FormStackExpandItemDropAnimateTest() {
  describe('FormStackExpandItemDropAnimateTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('dropForm', 0, () => {
      let animate: FormStackExpandItemDropAnimate = new FormStackExpandItemDropAnimate();
      let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(3);
      animate.initData(viewData);

      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackDebugCmd.getInstance(),
        FormStackDebugCmd.getInstance().isNeedExpandAnimate);
      when(mockFunc)().afterReturn(false);
      animate.dropForm(0, 0);
      when(mockFunc)().afterReturn(true);
      animate.dropForm(0, 0);
      mocker.clear(FormStackDebugCmd.getInstance());
      mocker.clearAll();
    });

    it('execDropAction_test01', 0, () => {
      let animate: FormStackExpandItemDropAnimate = new FormStackExpandItemDropAnimate();
      (animate as object)['mViewData'] = undefined;
      (animate as object)['execDropAction']();
      expect(animate).not().assertUndefined();
    });

    it('execDropAction_test02', 0, () => {
      let animate: FormStackExpandItemDropAnimate = new FormStackExpandItemDropAnimate();
      let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(3);
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(ItemUtils, ItemUtils.getRectById);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      (animate as object)['mViewData'] = viewData;
      (animate as object)['execDropAction']();
      expect(animate).not().assertUndefined();
      mocker.clear(ItemUtils);
    });

    it('execDropAction_test03', 0, () => {
      let formStackExpandItem: FormStackExpandItem = new FormStackExpandItem();
      let animate: FormStackExpandItemDropAnimate = new FormStackExpandItemDropAnimate();
      let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(3);
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(ItemUtils, ItemUtils.getRectById);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      (animate as object)['mViewData'] = viewData;
      (animate as object)['execDropAction'](formStackExpandItem, 1);
      expect(animate).not().assertUndefined();
      mocker.clear(ItemUtils);
    });
  });
}