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
import {
  AnimDataScene,
  AnimValue,
  bannerMgr,
  BannerPanelType,
  CapsuleListState,
  capsuleStateMgr,
  ComponentAnimState,
  DefaultPanelZIndex,
  LiveAnimScene,
  LiveUseScene,
  LiveViewDataArray,
  PropertyType
} from '@ohos/systemuicommon';
import {
  DomainName,
  LogDomain,
  LogHelper,
  TraceUtil
} from '@ohos/basicutils';
import {
  CustomPromise,
  DeviceHelper,
  ViewManagerPolicy,
  viewMgrPolicy,
  ViewType
} from '@ohos/frameworkwrapper';
import { CapsuleAnimVm } from '../../../main/ets/vm/CapsuleAnimVm';
import { liveCapsuleVm } from '../../../main/ets/vm/LiveViewVm';
import { LiveCapsuleAnimMgr } from '../../../main/ets/anim/LiveCapsuleAnimMgr';
import { LiveListAnimMgr, LiveListAnimStatus } from '../../../main/ets/anim/LiveListAnimMgr';
import { BannerLiveAnimHelper } from '../../../main/ets/anim/helper/BannerLiveAnimHelper';
import { LiveViewConstants } from '../../../main/ets/common/LiveViewConstants';
import { performanceMonitor } from '@kit.ArkUI';
import { OhterCardExtendAnimVm, ProgressCardAnimVm } from '@ohos/systemuicommon/Index';
import { screenLock } from '@kit.BasicServicesKit';
import { LiveViewItemSwipeVm } from '../../../main/ets/vm/LiveViewItemSwipeVm';
import { SystemUIStatusBarVm } from '@ohos/systemuicommon/Index';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { LiveViewAnimManager } from '../../../main/ets/anim/LiveViewAnimManager';
export default function LiveViewAnimManagerTest() {
  describe('getBannerListItemAnimState_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_return_state_when_itemAnimStateMap_has_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode";
      let state: ComponentAnimState = new ComponentAnimState(hashCode);
      liveListMgr.itemAnimStateMap.set(hashCode, state);
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertEqual(state);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });
    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });
    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });
    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });
    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });
    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });

    it('should_create_and_return_state_when_itemAnimStateMap_does_not_have_hashCode', 0, () => {
      let liveviewanimmanager: LiveViewAnimManager = new LiveViewAnimManager();
      let liveListMgr: LiveListAnimMgr = liveviewanimmanager.liveListMgr;
      let hashCode: string = "testHashCode2";
      let result = liveviewanimmanager.getBannerListItemAnimState(hashCode);
      expect(result).assertInstanceOf(ComponentAnimState);
      expect(result.hashCode).assertEqual(hashCode);
      expect(liveListMgr.itemAnimStateMap.get(hashCode)).assertEqual(result);
    });
  });
}