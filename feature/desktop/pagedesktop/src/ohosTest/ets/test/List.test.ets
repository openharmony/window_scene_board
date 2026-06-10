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

import PageDesktopLayoutTest from './ets/default/layout/PageDesktopLayout.test'
import SwiperIndicatorTest from './common/components/SwiperIndicator.test'
import PageDesktopViewModelUtilsTest from './common/viewmodel/PageDesktopViewModelUtils.test';
import PageDesktopViewModelTest from './common/viewmodel/PageDesktopViewModel.test';
import SwiperGestureHandlerTest from './common/SwiperGestureHandler.test';
import PageDesktopCloseAppHandlerForPCTest from './common/PageDesktopCloseAppHandlerForPC.test';
import PageDesktopCloseAppHandlerTest from './common/PageDesktopCloseAppHandler.test';
import GridLayoutOptionRetTest from './common/components/GridLayoutOptionRet.test';
import DesktopUtilsTest from './ets/default/common/DesktopUtils.test'
import FolderSizeAdjustServiceManagerTest from './common/components/folder/service/FolderSizeAdjustServiceManager.test';
import FolderSizeChangeViewModelTest from './common/components/folder/viewModel/FolderSizeChangeViewModel.test';
import AbstractAdjustServiceHandlerTest from './common/components/folder/service/hanlder/AbstractAdjustServiceHandler.test';
import RightBottomAreaAdjustServiceHandlerTest from './common/components/folder/service/hanlder/RightBottomAreaAdjustServiceHandler.test';
import BottomAreaAdjustServiceHandlerTest from './common/components/folder/service/hanlder/BottomAreaAdjustServiceHandler.test';
import TopAreaAdjustServiceHandlerTest from './common/components/folder/service/hanlder/TopAreaAdjustServiceHandler.test';
import RightAreaAdjustServiceHandlerTest from './common/components/folder/service/hanlder/RightAreaAdjustServiceHandler.test';
import LeftBottomAreaAdjustServiceHandlerTest from './common/components/folder/service/hanlder/LeftBottomAreaAdjustServiceHandler.test';
import LeftAreaAdjustServiceHandlerTest from './common/components/folder/service/hanlder/LeftAreaAdjustServiceHandler.test';
import RightTopAreaAdjustServiceHandlerTest from './common/components/folder/service/hanlder/RightTopAreaAdjustServiceHandler.test';
import LeftTopAreaAdjustServiceHandlerTest from './common/components/folder/service/hanlder/LeftTopAreaAdjustServiceHandler.test';
import PageDesktopPushUpViewModelTest from './common/viewmodel/PageDesktopPushUpViewModel.test';
import PageDesktopPushDownViewModelTest from './common/viewmodel/PageDesktopPushDownViewModel.test';
import RestoringDesktopLayoutTest from './ets/default/service/impl/RestoringDesktopLayout.test';
import SetPinShortcutLimitInfoTest from './ets/default/service/impl/SetPinShortcutLimitInfo.test';
import SampleDeviceServiceTest from './ets/default/service/SampleDeviceService.test';
import { DesktopFormStackViewModelTest } from './common/viewmodel/DesktopFormStackViewModel.test';

