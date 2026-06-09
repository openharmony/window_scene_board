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

import FolderOpenSwipingStateTest from './ets/launchercommon/folder/state/FolderOpenSwipingState.test'
import SmallFolderCacheManagerTest from './ets/launchercommon/folder/SmallFolderCacheManager.test';
import SmartDockSuggestAppConfigTest from './ets/launchercommon/layoutconfig/SmartDockSuggestAppConfig.test';
import SmartDockStyleConfigTest_1 from './ets/launchercommon/layoutconfig/SmartDockStyleConfig.test';
import SmartDockModeConfigTest from './ets/launchercommon/layoutconfig/SmartDockModeConfig.test';
import SmartDockLayoutConfigTest from './ets/launchercommon/layoutconfig/SmartDockLayoutConfig.test';
import PageDesktopModeConfigTest from './ets/launchercommon/layoutconfig/PageDesktopModeConfig.test';
import PageDesktopLayoutConfigTest from './ets/launchercommon/layoutconfig/PageDesktopLayoutConfig.test';
import PageDesktopAppModeConfigTest from './ets/launchercommon/layoutconfig/PageDesktopAppModeConfig.test';
import LayoutConfigManagerTest from './ets/launchercommon/layoutconfig/LayoutConfigManager.test';
import LauncherLayoutStyleConfigTest from './ets/launchercommon/layoutconfig/LauncherLayoutStyleConfig.test';
import GetLayoutInfoFromConfigTest from './ets/launchercommon/layoutconfig/GetLayoutInfoFromConfig.test';
import GetHideAppsFromConfigTest from './ets/launchercommon/layoutconfig/GetHideAppsFromConfig.test';
import SystemParameterUtilTest from './ets/launchercommon/utils/SystemParameterUtil.test';
import FormLayoutConfigTest from './ets/launchercommon/layoutconfig/FormLayoutConfig.test';
import AppListStyleConfigTest from './ets/launchercommon/layoutconfig/AppListStyleConfig.test';
import AppGridStyleConfigTest from './ets/launchercommon/layoutconfig/AppGridStyleConfig.test';
import RdbTaskPoolTest from './ets/launchercommon/db/RdbTaskPool.test';
import DuplicateItemCorrectorTest from './ets/launchercommon/db/gridlayoutcorrector/DuplicateItemCorrector.test';
import DuplicatePositionCorrectorTest from './ets/launchercommon/db/gridlayoutcorrector/DuplicatePositionCorrector.test';
import FieldNotNullCorrectorTest from './ets/launchercommon/db/gridlayoutcorrector/FieldNotNullCorrector.test';
import GridLayoutCorrectorChainTest from './ets/launchercommon/db/gridlayoutcorrector/GridLayoutCorrectorChain.test';
import DiskLruCacheTest from './ets/launchercommon/cache/DiskLruCache.test';
import DockLayoutCacheManagerTest from './ets/launchercommon/cache/layout/DockLayoutCacheManager.test';
import LruCacheTest from './ets/launchercommon/cache/LruCache.test';
import TransferRelationModelTest from './ets/launchercommon/model/TransferRelationModel.test';
import SettingsModelTest from './ets/launchercommon/model/SettingsModel.test';
import RecentMissionsModelTest from './ets/launchercommon/model/RecentMissionsModel.test';
import PageDesktopModelTest from './ets/launchercommon/model/PageDesktopModel.test';
import FormModelTest from './ets/launchercommon/model/FormModel.test';
import CustomBadgeManagerTest from './ets/launchercommon/model/CustomBadgeManager.test';
import AtomicServiceAppModelTest from './ets/launchercommon/model/AtomicServiceAppModel.test';
import ColorUtilTest from './ets/launchercommon/utils/ColorUtil.test';
import ConfigParseUtilTest from './ets/launchercommon/utils/ConfigParseUtil.test';
import DesktopUtilsTest from './ets/launchercommon/utils/DesktopUtils.test';
import IntentParseUtilTest from './ets/launchercommon/utils/IntentParseUtil.test';
import MultiFingerPinchUtilTest from './ets/launchercommon/utils/MultiFingerPinchUtil.test';
import SmallFolderIconFileUtilTest from './ets/launchercommon/utils/SmallFolderIconFileUtil.test';
import UdmfUtilsTest from './ets/launchercommon/utils/UdmfUtils.test';
import BitSetTest from './ets/launchercommon/utils/BitSet.test';
import AppShortcutLimitUtilsTest from './ets/launchercommon/utils/AppShortcutLimitUtils.test';
import { LauncherAbilityManagerTest } from './ets/launchercommon/abilitymanager/LauncherAbilityManager.test';
import { EditModeUtilTest } from './ets/launchercommon/utils/EditModeUtils.test';
import { CloseAppManagerTest }  from './ets/launchercommon/manager/CloseAppManager.test';
import { AppModelTest } from './ets/launchercommon/model/AppModel.test';
import LayoutRulesControllerTest from './ets/launchercommon/viewmodel/LayoutRulesController.test';
import LayoutViewModelTest from './ets/launchercommon/viewmodel/LayoutViewModel.test';
import PageDesktopOneShotManagerTest from './ets/launchercommon/viewmodel/PageDesktopOneShotManager.test';

