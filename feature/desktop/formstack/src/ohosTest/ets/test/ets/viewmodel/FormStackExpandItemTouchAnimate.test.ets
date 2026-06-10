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
  ArgumentMatchers,
} from '@ohos/hypium';
import { FormStackDebugCmd } from '../../../../../main/ets/common/FormStackDebugCmd';
import { FormStackUtil } from '../../../../../main/ets/common/FormStackUtil';
import { FormStackExpandItemTouchAnimate } from '../../../../../main/ets/viewmodel/FormStackExpandItemTouchAnimate';
import { FormStackExpandViewData } from '../../../../../main/ets/viewmodel/FormStackExpandViewData';
import { FormStackTestUtil } from '../common/FormStackTestUtil';
import { FormStackExpandLayoutModel } from '../../../../../main/ets/common/FormStackExpandLayoutModel';
import { FormStackConstants } from '../../../../../main/ets/common/FormStackConstants';
import { FormStackExpandItem } from '../../../../../main/ets/viewmodel/FormStackExpandItem';

export function FormStackExpandItemTouchAnimateTest() {
  describe('FormStackExpandItemTouchAnimateTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('onItemTouchFeedback', 0, () => {
      // 构建ViewData
      let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData();
      let layoutModel: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();

      // ItemTouchAnimate 初始化
      let touchAnimate: FormStackExpandItemTouchAnimate = new FormStackExpandItemTouchAnimate();
      touchAnimate.initData(viewData, layoutModel);

      // 动画开关, animateTo打桩
      FormStackDebugCmd.getInstance().setExpandAnimateSwitch(['false']);

      let scaleX: number = viewData.mItemInfoList[0].scaleX * FormStackConstants.EDIT_TOUCH_FEEDBACK_SCALE;
      let scaleY: number = viewData.mItemInfoList[0].scaleY * FormStackConstants.EDIT_TOUCH_FEEDBACK_SCALE;
      let translateY: number =
        viewData.mItemInfoList[0].translateY + FormStackConstants.EDIT_TOUCH_FEEDBACK_TRANSLATE_Y;

      // 触发Item touch事件
      touchAnimate.onItemTouchFeedback(0, true);

      // ViewData状态数据校验
      expect(FormStackUtil.isNumberEqual(scaleX, viewData.mItemInfoList[0].scaleX)).assertTrue();
      expect(FormStackUtil.isNumberEqual(scaleY, viewData.mItemInfoList[0].scaleY)).assertTrue();
      expect(FormStackUtil.isNumberEqual(translateY, viewData.mItemInfoList[0].translateY)).assertTrue();

      translateY = viewData.mItemInfoList[0].translateY - FormStackConstants.EDIT_TOUCH_FEEDBACK_TRANSLATE_Y;
      touchAnimate.onItemTouchFeedback(0, false);
      expect(FormStackUtil.isNumberEqual(translateY, viewData.mItemInfoList[0].translateY)).assertTrue();
    });

    it('onItemTouchFeedback', 0, () => {
      let animate: FormStackExpandItemTouchAnimate = new FormStackExpandItemTouchAnimate();
      let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(3);
      let layoutModel: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();
      animate.initData(viewData, layoutModel);

      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackDebugCmd.getInstance(),
        FormStackDebugCmd.getInstance().isNeedExpandAnimate);
      when(mockFunc)().afterReturn(true);
      animate.onItemTouchFeedback(0, true, false);
      animate.onItemTouchFeedback(0, true, true);

      mocker.clear(FormStackDebugCmd.getInstance());
      mocker.clearAll();
    });

    it('onItemPressFeedback', 0, () => {
      let animate: FormStackExpandItemTouchAnimate = new FormStackExpandItemTouchAnimate();
      let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(3);
      let layoutModel: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();
      animate.initData(viewData, layoutModel);

      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackDebugCmd.getInstance(),
        FormStackDebugCmd.getInstance().isNeedExpandAnimate);
      when(mockFunc)().afterReturn(true);
      animate.onItemPressFeedback(0, true);
      animate.onItemPressFeedback(0, true);
      animate.onItemPressFeedback(0, false);
      animate.onItemPressFeedback(0, false);

      when(mockFunc)().afterReturn(false);
      animate.onItemPressFeedback(0, true);
      animate.onItemPressFeedback(0, false);
      mocker.clear(FormStackDebugCmd.getInstance());
      mocker.clearAll();
    });

    it('longPressAvoidRestore_test01', 0, () => {
      let animate: FormStackExpandItemTouchAnimate = new FormStackExpandItemTouchAnimate();
      (animate as object)['mLayoutModel'] = undefined;
      (animate as object)['longPressAvoidRestore']();
      expect(animate).not().assertUndefined();
    });

    it('longPressAvoidRestore_test02', 0, () => {
      let formStackAnimateItem: FormStackExpandItem = new FormStackExpandItem();
      let formStackAnimateItemList: FormStackExpandItem[] =
        [formStackAnimateItem, formStackAnimateItem, formStackAnimateItem];
      let layoutModel: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();
      let animate: FormStackExpandItemTouchAnimate = new FormStackExpandItemTouchAnimate();
      layoutModel.mLastShowItemIndex = 2;
      (animate as object)['mLayoutModel'] = layoutModel;
      let mocker: MockKit = new MockKit();
      let mockFunc =
        mocker.mockFunc(FormStackDebugCmd.getInstance(), FormStackDebugCmd.getInstance().isNeedExpandAnimate);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      (animate as object)['longPressAvoidRestore'](formStackAnimateItemList, 1);
      expect(animate).not().assertUndefined();
      mocker.clear(FormStackDebugCmd.getInstance());
    });

    it('longPressAvoid_test01', 0, () => {
      let animate: FormStackExpandItemTouchAnimate = new FormStackExpandItemTouchAnimate();
      (animate as object)['mLayoutModel'] = undefined;
      (animate as object)['longPressAvoid']();
      expect(animate).not().assertUndefined();
    });
  });
}