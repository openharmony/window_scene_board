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
import { BindBaseStateTest } from './ets/immersivekeyguardcommon/base/bean/BindBaseStateTest.test';
import { DynamicCurveRateTest } from './ets/immersivekeyguardcommon/base/utils/DynamicCurveRateTest.test';
import { WidgetPropertyStateTest } from './ets/immersivekeyguardcommon/base/bean/WidgetPropertyStateTest.test';
import { ScreenLockUiStateManagerTest } from './ets/manager/ScreenLockUiStateManager.test';
import { FlashlightTipsUtilTest } from './ets/utils/FlashlightTipsUtil.test';
import { StaticBaseStateTest } from './ets/immersivekeyguardcommon/base/bean/StaticBaseStateTest.test';
import { ComponentPositionTest } from './ets/immersivekeyguardcommon/base/utils/ComponentPositionTest.test';
import { WidgetAnimStateTest } from './ets/immersivekeyguardcommon/base/bean/WidgetAnimStateTest.test';
import { WidgetStyleStateTest } from './ets/immersivekeyguardcommon/base/bean/WidgetStyleStateTest.test';
import DisplayStateManagerTest from './ets/manager/DisplayStateManager.test'
import FingerprintReporterTest from './ets/manager/FingerprintReporter.test'
import KeyguardStatusServiceTest from './ets/manager/KeyguardStatusService.test'
import OccludedStateManagerTest from './ets/manager/OccludedStateManager.test'
import ScreenLockStateManagerTest from './ets/manager/ScreenLockStateManager.test'
import SimCardStateManagerTest from './ets/manager/SimCardStateManager.test'
import ScreenLockVerifyServiceTest from './ets/services/ScreenLockVerifyService.test';
import ScreenLockUnlockServiceTest from './ets/services/ScreenLockUnlockService.test';
import ScreenOnOffServiceTest from './ets/services/ScreenOnOffService.test';
import UserSwitchServiceTest from './ets/services/UserSwitchService.test';
import VerifyInterceptorTest from './ets/services/VerifyInterceptor.test';
import ScreenLockApiTest from './ets/api/ScreenLockApi.test';
import BaseStateManagerTest from './ets/immersivekeyguardcommon/base/manager/BaseStateManager.test';
import LimitMapTest from './ets/immersivekeyguardcommon/base/utils/LimitMap.test';
import LimitSetTest from './ets/immersivekeyguardcommon/base/utils/LimitSet.test';
import MethodMapTest from './ets/immersivekeyguardcommon/base/utils/MethodMap.test';
import DataShareHelperTest from './ets/utils/DataShareHelper.test'
import CommonUtilTest from './ets/utils/CommonUtil.test'
import PerformanceMonitorUtilTest from './ets/utils/PerformanceMonitorUtil.test'
import SlServerHelperTest from './ets/utils/SlServerHelper.test'
import SlUnlockReportHelperTest from './ets/utils/SlUnlockReportHelper.test'
import VerifyDataManagerTest from './ets/manager/VerifyDataManager.test'
import SimCardVerifyServiceTest from './ets/services/SimCardVerifyService.test';
import ScreenLockVerifyVmTest from './ets/base/ScreenLockVerifyVm.test'
import DisplayUtilsTest from './ets/utils/DisplayUtils.test';
import { ImmInvertColorInfoTest } from './ets/immersivekeyguardcommon/immersivekg/bean/ImmInvertColorInfo.test';
import { ImmRunningLockMgrTest } from './ets/immersivekeyguardcommon/immersivekg/manager/ImmRunningLockMgr.test';
import { ImmInvertColorMgrTest } from './ets/immersivekeyguardcommon/immersivekg/manager/ImmInvertColorMgr.test';

export default function PipelineDemoSuite() {
  describe("screenlock_for_oh", () => {
    ScreenLockUiStateManagerTest();
    FlashlightTipsUtilTest();
    DisplayStateManagerTest();
    FingerprintReporterTest();
    KeyguardStatusServiceTest();
    OccludedStateManagerTest();
    ScreenLockStateManagerTest();
    SimCardStateManagerTest();
    ScreenLockUnlockServiceTest();
    ScreenLockVerifyServiceTest();
    ScreenOnOffServiceTest();
    UserSwitchServiceTest();
    VerifyInterceptorTest();
    ScreenLockApiTest();
    BaseStateManagerTest();
    LimitMapTest();
    LimitSetTest();
    MethodMapTest();
    DataShareHelperTest();
    CommonUtilTest();
    PerformanceMonitorUtilTest();
    SlServerHelperTest();
    SlUnlockReportHelperTest();
    VerifyDataManagerTest();
    SimCardVerifyServiceTest();
    ScreenLockVerifyVmTest();
    DisplayUtilsTest();
  });
  describe("ImmersiveKeyguard", () => {
    DynamicCurveRateTest();
    BindBaseStateTest();
    StaticBaseStateTest();
    ComponentPositionTest();
    WidgetAnimStateTest();
    WidgetStyleStateTest();
    WidgetPropertyStateTest();
    ImmInvertColorInfoTest();
    ImmRunningLockMgrTest();
    ImmInvertColorMgrTest();
  });
}