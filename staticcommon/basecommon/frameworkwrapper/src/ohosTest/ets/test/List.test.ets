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

import { OutSideWindowManagerTest } from './ets/framework/manager/OutSideWindowManagerTest.test';
import ViewManagerPolicyTest from './ets/framework/manager/view/ViewManagerPolicy.test';
import { CommonBundleManagerTest } from './ets/framework/manager/CommonBundleManagerTest.test';
import { SCBDesktopCacheManagerTest } from './ets/recent/manager/SCBDesktopCacheManager.test';
import { DebugCommandTest } from './ets/recent/debug/DebugCommand.test';
import AccountManagerTest from './ets/framework/accountmanager/AccountManager.test';
import { WorkSchedulerManagerTest }from './ets/framework/hisysevent/WorkSchedulerManagerTest.test';
import { ResourceManagerTest } from './ets/component/manager/ResourceManager.test';
import { ResourceManager2Test } from './ets/component/manager/ResourceManager2.test';
import ResourceManager3Test from './ets/framework/manager/ResourceManager.test';
import { AppNotificationRdbTest } from './ets/component/service/db/AppNotificationRdb.test';
import { RdbStoreHelperTest } from './ets/component/service/db/RdbStoreHelper.test';
import { SettingsUtilTest } from './ets/setting/SettingsUtil.test';
import { SettingsDataManagerTest } from './ets/setting/SettingsDataManager.test';
import { WallpaperManagerTest } from './ets/component/service/wallpaper/WallpaperManager.test';
import { CommonEventManagerATest } from './ets/framework/commoneventmanager/CommonEventManagerA.test';
import { WindowCommonEventManagerTest } from './ets/framework/commoneventmanager/WindowCommonEventManager.test';
import { CommonEventManagerTest } from './ets/framework/commoneventmanager/CommonEventManager.test';
import { ConfigManagerTest } from './ets/framework/configmanager/ConfigManager.test';
import { DeviceHelperTest } from './ets/framework/base/DeviceHelper.test';
import { ProxyObjectTest } from './ets/framework/base/ProxyObject.test';
import { MemoryInfoUtilTest } from './ets/framework/utils/MemoryInfoUtil.test';
import { LogCollectUtilTest } from './ets/framework/utils/LogCollectUtil.test';
import { GlobalContextTest } from './ets/framework/utils/GlobalContext.test';
import { EventUtilTest } from './ets/framework/utils/EventUtil.test';
import { EventManagerTest } from './ets/framework/utils/EventManager.test';
import { ApsUtilsTest } from './ets/framework/utils/ApsUtils.test';
import { EventBusTest } from './ets/framework/eventBus/EventBus.test';
import { EventsTest } from './ets/framework/eventBus/events/Events.test';
import { CommonEventFrameworkTest } from './ets/framework/eventBus/events/CommonEventFrameworkTest.test';
import { AmsMissionManagerTest } from './ets/framework/manager/AmsMissionManager.test';
import { ReportIntervalManagerTest } from './ets/framework/hisysevent/ReportIntervalManager.test';
import { HiSysEventUtilTest } from './ets/framework/hisysevent/HiSysEventUtil.test';
import { HiDfxEventUtilTest } from './ets/framework/hisysevent/HiDfxEventUtil.test';
import { AppResourceCacheManagerTest } from './ets/component/manager/AppResourceCacheManager.test';
import { PluginParseInfoTest } from './ets/framework/plugin/PluginParseInfo.test';
import { PluginInfoTest } from './ets/framework/plugin/PluginInfo.test';
import { WallpaperColorManagerTest } from './ets/component/service/wallpaper/WallpaperColorManager.test';
import { TextColorTest } from './ets/component/service/wallpaper/TextColor.test';
import { DbCacheTest } from './ets/framework/resourcemanager/cache/DbCache.test';
import { MemoryCacheTest } from './ets/framework/resourcemanager/cache/MemoryCache.test';
import { ResourceManagerFwkTest } from './ets/framework/resourcemanager/fwk/ResourceManagerFwk.test';
import { BundleManagerFwkTest } from './ets/framework/resourcemanager/fwk/BundleManagerFwk.test';
import { GraphicUtilsTest } from './ets/framework/resourcemanager/GraphicUtils.test';
import { IconInfoTest } from './ets/framework/resourcemanager/IconInfo.test';
import { IconResourceManagerTest } from './ets/framework/resourcemanager/IconResourceManager.test';
import { IntelligentCacheTest } from './ets/framework/resourcemanager/cache/IntelligentCache.test';
import { AccessibilityManagerTest } from './ets/framework/utils/AccessibilityManager.test';
import DropDownPanelManagerWrapperTest from './ets/component/manager/DropDownPanelManagerWrapper.test';
import { GrayscaleUtilTest } from './ets/component/utils/Grayscale.test';
import { TransparentBorderIconCropperTest } from './ets/framework/resourcemanager/TransparentBorderIconCropper.test';
import ModeChangeUtilsTest from './ets/framework/utils/ModeChangeUtils.test';
import { TimeOutUtilsTest } from './ets/framework/utils/TimeOutUtils.test';
import { ThemeUtilsTest } from './ets/framework/utils/ThemeUtils.test';
import { SubThemeUtilsTest } from './ets/framework/utils/SubThemeUtils.test';
import { OnLineThemeUtilTest } from './ets/framework/utils/OnLineThemeUtil.test';
import { IconEditPageUtilsTest } from './ets/framework/utils/IconEditPageUtils.test';
import { GrayscaleUtilsTest } from './ets/framework/utils/GrayscaleUtils.test';
import { EventBusUtilsTest } from './ets/framework/utils/EventBusUtils.test';
import { IconResourceUtilsTest } from './ets/framework/resourcemanager/IconResourceUtils.test';
import { DropDownPanelManagerWrappersTest } from './ets/framework/manager/DropDownPanelManagerWrapper.test';
import { PluginConstantsTest } from './ets/framework/plugin/PluginConstants.test';
import { LocalEventManagerTest } from './ets/framework/manager/LocalEventManager.test'
import { SceneBoardStateManagerTest } from './ets/framework/manager/fsm/SceneBoardStateManager.test';
import { SceneBoardCoreStateFsmTest } from './ets/framework/manager/fsm/SceneBoardCoreStateFsm.test';
import { StateFsmTest } from './ets/framework/manager/fsm/StateFsm.test';