import GridLayoutItemInfoTest from './ets/launchercommon/bean/GridLayoutItemInfo.test'
import GridLayoutItemBuilderTest from './ets/launchercommon/bean/GridLayoutItemBuilder.test'
import DragItemTest from './ets/launchercommon/bean/DragItem.test'
import DockItemInfoTest from './ets/launchercommon/bean/DockItemInfo.test'
import DockContinuableInfoTest from './ets/launchercommon/bean/DockContinuableInfo.test'
import DesktopDragResultTest from './ets/launchercommon/bean/DesktopDragResult.test'
import AppItemInfoTest from './ets/launchercommon/bean/AppItemInfo.test'
import AppIconEventDataTest from './ets/launchercommon/bean/AppIconEventData.test'
import AppBubbleEventDataTest from './ets/launchercommon/bean/AppBubbleEventData.test'
import RdbStoreManagerTest from './ets/launchercommon/db/RdbStoreManager.test';
import { FormManagerTest } from './ets/launchercommon/manager/FormManager.test';

import FolderLayoutConfigTest from './ets/launchercommon/folder/FolderLayoutConfig.test';
import BadgeItemInfoTest from './ets/launchercommon/bean/BadgeItemInfo.test';
import CardItemInfoTest from './ets/launchercommon/bean/CardItemInfo.test';
import FolderViewModelTest from './ets/launchercommon/folder/FolderViewModel.test';
import FolderReporterTest from './ets/launchercommon/folder/FolderReporter.test';
import FolderModelTest from './ets/launchercommon/folder/FolderModel.test';
import AppBubbleWrapperTest from './ets/launchercommon/uicomponents/AppBubbleWrapper.test';
import UsageStatisticUtilsTest from './ets/launchercommon/utils/UsageStatisticUtils.test';
import RadiusUtilTest from './ets/launchercommon/utils/RadiusUtil.test';
import HoverAnimationUtilTest from './ets/launchercommon/utils/HoverAnimationUtil.test';
import GridLayoutUtilTest from './ets/launchercommon/utils/GridLayoutUtil.test';
import FoldExpandAnimUtilsTest from './ets/launchercommon/utils/FoldExpandAnimUtils.test';
import FolderLayoutUtilTest from './ets/launchercommon/utils/FolderLayoutUtil.test';
import FormHiSysEventReporterTest from './ets/launchercommon/utils/FormHiSysEventReporter.test';
import PlusOneScreenInstructionTest from './ets/launchercommon/utils/differential/PlusOneScreenInstruction.test';
import ModifyInstructionTest from './ets/launchercommon/utils/differential/ModifyInstruction.test';
import InstructionManagerTest from './ets/launchercommon/utils/differential/InstructionManager.test';
import InstructionTest from './ets/launchercommon/utils/differential/Instruction.test';
import InsertIntoInstructionTest from './ets/launchercommon/utils/differential/InsertIntoInstruction.test';
import InsertInstructionTest from './ets/launchercommon/utils/differential/InsertInstruction.test';
import DeleteInstructionTest from './ets/launchercommon/utils/differential/DeleteInstruction.test';
import UpdateFormStackItemInstructionTest from './ets/launchercommon/utils/differential/UpdateFormStackItemInstruction.test';
import RestoreLauncherDataTest from './ets/launchercommon/service/impl/RestoreLauncherData.test';
import CloneCloudServiceTest from './ets/launchercommon/service/CloneCloudService.test';
import BaseControllerTest from './ets/launchercommon/model/BaseControllerTest.test';
import ViewManagerTest from './ets/launchercommon/manager/ViewManager.test';
import VibratorManagerTest from './ets/launchercommon/manager/VibratorManager.test';
import UpdateRdbManagerTest from './ets/launchercommon/manager/UpdateRdbManager.test';
import TransferRelationManagerTest from './ets/launchercommon/manager/TransferRelationManager.test';
import ThemeStylePreviewManagerTest from './ets/launchercommon/manager/ThemeStylePreviewManager.test';
import ThemeStyleManagerTest from './ets/launchercommon/manager/ThemeStyleManager.test';
import TextShadowManagerTest from './ets/launchercommon/manager/TextShadowManager.test';
import MenuInfoManagerTest from './ets/launchercommon/manager/MenuInfoManager.test';
import KeyEventManagerTest from './ets/launchercommon/manager/KeyEventManager.test';
import InputMethodManagerTest from './ets/launchercommon/manager/InputMethodManager.test';
import GrayAppListManagerTest from './ets/launchercommon/manager/GrayAppListManager.test';
import FolderAnimateEventManagerTest from './ets/launchercommon/manager/FolderAnimateEventManager.test';
import CloneItemInfoManagerTest from './ets/launchercommon/manager/CloneItemInfoManager.test';
import BadgeManagerTest from './ets/launchercommon/manager/BadgeManager.test';
import AtomicServiceAbilityManagerTest from './ets/launchercommon/manager/AtomicServiceAbilityManager.test';
import AppGalleryDownloadManagerTest from './ets/launchercommon/manager/AppGalleryDownloadManager.test';
import AppCategoryInfoManagerTest from './ets/launchercommon/manager/AppCategoryInfoManager.test';
import AppCategoryUtilsTest from './ets/launchercommon/utils/AppCategoryUtils.test';

