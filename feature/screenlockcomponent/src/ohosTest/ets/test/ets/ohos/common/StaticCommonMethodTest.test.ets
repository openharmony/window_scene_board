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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import StaticCommonMethod
  from '../../../../../../../../../feature/screenlockcomponent/src/main/ets/common/StaticCommonMethod';


export default function StaticCommonMethodTest() {

  describe('StaticCommonMethodTest', (): void => {

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_splitTransparencyColor', 0, (): void => {
      StaticCommonMethod.splitTransparencyColor('jfo019085j6464')
      StaticCommonMethod.splitTransparencyColor('#FFAA00CC')
      expect(true).assertTrue();
    })

    it('test_getDefColOfGadget', 0, (): void => {
      const result = StaticCommonMethod.getDefColOfGadget(true)
      expect(result?.color).assertEqual('#3C3C3C');
    })
  })
}