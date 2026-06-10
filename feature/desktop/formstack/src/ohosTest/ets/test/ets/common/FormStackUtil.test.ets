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
import { CardItemInfo, PageDesktopModel } from '@ohos/launchercommon';
import { CheckEmptyUtils, RectInfo } from '@ohos/basicutils';
import { DeviceHelper, ResourceManager } from '@ohos/frameworkwrapper';
import { FormStackUtil } from '../../../../../main/ets/common/FormStackUtil';
import { FormStackTestUtil } from './FormStackTestUtil';
import { FormStackManager } from '../../../../../main/ets/common/FormStackManager';
import { FormStackConstants } from '../../../../../main/ets/common/FormStackConstants';
import { FormStackItemInfo } from '../../../../../main/ets/common/FormStackItemInfo';

export function FormStackUtilTest() {
  describe('FormStackUtilTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('toFixNumber', 0, () => {
      let num: number = 123.454;
      expect(FormStackUtil.toFixNumber(num, 2)).assertEqual(123.45);
    });

    it('getFormComponentId', 0, () => {
      expect(FormStackUtil.getFormComponentId({} as CardItemInfo)).assertEqual('');
      let card: CardItemInfo = FormStackTestUtil.createCardItemInfo('123456');
      const componentId: string = `${FormStackConstants.FORM_STACK_ID_PREFIX}_${card.bundleName}_${card.cardId}`;
      expect(FormStackUtil.getFormComponentId(card)).assertEqual(componentId);
      expect(FormStackUtil.getFormComponentId(card, true)).assertEqual(`${componentId}_WithName`);
    });

    it('isValidCard', 0, () => {
      let card: CardItemInfo = {
        cardId: '123456',
        bundleName: 'com.ohos.photos',
      } as CardItemInfo;

      expect(FormStackUtil.isValidCard(card)).assertEqual(true);
    });

    it('isValidCardType', 0, () => {
      expect(FormStackUtil.isValidCardType(0)).assertEqual(false);
      expect(FormStackUtil.isValidCardType(1)).assertEqual(true);
      expect(FormStackUtil.isValidCardType(5)).assertEqual(false);
    });

    it('isPositive', 0, () => {
      expect(FormStackUtil.isPositive(1)).assertTrue();
      expect(FormStackUtil.isPositive(0)).assertFalse();
      expect(FormStackUtil.isPositive(-1)).assertFalse();
    });

    it('isInvalidFormStackList', 0, () => {
      expect(FormStackUtil.isInvalidFormStackList<number>([])).assertTrue();
      expect(FormStackUtil.isInvalidFormStackList<number>([1])).assertTrue();
      expect(FormStackUtil.isInvalidFormStackList<number>([1, 2])).assertFalse();
    });

    it('isNumberEqual', 0, () => {
      expect(FormStackUtil.isNumberEqual(0, 0.01)).assertFalse();
      expect(FormStackUtil.isNumberEqual(0.012, 0.01)).assertFalse();
      expect(FormStackUtil.isNumberEqual(0.0121, 0.0122)).assertTrue();
    });

    it('isValidImage', 0, () => {
      expect(FormStackUtil.isValidImage()).assertFalse();
    });

    it('getFormComponentId', 0, () => {
      expect(FormStackUtil.getFormStackComponentId('')).assertEqual('');
      const formStackId: string = '123456';
      expect(FormStackUtil.getFormStackComponentId(formStackId))
        .assertEqual(`${FormStackConstants.FORM_STACK_ID_PREFIX}_${formStackId}`);
    });

    it('isRectExistComponent', 0, () => {
      expect(!FormStackUtil.isRectExistComponent(null)).assertTrue();
      expect(!FormStackUtil.isRectExistComponent(new RectInfo())).assertTrue();
      expect(!FormStackUtil.isRectExistComponent({
        left: 0,
        right: 1,
      } as RectInfo)).assertTrue();
      expect(!FormStackUtil.isRectExistComponent({
        top: 0,
        bottom: 1,
      } as RectInfo)).assertTrue();
      expect(!FormStackUtil.isRectExistComponent({
        top: 0,
        bottom: 1,
        left:0,
        right: 1,
      } as RectInfo)).assertFalse();
    });

    it('isNumberEqualTest1', 0, () => {
      expect(FormStackUtil.isNumberEqual(Number.NaN, Number.NaN)).assertFalse();
    });

    it('updateNameTest1', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(ResourceManager.getInstance(),
        ResourceManager.getInstance().getAppNameWithCache);
      when(mockFunc)().afterReturn('');

      mocker.clear(ResourceManager.getInstance());
      mocker.clearAll();
    });

    it('isTargetItemInCurPageTest1', 0, () => {
      let targetPage: number = 1;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(PageDesktopModel.getInstance(),PageDesktopModel.getInstance().getPageIndex);
      when(mockFunc)().afterReturn(1);

      FormStackUtil.isTargetItemInCurPage(targetPage);
      mocker.clear(PageDesktopModel.getInstance());
      mocker.clearAll();
    });

    it('isFormStackLayoutItemInvalid', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc1 = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      expect(FormStackUtil.isFormStackLayoutItemInvalid(undefined)).assertTrue();
      let mockFunc2 = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      expect(FormStackUtil.isFormStackLayoutItemInvalid(undefined)).assertTrue();

      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();

      let formStackInfo: FormStackItemInfo = FormStackTestUtil.createFormStackItemInfo('123456');
      expect(FormStackUtil.isFormStackLayoutItemInvalid(formStackInfo)).assertFalse();
      formStackInfo = FormStackTestUtil.createFormStackItemInfo('123456', 0);
      expect(FormStackUtil.isFormStackLayoutItemInvalid(formStackInfo)).assertTrue();
    });

    it('getFormStackMaskExtraWidth', 0, () => {
      expect(FormStackUtil.getFormStackMaskExtraWidth(0)).assertEqual(
        FormStackConstants.FORM_STACK_LESS_MASK_EXTRA_WIDTH);

      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunc)().afterReturn(true);
      expect(FormStackUtil.getFormStackMaskExtraWidth(10)).assertEqual(
        FormStackConstants.FORM_STACK_PAD_MORE_MASK_EXTRA_WIDTH);
      when(mockFunc)().afterReturn(false);
      expect(FormStackUtil.getFormStackMaskExtraWidth(10)).assertEqual(
        FormStackConstants.FORM_STACK_MORE_MASK_EXTRA_WIDTH);

      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('getSplitFormId1', 0, () => {
      const idStr = '';
      const formId: string = FormStackUtil.getSplitFormId(idStr);
      expect(idStr === formId).assertTrue();
    });

    it('getSplitFormId3', 0, () => {
      const idStr = 'testIdStr';
      const formId: string = FormStackUtil.getSplitFormId(idStr);
      expect(idStr === formId).assertTrue();
    });

    it('getSplitFormId4', 0, () => {
      const idStr = 'FormSackView_123';
      const formId: string = FormStackUtil.getSplitFormId(idStr);
      expect('123' === formId).assertTrue();
    });
  });
}