import SCBHiSysEventUtilTest from './ets/launchercommon/hisysevent/SCBHiSysEventUtil.test';
import GlobalSearchStoreManagerTest from './ets/launchercommon/globalSearch/GlobalSearchStoreManager.test';
import SwiperItemInfoTest from './ets/launchercommon/entity/SwiperItemInfo.test';
import GridLayoutItemInfoDataBaseTest from './ets/launchercommon/entity/GridLayoutItemInfoDataBase.test';
import HiEditModeEventUtilsTest from './ets/launchercommon/editmode/hisysevent/HiEditModeEventUtils.test';
import EditModeReportManagerTest from './ets/launchercommon/editmode/hisysevent/EditModeReportManager.test';
import CommonConstantsTest_2 from './ets/launchercommon/constants/CommonConstants.test';
import FormListInfoCacheManagerTest from './ets/launchercommon/cache/FormListInfoCacheManager.test';
import ComponentPosShadowCacheTest from './ets/launchercommon/cache/ComponentPosShadowCache.test';
import BaseViewModelTest from './ets/launchercommon/base/BaseViewModel.test';
import ItemAnimationParamsTest from './ets/launchercommon/animation/ItemAnimationParams.test';
import { FormCommonUtilTest } from './ets/launchercommon/utils/FormCommonUtil.test';
import { OverflowFormInfoUtilTest } from './ets/launchercommon/utils/OverflowFormInfoUtil.test'
import { MenuCommonUtilTest } from './ets/launchercommon/utils/MenuCommonUtil.test';
import FolderServiceManagerTest from './ets/launchercommon/folder/model/FolderServiceManager.test';
import FolderItemAnimateDataTest from './ets/launchercommon/folder/data/FolderItemAnimateData.test';
import FolderDataModelTest from './ets/launchercommon/folder/data/FolderDataModel.test';
import FolderDataModelManagerTest
  from './ets/launchercommon/folder/model/FolderDataModelManager.test';
import FolderDataTest
  from './ets/launchercommon/folder/model/FolderData.test';