import DesktopPreviewViewModelTest from './ets/default/preview/DesktopPreviewViewModel.test'
import PreviewUtilsTest from './ets/default/preview/PreviewUtils.test'
import { FormDataUtilTest } from './common/components/form/useless/FormDataUtil.test';
import { FormDataUtilBetaTest } from './common/components/form/useless/FormDataBetaUtil.test'
import DesktopPreviewRdbManagerTest from './ets/default/preview/DesktopPreviewRdbManager.test'
import OverflowFormStatusControllerTest from './common/components/form/viewmodel/OverflowFormStatusController.test'
import QuitAppRectViewModelTest from './common/viewmodel/QuitAppRectViewModel.test'
import DesktopAccessibilityUtilsTest from './common/viewmodel/DesktopAccessibilityUtils.test'
import DesktopShortcutViewModelTest from './common/viewmodel/DesktopShortcutViewModel.test'
import GridLayoutOptionUtilTest from './ets/default/preview/GridLayoutOptionUtil.test'
import QueryAutoAlignStatusTest from './common/viewmodel/QueryAutoAlignStatus.test';
import PageDesktopDragHandlerTest from './common/PageDesktopDragHandler.test';
import CheckShortcutTest from './ets/default/service/impl/CheckShortcut.test';
import CardSqueezerTest from './ets/default/common/CardSqueezer.test';
import BlankPageViewModelTest from './common/viewmodel/BlankPageViewModel.test';
import { OverflowViewModelTest } from './common/viewmodel/OverflowViewModel.test';
import { OverflowFormUtilsTest } from './common/components/liveform/common/OverflowFormUtils.test';
import {
  OverflowFunInteractionFormStatusControllerTest
} from './common/components/liveform/controller/status/OverflowFunInteractionFormStatusController.test';
import { OverflowDefaultPolicyTest } from './common/components/liveform/controller/overflow/OverflowDefaultPolicy.test';
import { OverflowNoLimitPolicyTest } from './common/components/liveform/controller/overflow/OverflowNoLimitPolicy.test';
import { OverflowDeviceManagerTest } from './common/components/liveform/common/OverflowDeviceManager.test';
import PageDragViewModelTest from './common/viewmodel/PageDragViewModel.test'
import BigFolderUseGuidanceStateMachineTest from './common/BigFolderUseGuidanceStateMachine.test'
import BigFolderUseGuidanceViewModelTest from './common/viewmodel/BigFolderUseGuidanceViewModel.test'
import { OverflowFormItemEventTest } from './common/components/form/viewmodel/OverflowFormItemEvent.test'
import { FormTestSuit } from './FormTestSuit';
import MatchCardLayoutManagerTest from './common/viewmodel/MatchCardLayoutManager.test'

export default function PageDesktopTestSuite() {
  BlankPageViewModelTest();
  MatchCardLayoutManagerTest();
  FormTestSuit();
  DesktopUtilsTest(); // 测试用例
  LeftTopAreaAdjustServiceHandlerTest();
  RightTopAreaAdjustServiceHandlerTest();
  LeftAreaAdjustServiceHandlerTest();
  LeftBottomAreaAdjustServiceHandlerTest();
  RightAreaAdjustServiceHandlerTest();
  TopAreaAdjustServiceHandlerTest();
  BottomAreaAdjustServiceHandlerTest();
  RightBottomAreaAdjustServiceHandlerTest();
  AbstractAdjustServiceHandlerTest();
  FolderSizeChangeViewModelTest();
  FolderSizeAdjustServiceManagerTest();
  GridLayoutOptionRetTest();
  BigFolderUseGuidanceStateMachineTest();
  PageDesktopCloseAppHandlerTest();
  PageDesktopCloseAppHandlerForPCTest();
  SwiperGestureHandlerTest();
  PageDesktopViewModelTest();
  PageDesktopViewModelUtilsTest();
  SwiperIndicatorTest();
  PageDesktopLayoutTest();
  PageDesktopPushUpViewModelTest();
  PageDesktopPushDownViewModelTest();
  SampleDeviceServiceTest();
  RestoringDesktopLayoutTest();
  SetPinShortcutLimitInfoTest();
  DesktopPreviewViewModelTest();
  PreviewUtilsTest();
  DesktopPreviewRdbManagerTest();
  QuitAppRectViewModelTest();
  DesktopShortcutViewModelTest();
  OverflowFormStatusControllerTest();
  BigFolderUseGuidanceViewModelTest();
  DesktopAccessibilityUtilsTest();
  GridLayoutOptionUtilTest();
  PageDesktopDragHandlerTest();
  CheckShortcutTest();
  CardSqueezerTest();
  QueryAutoAlignStatusTest();
  OverflowFormUtilsTest();
  OverflowFunInteractionFormStatusControllerTest();
  OverflowDefaultPolicyTest();
  OverflowNoLimitPolicyTest();
  OverflowDeviceManagerTest();
  OverflowViewModelTest();
  PageDragViewModelTest();
  OverflowFormItemEventTest();
  TvAdaptiveAppIconEventTest()
}