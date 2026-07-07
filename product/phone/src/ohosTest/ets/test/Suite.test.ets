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
import { AodRotationAdapterFactoryTest } from './ets/SceneBoard/aod/adapter/AodRotationAdapterFactory.test';
import {
  AodViewControllerFullScreenFolderTest
} from './ets/SceneBoard/aod/factory/viewcontroller/AodViewControllerFullScreenFolder.test';
import {
  AodViewControllerSmartStickerFolderTest
} from './ets/SceneBoard/aod/factory/viewcontroller/AodViewControllerSmartStickerFolder.test';
import FreezingTipUtilTest from './ets/SceneBoard/screenlock/common/FreezingTipUtilTest.test';
import RecentLayoutManagerTest from './ets/SceneBoard/recent/common/RecentLayoutManagerTest';
import RecentRotationUtilTest from './ets/SceneBoard/recent/common/RecentRotationUtilTest';
import MultiRowRecentLayoutCalTest from './ets/SceneBoard/recent/common/MultiRowRecentLayoutCal.test';
import SingleRowRecentLayoutCalTest from './ets/SceneBoard/recent/common/SingleRowRecentLayoutCal.test';
import ContainerPreBuildMgrTest from './ets/SceneBoard/recent/common/ContainerPreBuildMgr.test';
import RecentStateManagerTest from './ets/SceneBoard/recent/innerstate/RecentStateManager.test';
import AppFloatingTest from './ets/SceneBoard/recent/scenepanel/apppanel/AppFloating.test';
import RecentDeleteTest from './ets/SceneBoard/recent/scenepanel/recentpanel/RecentDelete.test';
import RecentClearAllTest from './ets/SceneBoard/recent/scenepanel/recentpanel/RecentClearAll.test';
import RecentGestureTest from './ets/SceneBoard/recent/scenepanel/recentpanel/RecentGesture.test';
import RecentNotShowTest from './ets/SceneBoard/recent/scenepanel/recentpanel/RecentNotShow.test';
import RecentPanelControllerTest from './ets/SceneBoard/recent/scenepanel/recentpanel/RecentPanelController.test';
import RecentScrollTest from './ets/SceneBoard/recent/scenepanel/recentpanel/RecentScroll.test';
import RecentScrollFlingTest from './ets/SceneBoard/recent/scenepanel/recentpanel/RecentScrollFling.test';
import RecentZoomAlarmTest from './ets/SceneBoard/recent/scenepanel/recentpanel/RecentZoomAlarm.test';
import RecentStartSceneTest from './ets/SceneBoard/recent/scenepanel/recentpanel/RecentStartScene.test';
import RecentExitTest from './ets/SceneBoard/recent/scenepanel/recentpanel/RecentExit.test'
import SCBScenePanelFSMTest from './ets/SceneBoard/recent/scenepanel/SCBScenePanelFSM.test';
import PhoneFolderLayoutConfigTest from './ets/common/folder/PhoneFolderLayoutConfig.test';
import PhonePageDesktopLayoutConfigTest from './ets/common/PhonePageDesktopLayoutConfig.test';
import SwitchIntentExecutorTest from './ets/intents/SwitchIntentExecutorImplTest.test';

import PhoneSmartDockLayoutConfigTest from './ets/common/PhoneSmartDockLayoutConfig.test';
import PhonePageDesktopGridStyleConfigTest from './ets/common/PhonePageDesktopGridStyleConfig.test';
import PhoneLauncherLayoutStyleConfigTest from './ets/common/PhoneLauncherLayoutStyleConfig.test';
import PhoneFormLayoutConfigTest from './ets/common/PhoneFormLayoutConfig.test';
import InvokeAuthResultCallbackTest from './ets/service/exthome/executor/impl/InvokeAuthResultCallback.test';
import InvokeFaceTest from './ets/service/exthome/executor/impl/InvokeFace.test';
import ExtHomeServiceTest from './ets/service/exthome/ExtHomeService.test';
import { FloatCalculatorTest } from './ets/SceneBoard/scenemanager/multiwindow/FloatCalculatorTest.test';

import SCBAiBarProxyManagerTest from './ets/SceneBoard/aiBar/SCBAiBarProxyManager.test';
import SCBAiBarCallBackTest from './ets/SceneBoard/aiBar/SCBAiBarCallBack.test';
import AiBarServiceTest from './ets/SceneBoard/aiBar/AiBarService.test';
import SCBGestureBackViewModelTest from './ets/SceneBoard/gesturenavigation/viewmodel/SCBGestureBackViewModel.test';
import DebugCommandsUtilsTest from './ets/SceneBoard/gesturenavigation/utils/DebugCommandsUtils.test';
import GestureDockPullOutModelTest from './ets/SceneBoard/gesturenavigation/model/GestureDockPullOutModel.test';
import AiBarSettingsDataMgrTest from './ets/SceneBoard/aiBar/settings/preference/AiBarSettingsDataMgr.test';
import ThreeButtonAccessibilityManagerTest
  from './ets/SceneBoard/aiBar/settings/preference/ThreeButtonAccessibilityManager.test';
import TextCodecTest from './ets/SceneBoard/aiBar/util/TextCodec.test';
import GestureDockBarViewModelTest from './ets/SceneBoard/gestureDock/dockbar/viewmodel/GestureDockBarViewModel.test';
import GestureDockAllAppsItemViewDataMgrTest
  from './ets/SceneBoard/gestureDock/dockappitem/viewdata/GestureDockAllAppsItemViewDataMgr.test';
import GestureDockAllAppsItemViewEventMgrTest
  from './ets/SceneBoard/gestureDock/dockappitem/viewevent/GestureDockAllAppsItemViewEventMgr.test';
import GestureDockAppItemViewDataMgrTest
  from './ets/SceneBoard/gestureDock/dockappitem/viewdata/GestureDockAppItemViewDataMgr.test';
import GestureDockAppItemViewEventMgrTest
  from './ets/SceneBoard/gestureDock/dockappitem/viewevent/GestureDockAppItemViewEventMgr.test';
import GestureDockAdapterTest from './ets/SceneBoard/gestureDock/common/adapter/GestureDockAdapter.test';
import GestureDockPreferenceMgrTest
  from './ets/SceneBoard/gestureDock/common/preference/GestureDockPreferenceMgr.test';
