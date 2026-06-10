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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import sNfcController from '../../../../main/ets/com/ohos/controller/NfcController'

export default function NfcControllerTest() {
  describe('NfcControllerTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_NfcController_controllerType', 0, () => {
      expect(sNfcController === (globalThis as object)['Model.NfcController']).assertTrue();
    })

    it('test_NfcDataType', 0, () => {
      expect(sNfcController.mNfcData === sNfcController.getData()).assertTrue();
    })
  })
}