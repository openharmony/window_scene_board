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
import { FormStackConstants } from '../../../../../main/ets/common/FormStackConstants';

import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  MockKit,
  ArgumentMatchers,
  when,
} from '@ohos/hypium';
import { FormStackExpandConfig } from '../../../../../main/ets/common/FormStackExpandConfig';
import { FormStackExpandLayoutModel } from '../../../../../main/ets/common/FormStackExpandLayoutModel';
import { FormStackUtil } from '../../../../../main/ets/common/FormStackUtil';
import type { LayoutAnimateResult } from '../common/FormStackTestUtil';
import { FormStackTestUtil } from '../common/FormStackTestUtil';

export function FormStackExpandLayoutModelTest() {
  describe('FormStackExpandLayoutModelTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('initLayoutParam', 0, () => {
      let layout: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();
      let config: FormStackExpandConfig = FormStackExpandConfig.getInstance();
      FormStackTestUtil.initDefaultConfig(config);

      layout.initData(config);
      expect(FormStackUtil.isNumberEqual(layout.mChildCount, config.mChildCount)).assertEqual(true);
      expect(FormStackUtil.isNumberEqual(layout.mDisplayWidth, config.mDisplayWidth)).assertEqual(true);
      expect(FormStackUtil.isNumberEqual(layout.mFormHeight, config.mFormShowHeight)).assertEqual(true);
      expect(FormStackUtil.isNumberEqual(layout.mPreShowSize, config.mPreShowSize)).assertEqual(true);
      layout.resetData();
      expect(layout.mChildCount).assertEqual(0);
    });

    it('getChildStart', 0, () => {
      let layout: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();
      let config: FormStackExpandConfig = FormStackExpandConfig.getInstance();
      FormStackTestUtil.initDefaultConfig(config);

      let layoutResult: LayoutAnimateResult = FormStackTestUtil.getLayoutAnimateResult();
      let childStart: number = layout.getChildStart(config);
      expect(FormStackUtil.isNumberEqual(childStart, layoutResult.childStart[0]));
    });

    it('getFullChildStart', 0, () => {
      let layout: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();
      let config: FormStackExpandConfig = FormStackExpandConfig.getInstance();
      FormStackTestUtil.initDefaultConfig(config, 10);

      let layoutResult: LayoutAnimateResult = FormStackTestUtil.getMaxShowAnimateResult();
      let childStart: number = layout.getChildStart(config);
      expect(FormStackUtil.isNumberEqual(childStart, layoutResult.childStart[0]));
    });

    it('cacheChildSlideStartAttr', 0, () => {
      let layout: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();
      layout.cacheChildSlideStartAttr(-1, 0, 0, 0, false);
      expect(layout.mChildInitTranslateYList.length).assertEqual(0);
    });

    it('updateChildStart', 0, () => {
      let layout: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();
      let config: FormStackExpandConfig = FormStackExpandConfig.getInstance();
      config.mLayoutType = 1;
      layout.initData(config);
      layout.updateChildStart(0, 0);
    });

    let layout: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();
    let config: FormStackExpandConfig = FormStackExpandConfig.getInstance();

    it('initVisibility_test01', 0, () => {
      layout.mChildCount = 0;
      layout.mChildRestoreVisibilityList = [true, true, false];
      layout.initVisibility(true);
      expect(layout).not().assertUndefined();
    });

    it('getRotationByIndex_test01', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(FormStackConstants.FORM_DELTA_ROTATION_X, FormStackConstants.FORM_DELTA_ROTATION_X.get);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);
      (layout as object)['getRotationByIndex'](1, 2, 3);
      expect(layout).not().assertUndefined();
      mocker.clear(FormStackConstants.FORM_DELTA_ROTATION_X);
    });
  });
}