import GestureDockEventIdUtilTest from './ets/SceneBoard/gestureDock/common/util/GestureDockEventIdUtil.test';
import GestureDockUtilTest from './ets/SceneBoard/gestureDock/common/util/GestureDockUtil.test';
import ScreenInfoUtilTest from './ets/SceneBoard/gestureDock/common/util/ScreenInfoUtil.test';
import GestureDockParamTest from './ets/SceneBoard/gestureDock/dock/viewmodel/viewdata/GestureDockParam.test';
import GestureDockViewDataMgrTest
  from './ets/SceneBoard/gestureDock/dock/viewmodel/viewdata/GestureDockViewDataMgr.test';
import GestureDockViewEventMgrTest
  from './ets/SceneBoard/gestureDock/dock/viewmodel/viewevent/GestureDockViewEventMgr.test';
import CallStateHandlerTest from './ets/SceneBoard/gestureDock/dock/viewmodel/viewhandler/CallStateHandler.test';
import GestureDockViewModelTest from './ets/SceneBoard/gestureDock/dock/viewmodel/GestureDockViewModel.test';
import AllAppsStyleConfigMgrTest from './ets/SceneBoard/gestureDock/dockallapps/model/AllAppsStyleConfigMgr.test';
import GestureDockAllAppsViewDataMgrTest
  from './ets/SceneBoard/gestureDock/dockallapps/viewmodel/viewdata/GestureDockAllAppsViewDataMgr.test';
import GestureDockAllAppsViewEventMgrTest
  from './ets/SceneBoard/gestureDock/dockallapps/viewmodel/viewevent/GestureDockAllAppsViewEventMgr.test';
import GestureDockAllAppsViewModelTest
  from './ets/SceneBoard/gestureDock/dockallapps/viewmodel/GestureDockAllAppsViewModel.test';
import AllAppsItemViewEventTest from './ets/SceneBoard/gestureDock/dockappitem/AllAppsItemViewEvent.test';
import GestureDockBarViewAnimateTest
  from './ets/SceneBoard/gestureDock/dockbar/viewmodel/viewanimate/GestureDockBarViewAnimate.test';
import GestureDockBarParamTest from './ets/SceneBoard/gestureDock/dockbar/viewmodel/viewdata/GestureDockBarParam.test';
import GestureDockBarViewDataMgrTest
  from './ets/SceneBoard/gestureDock/dockbar/viewmodel/viewdata/GestureDockBarViewDataMgr.test';
import GestureDockBarViewEventMgrTest
  from './ets/SceneBoard/gestureDock/dockbar/viewmodel/viewevent/GestureDockBarViewEventMgr.test';
import GestureDockAppDataHandlerTest
  from './ets/SceneBoard/gestureDock/dockbar/viewmodel/viewhandler/GestureDockAppDataHandler.test';
import GestureDockItemDragHandlerTest
  from './ets/SceneBoard/gestureDock/dockbar/viewmodel/viewhandler/GestureDockItemDragHandler.test';
import AccessibilityUtilsTest from './ets/SceneBoard/aiBar/util/AccessibilityUtils.test';
import AIBarViewDataTest from './ets/SceneBoard/aiBar/AIBarModel/AlBarViewData.test';
import ThreeButtonUpgradeDSExtAbilityTest from './ets/SceneBoard/aiBar/ability/ThreeButtonUpgradeDSExtAbility.test';
import ThreeButtonUpgradeUIExtAbilityTest from './ets/SceneBoard/aiBar/ability/ThreeButtonUpgradeUIExtAbility.test';
import ThreeButtonUpgradeViewModelTest from './ets/SceneBoard/aiBar/AIBarModel/ThreeButtonUpgradeViewModel.test';
import AllAppsDataSourceTest from './ets/SceneBoard/gestureDock/dockallapps/model/AllAppsDataSource.test';
import FloatingNavigationManagerTest from './ets/SceneBoard/aiBar/proxy/FloatingNavigationManager.test';

import FormClearUtilsTest from './ets/common/FormClearUtils.test';
import BundleVerifyUtilsTest  from './ets/service/exthome/BundleVerifyUtils.test';
import SceneInfoTest from './ets/backup/SceneInfo.test';
import TransLayoutMethodImplTest from './ets/backup/impl/TransLayoutMethodImpl.test';
import NotificationFileRestoreMethodImplTest from './ets/backup/impl/NotificationFileRestoreMethodImpl.test';
import NotificationFileBackupMethodImplTest from './ets/backup/impl/NotificationFileBackupMethodImpl.test';
import FilePreprocessMethodImplTest from './ets/backup/impl/FilePreprocessMethodImpl.test';
import BackupNotificationControllerTest from './ets/backup/BackupNotificationController.test';
import BackupLauncherUtilTest from './ets/backup/BackupLauncherUtil.test';
import BackupLauncherControllerTest from './ets/backup/BackupLauncherController.test';
import BackupExtensionTest from './ets/backup/BackupExtension.test';
import BackupEventManagerTest from './ets/backup/BackupEventManager.test';
import GestureHelperTest from './ets/SceneBoard/recent/scenepanel/common/GestureHelper.test';
import HomeIdleTest from './ets/SceneBoard/recent/scenepanel/homepanel/HomeIdle.test';
import EmergencyHomeIdleTest from './ets/SceneBoard/recent/scenepanel/homepanel/EmergencyHomeIdle.test';
import HomePanelControllerTest from './ets/SceneBoard/recent/scenepanel/homepanel/HomePanelController.test';
import OverViewFollowingFromHomeTest from './ets/SceneBoard/recent/scenepanel/homepanel/OverViewFollowingFromHome.test';
import AppIdleTest from './ets/SceneBoard/recent/scenepanel/apppanel/AppIdle.test';
import QuickSwitchFollowingFromHomeTest
  from './ets/SceneBoard/recent/scenepanel/homepanel/QuickSwitchFollowingFromHome.test';
