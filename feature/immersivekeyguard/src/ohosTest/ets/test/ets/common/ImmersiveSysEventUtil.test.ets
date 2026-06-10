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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level } from '@ohos/hypium';
import { LiveViewData } from '@ohos/systemuicommon';
import {
  ImmersiveSysEventUtil,
  ImmersiveReportParams,
  StatusParams,
  ToggleWay,
  Lifecycle
} from '../../../../../main/ets/common/ImmersiveSysEventUtil';
import { ImmersiveNtfData } from '../../../../../main/ets/viewmodel/viewdata/ImmersiveNtfData';

export function ImmersiveSysEventUtilTest() {
  describe('ImmersiveSysEventUtilTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('ImmersiveSysEventUtil_CONSTANTS', Level.LEVEL1, (): void => {
      expect(ImmersiveSysEventUtil.ITEM_SEPARATOR).not().assertNull();
      expect(ImmersiveSysEventUtil.IMMERSIVE_LIFECYCLE).not().assertNull();
      expect(ImmersiveSysEventUtil.TOGGLE_STATUS).not().assertNull();
      expect(ImmersiveSysEventUtil.SLIDE_TO_UNLOCK).not().assertNull();
    });

    it('ImmersiveSysEventUtil_reportImmersiveEvent', Level.LEVEL1, (): void => {
      let params: ImmersiveReportParams = {
        PNAMEID: 'test', PVERSIONID: 'test', USER_PACKAGE_NAME: 'test', NOTIFICATION_ID: 'test', LIVE_TEMPLATE_TYPE: 2,
        CURRENT_STATUS: 1, OLD_STATUS: 1, NEW_STATUS: 2, HANDOVER_TYPE: 3, OPERATION: 4, REASON: 5
      };
      ImmersiveSysEventUtil.reportImmersiveEvent('test', params);
      expect(ImmersiveSysEventUtil.ITEM_SEPARATOR).not().assertNull();
    });

    it('ImmersiveSysEventUtil_reportImmersiveCycleEvent', Level.LEVEL1, (): void => {
      ImmersiveSysEventUtil.reportImmersiveCycleEvent();
      let data: LiveViewData = new LiveViewData();
      data.creatorBundleName = 'test';
      data.id = 123;
      ImmersiveSysEventUtil.reportImmersiveCycleEvent(data, 2);
      expect(ImmersiveSysEventUtil.ITEM_SEPARATOR).not().assertNull();
    });

    it('ImmersiveSysEventUtil_reportNotifyLifeCycleEvent', Level.LEVEL1, (): void => {
      ImmersiveSysEventUtil.reportNotifyLifeCycleEvent();
      let data: ImmersiveNtfData = new ImmersiveNtfData();
      data.creatorBundleName = 'test';
      data.id = 123;
      ImmersiveSysEventUtil.reportNotifyLifeCycleEvent(data, 2);
      expect(ImmersiveSysEventUtil.ITEM_SEPARATOR).not().assertNull();
    });

    it('ImmersiveSysEventUtil_reportToggleStatusEvent', Level.LEVEL1, (): void => {
      let data: ImmersiveNtfData = new ImmersiveNtfData();
      data.creatorBundleName = 'test';
      data.id = 123;
      ImmersiveSysEventUtil.reportToggleStatusEvent(data, 2, 1, 2);
      expect(ImmersiveSysEventUtil.ITEM_SEPARATOR).not().assertNull();
    });

    it('ImmersiveSysEventUtil_reportListToCapEvent', Level.LEVEL1, (): void => {
      ImmersiveSysEventUtil.reportListToCapEvent(2, 1, 2);
      expect(ImmersiveSysEventUtil.ITEM_SEPARATOR).not().assertNull();
    });

    it('ImmersiveSysEventUtil_reportListToCapsuleEvent', Level.LEVEL1, (): void => {
      let data: ImmersiveNtfData = new ImmersiveNtfData();
      data.creatorBundleName = 'test';
      data.id = 123;
      ImmersiveSysEventUtil.reportListToCapsuleEvent(undefined);
      ImmersiveSysEventUtil.reportListToCapsuleEvent(data);
      expect(ImmersiveSysEventUtil.ITEM_SEPARATOR).not().assertNull();
    });

    it('ImmersiveSysEventUtil_reportExitToCapsuleEvent', Level.LEVEL1, (): void => {
      let data: ImmersiveNtfData = new ImmersiveNtfData();
      data.creatorBundleName = 'test';
      data.id = 123;
      ImmersiveSysEventUtil.reportExitToCapsuleEvent(undefined);
      ImmersiveSysEventUtil.reportExitToCapsuleEvent(data);
      expect(ImmersiveSysEventUtil.ITEM_SEPARATOR).not().assertNull();
    });

    it('ImmersiveSysEventUtil_reportExitToListEvent', Level.LEVEL1, (): void => {
      let data: ImmersiveNtfData = new ImmersiveNtfData();
      data.creatorBundleName = 'test';
      data.id = 123;
      ImmersiveSysEventUtil.reportExitToListEvent(data);
      expect(ImmersiveSysEventUtil.ITEM_SEPARATOR).not().assertNull();
    });

    it('ImmersiveSysEventUtil_reportListAtEndUnlockEvent', Level.LEVEL1, (): void => {
      ImmersiveSysEventUtil.reportListAtEndUnlockEvent(1);
      expect(ImmersiveSysEventUtil.ITEM_SEPARATOR).not().assertNull();
    });

    it('ImmersiveSysEventUtil_reportEnterCpuMemEvent', Level.LEVEL1, (): void => {
      ImmersiveSysEventUtil.reportEnterCpuMemEvent();
      expect(ImmersiveSysEventUtil.ITEM_SEPARATOR).not().assertNull();
    });

    it('ImmersiveSysEventUtil_reportExitCpuMemEvent', Level.LEVEL1, (): void => {
      ImmersiveSysEventUtil.reportExitCpuMemEvent();
      expect(ImmersiveSysEventUtil.ITEM_SEPARATOR).not().assertNull();
    });

    it('StatusParams_CONSTANTS', Level.LEVEL1, (): void => {
      expect(StatusParams.CAPSULE).not().assertNull();
      expect(StatusParams.LIST).not().assertNull();
      expect(StatusParams.IMMERSIVE).not().assertNull();
    });

    it('ToggleWay_CONSTANTS', Level.LEVEL1, (): void => {
      expect(ToggleWay.CLICK).not().assertNull();
      expect(ToggleWay.LONG_CLICK).not().assertNull();
      expect(ToggleWay.DOWN).not().assertNull();
      expect(ToggleWay.UP).not().assertNull();
      expect(ToggleWay.BACK).not().assertNull();
      expect(ToggleWay.BLANK).not().assertNull();
    });

    it('Lifecycle_CONSTANTS', Level.LEVEL1, (): void => {
      expect(Lifecycle.CREATE).not().assertNull();
      expect(Lifecycle.UPDATE).not().assertNull();
      expect(Lifecycle.DELETE).not().assertNull();
    });
  });
}