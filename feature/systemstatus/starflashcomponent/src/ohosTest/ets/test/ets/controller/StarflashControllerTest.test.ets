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

import { describe, it, expect } from '@ohos/hypium';
import { StarflashData } from '../../../../../main/ets/common/Constants';
import sStarflashController from '../../../../../main/ets/controller/StarflashController';

export default function starFlashControllerTest() {
  describe('starFlashControllerTest', () => {
    it('initStarFlashController_test', 0, () => {
      expect(sStarflashController !== undefined).assertTrue();
    });

    it('getData_test', 0, () => {
      let dataTest = sStarflashController.getData();
      expect(dataTest instanceof StarflashData).assertTrue();
    });

    it('isAvailable_test', 0, () => {
      expect(sStarflashController.isAvailable()).assertTrue();
    });
  });
}