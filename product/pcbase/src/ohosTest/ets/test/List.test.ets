import DesktopDrawDoneManagerTest from './ets/desktop/DesktopDrawDoneManager.test'
import SCBSampleManagerTest from './ets/SceneBoard/systemscene/SCBSampleManager.test'
import SCBGestureBackViewModelTest from './ets/SceneBoard/gesturenavigation/viewmodel/SCBGestureBackViewModel.test'
import PcLauncherLayoutStyleConfigTest from './ets/common/PcLauncherLayoutStyleConfig.test'
import PcDialogControllerTest from './ets/SceneBoard/systemscene/ViewModel/PcDialogController.test'
import GestureHelperTest from './ets/SceneBoard/gesturenavigation/common/GestureHelper.test'
import SCBGestureNavBarViewModelTest from './ets/SceneBoard/gesturenavigation/viewmodel/SCBGestureNavBarViewModel.test'
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

import RightMenuOptionsCalcTest from './ets/common/viewmodel/RightMenuOptionsCalc.test'
import PcFileAccessTest from './ets/common/controller/PcFileAccess.test'
import PcRightMenuViewModelTest from './ets/common/viewmodel/PcRightMenuViewModel.test'
import PcFileFolderManagerTest from './ets/common/controller/PcFileFolderManager.test'
import FoldSwiperControllerTest from './ets/common/FoldSwiperController.test';
import PcPageDesktopGridStyleConfigTest from './ets/common/PcPageDesktopGridStyleConfig.test';

export default function DesktopFileTestSuite() {
  PcRightMenuViewModelTest();
  PcFileAccessTest();
  RightMenuOptionsCalcTest();
  PcFileFolderManagerTest();
  FoldSwiperControllerTest();
  PcPageDesktopGridStyleConfigTest();
  PcFileFolderManagerTest();
  FoldSwiperControllerTest();
  PcPageDesktopGridStyleConfigTest();
  SCBGestureNavBarViewModelTest()
  GestureHelperTest()
  PcDialogControllerTest()
  PcLauncherLayoutStyleConfigTest()
  SCBGestureBackViewModelTest()
  SCBSampleManagerTest()
  DesktopDrawDoneManagerTest()
}