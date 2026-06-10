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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import Want from '@ohos.app.ability.Want';
import { CapsulePositionType } from '../../../main/ets/common/ImmersiveConstants';
import { ImmersiveCapsuleVm } from '../../../main/ets/viewmodel/ImmersiveCapsuleVm';
import { immersiveVm } from '../../../main/ets/viewmodel/ImmersiveVm';
import {
  ImmersiveCardState,
  KeyGuardCapsuleState,
  KeyGuardListState,
  ImmersiveWidthState,
  immersiveStateMgr
} from '../../../main/ets/common/manager/ImmersiveStateManager';
import { ImmersiveDataGroupPacker } from '../../../main/ets/viewmodel/viewdata/ImmersiveDataGroupProcessor';
import { ImmersiveNtfData } from '../../../main/ets/viewmodel/viewdata/ImmersiveNtfData';
import { ImmersiveCapsuleList } from '../../../main/ets/viewmodel/viewdata/ImmersiveCapsuleList';
import { ImmersiveCardData } from '../../../main/ets/viewmodel/viewdata/ImmersiveCardData';
import {
  LiveType,
} from '@ohos/systemuicommon/src/main/ets/TsIndex';

/**
 * 沉浸式锁屏测试用例
 */
export function ImmersiveCapsuleVmTest1() {
  describe('ImmersiveCapsuleVmTest1', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterAll((): void => {
    });

    afterEach((): void => {
    });

    let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
    immersiveNtfData.hashCode = 'fd';
    immersiveNtfData.groupKey = 'grouptest1';
    immersiveNtfData.creatorBundleName = 'mytest1.com';
    immersiveNtfData.appName = 'myapp';
    immersiveNtfData.id = 10000;
    let ntfDatas: ImmersiveNtfData[] = [];
    ntfDatas.push(immersiveNtfData);

    it('testGetRootUiStyle1_0001', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.hashCode = 'myHashCode11';
      immersiveNtfData.id = 100000;
      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_CONTENT, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      let res = capsuleVm.getRootUiStyle();
      res?.onLongClick?.();
      res?.onIconClick?.();
      res?.onClick?.();
      expect(res).not().assertNull();
    });

    it('testGetRemindData_0001', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      let tmpList = new ImmersiveCapsuleList();
      tmpList.setCapsuleData(CapsulePositionType.TYPE_SHADOW, immersiveNtfData);
      (capsuleVm as object)['tmpList'] = tmpList;
      capsuleVm.checkAndUpdateUiData(true);

      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_REMIND, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      capsuleVm.checkAndUpdateUiData(true);
      capsuleVm.checkAndUpdateUiData(false);
      (capsuleVm as object)['getRemindData']();
      (groupPacker as object)['groupList'] = undefined;
      (capsuleVm as object)['getRemindData']();
    });

    it('testOnImmersiveStateChange_0001', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let cardState = new ImmersiveCardState();
      let capsuleState = new KeyGuardCapsuleState();
      let listState = new KeyGuardListState();
      let widthState = new ImmersiveWidthState();
      (capsuleVm as object)['onImmersiveStateChange'](cardState);
      (capsuleVm as object)['onImmersiveStateChange'](capsuleState);
      (capsuleVm as object)['onImmersiveStateChange'](listState);
      (capsuleVm as object)['onImmersiveStateChange'](widthState);
    });

    it('testClearRemindState_0001', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['clearRemindState']();
    });

    it('testProcessCapsuleRemind_0001', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['processCapsuleRemind']();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      (capsuleVm as object)['processCapsuleRemind']();
    });

    it('testClearRemindTask_0001', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['remindTaskId'] = setTimeout(() => {
        (capsuleVm as object)['ClearRemindTask']();
      }, 20);
    });

    it('testGetRootUiStyle1_0002', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.hashCode = 'myHashCode11';
      immersiveNtfData.id = 100000;
      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_CONTENT, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      let res = capsuleVm.getRootUiStyle();
      res?.onLongClick?.();
      res?.onIconClick?.();
      res?.onClick?.();
      expect(res).not().assertNull();
    });

    it('testGetRemindData_0002', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      let tmpList = new ImmersiveCapsuleList();
      tmpList.setCapsuleData(CapsulePositionType.TYPE_SHADOW, immersiveNtfData);
      (capsuleVm as object)['tmpList'] = tmpList;
      capsuleVm.checkAndUpdateUiData(true);

      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_REMIND, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      capsuleVm.checkAndUpdateUiData(true);
      capsuleVm.checkAndUpdateUiData(false);
      (capsuleVm as object)['getRemindData']();
      (groupPacker as object)['groupList'] = undefined;
      (capsuleVm as object)['getRemindData']();
    });

    it('testOnImmersiveStateChange_0002', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let cardState = new ImmersiveCardState();
      let capsuleState = new KeyGuardCapsuleState();
      let listState = new KeyGuardListState();
      let widthState = new ImmersiveWidthState();
      (capsuleVm as object)['onImmersiveStateChange'](cardState);
      (capsuleVm as object)['onImmersiveStateChange'](capsuleState);
      (capsuleVm as object)['onImmersiveStateChange'](listState);
      (capsuleVm as object)['onImmersiveStateChange'](widthState);
    });

    it('testClearRemindState_0002', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['clearRemindState']();
    });

    it('testProcessCapsuleRemind_0002', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['processCapsuleRemind']();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      (capsuleVm as object)['processCapsuleRemind']();
    });

    it('testClearRemindTask_0002', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['remindTaskId'] = setTimeout(() => {
        (capsuleVm as object)['ClearRemindTask']();
      }, 20);
    });

    it('testGetRootUiStyle1_0003', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.hashCode = 'myHashCode11';
      immersiveNtfData.id = 100000;
      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_CONTENT, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      let res = capsuleVm.getRootUiStyle();
      res?.onLongClick?.();
      res?.onIconClick?.();
      res?.onClick?.();
      expect(res).not().assertNull();
    });

    it('testGetRemindData_0003', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      let tmpList = new ImmersiveCapsuleList();
      tmpList.setCapsuleData(CapsulePositionType.TYPE_SHADOW, immersiveNtfData);
      (capsuleVm as object)['tmpList'] = tmpList;
      capsuleVm.checkAndUpdateUiData(true);

      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_REMIND, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      capsuleVm.checkAndUpdateUiData(true);
      capsuleVm.checkAndUpdateUiData(false);
      (capsuleVm as object)['getRemindData']();
      (groupPacker as object)['groupList'] = undefined;
      (capsuleVm as object)['getRemindData']();
    });

    it('testOnImmersiveStateChange_0003', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let cardState = new ImmersiveCardState();
      let capsuleState = new KeyGuardCapsuleState();
      let listState = new KeyGuardListState();
      let widthState = new ImmersiveWidthState();
      (capsuleVm as object)['onImmersiveStateChange'](cardState);
      (capsuleVm as object)['onImmersiveStateChange'](capsuleState);
      (capsuleVm as object)['onImmersiveStateChange'](listState);
      (capsuleVm as object)['onImmersiveStateChange'](widthState);
    });

    it('testClearRemindState_0003', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['clearRemindState']();
    });

    it('testProcessCapsuleRemind_0003', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['processCapsuleRemind']();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      (capsuleVm as object)['processCapsuleRemind']();
    });

    it('testClearRemindTask_0003', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['remindTaskId'] = setTimeout(() => {
        (capsuleVm as object)['ClearRemindTask']();
      }, 20);
    });

    it('testGetRootUiStyle1_0004', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.hashCode = 'myHashCode11';
      immersiveNtfData.id = 100000;
      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_CONTENT, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      let res = capsuleVm.getRootUiStyle();
      res?.onLongClick?.();
      res?.onIconClick?.();
      res?.onClick?.();
      expect(res).not().assertNull();
    });

    it('testGetRemindData_0004', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      let tmpList = new ImmersiveCapsuleList();
      tmpList.setCapsuleData(CapsulePositionType.TYPE_SHADOW, immersiveNtfData);
      (capsuleVm as object)['tmpList'] = tmpList;
      capsuleVm.checkAndUpdateUiData(true);

      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_REMIND, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      capsuleVm.checkAndUpdateUiData(true);
      capsuleVm.checkAndUpdateUiData(false);
      (capsuleVm as object)['getRemindData']();
      (groupPacker as object)['groupList'] = undefined;
      (capsuleVm as object)['getRemindData']();
    });

    it('testOnImmersiveStateChange_0004', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let cardState = new ImmersiveCardState();
      let capsuleState = new KeyGuardCapsuleState();
      let listState = new KeyGuardListState();
      let widthState = new ImmersiveWidthState();
      (capsuleVm as object)['onImmersiveStateChange'](cardState);
      (capsuleVm as object)['onImmersiveStateChange'](capsuleState);
      (capsuleVm as object)['onImmersiveStateChange'](listState);
      (capsuleVm as object)['onImmersiveStateChange'](widthState);
    });

    it('testClearRemindState_0004', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['clearRemindState']();
    });

    it('testProcessCapsuleRemind_0004', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['processCapsuleRemind']();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      (capsuleVm as object)['processCapsuleRemind']();
    });

    it('testClearRemindTask_0004', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['remindTaskId'] = setTimeout(() => {
        (capsuleVm as object)['ClearRemindTask']();
      }, 20);
    });

    it('testGetRootUiStyle1_0005', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.hashCode = 'myHashCode11';
      immersiveNtfData.id = 100000;
      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_CONTENT, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      let res = capsuleVm.getRootUiStyle();
      res?.onLongClick?.();
      res?.onIconClick?.();
      res?.onClick?.();
      expect(res).not().assertNull();
    });

    it('testGetRemindData_0005', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      let tmpList = new ImmersiveCapsuleList();
      tmpList.setCapsuleData(CapsulePositionType.TYPE_SHADOW, immersiveNtfData);
      (capsuleVm as object)['tmpList'] = tmpList;
      capsuleVm.checkAndUpdateUiData(true);

      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_REMIND, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      capsuleVm.checkAndUpdateUiData(true);
      capsuleVm.checkAndUpdateUiData(false);
      (capsuleVm as object)['getRemindData']();
      (groupPacker as object)['groupList'] = undefined;
      (capsuleVm as object)['getRemindData']();
    });

    it('testOnImmersiveStateChange_0005', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let cardState = new ImmersiveCardState();
      let capsuleState = new KeyGuardCapsuleState();
      let listState = new KeyGuardListState();
      let widthState = new ImmersiveWidthState();
      (capsuleVm as object)['onImmersiveStateChange'](cardState);
      (capsuleVm as object)['onImmersiveStateChange'](capsuleState);
      (capsuleVm as object)['onImmersiveStateChange'](listState);
      (capsuleVm as object)['onImmersiveStateChange'](widthState);
    });

    it('testClearRemindState_0005', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['clearRemindState']();
    });

    it('testProcessCapsuleRemind_0005', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['processCapsuleRemind']();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      (capsuleVm as object)['processCapsuleRemind']();
    });

    it('testClearRemindTask_0005', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['remindTaskId'] = setTimeout(() => {
        (capsuleVm as object)['ClearRemindTask']();
      }, 20);
    });

    it('testGetRootUiStyle1_0006', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.hashCode = 'myHashCode11';
      immersiveNtfData.id = 100000;
      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_CONTENT, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      let res = capsuleVm.getRootUiStyle();
      res?.onLongClick?.();
      res?.onIconClick?.();
      res?.onClick?.();
      expect(res).not().assertNull();
    });

    it('testGetRemindData_0006', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      let tmpList = new ImmersiveCapsuleList();
      tmpList.setCapsuleData(CapsulePositionType.TYPE_SHADOW, immersiveNtfData);
      (capsuleVm as object)['tmpList'] = tmpList;
      capsuleVm.checkAndUpdateUiData(true);

      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_REMIND, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      capsuleVm.checkAndUpdateUiData(true);
      capsuleVm.checkAndUpdateUiData(false);
      (capsuleVm as object)['getRemindData']();
      (groupPacker as object)['groupList'] = undefined;
      (capsuleVm as object)['getRemindData']();
    });

    it('testOnImmersiveStateChange_0006', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let cardState = new ImmersiveCardState();
      let capsuleState = new KeyGuardCapsuleState();
      let listState = new KeyGuardListState();
      let widthState = new ImmersiveWidthState();
      (capsuleVm as object)['onImmersiveStateChange'](cardState);
      (capsuleVm as object)['onImmersiveStateChange'](capsuleState);
      (capsuleVm as object)['onImmersiveStateChange'](listState);
      (capsuleVm as object)['onImmersiveStateChange'](widthState);
    });

    it('testClearRemindState_0006', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['clearRemindState']();
    });

    it('testProcessCapsuleRemind_0006', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['processCapsuleRemind']();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      (capsuleVm as object)['processCapsuleRemind']();
    });

    it('testClearRemindTask_0006', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['remindTaskId'] = setTimeout(() => {
        (capsuleVm as object)['ClearRemindTask']();
      }, 20);
    });

    it('testGetRootUiStyle1_0007', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.hashCode = 'myHashCode11';
      immersiveNtfData.id = 100000;
      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_CONTENT, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      let res = capsuleVm.getRootUiStyle();
      res?.onLongClick?.();
      res?.onIconClick?.();
      res?.onClick?.();
      expect(res).not().assertNull();
    });

    it('testGetRemindData_0007', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      let tmpList = new ImmersiveCapsuleList();
      tmpList.setCapsuleData(CapsulePositionType.TYPE_SHADOW, immersiveNtfData);
      (capsuleVm as object)['tmpList'] = tmpList;
      capsuleVm.checkAndUpdateUiData(true);

      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_REMIND, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      capsuleVm.checkAndUpdateUiData(true);
      capsuleVm.checkAndUpdateUiData(false);
      (capsuleVm as object)['getRemindData']();
      (groupPacker as object)['groupList'] = undefined;
      (capsuleVm as object)['getRemindData']();
    });

    it('testOnImmersiveStateChange_0007', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let cardState = new ImmersiveCardState();
      let capsuleState = new KeyGuardCapsuleState();
      let listState = new KeyGuardListState();
      let widthState = new ImmersiveWidthState();
      (capsuleVm as object)['onImmersiveStateChange'](cardState);
      (capsuleVm as object)['onImmersiveStateChange'](capsuleState);
      (capsuleVm as object)['onImmersiveStateChange'](listState);
      (capsuleVm as object)['onImmersiveStateChange'](widthState);
    });

    it('testClearRemindState_0007', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['clearRemindState']();
    });

    it('testProcessCapsuleRemind_0007', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['processCapsuleRemind']();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      (capsuleVm as object)['processCapsuleRemind']();
    });

    it('testClearRemindTask_0007', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['remindTaskId'] = setTimeout(() => {
        (capsuleVm as object)['ClearRemindTask']();
      }, 20);
    });

    it('testGetRootUiStyle1_0008', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.hashCode = 'myHashCode11';
      immersiveNtfData.id = 100000;
      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_CONTENT, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      let res = capsuleVm.getRootUiStyle();
      res?.onLongClick?.();
      res?.onIconClick?.();
      res?.onClick?.();
      expect(res).not().assertNull();
    });

    it('testGetRemindData_0008', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      let tmpList = new ImmersiveCapsuleList();
      tmpList.setCapsuleData(CapsulePositionType.TYPE_SHADOW, immersiveNtfData);
      (capsuleVm as object)['tmpList'] = tmpList;
      capsuleVm.checkAndUpdateUiData(true);

      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_REMIND, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      capsuleVm.checkAndUpdateUiData(true);
      capsuleVm.checkAndUpdateUiData(false);
      (capsuleVm as object)['getRemindData']();
      (groupPacker as object)['groupList'] = undefined;
      (capsuleVm as object)['getRemindData']();
    });

    it('testOnImmersiveStateChange_0008', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let cardState = new ImmersiveCardState();
      let capsuleState = new KeyGuardCapsuleState();
      let listState = new KeyGuardListState();
      let widthState = new ImmersiveWidthState();
      (capsuleVm as object)['onImmersiveStateChange'](cardState);
      (capsuleVm as object)['onImmersiveStateChange'](capsuleState);
      (capsuleVm as object)['onImmersiveStateChange'](listState);
      (capsuleVm as object)['onImmersiveStateChange'](widthState);
    });

    it('testClearRemindState_0008', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['clearRemindState']();
    });

    it('testProcessCapsuleRemind_0008', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['processCapsuleRemind']();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      (capsuleVm as object)['processCapsuleRemind']();
    });

    it('testClearRemindTask_0008', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['remindTaskId'] = setTimeout(() => {
        (capsuleVm as object)['ClearRemindTask']();
      }, 20);
    });

    it('testGetRootUiStyle1_0009', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.hashCode = 'myHashCode11';
      immersiveNtfData.id = 100000;
      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_CONTENT, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      let res = capsuleVm.getRootUiStyle();
      res?.onLongClick?.();
      res?.onIconClick?.();
      res?.onClick?.();
      expect(res).not().assertNull();
    });

    it('testGetRemindData_0009', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      let tmpList = new ImmersiveCapsuleList();
      tmpList.setCapsuleData(CapsulePositionType.TYPE_SHADOW, immersiveNtfData);
      (capsuleVm as object)['tmpList'] = tmpList;
      capsuleVm.checkAndUpdateUiData(true);

      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_REMIND, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      capsuleVm.checkAndUpdateUiData(true);
      capsuleVm.checkAndUpdateUiData(false);
      (capsuleVm as object)['getRemindData']();
      (groupPacker as object)['groupList'] = undefined;
      (capsuleVm as object)['getRemindData']();
    });

    it('testOnImmersiveStateChange_0009', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let cardState = new ImmersiveCardState();
      let capsuleState = new KeyGuardCapsuleState();
      let listState = new KeyGuardListState();
      let widthState = new ImmersiveWidthState();
      (capsuleVm as object)['onImmersiveStateChange'](cardState);
      (capsuleVm as object)['onImmersiveStateChange'](capsuleState);
      (capsuleVm as object)['onImmersiveStateChange'](listState);
      (capsuleVm as object)['onImmersiveStateChange'](widthState);
    });

    it('testClearRemindState_0009', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['clearRemindState']();
    });

    it('testProcessCapsuleRemind_0009', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['processCapsuleRemind']();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      (capsuleVm as object)['processCapsuleRemind']();
    });

    it('testClearRemindTask_0009', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['remindTaskId'] = setTimeout(() => {
        (capsuleVm as object)['ClearRemindTask']();
      }, 20);
    });

    it('testGetRootUiStyle1_0010', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.hashCode = 'myHashCode11';
      immersiveNtfData.id = 100000;
      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_CONTENT, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      let res = capsuleVm.getRootUiStyle();
      res?.onLongClick?.();
      res?.onIconClick?.();
      res?.onClick?.();
      expect(res).not().assertNull();
    });

    it('testGetRemindData_0010', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      let tmpList = new ImmersiveCapsuleList();
      tmpList.setCapsuleData(CapsulePositionType.TYPE_SHADOW, immersiveNtfData);
      (capsuleVm as object)['tmpList'] = tmpList;
      capsuleVm.checkAndUpdateUiData(true);

      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_REMIND, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      capsuleVm.checkAndUpdateUiData(true);
      capsuleVm.checkAndUpdateUiData(false);
      (capsuleVm as object)['getRemindData']();
      (groupPacker as object)['groupList'] = undefined;
      (capsuleVm as object)['getRemindData']();
    });

    it('testOnImmersiveStateChange_0010', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let cardState = new ImmersiveCardState();
      let capsuleState = new KeyGuardCapsuleState();
      let listState = new KeyGuardListState();
      let widthState = new ImmersiveWidthState();
      (capsuleVm as object)['onImmersiveStateChange'](cardState);
      (capsuleVm as object)['onImmersiveStateChange'](capsuleState);
      (capsuleVm as object)['onImmersiveStateChange'](listState);
      (capsuleVm as object)['onImmersiveStateChange'](widthState);
    });

    it('testClearRemindState_0010', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['clearRemindState']();
    });

    it('testProcessCapsuleRemind_0010', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['processCapsuleRemind']();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      (capsuleVm as object)['processCapsuleRemind']();
    });

    it('testClearRemindTask_0010', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['remindTaskId'] = setTimeout(() => {
        (capsuleVm as object)['ClearRemindTask']();
      }, 20);
    });

    it('testGetRootUiStyle1_0011', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.hashCode = 'myHashCode11';
      immersiveNtfData.id = 100000;
      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_CONTENT, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      let res = capsuleVm.getRootUiStyle();
      res?.onLongClick?.();
      res?.onIconClick?.();
      res?.onClick?.();
      expect(res).not().assertNull();
    });

    it('testGetRemindData_0011', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      let tmpList = new ImmersiveCapsuleList();
      tmpList.setCapsuleData(CapsulePositionType.TYPE_SHADOW, immersiveNtfData);
      (capsuleVm as object)['tmpList'] = tmpList;
      capsuleVm.checkAndUpdateUiData(true);

      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_REMIND, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      capsuleVm.checkAndUpdateUiData(true);
      capsuleVm.checkAndUpdateUiData(false);
      (capsuleVm as object)['getRemindData']();
      (groupPacker as object)['groupList'] = undefined;
      (capsuleVm as object)['getRemindData']();
    });

    it('testOnImmersiveStateChange_0011', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let cardState = new ImmersiveCardState();
      let capsuleState = new KeyGuardCapsuleState();
      let listState = new KeyGuardListState();
      let widthState = new ImmersiveWidthState();
      (capsuleVm as object)['onImmersiveStateChange'](cardState);
      (capsuleVm as object)['onImmersiveStateChange'](capsuleState);
      (capsuleVm as object)['onImmersiveStateChange'](listState);
      (capsuleVm as object)['onImmersiveStateChange'](widthState);
    });

    it('testClearRemindState_0011', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['clearRemindState']();
    });

    it('testProcessCapsuleRemind_0011', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['processCapsuleRemind']();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      (capsuleVm as object)['processCapsuleRemind']();
    });

    it('testClearRemindTask_0011', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['remindTaskId'] = setTimeout(() => {
        (capsuleVm as object)['ClearRemindTask']();
      }, 20);
    });

    it('testGetRootUiStyle1_0012', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.hashCode = 'myHashCode11';
      immersiveNtfData.id = 100000;
      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_CONTENT, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      let res = capsuleVm.getRootUiStyle();
      res?.onLongClick?.();
      res?.onIconClick?.();
      res?.onClick?.();
      expect(res).not().assertNull();
    });

    it('testGetRemindData_0012', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      let tmpList = new ImmersiveCapsuleList();
      tmpList.setCapsuleData(CapsulePositionType.TYPE_SHADOW, immersiveNtfData);
      (capsuleVm as object)['tmpList'] = tmpList;
      capsuleVm.checkAndUpdateUiData(true);

      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_REMIND, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      capsuleVm.checkAndUpdateUiData(true);
      capsuleVm.checkAndUpdateUiData(false);
      (capsuleVm as object)['getRemindData']();
      (groupPacker as object)['groupList'] = undefined;
      (capsuleVm as object)['getRemindData']();
    });

    it('testOnImmersiveStateChange_0012', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let cardState = new ImmersiveCardState();
      let capsuleState = new KeyGuardCapsuleState();
      let listState = new KeyGuardListState();
      let widthState = new ImmersiveWidthState();
      (capsuleVm as object)['onImmersiveStateChange'](cardState);
      (capsuleVm as object)['onImmersiveStateChange'](capsuleState);
      (capsuleVm as object)['onImmersiveStateChange'](listState);
      (capsuleVm as object)['onImmersiveStateChange'](widthState);
    });

    it('testClearRemindState_0012', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['clearRemindState']();
    });

    it('testProcessCapsuleRemind_0012', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['processCapsuleRemind']();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      (capsuleVm as object)['processCapsuleRemind']();
    });

    it('testClearRemindTask_0012', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['remindTaskId'] = setTimeout(() => {
        (capsuleVm as object)['ClearRemindTask']();
      }, 20);
    });

    it('testGetRootUiStyle1_0013', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.hashCode = 'myHashCode11';
      immersiveNtfData.id = 100000;
      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_CONTENT, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      let res = capsuleVm.getRootUiStyle();
      res?.onLongClick?.();
      res?.onIconClick?.();
      res?.onClick?.();
      expect(res).not().assertNull();
    });

    it('testGetRemindData_0013', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      let tmpList = new ImmersiveCapsuleList();
      tmpList.setCapsuleData(CapsulePositionType.TYPE_SHADOW, immersiveNtfData);
      (capsuleVm as object)['tmpList'] = tmpList;
      capsuleVm.checkAndUpdateUiData(true);

      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_REMIND, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      capsuleVm.checkAndUpdateUiData(true);
      capsuleVm.checkAndUpdateUiData(false);
      (capsuleVm as object)['getRemindData']();
      (groupPacker as object)['groupList'] = undefined;
      (capsuleVm as object)['getRemindData']();
    });

    it('testOnImmersiveStateChange_0013', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let cardState = new ImmersiveCardState();
      let capsuleState = new KeyGuardCapsuleState();
      let listState = new KeyGuardListState();
      let widthState = new ImmersiveWidthState();
      (capsuleVm as object)['onImmersiveStateChange'](cardState);
      (capsuleVm as object)['onImmersiveStateChange'](capsuleState);
      (capsuleVm as object)['onImmersiveStateChange'](listState);
      (capsuleVm as object)['onImmersiveStateChange'](widthState);
    });

    it('testClearRemindState_0013', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['clearRemindState']();
    });

    it('testProcessCapsuleRemind_0013', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['processCapsuleRemind']();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      (capsuleVm as object)['processCapsuleRemind']();
    });

    it('testClearRemindTask_0013', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['remindTaskId'] = setTimeout(() => {
        (capsuleVm as object)['ClearRemindTask']();
      }, 20);
    });

    it('testGetRootUiStyle1_0014', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.hashCode = 'myHashCode11';
      immersiveNtfData.id = 100000;
      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_CONTENT, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      let res = capsuleVm.getRootUiStyle();
      res?.onLongClick?.();
      res?.onIconClick?.();
      res?.onClick?.();
      expect(res).not().assertNull();
    });

    it('testGetRemindData_0014', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      let tmpList = new ImmersiveCapsuleList();
      tmpList.setCapsuleData(CapsulePositionType.TYPE_SHADOW, immersiveNtfData);
      (capsuleVm as object)['tmpList'] = tmpList;
      capsuleVm.checkAndUpdateUiData(true);

      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_REMIND, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      capsuleVm.checkAndUpdateUiData(true);
      capsuleVm.checkAndUpdateUiData(false);
      (capsuleVm as object)['getRemindData']();
      (groupPacker as object)['groupList'] = undefined;
      (capsuleVm as object)['getRemindData']();
    });

    it('testOnImmersiveStateChange_0014', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let cardState = new ImmersiveCardState();
      let capsuleState = new KeyGuardCapsuleState();
      let listState = new KeyGuardListState();
      let widthState = new ImmersiveWidthState();
      (capsuleVm as object)['onImmersiveStateChange'](cardState);
      (capsuleVm as object)['onImmersiveStateChange'](capsuleState);
      (capsuleVm as object)['onImmersiveStateChange'](listState);
      (capsuleVm as object)['onImmersiveStateChange'](widthState);
    });

    it('testClearRemindState_0014', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['clearRemindState']();
    });

    it('testProcessCapsuleRemind_0014', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['processCapsuleRemind']();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      (capsuleVm as object)['processCapsuleRemind']();
    });

    it('testClearRemindTask_0014', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['remindTaskId'] = setTimeout(() => {
        (capsuleVm as object)['ClearRemindTask']();
      }, 20);
    });

    it('testGetRootUiStyle1_0015', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.hashCode = 'myHashCode11';
      immersiveNtfData.id = 100000;
      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_CONTENT, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      let res = capsuleVm.getRootUiStyle();
      res?.onLongClick?.();
      res?.onIconClick?.();
      res?.onClick?.();
      expect(res).not().assertNull();
    });

    it('testGetRemindData_0015', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      let tmpList = new ImmersiveCapsuleList();
      tmpList.setCapsuleData(CapsulePositionType.TYPE_SHADOW, immersiveNtfData);
      (capsuleVm as object)['tmpList'] = tmpList;
      capsuleVm.checkAndUpdateUiData(true);

      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_REMIND, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      capsuleVm.checkAndUpdateUiData(true);
      capsuleVm.checkAndUpdateUiData(false);
      (capsuleVm as object)['getRemindData']();
      (groupPacker as object)['groupList'] = undefined;
      (capsuleVm as object)['getRemindData']();
    });

    it('testOnImmersiveStateChange_0015', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let cardState = new ImmersiveCardState();
      let capsuleState = new KeyGuardCapsuleState();
      let listState = new KeyGuardListState();
      let widthState = new ImmersiveWidthState();
      (capsuleVm as object)['onImmersiveStateChange'](cardState);
      (capsuleVm as object)['onImmersiveStateChange'](capsuleState);
      (capsuleVm as object)['onImmersiveStateChange'](listState);
      (capsuleVm as object)['onImmersiveStateChange'](widthState);
    });

    it('testClearRemindState_0015', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['clearRemindState']();
    });

    it('testProcessCapsuleRemind_0015', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['processCapsuleRemind']();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      (capsuleVm as object)['processCapsuleRemind']();
    });

    it('testClearRemindTask_0015', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['remindTaskId'] = setTimeout(() => {
        (capsuleVm as object)['ClearRemindTask']();
      }, 20);
    });

    it('testGetRootUiStyle1_0016', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.hashCode = 'myHashCode11';
      immersiveNtfData.id = 100000;
      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_CONTENT, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      let res = capsuleVm.getRootUiStyle();
      res?.onLongClick?.();
      res?.onIconClick?.();
      res?.onClick?.();
      expect(res).not().assertNull();
    });

    it('testGetRemindData_0016', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      let tmpList = new ImmersiveCapsuleList();
      tmpList.setCapsuleData(CapsulePositionType.TYPE_SHADOW, immersiveNtfData);
      (capsuleVm as object)['tmpList'] = tmpList;
      capsuleVm.checkAndUpdateUiData(true);

      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_REMIND, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      capsuleVm.checkAndUpdateUiData(true);
      capsuleVm.checkAndUpdateUiData(false);
      (capsuleVm as object)['getRemindData']();
      (groupPacker as object)['groupList'] = undefined;
      (capsuleVm as object)['getRemindData']();
    });

    it('testOnImmersiveStateChange_0016', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let cardState = new ImmersiveCardState();
      let capsuleState = new KeyGuardCapsuleState();
      let listState = new KeyGuardListState();
      let widthState = new ImmersiveWidthState();
      (capsuleVm as object)['onImmersiveStateChange'](cardState);
      (capsuleVm as object)['onImmersiveStateChange'](capsuleState);
      (capsuleVm as object)['onImmersiveStateChange'](listState);
      (capsuleVm as object)['onImmersiveStateChange'](widthState);
    });

    it('testClearRemindState_0016', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['clearRemindState']();
    });

    it('testProcessCapsuleRemind_0016', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['processCapsuleRemind']();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      (capsuleVm as object)['processCapsuleRemind']();
    });

    it('testClearRemindTask_0016', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['remindTaskId'] = setTimeout(() => {
        (capsuleVm as object)['ClearRemindTask']();
      }, 20);
    });

    it('testGetRootUiStyle1_0017', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.hashCode = 'myHashCode11';
      immersiveNtfData.id = 100000;
      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_CONTENT, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      let res = capsuleVm.getRootUiStyle();
      res?.onLongClick?.();
      res?.onIconClick?.();
      res?.onClick?.();
      expect(res).not().assertNull();
    });

    it('testGetRemindData_0017', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      let tmpList = new ImmersiveCapsuleList();
      tmpList.setCapsuleData(CapsulePositionType.TYPE_SHADOW, immersiveNtfData);
      (capsuleVm as object)['tmpList'] = tmpList;
      capsuleVm.checkAndUpdateUiData(true);

      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_REMIND, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      capsuleVm.checkAndUpdateUiData(true);
      capsuleVm.checkAndUpdateUiData(false);
      (capsuleVm as object)['getRemindData']();
      (groupPacker as object)['groupList'] = undefined;
      (capsuleVm as object)['getRemindData']();
    });

    it('testOnImmersiveStateChange_0017', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let cardState = new ImmersiveCardState();
      let capsuleState = new KeyGuardCapsuleState();
      let listState = new KeyGuardListState();
      let widthState = new ImmersiveWidthState();
      (capsuleVm as object)['onImmersiveStateChange'](cardState);
      (capsuleVm as object)['onImmersiveStateChange'](capsuleState);
      (capsuleVm as object)['onImmersiveStateChange'](listState);
      (capsuleVm as object)['onImmersiveStateChange'](widthState);
    });

    it('testClearRemindState_0017', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['clearRemindState']();
    });

    it('testProcessCapsuleRemind_0017', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['processCapsuleRemind']();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      (capsuleVm as object)['processCapsuleRemind']();
    });

    it('testClearRemindTask_0017', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['remindTaskId'] = setTimeout(() => {
        (capsuleVm as object)['ClearRemindTask']();
      }, 20);
    });

    it('testGetRootUiStyle1_0018', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.hashCode = 'myHashCode11';
      immersiveNtfData.id = 100000;
      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_CONTENT, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      let res = capsuleVm.getRootUiStyle();
      res?.onLongClick?.();
      res?.onIconClick?.();
      res?.onClick?.();
      expect(res).not().assertNull();
    });

    it('testGetRemindData_0018', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      let tmpList = new ImmersiveCapsuleList();
      tmpList.setCapsuleData(CapsulePositionType.TYPE_SHADOW, immersiveNtfData);
      (capsuleVm as object)['tmpList'] = tmpList;
      capsuleVm.checkAndUpdateUiData(true);

      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_REMIND, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      capsuleVm.checkAndUpdateUiData(true);
      capsuleVm.checkAndUpdateUiData(false);
      (capsuleVm as object)['getRemindData']();
      (groupPacker as object)['groupList'] = undefined;
      (capsuleVm as object)['getRemindData']();
    });

    it('testOnImmersiveStateChange_0018', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let cardState = new ImmersiveCardState();
      let capsuleState = new KeyGuardCapsuleState();
      let listState = new KeyGuardListState();
      let widthState = new ImmersiveWidthState();
      (capsuleVm as object)['onImmersiveStateChange'](cardState);
      (capsuleVm as object)['onImmersiveStateChange'](capsuleState);
      (capsuleVm as object)['onImmersiveStateChange'](listState);
      (capsuleVm as object)['onImmersiveStateChange'](widthState);
    });

    it('testClearRemindState_0018', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['clearRemindState']();
    });

    it('testProcessCapsuleRemind_0018', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['processCapsuleRemind']();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      (capsuleVm as object)['processCapsuleRemind']();
    });

    it('testClearRemindTask_0018', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['remindTaskId'] = setTimeout(() => {
        (capsuleVm as object)['ClearRemindTask']();
      }, 20);
    });
  });
}