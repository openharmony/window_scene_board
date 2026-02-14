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

import { describe } from '@ohos/hypium';
import { AudioManagerHelperTest } from './ets/component/utils/AudioManagerHelper.test';
import { RectTest } from './ets/component/utils/Rect.test';
import { ObjUtilTest } from './ets/framework/utils/ObjUtil.test';
import { ArrayUtilTest } from './ets/framework/utils/ArrayUtils.test';
import { CheckEmptyUtilTest } from './ets/framework/utils/CheckEmptyUtils.test';
import { CommonUtilTest } from './ets/framework/utils/CommonUtils.test';
import { TraceUtilTest } from './ets/framework/utils/TraceUtil.test';
import { FileUtilTest } from './ets/framework/utils/FileUtils.test';
import { LogHelperTest } from './ets/framework/utils/LogHelper.test';
import { JsonUtilsTest } from './ets/framework/manager/serialization/JsonUtils.test';
import { AppStorageUtilTest } from './ets/framework/utils/AppStorageUtil.test';
import { SolidColorAlgorithmUtilsTest } from './ets/framework/utils/SolidColorAlgorithmUtils.test';
import { SingleManagerTest } from './ets/component/utils/SingleManager/SingleManager.test';
import UnionArrayTest from './ets/recent/UnionArray.test';
import { AnimateToScheduleUtilsTest } from './ets/framework/utils/AnimateToScheduleUtils.test';
import TaskPoolTest from './ets/taskpool/TaskPool.test';
import TaskManagerTest from './ets/taskpool/viewmodel/viewhandler/TaskManager.test';

export default function PipelineDemoSuite() {
  describe("sceneboard_framework",  () =>  {
    ObjUtilTest();
    CommonUtilTest();
    CheckEmptyUtilTest();
    ArrayUtilTest();
    JsonUtilsTest();
    TraceUtilTest();
    FileUtilTest();
    LogHelperTest();
    AppStorageUtilTest();
    AnimateToScheduleUtilsTest();
    TaskPoolTest();
    TaskManagerTest();
  });

  describe("launcher_components",  () =>  {
    RectTest();
    AudioManagerHelperTest();
    SingleManagerTest();
  });

  describe("sceneboard_multitasks",  () =>  {
    UnionArrayTest();
  });

  describe("sceneboard_desktopedit", () => {
    SolidColorAlgorithmUtilsTest();
  })
}