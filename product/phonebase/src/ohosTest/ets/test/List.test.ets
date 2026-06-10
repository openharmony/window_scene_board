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

import CommonTestSuite from '@ohos/launchercommon/src/ohosTest/ets/test/List.test';
import ControlCenterTestSuite from '../../../../../../feature/controlcentercomponent/src/ohosTest/ets/test/List.test';
import HotSpotComponentTestSuite from '../../../../../../feature/systemstatus/hotspotcomponent/src/ohosTest/ets/test/List.test';
import AirplaneComponentTestSuite from '../../../../../../feature/systemstatus/airplanecomponent/src/ohosTest/ets/test/List.test';
import DarkModeComponentTestSuite from '../../../../../../feature/systemstatus/darkmodecomponent/src/ohosTest/ets/test/List.test';
import CameraComponentTestSuite from '../../../../../../feature/systemstatus/cameracomponent/src/ohosTest/ets/test/List.test';
import {
  PageDesktopDragHandlerTest,
} from '../../../../../../feature/desktop/pagedesktop/src/test/TestIndex';
import SmartdockTestSuite from '../../../../../../feature/smartdock/commonsmartdock/src/ohosTest/ets/test/List.test';
import DesktopEditTestSuite from '../../../../../../feature/desktop/desktopedit/src/ohosTest/ets/test/List.test';
import { DesktopEditPageViewModelTest } from 'sceneboard/src/ohosTest/ets/test/ets/desktopedit/viewmodel/DesktopEditPageViewModel.test';
import FormTestSuite from '../../../../../../feature/desktop/form/src/ohosTest/ets/test/List.test';
import FormStackTestSuite from '../../../../../../feature/desktop/formstack/src/ohosTest/ets/test/List.test';
import FreezingTipUtilTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/screenlock/common/FreezingTipUtilTest.test';
import RecentsTestSuite from '../../../../../../feature/recents/src/ohosTest/ets/test/List.test';
import { PadScreenLockShortcutLayoutConfigTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/screenlock/common/PadScreenLockShortcutLayoutConfig.test';
import WallpapercomponentTestSuite from '../../../../../../feature/wallpapercomponent/src/ohosTest/ets/test/List.test';
import RecentLayoutManagerTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/common/RecentLayoutManagerTest';
import RecentRotationUtilTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/common/RecentRotationUtilTest';
import LiveViewTestSuite from '../../../../../../feature/liveview/src/ohosTest/ets/test/List.test';
import GesturenavigationTestSuite from '../../../../../../feature/gesturenavigation/src/ohosTest/ets/test/List.test';
import GestureBackTestSuite from '../../../../../../feature/gestureback/src/ohosTest/ets/test/List.test';
import ScreenLockTestSuite from '@ohos/screenlockcomponent/src/ohosTest/ets/test/List.test';
import ChargingAnimationTestSuite from '@ohos/charginganimation/src/ohosTest/ets/test/List.test';
import ScreenLockWidgetTestSuite from '@ohos/screenlockwidget/src/ohosTest/ets/test/List.test';
import MultiRowRecentLayoutCalTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/common/MultiRowRecentLayoutCal.test';
import SingleRowRecentLayoutCalTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/common/SingleRowRecentLayoutCal.test';
import ContainerPreBuildMgrTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/common/ContainerPreBuildMgr.test';
import ContainerPreBuildRaiseScheduleAlarmTest from '../../../../../phone/src/ohosTest/ets/test/ets/SceneBoard/recent/common/ContainerPreBuildRaiseScheduleAlarm.test';
import RecentStateManagerTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/innerstate/RecentStateManager.test';
import AppFloatingTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/apppanel/AppFloating.test';
import RecentDeleteTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/recentpanel/RecentDelete.test';
import RecentClearAllTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/recentpanel/RecentClearAll.test';
import RecentLockIconModelTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/recentpanel/RecentLockIconModel.test'
import RecentMediaPlayTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/recentpanel/RecentMediaPlay.test'
import RecentGestureTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/recentpanel/RecentGesture.test';
import RecentNotShowTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/recentpanel/RecentNotShow.test';
import RecentPanelControllerTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/recentpanel/RecentPanelController.test';
import RecentScrollTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/recentpanel/RecentScroll.test';
import RecentScrollFlingTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/recentpanel/RecentScrollFling.test';
import RecentZoomAlarmTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/recentpanel/RecentZoomAlarm.test';
import RecentStartSceneTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/recentpanel/RecentStartScene.test';
import RecentExitTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/recentpanel/RecentExit.test'
import SCBScenePanelFSMTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/SCBScenePanelFSM.test';
import BatteryComponentTestSuite from '../../../../../../feature/systemstatus/batterycomponent/src/ohosTest/ets/test/List.test';
import VolumepanelComponentTestSuite from '../../../../../../feature/volume/volumepanelcomponent/src/ohosTest/ets/test/List.test';
import StatusBarComponentTestSuite from '../../../../../../feature/statusbarcomponent/src/ohosTest/ets/test/List.test';
import WifiComponentTestSuite from '../../../../../../feature/systemstatus/wificomponent/src/ohosTest/ets/test/List.test';
import HwCastTestSuite from '../../../../../../feature/systemcontrol/hcastcomponent/src/ohosTest/ets/test/List.test';
import SuperPrivacyTestSuite from '../../../../../../feature/systemcontrol/superprivacycomponent/src/ohosTest/ets/test/List.test';
import SignalComponentTestSuite from '../../../../../../feature/systemstatus/signalcomponent/src/ohosTest/ets/test/List.test';
import RingModeComponentTestSuite from '../../../../../../feature/systemstatus/ringmodecomponent/src/ohosTest/ets/test/List.test';
import PhonePageDesktopLayoutConfigTest from 'sceneboard/src/ohosTest/ets/test/ets/common/PhonePageDesktopLayoutConfig.test';
import PhoneFolderLayoutConfigTest from 'sceneboard/src/ohosTest/ets/test/ets/common/folder/PhoneFolderLayoutConfig.test';
import PowerSavingToggleSuite from '../../../../../../feature/systemcontrol/powersavingtogglecomponent/src/ohosTest/ets/test/List.test';

import DesktopBigFolderTestSuite from '../../../../../../feature/desktop/bigfolder/src/ohosTest/ets/test/List.test';
import DesktopSmallFolderTestSuite from '../../../../../../feature/desktop/smallfolder/src/ohosTest/ets/test/List.test';
import PageDesktopTestSuite from '../../../../../../feature/desktop/pagedesktop/src/ohosTest/ets/test/List.test';
import SwitchIntentExecutorTest from 'sceneboard/src/ohosTest/ets/test/ets/intents/SwitchIntentExecutorImplTest.test';
import ImmersiveKeyguardTestSuite from '../../../../../../feature/immersivekeyguard/src/ohosTest/ets/test/List.test'

import PhoneSmartDockLayoutConfigTest from 'sceneboard/src/ohosTest/ets/test/ets/common/PhoneSmartDockLayoutConfig.test';
import PhonePageDesktopGridStyleConfigTest from 'sceneboard/src/ohosTest/ets/test/ets/common/PhonePageDesktopGridStyleConfig.test';
import PhoneLauncherLayoutStyleConfigTest from 'sceneboard/src/ohosTest/ets/test/ets/common/PhoneLauncherLayoutStyleConfig.test';
import PhoneFormLayoutConfigTest from 'sceneboard/src/ohosTest/ets/test/ets/common/PhoneFormLayoutConfig.test';

import { IntelligentDataShareExtAbilityTest } from 'sceneboard/src/ohosTest/ets/test/ets/DataShareExtAbility/IntelligentDataShareExtAbility.test';
import InvokeAuthResultCallbackTest from 'sceneboard/src/ohosTest/ets/test/ets/service/exthome/executor/impl/InvokeAuthResultCallback.test';
import InvokeFaceTest from 'sceneboard/src/ohosTest/ets/test/ets/service/exthome/executor/impl/InvokeFace.test';
import ExtHomeServiceTest from 'sceneboard/src/ohosTest/ets/test/ets/service/exthome/ExtHomeService.test';

import SCBGestureBackViewModelTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/gesturenavigation/viewmodel/SCBGestureBackViewModel.test';
import DebugCommandsUtilsTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/gesturenavigation/utils/DebugCommandsUtils.test';
import GestureDockPullOutModelTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/gesturenavigation/model/GestureDockPullOutModel.test';
import TextCodecTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aiBar/util/TextCodec.test';
import GestureDockAdapterTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/gestureDock/common/adapter/GestureDockAdapter.test';
import GestureDockPreferenceMgrTest
  from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/gestureDock/common/preference/GestureDockPreferenceMgr.test';
import GestureDockEventIdUtilTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/gestureDock/common/util/GestureDockEventIdUtil.test';
import GestureDockUtilTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/gestureDock/common/util/GestureDockUtil.test';
import GestureDockParamTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/gestureDock/dock/viewmodel/viewdata/GestureDockParam.test';
import ScreenInfoUtilTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/gestureDock/common/util/ScreenInfoUtil.test';
import GestureDockViewDataMgrTest
  from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/gestureDock/dock/viewmodel/viewdata/GestureDockViewDataMgr.test';
import CallStateHandlerTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/gestureDock/dock/viewmodel/viewhandler/CallStateHandler.test';
import GestureDockViewEventMgrTest
  from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/gestureDock/dock/viewmodel/viewevent/GestureDockViewEventMgr.test';
import GestureDockAllAppsViewDataMgrTest
  from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/gestureDock/dockallapps/viewmodel/viewdata/GestureDockAllAppsViewDataMgr.test';
import GestureDockAllAppsViewEventMgrTest
  from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/gestureDock/dockallapps/viewmodel/viewevent/GestureDockAllAppsViewEventMgr.test';
import GestureDockBarViewDataMgrTest
  from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/gestureDock/dockbar/viewmodel/viewdata/GestureDockBarViewDataMgr.test';
import GestureDockBarViewModelTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/gestureDock/dockbar/viewmodel/GestureDockBarViewModel.test';
import GestureDockAllAppsItemViewDataMgrTest
  from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/gestureDock/dockappitem/viewdata/GestureDockAllAppsItemViewDataMgr.test';
import GestureDockAppItemViewDataMgrTest
  from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/gestureDock/dockappitem/viewdata/GestureDockAppItemViewDataMgr.test';
import GestureDockAllAppsItemViewEventMgrTest
  from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/gestureDock/dockappitem/viewevent/GestureDockAllAppsItemViewEventMgr.test';
import GestureDockAppItemViewEventMgrTest
  from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/gestureDock/dockappitem/viewevent/GestureDockAppItemViewEventMgr.test';
import GestureDockItemDragHandlerTest
  from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/gestureDock/dockbar/viewmodel/viewhandler/GestureDockItemDragHandler.test';
import GestureDockAppDataHandlerTest
  from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/gestureDock/dockbar/viewmodel/viewhandler/GestureDockAppDataHandler.test';
import GestureDockBarViewEventMgrTest
  from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/gestureDock/dockbar/viewmodel/viewevent/GestureDockBarViewEventMgr.test';
import GestureDockBarParamTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/gestureDock/dockbar/viewmodel/viewdata/GestureDockBarParam.test';
import GestureDockBarViewAnimateTest
  from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/gestureDock/dockbar/viewmodel/viewanimate/GestureDockBarViewAnimate.test';
import AllAppsItemViewEventTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/gestureDock/dockappitem/AllAppsItemViewEvent.test';
import AllAppsStyleConfigMgrTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/gestureDock/dockallapps/model/AllAppsStyleConfigMgr.test';
import GestureDockAllAppsViewModelTest
  from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/gestureDock/dockallapps/viewmodel/GestureDockAllAppsViewModel.test';
import GestureDockViewModelTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/gestureDock/dock/viewmodel/GestureDockViewModel.test';
import AllAppsDataSourceTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/gestureDock/dockallapps/model/AllAppsDataSource.test';
import FloatingNavigationManagerTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aiBar/proxy/FloatingNavigationManager.test';

import FormClearUtilsTest from 'sceneboard/src/ohosTest/ets/test/ets/common/FormClearUtils.test';
import BundleVerifyUtilsTest  from 'sceneboard/src/ohosTest/ets/test/ets/service/exthome/BundleVerifyUtils.test';
import SceneInfoTest from 'sceneboard/src/ohosTest/ets/test/ets/backup/SceneInfo.test';
import TransLayoutMethodImplTest from 'sceneboard/src/ohosTest/ets/test/ets/backup/impl/TransLayoutMethodImpl.test';
import NotificationFileBackupMethodImplTest from 'sceneboard/src/ohosTest/ets/test/ets/backup/impl/NotificationFileBackupMethodImpl.test';
import FilePreprocessMethodImplTest from 'sceneboard/src/ohosTest/ets/test/ets/backup/impl/FilePreprocessMethodImpl.test';
import BackupNotificationControllerTest from 'sceneboard/src/ohosTest/ets/test/ets/backup/BackupNotificationController.test';
import BackupLauncherUtilTest from 'sceneboard/src/ohosTest/ets/test/ets/backup/BackupLauncherUtil.test';
import BackupLauncherControllerTest from 'sceneboard/src/ohosTest/ets/test/ets/backup/BackupLauncherController.test';
import BackupExtensionTest from 'sceneboard/src/ohosTest/ets/test/ets/backup/BackupExtension.test';
import BackupEventManagerTest from 'sceneboard/src/ohosTest/ets/test/ets/backup/BackupEventManager.test';
import GestureHelperTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/common/GestureHelper.test';
import MainAbilityTest from 'sceneboard/src/ohosTest/ets/test/ets/MainAbility/MainAbility.test'
import HomeIdleTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/homepanel/HomeIdle.test';
import EmergencyHomeIdleTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/homepanel/EmergencyHomeIdle.test';
import HomePanelControllerTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/homepanel/HomePanelController.test';
import OverViewFollowingFromHomeTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/homepanel/OverViewFollowingFromHome.test';
import AppIdleTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/apppanel/AppIdle.test';
import QuickSwitchFollowingFromHomeTest
  from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/homepanel/QuickSwitchFollowingFromHome.test';
import SplitIdleTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/splitpanel/SplitIdle.test';
import QuickSwitchIdleTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/quickswitchpanel/QuickSwitchIdle.test';
import QuickSwitchRaiseTopAlarmTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/quickswitchpanel/QuickSwitchRaiseTopAlarm.test';
import RecentIdleTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/recentpanel/RecentIdle.test';
import RecentScrollHelperTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/recentpanel/RecentScrollHelper.test';
import QuickSwitchFollowingFromAppTest
  from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/apppanel/QuickSwitchFollowingFromApp.test';
import FarAwayFollowingFromAppTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/apppanel/FarAwayFollowingFromApp.test';
import RecentFollowingFromAppTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/apppanel/RecentFollowingFromApp.test';
import ZoomFollowingFromAppTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/apppanel/ZoomFollowingFromApp.test';
import ZoomFollowingAnimationsTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/apppanel/ZoomFollowingAnimations.test';
import { AodThemeParamDirectorTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/personalization/builder/AodThemeParamDirector.test';
import RecentTitleViewModelTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/RecentTitleViewModel.test';
import { AodStyleGroupBuilderTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/personalization/builder/AodStyleGroupBuilder.test';
import { AodThemeParamBuilderTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/personalization/builder/AodThemeParamBuilder.test';
import { AodIntentBackgroundUiAbilityTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/intents/AodIntentBackgroundUiAbility.test';
import { AodIntentExecutorImplTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/intents/AodIntentExecutorImpl.test';
import { AodStyleDataManagerTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/personalization/manager/AodStyleDataManager.test';
import { AodStyleImageManagerTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/personalization/manager/AodStyleImageManager.test';
import { ConstantTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/personalization/constant/Constant.test';
import { StorageKeyTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/personalization/constant/StorageKey.test';
import { AodMainPageControllerTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/personalization/controller/MainPageController.test';
import { PageControllerTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/personalization/controller/PageController.test';
import { PreviewPageControllerTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/personalization/controller/PreviewPageController.test';
import { AodRotationAdapterTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/adapter/AodRotationAdapter.test';
import { CompanionIconForPCTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/pcmode/CompanionIconForPC.test';
import { SCBMultiWindowReporterTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/MultiWindowReporter.test';
import {
  SystemUiCommonTestSuite
} from '../../../../../../staticcommon/systemuicommon/src/ohosTest/ets/test/List.test';
import {
  ScreenLockCommonTestSuite
} from '../../../../../../staticcommon/screenlockcommon/src/ohosTest/ets/test/List.test';
import { Rotation90StrategyTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/adapter/rotation/Rotation90Strategy.test';
import { Rotation180StrategyTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/adapter/rotation/Rotation180Strategy.test';
import { AodStyleListModelTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/personalization/model/AodStyleListModel.test';
import { AodStyleGroupListModelTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/personalization/model/AodStyleGroupListModel.test';
import {
  AodViewControllerDigitalClockFolderTest
} from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/factory/viewcontroller/AodViewControllerDigitalClockFolder.test';
import {
  AodViewControllerAnalogClockFolderTest
} from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/factory/viewcontroller/AodViewControllerAnalogClockFolder.test';
import {
  AodViewControllerInteractiveFolderTest
} from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/factory/viewcontroller/AodViewControllerInteractiveFolder.test';
import {
  AodViewControllerStereoForeImageFolderTest
} from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/factory/viewcontroller/AodViewControllerStereoForeImageFolder.test';
import {
  AodViewControllerStereoNumberClockFolderTest
} from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/factory/viewcontroller/AodViewControllerStereoNumberClockFolder.test';
import { SCBBlockCoverTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/SCBBlockCoverTest.test';
import { Rotation270StrategyTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/adapter/rotation/Rotation270Strategy.test';
import { AodRotationTemplateTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/adapter/AodRotationTemplate.test';
import { AodDisplayHelperTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/personalization/utils/AodDisplayHelper.test';
import { EditPanelSizeUtilTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/personalization/utils/EditPanelSizeUtil.test';
import { MainPanelUtilTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/personalization/utils/MainPanelUtil.test';
import { GridUtilTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/personalization/utils/GridUtil.test';
import { AodThemeUtilTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/personalization/utils/AodThemeUtil.test';
import { AodThemeAbstractFactoryTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/factory/AodThemeAbstractFactory.test';
import {
  ThumbnailSizeUtilTest
} from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/personalization/utils/ThumbnailSizeUtil.test';
import {
  RecoverThemeAppTest
} from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/personalization/utils/RecoverThemeApp.test';
import {
  ThemeServiceConnectorTest
} from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/personalization/service/ThemeServiceConnector.test';
import {
  AodViewCtlStereoNumberClockPadTest
} from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/factory/viewcontroller/AodViewCtlStereoNumberClockPad.test';
import {
  AodViewCtlStereoForeImagePadTest
} from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/factory/viewcontroller/AodViewCtlStereoForeImagePad.test';
import {
  AodViewCtlInteractivePadTest
} from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/factory/viewcontroller/AodViewCtlInteractivePad.test';
import {
  AodViewCtlAnalogClockPadTest
} from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/factory/viewcontroller/AodViewCtlAnalogClockPad.test';
import {
  AodRotationAdapterPadTest
} from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/adapter/AodRotationAdapterPad.test';
import {
  AodWindowManagerTest,
  AodWindowTest
} from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/personalization/manager/AodWindowManager.test';
import {
  AodDisplayManagerTest
} from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/personalization/manager/AodDisplayManager.test';
import {
  AodViewCtlDigitalClockPadTest
} from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/factory/viewcontroller/AodViewCtlDigitalClockPad.test';
import InvokeUnlockTest from 'sceneboard/src/ohosTest/ets/test/ets/service/exthome/executor/impl/invokeUnlock.test';
import RestoringPhoneDesktopLayoutTest from 'sceneboard/src/ohosTest/ets/test/ets/backup/impl/RestoringPhoneDesktopLayout.test';
import TransferDesktopSettingMethodImplTest
  from 'sceneboard/src/ohosTest/ets/test/ets/backup/impl/TransferDesktopSettingMethodImpl.test';
import OuterHomeManagerTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/screenlock/common/OuterHomeManagerTest.test';
import ScbIntentExecutorImplTest from 'sceneboard/src/ohosTest/ets/test/ets/intents/ScbIntentExecutorImplTest.test';
import OuterHomeRemoteServiceTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/screenlock/idlService/OuterHomeRemoteService.test';
import SCBRecentSessionsViewModelTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/pcmode/SCBRecentSessionsViewModel.test';
import IdlOuterHomeServiceProxyTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/screenlock/idlService/IdlOuterHomeServiceProxy.test';
import NearLinkToggleSuite from '../../../../../../feature/systemcontrol/nearlinktogglecomponent/src/ohosTest/ets/test/List.test';
import EmergencyTestSuite from '../../../../../../feature/desktop/emergencymode/src/ohosTest/ets/test/List.test';
import RecentDeleteFollowingTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/recentpanel/RecentDeleteFollowing.test';
import RecentAccessibilityUtilsTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/recentpanel/RecentAccessibilityUtils.test';
import RecentEventViewModelTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/recentpanel/RecentEventViewModel.test';
import RecentEnterAnimationsTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/recentpanel/RecentEnterAnimations.test';
import RecentRuntimeModelTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/recentpanel/RecentRuntimeModel.test';
import QuickSwitchAnimationsTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/quickswitchpanel/QuickSwitchAnimations.test';
import { SCBFloatManagerTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/SCBFloatManagerTest.test';
import { SCBMultiWindowManagerTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/SCBMultiWindowManagerTest.test';
import {
  SCBMultiWindowDumpsterManagerTest
} from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/SCBMultiWindowDumpsterManagerTest.test';
import SCBMultiWindowUtilsTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/SCBMultiWindowUtilsTest.test';
import { SCBOneStepViewModelTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/SCBOneStepViewModel.test';
import { PiPUtilsTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/PiPUtilsTest.test';
import { SCBPiPManagerTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/SCBPiPManager.test';
import { SCBSplitManagerTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/SCBSplitManagerTest.test';
import {
  SplitViewAnimationManagerTest
} from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/SplitViewAnimationManagerTest.test';
import MultiWindowSettingAbilityTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/MultiWindowSettingAbility.test';
import PiPSwitchControllerTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/PiPSwitchController.test';
import MultiDockSwitchControllerTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/MultiDockSwitchController.test';
import { SCBSceneTitleBarTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/SCBSceneTitleBar.test';
import { SCBAppIconTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/SCBAppIconTest.test';
import { SCBSideEdgeBarManagerTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/SCBSideEdgeBarManager.test';
import { SCBFloatMiniCoverTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/SCBFloatMiniCover.test';
import { SCBGestureRecordTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/SCBGestureRecord.test';
import GuidanceDialogManagerTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/GuidanceDialogManager.test';
import { SCBGridRowUtilsTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/SCBGridRowUtils.test';
import { SCBMenuParamTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/SCBMenuParam.test';
import SCBSnapScreenShotColorTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/SCBSnapScreenShotColorTest.test';
import { GuideTipsManagerTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/GuideTipsManager.test';
import { GuideTipSceneSessionTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/GuideTipSceneSession.test';
import { SCBFloatDragScaleTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/SCBFloatDragScaleTest.test';
import { SCBFloatGestureProcessorTest} from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/SCBFloatGestureProcessor.test'
import { FloatCalculatorTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/FloatCalculatorTest.test';
import LandscapeWindowControllerTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/landScapeWindow/controllers/LandscapeWindowController.test';
import { LandscapeWindowStartupControllerTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/landScapeWindow/controllers/LandscapeWindowStartupController.test';

import OuterPhonePageDesktopLayoutConfigTest from 'sceneboard/src/ohosTest/ets/test/ets/common/OuterPhonePageDesktopLayoutConfig.test';
import { SlBindStateTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/screenlock/model/data/SlBindState.test';
import { SlStaticStateTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/screenlock/model/data/SlStaticState.test';
import { SlStateHelperTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/screenlock/model/helper/SlStateHelper.test';
import {
  ScreenLockInitializeServiceTest
} from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/screenlock/model/service/ScreenLockInitializeServiceTest.test';
import { SlCommonStateManagerTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/screenlock/model/manager/SlCommonStateManagerTest.test';
import { ScreenLockVmTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/screenlock/viewmodel/ScreenLockVmTest.test';
import { ScreenLockEditVmTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/screenlock/viewmodel/ScreenLockEditVmTest.test';
import { OuterHomeManagerUtilTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/screenlock/utils/OuterHomeManagerUtil.test';
import TripleAnimManagerUtilTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/screenlock/utils/TripleAnimManagerUtilTest.test';
import { SCBFreeformSceneUtilsTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/pcmode/SCBFreeformSceneUtilsTest.test';
import FloatingSceneViewModelTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/pcmode/FloatingSceneViewModel.test'
import { FloatingSceneViewDataTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/pcmode/FloatingSceneViewDataTest.test';
import { SCBDividerParamTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/SCBDividerParam.test';
import { SCBFloatingParamTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/SCBFloatingParam.test';
import multiWindowTaskTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/SCBMultiWindowTask.test';
import floatBackgroundParamTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/SCBFloatBackground.test';
import { AnimationParamTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/AnimationParamTest.test';
import SCBGestureNavBarViewModelTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/gesturenavigation/SCBGestureNavBarViewModel.test';
import GlobalSearchLocationServiceTest from 'sceneboard/src/ohosTest/ets/test/ets/service/GlobalSearchLocationService.test';
import RecentDeviceServiceTest from 'sceneboard/src/ohosTest/ets/test/ets/service/RecentDeviceService.test';
import CancelRestoreLauncherDataTest from 'sceneboard/src/ohosTest/ets/test/ets/service/impl/CancelRestoreLauncherData.test';
import QueryDesktopAppTest from 'sceneboard/src/ohosTest/ets/test/ets/service/impl/QueryDesktopApp.test';
import { SCBDividerHelperTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/SCBDividerHelper.test';
import { SCBSplitParamTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/SCBSplitParam.test';
import { SCBStatusBarVMTest, SCBStatusBarVMTest1 } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/statusbar/viewmodel/SCBStatusBarVM.test';
import { SCBInputMethodHelperTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/SCBInputMethodHelperTest.test';
import { MidSceneManagerTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/midscene/MidSceneManagerTest.test';
import { MidSceneFSMTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/midscene/MidSceneFSMTest.test';
import MidSceneRecentHelperTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/midscene/MidSceneRecentHelper.test';
import { FilledStateTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/midscene/FilledStateTest.test';
import { NonMidStateTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/midscene/NonMidStateTest.test';
import { UnfilledStateTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/midscene/UnfilledStateTest.test';
import { SCBDockSplitHelperTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/SCBDockSplitHelperTest.test';
import { SCBSceneSessionManagerTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/SCBSceneSessionManagerTest.test';
import { WaitingAddStateTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/midscene/WaitingAddStateTest.test';
import {
  WaitingReplaceStateTest
} from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/midscene/WaitingReplaceStateTest.test';
import {
  NotificationComponentTest
} from '../../../../../../feature/notification/notificationcomponent/src/ohosTest/ets/test/List.test';
import { paramHelperTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/ParamHelper.test';
import { SoundComponentTestSuite } from '../../../../../../feature/systemcontrol/soundcomponent/src/test/List.test';
import { multiWindowRssHelperTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/MultiWindowRssHelper.test';
import { MidSceneUtilsTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/midscene/MidSceneUtilsTest.test';
import PcModeTestSuite from '../../../../../../feature/pcmode/src/ohosTest/ets/test/List.test';
import AIBarViewModelTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aiBar/AIBarModel/AIBarViewModel.test';
import AccessibilityUtilsTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aiBar/util/AccessibilityUtils.test';
import SwipeInwardControllerTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/touchboardgesture/SwipeInwardEvent.test';
import TouchBoardSwipeInwardGestureManagerTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/touchboardgesture/SwipeInwardGestureManager.test';
import FoldEffectTestSuite from '../../../../../../feature/foldeffect/src/ohosTest/ets/test/List.test';
import { StatusBarStatusTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/statusbar/viewmodel/StatusBarStatus.test';
import { MidSceneGestureTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/midscene/MidSceneGestureTest.test';
import RecentForegroundBlurAniMgrTest
  from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/recent/scenepanel/recentpanel/RecentForegroundBlurAniMgr.test';
import PrivacyIndicatorTestSuite from '../../../../../../feature/privacyindicator/src/ohosTest/ets/test/List.test';
import { FlashlightTipsHelperTest } from '../../../test/SceneBoard/flashlight/FlashlightTipsHelper.test';
import { ThreeFingerSwipeEventTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/touchboardgesture/ThreeFingerSwipeEventTest.test';
import {
  LandScapeWindowSettingAbilityTest
} from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/landScapeWindow/controllers/LandScapeWindowSettingAbilityTest.test';
import {
  ThreeFingerSwipeControllerPhoneTest
} from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/touchboardgesture/ThreeFingerSwipeControllerPhoneTest.test';
import { FlashlightTipsModelTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/screenlock/viewmodel/FlashlightTipsModelTest.test';
import { TouchBoardGestureManagerTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/touchboardgesture/TouchBoardGestureManagerTest.test';
import { EditModeIconAbilityPhoneTest } from 'sceneboard/src/ohosTest/ets/test/ets/desktopedit/ability/EditModeIconAbilityPhone.test';
import AIBarAnimateTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aiBar/AIBarModel/AIBarAnimate.test';
import AIBarClickBackgroundDataTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aiBar/AIBarModel/AIBarClickBackgroundData.test'
import AIBarDataTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aiBar/AIBarModel/AIBarData.test';
import AIBarViewDataTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aiBar/AIBarModel/AlBarViewData.test';
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
import PadBackGestureModelTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/gesturenavigation/model/PadBackGestureModel.test';
import PadBackEventViewModelTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/gesturenavigation/viewmodel/PadBackEventViewModel.test';
import SwipeInwardBackModelTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/touchboardgesture/SwipeInwardBackModel.test';
import AodPreviewImageManagerTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/personalization/manager/AodPreviewImageManager.test';
import ThermalPadStyleConfigTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/emergency/styleConfig/ThermalPadStyleConfig.test'
import EmergencyFoldStyleConfigTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/emergency/styleConfig/EmergencyFoldStyleConfig.test';
import StyleConfigFactoryTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/emergency/StyleConfigFactory.test';
import FoldPhoneLayoutRulesControllerTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/controllers/SceneDesktopController/FoldPhoneLayoutRulesController.test';
import SimplePhoneLayoutRulesControllerTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/controllers/SceneDesktopController/SimplePhoneLayoutRulesController.test';
import MidSceneManagerForPadTest
  from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/midsceneforpad/MidSceneManagerForPadTest.test';
import AodCommonTestSuite from '../../../../../../staticcommon/aodcommon/src/ohosTest/ets/test/List.test';
import ThermalPhoneStyleConfigTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/emergency/styleConfig/ThermalPhoneStyleConfig.test';
import IntentBeanFactoryTest from 'sceneboard/src/ohosTest/ets/test/ets/intents/utils/IntentBeanFactory.test';
import FileUtilTest from 'sceneboard/src/ohosTest/ets/test/ets/intents/utils/FileUtil.test';
// import DesktopInformationReporterTest from './ets/SceneBoard/desktopReporter/DesktopInformationReporter.test';
import GestureDockMethodImplTest from 'sceneboard/src/ohosTest/ets/test/ets/backup/impl/GestureDockMethodImpl.test';
import SCBSceneManagementOnPhoneTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/SCBSceneManagementOnPhoneTest.test';
import ThreeButtonUpgradeDSExtAbilityTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aiBar/ability/ThreeButtonUpgradeDSExtAbility.test';
import ThreeButtonUpgradeUIExtAbilityTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aiBar/ability/ThreeButtonUpgradeUIExtAbility.test';
import ThreeButtonUpgradeViewModelTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aiBar/AIBarModel/ThreeButtonUpgradeViewModel.test';
import { AodRotationAdapterUltraScreenTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/adapter/AodRotationAdapterUltraScreen.test';
import SCBRotateUtilsTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/utils/SCBRotateUtilsTest.test';
import MidSceneDraggingEventHandlerTest
  from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/midsceneforpad/MidSceneDraggingEventHandlerTest.test';
import SCBSingleHandControllerTest from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/onehandmode/SCBSingleHandController.test';
import BasicUtilsTestSuite from '@ohos/basicutils/src/ohosTest/ets/test/List.test';
import ComponentAnimatorTestSuite from '@ohos/componentanimator/src/ohosTest/ets/test/List.test';
import ComponentDragTestSuite from
  '../../../../../../staticcommon/basecommon/componentdrag/src/ohosTest/ets/test/List.test';
import ComponentHelperTestSuite from '@ohos/componenthelper/src/ohosTest/ets/test/List.test';
import FrameworkCommonTestSuite from '@ohos/frameworkcommon/src/ohosTest/ets/test/List.test';
import FrameworkPinyinTestSuite from '@ohos/frameworkpinyin/src/ohosTest/ets/test/List.test';
import FrameworkWrapperTestSuite from '@ohos/frameworkwrapper/src/ohosTest/ets/test/List.test';
import SwiperDataTestSuite from '../../../../../../staticcommon/basecommon/swiperdata/src/ohosTest/ets/test/List.test';
import WindowSceneSuite from '@ohos/windowscene/src/ohosTest/ets/test/List.test';
import { GreetViewVcTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/screenlock/subviewcontroller/GreetViewVc.test';
import { PipOneShotAnimHelperTest } from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/PipOneShotAnimHelper.test';
import { CommonSCBScreenSuite } from '../../../../../../feature/commonscbscreen/src/ohosTest/ets/test/List.test'
import {
  AodViewControllerOuterDigitalClockTest
} from 'sceneboard/src/ohosTest/ets/test/ets/SceneBoard/aod/factory/viewcontroller/AodViewControllerOuterDigitalClock.test';
import { PreInstallUtilsTest } from '@ohos/launchercommon/src/ohosTest/ets/test/ets/launchercommon/utils/PreInstallUtils.test';
import { AppInstallUtilsTest } from '@ohos/launchercommon/src/ohosTest/ets/test/ets/launchercommon/appinstall/AppInstallUtils.test';

export default function testsuite() {
  BasicUtilsTestSuite();
  ComponentAnimatorTestSuite();
  ComponentDragTestSuite();
  ComponentHelperTestSuite();
  FrameworkCommonTestSuite();
  FrameworkPinyinTestSuite();
  FrameworkWrapperTestSuite();
  SwiperDataTestSuite();
  WindowSceneSuite();
  AodCommonTestSuite();
  AodTestSuite();
  CommonTestSuite();
  PhoneFrameworkSuite();
  IntentFrameworkSuite();
  SCBRecentSessionsViewModelTest();
  FoldEffectTestSuite();
  PageDesktopDragHandlerTest();
  DesktopEditTestSuite();
  DesktopEditPageViewModelTest();
  EditModeIconAbilityPhoneTest();
  FormTestSuite();
  FormStackTestSuite();
  FreezingTipUtilTest();
  RecentsTestSuite();
  MultiWindowTestSuite();
  LandscapeWindowTestSuite();
  FreeformSceneTestSuite();
  HwCastTestSuite();
  SuperPrivacyTestSuite();
  ControlCenterTestSuite();
  AirplaneComponentTestSuite();
  HotSpotComponentTestSuite();
  DarkModeComponentTestSuite();
  PowerSavingToggleSuite();
  WirelessReverseToggleSuite();
  NearLinkToggleSuite();
  CameraComponentTestSuite();
  PadScreenLockShortcutLayoutConfigTest();
  WallpapercomponentTestSuite();
  PhoneAodSuite();
  GesturenavigationTestSuite();
  GestureBackTestSuite();
  LauncherNavigationTestSuite();
  ScreenLockTestSuite();
  ChargingAnimationTestSuite();
  ScreenLockWidgetTestSuite();
  CoverTestSuite();
  PhoneSystemUISuite();
  PhoneMultitasksSuite();
  RingModeComponentTestSuite();
  DesktopBigFolderTestSuite();
  DesktopSmallFolderTestSuite();
  PageDesktopTestSuite();
  LauncherCommonTestSuite();
  FolderTestSuite();
  ExtHomeSuite();
  SmartdockTestSuite();
  IntelligentDataShareExtAbilityTest();
  SoundComponentTestSuite();
  ImmersiveKeyguardTestSuite();
  SystemUiCommonTestSuite();
  ScreenLockCommonTestSuite();
  SlBindStateTest();
  SlStaticStateTest();
  SlStateHelperTest();
  GreetViewVcTest();
  ScreenLockInitializeServiceTest();
  SlCommonStateManagerTest();
  ScreenLockVmTest();
  StatusBarTestSuite();
  NotificationComponentTest();
  // 添加feature下pcmode的引用
  PcModeTestSuite();
  SwipeInwardControllerTest();
  SwipeInwardBackModelTest();
  TouchBoardSwipeInwardGestureManagerTest();
  ThreeFingerSwipeEventTest();
  PrivacyIndicatorTestSuite();
  FlashlightTipsHelperTest();
  ThreeFingerSwipeControllerPhoneTest();
  FlashlightTipsModelTest();
  TouchBoardGestureManagerTest();
  EmergencyFoldStyleConfigTest();
  StyleConfigFactoryTest();
  FoldPhoneLayoutRulesControllerTest();
  SimplePhoneLayoutRulesControllerTest();
  ThermalPadStyleConfigTest();
  ThermalPhoneStyleConfigTest();
  // DesktopInformationReporterTest();
  GestureDockMethodImplTest();
  SCBSceneManagementOnPhoneTest();
  SCBRotateUtilsTest();
  SCBSingleHandControllerTest();
  MidSceneManagerForPadTest();
  MidSceneDraggingEventHandlerTest();
  ScreenLockEditVmTest();
  CommonSCBScreenSuite();
  TripleAnimManagerUtilTest();
}

export function MultiWindowTestSuite() {
  SCBInputMethodHelperTest();
  SCBDividerHelperTest();
  SCBSplitParamTest();
  SCBSideEdgeBarManagerTest();
  SCBFloatManagerTest();
  SCBMultiWindowManagerTest();
  SCBMultiWindowDumpsterManagerTest();
  SCBBlockCoverTest();
  SCBMultiWindowUtilsTest();
  SCBOneStepViewModelTest();
  PiPUtilsTest();
  SCBPiPManagerTest();
  PipOneShotAnimHelperTest();
  SCBSplitManagerTest();
  SplitViewAnimationManagerTest();
  MultiWindowSettingAbilityTest();
  PiPSwitchControllerTest();
  MultiDockSwitchControllerTest();
  SCBSceneTitleBarTest();
  SCBAppIconTest();
  SCBMultiWindowReporterTest();
  SCBSnapScreenShotColorTest();
  SCBGestureRecordTest();
  SCBGridRowUtilsTest();
  SCBMenuParamTest();
  SCBFloatDragScaleTest();
  SCBFloatMiniCoverTest();
  GuidanceDialogManagerTest();
  GuideTipsManagerTest();
  FloatCalculatorTest();
  GuideTipSceneSessionTest();
  SCBFloatGestureProcessorTest();
  SCBDividerParamTest();
  SCBFloatingParamTest();
  multiWindowTaskTest();
  AnimationParamTest();
  floatBackgroundParamTest();
  MidSceneManagerTest();
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
  MidSceneGestureTest();
}

// 自由多窗测试套
export function FreeformSceneTestSuite() {
  SCBFreeformSceneUtilsTest();
  FloatingSceneViewModelTest();
  CompanionIconForPCTest();
  FloatingSceneViewDataTest();
}

export function PhoneAodSuite() {
  AodRotationAdapterFactoryTest();
  SmallWindowUtilTest();
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
  AodRotationAdapterUltraScreenTest();
  AodViewControllerOuterDigitalClockTest();
}

// Phone中多任务模块的所有DT用例
export function PhoneMultitasksSuite() {
  MultiRowRecentLayoutCalTest();
  RecentLayoutManagerTest();
  RecentRotationUtilTest();
  SingleRowRecentLayoutCalTest();
  ContainerPreBuildMgrTest();
  RecentStateManagerTest();
  AppFloatingTest();
   RecentDeleteTest();
  RecentClearAllTest();
  RecentLockIconModelTest();
  RecentMediaPlayTest();
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
  RecentTitleViewModelTest();
  QuickSwitchFollowingFromAppTest();
  FarAwayFollowingFromAppTest();
  RecentFollowingFromAppTest();
  ZoomFollowingFromAppTest();
  RecentZoomAlarmTest();
  RecentExitTest();
  RecentRuntimeModelTest();
  RecentAccessibilityUtilsTest();
  RecentEventViewModelTest();
  ContainerPreBuildRaiseScheduleAlarmTest();
  RecentScrollHelperTest();
  RecentForegroundBlurAniMgrTest();
  RecentStartSceneTest();
  RecentGestureTest();
  EmergencyHomeIdleTest();
  QuickSwitchRaiseTopAlarmTest();
  ZoomFollowingAnimationsTest();
  RecentScrollFlingTest();
}

// Phone中桌面导航模块的所有DT用例
export function LauncherNavigationTestSuite() {
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
  AIBarViewModelTest();
  TextCodecTest();
  AccessibilityUtilsTest();
  AIBarViewDataTest();
  ThreeButtonUpgradeDSExtAbilityTest();
  ThreeButtonUpgradeUIExtAbilityTest();
  ThreeButtonUpgradeViewModelTest();
  FloatingNavigationManagerTest();
}

export function PhoneSystemUISuite() {
  LiveViewTestSuite();
  VolumepanelComponentTestSuite();
  BatteryComponentTestSuite();
  StatusBarComponentTestSuite();
  WifiComponentTestSuite();
  HuaweiShareComponentTestSuite();
  SignalComponentTestSuite();
}

export function LauncherCommonTestSuite() {
  PhonePageDesktopLayoutConfigTest();
  BackupEventManagerTest();
  BackupExtensionTest();
  BackupLauncherControllerTest();
  BackupLauncherUtilTest();
  BackupNotificationControllerTest();
  FilePreprocessMethodImplTest();
  TransferDesktopSettingMethodImplTest();
  NotificationFileBackupMethodImplTest();
  TransLayoutMethodImplTest();
  RestoringPhoneDesktopLayoutTest();
  SceneInfoTest();
  FormClearUtilsTest();
  PhoneFormLayoutConfigTest();
  PhoneLauncherLayoutStyleConfigTest();
  PhonePageDesktopGridStyleConfigTest();
  PhoneSmartDockLayoutConfigTest();
  EmergencyTestSuite();
  OuterPhonePageDesktopLayoutConfigTest();
  GlobalSearchLocationServiceTest();
  RecentDeviceServiceTest();
  CancelRestoreLauncherDataTest();
  QueryDesktopAppTest();
  PreInstallUtilsTest();
  AppInstallUtilsTest();
}

export function ExtHomeSuite() {
  InvokeAuthResultCallbackTest();
  InvokeFaceTest();
  InvokeUnlockTest();
  ExtHomeServiceTest();
  BundleVerifyUtilsTest();
  OuterHomeManagerTest();
  OuterHomeRemoteServiceTest();
  IdlOuterHomeServiceProxyTest();
}

export function FolderTestSuite() {
  PhoneFolderLayoutConfigTest();
}

export function PhoneFrameworkSuite() {
  SwitchIntentExecutorTest();
  MainAbilityTest();
}

export function IntentFrameworkSuite() {
  ScbIntentExecutorImplTest();
  FileUtilTest();
  IntentBeanFactoryTest();
}

export function LandscapeWindowTestSuite() {
  LandscapeWindowControllerTest();
  LandscapeWindowStartupControllerTest();
  LandScapeWindowSettingAbilityTest();
}

// 状态栏
export function StatusBarTestSuite() {
  SCBStatusBarVMTest();
  SCBStatusBarVMTest1();
  StatusBarStatusTest();
}