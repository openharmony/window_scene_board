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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium';
import { FolderLayoutUtil, FolderStatus, FolderType } from '../../../../../../main/ets/utils/FolderLayoutUtil';
import { GridLayoutItemInfo, GridLayoutUtil, CommonConstants, FolderConstants } from '../../../../../../main/ets/TsIndex';
import { DragPosition, GridItemPositionUtil } from '@ohos/componentdrag';
import { RTLUtil, RectangularCoordinates } from '@ohos/componenthelper';
import { UIContext } from '@kit.ArkUI';

export default function FolderLayoutUtilTest() {
  describe('FolderLayoutUtilTest', () => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterEach((): void => {
    });

    afterAll((): void => {
    });

    it('test_FolderLayoutUtil_getItemPostion', 0, () => {
      let folderLayoutUtil: FolderLayoutUtil = new FolderLayoutUtil();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.row = 1;
      info.column = 1;
      info.folderId = '996';
      info.typeId = CommonConstants.TYPE_FOLDER;
      info.area = [2, 1];
      let position: RectangularCoordinates.Point = {x: 1, y: 1};
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isBigFolder);
      let mockFunc1: Function = mocker.mockFunc(folderLayoutUtil, folderLayoutUtil.getBigFolderItemPosition);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(position);
      let result: RectangularCoordinates.Point = folderLayoutUtil.getItemPostion(FolderStatus.CLOSE_FOLDER, info, 2);
      expect(result.x).assertEqual(1);
      let mockFunc2: Function = mocker.mockFunc(folderLayoutUtil, folderLayoutUtil.getSmallFolderItemPosition);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(position);
      let result1: RectangularCoordinates.Point = folderLayoutUtil.getItemPostion(FolderStatus.CLOSE_FOLDER, info, 2);
      expect(result1.x).assertEqual(1);
      let mockFunc3: Function = mocker.mockFunc(folderLayoutUtil, folderLayoutUtil.getOpenFolderItemPosition);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(position);
      let result2: RectangularCoordinates.Point = folderLayoutUtil.getItemPostion(FolderStatus.OPEN_FOLDER, info, 2);
      expect(result2.x).assertEqual(1);
      mocker.clear(GridLayoutUtil);
      mocker.clear(folderLayoutUtil);
      mocker.clearAll();
    })

    it('test_FolderLayoutUtil_getGridItemRect', 0, () => {
      let folderLayoutUtil: FolderLayoutUtil = new FolderLayoutUtil();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.row = 1;
      info.column = 1;
      info.folderId = '996';
      info.typeId = CommonConstants.TYPE_FOLDER;
      info.area = [2, 1];
      folderLayoutUtil.initFolderLayoutConfig();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderLayoutUtil, folderLayoutUtil['isStackApp']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let result: Size = folderLayoutUtil.getGridItemRect(FolderStatus.CLOSE_FOLDER, info, 2);
      expect(result.width).assertInstanceOf('Number');
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let result1: Size = folderLayoutUtil.getGridItemRect(FolderStatus.CLOSE_FOLDER, info, 2);
      expect(result1.width).assertInstanceOf('Number');
      let result2: Size = folderLayoutUtil.getGridItemRect(FolderStatus.OPEN_FOLDER, info, 2);
      expect(result2.width).assertInstanceOf('Number');
      mocker.clear(folderLayoutUtil);
      mocker.clearAll();
    })

    it('test_FolderLayoutUtil_isStackApp', 0, () => {
      let folderLayoutUtil: FolderLayoutUtil = new FolderLayoutUtil();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.row = 1;
      info.column = 1;
      info.folderId = '996';
      info.typeId = CommonConstants.TYPE_FOLDER;
      info.area = [2, 1];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isBigFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let result: boolean = folderLayoutUtil['isStackApp'](info, 2);
      expect(result).assertFalse();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc1: Function = mocker.mockFunc(folderLayoutUtil, folderLayoutUtil.getFirstPageMaxShowLength);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(1);
      let result1: boolean = folderLayoutUtil['isStackApp'](info, 2);
      expect(result1).assertFalse();
      mocker.clear(GridLayoutUtil);
      mocker.clear(folderLayoutUtil);
      mocker.clearAll();
    })

    it('test_FolderLayoutUtil_getFirstPageMaxShowLength', 0, () => {
      let folderLayoutUtil: FolderLayoutUtil = new FolderLayoutUtil();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.row = 1;
      info.column = 1;
      info.folderId = '996';
      info.typeId = CommonConstants.TYPE_FOLDER;
      info.area = [2, 1];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isBigFolder);
      let mockFunc1: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.getCountPerRowInFolder);
      let mockFunc2: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.getCountPerColumnInFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(1);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(1);
      let result: number = folderLayoutUtil.getFirstPageMaxShowLength(info);
      expect(result).assertEqual(1);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let result1: number = folderLayoutUtil.getFirstPageMaxShowLength(info);
      expect(result1).assertEqual(FolderConstants.MAX_ICON_LENGTH_IN_SMALL_FOLDER);
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
    })

    it('test_FolderLayoutUtil_getAllGridItemPosition', 0, () => {
      let folderLayoutUtil: FolderLayoutUtil = new FolderLayoutUtil();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.row = 1;
      info.column = 1;
      info.folderId = '996';
      info.typeId = CommonConstants.TYPE_FOLDER;
      info.area = [2, 1];
      let result: DragPosition[] = folderLayoutUtil.getAllGridItemPosition(FolderStatus.CLOSE_FOLDER ,info, true);
      expect(result.length).assertEqual(0);
    })

    it('test_FolderLayoutUtil_getFolderAppCount', 0, () => {
      let folderLayoutUtil: FolderLayoutUtil = new FolderLayoutUtil();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.row = 1;
      info.column = 1;
      info.folderId = '996';
      info.typeId = CommonConstants.TYPE_FOLDER;
      info.area = [2, 1];
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com';
      itemInfo.abilityName = 'openharmony';
      itemInfo.row = 1;
      itemInfo.column = 1;
      itemInfo.folderId = '996';
      itemInfo.typeId = CommonConstants.TYPE_FOLDER;
      itemInfo.area = [2, 1];
      itemInfo.layoutInfo = [[info]];
      folderLayoutUtil['isPadOrExpanded'] = true;
      let result: number = folderLayoutUtil.getFolderAppCount(itemInfo);
      expect(result).assertInstanceOf('Number');
      folderLayoutUtil['isPadOrExpanded'] = false;
      itemInfo.layoutInfo = [];
      let result1: number = folderLayoutUtil.getFolderAppCount(itemInfo);
      expect(result1).assertEqual(FolderConstants.DEFAULT_APP_LENGTH_WHEN_CREATE_FOLDER);
    })

    it('test_FolderLayoutUtil_getSmallFolderItemPosition', 0, () => {
      let folderLayoutUtil: FolderLayoutUtil = new FolderLayoutUtil();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.row = 1;
      info.column = 1;
      info.folderId = '996';
      info.isInDock = false;
      info.typeId = CommonConstants.TYPE_FOLDER;
      info.area = [2, 1];
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com';
      itemInfo.abilityName = 'openharmony';
      itemInfo.row = 1;
      itemInfo.column = 1;
      itemInfo.folderId = '996';
      itemInfo.isInDock = false;
      itemInfo.typeId = CommonConstants.TYPE_FOLDER;
      itemInfo.area = [2, 1];
      itemInfo.layoutInfo = [[info]];
      folderLayoutUtil.initFolderLayoutConfig();
      let result: RectangularCoordinates.Point = folderLayoutUtil.getSmallFolderItemPosition(itemInfo, 12);
      expect(result.x).assertInstanceOf('Number');
      itemInfo.isInDock = true;
      let result1: RectangularCoordinates.Point = folderLayoutUtil.getSmallFolderItemPosition(itemInfo, 3);
      expect(result1.x).assertInstanceOf('Number');
    })

    it('test_FolderLayoutUtil_getBigFolderItemPosition', 0, () => {
      let folderLayoutUtil: FolderLayoutUtil = new FolderLayoutUtil();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.row = 1;
      info.column = 1;
      info.folderId = '996';
      info.isInDock = false;
      info.typeId = CommonConstants.TYPE_FOLDER;
      info.area = [2, 1];
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com';
      itemInfo.abilityName = 'openharmony';
      itemInfo.row = 1;
      itemInfo.column = 1;
      itemInfo.folderId = '996';
      itemInfo.isInDock = false;
      itemInfo.typeId = CommonConstants.TYPE_FOLDER;
      itemInfo.area = [2, 1];
      itemInfo.layoutInfo = [[info]];
      folderLayoutUtil.initFolderLayoutConfig();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.getCountPerRowInFolder);
      let mockFunc1: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.getCountPerColumnInFolder);
      let mockFunc2: Function = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      let mockFunc3: Function = mocker.mockFunc(folderLayoutUtil, folderLayoutUtil.getFolderTypeByArea);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(1);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(3);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(FolderType.TYPE_2X1_BIG_FOLDER);
      let result: RectangularCoordinates.Point = folderLayoutUtil.getBigFolderItemPosition(itemInfo, 2);
      expect(result.x).assertInstanceOf('Number');
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      let result1: RectangularCoordinates.Point = folderLayoutUtil.getBigFolderItemPosition(itemInfo, 5);
      expect(result1.x).assertInstanceOf('Number');
      mocker.clear(GridLayoutUtil);
      mocker.clear(RTLUtil);
      mocker.clear(folderLayoutUtil);
      mocker.clearAll();
    })

    it('test_FolderLayoutUtil_updatePositionFor2x1', 0, () => {
      let folderLayoutUtil: FolderLayoutUtil = new FolderLayoutUtil();
      let folderGridPositions: GridItemPositionUtil = new GridItemPositionUtil();
      let position: DragPosition = {x: 1, y: 1};
      folderLayoutUtil['updatePositionFor2x1'](position, folderGridPositions, 3);
      expect(position.x).assertEqual(1);
    })

    it('test_FolderLayoutUtil_getOpenFolderItemPosition', 0, () => {
      let folderLayoutUtil: FolderLayoutUtil = new FolderLayoutUtil();
      folderLayoutUtil.initFolderLayoutConfig();
      folderLayoutUtil['isPadOrExpanded'] = false;
      let result: RectangularCoordinates.Point = folderLayoutUtil.getOpenFolderItemPosition(100);
      expect(result.x).assertInstanceOf('Number');
    })

    it('test_FolderLayoutUtil_getFolderComponentLeftTopPosition', 0, () => {
      let folderLayoutUtil: FolderLayoutUtil = new FolderLayoutUtil();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.row = 1;
      info.column = 1;
      info.folderId = '996';
      info.typeId = CommonConstants.TYPE_FOLDER;
      info.area = [2, 1];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.getRealGridItemPosition);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([1, 1]);
      let result: RectangularCoordinates.Point = folderLayoutUtil.getFolderComponentLeftTopPosition(info);
      expect(result.x).assertEqual(1);
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
    })

    it('test_FolderLayoutUtil_getFolderComponentCenterPosition', 0, () => {
      let folderLayoutUtil: FolderLayoutUtil = new FolderLayoutUtil();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.row = 1;
      info.column = 1;
      info.folderId = '996';
      info.typeId = CommonConstants.TYPE_FOLDER;
      info.area = [2, 1];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.getRealIconCenterPosition);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([1, 1]);
      let result: number[] = folderLayoutUtil.getFolderComponentCenterPosition(info);
      expect(result.length).assertEqual(2);
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
    })

    it('test_FolderLayoutUtil_getCurrentFolderCenterPosition', 0, () => {
      let folderLayoutUtil: FolderLayoutUtil = new FolderLayoutUtil();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.row = 1;
      info.column = 1;
      info.folderId = '996';
      info.typeId = CommonConstants.TYPE_FOLDER;
      info.area = [2, 1];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.getIconCenterPosition);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([1, 1]);
      let result: number[] = folderLayoutUtil.getCurrentFolderCenterPosition(info);
      expect(result.length).assertEqual(2);
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
    })

    it('test_FolderLayoutUtil_getFolderTypeByArea', 0, () => {
      let folderLayoutUtil: FolderLayoutUtil = new FolderLayoutUtil();
      let result: FolderType = folderLayoutUtil.getFolderTypeByArea([1, 1]);
      expect(result).assertEqual(FolderType.TYPE_SMALL_FOLDER);
      folderLayoutUtil['mFolderAreaMap'] = new Map<FolderType, number[]>([]);
      let result1: FolderType = folderLayoutUtil.getFolderTypeByArea([1, 1]);
      expect(result1).assertEqual(FolderType.TYPE_SMALL_FOLDER);
    })

    it('test_FolderLayoutUtil_getItemIndex', 0, () => {
      let folderLayoutUtil: FolderLayoutUtil = new FolderLayoutUtil();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.row = 1;
      info.column = 1;
      info.folderId = '996';
      info.typeId = CommonConstants.TYPE_FOLDER;
      info.area = [2, 1];
      folderLayoutUtil['isPadOrExpanded'] = true;
      let result: number = folderLayoutUtil.getItemIndex(info);
      expect(result).assertInstanceOf('Number');
      folderLayoutUtil['isPadOrExpanded'] = false;
      let result1: number = folderLayoutUtil.getItemIndex(info);
      expect(result1).assertInstanceOf('Number');
    })

    it('test_FolderLayoutUtil_isAppInFolder', 0, () => {
      let folderLayoutUtil: FolderLayoutUtil = new FolderLayoutUtil();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.row = 1;
      info.column = 1;
      info.folderId = '996';
      info.typeId = CommonConstants.TYPE_FOLDER;
      info.area = [2, 1];
      info.container = CommonConstants.ICON_DEFAULT_SCALE;
      let result: boolean = folderLayoutUtil.isAppInFolder(info);
      expect(result).assertTrue();
    })

    it('test_FolderLayoutUtil_getRowAndColCount', 0, () => {
      let folderLayoutUtil: FolderLayoutUtil = new FolderLayoutUtil();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.row = 1;
      info.column = 1;
      info.folderId = '996';
      info.typeId = CommonConstants.TYPE_FOLDER;
      info.area = [2, 1];
      info.container = CommonConstants.ICON_DEFAULT_SCALE;
      let result: number[] = folderLayoutUtil.getRowAndColCount(FolderStatus.CLOSE_FOLDER, info);
      expect(result.length).assertEqual(2);
      folderLayoutUtil['isPadOrExpanded'] = false;
      let result1: number[] = folderLayoutUtil.getRowAndColCount(FolderStatus.OPEN_FOLDER, info);
      expect(result1.length).assertEqual(2);
    });

    it('test_FolderLayoutUtil_getWidthByArea', 0, () => {
      let folderLayoutUtil: FolderLayoutUtil = new FolderLayoutUtil();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderLayoutUtil.getWidthByArea([1]);
      folderLayoutUtil.getWidthByArea([2]);
      folderLayoutUtil.getWidthByArea([3]);
      folderLayoutUtil.getWidthByArea([4]);
    });

    it('test_FolderLayoutUtil_getHeightByArea', 0, () => {
      let folderLayoutUtil: FolderLayoutUtil = new FolderLayoutUtil();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderLayoutUtil.getHeightByArea([1, 1]);
      folderLayoutUtil.getHeightByArea([2, 2]);
      folderLayoutUtil.getHeightByArea([3, 3]);
      folderLayoutUtil.getHeightByArea([4, 4]);
    });

    it('test_FolderLayoutUtil_getBigFolderItemPoint', 0, () => {
      let context: UIContext = new UIContext();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      let openItems: GridLayoutItemInfo[] = [];
      let appIndex: number = 1;
      let folderLayoutUtil: FolderLayoutUtil = new FolderLayoutUtil();
      folderLayoutUtil.getBigFolderItemPoint(context, info, openItems, appIndex);
    });

    it('test_FolderLayoutUtil_getSmallFolderItemPoint', 0, () => {
      let imagePoint: RectangularCoordinates.Point  = {x : 1, y : 1};
      let appIndex: number = 0;
      let folderLayoutUtil: FolderLayoutUtil = new FolderLayoutUtil();
      folderLayoutUtil.getSmallFolderItemPoint(imagePoint, appIndex);
    });

    it('test_FolderLayoutUtil_getSmallFolderItemPoint_01', 0, () => {
      let imagePoint: RectangularCoordinates.Point  = {x : 0, y : 0};
      let appIndex: number = 0;
      let folderLayoutUtil: FolderLayoutUtil = new FolderLayoutUtil();
      folderLayoutUtil.getSmallFolderItemPoint(imagePoint, appIndex);
    });

    it('test_FolderLayoutUtil_getOpenFolderItemPoint', 0, () => {
      let uiCon: UIContext = new UIContext();
      let iconId: string = '';
      let folderLayoutUtil: FolderLayoutUtil = new FolderLayoutUtil();
      folderLayoutUtil.getOpenFolderItemPoint(uiCon, iconId);
    });

    it('test_FolderLayoutUtil_getOpenFolderItemPoint_01', 0, () => {
      let uiCon: UIContext = new UIContext();
      let iconId: string = '123456';
      let folderLayoutUtil: FolderLayoutUtil = new FolderLayoutUtil();
      folderLayoutUtil.getOpenFolderItemPoint(uiCon, iconId);
    });

    it('test_FolderLayoutUtil_setSmallFolderItemCenter', 0, () => {
      let index: number = 0;
      let center: FolderItemCenter = new FolderItemCenter();
      let folderLayoutUtil: FolderLayoutUtil = new FolderLayoutUtil();
      folderLayoutUtil.setSmallFolderItemCenter(index, center);
    });

    it('test_FolderLayoutUtil_getMenuPositionThreshold', 0, () => {
      let isSmallFolder: boolean = true;
      let folderLayoutUtil: FolderLayoutUtil = new FolderLayoutUtil();
      folderLayoutUtil.getMenuPositionThreshold(isSmallFolder);
    });

    it('test_FolderLayoutUtil_getMenuPositionThreshold_01', 0, () => {
      let isSmallFolder: boolean = false;
      let folderLayoutUtil: FolderLayoutUtil = new FolderLayoutUtil();
      folderLayoutUtil.getMenuPositionThreshold(isSmallFolder);
    });
  })
}

class FolderItemCenter {
  x: number = 0;
  y: number = 0;
}
