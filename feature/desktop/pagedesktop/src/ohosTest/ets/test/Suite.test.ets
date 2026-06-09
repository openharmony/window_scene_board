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
import DesktopUtilsTest from './ets/default/common/DesktopUtils.test';
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
import PageDesktopViewModelUtilsTest from './common/viewmodel/PageDesktopViewModelUtils.test';
import PageDesktopViewModelTest from './common/viewmodel/PageDesktopViewModel.test';
import SwiperGestureHandlerTest from './common/SwiperGestureHandler.test';
import PageDesktopCloseAppHandlerForPCTest from './common/PageDesktopCloseAppHandlerForPC.test';
import PageDesktopCloseAppHandlerTest from './common/PageDesktopCloseAppHandler.test';
import GridLayoutOptionRetTest from './common/components/GridLayoutOptionRet.test';
import SwiperIndicatorTest from './common/components/SwiperIndicator.test';
import PageDesktopLayoutTest from './ets/default/layout/PageDesktopLayout.test';
import PageDesktopPushUpViewModelTest from './common/viewmodel/PageDesktopPushUpViewModel.test';
import PageDesktopPushDownViewModelTest from './common/viewmodel/PageDesktopPushDownViewModel.test';
import SampleDeviceServiceTest from './ets/default/service/SampleDeviceService.test';
import SetPinShortcutLimitInfoTest from './ets/default/service/impl/SetPinShortcutLimitInfo.test';
import RestoringDesktopLayoutTest from './ets/default/service/impl/RestoringDesktopLayout.test';
import { DesktopFormStackViewModelTest } from './common/viewmodel/DesktopFormStackViewModel.test';
import FocusViewModelTest from './common/viewmodel/FocusViewModel.test';
import GridItemsPoolTest from './common/viewmodel/GridItemsPool.test';
import SwiperPageVMTest from './common/viewmodel/SwiperPageVM.test';
import DesktopPreviewViewModelTest from './ets/default/preview/DesktopPreviewViewModel.test'
import PreviewUtilsTest from './ets/default/preview/PreviewUtils.test'
import DesktopPreviewRdbManagerTest from './ets/default/preview/DesktopPreviewRdbManager.test'
import DesktopShortcutViewModelTest from './common/viewmodel/DesktopShortcutViewModel.test'
import QuitAppRectViewModelTest from './common/viewmodel/QuitAppRectViewModel.test';
import DesktopAccessibilityUtilsTest from './common/viewmodel/DesktopAccessibilityUtils.test';
import GridLayoutOptionUtilTest from './ets/default/preview/GridLayoutOptionUtil.test'
import QueryAutoAlignStatusTest from './common/viewmodel/QueryAutoAlignStatus.test';

import PageDesktopDragHandlerTest from './common/PageDesktopDragHandler.test';
import CheckShortcutTest from './ets/default/service/impl/CheckShortcut.test';
import CardSqueezerTest from './ets/default/common/CardSqueezer.test';
import { OverflowViewModelTest } from './common/viewmodel/OverflowViewModel.test';
import { OverflowFormUtilsTest } from './common/components/liveform/common/OverflowFormUtils.test';
import {
  OverflowFunInteractionFormStatusControllerTest
} from './common/components/liveform/controller/status/OverflowFunInteractionFormStatusController.test';
import { OverflowDefaultPolicyTest } from './common/components/liveform/controller/overflow/OverflowDefaultPolicy.test';
import { OverflowNoLimitPolicyTest } from './common/components/liveform/controller/overflow/OverflowNoLimitPolicy.test';
import { OverflowDeviceManagerTest } from './common/components/liveform/common/OverflowDeviceManager.test';
import { OverflowFormItemEventTest } from './common/components/form/viewmodel/OverflowFormItemEvent.test'
import PageDragViewModelTest from './common/viewmodel/PageDragViewModel.test';
import BigFolderUseGuidanceStateMachineTest from './common/BigFolderUseGuidanceStateMachine.test';
import BigFolderUseGuidanceViewModelTest from './common/viewmodel/BigFolderUseGuidanceViewModel.test';
import { FormTestSuit } from './FormTestSuit'
import MatchCardLayoutManagerTest from './common/viewmodel/MatchCardLayoutManager.test';
import BlankPageViewModelTest from './common/viewmodel/BlankPageViewModel.test';

export default function PipelineDemoSuite() {
  describe("basic_launcher_for_oh",  () =>  {
    BlankPageViewModelTest();
    DesktopUtilsTest();
    LeftTopAreaAdjustServiceHandlerTest();
    RightTopAreaAdjustServiceHandlerTest();
    LeftAreaAdjustServiceHandlerTest();
    LeftBottomAreaAdjustServiceHandlerTest();
    RightAreaAdjustServiceHandlerTest();
    TopAreaAdjustServiceHandlerTest();
    BottomAreaAdjustServiceHandlerTest();
    RightBottomAreaAdjustServiceHandlerTest();
    AbstractAdjustServiceHandlerTest();

    MatchCardLayoutManagerTest();
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
    SetPinShortcutLimitInfoTest();
    RestoringDesktopLayoutTest();
    FocusViewModelTest();
    SwiperPageVMTest();
    GridItemsPoolTest();
    DesktopPreviewViewModelTest();
    PreviewUtilsTest();
    DesktopPreviewRdbManagerTest();
    DesktopShortcutViewModelTest();
    QuitAppRectViewModelTest();
    BigFolderUseGuidanceViewModelTest();
    DesktopAccessibilityUtilsTest();
    GridLayoutOptionUtilTest();
    PageDesktopDragHandlerTest();
    CheckShortcutTest();
    CardSqueezerTest();
    PageDragViewModelTest();
  });

  describe("sceneboard_folder",  () =>  {
    FolderSizeChangeViewModelTest();
    FolderSizeAdjustServiceManagerTest();

    QueryAutoAlignStatusTest();
  });

  describe("sceneboard_form",  () =>  {
    FormTestSuit();
  });

  describe("sceneboard_overflow",  () =>  {
    OverflowViewModelTest();
    OverflowFormUtilsTest();
    OverflowFunInteractionFormStatusControllerTest();
    OverflowDefaultPolicyTest();
    OverflowNoLimitPolicyTest();
    OverflowDeviceManagerTest();
    OverflowFormItemEventTest();
  });
}