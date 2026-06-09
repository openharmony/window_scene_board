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

import SCBGestureManagerTest from './ets/WindowScene/gesturenavigation/SCBGestureManager.test';
import RecentFsmTest from './ets/recent/Fsm.test';
import AnimateExTest from './ets/recent/AnimateEx.test';
import { ChainAnimationTest } from './ets/recent/ChainAnimation.test';
import { SpringMotionTest } from './ets/recent/SpringMotion.test';
import { SpringModelTest } from './ets/recent/SpringModel.test';
import { UIExceptionDetectionTest } from './ets/recent/UIExceptionDetection.test';
import { RecentViewParamTest } from './ets/recent/RecentViewParam.test';
import SCBTransitionManagerTest from './ets/WindowScene/animation/SCBTransitionManager.test';
import SCBCompanionManagerTest from './ets/WindowScene/animation/SCBCompanionController.test';
import BaseAnimationTest from './ets/WindowScene/animation/BaseAnimation.test';
import WindowAnimationUtilsTest from './ets/WindowScene/animation/WindowAnimationUtils.test';
import WindowAnimationTest from './ets/WindowScene/animation/WindowAnimation.test';
import { ResUtilsTest } from './ets/framework/utils/ResourceUtils.test';
import { DisplayManagerTest } from './ets/framework/utils/DisplayManager.test'
import { SCBSceneContainerSessionArrayTest } from './ets/WindowScene/scene/session/SCBSceneContainerSessionArray.test';
import { SCBScreenSessionTest } from './ets/WindowScene/screen/session/SCBScreenSession.test';
import { SCBSceneContainerSessionTest } from './ets/WindowScene/scene/session/SCBSceneContainerSession.test';
import { SCBSceneContainerSessionTest2 } from './ets/WindowScene/scene/session/SCBSceneContainerSession2.test';
import { SCBRootSceneSessionTest } from './ets/WindowScene/scene/session/SCBRootSceneSession.test';
import { SCBWindowRotateTest } from './ets/WindowScene/scene/session/SCBWindowRotate.test';
import { SCBSceneInfoTest } from './ets/WindowScene/scene/session/SCBSceneInfo.test';
import { SCBSceneSessionTest } from './ets/WindowScene/scene/session/SCBSceneSession.test';
import { SCBRecentSessionInfoTest } from './ets/WindowScene/scene/session/SCBRecentSessionInfo.test';
import { SCBScenePersistentTest } from './ets/WindowScene/scene/session/SCBScenePersistent.test';
import { SCBSceneSessionManagerOneTest } from './ets/WindowScene/scene/session/SCBSceneSessionManager.test';
import { SCBSceneSessionManagerFourTest } from './ets/WindowScene/scene/session/SCBSceneSessionManager4.test';
import { SCBSceneSessionManagerFiveTest } from './ets/WindowScene/scene/session/SCBSceneSessionManager5.test';
import { SCBSceneSessionManagerTest2 } from './ets/WindowScene/scene/session/SCBSceneSessionManager2.test';
import { SCBSceneSessionManagerTest3 } from './ets/WindowScene/scene/session/SCBSceneSessionManager3.test';
import { SCBSceneSessionManagerTest6 } from './ets/WindowScene/scene/session/SCBSceneSessionManager6.test';
import { SCBSceneSessionManagerTest7 } from './ets/WindowScene/scene/session/SCBSceneSessionManager7.test';
import { SCBSceneSessionManagerTest8 } from './ets/WindowScene/scene/session/SCBSceneSessionManager8.test';
import { SCBSystemSceneSessionTest } from './ets/WindowScene/scene/session/SCBSystemSceneSession.test';
import { SCBSpecificSessionTest } from './ets/WindowScene/scene/session/SCBSpecificSession.test'
import { SCBScreenSessionManagerTest } from './ets/WindowScene/screen/session/SCBScreenSessionManager.test';
import SCBEventExclusiveManagerTest
  from './ets/WindowScene/gesturenavigation/gestureignore/SCBEventExclusiveManager.test';
import SendTouchEventControllerTest from './ets/WindowScene/gesturenavigation/sendevent/SendTouchEventController.test';
import SendClickEventControllerTest from './ets/WindowScene/gesturenavigation/sendevent/SendClickEventController.test';
import { SCBRecoverManagerTest } from './ets/WindowScene/scene/manager/SCBRecoverManager.test';
import { SCBSessionRectTest } from './ets/WindowScene/scene/session/SCBSessionRect.test';
import SCBDebugUtilsTest from './ets/WindowScene/scene/uiDumpUtils/SCBDebugUtils.test';
import SCBScenePanelDebugCommandsTest from './ets/WindowScene/scene/uiDumpUtils/SCBScenePanelDebugCommands.test';
import SCBSceneContainerSessionDebugCommandsTest
  from './ets/WindowScene/scene/uiDumpUtils/SCBSceneContainerSessionDebugCommands.test';
