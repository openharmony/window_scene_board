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

import { CheckEmptyUtils, DataProperty } from '@ohos/basicutils';
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  ArgumentMatchers,
  when
} from '@ohos/hypium'
import { GridLayoutItemInfo } from '../../../../..'
import {
  CommonConstants
} from '../../../../../../../../staticcommon/launchercommon/src/main/ets/constants/CommonConstants';
import OpenFolderDragHandler from '../../../../main/ets/default/common/OpenFolderDragHandler'
import { unifiedDataChannel } from '@kit.ArkData';
import { FolderData, folderLayoutUtil, GridLayoutUtil } from '@ohos/launchercommon';
import { OpenFolderAppMoveVm } from '../../../../main/ets/default/viewmodel/OpenFolderAppMoveVM';
import { openFolderAppMoveVMManager } from '../../../../main/ets/default/viewmodel/OpenFolderAppMoveVMManager';

export default function OpenFolderDragHandlerTest() {
  describe('OpenFolderDragHandlerTest', () => {
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
    it('assertEqual', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let a = 'test'
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test')
    })

    it('test_getDragItemInfo_01', 0, () => {
      let instance: OpenFolderDragHandler = OpenFolderDragHandler.getInstance();

      let appInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_FOLDER;

      appInfo1.layoutInfo = [[item1],[item2]];
      appInfo1.typeId = CommonConstants.TYPE_FOLDER;
      appInfo1.keyName = 'keyName0';

      AppStorage.setOrCreate('dropItemInfo', appInfo1);
      let ret: GridLayoutItemInfo = instance.getDragItemInfo()
      expect(ret).not().assertNull();
      AppStorage.clear();
    });

    it('test_getDragItemInfo_02', 0, () => {
      let instance: OpenFolderDragHandler = OpenFolderDragHandler.getInstance();

      AppStorage.setOrCreate('dropItemInfo', null);
      let ret: GridLayoutItemInfo = instance.getDragItemInfo()
      expect(ret).not().assertNull();
      AppStorage.clear();
    });

    it('test_getCenterPositionList_01', 0, () => {
      let instance: OpenFolderDragHandler = OpenFolderDragHandler.getInstance();
      type ItemPosition = [number, number]
      let ret: ItemPosition[] = instance.getCenterPositionList();
      expect(instance).not().assertNull();
    });

    it('test_getCurrentIndex_01', 0, () => {
      let instance: OpenFolderDragHandler = OpenFolderDragHandler.getInstance();
      let x: number = -1;
      let y: number = -1;

      let ret: number = instance.getCurrentIndex(x, y);
      expect(ret).assertEqual(0);
    });

    it('test_getCenterPositionList_01', 0, () => {
      type ItemPosition = [number, number];
      let instance: OpenFolderDragHandler = OpenFolderDragHandler.getInstance();
      let ret: ItemPosition[] = instance.getCenterPositionList();
      expect(ret).not().assertNull();
    });

    it('test_dragStart_01', 0, () => {
      try {
        let dragItem: GridLayoutItemInfo = {} as GridLayoutItemInfo;
        let event: SimpleDragEvent = new SimpleDragEvent();
        let displayX = 40;
        event.setDisplayX(displayX);
        let displayY = 10;
        event.setDisplayY(displayY);
        let instance: OpenFolderDragHandler = OpenFolderDragHandler.getInstance();
        let x: number = 64;
        let y: number = 30;
        let width: number = 150;
        let height: number = 263;
        let rect: Rectangle = {
          x,
          y,
          width,
          height
        };
        event.setPreviewRect(rect);
        let dragItemType: number = CommonConstants.TYPE_FOLDER;
        instance.dragStart(dragItem, event, dragItemType);
        expect(instance).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_dragStart_02', 0, () => {
      try {
        let dragItem: GridLayoutItemInfo = new GridLayoutItemInfo();
        dragItem.bundleName = 'com.ohos.sceneboard';
        dragItem.keyName = 'keyName3'
        dragItem.appIconId = 92;
        dragItem.typeId = CommonConstants.TYPE_APP;
        dragItem.container = 1;
        dragItem.folderId = 'folder_0001';
        dragItem.badgeNumber = 0;
        dragItem.area = [1, 1]
        dragItem.page = 5;
        dragItem.row = 3;
        dragItem.column = 0;
        dragItem.itemType = CommonConstants.TYPE_APP;
        let event: SimpleDragEvent = new SimpleDragEvent();
        let displayX = 40;
        event.setDisplayX(displayX);
        let displayY = 10;
        event.setDisplayY(displayY);
        let instance: OpenFolderDragHandler = OpenFolderDragHandler.getInstance();
        let x: number = 62;
        let y: number = 10;
        let width: number = 150;
        let height: number = 88;
        let rect: Rectangle = {
          x,
          y,
          width,
          height
        };
        event.setPreviewRect(rect);
        let dragItemType: number = CommonConstants.TYPE_FOLDER;
        instance.dragStart(dragItem, event, dragItemType);
        expect(instance).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_dragDrop_01', 0, () => {
      let event: DragEvent = new SimpleDragEvent();
      let instance: OpenFolderDragHandler = OpenFolderDragHandler.getInstance();

      let dropIndex: number = -20;
      let key: string = 'aaaa';

      instance.dragDrop(event, dropIndex, key);
      expect(instance).not().assertNull();
    });

    it('test_dragDrop_02', 0, () => {
      let event: SimpleDragEvent = new SimpleDragEvent();
      let displayX = 10;
      event.setDisplayX(displayX);

      let displayY = 200;
      event.setDisplayY(displayY);
      let instance: OpenFolderDragHandler = OpenFolderDragHandler.getInstance();

      let x: number = 20;
      let key: string = 'key110';

      instance.dragDrop(event, x, key);
      expect(instance).not().assertNull();
    });

    it('test_dragStart_001', 0, () => {
      let dragItem: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      let event: SimpleDragEvent = new SimpleDragEvent();
      let displayX = 40;
      event.setDisplayX(displayX);
      let displayY = 10;
      event.setDisplayY(displayY);
      let instance: OpenFolderDragHandler = OpenFolderDragHandler.getInstance();
      let x: number = 64;
      let y: number = 30;
      let width: number = 150;
      let height: number = 263;
      let rect: Rectangle = {
        x,
        y,
        width,
        height
      };
      event.setPreviewRect(rect);
      let dragItemType: number = CommonConstants.TYPE_FOLDER;
      let folderDataInstance = FolderData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(folderDataInstance, folderDataInstance.getIndex);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(0);
      instance.dragStart(getNullObject() as GridLayoutItemInfo, event, dragItemType);
      instance.dragStart(dragItem, event, dragItemType);
      let saveValue: DataProperty | undefined = AppStorage.get('startPosition');
      expect(saveValue).not().assertUndefined();
      mocker.clear(folderDataInstance);
      mocker.clearAll();
    });


    it('test_dragDrop_001', 0, () => {
      AppStorage.set('isDrag', false);
      expect(AppStorage.get('isDrag')).assertFalse();
      let instance: OpenFolderDragHandler = OpenFolderDragHandler.getInstance();
      let dropIndex: number = -20;
      let key: string = 'aaaa';
      instance.dragDrop(getNullObject() as DragEvent, dropIndex, key);
      expect(AppStorage.get('isDrag')).assertFalse();
      let event: DragEvent = new SimpleDragEvent();
      instance.dragDrop(event, dropIndex, key);
      expect(AppStorage.get('isDrag')).assertFalse();
      instance.dragDrop(event, 1000, key);
      expect(AppStorage.get('isDrag')).assertFalse();
    });

    it('test_dragDrop_002', 0, () => {
      AppStorage.set('isDrag', false);
      expect(AppStorage.get('isDrag')).assertFalse();
      let instance: OpenFolderDragHandler = OpenFolderDragHandler.getInstance();
      let dropIndex: number = 0;
      let key: string = 'aaaa';
      let event: DragEvent = new SimpleDragEvent();
      instance.dragDrop(event, dropIndex, key);
      expect(AppStorage.get('isDrag')).assertFalse();
    });

    it('test_animationToOriginalPos_001', 0, () => {
      let event: DragEvent = new SimpleDragEvent();
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.getSingleDragItemInfo);
      when(mockFunc)().afterReturn(null);
      let instance: OpenFolderDragHandler = OpenFolderDragHandler.getInstance();
      let res = instance.animationToOriginalPos(event, 0);
      expect(res).assertFalse();
      let mockFunc1 = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isValidLayoutItem);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      let res1 = instance.animationToOriginalPos(event, 0);
      expect(res1).assertTrue();
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
    });

    it('test_StartAndEndIndex_001', 0, () => {
      let instance: OpenFolderDragHandler = OpenFolderDragHandler.getInstance();
      instance.initStartAndEndIndex(1);
      let dragEndIndex = instance.getDragEndIndex();
      expect(dragEndIndex).assertEqual(1);
    });

    it('test_startToFillPostion_001', 0, () => {
      let instance: OpenFolderDragHandler = OpenFolderDragHandler.getInstance();
      let endIndex: number = 2;
      let pageIndex: number = 0;
      let msg: string = 'testMsg';
      instance.initStartAndEndIndex(0);
      let folderDataInstance: FolderData = FolderData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(folderDataInstance, folderDataInstance.isFolderOpen);
      when(mockFunc)().afterReturn(false);
      instance.startToFillPostion(endIndex, pageIndex, msg);
      let dragEndIndex = instance.getDragEndIndex();
      expect(dragEndIndex).assertEqual(0);
      mocker.clear(folderDataInstance);
      mocker.clearAll();
    });

    it('test_startToFillPostion_002', 0, () => {
      let instance: OpenFolderDragHandler = OpenFolderDragHandler.getInstance();
      let endIndex: number = 2;
      let pageIndex: number = 0;
      let msg: string = 'testMsg';
      instance.initStartAndEndIndex(0);
      let folderDataInstance: FolderData = FolderData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(folderDataInstance, folderDataInstance.isFolderOpen);
      when(mockFunc)().afterReturn(true);
      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      let items: GridLayoutItemInfo[] = [];
      for (let index = 0; index < 4; index++) {
        let item = new GridLayoutItemInfo();
        item.keyName = 'testkeyName' + index;
        item.bundleName = 'testbundleName' + index;
        items.push(item);
      }
      openFolderData.layoutInfo = [items];
      let mockFunc1 = mocker.mockFunc(folderDataInstance, folderDataInstance.getOpenedFolder);
      when(mockFunc1)().afterReturn(openFolderData);
      let itemVm: OpenFolderAppMoveVm = new OpenFolderAppMoveVm();
      itemVm.translateX = 0;
      itemVm.translateY = 0;
      let mockFunc2 = mocker.mockFunc(openFolderAppMoveVMManager, openFolderAppMoveVMManager.getMoveVmByItem);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(itemVm);
      let mockFunc21 = mocker.mockFunc(instance, instance.getNextIndex);
      when(mockFunc21)(ArgumentMatchers.any).afterReturn(1);
      type ItemPosition = [number, number];
      let centerPositionList: ItemPosition[] = [[0, 1], [1, 2]];
      let openFolderDragHandler: OpenFolderDragHandler = OpenFolderDragHandler.getInstance();
      let mockFunc3 = mocker.mockFunc(openFolderDragHandler, openFolderDragHandler.getCenterPositionList);
      when(mockFunc3)().afterReturn(centerPositionList);
      instance.startToFillPostion(endIndex, pageIndex, msg);
      let dragEndIndex = instance.getDragEndIndex();
      expect(dragEndIndex).not().assertEqual(0);
      mocker.clear(instance);
      mocker.clear(folderDataInstance);
      mocker.clear(openFolderAppMoveVMManager);
      mocker.clear(openFolderDragHandler);
      mocker.clearAll();
    });

    it('test_startToFillPostion_003', 0, () => {
      let instance: OpenFolderDragHandler = OpenFolderDragHandler.getInstance();
      let endIndex: number = 2;
      let pageIndex: number = 0;
      let msg: string = 'testMsg';
      instance.initStartAndEndIndex(0);
      let folderDataInstance: FolderData = FolderData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(folderDataInstance, folderDataInstance.isFolderOpen);
      when(mockFunc)().afterReturn(true);
      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      let items: GridLayoutItemInfo[] = [];
      for (let index = 0; index < 4; index++) {
        let item = new GridLayoutItemInfo();
        item.keyName = 'testkeyName' + index;
        item.bundleName = 'testbundleName' + index;
        items.push(item);
      }
      openFolderData.layoutInfo = [items];
      let mockFunc1 = mocker.mockFunc(folderDataInstance, folderDataInstance.getOpenedFolder);
      when(mockFunc1)().afterReturn(openFolderData);
      let itemVm: OpenFolderAppMoveVm = new OpenFolderAppMoveVm();
      itemVm.translateX = 1;
      itemVm.translateY = 0;
      let mockFunc2 = mocker.mockFunc(openFolderAppMoveVMManager, openFolderAppMoveVMManager.getMoveVmByItem);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(itemVm);
      let mockFunc21 = mocker.mockFunc(instance, instance.getNextIndex);
      when(mockFunc21)(ArgumentMatchers.any).afterReturn(1);
      type ItemPosition = [number, number];
      let centerPositionList: ItemPosition[] = [[0, 1], [1, 2], [1, 2], [1, 2]];
      let openFolderDragHandler: OpenFolderDragHandler = OpenFolderDragHandler.getInstance();
      let mockFunc3 = mocker.mockFunc(openFolderDragHandler, openFolderDragHandler.getCenterPositionList);
      when(mockFunc3)().afterReturn(centerPositionList);
      instance.startToFillPostion(endIndex, pageIndex, msg);
      let dragEndIndex = instance.getDragEndIndex();
      expect(dragEndIndex).not().assertEqual(0);
      mocker.clear(instance);
      mocker.clear(folderDataInstance);
      mocker.clear(openFolderAppMoveVMManager);
      mocker.clear(openFolderDragHandler);
      mocker.clearAll();
    });

    it('test_getNextIndex_001', 0, () => {
      let instance: OpenFolderDragHandler = OpenFolderDragHandler.getInstance();
      (instance as object)['dragStartIndex'] = 1;
      (instance as object)['dragEndIndex'] = 2;
      let nextIndex: number = instance.getNextIndex(0);
      expect(nextIndex).assertEqual(0);
      (instance as object)['dragStartIndex'] = 1;
      (instance as object)['dragEndIndex'] = 3;
      let nextIndex1: number = instance.getNextIndex(2);
      expect(nextIndex1).assertEqual(1);
      (instance as object)['dragStartIndex'] = 3;
      (instance as object)['dragEndIndex'] = 1;
      let nextIndex2: number = instance.getNextIndex(2);
      expect(nextIndex2).assertEqual(3);
      (instance as object)['dragStartIndex'] = 1;
      (instance as object)['dragEndIndex'] = 3;
      let nextIndex3: number = instance.getNextIndex(4);
      expect(nextIndex3).assertEqual(4);
      (instance as object)['dragStartIndex'] = 3;
      (instance as object)['dragEndIndex'] = 1;
      let nextIndex4: number = instance.getNextIndex(0);
      expect(nextIndex4).assertEqual(0);
      instance.initStartAndEndIndex(0);
    });

    it('test_updateLayoutCacheAfterFillPosition_001', 0, () => {
      let instance: OpenFolderDragHandler = OpenFolderDragHandler.getInstance();
      let originLayoutInfo: GridLayoutItemInfo[] = [];
      for (let index = 0; index < 3; index++) {
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.id = index;
        originLayoutInfo.push(item);
      }
      instance.initStartAndEndIndex(4);
      instance.updateLayoutCacheAfterFillPosition(originLayoutInfo);
      expect(originLayoutInfo[0].id).assertEqual(0);
      instance.initStartAndEndIndex(0);
      instance.updateLayoutCacheAfterFillPosition(originLayoutInfo);
      expect(originLayoutInfo[0].id).assertEqual(0);
      instance.initStartAndEndIndex(0);
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)().afterReturn(true);
      instance.updateLayoutCacheAfterFillPosition(originLayoutInfo);
      expect(originLayoutInfo[0].id).assertEqual(0);
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('test_judgeTranslateBeforeInit_001', 0, () => {
      let instance: OpenFolderDragHandler = OpenFolderDragHandler.getInstance();
      let itemVm: OpenFolderAppMoveVm = new OpenFolderAppMoveVm();
      itemVm.translateX = 0;
      itemVm.translateY = 0;
      AppStorage.setOrCreate('isAddIconHidden', false);
      let mocker: MockKit = new MockKit();
      let folderDataInstance: FolderData = FolderData.getInstance();
      let mockFunc = mocker.mockFunc(folderDataInstance, folderDataInstance.isFolderOpen);
      when(mockFunc)().afterReturn(false);
      instance.judgeTranslateBeforeInit(itemVm);
      let isAddIconHidden: boolean = AppStorage.get<boolean>('isAddIconHidden') ?? false;
      expect(isAddIconHidden).assertFalse();
      when(mockFunc)().afterReturn(true);
      instance.judgeTranslateBeforeInit(itemVm);
      let isAddIconHidden1: boolean = AppStorage.get<boolean>('isAddIconHidden') ?? false;
      expect(isAddIconHidden1).assertFalse();
      when(mockFunc)().afterReturn(true);
      AppStorage.setOrCreate('isAddIconHidden', true);
      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      let items: GridLayoutItemInfo[] = [];
      for (let index = 0; index < 4; index++) {
        let item = new GridLayoutItemInfo();
        item.keyName = 'testkeyName' + index;
        item.bundleName = 'testbundleName' + index;
        items.push(item);
      }
      openFolderData.layoutInfo = [items];
      let mockFunc1 = mocker.mockFunc(folderDataInstance, folderDataInstance.getOpenedFolder);
      when(mockFunc1)().afterReturn(openFolderData);
      instance.judgeTranslateBeforeInit(itemVm);
      let isAddIconHidden2: boolean = AppStorage.get<boolean>('isAddIconHidden') ?? false;
      expect(isAddIconHidden2).assertTrue();
      mocker.clear(folderDataInstance);
      mocker.clearAll();
    });

  })
}

