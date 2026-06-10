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
import VolumeWindowController from '../main/ets/com/ohos/common/VolumeWindowController'

export function VolumeWindowControllerTest() {
  describe('VolumeWindowControllerTest', function () {
    beforeAll(function () {

    })
    beforeEach(function () {

    })
    afterAll(function () {

    })
    afterEach(function () {

    })

    it('createInstance011', 01, function () {
      let controller: VolumeWindowController = VolumeWindowController.getInstance();
      expect(controller === undefined).assertFalse();
      expect(controller === undefined).assertFalse();
      controller.init();
    })

    it('createController', 01, function () {
      let controller: VolumeWindowController = VolumeWindowController.getInstance();
      controller.init();
      expect(controller === undefined || controller === null).assertFalse();
      expect(controller === undefined || controller === null).assertFalse();
    })
  })
}