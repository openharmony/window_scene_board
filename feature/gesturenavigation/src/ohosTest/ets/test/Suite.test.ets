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

import { describe } from '@ohos/hypium';
import { CommonConstantsTest } from './ets/constants/CommonConstants.test';
import { GestureNavBarSettingsTest } from './ets/GestureNavBarSettings.test';
import SCBNavigationFromFullSceneStateTest
  from './ets/controllers/SceneNavigationController/state/SCBNavigationFromFullSceneState.test';
import SCBNavigationFromHomeStateTest
  from './ets/controllers/SceneNavigationController/state/SCBNavigationFromHomeState.test';
import SCBNavigationFromRecentStateTest
  from './ets/controllers/SceneNavigationController/state/SCBNavigationFromRecentState.test';
import SCBNavigationStateTest from './ets/controllers/SceneNavigationController/state/SCBNavigationState.test';

export default function PipelineDemoSuite() {
  describe("launcher_navigation_for_oh", () => {
    CommonConstantsTest();
    SCBNavigationFromFullSceneStateTest();
    SCBNavigationFromHomeStateTest();
    SCBNavigationFromRecentStateTest();
    SCBNavigationStateTest();
    GestureNavBarSettingsTest();
  });
}