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
import { immersiveDefaultCardDataHelper } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveDefaultCardDataHelper';
import { ImmersiveNtfData } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveNtfData';
import {
  BaseNotification, ImmersiveEntryEvent, NtfEventType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { EvtBus } from '@ohos/frameworkwrapper';

/**
 * 沉浸锁屏数据监听测试用例
 */
export function ImmersiveDefaultCardDataHelperTest() {
  describe('ImmersiveDefaultCardDataHelperTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterAll((): void => {
    });

    afterEach((): void => {
    });

    it('test_Init', Level.LEVEL1, (): void => {
      immersiveDefaultCardDataHelper.init();
      expect(immersiveDefaultCardDataHelper).not().assertNull();
    });

    it('test_addImmersiveNtfDataToShow', Level.LEVEL1, (): void => {
      immersiveDefaultCardDataHelper.addImmersiveNtfDataToShow('testHashCode');
      expect(immersiveDefaultCardDataHelper).not().assertNull();
    });

    it('test_handleNtfRemove', Level.LEVEL1, (): void => {
      let entry = new BaseNotification();
      entry.id = 100;
      entry.contentType = -1;
      entry.hashCode = 'testHashCode';
      let event = new ImmersiveEntryEvent();
      event.eventType = NtfEventType.EVENT_TYPE_POST_CANCEL;
      event.notificationList = new Array(entry);
      EvtBus.post(ImmersiveEntryEvent, event);
      expect(entry).not().assertNull();
    });

    it('test_handleNtfAdd', Level.LEVEL1, (): void => {
      let entry = new BaseNotification();
      entry.id = 100;
      entry.contentType = -1;
      entry.hashCode = 'testHashCode';
      let event = new ImmersiveEntryEvent();
      event.eventType = NtfEventType.EVENT_TYPE_POST_ADD;
      event.notificationList = new Array(entry);
      EvtBus.post(ImmersiveEntryEvent, event);
      expect(entry).not().assertNull();
    });

    it('test_handleNtfUpdate', Level.LEVEL1, (): void => {
      let entry = new BaseNotification();
      entry.id = 100;
      entry.contentType = -1;
      entry.hashCode = 'testHashCode';
      let event = new ImmersiveEntryEvent();
      event.eventType = NtfEventType.EVENT_TYPE_POST_UPDATE;
      event.notificationList = new Array(entry);
      EvtBus.post(ImmersiveEntryEvent, event);
      expect(entry).not().assertNull();
    });

    it('test_handleNtfInit', Level.LEVEL1, (): void => {
      let entry = new BaseNotification();
      entry.id = 100;
      entry.contentType = -1;
      entry.hashCode = 'testHashCode';
      let event = new ImmersiveEntryEvent();
      event.eventType = NtfEventType.EVENT_TYPE_INIT;
      event.notificationList = new Array(entry);
      EvtBus.post(ImmersiveEntryEvent, event);
      expect(entry).not().assertNull();
    });

    it('test_processAddOrUpdateNtf', Level.LEVEL1, (): void => {
      let entry = new BaseNotification();
      entry.id = 100;
      entry.contentType = -1;
      entry.hashCode = 'testHashCode';
      let ntfList: BaseNotification[] = new Array(entry);
      (immersiveDefaultCardDataHelper as object)['processAddOrUpdateNtf'](ntfList);
      expect(entry).not().assertNull();
    });

    it('test_shouldShowImmersiveNtfData01', Level.LEVEL1, (): void => {
      let ntfData = new ImmersiveNtfData();
      ntfData.id = 100;
      ntfData.groupKey = 'testGroupKey';
      ntfData.hashCode = 'testHashCode';
      let result: boolean = (immersiveDefaultCardDataHelper as object)['shouldShowImmersiveNtfData'](ntfData);
      expect(result).assertFalse();
    });

    it('test_shouldShowImmersiveNtfData02', Level.LEVEL1, (): void => {
      let ntfData = new ImmersiveNtfData();
      ntfData.id = 100;
      ntfData.groupKey = 'testGroupKey';
      ntfData.hashCode = 'testHashCode';
      (immersiveDefaultCardDataHelper as object)['isLiveHideContent'] = true;
      let result: boolean = (immersiveDefaultCardDataHelper as object)['shouldShowImmersiveNtfData'](ntfData);
      expect(result).assertFalse();
    });

    it('test_flagMediaCenter', Level.LEVEL1, (): void => {
      (immersiveDefaultCardDataHelper as object)['flagMediaCenter'](true);
      (immersiveDefaultCardDataHelper as object)['flagMediaCenter'](false);
      expect(immersiveDefaultCardDataHelper).not().assertNull();
    });

    it('test_checkDefaultShowImm', Level.LEVEL1, (): void => {
      (immersiveDefaultCardDataHelper as object)['checkDefaultShowImm']();
      expect(immersiveDefaultCardDataHelper).not().assertNull();
    });

    it('test_tryAddLiveData', Level.LEVEL1, (): void => {
      let entry = new BaseNotification();
      entry.id = 100;
      entry.contentType = -1;
      entry.hashCode = 'testHashCode';
      (immersiveDefaultCardDataHelper as object)['tryAddLiveData'](entry);
      expect(entry).not().assertNull();
    });

    it('test_tryRemoveLiveData', Level.LEVEL1, (): void => {
      (immersiveDefaultCardDataHelper as object)['tryRemoveLiveData']('testHashCode');
      expect(immersiveDefaultCardDataHelper).not().assertNull();
    });

    it('test_tryAddImmData', Level.LEVEL1, (): void => {
      (immersiveDefaultCardDataHelper as object)['tryAddImmData']('testHashCode');
      expect(immersiveDefaultCardDataHelper).not().assertNull();
    });

    it('test_tryRemoveImmData', Level.LEVEL1, (): void => {
      (immersiveDefaultCardDataHelper as object)['tryRemoveImmData']('testHashCode');
      expect(immersiveDefaultCardDataHelper).not().assertNull();
    });
  });
}