import HomeViewModelTest from './ets/SceneBoard/recent/scenepanel/homepanel/HomeViewModel.test';
import QuickSwitchViewModelTest from './ets/SceneBoard/recent/scenepanel/homepanel/QuickSwitchViewModel.test';
import { SCBBlockCoverTest } from './ets/SceneBoard/scenemanager/multiwindow/SCBBlockCoverTest.test';
import QuickSwitchIdleTest from './ets/SceneBoard/recent/scenepanel/quickswitchpanel/QuickSwitchIdle.test';
import QuickSwitchRaiseTopAlarmTest from './ets/SceneBoard/recent/scenepanel/quickswitchpanel/QuickSwitchRaiseTopAlarm.test';
import SplitIdleTest from './ets/SceneBoard/recent/scenepanel/splitpanel/SplitIdle.test';
import RecentIdleTest from './ets/SceneBoard/recent/scenepanel/recentpanel/RecentIdle.test';
import RecentScrollHelperTest from './ets/SceneBoard/recent/scenepanel/recentpanel/RecentScrollHelper.test';
import MainAbilityTest from './ets/MainAbility/MainAbility.test';
import { AodThemeParamDirectorTest } from './ets/SceneBoard/aod/personalization/builder/AodThemeParamDirector.test';
import RecentTitleViewModelTest from './ets/SceneBoard/recent/scenepanel/RecentTitleViewModel.test';
import QuickSwitchFollowingFromAppTest
  from './ets/SceneBoard/recent/scenepanel/apppanel/QuickSwitchFollowingFromApp.test';
import FarAwayFollowingFromAppTest from './ets/SceneBoard/recent/scenepanel/apppanel/FarAwayFollowingFromApp.test';
import RecentFollowingFromAppTest from './ets/SceneBoard/recent/scenepanel/apppanel/RecentFollowingFromApp.test';
import ZoomFollowingFromAppTest from './ets/SceneBoard/recent/scenepanel/apppanel/ZoomFollowingFromApp.test';
import ZoomFollowingAnimationsTest from './ets/SceneBoard/recent/scenepanel/apppanel/ZoomFollowingAnimations.test';
import { AodStyleGroupBuilderTest } from './ets/SceneBoard/aod/personalization/builder/AodStyleGroupBuilder.test';
import { AodThemeParamBuilderTest } from './ets/SceneBoard/aod/personalization/builder/AodThemeParamBuilder.test';
import { AodIntentBackgroundUiAbilityTest } from './ets/SceneBoard/aod/intents/AodIntentBackgroundUiAbility.test';
import { AodIntentExecutorImplTest } from './ets/SceneBoard/aod/intents/AodIntentExecutorImpl.test';
import { AodStyleDataManagerTest } from './ets/SceneBoard/aod/personalization/manager/AodStyleDataManager.test';
import { AodStyleImageManagerTest } from './ets/SceneBoard/aod/personalization/manager/AodStyleImageManager.test';
import { ConstantTest } from './ets/SceneBoard/aod/personalization/constant/Constant.test';
import { StorageKeyTest } from './ets/SceneBoard/aod/personalization/constant/StorageKey.test';
import { AodMainPageControllerTest } from './ets/SceneBoard/aod/personalization/controller/MainPageController.test';
import { PageControllerTest } from './ets/SceneBoard/aod/personalization/controller/PageController.test';
import { PreviewPageControllerTest } from './ets/SceneBoard/aod/personalization/controller/PreviewPageController.test';
import { AodRotationAdapterTest } from './ets/SceneBoard/aod/adapter/AodRotationAdapter.test';
import { Rotation90StrategyTest } from './ets/SceneBoard/aod/adapter/rotation/Rotation90Strategy.test';
import { Rotation180StrategyTest } from './ets/SceneBoard/aod/adapter/rotation/Rotation180Strategy.test';
import { AodStyleListModelTest } from './ets/SceneBoard/aod/personalization/model/AodStyleListModel.test';
import { AodStyleGroupListModelTest } from './ets/SceneBoard/aod/personalization/model/AodStyleGroupListModel.test';
import {
  AodViewControllerDigitalClockFolderTest
} from './ets/SceneBoard/aod/factory/viewcontroller/AodViewControllerDigitalClockFolder.test';
import {
  AodViewControllerAnalogClockFolderTest
} from './ets/SceneBoard/aod/factory/viewcontroller/AodViewControllerAnalogClockFolder.test';
import {
  AodViewControllerInteractiveFolderTest
} from './ets/SceneBoard/aod/factory/viewcontroller/AodViewControllerInteractiveFolder.test';
import {
  AodViewControllerStereoForeImageFolderTest
} from './ets/SceneBoard/aod/factory/viewcontroller/AodViewControllerStereoForeImageFolder.test';
import {
  AodViewControllerStereoNumberClockFolderTest
} from './ets/SceneBoard/aod/factory/viewcontroller/AodViewControllerStereoNumberClockFolder.test';
import { Rotation270StrategyTest } from './ets/SceneBoard/aod/adapter/rotation/Rotation270Strategy.test';
import { AodRotationTemplateTest } from './ets/SceneBoard/aod/adapter/AodRotationTemplate.test';
import { AodDisplayHelperTest } from './ets/SceneBoard/aod/personalization/utils/AodDisplayHelper.test';
import { SmallWindowUtilTest } from './ets/SceneBoard/aod/personalization/utils/SmallWindowUtil.test';
import { EditPanelSizeUtilTest } from './ets/SceneBoard/aod/personalization/utils/EditPanelSizeUtil.test';
import { MainPanelUtilTest } from './ets/SceneBoard/aod/personalization/utils/MainPanelUtil.test';
import { GridUtilTest } from './ets/SceneBoard/aod/personalization/utils/GridUtil.test';
import { AodThemeUtilTest } from './ets/SceneBoard/aod/personalization/utils/AodThemeUtil.test';
import { AodThemeAbstractFactoryTest } from './ets/SceneBoard/aod/factory/AodThemeAbstractFactory.test';
import {
  ThumbnailSizeUtilTest
} from './ets/SceneBoard/aod/personalization/utils/ThumbnailSizeUtil.test';
import {
  RecoverThemeAppTest
} from './ets/SceneBoard/aod/personalization/utils/RecoverThemeApp.test';
import {
  ThemeServiceConnectorTest
} from './ets/SceneBoard/aod/personalization/service/ThemeServiceConnector.test';
import {
  AodViewCtlStereoNumberClockPadTest
} from './ets/SceneBoard/aod/factory/viewcontroller/AodViewCtlStereoNumberClockPad.test';
import {
  AodViewCtlStereoForeImagePadTest
} from './ets/SceneBoard/aod/factory/viewcontroller/AodViewCtlStereoForeImagePad.test';
import {
  AodViewCtlInteractivePadTest
} from './ets/SceneBoard/aod/factory/viewcontroller/AodViewCtlInteractivePad.test';
import {
  AodWindowManagerTest,
  AodWindowTest
} from './ets/SceneBoard/aod/personalization/manager/AodWindowManager.test';
import {
  AodDisplayManagerTest
} from './ets/SceneBoard/aod/personalization/manager/AodDisplayManager.test';
import {
  AodViewCtlDigitalClockPadTest
} from './ets/SceneBoard/aod/factory/viewcontroller/AodViewCtlDigitalClockPad.test';
import {
  AodViewCtlAnalogClockPadTest
} from './ets/SceneBoard/aod/factory/viewcontroller/AodViewCtlAnalogClockPad.test';
import {
  AodRotationAdapterPadTest
} from './ets/SceneBoard/aod/adapter/AodRotationAdapterPad.test';
import SCBRecentSessionsViewModelTest from './ets/SceneBoard/scenemanager/pcmode/SCBRecentSessionsViewModel.test';
import InvokeUnlockTest from './ets/service/exthome/executor/impl/invokeUnlock.test';
import RestoringPhoneDesktopLayoutTest from './ets/backup/impl/RestoringPhoneDesktopLayout.test';
import TransferDesktopSettingMethodImplTest
  from './ets/backup/impl/TransferDesktopSettingMethodImpl.test';
