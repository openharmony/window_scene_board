/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
} from '@ohos/hypium'
import { SCBDeviceScreenConfig } from '../../../../../../main/ets/config/SCBDeviceScreenConfig';

export function SCBDeviceScreenConfigTest() {
  describe('SCBDeviceScreenConfigTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('getRotationPolicyMapTest', 0, () => {
      let rotationPolicyMap: Map<number, boolean>  =  SCBDeviceScreenConfig.getInstance().getRotationPolicyMap();
      expect(rotationPolicyMap).assertEqual(SCBDeviceScreenConfig.getInstance().getRotationPolicyMap());
    })

    it('getRightPowerButtonTest', 0, () => {
      expect(SCBDeviceScreenConfig.getInstance().getRightPowerButton()).assertEqual(true);
    })

  })
}