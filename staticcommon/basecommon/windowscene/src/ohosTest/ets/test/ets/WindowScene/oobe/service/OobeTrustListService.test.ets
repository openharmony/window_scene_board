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

import { describe, it, expect, beforeEach} from '@ohos/hypium';
import {
  OobeTrustListService,
  RequestMethod,
} from '../../../../../../../main/ets/oobe/service/OobeTrustListService';
import {
  AddTrustListResult,
} from '../../../../../../../main/ets/oobe/trustlist/TrustListOobeManager';
import {
  CallMessage,
  Response
} from '../../../../../../../main/ets/oobe/service/BaseServiceStub';

export function OobeTrustListServiceTest() {
  describe('OobeTrustListServiceTest', () => {
    let service: OobeTrustListService;
    beforeEach(() => {
      service = new OobeTrustListService();
    });

    it('onCall_InvalidJsonTest', 0, async () => {
      const json: string = 'invalid json';
      const result = await service.onCall(json);
      expect(result).assertEqual(Response.INVALID_METHOD);
    });

    it('onCall_InvalidCallMessageParamTest', 0, async () => {
      const json = '{"method": 0}';
      const result = await service.onCall(json);
      expect(result).assertEqual(Response.INVALID_METHOD);
    });

    it('onCall_EmptyMethodTest', 0, async () => {
      const json = '{"method": ""}';
      const result = await service.onCall(json);
      expect(result).assertEqual(Response.INVALID_METHOD);
    });

    it('onCall_UnknownMethodTest', 0, async () => {
      const json = '{"method": "unknownMethod"}';
      const result = await service.onCall(json);
      expect(result).assertEqual(Response.UNKNOWN_METHOD);
    });

    it('onCall_ValidMethodTest', 0, async () => {
      const json = `{"method": "${RequestMethod.ADD_OOBE_TRUST_LIST}"}`;
      const result = await service.onCall(json);
      expect(result === JSON.stringify(AddTrustListResult.FAILED_INVALID_CALLER)).assertTrue();
    });

    it('isCallMessageTest_NullParamTest', 0, () => {
      const result = service['isCallMessage'](null);
      expect(result).assertFalse();
    });

    it('isCallMessageTest_NonObjectParamTest', 0, () => {
      const result = service['isCallMessage']('not object');
      expect(result).assertFalse();
    });

    it('isCallMessageTest_NonMethodParamTest', 0, () => {
      interface NoMethod {
        noMethod: string,
      }

      const noMethodParam: NoMethod = {
        noMethod: 'noMethod',
      }
      const result = service['isCallMessage'](noMethodParam);
      expect(result).assertFalse();
    });

    it('isCallMessageTest_NonStringMethodParamTest', 0, () => {
      interface NonStringMethod {
        method: number,
      }

      const nonStringMethodParam: NonStringMethod = {
        method: 0
      };
      const result = service['isCallMessage'](nonStringMethodParam);
      expect(result).assertFalse();
    });

    it('isCallMessageTest_ValidParamTest', 0, () => {
      const callMessageParam: CallMessage = {
        method: 'method',
      };
      const result = service['isCallMessage'](callMessageParam);
      expect(result).assertTrue();
    });
  });
}
