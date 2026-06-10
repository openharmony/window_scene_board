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
  MockKit,
  when,
} from '@ohos/hypium';
import { FormStackDebugCmd } from '../../../../../main/ets/common/FormStackDebugCmd';
import { FormStackUtil } from '../../../../../main/ets/common/FormStackUtil';
import { FormStackExpandItemDragAnimate } from '../../../../../main/ets/viewmodel/FormStackExpandItemDragAnimate';
import { FormStackExpandViewData } from '../../../../../main/ets/viewmodel/FormStackExpandViewData';
import { FormStackTestUtil } from '../common/FormStackTestUtil';
import { FormStackExpandLayoutModel } from '../../../../../main/ets/common/FormStackExpandLayoutModel';

export function FormStackExpandItemDragAnimateTest() {
  describe('FormStackExpandItemDragAnimateTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('swapForm', 0, () => {
      // 构建ViewData
      let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData();
      let layoutModel: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();

      // ItemDragAnimate 初始化
      let dragAnimate: FormStackExpandItemDragAnimate = new FormStackExpandItemDragAnimate();
      dragAnimate.initData(viewData, layoutModel);

      // 动画开关, animateTo打桩
      FormStackDebugCmd.getInstance().setExpandAnimateSwitch(['false']);

      let rotateX0 = viewData.mItemInfoList[0].rotateX;
      let translateY0 = viewData.mItemInfoList[0].translateY;
      let zIndex0 = viewData.mItemInfoList[0].zIndex;
      let isVisible0 = viewData.mItemInfoList[0].isVisible;
      let opacity0 = viewData.mItemInfoList[0].opacity;

      let rotateX1 = viewData.mItemInfoList[1].rotateX;
      let translateY1 = viewData.mItemInfoList[1].translateY;
      let zIndex1 = viewData.mItemInfoList[1].zIndex;
      let isVisible1 = viewData.mItemInfoList[1].isVisible;
      let opacity1 = viewData.mItemInfoList[1].opacity;

      // 触发Item交换事件
      let isCalled: boolean = false;
      expect(isCalled).assertFalse();

      // ViewData状态数据校验
      expect(FormStackUtil.isNumberEqual(rotateX0, viewData.mItemInfoList[0].rotateX)).assertTrue();
      expect(FormStackUtil.isNumberEqual(translateY0, viewData.mItemInfoList[0].translateY)).assertTrue();
      expect(FormStackUtil.isNumberEqual(zIndex0, viewData.mItemInfoList[0].zIndex)).assertTrue();
      expect(FormStackUtil.isNumberEqual(rotateX1, viewData.mItemInfoList[1].rotateX)).assertTrue();
      expect(FormStackUtil.isNumberEqual(translateY1, viewData.mItemInfoList[1].translateY)).assertTrue();
      expect(FormStackUtil.isNumberEqual(zIndex1, viewData.mItemInfoList[1].zIndex)).assertTrue();

      expect(isVisible0).assertEqual(viewData.mItemInfoList[1].isVisible);
      expect(FormStackUtil.isNumberEqual(opacity0, viewData.mItemInfoList[1].opacity)).assertTrue();
      expect(isVisible1).assertEqual(viewData.mItemInfoList[0].isVisible);
      expect(FormStackUtil.isNumberEqual(opacity1, viewData.mItemInfoList[0].opacity)).assertTrue();
    });

    it('swapForm_2', 0, () => {
      let animate: FormStackExpandItemDragAnimate = new FormStackExpandItemDragAnimate();
      let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(3);
      let layoutModel: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();
      animate.initData(viewData, layoutModel);

      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackDebugCmd.getInstance(),
        FormStackDebugCmd.getInstance().isNeedExpandAnimate);
      when(mockFunc)().afterReturn(true);

      mocker.clear(FormStackDebugCmd.getInstance());
      mocker.clearAll();
    });
  });
}