import { FormStackEventIdUtilTest } from './ets/launchercommon/utils/FormStackEventIdUtil.test';
import GlobalSearchServiceTest from './ets/launchercommon/globalSearch/GlobalSearchService.test'
import GlobalSearchPowerMonitorTest from './ets/launchercommon/globalSearch/GlobalSearchPowerMonitor.test';
import { AppIconModelTest } from './ets/launchercommon/launchericon/common/AppIconModel.test';
import { AppIconBadgeEventTest } from './ets/launchercommon/launchericon/viewmodel/AppIconBadgeEvent.test';
import { AppIconDisableMaskEventTest } from './ets/launchercommon/launchericon/viewmodel/AppIconDisableMaskEvent.test';
import { AppIconBackplaneEventTest } from './ets/launchercommon/launchericon/viewmodel/AppIconBackplaneEvent.test';
import { AppIconMenuEventTest } from './ets/launchercommon/launchericon/viewmodel/AppIconMenuEvent.test';
import { AppIconMenuVmTest } from './ets/launchercommon/launchericon/viewmodel/AppIconMenuVm.test';
import { AppInstallImageEventTest } from './ets/launchercommon/launchericon/viewmodel/AppInstallImageEvent.test';
import { AppNameEventTest } from './ets/launchercommon/launchericon/viewmodel/AppNameEvent.test';
import AddInstructionTest from './ets/launchercommon/utils/differential/AddInstruction.test';
import ExchangeInstructionTest from './ets/launchercommon/utils/differential/ExchangeInstruction.test';
import BaseLayoutCacheManagerTest from './ets/launchercommon/cache/layout/BaseLayoutCacheManager.test';
import LaunchLayoutCacheManagerTest from './ets/launchercommon/cache/layout/LaunchLayoutCacheManager.test';
import FormLayoutCacheManagerTest from './ets/launchercommon/cache/layout/FormLayoutCacheManager.test';
import FolderLayoutCacheManagerTest from './ets/launchercommon/cache/layout/FolderLayoutCacheManager.test';
import DesktopLayoutCacheDataTest from './ets/launchercommon/cache/layout/DesktopLayoutCacheData.test';
import LauncherLayoutCacheUtilTest from './ets/launchercommon/cache/layout/LauncherLayoutCacheUtil.test';
import BadgeInfoManagerTest from './ets/launchercommon/manager/BadgeInfoManager.test';
import EditModeStateTest from './ets/launchercommon/editmode/data/EditModeState.test';
import EditModeViewStateTest from './ets/launchercommon/editmode/data/EditModeViewState.test';
import EditModeFolderViewDataTest from './ets/launchercommon/editmode/data/EditModeFolderViewData.test';
import EditModeManagerTest from './ets/launchercommon/editmode/model/EditModeManager.test';
import BatchUninstallChainTest from './ets/launchercommon/editmode/viewModel/batchUninstall/BatchUninstallChain.test';
import AbstractBatchUninstallerTest
  from './ets/launchercommon/editmode/viewModel/batchUninstall/AbstractBatchUninstaller.test';
import DialogBatchUninstallerTest
  from './ets/launchercommon/editmode/viewModel/batchUninstall/DialogBatchUninstaller.test';
import LongPressBatchUninstallerTest
  from './ets/launchercommon/editmode/viewModel/batchUninstall/LongPressBatchUninstaller.test';
import RecoverBatchUninstallerTest
  from './ets/launchercommon/editmode/viewModel/batchUninstall/RecoverBatchUninstaller.test';
import RemoveBatchUninstallerTest
  from './ets/launchercommon/editmode/viewModel/batchUninstall/RemoveBatchUninstaller.test';
import PageDesktopCommonModelTest from './ets/launchercommon/model/PageDesktopCommonModel.test';
import FolderViewDataTest from './ets/launchercommon/folder/FolderViewData.test'
import { AppCenterModelTest } from './ets/launchercommon/model/AppCenterModel.test';
import PadLaunchLayoutCacheManagerTest from './ets/launchercommon/cache/layout/PadLaunchLayoutCacheManager.test'
import DragTriggerUtilTest from './ets/launchercommon/utils/DragTriggerUtil.test';

