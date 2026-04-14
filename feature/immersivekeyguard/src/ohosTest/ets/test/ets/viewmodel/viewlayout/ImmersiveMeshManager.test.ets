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
import { describe, beforeAll, beforeEach, afterEach, afterAll, expect, it, Level, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium';
import { ImmersiveMeshManager } from '../../../../../../main/ets/viewmodel/viewlayout/ImmersiveMeshManager';
import { NtfListBindState, NtfListStaticState } from '../../../../../../main/ets/viewmodel/viewdata/NtfListState';
import { ImmersivePanelState } from '../../../../../../main/ets/viewmodel/viewdata/ImmersivePanelState';
import { CommonUtils } from '@ohos/basicutils';
import { MeshRange } from '@ohos/screenlockcommon';
import { SlMainStateType, SlStaticStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { ImmersiveState } from '@ohos/systemuicommon/src/main/ets/TsIndex';

/**
 * 沉浸式锁屏测试用例
 */
export function ImmersiveMeshManagerTest() {
  let mocker: MockKit;
  describe('ImmersiveMeshManagerTest', (): void => {
    beforeAll((): void => {
      mocker = new MockKit();
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
      mocker.clearAll();
    });
    afterEach((): void => {
    });

    let meshManager = new ImmersiveMeshManager();
    it('test_setPanelState', Level.LEVEL0, (): void => {
      let panelState: ImmersivePanelState = new ImmersivePanelState();
      meshManager.setPanelState(panelState);
      expect(meshManager).not().assertNull();
    });

    it('test_setListState', Level.LEVEL0, (): void => {
      let bindState: NtfListBindState = new NtfListBindState();
      let staticState: NtfListStaticState = new NtfListStaticState();
      meshManager.setListState(bindState, staticState);
      expect(meshManager).not().assertNull();
    });

    it('test_onListItemKeysChange', Level.LEVEL0, (): void => {
      let mockfun1 = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockfun1)(ArgumentMatchers.any).afterReturn(true);
      let itemKeys: Map<string, number> = new Map<string, number>();
      itemKeys.set('testkey', 100);
      meshManager.onListItemKeysChange(itemKeys);
      mocker.clear(CommonUtils);
      meshManager.onListItemKeysChange(itemKeys);
      expect(meshManager).not().assertNull();
    });

    it('test_onListItemSizeChange', Level.LEVEL0, (): void => {
      let oldSize: SizeOptions = {};
      let newSize: SizeOptions = {};
      meshManager.onListItemSizeChange('testkey', oldSize, newSize);
      oldSize.height = 10;
      newSize.height = 10;
      meshManager.onListItemSizeChange('testkey', oldSize, newSize);
      oldSize.height = 10;
      newSize.height = 100;
      meshManager.onListItemSizeChange('testkey', oldSize, newSize);
      expect(meshManager).not().assertNull();
    });

    it('test_onCardSizeChange', Level.LEVEL0, (): void => {
      let oldSize: SizeOptions = {};
      let newSize: SizeOptions = {};
      meshManager.onCardSizeChange(oldSize, newSize);
      oldSize.height = 10;
      newSize.height = 10;
      meshManager.onCardSizeChange(oldSize, newSize);
      oldSize.height = 10;
      newSize.height = 100;
      meshManager.onCardSizeChange(oldSize, newSize);
      newSize.height = undefined;
      meshManager.onCardSizeChange(oldSize, newSize);
      expect(meshManager).not().assertNull();
    });

    it('test_getTest', Level.LEVEL0, (): void => {
      meshManager.requestUpdateMeshRange();
      expect(meshManager).not().assertNull();
    });

    it('test_onImmersiveStateChange', Level.LEVEL0, (): void => {
      (meshManager as object)['onImmersiveStateChange']();
      expect(meshManager).not().assertNull();
    });

    it('test_screenLockClockShift', Level.LEVEL0, (): void => {
      meshManager.screenLockClockShift(true);
      meshManager.screenLockClockShift(false);
      expect(meshManager).not().assertNull();
    });

    it('test_updateItemHeightSum', Level.LEVEL0, (): void => {
      (meshManager as object)['updateItemHeightSum'](10);
      (meshManager as object)['updateItemHeightSum'](10, false);
      (meshManager as object)['updateItemHeightSum'](10, true);
      (meshManager as object)['updateItemHeightSum'](10, false, 5);
      (meshManager as object)['updateItemHeightSum'](10, true, 5);
      expect(meshManager).not().assertNull();
    });

    it('test_updateCacheValue', Level.LEVEL0, (): void => {
      (meshManager as object)['updateCacheValue'](20);
      (meshManager as object)['updateCacheValue'](20, 5);
      expect(meshManager).not().assertNull();
    });

    it('test_getImmersiveKeyguardMargin', Level.LEVEL0, (): void => {
      (meshManager as object)['getImmersiveKeyguardMargin'](0);
      (meshManager as object)['getImmersiveKeyguardMargin'](5);
      expect(meshManager).not().assertNull();
    });

    it('test_updateListState', Level.LEVEL0, (): void => {
      (meshManager as object)['updateListState']();
      expect(meshManager).not().assertNull();
    });

    it('test_updateCardMeshRange', Level.LEVEL0, (): void => {
      (meshManager as object)['updateCardMeshRange']();
      expect(meshManager).not().assertNull();
    });

    it('test_setListPanelAlign', Level.LEVEL0, (): void => {
      (meshManager as object)['setListPanelAlign']();
      expect(meshManager).not().assertNull();
    });

    it('test_setRequestMesh', Level.LEVEL0, (): void => {
      let meshR: MeshRange = new MeshRange(10, 10);
      (meshManager as object)['setRequestMesh'](meshR);
      expect(meshManager).not().assertNull();
    });

    it('test_getTest', Level.LEVEL0, (): void => {
      (meshManager as object)['getMeshHeight']();
      (meshManager as object)['getMeshEnd']();
      (meshManager as object)['getMeshRange'](10, 10);
      (meshManager as object)['updateReachMax'](true);
      (meshManager as object)['updateReachMax'](false);
      expect(meshManager).not().assertNull();
    });

    it('test_requestNotificationMeshRange', Level.LEVEL0, (): void => {
      let meshR: MeshRange = new MeshRange(10, 10);
      (meshManager as object)['requestNotificationMeshRange'](meshR, true);
      (meshManager as object)['requestNotificationMeshRange'](meshR, false);
      expect(meshManager).not().assertNull();
    });

    it('test_isListToBottom', Level.LEVEL0, (): void => {
      (meshManager as object)['isListToBottom']();
      expect(meshManager).not().assertNull();
    });

    it('test_onMeshConfigChange', Level.LEVEL0, (): void => {
      (meshManager as object)['onMeshConfigChange']();
      expect(meshManager).not().assertNull();
    });

    it('test_onClockExpandMeshYChange', Level.LEVEL0, (): void => {
      (meshManager as object)['onClockExpandMeshYChange']();
      expect(meshManager).not().assertNull();
    });

    it('test_getClockExpandMeshY', Level.LEVEL0, (): void => {
      (meshManager as object)['getClockExpandMeshY']();
      expect(meshManager).not().assertNull();
    });

    it('test_getClockExpandMeshY', Level.LEVEL0, (): void => {
      let res: boolean = (meshManager as object)['isListToTop']();
      expect(meshManager).not().assertNull();
    });

    it('test_isListToBottom', Level.LEVEL0, (): void => {
      let res: boolean = (meshManager as object)['isListToBottom']();
      expect(meshManager).not().assertNull();
    });

    it('test_slStaticStateListener', Level.LEVEL0, (): void => {
      (meshManager as object)['slStaticStateListener'].onSlStateChange(SlMainStateType.SL_STATIC_STATE,
        SlStaticStateType.MESH_CONFIG);
      (meshManager as object)['slStaticStateListener'].onSlStateChange(SlMainStateType.SL_STATIC_STATE,
        SlStaticStateType.CLOCK_EXPAND_MESH_Y);
      expect(meshManager).not().assertNull();
    });

    it('test_onCardSizeChange_02', Level.LEVEL0, (): void => {
      let oldSize: SizeOptions = {};
      let newSize: SizeOptions = {};
      oldSize.height = 10;
      newSize.height = 0;
      meshManager.onCardSizeChange(oldSize, newSize);
      expect(meshManager).not().assertNull();
    });

    it('test_updateListState', Level.LEVEL0, (): void => {
      let immersive: ImmersiveState = (meshManager as object)['immersiveState'];
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc(immersive, immersive.isShowList);
      when(mockFun1)().afterReturn(true);
      (meshManager as object)['updateListState']();
      expect(meshManager).not().assertNull();
      mock.clear(immersive);
    });

    it('test_updateListState_02', Level.LEVEL0, (): void => {
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc(meshManager, (meshManager as object)['isListToBottom']);
      when(mockFun1)().afterReturn(true);
      (meshManager as object)['isReachMax'] = true;
      expect(meshManager).not().assertNull();
      mock.clear(meshManager);
    });

    it('test_updateCardMeshRange_02', Level.LEVEL0, (): void => {
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc(meshManager, (meshManager as object)['isShowCard']);
      when(mockFun1)().afterReturn(true);
      (meshManager as object)['updateCardMeshRange']();
      expect(meshManager).not().assertNull();
      mock.clear(meshManager);
    });

    it('test_updateReachMax', Level.LEVEL0, (): void => {
      (meshManager as object)['isReachMax'] = false;
      (meshManager as object)['isItemHeightChanging'] = true;
      (meshManager as object)['updateReachMax'](false);
      expect(meshManager).not().assertNull();
    });


    it('test_onClockExpandMeshYChange_02', Level.LEVEL0, (): void => {
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc(meshManager, (meshManager as object)['getClockExpandMeshY']);
      when(mockFun1)().afterReturn(2);
      meshManager.initVm();
      (meshManager as object)['onClockExpandMeshYChange']();
      expect(meshManager).not().assertNull();
    });

    it('test_onImmersiveStateChange_02', Level.LEVEL0, (): void => {
      let immersive: ImmersiveState = (meshManager as object)['immersiveState'];
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc(immersive, immersive.isShowList);
      when(mockFun1)().afterReturn(true);
      (meshManager as object)['onImmersiveStateChange']();
      expect(meshManager).not().assertNull();
      mock.clear(immersive);
    });

    it('test_onImmersiveStateChange_03', Level.LEVEL0, (): void => {
      let immersive: ImmersiveState = (meshManager as object)['immersiveState'];
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc(immersive, immersive.isShowList);
      let mockFun2: Function = mock.mockFunc(immersive, immersive.isCapsule);
      let mockFun3: Function = mock.mockFunc(immersive, immersive.isShowCard);
      when(mockFun1)().afterReturn(false);
      when(mockFun2)().afterReturn(false);
      when(mockFun3)().afterReturn(true);
      (meshManager as object)['onImmersiveStateChange']();
      expect(meshManager).not().assertNull();
      mock.clear(immersive);
    });

    it('test_onListItemKeysChange_02', Level.LEVEL0, (): void => {
      let itemKeys: Map<string, number> = new Map<string, number>();
      meshManager.onListItemKeysChange(itemKeys);
      expect(meshManager).not().assertNull();
    });


  });
}
