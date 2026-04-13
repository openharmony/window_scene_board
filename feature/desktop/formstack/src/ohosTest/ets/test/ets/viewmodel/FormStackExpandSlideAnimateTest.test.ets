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
  MockKit,
  when,
  ArgumentMatchers,
} from '@ohos/hypium';
import { FormStackExpandLayoutModel } from '../../../../../main/ets/common/FormStackExpandLayoutModel';
import { FormStackExpandLayoutAnimate } from '../../../../../main/ets/viewmodel/FormStackExpandLayoutAnimate';
import { FormStackExpandSlideAnimate } from '../../../../../main/ets/viewmodel/FormStackExpandSlideAnimate';
import { FormStackExpandViewData } from '../../../../../main/ets/viewmodel/FormStackExpandViewData';
import { FormStackTestUtil } from '../common/FormStackTestUtil';
import { FormStackDebugCmd } from '../../../../../main/ets/common/FormStackDebugCmd';
import { EditCardCollapseType } from '../../../../../main/ets/common/FormStackConstants';
import { FormStackUtil } from '../../../../../main/ets/common/FormStackUtil';
import { FormStackExpandItem } from '../../../../../main/ets/viewmodel/FormStackExpandItem';

export function FormStackExpandSlideAnimateTest() {
  describe('FormStackExpandSlideAnimateTest', () => {
    let debugCmd: FormStackDebugCmd = FormStackDebugCmd.getInstance();
    let mocker: MockKit = new MockKit();
    const mockIsNeedExpandAnimate: Function = mocker.mockFunc(debugCmd, debugCmd.isNeedExpandAnimate);

    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
      mocker.clear(debugCmd);
      mocker.clearAll();
    });

    afterEach(() => {
    });

    it('longitudinalSlideMove', 0, () => {
      let slideAnimate: FormStackExpandSlideAnimate = new FormStackExpandSlideAnimate();
      // 构建ViewData等信息，用于初始化slideAnimate
      let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData();
      let layoutModel: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();

      // 初始化layoutAnimate
      let layoutAnimate: FormStackExpandLayoutAnimate = new FormStackExpandLayoutAnimate();
      layoutAnimate.initData(viewData, layoutModel);

      // slideAnimate未初始化，覆盖longitudinalSlideMove分支
      let ret: boolean = slideAnimate.longitudinalSlideMove(5);
      expect(ret).assertFalse();

      // 初始化slideAnimate
      slideAnimate.initData(viewData, layoutAnimate, layoutModel);
      // 动画开关, animateTo打桩
      when(mockIsNeedExpandAnimate)().afterReturn(false);
      // 模拟触发layout布局
      layoutAnimate.layoutFormStackExpand();

      // 模拟滑动事件,覆盖calculateMoveDistance分支
      ret = slideAnimate.longitudinalSlideMove(0);
      expect(ret).assertTrue();

      // 模拟滑动事件
      ret = slideAnimate.longitudinalSlideMove(5);
      expect(ret).assertTrue();

      // 模拟滑动事件,覆盖calculateMoveDistance和isCardMoveNeedIgnore中分支
      ret = slideAnimate.longitudinalSlideMove(5, true, 1, EditCardCollapseType.BOTTOM_COLLAPSE);
      expect(ret).assertTrue();
      ret = slideAnimate.longitudinalSlideMove(5, true, 1, EditCardCollapseType.TOP_COLLAPSE);
      expect(ret).assertTrue();

      // ViewData校验
      viewData.mItemInfoList.forEach((item) => {
        expect(item.opacity).assertEqual(1);
      });
    });

    it('updateChildAnimAttr', 0, () => {
      // 要设置10张卡片，然后滑动到底部，把curSlide调到最大
      let slideAnimate: FormStackExpandSlideAnimate = new FormStackExpandSlideAnimate();
      // 构建ViewData等信息，用于初始化slideAnimate
      let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(10);
      let layoutModel: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();

      // 初始化Animate
      let layoutAnimate: FormStackExpandLayoutAnimate = new FormStackExpandLayoutAnimate();
      layoutAnimate.initData(viewData, layoutModel);

      slideAnimate.initData(viewData, layoutAnimate, layoutModel);
      // 动画开关, animateTo打桩
      when(mockIsNeedExpandAnimate)().afterReturn(false);
      // 模拟触发layout布局
      layoutAnimate.layoutFormStackExpand();

      let len = viewData.mItemInfoList.length;
      let showSizePerPage: number = FormStackUtil.toFixNumber(layoutModel.mShowSizePerPage);
      const maxSlideValue: number = (len - layoutModel.mShowMaxCount) * showSizePerPage;

      // 模拟滑动事件,覆盖if分支
      let ret: boolean = slideAnimate.longitudinalSlideMove(maxSlideValue);
      expect(ret).assertTrue();

      // 模拟滑动事件
      ret = slideAnimate.longitudinalSlideMove(5);
      expect(ret).assertTrue();

      ret = slideAnimate.longitudinalSlideMove(5, true, 0, EditCardCollapseType.NONE);
      expect(ret).assertTrue();
    });

    it('heelSlideAnimate', 0, () => {
      let slideAnimate: FormStackExpandSlideAnimate = new FormStackExpandSlideAnimate();
      // 模拟滑动事件,slideAnimate未初始化
      let ret: boolean = slideAnimate.heelSlideAnimate(5, false, 0);
      expect(ret).assertFalse();

      // 构建ViewData等信息，用于初始化slideAnimate
      let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData();
      let layoutModel: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();

      // 初始化Animate
      let layoutAnimate: FormStackExpandLayoutAnimate = new FormStackExpandLayoutAnimate();
      layoutAnimate.initData(viewData, layoutModel);

      slideAnimate.initData(viewData, layoutAnimate, layoutModel);

      // 动画开关, animateTo打桩
      when(mockIsNeedExpandAnimate)().afterReturn(false);

      // 模拟触发layout布局
      layoutAnimate.layoutFormStackExpand();

      // 模拟滑动事件
      ret = slideAnimate.heelSlideAnimate(5, false, 0);
      expect(ret).assertTrue();
      // ViewData校验
      viewData.mItemInfoList.forEach((item) => {
        expect(item.opacity).assertEqual(1);
      });

      // 动画开关, animateTo打桩
      when(mockIsNeedExpandAnimate)().afterReturn(true);
      // 模拟滑动事件
      ret = slideAnimate.heelSlideAnimate(5, false, 0);
      expect(ret).assertTrue();
    });

    it('longitudinalSlideEnd', 0, () => {
      let slideAnimate: FormStackExpandSlideAnimate = new FormStackExpandSlideAnimate();
      // 模拟滑动事件,slideAnimate未初始化
      slideAnimate.longitudinalSlideEnd(5, 0);

      // 构建ViewData等信息，用于初始化slideAnimate
      let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData();
      let layoutModel: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();

      // 初始化Animate
      let layoutAnimate: FormStackExpandLayoutAnimate = new FormStackExpandLayoutAnimate();
      layoutAnimate.initData(viewData, layoutModel);

      slideAnimate.initData(viewData, layoutAnimate, layoutModel);

      // 模拟触发layout布局
      layoutAnimate.layoutFormStackExpand();

      // 动画开关, animateTo打桩
      when(mockIsNeedExpandAnimate)().afterReturn(false);
      // 模拟滑动事件
      slideAnimate.longitudinalSlideEnd(5, 0);
      viewData.mItemInfoList.forEach((item) => {
        expect(item.isVisible).assertTrue();
      });

      let len = viewData.mItemInfoList.length;
      let showSizePerPage: number = FormStackUtil.toFixNumber(layoutModel.mShowSizePerPage);
      const maxSlideValue: number = (len - layoutModel.mShowMaxCount) * showSizePerPage;
      // 先滑动到end，然后再滑动一下，覆盖getFinalSlidingDistance函数中else if分支
      slideAnimate.longitudinalSlideEnd(maxSlideValue + 1, 0);
      slideAnimate.longitudinalSlideEnd(5, 0);

      // 动画开关, animateTo打桩
      when(mockIsNeedExpandAnimate)().afterReturn(true);
      // 模拟滑动事件
      slideAnimate.longitudinalSlideEnd(5, 0);
      viewData.mItemInfoList.forEach((item) => {
        expect(item.isVisible).assertTrue();
      });
    });

    it('longitudinalSlideMoveAnimate', 0, () => {
      let slideAnimate: FormStackExpandSlideAnimate = new FormStackExpandSlideAnimate();

      // 构建ViewData等信息，用于初始化slideAnimate
      let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData();
      let layoutModel: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();
      // 初始化Animate
      let layoutAnimate: FormStackExpandLayoutAnimate = new FormStackExpandLayoutAnimate();
      layoutAnimate.initData(viewData, layoutModel);

      slideAnimate.initData(viewData, layoutAnimate, layoutModel);

      // 模拟触发layout布局
      layoutAnimate.layoutFormStackExpand();

      // 动画开关, animateTo打桩
      when(mockIsNeedExpandAnimate)().afterReturn(false);
      // 模拟滑动事件
      slideAnimate.longitudinalSlideMoveAnimate(5);
      viewData.mItemInfoList.forEach((item) => {
        expect(item.isVisible).assertTrue();
      });

      // 动画开关, animateTo打桩
      when(mockIsNeedExpandAnimate)().afterReturn(true);
      // 模拟滑动事件
      slideAnimate.longitudinalSlideMoveAnimate(5, 0, EditCardCollapseType.NONE);
      viewData.mItemInfoList.forEach((item) => {
        expect(item.isVisible).assertTrue();
      });
    });

    it('execSlideMoveBySwapping', 0, () => {
      let slideAnimate: FormStackExpandSlideAnimate = new FormStackExpandSlideAnimate();

      // 构建ViewData等信息，用于初始化slideAnimate
      let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData();
      let layoutModel: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();
      // 初始化Animate
      let layoutAnimate: FormStackExpandLayoutAnimate = new FormStackExpandLayoutAnimate();
      layoutAnimate.initData(viewData, layoutModel);

      slideAnimate.initData(viewData, layoutAnimate, layoutModel);

      // 模拟触发layout布局
      layoutAnimate.layoutFormStackExpand();

      // 动画开关, animateTo打桩
      when(mockIsNeedExpandAnimate)().afterReturn(false);
      // 模拟滑动事件
      slideAnimate.execSlideMoveBySwapping(5, 0);
      expect(viewData.mItemInfoList.length).assertLarger(0);

      // 动画开关, animateTo打桩
      when(mockIsNeedExpandAnimate)().afterReturn(true);
      // 模拟滑动事件
      slideAnimate.execSlideMoveBySwapping(5, 0);
      expect(viewData.mItemInfoList.length).assertLarger(0);
    });

    let slideAnimate: FormStackExpandSlideAnimate = new FormStackExpandSlideAnimate();
    let formStackExpandItem: FormStackExpandItem = new FormStackExpandItem();
    let itemList: FormStackExpandItem[] = [formStackExpandItem, formStackExpandItem, formStackExpandItem];
    let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData();
    let layoutModel: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();

    it('slideMoveBySwapping_test01', 0, () => {
      viewData.mItemInfoList = itemList;
      (slideAnimate as object)['mViewData'] = viewData;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isInvalidFormStackList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      (slideAnimate as object)['slideMoveBySwapping'](1, 1);
      expect(slideAnimate).not().assertUndefined();
      mocker.clear(FormStackUtil);
    });

    it('slideMoveBySwapping_test02', 0, () => {
      viewData.mItemInfoList = itemList;
      (slideAnimate as object)['mViewData'] = viewData;
      (slideAnimate as object)['mLayoutModel'] = undefined;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isInvalidFormStackList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      (slideAnimate as object)['slideMoveBySwapping'](1, 1);
      expect(slideAnimate).not().assertUndefined();
      mocker.clear(FormStackUtil);
    });

    it('slideMoveBySwapping_test03', 0, () => {
      layoutModel.mChildEndTranslateYList = [1, 2];
      viewData.mItemInfoList = itemList;
      (slideAnimate as object)['mViewData'] = viewData;
      (slideAnimate as object)['mLayoutModel'] = layoutModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isInvalidFormStackList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      (slideAnimate as object)['slideMoveBySwapping'](1, 1);
      expect(slideAnimate).not().assertUndefined();
      mocker.clear(FormStackUtil);
    });

    it('slideMoveBySwapping_test04', 0, () => {
      layoutModel.mChildEndTranslateYList = [1, 2, 3];
      viewData.mItemInfoList = itemList;
      (slideAnimate as object)['mViewData'] = viewData;
      (slideAnimate as object)['mLayoutModel'] = layoutModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isInvalidFormStackList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      (slideAnimate as object)['slideMoveBySwapping'](1, 1);
      expect(slideAnimate).not().assertUndefined();
      mocker.clear(FormStackUtil);
    });

    it('slideMoveBySwapping_test05', 0, () => {
      layoutModel.mChildEndTranslateYList = [1, 2, 3];
      layoutModel.mShowSizePerPage = 0;
      viewData.mItemInfoList = itemList;
      (slideAnimate as object)['mViewData'] = viewData;
      (slideAnimate as object)['mLayoutModel'] = layoutModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isInvalidFormStackList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      (slideAnimate as object)['slideMoveBySwapping'](1, 1);
      expect(slideAnimate).not().assertUndefined();
      mocker.clear(FormStackUtil);
    });

    it('slideMoveBySwapping_test06', 0, () => {
      layoutModel.mChildEndTranslateYList = [1, 2, 3];
      layoutModel.mShowSizePerPage = 1;
      viewData.mItemInfoList = itemList;
      (slideAnimate as object)['mViewData'] = viewData;
      (slideAnimate as object)['mLayoutModel'] = layoutModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isInvalidFormStackList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      (slideAnimate as object)['slideMoveBySwapping'](1, 1);
      expect(slideAnimate).not().assertUndefined();
      mocker.clear(FormStackUtil);
    });

    it('slideMoveBySwapping_test07', 0, () => {
      layoutModel.mChildEndTranslateYList = [1, 2, 3];
      layoutModel.mShowSizePerPage = 1;
      layoutModel.mPreShowSize = 0;
      viewData.mItemInfoList = itemList;
      (slideAnimate as object)['mViewData'] = viewData;
      (slideAnimate as object)['mLayoutModel'] = layoutModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isInvalidFormStackList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      (slideAnimate as object)['slideMoveBySwapping'](1, 1);
      expect(slideAnimate).not().assertUndefined();
      mocker.clear(FormStackUtil);
    });

    it('slideMoveBySwapping_test08', 0, () => {
      layoutModel.mChildEndTranslateYList = [1, 2, 3];
      layoutModel.mShowSizePerPage = 1;
      layoutModel.mPreShowSize = 1;
      viewData.mItemInfoList = itemList;
      (slideAnimate as object)['mViewData'] = viewData;
      (slideAnimate as object)['mLayoutModel'] = layoutModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isInvalidFormStackList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      (slideAnimate as object)['slideMoveBySwapping'](1, 1);
      expect(slideAnimate).not().assertUndefined();
      mocker.clear(FormStackUtil);
    });

    it('initLongitudinalSlideEndAnimate_test01', 0, () => {
      viewData.mItemInfoList = itemList;
      (slideAnimate as object)['mViewData'] = viewData;
      (slideAnimate as object)['mLayoutModel'] = undefined;
      (slideAnimate as object)['initLongitudinalSlideEndAnimate'](1, 1);
      expect(slideAnimate).not().assertUndefined();
    });

    it('initLongitudinalSlideEndAnimate_test02', 0, () => {
      viewData.mItemInfoList = itemList;
      (slideAnimate as object)['mViewData'] = viewData;
      (slideAnimate as object)['mLayoutModel'] = layoutModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc((slideAnimate as object), (slideAnimate as object)['getFinalSlidingDistance']);
      let mockFunc1 = mocker.mockFunc((slideAnimate as object), (slideAnimate as object)['longitudinalSlideMove']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(1);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      (slideAnimate as object)['initLongitudinalSlideEndAnimate'](1, 1);
      expect(slideAnimate).not().assertUndefined();
      mocker.clear((slideAnimate as object));
    });

    it('getFinalSlidingDistance_test01', 0, () => {
      layoutModel.mChildInitTranslateYList = [1, 2];
      (slideAnimate as object)['getFinalSlidingDistance'](layoutModel, itemList, 1, 1);
      expect(slideAnimate).not().assertUndefined();
    });

    it('getFinalSlidingDistance_test02', 0, () => {
      layoutModel.mChildInitTranslateYList = [1, 2, 3];
      layoutModel.mShowMaxCount = 1;
      (slideAnimate as object)['mCurrentSlideValue'] = 5;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.toFixNumber);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(2);
      (slideAnimate as object)['getFinalSlidingDistance'](layoutModel, itemList, 1, 1);
      expect(slideAnimate).not().assertUndefined();
      mocker.clear(FormStackUtil);
    });

    it('getFinalSlidingDistance_test03', 0, () => {
      layoutModel.mChildInitTranslateYList = [1, 2, 3];
      layoutModel.mShowMaxCount = 1;
      (slideAnimate as object)['mCurrentSlideValue'] = 3;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.toFixNumber);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(2);
      (slideAnimate as object)['getFinalSlidingDistance'](layoutModel, itemList, 1, 1);
      expect(slideAnimate).not().assertUndefined();
      mocker.clear(FormStackUtil);
    });

    it('updateChildAnimAttr_test01', 0, () => {
      (slideAnimate as object)['mLayoutModel'] = undefined;
      (slideAnimate as object)['updateChildAnimAttr']();
      expect(slideAnimate).not().assertUndefined();
    });

    it('updateChildAnimAttrBySwapping_test01', 0, () => {
      (slideAnimate as object)['mLayoutModel'] = undefined;
      (slideAnimate as object)['updateChildAnimAttrBySwapping']();
      expect(slideAnimate).not().assertUndefined();
    });

    it('getHandsOffDistance_test01', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isInvalidFormStackList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      (slideAnimate as object)['getHandsOffDistance'](itemList, 1, 2, 3);
      expect(slideAnimate).not().assertUndefined();
      mocker.clear(FormStackUtil);
    });

    it('getHandsOffDistance_test02', 0, () => {
      layoutModel.mShowMaxCount = 1;
      (slideAnimate as object)['mLayoutModel'] = layoutModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isInvalidFormStackList);
      let mockFunc1 = mocker.mockFunc(FormStackUtil, FormStackUtil.toFixNumber);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(2);
      (slideAnimate as object)['getHandsOffDistance'](itemList, 100, 2, 0);
      expect(slideAnimate).not().assertUndefined();

      (slideAnimate as object)['getHandsOffDistance'](itemList, 100, -1, 0);
      expect(slideAnimate).not().assertUndefined();

      (slideAnimate as object)['getHandsOffDistance'](itemList, 1, -1, 0);
      expect(slideAnimate).not().assertUndefined();

      (slideAnimate as object)['getHandsOffDistance'](itemList, 1, -1, 1200);
      expect(slideAnimate).not().assertUndefined();
      mocker.clear(FormStackUtil);
    });

    it('getHandsOffDistance_test03', 0, () => {
      layoutModel.mShowMaxCount = 1;
      (slideAnimate as object)['mLayoutModel'] = layoutModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isInvalidFormStackList);
      let mockFunc1 = mocker.mockFunc(FormStackUtil, FormStackUtil.toFixNumber);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(20);
      (slideAnimate as object)['getHandsOffDistance'](itemList, 100, 2, 0);
      expect(slideAnimate).not().assertUndefined();
      mocker.clear(FormStackUtil);
    });
  });
}