import DesktopModeManagerTest from './ets/launchercommon/desktopmode/statemanager/DesktopModeManager.test';
import { AppIconStyleConfigTest } from './ets/launchercommon/launchericon/config/AppIconStyleConfig.test';
import { AppIconClockModelTest } from './ets/launchercommon/launchericon/viewmodel/AppIconClockModel.test';
import { AppIconCalendarCacheTest } from './ets/launchercommon/launchericon/viewmodel/AppIconCalendarCache.test';
import FolderItemStateDataTest from './ets/launchercommon/folder/data/FolderItemStateData.test';
import FolderGridPositionHelpTest from './ets/launchercommon/folder/common/FolderGridPositionHelp.test';
import FolderStateManagerTest from './ets/launchercommon/folder/model/FolderStateManager.test';
import MultiSelectManagerTest from './ets/launchercommon/editmode/model/MultiSelectManager.test';
import TouchMoveMonitorTest from './ets/launchercommon/editmode/utils/TouchMoveMonitor.test';
import OpenFolderAppBubbleLayoutTest from './ets/launchercommon/folder/viewmodel/OpenFolderAppBubbleLayout.test';
import FolderGestureDataTest from './ets/launchercommon/folder/model/FolderGestureData.test';
import SpaceAnimationUtilsTest from './ets/launchercommon/animation/SpaceAnimationUtilsTest.test';
import FormComponentEventTest from './ets/launchercommon/form/viewmodel/FormComponentEvent.test';
import FormComponentConfigTest from './ets/launchercommon/form/model/FormComponentConfig.test';
import FormComponentModelTest from './ets/launchercommon/form/viewmodel/FormComponentModel.test';
import ShortcutViewModelTest from './ets/launchercommon/launchericon/viewmodel/ShortcutViewModel.test';
import AppIconCommonEventTest from './ets/launchercommon/launchericon/viewmodel/AppIconCommonEvent.test';
import SmallFoldStyleUtilTest from './ets/launchercommon/utils/SmallFoldStyleUtil.test';
import OuterIconCenterViewManagerTest from './ets/launchercommon/manager/OuterIconCenterViewManager.test';
import HighFrequencyCallStatisticsTest from './ets/launchercommon/db/HighFrequencyCallStatistics.test';
import MultiSelectListenManagerTest from './ets/launchercommon/editmode/model/MultiSelectListenerManager.test';
import AppToHapMappingManagerTest from './ets/launchercommon/base/AppToHapMappingManager.test';
import NotHarmonyUtilTest from './ets/launchercommon/utils/NotHarmonyUtil.test';
import AppListInfoCacheManagerTest from './ets/launchercommon/cache/AppListInfoCacheManager.test';
import ReplaceInstructionTest from './ets/launchercommon/utils/differential/ReplaceInstruction.test';
import DisposedEventManagerTest from './ets/launchercommon/manager/DisposedEventManager.test';
import {
  MultiSelectCheckboxViewModelTest
} from './ets/launchercommon/editmode/viewModel/MultiSelectCheckboxViewModel.test';
import DesktopManagerTest from './ets/launchercommon/manager/DesktopManager.test';
import ScreenSplitUtilTest from './ets/launchercommon/utils/ScreenSplitUtil.test';
import NoIconAppModelTest from './ets/launchercommon/model/NoIconAppModel.test';
import {
  MultiSelectAnimateManagerTest
} from './ets/launchercommon/editmode/model/MultiSelectAnimateManager.test';
import DesktopDataLoaderTest from './ets/launchercommon/viewmodel/DesktopDataLoader.test';
import OneShotUpdateClockCardStyleTest from './ets/launchercommon/viewmodel/OneShotUpdateClockCardStyle.test';
import AppGridItemInfoTest from './ets/launchercommon/bean/AppGridItemInfo.test';
import GameCardInfoTest from './ets/launchercommon/bean/GameCardInfo.test';
import Extend1DataTest from './ets/launchercommon/bean/Extend1Data.test';
import FolderDebugTest from './ets/launchercommon/folder/dfx/debug/FolderDebug.test';
import AddToFolderInstructionTest from './ets/launchercommon/utils/differential/AddToFolderInstruction.test';
import BaseNodeParamsTest from './ets/launchercommon/buildernode/BaseNodeParams.test';
import DesktopIconChangeManagerTest from './ets/launchercommon/manager/DesktopIconChangeManager.test';
import RdbSqlHelpTest from './ets/launchercommon/db/RdbSqlHelp.test';
import CacheRdbHelperTest from './ets/launchercommon/cache/CacheRdbHelper.test';
import DockUtilsTest from './ets/launchercommon/utils/DockUtils.test';
import LauncherVisualEffectManagerTest from './ets/launchercommon/manager/LauncherVisualEffectManager.test';
import MinorUpdateHandlerTest from './ets/launchercommon/db/MinorUpdateHandler.test';
import BundleChangeCorrectorTest from './ets/launchercommon/db/gridlayoutcorrector/BundleChangeCorrector.test';
import EmergencyThresholdManagerTest
  from './ets/launchercommon/desktopmode/eventmanager/EmergencyThresholdManager.test';