import SCBScreenDebugCommandsTest from './ets/WindowScene/scene/uiDumpUtils/SCBScreenDebugCommands.test';
import SCBSceneSessionDebugCommandsTest from './ets/WindowScene/scene/uiDumpUtils/SCBSceneSessionDebugCommans.test';
import SCBSpecificScenePanelDebugCommandsTest
  from './ets/WindowScene/scene/uiDumpUtils/SCBSpecificScenePanelDebugCommands.test';
import SCBSpecificSessionDebugCommandsTest
  from './ets/WindowScene/scene/uiDumpUtils/SCBSpecificSessionDebugCommands.test';
import SCBSpecialScenePanelDebugCommandsTest
  from './ets/WindowScene/scene/uiDumpUtils/SCBSpecialScenePanelDebugCommands.test';
import { SCBSceneOrientationPolicyTest } from './ets/WindowScene/scene/session/SCBSceneOrientationPolicy.test';
import { SCBDeviceScreenConfigTest } from './ets/WindowScene/config/SCBDeviceScreenConfig.test';
import { SCBKeyboardSessionTest } from './ets/WindowScene/scene/session/SCBKeyboardSession.test';
import { SCBKeyboardPanelSessionTest } from './ets/WindowScene/scene/session/SCBKeyboardPanelSession.test';
import WindowManagerProxyTest from './ets/WindowScene/windowmanager/WindowManagerProxy.test';
import { SCBScenePanelManagerTest } from './ets/WindowScene/scene/manager/SCBScenePanelManager.test';
import { SCBScenePanelManagerTwoTest } from './ets/WindowScene/scene/manager/SCBScenePanelManager2.test';
import { StartAbilityUtilTest } from './ets/WindowScene/startAbility/StartAbilityUtil.test';
import EventExclusiveConfigTest
  from './ets/WindowScene/gesturenavigation/gestureignore/configs/EventExclusiveConfig.test';
import { SCBWindowRotateTest2 } from './ets/WindowScene/scene/session/SCBWindowRotate2.test';
import { SCBWindowRotateTestForPad } from './ets/WindowScene/scene/session/SCBWindowRotateForPad.test';
import {SCBTogManagerTest} from './ets/WindowScene/scene/session/SCBTogManager.test';
import { SCBSplitParamTest } from './ets/WindowScene/scene/session/SCBSplitParam.test';
import { SCBWindowRotateTestForPhone } from './ets/WindowScene/scene/session/SCBWindowRotateForPhone.test';
import { SCBGestureRecordTest } from './ets/WindowScene/scene/session/SCBGestureRecord.test';
import { SCBAppIconTest } from './ets/WindowScene/scene/session/SCBAppIconTest.test';
import { SCBWindowRotateTestForFolder } from './ets/WindowScene/scene/session/SCBWindowRotateForFolder.test';
import { SCBDividerParamTest } from './ets/WindowScene/scene/session/SCBDividerParam.test';
import { SCBFloatingParamTest } from './ets/WindowScene/scene/session/SCBFloatingParam.test';
import PreferenceStoreTest from './ets/WindowScene/db/PreferenceStoreTest.test';
import WindowStyleStoreManagerTest from './ets/WindowScene/db/WindowStyleStoreManagerTest.test';
import EventExclusiveCommanderTest
  from './ets/WindowScene/gesturenavigation/gestureignore/utils/EventExclusiveCommander.test';
import GestureNavigationEventObserverTest
  from './ets/WindowScene/gesturenavigation/GestureNavigationEventObserver.test';
import { SCBAppUseControlManagerTest } from './ets/WindowScene/scene/appUseControl/SCBAppUseControlManager.test';
import { SCBKioskModeManagerTest } from './ets/WindowScene/scene/kiosk/SCBKioskModeManager.test';
import { SCBSceneMissionManagerTest } from './ets/WindowScene/scene/manager/SCBSceneMissionManager.test';
import { SCBWindowRotateControllerTest } from './ets/WindowScene/scene/manager/SCBWindowRotateController.test';
import { SCBSwitchMultiWindowManagerTest } from './ets/WindowScene/scene/manager/SCBSwitchMultiWindowManager.test';
import { StartSceneTemplateTest } from './ets/WindowScene/scene/missiontemplate/StartSceneTemplateTest.test';
import { SCBSceneStartInterceptorTest } from './ets/WindowScene/scene/missions/SCBSceneStartInterceptorTest.test';
import { TerminateSceneTemplateTest } from './ets/WindowScene/scene/missiontemplate/TerminateSceneTemplateTest.test';
import { SCBScenePanelBaseViewModelTest } from './ets/WindowScene/scene/viewmodel/SCBScenePanelBaseViewModelTest';
import { AddOobeTrustListTest } from './ets/WindowScene/oobe/service/impl/AddOobeTrustList.test';
import { BaseOobeServiceTest } from './ets/WindowScene/oobe/service/BaseOobeService.test';
import { BaseServiceStubTest } from './ets/WindowScene/oobe/service/BaseServiceStub.test';
import { OobeTrustListServiceTest } from './ets/WindowScene/oobe/service/OobeTrustListService.test';
import { TrustListOobeManagerTest } from './ets/WindowScene/oobe/trustlist/TrustListOobeManager.test';
import SCBKeyboardManagerTest from './ets/WindowScene/scene/session/SCBKeyboardManager.test'
import { SCBSceneMissionManagerTest } from './ets/manager/SCBSceneMissionManagerTest.test';

