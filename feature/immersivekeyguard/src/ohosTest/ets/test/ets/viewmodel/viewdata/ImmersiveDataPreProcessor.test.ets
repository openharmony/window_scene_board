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
import { ImmersiveCardVm } from '../../../../../../main/ets/viewmodel/ImmersiveCardVm';
import { ImmersiveListVm } from '../../../../../../main/ets/viewmodel/ImmersiveListVm';
import { ImmersiveCapsuleVm } from '../../../../../../main/ets/viewmodel/ImmersiveCapsuleVm';
import { ImmersiveAnimManager } from '../../../../../../main/ets/viewmodel/viewanim/ImmersiveAnimManager';
import { ImmersiveDataGroupPacker } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveDataGroupProcessor';
import { ImmersiveDataPreProcessor } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveDataPreProcessor';
import { ImmersivePanelState } from '../../../../../../main/ets/viewmodel/viewdata/ImmersivePanelState';
import { ImmersiveMeshManager } from '../../../../../../main/ets/viewmodel/viewlayout/ImmersiveMeshManager';
import type Ntf from '@ohos.notificationSubscribe';
import ntfMgr from '@ohos.notificationManager';
import {
  BaseNotification, ImmersiveEntryEvent, NtfEventType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { EvtBus } from '@ohos/frameworkwrapper';

/**
 * 沉浸式锁屏数据预处理测试用例
 */
export function ImmersiveDataPreProcessorTest() {
  describe('ImmersiveDataPreProcessorTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterAll((): void => {
    });

    afterEach((): void => {
    });

    it('testInit01', Level.LEVEL1, (): void => {
      let handle = new ImmersiveDataPreProcessor();
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      let packer = new ImmersiveDataGroupPacker();
      let cardVm = new ImmersiveCardVm(animManager, packer);
      let capsuleVm = new ImmersiveCapsuleVm(animManager, packer);
      handle.init(listVm, cardVm, capsuleVm);
      expect(handle).not().assertNull();
    });

    it('handleNtfInit', Level.LEVEL1, (): void => {
      let entry = new BaseNotification();
      entry.id = 100;
      entry.contentType = -1;
      let event = new ImmersiveEntryEvent();
      event.eventType = NtfEventType.EVENT_TYPE_INIT;
      event.notificationList = new Array(entry);
      EvtBus.post(ImmersiveEntryEvent, event)
      expect(entry).not().assertNull();
    });

    it('testDestroy', Level.LEVEL1, (): void => {
      let handle = new ImmersiveDataPreProcessor();
      handle.destroy();
      expect(handle).not().assertNull();
    });

    it('handleNtfAddUpdate1', Level.LEVEL1, (): void => {
      let entry = new BaseNotification();
      entry.id = 100;
      entry.contentType = -1;
      let event = new ImmersiveEntryEvent();
      event.eventType = NtfEventType.EVENT_TYPE_POST_ADD;
      event.notificationList = new Array(entry);
      EvtBus.post(ImmersiveEntryEvent, event)
      expect(entry).not().assertNull();
    });


    it('handleNtfAddUpdate2', Level.LEVEL1, (): void => {
      let entry = new BaseNotification();
      entry.id = 100;
      entry.contentType = -1;
      let event = new ImmersiveEntryEvent();
      event.eventType = NtfEventType.EVENT_TYPE_POST_UPDATE;
      event.notificationList = new Array(entry);
      EvtBus.post(ImmersiveEntryEvent, event)
      expect(entry).not().assertNull();
    });

    it('handleNtfRemove', Level.LEVEL1, (): void => {
      let entry = new BaseNotification();
      entry.id = 100;
      entry.contentType = -1;
      let event = new ImmersiveEntryEvent();
      event.eventType = NtfEventType.EVENT_TYPE_POST_CANCEL;
      event.notificationList = new Array(entry);
      EvtBus.post(ImmersiveEntryEvent, event)
      expect(entry).not().assertNull();
    });

    it('testHandleNtfInit01', Level.LEVEL0, (): void => {
      let handle = new ImmersiveDataPreProcessor();
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      let callback = () => {
      };
      let packer = new ImmersiveDataGroupPacker();
      let cardVm = new ImmersiveCardVm(animManager, packer);
      let capsuleVm = new ImmersiveCapsuleVm(animManager, packer);
      handle.init(listVm, cardVm, capsuleVm);
      expect(handle).not().assertNull();
    });

    it('testHandleNtfInit02', Level.LEVEL0, (): void => {
      let handle = new ImmersiveDataPreProcessor();
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      let callback = () => {
      };
      let packer = new ImmersiveDataGroupPacker();
      let cardVm = new ImmersiveCardVm(animManager, packer);
      let capsuleVm = new ImmersiveCapsuleVm(animManager, packer);
      handle.init(listVm, cardVm, capsuleVm);
      let event: ImmersiveEntryEvent = new ImmersiveEntryEvent();
      event.eventType = -1;
      expect(handle).not().assertNull();
    });

    it('testHandleNtfInit03', Level.LEVEL0, (): void => {
      let handle = new ImmersiveDataPreProcessor();
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      let callback = () => {
      };
      let packer = new ImmersiveDataGroupPacker();
      let cardVm = new ImmersiveCardVm(animManager, packer);
      let capsuleVm = new ImmersiveCapsuleVm(animManager, packer);
      handle.init(listVm, cardVm, capsuleVm);

      let event: ImmersiveEntryEvent = new ImmersiveEntryEvent();
      event.eventType = NtfEventType.EVENT_TYPE_INIT;
      expect(handle).not().assertNull();
    });

    it('testHandleNtfAddOrUpdate01', Level.LEVEL0, (): void => {
      let handle = new ImmersiveDataPreProcessor();
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      let callback = () => {
      };
      let packer = new ImmersiveDataGroupPacker();
      let cardVm = new ImmersiveCardVm(animManager, packer);
      let capsuleVm = new ImmersiveCapsuleVm(animManager, packer);
      handle.init(listVm, cardVm, capsuleVm);

      let event: ImmersiveEntryEvent = new ImmersiveEntryEvent();
      event.eventType = NtfEventType.EVENT_TYPE_POST_UPDATE;
      event.notificationList = [];
      EvtBus.post(ImmersiveEntryEvent, event);
      expect(handle).not().assertNull();
    });

    it('testHandleNtfRemove01', Level.LEVEL0, (): void => {
      let handle = new ImmersiveDataPreProcessor();
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      let packer = new ImmersiveDataGroupPacker();
      let cardVm = new ImmersiveCardVm(animManager, packer);
      let capsuleVm = new ImmersiveCapsuleVm(animManager, packer);
      handle.init(listVm, cardVm, capsuleVm);

      let event: ImmersiveEntryEvent = new ImmersiveEntryEvent();
      event.eventType = NtfEventType.EVENT_TYPE_POST_CANCEL;
      EvtBus.post(ImmersiveEntryEvent, event);
      expect(handle).not().assertNull();
    });

    it('testHandleNtfRemove02', Level.LEVEL0, (): void => {
      let handle = new ImmersiveDataPreProcessor();
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      let packer = new ImmersiveDataGroupPacker();
      let cardVm = new ImmersiveCardVm(animManager, packer);
      let capsuleVm = new ImmersiveCapsuleVm(animManager, packer);
      handle.init(listVm, cardVm, capsuleVm);
      let event: ImmersiveEntryEvent = new ImmersiveEntryEvent();
      event.eventType = NtfEventType.EVENT_TYPE_POST_CANCEL;
      event.notificationList = [];
      EvtBus.post(ImmersiveEntryEvent, event);
      expect(handle).not().assertNull();
    });
  });
}
