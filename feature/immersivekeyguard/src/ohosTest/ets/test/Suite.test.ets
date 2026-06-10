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
import { ImmersiveKeyguardTest } from './ets/immersivekeyguard.test';
import { ImmersiveListVmTest } from './ets/viewmodel/ImmersiveListVm.test';
import { ImmersiveAnimManagerTest } from './ets/viewmodel/viewanim/ImmersiveAnimManager.test';
import { ImmersiveListAnimManagerTest } from './ets/viewmodel/viewanim/ImmersiveListAnimManager.test';
import { ImmersiveCapsuleConstantsTest } from './ets/common/constants/ImmersiveCapsuleConstants.test';
import { ImmersiveConstantsTest } from './ets/common/ImmersiveConstants.test';
import { ImmersiveSysEventUtilTest } from './ets/common/ImmersiveSysEventUtil.test';
import { ImmersiveAnimParamTest } from './ets/common/anim/ImmersiveAnimParam.test';
import { ImmersiveAnimUnitTest } from './ets/common/anim/ImmersiveAnimUnit.test';
import { KeyGuardNtfControllerTest } from './ets/common/KeyGuardNtfController.test';
import { ImmersiveCardVmTest } from './ets/viewmodel/ImmersiveCardVm.test';
import { ImmersiveCardDataTest } from './ets/viewmodel/viewdata/ImmersiveCardData.test';
import { ImmersiveAppNameHelperTest } from './ets/common/helper/ImmersiveAppNameHelper.test';
import { ImmersiveAppIconHelperTest } from './ets/common/helper/ImmersiveAppIconHelper.test';
import { ImmersiveTraceHelperTest } from './ets/common/helper/ImmersiveTraceHelper.test';
import { ImmersiveStateHelperTest } from './ets/common/helper/ImmersiveStateHelper.test';
import { ImmersiveMultiDeviceHelperTest } from './ets/common/helper/ImmersiveMultiDeviceHelper.test';
import { ImmersiveVmTest } from './ets/viewmodel/ImmersiveVm.test';
import { ImmersiveCapsuleVmTest } from './ets/viewmodel/ImmersiveCapsuleVm.test';
import { ImmersiveDataPreProcessorTest } from './ets/viewmodel/viewdata/ImmersiveDataPreProcessor.test';
import { ImmersiveDataGroupPackerTest } from './ets/viewmodel/viewdata/ImmersiveDataGroupPacker.test';
import { ImmersiveDefaultCardDataHelperTest } from './ets/viewmodel/viewdata/ImmersiveDefaultCardDataHelper.test';
import { ImmersiveCardListTest } from './ets/viewmodel/viewdata/ImmersiveCardList.test';
import { ImmersiveCapsuleSceneHelperTest } from './ets/viewmodel/viewdata/ImmersiveCapsuleSceneHelper.test';
import { SlClockAnimManagerTest } from './ets/viewmodel/viewanim/SlClockAnimManager.test';
import { ImmersiveCapsuleDataTest } from './ets/viewmodel/viewdata/ImmersiveCapsuleData.test';
import { ImmersiveCapsuleListTest } from './ets/viewmodel/viewdata/ImmersiveCapsuleList.test';
import { ImmersiveStateManagerTest } from './ets/common/manager/ImmersiveStateManager.test';
import { ImmersiveAnimInfoTest } from './ets/model/data/anim/ImmersiveAnimInfo.test';
import { ImmersiveCardStyleTest } from './ets/model/data/ImmersiveCardStyle.test';
import { ImmersiveCapsuleStyleTest } from './ets/model/data/ImmersiveCapsuleStyle.test';
import { ImmersiveCapsuleAnimManagerTest } from './ets/viewmodel/viewanim/ImmersiveCapsuleAnimManager.test';
import { ImmersiveCardAnimManagerTest } from './ets/viewmodel/viewanim/ImmersiveCardAnimManager.test';
import { ImmersiveAnimStateManagerTest } from './ets/viewmodel/viewanim/ImmersiveAnimStateManager.test';
import { ImmersiveBaseAnimTest } from './ets/common/anim/ImmersiveBaseAnim.test';
import { ImmersiveSerialAnimTest } from './ets/common/anim/ImmersiveSerialAnim.test';
import { ImmersiveFingerControllTest } from './ets/model/service/ImmersiveFingerControll.test';
import { ImmersiveNtfAdapterTest } from './ets/model/service/ImmersiveNtfAdapter.test';
import { ImmersiveKgParserControllerTest } from './ets/model/service/ImmersiveKgParserController.test';
import { ImmersiveCapsuleHandleTest } from './ets/viewmodel/viewevent/ImmersiveCapsuleHandle.test';
import { ImmersiveCardHandleTest } from './ets/viewmodel/viewevent/ImmersiveCardHandle.test';
import { ImmersiveListHandleTest } from './ets/viewmodel/viewevent/ImmersiveListHandle.test';
import { ImmersiveNormalCapsuleDataTest } from './ets/viewmodel/viewdata/ImmersiveNormalCapsuleData.test';
import { ImmersiveNtfDataTest } from './ets/viewmodel/viewdata/ImmersiveNtfData.test';
import { ImmersivePanelStateTest } from './ets/viewmodel/viewdata/ImmersivePanelState.test';
import { ImmersiveKgDataTest } from './ets/viewmodel/viewdata/ImmersiveKgData.test';
import { ImmersiveMeshManagerTest } from './ets/viewmodel/viewlayout/ImmersiveMeshManager.test';
import { ImmersiveNtfSceneHelperTest } from './ets/viewmodel/viewdata/ImmersiveNtfSceneHelper.test';
import { SlListStaticStateTest } from './ets/model/data/SlListStaticState.test';
import { SlCapStaticStateTest } from './ets/model/data/SlCapStaticState.test';
import { SlCardStaticStateTest } from './ets/model/data/SlCardStaticState.test';
import { SlListWidgetBindStateTest } from './ets/model/data/SlListWidgetBindState.test';
import { SlCapWidgetBindStateTest } from './ets/model/data/SlCapWidgetBindState.test';
import { SlCardWidgetBindStateTest } from './ets/model/data/SlCardWidgetBindState.test';
import { NtfListStateTest } from './ets/viewmodel/viewdata/NtfListState.test';
import { ImmersiveLiveAnimManagerTest } from './ets/viewmodel/viewanim/ImmersiveLiveAnimManager.test';
import CardCapsuleAnimExecutorTest from './ets/viewmodel/viewanim/executor/CardCapsuleAnimExecutor.test';
import ListCardAnimExecutorTest from './ets/viewmodel/viewanim/executor/ListCardAnimExecutor.test';
import { ImmersiveAnimConstantsTest } from './ets/common/anim/ImmersiveAnimConstants.test';
import { CapsuleLayoutStyleTest } from './ets/common/constants/CapsuleLayoutStyle.test';
import { ImmersiveCardConstTest } from './ets/common/constants/ImmersiveCardConst.test';
import { ImmersiveAnimStyleTest } from './ets/model/data/anim/ImmersiveAnimStyle.test';
import { ImmersiveExtendStyleTest } from './ets/model/data/ImmersiveExtendStyle.test';
import { UIExtentionLoadingStateMgrTest } from './ets/model/manager/UIExtentionLoadingStateMgr.test';

