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

import { describe } from '@ohos/hypium';
import {
  GravityAnimationAlgorithmTest
} from './ets/component/animator/gravity/algorithm/algorithm/GravityAnimationAlgorithm.test';
import { GravityAnimationDebugTest } from './ets/component/animator/gravity/algorithm/debug/GravityAnimationDebug.test';
import { GravityAnimationManagerTest } from './ets/component/animator/gravity/manager/GravityAnimationManager.test';
import DropAnimationManagerTest from './ets/component/manager/DropAnimationManager.test';
import FrameAnimationUtilTest from './ets/component/service/animator/common/utils/FrameAnimationUtil.test';
import { AnimationContinueManagerTest } from
  './ets/component/service/animator/continue/manager/AnimationContinueManager.test';
import { DropAnimationTsAdapterTest } from './ets/component/service/animator/drop/adapter/DropAnimationTsAdapter.test';
import { DropAnimationConfigTest } from './ets/component/service/animator/drop/config/DropAnimationConfig.test';
import { DropAnimationObserverTest } from './ets/component/service/animator/drop/observer/DropAnimationObserver.test';
import DropItemViewModelTest from './ets/component/service/animator/drop/viewmodel/DropItemViewModel.test';

describe("sceneboard_desktopedit",  () =>  {
  GravityAnimationAlgorithmTest();
  GravityAnimationDebugTest();
  GravityAnimationManagerTest();
  DropAnimationManagerTest();
  DropItemViewModelTest();
  FrameAnimationUtilTest();
  AnimationContinueManagerTest();
  DropAnimationTsAdapterTest();
  DropAnimationConfigTest();
  DropAnimationObserverTest();
});