import PowerButtonManagerTest from './ets/manager/PowerButtonManager.test'
import AnimSystemProfileTest from './ets/manager/AnimSystemProfile.test'
import AiBarVisualEffectManagerTest from './ets/manager/AiBarVisualEffectManager.test';
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

import { ObjectCopyUtilTest } from './ets/component/utils/ObjectCopyUtil.test';
import { AppTypeUtilsTest } from './ets/component/utils/AppTypeUtils.test';
import { BaseServiceStubTest } from './ets/component/utils/BaseServiceStub.test';
import { DesktopUtilTest } from './ets/component/utils/DesktopUtil.test';
import { DragControllerUtilTest } from './ets/component/utils/DragControllerUtil.test';
import { DragSnapshotHelperTest } from './ets/component/utils/DragSnapshotHelper.test';
import { ItemUtilsTest } from './ets/component/utils/ItemUtils.test';
import { CartesianCoordinatesTest } from './ets/component/utils/CartesianCoordinates.test';
import { DragAccessibilityUtilsTest } from './ets/component/utils/DragAccessibilityUtils.test';
import { RTLUtilTest } from './ets/component/utils/RTLUtil.test';
import FrameUtilTest from './ets/component/utils/FrameUtil.test';
import BaseServiceStubUtilsTest from './ets/component/utils/BaseServiceStubUtils.test';
import { SCBVisualEffectManagerTest } from './ets/framework/visualeffect/manager/SCBVisualEffectManager.test';
import { SCBGestureNavSetManagerTest } from './ets/component/manager/SCBGestureNavSetManager.test';
import { GestureBackCcmSettingsTest } from './ets/framework/visualeffect/manager/GestureBackCcmSettings.test';
import { GestureNavBarCcmSettingsTest } from './ets/framework/visualeffect/manager/GestureNavBarCcmSettings.test';
import { OutdoorCcmManagerTest } from './ets/framework/visualeffect/manager/OutdoorCcmManager.test';

export default function ComponentHelperTestSuite() {
  FrameworkTestSuite(); // 合一框架组测试用例
  ComponentsTestSuite(); // 桌面组件组测试用例
  EditModeTestSuite(); // 桌面编辑组测试用例
}

export function FrameworkTestSuite() {
  SCBVisualEffectManagerTest();
  OutdoorCcmManagerTest();
  GestureBackCcmSettingsTest();
  GestureNavBarCcmSettingsTest();
}


export function ComponentsTestSuite() {
  BaseServiceStubUtilsTest();
  AppTypeUtilsTest();
  BaseServiceStubTest();
  ItemUtilsTest();
  ObjectCopyUtilTest();
  CartesianCoordinatesTest();
  RTLUtilTest();
  DesktopUtilTest();
  SCBGestureNavSetManagerTest();
}

export function EditModeTestSuite() {
  DragSnapshotHelperTest();
  DragControllerUtilTest();
  DragAccessibilityUtilsTest();
  FrameUtilTest();
  AiBarVisualEffectManagerTest();
  AnimSystemProfileTest()
  PowerButtonManagerTest()
}