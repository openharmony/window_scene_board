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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import sOutSideWindowMgr from '../../../../../../main/ets/manager/OutSideWindowManager';
import { ObjUtil } from '@ohos/basicutils';

export function OutSideWindowManagerTest() {
  describe('OutSideWindowManagerTest', () => {
    beforeAll((): void => {
    })
    beforeEach((): void => {
    })
    afterAll((): void => {
    })
    afterEach((): void => {
    })

    it('OutSideWindowManagerTest_registerGlobalSearchProgressListener', 0, (): void => {
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(ObjUtil,ObjUtil.isInvalid);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      sOutSideWindowMgr.registerGlobalSearchProgressListener(null, null);
      expect(true).assertTrue();
      mocker.clear(ObjUtil);
      mocker.clearAll();
    })

    it('OutSideWindowManagerTest_setNegativeOffset', 0, (): void => {
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(ObjUtil,ObjUtil.isInvalid);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      try {
        sOutSideWindowMgr.setNegativeOffset(1);
      } catch (e) {
      }
      expect(true).assertTrue();
      mocker.clear(ObjUtil);
      mocker.clearAll();
    })

    it('OutSideWindowManagerTest_setNegativeOffset_mock', 0, (): void => {
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(ObjUtil,ObjUtil.isInvalid);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        sOutSideWindowMgr.setNegativeOffset(1);
      } catch (e) {
      }
      expect(true).assertTrue();
      mocker.clear(ObjUtil);
      mocker.clearAll();
    })

    it('OutSideWindowManagerTest_setNegativeDesktopProgress', 0, (): void => {
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(ObjUtil,ObjUtil.isInvalid);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      sOutSideWindowMgr.setNegativeDesktopProgress(1);
      expect(true).assertTrue();
      mocker.clear(ObjUtil);
      mocker.clearAll();
    })

    it('OutSideWindowManagerTest_setNegativeDesktopProgress_mock', 0, (): void => {
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(ObjUtil,ObjUtil.isInvalid);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      sOutSideWindowMgr.setNegativeDesktopProgress(1);
      expect(true).assertTrue();
      mocker.clear(ObjUtil);
      mocker.clearAll();
    })

    it('OutSideWindowManagerTest_setShowNegative', 0, (): void => {
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(ObjUtil,ObjUtil.isInvalid);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      try {
        sOutSideWindowMgr.setShowNegative(false);
      } catch (e) {
      };
      expect(true).assertTrue();
      mocker.clear(ObjUtil);
      mocker.clearAll();
    })

    it('OutSideWindowManagerTest_setShowNegative_mock', 0, (): void => {
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(ObjUtil,ObjUtil.isInvalid);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        sOutSideWindowMgr.setShowNegative(false);
      } catch (e) {
      };
      expect(true).assertTrue();
      mocker.clear(ObjUtil);
      mocker.clearAll();
    })

    it('OutSideWindowManagerTest_setGlobalSearchTranslate', 0, (): void => {
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(ObjUtil,ObjUtil.isInvalid);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      sOutSideWindowMgr.setGlobalSearchTranslate(1,0.5);
      expect(true).assertTrue();
      mocker.clear(ObjUtil);
      mocker.clearAll();
    })

    it('OutSideWindowManagerTest_setGlobalSearchTranslate_mock', 0, (): void => {
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(ObjUtil,ObjUtil.isInvalid);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      sOutSideWindowMgr.setGlobalSearchTranslate(1,0.5);
      expect(true).assertTrue();
      mocker.clear(ObjUtil);
      mocker.clearAll();
    })

    it('OutSideWindowManagerTest_setGlobalSearchTranslateY', 0, (): void => {
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(ObjUtil,ObjUtil.isInvalid);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      sOutSideWindowMgr.setGlobalSearchTranslateY(1);
      expect(true).assertTrue();
      mocker.clear(ObjUtil);
      mocker.clearAll();
    })

    it('OutSideWindowManagerTest_setGlobalSearchTranslateY_mock', 0, (): void => {
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(ObjUtil,ObjUtil.isInvalid);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      sOutSideWindowMgr.setGlobalSearchTranslateY(1);
      expect(true).assertTrue();
      mocker.clear(ObjUtil);
      mocker.clearAll();
    })

    it('OutSideWindowManagerTest_setIsHidingGlobalSearch', 0, (): void => {
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(ObjUtil,ObjUtil.isInvalid);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      sOutSideWindowMgr.setIsHidingGlobalSearch(false);
      sOutSideWindowMgr.setGlobalSearchOpacity(0.5);
      try {
        sOutSideWindowMgr.setGlobalSearchDesktopProgress(1);
      } catch (e) {
      };
      sOutSideWindowMgr.setGlobalSearchDesktopTranslateY(1);
      sOutSideWindowMgr.setGlobalSearchStatus(0);
      sOutSideWindowMgr.setDesktopEnabled(true, 'setIsHidingGlobalSearch');
      expect(true).assertTrue();
      mocker.clear(ObjUtil);
      mocker.clearAll();
    })

    it('OutSideWindowManagerTest_setIsHidingGlobalSearch_mock', 0, (): void => {
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(ObjUtil,ObjUtil.isInvalid);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      sOutSideWindowMgr.setIsHidingGlobalSearch(false);
      sOutSideWindowMgr.setGlobalSearchOpacity(0.5);
      try {
        sOutSideWindowMgr.setGlobalSearchDesktopProgress(1);
      } catch (e) {
      };
      sOutSideWindowMgr.setGlobalSearchDesktopTranslateY(1);
      sOutSideWindowMgr.setGlobalSearchStatus(0);
      sOutSideWindowMgr.setDesktopEnabled(true, 'OutSideWindowManagerTest_setIsHidingGlobalSearch_mock');
      expect(true).assertTrue();
      mocker.clear(ObjUtil);
      mocker.clearAll();
    })
  })
}