import StartAndExitUtilTest from './ets/launchercommon/utils/StartAndExitUtil.test';
import LauncherBackupUtilTest from './ets/launchercommon/utils/LauncherBackupUtil.test';
import { AppDataWrapperTest } from './ets/launchercommon/launchericon/common/AppDataWrapper.test';
import { AppIconMsgKeyUtilTest } from './ets/launchercommon/launchericon/common/AppIconMsgKeyUtil.test';
import { AppIconBaseCanvasTest } from './ets/launchercommon/launchericon/interface/AppIconBaseCanvas.test';
import {
  AppIconContainerTouchEventTest
} from './ets/launchercommon/launchericon/viewmodel/AppIconContainerTouchEvent.test';
import { AppIconContextMenuTest } from './ets/launchercommon/launchericon/viewmodel/AppIconContextMenu.test';
import AddCardToNewPageManagerTest from './ets/launchercommon/manager/AddCardToNewPageManager.test';
import { OuterAppManagerTest } from './ets/launchercommon/manager/OuterAppManagerTest.test';
import UltraScreenExpandAnimUtilsTest from './ets/launchercommon/utils/UltraScreenExpandAnimUtils.test';
import SCBBlankPositionUtilsTest from './ets/launchercommon/utils/SCBBlankPositionUtils.test';
import { PageDragActionTest } from './ets/launchercommon/editmode/viewModel/PageDragAction.test';
import PageEditManagerTest from './ets/launchercommon/model/PageEditManager.test';
import PageEditViewModelTest from './ets/launchercommon/viewmodel/PageEditViewModel.test';
import { PageDragManagerTest } from './ets/launchercommon/editmode/model/PageDragManager.test';
import EmergencyEventManagerTest from './ets/launchercommon/desktopmode/eventmanager/EmergencyEventManager.test';
import AppIconLongPressGestureEventTest
  from './ets/launchercommon/launchericon/viewmodel/AppIconLongPressGestureEvent.test';
import { PreviewLayoutCheckToolTest } from "./ets/launchercommon/tools/PreviewLayoutCheckTool.test";
import AppIconTouchEventTest from './ets/launchercommon/launchericon/viewmodel/AppIconTouchEvent.test';
import CollaborationEventManagerTest from './ets/launchercommon/manager/CollaborationEventManager.test';
import AppIconClockEventTest from './ets/launchercommon/launchericon/viewmodel/AppIconClockEvent.test';
import AppIconDragEventTest from './ets/launchercommon/launchericon/viewmodel/AppIconDragEvent.test';
import AppIconCloneBadgeEventTest from './ets/launchercommon/launchericon/viewmodel/AppIconCloneBadgeEvent.test';
import MatchCardDataManagerTest from './ets/launchercommon/model/MatchCardDataManager.test';
import AppIconResConfigTest from './ets/launchercommon/launchericon/viewmodel/AppIconResConfig.test';
import DisplayCountDataTest from './ets/launchercommon/displaycount/DisplayCountData.test';
import DisplayCountViewModelTest from './ets/launchercommon/displaycount/DisplayCountViewModel.test';
import AppIconGestureJudgeEventTest from './ets/launchercommon/launchericon/viewmodel/AppIconGestureJudgeEvent.test';
import DesktopItemVibratorManagerTest from './ets/launchercommon/manager/DesktopItemVibratorManager.test';
import SwiperPageManagerTest from './ets/launchercommon/viewmodel/SwiperPageManager.test';

export default function CommonTestSuite() {
  FrameworkTestSuite(); // 合一框架组测试用例
  LauncherCommonTestSuite(); // 基础桌面测试用例
  EditModeTestSuite(); // 桌面编辑测试用例
  ComponentsTestSuite(); // 桌面组件
}

export function ComponentsTestSuite() {
  CollaborationEventManagerTest();
}

export function FrameworkTestSuite() {
  LauncherAbilityManagerTest();
}

