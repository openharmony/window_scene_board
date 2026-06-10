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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { NetSpeedController } from '../../../main/ets/default/controller/NetSpeedController';


export default function NetSpeedController() {
  describe('NetSpeedControllerTest', () => {
    beforeAll((): void => {
    })
    beforeEach((): void => {
    })
    afterEach((): void => {
    })
    afterAll((): void => {
    })
    it('initNetSpeedController', 0, () => {
      let initNetSpeedController: NetSpeedController = new NetSpeedController();
      expect(initNetSpeedController !== undefined).assertTrue();
    });
    it('getLinkedInfo', 0, () => {
      let getLinkedInfo: NetSpeedController = new NetSpeedController();
      expect(getLinkedInfo !== undefined).assertTrue();
    });
    it('handleUpdateState', 0, () => {
      let handleUpdateState: NetSpeedController = new NetSpeedController();
      expect(handleUpdateState !== undefined).assertTrue();
    });
  });
}