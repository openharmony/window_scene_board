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
import { BusinessError } from '@kit.BasicServicesKit';
import { describe, expect, it, Level } from '@ohos/hypium';
import { checkNumber } from '@ohos/themeservicebase/Index';
import { RemoteCode } from '@ohos/themeservicebase/src/main/ets/remote/RemoteCode';

export default function ParamInspectorTest() {
  describe('paramInspectorTest', () => {
    it('test01_validNumber', Level.LEVEL0, () => {
      expect(checkNumber(1, 20)(2)).assertEqual(2);
      expect(checkNumber(1, 20)(20)).assertEqual(20);
      expect(checkNumber(1, 20)(1)).assertEqual(1);
    })

    it('test02_InvalidNumber', Level.LEVEL0, () => {
      try {
        expect(checkNumber(1, 20)(0)).assertEqual(0);
      } catch (err) {
        expect((err as BusinessError).code).assertEqual(RemoteCode.ERR_PARAM);
      }

      try {
        expect(checkNumber(1, 20)(21)).assertEqual(21);
      } catch (err) {
        expect((err as BusinessError).code).assertEqual(RemoteCode.ERR_PARAM);
      }
    })
  })
}