export function LauncherCommonTestSuite() {
  MatchCardDataManagerTest();
  RdbSqlHelpTest();
  CacheRdbHelperTest();
  DockUtilsTest();
  BitSetTest();
  AppShortcutLimitUtilsTest();
  PreviewLayoutCheckToolTest();
  UdmfUtilsTest();
  SmallFolderIconFileUtilTest();
  MultiFingerPinchUtilTest();
  IntentParseUtilTest();
  LauncherBackupUtilTest();
  DesktopUtilsTest();
  NotHarmonyUtilTest();
  ConfigParseUtilTest();
  ColorUtilTest();
  FormCommonUtilTest();
  OverflowFormInfoUtilTest();
  MenuCommonUtilTest();
  AtomicServiceAppModelTest();
  CustomBadgeManagerTest();
  FormModelTest();
  PageDesktopModelTest();
  RecentMissionsModelTest();
  SettingsModelTest();
  TransferRelationModelTest();
  LruCacheTest();
  DiskLruCacheTest();
  DockLayoutCacheManagerTest();
  RdbTaskPoolTest();
  DirtyFormCorrectorTest();
  DuplicateItemCorrectorTest();
  DuplicatePositionCorrectorTest();
  FieldNotNullCorrectorTest();
  GridLayoutCorrectorChainTest();
  CloseAppManagerTest();
  FormManagerTest();

  AppGridStyleConfigTest();
  AppListStyleConfigTest();
  FormLayoutConfigTest();
  GetLayoutInfoFromConfigTest();
  GetHideAppsFromConfigTest();
  SystemParameterUtilTest();
  LauncherLayoutStyleConfigTest();
  LayoutConfigManagerTest();
  PageDesktopAppModeConfigTest();
  PageDesktopLayoutConfigTest();
  PageDesktopModeConfigTest();
  SmartDockLayoutConfigTest();
  SmartDockModeConfigTest();
  SmartDockStyleConfigTest_1();
  SmartDockSuggestAppConfigTest();
  FolderTestSuite();
  PageDesktopCommonModelTest();

  AppBubbleEventDataTest();
  AppIconEventDataTest();
  AppItemInfoTest();
  DesktopDragResultTest();
  DockContinuableInfoTest();
  DockItemInfoTest();
  DragItemTest();
  GridLayoutItemBuilderTest();
  GridLayoutItemInfoTest();
  RdbStoreManagerTest();
  HighFrequencyCallStatisticsTest();

  FolderReporterTest();
  FolderModelTest();
  FolderViewModelTest();
  FolderServiceManagerTest();
  FolderDataModelManagerTest();
  FolderDataTest();
  FolderGestureDataTest();
  OpenFolderAppBubbleLayoutTest();
  CardItemInfoTest();
  FormComponentEventTest();
  FormComponentConfigTest();
  FormComponentModelTest();
  BadgeItemInfoTest();
  FolderLayoutConfigTest();

  ItemAnimationParamsTest();
  SpaceAnimationUtilsTest();
  BaseViewModelTest();
  ComponentPosShadowCacheTest();
  FormListInfoCacheManagerTest();
  CommonConstantsTest_2();
  HiEditModeEventUtilsTest();
  GridLayoutItemInfoDataBaseTest();
  SwiperItemInfoTest();
  GlobalSearchStoreManagerTest();
  GlobalSearchPowerMonitorTest();
  SCBHiSysEventUtilTest();
  AppCategoryInfoManagerTest();
  AppCategoryUtilsTest();
  AppGalleryDownloadManagerTest();
  AtomicServiceAbilityManagerTest();
  BadgeManagerTest();
  CloneItemInfoManagerTest();
  FolderAnimateEventManagerTest();
  FolderItemAnimateDataTest();
  GrayAppListManagerTest();
  InputMethodManagerTest();
  KeyEventManagerTest();
  LauncherVisualEffectManagerTest();
  MenuInfoManagerTest();
  TextShadowManagerTest();
  ThemeStyleManagerTest();
  ThemeStylePreviewManagerTest();
  TransferRelationManagerTest();
  UpdateRdbManagerTest();
  VibratorManagerTest();
  ViewManagerTest();
  BaseControllerTest();
  CloneCloudServiceTest();
  RestoreLauncherDataTest();
  AddInstructionTest();
  DeleteInstructionTest();
  UpdateFormStackItemInstructionTest();
  InsertInstructionTest();
  InsertIntoInstructionTest();
  InstructionTest();
  InstructionManagerTest();
  ModifyInstructionTest();
  PlusOneScreenInstructionTest();
  FormHiSysEventReporterTest();
  HoverAnimationUtilTest();
  GridLayoutUtilTest();
  UltraScreenExpandAnimUtilsTest();
  FoldExpandAnimUtilsTest();
  FolderLayoutUtilTest();
  RadiusUtilTest();
  SCBBlankPositionUtilsTest();
  UsageStatisticUtilsTest();
  LayoutViewModelTest();
  PageDesktopOneShotManagerTest();
  SwiperPageManagerTest();
  AppBubbleWrapperTest();
  GlobalSearchServiceTest()
  FormStackEventIdUtilTest();
  AppIconTest();
  BaseLayoutCacheManagerTest();
  LaunchLayoutCacheManagerTest();
  FormLayoutCacheManagerTest();
  FolderLayoutCacheManagerTest();
  DesktopLayoutCacheDataTest();
  LauncherLayoutCacheUtilTest();
  BadgeInfoManagerTest();
  AppCenterModelTest();
  PadLaunchLayoutCacheManagerTest();
  DragTriggerUtilTest();
  OuterIconCenterViewManagerTest();
  SmallFoldStyleUtilTest();
  AppToHapMappingManagerTest();
  AppListInfoCacheManagerTest();
  ReplaceInstructionTest()
  DisposedEventManagerTest();
  DesktopDataLoaderTest();
  OneShotUpdateClockCardStyleTest();
  AppGridItemInfoTest();
  GameCardInfoTest();
  Extend1DataTest();
  FolderDebugTest();
  AddToFolderInstructionTest();
  BaseNodeParamsTest();
  DesktopIconChangeManagerTest();
  BundleChangeCorrectorTest();
  EmergencyThresholdManagerTest();
  EmergencyEventManagerTest();
  StartAndExitUtilTest();
  ExchangeInstructionTest();
  OuterAppManagerTest();
  DesktopModeManagerTest();
  DisplayCountDataTest();
  DisplayCountViewModelTest();
}

