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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect } from '@ohos/hypium';
import { BatterySocEvent } from '../../../../../main/ets/datasharemanager/SysUIDataShareEvent';
import { PureShowEvent } from '../../../../../main/ets/datasharemanager/SysUIDataShareEvent';
import { DataShareMgr } from '../../../../../main/ets/datasharemanager/DataShareManager';

const DEFAULT = 0;

export function BatterySocEventTest() {
  describe('BatterySocEventTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('BatterySocEventTest_init_should_not_return_undefined', DEFAULT, (): void => {
      let BatterySocEventTest: BatterySocEvent = new BatterySocEvent();
      expect(BatterySocEventTest !== undefined).assertTrue();
    })

    it('DataShareManagerTest_init_should_subscribeDataShare', DEFAULT, (): void => {
      DataShareMgr.init(undefined);
      expect(DataShareMgr !== undefined).assertTrue();
    })

    it('PureShowEventTest_init', DEFAULT, (): void => {
      let pureShowEventTest: PureShowEvent = new PureShowEvent();
      expect(pureShowEventTest !== undefined).assertTrue();
    })
  })
}