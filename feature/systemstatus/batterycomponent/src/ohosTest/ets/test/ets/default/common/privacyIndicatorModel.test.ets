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
import { componentUtils } from '@kit.ArkUI';
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, DEFAULT } from '@ohos/hypium';
import {
  CircleSize,
  getCircleSize,
  controlIsTrue,
  getBatteryHeight,
  PrivacyIndicatorViewModel,
} from '../../../../../../main/ets/default/common/privacyIndicatorModel'

export function PrivacyIndicatorModelTest01() {
  const privacyIndicatorViewModel = new PrivacyIndicatorViewModel();
  describe('PrivacyIndicatorModelTest01', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('PrivacyIndicatorModel_getCircleSizeTest01', DEFAULT, () => {
      const size: CircleSize = getCircleSize();
      expect(size !== undefined).assertTrue();
    });

    it('PrivacyIndicatorModel_controlIsTrueTest01', DEFAULT, () => {
      const isTrue: boolean = controlIsTrue(1, 1);
      expect(isTrue).assertInstanceOf('Boolean');
    });

    it('PrivacyIndicatorModel_controlIsTrueTest01', DEFAULT, () => {
      const isTrue: boolean = controlIsTrue(1, 1);
      expect(isTrue).assertInstanceOf('Boolean');
    });

    it('PrivacyIndicatorModel_getBatteryHeightTest01', DEFAULT, () => {
      const size: componentUtils.Size = getBatteryHeight();
      expect(size !== undefined).assertTrue();
    });

    it('PrivacyIndicatorModel_setStatusBarPaddingRightTest01', DEFAULT, () => {
      privacyIndicatorViewModel.setStatusBarPaddingRight(20);
      expect((privacyIndicatorViewModel as object)['statusBarPaddingRight']).assertEqual(20);
    });
  })
}

export function PrivacyIndicatorModelTest02() {
  const privacyIndicatorViewModel = new PrivacyIndicatorViewModel();
  describe('PrivacyIndicatorModelTest02', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('PrivacyIndicatorModel_getActivePrivacyIndicatorTest01', DEFAULT, () => {
      const res = privacyIndicatorViewModel.getActivePrivacyIndicator();
      expect(res).assertInstanceOf('Array');
    });

    it('PrivacyIndicatorModel_setCallbackTest01', DEFAULT, () => {
      const cb = () => {};
      privacyIndicatorViewModel.setCallback(cb);
      expect((privacyIndicatorViewModel as object)['mCallback']).assertDeepEquals(cb);
    });

    it('PrivacyIndicatorModel_getCircleTranslateTest01', DEFAULT, () => {
      const translate: number = privacyIndicatorViewModel.getCircleTranslate();
      expect(translate).assertInstanceOf('Number');
    });
  })
}
