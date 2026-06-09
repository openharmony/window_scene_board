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

import { CheckEmptyUtils } from '@ohos/basicutils';
import { desktopUtil } from '@ohos/componenthelper';

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
import { CardItemInfo, CommonConstants, LayoutViewModel } from '@ohos/launchercommon';
import { FormStackExpandConfig } from '../../../../../main/ets/common/FormStackExpandConfig';
import { FormStackUtil } from '../../../../../main/ets/common/FormStackUtil';
import { FormStackTestUtil } from './FormStackTestUtil';

export function FormStackExpandConfigTest() {
  describe('FormStackExpandConfigTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('getInstance', 0, () => {
      let instance: FormStackExpandConfig = FormStackExpandConfig.getInstance();
      FormStackTestUtil.initDefaultConfig(instance);
    });

    it('resetData', 0, () => {
      let instance: FormStackExpandConfig = FormStackExpandConfig.getInstance();
      FormStackTestUtil.initDefaultConfig(instance);

      instance.resetData();
      expect(instance.mFormHeight === 0).assertTrue();
      expect(instance.mFormWidth === 0).assertTrue();
      expect(instance.mFormHeight === 0).assertTrue();
      expect(instance.mFormWidth === 0).assertTrue();
      expect(instance.mChildCount === 0).assertTrue();
      expect(instance.mMaxShowRatio === 0).assertTrue();
      expect(instance.mMaxShowCount === 0).assertTrue();
      expect(instance.mLayoutType === CommonConstants.CARD_DIMENSION_2x2).assertTrue();
    });

    it('initDisplayInfo', 0, () => {
      let instance: FormStackExpandConfig = FormStackExpandConfig.getInstance();
      instance.resetData();
      instance.initDisplayInfo();
      let layoutModel: LayoutViewModel = LayoutViewModel.getInstance();
      expect(FormStackUtil.isNumberEqual(
        instance.mFullDisplayHeight, layoutModel.getScreenHeight()) !== undefined).assertTrue();
      expect(
        FormStackUtil.isNumberEqual(instance.mDisplayWidth, layoutModel.getScreenWidth()) !== undefined).assertTrue();
      expect(FormStackUtil.isNumberEqual(
        instance.mMarginTop,layoutModel.calculateDesktop()?.mDesktopMarginTop) === undefined).assertFalse();
    });

    it('isSupportFormStack', 0, () => {
      expect(FormStackExpandConfig.isSupportFormStack()).assertTrue();
    });

    it('updateFormLayoutInfo', 0, () => {
      let instance: FormStackExpandConfig = FormStackExpandConfig.getInstance();
      let card: CardItemInfo = FormStackTestUtil.createCardItemInfo('123456');
      let ret: boolean = instance.updateFormLayoutInfo(card, []);
      expect(ret).assertFalse();
      ret = instance.updateFormLayoutInfo(card, [153, 153]);
      expect(ret).assertTrue();

      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(FormStackExpandConfig, FormStackExpandConfig.isSupportExpandFromGrid);
      when(mockFunc)().afterReturn(true);

      instance.updateFormLayoutInfo(card, [0, 0]);
      instance.updateFormLayoutInfo(card, [153, 153]);
      expect(instance.mIsExpandCenter).assertFalse();

      mocker.clear(FormStackExpandConfig);
      mocker.clearAll();
    });

    let instance: FormStackExpandConfig = FormStackExpandConfig.getInstance();

    it('test_setOuterFormStackExpandScale', 0, () => {
      let instance: FormStackExpandConfig = FormStackExpandConfig.getInstance();
      instance.setOuterFormStackExpandScale(2.2);
      expect(instance.mOuterFormStackExpandScale).assertEqual(2.2);
    })
  });
}