import ScbIntentExecutorImplTest from './ets/intents/ScbIntentExecutorImplTest.test';
import OuterHomeManagerTest from './ets/SceneBoard/screenlock/common/OuterHomeManagerTest.test';
import OuterHomeRemoteServiceTest from './ets/SceneBoard/screenlock/idlService/OuterHomeRemoteService.test';
import IdlOuterHomeServiceProxyTest from './ets/SceneBoard/screenlock/idlService/IdlOuterHomeServiceProxy.test';
import { DesktopEditPageViewModelTest } from './ets/desktopedit/viewmodel/DesktopEditPageViewModel.test';
import RecentDeleteFollowingTest from './ets/SceneBoard/recent/scenepanel/recentpanel/RecentDeleteFollowing.test';
import RecentMediaPlayTest from './ets/SceneBoard/recent/scenepanel/recentpanel/RecentMediaPlay.test'
import RecentLockIconModelTest from './ets/SceneBoard/recent/scenepanel/recentpanel/RecentLockIconModel.test'
import RecentAccessibilityUtilsTest from './ets/SceneBoard/recent/scenepanel/recentpanel/RecentAccessibilityUtils.test';
import RecentEventViewModelTest from './ets/SceneBoard/recent/scenepanel/recentpanel/RecentEventViewModel.test';
import RecentEnterAnimationsTest from './ets/SceneBoard/recent/scenepanel/recentpanel/RecentEnterAnimations.test';
import RecentRuntimeModelTest from './ets/SceneBoard/recent/scenepanel/recentpanel/RecentRuntimeModel.test';
import QuickSwitchAnimationsTest from './ets/SceneBoard/recent/scenepanel/quickswitchpanel/QuickSwitchAnimations.test';
import { SCBFloatManagerTest } from './ets/SceneBoard/scenemanager/multiwindow/SCBFloatManagerTest.test';
import { SCBMultiWindowManagerTest } from './ets/SceneBoard/scenemanager/multiwindow/SCBMultiWindowManagerTest.test';
import {
  SCBMultiWindowDumpsterManagerTest
} from './ets/SceneBoard/scenemanager/multiwindow/SCBMultiWindowDumpsterManagerTest.test';
import SCBMultiWindowUtilsTest from './ets/SceneBoard/scenemanager/multiwindow/SCBMultiWindowUtilsTest.test';
import { SCBOneStepViewModelTest } from './ets/SceneBoard/scenemanager/multiwindow/SCBOneStepViewModel.test';
import { PiPUtilsTest } from './ets/SceneBoard/scenemanager/multiwindow/PiPUtilsTest.test';
import { SCBPiPManagerTest } from './ets/SceneBoard/scenemanager/multiwindow/SCBPiPManager.test';
import { SCBSplitManagerTest } from './ets/SceneBoard/scenemanager/multiwindow/SCBSplitManagerTest.test';
import {
  SplitViewAnimationManagerTest
} from './ets/SceneBoard/scenemanager/multiwindow/SplitViewAnimationManagerTest.test';
import MultiDockSwitchControllerTest from './ets/SceneBoard/scenemanager/multiwindow/MultiDockSwitchController.test';
import PiPSwitchControllerTest from './ets/SceneBoard/scenemanager/multiwindow/PiPSwitchController.test';
import { SCBSceneTitleBarTest } from './ets/SceneBoard/scenemanager/multiwindow/SCBSceneTitleBar.test';
import { SCBFloatDragScaleTest } from './ets/SceneBoard/scenemanager/multiwindow/SCBFloatDragScaleTest.test';
import { SCBAppIconTest } from './ets/SceneBoard/scenemanager/multiwindow/SCBAppIconTest.test';
import GuidanceDialogManagerTest from './ets/SceneBoard/scenemanager/multiwindow/GuidanceDialogManager.test';
import { SCBSideEdgeBarManagerTest } from './ets/SceneBoard/scenemanager/multiwindow/SCBSideEdgeBarManager.test';
import { SCBFloatMiniCoverTest } from './ets/SceneBoard/scenemanager/multiwindow/SCBFloatMiniCover.test';
import { SCBGestureRecordTest } from './ets/SceneBoard/scenemanager/multiwindow/SCBGestureRecord.test';
import { SCBGridRowUtilsTest } from './ets/SceneBoard/scenemanager/multiwindow/SCBGridRowUtils.test';
import { SCBMenuParamTest } from './ets/SceneBoard/scenemanager/multiwindow/SCBMenuParam.test';
import SCBSnapScreenShotColorTest from './ets/SceneBoard/scenemanager/multiwindow/SCBSnapScreenShotColorTest.test';
import { GuideTipsManagerTest } from './ets/SceneBoard/scenemanager/multiwindow/GuideTipsManager.test';
import { GuideTipSceneSessionTest } from './ets/SceneBoard/scenemanager/multiwindow/GuideTipSceneSession.test';
import { SCBFloatGestureProcessorTest} from './ets/SceneBoard/scenemanager/multiwindow/SCBFloatGestureProcessor.test'
import LandscapeWindowControllerTest from './ets/SceneBoard/scenemanager/landScapeWindow/controllers/LandscapeWindowController.test';
import { LandscapeWindowStartupControllerTest } from './ets/SceneBoard/scenemanager/landScapeWindow/controllers/LandscapeWindowStartupController.test';

