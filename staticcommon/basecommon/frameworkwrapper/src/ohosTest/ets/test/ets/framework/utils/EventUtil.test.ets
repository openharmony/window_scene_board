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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit } from '@ohos/hypium';
import { obtainStartAbilityWithWant, parseEventString } from '../../../../../../main/ets/utils/EventUtil'
import type Want from '@ohos.app.ability.Want';

export function EventUtilTest() {
  describe('EventUtilTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('obtainStartAbilityWithWant', 0, (): void => {
      let mWant: Want = {
        bundleName: '',
        abilityName: ''
      }
      expect(obtainStartAbilityWithWant(mWant)).assertInstanceOf('Object');
    })

    it('parseEventString_with_args_invalid', 0, (): void => {
      let mEventString1: string | undefined = undefined;
      let mEventString2: string | undefined = 'local=1';
      let mEventString3: string | undefined = 'ability=2';
      let mEventString4: string | undefined = 'serviceExt=3';
      let mEventString5: string | undefined = 'nothing=4';
      parseEventString(mEventString1);
      parseEventString(mEventString2);
      parseEventString(mEventString3);
      parseEventString(mEventString4);
      parseEventString(mEventString5);
      expect(true).assertTrue();
    })

    it('parseEventString_with_args_valid', 0, (): void => {
      let mEventString1: string | undefined = 'local=mtest|1';
      let mEventString2: string | undefined = 'ability=bundleName|abilityName|moduleName';
      let mEventString3: string | undefined = 'serviceExt=bundleName|abilityName';
      parseEventString(mEventString1);
      parseEventString(mEventString2);
      parseEventString(mEventString3);
      expect(true).assertTrue();
    })
  })
}