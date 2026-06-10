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
import { WallpaperModelTest } from './model/WallpaperModel.test';
import { DualInstanceHandlerTest } from './themeassistant/DualInstanceHandler.test';
import { EngineContainerManagerTest } from './themeassistant/EngineContainerManager.test';
import { LoadStrategyTest } from './themeassistant/LoadStrategy.test';
import TsActivationStrategyTest from './themeassistant/TsActivationStrategy.test';

export default function PipelineDemoSuite() {
  describe("launcher_components", () => {
  });

  describe("ExtremeAnimatronix", () => {
    EngineContainerManagerTest();
    DualInstanceHandlerTest();
    LoadStrategyTest();
    TsActivationStrategyTest();
  });

  // 桌面编辑DT测试套
  describe("sceneboard_desktopedit",  () =>  {
    WallpaperModelTest();
  });
}