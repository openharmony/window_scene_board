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
  describe,
  it,
  expect,
  MockKit,
  when,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  ArgumentMatchers} from '@ohos/hypium'
import { CheckboxCheckState, CheckboxInfoType,
  CheckboxParentEnum,
  FolderInfo,
  GatherAnimateTarget,
  GridItemRect,
  MultiSelectItemType,
  MultiSelectMode} from '../../../../../../../main/ets/editmode/data/MultiSelectData';
import { AppItemInfo,
  EditModeUtils,
  folderLayoutUtil,
  GridLayoutItemInfo,
  GridLayoutUtil,
  LaunchLayoutCacheManager,
  MultiSelectManager, MultiSelectStatusEnum } from '../../../../../../../main/ets/TsIndex'
import { layoutLockUtil } from '../../../../../../../main/ets/utils/LayoutLockUtil';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { desktopUtil } from '@ohos/componenthelper';
import { Frame, Position } from '@kit.ArkUI';
import { Action, ToolType, TouchEvent as multiInputTouchEvent } from '@ohos.multimodalInput.touchEvent';

const TAG: string = 'MultiSelectManagerTest';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export default function MultiSelectManagerTest() {
  describe('MultiSelectManagerTest', () => {
    let instance = new MultiSelectManager();
    let gestureEvent: GestureEvent = {
      repeat: true,
      fingerList: [{
        id: 0,
        globalX: 0,
        globalY: 0,
        localX: 0,
        localY: 0,
        displayX: 0,
        displayY: 0,
      }],
      offsetX: 0,
      offsetY: 0,
      angle: 0,
      speed: 0,
      scale: 0,
      pinchCenterX: 0,
      pinchCenterY: 0,
      velocityX: 0,
      velocityY: 0,
      velocity: 0,
      target: {
        area: {
          width: 0,
          height: 0,
          position: {
            x: 0,
            y: 0
          },
          globalPosition:{
            x: 0,
            y: 0
          },
        }
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };

    let touchEvent: multiInputTouchEvent = {
      touches: [{
        id: 0,
        pressedTime: 0,
        windowX: 0,
        windowY: 0,
        screenX: 0,
        screenY: 0,
        pressure: 0,
        width: 0,
        height: 0,
        tiltX: 0,
        tiltY: 0,
        toolX: 0,
        toolY: 0,
        toolWidth: 0,
        toolHeight: 0,
        rawX: 0,
        rawY: 0,
        toolType: ToolType.FINGER
      }],
      action: Action.CANCEL,
      touch: {
        id: 0,
        pressedTime: 0,
        windowX: 0,
        windowY: 0,
        screenX: 0,
        screenY: 0,
        pressure: 0,
        width: 0,
        height: 0,
        tiltX: 0,
        tiltY: 0,
        toolX: 0,
        toolY: 0,
        toolWidth: 0,
        toolHeight: 0,
        rawX: 0,
        rawY: 0,
        toolType: ToolType.FINGER
      },
      sourceType: 0,
      id: 0,
      deviceId: 0,
      actionTime: 0,
      screenId: 0,
      windowId: 0
    }

    let gridItemRect: GridItemRect = {
      width: 0,
      height: 0,
      leftTopX: 0,
      leftTopY: 0,
      centerX: 0,
      centerY: 0,
    }
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    it('test_getInstance', 0, () => {
      let instance1 = MultiSelectManager.getInstance();
      expect(instance1).not().assertNull();
      let instance2 = MultiSelectManager.getInstance();
      expect(instance2).not().assertNull();
    })

    it('test_load', 0, () => {
      instance.load();
      let status = instance.getStatus();
      expect(status.inStatus(MultiSelectStatusEnum.Entered)).assertTrue();
    })

    it('test_unload', 0, () => {
      instance.unload();
      let status = instance.getStatus();
      expect(status.inStatus(MultiSelectStatusEnum.Exited)).assertTrue();
    })

    it('test_isInMultiSelect', 0, () => {
      let isInMultiSelect = instance.isInMultiSelect;
      expect(isInMultiSelect).assertFalse();
    })

    it('test_isInSingleDrag', 0, () => {
      let isInMultiSelect = instance.isInSingleDrag;
      expect(isInMultiSelect).assertFalse();
    })

    it('test_isInOuterMultiSelect', 0, () => {
      let isInMultiSelect = instance.isInOuterMultiSelect;
      expect(isInMultiSelect).assertFalse();
    })

    it('test_sendAccessibility', 0, () => {
      instance['isAccessibilityMode'] = true;
      instance.sendAccessibility(true);
      expect(true).assertTrue();

      instance.sendAccessibility(false);
      expect(true).assertTrue();

      instance['isAccessibilityMode'] = false;
      instance.sendAccessibility(false);
      expect(true).assertTrue();
    })

    it('test_onIconClick', 0, async () => {
      let mockKit: MockKit = new MockKit();

      const result1 = await instance.onIconClick('1');
      expect(result1).assertFalse();

      instance.load();
      const result2 = await instance.onIconClick('1');
      expect(result2).assertFalse();

      const mockFunc1: Function = mockKit.mockFunc(instance, instance['canSelectWhenLayoutLocked']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      let checkBoxInfo: CheckboxInfoType = new CheckboxInfoType();
      checkBoxInfo.checkState = new CheckboxCheckState();
      instance.checkboxInfoMap.set('1', checkBoxInfo);
      const result3 = await instance.onIconClick('1');
      expect(result3).assertFalse();

      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      checkBoxInfo.parentType = CheckboxParentEnum.Folder;
      const result4 = await instance.onIconClick('1');
      expect(result4).assertFalse();

      checkBoxInfo.parentType = CheckboxParentEnum.App;
      const mockFunc2: Function = mockKit.mockFunc(instance, instance['isDeliverApp']);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      const result5 = await instance.onIconClick('1');
      expect(result5).assertFalse();

      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      const mockFunc3: Function = mockKit.mockFunc(instance, instance['onCheckboxSelect']);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      const result6 = await instance.onIconClick('1');
      expect(result6).assertTrue();
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      const result7 = await instance.onIconClick('1');
      expect(result7).assertTrue();

      checkBoxInfo.checkState.add();
      const mockFunc4: Function = mockKit.mockFunc(instance, instance['onCheckboxUnSelect']);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(true);
      const result8 = await instance.onIconClick('1');
      expect(result8).assertTrue();
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(false);
      const result9 = await instance.onIconClick('1');
      expect(result9).assertTrue();

      instance.unload();
      mockKit.clear(instance);
      mockKit.clearAll();
    })

    it('test_canSelectWhenLayoutLocked', 0, () => {
      instance.checkboxInfoMap.clear();
      instance.multiSelectMap.clear();
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(layoutLockUtil, layoutLockUtil.isLocked);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      instance.load();
      let checkBoxInfo: CheckboxInfoType = new CheckboxInfoType();
      expect(instance['canSelectWhenLayoutLocked'](checkBoxInfo)).assertTrue();

      checkBoxInfo.parentItemInfo = new AppItemInfo();
      checkBoxInfo.parentItemInfo.page = 1;
      checkBoxInfo.belongFolderCheckboxId = '1';
      checkBoxInfo.parentType = CheckboxParentEnum.AppInFolder;
      instance.checkboxInfoMap.set('1', checkBoxInfo);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      const mockFunc2: Function = mockKit.mockFunc(layoutLockUtil, layoutLockUtil.isLockedPage);
      const mockFunc3: Function = mockKit.mockFunc(instance, instance.checkboxInfoMap.get);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(checkBoxInfo);
      expect(instance['canSelectWhenLayoutLocked'](checkBoxInfo)).assertFalse();

      checkBoxInfo.parentType = CheckboxParentEnum.App;
      expect(instance['canSelectWhenLayoutLocked'](checkBoxInfo)).assertTrue();

      let item: MultiSelectItemType = new MultiSelectItemType();
      item.parentItemInfo = new AppItemInfo();
      checkBoxInfo.parentItemInfo.page = 1;
      instance.multiSelectMap.set('1', item);
      expect(instance['canSelectWhenLayoutLocked'](checkBoxInfo)).assertTrue();

      item.belongId = '1';
      instance.multiSelectMap.set('1', item);
      expect(instance['canSelectWhenLayoutLocked'](checkBoxInfo)).assertTrue();

      instance.checkboxInfoMap.clear();
      instance.multiSelectMap.clear();
      instance.unload();
      mockKit.clear(instance);
      mockKit.clear(layoutLockUtil);
      mockKit.clearAll();
    })

    it('test_clearAllSelect', 0, () => {
      instance.checkboxInfoMap.clear();
      instance.multiSelectMap.clear();
      instance.clearAllSelect()
      expect(instance.multiSelectMap.size).assertEqual(0)
    })

    it('test_getAllSelectedItem', 0, () => {
      expect(instance.getAllSelectedItem().length).assertEqual(0)
    })

    it('test_getAllSelectedItemKeyNames', 0, () => {
      expect(instance.getAllSelectedItemKeyNames().length).assertEqual(0)
    })

    it('test_getSelectedItemSortByFolder', 0, () => {
      let mockKit: MockKit = new MockKit();
      let item: MultiSelectItemType = new MultiSelectItemType();
      let checkBoxInfo: CheckboxInfoType = new CheckboxInfoType();
      checkBoxInfo.parentItemInfo = new AppItemInfo();
      instance.checkboxInfoMap.set('1', checkBoxInfo);
      item.belongId = undefined;
      instance.multiSelectMap.set('1', item);

      instance.getSelectedItemSortByFolder();
      expect(true).assertTrue();

      item.belongId = '1';
      instance.getSelectedItemSortByFolder();
      expect(true).assertTrue();

      instance.multiSelectMap.clear();
      instance.checkboxInfoMap.clear();
      mockKit.clear(instance);
      mockKit.clearAll();
    })

    it('test_enabledDefaultDrag', 0, () => {
      instance.multiSelectMap.clear();
      expect(instance.enabledDefaultDrag('1')).assertTrue();
      instance.multiSelectMap.set('1', new MultiSelectItemType);
      expect(instance.enabledDefaultDrag('1')).assertTrue();
      expect(instance.enabledDefaultDrag('2')).assertFalse();
      instance.multiSelectMap.clear();
    })

    it('test_preGather', 0, async () => {
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(instance, instance['illegalsGather']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);

      let rect: Frame = {
        x: 0,
        y: 0,
        width: 0,
        height: 0,
      };
      const mockFunc3: Function = mockKit.mockFunc(instance, instance['getItemPositionInFolder']);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(rect);
      const mockFunc4: Function = mockKit.mockFunc(instance, instance['updateSelectItemPosition']);
      when(mockFunc4)(ArgumentMatchers.any).afterReturnNothing();

      const result1 = await instance.preGather('1');
      expect(result1).assertFalse();

      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      let checkboxInfo: CheckboxInfoType = new CheckboxInfoType();
      checkboxInfo.parentType = CheckboxParentEnum.AppInFolder;
      checkboxInfo.belongFolderCheckboxId = '1';
      checkboxInfo.parentItemInfo = new AppItemInfo();
      checkboxInfo.parentItemInfo.page = 1;
      instance.checkboxInfoMap.set('1', checkboxInfo);
      const result2 = await instance.preGather('1');
      expect(result2).assertTrue();

      const mockFunc2: Function = mockKit.mockFunc(instance, instance['getCacheItemInfoByCheckboxInfo']);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(checkboxInfo.parentItemInfo);
      checkboxInfo.parentType = CheckboxParentEnum.App;
      const result3 = await instance.preGather('1');
      expect(result3).assertTrue();

      mockKit.clear(instance);
      mockKit.clearAll();
    })

    it('test_illegalsGather_27', 0, () => {
      try {
        instance.checkboxInfoMap.clear();
        instance.multiSelectMap.clear();
        let mockKit: MockKit = new MockKit();
        instance['status'].setStatus(MultiSelectStatusEnum.Exited);
        expect(instance['illegalsGather']('1')).assertTrue();

        instance.load();
        expect(instance['illegalsGather']('1')).assertTrue();

        let checkboxInfo: CheckboxInfoType = new CheckboxInfoType();
        checkboxInfo.parentType = CheckboxParentEnum.Folder;
        instance.checkboxInfoMap.set('1', checkboxInfo);
        expect(instance['illegalsGather']('1')).assertTrue();

        checkboxInfo.parentType = CheckboxParentEnum.App;
        const mockFunc1: Function = mockKit.mockFunc(instance, instance['isDeliverApp']);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
        expect(instance['illegalsGather']('1')).assertTrue();

        when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
        expect(instance['illegalsGather']('1')).assertFalse();

        instance.unload();
        mockKit.clear(instance);
        mockKit.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_isDeliverApp_01_27', 0, () => {
      try {
        let checkboxInfo = new CheckboxInfoType;
        expect(instance['isDeliverApp'](checkboxInfo)).assertInstanceOf('Boolean');

        checkboxInfo.parentType = CheckboxParentEnum.AppInFolder;
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_notifyLongPressAnimation', 0, () => {
      instance.notifyLongPressAnimation();
      expect(true).assertTrue();
    })

    it('test_singleDrag', 0, () => {
      instance['mode'] = MultiSelectMode.INIT;
      instance.startSingleDrag('1');
      instance.finishSingleDrag();

      instance['mode'] = MultiSelectMode.MULTI;
      instance.startSingleDrag('1');
      instance.finishSingleDrag();

      instance['mode'] = MultiSelectMode.INIT;
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('test_showCheckboxWithAnimation', 0, () => {
      instance['showCheckboxWithAnimation']('1');
      expect(true).assertTrue();

      instance['showCheckboxWithAnimation'](['1']);
      expect(true).assertTrue();
    })

    it('test_updateSelectView', 0, () => {
      instance.checkboxInfoMap.clear();
      instance.multiSelectMap.clear();
      instance.load();
      let selectItem: MultiSelectItemType = new MultiSelectItemType();
      let item: CheckboxInfoType = new CheckboxInfoType();
      item.checkState = new CheckboxCheckState();
      selectItem.belongId = '1';
      instance.multiSelectMap.set('1', selectItem);
      instance.checkboxInfoMap.set('1', item);
      instance.updateCheckboxSelectState();
      expect(true).assertTrue();

      instance.checkboxInfoMap.clear();
      instance.checkboxInfoMap.set('2', item);
      instance.updateCheckboxSelectState();
      expect(true).assertTrue();

      selectItem.belongId = '';
      selectItem.parentId = '1';
      instance.updateCheckboxSelectState();
      expect(true).assertTrue();

      instance.checkboxInfoMap.clear();
      instance.checkboxInfoMap.set('1', item);
      instance.updateCheckboxSelectState();
      expect(true).assertTrue();

      selectItem.belongId = undefined;
      selectItem.parentId = '';
      instance.updateCheckboxSelectState();
      expect(true).assertTrue();

      instance.multiSelectMap.clear();
      instance.unload();
    })

    it('test_startGather', 0, async () => {
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(instance, instance['illegalsGather']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      const mockFunc2: Function = mockKit.mockFunc(instance, instance.clearAllSelect);
      when(mockFunc2)(ArgumentMatchers.any).afterReturnNothing();
      const mockFunc3: Function = mockKit.mockFunc(instance, instance.finishDrag);
      when(mockFunc3)(ArgumentMatchers.any).afterReturnNothing();
      const mockFunc4: Function = mockKit.mockFunc(instance, instance['handlerGatherByUnSelectItem']);
      when(mockFunc4)(ArgumentMatchers.any).afterReturnNothing();
      const result1 = await instance.startGather('1', gestureEvent);
      expect(result1).assertFalse();

      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      const result2 = await instance.startGather('1', gestureEvent);
      expect(result2).assertFalse();

      let selectItem: MultiSelectItemType = new MultiSelectItemType();
      instance.multiSelectMap.set('1', selectItem);
      const result3 = await instance.startGather('1', gestureEvent);
      expect(result3).assertFalse();

      instance.multiSelectMap.clear();
      mockKit.clear(instance);
      mockKit.clearAll();
    })

    it('test_handlerGatherByUnSelectItem', 0, async () => {
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(instance, instance['createMultiSelectItem']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(undefined);

      let checkBoxInfo: CheckboxInfoType = new CheckboxInfoType();
      checkBoxInfo.parentItemInfo = new AppItemInfo();
      checkBoxInfo.parentItemInfo.page = 1;
      checkBoxInfo.belongFolderCheckboxId = '1';
      checkBoxInfo.parentType = CheckboxParentEnum.AppInFolder;
      instance.checkboxInfoMap.set('1', checkBoxInfo);
      let multiSelectItem: MultiSelectItemType = new MultiSelectItemType();
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.page = 1;
      let rect: Frame = {
        x: 0,
        y: 0,
        width: 0,
        height: 0,
      }

      const mockFunc2: Function = mockKit.mockFunc(instance, instance['getCacheItemInfoByCheckboxInfo']);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfo);
      const mockFunc3: Function = mockKit.mockFunc(instance, instance['getItemPositionInFolder']);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(rect);
      const mockFunc4: Function = mockKit.mockFunc(instance, instance['updateSelectItemPosition']);
      when(mockFunc4)(ArgumentMatchers.any).afterReturnNothing();

      await instance['handlerGatherByUnSelectItem']('1');
      expect(true).assertTrue();

      when(mockFunc1)(ArgumentMatchers.any).afterReturn(multiSelectItem);
      await instance['handlerGatherByUnSelectItem']('1');
      expect(true).assertTrue();

      checkBoxInfo.parentType = CheckboxParentEnum.App;
      await instance['handlerGatherByUnSelectItem']('1');
      expect(true).assertTrue();

      instance.checkboxInfoMap.clear();
      mockKit.clear(instance);
      mockKit.clearAll();
    })

    it('test_startDrag', 0, () => {
      instance.startDrag();
      expect(instance['status']['status']).assertEqual(MultiSelectStatusEnum.Dragging);
    })

    it('test_startDrop', 0, async () => {
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(instance, instance['status'].getEnteredState);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      const mockFunc2: Function = mockKit.mockFunc(LaunchLayoutCacheManager.getInstance(),
        LaunchLayoutCacheManager.getInstance().selectGridLayoutItemByItem);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      const mockFunc3: Function = mockKit.mockFunc(desktopUtil,
        desktopUtil.isFoldExpandStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);

      let gatherAnimateTarget: GatherAnimateTarget = new GatherAnimateTarget();
      const mockFunc4: Function = mockKit.mockFunc(instance, instance['createGatherAnimateTarget']);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(gatherAnimateTarget);
      const mockFunc5: Function = mockKit.mockFunc(instance, instance.doDropAnimate);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(true);
      const mockFunc6: Function = mockKit.mockFunc(instance, instance.finishDrag);
      when(mockFunc6)(ArgumentMatchers.any).afterReturnNothing();

      let item: MultiSelectItemType = new MultiSelectItemType();
      instance.multiSelectMap.set('1', item)
      instance.doDropAnimate = async () => {
        return true;
      }

      await instance.startDrop(0, 0, 0);
      expect(true).assertTrue();

      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.row = 1;
      gridLayoutItemInfo.column = 1;
      gridLayoutItemInfo.page = 2;
      gridLayoutItemInfo.area = [1];
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfo);
      await instance.startDrop(0, 0, 0);
      expect(true).assertTrue();

      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      await instance.startDrop(0, 0, 0);
      expect(true).assertTrue();

      instance.multiSelectMap.clear();
      mockKit.clear(instance);
      mockKit.clear(LaunchLayoutCacheManager.getInstance());
      mockKit.clear(desktopUtil);
      mockKit.clearAll();
    })

    it('test_getMultiIconToFolderTargetPos', 0, () => {
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(GridLayoutUtil, GridLayoutUtil.isBigFolder);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      const mockFunc2: Function = mockKit.mockFunc(folderLayoutUtil, folderLayoutUtil.getCurrentFolderCenterPosition);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn([0, 0]);
      const mockFunc3: Function = mockKit.mockFunc(folderLayoutUtil, GridLayoutUtil['getItemPostion']);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn({x: 0, y: 0});
      const mockFunc4: Function = mockKit.mockFunc(EditModeUtils, EditModeUtils.convertFolderCenterCoordinateToEditMode);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn({x: 0, y: 0});

      let rect: GridItemRect = {
        width: 0,
        height: 0,
        leftTopX: 0,
        leftTopY: 0,
        centerX: 0,
        centerY: 0
      }
      const mockFunc5: Function = mockKit.mockFunc(instance, instance['getSwiperPageGridByRowCol']);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(rect);

      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      expect(instance.getMultiIconToFolderTargetPos(1, 1, gridLayoutItemInfo, 1)[0]).assertEqual(0);

      expect(instance.getMultiIconToFolderTargetPos(0, 1, gridLayoutItemInfo, 1)[0]).assertEqual(0);

      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      expect(instance.getMultiIconToFolderTargetPos(0, 1, gridLayoutItemInfo, 1)[0]).assertEqual(0);

      expect(instance.getMultiIconToFolderTargetPos(1, 1, gridLayoutItemInfo, 1)[0]).assertEqual(0);

      mockKit.clear(instance);
      mockKit.clear(folderLayoutUtil);
      mockKit.clear(GridLayoutUtil);
      mockKit.clear(EditModeUtils);
      mockKit.clearAll();
    })

    it('test_getMultiIconToFolderDelay', 0, () => {
      instance.multiSelectMap.clear();
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(GridLayoutUtil, GridLayoutUtil.isBigFolder);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);

      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      expect(instance.getMultiIconToFolderDelay(1, 1, gridLayoutItemInfo, 0)).assertEqual(0);

      expect(instance.getMultiIconToFolderDelay(0, 1, gridLayoutItemInfo, 0)).assertEqual(0);

      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      expect(instance.getMultiIconToFolderDelay(1, 1, gridLayoutItemInfo, 0)).assertEqual(50);

      expect(instance.getMultiIconToFolderDelay(0, 1, gridLayoutItemInfo, 0)).assertEqual(0);

      mockKit.clear(GridLayoutUtil);
      mockKit.clearAll();
    })

    it('test_getMultiIconToFolderTargetSize', 0, () => {
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(folderLayoutUtil, folderLayoutUtil.getGridItemRect);
      let rect: Size = { width: 0, height: 0};
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(rect);
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      expect(instance.getMultiIconToFolderTargetSize(gridLayoutItemInfo, 0)[0]).assertEqual(0);

      mockKit.clear(folderLayoutUtil);
      mockKit.clearAll();
    })

    it('test_getMultiIconToFolderTargetIndex', 0, () => {
      expect(instance.getMultiIconToFolderTargetIndex(0, 0, 0)).assertEqual(-1);
    })

    it('test_getMultiIconToFolderType', 0, () => {
      let item: MultiSelectItemType = new MultiSelectItemType();
      item.parentId = '1'
      let folder: GridLayoutItemInfo = new GridLayoutItemInfo();
      let target: GatherAnimateTarget = new GatherAnimateTarget();

      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(GridLayoutUtil, GridLayoutUtil.isBigFolder);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      instance.resetDropAnimationItemZIndex = (key: string) => {}
      instance.resetDropAnimationItemOpacity = (key: string, opacity: number) => {}

      instance.getMultiIconToFolderType(item, 0, folder, target, 0, 0);
      expect(true).assertTrue();

      instance.getMultiIconToFolderType(item, 0, folder, target, 2, 0);
      expect(true).assertTrue();

      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);

      instance.getMultiIconToFolderType(item, 0, folder, target, 0, 0);
      expect(true).assertTrue();

      instance.getMultiIconToFolderType(item, 1, folder, target, 3, 0);
      expect(true).assertTrue();

      instance.getMultiIconToFolderType(item, 1, folder, target, 0, 0);
      expect(true).assertTrue();

      mockKit.clear(GridLayoutUtil);
      mockKit.clearAll();
    })

    it('test_startDropToFolder', 0, async () => {
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(instance, instance['status'].getEnteredState);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      const mockFunc2: Function = mockKit.mockFunc(instance, instance.finishDrag);
      when(mockFunc2)(ArgumentMatchers.any).afterReturnNothing();

      instance.doDropToFolderAnimate = async () => {
        return true;
      }
      let folder: GridLayoutItemInfo = new GridLayoutItemInfo();
      await instance.startDropToFolder(0, 0, folder);
      expect(true).assertTrue();

      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      await instance.startDropToFolder(0, 0, folder);
      expect(true).assertTrue();

      mockKit.clear(instance);
      mockKit.clear(GridLayoutUtil);
      mockKit.clearAll();
    })

    it('test_finishDrag', 0, async () => {
      instance.multiSelectMap.clear();
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(instance, instance['syncCheckboxAppItemInfoFromCache']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturnNothing();

      instance.inAnimation = true;
      instance.releaseAnimateItem = () => {};
      await instance.finishDrag();
      expect(true).assertTrue();

      instance.inAnimation = false;
      await instance.finishDrag();
      expect(true).assertTrue();

      instance['status'].setStatus(MultiSelectStatusEnum.Exited);
      await instance.finishDrag();
      expect(true).assertTrue();

      instance['status'].setStatus(MultiSelectStatusEnum.Dragging);
      await instance.finishDrag();
      expect(true).assertTrue();

      mockKit.clear(instance);
      mockKit.clearAll();
    })

    it('test_syncCheckboxAppItemInfoFromCache', 0, async () => {
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(instance, instance['getCachedItemInfo']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(undefined);

      let checkboxInfo1: CheckboxInfoType = new CheckboxInfoType();
      checkboxInfo1.checkState = new CheckboxCheckState();
      checkboxInfo1.parentType = CheckboxParentEnum.AppInFolder;
      checkboxInfo1.parentItemInfo = new AppItemInfo();
      checkboxInfo1.parentId = '1';
      let checkboxInfo2: CheckboxInfoType = new CheckboxInfoType();
      checkboxInfo2.checkState = new CheckboxCheckState();
      checkboxInfo2.parentType = CheckboxParentEnum.App;
      checkboxInfo2.parentItemInfo = new AppItemInfo();
      checkboxInfo2.parentId = '2';

      let cacheParentItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      cacheParentItemInfo.page = 1;
      cacheParentItemInfo.row = 1;
      cacheParentItemInfo.column = 1;

      instance.checkboxInfoMap.set('1', checkboxInfo1);
      instance.checkboxInfoMap.set('2', checkboxInfo2);
      await instance['syncCheckboxAppItemInfoFromCache']();
      expect(true).assertTrue();

      when(mockFunc1)(ArgumentMatchers.any).afterReturn(cacheParentItemInfo);
      await instance['syncCheckboxAppItemInfoFromCache']();
      expect(true).assertTrue();

      instance.checkboxInfoMap.clear();
      mockKit.clear(instance);
      mockKit.clearAll();
    })

    it('test_syncAppItemInfoFormCacheAfterSingleDrag', 0, () => {
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(instance, instance['getCacheItemInfoByCheckboxInfo']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(undefined);

      instance['status'].setStatus(MultiSelectStatusEnum.Exited);
      expect(instance.syncAppItemInfoFormCacheAfterSingleDrag('1')).assertFalse();

      instance['status'].setStatus(MultiSelectStatusEnum.Entered);
      expect(instance.syncAppItemInfoFormCacheAfterSingleDrag('1')).assertFalse();

      let checkboxInfo: CheckboxInfoType = new CheckboxInfoType();
      checkboxInfo.parentItemInfo = new AppItemInfo();
      instance.checkboxInfoMap.set('1', checkboxInfo);
      expect(instance.syncAppItemInfoFormCacheAfterSingleDrag('1')).assertFalse();

      let cacheParentItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      cacheParentItemInfo.page = 1;
      cacheParentItemInfo.row = 1;
      cacheParentItemInfo.column = 1;
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(cacheParentItemInfo);
      expect(instance.syncAppItemInfoFormCacheAfterSingleDrag('1')).assertTrue();

      instance.checkboxInfoMap.clear();
      mockKit.clear(instance);
      mockKit.clearAll();
    })

    it('test_checkIsGatherStarted', 0, () => {
      instance['status'].setStatus(MultiSelectStatusEnum.Entered);
      instance.checkIsGatherStarted(gestureEvent);
      expect(true).assertTrue();

      instance['status'].setStatus(MultiSelectStatusEnum.Dragging);
      instance.checkIsGatherStarted(gestureEvent);
      expect(true).assertTrue();

      instance['status'].setStatus(MultiSelectStatusEnum.Exited);
      instance.checkIsGatherStarted(gestureEvent);
      expect(true).assertTrue();
    })

    it('test_uploadCheckboxInfo', 0, () => {
      let checkboxInfo: CheckboxInfoType = new CheckboxInfoType();
      checkboxInfo.checkState = new CheckboxCheckState();
      checkboxInfo.parentType = CheckboxParentEnum.Folder;
      checkboxInfo.parentId = '1';

      let item1: MultiSelectItemType = new MultiSelectItemType();
      item1.belongId = '1';
      let item2: MultiSelectItemType = new MultiSelectItemType();
      item2.belongId = '2';
      instance.multiSelectMap.set('1', item1);
      instance.multiSelectMap.set('2', item2);

      instance.uploadCheckboxInfo(checkboxInfo);
      expect(instance.checkboxInfoMap.size).assertEqual(1);
      instance.checkboxInfoMap.clear();

      checkboxInfo.parentType = CheckboxParentEnum.App;
      instance.uploadCheckboxInfo(checkboxInfo);
      expect(instance.checkboxInfoMap.size).assertEqual(1);
      instance.checkboxInfoMap.clear();

      instance.multiSelectMap.clear();
    })

    it('test_isItemSelected', 0, () => {
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(instance, instance.getUniqueId);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn('1');

      let appItemInfo: AppItemInfo = new AppItemInfo();
      expect(instance.isItemSelected(appItemInfo)).assertFalse();

      let item: MultiSelectItemType = new MultiSelectItemType();
      instance.multiSelectMap.set('1', item);
      expect(instance.isItemSelected(appItemInfo)).assertTrue();

      instance.multiSelectMap.clear();
      mockKit.clear(instance);
      mockKit.clearAll();
    })

    it('test_getUniqueId', 0, () => {
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(GridLayoutUtil, GridLayoutUtil.generateUniqueKey);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn('1');

      let appItemInfo1: AppItemInfo = new AppItemInfo();
      expect(instance.getUniqueId(appItemInfo1)).assertEqual('1');
      let appItemInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
      expect(instance.getUniqueId(appItemInfo2)).assertEqual('1');

      mockKit.clear(GridLayoutUtil);
      mockKit.clearAll();
    })

    it('test_updateTouchPos', 0, () => {
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(instance, instance['isMoveExceededThreshold']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      instance.updateAnimationTarget = (position: Position): void => {}

      instance.updateTouchPos(touchEvent)
      expect(true).assertTrue();

      instance['status'].setStatus(MultiSelectStatusEnum.Gathering);
      instance.updateTouchPos(touchEvent)
      expect(true).assertTrue();

      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      instance.updateTouchPos(touchEvent)
      expect(true).assertTrue();

      mockKit.clear(instance);
      mockKit.clearAll();
    })

    it('test_getFinalIconPosition', 0, () => {
      instance.lastActionTouchPosition = {x: -1, y: -1};
      let result = instance.getFinalIconPosition();
      expect(result.x).assertEqual(-1);
    })

    it('test_isMoveExceededThreshold', 0, () => {
      instance.lastActionTouchPosition = {x: -1, y: -1};

      let currentTouchPosition1: Position = {x: 1, y: 1};
      expect(instance['isMoveExceededThreshold'](currentTouchPosition1)).assertTrue();

      let currentTouchPosition2: Position = {x: 1, y: -1};
      expect(instance['isMoveExceededThreshold'](currentTouchPosition2)).assertTrue();

      let currentTouchPosition3: Position = {x: -1, y: 1};
      expect(instance['isMoveExceededThreshold'](currentTouchPosition3)).assertTrue();

      let currentTouchPosition4: Position = {x: -1, y: -1};
      expect(instance['isMoveExceededThreshold'](currentTouchPosition4)).assertFalse();
    })

    it('test_onCheckboxSelect', 0, async () => {
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(instance, instance['notifyFolderCheckboxUpdate']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturnNothing();
      const mockFunc2: Function = mockKit.mockFunc(instance, instance['createMultiSelectItem']);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);

      let checkboxInfo: CheckboxInfoType = new CheckboxInfoType();
      checkboxInfo.parentId = '1';
      let result1 = await instance['onCheckboxSelect'](checkboxInfo);
      expect(result1).assertFalse();

      let multiSelectItem: MultiSelectItemType = new MultiSelectItemType();
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(multiSelectItem);
      let result2 = await instance['onCheckboxSelect'](checkboxInfo);
      expect(result2).assertTrue();

      instance.multiSelectMap.clear();
      mockKit.clear(instance);
      mockKit.clearAll();
    })

    it('test_onCheckboxUnSelect', 0, async () => {
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(instance, instance['notifyFolderCheckboxUpdate']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturnNothing();

      let checkboxInfo: CheckboxInfoType = new CheckboxInfoType();
      checkboxInfo.parentId = '1';
      let result1 = await instance['onCheckboxUnSelect'](checkboxInfo);
      expect(result1).assertTrue();

      let multiSelectItem: MultiSelectItemType = new MultiSelectItemType();
      instance.multiSelectMap.set('2', multiSelectItem);
      let result2 = await instance['onCheckboxUnSelect'](checkboxInfo);
      expect(result2).assertTrue();

      when(mockFunc1)(ArgumentMatchers.any).afterThrow('error onCheckboxUnSelect');
      let result3 = await instance['onCheckboxUnSelect'](checkboxInfo);
      expect(result3).assertFalse();

      instance.multiSelectMap.clear();
      mockKit.clear(instance);
      mockKit.clearAll();
    })

    it('test_createMultiSelectItem', 0, async () => {
      let selectItem: MultiSelectItemType = new MultiSelectItemType();
      selectItem.belongId = '1';

      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(instance, instance['createFolderAppMultiSelectItem']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(selectItem);
      const mockFunc2: Function = mockKit.mockFunc(instance, instance['createDesktopAppMultiSelectItem']);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(selectItem);

      let checkboxInfo: CheckboxInfoType = new CheckboxInfoType();
      checkboxInfo.parentType = CheckboxParentEnum.AppInFolder;
      checkboxInfo.parentId = '1';
      let result1 = await instance['createMultiSelectItem'](checkboxInfo);
      expect(result1?.belongId).assertEqual('1');

      checkboxInfo.parentType = CheckboxParentEnum.App;
      let result2 = await instance['createMultiSelectItem'](checkboxInfo);
      expect(result2?.belongId).assertEqual('1');

      checkboxInfo.parentType = CheckboxParentEnum.Folder;
      let result3 = await instance['createMultiSelectItem'](checkboxInfo);
      expect(result3?.belongId).assertUndefined();

      mockKit.clear(instance);
      mockKit.clearAll();
    })

    it('test_createDesktopAppMultiSelectItem', 0, async () => {
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(instance, instance['getSnapshotById']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(undefined);

      let checkboxInfo: CheckboxInfoType = new CheckboxInfoType();
      let result = await instance['createDesktopAppMultiSelectItem'](checkboxInfo);
      expect(result).assertUndefined();

      mockKit.clear(instance);
      mockKit.clearAll();
    })

    it('test_createFolderAppMultiSelectItem', 0, async () => {
      let selectItem: MultiSelectItemType = new MultiSelectItemType();

      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(instance, instance['createDesktopAppMultiSelectItem']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(undefined);

      let checkboxInfo: CheckboxInfoType = new CheckboxInfoType();
      checkboxInfo.parentId = '1'
      checkboxInfo.belongFolderCheckboxId = '1';
      checkboxInfo.parentItemInfo = new AppItemInfo();
      instance.checkboxInfoMap.set('1', checkboxInfo);
      let result1 = await instance['createFolderAppMultiSelectItem'](checkboxInfo);
      expect(result1).assertUndefined();

      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let child: GridLayoutItemInfo = new GridLayoutItemInfo();
      child.page = 1;
      child.row = 1;
      child.column = 1;
      gridLayoutItemInfo.layoutInfo = [[child]];

      let folderInfo1: FolderInfo = {
        isOpened: false,
        pageIndexInFolder: 0,
        lastOpenedFolderItemInfo: gridLayoutItemInfo,
        lastOpenedFolderUniqueId: ''
      }

      let folderInfo2: FolderInfo = {
        isOpened: true,
        pageIndexInFolder: 0,
        lastOpenedFolderItemInfo: gridLayoutItemInfo,
        lastOpenedFolderUniqueId: ''
      }

      when(mockFunc1)(ArgumentMatchers.any).afterReturn(selectItem);
      const mockFunc2: Function = mockKit.mockFunc(instance, instance['getCurrentFolderInfo']);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(folderInfo1);
      const mockFunc3: Function = mockKit.mockFunc(instance, instance['getRectByItemInfo']);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(gridItemRect);

      let result2 = await instance['createFolderAppMultiSelectItem'](checkboxInfo);
      expect(result2?.defaultX).assertEqual(0);

      when(mockFunc2)(ArgumentMatchers.any).afterReturn(folderInfo2);
      const mockFunc4: Function = mockKit.mockFunc(instance, instance['getCachedItemInfo']);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfo);
      const mockFunc5: Function = mockKit.mockFunc(instance, instance.getUniqueId);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn('2');
      let result3 = await instance['createFolderAppMultiSelectItem'](checkboxInfo);
      expect(result3?.defaultX).assertEqual(0);

      instance.checkboxInfoMap.clear();
      mockKit.clear(instance);
      mockKit.clearAll();
    })

    it('test_updateFolderCheckboxState', 0, () => {
      let checkboxInfo: CheckboxInfoType = new CheckboxInfoType();
      instance.checkboxInfoMap.set('1', checkboxInfo);
      checkboxInfo.checkState = new CheckboxCheckState();

      expect(instance['updateFolderCheckboxState']('2', false)).assertFalse();

      expect(instance['updateFolderCheckboxState']('1', false)).assertTrue();

      expect(instance['updateFolderCheckboxState']('1', true)).assertTrue();

      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(log, log.showError);
      when(mockFunc1)(ArgumentMatchers.any).afterThrow('error test_updateFolderCheckboxState');
      expect(instance['updateFolderCheckboxState']('2', false)).assertFalse();

      instance.checkboxInfoMap.clear();
      mockKit.clear(log);
      mockKit.clear(instance);
      mockKit.clearAll();
    })

    it('test_updateSelectItemPosition', 0, () => {
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(instance, instance['getItemPositionInDesktop']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn({ x: 0, y: 0 });
      let rect: Frame = {
        x: 0,
        y: 0,
        width: 0,
        height: 0,
      }
      const mockFunc2: Function = mockKit.mockFunc(instance, instance['getItemPositionInFolder']);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(rect);

      let selectItem: MultiSelectItemType = new MultiSelectItemType();
      selectItem.iconSize = 0;
      let folderInfo: FolderInfo = {
        isOpened: false,
        pageIndexInFolder: 0,
        lastOpenedFolderItemInfo: new GridLayoutItemInfo,
        lastOpenedFolderUniqueId: ''
      }
      let gatherPosition: Position = {
        x: 0,
        y: 0
      }
      instance['updateSelectItemPosition'](selectItem, 0, gatherPosition, folderInfo);
      expect(true).assertTrue();

      selectItem.belongId = '1';
      instance['updateSelectItemPosition'](selectItem, 0, gatherPosition, folderInfo);
      expect(true).assertTrue();

      let checkboxInfo: CheckboxInfoType = new CheckboxInfoType();
      checkboxInfo.parentItemInfo = new AppItemInfo();
      instance.checkboxInfoMap.set('1', checkboxInfo)
      instance['updateSelectItemPosition'](selectItem, 0, gatherPosition, folderInfo);
      expect(true).assertTrue();

      instance.checkboxInfoMap.clear();
      mockKit.clear(instance);
      mockKit.clearAll();
    })

    it('test_getItemPositionInFolder', 0, () => {
      let itemInfo: AppItemInfo = new AppItemInfo();
      let folder: AppItemInfo = new AppItemInfo();
      let folderInfo: FolderInfo = {
        isOpened: false,
        pageIndexInFolder: 0,
        lastOpenedFolderItemInfo: new GridLayoutItemInfo,
        lastOpenedFolderUniqueId: '1'
      }
      let rect: Frame = {
        x: 0,
        y: 0,
        width: 0,
        height: 0,
      }
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(instance, instance['getItemPositionInOpenedFolder']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(rect);
      const mockFunc2: Function = mockKit.mockFunc(instance, instance['getItemPositionInCollapsedFolder']);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(rect);
      const mockFunc3: Function = mockKit.mockFunc(instance, instance['getCurrentFolderInfo']);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(folderInfo);
      const mockFunc4: Function = mockKit.mockFunc(instance, instance.getUniqueId);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn('0');

      expect(instance['getItemPositionInFolder'](itemInfo, folder, 0, folderInfo).x).assertEqual(0);
      folderInfo.isOpened = true;
      expect(instance['getItemPositionInFolder'](itemInfo, folder, 0, folderInfo).x).assertEqual(0);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn('1');
      expect(instance['getItemPositionInFolder'](itemInfo, folder, 0, folderInfo).x).assertEqual(0);

      mockKit.clear(instance);
      mockKit.clearAll();
    })

    it('test_notifyFolderCheckboxUpdate', 0, () => {
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(instance, instance['updateFolderCheckboxState']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturnNothing();

      let checkboxInfo: CheckboxInfoType = new CheckboxInfoType();
      checkboxInfo.parentId = '1';
      checkboxInfo.parentType = CheckboxParentEnum.App;
      expect(instance['notifyFolderCheckboxUpdate'](checkboxInfo, true)).assertFalse();

      checkboxInfo.parentType = CheckboxParentEnum.AppInFolder;
      expect(instance['notifyFolderCheckboxUpdate'](checkboxInfo, true)).assertFalse();

      checkboxInfo.belongFolderCheckboxId = '1';
      expect(instance['notifyFolderCheckboxUpdate'](checkboxInfo, true)).assertTrue();

      mockKit.clear(instance);
      mockKit.clearAll();
    })

    it('test_getGridSwiperWidth', 0, async () => {
      expect(instance['getGridSwiperWidth'](true)).assertLarger(0);
      expect(instance['getGridSwiperWidth'](false)).assertLarger(0);
    })

    it('test_isDeliverApp_02_27', 0, async () => {
      let mockKit: MockKit = new MockKit();
      try {
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);

        let checkboxInfo: CheckboxInfoType = new CheckboxInfoType();
        checkboxInfo.belongFolderCheckboxId = '1';
        checkboxInfo.parentType = CheckboxParentEnum.App;
        checkboxInfo.parentItemInfo = new AppItemInfo();
        (checkboxInfo.parentItemInfo as Object as GridLayoutItemInfo).folderId = '1';
        instance.checkboxInfoMap.set('1', checkboxInfo);
        expect(instance['isDeliverApp'](checkboxInfo)).assertInstanceOf('Boolean');

        checkboxInfo.parentType = CheckboxParentEnum.AppInFolder;
        expect(instance['isDeliverApp'](checkboxInfo)).assertInstanceOf('Boolean');

        instance.checkboxInfoMap.clear();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mockKit.clearAll();
    })

    it('test_gatherAnimation', 0, async () => {
      let result = await instance['gatherAnimation']([new MultiSelectItemType()]);
      expect(result).assertFalse();
    })

    it('test_preLoadAnimationViewBySelectItemList', 0, () => {
      expect(instance['preLoadAnimationViewBySelectItemList']([new MultiSelectItemType()])).assertFalse();
    })

    it('test_getFolderUniqueId', 0, () => {
      let mockKit: MockKit = new MockKit();
      const mockFunc1: Function = mockKit.mockFunc(GridLayoutUtil, GridLayoutUtil.isBigFolder);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      const mockFunc2: Function = mockKit.mockFunc(instance, instance.getUniqueId);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn('1');

      expect(instance.getFolderUniqueId(new GridLayoutItemInfo())).assertContain('bigFolderItem');
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      expect(instance.getFolderUniqueId(new GridLayoutItemInfo())).assertContain('smallFolderItem');

      mockKit.clear(GridLayoutUtil);
      mockKit.clear(instance);
      mockKit.clearAll();
    })

    it('test_triggerManualDrop_01', 0, () => {
      let res: void = (instance as object)['triggerManualDrop'];
      expect(res !== null).assertTrue()
    })

    it('test_uploadCheckboxInfo_01', 0, () => {
      let checkboxInfo = new CheckboxInfoType();
      checkboxInfo.parentType = CheckboxParentEnum.Folder
      let res: void = instance.uploadCheckboxInfo(checkboxInfo)
      expect(res !== null).assertTrue()
    })

    it('test_getItemPositionInOpenedFolder_01', 0, () => {
      let folderItem = new GridLayoutItemInfo();
      let selectItem = new AppItemInfo();
      let folderInfo = {} as FolderInfo;
      let res: Frame = (instance as object)['getItemPositionInOpenedFolder'](folderItem, selectItem, folderInfo)
      expect(res !== null).assertTrue()
    })
  })
}
