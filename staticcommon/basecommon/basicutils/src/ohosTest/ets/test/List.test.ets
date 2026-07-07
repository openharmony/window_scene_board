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
import { FwkDeliverUtilTest } from './ets/framework/utils/DeliverUtil.test';
import { AudioManagerHelperTest } from './ets/component/utils/AudioManagerHelper.test';
import UnionArrayTest from './ets/recent/UnionArray.test';
import { SingleManagerTest } from './ets/component/utils/SingleManager/SingleManager.test';
import { SolidColorAlgorithmUtilsTest } from './ets/framework/utils/SolidColorAlgorithmUtils.test';
import { AnimateToScheduleUtilsTest } from './ets/framework/utils/AnimateToScheduleUtils.test';
import { OutdoorConfigTest } from './ets/framework/utils/OutdoorConfig.test';
import TaskPoolTest from './ets/taskpool/TaskPool.test';
import TaskManagerTest from './ets/taskpool/viewmodel/viewhandler/TaskManager.test';

export default function BasicUtilsTestSuite() {
  FrameworkTestSuite(); // 合一框架组测试用例
  ComponentsTestSuite(); // 桌面组件组测试用例
  MultitasksTestSuite(); // 桌面多任务测试用例
  EditTestSuite(); // 桌面编辑测试用例
}

export function FrameworkTestSuite() {
  ObjUtilTest();
  CommonUtilTest();
  CheckEmptyUtilTest();
  ArrayUtilTest();
  TraceUtilTest();
  FileUtilTest();
  LogHelperTest();
  JsonUtilsTest();
  AppStorageUtilTest();
  FwkDeliverUtilTest();
  AnimateToScheduleUtilsTest();
  OutdoorConfigTest();
  TaskPoolTest();
  TaskManagerTest();
}

export function ComponentsTestSuite() {
  RectTest();
  AudioManagerHelperTest();
  SingleManagerTest();
}

export function MultitasksTestSuite() {
  UnionArrayTest();
}

export function EditTestSuite() {
  SolidColorAlgorithmUtilsTest();
}