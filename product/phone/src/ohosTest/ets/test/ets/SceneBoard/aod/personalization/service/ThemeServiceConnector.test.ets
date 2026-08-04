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

import { ArgumentMatchers, describe, expect, it, MockKit, when } from '@ohos/hypium';
import ThemeServiceConnector
  from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/service/ThemeServiceConnector';
import { common } from '@kit.AbilityKit';


export function ThemeServiceConnectorTest() {
  describe('ThemeServiceConnectorTest', () => {

    it('test_connect', 0, () => {
      let context: common.UIAbilityContext = getContext() as common.UIAbilityContext;
      ThemeServiceConnector.connect(context);
      expect(true).assertTrue();
    });

  });
}