function getNullObject(): DragEvent | null | GridLayoutItemInfo {
  return null;
}


class SimpleDragEvent implements DragEvent {
  private displayX: number = 0;
  private displayY: number = 0;
  private mWindowX: number = 0;
  private mWindowY: number = 0;
  private x: number = 0;
  private y: number = 0;

  private velocityY: number = 0;
  private velocityX: number = 0;
  private velocity: number = 0;

  private mPreviewRect: Rectangle = {
    x: 0,
    y: 0,
    width: 0,
    height: 0
  };

  private mDragResult: DragResult = DragResult.DRAG_SUCCESSFUL;

  getDisplayX(): number {
    return this.displayX;
  }

  setDisplayX(x: number): void {
    this.displayX = x;
  }

  setDisplayY(y: number): void {
    this.displayY = y;
  }

  getDisplayY(): number {
    return this.displayY;
  }

  getWindowX(): number {
    return this.mWindowX;
  }

  getWindowY(): number {
    return this.mWindowY;
  }

  getX(): number {
    return this.x;
  }

  getY(): number {
    return this.y;
  }

  public dragBehavior: DragBehavior = DragBehavior.COPY;
  public useCustomDropAnimation: boolean = false;

  setData(unifiedData: unifiedDataChannel.UnifiedData): void {
    throw new Error('Method not implemented.');
  }

  getData(): unifiedDataChannel.UnifiedData {
    throw new Error('Method not implemented.');
  }

  getSummary(): unifiedDataChannel.Summary {
    throw new Error('Method not implemented.');
  }

  setResult(dragResult: DragResult): void {
    this.mDragResult = dragResult;
  }

  getResult(): DragResult {
    return this.mDragResult;
  }

  getPreviewRect(): Rectangle {
    return this.mPreviewRect;
  }

  setPreviewRect(rect: Rectangle): void {
    this.mPreviewRect = rect;
  }

  getVelocityX(): number {
    return this.velocityX;
  }

  setVelocityX(velX: number): void {
    this.velocityX = velX;
  }

  setVelocityY(velY: number): void {
    this.velocityY = velY;
  }

  setVelocity(vel: number): void {
    this.velocity - vel;
  }

  getVelocityY(): number {
    return this.velocityY;
  }

  getVelocity(): number {
    return this.velocity;
  }
}