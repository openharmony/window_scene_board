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
import ThreeFingerSwipeEventTest from './ets/common/ThreeFingerSwipeEvent.test';
import AccountsViewModelTest from './ets/SceneBoard/screenlock/AccountsViewModel.test';
import SpecialModeViewModelTest from './ets/SceneBoard/screenlock/specialmode/SpecialModeViewModel.test';
import SpecialModeViewDataTest from './ets/SceneBoard/screenlock/specialmode/model/SpecialModeViewDataTest.test';
import AccountsModelTest from './ets/SceneBoard/screenlock/AccountsModelTest.test';
import ScreenlockEventMonitorTest from './ets/SceneBoard/screenlock/ScreenlockEventMonitorTest.test';
import privacySpaceManagerTest from './ets/SceneBoard/screenlock/privacySpaceManagerTest.test';
import ScreenLockModelTest from './ets/SceneBoard/screenlock/ScreenLockModelTest.test';
import ScreenLockMediator from './ets/SceneBoard/screenlock/ScreenLockMediator.test';
import SlideScreenLockViewModelTest from './ets/SceneBoard/screenlock/SlideScreenLockViewModel.test';
import InputMethodPanelViewModelTest from "./ets/SceneBoard/inputmethodpanel/viewmodel/inputMethodPanelViewModel.test";
import BrightnessManagerTest from './ets/SceneBoard/brightnesspanel/common/BrightnessManager.test'
import AudioSoundModelTest from './ets/SceneBoard/soundpanel/model/AudioSoundModel.test';
import InputMethodModelTest from './ets/SceneBoard/inputmethodpanel/model/InputMethodModel.test';
import CustomizePromptViewModelTest from './ets/SceneBoard/screenlock/CustomizePromptViewModel.test';
import PasswordComplexityUtilTest from './ets/SceneBoard/screenlock/PasswordComplexityUtil.test';
import PinExpiryMsgControllerTest from './ets/SceneBoard/screenlock/PinExpiryMsgController.test';
import PasswordComplexityViewModelTest from './ets/SceneBoard/screenlock/PasswordComplexityViewModel.test';
import PasswordViewModelTest from './ets/SceneBoard/screenlock/PasswordViewModelTest.test';
import MicrophonePanelModelTest from './ets/SceneBoard/microphonePanel/model/MicrophonePanelModelTest';
import VolumeViewModelTest from './ets/SceneBoard/controlpanel/volumeslider/VolumeViewModel.test';
import AudioPlayerNewHelperTest from './ets/SceneBoard/soundpanel/util/AudioPlayerNewHelper.test';
import StatusBarResourceUtilsTest from './ets/common/utils/StatusBarResourceUtils.test';
import PCUtilsTest from './ets/common/utils/PCUtils.test';
import AnimationControllerTest from './ets/SceneBoard/control/animationcontroller/AnimationController.test';
import PcLayoutRulesControllerTest from './ets/SceneBoard/control/SceneDesktopController/PcLayoutRulesController.test';
import PinExpiryNotificationControllerTest
  from './ets/SceneBoard/control/SceneDesktopController/PinExpiryNotificationController.test';
import StatusBarResourceOneUtilsTest from './ets/common/utils/StatusBarResourceOneUtils.test';
import StatusBarResourceTwoUtilsTest from './ets/common/utils/StatusBarResourceTwoUtils.test';
import VolumeModelTest from './ets/SceneBoard/controlpanel/VolumeModel.test';
import PCToolUtilsTest from './ets/common/utils/PCToolUtils.test';
import FingerprintViewModelTest from './ets/SceneBoard/screenlock/FingerprintViewModelTest.test';
import LockScreenBaseTest from './ets/SceneBoard/screenlock/LockScreenBaseTest.test';
import PcSmartDockTestSuite from '@ohos/pcsmartdock/src/ohosTest/ets/test/List.test';
import DesktopFileTestSuite from '@ohos/pcbase/src/ohosTest/ets/test/List.test'
import { AppListPresenterTest } from './ets/appcenter/common/AppListPresenterTest.test';
import AppCenterDragMgrTest from './ets/appcenter/controller/AppCenterDragMgr.test';
import AppGridPresenterTest from './ets/appcenter/common/AppGridPresenter.test';
import AppCenterSceneAnimationControllerTest from './ets/appcenter/common/AppCenterSceneAnimationController.test';
import AppCenterGridStyleConfigTest from './ets/appcenter/common/AppCenterGridStyleConfig.test';
import AcDragStatusMgrTest from './ets/appcenter/common/AcDragStatusMgr.test';
import AppGridLayoutCacheManagerTest from './ets/appcenter/common/AppGridLayoutCacheManager.test';
import FoldedAppGridLayoutUtilityTest from './ets/appcenter/common/FoldedAppGridLayoutUtility.test';
import AppGridLayoutUtilTest from './ets/appcenter/common/AppGridLayoutUtil.test';
import AppCenterIconMenuVmTest from './ets/appcenter/vm/AppCenterIconMenuVm.test';
import FoldedDeviceAcViewModelTest from './ets/appcenter/common/FoldedDeviceAcViewModel.test';
import FoldedAcDragMgrTest from './ets/appcenter/common/FoldedAcDragMgr.test';
import FoldSwiperControllerTest from './ets/appcenter/common/FoldSwiperController.test';
import AppCenterViewModelTest from './ets/appcenter/common/AppCenterViewModel.test';
import regionFolderTestSuite from '../../../../../../feature/desktop/regionfolder/src/ohosTest/ets/test/List.test';
import SCBFoldSceneManagerTest from './ets/SceneBoard/scenemanager/fold/SCBFoldSceneManagerTest.test'

export default function testsuite() {
  SlideScreenLockViewModelTest();
  AccountsViewModelTest();
  SpecialModeViewModelTest();
  SpecialModeViewDataTest();
  AccountsModelTest();
  ScreenlockEventMonitorTest();
  privacySpaceManagerTest();
  ScreenLockModelTest();
  ScreenLockMediator();
  InputMethodPanelViewModelTest();
  ThreeFingerSwipeEventTest();
  //控制中心亮度调节用例
  BrightnessManagerTest();
  AudioSoundModelTest();
  MicrophonePanelModelTest();
  InputMethodModelTest();
  CustomizePromptViewModelTest();
  PasswordComplexityUtilTest();
  PinExpiryMsgControllerTest();
  PasswordComplexityViewModelTest();
  PasswordViewModelTest();
  VolumeViewModelTest();
  VolumeModelTest();
  AudioPlayerNewHelperTest();
  StatusBarResourceUtilsTest();
  StatusBarResourceOneUtilsTest();
  StatusBarResourceTwoUtilsTest();
  PCUtilsTest();
  PCToolUtilsTest();
  AnimationControllerTest();
  PcLayoutRulesControllerTest();
  PinExpiryNotificationControllerTest();
  FingerprintViewModelTest();
  LockScreenBaseTest();
  PcSmartDockTestSuite();
  DesktopFileTestSuite();
  AppListPresenterTest();
  AppCenterDragMgrTest();
  AppGridPresenterTest();
  AppCenterSceneAnimationControllerTest();
  AppCenterGridStyleConfigTest();
  AcDragStatusMgrTest();
  AppGridLayoutCacheManagerTest();
  FoldedAppGridLayoutUtilityTest();
  AppGridLayoutUtilTest();
  AppCenterIconMenuVmTest();
  FoldedDeviceAcViewModelTest();
  FoldedAcDragMgrTest();
  FoldSwiperControllerTest();
  AppCenterViewModelTest();
  regionFolderTestSuite();
  SCBFoldSceneManagerTest();
}