import { SlBindStateTest } from './ets/SceneBoard/screenlock/model/data/SlBindState.test';
import { SlStaticStateTest } from './ets/SceneBoard/screenlock/model/data/SlStaticState.test';
import { SlStateHelperTest } from './ets/SceneBoard/screenlock/model/helper/SlStateHelper.test';
import OuterPhonePageDesktopLayoutConfigTest from './ets/common/OuterPhonePageDesktopLayoutConfig.test';
import {
  ScreenLockInitializeServiceTest
} from './ets/SceneBoard/screenlock/model/service/ScreenLockInitializeServiceTest.test';
import { SlCommonStateManagerTest } from './ets/SceneBoard/screenlock/model/manager/SlCommonStateManagerTest.test';
import { ScreenLockVmTest } from './ets/SceneBoard/screenlock/viewmodel/ScreenLockVmTest.test';
import { ScreenLockEditVmTest } from './ets/SceneBoard/screenlock/viewmodel/ScreenLockEditVmTest.test';
import { OuterHomeManagerUtilTest } from './ets/SceneBoard/screenlock/utils/OuterHomeManagerUtil.test';
import TripleAnimManagerUtilTest from './ets/SceneBoard/screenlock/utils/TripleAnimManagerUtilTest.test';
import { SCBFreeformSceneUtilsTest } from './ets/SceneBoard/scenemanager/pcmode/SCBFreeformSceneUtilsTest.test';
import FloatingSceneViewModelTest from './ets/SceneBoard/scenemanager/pcmode/FloatingSceneViewModel.test'
import { CompanionIconForPCTest } from './ets/SceneBoard/scenemanager/pcmode/CompanionIconForPC.test';
import { FloatingSceneViewDataTest } from './ets/SceneBoard/scenemanager/pcmode/FloatingSceneViewDataTest.test';
import { SCBDividerParamTest } from './ets/SceneBoard/scenemanager/multiwindow/SCBDividerParam.test';
import { SCBFloatingParamTest } from './ets/SceneBoard/scenemanager/multiwindow/SCBFloatingParam.test';
import multiWindowTaskTest from './ets/SceneBoard/scenemanager/multiwindow/SCBMultiWindowTask.test';
import floatBackgroundParamTest from './ets/SceneBoard/scenemanager/multiwindow/SCBFloatBackground.test';
import { AnimationParamTest } from './ets/SceneBoard/scenemanager/multiwindow/AnimationParamTest.test';
import SCBGestureNavBarViewModelTest from './ets/SceneBoard/gesturenavigation/SCBGestureNavBarViewModel.test';
import GlobalSearchLocationServiceTest from './ets/service/GlobalSearchLocationService.test';
import RecentDeviceServiceTest from './ets/service/RecentDeviceService.test';
import CancelRestoreLauncherDataTest from './ets/service/impl/CancelRestoreLauncherData.test';
import QueryDesktopAppTest from './ets/service/impl/QueryDesktopApp.test';
import { SCBDividerHelperTest } from './ets/SceneBoard/scenemanager/multiwindow/SCBDividerHelper.test';
import { SCBSplitParamTest } from './ets/SceneBoard/scenemanager/multiwindow/SCBSplitParam.test';
import { SCBStatusBarVMTest } from './ets/SceneBoard/statusbar/viewmodel/SCBStatusBarVM.test';
import { SCBInputMethodHelperTest } from './ets/SceneBoard/scenemanager/multiwindow/SCBInputMethodHelperTest.test';
import { MidSceneManagerTest } from './ets/SceneBoard/scenemanager/multiwindow/midscene/MidSceneManagerTest.test';
import { MidSceneFSMTest } from './ets/SceneBoard/scenemanager/multiwindow/midscene/MidSceneFSMTest.test';
import MidSceneRecentHelperTest from './ets/SceneBoard/scenemanager/multiwindow/midscene/MidSceneRecentHelper.test';
import { FilledStateTest } from './ets/SceneBoard/scenemanager/multiwindow/midscene/FilledStateTest.test';
import { NonMidStateTest } from './ets/SceneBoard/scenemanager/multiwindow/midscene/NonMidStateTest.test';
import { UnfilledStateTest } from './ets/SceneBoard/scenemanager/multiwindow/midscene/UnfilledStateTest.test';
import { SCBDockSplitHelperTest } from './ets/SceneBoard/scenemanager/multiwindow/SCBDockSplitHelperTest.test';
import { SCBSceneSessionManagerTest } from './ets/SceneBoard/scenemanager/multiwindow/SCBSceneSessionManagerTest.test';
import { WaitingAddStateTest } from './ets/SceneBoard/scenemanager/multiwindow/midscene/WaitingAddStateTest.test';
import {
  WaitingReplaceStateTest
} from './ets/SceneBoard/scenemanager/multiwindow/midscene/WaitingReplaceStateTest.test';
import { paramHelperTest } from './ets/SceneBoard/scenemanager/multiwindow/ParamHelper.test';
import { MidSceneUtilsTest } from './ets/SceneBoard/scenemanager/multiwindow/midscene/MidSceneUtilsTest.test';
import { SCBMultiWindowReporterTest } from './ets/SceneBoard/scenemanager/multiwindow/MultiWindowReporter.test';
import SwipeInwardControllerTest from './ets/SceneBoard/touchboardgesture/SwipeInwardEvent.test';
import TouchBoardSwipeInwardGestureManagerTest from './ets/SceneBoard/touchboardgesture/SwipeInwardGestureManager.test';
import { multiWindowRssHelperTest } from './ets/SceneBoard/scenemanager/multiwindow/MultiWindowRssHelper.test';
import { MidSceneGestureTest } from './ets/SceneBoard/scenemanager/multiwindow/midscene/MidSceneGestureTest.test';
import {
  MidSceneManagerForTripleFoldTest
} from './ets/SceneBoard/scenemanager/multiwindow/midscene/MidSceneManagerForTripleFoldTest.test';
import RecentForegroundBlurAniMgrTest
  from './ets/SceneBoard/recent/scenepanel/recentpanel/RecentForegroundBlurAniMgr.test';
