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
import { describe, it, expect } from '@ohos/hypium'

import {
  AodEventName,
  AodSceneType,
  PageName,
  StyleGroupName
} from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/constant/Constant';

export function ConstantTest() {
  describe('ConstantTest', () => {

    it('ConstantTest_PageName', 0, () => {
      const pageName1 = PageName.INVALID;
      const pageName2 = PageName.SETTING;
      const pageName3 = PageName.MAIN;
      const pageName4 = PageName.PREVIEW;
      expect(pageName1 !== null).assertEqual(true);
    })

    it('ConstantTest_AodSceneType', 0, () => {
      const aodSceneType1 = AodSceneType.INVALID;
      const aodSceneType2 = AodSceneType.SETTING;
      const aodSceneType3 = AodSceneType.SCREEN_LOCK;
      expect(aodSceneType1 !== null).assertEqual(true);
    })

    it('ConstantTest_StyleGroupName', 0, () => {
      const styleGroupName1 = StyleGroupName.INVALID;
      const styleGroupName2 = StyleGroupName.FULL_SCREEN;
      const styleGroupName3 = StyleGroupName.WINDOW;
      const styleGroupName4 = StyleGroupName.MY_DOWNLOAD;
      const styleGroupName5 = StyleGroupName.THEMES;
      const styleGroupName6 = StyleGroupName.CLASSIC;
      expect(styleGroupName1 !== null).assertEqual(true);
    })

    it('ConstantTest_AodEventName', 0, () => {
      const aodEventName = AodEventName.GESTURE_BACK;
      expect(aodEventName !== null).assertEqual(true);
    })

  });

}