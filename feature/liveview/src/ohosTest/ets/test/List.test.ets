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
import { LiveViewVmTest, LiveViewVmTest2 } from './ets/vm/LiveViewVm.test';
import { LiveViewStateMgrTest } from './ets/common/LiveViewStateManager.test';
import { LiveListStateMgrTest } from './ets/common/LiveListStateManager.test';
import { LiveListStateTest } from './ets/info/LiveListState.test';
import {
  LiveViewAnimManagerTest,
  LiveViewAnimManagerTest2,
  LiveViewAnimManagerTest3,
  LiveViewAnimManagerTest4,
  LiveViewAnimManagerTest5,
  LiveViewAnimManagerTest7
} from './ets/anim/LiveViewAnimManager.test';
import { LiveCapsuleAnimMgrTest } from './ets/anim/LiveCapsuleAnimMgr.test';
import { LiveViewItemSwipeVmTest01, LiveViewItemSwipeVmTest02 } from './ets/vm/LiveViewItemSwipeVm.test'
import CapsuleLifecycleVmTest from './ets/vm/CapsuleLifecycleVm.test'
import LiveAnimParamTest from './ets/info/LiveAnimParam.test'
import LiveViewUtilTest from './ets/common/LiveViewUtil.test'
import LiveSysTimerManagerTest from './ets/common/LiveSysTimerManager.test'
import LiveListAnimMgrTest from './ets/anim/LiveListAnimMgr.test'
import CapsuleAnimVmTest from './ets/vm/CapsuleAnimVm.test';
import { BannerLiveAnimHelperTest01, BannerLiveAnimHelperTest02 } from './ets/anim/helper/BannerLiveAnimHelper.test';

/**
 * 实况feature模块测试用例
 */
export default function LiveViewTestSuite() {
  LiveViewVmTest();
  LiveViewVmTest2();
  LiveViewStateMgrTest();
  LiveListStateMgrTest();
  LiveListStateTest();
  LiveViewAnimManagerTest();
  LiveViewAnimManagerTest2();
  LiveViewAnimManagerTest3();
  LiveViewAnimManagerTest4();
  LiveViewAnimManagerTest5();
  LiveViewAnimManagerTest7();
  LiveCapsuleAnimMgrTest();
  LiveListAnimMgrTest();
  LiveSysTimerManagerTest();
  LiveViewUtilTest();
  LiveAnimParamTest();
  CapsuleLifecycleVmTest();
  LiveViewItemSwipeVmTest01();
  LiveViewItemSwipeVmTest02();
  CapsuleAnimVmTest();
  BannerLiveAnimHelperTest01();
  BannerLiveAnimHelperTest02();
}