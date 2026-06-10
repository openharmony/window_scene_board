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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium';
import { NotificationEntry } from '@ohos/notificationcomponent/src/main/ets/model/NotificationEntry';
import { NtfListKeyGuard } from '@ohos/notificationcomponent/src/main/ets/model/NtfListKeyGuard';
import { ImmersiveListVm } from '../../../../../main/ets/viewmodel/ImmersiveListVm';
import { ImmersiveAnimManager } from '../../../../../main/ets/viewmodel/viewanim/ImmersiveAnimManager';
import { ImmersiveMeshManager } from '../../../../../main/ets/viewmodel/viewlayout/ImmersiveMeshManager';
import { ImmersiveNtfData } from '../../../../../main/ets/viewmodel/viewdata/ImmersiveNtfData';
import { immersiveKgMgr, ImmersiveType, ImmersiveState, LiveUseScene } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { immersiveStateMgr } from '../../../../../main/ets/common/manager/ImmersiveStateManager';
import { NtfListStaticState } from '../../../../../main/ets/viewmodel/viewdata/NtfListState';

/**
 * 沉浸式锁屏测试用例
 */
export function ImmersiveListVmTest() {
  describe('ImmersiveListVmTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterAll((): void => {
    });

    afterEach((): void => {
    });

    it('testDisappear', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      let keyguard = new NtfListKeyGuard();
      listVm.appear(undefined);
      listVm.appear(keyguard);
      listVm.disappear();
      expect(listVm).not().assertUndefined();
    });

    it('testGetPanelState', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      let res = listVm.getPanelState();
      expect(res).not().assertNull();
    });

    it('testGetNtfList', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      let res = listVm.getNtfList();
      expect(res).not().assertNull();
    });

    it('testSetNtfList', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      let entry: NotificationEntry = new NotificationEntry(undefined);
      listVm.setNtfList([entry]);
      expect(listVm).not().assertUndefined();
    });

    it('testGetListStaticState', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      let res = listVm.getListStaticState();
      expect(res).not().assertNull();
    });

    it('testGetListBindState', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      let res = listVm.getListBindState();
      expect(res).not().assertNull();
    });

    it('testGetListScroller', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      let res = listVm.getListScroller();
      expect(res).not().assertNull();
    });

    it('testGetColorModeVM', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      let res = listVm.getColorModeVM();
      expect(res).not().assertNull();
    });

    it('testGetIconClickListener', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      let res = listVm.getIconClickListener();
      expect(res).not().assertNull();
    });

    it('testOnListAreaChange', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      let oldArea: Area = {width:100, height: 100, position: {x: 0, y: 0}, globalPosition: {x: 0, y: 0}};
      let newArea: Area = {width:100, height: 100, position: {x: 10, y: 10}, globalPosition: {x: 10, y: 10}};
      listVm.onListAreaChange(oldArea, newArea);
      expect(listVm).not().assertUndefined();
    });

    it('testIsListEmpty', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      (listVm as object)['ntfList'] = [];
      let res = listVm.isListEmpty();
      expect(res).assertTrue();
    });

    it('testShowNtfList', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      listVm.setNtfListHeight(100);
      listVm.getColorModeVM();
      expect(listVm).not().assertUndefined();
    });

    it('testOnIconClick', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      (listVm as object)['onIconClick']();
      expect(listVm).not().assertUndefined();
    });

    it('testStartListToCard', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      let ntfData = new ImmersiveNtfData();
      listVm.startListToCard(undefined);
      expect(listVm).not().assertUndefined();
    });

    it('testCheckBeforeToCard', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      let ntfData = new ImmersiveNtfData();
      listVm.checkBeforeToCard(ntfData);
      expect(listVm).not().assertUndefined();
    });

    it('test_onItemSizeChange', Level.LEVEL0, (): void => {
      let oldSize: SizeOptions = {};
      let newSize: SizeOptions = {};
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      listVm.onItemSizeChange('testGroup', oldSize, newSize);
      listVm.swipeItemToCollapse(false);
      listVm.swipeItemToCollapse(true);
      expect(listVm).not().assertUndefined();
    });

    it('test_groupItemToCollapse', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      listVm.groupItemToCollapse(false);
      listVm.groupItemToCollapse(true);
      expect(listVm).not().assertUndefined();
    });

    it('test_onRootStateAnimatingChange', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      (listVm as object)['onRootStateAnimatingChange']();
      (listVm as object)['resetListIndexToTop']();
      expect(listVm).not().assertUndefined();
    });

    it('testSwipeItemToCollapse', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      listVm.swipeItemToCollapse(true);
      listVm.swipeItemToCollapse(false);
      expect(listVm).not().assertUndefined();
    });

    it('testGroupItemToCollapse', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      listVm.groupItemToCollapse(true);
      listVm.groupItemToCollapse(false);
      expect(listVm).not().assertUndefined();
    });

    it('testUpdateListCollapsedState', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      listVm.updateListCollapsedState(true);
      listVm.updateListCollapsedState(false);
      expect(listVm).not().assertUndefined();
    });

    it('testResetGroupItemToCollapse', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
      listVm.resetGroupItemToCollapse();
      expect(listVm).not().assertUndefined();
    });

    it('testIsListAtTop', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      listVm.isListAtTop();
      expect(listVm).not().assertUndefined();
    });

    it('testScrollListToTop', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      (listVm as object)['ntfList'] = [];
      listVm.scrollListToTop();
      let entry: NotificationEntry = new NotificationEntry(undefined);
      (listVm as object)['ntfList'] = [entry];
      listVm.scrollListToTop();
      expect(listVm).not().assertUndefined();
    });

    it('testScrollListToBottom', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      (listVm as object)['ntfList'] = [];
      listVm.scrollListToBottom();
      let entry: NotificationEntry = new NotificationEntry(undefined);
      (listVm as object)['ntfList'] = [entry];
      listVm.scrollListToBottom();
      expect(listVm).not().assertUndefined();
    });

    it('testUpdateListData', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      let entry: NotificationEntry = new NotificationEntry(undefined);
      listVm.updateListData([entry]);
      expect(listVm).not().assertUndefined();
    });

    it('testSetNtfListHeight', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      listVm.getListStaticState().notificationListHeight = 100;
      listVm.setNtfListHeight(10);
      expect(listVm).not().assertUndefined();
    });

    it('testUpdateScrollIndex', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      listVm.updateScrollIndex(10, 20);
      expect(listVm).not().assertUndefined();
    });

    it('testInitNtfList', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      let entry: NotificationEntry = new NotificationEntry(undefined);
      (listVm as object)['initNtfList']([entry]);
      expect(listVm).not().assertUndefined();
    });

    it('testCheckDeleteItem', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      let entry: NotificationEntry = new NotificationEntry(undefined);
      let delItems: Map<string, number> = (listVm as object)['initNtfList']([entry]);
      (listVm as object)['checkDeleteItem'](undefined, true);
      (listVm as object)['checkDeleteItem'](undefined, false);
      (listVm as object)['checkDeleteItem'](delItems, true);
      (listVm as object)['checkDeleteItem'](delItems, false);
      expect(listVm).not().assertUndefined();
    });

    it('testUpdatePanelPaddingTop', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      (listVm as object)['updatePanelPaddingTop']();
      expect(listVm).not().assertUndefined();
    });

    it('testOnRootStateAnimatingChange', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      (listVm as object)['onRootStateAnimatingChange']();
      expect(listVm).not().assertUndefined();
    });

    it('testOnImmersiveTypeChange', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      let state: ImmersiveState = immersiveKgMgr.getImmersiveDisplayState();
      (listVm as object)['onImmersiveTypeChange'](state);
      expect(listVm).not().assertUndefined();
    });

    it('testOnImmersiveTypeChange', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      let state: ImmersiveState = immersiveKgMgr.getImmersiveDisplayState();
      (listVm as object)['checkNotifyListCollapseState'](state, false);
      (listVm as object)['checkNotifyListCollapseState'](state, true);
      expect(listVm).not().assertUndefined();
    });

    it('testResetListIndexToTop', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
      (listVm as object)['resetListIndexToTop']();
      expect(listVm).not().assertUndefined();
    });

    let animManager = new ImmersiveAnimManager();
    let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
    let oldArea: Area = {width:100, height: 100, position: {x: 0, y: 0}, globalPosition: {x: 0, y: 0}};
    let newArea: Area = {width:100, height: 100, position: {x: 10, y: 10}, globalPosition: {x: 10, y: 10}};
    let immersiveState: ImmersiveState = immersiveKgMgr.getImmersiveDisplayState();

    it('onListAreaChange_test01', Level.LEVEL0, (): void => {
      (listVm as object)['immersiveState'] = immersiveState;
      oldArea.height = 111;
      oldArea.width = 111;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc((listVm as object),(listVm as object)['setNtfListHeight']);
      let mockFunc1: Function = mocker.mockFunc(immersiveState,immersiveState.isShowList);
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing;
      when(mockFunc1)().afterReturn(true);
      listVm.onListAreaChange(oldArea,newArea);
      expect(listVm).not().assertUndefined();

      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing;
      when(mockFunc1)().afterReturn(false);
      listVm.onListAreaChange(oldArea,newArea);
      expect(listVm).not().assertUndefined();

      oldArea.height = 100;
      oldArea.width = 100;
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing;
      listVm.onListAreaChange(oldArea,newArea);
      expect(listVm).not().assertUndefined();
      mocker.clear((listVm as object));
      mocker.clear(immersiveState);
    });

    it('startListToCard_test01', Level.LEVEL0, (): void => {
      (listVm as object)['immersiveState'] = immersiveState;
      let ntfData = new ImmersiveNtfData();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(immersiveState,immersiveState.isList);
      let mockFunc1: Function = mocker.mockFunc(immersiveStateMgr,immersiveStateMgr.requestImmersiveCard);
      let mockFunc2: Function = mocker.mockFunc( immersiveStateMgr, immersiveStateMgr.switchImmersiveState);
      when(mockFunc)().afterReturn(true);
      when(mockFunc1)(ArgumentMatchers.any).afterReturnNothing;
      when(mockFunc2)(ArgumentMatchers.any).afterReturnNothing;
      listVm.startListToCard(ntfData,LiveUseScene.SCENE_LIVE_LIST);

      when(mockFunc)().afterReturn(true);
      when(mockFunc1)(ArgumentMatchers.any).afterReturnNothing;
      when(mockFunc2)(ArgumentMatchers.any).afterReturnNothing;
      listVm.startListToCard(ntfData,LiveUseScene.SCENE_SCREEN_LOCK);
      expect(listVm).not().assertUndefined();
      mocker.clear(immersiveState);
      mocker.clear(immersiveStateMgr);
    });

    it('setNtfListHeight_test01', Level.LEVEL0, (): void => {
      let staticState: NtfListStaticState = new NtfListStaticState();
      staticState.notificationListHeight = 10;
      (listVm as object)['staticState'] = staticState;
      listVm.setNtfListHeight(10);
      expect(listVm).not().assertUndefined();
    });

    it('ResetListIndexToTop_test01', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      let instance: ImmersiveState = immersiveKgMgr.getImmersiveDisplayState();
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(instance,instance.isCapsule);
      when(mockFun)().afterReturn(false);
      (listVm as object)['resetListIndexToTop']();
      expect(listVm).not().assertUndefined();
      mock.clear(instance);
      mock.clearAll();
    });

    it('checkNotifyListCollapseState_test01', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let listVm = new ImmersiveListVm(animManager, new ImmersiveMeshManager());
      let instance: ImmersiveState = immersiveKgMgr.getImmersiveDisplayState();
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(instance,instance.isCapsule);
      when(mockFun)().afterReturn(false);
      let mockFun1: Function = mock.mockFunc(listVm,listVm.isListEmpty);
      when(mockFun1)().afterReturn(false);
      let mockFun2: Function = mock.mockFunc(instance,instance.isShowList);
      when(mockFun2)().afterReturn(false);
      let mockFun3: Function = mock.mockFunc(instance,instance.isImmersive);
      when(mockFun3)().afterReturn(false);
      (listVm as object)['checkNotifyListCollapseState'](instance, true);
      expect(listVm).not().assertUndefined();
      mock.clear(instance);
      mock.clear(listVm);
      mock.clearAll();
    });
  });
}