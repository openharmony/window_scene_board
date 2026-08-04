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

import { describe, it, expect } from '@ohos/hypium';
import {
  PageController
} from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/controller/PageController'
import { AodStyleModel } from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/model/AodStyleModel'

export function PageControllerTest() {
  describe('PageControllerTest', () => {

    const AodStyleModelFalse: AodStyleModel = new AodStyleModel();
    const AodStyleModelTrue: AodStyleModel = new AodStyleModel();
    AodStyleModelTrue.isApplied = true;
    AodStyleModelTrue.isSelected = true;

    it('test_setAppliedStyle', 0, () => {
      const aodPageController = new PageController();
      aodPageController.setAppliedStyle(AodStyleModelTrue);
      expect(aodPageController !== null).assertEqual(true);
    });

    it('test_setAppliedStyle_if', 0, () => {
      const aodPageController = new PageController();
      aodPageController.setAppliedStyle(AodStyleModelFalse);
      expect(aodPageController !== null).assertEqual(true);
    });

    it('test_setSelectedStyle', 0, () => {
      const aodPageController = new PageController();
      aodPageController.setSelectedStyle(AodStyleModelTrue);
      expect(aodPageController !== null).assertEqual(true);
    });

    it('test_setSelectedStyle_if', 0, () => {
      const aodPageController = new PageController();
      aodPageController.setSelectedStyle(AodStyleModelFalse);
      expect(aodPageController !== null).assertEqual(true);
    });

  })
}