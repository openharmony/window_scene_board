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

import {
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium';
import SmartDockDragHandler from '../../../../main/ets/default/common/SmartDockDragHandler';
import { CommonConstants,
  DisappearLastAppData,
  DockContinuableInfo,
  GridLayoutUtil,
  LaunchLayoutCacheManager,
  layoutLockUtil,
  RdbStoreManager,
  RecentLayoutCacheMgr,
  ResidentLayoutCacheMgr,
  ShortcutViewModel } from '@ohos/launchercommon';
import { DockItemInfo, GridLayoutItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { DragAccessibilityUtils } from '@ohos/componenthelper';
import { DragItemPosition } from '@ohos/componentdrag';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import { SmartDockStyleMgr } from '../../../../main/ets/default/manager/SmartDockStyleMgr';
import { PageDesktopDragHandler } from '@ohos/pagedesktop';
import SmartDockReorderSolution from '../../../../main/ets/default/common/SmartDockReorderSolution';

export default function SmartDockDragHandlerTest() {
  describe('SmartDockDragHandlerTest', (): void => {
    let instance: SmartDockDragHandler = new SmartDockDragHandler();
    let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
    let mockKit: MockKit = new MockKit();
    const mockFunc1: Function = mockKit.mockFunc(ShortcutViewModel.getInstance(),
      ShortcutViewModel.getInstance()['subscribeColorChangeEvent']);
    when(mockFunc1)(ArgumentMatchers.any).afterReturnNothing();

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_getInstance', 0, () => {
      let instance1 = SmartDockDragHandler.getInstance();
      expect(instance1).not().assertNull();
      let instance2 = SmartDockDragHandler.getInstance();
      expect(instance2).not().assertNull();
    })

    it('test_onDragStart', 0, () => {
      let dragItem: DockItemInfo = new DockItemInfo();
      AppStorage.setOrCreate<DockItemInfo>('dragItemInfo', dragItem);

      instance.onDragStart();
      expect(true).assertTrue();

      dragItem.bundleName = '1'
      AppStorage.set<DockItemInfo>('dragItemInfo', dragItem);
      instance.onDragStart();
      expect(true).assertTrue();
    })

    it('test_onDragStart_01', 0, () => {
      let dragItem: DockItemInfo = new DockItemInfo();
      dragItem.bundleName = '1';
      AppStorage.setOrCreate<DockItemInfo>('dragItemInfo', dragItem);
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [dragItem], false);
      instance.onDragStart();
      expect(instance).not().assertUndefined();
    })

    it('test_onDragEnter', 0, () => {
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(layoutLockUtil, layoutLockUtil.isLocked);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);

      let dragGridItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      dragGridItem.typeId = 1;
      AppStorage.setOrCreate<GridLayoutItemInfo>('dragItemInfo', dragGridItem);

      instance.onDragEnter(0, 0);
      expect(true).assertTrue();

      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      instance.onDragEnter(0, 0);
      expect(true).assertTrue();

      dragGridItem.bundleName = '1'
      AppStorage.set<GridLayoutItemInfo>('dragItemInfo', dragGridItem);
      instance.onDragEnter(0, 0);
      expect(true).assertTrue();

      dragGridItem.typeId = CommonConstants.TYPE_APP;
      AppStorage.set<GridLayoutItemInfo>('dragItemInfo', dragGridItem);
      instance.onDragEnter(0, 0);
      expect(true).assertTrue();

      dragGridItem.typeId = CommonConstants.TYPE_FOLDER;
      AppStorage.set<GridLayoutItemInfo>('dragItemInfo', dragGridItem);
      instance.onDragEnter(0, 0);
      expect(true).assertTrue();

      AppStorage.delete('dragItemInfo');
      mockKit.clear(layoutLockUtil);
      mockKit.clearAll();
    })

    it('test_onDragEnter_01', 0, () => {
      let dragGridItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      dragGridItem.typeId = CommonConstants.TYPE_FOLDER;
      dragGridItem.area = [1,0];
      AppStorage.setOrCreate<GridLayoutItemInfo>('dragItemInfo', dragGridItem);
      instance.onDragEnter(0, 0);
      expect(instance).not().assertUndefined();
    })

    it('test_onDragEnter_02', 0, () => {
      let dragGridItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      dragGridItem.typeId = CommonConstants.TYPE_FOLDER;
      dragGridItem.area = [1,1];
      AppStorage.setOrCreate<GridLayoutItemInfo>('dragItemInfo', dragGridItem);
      instance.onDragEnter(0, 0);
      expect(instance).not().assertUndefined();
    })

    it('test_onDragEnter_03', 0, () => {
      let dragGridItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      dragGridItem.typeId = CommonConstants.TYPE_ADD;
      dragGridItem.area = [1,1];
      AppStorage.setOrCreate<GridLayoutItemInfo>('dragItemInfo', dragGridItem);
      instance.onDragEnter(0, 0);
      expect(instance).not().assertUndefined();
    })

    it('test_onDragEnter_04', 0, () => {
      let dragGridItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      dragGridItem.typeId = CommonConstants.TYPE_APP;
      dragGridItem.area = [1,0];
      AppStorage.setOrCreate<GridLayoutItemInfo>('dragItemInfo', dragGridItem);
      instance.onDragEnter(0, 0);
      expect(instance).not().assertUndefined();
    })

    it('test_onDragEnter_05', 0, () => {
      let dragGridItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      dragGridItem.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      dragGridItem.area = [1,0];
      AppStorage.setOrCreate<GridLayoutItemInfo>('dragItemInfo', dragGridItem);
      instance.onDragEnter(0, 0);
      expect(instance).not().assertUndefined();
    })

    it('test_onDragLeave', 0, () => {
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(layoutLockUtil, layoutLockUtil.isLocked);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);

      let dragItem: DockItemInfo = new DockItemInfo();
      AppStorage.setOrCreate<DockItemInfo>('dragItemInfo', dragItem);

      instance.onDragLeave(0, 0);
      expect(true).assertTrue();

      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      instance.onDragLeave(0, 0);
      expect(true).assertTrue();

      dragItem.bundleName = '1'
      AppStorage.set<DockItemInfo>('dragItemInfo', dragItem);
      instance.onDragLeave(0, 0);
      expect(true).assertTrue();

      dragItem.typeId = CommonConstants.TYPE_APP;
      AppStorage.set<DockItemInfo>('dragItemInfo', dragItem);
      instance.onDragLeave(0, 0);
      expect(true).assertTrue();

      AppStorage.delete('dragItemInfo');
      mockKit.clear(layoutLockUtil);
      mockKit.clearAll();
    })

    it('test_onDragMove', 0, () => {
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(layoutLockUtil, layoutLockUtil.isLocked);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);

      let dragItem: DockItemInfo = new DockItemInfo();
      AppStorage.setOrCreate<DockItemInfo>('dragItemInfo', dragItem);

      instance.onDragMove(0, 0);
      expect(true).assertTrue();

      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      instance.onDragMove(0, 0);
      expect(true).assertTrue();

      dragItem.bundleName = '1'
      AppStorage.set<DockItemInfo>('dragItemInfo', dragItem);
      instance.onDragMove(0, 0);
      expect(true).assertTrue();

      dragItem.typeId = CommonConstants.TYPE_APP;
      AppStorage.set<DockItemInfo>('dragItemInfo', dragItem);
      let targetItem: DockItemInfo = new DockItemInfo();
      const mockFunc5: Function = mockKit.mockFunc((instance as object)['mReorderSolution'],
        (instance as object)['mReorderSolution'].findNearestArea);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(0);
      const mockFunc6: Function = mockKit.mockFunc((instance as object)['mReorderLayout'],
        (instance as object)['mReorderLayout'].getItem);
      when(mockFunc6)(ArgumentMatchers.any).afterReturn(targetItem);
      const mockFunc7: Function = mockKit.mockFunc((instance as object)['mReorderLayout'],
        (instance as object)['mReorderLayout'].getItemIndex);
      when(mockFunc7)(ArgumentMatchers.any).afterReturn(-1);
      const mockFunc8: Function = mockKit.mockFunc((instance as object)['mReorderLayout'],
        (instance as object)['mReorderLayout'].getSolution);
      when(mockFunc8)(ArgumentMatchers.any).afterReturn([]);
      const mockFunc9: Function = mockKit.mockFunc(instance, (instance as object)['setSqueezeTimeout']);
      when(mockFunc9)(ArgumentMatchers.any).afterReturnNothing();
      const mockFunc10: Function = mockKit.mockFunc((instance as object)['mReorderSolution'],
        (instance as object)['mReorderSolution'].isCanCover);
      when(mockFunc10)(ArgumentMatchers.any).afterReturn(true);

      instance.onDragMove(0, 0);
      expect(true).assertTrue();

      when(mockFunc7)(ArgumentMatchers.any).afterReturn(1);
      instance.onDragMove(0, 0);
      expect(true).assertTrue();

      targetItem.keyName = '*'
      instance.onDragMove(0, 0);
      expect(true).assertTrue();

      when(mockFunc10)(ArgumentMatchers.any).afterReturn(false);
      instance.onDragMove(0, 0);
      expect(true).assertTrue();

      when(mockFunc5)(ArgumentMatchers.any).afterReturn(-1);
      instance.onDragMove(0, 0);
      expect(true).assertTrue();

      AppStorage.delete('dragItemInfo');
      mockKit.clear(layoutLockUtil);
      mockKit.clear((instance as object)['mReorderSolution']);
      mockKit.clear((instance as object)['mReorderLayout']);
      mockKit.clear(instance);
      mockKit.clearAll();
    })

    it('test_coveredItemAnimation', 0, () => {
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(instance, (instance as object)['clearLastCoveredItemAnimation']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturnNothing();
      const mockFunc2: Function = mockKit.mockFunc(instance, (instance as object)['getAppName']);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn('name');
      const mockFunc3: Function = mockKit.mockFunc((instance as object)['mSmallFolderViewModel'],
        (instance as object)['mSmallFolderViewModel'].getRealFolderName);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn('name');
      const mockFunc4: Function = mockKit.mockFunc(DragAccessibilityUtils,
        DragAccessibilityUtils.textAnnouncedForMoveToMerge);
      when(mockFunc4)(ArgumentMatchers.any).afterReturnNothing();
      const mockFunc5: Function = mockKit.mockFunc(DragAccessibilityUtils,
        DragAccessibilityUtils.textAnnouncedForMoveToFolder);
      when(mockFunc5)(ArgumentMatchers.any).afterReturnNothing();

      let dragItem: DockItemInfo = new DockItemInfo();
      let coveredItem: DockItemInfo = new DockItemInfo();
      dragItem.keyName = '1';
      coveredItem.keyName = '1';
      coveredItem.typeId = CommonConstants.TYPE_APP;
      (instance as object)['coveredItemAnimation'](dragItem, coveredItem);
      expect(true).assertTrue();

      coveredItem.keyName = '2';
      (instance as object)['coveredItemAnimation'](dragItem, coveredItem);
      expect(true).assertTrue();

      coveredItem.typeId = CommonConstants.TYPE_FOLDER;
      (instance as object)['coveredItemAnimation'](dragItem, coveredItem);
      expect(true).assertTrue();

      coveredItem.typeId = CommonConstants.TYPE_CARD;
      (instance as object)['coveredItemAnimation'](dragItem, coveredItem);
      expect(true).assertTrue();

      mockKit.clear(instance);
      mockKit.clear(DragAccessibilityUtils);
      mockKit.clear((instance as object)['mSmallFolderViewModel']);
      mockKit.clearAll();
    })

    it('test_clearLastCoveredItemAnimation', 0, () => {
      (instance as object)['coveredItem'].keyName = undefined;
      (instance as object)['clearLastCoveredItemAnimation']();
      expect(true).assertTrue();

      (instance as object)['coveredItem'].keyName = 'name';
      (instance as object)['clearLastCoveredItemAnimation']();
      expect(true).assertTrue();
    })

    it('test_setSqueezeTimeout', 0, () => {
      AppStorage.setOrCreate<boolean>('isDrag', false);
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(instance, (instance as object)['clearLastCoveredItemAnimation']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturnNothing();
      const mockFunc2: Function = mockKit.mockFunc((instance as object)['mReorderSolution'],
        (instance as object)['mReorderSolution'].getReorderSolution);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      const mockFunc3: Function = mockKit.mockFunc((instance as object)['mReorderLayout'],
        (instance as object)['mReorderLayout'].getItemIndex);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(0);
      const mockFunc4: Function = mockKit.mockFunc((instance as object)['mReorderLayout'],
        (instance as object)['mReorderLayout'].getSolution);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn([]);
      const mockFunc5: Function = mockKit.mockFunc(SmartDockStyleMgr.getInstance(),
        SmartDockStyleMgr.getInstance().getDockItemCenter);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(0);
      const mockFunc6: Function = mockKit.mockFunc(DragAccessibilityUtils,
        DragAccessibilityUtils.textAnnouncedForDragMoveToDock);
      when(mockFunc6)(ArgumentMatchers.any).afterReturnNothing();

      let dragItem: DockItemInfo = new DockItemInfo();
      (instance as object)['setSqueezeTimeout'](0, 0, 0, dragItem, true);
      expect(true).assertTrue();

      AppStorage.set<boolean>('isDrag', true);
      (instance as object)['setSqueezeTimeout'](0, 0, 0, dragItem, true);
      expect(true).assertTrue();

      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      (instance as object)['setSqueezeTimeout'](0, 0, 0, dragItem, true);
      expect(true).assertTrue();

      AppStorage.delete('isDrag');
      mockKit.clear(instance);
      mockKit.clear((instance as object)['mReorderSolution']);
      mockKit.clear((instance as object)['mReorderLayout']);
      mockKit.clear(SmartDockStyleMgr.getInstance());
      mockKit.clear(DragAccessibilityUtils);
      mockKit.clearAll();
    })

    it('test_setSqueezeTimeout_01', 0, () => {
      let dragItem: DockItemInfo = new DockItemInfo();
      AppStorage.set<boolean>('isDrag', false) as boolean;
      (instance as object)['setSqueezeTimeout'](0, 0, 0, dragItem, false);
      expect(instance).not().assertUndefined();
    })

    it('test_setSqueezeTimeout_02', 0, () => {
      let mocker: MockKit = new MockKit();
      let smartDockReorderSolution: SmartDockReorderSolution = new SmartDockReorderSolution();
      let mockFuc: Function = mocker.mockFunc(smartDockReorderSolution, smartDockReorderSolution.getReorderSolution);
      when(mockFuc)().afterReturn(true);
      let dragItem: DockItemInfo = new DockItemInfo();
      AppStorage.set<boolean>('isDrag', true) as boolean;
      (instance as object)['setSqueezeTimeout'](0, 0, 0, dragItem, false);
      expect(instance).not().assertUndefined();
      mocker.ignoreMock(smartDockReorderSolution, smartDockReorderSolution.getReorderSolution);
    })

    it('test_setSqueezeTimeout_03', 0, () => {
      let mocker: MockKit = new MockKit();
      let smartDockReorderSolution: SmartDockReorderSolution = new SmartDockReorderSolution();
      let mockFuc: Function = mocker.mockFunc(smartDockReorderSolution, smartDockReorderSolution.getReorderSolution);
      when(mockFuc)().afterReturn(false);
      let dragItem: DockItemInfo = new DockItemInfo();
      AppStorage.set<boolean>('isDrag', true) as boolean;
      (instance as object)['setSqueezeTimeout'](0, 0, 0, dragItem, false);
      expect(instance).not().assertUndefined();
      mocker.ignoreMock(smartDockReorderSolution, smartDockReorderSolution.getReorderSolution);
    })

    it('test_resetSqueezeTimeout', 0, () => {
      (instance as object)['squeezeTimeoutId'] = 0;
      (instance as object)['resetSqueezeTimeout']();
      expect((instance as object)['squeezeIndex']).assertEqual(CommonConstants.INVALID_VALUE);

      (instance as object)['squeezeTimeoutId'] = -1;
      (instance as object)['resetSqueezeTimeout']();
      expect((instance as object)['squeezeTimeoutId']).assertEqual(CommonConstants.INVALID_VALUE);
    })

    it('test_resetSqueezeTimeout_01', 0, () => {
      (instance as object)['squeezeTimeoutId'] = 0;
      (instance as object)['resetSqueezeTimeout']();
      expect(instance).not().assertUndefined();
    })

    it('test_resetSqueezeTimeout_02', 0, () => {
      (instance as object)['squeezeTimeoutId'] = -1;
      (instance as object)['resetSqueezeTimeout']();
      expect(instance).not().assertUndefined();
    })

    it('test_onDragDrop', 0, () => {
      let dragGridItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      AppStorage.setOrCreate<GridLayoutItemInfo>('dragItemInfo', dragGridItem);
      AppStorage.setOrCreate<number>('dragItemType', CommonConstants.DRAG_FROM_DOCK);
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(layoutLockUtil, layoutLockUtil.isLocked);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      const mockFunc2: Function = mockKit.mockFunc(instance, (instance as object)['handleInvalidDrop']);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      const mockFunc3: Function = mockKit.mockFunc(ShortcutViewModel.getInstance(),
        ShortcutViewModel.getInstance().canAddShortcutByDrag);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      const mockFunc4: Function = mockKit.mockFunc(instance, (instance as object)['handleInvalidAdd']);
      when(mockFunc4)(ArgumentMatchers.any).afterReturnNothing();
      const mockFunc5: Function = mockKit.mockFunc((instance as object)['mReorderSolution'],
        (instance as object)['mReorderSolution'].isCanCover);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(true);
      const mockFunc11: Function = mockKit.mockFunc(instance, (instance as object)['addToOrCreateFolder']);
      when(mockFunc11)(ArgumentMatchers.any).afterReturnNothing();
      const mockFunc12: Function = mockKit.mockFunc(DragAccessibilityUtils,
        DragAccessibilityUtils.textAnnouncedForDrop);
      when(mockFunc12)(ArgumentMatchers.any).afterReturnNothing();

      expect(instance.onDragDrop(0, 0)).assertFalse();

      dragGridItem.bundleName = '1'
      AppStorage.set<GridLayoutItemInfo>('dragItemInfo', dragGridItem);
      expect(instance.onDragDrop(0, 0)).assertTrue();

      AppStorage.set<number>('dragItemType', CommonConstants.DRAG_FROM_DESKTOP);
      expect(instance.onDragDrop(0, 0)).assertTrue();

      AppStorage.set<number>('dragItemType', CommonConstants.DRAG_FROM_FOLDER);
      expect(instance.onDragDrop(0, 0)).assertTrue();

      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      dragGridItem.typeId = CommonConstants.TYPE_APP;
      AppStorage.set<GridLayoutItemInfo>('dragItemInfo', dragGridItem);
      AppStorage.set<number>('dragItemType', CommonConstants.DRAG_FROM_SHORTCUT);
      expect(instance.onDragDrop(0, 0)).assertFalse();

      AppStorage.set<number>('dragItemType', CommonConstants.DRAG_FROM_FOLDER);
      let targetItem: DockItemInfo = new DockItemInfo();
      targetItem.layoutInfo = [];
      const mockFunc7: Function = mockKit.mockFunc((instance as object)['mReorderLayout'],
        (instance as object)['mReorderLayout'].getItem);
      when(mockFunc7)(ArgumentMatchers.any).afterReturn(targetItem);
      expect(instance.onDragDrop(0, 0)).assertFalse();

      when(mockFunc5)(ArgumentMatchers.any).afterReturn(false);
      const mockFunc6: Function = mockKit.mockFunc((instance as object)['mReorderSolution'],
        (instance as object)['mReorderSolution'].findNearestArea);
      when(mockFunc6)(ArgumentMatchers.any).afterReturn(1);
      const mockFunc8: Function = mockKit.mockFunc((instance as object)['mReorderLayout'],
        (instance as object)['mReorderLayout'].getItemIndex);
      when(mockFunc8)(ArgumentMatchers.any).afterReturn(-1);
      const mockFunc9: Function = mockKit.mockFunc((instance as object)['mReorderLayout'],
        (instance as object)['mReorderLayout'].getSolution);
      when(mockFunc9)(ArgumentMatchers.any).afterReturn([]);
      const mockFunc10: Function = mockKit.mockFunc(instance,
        (instance as object)['refreshDragItem']);
      when(mockFunc10)(ArgumentMatchers.any).afterReturn(true);
      expect(instance.onDragDrop(0, 0)).assertTrue();

      when(mockFunc8)(ArgumentMatchers.any).afterReturn(1);
      expect(instance.onDragDrop(0, 0)).assertTrue();

      AppStorage.delete('dragItemInfo');
      AppStorage.delete('dragItemType');
      mockKit.clear(layoutLockUtil);
      mockKit.clear(instance);
      mockKit.clear((instance as object)['mReorderSolution']);
      mockKit.clear((instance as object)['mReorderLayout']);
      mockKit.clear(ShortcutViewModel.getInstance());
      mockKit.clear(DragAccessibilityUtils);
      mockKit.clearAll();
    })

    it('test_setDropAnimationInfo', 0, () => {
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(layoutLockUtil, layoutLockUtil.isLocked);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      const mockFunc2: Function = mockKit.mockFunc((instance as object)['mReorderLayout'],
        (instance as object)['mReorderLayout'].getItemIndex);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(-1);
      const mockFunc3: Function = mockKit.mockFunc(LaunchLayoutCacheManager.getInstance(),
        LaunchLayoutCacheManager.getInstance().selectGridLayoutItemByItem);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(undefined);

      let dragItem: DockItemInfo = new DockItemInfo();
      dragItem.keyName = 'name';
      let dragType: number = CommonConstants.DRAG_FROM_DESKTOP;
      let startPosition: DragItemPosition = {
        page: 0,
        row: 0,
        column: 0,
        x: 0,
        y: 0,
        isInDock: false
      };
      (instance as object)['setDropAnimationInfo'](dragItem, dragType);
      expect(true).assertTrue();

      AppStorage.setOrCreate<DragItemPosition>('startPosition', startPosition);
      (instance as object)['setDropAnimationInfo'](dragItem, dragType);
      expect(true).assertTrue();

      dragType = CommonConstants.DRAG_FROM_DOCK;
      (instance as object)['setDropAnimationInfo'](dragItem, dragType);
      expect(true).assertTrue();

      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      (instance as object)['setDropAnimationInfo'](dragItem, dragType);
      expect(true).assertTrue();

      let cached: GridLayoutItemInfo = new GridLayoutItemInfo();
      cached.row = 0;
      cached.column = 0;
      cached.area = [1, 1];
      cached.page = 0;
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(cached);
      (instance as object)['setDropAnimationInfo'](dragItem, dragType);
      expect(true).assertTrue();

      when(mockFunc2)(ArgumentMatchers.any).afterReturn(11);
      (instance as object)['setDropAnimationInfo'](dragItem, dragType);
      expect(true).assertTrue();

      AppStorage.delete('startPosition');
      mockKit.clear(layoutLockUtil);
      mockKit.clear((instance as object)['mReorderLayout']);
      mockKit.clear(LaunchLayoutCacheManager.getInstance());
      mockKit.clearAll();
    })

    it('test_handleInvalidDrop', 0, () => {
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(instance, (instance as object)['handleBackToDesktop']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);

      AppStorage.setOrCreate<boolean>('dragCardOfFormstackClosed', false);
      let dragItem: DockItemInfo = new DockItemInfo();
      let dragType: number = CommonConstants.DRAG_FROM_FORM_STACK;
      expect((instance as object)['handleInvalidDrop'](dragItem, dragType, 0, 0)).assertFalse();

      AppStorage.setOrCreate<boolean>('dragCardOfFormstackClosed', true);
      expect((instance as object)['handleInvalidDrop'](dragItem, dragType, 0, 0)).assertFalse();

      dragType = CommonConstants.DRAG_FROM_DESKTOP;
      expect((instance as object)['handleInvalidDrop'](dragItem, dragType, 0, 0)).assertFalse();

      AppStorage.delete('dragCardOfFormstackClosed');
      mockKit.clear(instance);
      mockKit.clearAll();
    })

    it('test_handleInvalidDrop_01', 0, () => {
      let dragItem: DockItemInfo = new DockItemInfo();
      let dragType: number = CommonConstants.DRAG_FROM_FORM_STACK;
      AppStorage.set<boolean>('dragCardOfFormstackClosed', false);
      (instance as object)['handleInvalidDrop'](dragItem, dragType, 0, 0);
      expect(instance).not().assertUndefined();
    })

    it('test_handleInvalidDrop_02', 0, () => {
      let dragItem: DockItemInfo = new DockItemInfo();
      let dragType: number = CommonConstants.DRAG_FROM_FORM_STACK;
      AppStorage.set<boolean>('dragCardOfFormstackClosed', true);
      (instance as object)['handleInvalidDrop'](dragItem, dragType, 0, 0);
      expect(instance).not().assertUndefined();
    })

    it('test_handleBackToDesktop_01', 0, () => {
      let pageDesktopDragHandler:PageDesktopDragHandler = PageDesktopDragHandler.getInstance();
      let mocker: MockKit = new MockKit();
      let mockerFuc: Function = mocker.mockFunc(pageDesktopDragHandler, pageDesktopDragHandler.getCurrentPageIndex);
      when(mockerFuc)().afterReturn(1);
      let dragItem: DockItemInfo = new DockItemInfo();
      dragItem.page = 1;
      (instance as object)['handleBackToDesktop'](dragItem);
      expect(instance).not().assertUndefined();
    })

    it('test_handleInvalidAdd', 0, () => {
      let dragItem: DockItemInfo = new DockItemInfo();
      dragItem.keyName = 'name';
      (instance as object)['handleInvalidAdd'](dragItem);
      expect(true).assertTrue();
    })

    it('test_handleInvalidAdd_01', 0, () => {
      let dragItem: DockItemInfo = new DockItemInfo();
      dragItem.keyName = 'name';
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [], false);
      (instance as object)['handleInvalidAdd'](dragItem);
      expect(instance).not().assertUndefined();
    })

    it('test_addToOrCreateFolder', 0, () => {
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(instance, (instance as object)['canAddToFolder']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      const mockFunc2: Function = mockKit.mockFunc(instance, (instance as object)['addToFolder']);
      when(mockFunc2)(ArgumentMatchers.any).afterReturnNothing();
      const mockFunc3: Function = mockKit.mockFunc(DragAccessibilityUtils,
        DragAccessibilityUtils.textAnnouncedForDropMergeToDock);
      when(mockFunc3)(ArgumentMatchers.any).afterReturnNothing();
      const mockFunc4: Function = mockKit.mockFunc(ShortcutViewModel.getInstance(),
        ShortcutViewModel.getInstance()['addShortcutToBMSByDrag']);
      when(mockFunc4)(ArgumentMatchers.any).afterReturnNothing();

      let dragItem: DockItemInfo = new DockItemInfo();
      let targetItem: DockItemInfo = new DockItemInfo();
      targetItem.layoutInfo = [];
      let dragItemType: number = CommonConstants.DRAG_FROM_SWIPE_UP;
      AppStorage.setOrCreate<number>('dragItemType', dragItemType);

      expect((instance as object)['addToOrCreateFolder'](dragItem, targetItem, 0, 0)).assertFalse();

      dragItem.typeId = CommonConstants.TYPE_APP;
      targetItem.typeId = CommonConstants.TYPE_APP;
      expect((instance as object)['addToOrCreateFolder'](dragItem, targetItem, 0, 0)).assertTrue();

      targetItem.typeId = CommonConstants.TYPE_CARD;
      expect((instance as object)['addToOrCreateFolder'](dragItem, targetItem, 0, 0)).assertFalse();

      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      expect((instance as object)['addToOrCreateFolder'](dragItem, targetItem, 0, 0)).assertTrue();

      AppStorage.delete('dragItemType');
      mockKit.clear(instance);
      mockKit.clear(ShortcutViewModel.getInstance());
      mockKit.clear(DragAccessibilityUtils);
      mockKit.clearAll();
    })

    it('test_createFolder', 0, () => {
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(DragAccessibilityUtils,
        DragAccessibilityUtils.textAnnouncedForDropMergeToDock);
      when(mockFunc1)(ArgumentMatchers.any).afterReturnNothing();
      let dragItem: DockItemInfo = new DockItemInfo();
      dragItem.keyName = '1';
      let targetItem: DockItemInfo = new DockItemInfo();
      targetItem.keyName = '2';
      (instance as object)['createFolder'](dragItem, targetItem, 0, 0, 2);
      expect(instance).not().assertUndefined();
      mockKit.clear(DragAccessibilityUtils);
      mockKit.clearAll();
    })

    it('test_addBackToFolder', 0, () => {
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(DragAccessibilityUtils,
        DragAccessibilityUtils.textAnnouncedForDropToFolder);
      when(mockFunc1)(ArgumentMatchers.any).afterReturnNothing();
      let dragItem: DockItemInfo = new DockItemInfo();
      dragItem.keyName = '1';
      let targetItem: DockItemInfo = new DockItemInfo();
      targetItem.keyName = '2';
      const mockFunc2: Function = mockKit.mockFunc((instance as object)['mReorderLayout'],
        (instance as object)['mReorderLayout'].getSolution);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn([dragItem]);
      expect((instance as object)['addBackToFolder'](dragItem, targetItem, 0, 0)).assertTrue();

      when(mockFunc2)(ArgumentMatchers.any).afterReturn([targetItem]);
      expect((instance as object)['addBackToFolder'](dragItem, targetItem, 0, 0)).assertTrue();

      mockKit.clear((instance as object)['mReorderLayout']);
      mockKit.clear(DragAccessibilityUtils);
      mockKit.clearAll();
    })

    it('test_canAddToFolder', 0, () => {
      let targetItem: DockItemInfo = new DockItemInfo();
      targetItem.bundleName = 'name';
      (instance as object)['canAddToFolder'](targetItem);
      expect(true).assertTrue();
    })

    it('test_updateDockList', 0, () => {
      let dragItem: DockItemInfo = new DockItemInfo();
      dragItem.keyName = '1';
      let targetItem: DockItemInfo = new DockItemInfo();
      targetItem.keyName = '2';
      let folderInfo: DockItemInfo = new DockItemInfo();
      folderInfo.layoutInfo = [];
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc((instance as object)['mReorderLayout'],
        (instance as object)['mReorderLayout'].getSolution);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn([dragItem, targetItem]);

      (instance as object)['updateDockList'](dragItem, targetItem, folderInfo);
      expect(true).assertTrue();

      when(mockFunc1)(ArgumentMatchers.any).afterReturn([]);
      (instance as object)['updateDockList'](dragItem, targetItem, folderInfo);
      expect(true).assertTrue();

      when(mockFunc1)(ArgumentMatchers.any).afterReturn([dragItem]);
      (instance as object)['updateDockList'](dragItem, targetItem, folderInfo);
      expect(true).assertTrue();

      when(mockFunc1)(ArgumentMatchers.any).afterReturn([targetItem]);
      (instance as object)['updateDockList'](dragItem, targetItem, folderInfo);
      expect(true).assertTrue();

      mockKit.clear((instance as object)['mReorderLayout']);
      mockKit.clear(RdbStoreManager.getInstance());
      mockKit.clearAll();
    })

    it('test_updateDockItemTranslate', 0, () => {
      let dragItem: DockItemInfo = new DockItemInfo();
      dragItem.keyName = '1';
      let targetItem: DockItemInfo = new DockItemInfo();
      targetItem.keyName = '2';
      let oldList: DockItemInfo[] = [dragItem];
      let newList: DockItemInfo[] = [targetItem];
      (instance as object)['updateDockItemTranslate'](newList);
      expect(true).assertTrue();

      oldList = [targetItem];
      (instance as object)['updateDockItemTranslate'](newList);
      expect(true).assertTrue();
    })

    it('test_deleteDragItem', 0, () => {
      let dragItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      dragItem.keyName = '1';
      dragItem.appIndex = 1;
      let dragType: number = CommonConstants.DRAG_FROM_DESKTOP;
      let residentItem: DockItemInfo = new DockItemInfo();
      residentItem.keyName = '1';
      let residentList: DockItemInfo[] = [residentItem];

      (instance as object)['deleteDragItem'](dragItem, dragType, residentList);
      expect(true).assertTrue();

      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc((instance as object)['mBigFolderViewModel'],
        (instance as object)['mBigFolderViewModel'].isFolderDisappearing);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);

      dragType = CommonConstants.DRAG_FROM_FOLDER;
      (instance as object)['deleteDragItem'](dragItem, dragType, residentList);
      expect(true).assertTrue();

      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      (instance as object)['deleteDragItem'](dragItem, dragType, residentList);
      expect(true).assertTrue();

      dragType = CommonConstants.DRAG_FROM_FOLDER_IN_DOCK;
      (instance as object)['deleteDragItem'](dragItem, dragType, residentList);
      expect(true).assertTrue();

      mockKit.clear((instance as object)['mBigFolderViewModel']);
      mockKit.clearAll();
    })

    it('test_handleFolderDisappear', 0, () => {
      let disappearLastAppData: DisappearLastAppData = {
        folderId: '1',
        lastAppKeyName: '1',
        hiddenAppKeyName: '1'
      };

      (instance as object)['handleFolderDisappear']();
      expect(true).assertTrue();

      AppStorage.set<DisappearLastAppData>('disappearLastAppData', disappearLastAppData);
      (instance as object)['handleFolderDisappear']();
      expect(true).assertTrue();

      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc((instance as object)['mReorderLayout'],
        (instance as object)['mReorderLayout'].getSolution);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn([]);
      (instance as object)['handleFolderDisappear']();
      expect(true).assertTrue();

      let item: DockItemInfo = new DockItemInfo();
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.layoutInfo = [[gridLayoutItemInfo]];
      item.keyName = '1';
      when(mockFunc1)(ArgumentMatchers.any).afterReturn([item]);
      (instance as object)['handleFolderDisappear']();
      expect(true).assertTrue();

      AppStorage.delete('disappearLastAppData');
      mockKit.clear((instance as object)['mReorderLayout']);
      mockKit.clearAll();
    })

    it('test_refreshDragItem', 0, () => {
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(instance, instance.refreshDockItem);
      when(mockFunc1)(ArgumentMatchers.any).afterReturnNothing();
      const mockFunc2: Function = mockKit.mockFunc(instance, (instance as object)['handleBackToDesktop']);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      const mockFunc3: Function = mockKit.mockFunc(DragAccessibilityUtils,
        DragAccessibilityUtils.textAnnouncedForDockIsFull);
      when(mockFunc3)(ArgumentMatchers.any).afterReturnNothing();

      let dragItem: DockItemInfo = new DockItemInfo();
      dragItem.keyName = '1';
      let dragType: number = CommonConstants.DRAG_FROM_DOCK;
      expect((instance as object)['refreshDragItem'](dragItem, dragType)).assertFalse();

      dragType = CommonConstants.DRAG_FROM_DESKTOP;
      expect((instance as object)['refreshDragItem'](dragItem, dragType)).assertFalse();

      dragType = CommonConstants.DRAG_FROM_FOLDER;
      expect((instance as object)['refreshDragItem'](dragItem, dragType)).assertFalse();

      mockKit.clear(instance);
      mockKit.clearAll();
    })

    it('test_reportAddToDock', 0, () => {
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(DragAccessibilityUtils,
        DragAccessibilityUtils.textAnnouncedForDrop);
      when(mockFunc1)(ArgumentMatchers.any).afterReturnNothing();
      let lastOpenFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      AppStorage.setOrCreate<GridLayoutItemInfo>('lastOpenFolderData', lastOpenFolderData);
      AppStorage.setOrCreate('folderStatus', 0);
      let dragItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      dragItem.page = 0;
      dragItem.column = 0;
      dragItem.row = 0;
      dragItem.bundleName = 'bundleName';
      dragItem.folderName = 'folderName';
      let dragType: number = CommonConstants.DRAG_FROM_DESKTOP;

      (instance as object)['reportAddToDock'](dragItem, dragType, 0);
      expect(true).assertTrue();

      dragItem.typeId = CommonConstants.TYPE_APP;
      (instance as object)['reportAddToDock'](dragItem, dragType, 0);
      expect(true).assertTrue();

      dragType = CommonConstants.DRAG_FROM_DOCK;
      (instance as object)['reportAddToDock'](dragItem, dragType, 0);
      expect(true).assertTrue();

      dragType = CommonConstants.DRAG_FROM_FOLDER;
      (instance as object)['reportAddToDock'](dragItem, dragType, 0);
      expect(true).assertTrue();

      dragItem.typeId = CommonConstants.TYPE_FOLDER;
      dragType = CommonConstants.DRAG_FROM_FOLDER_IN_DOCK;
      (instance as object)['reportAddToDock'](dragItem, dragType, 0);
      expect(true).assertTrue();

      AppStorage.delete('lastOpenFolderData');
      AppStorage.delete('folderStatus');
      mockKit.clear(DragAccessibilityUtils);
      mockKit.clearAll();
    })

    it('test_getEmptyItemExist', 0, () => {
      (instance as object)['emptyItemExist'] = true;
      expect(instance.getEmptyItemExist()).assertTrue();
      (instance as object)['emptyItemExist'] = false;
      expect(instance.getEmptyItemExist()).assertFalse();
    })

    it('test_clearSqueezeInfo', 0, () => {
      (instance as object)['emptyItemExist'] = true;
      instance.clearSqueezeInfo();
      expect((instance as object)['emptyItemExist']).assertFalse();

      instance.clearSqueezeInfo();
      expect((instance as object)['emptyItemExist']).assertFalse();
    })

    it('test_refreshDockItem', 0, () => {
      let residentItem: DockItemInfo = new DockItemInfo();
      residentItem.keyName = '1';
      let residentList: DockItemInfo[] = [residentItem];
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', residentList, false);

      let dragItem: DockItemInfo = new DockItemInfo();
      instance.refreshDockItem(dragItem);
      expect(true).assertTrue();

      dragItem.bundleName = 'bundleName';
      instance.refreshDockItem(dragItem);
      expect(true).assertTrue();

      dragItem.keyName = '1';
      instance.refreshDockItem(dragItem);
      expect(true).assertTrue();

      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [], false);
    })

    it('test_getDockItemPosition', 0, () => {
      expect(instance.getDockItemPosition(-1)[0]).assertEqual(-1);
      expect(instance.getDockItemPosition(1)[0]).assertEqual(-1);
    })

    it('test_getDockItemPositionByItem', 0, () => {
      expect(instance.getDockItemPositionByItem(undefined)[0]).assertEqual(-1);
      expect(instance.getDockItemPositionByItem(new GridLayoutItemInfo)[0]).assertEqual(-1);
    })

    it('test_onDragMovePcMode', 0, () => {
      let dragItem: DockItemInfo = new DockItemInfo();
      dragItem.bundleName = 'onDragMovePcMode1';
      dragItem.typeId = CommonConstants.TYPE_APP;
      AppStorage.set<DockItemInfo>('dragItemInfo', dragItem);
      let targetItem: DockItemInfo = new DockItemInfo();
      targetItem.bundleName = 'onDragMovePcMode2';
      targetItem.typeId = CommonConstants.TYPE_APP;

      let mockKit: MockKit = new MockKit();
      const mockFunc0: Function = mockKit.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().isPcMode);
      when(mockFunc0)(ArgumentMatchers.any).afterReturn(true);
      const mockFunc1: Function = mockKit.mockFunc(layoutLockUtil, layoutLockUtil.isLocked);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      const mockFunc2: Function = mockKit.mockFunc((instance as object)['mReorderSolution'],
        (instance as object)['mReorderSolution'].findNearestArea);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(0);
      const mockFunc3: Function = mockKit.mockFunc((instance as object)['mReorderLayout'],
        (instance as object)['mReorderLayout'].getItem);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(targetItem);
      const mockFunc4: Function = mockKit.mockFunc((instance as object)['mReorderLayout'],
        (instance as object)['mReorderLayout'].getItemIndex);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(1);
      const mockFunc5: Function = mockKit.mockFunc((instance as object)['mReorderLayout'],
        (instance as object)['mReorderLayout'].getSolution);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn([]);
      const mockFunc6: Function = mockKit.mockFunc(instance, (instance as object)['setSqueezeTimeout']);
      when(mockFunc6)(ArgumentMatchers.any).afterReturnNothing();
      const mockFunc7: Function = mockKit.mockFunc((instance as object)['mReorderSolution'],
        (instance as object)['mReorderSolution'].isCanCover);
      when(mockFunc7)(ArgumentMatchers.any).afterReturn(false);

      instance.onDragMove(0, 0);
      expect(instance).not().assertNull();

      AppStorage.delete('dragItemInfo');
      mockKit.clear(layoutLockUtil);
      mockKit.clear(SCBSceneSessionManager.getInstance());
      mockKit.clear((instance as object)['mReorderSolution']);
      mockKit.clear((instance as object)['mReorderLayout']);
      mockKit.clear(instance);
      mockKit.clearAll();
    });

    it('test_recordDragStartPage_01', 0, () => {
      let dragItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let res: void = (instance as object)['recordDragStartPage'](dragItem,CommonConstants.DRAG_FROM_DESKTOP)
      expect(res !== null).assertTrue()
    })

    it('test_recordDragStartPage_02', 0, () => {
      let dragItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let res: void = (instance as object)['recordDragStartPage'](dragItem,CommonConstants.TYPE_APP)
      expect(res !== null).assertTrue()
    })

    it('test_isExistRecentItem', 0, () => {
      const dockItemInfo: DockItemInfo = new DockItemInfo();
      dockItemInfo.bundleName = '1';
      dockItemInfo.appIndex = 0;
      dockItemInfo.typeId = CommonConstants.TYPE_APP;
      RecentLayoutCacheMgr.getInstance().updateAllDockItems('test_isExistRecentItem', [dockItemInfo], false);
      expect((instance as object)['isExistRecentItem']()).assertTrue();

      RecentLayoutCacheMgr.getInstance().updateAllDockItems('test_isExistRecentItem', [], false);
      expect((instance as object)['isExistRecentItem']()).assertFalse();

      const deviceInfo: DockContinuableInfo = new DockContinuableInfo();
      deviceInfo.sourceDeviceType = 'string';
      AppStorage.setOrCreate<DockContinuableInfo>('continueDeviceInfo', deviceInfo);
      expect((instance as object)['isExistRecentItem']()).assertFalse();
      deviceInfo.bundleName = '1';
      expect((instance as object)['isExistRecentItem']()).assertFalse();
      deviceInfo.sourceDeviceName = '1';
      expect((instance as object)['isExistRecentItem']()).assertTrue();

      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [dockItemInfo], false);
      expect((instance as object)['isExistRecentItem']()).assertFalse();
      dockItemInfo.bundleName = '0';
      expect((instance as object)['isExistRecentItem']()).assertTrue();

      AppStorage.delete('continueDeviceInfo');
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [], false);
    });

    mockKit.clear(ShortcutViewModel.getInstance());
    mockKit.clearAll();
  })
}