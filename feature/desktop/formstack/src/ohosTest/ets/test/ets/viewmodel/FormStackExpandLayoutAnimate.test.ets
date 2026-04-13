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
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
} from '@ohos/hypium';
import { FormStackDebugCmd } from '../../../../../main/ets/common/FormStackDebugCmd';
import { FormStackExpandConfig } from '../../../../../main/ets/common/FormStackExpandConfig';
import { FormStackExpandLayoutModel } from '../../../../../main/ets/common/FormStackExpandLayoutModel';
import { FormStackUtil } from '../../../../../main/ets/common/FormStackUtil';
import { FormStackExpandLayoutAnimate } from '../../../../../main/ets/viewmodel/FormStackExpandLayoutAnimate';
import { FormStackExpandViewData } from '../../../../../main/ets/viewmodel/FormStackExpandViewData';
import { FormStackTestUtil, LayoutAnimateResult } from '../common/FormStackTestUtil';

export function FormStackExpandLayoutAnimateTest() {
  describe('FormStackExpandLayoutAnimateTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('layoutFormStackExpand', 0, () => {
      // 构建ViewData和Model
      let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData();
      let layoutModel: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();

      // 初始化layoutAnimate
      let layoutAnimate: FormStackExpandLayoutAnimate = new FormStackExpandLayoutAnimate();
      layoutAnimate.initData(viewData, layoutModel);

      // 配置设备信息
      let config: FormStackExpandConfig = FormStackExpandConfig.getInstance();
      FormStackTestUtil.initDefaultConfig(config);

      // 动画开关, animateTo打桩
      FormStackDebugCmd.getInstance().setExpandAnimateSwitch(['false']);

      // 模拟布局动画
      layoutAnimate.layoutFormStackExpand();

      // ViewData状态变量校验
      expect(viewData.mBlurScale).assertEqual(1);
      let layoutAnimateResult: LayoutAnimateResult = FormStackTestUtil.getLayoutAnimateResult();
      viewData.mItemInfoList.forEach((item, index) => {
        expect(FormStackUtil.isNumberEqual(item.rotateX, layoutAnimateResult.rotateX[index])).assertTrue();
      });
    });

    it('initItemLayoutInfo', 0, () => {
      let layoutAnimate: FormStackExpandLayoutAnimate = new FormStackExpandLayoutAnimate();
      layoutAnimate.resetData();
      let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(0);
      let layoutModel: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();
      layoutAnimate.initData(viewData, layoutModel);
      layoutAnimate.initItemLayoutInfo(viewData);
    });

    it('initLayoutInfo_test01', 0, () => {
      let layoutAnimate: FormStackExpandLayoutAnimate = new FormStackExpandLayoutAnimate();
      (layoutAnimate as object)['initLayoutInfo']();
      expect(layoutAnimate).not().assertUndefined();
    });
  });
}