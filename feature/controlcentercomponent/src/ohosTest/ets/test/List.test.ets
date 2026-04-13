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
import { CommonToggleControllerTest } from './ets/ohos/controller/CommonToggleController.test';
import { ControlCenterBaseControllerTest } from './ets/ohos/controller/ControlCenterBaseController.test';
import { QuickToggleControllerTest } from './ets/ohos/controller/QuickToggleController.test';
import { ConstantsTest } from './ets/ohos/common/Constants.test';
import { ControlCenterAnimParmTest } from './ets/ohos/common/ControlCenterAnimParm.test'
import { ControlCenterLayoutControllerTest } from './ets/ohos/controller/ControlCenterLayoutController.test';
import { PrivacySensorViewModelTest } from './ets/ohos/viewModel/PrivacySensorViewModel.test';
import { PrivacySubLayoutControllerTest } from './ets/ohos/controller/PrivacySubLayoutController.test';
import { ToggleEditViewModelTest } from './ets/ohos/vm/ToggleEditViewModel.test';
import { ControlCenterHomeViewModelTest } from './ets/ohos/vm/ControlCenterHomeViewModel.test';
import { LabelViewModelTest } from './ets/ohos/viewModel/LabelViewModel.test';
import { StartAbilityOverlayAnimateTest } from './ets/ohos/viewModel/StartAbilityOverlayAnimate.test';
import { ControlCenterComponentUiTest } from './ets/ohos/view/ControlCenterComponentUiTest.test';
import { IOTSubPageLayoutControllerTest } from './ets/ohos/controller/IOTSubPageLayoutController.test';
import { ControlCenterControllerTest } from './ets/ohos/controller/ControlCenterController.test';
import { DragHelperTest } from './ets/ohos/vm/DragHelper.test';
import { ColorModeViewModelTest } from './ets/ohos/viewModel/ColorModeViewModel.test';
import { HeaderViewModelTest } from './ets/ohos/viewModel/HeaderViewModel.test';
import { BrightnessViewModelTest } from './ets/ohos/viewModel/BrightnessViewModel.test';
import { AccessibilityUtilExtTestCC } from './ets/ohos/accessibility/AccessibilityUtilExt.test';
import { AccessibilityDataModelTest } from './ets/ohos/accessibility/AccessibilityDataModel.test';
import { AccessibilityUtilTestCC } from './ets/ohos/accessibility/AccessibilityUtil.test';
import { ControlCenterToggleDataMigrationTest } from './ets/ohos/controller/ControlCenterToggleDataMigration.test';
import { EmergencyManagerTest } from './ets/ohos/viewModel/EmergencyManager.test';
import { ControlCenterEditComponentUiTest } from './ets/ohos/view/ControlCenterEditComponentUiTest.test';
import { BrightnessViewModelExtTest } from './ets/ohos/viewModel/BrightnessViewModelExt.test';
import { MultiWindowToggleControllerTest } from './ets/ohos/controller/MultiWindowToggleController.test';
import { ControlCenterVisibilityControllerTest } from './ets/ohos/controller/ControlCenterVisibilityController.test';
import { ControlBrightnessManagerTest } from './ets/ohos/controller/ControlBrightnessManager.test';
import { BrightnessButtonViewModelTest } from './ets/ohos/viewModel/BrightnessButtonViewModel.test';
import { BrightnessSubPageLayoutControllerTest } from './ets/ohos/viewModel/BrightnessSubPageLayoutController.test';
import { ControlCenterViewModelTest } from './ets/ohos/viewModel/ControlCenterViewModel.test';
import ScreenToggleControllerTest from './ets/ohos/controller/ScreenToggleController.test';
import { ToggleBaseViewModelTest } from './ets/ohos/viewModel/ToggleBaseViewModel.test';

export default function ControlCenterTestSuite() {
  ControlCenterEditComponentUiTest();
  CommonToggleControllerTest();
  ControlCenterBaseControllerTest();
  QuickToggleControllerTest();
  ConstantsTest();
  ControlCenterAnimParmTest();
  ControlCenterLayoutControllerTest();
  PrivacySensorViewModelTest();
  PrivacySubLayoutControllerTest();
  ToggleEditViewModelTest();
  ControlCenterHomeViewModelTest();
  LabelViewModelTest();
  ControlCenterComponentUiTest();
  IOTSubPageLayoutControllerTest();
  ControlCenterControllerTest();
  DragHelperTest();
  StartAbilityOverlayAnimateTest();
  ToggleBaseViewModelTest();
  ColorModeViewModelTest();
  HeaderViewModelTest();
  BrightnessViewModelTest();
  AccessibilityUtilExtTestCC();
  AccessibilityDataModelTest();
  AccessibilityUtilTestCC();
  ControlCenterToggleDataMigrationTest();
  EmergencyManagerTest();
  BrightnessViewModelExtTest();
  MultiWindowToggleControllerTest();
  ControlCenterVisibilityControllerTest();
  ControlBrightnessManagerTest();
  BrightnessButtonViewModelTest();
  BrightnessSubPageLayoutControllerTest();
  ControlCenterViewModelTest();
  ScreenToggleControllerTest();
}
