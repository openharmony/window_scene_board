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
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect
} from '@ohos/hypium';
import { SCBScreenProperty } from '../../../../../main/ets/screen/session/SCBScreenSession';
import { RecentViewParam } from '../../../../../main/ets/recent/RecentViewParam';
import type { SCBPropertyChangeReason } from '../../../../../main/ets/screen/session/SCBScreenSessionManager';

let screenProperty: SCBScreenProperty = new SCBScreenProperty();
let reason: SCBPropertyChangeReason;
let recentViewParam: RecentViewParam = new RecentViewParam(screenProperty);

export function RecentViewParamTest() {
  describe('RecentViewParamTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('RecentViewParam_test_initAll', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_onScreenChange', 0, (): void => {
      recentViewParam.onScreenChange(screenProperty, reason);
      let rotation:number = screenProperty.rotation;
      expect(rotation).assertEqual(0);
    })

    it('RecentViewParam_test_toString', 0, (): void => {
      expect(recentViewParam.toString()).assertEqual('recentTransX: 0, recentTransY: 0, recentAlpha: 1, recentW:0, recentH:0')
    })
    it('RecentViewParam_test_initAll_copy_01', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_02', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_03', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_04', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_05', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_06', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_07', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_08', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_09', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_10', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_11', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_12', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_13', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_14', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_15', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_16', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_17', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_18', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_19', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_20', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_21', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_22', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_23', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_24', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_25', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_26', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_27', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_28', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_29', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_30', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_31', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_32', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_33', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_34', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_35', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_36', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_37', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_38', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_39', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_40', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_41', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_42', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_43', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_44', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_45', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_46', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_47', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_48', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_49', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })

    it('RecentViewParam_test_initAll_copy_50', 0, (): void => {
      recentViewParam.initAll();
      expect(recentViewParam.recentW).assertEqual(0);
      expect(recentViewParam.recentH).assertEqual(0);
      expect(recentViewParam.recentPadding).assertEqual(0);
      expect(recentViewParam.recentTransX).assertEqual(0);
      expect(recentViewParam.recentTransY).assertEqual(0);
      expect(recentViewParam.recentAlpha).assertEqual(1);
    })
  })
}