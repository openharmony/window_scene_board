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
import { FormStackExpandViewData } from '../../../../../main/ets/viewmodel/FormStackExpandViewData';
import { FormStackExpandLateralAnimate } from '../../../../../main/ets/viewmodel/FormStackExpandLateralAnimate';
import { FormStackExpandLayoutModel } from '../../../../../main/ets/common/FormStackExpandLayoutModel';
import { FormStackTestUtil } from '../common/FormStackTestUtil';

export function FormStackExpandLateralAnimateTest() {
  describe('FormStackExpandLateralAnimateTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('onTrashImgAngleChange', 0, () => {
      let animate: FormStackExpandLateralAnimate = new FormStackExpandLateralAnimate();
      let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(0);
      let layoutModel: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();
      animate.initData(viewData, layoutModel);
      animate.onTrashImgAngleChange(0, 0);
      viewData = FormStackTestUtil.createFormStackExpandViewData(3);
      animate.initData(viewData, layoutModel);
      animate.onTrashImgAngleChange(0, 0);
      expect(viewData.mItemInfoList[0].trashHeadAngle).assertEqual(0);
    });

    it('restoreTrashImgAngle', 0, () => {
      let animate: FormStackExpandLateralAnimate = new FormStackExpandLateralAnimate();
      let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(0);
      let layoutModel: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();
      animate.initData(viewData, layoutModel);
      animate.restoreTrashImgAngle(0, () => {});
      viewData = FormStackTestUtil.createFormStackExpandViewData(3);
      animate.initData(viewData, layoutModel);
      animate.restoreTrashImgAngle(0, () => {});

      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackDebugCmd.getInstance(),
        FormStackDebugCmd.getInstance().isNeedExpandAnimate);
      when(mockFunc)().afterReturn(false);
      animate.restoreTrashImgAngle(0, () => {});
      when(mockFunc)().afterReturn(true);
      animate.restoreTrashImgAngle(0, () => {});

      mocker.clear(FormStackDebugCmd.getInstance());
      mocker.clearAll();
    });

    it('execCardAvoid', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let animate: FormStackExpandLateralAnimate = new FormStackExpandLateralAnimate();
        let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(0);
        let layoutModel: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();
        animate.initData(viewData, layoutModel);
        animate.execCardAvoid(0, 0);
        animate.execCardFillingRestore(0, 0);
        viewData = FormStackTestUtil.createFormStackExpandViewData(3);
        animate.initData(viewData, layoutModel);
        animate.execCardAvoid(0, 0);

        let mockFunc = mocker.mockFunc(FormStackDebugCmd.getInstance(),
          FormStackDebugCmd.getInstance().isNeedExpandAnimate);
        when(mockFunc)().afterReturn(false);
        animate.execCardAvoid(0, 0, 0);
        animate.execCardLateralEnd(0, 0);
        animate.execCardFillingRestore(0, 0);
        animate.execLastCardFilling({});
        when(mockFunc)().afterReturn(true);
        animate.execCardAvoid(0, 0, 0);
        animate.execCardLateralEnd(0, 0);
        animate.execCardFillingRestore(0, 0);
        animate.execLastCardFilling({});

        mocker.clear(FormStackDebugCmd.getInstance());
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('execCardAvoidBack_test01', 0, () => {
      let animate: FormStackExpandLateralAnimate = new FormStackExpandLateralAnimate();
      (animate as object)['mLayoutModel'] = undefined;
      (animate as object)['execCardAvoidBack']();
      expect(animate).not().assertUndefined();
    });

    it('restoreCardFilling_test01', 0, () => {
      let animate: FormStackExpandLateralAnimate = new FormStackExpandLateralAnimate();
      (animate as object)['mLayoutModel'] = undefined;
      (animate as object)['restoreCardFilling']();
      expect(animate).not().assertUndefined();
    });

    it('getLastCardEndTranslateY_test01', 0, () => {
      let animate: FormStackExpandLateralAnimate = new FormStackExpandLateralAnimate();
      (animate as object)['mLayoutModel'] = undefined;
      (animate as object)['getLastCardEndTranslateY']();
      expect(animate).not().assertUndefined();
    });
  });
}