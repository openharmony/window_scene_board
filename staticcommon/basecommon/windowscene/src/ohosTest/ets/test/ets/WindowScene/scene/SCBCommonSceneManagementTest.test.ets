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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium'
import { SCBSceneContainerSessionTest } from './session/SCBSceneContainerSession.test';
import { SCBRootSceneSessionTest } from './session/SCBRootSceneSession.test';
import { SCBSceneContainerSessionArrayTest } from './session/SCBSceneContainerSessionArray.test';
import { SCBSceneInfoTest } from './session/SCBSceneInfo.test';
import { SCBSceneSessionTest } from './session/SCBSceneSession.test';
import { SCBSceneSessionManagerOneTest } from './session/SCBSceneSessionManager.test';
import { SCBSceneSessionManagerFourTest } from './session/SCBSceneSessionManager4.test';
import { SCBSceneSessionManagerFiveTest } from './session/SCBSceneSessionManager5.test';
import { SCBSceneSessionManagerTest2 } from './session/SCBSceneSessionManager2.test';
import { SCBSceneSessionManagerTest3 } from './session/SCBSceneSessionManager3.test';
import { SCBSceneSessionManagerTest6 } from './session/SCBSceneSessionManager6.test';
import { SCBSceneSessionManagerTest7 } from './session/SCBSceneSessionManager7.test';
import { SCBSceneSessionManagerTest8 } from './session/SCBSceneSessionManager8.test';
import { SCBSpecificSessionTest } from './session/SCBSpecificSession.test';
import { SCBSystemSceneSessionTest } from './session/SCBSystemSceneSession.test';
import { SCBScenePanelManagerTest } from './manager/SCBScenePanelManager.test';
import { SCBScenePanelManagerTwoTest } from './manager/SCBScenePanelManager2.test';

/**
 * 窗口管理底座测试套集合
 */
export default function SCBCommonSceneManagementTest() {
  SCBCommonSceneDataManagementTest();
  SCBSceneSessionManagerTest();
}

/**
 * 窗口数据管理测试套集合
 */
function SCBCommonSceneDataManagementTest() {
  SCBSceneInfoTest();
  SCBSceneSessionTest();
  SCBSpecificSessionTest();
  SCBRootSceneSessionTest();
  SCBSystemSceneSessionTest();
  SCBSceneContainerSessionTest();
  SCBSceneContainerSessionArrayTest();

  SCBScenePanelManagerTest();
  SCBScenePanelManagerTwoTest();
}

/**
 * SceneSessionManager测试套集合
 */
function SCBSceneSessionManagerTest() {
  SCBSceneSessionManagerOneTest();
  SCBSceneSessionManagerFourTest();
  SCBSceneSessionManagerFiveTest();
  SCBSceneSessionManagerTest2();
  SCBSceneSessionManagerTest3();
  SCBSceneSessionManagerTest6();
  SCBSceneSessionManagerTest7();
  SCBSceneSessionManagerTest8();
}