import { FlashlightTipsHelperTest } from '../../../test/SceneBoard/flashlight/FlashlightTipsHelper.test';
import { ThreeFingerSwipeEventTest } from './ets/SceneBoard/touchboardgesture/ThreeFingerSwipeEventTest.test';
import {
  LandScapeWindowSettingAbilityTest
} from './ets/SceneBoard/scenemanager/landScapeWindow/controllers/LandScapeWindowSettingAbilityTest.test';
import {
  ThreeFingerSwipeControllerPhoneTest,
} from './ets/SceneBoard/touchboardgesture/ThreeFingerSwipeControllerPhoneTest.test';
import { FlashlightTipsModelTest } from './ets/SceneBoard/screenlock/viewmodel/FlashlightTipsModelTest.test';
import { TouchBoardGestureManagerTest } from './ets/SceneBoard/touchboardgesture/TouchBoardGestureManagerTest.test';
import { EditModeIconAbilityPhoneTest } from './ets/desktopedit/ability/EditModeIconAbilityPhone.test';
import AIBarAnimateTest from './ets/SceneBoard/aiBar/AIBarModel/AIBarAnimate.test';
import AIBarClickBackgroundDataTest from './ets/SceneBoard/aiBar/AIBarModel/AIBarClickBackgroundData.test';
import AIBarDataTest from './ets/SceneBoard/aiBar/AIBarModel/AIBarData.test';
import AIBarViewModelTest from './ets/SceneBoard/aiBar/AIBarModel/AIBarViewModel.test';
import {
  AnimationParam1Test,
  DialClockParamTest,
  DigitalClockParamTest,
  FullScreenParamTest,
  InteractiveParamTest,
  MountainSeaParamTest,
  OuterClockParamTest,
  StereoForeImageParamTest,
  StereoNumberClockParamTest} from '@ohos/aod/src/ohosTest/ets/test/ets/theme/viewmodel/AodViewModel.test';
import PadBackGestureModelTest from './ets/SceneBoard/gesturenavigation/model/PadBackGestureModel.test';
import PadBackEventViewModelTest from './ets/SceneBoard/gesturenavigation/viewmodel/PadBackEventViewModel.test';
import SwipeInwardBackModelTest from './ets/SceneBoard/touchboardgesture/SwipeInwardBackModel.test';
import AodPreviewImageManagerTest from './ets/SceneBoard/aod/personalization/manager/AodPreviewImageManager.test';
import ThermalPadStyleConfigTest from './ets/SceneBoard/emergency/styleConfig/ThermalPadStyleConfig.test'
import EmergencyTestSuite from '../../../../../../feature/desktop/emergencymode/src/ohosTest/ets/test/List.test';
import EmergencyFoldStyleConfigTest from './ets/SceneBoard/emergency/styleConfig/EmergencyFoldStyleConfig.test';
import StyleConfigFactoryTest from './ets/SceneBoard/emergency/StyleConfigFactory.test';
import FoldPhoneLayoutRulesControllerTest from './ets/SceneBoard/controllers/SceneDesktopController/FoldPhoneLayoutRulesController.test';
import SimplePhoneLayoutRulesControllerTest from './ets/SceneBoard/controllers/SceneDesktopController/SimplePhoneLayoutRulesController.test';
import MidSceneManagerForPadTest
  from './ets/SceneBoard/scenemanager/multiwindow/midsceneforpad/MidSceneManagerForPadTest.test';
import ThermalPhoneStyleConfigTest from './ets/SceneBoard/emergency/styleConfig/ThermalPhoneStyleConfig.test';
import IntentBeanFactoryTest from './ets/intents/utils/IntentBeanFactory.test';
import FileUtilTest from './ets/intents/utils/FileUtil.test';
// import DesktopInformationReporterTest from './ets/SceneBoard/desktopReporter/DesktopInformationReporter.test';
import GestureDockMethodImplTest from './ets/backup/impl/GestureDockMethodImpl.test';
import SCBSceneManagementOnPhoneTest from './ets/SceneBoard/scenemanager/SCBSceneManagementOnPhoneTest.test';
import SCBRotateUtilsTest from './ets/SceneBoard/scenemanager/utils/SCBRotateUtilsTest.test';
import MidSceneDraggingEventHandlerTest
  from './ets/SceneBoard/scenemanager/multiwindow/midsceneforpad/MidSceneDraggingEventHandlerTest.test';
import { AodRotationAdapterThreeFoldTest } from './ets/SceneBoard/aod/adapter/AodRotationAdapterThreeFold.test';
import { PipOneShotAnimHelperTest } from './ets/SceneBoard/scenemanager/multiwindow/PipOneShotAnimHelper.test';
import { CommonSCBScreenSuite } from '../../../../../../feature/commonscbscreen/src/ohosTest/ets/test/List.test'
import {
  AodViewControllerOuterDigitalClockTest
} from './ets/SceneBoard/aod/factory/viewcontroller/AodViewControllerOuterDigitalClock.test';
import {
  AodLayerProviderOuterDigitalClockTest
} from './ets/SceneBoard/aod/factory/layerprovider/AodLayerProviderOuterDigitalClock.test';
import { MidSceneTimerUtilsTest } from './ets/SceneBoard/scenemanager/multiwindow/midscene/MidSceneTimerUtilsTest.test';
import { FloatingBallListVmTest } from './ets/SceneBoard/scenemanager/multiwindow/floatingball/FloatingBallListVm.test';
import { FloatingBallRectVmTest } from './ets/SceneBoard/scenemanager/multiwindow/floatingball/FloatingBallRectVm.test';
import { FloatingBallPanelVmTest } from './ets/SceneBoard/scenemanager/multiwindow/floatingball/FloatingBallPanelVm.test';
import {
  SCBBatchEnterMultiWindowManagerTest
} from './ets/SceneBoard/scenemanager/multiwindow/SCBBatchEnterMultiWindowManager.test';
import { AodOuterConstParamsTest } from './ets/SceneBoard/aod/view/outerdigitalclock/AodOuterConstParams.test';
import {
  FloatingBallAnimationTest
} from './ets/SceneBoard/scenemanager/multiwindow/floatingball/FloatingBallAnimation.test';
import {
  SCBFloatingBallPanelVmTest
} from './ets/SceneBoard/scenemanager/multiwindow/floatingball/SCBFloatingBallPanelVm.test';
import { FloatingBallMenuVmTest } from './ets/SceneBoard/scenemanager/multiwindow/floatingball/FloatingBallMenuVm.test';
import {
  FloatingBallOneMirrorAnimationTest
} from './ets/SceneBoard/scenemanager/multiwindow/floatingball/FloatingBallOneMirrorAnimation.test';

