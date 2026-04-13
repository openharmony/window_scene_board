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
import BigFolderViewModelTest from './viewmodel/BigFolderViewModel.test';
import OpenFolderDragHandlerTest  from './common/OpenFolderDragHandler.test';
import BigFolderStyleConfigTest from './common/BigFolderStyleConfig.test';
import AnimationBatchUtilTest from './viewmodel/AnimationBatchUtil.test'
import OpenFolderLayoutTest from './viewmodel/OpenFolderLayout.test';
import OpenFolderAddViewModelTest from './viewmodel/OpenFolderAddViewModel.test';
import OpenCloseAnimationViewModelTest from './viewmodel/OpenCloseAnimationViewModel.test'
import OpenFolderAppMoveVMManagerTest from './viewmodel/OpenFolderAppMoveVMManager.test'
import FolderAccessibilityUtilsTest from './common/FolderAccessibilityUtils.test';
import OpenFolderAppBubbleNodeManagerTest from './view/OpenFolderAppBubbleNodeManager.test';

export default function testsuite() {
  OpenFolderDragHandlerTest();
  BigFolderViewModelTest();
  BigFolderStyleConfigTest();
  AnimationBatchUtilTest();
  OpenFolderLayoutTest();
  OpenFolderAddViewModelTest();
  OpenCloseAnimationViewModelTest();
  OpenFolderAppMoveVMManagerTest();
  FolderAccessibilityUtilsTest();
  OpenFolderAppBubbleNodeManagerTest();
}