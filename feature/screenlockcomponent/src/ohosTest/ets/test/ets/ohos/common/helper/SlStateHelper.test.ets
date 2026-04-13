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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import { slStateHelper } from '../../../../../../../main/ets/common/helper/SlStateHelper';

export default function SlStateHelperTest() {

  describe('SlStateHelperTest', (): void => {

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_sl_getSlBindState', 0, (): void => {
      slStateHelper.getSlBindState();
      let result = slStateHelper.getSlBindState();
      expect(result).not().assertNull();
    })

    it('test_sl_getSlLockBindState', 0, (): void => {
      slStateHelper.getSlLockBindState();
      let result = slStateHelper.getSlLockBindState();
      expect(result).not().assertNull();
    })

    it('test_sl_getSlLockAnimState', 0, (): void => {
      slStateHelper.getSlLockAnimState();
      let result = slStateHelper.getSlLockAnimState();
      expect(result).not().assertNull();
    })

    it('test_sl_getSlSignBindState', 0, (): void => {
      slStateHelper.getSlSignBindState();
      let result = slStateHelper.getSlSignBindState();
      expect(result).not().assertNull();
    })

    it('test_sl_getSlClockBindState', 0, (): void => {
      slStateHelper.getSlClockBindState();
      let result = slStateHelper.getSlClockBindState();
      expect(result).not().assertNull();
    })

    it('test_sl_getSlClockStaticState', 0, (): void => {
      slStateHelper.getSlClockStaticState();
      let result = slStateHelper.getSlClockStaticState();
      expect(result).not().assertNull();
    })

    it('test_sl_getSlClockAnimState', 0, (): void => {
      slStateHelper.getSlClockAnimState();
      let result = slStateHelper.getSlClockAnimState();
      expect(result).not().assertNull();
    })

    it('test_sl_getSlRootAnimState', 0, (): void => {
      slStateHelper.getSlRootAnimState();
      let result = slStateHelper.getSlRootAnimState();
      expect(result).not().assertNull();
    })
  })
}