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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { SignalModel } from '../../../../../main/ets/default/signalModel';
import Constants from '../../../../../main/ets/default/common/constants';
export default function SignalModelTest() {
  describe('SignalModelTest', () => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })
    it('initSignalModel', 0, () => {
      let signalModel: SignalModel = new SignalModel();
      expect(signalModel !== undefined).assertTrue();
    });
    it('initSignalModel_test_1', 0, () => {
      let signalModel: SignalModel = new SignalModel();
      signalModel.initSignalModel();
      expect(signalModel !== undefined).assertTrue();
    });
    it('isAvailableTest', 0, () => {
      let signalModel: SignalModel = new SignalModel();
      expect(signalModel.isAvailable()).assertTrue();
    });
    it('isAvailableTest02', 0, () => {
      let signalModel: SignalModel = new SignalModel();
      expect(signalModel.isAvailable()).assertTrue();
    });

    it('initObserverTest', 0, () => {
      let signalModel: SignalModel = new SignalModel();
      signalModel.initObserver();
      expect(signalModel !== undefined).assertTrue();
    });
    it('isTelecomTest', 0, () => {
      let signalModel: SignalModel = new SignalModel();
      let isTelecomTestRes = signalModel.isTelecom(Constants.TELECOM_CDMA_PLMN);
      expect(isTelecomTestRes).assertTrue();
      let isTelecomTestRes1 = signalModel.isTelecom(Constants.TELECOM_CDMA2_PLMN);
      expect(isTelecomTestRes1).assertTrue();
      let isTelecomTestRes2 = signalModel.isTelecom(Constants.TELECOM_FDD_PLMN);
      expect(isTelecomTestRes2).assertTrue();
      let isTelecomTestRes3 = signalModel.isTelecom('test');
      expect(isTelecomTestRes3).assertFalse();
    });
    it('unInitSignalModelTest', 0, () => {
      let signalModel: SignalModel = new SignalModel();
      signalModel.uninitSignalModel();
      expect(signalModel !== undefined).assertTrue();
    });
  });
}