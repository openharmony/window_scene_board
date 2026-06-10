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

import { FormStackUtilTest } from './ets/common/FormStackUtil.test';
import { FormStackManagerTest } from './ets/common/FormStackManager.test';
import { FormStackDataAdaptTest } from './ets/common/FormStackDataAdapt.test';
import { FormStackExpandModelTest } from './ets/common/FormStackExpandModel.test';
import { FormStackExpandConfigTest } from './ets/common/FormStackExpandConfig.test';
import { FormStackExpandLayoutModelTest } from './ets/common/FormStackExpandLayoutModel.test';
import { FormStackExclusiveModelTest } from './ets/common/FormStackExclusiveModel.test';
import { FormStackExpandSlideAnimateTest } from './ets/viewmodel/FormStackExpandSlideAnimate.test';
import { FormStackViewModelTest } from './ets/viewmodel/FormStackViewModel.test';
import { FormStackAnimateTest } from './ets/viewmodel/FormStackAnimate.test';
import { FormStackExpandEventTest } from './ets/viewmodel/FormStackExpandEvent.test';
import { FormStackExpandCriticalAnimateTest } from './ets/viewmodel/FormStackExpandCriticalAnimate.test';
import { FormStackExpandEnterAnimateTest } from './ets/viewmodel/FormStackExpandEnterAnimate';
import { FormStackExpandItemEventTest } from './ets/viewmodel/FormStackExpandItemEvent.test';
import { FormStackExpandExitAnimateTest } from './ets/viewmodel/FormStackExpandExitAnimate.test';
import { FormStackExpandLateralAnimateTest } from './ets/viewmodel/FormStackExpandLateralAnimate.test';
import { FormStackExpandItemDragAnimateTest } from './ets/viewmodel/FormStackExpandItemDragAnimate.test';
import { FormStackExpandItemDropAnimateTest } from './ets/viewmodel/FormStackExpandItemDropAnimate.test';
import { FormStackExpandLayoutAnimateTest } from './ets/viewmodel/FormStackExpandLayoutAnimate.test';
import { FormStackExpandItemViewDataTest } from './ets/viewmodel/FormStackExpandItemViewData.test';
import { FormStackExpandViewDataTest } from './ets/viewmodel/FormStackExpandViewData.test';
import { FormStackExpandItemTouchAnimateTest } from './ets/viewmodel/FormStackExpandItemTouchAnimate.test';
import { FormStackStringUtilTest } from './ets/useless/StringUtil.test';
import { FormStackDebugCmdTest } from './ets/common/FormStackDebugCmd.test';
import { FormStackEventTest } from './ets/viewmodel/FormStackEvent.test';
import { HorizontalMenuItemEventTest } from './ets/viewmodel/HorizontalMenuItemEvent.test';
import { HorizontalMenuViewDataTest } from './ets/viewmodel/HorizontalMenuViewData.test';
import { FormStackSnapViewEventTest } from './ets/viewmodel//FormStackSnapViewEvent.test';
import { FormStackSnapCommonDataTest } from './ets/common/FormStackSnapCommonData.test';
import { FormStackSnapShowManagerTest } from './ets/common/FormStackSnapShowManager.test';
import { FormStackItemEventTest } from './ets/viewmodel/FormStackItemEvent.test';
import { FormStackModelTest } from './ets/common/FormStackModel.test';
import { FormStackSlideAnimateTest } from './ets/common/FormStackSlideAnimate.test';
import { FormStackMenuViewModelTest } from './ets/viewmodel//FormStackMenuViewModel.test';
import { FormStackEventReporterTest } from './ets/common/FormStackEventReporter.test';

export default function FormStackTestSuite() {
  FormStackCommonTest();
  FormStackVMTest();
}

export function FormStackCommonTest() {
  FormStackDataAdaptTest();
  FormStackExpandConfigTest();
  FormStackManagerTest();
  FormStackUtilTest();
  FormStackExpandLayoutModelTest();
  FormStackExpandModelTest();
  FormStackExclusiveModelTest();
  FormStackDebugCmdTest();
  FormStackSnapCommonDataTest();
  FormStackSnapShowManagerTest();
  FormStackModelTest();
  FormStackSlideAnimateTest();
  FormStackEventReporterTest();
  FormStackStringUtilTest();
}

export function FormStackVMTest() {
  FormStackExpandEventTest();
  FormStackExpandItemEventTest();

  FormStackAnimateTest();
  FormStackExpandCriticalAnimateTest();
  FormStackExpandEnterAnimateTest();
  FormStackExpandExitAnimateTest();
  FormStackExpandItemDragAnimateTest();
  FormStackExpandLayoutAnimateTest();
  FormStackExpandSlideAnimateTest();
  FormStackExpandItemTouchAnimateTest();
  FormStackExpandItemDropAnimateTest();
  FormStackExpandLateralAnimateTest();

  FormStackExpandViewDataTest();
  FormStackExpandItemViewDataTest();
  FormStackViewModelTest();
  FormStackEventTest();
  HorizontalMenuItemEventTest();
  HorizontalMenuViewDataTest();
  FormStackSnapViewEventTest();
  FormStackItemEventTest();
  FormStackMenuViewModelTest();
}