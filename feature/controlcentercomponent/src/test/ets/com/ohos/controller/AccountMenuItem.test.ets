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
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when } from '@ohos/hypium';
import sAccountMenuItem from '../../../../../main/ets/com/ohos/view/accountMenuItem';
import { ToggleData } from '../../../../../main/ets/com/ohos/common/Constants';

export function AccountMenuItem() {
  describe('AccountMenuItem', (): void => {

    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('AccountMenuItem001', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem002', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem003', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem004', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem005', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem006', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem007', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem008', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem009', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem010', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem011', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem012', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem013', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem014', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem015', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem016', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem017', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem018', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem019', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem020', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem021', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem022', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem023', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem024', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem025', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem026', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem027', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem028', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem029', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem030', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem031', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem032', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem033', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem034', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem035', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem036', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem037', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem038', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem039', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem040', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem041', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem042', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem043', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem044', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem045', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem046', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem047', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem048', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem049', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem050', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem051', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem052', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem053', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem054', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem055', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem056', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem057', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem058', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem059', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem060', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem061', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem062', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem063', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem064', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem001', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem002', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem003', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem004', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem005', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem006', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem007', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem008', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem009', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem010', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem011', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem012', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem013', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem014', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem015', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem016', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem017', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem018', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem019', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem020', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem021', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem022', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem023', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem024', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem025', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem026', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem027', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem028', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem029', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem030', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem031', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem032', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem033', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem034', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem035', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem036', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem037', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem038', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem039', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem040', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem041', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem042', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem043', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem044', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem045', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem046', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem047', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem048', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem049', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem050', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem051', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem052', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem053', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem054', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem055', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem056', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem057', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem058', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem059', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem060', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem061', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem062', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem063', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem064', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem065', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem066', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem067', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem068', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem069', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem070', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem071', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem072', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem073', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem074', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem075', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem076', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem077', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem078', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem079', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem080', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem081', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem082', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem083', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem084', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem085', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem086', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem087', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem088', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem089', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem090', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })
  })
}