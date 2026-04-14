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
import SuggestMenuModelTest from './default/model/SuggestMenuModel.test'
import PcSmartDockModelTest from './default/model/PcSmartDockModel.test'
import PcDockAnimationMgrTest from './default/manager/PcDockAnimationMgr.test'
import PcDockHiSysEventMgrTest from './default/manager/PcDockHiSysEventMgr.test'
import PcDockPopupMgrTest from './default/manager/PcDockPopupMgr.test'
import PcDockRecentProxyTest from './default/manager/PcDockRecentProxy.test'
import PcTouchOutSideMgrTest from './default/manager/PcTouchOutSideMgr.test'
import SmartDockViewModelTest from './default/viewModel/SmartDockViewModel.test'

export default function PcSmartDockTestSuite() {
  PcSmartDockModelTest();
  SuggestMenuModelTest();
  PcDockAnimationMgrTest();
  PcDockHiSysEventMgrTest();
  PcDockPopupMgrTest();
  PcDockRecentProxyTest();
  PcFoldDockPosMgrTest()
  PcTouchOutSideMgrTest();
  SmartDockViewModelTest()
}