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
import ThermalSafeViewModelTest from './thermalsafe/viewmodel/ThermalSafeViewModel.test'
import EmergencyViewModelTest from './emergency/viewmodel/EmergencyViewModel.test'
import EmergencyModelTest from './emergency/model/EmergencyModel.test'
import EmergencyThermalLayoutConfigTest from './common/layoutconfig/EmergencyThermalLayoutConfig.test'
import GetEmergencyThermalLayoutFromConfigTest from './common/layoutconfig/GetEmergencyThermalLayoutFromConfig.test'
import ThermalModelTest from './thermalsafe/model/ThermalModel.test'
import EmergencyUtilsTest from './common/EmergencyUtils.test'

export default function EmergencyTestSuite() {
  EmergencyModelTest();
  EmergencyViewModelTest();
  ThermalSafeViewModelTest();
  EmergencyThermalLayoutConfigTest();
  GetEmergencyThermalLayoutFromConfigTest();
  ThermalModelTest();
  EmergencyUtilsTest();
}