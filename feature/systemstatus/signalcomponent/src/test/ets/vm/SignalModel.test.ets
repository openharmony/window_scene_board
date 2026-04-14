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
import { SignalModel } from '../../../main/ets/default/signalModel';


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
    it('getSignalInformation', 0, () => {
      let signalModel: SignalModel = new SignalModel();
      expect(signalModel.getSignalInformation(0)).assertTrue();
    });
    it('getSignalInformation', 1, () => {
      let signalModel: SignalModel = new SignalModel();
      expect(signalModel.getSignalInformation(1)).assertTrue();
    });
    it('handleDataConnectState', 0, () => {
      let signalModel: SignalModel = new SignalModel();
      expect(signalModel.handleDataConnectState(0)).assertTrue();
    });
    it('handleDataConnectState', 1, () => {
      let signalModel: SignalModel = new SignalModel();
      expect(signalModel.handleDataConnectState(1)).assertTrue();
    });
    it('handleEflForbidden', 0, () => {
      let signalModel: SignalModel = new SignalModel();
      expect(signalModel.handleEflForbidden()).assertTrue();
    });
    it('handleEmergency', 0, () => {
      let signalModel: SignalModel = new SignalModel();
      expect(signalModel.handleEmergency()).assertTrue();
    });
  });
}