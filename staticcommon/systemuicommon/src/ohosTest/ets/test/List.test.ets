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
import { BatterySocEventTest } from './ets/datasharemanager/SysUIDataShareEvent.test';
import { CapsuleListStateTest } from './ets/liveview/info/capsule/CapsuleListState.test';
import { DataShareManagerTest } from './ets/datasharemanager/DataShareManager.test';
import { DataShareUtilsTest } from './ets/datasharemanager/DataShareUtils.test';
import { EventBroadcastTest } from './ets/event/EventBroadcast.test';
import {
  ImmersiveKeyguardStateManagerTest
} from './ets/immersivekeyguardcommon/manager/ImmersiveKeyguardStateManager.test';
import { LiveConstantsTest } from './ets/utils/NumberUtils.test';
import { LiveProgressDataTest } from './ets/liveview/LiveProgressData.test';
import { LiveSystemTemplateParserTest } from './ets/liveview/parse/local/LiveSystemTemplateParser.test';
import { LiveViewSysEventUtilTest } from './ets/liveview/common/LiveViewSysEventUtil.test';
import { LiveViewTimerManagerTest } from './ets/liveview/common/LiveViewTimerManager.test';
import LiveViewHelperTest from './ets/liveview/common/LiveViewHelper.test';
import { LiveViewDataTest } from './ets/liveview/data/LiveViewData.test';
import LiveViewCapsuleStyleTest from './ets/info/LiveViewCapsuleStyle.test';
import { LunarCalendarTest, LunarCalendarTest_two } from './ets/calendar/LunarCalendar.test';
import { sDropDownPanelManagerTest } from './ets/manager/DropDownPane.test';
import { SysDiaglogManagerTest } from './ets/sysdialog/common/info/SysDiaglogManager.test';
import { SysDialogManagerTest } from './ets/sysdialog/SysDialogManager.test';
import { TransResToPicHelperTest } from './ets/liveview/parse/utils/TransResToPicHelper.test';
import { AppNotificationSettingModelTest } from './ets/model/AppNotificationSettingModel.test';
import { AccessibilityUtilTest } from './ets/accessibility/AccessibilityUtilTest.test';
import { BannerDeformStateTest } from './ets/banner/common/info/BannerStateTest.test';
import { ExtendClipPathTest, ExtendClipPathTest_two } from './ets/base/anim/ComponentAnimStateTest.test';
import { FontScaleStateTest } from './ets/base/common/fontScale/fontScaleStateTest.test';
import { StateListenerRegisterTest } from './ets/base/StateListenerRegisterTest.test';
import { SystemUIGlobalHelperTest } from './ets/base/SystemUIGlobalHelperTest.test';
import { LunarTermsInfoTest } from './ets/calendar/LunarTermsInfoTest.test';
import { LunarTermTest } from './ets/calendar/LunarTermTest.test';
import { SexagenarianCycleTest } from './ets/calendar/SexagenarianCycleTest.test';
import { AppNotificationTableTest } from './ets/database/AppNotificationTableTest.test';
import { TableEntityTest } from './ets/database/TableEntityTest.test';
import { CommonEventSystemuiTest } from './ets/event/CommonEventSystemuiTest.test';
import { LiveViewEventTest } from './ets/event/LiveViewEventTest.test';
import { FrameNodeManagerTest } from './ets/framenode/FrameNodeManagerTest.test';
import { ParserControllerTest } from './ets/immersivekeyguardcommon/base/dataparse/ParserControllerTest.test';
import { TouchRunnableManagerTest } from './ets/immersivekeyguardcommon/base/manager/TouchRunnableManagerTest.test';
import LiveItemStartAnimManagerTest from './ets/liveview/common/LiveItemStartAnimManager.test';
import OverlayCardInfoTest from './ets/overlay/OverlayCardInfo.test';
import OverlayStartAnimHelperTest from './ets/overlay/OverlayStartAnimHelper.test';
import StartAbilityOverlayAnimateDataTest from './ets/liveview/common/StartAbilityOverlayAnimateData.test';
import StartAbilityOverlayAnimateTest from './ets/liveview/common/StartAbilityOverlayAnimate.test';
import { SymbolIconUtilTest } from './ets/utils/SymbolIconUtil.test';
import { AppProtectedVmTest } from './ets/vm/AppProtectedVm.test';
import NtfControlConfigTest from './ets/model/NtfControlConfigTest.test';

export function SystemUiCommonTestSuite() {
  AppNotificationSettingModelTest();
  BatterySocEventTest();
  CapsuleListStateTest();
  DataShareManagerTest();
  DataShareUtilsTest();
  EventBroadcastTest();
  ImmersiveKeyguardStateManagerTest();
  LiveConstantsTest();
  LiveProgressDataTest();
  LiveSystemTemplateParserTest();
  LiveViewCapsuleStyleTest();
  LiveViewDataTest();
  LiveViewSysEventUtilTest();
  LiveViewTimerManagerTest();
  LiveViewHelperTest();
  LunarCalendarTest();
  LunarCalendarTest_two();
  sDropDownPanelManagerTest();
  SysDiaglogManagerTest();
  SysDialogManagerTest();
  SymbolIconUtilTest();
  TransResToPicHelperTest();
  testSuiteTwo();
  LiveItemStartAnimManagerTest();
  OverlayCardInfoTest();
  OverlayStartAnimHelperTest();
  StartAbilityOverlayAnimateDataTest();
  StartAbilityOverlayAnimateTest();
  NtfControlConfigTest();
}

function testSuiteTwo() {
  AccessibilityUtilTest();
  BannerDeformStateTest();
  ExtendClipPathTest();
  ExtendClipPathTest_two();
  FontScaleStateTest();
  StateListenerRegisterTest();
  SystemUIGlobalHelperTest();
  LunarTermsInfoTest();
  LunarTermTest();
  SexagenarianCycleTest();
  AppNotificationTableTest();
  TableEntityTest();
  CommonEventSystemuiTest();
  LiveViewEventTest();
  FrameNodeManagerTest();
  ParserControllerTest();
  TouchRunnableManagerTest();
  AppProtectedVmTest();
}