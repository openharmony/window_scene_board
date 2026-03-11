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

export default function PipelineDemoSuite() {
  describe("sceneboard_framework",  () =>  {
    SCBVisualEffectManagerTest();
    GestureBackCcmSettingsTest();
    GestureNavBarCcmSettingsTest();
  });

  describe("launcher_components",  () =>  {
    AppTypeUtilsTest();
    BaseServiceStubTest();
    ItemUtilsTest();
    ObjectCopyUtilTest();
    CartesianCoordinatesTest();
    RTLUtilTest();
    DesktopUtilTest();
    BaseServiceStubUtilsTest();
    SCBGestureNavSetManagerTest();
  });

  describe("sceneboard_desktopedit",  () =>  {
    DragSnapshotHelperTest();
    DragControllerUtilTest();
    DragAccessibilityUtilsTest();
    FrameUtilTest();
  });
}
