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

import { afterAll, beforeAll, it, describe, expect } from '@ohos/hypium';
import { ToggleViewData } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleViewData';
import SuperPrivacyData from '../../../../main/ets/com/ohos/common/SuperPrivacyData';
import { SuperPrivacyController } from '../../../../main/ets/com/ohos/controller/SuperPrivacyController';

export function SuperPrivacyControllerTest() {
  describe('SuperPrivacyControllerTest', (): void => {
    beforeAll((): void => {
      new SuperPrivacyController().onStart();
    });

    afterAll((): void => {
      new SuperPrivacyController().onStop();
    });

    it('isAvailableTest', 0, (): void => {
      let isAvailable: boolean = new SuperPrivacyController().isAvailable();
      expect(isAvailable).assertTrue();
    });

    it("handleClickTest", 0, () => {
      let click: boolean = true;
      click = new SuperPrivacyController().handleOneClick();
      expect(click).assertFalse();
    });

    it("handleLongClickTest", 0, () => {
      let longClick: boolean = true;
      expect(longClick).assertTrue();
    });

    it("getDataTest", 0, () => {
      let data: ToggleViewData | undefined = undefined;
      data = new SuperPrivacyController().getViewData();
      expect(data).not().assertUndefined();
    });
  })
}