export default function FrameworkWrapperTestSuite() {
  FrameworkTestSuite(); // 合一框架组测试用例
  ComponentsTestSuite(); // 桌面组件组测试用例
  LauncherCommonTestSuite(); // 基础桌面测试用例
  RecentTestSuite(); // 桌面多任务测试用例
}

export function FrameworkTestSuite() {
  GlobalContextTest();
  DeviceHelperTest();
  CommonEventManagerTest();
  CommonEventManagerATest();
  WindowCommonEventManagerTest();
  CommonBundleManagerTest();
  WorkSchedulerManagerTest();
  LogCollectUtilTest();
  OutSideWindowManagerTest();
  ConfigManagerTest();
  EventUtilTest();
  EventManagerTest();
  ApsUtilsTest();
  AccountManagerTest();
  AmsMissionManagerTest();
  EventBusTest();
  EventsTest();
  CommonEventFrameworkTest();
  ReportIntervalManagerTest();
  HiSysEventUtilTest();
  HiDfxEventUtilTest();
  PluginInfoTest();
  PluginParseInfoTest();
  DbCacheTest();
  MemoryCacheTest();
  ResourceManagerFwkTest();
  BundleManagerFwkTest();
  GraphicUtilsTest();
  IconInfoTest();
  IconResourceManagerTest();
  MemoryInfoUtilTest();
  ProxyObjectTest();
  IntelligentCacheTest();
  AccessibilityManagerTest();
  TransparentBorderIconCropperTest();
  ModeChangeUtilsTest()
  TimeOutUtilsTest();
  ThemeUtilsTest();
  SubThemeUtilsTest();
  OnLineThemeUtilTest();
  IconEditPageUtilsTest();
  GrayscaleUtilsTest();
  EventBusUtilsTest();
  IconResourceUtilsTest();
  DropDownPanelManagerWrappersTest();
  PluginConstantsTest();
  LocalEventManagerTest();
  SceneBoardStateManagerTest();
  SceneBoardCoreStateFsmTest();
  StateFsmTest();
}


export function ComponentsTestSuite() {
  ResourceManagerTest();
  ResourceManager2Test();
  ResourceManager3Test();
  AppNotificationRdbTest();
  RdbStoreHelperTest();
  DropDownPanelManagerWrapperTest();
  SettingsUtilTest();
  SettingsDataManagerTest();
  WallpaperManagerTest();
  WallpaperColorManagerTest();
  TextColorTest();
  AppResourceCacheManagerTest();
  GrayscaleUtilTest()
}

export function LauncherCommonTestSuite() {
  ViewManagerPolicyTest()
}

export function RecentTestSuite() {
  SCBDesktopCacheManagerTest();
  DebugCommandTest();
}