export default function PipelineDemoSuite() {
  describe("sceneboard_aod", () => {
    AodRotationAdapterFactoryTest();
    AodViewControllerFullScreenFolderTest();
    AodViewControllerSmartStickerFolderTest();
    AodThemeParamDirectorTest();
    AodStyleGroupBuilderTest();
    AodThemeParamBuilderTest();
    AodIntentBackgroundUiAbilityTest();
    AodIntentExecutorImplTest();
    AodStyleDataManagerTest();
    AodStyleImageManagerTest();
    ConstantTest();
    StorageKeyTest();
    AodMainPageControllerTest();
    PageControllerTest();
    PreviewPageControllerTest();
    AodRotationAdapterTest();
    Rotation90StrategyTest();
    Rotation180StrategyTest();
    AodStyleListModelTest();
    AodStyleGroupListModelTest();
    AodViewControllerDigitalClockFolderTest();
    AodViewControllerAnalogClockFolderTest();
    AodViewControllerInteractiveFolderTest();
    AodViewControllerStereoForeImageFolderTest();
    AodViewControllerStereoNumberClockFolderTest();
    Rotation270StrategyTest();
    AodRotationTemplateTest();
    AodDisplayHelperTest();
    SmallWindowUtilTest();
    EditPanelSizeUtilTest();
    MainPanelUtilTest();
    GridUtilTest();
    AodThemeUtilTest();
    ThumbnailSizeUtilTest();
    AodThemeAbstractFactoryTest();
    RecoverThemeAppTest();
    ThemeServiceConnectorTest();
    AodViewCtlStereoNumberClockPadTest();
    AodViewCtlStereoForeImagePadTest();
    AodViewCtlInteractivePadTest();
    AodViewCtlAnalogClockPadTest();
    AodRotationAdapterPadTest();
    AodWindowManagerTest();
    AodDisplayManagerTest();
    AodViewCtlDigitalClockPadTest();
    AnimationParam1Test();
    DigitalClockParamTest();
    DialClockParamTest();
    MountainSeaParamTest();
    FullScreenParamTest();
    InteractiveParamTest();
    StereoForeImageParamTest();
    StereoNumberClockParamTest();
    OuterClockParamTest();
    AodWindowTest();
    AodPreviewImageManagerTest();
    AodRotationAdapterThreeFoldTest();
    AodViewControllerOuterDigitalClockTest();
    AodLayerProviderOuterDigitalClockTest();
    AodOuterConstParamsTest();
  });

  describe('ImmersiveKeyguard', () => {
    FreezingTipUtilTest();
    OuterHomeManagerTest();
    OuterHomeRemoteServiceTest();
    IdlOuterHomeServiceProxyTest();
    SlBindStateTest();
    SlStaticStateTest();
    SlStateHelperTest();
    ScreenLockInitializeServiceTest();
    SlCommonStateManagerTest();
    ScreenLockVmTest();
    ScreenLockEditVmTest();
  });

  // Phone中多任务模块的所有DT用例
  describe('sceneboard_multitasks', () => {
    MultiRowRecentLayoutCalTest();
    RecentLayoutManagerTest();
    RecentRotationUtilTest();
    SingleRowRecentLayoutCalTest();
    ContainerPreBuildMgrTest();
    RecentStateManagerTest();
    AppFloatingTest();
     RecentDeleteTest();
  RecentClearAllTest();
    RecentMediaPlayTest();
    RecentLockIconModelTest();
    RecentNotShowTest();
    RecentPanelControllerTest();
    RecentScrollTest();
    RecentDeleteFollowingTest();
    RecentEnterAnimationsTest();
    QuickSwitchAnimationsTest();
    SCBScenePanelFSMTest();
    GestureHelperTest();
    HomeIdleTest();
    HomePanelControllerTest();
    OverViewFollowingFromHomeTest();
    AppIdleTest();
    QuickSwitchFollowingFromHomeTest();
    QuickSwitchIdleTest();
    SplitIdleTest();
    RecentIdleTest();
    QuickSwitchFollowingFromAppTest();
    FarAwayFollowingFromAppTest();
    RecentFollowingFromAppTest();
    ZoomFollowingFromAppTest();
    RecentTitleViewModelTest();
    RecentZoomAlarmTest();
    RecentExitTest();
    RecentRuntimeModelTest();
    RecentAccessibilityUtilsTest();
    RecentEventViewModelTest();
    RecentScrollHelperTest();
    RecentForegroundBlurAniMgrTest();
    RecentStartSceneTest();
    RecentGestureTest();
    EmergencyHomeIdleTest();
    QuickSwitchRaiseTopAlarmTest();
    ZoomFollowingAnimationsTest();
    RecentScrollFlingTest();
    HomeViewModelTest();
    QuickSwitchViewModelTest();
  });

  // 设备桌面导航
  describe('launcher_navigation_for_oh', () => {
    // gestureDock
    GestureDockAdapterTest();
    GestureDockPreferenceMgrTest();
    GestureDockEventIdUtilTest();
    GestureDockUtilTest();
    ScreenInfoUtilTest();
    GestureDockParamTest();
    GestureDockViewDataMgrTest();
    GestureDockViewEventMgrTest();
    CallStateHandlerTest();
    GestureDockViewModelTest();
    AllAppsStyleConfigMgrTest();
    GestureDockAllAppsViewDataMgrTest();
    GestureDockAllAppsViewEventMgrTest();
    GestureDockAllAppsViewModelTest();
    AllAppsItemViewEventTest();
    GestureDockBarViewAnimateTest();
    GestureDockBarParamTest();
    GestureDockBarViewDataMgrTest();
    GestureDockBarViewEventMgrTest();
    GestureDockAppDataHandlerTest();
    GestureDockItemDragHandlerTest();
    GestureDockBarViewModelTest();
    GestureDockAllAppsItemViewDataMgrTest();
    GestureDockAllAppsItemViewEventMgrTest();
    GestureDockAppItemViewDataMgrTest();
    GestureDockAppItemViewEventMgrTest();
    AllAppsDataSourceTest();
    // gestureNavigation
    GestureDockPullOutModelTest();
    DebugCommandsUtilsTest();
    SCBGestureBackViewModelTest();
    SCBGestureNavBarViewModelTest();
    //aiBar
    SCBAiBarProxyManagerTest();
    SCBAiBarCallBackTest();
    AiBarServiceTest();
    PadBackGestureModelTest();
    PadBackEventViewModelTest();
    AIBarAnimateTest();
    AIBarClickBackgroundDataTest();
    AIBarDataTest();
    AiBarSettingsDataMgrTest();
    ThreeButtonAccessibilityManagerTest();
    AIBarViewModelTest();
    TextCodecTest();
    AccessibilityUtilsTest();
    AIBarViewDataTest();
    ThreeButtonUpgradeDSExtAbilityTest();
    ThreeButtonUpgradeUIExtAbilityTest();
    ThreeButtonUpgradeViewModelTest();
    FloatingNavigationManagerTest();
  });

  describe("sceneboard_folder", () => {
    PhoneFolderLayoutConfigTest();
  });

  describe("multiwindow", () => {
    SCBFloatManagerTest();
    SCBMultiWindowManagerTest();
    SCBMultiWindowDumpsterManagerTest();
    SCBBlockCoverTest();
    SCBFloatDragScaleTest();
    SCBMultiWindowUtilsTest();
    SCBOneStepViewModelTest();
    PiPUtilsTest();
    SCBPiPManagerTest();
    PipOneShotAnimHelperTest();
    SCBSplitManagerTest();
    SplitViewAnimationManagerTest();
    PiPSwitchControllerTest();
    SCBMultiWindowReporterTest();
    MultiDockSwitchControllerTest();
    SCBGestureRecordTest();
    SCBGridRowUtilsTest();
    GuidanceDialogManagerTest();
    SCBMenuParamTest();
    SCBSnapScreenShotColorTest();
    FloatCalculatorTest();
    SCBSceneTitleBarTest();
    SCBAppIconTest();
    SCBSideEdgeBarManagerTest();
    SCBFloatMiniCoverTest();
    GuideTipsManagerTest();
    GuideTipSceneSessionTest();
    SCBFloatGestureProcessorTest();
    SCBDividerParamTest();
    SCBFloatingParamTest();
    AnimationParamTest();
    multiWindowTaskTest();
    floatBackgroundParamTest();
    SCBDividerHelperTest();
    SCBInputMethodHelperTest();
    SCBSplitParamTest();
    MidSceneFSMTest();
    FilledStateTest();
    NonMidStateTest();
    UnfilledStateTest();
    SCBDockSplitHelperTest();
    SCBSceneSessionManagerTest();
    WaitingAddStateTest();
    WaitingReplaceStateTest();
    MidSceneRecentHelperTest();
    paramHelperTest();
    multiWindowRssHelperTest();
    MidSceneUtilsTest();
    MidSceneManagerForTripleFoldTest();
    MidSceneGestureTest();
    MidSceneManagerTest();
    MidSceneTimerUtilsTest();
    FloatingBallRectVmTest();
    FloatingBallListVmTest();
    FloatingBallPanelVmTest();
    SCBBatchEnterMultiWindowManagerTest();
    FloatingBallAnimationTest();
    SCBFloatingBallPanelVmTest();
    FloatingBallMenuVmTest();
    FloatingBallOneMirrorAnimationTest();
  });

  describe("launcher_components", () => {
    BackupEventManagerTest();
    BackupExtensionTest();
    BackupLauncherControllerTest();
    BackupLauncherUtilTest();
    BackupNotificationControllerTest();
    FilePreprocessMethodImplTest();
    TransferDesktopSettingMethodImplTest();
    NotificationFileBackupMethodImplTest();
    NotificationFileRestoreMethodImplTest();
    TransLayoutMethodImplTest();
    ThermalPadStyleConfigTest();
    ThermalPhoneStyleConfigTest();
    GlobalSearchLocationServiceTest();
    SceneInfoTest();
    RestoringPhoneDesktopLayoutTest();
    GestureDockMethodImplTest();
    StyleConfigFactoryTest();
  });

  describe("basic_launcher_for_oh", () => {
    PhonePageDesktopLayoutConfigTest();
    FormClearUtilsTest();
    PhoneFormLayoutConfigTest();
    PhoneLauncherLayoutStyleConfigTest();
    PhonePageDesktopGridStyleConfigTest();
    PhoneSmartDockLayoutConfigTest();
    InvokeAuthResultCallbackTest();
    InvokeFaceTest();
    InvokeUnlockTest();
    ExtHomeServiceTest();
    BundleVerifyUtilsTest();
    DesktopEditPageViewModelTest();
    OuterPhonePageDesktopLayoutConfigTest();
    RecentDeviceServiceTest();
    CancelRestoreLauncherDataTest();
    QueryDesktopAppTest();
    EmergencyTestSuite();
    EmergencyFoldStyleConfigTest();
    FoldPhoneLayoutRulesControllerTest();
    SimplePhoneLayoutRulesControllerTest();
    // DesktopInformationReporterTest();
  });

  // Phone中合一框架的所有DT用例
  describe('sceneboard_framework', () => {
    SwitchIntentExecutorTest();
    MainAbilityTest();
    FileUtilTest();
    IntentBeanFactoryTest();
  });

  // 意图框架
  describe('voice-HiVoiceHAP', () => {
    ScbIntentExecutorImplTest();
  });

  describe('window_scene_board', () => {
    SCBFreeformSceneUtilsTest();
    FloatingSceneViewModelTest();
    CompanionIconForPCTest();
    FloatingSceneViewDataTest();
    LandscapeWindowControllerTest();
    LandscapeWindowStartupControllerTest();
    SCBStatusBarVMTest();
    SwipeInwardControllerTest();
    SwipeInwardBackModelTest();
    TouchBoardSwipeInwardGestureManagerTest();
    FlashlightTipsHelperTest();
    ThreeFingerSwipeEventTest();
    LandScapeWindowSettingAbilityTest();
    SCBRecentSessionsViewModelTest();
    ThreeFingerSwipeControllerPhoneTest();
    FlashlightTipsModelTest();
    TouchBoardGestureManagerTest();
    SCBSceneManagementOnPhoneTest();
    SCBRotateUtilsTest();
    MidSceneManagerForPadTest();
    MidSceneDraggingEventHandlerTest();
    CommonSCBScreenSuite();
    TripleAnimManagerUtilTest();
  });

  // 桌面编辑DT测试套
  describe("sceneboard_desktopedit",  () =>  {
    EditModeIconAbilityPhoneTest();
  });
}