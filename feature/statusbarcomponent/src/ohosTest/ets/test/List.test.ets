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

import { StatusBarPanelControllerTest } from './ets/common/StatusBarPanelController.test'
import { LocalPluginStyleTest } from './ets/style/LocalPluginStyle.test'
import { PluginStyleManagerTest } from './ets/style/PluginStyleManager.test'
import { BackgroundLinearGradientTest } from './ets/viewmodel/BackgroundLinearGradient.test'
import { PluginSortManagerTest } from './ets/viewmodel/PluginSortManager.test'
import StatusBarLayoutVmV2Test from './ets/vm/StatusBarLayoutVmV2.test'
import MouseTypeStyleVmTest from './ets/vm/MouseTypeStyleVm.test'
import StatusBarNotchPaddingVmTest from './ets/vm/StatusBarNotchPaddingVm.test'

export default function StatusBarComponentTestSuite() {
  StatusBarPanelControllerTest();
  LocalPluginStyleTest();
  PluginStyleManagerTest();
  BackgroundLinearGradientTest();
  PluginSortManagerTest();
  StatusBarLayoutVmV2Test()
  MouseTypeStyleVmTest();
  StatusBarNotchPaddingVmTest();
}