export default function PipelineDemoSuite() {
  describe("ImmersiveKeyguard", () => {
    ImmersiveDataPreProcessorTest();
    ImmersiveDataGroupPackerTest();
    ImmersiveDefaultCardDataHelperTest();
    ImmersiveCardDataTest();
    ImmersiveCardListTest();
    ImmersiveCapsuleSceneHelperTest();
    ImmersiveKeyguardTest();
    ImmersiveListVmTest();
    ImmersiveAnimManagerTest();
    ImmersiveListAnimManagerTest();
    ImmersiveCapsuleConstantsTest();
    ImmersiveConstantsTest();
    ImmersiveSysEventUtilTest();
    ImmersiveAnimParamTest();
    ImmersiveAnimUnitTest();
    KeyGuardNtfControllerTest();
    ImmersiveCardVmTest();
    ImmersiveAppIconHelperTest();
    ImmersiveAppNameHelperTest();
    ImmersiveMultiDeviceHelperTest();
    ImmersiveTraceHelperTest();
    ImmersiveStateHelperTest();
    ImmersiveCapsuleVmTest();
    ImmersiveVmTest();
    SlClockAnimManagerTest();
    ImmersiveCapsuleDataTest();
    ImmersiveCapsuleListTest();
    ImmersiveStateManagerTest();
    ImmersiveAnimInfoTest();
    ImmersiveCapsuleStyleTest();
    ImmersiveCardStyleTest();
    ImmersiveCapsuleAnimManagerTest();
    ImmersiveCardAnimManagerTest();
    ImmersiveAnimStateManagerTest();
    ImmersiveBaseAnimTest();
    ImmersiveSerialAnimTest();
    ImmersiveFingerControllTest();
    ImmersiveNtfAdapterTest();
    ImmersiveKgParserControllerTest();
    ImmersiveCapsuleHandleTest();
    ImmersiveCardHandleTest();
    ImmersiveListHandleTest();
    ImmersiveNormalCapsuleDataTest();
    ImmersiveNtfDataTest();
    ImmersivePanelStateTest();
    ImmersiveKgDataTest();
    ImmersiveMeshManagerTest();
    ImmersiveNtfSceneHelperTest();
    SlListStaticStateTest();
    SlCapStaticStateTest();
    SlCardStaticStateTest();
    SlListWidgetBindStateTest();
    SlCapWidgetBindStateTest();
    SlCardWidgetBindStateTest();
    NtfListStateTest();
    ImmersiveLiveAnimManagerTest();
    CardCapsuleAnimExecutorTest();
    ListCardAnimExecutorTest();
    ImmersiveAnimConstantsTest();
    CapsuleLayoutStyleTest();
    ImmersiveCardConstTest()
    ImmersiveAnimStyleTest();
    ImmersiveExtendStyleTest();
    UIExtentionLoadingStateMgrTest();
  });
}