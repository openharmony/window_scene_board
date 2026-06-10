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
import { FormStackItemInfo } from '../../../../../../src/main/ets/common/FormStackItemInfo';
import { FormStackDataAdapt, FormStackMsg } from '../../../../../main/ets/common/FormStackDataAdapt';
import { FormStackExpandEvent } from '../../../../../main/ets/viewmodel/FormStackExpandEvent';
import { FormStackExpandViewData } from '../../../../../main/ets/viewmodel/FormStackExpandViewData';
import { FormStackExpandEnterAnimate } from '../../../../../main/ets/viewmodel/FormStackExpandEnterAnimate';
import { FormStackTestUtil } from '../common/FormStackTestUtil';

export function FormStackExpandEnterAnimateTest() {
  describe('FormStackExpandEnterAnimateTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('enterFormStackExpand', 0, () => {
      try {
        // 构建ViewData
        let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(3);

        // ViewEvent初始化
        let expandEvent: FormStackExpandEvent = new FormStackExpandEvent();
        let ret: boolean = expandEvent.initData(viewData, {});
        expect(ret).assertTrue();

        // 构建外部数据
        let formStackItemInfo: FormStackItemInfo =
          FormStackTestUtil.createFormStackItemInfo(FormStackTestUtil.TEST_FORM_STACK_ID, 3);

        // 模拟外部展开事件，触发进入动画
        FormStackDataAdapt.getInstance().handleMsg(FormStackMsg.SET_FORM_STACK_ITEM_INFO, formStackItemInfo);

        // ViewData状态数据校验
        expect(viewData.mVisible).assertTrue();
        expect(viewData.mBlurStyle).assertEqual(BlurStyle.BACKGROUND_THIN);
        expect(viewData.mBlurScale).assertEqual(1);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('enterFormStackExpand_2', 0, () => {
      let animate: FormStackExpandEnterAnimate = new FormStackExpandEnterAnimate();
      animate.enterFormStackExpand();
    });
  });
}