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
import { immersiveVm } from '../../../../../main/ets/viewmodel/ImmersiveVm';
import { immersiveKgMgr, ImmersiveType } from '@ohos/systemuicommon';

/**
 * 沉浸式锁屏测试用例
 */
export function ImmersiveVmTest() {
  describe('ImmersiveVmTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterAll((): void => {
    });

    afterEach((): void => {
    });

    it('testInitVm', Level.LEVEL0, (): void => {
      immersiveVm.initVm();
      immersiveVm.destroy();
      (immersiveVm as object)['ntfListVM'] = undefined;
      immersiveVm.destroy();
      expect(immersiveVm).not().assertNull();
    });

    it('testGetImmersiveAnimMgr', Level.LEVEL0, (): void => {
      let res = immersiveVm.getImmersiveAnimMgr();
      expect(res).not().assertNull();
    });

    it('testGetImmersiveCapsuleVm', Level.LEVEL0, (): void => {
      let res = immersiveVm.getImmersiveCapsuleVm();
      expect(res).not().assertNull();
    });

    it('testGetImmersiveListVm', Level.LEVEL0, (): void => {
      let res = immersiveVm.getImmersiveListVm();
      expect(res).not().assertNull();
    });

    it('testGetImmersiveCardVm', Level.LEVEL0, (): void => {
      let res = immersiveVm.getImmersiveCardVm();
      expect(res).not().assertNull();
    });

    it('testGetImmersiveCapsuleHandle', Level.LEVEL0, (): void => {
      let res = immersiveVm.getImmersiveCapsuleHandle();
      expect(res).not().assertNull();
    });

    it('testGetCardEventHandle', Level.LEVEL0, (): void => {
      let res = immersiveVm.getCardEventHandle();
      expect(res).not().assertNull();
    });

    it('testGetCapsuleExtendStyle', Level.LEVEL0, (): void => {
      let res = immersiveVm.getCapsuleExtendStyle();
      expect(res).not().assertNull();
    });

    it('testGetImmersiveListHandle', Level.LEVEL0, (): void => {
      let res = immersiveVm.getImmersiveListHandle();
      expect(res).not().assertNull();
    });

    it('testGetNtfList', Level.LEVEL0, (): void => {
      let res = immersiveVm.getNtfList();
      expect(res).not().assertNull();
    });

    it('testGetImmersiveMeshManager', Level.LEVEL0, (): void => {
      let res = immersiveVm.getImmersiveMeshManager();
      expect(res).not().assertNull();
    });

    it('testFindNativeData', Level.LEVEL0, (): void => {
      let res = immersiveVm.findNativeData('');
      expect(res).not().assertNull();
    });

    it('testFindGroupData', Level.LEVEL0, (): void => {
      let res = immersiveVm.findGroupData('');
      expect(res).not().assertNull();
    });

    it('testSetImmersivePanelHeight', Level.LEVEL0, (): void => {
      immersiveVm.setImmersivePanelHeight(100);
      immersiveVm.setImmersivePanelHeight('100');
      expect(immersiveVm).not().assertNull();
    });

    it('testGetNtfListInfoKeyGuard', Level.LEVEL0, (): void => {
      immersiveVm.getNtfListInfoKeyGuard();
      expect(immersiveVm).not().assertNull();
    });

    it('testProcessDataChange', Level.LEVEL0, (): void => {
      (immersiveVm as object)['processDataChange'](undefined);
      (immersiveVm as object)['processDataChange'](true);
      (immersiveVm as object)['processDataChange'](false);
      expect(immersiveVm).not().assertNull();
    });

    it('testHandleImmersiveBackEvent', Level.LEVEL0, (): void => {
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
      immersiveVm.handleImmersiveBackEvent();
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
      immersiveVm.handleImmersiveBackEvent();
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
      immersiveVm.handleImmersiveBackEvent();
      expect(immersiveVm).not().assertNull();
    });
  });
}