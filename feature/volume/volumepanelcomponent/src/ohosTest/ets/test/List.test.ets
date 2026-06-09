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

import { StyleConfigurationTest } from './ets/common/StyleConfigurationTest.test'
import { VolumeComponentStyleTest } from './ets/common/VolumeComponentStyleTest.test'
import { VolumeSysEventUtilTest } from './ets/common/VolumeSysEventUtilTest.test'
import { VolumeWindowControllerTest } from './ets/common/VolumeWindowControllerTest.test'
import { VolumePanelServiceTest } from './ets/model/VolumePanelServiceTest.test'
import { VolumePanelVMTest } from './ets/viewmodel/VolumePanelVMTest.test'

/**
 * 沉浸锁屏feature模块测试用例
 */
export default function VolumepanelComponentTestSuite() {
  StyleConfigurationTest();
  VolumeComponentStyleTest();
  VolumeSysEventUtilTest();
  VolumeWindowControllerTest();
  VolumePanelServiceTest();
  VolumePanelVMTest();
}