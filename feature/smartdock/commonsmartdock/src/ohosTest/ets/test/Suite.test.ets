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
import { describe } from '@ohos/hypium';
import SmartDockModelTest from './model/SmartDockModel.test';
import SmartDockDragHandlerTest from './common/SmartDockDragHandler.test';
import ResidentLayoutForPCTest from './common/ResidentLayoutForPC.test';
import RecentDockModelTest from './model/RecentDockModel.test';
import SmartDockViewModelTest from './viewmodel/SmartDockViewModel.test';
import PCDockUtilsTest from './utils/PCDockUtils.test';
import SuggestMenuModelTest from './model/SuggestMenuModel.test';
import ContinuableViewModelTest from './model/ContinuableViewModel.test';
import SmartDockStyleConfigTest_2 from './common/SmartDockStyleConfig.test';
import SmartDockReorderSolutionTest from './common/SmartDockReorderSolution.test';
import SmartDockCloseAppHandlerForPCTest from './common/SmartDockCloseAppHandlerForPC.test';
import SmartDockCloseAppHandlerTest from './common/SmartDockCloseAppHandler.test';
import PcSmartDockStyleConfigUpdaterTest from './common/PcSmartDockStyleConfigUpdater.test';
import BackPlaneTest from './common/component/BackPlane.test';
import SmartDockEventMgrTest from './manager/SmartDockEventMgr.test';
import SmartDockStyleMgrTest from './manager/SmartDockStyleMgr.test';
import DockItemPositionTest from './common/DockItemPosition.test';
import BigDockModelTest from './model/BigDockModel.test';
import PhoneDockUtilsTest from './utils/PhoneDockUtils.test';
import PcModeDockPopupMgrTest from './manager/PcModeDockPopupMgr.test';
import PcModeDockUtilsTest from './utils/PcModeDockUtils.test';
import DockHiSysEventMgrTest from './manager/DockHiSysEventMgr.test';
import StatusBarServiceEventMgrTest from './manager/StatusBarServiceEventMgr.test';
import DockRegionLayoutModelTest from './model/DockRegionLayoutModel.test';
import DockItemPlaceVmTest from './viewmodel/DockItemPlaceVm.test';
import DockItemAnimationEventTest from './viewmodel/DockItemAnimationEvent.test';
import DockRegionAnimationEventTest from './viewmodel/DockRegionAnimationEvent.test';
import SmartDockObserverTest from './viewmodel/SmartDockObserver.test';
import SmartDockZoomAnimationConfigTest from './viewmodel/SmartDockZoomAnimationConfig.test';
import SmartDockZoomAnimationManagerTest from './viewmodel/SmartDockZoomAnimationManager.test';
import SmartDockZoomEventTest from './viewmodel/SmartDockZoomEvent.test';
import SmartDockReorderLayoutTest from './layout/SmartDockReorderLayout.test';

export default function PipelineDemoSuite() {

  describe("launcher_components", () => {
    SmartDockModelTest();
    ResidentLayoutForPCTest();
    RecentDockModelTest();
    DockRegionLayoutModelTest();
    SmartDockViewModelTest();
    BackPlaneTest();
    PcSmartDockStyleConfigUpdaterTest();
    SmartDockCloseAppHandlerTest();
    SmartDockCloseAppHandlerForPCTest();
    SmartDockReorderSolutionTest();
    SmartDockStyleConfigTest_2();
    ContinuableViewModelTest();
    SuggestMenuModelTest();
    PCDockUtilsTest();
    DockItemPositionTest();
    SmartDockStyleMgrTest();
    BigDockModelTest();
    PhoneDockUtilsTest();
    PcModeDockPopupMgrTest();
    PcModeDockUtilsTest();
    DockHiSysEventMgrTest();
    StatusBarServiceEventMgrTest();
    SmartDockEventMgrTest();
    DockItemPlaceVmTest();
    DockItemAnimationEventTest();
    DockRegionAnimationEventTest();
    SmartDockObserverTest();
    SmartDockZoomAnimationConfigTest();
    SmartDockZoomAnimationManagerTest();
    SmartDockZoomEventTest();
    SmartDockReorderLayoutTest();
  });

  describe("sceneboard_desktopedit", () => {
    SmartDockDragHandlerTest();
  });
}