export default function WindowSceneSuite() {
  FrameworkTestSuite(); // 合一框架组测试用例
  RecentTestSuite(); // 桌面多任务测试用例
  WindowSceneTestSuite();
  GestureNavigationTestSuite(); // 桌面导航测试用例
  UtilsTestSuite();
}

export function FrameworkTestSuite() {
  ResUtilsTest();
  DisplayManagerTest();
}

export function RecentTestSuite() {
  RecentFsmTest();
  AnimateExTest();
  ChainAnimationTest();
  SpringMotionTest();
  SpringModelTest();
  RecentViewParamTest();
  UIExceptionDetectionTest();
}

export function WindowSceneTestSuite() {
  SCBSceneContainerSessionArrayTest();
  SCBScreenSessionTest();
  SCBTransitionManagerTest();
  BaseAnimationTest();
  SCBCompanionManagerTest();
  WindowAnimationUtilsTest();
  WindowAnimationTest();
  SCBSceneContainerSessionTest();
  SCBSceneContainerSessionTest2();
  SCBRootSceneSessionTest();
  SCBSceneInfoTest();
  SCBWindowRotateTest();
  SCBSceneOrientationPolicyTest();
  SCBDeviceScreenConfigTest();
  SCBSceneSessionTest();
  SCBRecentSessionInfoTest();
  SCBScenePersistentTest();
  SCBSceneSessionManagerOneTest();
  SCBSceneSessionManagerFourTest();
  SCBSceneSessionManagerFiveTest();
  SCBSceneSessionManagerTest2();
  SCBSceneSessionManagerTest3();
  SCBSceneSessionManagerTest6();
  SCBSceneSessionManagerTest7();
  SCBSceneSessionManagerTest8();
  SCBSystemSceneSessionTest();
  SCBSpecificSessionTest();
  SCBScreenSessionManagerTest();
  SCBRecoverManagerTest();
  SCBSessionRectTest();
  SCBDebugUtilsTest();
  SCBScenePanelDebugCommandsTest();
  SCBSceneContainerSessionDebugCommandsTest();
  SCBSceneSessionDebugCommandsTest();
  SCBScreenDebugCommandsTest();
  SCBSpecialScenePanelDebugCommandsTest();
  SCBSpecificScenePanelDebugCommandsTest();
  SCBSpecificSessionDebugCommandsTest();
  SCBKeyboardPanelSessionTest();
  WindowManagerProxyTest();
  SCBScenePanelManagerTest();
  SCBScenePanelManagerTwoTest();
  StartAbilityUtilTest();
  SCBKeyboardSessionTest();
  SCBKeyboardManagerTest();
  SCBWindowRotateTest2();
  SCBWindowRotateTestForPad();
  SCBTogManagerTest();
  SCBWindowRotateTestForPhone();
  SCBDividerParamTest();
  SCBWindowRotateTestForFolder();
  SCBFloatingParamTest();
  SCBSplitParamTest();
  SCBGestureRecordTest();
  SCBAppIconTest();
  PreferenceStoreTest();
  WindowStyleStoreManagerTest();
  SCBAppUseControlManagerTest();
  SCBKioskModeManagerTest();
  SCBSceneMissionManagerTest();
  SCBWindowRotateControllerTest();
  SCBSwitchMultiWindowManagerTest();
  StartSceneTemplateTest();
  SCBSceneStartInterceptorTest();
  TerminateSceneTemplateTest();
  SCBScenePanelBaseViewModelTest();
  AddOobeTrustListTest();
  BaseOobeServiceTest();
  BaseServiceStubTest();
  OobeTrustListServiceTest();
  TrustListOobeManagerTest();
}

export function GestureNavigationTestSuite() {
  SCBGestureManagerTest();
  SCBEventExclusiveManagerTest()
  SendTouchEventControllerTest();
  SendClickEventControllerTest();
  EventExclusiveConfigTest();
  EventExclusiveCommanderTest();
  GestureNavigationEventObserverTest();
}

export function UtilsTestSuite() {
  SCBSceneWindowAiSplitSwitchTest();
}

export function WindowSceneMissionTestSuite() {
  SCBSceneMissionManagerTest();
}