export function AppIconTest() {
  AppDataWrapperTest();
  AppIconModelTest();
  AppIconMsgKeyUtilTest();
  AppIconStyleConfigTest();
  AppIconInterfaceTest();
  AppIconViewModelTest();
}

export function AppIconInterfaceTest() {
  AppIconBaseCanvasTest();
}

export function AppIconViewModelTest() {
  AppIconDisableMaskEventTest();
  AppIconBadgeEventTest();
  AppIconBackplaneEventTest();
  AppIconMenuEventTest();
  AppIconMenuVmTest();
  AppInstallImageEventTest();
  AppNameEventTest();
  AppIconClockModelTest();
  AppIconCalendarCacheTest();
  ShortcutViewModelTest();
  AppIconCommonEventTest();
  AppIconClockEventTest();
  AppIconContainerTouchEventTest();
  AppIconContextMenuTest();
  AppIconLongPressGestureEventTest();
  AppIconTouchEventTest();
  AppIconCloneBadgeEventTest();
  AppIconDragEventTest();
  AppIconResConfigTest();
  AppIconGestureJudgeEventTest();
}

export function EditModeTestSuite() {
  EditModeUtilTest();
  EditModeStateTest()
  EditModeViewStateTest()
  EditModeFolderViewDataTest()
  EditModeManagerTest();
  BatchUninstallChainTest();
  AbstractBatchUninstallerTest();
  DialogBatchUninstallerTest();
  LongPressBatchUninstallerTest();
  RecoverBatchUninstallerTest();
  RemoveBatchUninstallerTest();
  MultiSelectManagerTest();
  EditModeReportManagerTest();
  MultiSelectListenManagerTest();
  MultiSelectCheckboxViewModelTest();
  AddCardToNewPageManagerTest();
  DesktopManagerTest();
  ScreenSplitUtilTest();
  NoIconAppModelTest();
  MultiSelectAnimateManagerTest();
  TouchMoveMonitorTest();
  PageDragActionTest();
  PageDragManagerTest();
  PageEditManagerTest();
  PageEditViewModelTest();
  DesktopItemVibratorManagerTest();
}

export function FolderTestSuite() {
  SmallFolderCacheManagerTest();
  LayoutRulesControllerTest()
  AppModelTest();
  FolderViewDataTest();
  FolderOpenSwipingStateTest();
  FolderDataModelTest();
  FolderItemStateDataTest();
  FolderGridPositionHelpTest();
  FolderStateManagerTest();
}

export function ShortcutViewModelTestSuite() {
  ShortcutViewModelTest();
}