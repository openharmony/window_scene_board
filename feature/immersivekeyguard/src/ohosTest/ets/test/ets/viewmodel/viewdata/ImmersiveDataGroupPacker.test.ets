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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import { NotificationEntry } from '@ohos/notificationcomponent/src/main/ets/model/NotificationEntry';
import { NtfListKeyGuard } from '@ohos/notificationcomponent/src/main/ets/model/NtfListKeyGuard';
import { ImmersiveDataGroupPacker } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveDataGroupProcessor';
import { ImmersiveNtfData } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveNtfData';
import type Ntf from '@ohos.notificationSubscribe';
import ntfMgr from '@ohos.notificationManager';
import { HideNtfContentEvent } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { EvtBus } from '@ohos/frameworkwrapper';

/**
 * 沉浸式锁屏分组工具测试用例
 */
export function ImmersiveDataGroupPackerTest() {
  describe('ImmersiveDataGroupPackerTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterAll((): void => {
    });

    afterEach((): void => {
    });

    it('testInit', Level.LEVEL1, (): void => {
      let packer = new ImmersiveDataGroupPacker();
      packer.init(new NtfListKeyGuard());
      expect(packer).not().assertNull();
    });

    it('testDestroy01', Level.LEVEL1, (): void => {
      let packer = new ImmersiveDataGroupPacker();
      packer.destroy();
      expect(packer).not().assertNull();
    });

    it('testDestroy02', Level.LEVEL1, (): void => {
      let packer = new ImmersiveDataGroupPacker();
      packer.init(new NtfListKeyGuard());
      packer.destroy();
      expect(packer).not().assertNull();
    });

    it('testGetGroupList01', Level.LEVEL1, (): void => {
      let packer = new ImmersiveDataGroupPacker();
      let list = packer.getGroupList();
      expect(list !== undefined).assertTrue();
    });

    it('testGetGroupList02', Level.LEVEL1, (): void => {
      let packer = new ImmersiveDataGroupPacker();
      let list = packer.getGroupList();
      expect(list?.length === 0).assertTrue();
    });

    it('testGetGroupList03', Level.LEVEL1, (): void => {
      let packer = new ImmersiveDataGroupPacker();
      let list = packer.getGroupList();
      list?.push(new ImmersiveNtfData());
      expect(list?.length === 1).assertTrue();
    });

    it('testIsEmptyGroupList01', Level.LEVEL1, (): void => {
      let packer = new ImmersiveDataGroupPacker();
      (packer as object)['groupList'] = [];
      let result = packer.isEmptyGroupList();
      expect(result).assertTrue();
    });

    it('testIsEmptyGroupList02', Level.LEVEL1, (): void => {
      let packer = new ImmersiveDataGroupPacker();
      let ntfData = new ImmersiveNtfData();
      ntfData.id = 100;
      ntfData.groupKey = 'testGroupKey';
      ntfData.hashCode = 'testHashCode';
      (packer as object)['groupList'] = [ntfData];
      let result = packer.isEmptyGroupList();
      expect(result).assertFalse();
    });

    it('testGetNtfList01', Level.LEVEL1, (): void => {
      let packer = new ImmersiveDataGroupPacker();
      let list = packer.getNtfList();
      expect(list?.length === 0).assertTrue();
    });

    it('testGetNtfList02', Level.LEVEL1, (): void => {
      let packer = new ImmersiveDataGroupPacker();
      let list = packer.getNtfList();
      expect(list?.length === 0).assertTrue();
    });

    it('testFindNativeData01', Level.LEVEL1, (): void => {
      let packer = new ImmersiveDataGroupPacker();
      let entry = packer.findNativeData('');
      expect(entry === undefined).assertTrue();
    });

    it('testFindNativeData02', Level.LEVEL1, (): void => {
      let packer = new ImmersiveDataGroupPacker();
      let entry = packer.findNativeData('testKey');
      expect(entry === undefined).assertTrue();
    });

    it('testFindGroupData01', Level.LEVEL1, (): void => {
      let packer = new ImmersiveDataGroupPacker();
      let group = packer.findGroupData('');
      expect(group === undefined).assertTrue();
    });

    it('testFindGroupData02', Level.LEVEL1, (): void => {
      let packer = new ImmersiveDataGroupPacker();
      let group = packer.findGroupData('testKey');
      expect(group === undefined).assertTrue();
    });

    it('testPackGroup', Level.LEVEL1, (): void => {
      let packer = new ImmersiveDataGroupPacker();
      packer.packGroup();
      expect(packer).not().assertNull();
    });

    it('testPackGroup02', Level.LEVEL1, (): void => {
      let packer = new ImmersiveDataGroupPacker();
      packer.packGroup(true);
      expect(packer).not().assertNull();
    });

    it('testPackGroup03', Level.LEVEL1, (): void => {
      let packer = new ImmersiveDataGroupPacker();
      packer.packGroup(false);
      expect(packer).not().assertNull();
    });

    it('testGetGroupSize', Level.LEVEL1, (): void => {
      let packer = new ImmersiveDataGroupPacker();
      packer.getGroupSize();
      expect(packer).not().assertNull();
    });

    it('testGetOldGroupSize', Level.LEVEL1, (): void => {
      let packer = new ImmersiveDataGroupPacker();
      packer.getOldGroupSize();
      expect(packer).not().assertNull();
    });

    it('testGetFirstCardData', Level.LEVEL1, (): void => {
      let packer = new ImmersiveDataGroupPacker();
      packer.getFirstCardData();
      expect(packer).not().assertNull();
    });

    it('testProcessGroupData', Level.LEVEL1, (): void => {
      let packer = new ImmersiveDataGroupPacker();
      let entry = new NotificationEntry();
      entry.id = 100;
      entry.contentType = -1;
      entry.hashCode = 'testHashCode';
      (packer as object)['processGroupData'](entry);
      (packer as object)['processGroupData'](entry, true);
      (packer as object)['processGroupData'](entry, false);
      expect(packer).not().assertNull();
    });

    it('onHideNtfContentEvent0', Level.LEVEL1, (): void => {
      let hideEvent = new HideNtfContentEvent();
      hideEvent.groupKey = "123";
      hideEvent.shouldHide = true;
      EvtBus.post(HideNtfContentEvent, hideEvent);
      expect(hideEvent).not().assertNull();
    });

    it('onHideNtfContentEvent1', Level.LEVEL1, (): void => {
      let hideEvent = new HideNtfContentEvent();
      hideEvent.groupKey = "123";
      hideEvent.shouldHide = false;
      EvtBus.post(HideNtfContentEvent, hideEvent);
      expect(hideEvent).not().assertNull();
    });

    it('testOnHideNtfContentEvent', Level.LEVEL1, (): void => {
      let packer = new ImmersiveDataGroupPacker();
      let hideEvent = new HideNtfContentEvent();
      hideEvent.groupKey = '';
      hideEvent.shouldHide = false;
      (packer as object)['onHideNtfContentEvent'](undefined);
      (packer as object)['onHideNtfContentEvent'](hideEvent);
      hideEvent.groupKey = 'myTest';
      (packer as object)['onHideNtfContentEvent'](hideEvent);
      expect(hideEvent).not().assertNull();
    });
  });
}